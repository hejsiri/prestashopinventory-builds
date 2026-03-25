<?php

require_once dirname(__DIR__, 2) . '/classes/PrestashopInventoryService.php';
require_once dirname(__DIR__, 2) . '/classes/PrestashopInventoryI18n.php';
require_once dirname(__DIR__, 2) . '/classes/PrestashopInventoryLicense.php';

class AdminPrestashopInventoryPurchaseOrdersController extends ModuleAdminController
{
    private PrestashopInventoryService $inventoryService;
    private PrestashopInventoryLicense $licenseService;

    public function __construct()
    {
        $this->bootstrap = true;

        parent::__construct();

        $this->inventoryService = new PrestashopInventoryService($this->module->getLocalPath(), $this->context, $this->module);
        $this->licenseService = new PrestashopInventoryLicense($this->module->getLocalPath(), $this->context, $this->module);
    }

    public function initContent(): void
    {
        Tools::redirectAdmin($this->getModuleRouteUrl('prestashop_inventory_purchase_orders'));

        if ($this->module instanceof PrestashopInventory) {
            $this->module->ensureTabsAvailable();
        }

        $translations = $this->inventoryService->getTranslations();
        $licenseStatus = $this->licenseService->getStatus();

        $this->context->smarty->assign([
            'inventoryModuleUrl' => $this->context->link->getAdminLink('AdminPrestashopInventory', true),
            'inventorySuppliersUrl' => $this->context->link->getAdminLink('AdminPrestashopInventorySuppliers', true),
            'inventoryPurchaseOrdersUrl' => $this->context->link->getAdminLink('AdminPrestashopInventoryPurchaseOrders', true),
            'inventoryConfigUrl' => $this->context->link->getAdminLink('AdminModules', true, [], [
                'configure' => $this->module->name,
                'module_name' => $this->module->name,
                'tab_module' => $this->module->tab,
            ]),
            'inventoryTranslations' => $translations,
            'inventoryLicenseStatus' => $licenseStatus,
            'inventoryPlaceholderTitle' => $translations['purchase_orders_tab'] ?? 'Zamowienia towaru',
            'inventoryPlaceholderDescription' => $translations['new_purchase_orders_view_scaffold'] ?? '',
            'inventoryPlaceholderNotice' => $translations['purchase_orders_migration_notice'] ?? '',
        ]);

        $this->content = $this->module->display(
            $this->module->getLocalPath() . $this->module->name . '.php',
            'views/templates/admin/purchase_orders.tpl'
        );

        parent::initContent();
    }

    private function getModuleRouteUrl(string $routeName): string
    {
        $router = \PrestaShop\PrestaShop\Adapter\SymfonyContainer::getInstance()->get('router');

        return $router->generate($routeName);
    }
}
