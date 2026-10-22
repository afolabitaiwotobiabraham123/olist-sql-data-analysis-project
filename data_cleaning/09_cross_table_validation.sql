PROJECT: Olist E-Commerce Dataset
PHASE: 09 - Cross-Table Validation
FILE: 09_cross_table_validation.sql

OBJECTIVE
Validate relationships between the Olist datasets to identify:
1. Missing or unmatched foreign-key references.
2. Orders without related order items or payment records.
3. Duplicate product identifiers that can multiply join results.
4. Differences between order item/freight totals and payment totals.
5. Repeated review identifiers and orders without reviews.
6. Customer and seller ZIP prefixes missing from geolocation data.

METHODOLOGY
- Use LEFT JOINs to identify missing related records.
- Use DISTINCT identifiers when checking relationships against tables with duplicate keys.
- Aggregate order items and payments separately before reconciling totals.
- Investigate anomalies before deciding whether they require correction.
- Preserve original records until a correction is supported by evidence.

IMPORTANT
This is a cross-table assessment and investigation file.
It does not automatically delete records, modify identifiers, fabricate missing records, or make destructive changes to the source tables.

SECTION 1 - ORDERS TO CUSTOMERS
OBJECTIVE
Determine whether every order references an existing customer.

SQL QUERY : 
SELECT
    COUNT(*) AS total_order_rows,
    COUNT(DISTINCT o.order_id) AS distinct_orders,
    COUNT(c.customer_id) AS matched_customer_rows,
    SUM(
        CASE
            WHEN c.customer_id IS NULL THEN 1
            ELSE 0
        END
    ) AS unmatched_customer_rows
FROM olist_orders_dataset AS o
LEFT JOIN olist_customers_dataset AS c
    ON o.customer_id = c.customer_id;

QUERY RESULT
Total order rows:                         99,441
Distinct order IDs:                       99,441
Orders with matching customer records:    99,441
Orders without matching customer records: 0

OBSERVATION
Every order matched a customer record. The total number of order rows also matched the number of distinct order IDs.

CLEANING DECISION
No referential-integrity correction is indicated for this relationship.

SECTION 2 - ORDERS TO ORDER ITEMS
OBJECTIVE
Identify orders that do not have corresponding order-item records.

SQL QUERY : 
SELECT
    o.order_status,
    COUNT(*) AS orders_without_items
FROM olist_orders_dataset AS o
LEFT JOIN olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL
GROUP BY o.order_status
ORDER BY orders_without_items DESC;

QUERY RESULT
Total orders without item records: 775
Status breakdown:
    unavailable: 603
    canceled:    164
    created:       5
    invoiced:      2
    shipped:       1
The 8 orders with created, invoiced, or shipped statuses were investigated.
Each had one payment record but zero order-item rows.

AFFECTED ORDERS
Created:
    90ab3e7d52544ec7bc3363c82689965f
    7a4df5d8cff4090e541401a20a22bb80
    b5359909123fa03c50bdb0cfed07f098
    35de4050331c6c644cddc86f4f2d0d64
    dba5062fbda3af4fb6c33b1e040ca38f
Invoiced:
    e04f1da1f48bf2bbffcf57b9824f76e1
    2ce9683175cdab7d1c95bcbb3e36f478
Shipped:
    a68ce1686d536ca72bd2dadc4b8671e5
OBSERVATION
Of the 775 orders without item records, 767 were unavailable or canceled.
The remaining 8 had created, invoiced, or shipped statuses and require additional attention.
A missing item record is not sufficient evidence that the order itself is invalid.

CLEANING DECISION
Flag the 8 orders for further investigation.
Do not invent order items or delete the affected orders automatically. Preserve the original records.

SECTION 3 - ORDER ITEMS TO PRODUCTS
OBJECTIVE
Validate product references and investigate duplicate product identifiers.

SQL QUERY : 
SELECT
    COUNT(*) AS total_order_item_rows,
    COUNT(DISTINCT oi.product_id) AS distinct_product_ids_in_items,
    SUM(
        CASE
            WHEN p.product_id IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS item_rows_with_matching_products,
    SUM(
        CASE
            WHEN p.product_id IS NULL THEN 1
            ELSE 0
        END
    ) AS item_rows_without_matching_products
FROM olist_order_items_dataset AS oi
LEFT JOIN (
    SELECT DISTINCT product_id
    FROM olist_products_dataset
) AS p
    ON oi.product_id = p.product_id;

INITIAL QUERY RESULT
Order-item rows:                         112,650
Distinct product IDs in order items:      32,951
Joined rows using original product table: 225,300
Item rows without matching products:           0

PRODUCT TABLE INVESTIGATION
Total product rows:                      65,902
Distinct product IDs:                    32,951
Extra rows beyond distinct IDs:           32,951
Product IDs with NULL values:                  0
Every product ID occurred exactly twice.
A comparison of the available product attributes showed:
    Product IDs occurring twice:                 32,951
    IDs with one distinct attribute combination: 32,951
    IDs with conflicting attribute combinations:       0
REVALIDATED RELATIONSHIP
Order-item rows:                          112,650
Distinct product IDs referenced:           32,951
Item rows with matching product IDs:       112,650
Item rows without matching product IDs:          0

OBSERVATION
Every order-item row references a product ID found in the product table.
However, every product ID appears twice with identical values across the available attributes. Joining the order items directly to the original product
table therefore multiplies the joined row count from 112,650 to 225,300.

CLEANING DECISION
Flag the product table's duplicate rows for remediation.
For relationship checks, use distinct product IDs. For analytical joins, use a validated product dimension with one row per product ID.
Do not delete source rows during this assessment. Preserve all 112,650 order-item records.

SECTION 4 - ORDER ITEMS TO SELLERS
OBJECTIVE 
Verify that seller identifiers in the order-item table exist in the sellers table.

SQL QUERY : 
SELECT
    COUNT(*) AS total_order_item_rows,
    COUNT(DISTINCT oi.seller_id) AS distinct_seller_ids_in_items,
    SUM(
        CASE
            WHEN s.seller_id IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS item_rows_with_matching_sellers,
    SUM(
        CASE
            WHEN s.seller_id IS NULL THEN 1
            ELSE 0
        END
    ) AS item_rows_without_matching_sellers
FROM olist_order_items_dataset AS oi
LEFT JOIN olist_sellers_dataset AS s
    ON oi.seller_id = s.seller_id;
  
QUERY RESULT
Order-item rows:                     112,650
Distinct seller IDs referenced:        3,095
Item rows matching sellers:           112,650
Item rows without matching sellers:         0

OBSERVATION
Every order-item seller reference matched a seller record.

CLEANING DECISION
No unmatched seller-ID correction is indicated by this relationship check.

SECTION 5 - ORDERS TO PAYMENTS
OBJECTIVE 
Identify orders without payment records.

SQL QUERY :
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date
FROM olist_orders_dataset AS o
LEFT JOIN olist_order_payments_dataset AS p
    ON o.order_id = p.order_id
WHERE p.order_id IS NULL;
  
QUERY RESULT
Total orders:                           99,441
Orders with payment records:             99,440
Orders without payment records:               1

AFFECTED ORDER
order_id:
    bfbd0f9bdef84302105ad712db648a6c
customer_id:
    86dc2ffce2dfff336de2f386a786e574
order_status:
    delivered
order_purchase_timestamp:
    2016-09-15 12:16:38
order_approved_at:
    2016-09-15 12:16:38
order_delivered_carrier_date:
    2016-11-07 17:11:53
order_delivered_customer_date:
    2016-11-09 07:47:38
order_estimated_delivery_date:
    2016-10-04 00:00:00
Additional investigation:
    Order-item rows:        3
    Distinct products:      1
    Distinct sellers:       1
    Item price total:      134.97
    Freight total:           8.49
    Items plus freight:    143.46

OBSERVATION
The affected order is marked delivered and contains item records, but no payment record was found.
The recorded customer delivery date is also later than the estimated delivery date. 
This is a separate delivery-performance observation.

CLEANING DECISION
Flag the order for investigation.
Do not fabricate a payment or remove the order. Validate against authoritative payment or source-system records before considering any correction.

SECTION 6 - ORDER ITEM AND FREIGHT TOTALS TO PAYMENT TOTALS
OBJECTIVE
Compare the sum of item prices and freight charges against the recorded payment total for each order.

RECONCILIATION RULE
Expected order total = SUM(price) + SUM(freight_value)
Recorded payment total = SUM(payment_value)
Difference = Recorded payment total - Expected order total
Orders reconcile when the absolute difference is less than or equal to 0.01.

AGGREGATION REQUIREMENT
Aggregate order items and payments separately by order_id before joining the totals. 
Joining raw item rows directly to raw payment rows can multiply amounts for orders with multiple items and/or multiple payment records.

SQL QUERY :
WITH item_totals AS (
    SELECT
        order_id,
        SUM(price) AS item_price_total,
        SUM(freight_value) AS freight_total,
        SUM(price + freight_value) AS items_plus_freight_total
    FROM olist_order_items_dataset
    GROUP BY order_id
),
payment_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
)
SELECT
    COUNT(*) AS orders_with_items_and_payments,
    SUM(
        CASE
            WHEN ABS(
                p.payment_total - i.items_plus_freight_total
            ) <= 0.01 THEN 1
            ELSE 0
        END
    ) AS orders_reconciling_within_one_cent,
    SUM(
        CASE
            WHEN ABS(
                p.payment_total - i.items_plus_freight_total
            ) > 0.01 THEN 1
            ELSE 0
        END
    ) AS orders_with_differences
FROM item_totals AS i
INNER JOIN payment_totals AS p
    ON i.order_id = p.order_id;

QUERY RESULT
Orders with both item and payment records: 98,665
Orders reconciling within one cent:         98,213
Orders with differences:                       452
Reconciliation rate: approximately 99.54%.

DISCREPANCY CLASSIFICATION
Payment exceeds items plus freight:
    Orders: 311
    Net difference: +3,070.61
Items plus freight exceed payment:
    Orders: 141
    Net difference: -200.10
Net difference across the 452 discrepant orders:
    +2,870.51
  
PAYMENT RECORD COUNT PATTERN
Orders with one payment record:
    Discrepant orders: 430
    Total absolute difference: 3,223.05
Orders with multiple payment records:
    Discrepant orders: 22
    Total absolute difference: 47.66

SINGLE-PAYMENT DISCREPANCY BREAKDOWN
Credit card:
    Orders: 372
    Items plus freight: 80,772.45
    Payment total:      83,647.48
    Net difference:      +2,875.03
Boleto:
    Orders: 46
    Items plus freight: 19,275.49
    Payment total:      19,275.37
    Net difference:          -0.12
Debit card:
    Orders: 11
    Items plus freight: 1,711.78
    Payment total:      1,659.79
    Net difference:        -51.99
Voucher:
    Orders: 1
    Items plus freight: 104.00
    Payment total:      103.99
    Net difference:       -0.01

LARGEST INSPECTED DISCREPANCY
order_id:
    ce6d150fb29ada17d2082f4847107665
Order status:
    delivered
Item price:
    1,299.00
Freight:
    104.66
Items plus freight:
    1,403.66
Payment total:
    1,586.47
Difference:
    +182.81
Item rows:
    1
Payment records:
    1
Payment type:
    credit_card
Installments:
    10

OBSERVATION
Most checked orders reconcile within one cent. A total of 452 orders have differences exceeding that tolerance.
Most discrepant orders with a single payment record in the inspected breakdown use credit cards.
This is an observed pattern, not proof of the cause.
The payment_value field represents the recorded payment amount. Do not multiply it by payment_installments during reconciliation.

CLEANING DECISION
Flag the 452 discrepant orders for further investigation.
Do not automatically modify payment values, item prices, or freight charges.
Where available, investigate payment records, refunds, discounts, vouchers, and source-system business rules before deciding whether a correction is valid.

SECTION 7 - REVIEWS TO ORDERS AND REVIEW IDENTIFIERS

OBJECTIVE
Validate review-to-order references, check review identifier uniqueness, investigate repeated review IDs, and measure review coverage.

SQL QUERY : 
SELECT
    COUNT(*) AS total_review_rows,
    COUNT(DISTINCT review_id) AS distinct_review_ids,
    COUNT(DISTINCT order_id) AS distinct_review_order_ids,
    SUM(
        CASE WHEN review_id IS NULL THEN 1 ELSE 0 END
    ) AS null_review_ids,
    SUM(
        CASE WHEN order_id IS NULL THEN 1 ELSE 0 END
    ) AS null_order_ids
FROM olist_order_reviews_dataset;

A. REVIEW REFERENCE VALIDATION
Total review rows:                  99,223
Review rows matching existing orders: 99,223
Review rows without matching orders:       0

Distinct review IDs:                98,409
Distinct order IDs in reviews:      98,672
NULL review IDs:                         0
NULL order IDs:                          0

B. REPEATED REVIEW IDENTIFIERS
Repeated review_id groups:            789
Rows belonging to repeated groups:  1,603
Excess rows beyond one per repeated ID: 814
Repeated groups associated with multiple orders: 789

Attribute consistency check:
    Groups with the same counted review attributes: 789
    Groups with different counted review attributes: 0

INSPECTED EXAMPLE
review_id:
    08528f70f579f0c830189efc523d2182
This review ID appears against three different orders:
    03310aa823a66056268a3bab36e827fb
    53c71d3953507c6239ff73917ed358c9
    7813842ae95e8c497fc0233232ae815a
The inspected records have the same:
    review_score
    review_comment_title
    review_comment_message
    review_creation_date
    review_answer_timestamp

C. ORDERS WITHOUT REVIEWS
Total orders:                  99,441
Distinct orders:                99,441
Orders with at least one review: 98,672
Orders without a review record:     769

OBSERVATION
All review records reference existing orders. However, 789 repeated review IDs are associated with multiple orders while their counted review attributes
remain consistent.
COUNT(DISTINCT column) ignores NULL values. Therefore, the attribute-count check does not establish that every attribute is non-NULL or that the rows
are identical in every possible respect.
An order without a review is not automatically a data error because customers may choose not to submit a review.

CLEANING DECISION
Flag the 789 repeated review_id groups for investigation.
Do not generate replacement review IDs or delete records automatically.
Determine whether the repeated associations are valid before changing them.
Retain the 769 orders without reviews. Do not create artificial review records.

SECTION 8 - CUSTOMER ZIP PREFIXES TO GEOLOCATION
OBJECTIVE 
Determine whether customer ZIP prefixes are represented in the geolocation dataset.

SQL QUERY : 
SELECT
    COUNT(*) AS total_customer_rows,
    SUM(
        CASE
            WHEN g.geolocation_zip_code_prefix IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS customer_rows_with_matching_geolocation_prefix,
    SUM(
        CASE
            WHEN g.geolocation_zip_code_prefix IS NULL THEN 1
            ELSE 0
        END
    ) AS customer_rows_without_matching_geolocation_prefix
FROM olist_customers_dataset AS c
LEFT JOIN (
    SELECT DISTINCT geolocation_zip_code_prefix
    FROM olist_geolocation_dataset
) AS g
    ON c.customer_zip_code_prefix = g.geolocation_zip_code_prefix;

SQL QUERY : 
SELECT
    s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state
FROM olist_sellers_dataset AS s
LEFT JOIN (
    SELECT DISTINCT geolocation_zip_code_prefix
    FROM olist_geolocation_dataset
) AS g
    ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE g.geolocation_zip_code_prefix IS NULL
ORDER BY
    s.seller_state,
    s.seller_city,
    s.seller_zip_code_prefix;

QUERY RESULT
Customer rows:                              99,441
Rows with matching geolocation prefixes:     99,163
Rows without matching geolocation prefixes:     278
Distinct unmatched customer ZIP prefixes:       157

UNMATCHED CUSTOMER ROWS BY STATE
DF: 171 rows / 67 prefixes
SP:  15 rows / 14 prefixes
RJ:  13 rows / 10 prefixes
MG:  11 rows / 11 prefixes
PR:  11 rows / 10 prefixes
BA:   9 rows / 7 prefixes
GO:   9 rows / 6 prefixes
ES:   6 rows / 3 prefixes
CE:   4 rows / 3 prefixes
MA:   4 rows / 2 prefixes
PE:   4 rows / 4 prefixes
RS:   4 rows / 4 prefixes
PA:   3 rows / 3 prefixes
PI:   3 rows / 3 prefixes
MT:   2 rows / 1 prefix
PB:   2 rows / 2 prefixes
RN:   2 rows / 2 prefixes
RO:   2 rows / 2 prefixes
AL:   1 row / 1 prefix
SE:   1 row / 1 prefix
TO:   1 row / 1 prefix
DF accounts for approximately 61.5% of unmatched customer rows.

REVERSE GEOLOCATION COVERAGE
Distinct geolocation ZIP prefixes: 19,015
Prefixes used by customers:        14,837
Prefixes not used by customers:     4,178

OBSERVATION
A total of 278 customer rows have ZIP prefixes absent from the distinct geolocation prefix set.
The 4,178 geolocation prefixes not used by customers are not necessarily errors; the geolocation table may cover areas without customers in this dataset.

CLEANING DECISION
Flag the 278 unmatched customer records for review.
Do not invent coordinates or delete customers. Do not classify unused geolocation prefixes as invalid without additional evidence.

SECTION 9 - SELLER ZIP PREFIXES TO GEOLOCATION
OBJECTIVE 
Identify seller ZIP prefixes that do not appear in the geolocation dataset.

QUERY RESULT
Seller rows:                              3,095
Sellers with matching geolocation prefix: 3,088
Sellers without matching prefix:              7

UNMATCHED SELLER ZIP PREFIXES
02285 - São Paulo, SP - 1 seller
07412 - Arujá, SP - 1 seller
37708 - Poços de Caldas, MG - 1 seller
71551 - Brasília, DF - 1 seller
72580 - Brasília, DF - 1 seller
82040 - Curitiba, PR - 1 seller
91901 - Porto Alegre, RS - 1 seller

OBSERVATION
Seven seller records have ZIP prefixes that were not found in the distinct geolocation ZIP prefix set.
This mismatch does not conclusively establish that the seller addresses are invalid.

CLEANING DECISION
Flag the seven seller records for review.
Preserve the original ZIP prefixes. Do not invent coordinates or delete seller records solely because their prefixes were not found.

SECTION 10 - PHASE 09 FINAL SUMMARY AND CLEANING DECISIONS

PHASE STATUS
Phase 09 - Cross-Table Validation: COMPLETE

RELATIONSHIPS WITH NO UNMATCHED KEY REFERENCES IN THE CHECKS
1. Orders to customers:
       99,441 orders matched customer records.
       0 unmatched customer references.

2. Order items to products:
       112,650 item rows matched product IDs when checked against distinct
       product identifiers.
       0 unmatched product references.

3. Order items to sellers:
       112,650 item rows matched seller records.
       0 unmatched seller references.

FINDINGS TO CARRY FORWARD
1. Orders without item records:
       775 orders have no item rows.
       8 orders with created, invoiced, or shipped statuses warrant attention.

2. Duplicate product records:
       65,902 product rows contain 32,951 distinct product IDs.
       Each product ID occurs twice with identical available attributes.
       Direct joins can multiply order-item rows.

3. Missing payment record:
       1 delivered order has no payment record.

4. Payment reconciliation:
       452 orders with both item and payment records have differences exceeding
       one cent between recorded payments and item-plus-freight totals.

5. Repeated review IDs:
       789 repeated review_id groups are linked to multiple orders and have
       consistent counted review attributes.

6. Orders without reviews:
       769 orders have no review record.

7. Customer geolocation coverage:
       278 customer rows have ZIP prefixes absent from geolocation.

8. Seller geolocation coverage:
       7 seller rows have ZIP prefixes absent from geolocation.

GENERAL CLEANING DECISIONS
- Preserve the original datasets and maintain traceability.
- Do not delete records solely because they appear in these findings.
- Do not fabricate missing item, payment, review, or geolocation records.
- Do not change review IDs or other identifiers without supporting evidence.
- Prevent join multiplication by validating key uniqueness and aggregating one-to-many tables before joining.
- Resolve discrepancies only when supported by reliable evidence.
- Carry the findings into the appropriate cleaning and remediation phases.

LIMITATIONS
These checks identify patterns and relationship coverage; they do not necessarily establish the business cause of each anomaly.
Repeated review attributes may contain NULL values because COUNT(DISTINCT) ignores NULLs.
Payment discrepancies may require additional context such as discounts, vouchers, refunds, or source-system business rules.
ZIP-prefix mismatches do not alone establish incorrect addresses.

FINAL DECISION
Phase 09 is complete. Investigation findings are documented, and anomalies requiring further evidence have been flagged rather than automatically changed.

