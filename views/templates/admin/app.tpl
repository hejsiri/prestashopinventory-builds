<div class="inventory-module-content{if !empty($inventoryEmbeddedInModernLayout)} inventory-module-content--embedded{/if}">
{if empty($inventoryEmbeddedInModernLayout)}
<div id="psinventory-head-tabs-source" class="page-head-tabs inventory-panel-tabs" role="tablist" aria-label="{$inventoryTranslations.module_navigation|escape:'html':'UTF-8'}">
  <ul class="nav nav-pills">
    <li class="nav-item">
      <a href="{$inventoryModuleUrl|escape:'html':'UTF-8'}" class="router-link-active router-link-exact-active nav-link active" aria-current="page" role="tab">{$inventoryTranslations.products_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$inventorySuppliersUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$inventoryTranslations.suppliers_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$inventoryPurchaseOrdersUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$inventoryTranslations.purchase_orders_tab|escape:'html':'UTF-8'}</a>
    </li>
    <li class="nav-item">
      <a href="{$inventoryConfigUrl|escape:'html':'UTF-8'}" class="nav-link" role="tab">{$inventoryTranslations.settings_tab|escape:'html':'UTF-8'}</a>
    </li>
  </ul>
  <div class="inventory-update-meta">
    <div id="inventoryUpdateMetaStatus" class="inventory-update-meta-status"></div>
  </div>
</div>
{/if}
<div class="card js-grid-panel prestashop-inventory">
  <div class="card-header js-grid-header">
    <h3 class="d-inline-block card-header-title">{$inventoryTranslations.products_tab|escape:'html':'UTF-8'}</h3>
  </div>
  <div class="card-body">
  <div id="inventoryUpdateStatus" class="inventory-update-status" aria-live="polite"></div>

  {if !$inventoryLicenseStatus.valid}
    <div class="alert alert-danger inventory-license-alert" role="alert">
      <strong>{$inventoryTranslations.license_required_title|escape:'html':'UTF-8'}:</strong>
      <span>{$inventoryLicenseStatus.message|escape:'html':'UTF-8'}</span>
    </div>
  {/if}

  {if $inventoryLicenseStatus.valid}
  <div class="inventory-topbar">
    <div class="inventory-search">
      <div class="inventory-search-wrap">
        <div id="searchBox" class="inventory-tagbox">
          <div id="searchTags" class="inventory-tags"></div>
          <input type="text" id="searchInput" class="inventory-tag-input" autocomplete="off">
        </div>
        <button id="clearSearch" type="button" class="inventory-clear" aria-label="{$inventoryTranslations.clear|escape:'html':'UTF-8'}">&times;</button>
      </div>
    </div>

    <div class="inventory-toolbar">
      <div class="inventory-actions">
        <div class="inventory-actions-menu inventory-filters-menu">
          <button class="btn btn-outline-secondary inventory-toolbar-btn inventory-actions-toggle inventory-filter-toggle" type="button" aria-haspopup="true" aria-expanded="false" aria-label="{$inventoryTranslations.filters|escape:'html':'UTF-8'}">
            <i class="icon-tasks"></i>
            <span class="inventory-filter-toggle-label">{$inventoryTranslations.filters|escape:'html':'UTF-8'}</span>
            <span id="filterActiveCount" class="inventory-filter-badge">0</span>
          </button>
          <div class="inventory-actions-dropdown inventory-filter-dropdown">
            <label class="inventory-switch-row inventory-filter-row">
              <span class="ios-switch">
                <input type="checkbox" id="activeOnly">
                <span class="slider"></span>
              </span>
              <span id="activeOnlyLabel"></span>
            </label>

            <label class="inventory-switch-row inventory-filter-row">
              <span class="ios-switch">
                <input type="checkbox" id="onlyAvailable">
                <span class="slider"></span>
              </span>
              <span id="onlyAvailableLabel"></span>
            </label>

            <label class="inventory-switch-row inventory-filter-row">
              <span class="ios-switch">
                <input type="checkbox" id="missingPurchasePriceOnly">
                <span class="slider"></span>
              </span>
              <span id="missingPurchasePriceOnlyLabel"></span>
            </label>

            <label class="inventory-switch-row inventory-filter-row">
              <span class="ios-switch">
                <input type="checkbox" id="showWeight" checked>
                <span class="slider"></span>
              </span>
              <span id="showWeightLabel"></span>
            </label>

            <label class="inventory-switch-row inventory-filter-row">
              <span class="ios-switch">
                <input type="checkbox" id="missingWeightOnly">
                <span class="slider"></span>
              </span>
              <span id="missingWeightOnlyLabel"></span>
            </label>

            <label class="inventory-switch-row inventory-filter-row">
              <span class="ios-switch">
                <input type="checkbox" id="showBrutto" checked>
                <span class="slider"></span>
              </span>
              <span id="showBruttoLabel"></span>
            </label>
          </div>
        </div>

        <button id="btnPdf" class="btn btn-primary inventory-toolbar-btn" type="button">
          <i class="icon-file-pdf-o"></i> PDF
        </button>

        <button id="inventoryUpdateButton" class="btn btn-outline-primary inventory-toolbar-btn inventory-update-btn" type="button" hidden data-version="">
          <span class="inventory-update-btn-icon" aria-hidden="true">
            <svg viewBox="0 0 24 24" focusable="false">
              <path d="M6.5 18.5a4.5 4.5 0 0 1-.4-9 6.5 6.5 0 0 1 12.6 1.6h.8a3.5 3.5 0 1 1 0 7H6.5Z" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
              <path d="M12 9.5v7" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
              <path d="m9.25 13.75 2.75 2.75 2.75-2.75" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
          </span>
          <span class="inventory-update-btn-label"></span>
        </button>
      </div>
    </div>
  </div>

  <div class="table-responsive-row clearfix">
    <table id="productsTable" class="grid-table js-grid-table table">
      <thead class="thead-default">
        <tr>
          <th id="thNo" class="inventory-sortable" data-sort-field="id_product"><div class="ps-sortable-column inventory-sort-button" role="button" tabindex="0"><span role="columnheader" class="inventory-head-title">ID</span><span class="ps-sort inventory-sort-indicator" aria-hidden="true"></span></div></th>
          <th id="thPicture">{$inventoryTranslations.image|escape:'html':'UTF-8'}</th>
          <th id="thName" class="inventory-sortable" data-sort-field="product_name"><div class="ps-sortable-column inventory-sort-button" role="button" tabindex="0"><span role="columnheader"><span class="inventory-head-title">{$inventoryTranslations.product_name|escape:'html':'UTF-8'}</span><span class="inventory-head-subtitle">{$inventoryTranslations.ean13|escape:'html':'UTF-8'}</span></span><span class="ps-sort inventory-sort-indicator" aria-hidden="true"></span></div></th>
          <th id="thActive" class="text-center inventory-sortable" data-sort-field="active"><div class="ps-sortable-column inventory-sort-button inventory-sort-button-center" role="button" tabindex="0"><span role="columnheader" class="inventory-head-title">{$inventoryTranslations.active|escape:'html':'UTF-8'}</span><span class="ps-sort inventory-sort-indicator" aria-hidden="true"></span></div></th>
          <th id="thWeight" class="text-center inventory-sortable" data-sort-field="weight"><div class="ps-sortable-column inventory-sort-button inventory-sort-button-center" role="button" tabindex="0"><span role="columnheader" class="inventory-head-title">{$inventoryTranslations.product_weight|escape:'html':'UTF-8'}</span><span class="ps-sort inventory-sort-indicator" aria-hidden="true"></span></div></th>
          <th id="thPrice" class="text-center inventory-sortable" data-sort-field="purchase_price"><div class="ps-sortable-column inventory-sort-button inventory-sort-button-center" role="button" tabindex="0"><span role="columnheader" class="inventory-head-title">{$inventoryTranslations.purchase_price_net|escape:'html':'UTF-8'}</span><span class="ps-sort inventory-sort-indicator" aria-hidden="true"></span></div></th>
          <th id="thPriceBrutto" class="text-center inventory-sortable" data-sort-field="retail_price"><div class="ps-sortable-column inventory-sort-button inventory-sort-button-center" role="button" tabindex="0"><span role="columnheader" class="inventory-head-title">{$inventoryTranslations.retail_price_gross|escape:'html':'UTF-8'}</span><span class="ps-sort inventory-sort-indicator" aria-hidden="true"></span></div></th>
          <th id="thQty" class="text-center inventory-sortable" data-sort-field="quantity"><div class="ps-sortable-column inventory-sort-button inventory-sort-button-center" role="button" tabindex="0"><span role="columnheader" class="inventory-head-title">{$inventoryTranslations.available_quantity|escape:'html':'UTF-8'}</span><span class="ps-sort inventory-sort-indicator" aria-hidden="true"></span></div></th>
          <th id="thValue" class="text-center">{$inventoryTranslations.purchase_value_net|escape:'html':'UTF-8'}</th>
          <th id="thValueBrutto" class="text-center">{$inventoryTranslations.retail_value_gross|escape:'html':'UTF-8'}</th>
          <th id="thActions" class="text-center">{$inventoryTranslations.actions|escape:'html':'UTF-8'}</th>
        </tr>
      </thead>
      <tbody></tbody>
    </table>
  </div>

  <div id="inventoryPagination" class="inventory-pagination"></div>
  {/if}
  </div>
</div>

<div id="inventoryProfitModal" class="inventory-sales-modal inventory-profit-modal" aria-hidden="true">
  <div class="inventory-sales-modal-backdrop"></div>
  <div class="inventory-sales-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="inventoryProfitModalTitle">
    <button type="button" class="inventory-sales-modal-close inventory-profit-modal-close" aria-label="Close"></button>
    <div class="inventory-sales-modal-head">
      <div class="inventory-sales-modal-media">
        <div class="inventory-sales-modal-thumb-wrap">
          <img id="inventoryProfitModalImage" class="inventory-sales-modal-thumb" src="" alt="">
          <div id="inventoryProfitModalImageFallback" class="inventory-sales-modal-thumb-fallback"></div>
        </div>
        <div class="inventory-sales-modal-copy">
          <div id="inventoryProfitModalTitle" class="inventory-sales-modal-title"></div>
          <div id="inventoryProfitModalSubtitle" class="inventory-sales-modal-subtitle"></div>
        </div>
      </div>
    </div>
    <div id="inventoryProfitModalContent" class="inventory-sales-modal-content"></div>
  </div>
</div>
</div>

<div id="inventorySalesModal" class="inventory-sales-modal" aria-hidden="true">
  <div class="inventory-sales-modal-backdrop"></div>
  <div class="inventory-sales-modal-dialog" role="dialog" aria-modal="true" aria-labelledby="inventorySalesModalTitle">
    <button type="button" class="inventory-sales-modal-close" aria-label="Close"></button>
    <div class="inventory-sales-modal-head">
      <div class="inventory-sales-modal-media">
        <div class="inventory-sales-modal-thumb-wrap">
          <img id="inventorySalesModalImage" class="inventory-sales-modal-thumb" src="" alt="">
          <div id="inventorySalesModalImageFallback" class="inventory-sales-modal-thumb-fallback"></div>
        </div>
        <div class="inventory-sales-modal-copy">
          <div id="inventorySalesModalTitle" class="inventory-sales-modal-title"></div>
          <div id="inventorySalesModalSubtitle" class="inventory-sales-modal-subtitle"></div>
        </div>
      </div>
    </div>
    <div id="inventorySalesModalState" class="inventory-sales-modal-state"></div>
    <div id="inventorySalesModalContent" class="inventory-sales-modal-content"></div>
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

  .prestashop-inventory.card {
    margin-bottom: 0;
    margin-top: 0 !important;
  }

  .prestashop-inventory .card-header {
    padding: 1rem 1.25rem;
  }

  .prestashop-inventory .card-body {
    padding: 20px 28px 24px;
  }

  .prestashop-inventory .inventory-topbar {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 20px 24px;
    margin-bottom: 22px;
    padding-bottom: 18px;
    border-bottom: 1px solid #edf3f7;
  }

  .prestashop-inventory .inventory-toolbar {
    display: flex;
    justify-content: flex-end;
    gap: 16px;
    align-items: center;
    flex-wrap: wrap;
    margin: 0 0 0 auto;
    flex: 0 0 auto;
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

  .page-head > .inventory-panel-tabs .inventory-update-meta-status.is-error {
    color: #c05c67;
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

  .prestashop-inventory .inventory-actions {
    display: flex;
    gap: 16px;
    align-items: center;
    flex-wrap: wrap;
  }

  .prestashop-inventory .inventory-search {
    margin: 0;
    flex: 1 1 620px;
    min-width: 280px;
  }

  .prestashop-inventory .inventory-marketplace-settings {
    margin-bottom: 20px;
    padding: 14px 16px;
    border: 1px solid #dbe6ed;
    border-radius: 14px;
    background: linear-gradient(180deg, #fdfefe 0%, #f5f9fc 100%);
  }

  .prestashop-inventory .inventory-marketplace-settings-title {
    margin-bottom: 10px;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: .08em;
    text-transform: uppercase;
    color: #6f8594;
  }

  .prestashop-inventory .inventory-marketplace-settings-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, max-content));
    gap: 12px;
  }

  .prestashop-inventory .inventory-marketplace-setting {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    min-width: 0;
    padding: 10px 12px;
    border-radius: 12px;
    background: #fff;
    border: 1px solid #e2ecf2;
  }

  .prestashop-inventory .inventory-marketplace-setting-label {
    font-size: 12px;
    color: #6f8594;
    white-space: nowrap;
  }

  .prestashop-inventory .inventory-marketplace-setting-value {
    display: inline-flex;
    align-items: center;
    min-height: 24px;
    font-size: 13px;
    font-weight: 700;
    color: #1f3442;
    cursor: pointer;
    text-decoration: underline dotted;
    text-underline-offset: 3px;
    white-space: nowrap;
  }

  .prestashop-inventory .inventory-toolbar-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    height: 42px;
    min-height: 42px;
    padding: 0 16px !important;
    border-radius: 8px !important;
    font-size: 14px !important;
    font-weight: 700 !important;
    line-height: 1 !important;
    white-space: nowrap;
  }

  .prestashop-inventory .inventory-toolbar-btn:hover,
  .prestashop-inventory .inventory-toolbar-btn:focus {
    text-decoration: none;
  }

  .prestashop-inventory .inventory-toolbar-btn i {
    font-size: 15px;
    line-height: 1;
  }

  .prestashop-inventory #btnPdf {
    min-width: 122px;
  }

  .prestashop-inventory .inventory-update-btn[hidden] {
    display: none !important;
  }

  .prestashop-inventory .inventory-update-status {
    display: none !important;
  }

  .prestashop-inventory .inventory-update-status.is-error {
    color: #c05c67;
  }

  .prestashop-inventory .inventory-license-alert {
    margin-bottom: 18px;
    border-radius: 12px;
  }

  .prestashop-inventory .inventory-search-wrap {
    max-width: none;
    width: 100%;
    position: relative;
  }

  .prestashop-inventory .inventory-tagbox {
    min-height: 42px;
    height: 42px;
    padding: 0 40px 0 10px;
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 6px;
    cursor: text;
    border: 1px solid #ccd9e2;
    border-radius: 10px;
    background: #fff;
    box-shadow: none;
  }

  .prestashop-inventory .inventory-tagbox:focus-within {
    border-color: #25b9d7;
    box-shadow: 0 0 0 1px rgba(37, 185, 215, 0.2);
  }

  .prestashop-inventory .inventory-tags {
    display: flex;
    align-items: center;
    flex-wrap: wrap;
    gap: 6px;
  }

  .prestashop-inventory .inventory-tag {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    min-height: 32px;
    padding: 3px 11px;
    background: linear-gradient(135deg, #25b9d7 0%, #31c0e3 100%);
    color: #fff;
    border-radius: 8px;
    font-weight: 600;
    font-size: 13px;
    line-height: 1;
    box-shadow: none;
  }

  .prestashop-inventory .inventory-tag-remove {
    border: 0;
    background: transparent;
    padding: 0;
    line-height: 1;
    font-size: 18px;
    color: rgba(255, 255, 255, 0.96);
  }

  .prestashop-inventory .inventory-tag-input {
    flex: 1 1 140px;
    min-width: 120px;
    border: 0 !important;
    outline: none !important;
    box-shadow: none !important;
    -webkit-box-shadow: none !important;
    height: 40px;
    padding: 0;
    margin: 0;
    background: transparent !important;
    appearance: none;
    -webkit-appearance: none;
    border-radius: 0;
  }

  .prestashop-inventory .inventory-tag-input:focus,
  .prestashop-inventory .inventory-tag-input:hover,
  .prestashop-inventory .inventory-tag-input:active {
    border: 0 !important;
    outline: none !important;
    box-shadow: none !important;
    -webkit-box-shadow: none !important;
    background: transparent !important;
  }

  .prestashop-inventory .inventory-clear {
    position: absolute;
    top: 50%;
    right: 12px;
    transform: translateY(-50%);
    border: 0;
    background: transparent;
    color: #888;
    font-size: 22px;
    line-height: 1;
    padding: 0;
  }

  .prestashop-inventory .ios-switch {
    position: relative;
    display: inline-block;
    width: 28px;
    height: 16px;
  }

  .prestashop-inventory .ios-switch input {
    opacity: 0;
    width: 0;
    height: 0;
  }

  .prestashop-inventory .slider {
    position: absolute;
    inset: 0;
    cursor: pointer;
    background-color: #ccc;
    border-radius: 25px;
    transition: .4s;
  }

  .prestashop-inventory .slider:before {
    content: "";
    position: absolute;
    width: 12px;
    height: 12px;
    top: 2px;
    left: 2px;
    background: #fff;
    border-radius: 50%;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.18);
    transition: .2s ease;
  }

  .prestashop-inventory input:checked + .slider {
    background: #4f955d;
  }

  .prestashop-inventory input:checked + .slider:before {
    transform: translateX(12px);
  }

  .prestashop-inventory .inventory-switch-row {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    margin: 0;
    font-weight: 400;
  }

  .prestashop-inventory .inventory-filters-menu {
    position: relative;
  }

  .prestashop-inventory .inventory-filter-toggle {
    position: relative;
  }

  .prestashop-inventory .table-responsive-row {
    overflow-x: auto;
  }

  .prestashop-inventory .inventory-filter-badge {
    position: absolute;
    top: -6px;
    right: -6px;
    min-width: 18px;
    height: 18px;
    padding: 0 4px;
    border-radius: 999px;
    background: #d93025;
    color: #fff;
    font-size: 11px;
    font-weight: 700;
    line-height: 18px;
    text-align: center;
  }

  .prestashop-inventory .inventory-filter-badge.is-hidden {
    display: none;
  }

  .prestashop-inventory .inventory-filter-dropdown {
    width: max-content;
    min-width: 0;
    max-width: calc(100vw - 32px);
    padding: 8px 0;
  }

  .prestashop-inventory .inventory-filter-row {
    display: flex;
    width: 100%;
    padding: 10px 16px;
    gap: 12px;
    cursor: pointer;
  }

  .prestashop-inventory .inventory-filter-row > span:last-child {
    flex: 1 1 auto;
    line-height: 1.3;
    white-space: nowrap;
  }

  .prestashop-inventory .inventory-filter-row:hover {
    background: #f5f7fa;
  }

  .prestashop-inventory img.img-thumbnail {
    width: 45px;
    height: 45px;
    object-fit: cover;
    border: 1px solid #ddd;
    border-radius: 8px;
    background: #fff;
    padding: 2px;
  }

  .prestashop-inventory .product-preview {
    position: relative;
    display: inline-flex;
    align-items: center;
    outline: none;
    z-index: 1;
  }

  .prestashop-inventory .product-preview-card {
    position: absolute;
    left: calc(100% + 12px);
    top: 50%;
    z-index: 2100;
    display: none;
    min-width: 260px;
    padding: 14px 16px;
    background-color: #fff;
    color: #111;
    border-radius: 14px;
    box-shadow: 0 12px 28px rgba(0, 0, 0, 0.18), 0 4px 10px rgba(0, 0, 0, 0.12);
    transform: translateY(-50%);
    white-space: normal;
  }

  .prestashop-inventory .product-preview:hover .product-preview-card,
  .prestashop-inventory .product-preview:focus .product-preview-card,
  .prestashop-inventory .product-preview:focus-within .product-preview-card {
    display: block;
  }

  .prestashop-inventory .product-preview:hover,
  .prestashop-inventory .product-preview:focus,
  .prestashop-inventory .product-preview:focus-within {
    z-index: 2101;
  }

  .prestashop-inventory .product-preview-title,
  .prestashop-inventory .product-preview-subtitle {
    display: block;
    line-height: 1.35;
  }

  .prestashop-inventory .product-preview-title {
    font-weight: 600;
  }

  .prestashop-inventory .product-preview-subtitle {
    margin-top: 4px;
    color: #666;
  }

  .prestashop-inventory .product-preview-image {
    display: block;
    width: 240px;
    max-width: min(240px, 70vw);
    height: auto;
    border-radius: 10px;
    margin-top: 10px;
  }

  .prestashop-inventory #productsTable {
    margin-bottom: 0;
    background: #fff;
  }

  .prestashop-inventory .inventory-pagination {
    margin-top: 18px;
    overflow-x: auto;
    overflow-y: hidden;
    padding-bottom: 4px;
  }

  .prestashop-inventory .inventory-pagination-inner {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 16px;
    flex-wrap: nowrap;
    min-width: max-content;
  }

  .prestashop-inventory .inventory-pagination-pages {
    display: flex;
    align-items: center;
    flex: 0 0 auto;
  }

  .prestashop-inventory .inventory-pagination-pages .pagination {
    display: flex;
    align-items: center;
    margin: 0;
    gap: 0;
  }

  .prestashop-inventory .inventory-pagination-pages .page-item {
    display: flex;
    align-items: center;
  }

  .prestashop-inventory .inventory-pagination-pages .page-item.current,
  .prestashop-inventory .inventory-pagination-pages .page-item.current.active {
    flex: 0 0 auto;
    width: auto;
    background: transparent;
    border: 0;
  }

  .prestashop-inventory .inventory-pagination-pages .page-item.current label {
    margin: 0;
    display: block;
    width: 48px !important;
    min-width: 48px !important;
    max-width: 48px !important;
    flex: 0 0 48px !important;
  }

  .prestashop-inventory .inventory-pagination-pages .page-item.current .jump-to-page,
  .prestashop-inventory .inventory-page-current {
    width: 48px !important;
    min-width: 48px !important;
    max-width: 48px !important;
    flex: 0 0 48px !important;
    height: 50px;
    border: 1px solid #d7d7d7;
    background: #fff;
    font-weight: 700;
    font-size: 16px;
    line-height: 1;
    padding: 0 4px;
    text-align: center;
    box-shadow: none;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    border-radius: 0;
  }

  .prestashop-inventory .inventory-pagination-pages .page-link.previous,
  .prestashop-inventory .inventory-pagination-pages .page-link.next {
    min-width: 28px;
    height: 28px;
    padding: 0;
    border: 0;
    background: transparent;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 34px;
    font-weight: 300;
    line-height: 1;
    color: #7a7a7a;
  }

  .prestashop-inventory .inventory-pagination-pages .page-link.previous span[aria-hidden="true"],
  .prestashop-inventory .inventory-pagination-pages .page-link.next span[aria-hidden="true"] {
    display: inline-block;
    transform: translateY(-1px);
  }

  .prestashop-inventory .inventory-page-current::-webkit-outer-spin-button,
  .prestashop-inventory .inventory-page-current::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }

  .prestashop-inventory .inventory-pagination-pages .page-link {
    box-shadow: none;
  }

  .prestashop-inventory .inventory-pagination-pages .page-item.previous.disabled .page-link,
  .prestashop-inventory .inventory-pagination-pages .page-item.next.disabled .page-link {
    color: #cfcfcf;
    cursor: default;
  }

  .prestashop-inventory .inventory-pagination-status {
    font-size: 16px;
    color: #2b2b2b;
    white-space: nowrap;
    flex: 0 0 auto;
  }

  .prestashop-inventory .inventory-per-page {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    margin: 0;
    font-weight: 400;
    font-size: 16px;
    white-space: nowrap;
    flex: 0 0 auto;
  }

  .prestashop-inventory .inventory-per-page-label {
    white-space: nowrap;
  }

  .prestashop-inventory .inventory-per-page-select {
    min-width: 74px;
    height: 50px;
    padding: 0 28px 0 14px;
    border: 1px solid #d7d7d7;
    border-radius: 0;
    background-color: #fff;
    font-size: 15px;
    box-shadow: none;
  }

  .prestashop-inventory #productsTable thead th {
    white-space: normal;
    vertical-align: middle;
  }

  .prestashop-inventory .inventory-sort-button {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 8px;
    width: 100%;
    padding: 0;
    text-align: left;
    color: inherit;
  }

  .prestashop-inventory .inventory-sort-button-center {
    justify-content: center;
  }

  .prestashop-inventory .inventory-sort-indicator {
    width: 14px;
    min-width: 14px;
    height: 14px;
    position: relative;
    opacity: .72;
    display: inline-block;
  }

  .prestashop-inventory .inventory-sort-indicator:before {
    content: "";
    position: absolute;
    top: 4px;
    left: 3px;
    width: 6px;
    height: 6px;
    border-right: 1px solid #6c868e;
    border-bottom: 1px solid #6c868e;
    transform: rotate(135deg);
  }

  .prestashop-inventory .inventory-sortable.is-active .inventory-sort-indicator {
    opacity: 1;
  }

  .prestashop-inventory .inventory-sortable.sort-asc .inventory-sort-indicator:before {
    top: 2px;
    transform: rotate(-45deg);
  }

  .prestashop-inventory #productsTable tbody td {
    padding: 8px 14px;
    border: 0;
    border-bottom: 1px solid #ececec;
    vertical-align: middle;
    font-size: 13px;
    color: #2b2b2b;
    background: #fff;
    transition: background-color .15s ease;
  }

  .prestashop-inventory #productsTable tbody tr:hover td {
    background: #f4f8fb;
  }

  .prestashop-inventory .inventory-col-id {
    width: 92px;
    font-weight: 400;
  }

  .prestashop-inventory .inventory-col-image {
    width: 86px;
  }

  .prestashop-inventory .inventory-col-name {
    min-width: 360px;
  }

  .prestashop-inventory .inventory-col-price,
  .prestashop-inventory .inventory-col-metric,
  .prestashop-inventory .inventory-col-active,
  .prestashop-inventory .inventory-col-qty,
  .prestashop-inventory .inventory-col-value {
    white-space: nowrap;
    font-variant-numeric: tabular-nums;
  }

  .prestashop-inventory .inventory-col-metric {
    width: 112px;
  }

  .prestashop-inventory .inventory-col-actions {
    width: 88px;
  }

  .prestashop-inventory .inventory-col-active {
    width: 110px;
  }

  .prestashop-inventory .inventory-product-name {
    font-size: 13px;
    font-weight: 500;
    line-height: 1.2;
  }

  .prestashop-inventory .inventory-product-link {
    color: #2b2b2b;
    text-decoration: none;
  }

  .prestashop-inventory .inventory-product-link:hover,
  .prestashop-inventory .inventory-product-link:focus {
    color: #25b9d7;
    text-decoration: none;
    outline: none;
  }

  .prestashop-inventory .inventory-product-meta {
    margin-top: 2px;
    color: #a0a0a0;
    font-size: 11px;
    line-height: 1.15;
  }

  .prestashop-inventory .inventory-product-ean {
    margin-top: 2px;
    color: #6f6f6f;
    font-size: 11px;
    line-height: 1.15;
    font-variant-numeric: tabular-nums;
    border: 0;
    background: transparent;
    padding: 0;
    text-align: left;
    cursor: pointer;
  }

  .prestashop-inventory .inventory-product-ean:hover,
  .prestashop-inventory .inventory-product-ean:focus {
    color: #25b9d7;
    outline: none;
  }

  .prestashop-inventory .inventory-product-ean.is-copied {
    color: #4f955d;
  }

  .prestashop-inventory .inventory-calculated-metric {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-width: 64px;
    color: #264355;
    font-weight: 700;
  }

  .prestashop-inventory .inventory-calculated-metric.is-negative {
    color: #bb4d4d;
  }

  .prestashop-inventory .inventory-no-image {
    color: #777;
  }

  .prestashop-inventory .inline-editor {
    display: inline-flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;
  }

  .prestashop-inventory .inline-editor-input {
    width: 96px !important;
    min-width: 96px;
    text-align: center;
    margin: 0 auto;
  }

  .prestashop-inventory .inline-editor-actions {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    flex-wrap: nowrap;
  }

  .prestashop-inventory .inline-editor-actions .btn {
    min-width: 88px;
    margin: 0;
  }

  .prestashop-inventory .weight-editor .inline-editor-actions {
    gap: 6px;
  }

  .prestashop-inventory .weight-editor .inline-editor-actions .btn {
    min-width: 0;
    padding: 6px 12px;
    line-height: 1.2;
  }

  .prestashop-inventory .weight-editor .save-weight {
    min-width: 38px;
    padding: 6px 10px;
  }

  .prestashop-inventory .save-price,
  .prestashop-inventory .save-retail-price,
  .prestashop-inventory .save-quantity {
    min-width: 38px;
    padding: 6px 10px;
  }

  .prestashop-inventory .inventory-summary-row td {
    background: #fafafa !important;
    font-weight: 700;
  }

  .prestashop-inventory .inventory-head-title,
  .prestashop-inventory .inventory-head-subtitle {
    display: block;
  }

  .prestashop-inventory .inventory-head-subtitle {
    margin-top: 2px;
  }

  .prestashop-inventory .inventory-col-active .ps-switch {
    display: inline-block;
  }

  .prestashop-inventory .inventory-actions-menu {
    position: relative;
    display: inline-flex;
    justify-content: center;
  }

  .prestashop-inventory .inventory-actions-toggle {
    position: relative;
  }

  .prestashop-inventory .inventory-filter-toggle {
    min-width: 132px;
    border: 1px solid #c9d2db !important;
    background: #f5f7fa !important;
    color: #51606d !important;
    box-shadow: none !important;
    transition: background .18s ease, border-color .18s ease, color .18s ease !important;
  }

  .prestashop-inventory .inventory-filter-toggle:hover,
  .prestashop-inventory .inventory-filter-toggle:focus {
    background: #eef2f6 !important;
    border-color: #bbc7d1 !important;
    color: #3f4d59 !important;
    box-shadow: none !important;
  }

  .prestashop-inventory .inventory-filter-toggle i {
    font-size: 15px !important;
    line-height: 1;
  }

  .prestashop-inventory .inventory-filter-toggle-label {
    display: inline-block;
    font-size: 14px !important;
    line-height: 1;
  }

  .prestashop-inventory .inventory-update-btn {
    min-width: 154px;
    border: 1px solid #d94b56 !important;
    background: #e74c5b !important;
    color: #fff !important;
    box-shadow: none !important;
  }

  .prestashop-inventory .inventory-update-btn:hover,
  .prestashop-inventory .inventory-update-btn:focus {
    background: #d83c4c !important;
    border-color: #ca3242 !important;
    color: #fff !important;
    box-shadow: none !important;
  }

  .prestashop-inventory .inventory-update-btn i,
  .prestashop-inventory .inventory-update-btn-label {
    color: inherit !important;
  }

  .prestashop-inventory .inventory-update-btn-icon {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 18px;
    height: 18px;
    color: inherit !important;
    flex: 0 0 18px;
  }

  .prestashop-inventory .inventory-update-btn-icon svg {
    display: block;
    width: 18px;
    height: 18px;
  }

  .prestashop-inventory .inventory-actions-dropdown {
    position: absolute;
    top: calc(100% + 8px);
    right: 0;
    z-index: 30;
    min-width: 220px;
    padding: 8px 0;
    border: 1px solid #e3e3e3;
    background: #fff;
    box-shadow: 0 8px 18px rgba(0, 0, 0, 0.12);
    display: none;
    text-align: left;
  }

  .prestashop-inventory .inventory-actions-menu.is-open .inventory-actions-dropdown {
    display: block;
  }

  .prestashop-inventory .inventory-actions-dropdown button {
    width: 100%;
    padding: 12px 16px;
    border: 0;
    background: transparent;
    display: flex;
    align-items: center;
    gap: 12px;
    font-size: 15px;
    color: #222;
    text-align: left;
  }

  .prestashop-inventory .inventory-actions-dropdown button:hover {
    background: #f5f7fa;
  }

  .prestashop-inventory .inventory-actions-dropdown i {
    width: 18px;
    color: #8a8a8a;
    text-align: center;
  }

  .prestashop-inventory .inventory-row-actions {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 4px;
  }

  .prestashop-inventory .inventory-sales-trigger {
    width: 34px;
    height: 34px;
    border: 1px solid #d7e0ea;
    border-radius: 10px;
    background: linear-gradient(180deg, #ffffff 0%, #f5f8fb 100%);
    color: #0f6b8a;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0;
    box-shadow: none;
    transition: transform .18s ease, border-color .18s ease;
  }

  .prestashop-inventory .inventory-sales-trigger:hover,
  .prestashop-inventory .inventory-sales-trigger:focus {
    border-color: #9bc8d8;
    box-shadow: none;
    transform: translateY(-1px);
    text-decoration: none;
  }

  .prestashop-inventory .inventory-sales-trigger i {
    font-size: 15px;
    line-height: 1;
  }

  .prestashop-inventory .inventory-profit-trigger {
    width: 34px;
    height: 34px;
    border: 1px solid #d7e0ea;
    border-radius: 10px;
    background: linear-gradient(180deg, #ffffff 0%, #f5f8fb 100%);
    color: #0f6b8a;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0;
    box-shadow: none;
    transition: transform .18s ease, border-color .18s ease;
    font-size: 16px;
    font-weight: 800;
    line-height: 1;
  }

  .prestashop-inventory .inventory-profit-trigger:hover,
  .prestashop-inventory .inventory-profit-trigger:focus {
    border-color: #9bc8d8;
    box-shadow: none;
    transform: translateY(-1px);
    text-decoration: none;
  }

  .prestashop-inventory .inventory-hide-product-icon {
    width: 34px;
    height: 34px;
    border: 1px solid #ead9d9;
    border-radius: 10px;
    background: linear-gradient(180deg, #ffffff 0%, #fbf5f5 100%);
    color: #a35656;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    padding: 0;
    box-shadow: none;
    transition: transform .18s ease, border-color .18s ease;
  }

  .prestashop-inventory .inventory-hide-product-icon:hover,
  .prestashop-inventory .inventory-hide-product-icon:focus {
    border-color: #d8a3a3;
    box-shadow: none;
    transform: translateY(-1px);
    text-decoration: none;
  }

  .prestashop-inventory .inventory-hide-product-icon i {
    font-size: 15px;
    line-height: 1;
  }

  .inventory-profit-modal .inventory-marketplace-settings {
    margin-bottom: 14px;
    padding: 14px 16px;
    border: 1px solid #dbe6ed;
    border-radius: 14px;
    background: linear-gradient(180deg, #fdfefe 0%, #f5f9fc 100%);
  }

  .inventory-profit-modal .inventory-marketplace-settings-title {
    margin-bottom: 10px;
    font-size: 12px;
    font-weight: 700;
    letter-spacing: .08em;
    text-transform: uppercase;
    color: #6f8594;
  }

  .inventory-profit-modal .inventory-marketplace-settings-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 12px;
  }

  .inventory-profit-modal .inventory-marketplace-setting {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    gap: 10px;
    min-width: 0;
    padding: 10px 12px;
    border-radius: 12px;
    background: #fff;
    border: 1px solid #e2ecf2;
  }

  .inventory-profit-modal .inventory-marketplace-setting-label {
    font-size: 12px;
    color: #6f8594;
    white-space: nowrap;
  }

  .inventory-profit-modal .inventory-marketplace-setting-copy {
    display: grid;
    gap: 4px;
    min-width: 0;
  }

  .inventory-profit-modal .inventory-marketplace-setting-description {
    font-size: 11px;
    line-height: 1.45;
    color: #8ba0af;
    max-width: 360px;
  }

  .inventory-profit-modal .inventory-marketplace-setting-value {
    display: inline-flex;
    align-items: center;
    min-height: 24px;
    font-size: 13px;
    font-weight: 700;
    color: #1f3442;
    cursor: pointer;
    text-decoration: underline dotted;
    text-underline-offset: 3px;
    white-space: nowrap;
  }

  .inventory-profit-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 14px;
  }

  .inventory-profit-card {
    border: 1px solid rgba(208, 222, 234, 0.95);
    border-radius: 22px;
    padding: 16px;
    background: linear-gradient(180deg, #ffffff 0%, #f8fbfd 100%);
    box-shadow: 0 10px 24px rgba(17, 33, 45, 0.05);
  }

  .inventory-profit-card-label {
    display: inline-flex;
    align-items: center;
    min-height: 30px;
    padding: 0 11px;
    border-radius: 10px;
    font-size: 13px;
    font-weight: 800;
    color: #f5fbff;
    margin-bottom: 12px;
  }

  .inventory-profit-card.is-store .inventory-profit-card-label {
    background: linear-gradient(135deg, #1f8eaf 0%, #42bfdc 100%);
  }

  .inventory-profit-card.is-marketplace .inventory-profit-card-label {
    background: linear-gradient(135deg, #2f9666 0%, #3eb77d 100%);
  }

  .inventory-profit-price {
    margin-bottom: 12px;
    font-size: 24px;
    font-weight: 800;
    color: #20303b;
  }

  .inventory-profit-lines {
    display: grid;
    gap: 6px;
  }

  .inventory-profit-line {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    gap: 12px;
    padding-top: 6px;
    border-top: 1px solid rgba(208, 222, 234, 0.7);
    color: #5d7687;
    font-size: 13px;
  }

  .inventory-profit-line strong {
    color: #12232f;
    font-weight: 800;
  }

  .inventory-profit-line strong.inventory-profit-value {
    display: inline-flex;
    align-items: center;
    padding: 4px 10px;
    border-radius: 999px;
  }

  .inventory-profit-line strong.inventory-profit-value.is-positive {
    background: rgba(50, 168, 82, 0.14);
    color: #1f7a39;
  }

  .inventory-profit-line strong.inventory-profit-value.is-negative {
    background: rgba(212, 72, 72, 0.14);
    color: #a52d2d;
  }

  .inventory-profit-line strong.inventory-percent-value.is-negative {
    color: #a52d2d;
  }

  .inventory-sales-modal {
    position: fixed;
    inset: 0;
    z-index: 1050;
    display: none;
  }

  .inventory-sales-modal.is-open {
    display: block;
  }

  .inventory-sales-modal-backdrop {
    position: absolute;
    inset: 0;
    background: rgba(11, 20, 28, 0.58);
    backdrop-filter: blur(6px);
  }

  .inventory-sales-modal-dialog {
    position: relative;
    width: min(1120px, calc(100vw - 40px));
    margin: 34px auto;
    border-radius: 32px;
    background:
      radial-gradient(circle at top left, rgba(29, 141, 177, 0.08), transparent 24%),
      linear-gradient(180deg, #ffffff 0%, #f6f9fc 100%);
    box-shadow: 0 34px 90px rgba(11, 20, 28, 0.24);
    padding: 34px 32px 30px;
    overflow: hidden;
  }

  .inventory-sales-modal-dialog::before {
    content: "";
    position: absolute;
    inset: 0 0 auto 0;
    height: 6px;
    background: linear-gradient(90deg, #1d8db1 0%, #62c2b2 50%, #f2c14e 100%);
  }

  .inventory-sales-modal-close {
    position: absolute;
    top: 18px;
    right: 18px;
    width: 52px;
    height: 52px;
    border: 0;
    border-radius: 999px;
    background: linear-gradient(180deg, rgba(12, 32, 44, 0.05) 0%, rgba(12, 32, 44, 0.09) 100%);
    color: transparent;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 0;
    line-height: 1;
    padding: 0;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.85);
    transition: transform .18s ease, box-shadow .18s ease, background .18s ease;
  }

  .inventory-sales-modal-close::before,
  .inventory-sales-modal-close::after {
    content: "";
    position: absolute;
    width: 22px;
    height: 3px;
    border-radius: 999px;
    background: #60798a;
  }

  .inventory-sales-modal-close::before {
    transform: rotate(45deg);
  }

  .inventory-sales-modal-close::after {
    transform: rotate(-45deg);
  }

  .inventory-sales-modal-close:hover,
  .inventory-sales-modal-close:focus {
    background: linear-gradient(180deg, rgba(12, 32, 44, 0.09) 0%, rgba(12, 32, 44, 0.13) 100%);
    box-shadow: 0 10px 20px rgba(18, 48, 64, 0.12);
    transform: translateY(-1px);
  }

  .inventory-sales-modal-head {
    margin-bottom: 16px;
    padding: 10px 86px 8px 4px;
    border-bottom: 0;
  }

  .inventory-sales-modal-media {
    display: flex;
    align-items: flex-start;
    gap: 18px;
    min-width: 0;
  }

  .inventory-sales-modal-thumb-wrap {
    width: 84px;
    height: 84px;
    flex: 0 0 84px;
    position: relative;
    padding: 6px;
    border-radius: 22px;
    background: #ffffff;
    border: 1px solid rgba(198, 214, 227, 0.9);
    box-shadow: 0 14px 28px rgba(22, 52, 71, 0.08);
  }

  .inventory-sales-modal-thumb,
  .inventory-sales-modal-thumb-fallback {
    width: 100%;
    height: 100%;
    border-radius: 16px;
    display: block;
  }

  .inventory-sales-modal-thumb {
    object-fit: cover;
    background: #eef4f8;
  }

  .inventory-sales-modal-thumb.is-hidden {
    display: none;
  }

  .inventory-sales-modal-thumb-fallback {
    display: none;
    background: linear-gradient(135deg, #173548 0%, #2b6a84 100%);
  }

  .inventory-sales-modal-thumb-fallback.is-visible {
    display: block;
  }

  .inventory-sales-modal-copy {
    min-width: 0;
    padding-top: 4px;
    background: transparent;
  }

  .inventory-sales-modal-title {
    margin: 0;
    max-width: 860px;
    padding: 0 !important;
    font-size: clamp(16px, 1.15vw, 20px);
    line-height: 1.35;
    letter-spacing: -.01em;
    color: #60798a;
    font-weight: 600;
    word-break: break-word;
    text-wrap: pretty;
    text-decoration: none;
    background: transparent;
    border: 0 !important;
    border-bottom: 0 !important;
    box-shadow: none !important;
    outline: 0;
  }

  .inventory-sales-modal-subtitle {
    margin-top: 6px;
    font-size: clamp(16px, 1.15vw, 20px);
    line-height: 1.35;
    color: #60798a;
    font-weight: 600;
    word-break: break-word;
    text-wrap: pretty;
  }

  .inventory-sales-modal-subtitle:empty {
    display: none;
  }

  .inventory-sales-modal-state {
    display: none;
    padding: 24px;
    border-radius: 18px;
    background: #f4f7fa;
    color: #51606d;
    text-align: center;
    font-size: 15px;
    font-weight: 600;
  }

  .inventory-sales-modal-state.is-visible {
    display: block;
  }

  .inventory-sales-modal-content {
    display: none;
  }

  .inventory-sales-modal-content.is-visible {
    display: block;
  }

  .inventory-sales-summary {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 12px;
    margin-bottom: 14px;
  }

  .inventory-sales-summary-card {
    min-height: 0;
    border-radius: 22px;
    padding: 14px 16px 12px;
    background:
      radial-gradient(circle at top right, rgba(29, 141, 177, 0.07), transparent 34%),
      linear-gradient(180deg, #ffffff 0%, #f8fbfd 100%);
    border: 1px solid rgba(208, 222, 234, 0.95);
    box-shadow: 0 10px 24px rgba(17, 33, 45, 0.05);
  }

  .inventory-sales-summary-label {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 30px;
    padding: 0 11px;
    border-radius: 10px;
    background: linear-gradient(135deg, #173548 0%, #234b62 100%);
    color: #f5fbff;
    font-size: 13px;
    font-weight: 800;
    text-transform: uppercase;
    letter-spacing: .12em;
  }

  .inventory-sales-summary-card.is-earliest .inventory-sales-summary-label {
    background: linear-gradient(135deg, rgba(196, 144, 22, 1) 0%, rgba(224, 170, 40, 1) 100%);
    color: #fffaf0;
  }

  .inventory-sales-summary-card.is-previous .inventory-sales-summary-label {
    background: linear-gradient(135deg, #1f8eaf 0%, #42bfdc 100%);
    color: #f4fcff;
  }

  .inventory-sales-summary-card.is-current .inventory-sales-summary-label {
    background: linear-gradient(135deg, #2f9666 0%, #3eb77d 100%);
    color: #f3fff8;
  }

  .inventory-sales-summary-value {
    display: flex;
    align-items: center;
    gap: 10px;
    max-width: 100%;
    font-size: clamp(15px, 1.02vw, 18px);
    line-height: 1.2;
    font-weight: 800;
    letter-spacing: -.025em;
    color: #12232f;
  }

  .inventory-sales-summary-text {
    min-width: 0;
  }

  .inventory-sales-summary-note {
    margin-top: 10px;
  }

  .inventory-sales-summary-note strong {
    color: #12232f;
    font-weight: 800;
  }

  .inventory-sales-summary-lines {
    display: grid;
    gap: 4px;
  }

  .inventory-sales-summary-line {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    gap: 12px;
    color: #5d7687;
    font-size: 12px;
    line-height: 1.32;
    padding-top: 5px;
    border-top: 1px solid rgba(208, 222, 234, 0.7);
  }

  .inventory-sales-summary-line-label {
    text-transform: uppercase;
    letter-spacing: .08em;
    font-size: 11px;
    color: #7b8f9e;
    flex: 0 0 auto;
  }

  .inventory-sales-summary-line-value {
    text-align: right;
  }

  .inventory-sales-summary-line-value .inventory-sales-channel-profit {
    display: block;
  }

  .inventory-sales-chart {
    border-radius: 24px;
    padding: 14px 14px;
    background:
      radial-gradient(circle at top right, rgba(61, 198, 228, 0.12), transparent 28%),
      radial-gradient(circle at bottom left, rgba(245, 197, 92, 0.12), transparent 24%),
      linear-gradient(180deg, #f9fcff 0%, #eef5fb 100%);
    color: #19374a;
    box-shadow: 0 16px 32px rgba(24, 50, 68, 0.08);
  }

  .inventory-sales-chart-layout {
    display: grid;
    grid-template-columns: 42px minmax(0, 1fr) 42px;
    gap: 8px;
    align-items: center;
  }

  .inventory-sales-chart-panel {
    min-width: 0;
  }

  .inventory-sales-chart-meta {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 16px;
    margin-bottom: 8px;
  }

  .inventory-sales-chart-range {
    font-size: 13px;
    text-transform: uppercase;
    letter-spacing: .12em;
    line-height: 1.3;
    color: rgba(56, 97, 121, 0.72);
  }

  .inventory-sales-chart-year {
    font-size: 15px;
    line-height: 1;
    font-weight: 800;
    letter-spacing: .02em;
    color: #1c3f52;
  }

  .inventory-sales-chart-surface {
    border-radius: 18px;
    background:
      linear-gradient(180deg, rgba(255, 255, 255, 0.98) 0%, rgba(244, 249, 253, 0.98) 100%);
    padding: 10px 10px 8px;
    box-shadow: inset 0 1px 0 rgba(255, 255, 255, 0.92), 0 8px 18px rgba(27, 59, 77, 0.04);
    border: 1px solid rgba(194, 214, 229, 0.78);
  }

  .inventory-sales-chart-canvas {
    width: 100%;
    height: 220px;
    position: relative;
  }

  .inventory-sales-chart-canvas canvas {
    width: 100% !important;
    height: 100% !important;
    display: block;
  }

  .inventory-sales-chart-footnote {
    display: none;
  }

  .inventory-sales-nav {
    align-self: center;
    width: 48px;
    height: 48px;
    border: 0;
    border-radius: 999px;
    background: rgba(255, 255, 255, 0.94);
    color: #60798a;
    box-shadow: 0 12px 24px rgba(12, 32, 44, 0.18);
    display: inline-flex;
    align-items: center;
    justify-content: center;
    font-size: 22px;
    font-weight: 600;
    line-height: 1;
    transition: transform .18s ease, box-shadow .18s ease, opacity .18s ease;
  }

  .inventory-sales-nav span[aria-hidden="true"] {
    display: block;
    font-size: 36px;
    font-family: Arial, sans-serif;
    font-weight: 400;
    line-height: .7;
    transform: translateY(-1px);
    color: #60798a;
  }

  .inventory-sales-nav:hover,
  .inventory-sales-nav:focus {
    transform: translateY(-1px) scale(1.02);
    box-shadow: 0 16px 30px rgba(12, 32, 44, 0.22);
  }

  .inventory-sales-nav.is-disabled {
    opacity: .35;
    pointer-events: none;
  }

  @media (max-width: 900px) {
    .prestashop-inventory .inventory-marketplace-settings-grid {
      grid-template-columns: 1fr;
    }

    .prestashop-inventory .inventory-marketplace-setting {
      justify-content: space-between;
    }

    .inventory-sales-summary {
      grid-template-columns: 1fr;
    }

    .inventory-sales-chart-layout {
      grid-template-columns: 1fr;
      gap: 10px;
    }

    .inventory-sales-modal-dialog {
      width: calc(100vw - 20px);
      margin: 24px auto;
      padding: 26px 18px 18px;
    }

    .inventory-sales-modal-head {
      padding: 4px 56px 8px 0;
    }

    .inventory-sales-modal-title {
      font-size: 18px;
    }

    .inventory-sales-modal-thumb-wrap {
      width: 64px;
      height: 64px;
    }

    .inventory-sales-nav {
      width: 42px;
      height: 42px;
      justify-self: center;
    }

    .inventory-sales-summary-line {
      flex-direction: column;
      align-items: flex-start;
      gap: 4px;
    }

    .inventory-sales-summary-line-value {
      text-align: left;
    }

    .inventory-sales-chart {
      padding: 12px 10px;
    }

    .inventory-sales-chart-canvas {
      height: 190px;
    }
  }
</style>

<script src="{$inventoryModuleBaseUrl|escape:'html':'UTF-8'}views/js/chart.umd.min.js"></script>
<script>
  {if empty($inventoryEmbeddedInModernLayout)}
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
      moduleLink.href = '{$inventoryModuleUrl|escape:'javascript'}';
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
      var pageHead = document.querySelector('.page-head');
      var pageHeadWrapper = pageHead ? pageHead.querySelector('.wrapper.clearfix') : null;
      var contentDiv = document.querySelector('#main-div > .content-div');

      if (!source || !pageHead) {
        if ((attempt || 0) < 100) {
          window.setTimeout(function () {
            mountBoTabs(sourceId, (attempt || 0) + 1);
          }, 100);
          return false;
        }

        if (source) {
          source.hidden = false;
        }
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

      if (contentDiv) {
        contentDiv.classList.add('with-tabs');
      }

      syncBreadcrumb('Magazyn');

      source.hidden = false;
      return false;
    }

    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', function () {
        mountBoTabs('psinventory-head-tabs-source', 0);
      });
    } else {
      mountBoTabs('psinventory-head-tabs-source', 0);
    }

    window.addEventListener('load', function () {
      mountBoTabs('psinventory-head-tabs-source', 0);
    });

    var mountObserver = new MutationObserver(function () {
      mountBoTabs('psinventory-head-tabs-source', 0);
    });
    mountObserver.observe(document.documentElement, {ldelim}childList: true, subtree: true{rdelim});
  window.setTimeout(function () {
      mountObserver.disconnect();
    }, 10000);
  })();
  {/if}

  window.prestashopInventoryConfig = {
    ajaxUrl: '{$inventoryAjaxUrl|escape:'javascript'}',
    exportUrl: '{$inventoryExportUrl|escape:'javascript'}',
    languageIso: '{$inventoryLanguageIso|escape:'javascript'}',
    canEdit: {$inventoryCanEdit|intval},
    moduleVersion: '{$inventoryModuleVersion|escape:'javascript'}',
    licenseValid: {$inventoryLicenseStatus.valid|intval},
    updateConfigured: {$inventoryUpdateConfigured|intval}
  };

  (function () {
    var sourceTranslations = {$inventoryTranslationsJson nofilter};
    var translations = {
      no: sourceTranslations.id,
      title: sourceTranslations.report_title,
      activeOnly: sourceTranslations.show_only_active_products,
      onlyAvailable: sourceTranslations.show_only_available_in_stock,
      missingPurchasePriceOnly: sourceTranslations.show_only_missing_purchase_price,
      showWeight: sourceTranslations.show_product_weight,
      missingWeightOnly: sourceTranslations.show_only_missing_weight,
      showBrutto: sourceTranslations.show_retail_prices_gross,
      searchPlaceholder: sourceTranslations.search_placeholder,
      picture: sourceTranslations.image,
      name: sourceTranslations.product_name,
      active: sourceTranslations.active,
      weight: sourceTranslations.product_weight,
      price: sourceTranslations.purchase_price_net,
      purchasePriceGross: sourceTranslations.purchase_price_gross,
      priceBrutto: sourceTranslations.retail_price_gross,
      qty: sourceTranslations.available_quantity,
      value: sourceTranslations.purchase_value_net,
      valueBrutto: sourceTranslations.retail_value_gross,
      save: sourceTranslations.save,
      cancel: sourceTranslations.cancel,
      enterQty: sourceTranslations.enter_qty,
      enterPrice: sourceTranslations.enter_price,
      enterRetailPrice: sourceTranslations.enter_retail_price,
      enterWeight: sourceTranslations.enter_weight,
      errorSave: sourceTranslations.error_save,
      errorNetwork: sourceTranslations.error_network,
      errorQtySave: sourceTranslations.error_qty_save,
      errorWeightSave: sourceTranslations.error_weight_save,
      errorHide: sourceTranslations.error_hide,
      hideForever: sourceTranslations.hide_forever,
      typeQty: sourceTranslations.type_qty,
      typePrice: sourceTranslations.type_price,
      typeWeight: sourceTranslations.type_weight,
      errorToggle: sourceTranslations.error_toggle,
      copied: sourceTranslations.copied,
      copyError: sourceTranslations.copy_error,
      loadError: sourceTranslations.load_error,
      salesChart: sourceTranslations.sales_chart,
      salesStatsTitle: sourceTranslations.sales_stats_title,
      salesStatsLoading: sourceTranslations.sales_stats_loading,
      salesStatsEmpty: sourceTranslations.sales_stats_empty,
      salesMonthsRange: sourceTranslations.sales_months_range,
      salesTotalSold: sourceTranslations.sales_total_sold,
      salesBestMonth: sourceTranslations.sales_best_month,
      salesMonthsCount: sourceTranslations.sales_months_count,
      salesUnits: sourceTranslations.sales_units,
      salesRevenue: sourceTranslations.sales_revenue,
      salesRevenueShort: sourceTranslations.sales_revenue_short,
      salesRevenueNet: sourceTranslations.sales_revenue_net,
      salesRevenueNetShort: sourceTranslations.sales_revenue_net_short,
      estimatedProfitNet: sourceTranslations.estimated_profit_net,
      estimatedProfitGross: sourceTranslations.estimated_profit_gross,
      year: sourceTranslations.year,
      errorSalesStats: sourceTranslations.error_sales_stats,
      close: sourceTranslations.close,
      previousYear: sourceTranslations.previous_year,
      nextYear: sourceTranslations.next_year,
      profitability: sourceTranslations.profitability,
      storePrice: sourceTranslations.store_price,
      marketplacePrice: sourceTranslations.marketplace_price,
      storeChannel: sourceTranslations.store_channel,
      marketplaceChannel: sourceTranslations.marketplace_channel,
      profitabilityMarkup: sourceTranslations.profitability_markup,
      profitabilityMargin: sourceTranslations.profitability_margin,
      profitabilityProfit: sourceTranslations.profitability_profit,
      marketplaceMarkup: sourceTranslations.marketplace_markup,
      marketplaceMarkupDescription: sourceTranslations.marketplace_markup_description,
      marketplaceCommission: sourceTranslations.marketplace_commission,
      marketplaceCommissionDescription: sourceTranslations.marketplace_commission_description,
      marketplaceSettings: sourceTranslations.marketplace_settings,
      licenseRequiredTitle: sourceTranslations.license_required_title,
      licenseMissingMessage: sourceTranslations.license_missing_message,
      licenseInvalidMessage: sourceTranslations.license_invalid_message,
      licenseExpiredMessage: sourceTranslations.license_expired_message,
      licenseDomainMismatchMessage: sourceTranslations.license_domain_mismatch_message,
      licenseFileErrorMessage: sourceTranslations.license_file_error_message,
      updateAvailableButton: sourceTranslations.update_available_button,
      updateCheckingMessage: sourceTranslations.update_checking_message,
      updateInstallingMessage: sourceTranslations.update_installing_message,
      updateInstalledMessage: sourceTranslations.update_installed_message,
      updateCheckErrorMessage: sourceTranslations.update_check_error_message,
      updateInstallErrorMessage: sourceTranslations.update_install_error_message,
      enterPercentage: sourceTranslations.enter_percentage,
      typePercentage: sourceTranslations.type_percentage,
      notAvailable: sourceTranslations.not_available
    };

    var LS_QUERY = 'ps_inventory_query';
    var LS_ACTIVE_ONLY = 'ps_inventory_activeOnly';
    var LS_ONLY = 'ps_inventory_onlyAvailable';
    var LS_MISSING_PURCHASE = 'ps_inventory_missingPurchasePriceOnly';
    var LS_SHOW_WEIGHT = 'ps_inventory_showWeight';
    var LS_MISSING_WEIGHT = 'ps_inventory_missingWeightOnly';
    var LS_BRUTTO = 'ps_inventory_showBrutto';
    var LS_PAGE = 'ps_inventory_page';
    var LS_PER_PAGE = 'ps_inventory_per_page';
    var LS_SORT_FIELD = 'ps_inventory_sort_field';
    var LS_SORT_DIR = 'ps_inventory_sort_dir';
    var LS_MARKETPLACE_MARKUP = 'ps_inventory_marketplace_markup';
    var LS_MARKETPLACE_COMMISSION = 'ps_inventory_marketplace_commission';
    var currentPage = Math.max(parseInt(localStorage.getItem(LS_PAGE) || '1', 10), 1);
    var currentPerPage = parseInt(localStorage.getItem(LS_PER_PAGE) || '20', 10);
    if ([20, 50, 100, 200].indexOf(currentPerPage) === -1) {
      currentPerPage = 20;
    }
    var currentSortField = localStorage.getItem(LS_SORT_FIELD) || 'product_name';
    var currentSortDir = localStorage.getItem(LS_SORT_DIR) || 'ASC';
    var salesModalState = {
      productId: 0,
      productAttributeId: 0,
      productName: '',
      combinationName: '',
      imageSrc: '',
      cost: 0,
      costGross: 0,
      retailNet: 0,
      retail: 0,
      months: 12,
      offsetMonths: 0,
      selectedYear: 0,
      previousYear: 0,
      earliestYear: 0
    };
    var profitModalState = {
      productName: '',
      combinationName: '',
      imageSrc: '',
      cost: 0,
      costGross: 0,
      retailNet: 0,
      retail: 0
    };
    var marketplaceSettingsState = {
      marketplaceMarkup: 20,
      marketplaceCommission: 10
    };
    var salesChartInstance = null;

    function t(key) {
      return translations[key] ? translations[key] : key;
    }

    function setUpdateStatus(message, isError) {
      var el = document.getElementById('inventoryUpdateStatus');
      var metaEl = document.getElementById('inventoryUpdateMetaStatus');
      if (!el && !metaEl) {
        return;
      }

      if (el) {
        el.textContent = message || '';
        el.classList.toggle('is-error', !!isError);
      }

      if (metaEl) {
        metaEl.textContent = message || '';
        metaEl.classList.toggle('is-error', !!isError);
      }
    }

    function formatUpdateButtonLabel(version) {
      return String(t('updateAvailableButton') || '')
        .replace('{{ version }}', version)
        .replace('%version%', version)
        .trim();
    }

    function updateButtonVisibility(version) {
      var button = document.getElementById('inventoryUpdateButton');
      var label = button ? button.querySelector('.inventory-update-btn-label') : null;
      if (!button || !label) {
        return;
      }

      if (!version) {
        button.hidden = true;
        button.removeAttribute('data-version');
        label.textContent = '';
        return;
      }

      button.hidden = false;
      button.setAttribute('data-version', version);
      label.textContent = formatUpdateButtonLabel(version);
    }

    function normalizePercentValue(value, fallbackValue) {
      var parsed = Number(String(value == null ? '' : value).replace(',', '.').trim());
      if (!isFinite(parsed) || parsed < 0) {
        return fallbackValue;
      }

      return parsed;
    }

    function formatPercentValue(value) {
      if (!isFinite(value)) {
        return t('notAvailable');
      }

      return Number(value).toFixed(1).replace(/\.0$/, '') + '%';
    }

    function calculateChannelMetrics(cost, sellPrice, commissionPercent) {
      if (!(cost > 0) || !(sellPrice > 0)) {
        return null;
      }

      var commissionValue = sellPrice * (commissionPercent / 100);
      var profit = sellPrice - cost - commissionValue;

      return {
        profit: profit,
        markup: (profit / cost) * 100,
        margin: (profit / sellPrice) * 100
      };
    }

    function buildEstimatedSalesProfit(totalQuantity) {
      var qty = Number(totalQuantity || 0);
      if (!(qty > 0)) {
        return null;
      }

      var marketplaceGrossPrice = salesModalState.retail > 0 ? salesModalState.retail * (1 + (marketplaceSettingsState.marketplaceMarkup / 100)) : 0;
      var marketplaceNetPrice = salesModalState.retailNet > 0 ? salesModalState.retailNet * (1 + (marketplaceSettingsState.marketplaceMarkup / 100)) : 0;
      var marketplaceGrossCommission = marketplaceGrossPrice * (marketplaceSettingsState.marketplaceCommission / 100);
      var marketplaceNetCommission = marketplaceNetPrice * (marketplaceSettingsState.marketplaceCommission / 100);

      return {
        storeNet: salesModalState.retailNet > 0 ? qty * (salesModalState.retailNet - salesModalState.cost) : NaN,
        marketplaceNet: marketplaceNetPrice > 0 ? qty * (marketplaceNetPrice - salesModalState.cost - marketplaceNetCommission) : NaN,
        storeGross: salesModalState.retail > 0 ? qty * (salesModalState.retail - salesModalState.costGross) : NaN,
        marketplaceGross: marketplaceGrossPrice > 0 ? qty * (marketplaceGrossPrice - salesModalState.costGross - marketplaceGrossCommission) : NaN
      };
    }

    function renderEstimatedProfitValue(storeValue, marketplaceValue) {
      var storeText = isFinite(storeValue) ? formatCurrencyAmount(storeValue) : t('notAvailable');
      var marketplaceText = isFinite(marketplaceValue) ? formatCurrencyAmount(marketplaceValue) : t('notAvailable');

      return '<span class="inventory-sales-channel-profit">' + escapeHtml(t('storeChannel')) + ': <strong>' + escapeHtml(storeText) + '</strong></span>' +
        '<span class="inventory-sales-channel-profit">' + escapeHtml(t('marketplaceChannel')) + ': <strong>' + escapeHtml(marketplaceText) + '</strong></span>';
    }

    function syncMarketplaceSettingsUi() {
      $('.editable-marketplace-setting').each(function () {
        var key = String($(this).data('setting-key') || '');
        var value = marketplaceSettingsState[key];
        $(this).text(formatPercentValue(value)).attr('data-current-value', String(value));
      });
    }

    function formatMoneyValue(value) {
      if (!isFinite(value) || value <= 0) {
        return t('notAvailable');
      }

      return formatCurrencyAmount(value);
    }

    function formatCurrencyAmount(value) {
      if (!isFinite(value)) {
        return t('notAvailable');
      }

      var integerPart = '';

      try {
        integerPart = new Intl.NumberFormat('pl-PL', {
          minimumFractionDigits: 0,
          maximumFractionDigits: 0,
          useGrouping: true
        }).format(Math.round(Number(value)));
      } catch (error) {
        var rounded = String(Math.round(Number(value)));
        integerPart = rounded.replace(/\B(?=(\d{3})+(?!\d))/g, '\u00A0');
      }

      integerPart = String(integerPart).replace(/\s/g, '\u00A0');

      return integerPart + '\u00A0zł';
    }

    function renderProfitabilityCard(label, toneClass, priceLabel, metrics) {
      var costText = formatMoneyValue(profitModalState.cost);
      var costGrossText = formatMoneyValue(profitModalState.costGross);
      var markupText = metrics ? formatPercentValue(metrics.markup) : t('notAvailable');
      var marginText = metrics ? formatPercentValue(metrics.margin) : t('notAvailable');
      var profitText = metrics ? formatCurrencyAmount(metrics.profit) : t('notAvailable');
      var profitValueClass = 'inventory-profit-value';
      var markupValueClass = 'inventory-percent-value';
      var marginValueClass = 'inventory-percent-value';

      if (metrics) {
        if (metrics.markup < 0) {
          markupValueClass += ' is-negative';
        }

        if (metrics.margin < 0) {
          marginValueClass += ' is-negative';
        }

        if (metrics.profit < 0) {
          profitValueClass += ' is-negative';
        } else {
          profitValueClass += ' is-positive';
        }
      }

      return '' +
        '<div class="inventory-profit-card ' + toneClass + '">' +
          '<div class="inventory-profit-card-label">' + escapeHtml(label) + '</div>' +
          '<div class="inventory-profit-price">' + escapeHtml(priceLabel) + '</div>' +
          '<div class="inventory-profit-lines">' +
            '<div class="inventory-profit-line"><span>' + escapeHtml(t('price')) + '</span><strong>' + escapeHtml(costText) + '</strong></div>' +
            '<div class="inventory-profit-line"><span>' + escapeHtml(t('purchasePriceGross')) + '</span><strong>' + escapeHtml(costGrossText) + '</strong></div>' +
            '<div class="inventory-profit-line"><span>' + escapeHtml(t('profitabilityMarkup')) + '</span><strong class="' + escapeHtml(markupValueClass) + '">' + escapeHtml(markupText) + '</strong></div>' +
            '<div class="inventory-profit-line"><span>' + escapeHtml(t('profitabilityMargin')) + '</span><strong class="' + escapeHtml(marginValueClass) + '">' + escapeHtml(marginText) + '</strong></div>' +
            '<div class="inventory-profit-line"><span>' + escapeHtml(t('profitabilityProfit')) + '</span><strong class="' + escapeHtml(profitValueClass) + '">' + escapeHtml(profitText) + '</strong></div>' +
          '</div>' +
        '</div>';
    }

    function updateProfitModalHeading() {
      document.getElementById('inventoryProfitModalTitle').textContent = profitModalState.productName || '';
      document.getElementById('inventoryProfitModalSubtitle').textContent = profitModalState.combinationName || '';
    }

    function renderProfitabilityModal() {
      var marketplacePrice = profitModalState.retail > 0 ? profitModalState.retail * (1 + (marketplaceSettingsState.marketplaceMarkup / 100)) : 0;
      var storeMetrics = calculateChannelMetrics(profitModalState.cost, profitModalState.retail, 0);
      var marketplaceMetrics = calculateChannelMetrics(profitModalState.cost, marketplacePrice, marketplaceSettingsState.marketplaceCommission);
      var storeProfitNet = profitModalState.retailNet > 0 ? profitModalState.retailNet - profitModalState.cost : NaN;
      var marketplaceRetailNet = profitModalState.retailNet > 0 ? profitModalState.retailNet * (1 + (marketplaceSettingsState.marketplaceMarkup / 100)) : 0;
      var marketplaceCommissionNet = marketplaceRetailNet * (marketplaceSettingsState.marketplaceCommission / 100);
      var marketplaceProfitNet = marketplaceRetailNet > 0 ? marketplaceRetailNet - profitModalState.cost - marketplaceCommissionNet : NaN;

      if (storeMetrics) {
        storeMetrics.profit = storeProfitNet;
      }

      if (marketplaceMetrics) {
        marketplaceMetrics.profit = marketplaceProfitNet;
      }

      var html = '' +
        '<div class="inventory-marketplace-settings">' +
          '<div class="inventory-marketplace-settings-title">' + escapeHtml(t('marketplaceSettings')) + '</div>' +
          '<div class="inventory-marketplace-settings-grid">' +
            '<div class="inventory-marketplace-setting">' +
              '<div class="inventory-marketplace-setting-copy">' +
                '<span class="inventory-marketplace-setting-label">' + escapeHtml(t('marketplaceMarkup')) + '</span>' +
                '<span class="inventory-marketplace-setting-description">' + escapeHtml(t('marketplaceMarkupDescription')) + '</span>' +
              '</div>' +
              '<span class="inventory-marketplace-setting-value editable-marketplace-setting" data-setting-key="marketplaceMarkup" data-current-value="' + escapeHtml(String(marketplaceSettingsState.marketplaceMarkup)) + '"></span>' +
            '</div>' +
            '<div class="inventory-marketplace-setting">' +
              '<div class="inventory-marketplace-setting-copy">' +
                '<span class="inventory-marketplace-setting-label">' + escapeHtml(t('marketplaceCommission')) + '</span>' +
                '<span class="inventory-marketplace-setting-description">' + escapeHtml(t('marketplaceCommissionDescription')) + '</span>' +
              '</div>' +
              '<span class="inventory-marketplace-setting-value editable-marketplace-setting" data-setting-key="marketplaceCommission" data-current-value="' + escapeHtml(String(marketplaceSettingsState.marketplaceCommission)) + '"></span>' +
            '</div>' +
          '</div>' +
        '</div>' +
        '<div class="inventory-profit-grid">' +
          renderProfitabilityCard(t('storeChannel'), 'is-store', t('storePrice') + ': ' + formatMoneyValue(profitModalState.retail), storeMetrics) +
          renderProfitabilityCard(t('marketplaceChannel'), 'is-marketplace', t('marketplacePrice') + ': ' + formatMoneyValue(marketplacePrice), marketplaceMetrics) +
        '</div>';

      document.getElementById('inventoryProfitModalContent').innerHTML = html;
      document.getElementById('inventoryProfitModalContent').classList.add('is-visible');
      syncMarketplaceSettingsUi();
    }

    function openProfitModal() {
      var modal = document.getElementById('inventoryProfitModal');
      var modalImage = document.getElementById('inventoryProfitModalImage');
      var modalFallback = document.getElementById('inventoryProfitModalImageFallback');
      updateProfitModalHeading();
      if (profitModalState.imageSrc) {
        modalImage.setAttribute('src', profitModalState.imageSrc);
        modalImage.classList.remove('is-hidden');
        modalFallback.classList.remove('is-visible');
      } else {
        modalImage.setAttribute('src', '');
        modalImage.classList.add('is-hidden');
        modalFallback.classList.add('is-visible');
      }
      renderProfitabilityModal();
      modal.classList.add('is-open');
      modal.setAttribute('aria-hidden', 'false');
    }

    function closeProfitModal() {
      var modal = document.getElementById('inventoryProfitModal');
      var modalImage = document.getElementById('inventoryProfitModalImage');
      var modalFallback = document.getElementById('inventoryProfitModalImageFallback');
      document.getElementById('inventoryProfitModalTitle').textContent = '';
      document.getElementById('inventoryProfitModalSubtitle').textContent = '';
      document.getElementById('inventoryProfitModalContent').innerHTML = '';
      document.getElementById('inventoryProfitModalContent').classList.remove('is-visible');
      modalImage.setAttribute('src', '');
      modalImage.classList.remove('is-hidden');
      modalFallback.classList.remove('is-visible');
      modal.classList.remove('is-open');
      modal.setAttribute('aria-hidden', 'true');
    }

    function refreshCalculatedMetrics() {
      $('.inventory-calculated-metric').each(function () {
        var $metric = $(this);
        var cost = Number($metric.data('cost') || 0);
        var retail = Number($metric.data('retail') || 0);
        var marketplaceMarkupPercent = marketplaceSettingsState.marketplaceMarkup;
        var marketplaceCommissionPercent = marketplaceSettingsState.marketplaceCommission;
        var marketplacePrice = retail > 0 ? retail * (1 + (marketplaceMarkupPercent / 100)) : 0;
        var result = null;

        if ($metric.hasClass('inventory-store-markup')) {
          result = calculateChannelMetrics(cost, retail, 0);
          result = result ? result.markup : null;
        } else if ($metric.hasClass('inventory-store-margin')) {
          result = calculateChannelMetrics(cost, retail, 0);
          result = result ? result.margin : null;
        } else if ($metric.hasClass('inventory-marketplace-markup-result')) {
          result = calculateChannelMetrics(cost, marketplacePrice, marketplaceCommissionPercent);
          result = result ? result.markup : null;
        } else if ($metric.hasClass('inventory-marketplace-margin')) {
          result = calculateChannelMetrics(cost, marketplacePrice, marketplaceCommissionPercent);
          result = result ? result.margin : null;
        }

        $metric
          .text(result == null ? t('notAvailable') : formatPercentValue(result))
          .toggleClass('is-negative', result != null && result < 0);
      });
    }

    function parseKeywords(raw) {
      return (raw || '').trim().split(/[,\s]+/g).map(function (item) {
        return item.trim();
      }).filter(Boolean);
    }

    function applyLanguage() {
      document.querySelector('#thNo .inventory-head-title').textContent = t('no');
      document.getElementById('activeOnlyLabel').textContent = t('activeOnly');
      document.getElementById('onlyAvailableLabel').textContent = t('onlyAvailable');
      document.getElementById('missingPurchasePriceOnlyLabel').textContent = t('missingPurchasePriceOnly');
      document.getElementById('showWeightLabel').textContent = t('showWeight');
      document.getElementById('missingWeightOnlyLabel').textContent = t('missingWeightOnly');
      document.getElementById('showBruttoLabel').textContent = t('showBrutto');
      document.getElementById('searchInput').setAttribute('placeholder', t('searchPlaceholder'));
      document.getElementById('thPicture').textContent = t('picture');
      document.querySelector('#thName .inventory-head-title').textContent = t('name');
      document.querySelector('#thActive .inventory-head-title').textContent = t('active');
      document.querySelector('#thWeight .inventory-head-title').textContent = t('weight');
      document.querySelector('#thPrice .inventory-head-title').textContent = t('price');
      document.querySelector('#thPriceBrutto .inventory-head-title').textContent = t('priceBrutto');
      document.querySelector('#thQty .inventory-head-title').textContent = t('qty');
      document.getElementById('thValue').textContent = t('value');
      document.getElementById('thValueBrutto').textContent = t('valueBrutto');
      renderSortState();
    }

    function toggleWeightColumns(show, shouldReload) {
      document.getElementById('thWeight').style.display = show ? '' : 'none';
      if (shouldReload === false) {
        return;
      }

      currentPage = 1;
      localStorage.setItem(LS_PAGE, String(currentPage));
      loadTable(getSearchQuery(), document.getElementById('activeOnly').checked, document.getElementById('onlyAvailable').checked, document.getElementById('missingPurchasePriceOnly').checked, document.getElementById('missingWeightOnly').checked);
    }

    function toggleBruttoColumns(show, shouldReload) {
      var display = show ? '' : 'none';
      document.getElementById('thPriceBrutto').style.display = display;
      document.getElementById('thValueBrutto').style.display = display;
      if (shouldReload === false) {
        return;
      }

      currentPage = 1;
      localStorage.setItem(LS_PAGE, String(currentPage));
      loadTable(getSearchQuery(), document.getElementById('activeOnly').checked, document.getElementById('onlyAvailable').checked, document.getElementById('missingPurchasePriceOnly').checked, document.getElementById('missingWeightOnly').checked);
    }

    function normalizeKeywords(value) {
      return (value || []).map(function (item) {
        return item.trim();
      }).filter(Boolean);
    }

    function getSearchKeywords() {
      return normalizeKeywords($('#searchTags').data('keywords') || []);
    }

    function setSearchKeywords(keywords) {
      $('#searchTags').data('keywords', normalizeKeywords(keywords));
      renderSearchTags();
    }

    function getSearchQuery() {
      return getSearchKeywords().join(' ');
    }

    function renderSearchTags() {
      var keywords = getSearchKeywords();
      var $tags = $('#searchTags');

      $tags.empty();
      keywords.forEach(function (keyword, index) {
        var $tag = $('<span class="inventory-tag"></span>');
        $tag.append($('<span></span>').text(keyword));
        $tag.append($('<button type="button" class="inventory-tag-remove" aria-label="Remove">&times;</button>').attr('data-index', index));
        $tags.append($tag);
      });
    }

    function persistAndLoadKeywords(keywords) {
      setSearchKeywords(keywords);
      localStorage.setItem(LS_QUERY, getSearchQuery());
      updateFilterBadge();
      currentPage = 1;
      localStorage.setItem(LS_PAGE, String(currentPage));
      loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
    }

    function appendKeywordsFromInput() {
      var current = $('#searchInput').val();
      var inputKeywords = parseKeywords(current);
      if (!inputKeywords.length) {
        return false;
      }

      var merged = getSearchKeywords().concat(inputKeywords);
      persistAndLoadKeywords(merged);
      $('#searchInput').val('');

      return true;
    }

    function loadTable(query, activeOnly, onlyAvailable, missingPurchasePriceOnly, missingWeightOnly) {
      if (!window.prestashopInventoryConfig.licenseValid) {
        $('#productsTable tbody').empty();
        $('#inventoryPagination').empty();
        return;
      }

      var keywords = parseKeywords(query);
      var showWeight = document.getElementById('showWeight').checked;
      var showBrutto = document.getElementById('showBrutto').checked;

      $.post(window.prestashopInventoryConfig.ajaxUrl + '&action=FetchProducts', {
        query: query || '',
        keywords: keywords,
        activeOnly: activeOnly ? 1 : 0,
        onlyAvailable: onlyAvailable ? 1 : 0,
        missingPurchasePriceOnly: missingPurchasePriceOnly ? 1 : 0,
        missingWeightOnly: missingWeightOnly ? 1 : 0,
        showWeight: showWeight ? 1 : 0,
        showBrutto: showBrutto ? 1 : 0,
        lang: window.prestashopInventoryConfig.languageIso || 'en',
        sort_field: currentSortField,
        sort_dir: currentSortDir,
        page: currentPage,
        per_page: currentPerPage
      }, null, 'json').done(function (resp) {
        $('#productsTable tbody').html(resp && resp.tbody ? resp.tbody : '');
        refreshCalculatedMetrics();
        $('#inventoryPagination').html(resp && resp.pagination ? resp.pagination : '');
        if (resp && resp.meta) {
          currentPage = Math.max(parseInt(resp.meta.current_page || 1, 10), 1);
          currentPerPage = parseInt(resp.meta.per_page || currentPerPage, 10);
          localStorage.setItem(LS_PAGE, String(currentPage));
          localStorage.setItem(LS_PER_PAGE, String(currentPerPage));
        }
      }).fail(function () {
        var colspan = (document.getElementById('showWeight').checked ? 9 : 8) + (document.getElementById('showBrutto').checked ? 2 : 0);
        $('#productsTable tbody').html('<tr><td colspan="' + colspan + '" class="text-center text-danger">' + t('loadError') + '</td></tr>');
        $('#inventoryPagination').empty();
      });
    }

    function renderSortState() {
      $('.inventory-sortable').removeClass('is-active sort-asc sort-desc');
      var $active = $('.inventory-sortable[data-sort-field="' + currentSortField + '"]');
      $active.addClass('is-active ' + (currentSortDir === 'DESC' ? 'sort-desc' : 'sort-asc'));
    }

    function updateFilterBadge() {
      var count = 0;

      [
        'activeOnly',
        'onlyAvailable',
        'missingPurchasePriceOnly',
        'showWeight',
        'missingWeightOnly',
        'showBrutto'
      ].forEach(function (id) {
        var input = document.getElementById(id);
        if (input && input.checked) {
          count += 1;
        }
      });

      var badge = document.getElementById('filterActiveCount');
      if (badge) {
        badge.textContent = String(count);
        badge.classList.toggle('is-hidden', count === 0);
      }
    }

    function copyTextToClipboard(text) {
      if (navigator.clipboard && navigator.clipboard.writeText) {
        return navigator.clipboard.writeText(text);
      }

      return new Promise(function (resolve, reject) {
        var input = document.createElement('textarea');
        input.value = text;
        input.setAttribute('readonly', '');
        input.style.position = 'absolute';
        input.style.left = '-9999px';
        document.body.appendChild(input);
        input.select();

        try {
          document.execCommand('copy');
          document.body.removeChild(input);
          resolve();
        } catch (error) {
          document.body.removeChild(input);
          reject(error);
        }
      });
    }

    function escapeHtml(value) {
      return String(value == null ? '' : value)
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#39;');
    }

    function formatSalesMonth(monthDate) {
      var date = new Date(monthDate + 'T00:00:00');

      try {
        return new Intl.DateTimeFormat(window.prestashopInventoryConfig.languageIso || 'en', {
          month: 'short',
          year: 'numeric'
        }).format(date);
      } catch (error) {
        return monthDate;
      }
    }

    function formatSalesMonthShort(monthDate) {
      var date = new Date(monthDate + 'T00:00:00');

      try {
        return new Intl.DateTimeFormat(window.prestashopInventoryConfig.languageIso || 'en', {
          month: 'short'
        }).format(date);
      } catch (error) {
        return monthDate;
      }
    }

    function formatSalesMonthName(monthDate, grammaticalCase) {
      var date = new Date(monthDate + 'T00:00:00');
      var iso = String(window.prestashopInventoryConfig.languageIso || 'en').toLowerCase();
      var monthIndex = date.getMonth();

      if (iso.indexOf('pl') === 0) {
        var polishMonthsStandalone = ['styczeń', 'luty', 'marzec', 'kwiecień', 'maj', 'czerwiec', 'lipiec', 'sierpień', 'wrzesień', 'październik', 'listopad', 'grudzień'];
        var polishMonthsLocative = ['styczniu', 'lutym', 'marcu', 'kwietniu', 'maju', 'czerwcu', 'lipcu', 'sierpniu', 'wrześniu', 'październiku', 'listopadzie', 'grudniu'];

        return grammaticalCase === 'locative'
          ? polishMonthsLocative[monthIndex]
          : polishMonthsStandalone[monthIndex];
      }

      try {
        return new Intl.DateTimeFormat(window.prestashopInventoryConfig.languageIso || 'en', {
          month: 'long'
        }).format(date);
      } catch (error) {
        return monthDate;
      }
    }

    function buildYearSummary(year, quantities, values, valuesNet) {
      var today = new Date();
      var currentYear = today.getFullYear();
      var currentMonthIndex = today.getMonth();
      var currentDay = today.getDate();
      var daysInCurrentMonth = new Date(currentYear, currentMonthIndex + 1, 0).getDate();
      var lastIncludedMonthIndex = year === currentYear ? Math.min(currentMonthIndex, quantities.length - 1) : (quantities.length - 1);
      var elapsedMonthUnits = quantities.length;
      var total = 0;
      var totalValue = 0;
      var totalValueNet = 0;
      var minValue = null;
      var maxValue = null;
      var minMonthIndex = 0;
      var maxMonthIndex = 0;

      quantities.forEach(function (qty, index) {
        if (index > lastIncludedMonthIndex) {
          return;
        }

        var value = Number(qty || 0);
        total += value;
        totalValue += Number((values || [])[index] || 0);
        totalValueNet += Number((valuesNet || [])[index] || 0);

        if (minValue === null || value < minValue) {
          minValue = value;
          minMonthIndex = index;
        }

        if (maxValue === null || value > maxValue) {
          maxValue = value;
          maxMonthIndex = index;
        }
      });

      if (year === currentYear) {
        elapsedMonthUnits = currentMonthIndex + (daysInCurrentMonth > 0 ? (currentDay / daysInCurrentMonth) : 0);
      }

      if (!isFinite(elapsedMonthUnits) || elapsedMonthUnits <= 0) {
        elapsedMonthUnits = Math.max(lastIncludedMonthIndex + 1, 1);
      }

      return {
        year: year,
        total: total,
        totalValue: totalValue,
        totalValueNet: totalValueNet,
        average: total / elapsedMonthUnits,
        averageValue: totalValue / elapsedMonthUnits,
        averageValueNet: totalValueNet / elapsedMonthUnits,
        minValue: minValue === null ? 0 : minValue,
        maxValue: maxValue === null ? 0 : maxValue,
        minMonthDate: year + '-' + String(minMonthIndex + 1).padStart(2, '0') + '-01',
        maxMonthDate: year + '-' + String(maxMonthIndex + 1).padStart(2, '0') + '-01'
      };
    }

    function renderYearSummaryCard(summary, toneClass) {
      var averageLabel = Number(summary.average || 0).toFixed(1).replace(/\.0$/, '');
      var averageValueLabel = formatCurrencyAmount(Number(summary.averageValue || 0));
      var averageValueNetLabel = formatCurrencyAmount(Number(summary.averageValueNet || 0));
      var estimatedProfit = buildEstimatedSalesProfit(summary.total);
      var title = 'łącznie sprzedano ' + summary.total + ' ' + t('salesUnits');
      var revenueLine = '<span class="inventory-sales-summary-line-label">' + escapeHtml(t('salesRevenue')) + '</span><span class="inventory-sales-summary-line-value"><strong>' + escapeHtml(formatCurrencyAmount(Number(summary.totalValue || 0))) + '</strong></span>';
      var revenueNetLine = '<span class="inventory-sales-summary-line-label">' + escapeHtml(t('salesRevenueNet')) + '</span><span class="inventory-sales-summary-line-value"><strong>' + escapeHtml(formatCurrencyAmount(Number(summary.totalValueNet || 0))) + '</strong></span>';
      var estimatedNetLine = '<span class="inventory-sales-summary-line-label">' + escapeHtml(t('estimatedProfitNet')) + '</span><span class="inventory-sales-summary-line-value">' + (estimatedProfit ? renderEstimatedProfitValue(estimatedProfit.storeNet, estimatedProfit.marketplaceNet) : escapeHtml(t('notAvailable'))) + '</span>';
      var estimatedGrossLine = '<span class="inventory-sales-summary-line-label">' + escapeHtml(t('estimatedProfitGross')) + '</span><span class="inventory-sales-summary-line-value">' + (estimatedProfit ? renderEstimatedProfitValue(estimatedProfit.storeGross, estimatedProfit.marketplaceGross) : escapeHtml(t('notAvailable'))) + '</span>';
      var minLine = '<span class="inventory-sales-summary-line-label">Min</span><span class="inventory-sales-summary-line-value"><strong>' + summary.minValue + ' ' + escapeHtml(t('salesUnits')) + '</strong> w ' + escapeHtml(formatSalesMonthName(summary.minMonthDate, 'locative')) + '</span>';
      var maxLine = '<span class="inventory-sales-summary-line-label">Max</span><span class="inventory-sales-summary-line-value"><strong>' + summary.maxValue + ' ' + escapeHtml(t('salesUnits')) + '</strong> w ' + escapeHtml(formatSalesMonthName(summary.maxMonthDate, 'locative')) + '</span>';
      var avgLine = '<span class="inventory-sales-summary-line-label">Średnio</span><span class="inventory-sales-summary-line-value"><strong>' + escapeHtml(averageLabel) + ' ' + escapeHtml(t('salesUnits')) + '</strong> w miesiącu</span>';
      var avgValueLine = '<span class="inventory-sales-summary-line-label">' + escapeHtml(t('salesRevenue')) + ' / mies.</span><span class="inventory-sales-summary-line-value"><strong>' + escapeHtml(averageValueLabel) + '</strong></span>';
      var avgValueNetLine = '<span class="inventory-sales-summary-line-label">' + escapeHtml(t('salesRevenueNet')) + ' / mies.</span><span class="inventory-sales-summary-line-value"><strong>' + escapeHtml(averageValueNetLabel) + '</strong></span>';

      return '' +
        '<div class="inventory-sales-summary-card ' + escapeHtml(toneClass || '') + '">' +
          '<div class="inventory-sales-summary-value"><span class="inventory-sales-summary-label">' + escapeHtml(String(summary.year)) + '</span><span class="inventory-sales-summary-text">' + escapeHtml(title) + '</span></div>' +
          '<div class="inventory-sales-summary-note inventory-sales-summary-lines">' +
            '<div class="inventory-sales-summary-line">' + revenueLine + '</div>' +
            '<div class="inventory-sales-summary-line">' + revenueNetLine + '</div>' +
            '<div class="inventory-sales-summary-line">' + estimatedNetLine + '</div>' +
            '<div class="inventory-sales-summary-line">' + estimatedGrossLine + '</div>' +
            '<div class="inventory-sales-summary-line">' + minLine + '</div>' +
            '<div class="inventory-sales-summary-line">' + maxLine + '</div>' +
            '<div class="inventory-sales-summary-line">' + avgLine + '</div>' +
            '<div class="inventory-sales-summary-line">' + avgValueLine + '</div>' +
            '<div class="inventory-sales-summary-line">' + avgValueNetLine + '</div>' +
          '</div>' +
        '</div>';
    }

    function destroySalesChart() {
      if (salesChartInstance && typeof salesChartInstance.destroy === 'function') {
        salesChartInstance.destroy();
      }

      salesChartInstance = null;
    }

    function renderSalesChart(months) {
      var canvas = document.getElementById('inventorySalesChartCanvas');
      if (!canvas || typeof Chart === 'undefined') {
        return;
      }

      destroySalesChart();

      var ctx = canvas.getContext('2d');
      var currentGradient = ctx.createLinearGradient(0, 0, 0, canvas.height || 220);
      currentGradient.addColorStop(0, 'rgba(62, 183, 125, 0.48)');
      currentGradient.addColorStop(0.5, 'rgba(62, 183, 125, 0.2)');
      currentGradient.addColorStop(1, 'rgba(62, 183, 125, 0.05)');
      var previousGradient = ctx.createLinearGradient(0, 0, 0, canvas.height || 220);
      previousGradient.addColorStop(0, 'rgba(66, 191, 220, 0.46)');
      previousGradient.addColorStop(0.5, 'rgba(66, 191, 220, 0.2)');
      previousGradient.addColorStop(1, 'rgba(66, 191, 220, 0.05)');
      var earliestGradient = ctx.createLinearGradient(0, 0, 0, canvas.height || 220);
      earliestGradient.addColorStop(0, 'rgba(224, 170, 40, 0.4)');
      earliestGradient.addColorStop(0.5, 'rgba(224, 170, 40, 0.16)');
      earliestGradient.addColorStop(1, 'rgba(224, 170, 40, 0.04)');

      salesChartInstance = new Chart(ctx, {
        type: 'line',
        data: {
          labels: months.map(function (item) {
            return formatSalesMonthShort(item.month_date || item.month);
          }),
          datasets: [{
            label: String(salesModalState.earliestYear || ''),
            data: months.map(function (item) {
              return Number(item.earliest_quantity || 0);
            }),
            borderColor: 'rgba(224, 170, 40, 0.96)',
            backgroundColor: earliestGradient,
            borderWidth: 2.25,
            fill: true,
            tension: 0.34,
            pointRadius: 2.75,
            pointHoverRadius: 4,
            pointBackgroundColor: '#ffffff',
            pointBorderColor: 'rgba(224, 170, 40, 0.96)',
            pointBorderWidth: 2.5,
            pointHoverBackgroundColor: '#ffffff',
            pointHoverBorderColor: 'rgba(255, 216, 128, 1)'
          }, {
            label: String(salesModalState.previousYear || ''),
            data: months.map(function (item) {
              return Number(item.previous_quantity || 0);
            }),
            borderColor: '#42bfdc',
            backgroundColor: previousGradient,
            borderWidth: 2.5,
            fill: true,
            tension: 0.34,
            pointRadius: 3,
            pointHoverRadius: 4,
            pointBackgroundColor: '#ffffff',
            pointBorderColor: '#42bfdc',
            pointBorderWidth: 3,
            pointHoverBackgroundColor: '#ffffff',
            pointHoverBorderColor: '#42bfdc'
          }, {
            label: String(salesModalState.selectedYear || ''),
            data: months.map(function (item) {
              return Number(item.quantity || 0);
            }),
            borderColor: '#3eb77d',
            backgroundColor: currentGradient,
            borderWidth: 3,
            fill: true,
            tension: 0.38,
            pointRadius: 3.5,
            pointHoverRadius: 4.5,
            pointBackgroundColor: '#ffffff',
            pointBorderColor: '#3eb77d',
            pointBorderWidth: 3,
            pointHoverBackgroundColor: '#ffffff',
            pointHoverBorderColor: '#3eb77d'
          }]
        },
        options: {
          responsive: true,
          maintainAspectRatio: false,
          animation: {
            duration: 380,
            easing: 'easeOutCubic'
          },
          interaction: {
            mode: 'index',
            intersect: false
          },
          plugins: {
            legend: {
              display: true,
              position: 'top',
              align: 'start',
              labels: {
                color: 'rgba(28, 63, 82, 0.78)',
                usePointStyle: true,
                pointStyle: 'circle',
                boxWidth: 10,
                boxHeight: 10,
                padding: 20,
                font: {
                  size: 13,
                  weight: '700'
                }
              }
            },
            tooltip: {
              displayColors: false,
              backgroundColor: 'rgba(255, 255, 255, 0.98)',
              titleColor: '#1b3b4d',
              bodyColor: '#35586b',
              borderColor: 'rgba(194, 214, 229, 0.9)',
              borderWidth: 1,
              padding: 12,
              callbacks: {
                title: function () {
                  return '';
                },
                labelTextColor: function (context) {
                  return context && context.dataset && context.dataset.borderColor ? context.dataset.borderColor : '#35586b';
                },
                label: function (context) {
                  var item = months[context.dataIndex] || {};
                  var datasetYear = context.datasetIndex === 0
                    ? salesModalState.earliestYear
                    : (context.datasetIndex === 1 ? salesModalState.previousYear : salesModalState.selectedYear);
                  var monthDate = context.datasetIndex === 2
                    ? (item.month_date || item.month || (String(datasetYear || '') + '-' + String(context.dataIndex + 1).padStart(2, '0') + '-01'))
                    : String(datasetYear || '') + '-' + String(context.dataIndex + 1).padStart(2, '0') + '-01';
                  var datasetValue = context.datasetIndex === 0
                    ? Number(item.earliest_value || 0)
                    : (context.datasetIndex === 1 ? Number(item.previous_value || 0) : Number(item.value || 0));

                  var revenueShortLabel = t('salesRevenueShort');
                  if (!revenueShortLabel || revenueShortLabel === 'sales value') {
                    revenueShortLabel = 'wartość sprzedaży (brutto)';
                  }

                  return [
                    formatSalesMonth(monthDate) + ': ' + String(context.parsed.y || 0) + ' ' + t('salesUnits'),
                    revenueShortLabel + ': ' + formatCurrencyAmount(datasetValue)
                  ];
                }
              }
            }
          },
          scales: {
            x: {
              grid: {
                color: 'rgba(188, 210, 225, 0.3)',
                drawTicks: false
              },
              border: {
                display: false
              },
              ticks: {
                color: 'rgba(70, 103, 123, 0.8)',
                maxRotation: 0,
                autoSkip: false,
                font: {
                  size: 10,
                  weight: '600'
                }
              }
            },
            y: {
              beginAtZero: true,
              grace: '10%',
              border: {
                display: false
              },
              grid: {
                color: 'rgba(188, 210, 225, 0.58)',
                drawTicks: false
              },
              ticks: {
                precision: 0,
                color: 'rgba(82, 113, 131, 0.78)',
                font: {
                  size: 9,
                  weight: '600'
                }
              }
            }
          }
        }
      });
    }

    function setSalesModalState(message, visible) {
      var state = document.getElementById('inventorySalesModalState');
      state.textContent = message || '';
      state.classList.toggle('is-visible', !!visible);
    }

    function setSalesModalContent(html, visible) {
      var content = document.getElementById('inventorySalesModalContent');
      content.innerHTML = html || '';
      content.classList.toggle('is-visible', !!visible);
    }

    function updateSalesModalNav() {
      var prev = document.querySelector('.inventory-sales-nav-prev');
      var next = document.querySelector('.inventory-sales-nav-next');
      if (!prev || !next) {
        return;
      }

      prev.classList.toggle('is-disabled', false);
      next.classList.toggle('is-disabled', salesModalState.offsetMonths <= 0);
    }

    function updateSalesModalHeading() {
      document.getElementById('inventorySalesModalTitle').textContent = salesModalState.productName || '';
      document.getElementById('inventorySalesModalSubtitle').textContent = salesModalState.combinationName || '';
    }

    function closeSalesModal() {
      var modal = document.getElementById('inventorySalesModal');
      var modalImage = document.getElementById('inventorySalesModalImage');
      var modalFallback = document.getElementById('inventorySalesModalImageFallback');
      document.getElementById('inventorySalesModalTitle').textContent = '';
      document.getElementById('inventorySalesModalSubtitle').textContent = '';
      destroySalesChart();
      modalImage.setAttribute('src', '');
      modalImage.classList.remove('is-hidden');
      modalFallback.classList.remove('is-visible');
      modal.classList.remove('is-open');
      modal.setAttribute('aria-hidden', 'true');
      setSalesModalState('', false);
      setSalesModalContent('', false);
    }

    function openSalesModal() {
      var modal = document.getElementById('inventorySalesModal');
      var modalImage = document.getElementById('inventorySalesModalImage');
      var modalFallback = document.getElementById('inventorySalesModalImageFallback');
      updateSalesModalHeading();
      if (salesModalState.imageSrc) {
        modalImage.setAttribute('src', salesModalState.imageSrc);
        modalImage.classList.remove('is-hidden');
        modalFallback.classList.remove('is-visible');
      } else {
        modalImage.setAttribute('src', '');
        modalImage.classList.add('is-hidden');
        modalFallback.classList.add('is-visible');
      }
      modal.classList.add('is-open');
      modal.setAttribute('aria-hidden', 'false');
      updateSalesModalNav();
      setSalesModalState(t('salesStatsLoading'), true);
      setSalesModalContent('', false);
    }

    function fetchSalesStats() {
      openSalesModal();

      $.post(window.prestashopInventoryConfig.ajaxUrl + '&action=GetSalesStats', {
        id_product: salesModalState.productId,
        id_product_attribute: salesModalState.productAttributeId,
        months: salesModalState.months,
        offset_months: salesModalState.offsetMonths
      }, null, 'json').done(function (resp) {
        if (!resp || !resp.ok || !resp.stats) {
          setSalesModalState(resp && resp.error ? resp.error : t('errorSalesStats'), true);
          setSalesModalContent('', false);
          return;
        }

        renderSalesStats(salesModalState.productName, resp.stats);
        updateSalesModalNav();
      }).fail(function (xhr) {
        var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : t('errorSalesStats');
        setSalesModalState(error, true);
        setSalesModalContent('', false);
      });
    }

    function renderSalesStats(productName, stats) {
      var months = stats && stats.months ? stats.months : [];
      var comparison = stats && stats.comparison ? stats.comparison : {};
      var rangeLabel = '—';
      var yearLabel = '—';

      if (!months.length) {
        setSalesModalState(t('salesStatsEmpty'), true);
        setSalesModalContent('', false);
        return;
      }

      salesModalState.selectedYear = Number(comparison.current_year || 0);
      salesModalState.previousYear = Number(comparison.previous_year || 0);
      salesModalState.earliestYear = Number(comparison.earliest_year || 0);
      rangeLabel = 'Porównanie roczne';
      yearLabel = String(comparison.current_year || '—') + ' / ' + String(comparison.previous_year || '—') + ' / ' + String(comparison.earliest_year || '—');
      var currentSummary = buildYearSummary(salesModalState.selectedYear, months.map(function (item) {
        return Number(item.quantity || 0);
      }), months.map(function (item) {
        return Number(item.value || 0);
      }), months.map(function (item) {
        return Number(item.value_net || 0);
      }));
      var previousSummary = buildYearSummary(salesModalState.previousYear, months.map(function (item) {
        return Number(item.previous_quantity || 0);
      }), months.map(function (item) {
        return Number(item.previous_value || 0);
      }), months.map(function (item) {
        return Number(item.previous_value_net || 0);
      }));
      var earliestSummary = buildYearSummary(salesModalState.earliestYear, months.map(function (item) {
        return Number(item.earliest_quantity || 0);
      }), months.map(function (item) {
        return Number(item.earliest_value || 0);
      }), months.map(function (item) {
        return Number(item.earliest_value_net || 0);
      }));

      var html = '' +
        '<div class="inventory-sales-summary">' +
          renderYearSummaryCard(earliestSummary, 'is-earliest') +
          renderYearSummaryCard(previousSummary, 'is-previous') +
          renderYearSummaryCard(currentSummary, 'is-current') +
        '</div>' +
        '<div class="inventory-sales-chart">' +
          '<div class="inventory-sales-chart-layout">' +
            '<button type="button" class="inventory-sales-nav inventory-sales-nav-prev" aria-label="' + escapeHtml(t('previousYear')) + '" title="' + escapeHtml(t('previousYear')) + '">' +
              '<span aria-hidden="true">&#8249;</span>' +
            '</button>' +
            '<div class="inventory-sales-chart-panel">' +
              '<div class="inventory-sales-chart-meta">' +
                '<div class="inventory-sales-chart-range">' + escapeHtml(rangeLabel) + '</div>' +
                '<div class="inventory-sales-chart-year">' + escapeHtml(yearLabel) + '</div>' +
              '</div>' +
              '<div class="inventory-sales-chart-surface">' +
                '<div class="inventory-sales-chart-canvas"><canvas id="inventorySalesChartCanvas"></canvas></div>' +
                '<div class="inventory-sales-chart-footnote">' + escapeHtml(productName) + '</div>' +
              '</div>' +
            '</div>' +
            '<button type="button" class="inventory-sales-nav inventory-sales-nav-next" aria-label="' + escapeHtml(t('nextYear')) + '" title="' + escapeHtml(t('nextYear')) + '">' +
              '<span aria-hidden="true">&#8250;</span>' +
            '</button>' +
          '</div>' +
        '</div>';

      updateSalesModalHeading();
      setSalesModalState('', false);
      setSalesModalContent(html, true);
      renderSalesChart(months);
    }

    function checkForUpdates() {
      if (!window.prestashopInventoryConfig.updateConfigured) {
        updateButtonVisibility('');
        return;
      }

      setUpdateStatus(t('updateCheckingMessage'), false);

      $.post(window.prestashopInventoryConfig.ajaxUrl + '&action=CheckForUpdates', {}, null, 'json').done(function (resp) {
        var status = resp && resp.ok ? (resp.status || {}) : null;
        if (!status || !status.configured) {
          updateButtonVisibility('');
          setUpdateStatus('', false);
          return;
        }

        if (status.available && status.version) {
          updateButtonVisibility(String(status.version));
          setUpdateStatus('', false);
          return;
        }

        updateButtonVisibility('');
        setUpdateStatus('', false);
      }).fail(function (xhr) {
        var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : t('updateCheckErrorMessage');
        updateButtonVisibility('');
        setUpdateStatus(error, true);
      });
    }

    function installUpdate() {
      var button = document.getElementById('inventoryUpdateButton');
      if (!button || button.hidden) {
        return;
      }

      button.disabled = true;
      setUpdateStatus(t('updateInstallingMessage'), false);

      $.post(window.prestashopInventoryConfig.ajaxUrl + '&action=InstallUpdate', {}, null, 'json').done(function (resp) {
        var message = resp && resp.message ? resp.message : t('updateInstalledMessage');
        setUpdateStatus(message, false);
        updateButtonVisibility('');
        window.setTimeout(function () {
          window.location.reload();
        }, 1200);
      }).fail(function (xhr) {
        var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : t('updateInstallErrorMessage');
        setUpdateStatus(error, true);
        button.disabled = false;
      });
    }

    $(document).ready(function () {
      var savedQuery = localStorage.getItem(LS_QUERY) || '';
      var savedActiveOnly = localStorage.getItem(LS_ACTIVE_ONLY) === '1';
      var savedOnly = localStorage.getItem(LS_ONLY) === '1';
      var savedMissingPurchaseOnly = localStorage.getItem(LS_MISSING_PURCHASE) === '1';
      var savedShowWeight = localStorage.getItem(LS_SHOW_WEIGHT) !== '0';
      var savedMissingWeightOnly = localStorage.getItem(LS_MISSING_WEIGHT) === '1';
      var savedBrutto = localStorage.getItem(LS_BRUTTO) !== '0';
      marketplaceSettingsState.marketplaceMarkup = normalizePercentValue(localStorage.getItem(LS_MARKETPLACE_MARKUP), 20);
      marketplaceSettingsState.marketplaceCommission = normalizePercentValue(localStorage.getItem(LS_MARKETPLACE_COMMISSION), 10);

      applyLanguage();
      syncMarketplaceSettingsUi();
      renderSortState();

      setSearchKeywords(parseKeywords(savedQuery));
      $('#activeOnly').prop('checked', savedActiveOnly);
      $('#onlyAvailable').prop('checked', savedOnly);
      $('#missingPurchasePriceOnly').prop('checked', savedMissingPurchaseOnly);
      $('#showWeight').prop('checked', savedShowWeight);
      $('#missingWeightOnly').prop('checked', savedMissingWeightOnly);
      $('#showBrutto').prop('checked', savedBrutto);
      updateFilterBadge();
      toggleWeightColumns(savedShowWeight, false);
      toggleBruttoColumns(savedBrutto, false);
      $('.inventory-sales-modal-close').attr('aria-label', t('close'));

      if (window.prestashopInventoryConfig.updateConfigured) {
        checkForUpdates();
      }

      $('#searchBox').on('click', function () {
        $('#searchInput').trigger('focus');
      });

      $('#searchInput').on('keydown', function (e) {
        if (e.key === 'Enter') {
          e.preventDefault();
          appendKeywordsFromInput();
          return;
        }

        if (e.key === 'Backspace' && !this.value) {
          var keywords = getSearchKeywords();
          if (keywords.length) {
            keywords.pop();
            persistAndLoadKeywords(keywords);
          }
        }
      });

      $('#activeOnly').on('change', function () {
        localStorage.setItem(LS_ACTIVE_ONLY, this.checked ? '1' : '0');
        updateFilterBadge();
        currentPage = 1;
        localStorage.setItem(LS_PAGE, String(currentPage));
        loadTable(getSearchQuery(), this.checked, $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
      });

      $('#onlyAvailable').on('change', function () {
        localStorage.setItem(LS_ONLY, this.checked ? '1' : '0');
        updateFilterBadge();
        currentPage = 1;
        localStorage.setItem(LS_PAGE, String(currentPage));
        loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), this.checked, $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
      });

      $('#missingPurchasePriceOnly').on('change', function () {
        localStorage.setItem(LS_MISSING_PURCHASE, this.checked ? '1' : '0');
        updateFilterBadge();
        currentPage = 1;
        localStorage.setItem(LS_PAGE, String(currentPage));
        loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), this.checked, $('#missingWeightOnly').is(':checked'));
      });

      $('#showWeight').on('change', function () {
        localStorage.setItem(LS_SHOW_WEIGHT, this.checked ? '1' : '0');
        updateFilterBadge();
        toggleWeightColumns(this.checked);
      });

      $('#missingWeightOnly').on('change', function () {
        localStorage.setItem(LS_MISSING_WEIGHT, this.checked ? '1' : '0');
        updateFilterBadge();
        currentPage = 1;
        localStorage.setItem(LS_PAGE, String(currentPage));
        loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), this.checked);
      });

      $('#showBrutto').on('change', function () {
        localStorage.setItem(LS_BRUTTO, this.checked ? '1' : '0');
        updateFilterBadge();
        toggleBruttoColumns(this.checked);
      });

      $(document).on('click', '.inventory-sortable .inventory-sort-button', function () {
        var field = $(this).closest('.inventory-sortable').data('sort-field');
        if (!field) {
          return;
        }

        if (currentSortField === field) {
          currentSortDir = currentSortDir === 'ASC' ? 'DESC' : 'ASC';
        } else {
          currentSortField = field;
          currentSortDir = 'ASC';
        }

        localStorage.setItem(LS_SORT_FIELD, currentSortField);
        localStorage.setItem(LS_SORT_DIR, currentSortDir);
        renderSortState();
        loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
      });

      $(document).on('keydown', '.inventory-sortable .inventory-sort-button', function (event) {
        if (event.key !== 'Enter' && event.key !== ' ') {
          return;
        }

        event.preventDefault();
        $(this).trigger('click');
      });

      $(document).on('click', '.inventory-tag-remove', function () {
        var keywords = getSearchKeywords();
        var index = Number($(this).attr('data-index'));
        keywords.splice(index, 1);
        persistAndLoadKeywords(keywords);
      });

      $('#clearSearch').on('click', function () {
        $('#searchInput').val('');
        setSearchKeywords([]);
        localStorage.setItem(LS_QUERY, '');
        updateFilterBadge();
        currentPage = 1;
        localStorage.setItem(LS_PAGE, String(currentPage));
        loadTable('', $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
      });

      $('#btnPdf').on('click', function () {
        appendKeywordsFromInput();
        var q = getSearchQuery();
        var activeOnly = $('#activeOnly').is(':checked') ? '1' : '0';
        var only = $('#onlyAvailable').is(':checked') ? '1' : '0';
        var missingPurchasePriceOnly = $('#missingPurchasePriceOnly').is(':checked') ? '1' : '0';
        var showWeight = $('#showWeight').is(':checked') ? '1' : '0';
        var missingWeightOnly = $('#missingWeightOnly').is(':checked') ? '1' : '0';
        var showBrutto = $('#showBrutto').is(':checked') ? '1' : '0';
        window.location.href = window.prestashopInventoryConfig.exportUrl + '&lang=' + encodeURIComponent(window.prestashopInventoryConfig.languageIso || 'en') + '&activeOnly=' + encodeURIComponent(activeOnly) + '&onlyAvailable=' + encodeURIComponent(only) + '&missingPurchasePriceOnly=' + encodeURIComponent(missingPurchasePriceOnly) + '&showWeight=' + encodeURIComponent(showWeight) + '&missingWeightOnly=' + encodeURIComponent(missingWeightOnly) + '&showBrutto=' + encodeURIComponent(showBrutto) + '&query=' + encodeURIComponent(q);
      });

      $('#inventoryUpdateButton').on('click', function () {
        installUpdate();
      });

      function closeInlineEditor($td) {
        $td.find('.price-editor, .qty-editor, .weight-editor').remove();
        $td.find('.editable-price, .editable-retail-price, .editable-quantity, .editable-weight').show();
      }

      function closeMarketplaceSettingEditor($container) {
        $container.find('.marketplace-setting-editor').remove();
        $container.find('.editable-marketplace-setting').show();
      }

      function focusEditorInput($td, selector) {
        window.setTimeout(function () {
          var $input = $td.find(selector).first();
          if ($input.length) {
            $input.trigger('focus');
            $input.select();
          }
        }, 0);
      }

      function startInlineEditor($el, editorClass, inputHtml) {
        var $td = $el.closest('td');
        if ($td.find('.price-editor, .qty-editor, .weight-editor').length) {
          return;
        }

        $el.hide().after('<div class="' + editorClass + ' inline-editor">' + inputHtml + '</div>');
      }

      function startMarketplaceSettingEditor($el) {
        var $container = $el.closest('.inventory-marketplace-setting');
        if ($container.find('.marketplace-setting-editor').length) {
          return;
        }

        $el.hide().after('<div class="marketplace-setting-editor inline-editor"><input type="text" class="form-control input-sm marketplace-setting-input inline-editor-input" placeholder="' + t('enterPercentage') + '" value="' + (($el.data('current-value') || '').toString()) + '"></div>');
        focusEditorInput($container, '.marketplace-setting-input');
      }

      function submitMarketplaceSetting($input) {
        var $container = $input.closest('.inventory-marketplace-setting');
        var $editor = $input.closest('.marketplace-setting-editor');
        var $el = $container.find('.editable-marketplace-setting');
        var settingKey = String($el.data('setting-key') || '');
        var value = normalizePercentValue($input.val(), NaN);

        if (!isFinite(value)) {
          alert(t('typePercentage'));
          focusEditorInput($container, '.marketplace-setting-input');
          return;
        }

        if (settingKey === 'marketplaceMarkup') {
          marketplaceSettingsState.marketplaceMarkup = value;
          localStorage.setItem(LS_MARKETPLACE_MARKUP, String(value));
        } else if (settingKey === 'marketplaceCommission') {
          marketplaceSettingsState.marketplaceCommission = value;
          localStorage.setItem(LS_MARKETPLACE_COMMISSION, String(value));
        }

        closeMarketplaceSettingEditor($container);
        if ($('#inventoryProfitModal').hasClass('is-open')) {
          renderProfitabilityModal();
        } else {
          syncMarketplaceSettingsUi();
          refreshCalculatedMetrics();
        }
      }

      function submitPrice($input, isRetail) {
        var $td = $input.closest('td');
        var $editor = $input.closest('.price-editor');
        var $el = $td.find(isRetail ? '.editable-retail-price' : '.editable-price');
        var priceVal = $input.val().trim();

        if ($editor.data('isSubmitting')) {
          return;
        }

        if (!priceVal) {
          alert(t('typePrice'));
          focusEditorInput($td, '.price-input');
          return;
        }

        $editor.data('isSubmitting', true);
        $input.prop('disabled', true);

        $.post(window.prestashopInventoryConfig.ajaxUrl + '&action=' + (isRetail ? 'SaveRetailPrice' : 'SavePrice'), {
          id_product: $el.data('id-product'),
          id_product_attribute: $el.data('id-attr'),
          price: priceVal
        }, null, 'json').done(function (resp) {
          if (!resp || !resp.ok) {
            alert(resp && resp.error ? resp.error : t('errorSave'));
            $editor.data('isSubmitting', false);
            $input.prop('disabled', false);
            focusEditorInput($td, '.price-input');
            return;
          }

          var priceNumber = Number(resp.price || 0);
          $el.text(priceNumber.toFixed(2).replace('.', ',') + ' zł').removeClass('text-danger').attr('data-current-price', priceNumber.toFixed(2));
          closeInlineEditor($td);
          loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
        }).fail(function (xhr) {
          var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : t('errorNetwork');
          alert(error);
          $editor.data('isSubmitting', false);
          $input.prop('disabled', false);
          focusEditorInput($td, '.price-input');
        });
      }

      function submitQuantity($input) {
        var $td = $input.closest('td');
        var $editor = $input.closest('.qty-editor');
        var $el = $td.find('.editable-quantity');
        var quantityVal = $input.val().trim();

        if ($editor.data('isSubmitting')) {
          return;
        }

        if (!/^-?\d+$/.test(quantityVal)) {
          alert(t('typeQty'));
          focusEditorInput($td, '.qty-input');
          return;
        }

        $editor.data('isSubmitting', true);
        $input.prop('disabled', true);

        $.post(window.prestashopInventoryConfig.ajaxUrl + '&action=SaveQuantity', {
          id_product: $el.data('id-product'),
          id_product_attribute: $el.data('id-attr'),
          quantity: quantityVal
        }, null, 'json').done(function (resp) {
          if (!resp || !resp.ok) {
            alert(resp && resp.error ? resp.error : t('errorQtySave'));
            $editor.data('isSubmitting', false);
            $input.prop('disabled', false);
            focusEditorInput($td, '.qty-input');
            return;
          }

          var quantityNumber = parseInt(resp.quantity, 10) || 0;
          $el.text(String(quantityNumber)).attr('data-current-qty', String(quantityNumber));
          closeInlineEditor($td);
          loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
        }).fail(function (xhr) {
          var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : t('errorQtySave');
          alert(error);
          $editor.data('isSubmitting', false);
          $input.prop('disabled', false);
          focusEditorInput($td, '.qty-input');
        });
      }

      function submitWeight($input) {
        var $td = $input.closest('td');
        var $editor = $input.closest('.weight-editor');
        var $el = $td.find('.editable-weight');
        var weightVal = $input.val().trim();

        if ($editor.data('isSubmitting')) {
          return;
        }

        if (!weightVal || isNaN(Number(weightVal)) || Number(weightVal) < 0) {
          alert(t('typeWeight'));
          focusEditorInput($td, '.weight-input');
          return;
        }

        $editor.data('isSubmitting', true);
        $input.prop('disabled', true);

        $.post(window.prestashopInventoryConfig.ajaxUrl + '&action=SaveWeight', {
          id_product: $el.data('id-product'),
          id_product_attribute: $el.data('id-attr'),
          weight: weightVal
        }, null, 'json').done(function (resp) {
          if (!resp || !resp.ok) {
            alert(resp && resp.error ? resp.error : t('errorWeightSave'));
            $editor.data('isSubmitting', false);
            $input.prop('disabled', false);
            focusEditorInput($td, '.weight-input');
            return;
          }

          var weightNumber = Number(resp.weight || 0);
          var weightText = weightNumber > 0 ? weightNumber.toFixed(3).replace('.', ',') + ' kg' : '—';
          $el.text(weightText).attr('data-current-weight', weightNumber.toFixed(3)).toggleClass('text-danger', weightNumber <= 0);
          closeInlineEditor($td);
          loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
        }).fail(function (xhr) {
          var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : t('errorWeightSave');
          alert(error);
          $editor.data('isSubmitting', false);
          $input.prop('disabled', false);
          focusEditorInput($td, '.weight-input');
        });
      }

      function submitInlineEditor($input) {
        if ($input.hasClass('marketplace-setting-input')) {
          submitMarketplaceSetting($input);
          return;
        }

        if ($input.hasClass('qty-input')) {
          submitQuantity($input);
          return;
        }

        if ($input.hasClass('weight-input')) {
          submitWeight($input);
          return;
        }

        submitPrice($input, $input.closest('td').find('.editable-retail-price:hidden').length > 0);
      }

      $(document).on('click', '.editable-price', function () {
        if (!window.prestashopInventoryConfig.canEdit) {
          return;
        }

        var $el = $(this);
        startInlineEditor($el, 'price-editor', '<input type="text" class="form-control input-sm price-input inline-editor-input" placeholder="' + t('enterPrice') + '" value="' + (($el.data('current-price') || '').toString()) + '">');
        focusEditorInput($el.closest('td'), '.price-input');
      });

      $(document).on('click', '.editable-retail-price', function () {
        if (!window.prestashopInventoryConfig.canEdit) {
          return;
        }

        var $el = $(this);
        startInlineEditor($el, 'price-editor', '<input type="text" class="form-control input-sm price-input inline-editor-input" placeholder="' + t('enterRetailPrice') + '" value="' + (($el.data('current-price') || '').toString()) + '">');
        focusEditorInput($el.closest('td'), '.price-input');
      });

      $(document).on('click', '.editable-quantity', function () {
        if (!window.prestashopInventoryConfig.canEdit) {
          return;
        }

        var $el = $(this);
        startInlineEditor($el, 'qty-editor', '<input type="number" step="1" class="form-control input-sm qty-input inline-editor-input" placeholder="' + t('enterQty') + '" value="' + (($el.data('current-qty') || '').toString()) + '">');
        focusEditorInput($el.closest('td'), '.qty-input');
      });

      $(document).on('click', '.editable-weight', function () {
        if (!window.prestashopInventoryConfig.canEdit) {
          return;
        }

        var $el = $(this);
        startInlineEditor($el, 'weight-editor', '<input type="number" step="0.001" min="0" class="form-control input-sm weight-input inline-editor-input" placeholder="' + t('enterWeight') + '" value="' + (($el.data('current-weight') || '').toString()) + '">');
        focusEditorInput($el.closest('td'), '.weight-input');
      });

      $(document).on('click', '.editable-marketplace-setting', function () {
        var $el = $(this);
        startMarketplaceSettingEditor($el);
      });

      $(document).on('keydown', '.price-input, .qty-input, .weight-input, .marketplace-setting-input', function (e) {
        if (e.key === 'Enter') {
          e.preventDefault();
          $(this).data('skipBlurSubmit', true);
          submitInlineEditor($(this));
          return;
        }

        if (e.key === 'Escape') {
          e.preventDefault();
          $(this).data('skipBlurSubmit', true);
          closeInlineEditor($(this).closest('td'));
          closeMarketplaceSettingEditor($(this).closest('.inventory-marketplace-setting'));
        }
      });

      $(document).on('blur', '.price-input, .qty-input, .weight-input, .marketplace-setting-input', function () {
        var $input = $(this);

        if ($input.data('skipBlurSubmit')) {
          $input.removeData('skipBlurSubmit');
          return;
        }

        window.setTimeout(function () {
          if (!$input.closest('body').length || !$input.is(':visible')) {
            return;
          }

          submitInlineEditor($input);
        }, 0);
      });

      $(document).on('change', '.toggle-product-active', function () {
        var radio = this;
        var $radio = $(radio);
        var switchName = $radio.attr('name');
        var $group = $('input[name="' + switchName + '"]');
        var nextValue = Number($radio.val()) === 1 ? 1 : 0;
        var previousValue = nextValue === 1 ? 0 : 1;

        if (!window.prestashopInventoryConfig.canEdit) {
          $group.filter('[value="' + String(previousValue) + '"]').prop('checked', true);
          return;
        }

        $group.prop('disabled', true);

        $.post(window.prestashopInventoryConfig.ajaxUrl + '&action=ToggleProductActive', {
          id_product: $radio.data('id-product'),
          active: nextValue
        }, null, 'json').done(function (resp) {
          if (!resp || !resp.ok) {
            $group.filter('[value="' + String(previousValue) + '"]').prop('checked', true);
            alert(resp && resp.error ? resp.error : t('errorToggle'));
          } else {
            $group.filter('[value="' + String(Number(resp.active) === 1 ? 1 : 0) + '"]').prop('checked', true);
          }
        }).fail(function (xhr) {
          $group.filter('[value="' + String(previousValue) + '"]').prop('checked', true);
          var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : t('errorToggle');
          alert(error);
        }).always(function () {
          $group.prop('disabled', false);
        });
      });

      $(document).on('click', '.copy-ean-btn', function () {
        var button = this;
        var $button = $(button);
        var ean = String($button.data('ean') || '');
        var originalText = $button.text();

        copyTextToClipboard(ean).then(function () {
          $button.addClass('is-copied').text(t('copied'));
          window.setTimeout(function () {
            $button.removeClass('is-copied').text(originalText);
          }, 900);
        }).catch(function () {
          alert(t('copyError'));
        });
      });

      $(document).on('click', '.inventory-sales-trigger', function (e) {
        e.preventDefault();
        e.stopPropagation();

        var $button = $(this);
        salesModalState.productId = parseInt($button.data('id-product') || '0', 10);
        salesModalState.productAttributeId = parseInt($button.data('id-attr') || '0', 10);
        salesModalState.productName = String($button.data('product-name') || t('salesStatsTitle'));
        salesModalState.combinationName = String($button.data('combination-name') || '');
        salesModalState.imageSrc = String($button.data('image-src') || '');
        salesModalState.cost = Number($button.data('cost') || 0);
        salesModalState.costGross = Number($button.data('cost-gross') || 0);
        salesModalState.retailNet = Number($button.data('retail-net') || 0);
        salesModalState.retail = Number($button.data('retail') || 0);
        salesModalState.months = 12;
        salesModalState.offsetMonths = 0;

        fetchSalesStats();
      });

      $(document).on('click', '.inventory-profit-trigger', function (e) {
        e.preventDefault();
        e.stopPropagation();

        var $button = $(this);
        profitModalState.productName = String($button.data('product-name') || t('profitability'));
        profitModalState.combinationName = String($button.data('combination-name') || '');
        profitModalState.imageSrc = String($button.data('image-src') || '');
        profitModalState.cost = Number($button.data('cost') || 0);
        profitModalState.costGross = Number($button.data('cost-gross') || 0);
        profitModalState.retailNet = Number($button.data('retail-net') || 0);
        profitModalState.retail = Number($button.data('retail') || 0);
        openProfitModal();
      });

      $(document).on('click', '.inventory-sales-nav-prev', function () {
        salesModalState.offsetMonths += 12;
        fetchSalesStats();
      });

      $(document).on('click', '.inventory-sales-nav-next', function () {
        if (salesModalState.offsetMonths <= 0) {
          return;
        }

        salesModalState.offsetMonths = Math.max(0, salesModalState.offsetMonths - 12);
        fetchSalesStats();
      });

      $(document).on('click', '.inventory-sales-modal-close, .inventory-sales-modal-backdrop', function () {
        if ($(this).closest('#inventoryProfitModal').length) {
          closeProfitModal();
          return;
        }

        closeSalesModal();
      });

      $(document).on('keydown', function (e) {
        if (e.key === 'Escape' && $('#inventorySalesModal').hasClass('is-open')) {
          closeSalesModal();
        }

        if (e.key === 'Escape' && $('#inventoryProfitModal').hasClass('is-open')) {
          closeProfitModal();
        }
      });

      $(document).on('click', '.inventory-actions-toggle', function (e) {
        e.preventDefault();
        e.stopPropagation();

        var $menu = $(this).closest('.inventory-actions-menu');
        $('.inventory-actions-menu').not($menu).removeClass('is-open').find('.inventory-actions-toggle').attr('aria-expanded', 'false');
        $menu.toggleClass('is-open');
        $(this).attr('aria-expanded', $menu.hasClass('is-open') ? 'true' : 'false');
      });

      $(document).on('click', function () {
        $('.inventory-actions-menu').removeClass('is-open').find('.inventory-actions-toggle').attr('aria-expanded', 'false');
      });

      $(document).on('click', '.inventory-actions-dropdown', function (e) {
        e.stopPropagation();
      });

      $(document).on('click', '.inventory-hide-product', function () {
        if (!window.prestashopInventoryConfig.canEdit) {
          return;
        }

        var $btn = $(this);
        var idProduct = parseInt($btn.data('id-product') || '0', 10);
        if (!idProduct) {
          return;
        }

        $btn.prop('disabled', true);

        $.post(window.prestashopInventoryConfig.ajaxUrl + '&action=HideProduct', {
          id_product: idProduct
        }, null, 'json').done(function (resp) {
          if (!resp || !resp.ok) {
            alert(resp && resp.error ? resp.error : t('errorHide'));
            $btn.prop('disabled', false);
            return;
          }

          loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
        }).fail(function (xhr) {
          var error = xhr.responseJSON && xhr.responseJSON.error ? xhr.responseJSON.error : t('errorHide');
          alert(error);
          $btn.prop('disabled', false);
        });
      });

      $(document).on('click', '.inventory-page-edge, .inventory-page-nav', function () {
        if (this.disabled) {
          return;
        }

        var page = parseInt($(this).attr('data-page') || '1', 10);
        currentPage = page > 0 ? page : 1;
        localStorage.setItem(LS_PAGE, String(currentPage));
        loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
      });

      $(document).on('change', '.inventory-per-page-select', function () {
        var perPage = parseInt(this.value || '20', 10);
        currentPerPage = [20, 50, 100, 200].indexOf(perPage) !== -1 ? perPage : 20;
        currentPage = 1;
        localStorage.setItem(LS_PER_PAGE, String(currentPerPage));
        localStorage.setItem(LS_PAGE, String(currentPage));
        loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
      });

      function applyCurrentPageInput(input) {
        var min = parseInt(input.getAttribute('min') || '1', 10);
        var max = parseInt(input.getAttribute('max') || '1', 10);
        var page = parseInt(input.value || String(currentPage), 10);

        if (isNaN(page)) {
          page = currentPage;
        }

        page = Math.max(min, Math.min(max, page));
        input.value = String(page);

        if (page === currentPage) {
          return;
        }

        currentPage = page;
        localStorage.setItem(LS_PAGE, String(currentPage));
        loadTable(getSearchQuery(), $('#activeOnly').is(':checked'), $('#onlyAvailable').is(':checked'), $('#missingPurchasePriceOnly').is(':checked'), $('#missingWeightOnly').is(':checked'));
      }

      $(document).on('keydown', '.inventory-page-current', function (e) {
        if (e.key === 'Enter') {
          e.preventDefault();
          applyCurrentPageInput(this);
        }
      });

      $(document).on('change', '.inventory-page-current', function () {
        applyCurrentPageInput(this);
      });

      if (window.prestashopInventoryConfig.licenseValid) {
        loadTable(getSearchQuery(), savedActiveOnly, savedOnly, savedMissingPurchaseOnly, savedMissingWeightOnly);
      }
    });
  })();
</script>
