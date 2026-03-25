<?php

require_once dirname(__DIR__, 2) . '/classes/PrestashopInventoryService.php';
require_once dirname(__DIR__, 2) . '/classes/PrestashopInventoryI18n.php';
require_once dirname(__DIR__, 2) . '/classes/PrestashopInventoryLicense.php';

class AdminPrestashopInventorySuppliersController extends ModuleAdminController
{
    private PrestashopInventoryService $inventoryService;
    private PrestashopInventoryLicense $licenseService;
    private array $supplierErrors = [];
    private array $supplierMessages = [];
    private array $supplierForm = [];

    public function __construct()
    {
        $this->bootstrap = true;

        parent::__construct();

        $this->inventoryService = new PrestashopInventoryService($this->module->getLocalPath(), $this->context, $this->module);
        $this->licenseService = new PrestashopInventoryLicense($this->module->getLocalPath(), $this->context, $this->module);
    }

    public function postProcess(): void
    {
        if (Tools::isSubmit('submitPrestashopInventorySaveSupplier')) {
            $this->handleSupplierSave();
        }

        parent::postProcess();
    }

    public function initContent(): void
    {
        Tools::redirectAdmin($this->getModuleRouteUrl('prestashop_inventory_suppliers'));

        if ($this->module instanceof PrestashopInventory) {
            $this->module->ensureTabsAvailable();
        }

        $translations = $this->inventoryService->getTranslations();
        $licenseStatus = $this->licenseService->getStatus();
        $suppliers = $this->inventoryService->getSuppliers();

        if (!$this->supplierMessages) {
            $status = (string) Tools::getValue('supplier_status', '');
            if ($status === 'created') {
                $this->supplierMessages[] = $translations['supplier_created_message'] ?? 'Supplier created.';
            } elseif ($status === 'updated') {
                $this->supplierMessages[] = $translations['supplier_updated_message'] ?? 'Supplier updated.';
            }
        }

        if (!$this->supplierForm) {
            $this->supplierForm = $this->buildSupplierFormState($translations);
        }

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
            'inventorySuppliers' => $suppliers,
            'inventorySupplierForm' => $this->supplierForm,
            'inventorySupplierMessages' => $this->supplierMessages,
            'inventorySupplierErrors' => $this->supplierErrors,
            'inventorySupplierCountries' => $this->inventoryService->getSupplierCountries(),
            'inventoryCanManageSuppliers' => $this->access('add') || $this->access('edit'),
            'inventorySupplierCreateUrl' => $this->context->link->getAdminLink('AdminPrestashopInventorySuppliers', true, [], [
                'addSupplier' => 1,
            ]),
            'inventorySupplierListUrl' => $this->context->link->getAdminLink('AdminPrestashopInventorySuppliers', true),
        ]);

        $this->content = $this->module->display(
            $this->module->getLocalPath() . $this->module->name . '.php',
            'views/templates/admin/suppliers.tpl'
        );

        parent::initContent();
    }

    private function getModuleRouteUrl(string $routeName): string
    {
        $router = \PrestaShop\PrestaShop\Adapter\SymfonyContainer::getInstance()->get('router');
        $query = $_GET;
        unset($query['controller'], $query['token']);

        $url = $router->generate($routeName);
        if (!$query) {
            return $url;
        }

        return $url . (strpos($url, '?') === false ? '?' : '&') . http_build_query($query);
    }

    private function handleSupplierSave(): void
    {
        $isEdit = (int) Tools::getValue('id_supplier') > 0;
        if (($isEdit && !$this->access('edit')) || (!$isEdit && !$this->access('add'))) {
            $this->supplierErrors[] = PrestashopInventoryI18n::translate($this->module, 'access_denied');

            return;
        }

        $formData = [
            'id_supplier' => (int) Tools::getValue('id_supplier'),
            'name' => (string) Tools::getValue('supplier_name', ''),
            'description' => (string) Tools::getValue('supplier_description', ''),
            'active' => (bool) Tools::getValue('supplier_active', 0),
            'phone' => (string) Tools::getValue('supplier_phone', ''),
            'address1' => (string) Tools::getValue('supplier_address1', ''),
            'address2' => (string) Tools::getValue('supplier_address2', ''),
            'postcode' => (string) Tools::getValue('supplier_postcode', ''),
            'city' => (string) Tools::getValue('supplier_city', ''),
            'id_country' => (int) Tools::getValue('supplier_id_country', 0),
        ];

        try {
            $savedSupplierId = $this->inventoryService->saveSupplier($formData);
            $status = $formData['id_supplier'] > 0 ? 'updated' : 'created';

            Tools::redirectAdmin($this->context->link->getAdminLink('AdminPrestashopInventorySuppliers', true, [], [
                'supplier_status' => $status,
                'id_supplier' => $savedSupplierId,
            ]));
        } catch (Throwable $e) {
            $this->supplierErrors[] = PrestashopInventoryI18n::translate($this->module, 'supplier_save_error');
            if (_PS_MODE_DEV_) {
                $this->supplierErrors[] = $e->getMessage();
            }

            $translations = $this->inventoryService->getTranslations();
            $this->supplierForm = [
                'show' => true,
                'mode' => $formData['id_supplier'] > 0 ? 'edit' : 'create',
                'title' => $formData['id_supplier'] > 0
                    ? ($translations['supplier_form_edit_title'] ?? 'Edit supplier')
                    : ($translations['supplier_form_new_title'] ?? 'New supplier'),
                'data' => $formData,
            ];
        }
    }

    private function buildSupplierFormState(array $translations): array
    {
        if (Tools::getIsset('addSupplier')) {
            return [
                'show' => true,
                'mode' => 'create',
                'title' => $translations['supplier_form_new_title'] ?? 'New supplier',
                'data' => [
                    'id_supplier' => 0,
                    'name' => '',
                    'description' => '',
                    'active' => true,
                    'id_address' => 0,
                    'phone' => '',
                    'address1' => '',
                    'address2' => '',
                    'postcode' => '',
                    'city' => '',
                    'id_country' => (int) Configuration::get('PS_COUNTRY_DEFAULT'),
                ],
            ];
        }

        if (Tools::getIsset('editSupplier')) {
            $idSupplier = (int) Tools::getValue('id_supplier');

            try {
                return [
                    'show' => true,
                    'mode' => 'edit',
                    'title' => $translations['supplier_form_edit_title'] ?? 'Edit supplier',
                    'data' => $this->inventoryService->getSupplierFormData($idSupplier),
                ];
            } catch (Throwable $e) {
                $this->supplierErrors[] = $translations['supplier_not_found'] ?? 'Supplier not found.';
            }
        }

        return [
            'show' => false,
            'mode' => 'list',
            'title' => '',
            'data' => [
                'id_supplier' => 0,
                'name' => '',
                'description' => '',
                'active' => true,
                'id_address' => 0,
                'phone' => '',
                'address1' => '',
                'address2' => '',
                'postcode' => '',
                'city' => '',
                'id_country' => (int) Configuration::get('PS_COUNTRY_DEFAULT'),
            ],
        ];
    }
}
