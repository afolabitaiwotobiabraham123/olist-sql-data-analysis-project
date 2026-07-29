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
