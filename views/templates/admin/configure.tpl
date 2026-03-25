<div class="inventory-module-content">
<div id="psinventory-config-head-tabs-source" class="page-head-tabs inventory-panel-tabs" role="tablist" aria-label="{$prestashopInventoryTranslations.module_navigation|escape:'html':'UTF-8'}">
  <ul class="nav nav-pills">
    <li class="nav-item">
      <a href="{$prestashopInventoryBackUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$prestashopInventoryTranslations.warehouse_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$prestashopInventoryConfigAction|escape:'html':'UTF-8'}" class="router-link-active router-link-exact-active nav-link active" aria-current="page" role="tab">{$prestashopInventoryTranslations.settings_tab|escape:'html':'UTF-8'}</a>
    </li>
  </ul>
  <div class="inventory-update-meta">
    <div class="inventory-update-meta-version">Wersja {$prestashopInventoryModuleVersion|escape:'html':'UTF-8'}</div>
    <div class="inventory-update-meta-status"></div>
  </div>
</div>
<div class="panel prestashopinventory-config-list">

  {if $prestashopInventoryIgnoredProducts}
    <div class="table-responsive-row clearfix">
      <table class="table">
        <thead>
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
                <span class="config-switch {if $product.active}is-on{/if}">
                  <span class="config-switch-track"></span>
                  <span class="config-switch-thumb"></span>
                </span>
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

<style>
  .inventory-module-content {
    padding-top: 60px;
    clear: both;
    position: relative;
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
    flex: 0 0 auto;
    flex-direction: column;
    align-items: flex-end;
    justify-content: center;
    gap: 2px;
    min-height: 56px;
    margin: 0 18px 0 0;
    text-align: right;
  }

  .page-head > .inventory-panel-tabs .inventory-update-meta-version {
    font-size: 11px;
    font-weight: 700;
    color: #5f7484;
    line-height: 1.2;
    white-space: nowrap;
  }

  .page-head > .inventory-panel-tabs .inventory-update-meta-status {
    font-size: 11px;
    font-weight: 600;
    color: #7a8f9d;
    line-height: 1.2;
    min-height: 12px;
    white-space: nowrap;
  }

  .prestashopinventory-config-list.panel {
    border: 1px solid #dce7ef;
    border-radius: 0 20px 20px 20px;
    box-shadow: 0 14px 28px rgba(31, 52, 66, 0.10);
    padding: 20px 28px 24px;
    position: relative;
    z-index: 2;
    margin-bottom: 0;
    margin-top: 0 !important;
    background: #fff;
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

  .prestashopinventory-config-list .config-switch {
    position: relative;
    display: inline-block;
    width: 28px;
    height: 16px;
  }

  .prestashopinventory-config-list .config-switch-track {
    position: absolute;
    inset: 0;
    border-radius: 999px;
    background: #d3d3d3;
  }

  .prestashopinventory-config-list .config-switch-thumb {
    position: absolute;
    top: 2px;
    left: 2px;
    width: 12px;
    height: 12px;
    background: #fff;
    border-radius: 50%;
    transition: transform .2s ease;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.18);
  }

  .prestashopinventory-config-list .config-switch.is-on .config-switch-track {
    background: #4f955d;
  }

  .prestashopinventory-config-list .config-switch.is-on .config-switch-thumb {
    transform: translateX(12px);
  }
</style>

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
