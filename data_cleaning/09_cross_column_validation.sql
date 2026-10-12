FILE: 08_cross_column_validation.sql
PROJECT: Olist E-Commerce Data Analysis
PHASE: Data Cleaning
TOPIC: Cross-Column Validation

OBJECTIVE
Validate relationships between related columns to identify inconsistent combinations of values, suspicious operational records, and potential
data-quality issues that cannot be identified by examining individual columns in isolation.
This phase focuses on CROSS-COLUMN VALIDATION, not automatic data modification.
The objectives are to:
1. Identify inconsistencies between product weights and dimensions.
2. Validate order statuses against delivery timestamps.
3. Investigate chronological relationships between order timestamps.
4. Compare actual delivery dates with estimated delivery dates.
5. Investigate unusual relationships between item prices and freight charges.
6. Compare order-item totals and freight totals with recorded payment totals.
7. Identify canceled orders with unusual item and payment relationships.
8. Distinguish confirmed inconsistencies from legitimate business variation.
9. Preserve source data and document findings for subsequent cleaning decisions.

IMPORTANT
The following assessments have already been performed:
    04_invalid_value_assessment.sql
    05_data_type_assessment.sql
    07_date_and_timestamp_validation.sql
This phase builds on those assessments by examining relationships between columns and related tables.
This phase does NOT automatically delete records, replace measurements, change order statuses, or invent missing values.

SOURCE TABLES
1. olist_products_dataset
2. olist_orders_dataset
3. olist_order_items_dataset
4. olist_order_payments_dataset

METHODOLOGY
The investigation uses:
1. Conditional comparisons between related columns.
2. Date and timestamp chronology checks.
3. Status-to-timestamp consistency checks.
4. Product measurement relationship checks.
5. Order-level aggregation and financial reconciliation.
6. Investigation of unusual price and freight relationships.

IMPORTANT INTERPRETATION
An unusual relationship does not automatically establish that a record is incorrect.
For example:
Zero product weight with positive dimensions May indicate incomplete product measurements.
A delivered order with a zero customer-delivery timestamp Conflicts with the expected order lifecycle.
Freight greater than item price May be legitimate depending on shipping conditions.
Payment totals differing from item plus freight totals May require investigation of payment and order business rules.
Delivery after the estimated date Indicates late delivery, not necessarily a data-quality error.
All findings must therefore be interpreted before corrective action is considered.

SECTION 1: PRODUCT WEIGHT AND DIMENSION VALIDATION
OBJECTIVE
Identify products whose recorded weights and dimensions may be incomplete or inconsistent.
The investigation focuses on:
1. Products with zero weight and positive dimensions.
2. Products with zero weight and all three dimensions equal to zero.
The raw product table contains duplicate product records. DISTINCT product_id records are therefore used where appropriate to avoid treating duplicate
records as separate products.

QUERY 1: IDENTIFY ZERO-WEIGHT PRODUCTS WITH POSITIVE DIMENSIONS
SQL QUERY : 
SELECT DISTINCT
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_products_dataset
WHERE product_weight_g = 0
  AND product_length_cm > 0
  AND product_height_cm > 0
  AND product_width_cm > 0;

RESULT
Distinct products identified = 4

OBSERVATION
Four distinct products have zero recorded weight while all three dimensions are positive.
These products have physical dimensions but no recorded weight.
The available data does not establish their correct weights.

CONCLUSION
The four products are candidates for measurement-completeness investigation.
No weight values are automatically replaced.

QUERY 2: IDENTIFY PRODUCTS WITH ZERO WEIGHT AND ZERO DIMENSIONS
SQL QUERY :
SELECT DISTINCT
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_products_dataset
WHERE product_weight_g = 0
  AND product_length_cm = 0
  AND product_height_cm = 0
  AND product_width_cm = 0;

RESULT
Distinct products identified = 2

OBSERVATION
Two distinct products have zero weight and zero values for all three dimensions.
One product has a blank product category. The other belongs to the bebes category.
The available data does not establish whether these values represent missing measurements or a source-data convention.

PRODUCT MEASUREMENT SUMMARY
Products with zero weight and positive dimensions = 4
Products with zero weight and all dimensions zero  = 2
Total distinct products identified               = 6
Corresponding raw product rows                    = 12

DECISION
Flag the six products for measurement-completeness review.
Do not infer or manufacture product measurements.
No raw product records are modified.

SECTION 2: ORDER STATUS AND CUSTOMER DELIVERY DATE VALIDATION
OBJECTIVE
Determine whether customer-delivery timestamps are consistent with order statuses.
Zero-date placeholders such as: 0000-00-00 00:00:00 require special handling because they may not behave like SQL NULL values.
The zero-date check uses CAST(... AS CHAR) to avoid direct DATETIME comparisons against invalid zero-date values.

QUERY 3: SUMMARIZE CUSTOMER DELIVERY DATES BY ORDER STATUS
SQL QUERY : 
SELECT
    order_status,
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN CAST(order_delivered_customer_date AS CHAR)
                 LIKE '0000-00-00%'
            THEN 1
            ELSE 0
        END
    ) AS zero_customer_delivery_dates,
    SUM(
        CASE
            WHEN order_delivered_customer_date IS NOT NULL
             AND CAST(order_delivered_customer_date AS CHAR)
                 NOT LIKE '0000-00-00%'
            THEN 1
            ELSE 0
        END
    ) AS nonzero_customer_delivery_dates
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY order_status;

RESULT
Total orders = 99441
Zero customer-delivery timestamps = 2965
Non-zero customer-delivery timestamps = 96476
Order status distribution:
    approved:
        Total orders = 2
        Zero customer-delivery dates = 2
    canceled:
        Total orders = 625
        Zero customer-delivery dates = 619
    created:
        Total orders = 5
        Zero customer-delivery dates = 5
    delivered:
        Total orders = 96478
        Zero customer-delivery dates = 8
    invoiced:
        Total orders = 314
        Zero customer-delivery dates = 314
    processing:
        Total orders = 301
        Zero customer-delivery dates = 301
    shipped:
        Total orders = 1107
        Zero customer-delivery dates = 1107
    unavailable:
        Total orders = 609
        Zero customer-delivery dates = 609

OBSERVATION
Most zero customer-delivery timestamps belong to orders that have not reached the delivered status.
However, eight orders marked delivered have zero customer-delivery timestamps.
This combination conflicts with the expected relationship between a completed delivery status and a valid customer-delivery timestamp.

QUERY 4: INSPECT DELIVERED ORDERS WITH ZERO CUSTOMER DELIVERY DATES
SQL QUERY : 
SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM olist_orders_dataset
WHERE order_status = 'delivered'
  AND CAST(order_delivered_customer_date AS CHAR)
      LIKE '0000-00-00%';

RESULT
Delivered orders with zero customer-delivery timestamps = 8
Seven orders have a non-zero carrier-delivery timestamp.
One order: 2d858f451373b04fb5c984a1cc2defaf has zero carrier-delivery and customer-delivery timestamps.
All eight have purchase, approval, and estimated delivery timestamps.

OBSERVATION
The eight orders have incomplete or invalid delivery timestamp information despite being marked delivered.
The correct delivery timestamps cannot be inferred from the available columns.

DECISION
Flag the eight orders for order-lifecycle validation.
Do not invent delivery timestamps or automatically change order statuses.

QUERY 5: IDENTIFY CANCELED ORDERS WITH CUSTOMER DELIVERY DATES
SQL QUERY :
SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM olist_orders_dataset
WHERE order_status = 'canceled'
  AND order_delivered_customer_date IS NOT NULL
  AND CAST(order_delivered_customer_date AS CHAR)
      NOT LIKE '0000-00-00%';

RESULT
Canceled orders with non-zero customer-delivery timestamps = 6
All six also have non-zero carrier-delivery timestamps.
  
OBSERVATION
The six orders combine a canceled status with recorded carrier and customer delivery timestamps.
This conflicts with the usual interpretation of the order status.
However, the data does not establish whether the status or timestamps are incorrect, or whether the records reflect a more complicated operational history.

DECISION
Flag the six records for business-rule review.
Do not automatically change their statuses or remove their timestamps.

SECTION 3: ORDER TIMESTAMP CHRONOLOGY VALIDATION
OBJECTIVE
Investigate whether related order timestamps follow the expected chronological sequence.
The relationships examined are:
1. Approval should not ordinarily precede purchase.
2. Carrier delivery should not ordinarily precede purchase.
3. Customer delivery should not ordinarily precede carrier delivery.

QUERY 6: CHECK ORDER TIMESTAMP SEQUENCING
SQL QUERY : 
SELECT
    COUNT(*) AS total_orders,
    SUM(
        CASE
            WHEN order_approved_at IS NOT NULL
             AND CAST(order_approved_at AS CHAR)
                 NOT LIKE '0000-00-00%'
             AND order_approved_at < order_purchase_timestamp
            THEN 1
            ELSE 0
        END
    ) AS approval_before_purchase,

    SUM(
        CASE
            WHEN order_delivered_carrier_date IS NOT NULL
             AND CAST(order_delivered_carrier_date AS CHAR)
                 NOT LIKE '0000-00-00%'
             AND order_delivered_carrier_date < order_purchase_timestamp
            THEN 1
            ELSE 0
        END
    ) AS carrier_before_purchase,

    SUM(
        CASE
            WHEN order_delivered_customer_date IS NOT NULL
             AND CAST(order_delivered_customer_date AS CHAR)
                 NOT LIKE '0000-00-00%'
             AND order_delivered_carrier_date IS NOT NULL
             AND CAST(order_delivered_carrier_date AS CHAR)
                 NOT LIKE '0000-00-00%'
             AND order_delivered_customer_date
                 < order_delivered_carrier_date
            THEN 1
            ELSE 0
        END
    ) AS customer_before_carrier
FROM olist_orders_dataset;

RESULT
Total orders = 99441
Approval before purchase = 0
Carrier delivery before purchase = 166
Customer delivery before carrier delivery = 23

OBSERVATION
No approval-before-purchase violations were identified.
However:
    166 orders have carrier-delivery timestamps before purchase.
    23 orders have customer-delivery timestamps before carrier delivery.
These counts represent violations of separate chronology rules. They are not necessarily counts of distinct affected orders because a single order
may violate more than one rule.

DECISION
Flag the chronology violations for timestamp validation.
Do not automatically reorder timestamps or substitute assumed values.

SECTION 4: ACTUAL DELIVERY VERSUS ESTIMATED DELIVERY
  
OBJECTIVE
Determine how many completed deliveries occurred after their estimated delivery dates.
This validation supports operational performance analysis.
A late delivery is not automatically a data-quality error.

QUERY 7: IDENTIFY LATE DELIVERIES
SQL QUERY :
SELECT
    COUNT(*) AS delivered_orders_with_valid_dates,
    SUM(
        CASE
            WHEN order_delivered_customer_date
                 > order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delivered_after_estimate,
    SUM(
        CASE
            WHEN order_delivered_customer_date
                 <= order_estimated_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS delivered_on_time_or_early
FROM olist_orders_dataset
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL
  AND CAST(order_delivered_customer_date AS CHAR)
      NOT LIKE '0000-00-00%'
  AND CAST(order_estimated_delivery_date AS CHAR)
      NOT LIKE '0000-00-00%';

RESULT
Delivered orders with valid dates = 96470
Delivered after estimate         = 7826
Delivered on time or early       = 88644
Late delivery rate               = approximately 8.11%
On-time or early delivery rate   = approximately 91.89%

OBSERVATION
A total of 7826 delivered orders arrived after their estimated delivery dates.
The other 88644 orders were delivered on or before their estimated dates.

CONCLUSION
These results describe delivery performance rather than confirmed data-quality errors.
The late-delivery records should be retained for operational analysis unless separate evidence establishes that their timestamps are incorrect.

SECTION 5: ORDER ITEM PRICE AND FREIGHT VALIDATION
OBJECTIVE
Identify unusual relationships between order-item prices and freight charges.
Freight charges may exceed item prices for legitimate reasons. Such relationships should be investigated rather than automatically classified as invalid.

QUERY 8: IDENTIFY FREIGHT CHARGES GREATER THAN ITEM PRICES
SQL QUERY :
SELECT
    COUNT(*) AS affected_item_records,
    COUNT(DISTINCT order_id) AS affected_orders,
    COUNT(DISTINCT product_id) AS affected_products,
    COUNT(DISTINCT seller_id) AS affected_sellers,
    MIN(price) AS minimum_item_price,
    MAX(price) AS maximum_item_price,
    MIN(freight_value) AS minimum_freight,
    MAX(freight_value) AS maximum_freight,
    SUM(price) AS total_item_price,
    SUM(freight_value) AS total_freight
FROM olist_order_items_dataset
WHERE freight_value > price;

RESULT
Affected item records = 4124
Affected orders = 3346
Affected products = 1896
Affected sellers = 644
Minimum item price = 0.85
Maximum item price = 189.90
Minimum freight = 7.39
Maximum freight = 299.16
Total item price = 72678.81
Total freight = 100348.57
Order status distribution:
    delivered:
        Item records = 4008
        Distinct orders = 3260
    shipped:
        Item records = 64
        Distinct orders = 52
    processing:
        Item records = 23
        Distinct orders = 14
    canceled:
        Item records = 19
        Distinct orders = 12
    invoiced:
        Item records = 10
        Distinct orders = 8

OBSERVATION
A total of 4124 order-item records have freight charges greater than their item prices.
The records span 3346 orders, 1896 products, and 644 sellers.
Most affected records belong to delivered orders.
The available data does not establish that these freight charges are incorrect.

DECISION
Retain the freight values pending business-rule validation.
Do not cap or replace freight charges merely because they exceed item prices.

QUERY 9: INVESTIGATE ZERO-FREIGHT RECORDS
SQL QUERY : 
SELECT
    COUNT(*) AS zero_freight_item_records,
    COUNT(DISTINCT order_id) AS affected_orders,
    COUNT(DISTINCT product_id) AS affected_products,
    COUNT(DISTINCT seller_id) AS affected_sellers,
    MIN(price) AS minimum_item_price,
    MAX(price) AS maximum_item_price,
    SUM(price) AS total_item_price
FROM olist_order_items_dataset
WHERE freight_value = 0;

RESULT
Zero-freight item records = 383
Affected orders = 339
Affected products = 10
Minimum item price = 53.90
Maximum item price = 712.90
Total item price = 37764.37

OBSERVATION
The 383 zero-freight records are concentrated among ten products and a limited number of sellers.
Among the 339 affected orders:
    338 orders have only zero-freight item records.
    1 order contains both zero-freight and positive-freight item records.
The mixed-freight order is:
    80850824446cd379f755548b967c61b9
Its item total is 166.00, freight total is 18.88, and payment total is approximately 184.88.
The order reconciles within normal numeric precision.

CONCLUSION
Zero freight is a pattern requiring business interpretation, not a confirmed data-quality error.
Possible explanations cannot be established from the available columns.

DECISION
Retain all zero-freight values pending shipping-rule validation.
  
SECTION 6: ORDER ITEM, FREIGHT, AND PAYMENT RECONCILIATION
OBJECTIVE
Determine whether order-level item totals plus freight totals reconcile with recorded payment totals.
Item totals and payment totals must be aggregated separately before joining them by order_id.
Joining individual item records directly to individual payment records before aggregation can multiply rows and produce incorrect totals.

QUERY 10: RECONCILE ORDER-LEVEL TOTALS
SQL QUERY : 
WITH item_totals AS (
    SELECT
        order_id,
        SUM(price) AS item_total,
        SUM(freight_value) AS freight_total
    FROM olist_order_items_dataset
    GROUP BY order_id
),
payment_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
),
reconciliation AS (
    SELECT
        i.order_id,
        i.item_total,
        i.freight_total,
        p.payment_total,
        i.item_total + i.freight_total AS expected_total,
        (i.item_total + i.freight_total) - p.payment_total
            AS difference
    FROM item_totals AS i
    INNER JOIN payment_totals AS p
        ON i.order_id = p.order_id
)
SELECT
    COUNT(*) AS orders_compared,

    SUM(
        CASE
            WHEN ABS(difference) <= 0.01 THEN 1
            ELSE 0
        END
    ) AS reconciled_within_one_cent,

    SUM(
        CASE
            WHEN ABS(difference) > 0.01 THEN 1
            ELSE 0
        END
    ) AS unreconciled_orders,

    MIN(difference) AS minimum_difference,
    MAX(difference) AS maximum_difference
FROM reconciliation;

RESULT
Orders compared = 98665
Reconciled within 0.01 = 98213
Unreconciled orders = 452

OBSERVATION
A total of 98213 orders reconcile within one cent.
A further 452 orders have differences greater than one cent.
The discrepancy direction was:
    Payment total greater than item plus freight = 311 orders
    Item plus freight greater than payment total = 141 orders
The discrepancies may require further investigation of applicable payment and order business rules.
The available data does not establish the cause of every difference.

DECISION
Flag the 452 orders for financial reconciliation review.
Do not automatically modify payment values, item prices, or freight values.

IMPORTANT
The reconciliation assumes that item prices plus freight should equal recorded payment totals for the orders being compared.
Before applying this as a universal business rule, the analysis must consider order lifecycle, payment processing, and any applicable adjustments.

SECTION 7: CANCELED ORDERS AND PAYMENT RELATIONSHIPS
OBJECTIVE
Investigate canceled orders that have payment records and identify canceled orders without corresponding order-item records.

QUERY 11: SUMMARIZE CANCELED ORDER PAYMENTS
SQL QUERY :
SELECT
    o.order_status,
    COUNT(DISTINCT o.order_id) AS canceled_orders,
    COUNT(DISTINCT p.order_id) AS orders_with_payments,
    COUNT(p.order_id) AS payment_records,
    SUM(p.payment_value) AS total_recorded_payments
FROM olist_orders_dataset AS o
LEFT JOIN olist_order_payments_dataset AS p
    ON o.order_id = p.order_id
WHERE o.order_status = 'canceled'
GROUP BY o.order_status;

RESULT
Canceled orders = 625
Canceled orders with payment records = 625
Payment records = 664
Total recorded payments = approximately 143255.60

OBSERVATION
All 625 canceled orders have payment records.
The payment table contains 664 records because some orders have multiple payment records.
The existence of payment records does not establish whether the money was ultimately captured, refunded, or otherwise settled.

DECISION
Do not classify every canceled order with a payment record as a data-quality error.
Refund and settlement information would be needed to establish the final financial outcome.

QUERY 12: IDENTIFY CANCELED ORDERS WITHOUT ITEM RECORDS
SQL QUERY : 
WITH canceled_orders AS (
    SELECT
        order_id
    FROM olist_orders_dataset
    WHERE order_status = 'canceled'
),
payment_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
)
SELECT
    COUNT(*) AS canceled_orders_without_items,
    SUM(
        CASE
            WHEN p.order_id IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS orders_with_payment_records,
    SUM(p.payment_total) AS total_recorded_payments
FROM canceled_orders AS o
LEFT JOIN olist_order_items_dataset AS i
    ON o.order_id = i.order_id
LEFT JOIN payment_totals AS p
    ON o.order_id = p.order_id
WHERE i.order_id IS NULL;

RESULT
Canceled orders without item records = 164
Orders with payment records = 164
Total recorded payments = approximately 37337.87
Additional investigation established:
    161 orders have positive recorded payment totals.
    3 orders have zero recorded payment totals.
The three zero-payment orders are:
    00b1cb0320190ca0daa2c88b35206009
    4637ca194b6387e2d538dc89b124b0ee
    c8c528189310eaa44a745b8d9d26908b
Each has one payment record with:
    payment_type = not_defined
    payment_sequential = 1
    payment_installments = 1
    payment_value = 0

OBSERVATION
The absence of item records prevents direct item-total reconciliation for these 164 canceled orders.
The three zero-payment records correspond to the previously identified not_defined payment-type issue.
The available data does not establish why the other canceled orders lack item records.

DECISION
Flag the 164 orders for relationship and business-context review.
Do not create synthetic order-item records or infer missing product values.

SECTION 8: HIGH ITEM PRICE CROSS-COLUMN INVESTIGATION
OBJECTIVE
Investigate whether the highest item prices are accompanied by product and order attributes that establish an obvious inconsistency.
High item prices were already investigated during: 07_outlier_investigation.sql
This section uses related columns to assess whether additional evidence confirms any of those prices as invalid.

QUERY 13: INSPECT THE HIGHEST-PRICED ORDER ITEMS
SQL QUERY : 
SELECT
    oi.order_id,
    oi.product_id,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    o.order_status,
    p.product_category_name,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM olist_order_items_dataset AS oi
LEFT JOIN olist_orders_dataset AS o
    ON oi.order_id = o.order_id
LEFT JOIN (
    SELECT DISTINCT
        product_id,
        product_category_name,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm
    FROM olist_products_dataset
) AS p
    ON oi.product_id = p.product_id
ORDER BY oi.price DESC
LIMIT 10;

RESULT
Highest observed item price = 6735.00
The highest-priced items belong to varied categories, including:
    utilidades_domesticas
    pcs
    artes
    eletroportateis
    instrumentos_musicais
    consoles_games
    esporte_lazer
All ten highest-priced items belong to delivered orders.
The inspected physical product attributes were positive.

OBSERVATION
The available category, physical measurement, and order-status information does not establish that the high prices are invalid.
Positive product measurements and a delivered status do not independently prove that a price is correct.
The raw product table contains duplicate product records. The DISTINCT product-attribute subquery reduces the risk of multiplying order-item 
records during the join.

DECISION
Retain the high-priced items.
No confirmed price error was established by the cross-column investigation.

SECTION 9: HIGH FREIGHT CROSS-COLUMN INVESTIGATION
OBJECTIVE
Investigate the relationship between freight charges and item prices to identify unusual business patterns.

QUERY 14: CHECK FREIGHT RELATIVE TO ITEM PRICE
SQL QUERY : 
SELECT
    COUNT(*) AS total_item_records,
    SUM(
        CASE
            WHEN freight_value > price THEN 1
            ELSE 0
        END
    ) AS freight_greater_than_price,

    SUM(
        CASE
            WHEN freight_value >= 0.5 * price THEN 1
            ELSE 0
        END
    ) AS freight_at_least_half_price,

    SUM(
        CASE
            WHEN freight_value >= price THEN 1
            ELSE 0
        END
    ) AS freight_at_least_item_price

FROM olist_order_items_dataset;

RESULT
Total item records = 112650
Freight greater than item price = 4124
Freight at least 50% of item price = 18944
Freight at least 100% of item price = 4124

OBSERVATION
Freight exceeds item price in 4124 records, representing approximately 3.66% of all order-item records.
These records span 3346 orders, 1896 products, and 644 sellers.
The available data does not establish that these charges are incorrect.

DECISION
Retain the freight values pending business-rule validation.
Do not cap freight charges solely because they exceed item prices or statistical thresholds.

FINAL PHASE 08 SUMMARY
INVESTIGATIONS COMPLETED
1. PRODUCT WEIGHT AND DIMENSIONS
   Products with zero weight and positive dimensions = 4
   Products with zero weight and all dimensions zero = 2
   Total distinct products identified = 6
   Decision:
       Flag for measurement-completeness review.
       Do not infer missing measurements.

2. ORDER STATUS AND DELIVERY TIMESTAMPS
   Delivered orders with zero customer-delivery timestamps = 8
   Canceled orders with non-zero customer-delivery timestamps = 6
   Decision:
       Flag for order-lifecycle validation.
       Do not invent timestamps or automatically change statuses.

3. ORDER TIMESTAMP CHRONOLOGY
   Approval before purchase = 0
   Carrier delivery before purchase = 166
   Customer delivery before carrier delivery = 23
   Decision:
       Flag chronology violations for timestamp validation.

4. DELIVERY PERFORMANCE
   Delivered orders with valid dates = 96470
   Delivered after estimated date = 7826
   Delivered on time or early = 88644
   Decision:
       Retain these records for operational performance analysis.

5. FREIGHT AND ITEM PRICE
   Freight-greater-than-price records = 4124
   Affected orders = 3346
   Affected products = 1896
   Affected sellers = 644
   Decision:
       Retain pending business-rule validation.

6. ZERO FREIGHT
   Zero-freight item records = 383
   Affected orders = 339
   Affected products = 10
   Decision:
       Retain pending shipping-rule interpretation.

7. ORDER-LEVEL FINANCIAL RECONCILIATION
   Orders compared = 98665
   Reconciled within 0.01 = 98213
   Unreconciled orders = 452
   Decision:
       Flag for reconciliation review.
       Do not automatically modify monetary values.

8. CANCELED ORDERS
   Canceled orders = 625
   Canceled orders with payment records = 625
   Canceled orders without item records = 164
   Decision:
       Flag missing item relationships for business-context review.

9. HIGH ITEM PRICES
   Highest observed item price = 6735.00
   Decision:
       No confirmed price error established.
       Retain values pending authoritative business validation.

IMPORTANT INTERPRETATION
The findings represent different types of validation evidence.
A timestamp inconsistency is not equivalent to a late delivery.
A zero product measurement is not proof of the correct replacement value.
Freight greater than item price is not automatically invalid.
A payment reconciliation difference does not establish the cause of thedifference.
The same order or product may appear in multiple investigations. Therefore, the counts above must not be added together to calculate a total number of
affected orders or products.

FINAL DECISION
Phase 08 Cross-Column Validation is COMPLETE for the investigations documented above.
The investigation identified product measurement concerns, order lifecycle and timestamp chronology inconsistencies, unusual freight relationships,
and order-level financial reconciliation differences.
No raw records were automatically deleted, capped, or replaced.
Findings requiring additional business context remain flagged rather than being presented as confirmed errors.
The results support subsequent cross-table validation, controlled cleaning decisions, SQL analysis, Python/Pandas analysis, and Power BI reporting.
