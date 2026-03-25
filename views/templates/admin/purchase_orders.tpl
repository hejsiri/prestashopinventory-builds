<div class="inventory-module-content">
<div id="psinventory-purchase-orders-head-tabs-source" class="page-head-tabs inventory-panel-tabs" role="tablist" aria-label="{$inventoryTranslations.module_navigation|escape:'html':'UTF-8'}">
  <ul class="nav nav-pills">
    <li class="nav-item">
      <a href="{$inventoryModuleUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$inventoryTranslations.products_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$inventorySuppliersUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$inventoryTranslations.suppliers_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$inventoryPurchaseOrdersUrl|escape:'html':'UTF-8'}" class="router-link-active router-link-exact-active nav-link active" aria-current="page" role="tab">{$inventoryTranslations.purchase_orders_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$inventoryConfigUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$inventoryTranslations.settings_tab|escape:'html':'UTF-8'}</a>
    </li>
  </ul>
</div>

<div class="panel prestashopinventory-placeholder-panel">
  <h3 class="prestashopinventory-placeholder-title">{$inventoryPlaceholderTitle|escape:'html':'UTF-8'}</h3>
  <p class="prestashopinventory-placeholder-copy">{$inventoryPlaceholderDescription|escape:'html':'UTF-8'}</p>
  <div class="alert alert-info mb-0">{$inventoryPlaceholderNotice|escape:'html':'UTF-8'}</div>
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

  .prestashopinventory-placeholder-title {
    margin: 0 0 10px;
    font-size: 22px;
    font-weight: 700;
    color: #243746;
  }

  .prestashopinventory-placeholder-copy {
    margin: 0 0 18px;
    color: #5f7484;
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
        mountBoTabs('psinventory-purchase-orders-head-tabs-source', 0);
      });
    } else {
      mountBoTabs('psinventory-purchase-orders-head-tabs-source', 0);
    }

    window.addEventListener('load', function () {
      mountBoTabs('psinventory-purchase-orders-head-tabs-source', 0);
    });
  })();
</script>
