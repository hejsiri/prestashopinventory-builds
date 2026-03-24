<?php

require_once __DIR__ . '/classes/PrestashopInventoryI18n.php';
require_once __DIR__ . '/classes/PrestashopInventoryService.php';
require_once __DIR__ . '/classes/PrestashopInventoryLicense.php';
require_once __DIR__ . '/classes/PrestashopInventoryUpdater.php';

if (!defined('_PS_VERSION_')) {
    exit;
}

class PrestashopInventory extends Module
{
    private const ADMIN_TAB_CLASS_NAME = 'AdminPrestashopInventory';

    public function __construct()
    {
        $this->name = 'prestashopinventory';
        $this->tab = 'administration';
        $this->version = '0.2.61';
        $this->author = 'hejsiri';
        $this->need_instance = 0;
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->trans('Inventory Report', [], 'Modules.Prestashopinventory.Admin');
        $this->description = $this->trans('Back Office inventory view with purchase price editing and PDF export.', [], 'Modules.Prestashopinventory.Admin');
        $this->ps_versions_compliancy = ['min' => '8.2.0', 'max' => _PS_VERSION_];
    }

    public function install(): bool
    {
        $defaultIgnoredIds = '';
        $ignoreFilePath = __DIR__ . '/ignore.txt';
        if (is_file($ignoreFilePath)) {
            $defaultIgnoredIds = trim((string) file_get_contents($ignoreFilePath));
        }

        if (!parent::install()) {
            return false;
        }

        if (!$this->installTab()) {
            parent::uninstall();

            return false;
        }

        if ($defaultIgnoredIds !== '') {
            Configuration::updateValue(PrestashopInventoryService::CONFIG_IGNORED_IDS, $defaultIgnoredIds);
        }

        return true;
    }

    public function uninstall(): bool
    {
        Configuration::deleteByName(PrestashopInventoryService::CONFIG_IGNORED_IDS);

        return $this->uninstallTab() && parent::uninstall();
    }

    public function getContent(): string
    {
        $output = '';
        $service = new PrestashopInventoryService($this->getLocalPath(), $this->context, $this);

        if (Tools::isSubmit('submitPrestashopInventoryRestoreHidden')) {
            try {
                $service->unhideProduct((int) Tools::getValue('id_product'));
                $output .= $this->displayConfirmation(PrestashopInventoryI18n::translate($this, 'product_restored'));
            } catch (Throwable $e) {
                $output .= $this->displayError(PrestashopInventoryI18n::translate($this, 'product_restore_error'));
            }
        }

        $translations = $service->getTranslations();

        $this->context->smarty->assign([
            'prestashopInventoryConfigAction' => AdminController::$currentIndex . '&configure=' . $this->name . '&token=' . Tools::getAdminTokenLite('AdminModules'),
            'prestashopInventoryCatalogUrl' => $this->context->link->getAdminLink('AdminProducts', true),
            'prestashopInventoryBackUrl' => $this->context->link->getAdminLink('AdminPrestashopInventory', true),
            'prestashopInventoryIgnoredProducts' => $service->getIgnoredProducts(),
            'prestashopInventoryTranslations' => $translations,
        ]);

        $output .= $this->display(__FILE__, 'views/templates/admin/configure.tpl');

        return $output;
    }

    public function isUsingNewTranslationSystem(): bool
    {
        return true;
    }

    public function transModule(string $message, array $parameters = []): string
    {
        return $this->trans($message, $parameters, PrestashopInventoryI18n::DOMAIN);
    }

    public function getTranslationCatalogue(): array
    {
        return [
            'warehouse_tab' => $this->trans('Warehouse', [], PrestashopInventoryI18n::DOMAIN),
            'settings_tab' => $this->trans('Settings', [], PrestashopInventoryI18n::DOMAIN),
            'inventory_report' => $this->trans('Inventory report', [], PrestashopInventoryI18n::DOMAIN),
            'new_warehouse_view_scaffold' => $this->trans('New Warehouse view scaffold for the Inventory module.', [], PrestashopInventoryI18n::DOMAIN),
            'new_settings_view_scaffold' => $this->trans('New Settings view scaffold for the Inventory module.', [], PrestashopInventoryI18n::DOMAIN),
            'warehouse_migration_notice' => $this->trans('This tab will become the new place for the inventory table after the migration to the PrestaShop 8.2+ / 9.x compatible architecture is completed.', [], PrestashopInventoryI18n::DOMAIN),
            'settings_migration_notice' => $this->trans('This tab will become the new place for hidden products configuration and module settings after the migration is completed.', [], PrestashopInventoryI18n::DOMAIN),
            'no_image' => $this->trans('None', [], PrestashopInventoryI18n::DOMAIN),
            'no_data' => $this->trans('No data', [], PrestashopInventoryI18n::DOMAIN),
            'combination_id' => $this->trans('Combination ID: %id%', ['%id%' => '{{ id }}'], PrestashopInventoryI18n::DOMAIN),
            'actions' => $this->trans('Actions', [], PrestashopInventoryI18n::DOMAIN),
            'hide_forever' => $this->trans('Hide permanently', [], PrestashopInventoryI18n::DOMAIN),
            'total_purchase_value_net' => $this->trans('Total net purchase value:', [], PrestashopInventoryI18n::DOMAIN),
            'total_retail_value_gross' => $this->trans('Total gross retail value:', [], PrestashopInventoryI18n::DOMAIN),
            'no_results' => $this->trans('No results.', [], PrestashopInventoryI18n::DOMAIN),
            'report_title' => $this->trans('Inventory status', [], PrestashopInventoryI18n::DOMAIN),
            'show_only_active_products' => $this->trans('Show only active products', [], PrestashopInventoryI18n::DOMAIN),
            'show_only_available_in_stock' => $this->trans('Show only available in stock', [], PrestashopInventoryI18n::DOMAIN),
            'show_only_missing_purchase_price' => $this->trans('Show only with missing purchase price', [], PrestashopInventoryI18n::DOMAIN),
            'show_product_weight' => $this->trans('Show product weight', [], PrestashopInventoryI18n::DOMAIN),
            'show_only_missing_weight' => $this->trans('Show products without weight', [], PrestashopInventoryI18n::DOMAIN),
            'show_retail_prices_gross' => $this->trans('Show retail gross prices', [], PrestashopInventoryI18n::DOMAIN),
            'row_number' => $this->trans('No.', [], PrestashopInventoryI18n::DOMAIN),
            'image' => $this->trans('Image', [], PrestashopInventoryI18n::DOMAIN),
            'name' => $this->trans('Name', [], PrestashopInventoryI18n::DOMAIN),
            'product_name' => $this->trans('Product name', [], PrestashopInventoryI18n::DOMAIN),
            'product_weight' => $this->trans('Product weight', [], PrestashopInventoryI18n::DOMAIN),
            'active' => $this->trans('Active', [], PrestashopInventoryI18n::DOMAIN),
            'purchase_price_net' => $this->trans('Purchase price (net)', [], PrestashopInventoryI18n::DOMAIN),
            'purchase_price_gross' => $this->trans('Purchase price (gross)', [], PrestashopInventoryI18n::DOMAIN),
            'retail_price_gross' => $this->trans('Retail price (gross)', [], PrestashopInventoryI18n::DOMAIN),
            'quantity' => $this->trans('Quantity', [], PrestashopInventoryI18n::DOMAIN),
            'available_quantity' => $this->trans('Available quantity', [], PrestashopInventoryI18n::DOMAIN),
            'purchase_value_net' => $this->trans('Purchase value (net)', [], PrestashopInventoryI18n::DOMAIN),
            'retail_value_gross' => $this->trans('Retail value (gross)', [], PrestashopInventoryI18n::DOMAIN),
            'products_per_page' => $this->trans('Products per page:', [], PrestashopInventoryI18n::DOMAIN),
            'visible_range' => $this->trans('Showing %from%-%to% of %total% (page %page% / %total_pages%)', [
                '%from%' => '{{ from }}',
                '%to%' => '{{ to }}',
                '%total%' => '{{ total }}',
                '%page%' => '{{ page }}',
                '%total_pages%' => '{{ total_pages }}',
            ], PrestashopInventoryI18n::DOMAIN),
            'current_page' => $this->trans('Current page', [], PrestashopInventoryI18n::DOMAIN),
            'previous' => $this->trans('Previous', [], PrestashopInventoryI18n::DOMAIN),
            'next' => $this->trans('Next', [], PrestashopInventoryI18n::DOMAIN),
            'id' => $this->trans('ID', [], PrestashopInventoryI18n::DOMAIN),
            'ean13' => $this->trans('EAN13', [], PrestashopInventoryI18n::DOMAIN),
            'module_navigation' => $this->trans('Module navigation', [], PrestashopInventoryI18n::DOMAIN),
            'filters' => $this->trans('Filters', [], PrestashopInventoryI18n::DOMAIN),
            'clear' => $this->trans('Clear', [], PrestashopInventoryI18n::DOMAIN),
            'search_placeholder' => $this->trans('Search table...', [], PrestashopInventoryI18n::DOMAIN),
            'save' => $this->trans('Save', [], PrestashopInventoryI18n::DOMAIN),
            'cancel' => $this->trans('Cancel', [], PrestashopInventoryI18n::DOMAIN),
            'enter_qty' => $this->trans('e.g. 12', [], PrestashopInventoryI18n::DOMAIN),
            'enter_price' => $this->trans('e.g. 12.34', [], PrestashopInventoryI18n::DOMAIN),
            'enter_retail_price' => $this->trans('e.g. 99.99', [], PrestashopInventoryI18n::DOMAIN),
            'enter_weight' => $this->trans('e.g. 1.250', [], PrestashopInventoryI18n::DOMAIN),
            'error_save' => $this->trans('Save error', [], PrestashopInventoryI18n::DOMAIN),
            'error_network' => $this->trans('Connection / server error while saving.', [], PrestashopInventoryI18n::DOMAIN),
            'error_qty_save' => $this->trans('Could not save quantity.', [], PrestashopInventoryI18n::DOMAIN),
            'error_weight_save' => $this->trans('Could not save weight.', [], PrestashopInventoryI18n::DOMAIN),
            'error_hide' => $this->trans('Could not hide the product.', [], PrestashopInventoryI18n::DOMAIN),
            'type_qty' => $this->trans('Enter an integer quantity.', [], PrestashopInventoryI18n::DOMAIN),
            'type_price' => $this->trans('Enter a price.', [], PrestashopInventoryI18n::DOMAIN),
            'type_weight' => $this->trans('Enter a valid weight.', [], PrestashopInventoryI18n::DOMAIN),
            'error_toggle' => $this->trans('Could not change product status.', [], PrestashopInventoryI18n::DOMAIN),
            'copied' => $this->trans('Copied', [], PrestashopInventoryI18n::DOMAIN),
            'copy_error' => $this->trans('Could not copy EAN13.', [], PrestashopInventoryI18n::DOMAIN),
            'load_error' => $this->trans('Loading error.', [], PrestashopInventoryI18n::DOMAIN),
            'sales_chart' => $this->trans('Sales chart', [], PrestashopInventoryI18n::DOMAIN),
            'profitability' => $this->trans('Profitability', [], PrestashopInventoryI18n::DOMAIN),
            'store_price' => $this->trans('Store price', [], PrestashopInventoryI18n::DOMAIN),
            'marketplace_price' => $this->trans('Marketplace price', [], PrestashopInventoryI18n::DOMAIN),
            'store_channel' => $this->trans('Store', [], PrestashopInventoryI18n::DOMAIN),
            'marketplace_channel' => $this->trans('Marketplace', [], PrestashopInventoryI18n::DOMAIN),
            'profitability_markup' => $this->trans('Markup', [], PrestashopInventoryI18n::DOMAIN),
            'profitability_margin' => $this->trans('Margin', [], PrestashopInventoryI18n::DOMAIN),
            'profitability_profit' => $this->trans('Profit (net)', [], PrestashopInventoryI18n::DOMAIN),
            'marketplace_markup' => $this->trans('Marketplace markup', [], PrestashopInventoryI18n::DOMAIN),
            'marketplace_markup_description' => $this->trans('Enter the percentage value of how much higher the product price is on the marketplace compared to the store price.', [], PrestashopInventoryI18n::DOMAIN),
            'marketplace_commission' => $this->trans('Marketplace commission', [], PrestashopInventoryI18n::DOMAIN),
            'marketplace_commission_description' => $this->trans('Enter the percentage value of the total sales commission cost on the marketplace.', [], PrestashopInventoryI18n::DOMAIN),
            'marketplace_settings' => $this->trans('Marketplace settings', [], PrestashopInventoryI18n::DOMAIN),
            'license_required_title' => $this->trans('License required', [], PrestashopInventoryI18n::DOMAIN),
            'license_missing_message' => $this->trans('The module requires a valid license key in the license.php file.', [], PrestashopInventoryI18n::DOMAIN),
            'license_invalid_message' => $this->trans('The license key is invalid.', [], PrestashopInventoryI18n::DOMAIN),
            'license_expired_message' => $this->trans('The license has expired.', [], PrestashopInventoryI18n::DOMAIN),
            'license_domain_mismatch_message' => $this->trans('The license is not valid for this shop domain.', [], PrestashopInventoryI18n::DOMAIN),
            'license_file_error_message' => $this->trans('The license file or public verification key could not be read.', [], PrestashopInventoryI18n::DOMAIN),
            'update_available_button' => $this->trans('Update to %version%', ['%version%' => '{{ version }}'], PrestashopInventoryI18n::DOMAIN),
            'update_checking_message' => $this->trans('Checking for updates...', [], PrestashopInventoryI18n::DOMAIN),
            'update_installing_message' => $this->trans('Downloading and installing the update...', [], PrestashopInventoryI18n::DOMAIN),
            'update_installed_message' => $this->trans('The module was updated. Refresh the page.', [], PrestashopInventoryI18n::DOMAIN),
            'update_check_error_message' => $this->trans('Could not check for updates.', [], PrestashopInventoryI18n::DOMAIN),
            'update_install_error_message' => $this->trans('Could not install the update.', [], PrestashopInventoryI18n::DOMAIN),
            'enter_percentage' => $this->trans('e.g. 20', [], PrestashopInventoryI18n::DOMAIN),
            'type_percentage' => $this->trans('Enter a valid percentage.', [], PrestashopInventoryI18n::DOMAIN),
            'percent_short' => $this->trans('%', [], PrestashopInventoryI18n::DOMAIN),
            'not_available' => $this->trans('—', [], PrestashopInventoryI18n::DOMAIN),
            'sales_stats_title' => $this->trans('Monthly sales', [], PrestashopInventoryI18n::DOMAIN),
            'sales_stats_loading' => $this->trans('Loading sales statistics...', [], PrestashopInventoryI18n::DOMAIN),
            'sales_stats_empty' => $this->trans('No sales in selected period.', [], PrestashopInventoryI18n::DOMAIN),
            'sales_months_range' => $this->trans('Last 12 months', [], PrestashopInventoryI18n::DOMAIN),
            'sales_total_sold' => $this->trans('Total sold', [], PrestashopInventoryI18n::DOMAIN),
            'sales_best_month' => $this->trans('Best month', [], PrestashopInventoryI18n::DOMAIN),
            'sales_months_count' => $this->trans('Months', [], PrestashopInventoryI18n::DOMAIN),
            'sales_units' => $this->trans('pcs', [], PrestashopInventoryI18n::DOMAIN),
            'year' => $this->trans('Year', [], PrestashopInventoryI18n::DOMAIN),
            'error_sales_stats' => $this->trans('Could not load sales statistics.', [], PrestashopInventoryI18n::DOMAIN),
            'close' => $this->trans('Close', [], PrestashopInventoryI18n::DOMAIN),
            'previous_year' => $this->trans('Previous year', [], PrestashopInventoryI18n::DOMAIN),
            'next_year' => $this->trans('Next year', [], PrestashopInventoryI18n::DOMAIN),
            'product_restored' => $this->trans('Product restored to the list.', [], PrestashopInventoryI18n::DOMAIN),
            'product_restore_error' => $this->trans('Could not restore the product.', [], PrestashopInventoryI18n::DOMAIN),
            'restore' => $this->trans('Restore', [], PrestashopInventoryI18n::DOMAIN),
            'displayed' => $this->trans('Displayed', [], PrestashopInventoryI18n::DOMAIN),
            'hidden_products_empty' => $this->trans('No hidden products.', [], PrestashopInventoryI18n::DOMAIN),
            'module_parent_tab_error' => $this->trans('Could not resolve the parent Back Office tab for Inventory.', [], PrestashopInventoryI18n::DOMAIN),
            'module_tab_create_error' => $this->trans('Could not create the Inventory tab in Back Office.', [], PrestashopInventoryI18n::DOMAIN),
            'access_denied' => $this->trans('Access denied', [], PrestashopInventoryI18n::DOMAIN),
            'db_update_error' => $this->trans('Database update error', [], PrestashopInventoryI18n::DOMAIN),
            'stock_update_error' => $this->trans('Stock update error', [], PrestashopInventoryI18n::DOMAIN),
            'hide_product_error' => $this->trans('Hide product error', [], PrestashopInventoryI18n::DOMAIN),
            'missing_id_product' => $this->trans('Missing product ID', [], PrestashopInventoryI18n::DOMAIN),
            'invalid_price' => $this->trans('Invalid price', [], PrestashopInventoryI18n::DOMAIN),
            'price_must_be_greater_than_zero' => $this->trans('Price must be greater than 0', [], PrestashopInventoryI18n::DOMAIN),
            'invalid_quantity' => $this->trans('Invalid quantity', [], PrestashopInventoryI18n::DOMAIN),
            'invalid_weight' => $this->trans('Invalid weight', [], PrestashopInventoryI18n::DOMAIN),
            'stock_api_not_available' => $this->trans('Stock API is not available.', [], PrestashopInventoryI18n::DOMAIN),
            'product_not_found' => $this->trans('Product not found', [], PrestashopInventoryI18n::DOMAIN),
            'pdf_filename' => $this->trans('Inventory_status_%date%', ['%date%' => '{{ date }}'], PrestashopInventoryI18n::DOMAIN),
        ];
    }

    private function installTab(): bool
    {
        $tabId = (int) Tab::getIdFromClassName(self::ADMIN_TAB_CLASS_NAME);
        if ($tabId > 0) {
            return true;
        }

        $parentId = $this->resolveCatalogParentTabId();
        if ($parentId <= 0) {
            $this->_errors[] = PrestashopInventoryI18n::translate($this, 'module_parent_tab_error');

            return false;
        }

        $tab = new Tab();
        $tab->active = 1;
        $tab->class_name = self::ADMIN_TAB_CLASS_NAME;
        $tab->module = $this->name;
        $tab->id_parent = $parentId;

        $inventoryLabel = PrestashopInventoryI18n::translate($this, 'inventory_report');
        foreach (Language::getLanguages(false) as $language) {
            $tab->name[(int) $language['id_lang']] = $inventoryLabel;
        }

        if (!$tab->add()) {
            $this->_errors[] = PrestashopInventoryI18n::translate($this, 'module_tab_create_error');

            return false;
        }

        return true;
    }

    private function uninstallTab(): bool
    {
        $tabId = (int) Tab::getIdFromClassName(self::ADMIN_TAB_CLASS_NAME);
        if ($tabId <= 0) {
            return true;
        }

        $tab = new Tab($tabId);

        return (bool) $tab->delete();
    }

    private function resolveCatalogParentTabId(): int
    {
        $candidates = [
            'AdminCatalog',
            'SELL',
            'AdminParentCatalog',
        ];

        foreach ($candidates as $className) {
            $tabId = (int) Tab::getIdFromClassName($className);
            if ($tabId > 0) {
                return $tabId;
            }
        }

        return 0;
    }
}
