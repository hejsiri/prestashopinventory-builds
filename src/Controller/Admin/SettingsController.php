<?php
declare(strict_types=1);

namespace PrestaShop\Module\PrestashopInventory\Controller\Admin;

require_once dirname(__DIR__, 3) . '/classes/PrestashopInventoryService.php';
require_once dirname(__DIR__, 3) . '/classes/PrestashopInventoryLicense.php';

use PrestaShopBundle\Security\Annotation\AdminSecurity;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

class SettingsController extends AbstractInventoryController
{
    /**
     * @AdminSecurity("is_granted('read', request.get('_legacy_controller'))")
     */
    public function indexAction(Request $request): Response
    {
        $module = \Module::getInstanceByName('prestashopinventory');
        $context = \Context::getContext();
        $service = new \PrestashopInventoryService($module->getLocalPath(), $context, $module);
        $licenseService = new \PrestashopInventoryLicense($module->getLocalPath(), $context, $module);
        $messages = [];
        $errors = [];

        if ($module instanceof \PrestashopInventory) {
            $module->ensureTabsAvailable();
        }

        if ($request->isMethod('POST') && \Tools::isSubmit('submitPrestashopInventoryRestoreHidden')) {
            try {
                $service->unhideProduct((int) \Tools::getValue('id_product'));
                $messages[] = $this->translate('product_restored');
            } catch (\Throwable $e) {
                $errors[] = $this->translate('product_restore_error');
                if (\defined('_PS_MODE_DEV_') && _PS_MODE_DEV_) {
                    $errors[] = $e->getMessage();
                }
            }
        }

        $licenseStatus = $licenseService->getStatus();
        $licenseDetails = is_array($licenseStatus['details'] ?? null) ? $licenseStatus['details'] : [];
        $licensePayload = is_array($licenseDetails['payload'] ?? null) ? $licenseDetails['payload'] : [];
        $licenseCustomer = trim((string) ($licensePayload['customer'] ?? ''));
        $licenseDomain = trim((string) ($licenseDetails['domain'] ?? $licensePayload['domain'] ?? ''));
        $licenseExpiresAt = trim((string) ($licenseDetails['expires_at'] ?? $licensePayload['expires_at'] ?? ''));

        $context->smarty->assign([
            'prestashopInventoryConfigAction' => $this->generateUrl('prestashop_inventory_settings'),
            'prestashopInventoryBackUrl' => $this->generateUrl('prestashop_inventory_products'),
            'prestashopInventorySuppliersUrl' => $this->generateUrl('prestashop_inventory_suppliers'),
            'prestashopInventoryPurchaseOrdersUrl' => $this->generateUrl('prestashop_inventory_purchase_orders'),
            'prestashopInventoryIgnoredProducts' => $service->getIgnoredProducts(),
            'prestashopInventoryTranslations' => $service->getTranslations(),
            'prestashopInventoryModuleVersion' => (string) $module->version,
            'prestashopInventoryLicenseStatus' => $licenseStatus,
            'prestashopInventoryLicenseSummary' => [
                'customer' => $licenseCustomer !== '' ? $licenseCustomer : '—',
                'domain' => $licenseDomain !== '' ? $licenseDomain : '—',
                'expires_at' => $licenseExpiresAt !== '' ? $licenseExpiresAt : '—',
            ],
            'prestashopInventoryEmbeddedInModernLayout' => true,
            'prestashopInventoryMessages' => $messages,
            'prestashopInventoryErrors' => $errors,
        ]);

        $legacyContent = $module->display(
            $module->getLocalPath() . $module->name . '.php',
            'views/templates/admin/configure.tpl'
        );

        return $this->renderInventoryPage(
            '@Modules/prestashopinventory/views/templates/admin-modern/settings.html.twig',
            'prestashop_inventory_settings',
            'settings_tab',
            [
                'legacyContent' => $legacyContent,
            ]
        );
    }
}
