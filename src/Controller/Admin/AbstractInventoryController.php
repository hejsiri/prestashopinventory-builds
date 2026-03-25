<?php
declare(strict_types=1);

namespace PrestaShop\Module\PrestashopInventory\Controller\Admin;

require_once dirname(__DIR__, 3) . '/classes/PrestashopInventoryI18n.php';

use PrestaShopBundle\Controller\Admin\FrameworkBundleAdminController;
use Symfony\Contracts\Translation\TranslatorInterface;
use Twig\Markup;

abstract class AbstractInventoryController extends FrameworkBundleAdminController
{
    private TranslatorInterface $translator;

    public function __construct(TranslatorInterface $translator)
    {
        $this->translator = $translator;
    }

    protected function buildHeaderTabContent(string $currentRoute): array|string
    {
        $tabsMarkup = $this->renderView('@Modules/prestashopinventory/views/templates/admin-modern/_head_tabs.html.twig', [
            'currentRoute' => $currentRoute,
            'inventoryTexts' => \PrestashopInventoryI18n::all($this->translator),
            'inventoryModuleUrl' => $this->generateUrl('prestashop_inventory_products'),
            'inventoryConfigUrl' => $this->generateUrl('prestashop_inventory_settings'),
            'inventorySuppliersUrl' => $this->generateUrl('prestashop_inventory_suppliers'),
            'inventoryPurchaseOrdersUrl' => $this->generateUrl('prestashop_inventory_purchase_orders'),
        ]);

        if (version_compare(_PS_VERSION_, '9.0.0', '>=')) {
            return [new Markup($tabsMarkup, 'UTF-8')];
        }

        return $tabsMarkup;
    }

    protected function translate(string $key, array $params = []): string
    {
        return \PrestashopInventoryI18n::translate($this->translator, $key, $params);
    }

    protected function inventoryTexts(): array
    {
        return \PrestashopInventoryI18n::all($this->translator);
    }

    protected function renderInventoryPage(string $template, string $currentRoute, string $sectionLabelKey, array $extra = [])
    {
        $module = \Module::getInstanceByName('prestashopinventory');

        return $this->render($template, array_merge($extra, [
            'layoutTitle' => $this->translate('inventory_report'),
            'headerTabContent' => $this->buildHeaderTabContent($currentRoute),
            'inventoryCurrentSectionLabel' => $this->translate($sectionLabelKey),
            'moduleVersion' => $module instanceof \Module ? (string) $module->version : '0.0.0',
            'inventoryTexts' => $this->inventoryTexts(),
        ]));
    }
}
