<div class="inventory-module-content{if !empty($prestashopInventoryEmbeddedInModernLayout)} inventory-module-content--embedded{/if}">
{if empty($prestashopInventoryEmbeddedInModernLayout)}
<div id="psinventory-config-head-tabs-source" class="page-head-tabs inventory-panel-tabs" role="tablist" aria-label="{$prestashopInventoryTranslations.module_navigation|escape:'html':'UTF-8'}">
  <ul class="nav nav-pills">
    <li class="nav-item">
      <a href="{$prestashopInventoryBackUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$prestashopInventoryTranslations.products_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$prestashopInventorySuppliersUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$prestashopInventoryTranslations.suppliers_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$prestashopInventoryPurchaseOrdersUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$prestashopInventoryTranslations.purchase_orders_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$prestashopInventoryConfigAction|escape:'html':'UTF-8'}" class="router-link-active router-link-exact-active nav-link active" aria-current="page" role="tab">{$prestashopInventoryTranslations.settings_tab|escape:'html':'UTF-8'}</a>
    </li>
  </ul>
  <div class="inventory-update-meta">
    <div class="inventory-update-meta-status"></div>
  </div>
</div>
{/if}
{foreach from=$prestashopInventoryMessages item=message}
  <div class="alert alert-success">{$message|escape:'html':'UTF-8'}</div>
{/foreach}

{foreach from=$prestashopInventoryErrors item=errorMessage}
  <div class="alert alert-danger">{$errorMessage|escape:'html':'UTF-8'}</div>
{/foreach}

<div class="card js-grid-panel prestashopinventory-config-list">
  <div class="card-header js-grid-header">
    <h3 class="d-inline-block card-header-title">Informacje o module</h3>
  </div>
  <div class="card-body">
    <div class="inventory-settings-meta">
      <div class="inventory-settings-meta-grid">
        <div class="inventory-settings-meta-item">
          <div class="inventory-settings-meta-label">Wersja modułu</div>
          <div class="inventory-settings-meta-value">{$prestashopInventoryModuleVersion|escape:'html':'UTF-8'}</div>
        </div>

        <div class="inventory-settings-meta-item">
          <div class="inventory-settings-meta-label">Licencja dla</div>
          <div class="inventory-settings-meta-value">{$prestashopInventoryLicenseSummary.customer|escape:'html':'UTF-8'}</div>
        </div>

        <div class="inventory-settings-meta-item">
          <div class="inventory-settings-meta-label">Domena</div>
          <div class="inventory-settings-meta-value">{$prestashopInventoryLicenseSummary.domain|escape:'html':'UTF-8'}</div>
        </div>

        <div class="inventory-settings-meta-item">
          <div class="inventory-settings-meta-label">Wygasa</div>
          <div class="inventory-settings-meta-value">{$prestashopInventoryLicenseSummary.expires_at|escape:'html':'UTF-8'}</div>
        </div>
      </div>

      {if !$prestashopInventoryLicenseStatus.valid}
        <div class="alert alert-danger inventory-settings-license-alert" role="alert">
          <strong>{$prestashopInventoryTranslations.license_required_title|escape:'html':'UTF-8'}:</strong>
          <span>{$prestashopInventoryLicenseStatus.message|escape:'html':'UTF-8'}</span>
        </div>
      {/if}
    </div>
  </div>
</div>

<div class="card js-grid-panel prestashopinventory-config-list">
  <div class="card-header js-grid-header">
    <h3 class="d-inline-block card-header-title">Lista ukrytych produktów</h3>
  </div>
  <div class="card-body">
    {if $prestashopInventoryIgnoredProducts}
      <div class="table-responsive-row clearfix">
        <table class="grid-table js-grid-table table">
          <thead class="thead-default">
            <tr>
              <th>ID</th>
              <th>{$prestashopInventoryTranslations.image|escape:'html':'UTF-8'}</th>
              <th>{$prestashopInventoryTranslations.product_name|escape:'html':'UTF-8'}</th>
              <th>{$prestashopInventoryTranslations.ean13|escape:'html':'UTF-8'}</th>
              <th>{$prestashopInventoryTranslations.displayed|escape:'html':'UTF-8'}</th>
              <th>{$prestashopInventoryTranslations.actions|escape:'html':'UTF-8'}</th>
            </tr>
          </thead>
          <tbody>
            {foreach from=$prestashopInventoryIgnoredProducts item=product}
              <tr>
                <td class="config-col-id">{$product.id_product|intval}</td>
                <td class="config-col-image">
                  {if $product.image_url}
                    <img src="{$product.image_url|escape:'html':'UTF-8'}" alt="" class="config-thumb">
                  {else}
                    <span class="config-empty-image">{$prestashopInventoryTranslations.no_image|escape:'html':'UTF-8'}</span>
                  {/if}
                </td>
                <td>
                  <strong>{$product.product_name|escape:'html':'UTF-8'}</strong>
                </td>
                <td>{$product.ean13|escape:'html':'UTF-8'}</td>
                <td class="config-col-switch">
                  <div class="ps-switch ps-switch-sm ps-switch-nolabel ps-switch-center">
                    <input type="radio" name="hidden_product_active_{$product.id_product|intval}" id="hidden_product_active_{$product.id_product|intval}_off" value="0" {if !$product.active}checked{/if} disabled>
                    <label for="hidden_product_active_{$product.id_product|intval}_off">Off</label>
                    <input type="radio" name="hidden_product_active_{$product.id_product|intval}" id="hidden_product_active_{$product.id_product|intval}_on" value="1" {if $product.active}checked{/if} disabled>
                    <label for="hidden_product_active_{$product.id_product|intval}_on">On</label>
                    <span class="slide-button"></span>
                  </div>
                </td>
                <td class="config-col-actions">
                  <form method="post" action="{$prestashopInventoryConfigAction|escape:'html':'UTF-8'}" class="config-restore-form">
                    <input type="hidden" name="id_product" value="{$product.id_product|intval}">
                    <button type="submit" name="submitPrestashopInventoryRestoreHidden" class="config-secondary-btn">
                      <i class="icon-undo"></i> {$prestashopInventoryTranslations.restore|escape:'html':'UTF-8'}
                    </button>
                  </form>
                </td>
              </tr>
            {/foreach}
          </tbody>
        </table>
      </div>
    {else}
      <p class="alert alert-info">{$prestashopInventoryTranslations.hidden_products_empty|escape:'html':'UTF-8'}</p>
    {/if}
  </div>
</div>

<div class="card js-grid-panel prestashopinventory-config-list">
  <div class="card-header js-grid-header">
    <h3 class="d-inline-block card-header-title">Inne ustawienia</h3>
  </div>
  <div class="card-body">
    <p class="text-muted mb-0">Ta sekcja jest gotowa pod kolejne ustawienia modułu.</p>
  </div>
</div>
</div>

<style>
  .inventory-module-content {
    padding-top: 60px;
    clear: both;
    position: relative;
  }

  .inventory-module-content--embedded {
    padding-top: 0;
  }

  .inventory-panel-tabs {
    margin: 0;
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

  .page-head > .inventory-panel-tabs .inventory-update-meta {
    display: flex;
    flex: 0 0 260px;
    align-items: center;
    justify-content: center;
    min-height: 56px;
    height: 56px;
    margin: 0 18px 0 0;
    text-align: right;
    overflow: hidden;
  }

  .page-head > .inventory-panel-tabs .inventory-update-meta-status {
    display: block;
    width: 100%;
    margin: 0;
    padding: 0;
    border: 0;
    background: transparent;
    font-size: 11px;
    font-weight: 600;
    color: #7a8f9d;
    line-height: 1.25;
    min-height: 0;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  @media (max-width: 1100px) {
    .page-head > .inventory-panel-tabs .inventory-update-meta {
      flex-basis: 180px;
      margin-right: 12px;
    }
  }

  @media (max-width: 920px) {
    .page-head > .inventory-panel-tabs .inventory-update-meta {
      display: none;
    }
  }

  .prestashopinventory-config-list.card {
    margin-bottom: 1rem;
    margin-top: 0 !important;
  }

  .prestashopinventory-config-list .card-header {
    padding: 1rem 1.25rem;
  }

  .prestashopinventory-config-list .card-body {
    padding: 20px 28px 24px;
  }

  .prestashopinventory-config-list .inventory-settings-meta {
    margin-bottom: 24px;
    padding: 18px 20px;
    border: 1px solid #dce7ef;
    border-radius: 4px;
    background: linear-gradient(180deg, #f9fcfe 0%, #f3f8fb 100%);
  }

  .prestashopinventory-config-list .inventory-settings-meta-header {
    margin-bottom: 14px;
  }

  .prestashopinventory-config-list .inventory-settings-meta-title {
    margin: 0;
    font-size: 18px;
    font-weight: 700;
    color: #243746;
  }

  .prestashopinventory-config-list .inventory-settings-meta-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
    gap: 14px;
  }

  .prestashopinventory-config-list .inventory-settings-meta-item {
    padding: 14px 16px;
    border: 1px solid #d8e4ec;
    border-radius: 4px;
    background: #fff;
  }

  .prestashopinventory-config-list .inventory-settings-meta-label {
    margin-bottom: 6px;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: 0.04em;
    text-transform: uppercase;
    color: #6f8796;
  }

  .prestashopinventory-config-list .inventory-settings-meta-value {
    font-size: 15px;
    font-weight: 600;
    color: #243746;
    word-break: break-word;
  }

  .prestashopinventory-config-list .inventory-settings-license-alert {
    margin: 16px 0 0;
  }

  .prestashopinventory-config-list .config-secondary-btn {
    height: 38px;
    padding: 0 14px;
    border: 1px solid #d7d7d7;
    border-radius: 0;
    background: #fff;
    color: #2b2b2b;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    font-size: 14px;
    line-height: 1;
    box-shadow: none;
  }

  .prestashopinventory-config-list .config-secondary-btn:hover,
  .prestashopinventory-config-list .config-secondary-btn:focus {
    background: #f5f5f5;
    color: #2b2b2b;
  }

  .prestashopinventory-config-list .config-secondary-btn i {
    font-size: 14px;
    line-height: 1;
  }

  .prestashopinventory-config-list table {
    margin-bottom: 0;
  }

  .prestashopinventory-config-list thead th {
    border: 0;
    border-bottom: 3px solid #1f1f1f;
    background: transparent;
    font-weight: 700;
    padding: 12px 16px;
  }

  .prestashopinventory-config-list tbody td {
    padding: 12px 16px;
    border: 0;
    border-bottom: 1px solid #ececec;
    vertical-align: middle;
  }

  .prestashopinventory-config-list .config-col-id {
    width: 90px;
    font-weight: 600;
  }

  .prestashopinventory-config-list .config-col-image {
    width: 100px;
  }

  .prestashopinventory-config-list .config-thumb {
    width: 56px;
    height: 56px;
    object-fit: cover;
    background: #fff;
    border: 1px solid #ddd;
    padding: 4px;
  }

  .prestashopinventory-config-list .config-empty-image {
    color: #888;
  }

  .prestashopinventory-config-list .config-col-switch {
    width: 150px;
  }

  .prestashopinventory-config-list .config-col-actions {
    width: 150px;
  }

  .prestashopinventory-config-list .config-restore-form {
    margin: 0;
  }

  .prestashopinventory-config-list .config-col-switch .ps-switch {
    display: inline-block;
  }
</style>

{if empty($prestashopInventoryEmbeddedInModernLayout)}
<script>
  (function () {
    function syncBreadcrumb(currentLabel) {
      var breadcrumb = document.querySelector('.header-toolbar .breadcrumb');
      if (!breadcrumb) {
        return;
      }

      while (breadcrumb.firstChild) {
        breadcrumb.removeChild(breadcrumb.firstChild);
      }

      var catalogItem = document.createElement('li');
      catalogItem.className = 'breadcrumb-item';
      var catalogIcon = document.createElement('i');
      catalogIcon.className = 'material-icons';
      catalogIcon.textContent = 'store';
      catalogItem.appendChild(catalogIcon);
      catalogItem.appendChild(document.createTextNode('Katalog'));
      breadcrumb.appendChild(catalogItem);

      var moduleItem = document.createElement('li');
      moduleItem.className = 'breadcrumb-item';
      var moduleLink = document.createElement('a');
      moduleLink.href = '{$prestashopInventoryBackUrl|escape:'javascript'}';
      moduleLink.textContent = 'Inventory';
      moduleItem.appendChild(moduleLink);
      breadcrumb.appendChild(moduleItem);

      var currentItem = document.createElement('li');
      currentItem.className = 'breadcrumb-item active breadcrumb-item--inventory-current';
      var currentSpan = document.createElement('span');
      currentSpan.textContent = currentLabel;
      currentItem.appendChild(currentSpan);
      breadcrumb.appendChild(currentItem);
    }

    function getDirectContainerFluid(headerToolbar) {
      if (!headerToolbar) {
        return null;
      }

      var children = headerToolbar.children || [];
      for (var i = 0; i < children.length; i++) {
        if (children[i].classList && children[i].classList.contains('container-fluid')) {
          return children[i];
        }
      }

      return headerToolbar.querySelector('.container-fluid');
    }

    function mountBoTabs(sourceId, attempt) {
      var source = document.getElementById(sourceId);
      if (!source) {
        return true;
      }

      var pageHead = document.querySelector('.page-head');
      var pageHeadWrapper = pageHead ? pageHead.querySelector('.wrapper.clearfix') : null;
      if (!pageHead) {
        if ((attempt || 0) < 100) {
          window.setTimeout(function () {
            mountBoTabs(sourceId, (attempt || 0) + 1);
          }, 100);
          return false;
        }

        source.hidden = false;
        return false;
      }

      var mounted = document.getElementById('head_tabs');
      if (mounted && mounted !== source && mounted.parentNode) {
        mounted.parentNode.removeChild(mounted);
      }

      if (pageHeadWrapper) {
        if (source.parentNode !== pageHead || source.previousElementSibling !== pageHeadWrapper) {
          pageHeadWrapper.insertAdjacentElement('afterend', source);
        }
      } else if (source.parentNode !== pageHead) {
        pageHead.appendChild(source);
      }

      var contentDiv = document.querySelector('#main-div > .content-div');
      if (contentDiv) {
        contentDiv.classList.add('with-tabs');
      }

      syncBreadcrumb('Ustawienia');

      source.hidden = false;
      return true;
    }

    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', function () {
        mountBoTabs('psinventory-config-head-tabs-source', 0);
      });
    } else {
      mountBoTabs('psinventory-config-head-tabs-source', 0);
    }

    window.addEventListener('load', function () {
      mountBoTabs('psinventory-config-head-tabs-source', 0);
    });

    var mountObserver = new MutationObserver(function () {
      mountBoTabs('psinventory-config-head-tabs-source', 0);
    });
    mountObserver.observe(document.documentElement, {ldelim}childList: true, subtree: true{rdelim});
    window.setTimeout(function () {
      mountObserver.disconnect();
    }, 10000);
  })();
</script>
{/if}
