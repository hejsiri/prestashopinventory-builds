<?php

require_once __DIR__ . '/PrestashopInventoryI18n.php';

class PrestashopInventoryService
{
    public const CONFIG_IGNORED_IDS = 'PSINV_IGNORED_PRODUCT_IDS';
    private const SORT_FIELD_MAP = [
        'id_product' => 'id_product',
        'product_name' => 'product_name',
        'active' => 'active',
        'weight' => 'product_weight',
        'purchase_price' => 'product_cost',
        'retail_price' => 'product_price_brutto',
        'quantity' => 'stock_quantity',
    ];

    private string $modulePath;
    private Context $context;
    private Module $module;
    private ?PDO $pdo = null;

    public function __construct(string $modulePath, Context $context, Module $module)
    {
        $this->modulePath = rtrim($modulePath, '/') . '/';
        $this->context = $context;
        $this->module = $module;
    }

    public function renderProductsTable(array $filters): array
    {
        $showBrutto = $this->toBool($filters['showBrutto'] ?? true, true);
        $showWeight = $this->toBool($filters['showWeight'] ?? true, true);
        $page = $this->normalizePage($filters['page'] ?? 1);
        $perPage = $this->normalizePerPage($filters['per_page'] ?? 20);
        $result = $this->fetchProductsPage($filters, $page, $perPage);
        $products = $result['items'];

        $output = '';

        if ($products) {
            foreach ($products as $product) {
                $idProduct = (int) $product['id_product'];
                $idAttr = (int) $product['id_product_attribute'];
                $isActive = (bool) $product['active'];
                $cost = (float) $product['product_cost'];
                $taxRate = (float) ($product['tax_rate'] ?? 0);
                $costBrutto = $cost * (1 + ($taxRate / 100));
                $priceNetto = (float) ($product['product_price_netto'] ?? 0);
                $priceBrutto = (float) $product['product_price_brutto'];
                $weight = (float) $product['product_weight'];
                $qty = (float) $product['stock_quantity'];
                $valueNetto = ($cost > 0) ? ($cost * $qty) : 0.0;
                $valueBrutto = ($priceBrutto > 0) ? ($priceBrutto * $qty) : 0.0;

                $output .= '<tr>';
                $output .= '<td class="inventory-col-id">' . $idProduct . '</td>';
                $output .= '<td class="inventory-col-image">';

                $imgId = !empty($product['combination_image_id']) ? (int) $product['combination_image_id'] : (int) $product['product_image_id'];
                if ($imgId > 0) {
                    $imagePath = htmlspecialchars($this->getImagePath($imgId), ENT_QUOTES, 'UTF-8');
                    $output .= '<span class="product-preview" tabindex="0">';
                    $output .= '<img src="' . $imagePath . '" alt="" class="img-thumbnail">';
                    $output .= '<span class="product-preview-card">';
                    if ($idAttr > 0) {
                        $output .= '<span class="product-preview-title">' . htmlspecialchars($this->t('combination_id', ['id' => $idAttr]), ENT_QUOTES, 'UTF-8') . '</span>';
                    }
                    $output .= '<img src="' . $imagePath . '" alt="" class="product-preview-image">';
                    $output .= '</span>';
                    $output .= '</span>';
                } else {
                    $output .= '<span class="inventory-no-image">' . htmlspecialchars($this->t('no_image'), ENT_QUOTES, 'UTF-8') . '</span>';
                }
                $output .= '</td>';

                $ean = $product['combination_ean13'] ?: $product['product_ean13'];
                $productEditUrl = htmlspecialchars($this->getProductEditUrl($idProduct), ENT_QUOTES, 'UTF-8');

                $output .= '<td class="inventory-col-name">';
                $output .= '<div class="inventory-product-name"><a class="inventory-product-link" href="' . $productEditUrl . '">' . htmlspecialchars((string) $product['product_name'], ENT_QUOTES, 'UTF-8') . '</a></div>';
                if (!empty($ean)) {
                    $output .= '<button type="button" class="inventory-product-ean copy-ean-btn" data-ean="' . htmlspecialchars((string) $ean, ENT_QUOTES, 'UTF-8') . '">' . htmlspecialchars((string) $ean, ENT_QUOTES, 'UTF-8') . '</button>';
                }
                if (!empty($product['combination_name'])) {
                    $output .= '<div class="inventory-product-meta">' . htmlspecialchars((string) $product['combination_name'], ENT_QUOTES, 'UTF-8') . '</div>';
                }
                $output .= '</td>';

                $output .= '<td class="inventory-col-active text-center">';
                $output .= '<label class="inventory-row-switch">';
                $output .= '<input type="checkbox" class="toggle-product-active" data-id-product="' . $idProduct . '"' . ($isActive ? ' checked' : '') . '>';
                $output .= '<span class="inventory-row-slider"></span>';
                $output .= '</label>';
                $output .= '</td>';

                if ($showWeight) {
                    $output .= '<td class="inventory-col-weight text-center">';
                    $weightLabel = htmlspecialchars($this->formatWeight($weight), ENT_QUOTES, 'UTF-8');
                    $weightData = htmlspecialchars(number_format($weight, 3, '.', ''), ENT_QUOTES, 'UTF-8');
                    $weightClass = $weight > 0 ? 'editable-weight' : 'editable-weight text-danger';
                    $output .= '<span class="' . $weightClass . '" style="cursor:pointer; text-decoration: underline dotted;" data-id-product="' . $idProduct . '" data-id-attr="' . $idAttr . '" data-current-weight="' . $weightData . '">' . $weightLabel . '</span>';
                    $output .= '</td>';
                }

                $output .= '<td class="inventory-col-price text-center">';
                if ($cost > 0) {
                    $label = $this->formatMoney($cost);
                    $class = 'editable-price';
                    $dataPrice = number_format($cost, 2, '.', '');
                } else {
                    $label = $this->t('no_data');
                    $class = 'editable-price text-danger';
                    $dataPrice = '';
                }

                $output .= '<span class="' . $class . '" style="cursor:pointer; text-decoration: underline dotted;" data-id-product="' . $idProduct . '" data-id-attr="' . $idAttr . '" data-current-price="' . htmlspecialchars($dataPrice, ENT_QUOTES, 'UTF-8') . '">' . htmlspecialchars($label, ENT_QUOTES, 'UTF-8') . '</span>';
                $output .= '</td>';

                if ($showBrutto) {
                    $output .= '<td class="inventory-col-price text-center">';
                    if ($priceBrutto > 0) {
                        $grossLabel = $this->formatMoney($priceBrutto);
                        $grossClass = 'editable-retail-price';
                        $grossDataPrice = number_format($priceBrutto, 2, '.', '');
                    } else {
                        $grossLabel = $this->t('no_data');
                        $grossClass = 'editable-retail-price text-danger';
                        $grossDataPrice = '';
                    }

                    $output .= '<span class="' . $grossClass . '" style="cursor:pointer; text-decoration: underline dotted;" data-id-product="' . $idProduct . '" data-id-attr="' . $idAttr . '" data-current-price="' . htmlspecialchars($grossDataPrice, ENT_QUOTES, 'UTF-8') . '">' . htmlspecialchars($grossLabel, ENT_QUOTES, 'UTF-8') . '</span>';
                    $output .= '</td>';
                }

                $output .= '<td class="inventory-col-qty text-center">';
                $output .= '<span class="editable-quantity" style="cursor:pointer; text-decoration: underline dotted;" data-id-product="' . $idProduct . '" data-id-attr="' . $idAttr . '" data-current-qty="' . (int) $qty . '">' . (int) $qty . '</span>';
                $output .= '</td>';
                $output .= '<td class="inventory-col-value text-center">' . $this->formatMoney($valueNetto > 0 ? $valueNetto : 0.0) . '</td>';

                if ($showBrutto) {
                    $output .= '<td class="inventory-col-value text-center">' . $this->formatMoney($valueBrutto > 0 ? $valueBrutto : 0.0) . '</td>';
                }

                $salesProductName = (string) $product['product_name'];
                $salesCombinationName = (string) ($product['combination_name'] ?? '');
                $output .= '<td class="inventory-col-actions text-center">';
                $output .= '<div class="inventory-row-actions">';
                $output .= '<button type="button" class="inventory-sales-trigger" data-id-product="' . $idProduct . '" data-id-attr="' . $idAttr . '" data-product-name="' . htmlspecialchars($salesProductName, ENT_QUOTES, 'UTF-8') . '" data-combination-name="' . htmlspecialchars($salesCombinationName, ENT_QUOTES, 'UTF-8') . '" data-image-src="' . ($imgId > 0 ? htmlspecialchars($this->getImagePath($imgId), ENT_QUOTES, 'UTF-8') : '') . '" data-cost="' . htmlspecialchars(number_format($cost, 2, '.', ''), ENT_QUOTES, 'UTF-8') . '" data-cost-gross="' . htmlspecialchars(number_format($costBrutto, 2, '.', ''), ENT_QUOTES, 'UTF-8') . '" data-retail-net="' . htmlspecialchars(number_format($priceNetto, 2, '.', ''), ENT_QUOTES, 'UTF-8') . '" data-retail="' . htmlspecialchars(number_format($priceBrutto, 2, '.', ''), ENT_QUOTES, 'UTF-8') . '" aria-label="' . htmlspecialchars($this->t('sales_chart'), ENT_QUOTES, 'UTF-8') . '" title="' . htmlspecialchars($this->t('sales_chart'), ENT_QUOTES, 'UTF-8') . '"><i class="icon-bar-chart"></i></button>';
                $output .= '<button type="button" class="inventory-profit-trigger" data-product-name="' . htmlspecialchars($salesProductName, ENT_QUOTES, 'UTF-8') . '" data-combination-name="' . htmlspecialchars($salesCombinationName, ENT_QUOTES, 'UTF-8') . '" data-image-src="' . ($imgId > 0 ? htmlspecialchars($this->getImagePath($imgId), ENT_QUOTES, 'UTF-8') : '') . '" data-cost="' . htmlspecialchars(number_format($cost, 2, '.', ''), ENT_QUOTES, 'UTF-8') . '" data-cost-gross="' . htmlspecialchars(number_format($costBrutto, 2, '.', ''), ENT_QUOTES, 'UTF-8') . '" data-retail-net="' . htmlspecialchars(number_format($priceNetto, 2, '.', ''), ENT_QUOTES, 'UTF-8') . '" data-retail="' . htmlspecialchars(number_format($priceBrutto, 2, '.', ''), ENT_QUOTES, 'UTF-8') . '" aria-label="' . htmlspecialchars($this->t('profitability'), ENT_QUOTES, 'UTF-8') . '" title="' . htmlspecialchars($this->t('profitability'), ENT_QUOTES, 'UTF-8') . '"><span aria-hidden="true">%</span></button>';
                $output .= '<button type="button" class="inventory-hide-product inventory-hide-product-icon" data-id-product="' . $idProduct . '" aria-label="' . htmlspecialchars($this->t('hide_forever'), ENT_QUOTES, 'UTF-8') . '" title="' . htmlspecialchars($this->t('hide_forever'), ENT_QUOTES, 'UTF-8') . '"><i class="icon-eye-close"></i></button>';
                $output .= '</div>';
                $output .= '</td>';

                $output .= '</tr>';
            }

            $colspanNetto = 7 + ($showWeight ? 1 : 0);
            $output .= '<tr class="inventory-summary-row" id="summaryNetto">';
            $output .= '<td colspan="' . $colspanNetto . '" class="text-end"><strong>' . htmlspecialchars($this->t('total_purchase_value_net'), ENT_QUOTES, 'UTF-8') . '</strong></td>';
            $output .= '<td class="text-center text-nowrap"><strong>' . $this->formatMoney((float) $result['total_value_netto']) . '</strong></td>';
            if ($showBrutto) {
                $output .= '<td></td>';
            }
            $output .= '<td></td>';
            $output .= '</tr>';

            if ($showBrutto) {
                $output .= '<tr class="inventory-summary-row" id="summaryBrutto">';
                $output .= '<td colspan="' . (8 + ($showWeight ? 1 : 0)) . '" class="text-end"><strong>' . htmlspecialchars($this->t('total_retail_value_gross'), ENT_QUOTES, 'UTF-8') . '</strong></td>';
                $output .= '<td class="text-center text-nowrap"><strong>' . $this->formatMoney((float) $result['total_value_brutto']) . '</strong></td>';
                $output .= '<td></td>';
                $output .= '</tr>';
            }
        } else {
            $colspanEmpty = ($showBrutto ? 10 : 8) + ($showWeight ? 1 : 0);
            $output = '<tr><td colspan="' . $colspanEmpty . '" class="text-center">' . htmlspecialchars($this->t('no_results'), ENT_QUOTES, 'UTF-8') . '</td></tr>';
        }

        return [
            'tbody' => $output,
            'pagination' => $this->renderPagination($result),
            'meta' => [
                'current_page' => $result['current_page'],
                'per_page' => $result['per_page'],
                'total_pages' => $result['total_pages'],
                'total_rows' => $result['total_rows'],
            ],
        ];
    }

    public function getMonthlySalesStats(int $idProduct, int $idAttr, int $months = 12, int $offsetMonths = 0): array
    {
        if ($idProduct <= 0) {
            throw new InvalidArgumentException($this->t('missing_id_product'));
        }

        $months = 12;
        $offsetMonths = max(0, min(120, $offsetMonths));
        $offsetYears = (int) floor($offsetMonths / 12);
        $selectedYear = (int) date('Y') - $offsetYears;
        $previousYear = $selectedYear - 1;
        $earliestYear = $selectedYear - 2;

        $monthLabels = [];
        $currentSeries = [];
        $previousSeries = [];
        $earliestSeries = [];
        $currentRevenueSeries = [];
        $previousRevenueSeries = [];
        $earliestRevenueSeries = [];
        $currentRevenueNetSeries = [];
        $previousRevenueNetSeries = [];
        $earliestRevenueNetSeries = [];

        for ($month = 1; $month <= 12; $month++) {
            $monthKey = sprintf('%02d', $month);
            $monthLabels[$monthKey] = sprintf('%s-%s-01', $selectedYear, $monthKey);
            $currentSeries[$monthKey] = 0;
            $previousSeries[$monthKey] = 0;
            $earliestSeries[$monthKey] = 0;
            $currentRevenueSeries[$monthKey] = 0.0;
            $previousRevenueSeries[$monthKey] = 0.0;
            $earliestRevenueSeries[$monthKey] = 0.0;
            $currentRevenueNetSeries[$monthKey] = 0.0;
            $previousRevenueNetSeries[$monthKey] = 0.0;
            $earliestRevenueNetSeries[$monthKey] = 0.0;
        }

        $dateFrom = sprintf('%d-01-01 00:00:00', $earliestYear);
        $dateTo = sprintf('%d-12-31 23:59:59', $selectedYear);

        $sql = '
            SELECT DATE_FORMAT(o.date_add, "%Y") AS sale_year, DATE_FORMAT(o.date_add, "%m") AS sale_month, SUM(od.product_quantity) AS sold_qty, SUM(od.total_price_tax_incl / NULLIF(o.conversion_rate, 0)) AS sold_value, SUM(od.total_price_tax_excl / NULLIF(o.conversion_rate, 0)) AS sold_value_net
            FROM `' . _DB_PREFIX_ . 'orders` o
            INNER JOIN `' . _DB_PREFIX_ . 'order_detail` od ON od.id_order = o.id_order
            WHERE o.valid = 1
              AND od.product_id = :id_product
              AND od.product_attribute_id = :id_attr
              AND o.date_add >= :date_from
              AND o.date_add <= :date_to
            GROUP BY sale_year, sale_month
            ORDER BY sale_year ASC, sale_month ASC
        ';

        $stmt = $this->getPdo()->prepare($sql);
        $stmt->execute([
            ':id_product' => $idProduct,
            ':id_attr' => max(0, $idAttr),
            ':date_from' => $dateFrom,
            ':date_to' => $dateTo,
        ]);

        foreach ($stmt->fetchAll() as $row) {
            $saleYear = (int) ($row['sale_year'] ?? 0);
            $monthKey = (string) ($row['sale_month'] ?? '');
            if (!array_key_exists($monthKey, $currentSeries)) {
                continue;
            }

            $soldQty = (int) round((float) ($row['sold_qty'] ?? 0));
            $soldValue = (float) ($row['sold_value'] ?? 0);
            $soldValueNet = (float) ($row['sold_value_net'] ?? 0);

            if ($saleYear === $selectedYear) {
                $currentSeries[$monthKey] = $soldQty;
                $currentRevenueSeries[$monthKey] = $soldValue;
                $currentRevenueNetSeries[$monthKey] = $soldValueNet;
            } elseif ($saleYear === $previousYear) {
                $previousSeries[$monthKey] = $soldQty;
                $previousRevenueSeries[$monthKey] = $soldValue;
                $previousRevenueNetSeries[$monthKey] = $soldValueNet;
            } elseif ($saleYear === $earliestYear) {
                $earliestSeries[$monthKey] = $soldQty;
                $earliestRevenueSeries[$monthKey] = $soldValue;
                $earliestRevenueNetSeries[$monthKey] = $soldValueNet;
            }
        }

        $items = [];
        $currentYearTotal = 0;
        $previousYearTotal = 0;
        $earliestYearTotal = 0;
        $currentYearRevenue = 0.0;
        $previousYearRevenue = 0.0;
        $earliestYearRevenue = 0.0;
        $currentYearRevenueNet = 0.0;
        $previousYearRevenueNet = 0.0;
        $earliestYearRevenueNet = 0.0;
        $bestMonth = null;
        $bestMonthQty = -1;

        foreach (array_keys($monthLabels) as $monthKey) {
            $currentQty = $currentSeries[$monthKey];
            $previousQty = $previousSeries[$monthKey];
            $earliestQty = $earliestSeries[$monthKey];
            $currentRevenue = $currentRevenueSeries[$monthKey];
            $previousRevenue = $previousRevenueSeries[$monthKey];
            $earliestRevenue = $earliestRevenueSeries[$monthKey];
            $currentRevenueNet = $currentRevenueNetSeries[$monthKey];
            $previousRevenueNet = $previousRevenueNetSeries[$monthKey];
            $earliestRevenueNet = $earliestRevenueNetSeries[$monthKey];
            $currentYearTotal += $currentQty;
            $previousYearTotal += $previousQty;
            $earliestYearTotal += $earliestQty;
            $currentYearRevenue += $currentRevenue;
            $previousYearRevenue += $previousRevenue;
            $earliestYearRevenue += $earliestRevenue;
            $currentYearRevenueNet += $currentRevenueNet;
            $previousYearRevenueNet += $previousRevenueNet;
            $earliestYearRevenueNet += $earliestRevenueNet;

            if ($currentQty > $bestMonthQty) {
                $bestMonthQty = $currentQty;
                $bestMonth = sprintf('%d-%s', $selectedYear, $monthKey);
            }

            $items[] = [
                'month' => $monthKey,
                'month_date' => $monthLabels[$monthKey],
                'quantity' => $currentQty,
                'previous_quantity' => $previousQty,
                'earliest_quantity' => $earliestQty,
                'value' => round($currentRevenue, 2),
                'previous_value' => round($previousRevenue, 2),
                'earliest_value' => round($earliestRevenue, 2),
                'value_net' => round($currentRevenueNet, 2),
                'previous_value_net' => round($previousRevenueNet, 2),
                'earliest_value_net' => round($earliestRevenueNet, 2),
            ];
        }

        if ($currentYearTotal <= 0) {
            $bestMonth = null;
            $bestMonthQty = 0;
        }

        return [
            'months' => $items,
            'comparison' => [
                'current_year' => $selectedYear,
                'previous_year' => $previousYear,
                'earliest_year' => $earliestYear,
            ],
            'summary' => [
                'months_count' => $months,
                'offset_months' => $offsetMonths,
                'total_sold' => $currentYearTotal,
                'previous_total_sold' => $previousYearTotal,
                'earliest_total_sold' => $earliestYearTotal,
                'total_value' => round($currentYearRevenue, 2),
                'previous_total_value' => round($previousYearRevenue, 2),
                'earliest_total_value' => round($earliestYearRevenue, 2),
                'total_value_net' => round($currentYearRevenueNet, 2),
                'previous_total_value_net' => round($previousYearRevenueNet, 2),
                'earliest_total_value_net' => round($earliestYearRevenueNet, 2),
                'best_month' => $bestMonth,
                'best_month_quantity' => max(0, $bestMonthQty),
            ],
        ];
    }

    public function saveWholesalePrice(int $idProduct, int $idAttr, string $priceRaw): float
    {
        $priceRaw = str_replace([' ', ','], ['', '.'], trim($priceRaw));

        if ($idProduct <= 0) {
            throw new InvalidArgumentException($this->t('missing_id_product'));
        }

        if ($priceRaw === '' || !is_numeric($priceRaw)) {
            throw new InvalidArgumentException($this->t('invalid_price'));
        }

        $price = (float) $priceRaw;
        if ($price <= 0) {
            throw new InvalidArgumentException($this->t('price_must_be_greater_than_zero'));
        }

        if ($idAttr > 0) {
            $stmt = $this->getPdo()->prepare('
                UPDATE `' . _DB_PREFIX_ . 'product_attribute`
                SET wholesale_price = :price
                WHERE id_product = :id_product
                  AND id_product_attribute = :id_attr
                LIMIT 1
            ');
            $stmt->execute([
                ':price' => $price,
                ':id_product' => $idProduct,
                ':id_attr' => $idAttr,
            ]);
        } else {
            $stmt = $this->getPdo()->prepare('
                UPDATE `' . _DB_PREFIX_ . 'product`
                SET wholesale_price = :price
                WHERE id_product = :id_product
                LIMIT 1
            ');
            $stmt->execute([
                ':price' => $price,
                ':id_product' => $idProduct,
            ]);
        }

        return $price;
    }

    public function saveRetailGrossPrice(int $idProduct, int $idAttr, string $priceRaw): float
    {
        $priceRaw = str_replace([' ', ','], ['', '.'], trim($priceRaw));

        if ($idProduct <= 0) {
            throw new InvalidArgumentException($this->t('missing_id_product'));
        }

        if ($priceRaw === '' || !is_numeric($priceRaw)) {
            throw new InvalidArgumentException($this->t('invalid_price'));
        }

        $grossPrice = (float) $priceRaw;
        if ($grossPrice <= 0) {
            throw new InvalidArgumentException($this->t('price_must_be_greater_than_zero'));
        }

        $pricingContext = $this->getRetailPricingContext($idProduct, $idAttr);
        $taxMultiplier = 1 + ((float) $pricingContext['tax_rate'] / 100);
        $netPrice = $grossPrice / ($taxMultiplier > 0 ? $taxMultiplier : 1);

        if ($idAttr > 0) {
            $attributeNetImpact = $netPrice - (float) $pricingContext['base_net_price'];

            $stmt = $this->getPdo()->prepare('
                UPDATE `' . _DB_PREFIX_ . 'product_attribute`
                SET price = :price
                WHERE id_product = :id_product
                  AND id_product_attribute = :id_attr
                LIMIT 1
            ');
            $stmt->execute([
                ':price' => $attributeNetImpact,
                ':id_product' => $idProduct,
                ':id_attr' => $idAttr,
            ]);
        } else {
            $stmtProduct = $this->getPdo()->prepare('
                UPDATE `' . _DB_PREFIX_ . 'product`
                SET price = :price
                WHERE id_product = :id_product
                LIMIT 1
            ');
            $stmtProduct->execute([
                ':price' => $netPrice,
                ':id_product' => $idProduct,
            ]);

            $stmtShop = $this->getPdo()->prepare('
                UPDATE `' . _DB_PREFIX_ . 'product_shop`
                SET price = :price
                WHERE id_product = :id_product
            ');
            $stmtShop->execute([
                ':price' => $netPrice,
                ':id_product' => $idProduct,
            ]);
        }

        return round($grossPrice, 2);
    }

    public function saveQuantity(int $idProduct, int $idAttr, string $quantityRaw): int
    {
        $quantityRaw = trim($quantityRaw);

        if ($idProduct <= 0) {
            throw new InvalidArgumentException($this->t('missing_id_product'));
        }

        if ($quantityRaw === '' || !preg_match('/^-?\d+$/', $quantityRaw)) {
            throw new InvalidArgumentException($this->t('invalid_quantity'));
        }

        $quantity = (int) $quantityRaw;

        if (!class_exists('StockAvailable') || !method_exists('StockAvailable', 'setQuantity')) {
            throw new RuntimeException($this->t('stock_api_not_available'));
        }

        StockAvailable::setQuantity(
            $idProduct,
            $idAttr,
            $quantity,
            (int) $this->context->shop->id
        );

        return $quantity;
    }

    public function saveWeight(int $idProduct, int $idAttr, string $weightRaw): float
    {
        $weightRaw = str_replace([' ', ','], ['', '.'], trim($weightRaw));

        if ($idProduct <= 0) {
            throw new InvalidArgumentException($this->t('missing_id_product'));
        }

        if ($weightRaw === '' || !is_numeric($weightRaw)) {
            throw new InvalidArgumentException($this->t('invalid_weight'));
        }

        $weight = round((float) $weightRaw, 6);
        $weightForDb = number_format($weight, 6, '.', '');
        if ($weight < 0) {
            throw new InvalidArgumentException($this->t('invalid_weight'));
        }

        if ($idAttr > 0) {
            $baseWeight = $this->getBaseProductWeight($idProduct);
            $attributeWeight = $weight - $baseWeight;
            $attributeWeightForDb = number_format($attributeWeight, 6, '.', '');

            $stmt = $this->getPdo()->prepare('
                UPDATE `' . _DB_PREFIX_ . 'product_attribute`
                SET weight = :weight
                WHERE id_product = :id_product
                  AND id_product_attribute = :id_attr
                LIMIT 1
            ');
            $stmt->execute([
                ':weight' => $attributeWeightForDb,
                ':id_product' => $idProduct,
                ':id_attr' => $idAttr,
            ]);
        } else {
            $stmtProduct = $this->getPdo()->prepare('
                UPDATE `' . _DB_PREFIX_ . 'product`
                SET weight = :weight
                WHERE id_product = :id_product
                LIMIT 1
            ');
            $stmtProduct->execute([
                ':weight' => $weightForDb,
                ':id_product' => $idProduct,
            ]);
        }

        return round($weight, 3);
    }

    public function getIgnoredProducts(): array
    {
        $ignoredIds = $this->getIgnoredIds();
        if ($ignoredIds === []) {
            return [];
        }

        $prefix = _DB_PREFIX_;
        $idLang = (int) $this->context->language->id;
        $idShop = (int) $this->context->shop->id;

        $params = [
            ':id_lang' => $idLang,
            ':id_shop' => $idShop,
        ];
        $placeholders = [];
        foreach ($ignoredIds as $index => $id) {
            $placeholder = ':ignored_' . $index;
            $placeholders[] = $placeholder;
            $params[$placeholder] = (int) $id;
        }

        $sql = "
            SELECT
                p.id_product,
                IFNULL(ps.active, p.active) AS active,
                p.ean13,
                pl.name AS product_name,
                i.id_image AS product_image_id
            FROM `{$prefix}product` p
            LEFT JOIN `{$prefix}product_shop` ps
                ON p.id_product = ps.id_product
               AND ps.id_shop = :id_shop
            LEFT JOIN `{$prefix}product_lang` pl
                ON p.id_product = pl.id_product
               AND pl.id_lang = :id_lang
               AND pl.id_shop = :id_shop
            LEFT JOIN `{$prefix}image` i
                ON p.id_product = i.id_product
               AND i.cover = 1
            WHERE p.id_product IN (" . implode(',', $placeholders) . ")
            ORDER BY pl.name ASC
        ";

        $stmt = $this->getPdo()->prepare($sql);
        foreach ($params as $key => $value) {
            $stmt->bindValue($key, $value, is_int($value) ? PDO::PARAM_INT : PDO::PARAM_STR);
        }
        $stmt->execute();

        $products = $stmt->fetchAll(PDO::FETCH_ASSOC);
        foreach ($products as &$product) {
            $product['image_url'] = !empty($product['product_image_id'])
                ? $this->getImagePath((int) $product['product_image_id'])
                : null;
        }
        unset($product);

        return $products;
    }

    public function hideProduct(int $idProduct): array
    {
        if ($idProduct <= 0) {
            throw new InvalidArgumentException($this->t('missing_id_product'));
        }

        $ids = $this->getIgnoredIds();
        if (!in_array($idProduct, $ids, true)) {
            $ids[] = $idProduct;
            sort($ids, SORT_NUMERIC);
            Configuration::updateValue(self::CONFIG_IGNORED_IDS, implode(PHP_EOL, $ids));
        }

        return [
            'id_product' => $idProduct,
            'ignored_ids' => $ids,
        ];
    }

    public function unhideProduct(int $idProduct): array
    {
        if ($idProduct <= 0) {
            throw new InvalidArgumentException($this->t('missing_id_product'));
        }

        $ids = array_values(array_filter($this->getIgnoredIds(), static function ($value) use ($idProduct) {
            return (int) $value !== $idProduct;
        }));

        Configuration::updateValue(self::CONFIG_IGNORED_IDS, implode(PHP_EOL, $ids));

        return [
            'id_product' => $idProduct,
            'ignored_ids' => $ids,
        ];
    }

    public function setProductActive(int $idProduct, $active): bool
    {
        if ($idProduct <= 0) {
            throw new InvalidArgumentException($this->t('missing_id_product'));
        }

        $isActive = $this->toBool($active);

        $stmt = $this->getPdo()->prepare('
            UPDATE `' . _DB_PREFIX_ . 'product`
            SET active = :active
            WHERE id_product = :id_product
            LIMIT 1
        ');
        $stmt->execute([
            ':active' => $isActive ? 1 : 0,
            ':id_product' => $idProduct,
        ]);

        $stmtShop = $this->getPdo()->prepare('
            UPDATE `' . _DB_PREFIX_ . 'product_shop`
            SET active = :active
            WHERE id_product = :id_product
        ');
        $stmtShop->execute([
            ':active' => $isActive ? 1 : 0,
            ':id_product' => $idProduct,
        ]);

        return $isActive;
    }

    private function getRetailPricingContext(int $idProduct, int $idAttr): array
    {
        $idShop = (int) $this->context->shop->id;
        $idCountry = (int) Configuration::get('PS_COUNTRY_DEFAULT');

        $sql = '
            SELECT
                IFNULL(ps.price, 0) AS base_net_price,
                IFNULL(pa.price, 0) AS attribute_net_impact,
                IFNULL(t.rate, 0) AS tax_rate
            FROM `' . _DB_PREFIX_ . 'product` p
            LEFT JOIN `' . _DB_PREFIX_ . 'product_shop` ps
                ON p.id_product = ps.id_product
               AND ps.id_shop = :id_shop
            LEFT JOIN `' . _DB_PREFIX_ . 'tax_rule` tr
                ON ps.id_tax_rules_group = tr.id_tax_rules_group
               AND tr.id_country = :id_country
               AND (tr.id_state = 0 OR tr.id_state IS NULL)
            LEFT JOIN `' . _DB_PREFIX_ . 'tax` t
                ON tr.id_tax = t.id_tax
            LEFT JOIN `' . _DB_PREFIX_ . 'product_attribute` pa
                ON p.id_product = pa.id_product
               AND pa.id_product_attribute = :id_attr
            WHERE p.id_product = :id_product
            LIMIT 1
        ';

        $stmt = $this->getPdo()->prepare($sql);
        $stmt->execute([
            ':id_shop' => $idShop,
            ':id_country' => $idCountry,
            ':id_attr' => $idAttr,
            ':id_product' => $idProduct,
        ]);

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$result) {
            throw new InvalidArgumentException($this->t('product_not_found'));
        }

        return $result;
    }

    private function getBaseProductWeight(int $idProduct): float
    {
        $stmt = $this->getPdo()->prepare('
            SELECT IFNULL(weight, 0) AS weight
            FROM `' . _DB_PREFIX_ . 'product`
            WHERE id_product = :id_product
            LIMIT 1
        ');
        $stmt->execute([
            ':id_product' => $idProduct,
        ]);

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$result) {
            throw new InvalidArgumentException($this->t('product_not_found'));
        }

        return (float) ($result['weight'] ?? 0);
    }

    public function outputPdfReport(array $filters): void
    {
        $this->loadPdfLibrary();

        $products = $this->fetchProducts($filters);
        $activeOnly = $this->toBool($filters['activeOnly'] ?? false);
        $onlyAvailable = $this->toBool($filters['onlyAvailable'] ?? false);
        $missingPurchasePriceOnly = $this->toBool($filters['missingPurchasePriceOnly'] ?? false);
        $missingWeightOnly = $this->toBool($filters['missingWeightOnly'] ?? false);
        $showWeight = $this->toBool($filters['showWeight'] ?? true, true);
        $showBrutto = $this->toBool($filters['showBrutto'] ?? true, true);
        $totalValueNetto = 0.0;
        $totalValueBrutto = 0.0;
        $rowsHtml = '';
        $lp = 1;

        foreach ($products as $product) {
            $ean = $product['combination_ean13'] ?: $product['product_ean13'];
            $name = (string) ($product['product_name'] ?? '');
            $comb = (string) ($product['combination_name'] ?? '');
            $cost = (float) ($product['product_cost'] ?? 0);
            $priceBrutto = (float) ($product['product_price_brutto'] ?? 0);
            $weight = (float) ($product['product_weight'] ?? 0);
            $qty = (int) ($product['stock_quantity'] ?? 0);
            $value = ($cost > 0) ? ($cost * $qty) : 0.0;
            $valueBrutto = ($priceBrutto > 0) ? ($priceBrutto * $qty) : 0.0;
            $totalValueNetto += $value;
            $totalValueBrutto += $valueBrutto;

            $priceTxt = ($cost > 0) ? $this->formatMoney($cost) : '—';
            $priceBruttoTxt = ($priceBrutto > 0) ? $this->formatMoney($priceBrutto) : '—';
            $weightTxt = htmlspecialchars($this->formatWeight($weight), ENT_QUOTES, 'UTF-8');
            $valueTxt = $this->formatMoney($value);
            $valueBruttoTxt = $this->formatMoney($valueBrutto);

            $imgId = !empty($product['combination_image_id']) ? (int) $product['combination_image_id'] : (int) $product['product_image_id'];
            $imgSrc = $imgId > 0 ? $this->getAbsoluteImagePath($imgId) : null;
            $imgTag = $imgSrc ? '<img class="thumb" src="' . htmlspecialchars($imgSrc, ENT_QUOTES, 'UTF-8') . '">' : '—';

            $rowsHtml .= '
                <tr>
                    <td class="c lp">' . $lp++ . '</td>
                    <td class="c img">' . $imgTag . '</td>
                    <td class="ean">' . htmlspecialchars((string) $ean, ENT_QUOTES, 'UTF-8') . '</td>
                    <td class="name">
                        <div class="n">' . htmlspecialchars($name, ENT_QUOTES, 'UTF-8') . '</div>'
                        . ($comb !== '' ? '<div class="m">' . htmlspecialchars($comb, ENT_QUOTES, 'UTF-8') . '</div>' : '') . '
                    </td>
                    ' . ($showWeight ? '<td class="c weight">' . $weightTxt . '</td>' : '') . '
                    <td class="r price">' . $priceTxt . '</td>
                    ' . ($showBrutto ? '<td class="r price">' . $priceBruttoTxt . '</td>' : '') . '
                    <td class="c qty">' . $qty . '</td>
                    <td class="r val">' . $valueTxt . '</td>
                    ' . ($showBrutto ? '<td class="r val">' . $valueBruttoTxt . '</td>' : '') . '
                </tr>
            ';
        }

        $switchActiveUri = $this->switchSvgDataUri($activeOnly);
        $switchAvailableUri = $this->switchSvgDataUri($onlyAvailable);
        $switchMissingPurchaseUri = $this->switchSvgDataUri($missingPurchasePriceOnly);
        $switchWeightUri = $this->switchSvgDataUri($showWeight);
        $switchMissingWeightUri = $this->switchSvgDataUri($missingWeightOnly);
        $switchBruttoUri = $this->switchSvgDataUri($showBrutto);
        $colspan = ($showBrutto ? 8 : 7) + ($showWeight ? 1 : 0);

        $html = '
        <!DOCTYPE html>
        <html>
        <head>
        <meta charset="utf-8">
        <style>
            body { font-family: dejavusans, sans-serif; font-size: 9pt; color:#111; }
            h1 { font-size: 13pt; margin: 0 0 4pt 0; }
            .filters{ width: 100%; margin: 0 0 6pt 0; border-collapse: collapse; table-layout: fixed; }
            .filters td{ border: 0; padding: 0 4pt 2pt 0; vertical-align: middle; }
            .filters .filter-item{ width: 33.33%; }
            .filters .filter-icon-cell{ width: 28px; padding-right: 3pt; }
            .switch-img{ width: 22px; height: 11px; display:block; }
            .filter-label{ font-size: 7.2pt; color:#111; line-height: 1; margin: 0; }
            table { width: 100%; border-collapse: collapse; table-layout: fixed; }
            th { background:#f2f4f7; font-weight:600; font-size: 8.5pt; padding: 6pt; border: 1px solid #d9dee5; }
            td { padding: 6pt; border: 1px solid #e2e6ec; vertical-align: top; }
            .c { text-align:center; white-space:nowrap; }
            .r { text-align:right; white-space:nowrap; }
            .lp { width: 5%; }
            .img { width: 7%; }
            .ean { width: 20%; font-size: 8.6pt; }
            .name { width: 36%; }
            .weight { width: 8%; }
            .price { width: 10%; }
            .qty { width: 6%; }
            .val { width: 12%; }
            .n { font-size: 9.2pt; font-weight:600; word-wrap: break-word; }
            .m { font-size: 8.1pt; color:#666; margin-top: 2pt; word-wrap: break-word; }
            .thumb { width: 34px; height: 34px; object-fit: cover; border-radius: 7px; }
            tfoot td { font-weight:700; background:#fafbfc; }
        </style>
        </head>
        <body>
            <h1>' . htmlspecialchars($this->t('report_title'), ENT_QUOTES, 'UTF-8') . '</h1>
            <table class="filters">
                <tr>
                    <td class="filter-item">
                        <table>
                            <tr>
                                <td class="filter-icon-cell"><img class="switch-img" src="' . $switchActiveUri . '" alt="' . ($activeOnly ? 'ON' : 'OFF') . '"></td>
                                <td><div class="filter-label">' . htmlspecialchars($this->t('show_only_active_products'), ENT_QUOTES, 'UTF-8') . '</div></td>
                            </tr>
                        </table>
                    </td>
                    <td class="filter-item">
                        <table>
                            <tr>
                                <td class="filter-icon-cell"><img class="switch-img" src="' . $switchAvailableUri . '" alt="' . ($onlyAvailable ? 'ON' : 'OFF') . '"></td>
                                <td><div class="filter-label">' . htmlspecialchars($this->t('show_only_available_in_stock'), ENT_QUOTES, 'UTF-8') . '</div></td>
                            </tr>
                        </table>
                    </td>
                    <td class="filter-item">
                        <table>
                            <tr>
                                <td class="filter-icon-cell"><img class="switch-img" src="' . $switchMissingPurchaseUri . '" alt="' . ($missingPurchasePriceOnly ? 'ON' : 'OFF') . '"></td>
                                <td><div class="filter-label">' . htmlspecialchars($this->t('show_only_missing_purchase_price'), ENT_QUOTES, 'UTF-8') . '</div></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td class="filter-item">
                        <table>
                            <tr>
                                <td class="filter-icon-cell"><img class="switch-img" src="' . $switchWeightUri . '" alt="' . ($showWeight ? 'ON' : 'OFF') . '"></td>
                                <td><div class="filter-label">' . htmlspecialchars($this->t('show_product_weight'), ENT_QUOTES, 'UTF-8') . '</div></td>
                            </tr>
                        </table>
                    </td>
                    <td class="filter-item">
                        <table>
                            <tr>
                                <td class="filter-icon-cell"><img class="switch-img" src="' . $switchMissingWeightUri . '" alt="' . ($missingWeightOnly ? 'ON' : 'OFF') . '"></td>
                                <td><div class="filter-label">' . htmlspecialchars($this->t('show_only_missing_weight'), ENT_QUOTES, 'UTF-8') . '</div></td>
                            </tr>
                        </table>
                    </td>
                    <td class="filter-item">
                        <table>
                            <tr>
                                <td class="filter-icon-cell"><img class="switch-img" src="' . $switchBruttoUri . '" alt="' . ($showBrutto ? 'ON' : 'OFF') . '"></td>
                                <td><div class="filter-label">' . htmlspecialchars($this->t('show_retail_prices_gross'), ENT_QUOTES, 'UTF-8') . '</div></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <table>
                <thead>
                    <tr>
                        <th class="c lp">' . htmlspecialchars($this->t('row_number'), ENT_QUOTES, 'UTF-8') . '</th>
                        <th class="c img">' . htmlspecialchars($this->t('image'), ENT_QUOTES, 'UTF-8') . '</th>
                        <th class="ean">' . htmlspecialchars($this->t('ean13'), ENT_QUOTES, 'UTF-8') . '</th>
                        <th class="name">' . htmlspecialchars($this->t('name'), ENT_QUOTES, 'UTF-8') . '</th>
                        ' . ($showWeight ? '<th class="c weight">' . htmlspecialchars($this->t('product_weight'), ENT_QUOTES, 'UTF-8') . '</th>' : '') . '
                        <th class="r price">' . htmlspecialchars($this->t('purchase_price_net'), ENT_QUOTES, 'UTF-8') . '</th>
                        ' . ($showBrutto ? '<th class="r price">' . htmlspecialchars($this->t('retail_price_gross'), ENT_QUOTES, 'UTF-8') . '</th>' : '') . '
                        <th class="c qty">' . htmlspecialchars($this->t('quantity'), ENT_QUOTES, 'UTF-8') . '</th>
                        <th class="r val">' . htmlspecialchars($this->t('purchase_value_net'), ENT_QUOTES, 'UTF-8') . '</th>
                        ' . ($showBrutto ? '<th class="r val">' . htmlspecialchars($this->t('retail_value_gross'), ENT_QUOTES, 'UTF-8') . '</th>' : '') . '
                    </tr>
                </thead>
                <tbody>
                    ' . ($rowsHtml !== '' ? $rowsHtml : '<tr><td colspan="' . $colspan . '" class="c">' . htmlspecialchars($this->t('no_results'), ENT_QUOTES, 'UTF-8') . '</td></tr>') . '
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="' . (6 + ($showWeight ? 1 : 0) + ($showBrutto ? 1 : 0)) . '" class="r">' . htmlspecialchars($this->t('total_purchase_value_net'), ENT_QUOTES, 'UTF-8') . '</td>
                        <td class="r">' . $this->formatMoney($totalValueNetto) . '</td>
                        ' . ($showBrutto ? '<td></td>' : '') . '
                    </tr>
                    ' . ($showBrutto ? '
                    <tr>
                        <td colspan="' . (8 + ($showWeight ? 1 : 0)) . '" class="r">' . htmlspecialchars($this->t('total_retail_value_gross'), ENT_QUOTES, 'UTF-8') . '</td>
                        <td class="r">' . $this->formatMoney($totalValueBrutto) . '</td>
                    </tr>
                    ' : '') . '
                </tfoot>
            </table>
        </body>
        </html>';

        $mpdf = new \Mpdf\Mpdf([
            'mode' => 'utf-8',
            'format' => 'A4',
            'margin_left' => 10,
            'margin_right' => 10,
            'margin_top' => 10,
            'margin_bottom' => 10,
            'default_font' => 'dejavusans',
            'backupSubsFont' => ['dejavusans'],
        ]);

        $mpdf->SetTitle($this->t('report_title'));
        $mpdf->WriteHTML($html);
        $mpdf->Output($this->t('pdf_filename', ['date' => date('Y-m-d_H-i')]) . '.pdf', \Mpdf\Output\Destination::DOWNLOAD);
        exit;
    }

    private function fetchProducts(array $filters): array
    {
        [$baseSql, $params] = $this->buildProductBaseSql($filters);
        $sortField = (string) ($filters['sort_field'] ?? 'product_name');
        $sortDir = strtoupper((string) ($filters['sort_dir'] ?? 'ASC')) === 'DESC' ? 'DESC' : 'ASC';
        $sortSql = self::SORT_FIELD_MAP[$sortField] ?? self::SORT_FIELD_MAP['product_name'];
        $sql = 'SELECT * FROM (' . $baseSql . ') inventory_rows ORDER BY ' . $sortSql . ' ' . $sortDir . ', id_product ASC';

        $stmt = $this->getPdo()->prepare($sql);
        foreach ($params as $key => $value) {
            $stmt->bindValue($key, $value, is_int($value) ? PDO::PARAM_INT : PDO::PARAM_STR);
        }
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    private function fetchProductsPage(array $filters, int $page, int $perPage): array
    {
        [$baseSql, $params] = $this->buildProductBaseSql($filters);
        $countSql = '
            SELECT
                COUNT(*) AS total_rows,
                COALESCE(SUM(CASE WHEN product_cost > 0 THEN product_cost * stock_quantity ELSE 0 END), 0) AS total_value_netto,
                COALESCE(SUM(CASE WHEN product_price_brutto > 0 THEN product_price_brutto * stock_quantity ELSE 0 END), 0) AS total_value_brutto
            FROM (' . $baseSql . ') inventory_rows
        ';

        $countStmt = $this->getPdo()->prepare($countSql);
        foreach ($params as $key => $value) {
            $countStmt->bindValue($key, $value, is_int($value) ? PDO::PARAM_INT : PDO::PARAM_STR);
        }
        $countStmt->execute();
        $summary = $countStmt->fetch(PDO::FETCH_ASSOC) ?: [];

        $totalRows = (int) ($summary['total_rows'] ?? 0);
        $totalPages = max(1, (int) ceil($totalRows / $perPage));
        $currentPage = min($page, $totalPages);
        $offset = ($currentPage - 1) * $perPage;

        $sortField = (string) ($filters['sort_field'] ?? 'product_name');
        $sortDir = strtoupper((string) ($filters['sort_dir'] ?? 'ASC')) === 'DESC' ? 'DESC' : 'ASC';
        $sortSql = self::SORT_FIELD_MAP[$sortField] ?? self::SORT_FIELD_MAP['product_name'];
        $rowsSql = '
            SELECT * FROM (' . $baseSql . ') inventory_rows
            ORDER BY ' . $sortSql . ' ' . $sortDir . ', id_product ASC
            LIMIT :limit OFFSET :offset
        ';

        $rowsStmt = $this->getPdo()->prepare($rowsSql);
        foreach ($params as $key => $value) {
            $rowsStmt->bindValue($key, $value, is_int($value) ? PDO::PARAM_INT : PDO::PARAM_STR);
        }
        $rowsStmt->bindValue(':limit', $perPage, PDO::PARAM_INT);
        $rowsStmt->bindValue(':offset', $offset, PDO::PARAM_INT);
        $rowsStmt->execute();

        $from = $totalRows > 0 ? ($offset + 1) : 0;
        $to = min($offset + $perPage, $totalRows);

        return [
            'items' => $rowsStmt->fetchAll(PDO::FETCH_ASSOC),
            'current_page' => $currentPage,
            'per_page' => $perPage,
            'total_pages' => $totalPages,
            'total_rows' => $totalRows,
            'from' => $from,
            'to' => $to,
            'total_value_netto' => (float) ($summary['total_value_netto'] ?? 0),
            'total_value_brutto' => (float) ($summary['total_value_brutto'] ?? 0),
        ];
    }

    private function buildProductBaseSql(array $filters): array
    {
        $query = (string) ($filters['query'] ?? '');
        $lang = $this->resolveLanguage((string) ($filters['lang'] ?? 'pl'));
        $idLang = (int) $lang['id_lang'];
        $idCountry = (int) Configuration::get('PS_COUNTRY_DEFAULT');
        $idShop = (int) $this->context->shop->id;
        $idShopGroup = (int) $this->context->shop->id_shop_group;
        $activeOnly = $this->toBool($filters['activeOnly'] ?? false);
        $onlyAvailable = $this->toBool($filters['onlyAvailable'] ?? false);
        $missingPurchasePriceOnly = $this->toBool($filters['missingPurchasePriceOnly'] ?? false);
        $missingWeightOnly = $this->toBool($filters['missingWeightOnly'] ?? false);
        $keywords = $this->parseKeywords($query, $filters['keywords'] ?? null);
        $prefix = _DB_PREFIX_;

        $sql = "
            SELECT
                p.id_product,
                IFNULL(pa.id_product_attribute, 0) AS id_product_attribute,
                IFNULL(ps.active, p.active) AS active,
                p.ean13 AS product_ean13,
                pa.ean13 AS combination_ean13,
                pl.name AS product_name,
                (IFNULL(p.weight, 0) + IFNULL(pa.weight, 0)) AS product_weight,
                IFNULL(pa.wholesale_price, p.wholesale_price) AS product_cost,
                (IFNULL(ps.price, 0) + IFNULL(pa.price, 0)) AS product_price_netto,
                (IFNULL(ps.price, 0) + IFNULL(pa.price, 0)) * (1 + IFNULL(t.rate, 0) / 100) AS product_price_brutto,
                IFNULL(t.rate, 0) AS tax_rate,
                IFNULL(sa.quantity, 0) AS stock_quantity,
                MIN(pai.id_image) AS combination_image_id,
                i.id_image AS product_image_id,
                GROUP_CONCAT(DISTINCT CONCAT(agl.name, ': ', al.name) SEPARATOR ', ') AS combination_name
            FROM `{$prefix}product` p
            LEFT JOIN `{$prefix}product_shop` ps
                ON p.id_product = ps.id_product AND ps.id_shop = :id_shop
            LEFT JOIN `{$prefix}product_lang` pl
                ON p.id_product = pl.id_product AND pl.id_lang = :id_lang AND pl.id_shop = ps.id_shop
            LEFT JOIN `{$prefix}tax_rule` tr
                ON ps.id_tax_rules_group = tr.id_tax_rules_group
                AND tr.id_country = :id_country
                AND (tr.id_state = 0 OR tr.id_state IS NULL)
            LEFT JOIN `{$prefix}tax` t
                ON tr.id_tax = t.id_tax
            LEFT JOIN `{$prefix}product_attribute` pa
                ON p.id_product = pa.id_product
            LEFT JOIN (
                SELECT
                    sa0.id_product,
                    sa0.id_product_attribute,
                    COALESCE(
                        MAX(CASE WHEN sa0.id_shop = :id_shop THEN sa0.quantity END),
                        MAX(CASE WHEN sa0.id_shop = 0 AND sa0.id_shop_group = :id_shop_group THEN sa0.quantity END),
                        MAX(CASE WHEN sa0.id_shop = 0 AND sa0.id_shop_group = 0 THEN sa0.quantity END)
                    ) AS quantity
                FROM `{$prefix}stock_available` sa0
                GROUP BY sa0.id_product, sa0.id_product_attribute
            ) sa
                ON p.id_product = sa.id_product
                AND sa.id_product_attribute = IFNULL(pa.id_product_attribute, 0)
            LEFT JOIN `{$prefix}product_attribute_image` pai
                ON pa.id_product_attribute = pai.id_product_attribute
            LEFT JOIN `{$prefix}image` i
                ON p.id_product = i.id_product AND i.cover = 1
            LEFT JOIN `{$prefix}product_attribute_combination` pac
                ON pa.id_product_attribute = pac.id_product_attribute
            LEFT JOIN `{$prefix}attribute` a
                ON pac.id_attribute = a.id_attribute
            LEFT JOIN `{$prefix}attribute_lang` al
                ON a.id_attribute = al.id_attribute AND al.id_lang = :id_lang
            LEFT JOIN `{$prefix}attribute_group_lang` agl
                ON a.id_attribute_group = agl.id_attribute_group AND agl.id_lang = :id_lang
            WHERE 1 = 1
        ";

        $params = [
            ':id_shop' => $idShop,
            ':id_shop_group' => $idShopGroup,
            ':id_lang' => $idLang,
            ':id_country' => $idCountry,
        ];

        $ignoredIds = $this->getIgnoredIds();
        if ($ignoredIds !== []) {
            $placeholders = [];
            foreach ($ignoredIds as $index => $id) {
                $placeholder = ':ign' . $index;
                $placeholders[] = $placeholder;
                $params[$placeholder] = (int) $id;
            }
            $sql .= ' AND p.id_product NOT IN (' . implode(',', $placeholders) . ')';
        }

        if ($activeOnly) {
            $sql .= ' AND IFNULL(ps.active, p.active) = 1';
        }

        if ($onlyAvailable) {
            $sql .= ' AND sa.quantity > 0';
        }

        if ($missingPurchasePriceOnly) {
            $sql .= ' AND IFNULL(pa.wholesale_price, p.wholesale_price) <= 0';
        }

        if ($missingWeightOnly) {
            $sql .= ' AND (IFNULL(p.weight, 0) + IFNULL(pa.weight, 0)) <= 0';
        }

        if ($keywords !== []) {
            $andParts = [];
            foreach ($keywords as $index => $keyword) {
                $placeholder = ':kw' . $index;
                $andParts[] = "(pl.name LIKE {$placeholder} OR p.ean13 LIKE {$placeholder} OR pa.ean13 LIKE {$placeholder})";
                $params[$placeholder] = '%' . $keyword . '%';
            }
            $sql .= ' AND (' . implode(' AND ', $andParts) . ')';
        }

        $sql .= ' GROUP BY p.id_product, pa.id_product_attribute';

        return [$sql, $params];
    }

    private function renderPagination(array $result): string
    {
        $currentPage = (int) $result['current_page'];
        $totalPages = (int) $result['total_pages'];
        $totalRows = (int) $result['total_rows'];
        $from = (int) $result['from'];
        $to = (int) $result['to'];
        $perPage = (int) $result['per_page'];
        $options = [20, 50, 100, 200];

        $html = '<div class="inventory-pagination-inner">';
        $html .= '<div class="inventory-pagination-pages">';
        $html .= '<ul class="pagination mb-0">';
        if ($totalPages > 1) {
            $html .= '<li class="page-item first' . ($currentPage === 1 ? ' disabled' : '') . '">';
            $html .= '<button type="button" class="page-link first inventory-page-edge" data-page="1"' . ($currentPage === 1 ? ' disabled' : '') . '>1</button>';
            $html .= '</li>';
            $html .= '<li class="page-item previous' . ($currentPage === 1 ? ' disabled' : '') . '">';
            $html .= '<button type="button" class="page-link previous inventory-page-nav" data-page="' . max(1, $currentPage - 1) . '"' . ($currentPage === 1 ? ' disabled' : '') . ' aria-label="' . htmlspecialchars($this->t('previous'), ENT_QUOTES, 'UTF-8') . '"><span aria-hidden="true">&#8249;</span><span class="sr-only">' . htmlspecialchars($this->t('previous'), ENT_QUOTES, 'UTF-8') . '</span></button>';
            $html .= '</li>';
            $html .= '<li class="page-item current active"><label><input type="text" inputmode="numeric" pattern="[0-9]*" name="paginator-jump-page" class="jump-to-page inventory-page-current" min="1" max="' . $totalPages . '" value="' . $currentPage . '" aria-label="' . htmlspecialchars($this->t('current_page'), ENT_QUOTES, 'UTF-8') . '"></label></li>';
            $html .= '<li class="page-item next' . ($currentPage >= $totalPages ? ' disabled' : '') . '">';
            $html .= '<button type="button" class="page-link next inventory-page-nav" data-page="' . min($totalPages, $currentPage + 1) . '"' . ($currentPage >= $totalPages ? ' disabled' : '') . ' aria-label="' . htmlspecialchars($this->t('next'), ENT_QUOTES, 'UTF-8') . '"><span aria-hidden="true">&#8250;</span><span class="sr-only">' . htmlspecialchars($this->t('next'), ENT_QUOTES, 'UTF-8') . '</span></button>';
            $html .= '</li>';
            $html .= '<li class="page-item last' . ($currentPage === $totalPages ? ' disabled' : '') . '">';
            $html .= '<button type="button" class="page-link last inventory-page-edge" data-page="' . $totalPages . '"' . ($currentPage === $totalPages ? ' disabled' : '') . '>' . $totalPages . '</button>';
            $html .= '</li>';
        } else {
            $html .= '<li class="page-item current active"><label><input type="text" inputmode="numeric" pattern="[0-9]*" name="paginator-jump-page" class="jump-to-page inventory-page-current" min="1" max="1" value="1" aria-label="' . htmlspecialchars($this->t('current_page'), ENT_QUOTES, 'UTF-8') . '"></label></li>';
        }
        $html .= '</ul>';
        $html .= '</div>';
        $html .= '<div class="inventory-pagination-status">' . htmlspecialchars($this->t('visible_range', ['from' => $from, 'to' => $to, 'total' => $totalRows, 'page' => $currentPage, 'total_pages' => $totalPages]), ENT_QUOTES, 'UTF-8') . '</div>';
        $html .= '<label class="inventory-per-page"><span class="inventory-per-page-label">' . htmlspecialchars($this->t('products_per_page'), ENT_QUOTES, 'UTF-8') . '</span> <select class="inventory-per-page-select">';
        foreach ($options as $option) {
            $selected = $option === $perPage ? ' selected' : '';
            $html .= '<option value="' . $option . '"' . $selected . '>' . $option . '</option>';
        }
        $html .= '</select></label>';
        $html .= '</div>';

        return $html;
    }

    private function normalizePage($value): int
    {
        $page = (int) $value;

        return $page > 0 ? $page : 1;
    }

    private function normalizePerPage($value): int
    {
        $perPage = (int) $value;
        $allowed = [20, 50, 100, 200];

        return in_array($perPage, $allowed, true) ? $perPage : 20;
    }

    private function getPdo(): PDO
    {
        if ($this->pdo instanceof PDO) {
            return $this->pdo;
        }

        $this->pdo = new PDO(
            'mysql:host=' . _DB_SERVER_ . ';dbname=' . _DB_NAME_ . ';charset=utf8mb4',
            _DB_USER_,
            _DB_PASSWD_,
            [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            ]
        );

        return $this->pdo;
    }

    private function resolveLanguage(string $isoCode): array
    {
        $idLang = (int) Language::getIdByIso($isoCode);
        if ($idLang <= 0) {
            $idLang = (int) $this->context->language->id;
        }

        return [
            'id_lang' => $idLang,
        ];
    }

    public function getIgnoredIds(): array
    {
        $configured = (string) Configuration::get(self::CONFIG_IGNORED_IDS);
        if (trim($configured) !== '') {
            return self::parseIgnoredIdsText($configured);
        }

        $filePath = $this->modulePath . 'ignore.txt';
        if (!is_file($filePath)) {
            return [];
        }

        return self::parseIgnoredIdsText((string) file_get_contents($filePath));
    }

    public function getTranslations(): array
    {
        return PrestashopInventoryI18n::all($this->module);
    }

    private function t(string $key, array $params = []): string
    {
        return PrestashopInventoryI18n::translate($this->module, $key, $params);
    }

    private function formatMoney(float $amount): string
    {
        $currencySign = 'zł';
        if (isset($this->context->currency) && isset($this->context->currency->sign) && $this->context->currency->sign) {
            $currencySign = (string) $this->context->currency->sign;
        }

        return number_format($amount, 2, ',', ' ') . ' ' . $currencySign;
    }

    private function formatWeight(float $weight): string
    {
        if ($weight <= 0) {
            return '—';
        }

        return number_format($weight, 3, ',', ' ') . ' kg';
    }

    public static function parseIgnoredIdsText(string $raw): array
    {
        $items = preg_split('/[\s,;]+/u', trim($raw), -1, PREG_SPLIT_NO_EMPTY);
        $items = array_map('intval', $items ?: []);
        $items = array_values(array_unique(array_filter($items, static function ($id) {
            return $id > 0;
        })));

        return $items;
    }

    private function parseKeywords(string $query, $keywords): array
    {
        if (!is_array($keywords) || $keywords === []) {
            $keywords = preg_split('/[,\s]+/u', trim($query), -1, PREG_SPLIT_NO_EMPTY);
        }

        return array_values(array_filter(array_map('trim', (array) $keywords)));
    }

    private function toBool($value, bool $default = false): bool
    {
        if ($value === null || $value === '') {
            return $default;
        }

        return $value === true
            || $value === 1
            || $value === '1'
            || $value === 'true'
            || $value === 'on';
    }

    private function getImagePath(int $idImage): string
    {
        return __PS_BASE_URI__ . 'img/p/' . implode('/', str_split((string) $idImage)) . '/' . $idImage . '.jpg';
    }

    private function getProductEditUrl(int $idProduct): string
    {
        $legacyUrl = $this->context->link->getAdminLink('AdminProducts', true, [], [
            'id_product' => $idProduct,
            'updateproduct' => 1,
        ]);

        $symfonyUrl = $this->context->link->getAdminLink('AdminProducts', true, [
            'route' => 'admin_product_form',
            'id' => $idProduct,
        ]);

        if (!is_string($symfonyUrl) || $symfonyUrl === '') {
            return $legacyUrl;
        }

        if (strpos($symfonyUrl, 'route=admin_product_form') !== false || preg_match('#/sell/catalog/products/' . $idProduct . '(?:/edit)?(?:[/?]|$)#', $symfonyUrl)) {
            return $symfonyUrl;
        }

        return $legacyUrl;
    }

    private function getAbsoluteImagePath(int $idImage): ?string
    {
        $relativePath = '/img/p/' . implode('/', str_split((string) $idImage)) . '/' . $idImage . '.jpg';
        $filePath = _PS_ROOT_DIR_ . $relativePath;
        if (is_file($filePath)) {
            return $filePath;
        }

        return null;
    }

    private function switchSvgDataUri(bool $on): string
    {
        $bg = $on ? '#6bb35a' : '#d9d9d9';
        $cx = $on ? 30 : 10;
        $svg = <<<SVG
<svg xmlns="http://www.w3.org/2000/svg" width="40" height="20" viewBox="0 0 40 20">
  <rect x="0" y="0" width="40" height="20" rx="10" fill="$bg"/>
  <circle cx="$cx" cy="10" r="8" fill="#ffffff"/>
</svg>
SVG;

        return 'data:image/svg+xml;base64,' . base64_encode($svg);
    }

    private function loadPdfLibrary(): void
    {
        if (class_exists(\Mpdf\Mpdf::class)) {
            return;
        }

        $autoloadCandidates = [
            $this->modulePath . 'vendor/autoload.php',
            dirname($this->modulePath, 2) . '/vendor/autoload.php',
        ];

        foreach ($autoloadCandidates as $autoloadFile) {
            if (is_file($autoloadFile)) {
                require_once $autoloadFile;
                if (class_exists(\Mpdf\Mpdf::class)) {
                    return;
                }
            }
        }

        throw new RuntimeException('mPDF autoloader not found for prestashopinventory module.');
    }
}
