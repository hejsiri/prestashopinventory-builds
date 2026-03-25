<?php
declare(strict_types=1);

namespace PrestaShop\Module\PrestashopInventory\Controller\Admin;

require_once dirname(__DIR__, 3) . '/classes/PrestashopInventoryService.php';
require_once dirname(__DIR__, 3) . '/classes/PrestashopInventoryLicense.php';

use PrestaShopBundle\Security\Annotation\AdminSecurity;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Response;

class SuppliersController extends AbstractInventoryController
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
        $texts = $this->inventoryTexts();
        $errors = [];
        $messages = [];
        $form = [];

        if ($module instanceof \PrestashopInventory) {
            $module->ensureTabsAvailable();
        }

        if ($request->isMethod('POST') && \Tools::isSubmit('submitPrestashopInventorySaveSupplier')) {
            $formData = [
                'id_supplier' => (int) \Tools::getValue('id_supplier'),
                'name' => (string) \Tools::getValue('supplier_name', ''),
                'description' => (string) \Tools::getValue('supplier_description', ''),
                'active' => (bool) \Tools::getValue('supplier_active', 0),
                'phone' => (string) \Tools::getValue('supplier_phone', ''),
                'address1' => (string) \Tools::getValue('supplier_address1', ''),
                'address2' => (string) \Tools::getValue('supplier_address2', ''),
                'postcode' => (string) \Tools::getValue('supplier_postcode', ''),
                'city' => (string) \Tools::getValue('supplier_city', ''),
                'id_country' => (int) \Tools::getValue('supplier_id_country', 0),
            ];

            try {
                $savedSupplierId = $service->saveSupplier($formData);

                return $this->redirectToRoute('prestashop_inventory_suppliers', [
                    'supplier_status' => $formData['id_supplier'] > 0 ? 'updated' : 'created',
                    'id_supplier' => $savedSupplierId,
                ]);
            } catch (\Throwable $e) {
                $errors[] = $texts['supplier_save_error'] ?? 'Could not save supplier.';
                if (\defined('_PS_MODE_DEV_') && _PS_MODE_DEV_) {
                    $errors[] = $e->getMessage();
                }

                $form = [
                    'show' => true,
                    'mode' => $formData['id_supplier'] > 0 ? 'edit' : 'create',
                    'title' => $formData['id_supplier'] > 0
                        ? ($texts['supplier_form_edit_title'] ?? 'Edit supplier')
                        : ($texts['supplier_form_new_title'] ?? 'New supplier'),
                    'data' => $formData,
                ];
            }
        }

        if (!$messages) {
            $status = (string) $request->query->get('supplier_status', '');
            if ($status === 'created') {
                $messages[] = $texts['supplier_created_message'] ?? 'Supplier created.';
            } elseif ($status === 'updated') {
                $messages[] = $texts['supplier_updated_message'] ?? 'Supplier updated.';
            }
        }

        if (!$form) {
            if ($request->query->has('addSupplier')) {
                $form = [
                    'show' => true,
                    'mode' => 'create',
                    'title' => $texts['supplier_form_new_title'] ?? 'New supplier',
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
                        'id_country' => (int) \Configuration::get('PS_COUNTRY_DEFAULT'),
                    ],
                ];
            } elseif ($request->query->has('editSupplier')) {
                $idSupplier = (int) $request->query->get('id_supplier', 0);

                try {
                    $form = [
                        'show' => true,
                        'mode' => 'edit',
                        'title' => $texts['supplier_form_edit_title'] ?? 'Edit supplier',
                        'data' => $service->getSupplierFormData($idSupplier),
                    ];
                } catch (\Throwable $e) {
                    $errors[] = $texts['supplier_not_found'] ?? 'Supplier not found.';
                }
            }
        }

        if (!$form) {
            $form = [
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
                    'id_country' => (int) \Configuration::get('PS_COUNTRY_DEFAULT'),
                ],
            ];
        }

        return $this->renderInventoryPage(
            '@Modules/prestashopinventory/views/templates/admin-modern/suppliers.html.twig',
            'prestashop_inventory_suppliers',
            'suppliers_tab',
            [
                'suppliers' => $service->getSuppliers(),
                'supplierForm' => $form,
                'supplierMessages' => $messages,
                'supplierErrors' => $errors,
                'supplierCountries' => $service->getSupplierCountries(),
                'canManageSuppliers' => true,
                'supplierCreateUrl' => $this->generateUrl('prestashop_inventory_suppliers', ['addSupplier' => 1]),
                'supplierListUrl' => $this->generateUrl('prestashop_inventory_suppliers'),
                'licenseStatus' => $licenseService->getStatus(),
            ]
        );
    }
}
