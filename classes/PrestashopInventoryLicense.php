<?php

require_once __DIR__ . '/PrestashopInventoryI18n.php';

class PrestashopInventoryLicense
{
    private const LICENSE_FILE = 'license.php';
    private const PUBLIC_KEY_FILE = 'keys/license_public.pem';

    private string $modulePath;
    private Context $context;
    private Module $module;
    private ?array $status = null;

    public function __construct(string $modulePath, Context $context, Module $module)
    {
        $this->modulePath = rtrim($modulePath, '/') . '/';
        $this->context = $context;
        $this->module = $module;
    }

    public function getStatus(): array
    {
        if ($this->status !== null) {
            return $this->status;
        }

        $licenseKey = $this->loadLicenseKey();
        if ($licenseKey === null || $licenseKey === '') {
            return $this->status = $this->buildStatus(
                false,
                'missing',
                PrestashopInventoryI18n::translate($this->module, 'license_missing_message')
            );
        }

        $parts = explode('.', $licenseKey, 2);
        if (count($parts) !== 2) {
            return $this->status = $this->buildStatus(
                false,
                'invalid_format',
                PrestashopInventoryI18n::translate($this->module, 'license_invalid_message')
            );
        }

        $payloadEncoded = trim($parts[0]);
        $signatureEncoded = trim($parts[1]);
        $payloadJson = $this->base64UrlDecode($payloadEncoded);
        $signature = $this->base64UrlDecode($signatureEncoded);

        if ($payloadJson === '' || $signature === '') {
            return $this->status = $this->buildStatus(
                false,
                'invalid_format',
                PrestashopInventoryI18n::translate($this->module, 'license_invalid_message')
            );
        }

        $payload = json_decode($payloadJson, true);
        if (!is_array($payload)) {
            return $this->status = $this->buildStatus(
                false,
                'invalid_payload',
                PrestashopInventoryI18n::translate($this->module, 'license_invalid_message')
            );
        }

        $publicKeyPath = $this->modulePath . self::PUBLIC_KEY_FILE;
        if (!is_file($publicKeyPath)) {
            return $this->status = $this->buildStatus(
                false,
                'public_key_missing',
                PrestashopInventoryI18n::translate($this->module, 'license_file_error_message')
            );
        }

        $publicKey = (string) file_get_contents($publicKeyPath);
        $verification = openssl_verify($payloadEncoded, $signature, $publicKey, OPENSSL_ALGO_SHA256);
        if ($verification !== 1) {
            return $this->status = $this->buildStatus(
                false,
                'signature_invalid',
                PrestashopInventoryI18n::translate($this->module, 'license_invalid_message')
            );
        }

        $licensedModule = (string) ($payload['module'] ?? '');
        if ($licensedModule !== '' && $licensedModule !== $this->module->name) {
            return $this->status = $this->buildStatus(
                false,
                'module_mismatch',
                PrestashopInventoryI18n::translate($this->module, 'license_invalid_message')
            );
        }

        $currentDomain = $this->normalizeDomain($this->getCurrentDomain());
        $licensedDomain = $this->normalizeDomain((string) ($payload['domain'] ?? ''));
        if ($currentDomain === '' || !$this->domainMatches($licensedDomain, $currentDomain)) {
            return $this->status = $this->buildStatus(
                false,
                'domain_mismatch',
                PrestashopInventoryI18n::translate($this->module, 'license_domain_mismatch_message')
            );
        }

        $expiresAt = (string) ($payload['expires_at'] ?? '');
        if (!$this->isExpiryValid($expiresAt)) {
            return $this->status = $this->buildStatus(
                false,
                'expired',
                PrestashopInventoryI18n::translate($this->module, 'license_expired_message')
            );
        }

        return $this->status = $this->buildStatus(
            true,
            'valid',
            '',
            [
                'domain' => $licensedDomain,
                'expires_at' => $expiresAt,
                'payload' => $payload,
            ]
        );
    }

    public function assertValid(): void
    {
        $status = $this->getStatus();
        if (!$status['valid']) {
            throw new PrestaShopException((string) $status['message']);
        }
    }

    private function buildStatus(bool $valid, string $code, string $message, array $details = []): array
    {
        return [
            'valid' => $valid,
            'code' => $code,
            'message' => $message,
            'details' => $details,
        ];
    }

    private function loadLicenseKey(): ?string
    {
        $licensePath = $this->modulePath . self::LICENSE_FILE;
        if (!is_file($licensePath)) {
            return null;
        }

        try {
            $value = require $licensePath;
        } catch (Throwable $e) {
            return '';
        }

        if (is_string($value)) {
            return trim($value);
        }

        if (is_array($value)) {
            foreach (['key', 'license_key'] as $field) {
                if (!empty($value[$field]) && is_string($value[$field])) {
                    return trim($value[$field]);
                }
            }
        }

        return '';
    }

    private function getCurrentDomain(): string
    {
        $baseUrl = '';
        if (isset($this->context->shop) && is_object($this->context->shop) && method_exists($this->context->shop, 'getBaseURL')) {
            $baseUrl = (string) $this->context->shop->getBaseURL(true);
        }

        $host = (string) parse_url($baseUrl, PHP_URL_HOST);
        if ($host !== '') {
            return $host;
        }

        return (string) ($_SERVER['HTTP_HOST'] ?? $_SERVER['SERVER_NAME'] ?? '');
    }

    private function normalizeDomain(string $domain): string
    {
        $domain = trim(strtolower($domain));
        if ($domain === '') {
            return '';
        }

        if (str_contains($domain, '://')) {
            $domain = (string) parse_url($domain, PHP_URL_HOST);
        }

        $domain = preg_replace('~:\d+$~', '', $domain);
        $domain = rtrim((string) $domain, '.');

        if (str_starts_with($domain, 'www.')) {
            $domain = substr($domain, 4);
        }

        return $domain;
    }

    private function domainMatches(string $licensedDomain, string $currentDomain): bool
    {
        if ($licensedDomain === '' || $currentDomain === '') {
            return false;
        }

        if ($licensedDomain === $currentDomain) {
            return true;
        }

        if (str_starts_with($licensedDomain, '*.')) {
            $suffix = substr($licensedDomain, 1);

            return str_ends_with($currentDomain, $suffix);
        }

        return false;
    }

    private function isExpiryValid(string $expiresAt): bool
    {
        if ($expiresAt === '') {
            return false;
        }

        try {
            if (preg_match('/^\d{4}-\d{2}-\d{2}$/', $expiresAt)) {
                $expiry = new DateTimeImmutable($expiresAt . ' 23:59:59', new DateTimeZone('UTC'));
            } else {
                $expiry = new DateTimeImmutable($expiresAt);
            }
        } catch (Throwable $e) {
            return false;
        }

        $now = new DateTimeImmutable('now', new DateTimeZone('UTC'));

        return $expiry >= $now;
    }

    private function base64UrlDecode(string $value): string
    {
        $value = strtr($value, '-_', '+/');
        $remainder = strlen($value) % 4;
        if ($remainder > 0) {
            $value .= str_repeat('=', 4 - $remainder);
        }

        $decoded = base64_decode($value, true);

        return $decoded === false ? '' : $decoded;
    }
}
