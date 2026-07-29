PHASE 2: DATA QUALITY ASSESSMENT
Objective:
-- Assess the quality and reliability of the Olist e-commerce datasets by identifying potential data quality issues.
The assessment will focus on:
-- 1. NULL values
-- 2. Duplicate records
-- 3. Duplicate identifiers
-- 4. Invalid or unexpected values
-- 5. Data consistency
-- 6. Data integrity issues
The findings from this phase will be used to determine
-- whether data cleaning or transformation is required before proceeding to further analysis.

SECTION 1: NULL VALUE ASSESSMENT
Objective:
-- Check for the presence of NULL values in the columns of each Olist dataset.
-- NULL values can indicate missing or incomplete information and may affect data analysis and business insights.
-- The NULL value assessment will be performed table by table.
  
1.1 NULL VALUE ASSESSMENT: olist_customers_dataset
Objective:
-- Check for the presence of NULL values in all columns of the olist_customers_dataset table.
SQL Query:
SELECT
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(customer_unique_id IS NULL) AS customer_unique_id_nulls,
    SUM(customer_zip_code_prefix IS NULL) AS customer_zip_code_prefix_nulls,
    SUM(customer_city IS NULL) AS customer_city_nulls,
    SUM(customer_state IS NULL) AS customer_state_nulls
FROM olist_customers_dataset;
Observation:
The query returned 0 NULL values for all 5 columns.
-- customer_id: 0 NULL values
-- customer_unique_id: 0 NULL values
-- customer_zip_code_prefix: 0 NULL values
-- customer_city: 0 NULL values
-- customer_state: 0 NULL values
Conclusion:
-- No NULL values were identified in the olist_customers_dataset table. 
-- Therefore, no NULL value treatment is required for this table at this stage of the Data Quality Assessment.
-- ==================================================================================================================================================

  1.2 NULL VALUE ASSESSMENT: olist_geolocation_dataset
 Objective:
-- Check for the presence of NULL values in all columns of the olist_geolocation_dataset table.
SQL Query:
SELECT
    SUM(geolocation_zip_code_prefix IS NULL) AS geolocation_zip_code_prefix_nulls,
    SUM(geolocation_lat IS NULL) AS geolocation_lat_nulls,
    SUM(geolocation_lng IS NULL) AS geolocation_lng_nulls,
    SUM(geolocation_city IS NULL) AS geolocation_city_nulls,
    SUM(geolocation_state IS NULL) AS geolocation_state_nulls
FROM olist_geolocation_dataset;
Observation:
The query returned 0 NULL values for all 5 columns.
-- geolocation_zip_code_prefix: 0 NULL values
-- geolocation_lat: 0 NULL values
-- geolocation_lng: 0 NULL values
-- geolocation_city: 0 NULL values
-- geolocation_state: 0 NULL values
Conclusion:
-- No NULL values were identified in the olist_geolocation_dataset table. 
-- Therefore, no NULL value treatment is required for this table at this stage of the Data Quality Assessment.
-- =====================================================================================================================================================
  
1.3 NULL VALUE ASSESSMENT: olist_orders_dataset
Objective:
-- Check for the presence of NULL values in all columns of the olist_orders_dataset table.
SQL Query:
SELECT
    SUM(order_id IS NULL) AS order_id_nulls,
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(order_status IS NULL) AS order_status_nulls,
    SUM(order_purchase_timestamp IS NULL) AS order_purchase_timestamp_nulls,
    SUM(order_approved_at IS NULL) AS order_approved_at_nulls,
    SUM(order_delivered_carrier_date IS NULL) AS order_delivered_carrier_date_nulls,
    SUM(order_delivered_customer_date IS NULL) AS order_delivered_customer_date_nulls,
    SUM(order_estimated_delivery_date IS NULL) AS order_estimated_delivery_date_nulls
FROM olist_orders_dataset;
Observation:
The query returned 0 NULL values for all 8 columns.
-- order_id: 0 NULL values
-- customer_id: 0 NULL values
-- order_status: 0 NULL values
-- order_purchase_timestamp: 0 NULL values
-- order_approved_at: 0 NULL values
-- order_delivered_carrier_date: 0 NULL values
-- order_delivered_customer_date: 0 NULL values
-- order_estimated_delivery_date: 0 NULL values
Conclusion:
-- No NULL values were identified in the olist_orders_dataset table. 
-- Therefore, no NULL value treatment is required for this table at this stage of the Data Quality Assessment.
-- ======================================================================================================================================================

1.4 NULL VALUE ASSESSMENT: olist_order_payments_dataset
Objective:
-- Check for the presence of NULL values in all columns of the olist_order_payments_dataset table.
SQL Query:
SELECT
    SUM(order_id IS NULL) AS order_id_nulls,
    SUM(payment_sequential IS NULL) AS payment_sequential_nulls,
    SUM(payment_type IS NULL) AS payment_type_nulls,
    SUM(payment_installments IS NULL) AS payment_installments_nulls,
    SUM(payment_value IS NULL) AS payment_value_nulls
FROM olist_order_payments_dataset;
Observation:
The query returned 0 NULL values for all 5 columns.
-- order_id: 0 NULL values
-- payment_sequential: 0 NULL values
-- payment_type: 0 NULL values
-- payment_installments: 0 NULL values
-- payment_value: 0 NULL values
Conclusion:
-- No NULL values were identified in the olist_order_payments_dataset table. 
-- Therefore, no NULL value treatment is required for this table at this stage of the Data Quality Assessment.
-- =====================================================================================================================================================
  
1.5 NULL VALUE ASSESSMENT: olist_order_reviews_dataset
Objective:
-- Check for the presence of NULL values in all columns of the olist_order_reviews_dataset table.
SQL Query:
SELECT
    SUM(review_id IS NULL) AS review_id_nulls,
    SUM(order_id IS NULL) AS order_id_nulls,
    SUM(review_score IS NULL) AS review_score_nulls,
    SUM(review_comment_title IS NULL) AS review_comment_title_nulls,
    SUM(review_comment_message IS NULL) AS review_comment_message_nulls,
    SUM(review_creation_date IS NULL) AS review_creation_date_nulls,
    SUM(review_answer_timestamp IS NULL) AS review_answer_timestamp_nulls
FROM olist_order_reviews_dataset;
Observation:
The query returned 0 NULL values for all 7 columns.
-- review_id: 0 NULL values
-- order_id: 0 NULL values
-- review_score: 0 NULL values
-- review_comment_title: 0 NULL values
-- review_comment_message: 0 NULL values
-- review_creation_date: 0 NULL values
-- review_answer_timestamp: 0 NULL values
Conclusion:
-- No NULL values were identified in the olist_order_reviews_dataset table. 
-- Therefore, no NULL value treatment is required for this table at this stage of the Data Quality Assessment.
-- =====================================================================================================================================================
  
1.6 NULL VALUE ASSESSMENT: olist_order_items_dataset
Objective:
-- Check for the presence of NULL values in all columns of the olist_order_items_dataset table.
SQL Query:
SELECT
    SUM(order_id IS NULL) AS order_id_nulls,
    SUM(order_item_id IS NULL) AS order_item_id_nulls,
    SUM(product_id IS NULL) AS product_id_nulls,
    SUM(seller_id IS NULL) AS seller_id_nulls,
    SUM(shipping_limit_date IS NULL) AS shipping_limit_date_nulls,
    SUM(price IS NULL) AS price_nulls,
    SUM(freight_value IS NULL) AS freight_value_nulls
FROM olist_order_items_dataset;
Observation:
The query returned 0 NULL values for all 7 columns.
-- order_id: 0 NULL values
-- order_item_id: 0 NULL values
-- product_id: 0 NULL values
-- seller_id: 0 NULL values
-- shipping_limit_date: 0 NULL values
-- price: 0 NULL values
-- freight_value: 0 NULL values
Conclusion:
-- No NULL values were identified in the olist_order_items_dataset table. 
-- Therefore, no NULL value treatment is required for this table at this stage of the Data Quality Assessment.
-- ==========================================================================================================================================================

1.7 NULL VALUE ASSESSMENT: olist_products_dataset
Objective:
-- Check for the presence of NULL values in all columns of the olist_products_dataset table.
SQL Query:
SELECT
    SUM(product_id IS NULL) AS product_id_nulls,
    SUM(product_category_name IS NULL) AS product_category_name_nulls,
    SUM(product_name_length IS NULL) AS product_name_length_nulls,
    SUM(product_description_lenght IS NULL) AS product_description_lenght_nulls,
    SUM(product_photos_qty IS NULL) AS product_photos_qty_nulls,
    SUM(product_weight_g IS NULL) AS product_weight_g_nulls,
    SUM(product_length_cm IS NULL) AS product_length_cm_nulls,
    SUM(product_height_cm IS NULL) AS product_height_cm_nulls,
    SUM(product_width_cm IS NULL) AS product_width_cm_nulls
FROM olist_products_dataset;
Observation:
The query returned 0 NULL values for all 9 columns.
-- product_id: 0 NULL values
-- product_category_name: 0 NULL values
-- product_name_length: 0 NULL values
-- product_description_lenght: 0 NULL values
-- product_photos_qty: 0 NULL values
-- product_weight_g: 0 NULL values
-- product_length_cm: 0 NULL values
-- product_height_cm: 0 NULL values
-- product_width_cm: 0 NULL values
Conclusion:
-- No NULL values were identified in the olist_products_dataset table. 
-- Therefore, no NULL value treatment is required for this table at this stage of the Data Quality Assessment.
-- ========================================================================================================================================================

1.8 NULL VALUE ASSESSMENT: olist_sellers_dataset
Objective:
-- Check for the presence of NULL values in all columns of the olist_sellers_dataset table.
SQL Query:
SELECT
    SUM(seller_id IS NULL) AS seller_id_nulls,
    SUM(seller_zip_code_prefix IS NULL) AS seller_zip_code_prefix_nulls,
    SUM(seller_city IS NULL) AS seller_city_nulls,
    SUM(seller_state IS NULL) AS seller_state_nulls
FROM olist_sellers_dataset;
Observation:
The query returned 0 NULL values for all 4 columns.
-- seller_id: 0 NULL values
-- seller_zip_code_prefix: 0 NULL values
-- seller_city: 0 NULL values
-- seller_state: 0 NULL values
Conclusion:
-- No NULL values were identified in the olist_sellers_dataset table. 
-- Therefore, no NULL value treatment is required for this table at this stage of the Data Quality Assessment.
-- ========================================================================================================================================================

1.9 NULL VALUE ASSESSMENT: product_category_name_translation
Objective:
-- Check for the presence of NULL values in all columns of the product_category_name_translation table.
SQL Query:
SELECT
    SUM(product_category_name IS NULL) AS product_category_name_nulls,
    SUM(product_category_name_english IS NULL) AS product_category_name_english_nulls
FROM product_category_name_translation;
Observation:
The query returned 0 NULL values for both columns.
-- product_category_name: 0 NULL values
-- product_category_name_english: 0 NULL values
Conclusion:
-- No NULL values were identified in the product_category_name_translation table. 
-- Therefore, no NULL value treatment is required for this table at this stage of the Data Quality Assessment.
-- ===========================================================================================================================================================
  
SECTION 2: DUPLICATE RECORD AND IDENTIFIER UNIQUENESS ASSESSMENT
Objective:
-- Assess the Olist datasets for duplicate records and evaluate the uniqueness of important identifier columns.
-- Duplicate records can lead to inaccurate analysis, including inflated customer counts, order counts, product counts, and other business metrics.
The assessment distinguishes between:
-- Exact duplicate records, where all column values are identical.
-- Repeated identifier values, where the same identifier appears in multiple records.
NOTE
-- Repeated identifiers do not always indicate duplicate records.
-- Some identifiers may legitimately appear multiple times based on the relationships and structure of the dataset.

2.1 DUPLICATE RECORD AND IDENTIFIER UNIQUENESS ASSESSMENT: olist_customers_dataset
2.1.1 EXACT DUPLICATE RECORD ASSESSMENT
Objective:
-- Check for exact duplicate records in the olist_customers_dataset table.
SQL Query:
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state,
    COUNT(*) AS duplicate_count
FROM olist_customers_dataset
GROUP BY
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no exact duplicate records were identified in the olist_customers_dataset table.
This means that no two or more records have identical values across all five columns:
-- customer_id
-- customer_unique_id
-- customer_zip_code_prefix
-- customer_city
-- customer_state
Conclusion:
-- No exact duplicate records were identified in the olist_customers_dataset table. 
-- Therefore, no duplicate record removal is required for this table at this stage of the Data Quality Assessment.

2.1.2 CUSTOMER_ID UNIQUENESS ASSESSMENT
Objective:
-- Check whether repeated customer_id values exist in the olist_customers_dataset table.
SQL Query:
SELECT
    customer_id,
    COUNT(*) AS occurrence_count
FROM olist_customers_dataset
GROUP BY customer_id
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no repeated customer_id values were identified.
-- Each customer_id appears exactly once in the olist_customers_dataset table.
Conclusion:
-- The customer_id column demonstrates unique values across all records in the table. 
-- This indicates that customer_id functions as a unique identifier for each customer record in the dataset.
  
2.1.3 CUSTOMER_UNIQUE_ID UNIQUENESS ASSESSMENT
Objective:
-- Check whether repeated customer_unique_id values exist in the olist_customers_dataset table.
SQL Query:
SELECT
    customer_unique_id,
    COUNT(*) AS occurrence_count
FROM olist_customers_dataset
GROUP BY customer_unique_id
HAVING COUNT(*) > 1;
Observation:
-- The query returned 2,997 customer_unique_id values that appeared more than once in the table.
-- The occurrence count ranged from 2 to 19 records per repeated customer_unique_id.
-- This indicates that some customers are associated with multiple records in the olist_customers_dataset table.
-- The repeated customer_unique_id values are not considered exact duplicate records 
-- because the earlier duplicate assessment found no rows with identical values across all five columns.
-- The repetition of customer_unique_id is expected based on the structure of the Olist dataset. 
-- A single real customer can place multiple orders, and each order may be associated with a separate customer_id while retaining the same customer_unique_id.
Conclusion:
-- The customer_unique_id column is not unique in the olist_customers_dataset table.
-- However, the repeated values are considered valid and expected based on the dataset structure and should not be removed as duplicates.
-- The customer_unique_id should therefore be treated as an identifier for the actual customer, 
-- while customer_id represents the customer record associated with an order.
-- No data cleaning action is required for the repeated customer_unique_id values at this stage.
-- ==============================================================================================================================================================

2.2 DUPLICATE RECORD AND IDENTIFIER UNIQUENESS ASSESSMENT: olist_geolocation_dataset
2.2.1 EXACT DUPLICATE RECORD ASSESSMENT
Objective:
-- Check for exact duplicate records in the olist_geolocation_dataset table.
SQL Query:
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS duplicate_count
FROM olist_geolocation_dataset
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1;
Observation:
-- The query identified 131,544 groups of records that appeared more than once in the olist_geolocation_dataset table.
-- The duplicate_count ranged from 2 to 314 occurrences per duplicate record group.
This indicates that multiple records have identical values across all five columns:
-- geolocation_zip_code_prefix
-- geolocation_lat
-- geolocation_lng
-- geolocation_city
-- geolocation_state
-- The results indicate the presence of exact duplicate records.
-- However, the 131,544 returned rows represent duplicate groups rather than the total number of redundant duplicate rows.

2.2.2 TOTAL ROW COUNT ASSESSMENT
Objective:
-- Determine the total number of records currently stored in the olist_geolocation_dataset table.
SQL Query:
SELECT
    COUNT(*) AS total_rows
FROM olist_geolocation_dataset;
Observation:
-- The query returned a total of 1,000,163 rows in the olist_geolocation_dataset table.

2.2.3 UNIQUE RECORD COUNT ASSESSMENT
Objective:
-- Determine the number of unique records based on the combination of all five columns in the olist_geolocation_dataset table.
SQL Query:
SELECT
    COUNT(*) AS unique_records
FROM (
    SELECT DISTINCT
        geolocation_zip_code_prefix,
        geolocation_lat,
        geolocation_lng,
        geolocation_city,
        geolocation_state
    FROM olist_geolocation_dataset
) AS unique_geolocation_records;
Observation:
-- The query returned 720,496 unique records based on the combination of all five columns in the table.

2.2.4 REDUNDANT DUPLICATE ROW COUNT ASSESSMENT
Objective:
-- Determine the number of redundant duplicate rows by comparing the total number of rows with the number of unique records.
SQL Query:
SELECT
    COUNT(*) - COUNT(DISTINCT CONCAT(
        geolocation_zip_code_prefix, '|',
        geolocation_lat, '|',
        geolocation_lng, '|',
        geolocation_city, '|',
        geolocation_state
    )) AS redundant_duplicate_rows
FROM olist_geolocation_dataset;
Observation:
-- The query identified 279,667 redundant duplicate rows.
This result is consistent with the difference between the total number of rows and the number of unique records:
-- 1,000,163 total rows - 720,496 unique records = 279,667 redundant duplicate rows.
-- Therefore, 279,667 rows represent additional copies of records that already exist in the dataset.
-- The redundant duplicate rows account for approximately 28% of the total records in the table.

2.2.5 GEOLOCATION_ZIP_CODE_PREFIX UNIQUENESS ASSESSMENT
Objective:
-- Check whether repeated geolocation_zip_code_prefix values exist in the olist_geolocation_dataset table.
SQL Query:
SELECT
    geolocation_zip_code_prefix,
    COUNT(*) AS occurrence_count
FROM olist_geolocation_dataset
GROUP BY geolocation_zip_code_prefix
HAVING COUNT(*) > 1;
Observation:
-- The query identified 17,972 geolocation_zip_code_prefix values that appeared more than once in the table.
-- The occurrence count for repeated ZIP code prefixes ranged from 2 to 1,146 records.
-- This indicates that the geolocation_zip_code_prefix column does not contain unique values.
-- The repeated ZIP code prefixes are expected based on the structure and purpose of the geolocation dataset. 
-- A single ZIP code prefix can be associated with multiple geographic coordinates, cities, or locations.
-- Therefore, the presence of repeated geolocation_zip_code_prefix values does not, by itself, indicate duplicate or erroneous records.
-- It is important to distinguish these repeated ZIP code prefixes from the exact duplicate records identified earlier. 
-- The repeated ZIP code prefixes may represent legitimate geographic records, whereas exact duplicates have identical values across all five columns.

Conclusion:
-- The olist_geolocation_dataset contains 1,000,163 total rows, of which 720,496 are unique records based on the combination of all five columns.
-- The assessment identified 279,667 redundant duplicate rows, indicating a significant level of exact record duplication within the table.
-- The geolocation_zip_code_prefix column is not unique, with 17,972 ZIP code prefixes appearing more than once and occurrence counts ranging from 2 to 1,146.
-- The repeated ZIP code prefixes are considered valid and expected for the geolocation dataset and should not be removed as duplicate records solely 
-- because the ZIP coden prefix is repeated.
-- Any duplicate record removal should be based on the complete combination of the five columns rather than on the geolocation_zip_code_prefix column alone.
-- No duplicate records will be removed at this stage.
-- The identified exact redundant duplicate records will be reviewed and addressed during the Data Cleaning phase.
-- =============================================================================================================================================================

2.3 DUPLICATE RECORD AND IDENTIFIER UNIQUENESS ASSESSMENT: olist_orders_dataset
2.3.1 EXACT DUPLICATE RECORD ASSESSMENT
Objective:
-- Check for exact duplicate records in the olist_orders_dataset table.
SQL Query:
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date,
    COUNT(*) AS duplicate_count
FROM olist_orders_dataset
GROUP BY
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no exact duplicate records were identified in the olist_orders_dataset table.
This means that no two or more records have identical values across all eight columns:
-- order_id
-- customer_id
-- order_status
-- order_purchase_timestamp
-- order_approved_at
-- order_delivered_carrier_date
-- order_delivered_customer_date
-- order_estimated_delivery_date
Conclusion:
-- No exact duplicate records were identified in the olist_orders_dataset table.
-- Therefore, no duplicate record removal is required for this table at this stage of the Data Quality Assessment.

2.3.2 ORDER_ID UNIQUENESS ASSESSMENT
Objective:
-- Check whether repeated order_id values exist in the olist_orders_dataset table.
SQL Query:
SELECT
    order_id,
    COUNT(*) AS occurrence_count
FROM olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no repeated order_id values were identified in the table.
-- Each order_id appears exactly once in the olist_orders_dataset table.
-- This confirms that the order_id column contains unique values across all records in the table.
Conclusion:
-- The order_id column functions as a unique identifier for each order record in the olist_orders_dataset table.
-- No repeated order_id values were identified, and therefore
-- no data cleaning action is required for order_id uniqueness at this stage of the Data Quality Assessment.

2.3.3 CUSTOMER_ID REPEAT VALUE ASSESSMENT
Objective:
-- Check whether customer_id values are repeated in the olist_orders_dataset table.
SQL Query:
SELECT
    customer_id,
    COUNT(*) AS occurrence_count
FROM olist_orders_dataset
GROUP BY customer_id
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no repeated customer_id values were identified in the olist_orders_dataset table.
-- Each customer_id appears only once in the olist_orders_dataset table.
-- This indicates that, within this table, each customer_id is associated with a single order record.
-- However, customer_id should not automatically be interpreted as the unique identifier of the actual customer across the entire Olist dataset.
-- The customer_unique_id column in the olist_customers_dataset table represents the actual customer and may be associated with multiple customer records.
-- Therefore, to determine whether the same real customer has placed multiple orders, 
-- customer_unique_id should be analyzed across the related tables using customer_id as the linking key.

Conclusion:
-- No repeated customer_id values were identified in the olist_orders_dataset table.
-- The customer_id column therefore contains unique values within this table. 
-- However, the relationship between actual customers and multiple orders should be assessed using customer_unique_id across the relevant tables,
-- rather than relying solely on customer_id.
-- =============================================================================================================================================================

2.4 DUPLICATE RECORD AND IDENTIFIER UNIQUENESS ASSESSMENT: olist_order_payments_dataset
2.4.1 EXACT DUPLICATE RECORD ASSESSMENT
Objective:
-- Check for exact duplicate records in the olist_order_payments_dataset table.
SQL Query:
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,
    COUNT(*) AS duplicate_count
FROM olist_order_payments_dataset
GROUP BY
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no exact duplicate payment records were identified in the olist_order_payments_dataset table.
This means that no two or more records have identical values across all five columns:
-- order_id
-- payment_sequential
-- payment_type
-- payment_installments
-- payment_value
-- Although the order_id column may appear multiple times in the payment table, repeated order_id values do not automatically represent duplicate records. 
-- A single order may be associated with multiple payment records.
-- Therefore, the complete combination of payment-related columns was used to identify exact duplicate records.
Conclusion:
-- No exact duplicate records were identified in the olist_order_payments_dataset table.
-- Therefore, no duplicate payment records require removal based on the current exact duplicate assessment.

2.4.2 ORDER_ID REPEAT VALUE ASSESSMENT
Objective:
-- Identify orders associated with multiple payment records.
SQL Query:
SELECT
    order_id,
    COUNT(*) AS occurrence_count
FROM olist_order_payments_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;
Observation:
-- The query identified 2,961 order_id values that appeared more than once in the olist_order_payments_dataset table.
-- The occurrence count for these repeated order_id values ranged from 2 to 29 payment records per order.
-- This indicates that some orders are associated with multiple payment records in the payment dataset.
-- The repeated order_id values should not be considered exact duplicates because the earlier exact duplicate assessment returned no rows.
-- Multiple payment records for the same order may represent different payment transactions or payment components associated with a single order.
-- Therefore, the repeated order_id values are considered expected based on the structure of the payment table and
-- do not, by themselves, indicate a data-quality issue.
-- The payment_sequential column helps distinguish multiple payment records associated with the same order.
Conclusion:
-- The order_id column is not unique in the olist_order_payments_dataset table.
-- A total of 2,961 order_id values were found to have multiple payment records, with occurrence counts ranging from 2 to 29.
-- This is considered an expected characteristic of the payment table rather than an error, 
-- provided that each payment record represents a valid payment associated with the corresponding order.
-- Therefore, repeated order_id values should not be removed during data cleaning solely because they occur multiple times.

2.4.3 ORDER_ID AND PAYMENT_SEQUENTIAL UNIQUENESS ASSESSMENT
Objective:
-- Check whether the combination of order_id and payment_sequential contains repeated values.
-- This assessment determines whether the same payment sequence number is assigned more than once within the same order.
SQL Query:
SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS occurrence_count
FROM olist_order_payments_dataset
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no repeated combinations of order_id and payment_sequential were
-- identified in the olist_order_payments_dataset table.
-- This indicates that each payment record within an order has a unique payment_sequential value.
-- No order was found to have the same payment_sequential value assigned to multiple records.
-- Therefore, the combination of order_id and payment_sequential provides a unique way to distinguish individual payment records within each order.
Conclusion:
-- No duplicate combinations of order_id and payment_sequential were identified.
-- The combination of order_id and payment_sequential can therefore be treated as a unique composite identifier for
-- payment records within the olist_order_payments_dataset table.
-- No data cleaning action is required based on the uniqueness of this composite identifier.
-- =============================================================================================================================================================

2.5 DUPLICATE RECORD AND IDENTIFIER UNIQUENESS ASSESSMENT: olist_order_reviews_dataset
2.5.1 EXACT DUPLICATE RECORD ASSESSMENT
Objective:
-- Check for exact duplicate records in the olist_order_reviews_dataset table.
SQL Query:
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    COUNT(*) AS duplicate_count
FROM olist_order_reviews_dataset
GROUP BY
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no exact duplicate review records were identified in the olist_order_reviews_dataset table.
-- This means that no two or more records contain identical values across all seven columns:
-- review_id
-- order_id
-- review_score
-- review_comment_title
-- review_comment_message
-- review_creation_date
-- review_answer_timestamp
-- Therefore, no exact duplicate review records were identified during this assessment.
Conclusion:
-- No exact duplicate review records were identified.
-- Therefore, no records require removal based on the exact duplicate assessment.

2.5.2 REVIEW_ID UNIQUENESS ASSESSMENT
Objective:
-- Determine whether review_id values are unique within the olist_order_reviews_dataset table.
SQL Query:
SELECT
    review_id,
    COUNT(*) AS occurrence_count
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1;
Observation:
-- The query identified 789 review_id values that appeared more than once in the olist_order_reviews_dataset table.
-- The occurrence count for the repeated review_id values ranged from 2 to 3.
-- This indicates that the review_id column does not contain unique values across all records in the table.
-- Therefore, review_id should not be treated as a unique identifier for individual review records.
Conclusion:
-- The review_id column is not unique within the olist_order_reviews_dataset table.
-- A total of 789 review_id values were found to occur more than once, with each repeated review_id occurring between 2 and 3 times.

2.5.3 REVIEW_ID AND ORDER_ID RELATIONSHIP ASSESSMENT
Objective:
-- Determine whether repeated review_id values are associated with the same order_id or with different order_id values.
SQL Query:
SELECT
    review_id,
    COUNT(*) AS review_record_count,
    COUNT(DISTINCT order_id) AS unique_order_count
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1;
Observation:
-- The query returned 789 rows, corresponding to the 789 review_id values that were identified as repeated.
-- For the repeated review_id values, the review_record_count and unique_order_count values were the same.
-- This indicates that each occurrence of a repeated review_id is associated with a different order_id.
-- For example, a review_id with a review_record_count of 2 and a unique_order_count of 2 is associated with two different orders.
-- Similarly, a review_id with a review_record_count of 3 and a unique_order_count of 3 is associated with three different orders.
Conclusion:
-- The repeated review_id values are associated with multiple different order_id values rather than being repeated for the same order.

2.5.4 INVESTIGATION OF RECORDS ASSOCIATED WITH REPEATED REVIEW_ID VALUES
Objective:
-- Retrieve all records associated with review_id values that appear more than once in the dataset,
-- in order to investigate the nature of the repeated review records.
SQL Query:
SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM olist_order_reviews_dataset
WHERE review_id IN (
    SELECT
        review_id
    FROM olist_order_reviews_dataset
    GROUP BY review_id
    HAVING COUNT(*) > 1
)
ORDER BY review_id, order_id;
Observation:
-- The query returned 1,603 records.
-- These 1,603 records represent all rows associated with the 789 review_id values that were identified as repeated.
-- The difference between the 789 repeated review_id values and the 1,603 returned records is because 
-- each repeated review_id occurs between 2 and 3 times in the dataset.
-- Therefore: 789 = Number of distinct review_id values that occur more than once.
-- 1,603 = Total number of records associated with those repeated review_id values.
-- Examination of the returned records showed that the same review_id can be associated with different order_id values.
-- In the examples examined, the review_score,review_comment_title, review_comment_message,review_creation_date, and review_answer_timestamp values
-- remained identical while the order_id values differed.
Conclusion:
-- The 1,603 records are not considered exact duplicate records because the associated order_id values differ.
-- The repeated review_id values require further interpretation based on their relationship with orders and customers rather
-- than being automatically treated as duplicate records.

2.5.5 REVIEW CONTENT CONSISTENCY ASSESSMENT
Objective:
-- Determine whether repeated review_id values have identical review information while being associated with different order_id values.
SQL Query:
SELECT
    review_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    COUNT(*) AS occurrence_count,
    COUNT(DISTINCT order_id) AS unique_order_count
FROM olist_order_reviews_dataset
GROUP BY
    review_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
HAVING COUNT(*) > 1;
Observation:
-- The query confirmed that repeated review_id values can have identical review information across multiple records.
-- The review information examined includes:
-- review_score
-- review_comment_title
-- review_comment_message
-- review_creation_date
-- review_answer_timestamp
-- The occurrence_count and unique_order_count values were the same for the repeated review_id groups identified.
-- This indicates that the repeated review_id values are associated with different order_id values while the
-- corresponding review information remains identical within each repeated group.
-- For example, a review_id with an occurrence_count of 2 and a unique_order_count of 2 represents the same review_id
-- appearing in two records associated with two different orders.
-- Similarly, a review_id with an occurrence_count of 3 and a unique_order_count of 3 represents the same review_id
-- appearing in three records associated with three different orders.
Conclusion:
-- The repeated review_id values are not exact duplicate records because the associated order_id values differ.
-- However, review_id cannot be considered a unique identifier within the olist_order_reviews_dataset table.
-- The repeated review information should therefore be interpreted in the context of its relationship with order_id and customer information.

2.5.6 INVESTIGATION OF CUSTOMER RELATIONSHIP
Objective:
-- Investigate whether repeated review_id values associated with different orders belong to different customers or to the same real customer.
SQL Query:
SELECT
    r.review_id,
    r.order_id,
    o.customer_id,
    c.customer_unique_id,
    r.review_score,
    r.review_comment_message
FROM olist_order_reviews_dataset AS r
JOIN olist_orders_dataset AS o
    ON r.order_id = o.order_id
JOIN olist_customers_dataset AS c
    ON o.customer_id = c.customer_id
WHERE r.review_id = '00130cbe1f9d422698c812ed8ded1919';
Observation:
-- The investigation of the repeated review_id 00130cbe1f9d422698c812ed8ded1919 identified two different order_id values:
-- 1. dfcdfc43867d1c1381bfaf62d6b9c195
-- 2. 04a28263e085d399c97ae49e0b477efa
-- The two orders were associated with different customer_id values:
-- 1. a7026133ddbd2e86c83ecd4dfa4dbe01
-- 2. fef2e5e63da9f3e1dd89e8e319468657
-- However, both customer_id values were associated with the same customer_unique_id: f30856ad31d3e74253a3f4ccef670648
-- This indicates that the two different customer_id values represent the same real-world customer.
-- The two orders were therefore placed by the same customer_unique_id, while the review_id and review information remained the same across both orders.
Conclusion:
-- The investigation demonstrates that repeated review_id values can be associated with multiple orders belonging to the same customer_unique_id.
-- The different customer_id values represent separate customer records associated with individual orders, while the
-- customer_unique_id identifies the same real-world customer.
-- Therefore, the repeated review_id finding should not be automatically interpreted as an exact duplicate or as a confirmed data-entry error.
-- Instead, the finding should be documented as a characteristic of the source dataset and considered when using review_id
-- for record identification, joins, or analysis.
-- no exact duplicate review records in the olist_order_reviews_dataset table.
-- The exact duplicate assessment returned zero rows, indicating that no two records contained identical values across all seven columns examined.
-- The review_id uniqueness assessment identified 789 review_id values that occurred more than once, with occurrence counts ranging from 2 to 3.
-- A further investigation of these repeated review_id values returned 1,603 records in total. The 789 repeated review_id 
-- values and the 1,603 returned records represent two different measurements:
-- 789 = Number of distinct review_id values that were repeated.
-- 1,603 = Total number of records associated with those repeated review_id values.
-- Further assessment showed that the repeated review_id values were associated with different order_id values. 
-- The review_record_count and unique_order_count were the same,
-- indicating that each repeated review_id occurrence was associated with a different order.
-- Examination of the repeated records showed that the same review information, including review_score, review comments,review_creation_date,
-- and review_answer_timestamp, could appear across records associated with different orders.
-- An additional customer-level investigation showed that, for the example examined, the different orders were linked
-- to different customer_id values but shared the same customer_unique_id.
-- This indicates that the different orders belonged to the same real-world customer.
-- Therefore, review_id should not be treated as a globally unique identifier within the olist_order_reviews_dataset table.
-- However, the repeated review_id values should not be automatically classified as exact duplicate records or removed solely because the identifier is repeated.
-- The assessment found no exact duplicate records requiring removal.
-- The repeated review_id values should instead be documented as a characteristic of the source dataset and considered carefully in subsequent analysis, 
-- joins, and record identification.
-- Any future analysis involving review_id should consider its relationship with order_id, customer_id, and
-- customer_unique_id rather than assuming that review_id is unique.
-- ============================================================================================================================================================

2.6 DUPLICATE RECORD AND IDENTIFIER UNIQUENESS ASSESSMENT: olist_order_items_dataset
2.6.1 EXACT DUPLICATE RECORD ASSESSMENT
Objective:
-- Check for exact duplicate records in the olist_order_items_dataset table.
SQL Query:
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value,
    COUNT(*) AS duplicate_count
FROM olist_order_items_dataset
GROUP BY
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no exact duplicate order-item records were identified in the olist_order_items_dataset table.
-- This means that no two or more records contain identical values across all seven columns:
-- order_id
-- order_item_id
-- product_id
-- seller_id
-- shipping_limit_date
-- price
-- freight_value
-- Therefore, no exact duplicate order-item records were identified during this assessment.
Conclusion:
-- No exact duplicate records were identified in the olist_order_items_dataset table.
-- Therefore, no records require removal based on the exact duplicate assessment.

2.6.2 ORDER_ID REPETITION ASSESSMENT
Objective:
-- Determine whether an order can contain multiple order-item records.
SQL Query:
SELECT
    order_id,
    COUNT(*) AS occurrence_count
FROM olist_order_items_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;
Observation:
-- The query returned 9,803 rows, indicating that 9,803 different order_id values appear more than once in the olist_order_items_dataset table.
-- The occurrence_count ranged from 2 to 21.
-- This means that the identified orders contain between 2 and 21 order-item records.
-- The repetition of order_id values is expected because the olist_order_items_dataset table stores individual items associated with each order.
-- Therefore, a single order can contain multiple order-item records, with each record representing an individual item included in that order.
-- Repeated order_id values do not represent duplicate records when the associated order-item information is different.
Conclusion:
-- The order_id column is not expected to be unique within the olist_order_items_dataset table.
-- The repetition of order_id values is considered a normal characteristic of the table structure because one order can contain multiple items.
-- The identified repeated order_id values should not be removed as duplicates.
-- The order_id column should therefore be treated as a grouping or relationship key rather than a unique identifier for
-- individual records in the order-items table.

2.6.3 ORDER_ITEM_ID REPETITION ASSESSMENT
Objective:
-- Determine whether order_item_id values are unique across the entire olist_order_items_dataset table.
SQL Query:
SELECT
    order_item_id,
    COUNT(*) AS occurrence_count
FROM olist_order_items_dataset
GROUP BY order_item_id
HAVING COUNT(*) > 1;
Observation:
-- The query returned 20 rows, corresponding to order_item_id values ranging from 1 to 20.
-- The occurrence counts were as follows:
-- order_item_id = 1  → 98,666 occurrences
-- order_item_id = 2  →  9,803 occurrences
-- order_item_id = 3  →  2,287 occurrences
-- order_item_id = 4  →    965 occurrences
-- order_item_id = 5  →    460 occurrences
-- order_item_id = 6  →    256 occurrences
-- order_item_id = 7  →     58 occurrences
-- order_item_id = 8  →     36 occurrences
-- order_item_id = 9  →     28 occurrences
-- order_item_id = 10 →     25 occurrences
-- order_item_id = 11 →     17 occurrences
-- order_item_id = 12 →     13 occurrences
-- order_item_id = 13 →      8 occurrences
-- order_item_id = 14 →      7 occurrences
-- order_item_id = 15 →      5 occurrences
-- order_item_id = 16 →      3 occurrences
-- order_item_id = 17 →      3 occurrences
-- order_item_id = 18 →      3 occurrences
-- order_item_id = 19 →      3 occurrences
-- order_item_id = 20 →      3 occurrences
-- The total number of occurrences across all order_item_id values is 112,650, which corresponds to the total number of records in the table.
-- The result demonstrates that order_item_id is not globally unique within the table.
-- The distribution is consistent with order_item_id being used as a sequence or position number for items within an order.
-- For example, an order containing one item will have order_item_id = 1, while an order containing multiple items
-- may have order_item_id values of 1, 2, 3, and so on.
-- The numbering therefore restarts for each new order.
-- The decreasing frequency of the values from 1 through 20 indicates that fewer orders contain larger numbers of items.
Conclusion:
-- The order_item_id column is not unique across the entire olist_order_items_dataset table.
-- The repeated values are considered expected based on the structure of the dataset and should not be treated as duplicate records.
-- The order_item_id column should be interpreted as an item sequence or position within an order rather than as a globally unique identifier.

2.6.4 COMPOSITE IDENTIFIER ASSESSMENT: order_id + order_item_id
Objective:
-- Determine whether the combination of order_id and order_item_id uniquely identifies each order-item record.
SQL Query:
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS occurrence_count
FROM olist_order_items_dataset
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows.
-- This indicates that no combination of order_id and order_item_id appears more than once in the table.
-- While order_id is repeated across multiple records and order_item_id is also repeated across different orders, their combination does not repeat.
-- Therefore, each order_id + order_item_id combination uniquely identifies an individual order-item record.
Conclusion:
-- The combination of order_id and order_item_id functions as a composite identifier for individual records in the olist_order_items_dataset table.
-- The order_id identifies the order, while the order_item_id identifies the item's position within that specific order.
-- The combination of both columns provides a unique reference to each order-item record.
-- The duplicate and identifier uniqueness assessment found no exact duplicate records in the olist_order_items_dataset table.
-- The exact duplicate assessment returned zero rows, indicating that no two records contained identical values across all seven columns examined.
-- The order_id assessment identified 9,803 order_id values that occurred more than once, with occurrence counts ranging from 2 to 21.
-- This repetition is expected because one order can contain multiple items. Therefore, order_id is not expected to be unique within the order-items table.
-- The order_item_id assessment identified 20 repeated order_item_id values ranging from 1 to 20.
-- The value 1 occurred 98,666 times, while the values with higher sequence numbers occurred progressively less often,
-- with order_item_id values 16 through 20 occurring only a few times.
-- This distribution is consistent with order_item_id representing the sequence or position of an item within an order. 
-- The sequence restarts for each new order, meaning order_item_id is not globally unique across the table.
-- The composite identifier assessment found zero repeated combinations of order_id and order_item_id.
-- This indicates that the combination of order_id and order_item_id uniquely identifies each individual order-item record in the table.
-- Therefore: order_id → Not unique; identifies the order and can repeat when an order contains multiple items.
-- order_item_id → Not globally unique; represents the item's sequence or position within an order.
-- order_id + order_item_id → Unique combination; functions as a composite identifier for each order-item record.
-- Based on this assessment, no duplicate records requiring removal were identified.
-- The repeated values observed in order_id and order_item_id are considered expected characteristics of the table's 
-- relational structure rather than data-quality errors.
-- The combination of order_id and order_item_id should be considered when uniquely identifying individual records in subsequent analysis.
-- =============================================================================================================================================================

2.7 DUPLICATE RECORD AND IDENTIFIER UNIQUENESS ASSESSMENT: olist_products_dataset
2.7.1 EXACT DUPLICATE RECORD ASSESSMENT
Objective:
-- Identify exact duplicate product records in the olist_products_dataset table.
SQL Query:
SELECT
    product_id,
    product_category_name,
    product_name_length,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    COUNT(*) AS duplicate_count
FROM olist_products_dataset
GROUP BY
    product_id,
    product_category_name,
    product_name_length,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
HAVING COUNT(*) > 1;
Observation:
-- The query returned 32,951 rows.
-- Each duplicate group had a duplicate_count of 2,
-- indicating that each identified product record appears exactly twice with identical values across all nine columns examined.
-- The duplicate records include identical values for:
-- product_id
-- product_category_name
-- product_name_length
-- product_description_lenght
-- product_photos_qty
-- product_weight_g
-- product_length_cm
-- product_height_cm
-- product_width_cm
-- This indicates that the repeated records represent exact duplicate product records rather than different records associated with the same product.
Conclusion:
-- The assessment identified 32,951 exact duplicate product records, with each duplicate record appearing exactly twice.
-- These records should be flagged for removal during the subsequent Data Cleaning phase to prevent duplicate product records from affecting analysis.
2.7.2 PRODUCT_ID REPETITION ASSESSMENT
Objective:
-- Determine whether product_id values are unique within the olist_products_dataset table.
SQL Query:
SELECT
    product_id,
    COUNT(*) AS occurrence_count
FROM olist_products_dataset
GROUP BY product_id
HAVING COUNT(*) > 1;
Observation:
-- The query returned 32,951 rows.
-- All identified product_id values had an occurrence_count of exactly 2.
-- This indicates that each of the 32,951 product_id values appears exactly twice in the table.
-- The repeated product_id values correspond to the exact duplicate records identified in the previous assessment.
Conclusion:
-- The product_id column is not unique in the current raw dataset because every product_id appears twice.
-- However, the repeated product_id values are associated with exact duplicate product records.
-- Therefore, the repetition of product_id values is considered a data duplication issue rather than an expected relational structure of the products table.
-- The duplicate records should be addressed during the subsequent Data Cleaning phase.
2.7.3 TOTAL ROW AND UNIQUE PRODUCT_ID ASSESSMENT
Objective:
-- Compare the total number of records with the number of unique product_id values to further assess the extent of duplication.
SQL Query:
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM olist_products_dataset;
Observation:
-- The table contains 65,902 total rows and 32,951 unique product_id values.
-- The number of total rows is exactly twice the number of unique product_id values: 32,951 × 2 = 65,902
-- This confirms that every unique product_id occurs exactly twice in the dataset.
-- This result is consistent with the previous assessments, which identified 32,951 exact duplicate product records, each occurring twice.
Conclusion:
-- The comparison between total rows and unique product_id values confirms that the table contains a duplicated copy of every product record.
-- Each unique product is represented by two identical records in the raw dataset.
-- The duplicate records should be addressed during the Data Cleaning phase to ensure that each product is represented only once in the cleaned products dataset.
OVERALL CONCLUSION: olist_products_dataset
-- The duplicate and identifier uniqueness assessment found significant duplication within the olist_products_dataset table.
-- The exact duplicate assessment identified 32,951 duplicate product records, with each duplicate group appearing exactly twice.
-- The product_id repetition assessment also identified 32,951 repeated product_id values, with every product_id occurring exactly twice.
-- A comparison of the total number of rows and unique product_id values showed: Total rows = 65,902 Unique product_id values = 32,951
-- The total number of rows is exactly twice the number of unique products, confirming that each product record appears twice in the raw dataset.
-- The repeated product_id values are therefore not considered an expected relational characteristic of the products table.
-- Instead, they represent exact duplicate records.
-- No records should be deleted during the Data Quality
-- Assessment phase. However, the 32,951 duplicate records should be flagged for removal or deduplication during the subsequent Data Cleaning phase.
-- After deduplication, each product_id should uniquely identify one product record in the cleaned products dataset.
-- =============================================================================================================================================================

2.8 DUPLICATE RECORD AND IDENTIFIER UNIQUENESS ASSESSMENT: olist_sellers_dataset
2.8.1 EXACT DUPLICATE RECORD ASSESSMENT
Objective:
-- Check for exact duplicate seller records in the olist_sellers_dataset table.
SQL Query:
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state,
    COUNT(*) AS duplicate_count
FROM olist_sellers_dataset
GROUP BY
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no exact duplicate seller records were identified in the olist_sellers_dataset table.
-- No two or more records were found with identical values across all four columns:
-- seller_id
-- seller_zip_code_prefix
-- seller_city
-- seller_state
-- Therefore, no exact duplicate seller records were identified during this assessment.
Conclusion:
-- No exact duplicate records were identified in the olist_sellers_dataset table.
-- Therefore, no records require removal based on the exact duplicate assessment.
2.8.2 SELLER_ID UNIQUENESS ASSESSMENT
Objective:
-- Determine whether each seller_id uniquely identifies a single seller record in the olist_sellers_dataset table.
SQL Query:
SELECT
    seller_id,
    COUNT(*) AS occurrence_count
FROM olist_sellers_dataset
GROUP BY seller_id
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no seller_id values appear more than once in the olist_sellers_dataset table.
-- Therefore, each seller_id occurs only once in the table.
-- This result is consistent with the expected structure of a sellers reference table, where each seller should be represented by a single unique seller_id.
Conclusion:
-- The seller_id column is unique within the olist_sellers_dataset table.
-- No repeated seller identifiers were identified during this assessment.
-- Therefore, seller_id can be treated as a unique identifier for sellers in subsequent analysis.
-- The duplicate and identifier uniqueness assessment found -- no exact duplicate records in the olist_sellers_dataset table.
-- The exact duplicate assessment returned zero rows, indicating that no two or more seller records contain identical values across all four columns:
-- seller_id
-- seller_zip_code_prefix
-- seller_city
-- seller_state
-- The seller_id uniqueness assessment also returned zero rows, indicating that no seller_id values appear more than once in the table.
-- Therefore, each seller_id uniquely identifies a single seller record within the olist_sellers_dataset table.
-- The absence of repeated seller_id values is consistent with the expected structure of a sellers reference table,
-- where each seller should be represented by one unique record.
-- Based on the duplicate and identifier uniqueness assessment, 
-- no data-quality issues related to exact duplicate records or repeated seller identifiers were identified.
-- Therefore, no records require removal based on the assessments performed in this phase.
-- The seller_id column can be treated as a unique identifier for sellers in subsequent analysis and can be used to
-- establish relationships with other tables containing seller-related transaction records.
-- =============================================================================================================================================================

2.9 DUPLICATE RECORD AND IDENTIFIER UNIQUENESS ASSESSMENT: product_category_name_translation
2.9.1 EXACT DUPLICATE RECORD ASSESSMENT
Objective:
-- Check for exact duplicate category translation records.
SQL Query:
SELECT
    product_category_name,
    product_category_name_english,
    COUNT(*) AS duplicate_count
FROM product_category_name_translation
GROUP BY
    product_category_name,
    product_category_name_english
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no exact duplicate category translation records were identified in the product_category_name_translation table.
-- No two or more records were found with identical values across both columns:
-- product_category_name
-- product_category_name_english
-- Therefore, each Portuguese-English category translation pair appears only once in the table.
Conclusion:
-- No exact duplicate records were identified in the product_category_name_translation table.
-- Therefore, no records require removal based on the exact duplicate assessment.
2.9.2 PRODUCT_CATEGORY_NAME UNIQUENESS ASSESSMENT
Objective:
-- Determine whether each product_category_name appears only once in the product_category_name_translation table.
SQL Query:
SELECT
    product_category_name,
    COUNT(*) AS occurrence_count
FROM product_category_name_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no product_category_name values appear more than once in the product_category_name_translation table.
-- Therefore, each Portuguese product category appears only once in the translation table.
-- This indicates that each product_category_name has a single corresponding English translation record.
Conclusion:
-- The product_category_name column is unique within the product_category_name_translation table.
-- No repeated Portuguese product category names were identified during this assessment.
-- Therefore, product_category_name can be used as a unique reference for mapping Portuguese product categories to their corresponding English translations.
2.9.3 PRODUCT_CATEGORY_NAME_ENGLISH UNIQUENESS ASSESSMENT
Objective:
-- Determine whether each English product category translation appears only once in the product_category_name_translation table.
SQL Query:
SELECT
    product_category_name_english,
    COUNT(*) AS occurrence_count
FROM product_category_name_translation
GROUP BY product_category_name_english
HAVING COUNT(*) > 1;
Observation:
-- The query returned no rows, indicating that no product_category_name_english values appear more than once in the product_category_name_translation table.
-- Therefore, each English product category translation appears only once in the table.
-- This indicates that no two or more Portuguese product categories share the same English translation within the translation table.
Conclusion:
-- The product_category_name_english column is unique within the product_category_name_translation table.
-- No repeated English product category translations were identified during this assessment.
-- Therefore, product_category_name_english can also be treated as a unique value within this translation table.
-- The duplicate and identifier uniqueness assessment found no exact duplicate records in the product_category_name_translation table.
-- The exact duplicate assessment returned zero rows, indicating that no Portuguese-English category translation pair appears more than once.
-- The product_category_name uniqueness assessment also returned zero rows, indicating that each Portuguese product
-- category appears only once in the translation table.
-- The product_category_name_english uniqueness assessment returned zero rows as well, indicating that each English 
-- product category translation appears only once.
-- Therefore, both product_category_name and product_category_name_english contain unique values within the translation table.
-- The results indicate that each Portuguese product category has one corresponding English translation, and no duplicate
-- translation records or repeated category values were identified during this assessment.
-- Based on the duplicate and identifier uniqueness assessment,
-- no data-quality issues related to exact duplicate records or repeated category identifiers were identified.
-- Therefore, no records require removal based on the assessments performed in this phase.
-- The product_category_name column can be used as a unique reference for mapping Portuguese category names to their English translations.
-- The product_category_name_english column can also be treated as unique within this translation table and may be used as
-- a reference for English-language category analysis.
