PROJECT: Olist Brazilian E-Commerce Data Analysis
PHASE 11: BUSINESS RULE VALIDATION
DATABASE: MySQL
PURPOSE: Validate business rules, transaction consistency, operational chronology, identifier uniqueness, product attributes, and
         relationships across the Olist dataset.

TABLES INVESTIGATED:
    olist_orders_dataset
    olist_order_items_dataset
    olist_order_payments_dataset
    olist_order_reviews_dataset
    olist_products_dataset
    olist_sellers_dataset
    olist_customers_dataset
    product_category_name_translation

IMPORTANT DATA HANDLING PRINCIPLES:
    1. Preserve the original source tables.
    2. Do not invent missing values or replacement timestamps.
    3. Do not automatically classify every anomaly as invalid.
    4. Distinguish zero-date placeholders from genuine chronology anomalies.
    5. Investigate payment-to-item reconciliation exceptions before correction.
    6. Avoid direct joins to the duplicated product table when aggregating sales or freight.
    7. Document findings before implementing any cleaning action.

SECTION 1: ORDER STATUS AND REQUIRED TIMESTAMPS
OBJECTIVE: Check whether orders have the timestamps expected for their recorded statuses.

SQL QUERY:
SELECT
    order_status,
    COUNT(*) AS total_orders,

    SUM(CASE
        WHEN order_delivered_customer_date IS NULL
          OR CAST(order_delivered_customer_date AS CHAR)
                LIKE '0000-00-00%'
        THEN 1 ELSE 0
    END) AS missing_or_zero_customer_delivery,

    SUM(CASE
        WHEN order_delivered_carrier_date IS NULL
          OR CAST(order_delivered_carrier_date AS CHAR)
                LIKE '0000-00-00%'
        THEN 1 ELSE 0
    END) AS missing_or_zero_carrier_delivery,

    SUM(CASE
        WHEN order_approved_at IS NULL
          OR CAST(order_approved_at AS CHAR)
                LIKE '0000-00-00%'
        THEN 1 ELSE 0
    END) AS missing_or_zero_approval

FROM olist_orders_dataset
GROUP BY order_status
ORDER BY order_status;

OBSERVATION/RESULT:
The delivered group contained 96,478 orders, with no missing or zero customer-delivery or carrier-delivery timestamps in this check.
The original status-based check returned the following order counts:
    approved       2
    canceled     625
    created        5
    delivered  96,478
    invoiced     314
    processing   301
    shipped    1,107
    unavailable  609
No violations were identified in the specific status/timestamp conditions tested during the investigation.

CONCLUSION/DECISION:
The checked status/timestamp rules passed. This does not mean every timestamp is chronologically valid; chronology is assessed separately below.

SECTION 2: ORDER TIMESTAMP CHRONOLOGY
OBJECTIVE: Investigate the expected order of purchase, approval, carrier handoff, and customer delivery timestamps.
EXPECTED SEQUENCE:
    Purchase -> Approval -> Carrier Handoff -> Customer Delivery

SQL QUERY:
SELECT
    COUNT(*) AS total_orders,

    SUM(CASE
        WHEN order_approved_at < order_purchase_timestamp
        THEN 1 ELSE 0
    END) AS approval_before_purchase,

    SUM(CASE
        WHEN order_delivered_carrier_date < order_approved_at
        THEN 1 ELSE 0
    END) AS carrier_before_approval,

    SUM(CASE
        WHEN order_delivered_customer_date < order_delivered_carrier_date
        THEN 1 ELSE 0
    END) AS customer_delivery_before_carrier

FROM olist_orders_dataset;

OBSERVATION/RESULT:
The initial aggregate returned:
    Total orders:                         99,441
    Approval before purchase:                160
    Carrier before approval:               2,996
    Customer delivery before carrier:       1,206
These initial counts include zero-date placeholders, so they must not all be interpreted as genuine chronology violations.

FINDING 1: APPROVAL BEFORE PURCHASE
All 160 apparent violations were associated with '0000-00-00 00:00:00' approval timestamps.
Status breakdown:
    canceled:   141
    created:      5
    delivered:   14

FINDING 2: CARRIER BEFORE APPROVAL
The initial count included zero carrier timestamps. 
Investigation also identified records with nonzero timestamps where carrier handoff preceded approval.
Sample records showed gaps ranging from minutes to several days.
The exact number of genuine nonzero carrier-before-approval anomalies was not established in the recorded investigation.

FINDING 3: CUSTOMER DELIVERY BEFORE CARRIER
The initial count of 1,206 included 1,183 zero customer-delivery timestamps.
A further 23 delivered orders had nonzero timestamps where customer delivery was recorded before carrier handoff.

CONCLUSION/DECISION:
    - Treat zero-date timestamps as missing/invalid timestamp values requiring investigation, not as genuine historical events.
    - Flag the 23 confirmed nonzero customer-delivery chronology anomalies.
    - Flag nonzero carrier-before-approval anomalies for investigation.
    - Do not swap timestamps, invent replacement dates, or rewrite the raw data.

SECTION 3: PAYMENT VALUE VALIDATION
OBJECTIVE:
Check payment records for missing, zero, and negative payment values.
SQL QUERY:
SELECT
    COUNT(*) AS total_payment_records,

    SUM(CASE
        WHEN payment_value = 0
        THEN 1 ELSE 0
    END) AS zero_payment_values,

    SUM(CASE
        WHEN payment_value < 0
        THEN 1 ELSE 0
    END) AS negative_payment_values,

    SUM(CASE
        WHEN payment_value IS NULL
        THEN 1 ELSE 0
    END) AS null_payment_values

FROM olist_order_payments_dataset;

OBSERVATION/RESULT:
    Total payment records:       103,886
    Zero payment values:              9
    Negative payment values:          0
    NULL payment values:              0
The nine zero-value records comprised:
    - Three not_defined payment records on canceled orders.
    - Four zero-value voucher records on delivered orders.
    - Two zero-value voucher records on a shipped order.
Two zero-value voucher records belonged to the same order, with distinct payment_sequential values. That order had 29 voucher payment records in total.

CONCLUSION/DECISION:
No negative or NULL payment values were found. Zero-value payments require contextual interpretation and are not automatically invalid.
Preserve the records pending business-rule confirmation.

SECTION 4: PAYMENT INSTALLMENT VALIDATION
OBJECTIVE:
Check whether payment installment counts contain zero, negative, or NULL values.
  
SQL QUERY:
SELECT
    COUNT(*) AS total_payment_records,

    SUM(CASE
        WHEN payment_installments = 0
        THEN 1 ELSE 0
    END) AS zero_installments,

    SUM(CASE
        WHEN payment_installments < 0
        THEN 1 ELSE 0
    END) AS negative_installments,

    SUM(CASE
        WHEN payment_installments IS NULL
        THEN 1 ELSE 0
    END) AS null_installments

FROM olist_order_payments_dataset;

OBSERVATION/RESULT:
    Total payment records:       103,886
    Zero installments:                 2
    Negative installments:             0
    NULL installments:                 0
Both zero-installment records were credit-card payments on delivered orders,
with positive payment values:
    Order 1: payment value 129.94
    Order 2: payment value 58.69

CONCLUSION/DECISION:
Zero installments on credit-card records are potential business-rule violations. Investigate the payment convention before replacing zero with one.
No automatic correction is justified by the available evidence.

SECTION 5: PAYMENT TYPE VALIDATION
OBJECTIVE: Identify payment types and verify whether unexpected categories exist.

SQL QUERY:
SELECT
    payment_type,
    COUNT(*) AS payment_record_count
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY payment_record_count DESC;

OBSERVATION/RESULT:
    credit_card:  76,795
    boleto:       19,784
    voucher:       5,775
    debit_card:    1,529
    not_defined:       3
Total: 103,886 payment records.
The three not_defined records were zero-value payments on canceled orders.

CONCLUSION/DECISION:
The four recognized payment types account for 103,883 records.
The three not_defined records require review.
Do not invent replacement payment types.

SECTION 6: ORDER ITEM PRICE AND FREIGHT VALIDATION

OBJECTIVE:
Check order-item prices and freight values for missing, zero, and negative values.

SQL QUERY:
SELECT
    COUNT(*) AS total_order_items,

    SUM(CASE WHEN price = 0
        THEN 1 ELSE 0 END) AS zero_prices,

    SUM(CASE WHEN price < 0
        THEN 1 ELSE 0 END) AS negative_prices,

    SUM(CASE WHEN price IS NULL
        THEN 1 ELSE 0 END) AS null_prices,

    SUM(CASE WHEN freight_value = 0
        THEN 1 ELSE 0 END) AS zero_freight_values,

    SUM(CASE WHEN freight_value < 0
        THEN 1 ELSE 0 END) AS negative_freight_values,

    SUM(CASE WHEN freight_value IS NULL
        THEN 1 ELSE 0 END) AS null_freight_values

FROM olist_order_items_dataset;

OBSERVATION/RESULT:
    Total order items:          112,650
    Zero prices:                      0
    Negative prices:                  0
    NULL prices:                      0
    Zero freight values:            383
    Negative freight values:          0
    NULL freight values:              0
Context investigation found:
    - 382 zero-freight items belonged to orders where all item freight values were zero.
    - One zero-freight item belonged to an order containing both zero and positive freight values.

CONCLUSION/DECISION:
Item prices passed the tested checks. Zero freight is not automatically invalid; it may reflect free shipping, promotional arrangements, or another
order-level business rule. Preserve these values pending further evidence.

SECTION 7: REVIEW SCORE VALIDATION
OBJECTIVE: Verify that review scores fall within the expected 1-to-5 range and are not NULL.

SQL QUERY:
SELECT
    COUNT(*) AS total_reviews,

    SUM(CASE
        WHEN review_score < 1
        THEN 1 ELSE 0
    END) AS scores_below_one,

    SUM(CASE
        WHEN review_score > 5
        THEN 1 ELSE 0
    END) AS scores_above_five,

    SUM(CASE
        WHEN review_score IS NULL
        THEN 1 ELSE 0
    END) AS null_scores

FROM olist_order_reviews_dataset;

OBSERVATION/RESULT:
    Total reviews:       99,223
    Scores below 1:           0
    Scores above 5:           0
    NULL scores:              0

CONCLUSION/DECISION:
Review scores passed the tested range and completeness checks. No cleaning action is required for these conditions.

SECTION 8: DELIVERY PERFORMANCE AND ESTIMATED DELIVERY DATES
OBJECTIVE: Assess delivered orders against purchase dates and estimated delivery dates.

SQL QUERY:
SELECT
    COUNT(*) AS delivered_orders,

    SUM(CASE
        WHEN order_delivered_customer_date < order_purchase_timestamp
        THEN 1 ELSE 0
    END) AS delivery_before_purchase,

    SUM(CASE
        WHEN order_delivered_customer_date > order_estimated_delivery_date
        THEN 1 ELSE 0
    END) AS delivered_after_estimate,

    SUM(CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
        THEN 1 ELSE 0
    END) AS delivered_on_or_before_estimate

FROM olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND CAST(order_delivered_customer_date AS CHAR)
        NOT LIKE '0000-00-00%'
  AND CAST(order_estimated_delivery_date AS CHAR)
        NOT LIKE '0000-00-00%';

OBSERVATION/RESULT:
The original delivered-order investigation returned:
    Delivered orders:                    96,478
    Apparent delivery-before-purchase:        8
    Delivered after estimated date:        7,826
    Delivered on/before estimate:         88,652
All eight apparent delivery-before-purchase records had '0000-00-00 00:00:00' customer-delivery timestamps.
Estimated delivery date validation returned:
    Total orders:                    99,441
    NULL estimated dates:                  0
    Zero estimated dates:                  0
    Estimated dates before purchase:       0

CONCLUSION/DECISION:
The eight apparent delivery-before-purchase cases are zero-date placeholder issues, not confirmed actual delivery events before purchase.
The 7,826 late deliveries are operational performance findings, not automatically data-quality errors. Preserve them for delivery-performance analysis.

SECTION 9: ORDER ITEM IDENTIFIER VALIDATION
OBJECTIVE:
Check order-item identifiers and ensure the combination of order_id and order_item_id is unique.

SQL QUERY:
SELECT
    COUNT(*) AS total_order_items,

    SUM(CASE
        WHEN order_id IS NULL OR TRIM(order_id) = ''
        THEN 1 ELSE 0
    END) AS missing_order_ids,

    SUM(CASE
        WHEN product_id IS NULL OR TRIM(product_id) = ''
        THEN 1 ELSE 0
    END) AS missing_product_ids,

    SUM(CASE
        WHEN seller_id IS NULL OR TRIM(seller_id) = ''
        THEN 1 ELSE 0
    END) AS missing_seller_ids,

    SUM(CASE
        WHEN order_item_id IS NULL OR order_item_id <= 0
        THEN 1 ELSE 0
    END) AS invalid_order_item_ids

FROM olist_order_items_dataset;

OBSERVATION/RESULT:
    Total order items:           112,650
    Missing order IDs:                 0
    Missing product IDs:               0
    Missing seller IDs:                0
    Invalid order-item IDs:            0
Duplicate combination check:
    GROUP BY order_id, order_item_id
    HAVING COUNT(*) > 1
Result: 0 rows.

CONCLUSION/DECISION:
Order-item identifiers passed the tested checks. The combination (order_id, order_item_id) uniquely identifies the order-item records.

SECTION 10: PRODUCT PHYSICAL MEASUREMENTS
OBJECTIVE:
Check product weight and dimensions for NULL or nonpositive values.

SQL QUERY:
SELECT
    COUNT(*) AS total_product_records,

    SUM(CASE
        WHEN product_weight_g IS NULL
        THEN 1 ELSE 0
    END) AS null_weights,

    SUM(CASE
        WHEN product_weight_g <= 0
        THEN 1 ELSE 0
    END) AS nonpositive_weights,

    SUM(CASE
        WHEN product_length_cm IS NULL
        THEN 1 ELSE 0
    END) AS null_lengths,

    SUM(CASE
        WHEN product_length_cm <= 0
        THEN 1 ELSE 0
    END) AS nonpositive_lengths,

    SUM(CASE
        WHEN product_height_cm IS NULL
        THEN 1 ELSE 0
    END) AS null_heights,

    SUM(CASE
        WHEN product_height_cm <= 0
        THEN 1 ELSE 0
    END) AS nonpositive_heights,

    SUM(CASE
        WHEN product_width_cm IS NULL
        THEN 1 ELSE 0
    END) AS null_widths,

    SUM(CASE
        WHEN product_width_cm <= 0
        THEN 1 ELSE 0
    END) AS nonpositive_widths

FROM olist_products_dataset;
OBSERVATION/RESULT:
    Total product records:       65,902
    NULL weights:                      0
    Nonpositive weights:              12
    NULL lengths:                       0
    Nonpositive lengths:               4
    NULL heights:                       0
    Nonpositive heights:               4
    NULL widths:                        0
    Nonpositive widths:                4
The 12 affected rows corresponded to six distinct product IDs, with each product appearing twice in the product table.
All six distinct products appeared in delivered orders.

CONCLUSION/DECISION:
Nonpositive physical measurements are confirmed product-data quality issues.
They may affect dimensional-weight calculations, shipping estimates, and logistics analysis. Do not invent replacement measurements.

SECTION 11: PRODUCT CATEGORY COMPLETENESS
OBJECTIVE: Identify missing and blank product category names.

SQL QUERY:
SELECT
    COUNT(*) AS total_product_records,

    SUM(CASE
        WHEN product_category_name IS NULL
        THEN 1 ELSE 0
    END) AS null_categories,

    SUM(CASE
        WHEN product_category_name IS NOT NULL
         AND TRIM(product_category_name) = ''
        THEN 1 ELSE 0
    END) AS blank_categories

FROM olist_products_dataset;

OBSERVATION/RESULT:
    Total product records:       65,902
    NULL categories:                   0
    Blank categories:              1,220
The 1,220 blank-category records corresponded to 610 distinct product IDs.
All 610 distinct affected products had order activity.

CONCLUSION/DECISION:
Blank categories affect product segmentation and category-based demand analysis. 
Preserve the source values and flag the affected products.
Do not infer category names without evidence.

SECTION 12: PRODUCT CATEGORY TRANSLATION COVERAGE
OBJECTIVE: Check whether nonblank product categories have matching English translations.

SQL QUERY:
SELECT
    COUNT(DISTINCT p.product_category_name)
        AS distinct_nonblank_categories,

    COUNT(DISTINCT CASE
        WHEN t.product_category_name IS NOT NULL
        THEN p.product_category_name
    END) AS categories_with_translation,

    COUNT(DISTINCT CASE
        WHEN t.product_category_name IS NULL
        THEN p.product_category_name
    END) AS categories_without_translation

FROM olist_products_dataset AS p
LEFT JOIN product_category_name_translation AS t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND TRIM(p.product_category_name) <> '';

OBSERVATION/RESULT:
    Distinct nonblank categories:       73
    Categories with translation:        71
    Categories without translation:      2

The two categories without translations were:
    pc_gamer
    portateis_cozinha_e_preparadores_de_alimentos

Additional checks found:
    - Duplicate original-category mappings: 0 rows.
    - Total translation records: 71.
    - Missing/blank original category names in translation table: 0.
    - Missing/blank English translations in translation table: 0.

CONCLUSION/DECISION:
The translation table is complete for its existing 71 records but does not cover two nonblank product categories. 
This is a translation-coverage gap, not proof that the original categories are invalid.

SECTION 13: CUSTOMER AND SELLER STATE CODE VALIDATION

OBJECTIVE:
Validate state-code completeness, basic format, and recognized Brazilian state/Federal District values.

SQL QUERY: CUSTOMER FORMAT
SELECT
    COUNT(*) AS total_customer_records,

    SUM(CASE
        WHEN customer_state IS NULL
          OR TRIM(customer_state) = ''
        THEN 1 ELSE 0
    END) AS missing_state_codes,

    SUM(CASE
        WHEN customer_state IS NOT NULL
         AND TRIM(customer_state) <> ''
         AND TRIM(customer_state) NOT REGEXP '^[A-Z]{2}$'
        THEN 1 ELSE 0
    END) AS invalid_format_state_codes

FROM olist_customers_dataset;

OBSERVATION/RESULT:
    Customer records:             99,441
    Missing state codes:               0
    Invalid-format state codes:        0
Seller format check:
    Seller records:                3,095
    Missing state codes:               0
    Invalid-format state codes:        0
Both customer and seller values also passed the valid-value check against the recognized Brazilian state and Federal District abbreviations.

CONCLUSION/DECISION:
Customer and seller state codes passed the tested completeness, format, and valid-value checks. No cleaning action is required for these checks.

SECTION 14: CUSTOMER AND SELLER POSTAL CODE PREFIXES

OBJECTIVE:
Check numeric postal-code prefixes and investigate values stored with fewer than five digits.

OBSERVATION/RESULT:
CUSTOMERS:
    Total records:                    99,441
    Values outside numeric range:          0
    Prefixes stored with fewer than
    five digits:                     23,995
    Minimum stored value:              1,003
    Maximum stored value:             99,990

SELLERS:
    Total records:                     3,095
    Values outside numeric range:          0
    Prefixes stored with fewer than
    five digits:                      1,027
    Minimum stored value:              1,001
    Maximum stored value:             99,730

The postal-code prefix columns are stored as integers, so leading zeros cannot be preserved in the stored numeric representation.

CONCLUSION/DECISION:
The values passed numeric-range checks. Prefixes with fewer than five stored digits may have lost leading zeros because of the integer data type.
For reporting or geographic analysis, use a derived five-character representation, for example LPAD(CAST(customer_zip_code_prefix AS CHAR), 5, '0').
Do not overwrite the raw numeric columns without an approved cleaning plan.

SECTION 15: PRODUCT TABLE DUPLICATION
OBJECTIVE:
Investigate product identifier uniqueness and determine whether duplicate product records are identical.

SQL QUERY:
SELECT
    COUNT(*) AS total_product_records,
    COUNT(DISTINCT product_id) AS distinct_product_ids,
    COUNT(*) - COUNT(DISTINCT product_id) AS excess_product_records
FROM olist_products_dataset;

OBSERVATION/RESULT:
    Total product records:        65,902
    Distinct product IDs:         32,951
    Excess product records:       32,951

Occurrence-count analysis showed:
    Product IDs appearing once:        0
    Product IDs appearing twice:  32,951
    Product IDs appearing more
    than twice:                         0

Comparisons across the eight available product attributes found:
    Product IDs with conflicting non-NULL values: 0
    Product IDs with inconsistent NULL patterns:  0

Complete duplicate-group analysis returned:
    Duplicate product-record groups:  32,951
    Records in duplicate groups:      65,902
    Excess duplicate records:         32,951

CONCLUSION/DECISION:
Every distinct product ID appears exactly twice, with identical values across the eight checked attributes. 
This is a confirmed duplication issue in the product table.
Preserve the raw table.
Create and validate a deduplicated product table or view during the cleaning phase before using product attributes in analytical joins.

SECTION 16: IMPACT OF PRODUCT DUPLICATION ON ORDER-ITEM JOINS

OBJECTIVE:
Determine whether duplicated product records multiply order-item rows and inflate sales and freight totals.

SQL QUERY:
SELECT
    (SELECT COUNT(*)
     FROM olist_order_items_dataset) AS total_order_item_records,

    COUNT(*) AS rows_after_product_join,

    COUNT(DISTINCT oi.order_id, oi.order_item_id)
        AS distinct_order_item_identifiers

FROM olist_order_items_dataset AS oi
JOIN olist_products_dataset AS p
    ON oi.product_id = p.product_id;

OBSERVATION/RESULT:
    Original order-item records:        112,650
    Rows after product join:            225,300
    Distinct order-item identifiers:    112,650

Sales and freight comparison:
    Original item sales:        13,591,643.701720357
    Joined item sales:          27,183,287.403440714
    Original freight:            2,251,909.5430001207
    Joined freight:              4,503,819.086000241
Both sales and freight totals doubled after joining to the raw product table.

CONCLUSION/DECISION:
Direct joins to the raw product table can overstate sales, freight, and other order-item metrics by 100%.
Use a validated one-row-per-product dataset for analytical joins. 
Confirm that the cleaned product table has unique product IDs before aggregation.

SECTION 17: SELLER, CUSTOMER, AND ORDER IDENTIFIER UNIQUENESS
OBJECTIVE:
Validate identifier uniqueness in the seller, customer, and order tables.

OBSERVATION/RESULT:
SELLERS:
    Total records:             3,095
    Distinct seller IDs:       3,095
    Excess records:                0

CUSTOMERS:
    Total records:            99,441
    Distinct customer IDs:    99,441
    Excess records:                0

ORDERS:
    Total records:            99,441
    Distinct order IDs:       99,441
    Excess records:                0

CONCLUSION/DECISION:
The tested seller, customer, and order identifiers are unique in their respective tables. 
No cleaning action is required for these identifier checks.

SECTION 18: ORDER ITEM REFERENCES TO ORDERS, PRODUCTS, AND SELLERS
OBJECTIVE:
Check whether order-item records reference existing orders, products, and sellers.

SQL QUERY:
SELECT
    COUNT(*) AS total_order_item_records,

    SUM(CASE
        WHEN p.product_id IS NULL
        THEN 1 ELSE 0
    END) AS items_with_missing_products,

    SUM(CASE
        WHEN s.seller_id IS NULL
        THEN 1 ELSE 0
    END) AS items_with_missing_sellers

FROM olist_order_items_dataset AS oi

LEFT JOIN (
    SELECT DISTINCT product_id
    FROM olist_products_dataset
) AS p
    ON oi.product_id = p.product_id

LEFT JOIN olist_sellers_dataset AS s
    ON oi.seller_id = s.seller_id;

OBSERVATION/RESULT:
    Total order-item records:       112,650
    Items with missing products:          0
    Items with missing sellers:           0

The separate order-reference check returned:
    Total order-item records:       112,650
    Items with missing orders:            0

The seller join also preserved the row count:
    Original order-item records:    112,650
    Rows after seller join:         112,650
    Distinct order-item identifiers:112,650

CONCLUSION/DECISION:
All tested order-item records reference existing orders, products, and sellers.
Seller joins do not multiply order-item rows.
The DISTINCT product-ID subquery is essential when checking product references because the raw product table contains duplicate product IDs.

SECTION 19: PAYMENT IDENTIFIER UNIQUENESS AND ORDER REFERENCES
OBJECTIVE:
Validate payment identifiers and confirm that payment records reference existing orders.

SQL QUERY:
SELECT
    COUNT(*) AS total_payment_records,

    COUNT(DISTINCT order_id, payment_sequential)
        AS distinct_payment_identifiers,

    COUNT(*) - COUNT(DISTINCT order_id, payment_sequential)
        AS duplicate_payment_identifiers

FROM olist_order_payments_dataset;

OBSERVATION/RESULT:
    Total payment records:               103,886
    Distinct payment identifiers:        103,886
    Duplicate payment identifiers:             0

The payment-to-order reference check returned:
    Total payment records:               103,886
    Payments with missing orders:               0

CONCLUSION/DECISION:
The combination of order_id and payment_sequential uniquely identifies payment records, and all payment records reference existing orders.
No cleaning action is required for these checks.

SECTION 20: PAYMENT-TO-ORDER-ITEM RECONCILIATION
OBJECTIVE:
Identify orders with payment records but no order-item records, and orders with order-item records but no payment records.

SQL QUERY: PAYMENTS WITHOUT ITEMS
SELECT
    COUNT(*) AS orders_with_payments_but_no_items
FROM (
    SELECT DISTINCT p.order_id
    FROM olist_order_payments_dataset AS p
    LEFT JOIN olist_order_items_dataset AS oi
        ON p.order_id = oi.order_id
    WHERE oi.order_id IS NULL
) AS unmatched_orders;

OBSERVATION/RESULT:
    Orders with payments but no items: 775

Status breakdown:
    unavailable: 603 orders; payment total 124,339.02
    canceled:    164 orders; payment total  37,337.87
    created:       5 orders; payment total     688.10
    invoiced:      2 orders; payment total     149.23
    shipped:       1 order;  payment total      77.73

Total:
    775 orders
    Approximately 162,591.95 in recorded payments

SQL QUERY: ITEMS WITHOUT PAYMENTS
SELECT
    COUNT(*) AS orders_with_items_but_no_payments
FROM (
    SELECT DISTINCT oi.order_id
    FROM olist_order_items_dataset AS oi
    LEFT JOIN olist_order_payments_dataset AS p
        ON oi.order_id = p.order_id
    WHERE p.order_id IS NULL
) AS unmatched_orders;

OBSERVATION/RESULT:
    Orders with items but no payment records: 1
The affected order was:
    bfbd0f9bdef84302105ad712db648a6c
Its recorded details were:
    Status: delivered
    Item records: 3
    Item value: approximately 134.97
    Freight value: approximately 8.49
    Payment records: 0

CONCLUSION/DECISION:
Two reconciliation exceptions were identified:
    1. 775 orders have payment records but no item records.
    2. One delivered order has item records but no payment record.

Most of the 775 orders are unavailable or canceled, but eight have other statuses. 
The exceptions should not automatically be treated as invalid payments or missing transactions without additional business context.
Do not delete payment records, invent item records, or invent payment records.
Preserve the data and investigate these exceptions during the cleaning and business interpretation stages.

SECTION 21: REVIEW COMMENT COMPLETENESS
OBJECTIVE:
Check whether reviews have written titles and messages, while distinguishing missing written feedback from missing review scores.

OBSERVATION/RESULT:
    Total reviews:                       99,223
    NULL review titles:                       0
    Blank review titles:                  87,657
    NULL review messages:                      0
    Blank review messages:                58,256

A separate investigation found:
    Reviews with blank messages:          58,256
    Reviews with written messages:         40,967

Review scores were present and valid for all 99,223 records.

CONCLUSION/DECISION:
A review without a written message is not automatically invalid if its score is present.
Do not delete rating-only reviews.
Blank title and message fields may be documented as feedback-completeness characteristics. 
Any normalization of blank strings to NULL should be handled as a separate, justified cleaning decision.

SECTION 22: FINAL PHASE 10 SUMMARY
CONFIRMED DATA-QUALITY ISSUES:
    1. Every product ID appears twice in the raw product table.
    2. Direct product joins double order-item rows, sales, and freight totals.
    3. Six distinct products have nonpositive physical measurements and appear in delivered orders.
    4. 610 distinct products have blank category names and have order activity.
    5. Two nonblank product categories lack English translations.
    6. Two credit-card payment records have zero installments.
    7. Three canceled orders have zero-value not_defined payments.
    8. Zero-date placeholders create misleading chronology findings.
    9. Twenty-three delivered orders have nonzero customer-delivery timestamps preceding their carrier handoff timestamps.
   10. Nonzero carrier-before-approval chronology anomalies were observed; their exact total was not established in the recorded investigation.
   11. 775 orders have payment records but no order-item records.
   12. One delivered order has order-item records but no payment record.
   13. Customer and seller postal-code prefixes with fewer than five stored digits may have lost leading zeros due to integer storage.

CHECKS THAT PASSED:
    - Review scores are within the 1-to-5 range and are not NULL.
    - Item prices have no zero, negative, or NULL values.
    - No negative or NULL payment values were found.
    - Estimated delivery dates passed the tested completeness and chronology checks.
    - Customer and seller state codes passed format and valid-value checks.
    - Customer IDs, seller IDs, and order IDs are unique.
    - Payment identifier combinations are unique.
    - Order-item identifiers passed the tested checks.
    - Order items reference existing orders, products, and sellers.
    - Payments reference existing orders.
    - Product translation records contain no duplicate original-category mappings or blank translation fields.

FINAL CONCLUSION:
Phase 10 identified several business-rule exceptions and analytical risks.
The findings provide a basis for the subsequent data-cleaning phase and operational analysis.
No raw source data should be altered solely because an anomaly was found.
Each cleaning action must be justified, implemented in a controlled cleaned table or view, and validated against the relevant business rule.

