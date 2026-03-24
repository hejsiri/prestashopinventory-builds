<?php
declare(strict_types=1);

namespace PrestaShop\Module\PrestashopInventory\Controller\Admin;

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
        return $this->renderInventoryPage(
            '@Modules/prestashopinventory/views/templates/admin-modern/warehouse.html.twig',
            'prestashop_inventory_warehouse',
            'warehouse_tab',
            [
                'migrationNotice' => $this->translate('warehouse_migration_notice'),
            ]
        );
    }
}
