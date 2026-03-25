<?php
declare(strict_types=1);

namespace PrestaShop\Module\PrestashopInventory\Controller\Admin;

require_once dirname(__DIR__, 3) . '/classes/PrestashopInventoryService.php';
require_once dirname(__DIR__, 3) . '/classes/PrestashopInventoryLicense.php';
require_once dirname(__DIR__, 3) . '/classes/PrestashopInventoryUpdater.php';

use PrestaShopBundle\Security\Annotation\AdminSecurity;
use Symfony\Component\HttpFoundation\Response;

class WarehouseController extends AbstractInventoryController
{
    public const TAB_CLASS_NAME = 'AdminPrestashopInventory';

    /**
     * @AdminSecurity("is_granted('read', request.get('_legacy_controller'))")
     */
    public function indexAction(): Response
    {
        $module = \Module::getInstanceByName('prestashopinventory');
        $context = \Context::getContext();
        $service = new \PrestashopInventoryService($module->getLocalPath(), $context, $module);
        $licenseService = new \PrestashopInventoryLicense($module->getLocalPath(), $context, $module);
        $updaterService = new \PrestashopInventoryUpdater($module->getLocalPath(), $context, $module);

        if ($module instanceof \PrestashopInventory) {
            $module->ensureTabsAvailable();
        }

        $translations = $service->getTranslations();
        $licenseStatus = $licenseService->getStatus();

        $context->smarty->assign([
            'inventoryCatalogUrl' => $context->link->getAdminLink('AdminProducts', true),
            'inventoryModuleUrl' => $context->link->getAdminLink('AdminPrestashopInventory', true),
            'inventorySuppliersUrl' => $context->link->getAdminLink('AdminPrestashopInventorySuppliers', true),
            'inventoryPurchaseOrdersUrl' => $context->link->getAdminLink('AdminPrestashopInventoryPurchaseOrders', true),
            'inventoryModuleBaseUrl' => $module->getPathUri(),
            'inventoryAjaxUrl' => $context->link->getAdminLink('AdminPrestashopInventory', true, [], [
                'ajax' => 1,
            ]),
            'inventoryExportUrl' => $context->link->getAdminLink('AdminPrestashopInventory', true, [], [
                'exportPdf' => 1,
            ]),
            'inventoryConfigUrl' => $context->link->getAdminLink('AdminModules', true, [], [
                'configure' => $module->name,
                'module_name' => $module->name,
                'tab_module' => $module->tab,
            ]),
            'inventoryLanguageIso' => (string) $context->language->iso_code,
            'inventoryCanEdit' => true,
            'inventoryTranslations' => $translations,
            'inventoryTranslationsJson' => json_encode($translations, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES),
            'inventoryModuleVersion' => (string) $module->version,
            'inventoryLicenseStatus' => $licenseStatus,
            'inventoryUpdateConfigured' => $updaterService->isConfigured(),
            'inventoryEmbeddedInModernLayout' => true,
        ]);

        $legacyContent = $module->display(
            $module->getLocalPath() . $module->name . '.php',
            'views/templates/admin/app.tpl'
        );

        return $this->renderInventoryPage(
            '@Modules/prestashopinventory/views/templates/admin-modern/warehouse.html.twig',
            'prestashop_inventory_products',
            'products_tab',
            [
                'legacyContent' => $legacyContent,
            ]
        );
    }
}
