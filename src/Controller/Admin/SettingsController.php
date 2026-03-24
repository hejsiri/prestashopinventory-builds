<?php
declare(strict_types=1);

namespace PrestaShop\Module\PrestashopInventory\Controller\Admin;

use PrestaShopBundle\Security\Annotation\AdminSecurity;
use Symfony\Component\HttpFoundation\Response;

class SettingsController extends AbstractInventoryController
{
    /**
     * @AdminSecurity("is_granted('read', request.get('_legacy_controller'))")
     */
    public function indexAction(): Response
    {
        return $this->renderInventoryPage(
            '@Modules/prestashopinventory/views/templates/admin-modern/settings.html.twig',
            'prestashop_inventory_settings',
            'settings_tab',
            [
                'migrationNotice' => $this->translate('settings_migration_notice'),
            ]
        );
    }
}
