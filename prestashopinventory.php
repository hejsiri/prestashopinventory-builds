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
    private const SUPPLIERS_TAB_CLASS_NAME = 'AdminPrestashopInventorySuppliers';
    private const PURCHASE_ORDERS_TAB_CLASS_NAME = 'AdminPrestashopInventoryPurchaseOrders';
    private const RUNTIME_VERSION_CONFIG = 'PSINV_RUNTIME_VERSION';

    public function __construct()
    {
        $this->name = 'prestashopinventory';
        $this->tab = 'administration';
        $this->version = '0.3.42';
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

        if (!$this->installTabs()) {
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

        return $this->uninstallTabs() && parent::uninstall();
    }

    public function getContent(): string
    {
        $this->ensureModuleRuntimeReady();
        $this->ensureTabsAvailable();

        $output = '';
        $service = new PrestashopInventoryService($this->getLocalPath(), $this->context, $this);
        $licenseService = new PrestashopInventoryLicense($this->getLocalPath(), $this->context, $this);

        if (Tools::isSubmit('submitPrestashopInventoryRestoreHidden')) {
            try {
                $service->unhideProduct((int) Tools::getValue('id_product'));
                $output .= $this->displayConfirmation(PrestashopInventoryI18n::translate($this, 'product_restored'));
            } catch (Throwable $e) {
                $output .= $this->displayError(PrestashopInventoryI18n::translate($this, 'product_restore_error'));
            }
        }

        $translations = $service->getTranslations();
        $licenseStatus = $licenseService->getStatus();
        $licenseDetails = is_array($licenseStatus['details'] ?? null) ? $licenseStatus['details'] : [];
        $licensePayload = is_array($licenseDetails['payload'] ?? null) ? $licenseDetails['payload'] : [];
        $licenseCustomer = trim((string) ($licensePayload['customer'] ?? ''));
        $licenseDomain = trim((string) ($licenseDetails['domain'] ?? $licensePayload['domain'] ?? ''));
        $licenseExpiresAt = trim((string) ($licenseDetails['expires_at'] ?? $licensePayload['expires_at'] ?? ''));

        $this->context->smarty->assign([
            'prestashopInventoryConfigAction' => AdminController::$currentIndex . '&configure=' . $this->name . '&token=' . Tools::getAdminTokenLite('AdminModules'),
            'prestashopInventoryCatalogUrl' => $this->context->link->getAdminLink('AdminProducts', true),
            'prestashopInventoryBackUrl' => $this->context->link->getAdminLink('AdminPrestashopInventory', true),
            'prestashopInventorySuppliersUrl' => $this->context->link->getAdminLink('AdminPrestashopInventorySuppliers', true),
            'prestashopInventoryPurchaseOrdersUrl' => $this->context->link->getAdminLink('AdminPrestashopInventoryPurchaseOrders', true),
            'prestashopInventoryIgnoredProducts' => $service->getIgnoredProducts(),
            'prestashopInventoryTranslations' => $translations,
            'prestashopInventoryModuleVersion' => (string) $this->version,
            'prestashopInventoryLicenseStatus' => $licenseStatus,
            'prestashopInventoryLicenseSummary' => [
                'customer' => $licenseCustomer !== '' ? $licenseCustomer : '—',
                'domain' => $licenseDomain !== '' ? $licenseDomain : '—',
                'expires_at' => $licenseExpiresAt !== '' ? $licenseExpiresAt : '—',
            ],
        ]);

        $output .= $this->display(__FILE__, 'views/templates/admin/configure.tpl');

        return $output;
    }

    public function ensureTabsAvailable(): void
    {
        $this->ensureModuleRuntimeReady();
        $this->installTabs();
    }

    public function ensureModuleRuntimeReady(): void
    {
        $storedVersion = (string) Configuration::get(self::RUNTIME_VERSION_CONFIG);
        if ($storedVersion === (string) $this->version) {
            return;
        }

        $this->clearRuntimeCache();
        Configuration::updateValue(self::RUNTIME_VERSION_CONFIG, (string) $this->version);
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
            'products_tab' => $this->trans('Products', [], PrestashopInventoryI18n::DOMAIN),
            'suppliers_tab' => $this->trans('Suppliers', [], PrestashopInventoryI18n::DOMAIN),
            'purchase_orders_tab' => $this->trans('Purchase orders', [], PrestashopInventoryI18n::DOMAIN),
            'settings_tab' => $this->trans('Settings', [], PrestashopInventoryI18n::DOMAIN),
            'inventory_report' => $this->trans('Inventory report', [], PrestashopInventoryI18n::DOMAIN),
            'new_products_view_scaffold' => $this->trans('New Products view scaffold for the Inventory module.', [], PrestashopInventoryI18n::DOMAIN),
            'new_suppliers_view_scaffold' => $this->trans('New Suppliers view scaffold for the Inventory module.', [], PrestashopInventoryI18n::DOMAIN),
            'new_purchase_orders_view_scaffold' => $this->trans('New Purchase orders view scaffold for the Inventory module.', [], PrestashopInventoryI18n::DOMAIN),
            'new_settings_view_scaffold' => $this->trans('New Settings view scaffold for the Inventory module.', [], PrestashopInventoryI18n::DOMAIN),
            'products_migration_notice' => $this->trans('This tab will become the new place for the inventory table after the migration to the PrestaShop 8.2+ / 9.x compatible architecture is completed.', [], PrestashopInventoryI18n::DOMAIN),
            'suppliers_migration_notice' => $this->trans('This tab will become the new place for suppliers management after the migration is completed.', [], PrestashopInventoryI18n::DOMAIN),
            'purchase_orders_migration_notice' => $this->trans('This tab will become the new place for purchase orders after the migration is completed.', [], PrestashopInventoryI18n::DOMAIN),
            'settings_migration_notice' => $this->trans('This tab will become the new place for hidden products configuration and module settings after the migration is completed.', [], PrestashopInventoryI18n::DOMAIN),
            'suppliers_empty' => $this->trans('No suppliers found.', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_products_count' => $this->trans('Products', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_open_native' => $this->trans('Open in PrestaShop', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_panel_note' => $this->trans('This list uses the default suppliers configured in PrestaShop.', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_add_button' => $this->trans('Add supplier', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_form_new_title' => $this->trans('New supplier', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_form_edit_title' => $this->trans('Edit supplier', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_description' => $this->trans('Description', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_edit_button' => $this->trans('Edit', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_back_to_list' => $this->trans('Back to list', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_created_message' => $this->trans('Supplier created.', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_updated_message' => $this->trans('Supplier updated.', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_save_error' => $this->trans('Could not save supplier.', [], PrestashopInventoryI18n::DOMAIN),
            'supplier_not_found' => $this->trans('Supplier not found.', [], PrestashopInventoryI18n::DOMAIN),
            'created_at' => $this->trans('Created at', [], PrestashopInventoryI18n::DOMAIN),
            'updated_at' => $this->trans('Updated at', [], PrestashopInventoryI18n::DOMAIN),
            'phone' => $this->trans('Phone', [], PrestashopInventoryI18n::DOMAIN),
            'address' => $this->trans('Address', [], PrestashopInventoryI18n::DOMAIN),
            'address2' => $this->trans('Address (2)', [], PrestashopInventoryI18n::DOMAIN),
            'postcode' => $this->trans('Postal code', [], PrestashopInventoryI18n::DOMAIN),
            'city' => $this->trans('City', [], PrestashopInventoryI18n::DOMAIN),
            'country' => $this->trans('Country', [], PrestashopInventoryI18n::DOMAIN),
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
            'sales_revenue' => $this->trans('Wartość sprzedaży (brutto)', [], PrestashopInventoryI18n::DOMAIN),
            'sales_revenue_short' => $this->trans('wartość sprzedaży (brutto)', [], PrestashopInventoryI18n::DOMAIN),
            'sales_revenue_net' => $this->trans('Wartość sprzedaży (netto)', [], PrestashopInventoryI18n::DOMAIN),
            'sales_revenue_net_short' => $this->trans('wartość sprzedaży (netto)', [], PrestashopInventoryI18n::DOMAIN),
            'estimated_profit_net' => $this->trans('Szacowany zysk netto', [], PrestashopInventoryI18n::DOMAIN),
            'estimated_profit_gross' => $this->trans('Szacowany zysk brutto', [], PrestashopInventoryI18n::DOMAIN),
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

    private function installTabs(): bool
    {
        $parentId = $this->resolveCatalogParentTabId();
        if ($parentId <= 0) {
            $this->_errors[] = PrestashopInventoryI18n::translate($this, 'module_parent_tab_error');

            return false;
        }

        $mainTabId = $this->ensureTab(self::ADMIN_TAB_CLASS_NAME, $parentId, PrestashopInventoryI18n::translate($this, 'inventory_report'), true);
        if ($mainTabId <= 0) {
            return false;
        }

        if ($this->ensureTab(self::SUPPLIERS_TAB_CLASS_NAME, $mainTabId, PrestashopInventoryI18n::translate($this, 'suppliers_tab'), false) <= 0) {
            return false;
        }

        if ($this->ensureTab(self::PURCHASE_ORDERS_TAB_CLASS_NAME, $mainTabId, PrestashopInventoryI18n::translate($this, 'purchase_orders_tab'), false) <= 0) {
            return false;
        }

        return true;
    }

    private function uninstallTabs(): bool
    {
        $success = true;

        foreach ([self::SUPPLIERS_TAB_CLASS_NAME, self::PURCHASE_ORDERS_TAB_CLASS_NAME, self::ADMIN_TAB_CLASS_NAME] as $className) {
            $tabId = (int) Tab::getIdFromClassName($className);
            if ($tabId <= 0) {
                continue;
            }

            $tab = new Tab($tabId);
            $success = (bool) $tab->delete() && $success;
        }

        return $success;
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

    private function ensureTab(string $className, int $parentId, string $label, bool $active): int
    {
        $tabId = (int) Tab::getIdFromClassName($className);
        if ($tabId > 0) {
            return $tabId;
        }

        $tab = new Tab();
        $tab->active = $active ? 1 : 0;
        $tab->class_name = $className;
        $tab->module = $this->name;
        $tab->id_parent = $parentId;

        foreach (Language::getLanguages(false) as $language) {
            $tab->name[(int) $language['id_lang']] = $label;
        }

        if (!$tab->add()) {
            $this->_errors[] = PrestashopInventoryI18n::translate($this, 'module_tab_create_error');

            return 0;
        }

        return (int) $tab->id;
    }

    private function clearRuntimeCache(): void
    {
        $cachePaths = [
            _PS_ROOT_DIR_ . '/var/cache',
            _PS_ROOT_DIR_ . '/app/cache',
        ];

        foreach ($cachePaths as $cachePath) {
            if (!is_dir($cachePath)) {
                continue;
            }

            $entries = @scandir($cachePath);
            if (!is_array($entries)) {
                continue;
            }

            foreach ($entries as $entry) {
                if ($entry === '.' || $entry === '..') {
                    continue;
                }

                $this->deletePathRecursively($cachePath . '/' . $entry);
            }
        }
    }

    private function deletePathRecursively(string $path): void
    {
        if (!file_exists($path) && !is_link($path)) {
            return;
        }

        if (is_file($path) || is_link($path)) {
            @unlink($path);

            return;
        }

        $entries = @scandir($path);
        if (is_array($entries)) {
            foreach ($entries as $entry) {
                if ($entry === '.' || $entry === '..') {
                    continue;
                }

                $this->deletePathRecursively($path . '/' . $entry);
            }
        }

        @rmdir($path);
    }
}
