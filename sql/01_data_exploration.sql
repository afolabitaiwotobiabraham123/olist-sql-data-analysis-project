-- ==========================================================================================================================================
OLIST E-COMMERCE DATA ANALYSIS
Phase 1: Data Exploration

Step 1: Explore Database Tables
-- ==========================================================================================================================================
Objective:
-- Identify all tables available in the Olist database.
SQL Query:
-- SHOW TABLES;
Observation:
The Olist database contains 9 tables:
-- 1. olist_customers_dataset
-- 2. olist_geolocation_dataset
-- 3. olist_order_dataset
-- 4. olist_order_payments_dataset
-- 5. olist_order_reviews_dataset
-- 6. olist_orders_items_dataset
-- 7. olist_products_dataset
-- 8. olist_sellers_dataset
-- 9. product_category_name_translation
-- ============================================================================================================================================

Step 2: Explore Table Structures
Table 1: olist_customers_dataset
Objective:
-- Explore the structure, columns, and data types of the olist_customers_dataset table.
SQL Query:
-- DESCRIBE olist_customers_dataset;
Observation:
-- The olist_customers_dataset table contains 5 columns:
1. customer_id
--    Data type: VARCHAR(32)
--    Description: Identifier for a customer record associated with an order.
2. customer_unique_id
--    Data type: VARCHAR(32)
--    Description: Unique identifier representing the actual customer.
3. customer_zip_code_prefix
--    Data type: INT
--    Description: The first five digits of the customer's ZIP code.
4. customer_city
--    Data type: VARCHAR(100)
--    Description: City where the customer is located.
5. customer_state
--    Data type: CHAR(2)
--    Description: Two-letter abbreviation of the customer's state.
-- ============================================================================================================================================
   
Table 2: olist_geolocation_dataset
Objective:
-- Explore the structure, columns, and data types of the olist_geolocation_dataset table.
SQL Query:
-- DESCRIBE olist_geolocation_dataset;
Observation:
-- The olist_geolocation_dataset table contains 5 columns:
1. geolocation_zip_code_prefix
--    Data type: INT
--    Description: The first five digits of the ZIP code associated with a geographic location in Brazil.

2. geolocation_lat
--    Data type: DECIMAL(10, 8)
--    Description: The latitude coordinate representing the north-south geographic position of the location.

3. geolocation_lng
--    Data type: DECIMAL(11, 8)
--    Description: The longitude coordinate representing the east-west geographic position of the location.

4. geolocation_city
--    Data type: VARCHAR(100)
--    Description: City associated with the geographic location identified by the ZIP code prefix.

5. geolocation_state
--    Data type: CHAR(2)
--    Description: Two-letter abbreviation of the Brazilian state where the geographic location is situated.
-- ==============================================================================================================================================

Table 3: olist_orders_dataset
Objective:
-- Explore the structure, columns, and data types of the olist_orders_dataset table.
SQL Query:
--DESCRIBE olist_orders_dataset;
Observation:
-- The olist_orders_dataset table contains 8 columns:
1. order_id
--    Data type: VARCHAR(32)
--    Description: Unique identifier assigned to each order.
2. customer_id
--    Data type: VARCHAR(32)
--    Description: Identifier linking the order to the customer who placed the order.
3. order_status
--    Data type: VARCHAR(20)
--    Description: Indicates the current status of the order, such as delivered, shipped, canceled, or unavailable.
4. order_purchase_timestamp
--    Data type: DATETIME
--    Description: Date and time when the customer placed the order.
5. order_approved_at
--    Data type: DATETIME
--    Description: Date and time when the payment for the order was approved.
6. order_delivered_carrier_date
--    Data type: DATETIME
--    Description: Date and time when the order was handed over to the logistics carrier for delivery.
7. order_delivered_customer_date
--    Data type: DATETIME
--    Description: Date and time when the order was delivered to the customer.
8. order_estimated_delivery_date
--    Data type: DATETIME
--    Description: Estimated date when the order was expected to be delivered to the customer.
-- =================================================================================================================================================

Table 4: olist_order_payments_dataset
Objective:
-- Explore the structure, columns, and data types of the olist_order_payments_dataset table.
SQL Query:
-- DESCRIBE olist_order_payments_dataset;
Observation:
-- The olist_order_payments_dataset table contains 5 columns:
1. order_id
-- Data type: VARCHAR(32)
-- Description: Identifier linking the payment record to the corresponding order.
2. payment_sequential
-- Data type: INT
-- Description: Sequential number identifying the order of payment methods or payment records associated with an order.
3. payment_type
-- Data type: VARCHAR(32)
-- Description: Type of payment method used to pay for the order,such as credit card, boleto, voucher, or debit card.
4. payment_installments
-- Data type: INT
-- Description: Number of installments selected by the customer for the payment of the order.
5. payment_value
-- Data type: FLOAT
-- Description: Total monetary value of the payment made for the order.
-- ==================================================================================================================================================

Table 5: olist_order_reviews_dataset
Objective:
-- Explore the structure, columns, and data types of the olist_order_reviews_dataset table.
SQL Query:
-- DESCRIBE olist_order_reviews_dataset;
Observation:
-- The olist_order_reviews_dataset table contains 7 columns:
1. review_id
-- Data type: VARCHAR(32)
-- Description: Unique identifier assigned to a customer review.
2. order_id
-- Data type: VARCHAR(32)
-- Description: Identifier linking the review to the corresponding order.
3. review_score
-- Data type: INT
-- Description: Numerical score given by the customer to rate their experience with the order.
4. review_comment_title
-- Data type: VARCHAR(255)
-- Description: Title or short heading provided by the customer as part of their review.
5. review_comment_message
-- Data type: VARCHAR(255)
-- Description: Written feedback or comment provided by the customer about their order experience.
6. review_creation_date
-- Data type: DATETIME
-- Description: Date and time when the customer review was created.
7. review_answer_timestamp
-- Data type: DATETIME
-- Description: Date and time when the review was answered or responded to.
-- ===================================================================================================================================================

Table 6: olist_order_items_dataset
Objective:
-- Explore the structure, columns, and data types of the olist_order_items_dataset table.
SQL Query:
-- DESCRIBE olist_order_items_dataset;
Observation:
-- The olist_order_items_dataset table contains 7 columns:
1. order_id
-- Data type: VARCHAR(32)
-- Description: Identifier linking the order item to the corresponding order.
2. order_item_id
-- Data type: VARCHAR(32)
-- Description: Identifier used to distinguish individual items within the same order.
3. product_id
-- Data type: VARCHAR(32)
-- Description: Identifier linking the order item to the corresponding product.
4. seller_id
-- Data type: VARCHAR(32)
-- Description: Identifier linking the order item to the seller responsible for selling the product.
5. shipping_limit_date
-- Data type: DATETIME
-- Description: Date and time by which the seller is expected to hand the order item over to the carrier for shipping.
6. price
-- Data type: FLOAT
-- Description: Price of the individual product item in the order.
7. freight_value
-- Data type: FLOAT
-- Description: Freight or shipping cost associated with the individual order item.
-- =================================================================================================================================================

Table 7: olist_products_dataset
Objective:
-- Explore the structure, columns, and data types of the olist_products_dataset table.
SQL Query:
-- DESCRIBE olist_products_dataset;
Observation:
-- The olist_products_dataset table contains 9 columns:
1. product_id
-- Data type: VARCHAR(32)
-- Description: Unique identifier assigned to each product.
2. product_category_name
-- Data type: VARCHAR(100)
-- Description: Name of the category to which the product belongs.
3. product_name_length
-- Data type: INT
-- Description: Number of characters contained in the product name.
4. product_description_lenght
-- Data type: INT
-- Description: Number of characters contained in the product description.
5. product_photos_qty
-- Data type: INT
-- Description: Number of photos or images available for the product listing.
6. product_weight_g
-- Data type: INT
-- Description: Weight of the product measured in grams.
7. product_length_cm
-- Data type: INT
-- Description: Length of the product measured in centimeters.
8. product_height_cm
-- Data type: INT
-- Description: Height of the product measured in centimeters.
9. product_width_cm
-- Data type: INT
-- Description: Width of the product measured in centimeters.
-- ===================================================================================================================================================

Table 8: olist_sellers_dataset
Objective:
-- Explore the structure, columns, and data types of the olist_sellers_dataset table.
SQL Query:
-- DESCRIBE olist_sellers_dataset;
Observation:
-- The olist_sellers_dataset table contains 4 columns:
1. seller_id
-- Data type: VARCHAR(32)
-- Description: Unique identifier assigned to each seller registered on the Olist e-commerce platform.
2. seller_zip_code_prefix
-- Data type: INT
-- Description: The first five digits of the seller's ZIP code,indicating the geographic area where the seller is located.
3. seller_city
-- Data type: VARCHAR(32)
-- Description: City where the seller is located.
4. seller_state
-- Data type: CHAR(2)
-- Description: Two-letter abbreviation of the Brazilian state where the seller is located.
-- ================================================================================================================================================

Table 9: product_category_name_translation
Objective:
-- Explore the structure, columns, and data types of the product_category_name_translation table.
SQL Query:
-- DESCRIBE product_category_name_translation;
Observation:
-- The product_category_name_translation table contains 2 columns:
1. product_category_name
-- Data type: VARCHAR(100)
-- Description: Product category name in the original language used in the Olist dataset.
2. product_category_name_english
-- Data type: VARCHAR(255)
-- Description: English translation of the corresponding product category name.
-- ======================================================================================================================================================

General Note on NULL Values
-- The DESCRIBE statement shows that NULL values are allowed in the columns of the tables examined. 
-- However, this does not confirm that NULL values actually exist in the data.
-- The actual presence and number of NULL values will be investigated during the Data Quality Assessment phase.
-- =======================================================================================================================================================

Step 3: Identify Primary Keys, Foreign Keys and Table Relationships
Table 1: olist_customers_dataset
Primary Key Identification
Objective:
-- Identify the column that uniquely identifies each record in the olist_customers_dataset table.
SQL Query:
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM olist_customers_dataset;
 Observation:
-- The olist_customers_dataset table contains 99,441 total records.
-- The customer_id column also contains 99,441 unique values.
-- Since the number of unique customer_id values is equal to the total number of records, every record in the table has a unique customer_id value.
-- Therefore, customer_id is identified as the candidate primary key of the olist_customers_dataset table.
-- The customer_unique_id column is not identified as the primary key because repeated customer_unique_id values were found during the
-- identifier uniqueness assessment in the Data Quality Assessment phase.
-- The customer_unique_id column represents the underlying customer, while customer_id identifies the individual customer record used
-- within the Olist dataset.
 Conclusion:
-- customer_id serves as the primary identifier for records in the olist_customers_dataset table.
-- Each customer record can therefore be uniquely identified using customer_id.


