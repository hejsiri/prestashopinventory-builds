<?php
declare(strict_types=1);

namespace PrestaShop\Module\PrestashopInventory\Controller\Admin;

use PrestaShopBundle\Security\Annotation\AdminSecurity;
use Symfony\Component\HttpFoundation\Response;

class PurchaseOrdersController extends AbstractInventoryController
{
    /**
     * @AdminSecurity("is_granted('read', request.get('_legacy_controller'))")
     */
    public function indexAction(): Response
    {
        return $this->renderInventoryPage(
            '@Modules/prestashopinventory/views/templates/admin-modern/purchase_orders.html.twig',
            'prestashop_inventory_purchase_orders',
            'purchase_orders_tab',
            [
                'migrationNotice' => $this->translate('purchase_orders_migration_notice'),
            ]
        );
    }
}
