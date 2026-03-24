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

    protected function renderInventoryPage(string $template, string $currentRoute, string $sectionLabelKey, array $extra = [])
    {
        return $this->render($template, array_merge($extra, [
            'layoutTitle' => $this->translate('inventory_report'),
            'headerTabContent' => $this->buildHeaderTabContent($currentRoute),
            'inventoryCurrentSectionLabel' => $this->translate($sectionLabelKey),
            'moduleVersion' => '0.2.0',
            'inventoryTexts' => \PrestashopInventoryI18n::all($this->translator),
        ]));
    }
}
