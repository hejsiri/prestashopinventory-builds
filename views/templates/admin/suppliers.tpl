<div class="inventory-module-content">
<div id="psinventory-suppliers-head-tabs-source" class="page-head-tabs inventory-panel-tabs" role="tablist" aria-label="{$inventoryTranslations.module_navigation|escape:'html':'UTF-8'}">
  <ul class="nav nav-pills">
    <li class="nav-item">
      <a href="{$inventoryModuleUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$inventoryTranslations.products_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$inventorySuppliersUrl|escape:'html':'UTF-8'}" class="router-link-active router-link-exact-active nav-link active" aria-current="page" role="tab">{$inventoryTranslations.suppliers_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$inventoryPurchaseOrdersUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$inventoryTranslations.purchase_orders_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$inventoryConfigUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$inventoryTranslations.settings_tab|escape:'html':'UTF-8'}</a>
    </li>
  </ul>
</div>

<div class="panel prestashopinventory-placeholder-panel">
  <div class="prestashopinventory-placeholder-head">
    <div>
      <h3 class="prestashopinventory-placeholder-title">{$inventoryTranslations.suppliers_tab|escape:'html':'UTF-8'}</h3>
      <p class="prestashopinventory-placeholder-copy">{$inventoryTranslations.supplier_panel_note|escape:'html':'UTF-8'}</p>
    </div>
    {if $inventoryCanManageSuppliers}
      <a href="{$inventorySupplierCreateUrl|escape:'html':'UTF-8'}" class="btn btn-primary prestashopinventory-placeholder-link">{$inventoryTranslations.supplier_add_button|escape:'html':'UTF-8'}</a>
    {/if}
  </div>

  {foreach from=$inventorySupplierMessages item=message}
    <div class="alert alert-success">{$message|escape:'html':'UTF-8'}</div>
  {/foreach}

  {foreach from=$inventorySupplierErrors item=errorMessage}
    <div class="alert alert-danger">{$errorMessage|escape:'html':'UTF-8'}</div>
  {/foreach}

  {if $inventorySupplierForm.show}
    <div class="prestashopinventory-supplier-form-wrap">
      <div class="prestashopinventory-supplier-form-head">
        <h4 class="prestashopinventory-supplier-form-title">{$inventorySupplierForm.title|escape:'html':'UTF-8'}</h4>
        <a href="{$inventorySupplierListUrl|escape:'html':'UTF-8'}" class="btn btn-outline-secondary btn-sm">{$inventoryTranslations.supplier_back_to_list|escape:'html':'UTF-8'}</a>
      </div>

      <form method="post" action="{$inventorySuppliersUrl|escape:'html':'UTF-8'}" class="prestashopinventory-supplier-form">
        <input type="hidden" name="id_supplier" value="{$inventorySupplierForm.data.id_supplier|intval}">

        <div class="form-group">
          <label for="supplier_name">{$inventoryTranslations.name|escape:'html':'UTF-8'}</label>
          <input type="text" id="supplier_name" name="supplier_name" class="form-control" value="{$inventorySupplierForm.data.name|escape:'html':'UTF-8'}" required>
        </div>

        <div class="form-group">
          <label for="supplier_description">{$inventoryTranslations.supplier_description|escape:'html':'UTF-8'}</label>
          <textarea id="supplier_description" name="supplier_description" class="form-control" rows="4">{$inventorySupplierForm.data.description|escape:'html':'UTF-8'}</textarea>
        </div>

        <div class="form-group">
          <label for="supplier_phone">{$inventoryTranslations.phone|escape:'html':'UTF-8'}</label>
          <input type="text" id="supplier_phone" name="supplier_phone" class="form-control" value="{$inventorySupplierForm.data.phone|escape:'html':'UTF-8'}">
        </div>

        <div class="form-group">
          <label for="supplier_address1">* {$inventoryTranslations.address|escape:'html':'UTF-8'}</label>
          <input type="text" id="supplier_address1" name="supplier_address1" class="form-control" value="{$inventorySupplierForm.data.address1|escape:'html':'UTF-8'}" required>
        </div>

        <div class="form-group">
          <label for="supplier_address2">{$inventoryTranslations.address2|escape:'html':'UTF-8'}</label>
          <input type="text" id="supplier_address2" name="supplier_address2" class="form-control" value="{$inventorySupplierForm.data.address2|escape:'html':'UTF-8'}">
        </div>

        <div class="prestashopinventory-supplier-form-grid">
          <div class="form-group">
            <label for="supplier_postcode">{$inventoryTranslations.postcode|escape:'html':'UTF-8'}</label>
            <input type="text" id="supplier_postcode" name="supplier_postcode" class="form-control" value="{$inventorySupplierForm.data.postcode|escape:'html':'UTF-8'}">
          </div>

          <div class="form-group">
            <label for="supplier_city">* {$inventoryTranslations.city|escape:'html':'UTF-8'}</label>
            <input type="text" id="supplier_city" name="supplier_city" class="form-control" value="{$inventorySupplierForm.data.city|escape:'html':'UTF-8'}" required>
          </div>
        </div>

        <div class="form-group">
          <label for="supplier_id_country">* {$inventoryTranslations.country|escape:'html':'UTF-8'}</label>
          <select id="supplier_id_country" name="supplier_id_country" class="form-control" required>
            <option value="">--</option>
            {foreach from=$inventorySupplierCountries item=country}
              <option value="{$country.id_country|intval}" {if $inventorySupplierForm.data.id_country|intval === $country.id_country|intval}selected{/if}>{$country.name|escape:'html':'UTF-8'}</option>
            {/foreach}
          </select>
        </div>

        <div class="form-group">
          <label class="prestashopinventory-form-check">
            <input type="checkbox" name="supplier_active" value="1" {if $inventorySupplierForm.data.active}checked{/if}>
            <span>{$inventoryTranslations.active|escape:'html':'UTF-8'}</span>
          </label>
        </div>

        <div class="prestashopinventory-supplier-form-actions">
          <button type="submit" name="submitPrestashopInventorySaveSupplier" class="btn btn-primary">{$inventoryTranslations.save|escape:'html':'UTF-8'}</button>
          <a href="{$inventorySupplierListUrl|escape:'html':'UTF-8'}" class="btn btn-outline-secondary">{$inventoryTranslations.cancel|escape:'html':'UTF-8'}</a>
        </div>
      </form>
    </div>
  {/if}

  {if $inventorySuppliers}
    <div class="table-responsive-row clearfix">
      <table class="table">
        <thead>
          <tr>
            <th>ID</th>
            <th>{$inventoryTranslations.name|escape:'html':'UTF-8'}</th>
            <th>{$inventoryTranslations.supplier_products_count|escape:'html':'UTF-8'}</th>
            <th>{$inventoryTranslations.active|escape:'html':'UTF-8'}</th>
            <th>{$inventoryTranslations.created_at|escape:'html':'UTF-8'}</th>
            <th>{$inventoryTranslations.updated_at|escape:'html':'UTF-8'}</th>
            <th>{$inventoryTranslations.actions|escape:'html':'UTF-8'}</th>
          </tr>
        </thead>
        <tbody>
          {foreach from=$inventorySuppliers item=supplier}
            <tr>
              <td>{$supplier.id_supplier|intval}</td>
              <td><strong>{$supplier.name|escape:'html':'UTF-8'}</strong></td>
              <td>{$supplier.products_count|intval}</td>
              <td>
                <span class="switch prestashop-switch fixed-width-lg prestashopinventory-switch-readonly">
                  <input
                    type="radio"
                    name="supplier_active_{$supplier.id_supplier|intval}"
                    id="supplier_active_on_{$supplier.id_supplier|intval}"
                    value="1"
                    {if $supplier.active}checked="checked"{/if}
                    disabled="disabled"
                  >
                  <label for="supplier_active_on_{$supplier.id_supplier|intval}">Tak</label>

                  <input
                    type="radio"
                    name="supplier_active_{$supplier.id_supplier|intval}"
                    id="supplier_active_off_{$supplier.id_supplier|intval}"
                    value="0"
                    {if !$supplier.active}checked="checked"{/if}
                    disabled="disabled"
                  >
                  <label for="supplier_active_off_{$supplier.id_supplier|intval}">Nie</label>

                  <a class="slide-button btn"></a>
                </span>
              </td>
              <td>{$supplier.date_add|escape:'html':'UTF-8'}</td>
              <td>{$supplier.date_upd|escape:'html':'UTF-8'}</td>
              <td>
                {if $inventoryCanManageSuppliers}
                  <a href="{$supplier.edit_url|escape:'html':'UTF-8'}" class="btn btn-outline-secondary btn-sm">{$inventoryTranslations.supplier_edit_button|escape:'html':'UTF-8'}</a>
                {/if}
              </td>
            </tr>
          {/foreach}
        </tbody>
      </table>
    </div>
  {else}
    <div class="alert alert-info mb-0">{$inventoryTranslations.suppliers_empty|escape:'html':'UTF-8'}</div>
  {/if}
</div>
</div>

<style>
  .inventory-module-content {
    padding-top: 60px;
    clear: both;
    position: relative;
  }

  .inventory-panel-tabs {
    margin: 0;
    flex: 1 1 auto;
  }

  .page-head > .inventory-panel-tabs {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 14px;
    min-height: 58px;
    margin: 0;
    padding: 0;
    border-top: 1px solid #eaebec;
    border-bottom: 1px solid #eaebec;
    background: #fff;
    box-shadow: none;
  }

  .page-head > .inventory-panel-tabs .nav.nav-pills {
    display: flex;
    flex: 1 1 auto;
    align-self: stretch;
    gap: 0;
    margin: 0;
    padding: 0;
  }

  .page-head > .inventory-panel-tabs .nav-item {
    display: flex;
    margin: 0;
  }

  .page-head > .inventory-panel-tabs .nav-link {
    position: relative;
    display: inline-flex;
    align-items: center;
    margin: 0;
    min-height: 56px;
    padding: 0 1.6rem;
    border: 0;
    border-radius: 0;
    background: transparent;
    color: #6c868e;
    font-size: 0.95rem;
    font-weight: 400;
    line-height: 1.3;
    transition: color .2s ease, background-color .2s ease;
    box-shadow: none;
  }

  .page-head > .inventory-panel-tabs .nav-link:hover,
  .page-head > .inventory-panel-tabs .nav-link:focus {
    background: #fff;
    color: #25b9d7;
    box-shadow: none;
  }

  .page-head > .inventory-panel-tabs .nav-link::after {
    content: "";
    position: absolute;
    right: 0;
    bottom: 0;
    left: 0;
    height: 3px;
    background: #25b9d7;
    opacity: 0;
    transition: opacity .2s ease;
  }

  .page-head > .inventory-panel-tabs .nav-link:hover::after,
  .page-head > .inventory-panel-tabs .nav-link:focus::after,
  .page-head > .inventory-panel-tabs .nav-link.active::after,
  .page-head > .inventory-panel-tabs .nav-link[aria-current="page"]::after {
    opacity: 1;
  }

  .page-head > .inventory-panel-tabs .nav-link.active,
  .page-head > .inventory-panel-tabs .nav-link[aria-current="page"] {
    background: #eef8fd;
    color: #363a41;
    font-weight: 400;
    box-shadow: none;
  }

  .prestashopinventory-placeholder-panel {
    border: 1px solid #dce7ef;
    border-radius: 4px;
    box-shadow: none;
    padding: 24px 28px;
    background: #fff;
  }

  .prestashopinventory-placeholder-head,
  .prestashopinventory-supplier-form-head {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 18px;
  }

  .prestashopinventory-placeholder-title,
  .prestashopinventory-supplier-form-title {
    margin: 0 0 10px;
    font-size: 22px;
    font-weight: 700;
    color: #243746;
  }

  .prestashopinventory-placeholder-copy {
    margin: 0 0 18px;
    color: #5f7484;
  }

  .prestashopinventory-placeholder-link {
    white-space: nowrap;
  }

  .prestashopinventory-supplier-form-wrap {
    margin-bottom: 24px;
    padding: 20px;
    border: 1px solid #dce7ef;
    border-radius: 4px;
    background: linear-gradient(180deg, #fbfdff 0%, #f4f9fc 100%);
  }

  .prestashopinventory-supplier-form .form-group {
    margin-bottom: 16px;
  }

  .prestashopinventory-supplier-form-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 16px;
  }

  .prestashopinventory-form-check {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    font-weight: 600;
  }

  @media (max-width: 768px) {
    .prestashopinventory-supplier-form-grid {
      grid-template-columns: 1fr;
    }
  }

  .prestashopinventory-supplier-form-actions {
    display: flex;
    gap: 12px;
  }

  .prestashopinventory-switch-readonly {
    cursor: default;
  }
</style>

<script>
  (function () {
    function mountBoTabs(sourceId, attempt) {
      var source = document.getElementById(sourceId);
      var pageHead = document.querySelector('.page-head');
      if (!source || !pageHead) {
        if ((attempt || 0) < 20) {
          window.setTimeout(function () {
            mountBoTabs(sourceId, (attempt || 0) + 1);
          }, 150);
        }
        return false;
      }

      var pageHeadWrapper = pageHead.querySelector('.page-head__tabs');
      var contentDiv = document.getElementById('content') || document.querySelector('.content-div');

      if (pageHeadWrapper) {
        if (source.parentNode !== pageHead || source.previousElementSibling !== pageHeadWrapper) {
          pageHeadWrapper.insertAdjacentElement('afterend', source);
        }
      } else if (source.parentNode !== pageHead) {
        pageHead.appendChild(source);
      }

      if (contentDiv) {
        contentDiv.classList.add('with-tabs');
      }

      source.hidden = false;
      return true;
    }

    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', function () {
        mountBoTabs('psinventory-suppliers-head-tabs-source', 0);
      });
    } else {
      mountBoTabs('psinventory-suppliers-head-tabs-source', 0);
    }

    window.addEventListener('load', function () {
      mountBoTabs('psinventory-suppliers-head-tabs-source', 0);
    });
  })();
</script>
