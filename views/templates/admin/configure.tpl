<div id="psinventory-config-head-tabs-source" class="page-head-tabs" role="tablist" aria-label="{$prestashopInventoryTranslations.module_navigation|escape:'html':'UTF-8'}">
  <ul class="nav nav-pills">
    <li class="nav-item">
      <a href="{$prestashopInventoryBackUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$prestashopInventoryTranslations.warehouse_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$prestashopInventoryConfigAction|escape:'html':'UTF-8'}" class="nav-link active" aria-current="page" role="tab">{$prestashopInventoryTranslations.settings_tab|escape:'html':'UTF-8'}</a>
    </li>
  </ul>
</div>

<div class="inventory-module-content">
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
    margin-top: 16px;
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

      var headerToolbar = document.querySelector('.header-toolbar.d-print-none, body > .header-toolbar, #main-div > .header-toolbar, .content-div > .header-toolbar, .header-toolbar');
      var headerContainer = getDirectContainerFluid(headerToolbar);
      if (!headerToolbar || !headerContainer) {
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
      if (!mounted) {
        mounted = source.cloneNode(true);
        mounted.id = 'head_tabs';
        mounted.hidden = false;
      }

      if (mounted.parentNode !== headerToolbar || mounted.previousElementSibling !== headerContainer) {
        headerContainer.insertAdjacentElement('afterend', mounted);
      }

      var contentDiv = document.querySelector('#main-div > .content-div');
      if (contentDiv) {
        contentDiv.classList.add('with-tabs');
      }

      source.hidden = true;
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
