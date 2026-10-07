FILE: 03_invalid_value_cleaning.sql
PROJECT: Olist E-Commerce Data Analysis
PHASE: Data Cleaning
TOPIC: Invalid Value Cleaning

OBJECTIVE : 
Remove, standardize, or appropriately represent confirmed invalid values identified during the invalid-value assessment while preserving the original raw tables.

CLEANING PRINCIPLE
1. Never modify the original/raw tables directly.
2. Clean only values confirmed to be invalid or inappropriate for analysis.
3. Do not invent replacement values when the correct value cannot be known.
4. Convert invalid placeholder values to NULL when the information is genuinely unknown or unavailable.
5. Preserve valid business records even when some attributes are incomplete.
6. Investigate business-rule and chronological anomalies before deciding whether they should be changed.
7. Create separate cleaned tables where cleaning is required.
8. Validate each cleaning operation after it is performed.
9. Do not treat incomplete optional fields as invalid unless there is sufficient evidence that they represent invalid data.

TABLES REQUIRING INVALID-VALUE CLEANING
1. olist_order_payments_dataset
2. olist_order_reviews_dataset
3. olist_orders_dataset
4. olist_products_dataset

TABLES ASSESSED BUT NOT REQUIRING INVALID-VALUE CLEANING
- olist_customers_dataset
- olist_geolocation_dataset
- olist_order_items_dataset
- olist_sellers_dataset
- product_category_name_translation

SECTION 1: ORDER PAYMENTS INVALID-VALUE CLEANING

OBJECTIVE : 
Correct confirmed invalid payment values while preserving valid payment records and avoiding unsupported assumptions about payment methods.

ASSESSMENT RESULT
The invalid-value assessment identified:
1. payment_sequential <= 0:
   - No invalid records found.
2. payment_value < 0:
   - No invalid records found.
3. payment_installments <= 0:
   - 2 invalid records identified.
4. payment_type = 'not_defined':
   - 3 records identified.
The three 'not_defined' payment records were investigated before cleaning.
All three belonged to canceled orders with:
- payment_value = 0
- payment_installments = 1
- no other payment records for the affected orders
Because the actual payment method could not be determined, the value was not replaced with a guessed payment type.

CLEANING DECISION
1. Convert 'not_defined' payment types to NULL.
2. Convert payment_installments <= 0 to NULL.
3. Do not change valid payment_sequential values.
4. Do not change valid payment_value values.

INVESTIGATION: Confirm 'not_defined' payment records
SQL QUERY :
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM olist_order_payments_dataset
WHERE payment_type = 'not_defined';

OBSERVATION : 
Three records were identified:
order_id                         payment_sequential   payment_type   installments   value
--------------------------------------------------------------------------------------------
4637ca194b6387e2d538dc89b124b0ee       1               not_defined        1          0
00b1cb0320190ca0daa2c88b35206009       1               not_defined        1          0
c8c528189310eaa44a745b8d9d26908b       1               not_defined        1          0
All three records had a payment value of zero.

INVESTIGATION: Confirm the order status of the 'not_defined' records
SQL QUERY : 
SELECT
    p.order_id,
    p.payment_type,
    p.payment_installments,
    p.payment_value,
    o.order_status
FROM olist_order_payments_dataset AS p
JOIN olist_orders_dataset AS o
    ON p.order_id = o.order_id
WHERE p.payment_type = 'not_defined';

OBSERVATION : 
All three 'not_defined' payment records belonged to canceled orders.
The records had no other payment records associated with the affected orders.

CONCLUSION : 
The actual payment method cannot be reliably determined.
Therefore, 'not_defined' is converted to NULL rather than being assigned an assumed payment type.

CLEANING METHOD : 
NULLIF is used to convert the placeholder value 'not_defined' into NULL while preserving all other valid payment types.
SQL QUERY : 
CREATE TABLE olist_order_payments_clean AS
SELECT
    order_id,
    payment_sequential,
    NULLIF(payment_type, 'not_defined') AS payment_type,
    payment_installments,
    payment_value
FROM olist_order_payments_dataset;

OBSERVATION : 
The table creation returned:
Rows affected: 103,886
Records: 103,886
Duplicates: 0
Warnings: 0
The cleaned table contains all original payment records.

VALIDATION 1: Confirm 'not_defined' values were removed
SQL QUERY : 
SELECT
    SUM(payment_type = 'not_defined') AS remaining_not_defined,
    SUM(payment_type IS NULL) AS null_payment_types
FROM olist_order_payments_clean;

OBSERVATION  
Result:
remaining_not_defined | null_payment_types
----------------------|-------------------
0                     | 3

CONCLUSION
All three 'not_defined' payment values were successfully converted to NULL.
No payment type was incorrectly guessed.

CLEANING: Correct invalid payment installments
The invalid-value assessment identified two records with
payment_installments <= 0.
Both records had:
- payment_type = credit_card
- payment_installments = 0
- positive payment values
- delivered order status
Because zero installments is not a valid installment count, the value is converted to NULL rather than assigning an arbitrary installment count.
SQL QUERY : 
UPDATE olist_order_payments_clean
SET payment_installments = NULL
WHERE payment_installments <= 0;

OBSERVATION
The update returned:
Rows affected: 2
Rows matched: 2
Changed: 2
Warnings: 0

CONCLUSION
The two invalid payment installment values were converted to NULL.

VALIDATION 2: Confirm no invalid installment values remain
SQL QUERY :
SELECT
    SUM(payment_installments <= 0) AS remaining_invalid_installments,
    SUM(payment_installments IS NULL) AS null_installments
FROM olist_order_payments_clean;

OBSERVATION
Result:
remaining_invalid_installments | null_installments
-------------------------------|-----------------
0                              | 2
  
CONCLUSION
No invalid payment installment values remain.
The two records now correctly indicate that the installment information is unknown rather than incorrectly storing zero installments.

VALIDATION 3: Final payment invalid-value check
SQL QUERY : 
SELECT
    SUM(payment_type = 'not_defined') AS remaining_not_defined,
    SUM(payment_installments <= 0) AS remaining_invalid_installments,
    SUM(payment_type IS NULL) AS null_payment_types,
    SUM(payment_installments IS NULL) AS null_installments,
    SUM(payment_value < 0) AS negative_payment_values,
    SUM(payment_sequential <= 0) AS invalid_payment_sequences
FROM olist_order_payments_clean;

OBSERVATION
Result:
remaining_not_defined | remaining_invalid_installments | null_payment_types
----------------------|--------------------------------|-------------------
0                     | 0                              | 3

null_installments | negative_payment_values | invalid_payment_sequences
------------------|-------------------------|--------------------------
2                 | 0                       | 0

CONCLUSION
All confirmed invalid payment values were successfully cleaned.
No invalid payment values remain except for NULLs representing information that could not be reliably determined.

SECTION 2: ORDER REVIEWS INVALID-VALUE CLEANING
OBJECTIVE : 
Correct invalid placeholder date values in the order reviews table while preserving legitimate review records and unresolved chronological anomalies.

ASSESSMENT RESULT
The invalid-value assessment identified:
- review_score outside 1-5: 0
- zero review_creation_date: 1
- zero review_answer_timestamp: 1
- review_creation_date before order_purchase_timestamp: 75
- review_answer_timestamp before review_creation_date: 0
- blank review_comment_title: 87,657
- blank review_comment_message: 58,256
The zero dates were confirmed as placeholder values.
The blank review title and message fields were not treated as invalid because they are optional review text fields and may legitimately be left blank.
The chronological anomalies were investigated separately and were not automatically overwritten because the correct timestamps could not be known.

INVESTIGATION: Confirm zero-date review records
SQL QUERY :
SELECT
    r.order_id,
    r.review_id,
    r.review_score,
    r.review_creation_date,
    r.review_answer_timestamp,
    o.order_status,
    o.order_purchase_timestamp
FROM olist_order_reviews_dataset AS r
LEFT JOIN olist_orders_dataset AS o
    ON r.order_id = o.order_id
WHERE YEAR(r.review_creation_date) = 0
   OR YEAR(r.review_answer_timestamp) = 0;

OBSERVATION
One review record contained zero-date placeholders.
The record had:
- review_score = 2
- review_creation_date = 0000-00-00 00:00:00
- review_answer_timestamp = 0000-00-00 00:00:00
- order_status = delivered
The corresponding order purchase timestamp was valid.

CONCLUSION
The zero dates do not represent usable dates and were converted to NULL.
No replacement date was invented.

CLEANING METHOD
CASE statements are used to convert zero-date placeholders into NULL while preserving valid timestamps.
SQL QUERY : 
CREATE TABLE olist_order_reviews_clean AS
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    CASE
        WHEN YEAR(review_creation_date) = 0 THEN NULL
        ELSE review_creation_date
    END AS review_creation_date,
    CASE
        WHEN YEAR(review_answer_timestamp) = 0 THEN NULL
        ELSE review_answer_timestamp
    END AS review_answer_timestamp
FROM olist_order_reviews_dataset;

OBSERVATION
The table creation returned:
Rows affected: 99,223
Records: 99,223
Duplicates: 0
Warnings: 0

VALIDATION 1: Confirm zero dates were removed
SQL QUERY : 
SELECT
    SUM(YEAR(review_creation_date) = 0) AS remaining_zero_creation_dates,
    SUM(YEAR(review_answer_timestamp) = 0) AS remaining_zero_answer_dates,
    SUM(review_creation_date IS NULL) AS null_creation_dates,
    SUM(review_answer_timestamp IS NULL) AS null_answer_dates
FROM olist_order_reviews_clean;

OBSERVATION
Result:
remaining_zero_creation_dates | remaining_zero_answer_dates
------------------------------|----------------------------
0                             | 0

null_creation_dates | null_answer_dates
--------------------|------------------
1                   | 1

CONCLUSION
The zero-date placeholders were successfully removed and represented as NULL.

VALIDATION 2: Investigate chronological review anomalies
SQL QUERY : 
SELECT
    r.review_id,
    r.order_id,
    r.review_score,
    r.review_creation_date,
    o.order_purchase_timestamp,
    o.order_status
FROM olist_order_reviews_clean AS r
JOIN olist_orders_dataset AS o
    ON r.order_id = o.order_id
WHERE r.review_creation_date IS NOT NULL
  AND r.review_creation_date < o.order_purchase_timestamp
ORDER BY r.review_creation_date;

OBSERVATION
The cleaned table contained 74 review creation timestamps that occurred before the corresponding order purchase timestamp.
The original assessment reported 75 anomalies because one of the original records was the zero-date record already cleaned above.

CONCLUSION
The 74 remaining chronological anomalies were preserved because the correct timestamp cannot be determined from the available data.
These records are documented as unresolved chronological anomalies rather than being assigned guessed dates.

VALIDATION 3: Review comment completeness check
SQL QUERY 
SELECT
    COUNT(*) AS total_reviews,
    SUM(TRIM(review_comment_title) = '') AS blank_titles,
    SUM(TRIM(review_comment_message) = '') AS blank_messages,
    SUM(
        TRIM(review_comment_title) = ''
        AND TRIM(review_comment_message) = ''
    ) AS both_blank
FROM olist_order_reviews_clean;

OBSERVATION
Result:
total_reviews | blank_titles | blank_messages | both_blank
--------------|--------------|----------------|-----------
99,223        | 87,657       | 58,256         | 56,527

CONCLUSION
Blank review titles and messages were not cleaned because these fields are optional review content and blank values do not necessarily represent invalid data.
The blank values are therefore preserved.

SECTION 3: ORDERS INVALID-VALUE CLEANING
  
OBJECTIVE
Correct invalid zero-date placeholders in the orders table while preserving valid timestamps and documenting unresolved chronological and business-rule
inconsistencies.

ASSESSMENT RESULT
The invalid-value assessment identified:
- Zero order_approved_at timestamps: 160
- Zero order_delivered_carrier_date timestamps: 1,783
- Zero order_delivered_customer_date timestamps: 2,965
- Carrier date before purchase date: 166
- Customer date before purchase date: 0 after zero-date cleaning
- Customer date before carrier date: 23
- Delivered orders without customer delivery date: 8
- Canceled orders with customer delivery date: 6
Zero timestamps were treated as placeholder values and converted to NULL.
The chronological anomalies and business-rule inconsistencies were preserved because the correct values could not be reliably inferred.

INVESTIGATION: Understand zero-date values by order status
SQL QUERY
SELECT
    order_status,
    COUNT(*) AS order_count,
    SUM(YEAR(order_approved_at) = 0) AS zero_approved,
    SUM(YEAR(order_delivered_carrier_date) = 0) AS zero_carrier,
    SUM(YEAR(order_delivered_customer_date) = 0) AS zero_customer
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY order_status;

OBSERVATION
Zero timestamps occur across multiple order workflow states, including:
- approved
- canceled
- created
- delivered
- invoiced
- processing
- shipped
- unavailable
This confirms that zero dates are being used as placeholder values for missing or unavailable timestamps.

CONCLUSION
Zero timestamps should be converted to NULL rather than interpreted as actual dates.

CLEANING METHOD
CASE statements are used to convert zero-date placeholders into NULL while preserving all valid timestamps.

SQL QUERY
CREATE TABLE olist_orders_clean AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    CASE
        WHEN YEAR(order_approved_at) = 0 THEN NULL
        ELSE order_approved_at
    END AS order_approved_at,
    CASE
        WHEN YEAR(order_delivered_carrier_date) = 0 THEN NULL
        ELSE order_delivered_carrier_date
    END AS order_delivered_carrier_date,
    CASE
        WHEN YEAR(order_delivered_customer_date) = 0 THEN NULL
        ELSE order_delivered_customer_date
    END AS order_delivered_customer_date,
    order_estimated_delivery_date
FROM olist_orders_dataset;

OBSERVATION
The table creation returned:
Rows affected: 99,441
Records: 99,441
Duplicates: 0
Warnings: 0

VALIDATION 1: Confirm zero dates were removed
SQL QUERY : 
SELECT
    SUM(YEAR(order_approved_at) = 0) AS remaining_zero_approved,
    SUM(YEAR(order_delivered_carrier_date) = 0) AS remaining_zero_carrier,
    SUM(YEAR(order_delivered_customer_date) = 0) AS remaining_zero_customer,
    SUM(order_approved_at IS NULL) AS null_approved,
    SUM(order_delivered_carrier_date IS NULL) AS null_carrier,
    SUM(order_delivered_customer_date IS NULL) AS null_customer
FROM olist_orders_clean;

OBSERVATION
Result:
remaining_zero_approved | remaining_zero_carrier | remaining_zero_customer
------------------------|------------------------|------------------------
0                       | 0                      | 0

null_approved | null_carrier | null_customer
--------------|--------------|---------------
160           | 1,783        | 2,965

CONCLUSION
All zero-date placeholders were successfully converted to NULL.


VALIDATION 2: Investigate carrier dates before purchase dates
SQL QUERY :
SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_delivered_carrier_date
FROM olist_orders_clean
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_purchase_timestamp
ORDER BY order_delivered_carrier_date;

OBSERVATION
166 records contain carrier timestamps earlier than the order purchase timestamp.
The anomaly range was:
- Minimum difference: 0 minutes
- Maximum difference: 246,545 minutes
- Average difference: 1,561.9096 minutes
Some anomalies were only a few minutes apart, while at least one record contained a very large chronological difference.

CONCLUSION
The 166 timestamps were preserved because the correct carrier timestamp cannot be determined with certainty.
They are documented as chronological anomalies rather than being overwritten with guessed values.

VALIDATION 3: Check customer delivery before carrier delivery
SQL QUERY :
SELECT
    order_id,
    order_status,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM olist_orders_clean
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;

OBSERVATION
23 orders contain customer delivery timestamps earlier than their carrier delivery timestamps.

CONCLUSION
These timestamps were preserved because it is not possible to determine which timestamp is incorrect without an authoritative source.
The records are documented as chronological anomalies.

VALIDATION 4: Delivered orders without customer delivery date
SQL QUERY :
SELECT
    order_id,
    order_status,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM olist_orders_clean
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NULL;

OBSERVATION
8 delivered orders do not contain a valid customer delivery timestamp.
7 of these orders contain a carrier delivery timestamp.
1 order contains neither a carrier delivery timestamp nor a customer delivery timestamp.

CONCLUSION
The missing customer delivery timestamps were preserved as NULL.
The estimated delivery date was not used as a replacement because an estimated date does not represent an actual delivery event.

VALIDATION 5: Canceled orders with customer delivery dates
SQL QUERY :
SELECT
    order_id,
    order_status,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM olist_orders_clean
WHERE order_status = 'canceled'
  AND order_delivered_customer_date IS NOT NULL;

OBSERVATION
6 canceled orders contain customer delivery timestamps.

CONCLUSION
The original values were preserved.
The order status was not changed to 'delivered' because changing the business status would require information that is not available in the dataset.
These records are documented as cross-field business-rule inconsistencies.

VALIDATION 6: Final order invalid-value and business-rule check
SQL QUERY : 
SELECT
    SUM(
        order_delivered_carrier_date IS NOT NULL
        AND order_delivered_carrier_date < order_purchase_timestamp
    ) AS carrier_before_purchase,
    SUM(
        order_delivered_customer_date IS NOT NULL
        AND order_delivered_customer_date < order_purchase_timestamp
    ) AS customer_before_purchase,
    SUM(
        order_delivered_carrier_date IS NOT NULL
        AND order_delivered_customer_date IS NOT NULL
        AND order_delivered_customer_date < order_delivered_carrier_date
    ) AS customer_before_carrier,
    SUM(
        order_status = 'delivered'
        AND order_delivered_customer_date IS NULL
    ) AS delivered_without_customer_date,
    SUM(
        order_status = 'canceled'
        AND order_delivered_customer_date IS NOT NULL
    ) AS canceled_with_customer_date
FROM olist_orders_clean;

OBSERVATION
Result:
carrier_before_purchase | customer_before_purchase
------------------------|-------------------------
166                     | 0

customer_before_carrier | delivered_without_customer_date
------------------------|---------------------------------
23                      | 8

canceled_with_customer_date
---------------------------
6

CONCLUSION
All confirmed zero-date placeholders were cleaned.
The remaining anomalies were preserved because they require business-context investigation rather than automatic value replacement.

SECTION 4: PRODUCTS INVALID-VALUE CLEANING

OBJECTIVE
Correct confirmed invalid physical measurements and incomplete metadata represented by zero values or empty category values while preserving products
that have legitimate order activity.

ASSESSMENT RESULT
The invalid-value assessment identified:
- Negative product weights: 0
- Negative dimensions: 0
- Zero product weights: affected product records identified
- Zero dimensions: 2 affected products
- Zero photo counts: 610 products
- Zero product name lengths: 610 products
- Zero description lengths: 610 products
- Empty product categories: 610 products
Zero photo counts were not automatically treated as invalid because a product may legitimately have no product photographs.
The 610 products with zero name length, zero description length, and empty category were confirmed to represent incomplete product metadata.
The affected products had actual order activity and therefore were preserved.

INVESTIGATION: Confirm products with zero physical measurements
SQL QUERY :
SELECT
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    product_photos_qty,
    product_name_length,
    product_description_lenght
FROM olist_products_clean
WHERE product_weight_g = 0;

OBSERVATION
The cleaned products table contained 6 affected product records with product_weight_g = 0.
Several of the affected products also had zero physical dimensions.
The zero values cannot be interpreted as reliable physical measurements because a product with zero weight or zero dimensions is not physically
meaningful for logistics and fulfillment analysis.

INVESTIGATION: Confirm order activity for zero-measurement products
SQL QUERY : 
SELECT
    p.product_id,
    COUNT(oi.order_id) AS order_item_count,
    SUM(oi.price) AS total_sales_value
FROM olist_products_clean AS p
LEFT JOIN olist_order_items_dataset AS oi
    ON p.product_id = oi.product_id
WHERE p.product_weight_g = 0
GROUP BY
    p.product_id
ORDER BY
    order_item_count DESC;

OBSERVATION
All affected products had order activity.
The affected products therefore represent real products rather than unused records.

CONCLUSION
The product records must be preserved.
Only the invalid physical measurements should be cleaned.

INVESTIGATION: Confirm zero dimensions
SQL QUERY :
SELECT
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_products_clean
WHERE product_weight_g = 0
   OR product_length_cm = 0
   OR product_height_cm = 0
   OR product_width_cm = 0
ORDER BY product_id;

OBSERVATION
The affected records included products with zero weight and/or zero physical dimensions.
A separate count confirmed:
zero_dimension_rows: 2
zero_dimension_products: 2

CONCLUSION
Zero physical measurements are treated as missing/unknown measurements and converted to NULL.

CLEANING: Convert zero physical measurements to NULL
SQL QUERY :
UPDATE olist_products_clean
SET
    product_weight_g = NULL,
    product_length_cm = NULL,
    product_height_cm = NULL,
    product_width_cm = NULL
WHERE product_weight_g = 0
   OR product_length_cm = 0
   OR product_height_cm = 0
   OR product_width_cm = 0;

OBSERVATION
The update returned:
Rows affected: 6
Rows matched: 6
Changed: 6
Warnings: 0

CONCLUSION
All confirmed zero physical measurements were converted to NULL.

VALIDATION 1: Confirm no zero physical measurements remain
SQL QUERY : 
SELECT
    SUM(product_weight_g = 0) AS remaining_zero_weight,
    SUM(product_length_cm = 0) AS remaining_zero_length,
    SUM(product_height_cm = 0) AS remaining_zero_height,
    SUM(product_width_cm = 0) AS remaining_zero_width,
    SUM(product_weight_g IS NULL) AS null_weight,
    SUM(product_length_cm IS NULL) AS null_length,
    SUM(product_height_cm IS NULL) AS null_height,
    SUM(product_width_cm IS NULL) AS null_width
FROM olist_products_clean;

OBSERVATION
Result:
remaining_zero_weight | remaining_zero_length | remaining_zero_height
----------------------|----------------------|-----------------------
0                     | 0                    | 0

remaining_zero_width | null_weight | null_length | null_height | null_width
---------------------|-------------|-------------|-------------|-----------
0                    | 6           | 6           | 6           | 6

CONCLUSION
No zero physical measurements remain.
The affected measurements are now represented as NULL.

INVESTIGATION: Confirm incomplete product metadata
SQL QUERY :
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products,
    SUM(product_name_length = 0) AS zero_name_length,
    SUM(product_description_lenght = 0) AS zero_description_length,
    SUM(TRIM(COALESCE(product_category_name, '')) = '') AS blank_category
FROM olist_products_clean
WHERE product_name_length = 0
   OR product_description_lenght = 0
   OR TRIM(COALESCE(product_category_name, '')) = '';

OBSERVATION
Result:
total_rows | unique_products | zero_name_length | zero_description_length
-----------|-----------------|------------------|------------------------
610        | 610             | 610              | 610

blank_category
610
All 610 affected product records have:
- product_name_length = 0
- product_description_lenght = 0
- blank product_category_name
This confirms that the values represent incomplete product metadata.

INVESTIGATION: Confirm product activity
SQL QUERY : 
SELECT
    COUNT(DISTINCT p.product_id) AS affected_products,
    COUNT(DISTINCT oi.product_id) AS affected_products_with_orders,
    COUNT(oi.order_id) AS order_item_rows
FROM olist_products_clean AS p
LEFT JOIN olist_order_items_dataset AS oi
    ON p.product_id = oi.product_id
WHERE p.product_name_length = 0
  AND p.product_description_lenght = 0
  AND TRIM(COALESCE(p.product_category_name, '')) = '';

OBSERVATION
Result:
affected_products | affected_products_with_orders | order_item_rows
------------------|-------------------------------|----------------
610               | 610                           | 1,603

All 610 affected products have order activity.

CONCLUSION
The products are valid business records with incomplete metadata.
The products should not be deleted.

INVESTIGATION: Confirm category storage format
SQL QUERY :
SELECT
    SUM(product_category_name IS NULL) AS null_categories,
    SUM(product_category_name = '') AS empty_categories,
    SUM(
        product_category_name IS NOT NULL
        AND TRIM(product_category_name) = ''
    ) AS whitespace_categories
FROM olist_products_clean;

OBSERVATION
Result:
null_categories | empty_categories | whitespace_categories
----------------|------------------|----------------------
0               | 610              | 610

The 610 empty categories are stored as empty strings rather than NULL values.

CONCLUSION
The empty category values should be converted to NULL because the category information is unavailable.

CLEANING: Convert incomplete metadata values to NULL
The cleaning is restricted to records where all three indicators confirm the same incomplete metadata pattern:
- product_name_length = 0
- product_description_lenght = 0
- product_category_name is blank

SQL QUERY : 
UPDATE olist_products_clean
SET
    product_category_name = NULL,
    product_name_length = NULL,
    product_description_lenght = NULL
WHERE product_name_length = 0
  AND product_description_lenght = 0
  AND TRIM(COALESCE(product_category_name, '')) = '';

OBSERVATION
The update returned:
Rows affected: 610
Rows matched: 610
Changed: 610
Warnings: 0

CONCLUSION
The incomplete product metadata was converted to NULL rather than being assigned fabricated values.

VALIDATION 2: Confirm incomplete metadata was cleaned
SQL QUERY :
SELECT
    SUM(product_name_length = 0) AS remaining_zero_name_length,
    SUM(product_description_lenght = 0) AS remaining_zero_description_length,
    SUM(product_category_name = '') AS remaining_empty_category,
    SUM(
        product_category_name IS NOT NULL
        AND TRIM(product_category_name) = ''
    ) AS remaining_whitespace_category,
    SUM(product_name_length IS NULL) AS null_name_length,
    SUM(product_description_lenght IS NULL) AS null_description_length,
    SUM(product_category_name IS NULL) AS null_category
FROM olist_products_clean;

OBSERVATION
Result:
remaining_zero_name_length | remaining_zero_description_length
----------------------------|-----------------------------------
0                           | 0

remaining_empty_category | remaining_whitespace_category
-------------------------|-------------------------------
0                        | 0

null_name_length | null_description_length | null_category
-----------------|-------------------------|--------------
610              | 610                     | 610

CONCLUSION
The 610 incomplete metadata records were successfully converted to NULL.
No empty category values remain.

INVESTIGATION: Zero product photos
SQL QUERY : 
SELECT
    COUNT(*) AS zero_photo_rows,
    COUNT(DISTINCT product_id) AS zero_photo_products,
    SUM(product_name_length IS NULL) AS null_name_length,
    SUM(product_description_lenght IS NULL) AS null_description_length,
    SUM(product_category_name IS NULL) AS null_category
FROM olist_products_clean
WHERE product_photos_qty = 0;

OBSERVATION
Result:
zero_photo_rows | zero_photo_products
----------------|--------------------
610             | 610

The same 610 products also contain NULL values for name length, description length, and category after cleaning.

CONCLUSION
Zero photos were not converted to NULL because the dataset does not provide sufficient evidence that zero photographs are invalid.
The value 0 is therefore preserved.

VALIDATION 3: Final product invalid-value check
SQL QUERY :
SELECT
    COUNT(*) AS total_products,
    SUM(product_weight_g = 0) AS zero_weight,
    SUM(product_length_cm = 0) AS zero_length,
    SUM(product_height_cm = 0) AS zero_height,
    SUM(product_width_cm = 0) AS zero_width,
    SUM(product_name_length = 0) AS zero_name_length,
    SUM(product_description_lenght = 0) AS zero_description_length,
    SUM(
        product_category_name IS NOT NULL
        AND TRIM(product_category_name) = ''
    ) AS blank_category,
    SUM(product_photos_qty = 0) AS zero_photos
FROM olist_products_clean;

OBSERVATION
Result:
total_products | zero_weight | zero_length | zero_height | zero_width
---------------|-------------|-------------|--------------|-----------
32,951         | 0           | 0           | 0            | 0

zero_name_length | zero_description_length | blank_category | zero_photos
-----------------|-------------------------|----------------|------------
0                | 0                       | 0              | 610

CONCLUSION
All confirmed invalid zero values were removed.
The 610 zero-photo records were intentionally preserved because zero photos were not proven to be invalid.

VALIDATION 4: Confirm no negative product values remain
SQL QUERY : 
SELECT
    SUM(product_weight_g < 0) AS negative_weight,
    SUM(product_length_cm < 0) AS negative_length,
    SUM(product_height_cm < 0) AS negative_height,
    SUM(product_width_cm < 0) AS negative_width,
    SUM(product_photos_qty < 0) AS negative_photos,
    SUM(product_name_length < 0) AS negative_name_length,
    SUM(product_description_lenght < 0) AS negative_description_length
FROM olist_products_clean;

OBSERVATION
Result:
negative_weight | negative_length | negative_height | negative_width
----------------|-----------------|-----------------|---------------
0               | 0               | 0               | 0

negative_photos | negative_name_length | negative_description_length
----------------|----------------------|----------------------------
0               | 0                    | 0

CONCLUSION
No negative product values remain.

SECTION 5: TABLES NOT REQUIRING INVALID-VALUE CLEANING
The invalid-value assessment found no confirmed invalid values requiring cleaning in the following tables:
- olist_customers_dataset
- olist_geolocation_dataset
- olist_order_items_dataset
- olist_sellers_dataset
- product_category_name_translation
Examples of confirmed valid conditions included:
- Customer ZIP codes within the expected numeric range
- Valid Brazilian state codes
- Valid geolocation latitude and longitude ranges
- No negative order item prices
- No negative freight values
- Valid order item identifier values
- No negative seller-related values
- No invalid translated category values
Monetary FLOAT data types identified during assessment were treated as a schema/design consideration rather than an invalid-value issue and were not
changed during this phase.

FINAL CONCLUSION
Invalid-value cleaning was successfully completed for the four Olist tables where confirmed invalid or placeholder values were identified.
The cleaning process focused on correcting values that could be confidently classified as invalid while preserving valid business records and avoiding
unsupported assumptions.

FINAL RESULTS
Table                         Main Cleaning Performed
---------------------------------------------------------------------------
olist_order_payments_clean    Converted 'not_defined' payment types to NULL
                              Converted 2 invalid installment values to NULL

olist_order_reviews_clean     Converted zero review dates to NULL
                              Preserved 74 unresolved chronology anomalies
                              Preserved optional blank review text

olist_orders_clean            Converted zero workflow timestamps to NULL
                              Preserved 166 carrier chronology anomalies
                              Preserved 23 customer/carrier anomalies
                              Preserved 8 delivered orders without actual
                              customer delivery timestamps
                              Preserved 6 canceled orders with delivery dates

olist_products_clean          Converted zero physical measurements to NULL
                              Converted incomplete metadata to NULL
                              Preserved 610 zero-photo values
KEY CLEANING RESULTS
ORDER PAYMENTS
- 3 'not_defined' payment types converted to NULL
- 2 invalid installment values converted to NULL
- 0 invalid payment sequences remain
- 0 negative payment values remain

ORDER REVIEWS
- 1 zero review creation date converted to NULL
- 1 zero review answer timestamp converted to NULL
- 74 chronological anomalies remain documented
- Optional blank review text preserved

ORDERS
- 160 zero approval timestamps converted to NULL
- 1,783 zero carrier timestamps converted to NULL
- 2,965 zero customer delivery timestamps converted to NULL
- 166 carrier-before-purchase anomalies preserved and documented
- 23 customer-before-carrier anomalies preserved and documented
- 8 delivered orders without customer delivery timestamps preserved
- 6 canceled orders with customer delivery timestamps preserved

PRODUCTS
- 6 affected product records had zero physical measurements cleaned
- 610 incomplete product metadata records converted to NULL
- 610 zero-photo records intentionally preserved
- No negative product values remain

IMPORTANT DATA-CLEANING PRINCIPLE
Values were not changed simply because they looked unusual.
Where the correct value could be determined confidently, the invalid value was cleaned.
Where the correct value could not be determined, the value was converted to NULL or preserved and documented as an anomaly.
No business records were deleted because of invalid attributes.
The original/raw tables were preserved, and cleaned tables were created for downstream analysis.

DATA CLEANING STATUS
Invalid-value cleaning: COMPLETED
The cleaned tables are ready for the next data-cleaning phase.

