<?php

require_once dirname(__DIR__, 2) . '/classes/PrestashopInventoryService.php';
require_once dirname(__DIR__, 2) . '/classes/PrestashopInventoryI18n.php';
require_once dirname(__DIR__, 2) . '/classes/PrestashopInventoryLicense.php';
require_once dirname(__DIR__, 2) . '/classes/PrestashopInventoryUpdater.php';

class AdminPrestashopInventoryController extends ModuleAdminController
{
    private PrestashopInventoryService $inventoryService;
    private PrestashopInventoryLicense $licenseService;
    private PrestashopInventoryUpdater $updaterService;

    public function __construct()
    {
        $this->bootstrap = true;

        parent::__construct();

        $this->inventoryService = new PrestashopInventoryService($this->module->getLocalPath(), $this->context, $this->module);
        $this->licenseService = new PrestashopInventoryLicense($this->module->getLocalPath(), $this->context, $this->module);
        $this->updaterService = new PrestashopInventoryUpdater($this->module->getLocalPath(), $this->context, $this->module);
    }

    public function initContent(): void
    {
        $this->assertViewAccess();

        $translations = $this->inventoryService->getTranslations();
        $licenseStatus = $this->licenseService->getStatus();

        $this->context->smarty->assign([
            'inventoryCatalogUrl' => $this->context->link->getAdminLink('AdminProducts', true),
            'inventoryModuleUrl' => $this->context->link->getAdminLink('AdminPrestashopInventory', true),
            'inventoryModuleBaseUrl' => $this->module->getPathUri(),
            'inventoryAjaxUrl' => $this->context->link->getAdminLink('AdminPrestashopInventory', true, [], [
                'ajax' => 1,
            ]),
            'inventoryExportUrl' => $this->context->link->getAdminLink('AdminPrestashopInventory', true, [], [
                'exportPdf' => 1,
            ]),
            'inventoryConfigUrl' => $this->context->link->getAdminLink('AdminModules', true, [], [
                'configure' => $this->module->name,
                'module_name' => $this->module->name,
                'tab_module' => $this->module->tab,
            ]),
            'inventoryLanguageIso' => (string) $this->context->language->iso_code,
            'inventoryCanEdit' => $this->access('edit'),
            'inventoryTranslations' => $translations,
            'inventoryTranslationsJson' => json_encode($translations, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
            'inventoryModuleVersion' => (string) $this->module->version,
            'inventoryLicenseStatus' => $licenseStatus,
            'inventoryUpdateConfigured' => $this->updaterService->isConfigured(),
        ]);

        $this->content = $this->module->display(
            $this->module->getLocalPath() . $this->module->name . '.php',
            'views/templates/admin/app.tpl'
        );

        parent::initContent();
    }

    public function postProcess(): void
    {
        if (Tools::getIsset('exportPdf')) {
            $this->assertViewAccess();
            $this->assertLicenseValid();
            $this->inventoryService->outputPdfReport([
                'lang' => (string) Tools::getValue('lang', (string) $this->context->language->iso_code),
                'activeOnly' => (string) Tools::getValue('activeOnly', '0'),
                'onlyAvailable' => (string) Tools::getValue('onlyAvailable', '0'),
                'missingPurchasePriceOnly' => (string) Tools::getValue('missingPurchasePriceOnly', '0'),
                'missingWeightOnly' => (string) Tools::getValue('missingWeightOnly', '0'),
                'showWeight' => (string) Tools::getValue('showWeight', '1'),
                'showBrutto' => (string) Tools::getValue('showBrutto', '1'),
                'query' => (string) Tools::getValue('query', ''),
            ]);
        }

        parent::postProcess();
    }

    public function ajaxProcessFetchProducts(): void
    {
        $this->assertViewAccess();
        $this->assertLicenseValid();

        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($this->inventoryService->renderProductsTable([
            'query' => (string) Tools::getValue('query', ''),
            'keywords' => Tools::getValue('keywords'),
            'activeOnly' => Tools::getValue('activeOnly'),
            'onlyAvailable' => Tools::getValue('onlyAvailable'),
            'missingPurchasePriceOnly' => Tools::getValue('missingPurchasePriceOnly'),
            'missingWeightOnly' => Tools::getValue('missingWeightOnly'),
            'showWeight' => Tools::getValue('showWeight', 1),
            'showBrutto' => Tools::getValue('showBrutto', 1),
            'lang' => (string) Tools::getValue('lang', (string) $this->context->language->iso_code),
            'sort_field' => (string) Tools::getValue('sort_field', 'product_name'),
            'sort_dir' => (string) Tools::getValue('sort_dir', 'ASC'),
            'page' => (int) Tools::getValue('page', 1),
            'per_page' => (int) Tools::getValue('per_page', 20),
        ]));
        exit;
    }

    public function ajaxProcessSavePrice(): void
    {
        $this->assertEditAccess();
        $this->assertLicenseValid();

        header('Content-Type: application/json; charset=utf-8');

        try {
            $price = $this->inventoryService->saveWholesalePrice(
                (int) Tools::getValue('id_product'),
                (int) Tools::getValue('id_product_attribute'),
                (string) Tools::getValue('price', '')
            );

            echo json_encode([
                'ok' => true,
                'price' => $price,
            ]);
        } catch (InvalidArgumentException $e) {
            http_response_code(400);
            echo json_encode([
                'ok' => false,
                'error' => $e->getMessage(),
            ]);
        } catch (Throwable $e) {
            http_response_code(500);
            echo json_encode([
                'ok' => false,
                'error' => _PS_MODE_DEV_
                    ? PrestashopInventoryI18n::translate($this->module, 'db_update_error') . ': ' . $e->getMessage()
                    : PrestashopInventoryI18n::translate($this->module, 'db_update_error'),
            ]);
        }

        exit;
    }

    public function ajaxProcessSaveRetailPrice(): void
    {
        $this->assertEditAccess();
        $this->assertLicenseValid();

        header('Content-Type: application/json; charset=utf-8');

        try {
            $price = $this->inventoryService->saveRetailGrossPrice(
                (int) Tools::getValue('id_product'),
                (int) Tools::getValue('id_product_attribute'),
                (string) Tools::getValue('price', '')
            );

            echo json_encode([
                'ok' => true,
                'price' => $price,
            ]);
        } catch (InvalidArgumentException $e) {
            http_response_code(400);
            echo json_encode([
                'ok' => false,
                'error' => $e->getMessage(),
            ]);
        } catch (Throwable $e) {
            http_response_code(500);
            echo json_encode([
                'ok' => false,
                'error' => _PS_MODE_DEV_
                    ? PrestashopInventoryI18n::translate($this->module, 'db_update_error') . ': ' . $e->getMessage()
                    : PrestashopInventoryI18n::translate($this->module, 'db_update_error'),
            ]);
        }

        exit;
    }

    public function ajaxProcessToggleProductActive(): void
    {
        $this->assertEditAccess();
        $this->assertLicenseValid();

        header('Content-Type: application/json; charset=utf-8');

        try {
            $isActive = $this->inventoryService->setProductActive(
                (int) Tools::getValue('id_product'),
                Tools::getValue('active')
            );

            echo json_encode([
                'ok' => true,
                'active' => $isActive ? 1 : 0,
            ]);
        } catch (InvalidArgumentException $e) {
            http_response_code(400);
            echo json_encode([
                'ok' => false,
                'error' => $e->getMessage(),
            ]);
        } catch (Throwable $e) {
            http_response_code(500);
            echo json_encode([
                'ok' => false,
                'error' => PrestashopInventoryI18n::translate($this->module, 'db_update_error'),
            ]);
        }

        exit;
    }

    public function ajaxProcessSaveQuantity(): void
    {
        $this->assertEditAccess();
        $this->assertLicenseValid();

        header('Content-Type: application/json; charset=utf-8');

        try {
            $quantity = $this->inventoryService->saveQuantity(
                (int) Tools::getValue('id_product'),
                (int) Tools::getValue('id_product_attribute'),
                (string) Tools::getValue('quantity', '')
            );

            echo json_encode([
                'ok' => true,
                'quantity' => $quantity,
            ]);
        } catch (InvalidArgumentException $e) {
            http_response_code(400);
            echo json_encode([
                'ok' => false,
                'error' => $e->getMessage(),
            ]);
        } catch (Throwable $e) {
            http_response_code(500);
            echo json_encode([
                'ok' => false,
                'error' => PrestashopInventoryI18n::translate($this->module, 'stock_update_error'),
            ]);
        }

        exit;
    }

    public function ajaxProcessSaveWeight(): void
    {
        $this->assertEditAccess();
        $this->assertLicenseValid();

        header('Content-Type: application/json; charset=utf-8');

        try {
            $weight = $this->inventoryService->saveWeight(
                (int) Tools::getValue('id_product'),
                (int) Tools::getValue('id_product_attribute'),
                (string) Tools::getValue('weight', '')
            );

            echo json_encode([
                'ok' => true,
                'weight' => $weight,
            ]);
        } catch (InvalidArgumentException $e) {
            http_response_code(400);
            echo json_encode([
                'ok' => false,
                'error' => $e->getMessage(),
            ]);
        } catch (Throwable $e) {
            http_response_code(500);
            echo json_encode([
                'ok' => false,
                'error' => PrestashopInventoryI18n::translate($this->module, 'db_update_error'),
            ]);
        }

        exit;
    }

    public function ajaxProcessGetSalesStats(): void
    {
        $this->assertViewAccess();
        $this->assertLicenseValid();

        header('Content-Type: application/json; charset=utf-8');

        try {
            $stats = $this->inventoryService->getMonthlySalesStats(
                (int) Tools::getValue('id_product'),
                (int) Tools::getValue('id_product_attribute'),
                (int) Tools::getValue('months', 12),
                (int) Tools::getValue('offset_months', 0)
            );

            echo json_encode([
                'ok' => true,
                'stats' => $stats,
            ]);
        } catch (InvalidArgumentException $e) {
            http_response_code(400);
            echo json_encode([
                'ok' => false,
                'error' => $e->getMessage(),
            ]);
        } catch (Throwable $e) {
            http_response_code(500);
            echo json_encode([
                'ok' => false,
                'error' => PrestashopInventoryI18n::translate($this->module, 'error_sales_stats'),
            ]);
        }

        exit;
    }

    public function ajaxProcessHideProduct(): void
    {
        $this->assertEditAccess();
        $this->assertLicenseValid();

        header('Content-Type: application/json; charset=utf-8');

        try {
            $result = $this->inventoryService->hideProduct(
                (int) Tools::getValue('id_product')
            );

            echo json_encode([
                'ok' => true,
                'id_product' => (int) $result['id_product'],
            ]);
        } catch (InvalidArgumentException $e) {
            http_response_code(400);
            echo json_encode([
                'ok' => false,
                'error' => $e->getMessage(),
            ]);
        } catch (Throwable $e) {
            http_response_code(500);
            echo json_encode([
                'ok' => false,
                'error' => PrestashopInventoryI18n::translate($this->module, 'hide_product_error'),
            ]);
        }

        exit;
    }

    public function ajaxProcessCheckForUpdates(): void
    {
        $this->assertViewAccess();

        header('Content-Type: application/json; charset=utf-8');

        try {
            $status = $this->updaterService->checkForUpdates();
            echo json_encode([
                'ok' => true,
                'status' => $status,
            ]);
        } catch (Throwable $e) {
            http_response_code(500);
            echo json_encode([
                'ok' => false,
                'error' => PrestashopInventoryI18n::translate($this->module, 'update_check_error_message'),
            ]);
        }

        exit;
    }

    public function ajaxProcessInstallUpdate(): void
    {
        $this->assertEditAccess();

        header('Content-Type: application/json; charset=utf-8');

        try {
            $result = $this->updaterService->installAvailableUpdate();
            echo json_encode([
                'ok' => true,
                'version' => (string) ($result['version'] ?? ''),
                'message' => PrestashopInventoryI18n::translate($this->module, 'update_installed_message'),
            ]);
        } catch (Throwable $e) {
            http_response_code(500);
            echo json_encode([
                'ok' => false,
                'error' => PrestashopInventoryI18n::translate($this->module, 'update_install_error_message'),
            ]);
        }

        exit;
    }

    private function assertViewAccess(): void
    {
        if (!$this->access('view')) {
            throw new PrestaShopException(PrestashopInventoryI18n::translate($this->module, 'access_denied'));
        }
    }

    private function assertEditAccess(): void
    {
        if (!$this->access('edit')) {
            http_response_code(403);
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode([
                'ok' => false,
                'error' => PrestashopInventoryI18n::translate($this->module, 'access_denied'),
            ]);
            exit;
        }
    }

    private function assertLicenseValid(): void
    {
        $status = $this->licenseService->getStatus();
        if (!empty($status['valid'])) {
            return;
        }

        http_response_code(403);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode([
            'ok' => false,
            'error' => (string) ($status['message'] ?? PrestashopInventoryI18n::translate($this->module, 'license_missing_message')),
        ]);
        exit;
    }
}
