<?php

require_once __DIR__ . '/PrestashopInventoryI18n.php';

class PrestashopInventoryUpdater
{
    private const CONFIG_FILE = 'distribution.php';
    private const PUBLIC_KEY_FILE = 'keys/update_public.pem';

    private string $modulePath;
    private Context $context;
    private Module $module;
    private ?array $cachedStatus = null;

    public function __construct(string $modulePath, Context $context, Module $module)
    {
        $this->modulePath = rtrim($modulePath, '/') . '/';
        $this->context = $context;
        $this->module = $module;
    }

    public function isConfigured(): bool
    {
        $config = $this->loadConfig();

        return $this->resolveManifestUrl($config) !== '';
    }

    public function checkForUpdates(): array
    {
        if ($this->cachedStatus !== null) {
            return $this->cachedStatus;
        }

        $config = $this->loadConfig();
        $manifestUrl = $this->resolveManifestUrl($config);
        if ($manifestUrl === '') {
            return $this->cachedStatus = [
                'configured' => false,
                'available' => false,
                'current_version' => (string) $this->module->version,
            ];
        }

        $manifestRaw = $this->fetchUrl($this->withCacheBuster($manifestUrl));
        $manifest = json_decode($manifestRaw, true);

        if (!is_array($manifest)) {
            throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_check_error_message'));
        }

        $requiredFields = ['version', 'url', 'sha256', 'signature'];
        foreach ($requiredFields as $field) {
            if (empty($manifest[$field]) || !is_string($manifest[$field])) {
                throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_check_error_message'));
            }
        }

        if (!$this->verifyManifest($manifest)) {
            throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_check_error_message'));
        }

        return $this->cachedStatus = [
            'configured' => true,
            'available' => version_compare((string) $manifest['version'], (string) $this->module->version, '>'),
            'current_version' => (string) $this->module->version,
            'version' => (string) $manifest['version'],
            'url' => (string) $manifest['url'],
            'sha256' => strtolower((string) $manifest['sha256']),
            'signature' => (string) $manifest['signature'],
            'published_at' => (string) ($manifest['published_at'] ?? ''),
            'notes' => (string) ($manifest['notes'] ?? ''),
        ];
    }

    public function installAvailableUpdate(): array
    {
        $status = $this->checkForUpdates();
        if (empty($status['available'])) {
            throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_check_error_message'));
        }

        $zipContents = $this->fetchUrl((string) $status['url'], true);
        $tempBase = rtrim(sys_get_temp_dir(), '/') . '/psinv_update_' . bin2hex(random_bytes(8));
        $zipPath = $tempBase . '.zip';
        $extractPath = $tempBase . '_extract';

        file_put_contents($zipPath, $zipContents);
        if (hash_file('sha256', $zipPath) !== (string) $status['sha256']) {
            @unlink($zipPath);
            throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_install_error_message'));
        }

        $zip = new ZipArchive();
        if ($zip->open($zipPath) !== true) {
            @unlink($zipPath);
            throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_install_error_message'));
        }

        if (!is_dir($extractPath) && !mkdir($extractPath, 0775, true) && !is_dir($extractPath)) {
            $zip->close();
            @unlink($zipPath);
            throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_install_error_message'));
        }

        $zip->extractTo($extractPath);
        $zip->close();

        $sourceRoot = $this->resolveExtractedModuleRoot($extractPath);
        if ($sourceRoot === null) {
            $this->cleanupTemp($zipPath, $extractPath);
            throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_install_error_message'));
        }

        $this->copyDirectory($sourceRoot, rtrim($this->modulePath, '/'), [
            'license.php',
        ]);

        $this->cleanupTemp($zipPath, $extractPath);
        $this->cachedStatus = null;

        return [
            'ok' => true,
            'version' => (string) $status['version'],
        ];
    }

    private function loadConfig(): array
    {
        $configPath = $this->modulePath . self::CONFIG_FILE;
        if (!is_file($configPath)) {
            return [];
        }

        $config = require $configPath;

        return is_array($config) ? $config : [];
    }

    private function resolveManifestUrl(array $config): string
    {
        $manifestUrl = trim((string) ($config['manifest_url'] ?? ''));
        if ($manifestUrl !== '') {
            return $manifestUrl;
        }

        $repository = trim((string) ($config['github_repository'] ?? ''));
        if ($repository === '') {
            return '';
        }

        $branch = trim((string) ($config['github_branch'] ?? 'main'));
        if ($branch === '') {
            $branch = 'main';
        }

        $manifestPath = trim((string) ($config['manifest_path'] ?? 'latest.json'));
        $manifestPath = ltrim($manifestPath, '/');
        if ($manifestPath === '') {
            $manifestPath = 'latest.json';
        }

        $owner = $this->trimRepositoryOwner($repository);
        $name = $this->trimRepositoryName($repository);
        if ($owner === '' || $name === '') {
            return '';
        }

        return sprintf(
            'https://raw.githubusercontent.com/%s/%s/%s/%s',
            rawurlencode($owner),
            rawurlencode($name),
            rawurlencode($branch),
            implode('/', array_map('rawurlencode', explode('/', $manifestPath)))
        );
    }

    private function trimRepositoryOwner(string $repository): string
    {
        $parts = explode('/', trim($repository), 2);

        return trim($parts[0] ?? '');
    }

    private function trimRepositoryName(string $repository): string
    {
        $parts = explode('/', trim($repository), 2);

        return trim($parts[1] ?? '');
    }

    private function verifyManifest(array $manifest): bool
    {
        $publicKeyPath = $this->modulePath . self::PUBLIC_KEY_FILE;
        if (!is_file($publicKeyPath)) {
            return false;
        }

        $publicKey = (string) file_get_contents($publicKeyPath);
        $signature = base64_decode((string) $manifest['signature'], true);
        if ($signature === false) {
            return false;
        }

        return openssl_verify($this->buildSignaturePayload($manifest), $signature, $publicKey, OPENSSL_ALGO_SHA256) === 1;
    }

    private function buildSignaturePayload(array $manifest): string
    {
        return implode("\n", [
            (string) $manifest['version'],
            (string) $manifest['url'],
            strtolower((string) $manifest['sha256']),
        ]);
    }

    private function fetchUrl(string $url, bool $binary = false): string
    {
        if (function_exists('curl_init')) {
            $ch = curl_init($url);
            curl_setopt_array($ch, [
                CURLOPT_RETURNTRANSFER => true,
                CURLOPT_FOLLOWLOCATION => true,
                CURLOPT_CONNECTTIMEOUT => 10,
                CURLOPT_TIMEOUT => 30,
                CURLOPT_USERAGENT => 'PrestashopInventory/' . (string) $this->module->version,
            ]);
            $content = curl_exec($ch);
            $status = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
            curl_close($ch);

            if (!is_string($content) || $status >= 400 || $status === 0) {
                throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_check_error_message'));
            }

            return $content;
        }

        $context = stream_context_create([
            'http' => [
                'timeout' => 30,
                'follow_location' => 1,
                'user_agent' => 'PrestashopInventory/' . (string) $this->module->version,
            ],
        ]);
        $content = @file_get_contents($url, false, $context);
        if (!is_string($content)) {
            throw new RuntimeException(
                PrestashopInventoryI18n::translate(
                    $this->module,
                    $binary ? 'update_install_error_message' : 'update_check_error_message'
                )
            );
        }

        return $content;
    }

    private function withCacheBuster(string $url): string
    {
        $separator = str_contains($url, '?') ? '&' : '?';

        return $url . $separator . '_ts=' . rawurlencode((string) time());
    }

    private function resolveExtractedModuleRoot(string $extractPath): ?string
    {
        $directRoot = rtrim($extractPath, '/') . '/' . $this->module->name;
        if (is_dir($directRoot)) {
            return $directRoot;
        }

        $entries = array_values(array_filter(scandir($extractPath) ?: [], function ($entry) use ($extractPath) {
            return $entry !== '.' && $entry !== '..' && is_dir($extractPath . '/' . $entry);
        }));

        if (count($entries) === 1) {
            return $extractPath . '/' . $entries[0];
        }

        return null;
    }

    private function copyDirectory(string $source, string $target, array $excludedBasenames = []): void
    {
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($source, FilesystemIterator::SKIP_DOTS),
            RecursiveIteratorIterator::SELF_FIRST
        );

        foreach ($iterator as $item) {
            $relativePath = substr($item->getPathname(), strlen($source) + 1);
            if ($relativePath === false || $relativePath === '') {
                continue;
            }

            $basename = basename($relativePath);
            if (in_array($basename, $excludedBasenames, true)) {
                continue;
            }

            $destinationPath = $target . '/' . $relativePath;
            if ($item->isDir()) {
                if (!is_dir($destinationPath) && !mkdir($destinationPath, 0775, true) && !is_dir($destinationPath)) {
                    throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_install_error_message'));
                }
                continue;
            }

            $destinationDir = dirname($destinationPath);
            if (!is_dir($destinationDir) && !mkdir($destinationDir, 0775, true) && !is_dir($destinationDir)) {
                throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_install_error_message'));
            }

            if (!copy($item->getPathname(), $destinationPath)) {
                throw new RuntimeException(PrestashopInventoryI18n::translate($this->module, 'update_install_error_message'));
            }
        }
    }

    private function cleanupTemp(string $zipPath, string $extractPath): void
    {
        @unlink($zipPath);

        if (!is_dir($extractPath)) {
            return;
        }

        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($extractPath, FilesystemIterator::SKIP_DOTS),
            RecursiveIteratorIterator::CHILD_FIRST
        );

        foreach ($iterator as $item) {
            if ($item->isDir()) {
                @rmdir($item->getPathname());
            } else {
                @unlink($item->getPathname());
            }
        }

        @rmdir($extractPath);
    }
}
