OLIST E-COMMERCE DATA ANALYSIS
Phase 1: Data Exploration
-- =============================================================================================================================================================
Step 1: Explore Database Tables
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
-- ============================================================================================================================================================
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
General Note on NULL Values
-- The DESCRIBE statement shows that NULL values are allowed in the columns of the tables examined. 
-- However, this does not confirm that NULL values actually exist in the data.
-- The actual presence and number of NULL values will be investigated during the Data Quality Assessment phase.
-- =============================================================================================================================================================

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
-- The customer_unique_id column is not identified as the primary key because repeated customer_unique_id values were observed in the table.
-- The uniqueness of this identifier will be formally assessed during the Data Quality Assessment phase.
-- The customer_unique_id column represents the underlying customer, while customer_id identifies the individual customer record used within the Olist dataset.
Conclusion:
-- customer_id serves as the primary identifier for records in the olist_customers_dataset table.
-- Each customer record can therefore be uniquely identified using customer_id.

Table 2: olist_geolocation_dataset
Primary Key Identification
Objective:
-- Determine whether the olist_geolocation_dataset table contains a column or combination of columns that can uniquely identify each record.
SQL Query 1: 
-- Assess uniqueness of geolocation_zip_code_prefix.
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_prefixes
FROM olist_geolocation_dataset;
Observation:
-- The olist_geolocation_dataset table contains 1,000,163 records, while geolocation_zip_code_prefix contains only 19,015 unique values.
-- Since the number of unique ZIP-code prefixes is substantially lower than the total number of records, 
-- geolocation_zip_code_prefix does not uniquely identify each record.
-- Therefore, geolocation_zip_code_prefix cannot serve as the primary key of the table.
SQL Query 2:
-- Assess whether the combination of all geolocation attributes uniquely identifies each record.
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT CONCAT(
        geolocation_zip_code_prefix, '|',
        geolocation_lat, '|',
        geolocation_lng, '|',
        geolocation_city, '|',
        geolocation_state
    )) AS unique_geolocation_records
FROM olist_geolocation_dataset;
Observation:
-- The table contains 1,000,163 total records, while the combination of geolocation_zip_code_prefix, geolocation_lat, geolocation_lng,
-- geolocation_city, and geolocation_state produces only 720,496 unique combinations.
-- This means that the complete combination of the available geolocation attributes does not uniquely identify every record.
-- Therefore, no unique primary key can be identified from the available columns in the raw olist_geolocation_dataset table.
Conclusion:
-- No primary key was identified for the raw olist_geolocation_dataset table.
-- geolocation_zip_code_prefix cannot serve as a primary key because it is repeated across multiple records.
-- The combination of all five available geolocation attributes also does not uniquely identify every record.
-- The repeated combinations indicate that the selected columns do not form a unique identifier for the table. 
-- Further investigation of duplicate records and identifier uniqueness will be performed during the Data Quality Assessment phase.
-- The table should therefore be treated as a reference dataset without a unique row-level identifier in its raw form.

Table 3: olist_orders_dataset
Primary Key, Foreign Key and Relationship Assessment
3.1 PRIMARY KEY IDENTIFICATION
Objective:
-- Determine whether order_id uniquely identifies each record in the olist_orders_dataset table.
SQL Query:
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM olist_orders_dataset;
Observation:
-- The olist_orders_dataset table contains 99,441 total records and order_id contains 99,441 unique values.
-- Since the number of unique order_id values is equal to the total number of records, each order record has a unique order_id.
-- Therefore, order_id is identified as the candidate primary key of the olist_orders_dataset table.
Conclusion:
-- order_id serves as the primary identifier for records in the olist_orders_dataset table.
-- Each order record can be uniquely identified using order_id.

3.2 FOREIGN KEY IDENTIFICATION AND RELATIONSHIP VALIDATION
Objective:
-- Determine whether customer_id in the olist_orders_dataset table correctly references customer_id in the olist_customers_dataset table.
SQL Query:
SELECT
    COUNT(*) AS unmatched_customer_ids
FROM olist_orders_dataset o
LEFT JOIN olist_customers_dataset c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;
Observation:
-- The query returned 0 unmatched customer IDs.
-- This indicates that every customer_id recorded in the olist_orders_dataset table has a corresponding customer_id in the olist_customers_dataset table.
-- Therefore, customer_id in the olist_orders_dataset table successfully references customer_id in the olist_customers_dataset table.
Relationship:
-- olist_customers_dataset.customer_id
--              ↓
--              ↓ referenced by
--              ↓
-- olist_orders_dataset.customer_id
-- The relationship is one-to-many because one customer can be associated with multiple orders.
Conclusion:
-- customer_id in the olist_orders_dataset table is identified as a foreign key referencing customer_id in the olist_customers_dataset table.
-- The relationship was successfully validated because no unmatched customer_id values were identified.
-- Therefore, the relationship between the customers and orders tables is structurally consistent in the assessed data.

Table 4: olist_order_payments_dataset
Primary Key, Foreign Key and Relationship Assessment
4.1 COMPOSITE PRIMARY KEY IDENTIFICATION
Objective:
-- Determine whether the combination of order_id and payment_sequential uniquely identifies each payment record.
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
-- The query returned zero rows.
-- This indicates that no combination of order_id and payment_sequential occurs more than once in the table.
-- Although order_id can occur multiple times because a single order can have multiple payment records,
-- the addition of payment_sequential distinguishes the individual payment records.
Conclusion:
-- order_id + payment_sequential is identified as the candidate composite primary key of the olist_order_payments_dataset table.
-- order_id alone is not considered the primary key because multiple payment records can belong to the same order.

4.2 FOREIGN KEY IDENTIFICATION AND RELATIONSHIP VALIDATION
Objective:
-- Determine whether order_id in the olist_order_payments_dataset table correctly references order_id in the olist_orders_dataset table.
SQL Query:
SELECT
    COUNT(*) AS unmatched_order_ids
FROM olist_order_payments_dataset p
LEFT JOIN olist_orders_dataset o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

Observation:
-- The query returned 0 unmatched order IDs.
-- This indicates that every order_id recorded in the olist_order_payments_dataset table has a corresponding
-- order_id in the olist_orders_dataset table.
-- Therefore, order_id in the payment table successfully references order_id in the orders table.

Relationship:
-- olist_orders_dataset.order_id
--              ↓
--              ↓ referenced by
--              ↓
-- olist_order_payments_dataset.order_id
-- The relationship is one-to-many because one order can have multiple payment records.

Conclusion:
-- order_id in the olist_order_payments_dataset table is identified as a foreign key referencing order_id in the olist_orders_dataset table.
-- The relationship was successfully validated because no unmatched order_id values were identified.
-- Therefore, the relationship between the orders and payments tables is structurally consistent in the assessed data.

Table 5: olist_order_reviews_dataset
Primary Key, Foreign Key and Relationship Assessment
5.1 CANDIDATE COMPOSITE KEY IDENTIFICATION
Objective:
-- Determine whether the combination of review_id and order_id uniquely identifies review records.
SQL Query:
SELECT
    review_id,
    order_id,
    COUNT(*) AS occurrence_count
FROM olist_order_reviews_dataset
GROUP BY
    review_id,
    order_id
HAVING COUNT(*) > 1;
Observation:
-- The query returned zero rows.
-- This indicates that no review_id + order_id combination occurs more than once in the table.
-- Therefore, the combination of review_id and order_id can uniquely distinguish the records based on the uniqueness assessment performed.
-- review_id alone was not considered unique because repeated review_id values were identified during the Data Quality Assessment phase.
Conclusion:
-- review_id + order_id is identified as a candidate composite identifier for the olist_order_reviews_dataset table.
-- The combination was not found to contain duplicate records during the uniqueness assessment.
5.2 FOREIGN KEY IDENTIFICATION AND RELATIONSHIP VALIDATION
Objective:
-- Determine whether order_id in the olist_order_reviews_dataset table correctly references order_id in the olist_orders_dataset table.
SQL Query:
SELECT
    COUNT(*) AS unmatched_order_ids
FROM olist_order_reviews_dataset r
LEFT JOIN olist_orders_dataset o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;
Observation:
-- The query returned 0 unmatched order IDs.
-- This indicates that every order_id recorded in the olist_order_reviews_dataset table has a corresponding order_id in the olist_orders_dataset table.
-- Therefore, the order_id relationship between the reviews and orders tables is valid in the assessed data.
Relationship:
-- olist_orders_dataset.order_id
--              ↓
--              ↓ referenced by
--              ↓
-- olist_order_reviews_dataset.order_id
Conclusion:
-- order_id in the olist_order_reviews_dataset table is identified as a foreign key relationship referencing order_id in the olist_orders_dataset table.
-- The relationship was successfully validated because no unmatched order_id values were identified.

Table 6: olist_order_items_dataset
Primary Key, Foreign Key and Relationship Assessment
6.1 CANDIDATE COMPOSITE KEY IDENTIFICATION
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
-- The query returned zero rows.
-- This indicates that no order_id + order_item_id combination occurs more than once in the table.
-- order_id alone is not unique because one order can contain multiple items.
-- Therefore, the combination of order_id and order_item_id can uniquely distinguish individual items within an order.
Conclusion:
-- order_id + order_item_id is identified as a candidate composite identifier for the olist_order_items_dataset table.
-- order_id alone cannot serve as the primary key because multiple items can belong to the same order.

6.2 FOREIGN KEY: order_id
Objective:
-- Determine whether order_id in the order-items table correctly references order_id in the orders table.
SQL Query:
SELECT
    COUNT(*) AS unmatched_order_ids
FROM olist_order_items_dataset i
LEFT JOIN olist_orders_dataset o
    ON i.order_id = o.order_id
WHERE o.order_id IS NULL;
Observation:
-- The query returned 0 unmatched order IDs.
-- This indicates that every order_id in the olist_order_items_dataset table has a corresponding order_id in the olist_orders_dataset table.
Conclusion:
-- order_id in the order-items table is identified as a foreign key referencing order_id in the orders table.
-- The relationship was successfully validated because no unmatched order_id values were identified.

6.3 FOREIGN KEY: product_id
Objective:
-- Determine whether product_id in the order-items table correctly references product_id in the products table.
SQL Query:
SELECT
    COUNT(*) AS unmatched_product_ids
FROM olist_order_items_dataset i
LEFT JOIN olist_products_dataset p
    ON i.product_id = p.product_id
WHERE p.product_id IS NULL;
Observation:
-- The query returned 0 unmatched product IDs.
-- This indicates that every product_id recorded in the olist_order_items_dataset table has a corresponding product_id in the olist_products_dataset table.
Conclusion:
-- product_id in the order-items table is identified as a foreign key referencing product_id in the products table.
-- The relationship was successfully validated because no unmatched product_id values were identified.

6.4 FOREIGN KEY: seller_id
Objective:
-- Determine whether seller_id in the order-items table correctly references seller_id in the sellers table.
SQL Query:
SELECT
    COUNT(*) AS unmatched_seller_ids
FROM olist_order_items_dataset i
LEFT JOIN olist_sellers_dataset s
    ON i.seller_id = s.seller_id
WHERE s.seller_id IS NULL;
Observation:
-- The query returned 0 unmatched seller IDs.
-- This indicates that every seller_id recorded in the olist_order_items_dataset table has a corresponding seller_id in the olist_sellers_dataset table.
Conclusion:
-- seller_id in the order-items table is identified as a foreign key referencing seller_id in the sellers table.
-- The relationship was successfully validated because no unmatched seller_id values were identified.

6.5 TABLE 6 OVERALL RELATIONSHIP SUMMARY
-- The olist_order_items_dataset table connects orders,products and sellers at the individual order-item level.
-- Relationships:
-- olist_orders_dataset.order_id
--              ↓
-- olist_order_items_dataset.order_id
--
-- olist_products_dataset.product_id
--              ↓
-- olist_order_items_dataset.product_id
--
-- olist_sellers_dataset.seller_id
--              ↓
-- olist_order_items_dataset.seller_id
--
-- All three foreign-key relationships were successfully validated because zero unmatched values were identified.
-- The order-item records therefore maintain valid references to the corresponding orders, products and sellers in the assessed dataset.

Table 7: olist_products_dataset
Primary Key, Foreign Key and Relationship Assessment
7.1 CANDIDATE PRIMARY KEY IDENTIFICATION
Objective:
-- Determine whether product_id uniquely identifies each product record in the olist_products_dataset table.
SQL Query:
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM olist_products_dataset;
Observation:
-- The query returned 65,902 total rows and 32,951 unique product_id values.
-- This indicates that product_id is not unique across all records in the raw olist_products_dataset table.
-- A primary key must uniquely identify every record.
-- Since duplicate product_id values exist, product_id cannot be confirmed as a primary key at the raw-table level.
Conclusion:
-- product_id is identified as the natural identifier for products but cannot be confirmed as the primary key of
-- the raw olist_products_dataset table because duplicate product_id values were identified.
-- The duplicate records should be considered during subsequent data cleaning and transformation.
7.2 COMPLETENESS ASSESSMENT: product_id
Objective:
-- Determine whether the candidate product identifier contains NULL or blank values.
SQL Query:
SELECT
    SUM(product_id IS NULL) AS null_product_ids,
    SUM(TRIM(product_id) = '') AS blank_product_ids
FROM olist_products_dataset;
Observation:
-- The query returned:
-- null_product_ids = 0
-- blank_product_ids = 0
-- This indicates that no NULL or blank product_id values were identified in the table.
-- Therefore, the product_id field is complete, although it is not unique.
Conclusion:
-- product_id satisfies the completeness requirement expected of an identifier because no NULL or blank values were found.
-- However, it does not satisfy the uniqueness requirement because duplicate product_id values exist.
-- Therefore, product_id cannot be confirmed as a primary key in the raw table.
7.3 COMPLETENESS ASSESSMENT: product_category_name — NULL VALUES
Objective:
-- Determine whether product_category_name contains SQL NULL values.
SQL Query:
SELECT
    COUNT(*) AS null_category_count
FROM olist_products_dataset
WHERE product_category_name IS NULL;
Observation:
-- The query returned 0 NULL category values.
-- This indicates that no SQL NULL values were identified in the product_category_name column.
Conclusion:
-- product_category_name does not contain SQL NULL values.
-- However, the absence of NULL values does not necessarily mean that all category information is populated, since
-- empty strings may also represent missing values.
7.4 COMPLETENESS ASSESSMENT: product_category_name — EMPTY VALUES
Objective:
-- Determine whether product_category_name contains empty string values that may represent missing category information.
SQL Query:
SELECT
    COUNT(*) AS empty_category_count
FROM olist_products_dataset
WHERE product_category_name = '';
Observation:
-- The query returned 1,220 empty category values.
-- This indicates that 1,220 product records contain an empty product_category_name value rather than a SQL NULL.
Conclusion:
-- product_category_name contains 1,220 missing category values represented as empty strings.
-- These records should be treated as missing category information during subsequent data cleaning and analysis.
7.5 COMPLETENESS ASSESSMENT: product_category_name — BLANK/WHITESPACE VALUES
Objective:
-- Confirm whether the empty category values identified above are empty or whitespace-only values.
SQL Query:
SELECT
    COUNT(*) AS blank_or_whitespace_categories
FROM olist_products_dataset
WHERE product_category_name IS NOT NULL
  AND TRIM(product_category_name) = '';
Observation:
-- The query returned 1,220 blank or whitespace-only category values.
-- This confirms that the 1,220 missing category values are empty or whitespace-only values.
-- No additional whitespace-only values were identified beyond the 1,220 empty values.
Conclusion:
-- 1,220 product records contain missing category information represented by empty or whitespace-only values.
-- These values should be treated as missing data rather than valid product categories.
7.6 FOREIGN KEY: product_id
Objective:
-- Determine whether product_id in the order-items table correctly references product_id in the products table.
SQL Query:
SELECT
    COUNT(*) AS unmatched_product_ids
FROM olist_order_items_dataset oi
LEFT JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;
Observation:
-- The query returned 0 unmatched product IDs.
-- This indicates that every product_id recorded in the olist_order_items_dataset table has a corresponding product_id in the olist_products_dataset table.
Conclusion:
-- product_id in the olist_order_items_dataset table is identified as a foreign key/reference column to product_id in the olist_products_dataset table.
-- The relationship was successfully validated because no unmatched product_id values were identified.
-- The relationship represents a one-to-many relationship: one product can appear in multiple order-item records.

7.7 RELATIONSHIP: product_category_name
Objective:
-- Determine whether product_category_name in the products table has a corresponding category in the product_category_name_translation lookup table.
SQL Query:
SELECT
    COUNT(*) AS unmatched_category_names
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;
Observation:
-- The query returned 1,246 unmatched product records.
-- This initially indicates that 1,246 product records contain category values that do not have corresponding records in
-- the product_category_name_translation table.
-- Further investigation was performed to determine whether these unmatched values represent missing translations or missing category values.
Conclusion:
-- The initial referential-integrity assessment identified 1,246 unmatched product records.
-- Further investigation was required because an unmatched category value does not necessarily represent a missing
-- translation; it may also represent an empty category value.

7.8 INVESTIGATION OF UNMATCHED CATEGORY VALUES
Objective:
-- Identify the specific category values responsible for the 1,246 unmatched product records and determine their frequency.
SQL Query:
SELECT
    CONCAT('[', p.product_category_name, ']') AS category_check,
    LENGTH(p.product_category_name) AS category_length,
    COUNT(*) AS occurrence_count
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL
GROUP BY p.product_category_name
ORDER BY occurrence_count DESC;
Observation:
-- The query returned three unmatched values:
-- Empty category value ('')                                1,220
-- portateis_cozinha_e_preparadores_de_alimentos               20
-- pc_gamer                                                     6
-- The total number of unmatched records is:
-- 1,220 + 20 + 6 = 1,246
-- Therefore, the 1,246 unmatched records consist of both missing category values and category names without corresponding translation records.
Conclusion:
-- The 1,246 unmatched records were broken down into:
-- 1,220 records with empty/blank category values.
-- 20 records belonging to the portateis_cozinha_e_preparadores_de_alimentos category.
-- 6 records belonging to the pc_gamer category.
-- Therefore, only 26 records belong to actual category names that lack corresponding translation records.

7.9 DISTINCT UNMATCHED CATEGORY VALUE ASSESSMENT
Objective:
-- Determine the number of distinct unmatched values in the
-- product_category_name field.
SQL Query:
SELECT
    COUNT(DISTINCT p.product_category_name) AS unmatched_category_count
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;
Observation:
-- The query returned 3 distinct unmatched values.
-- These values consist of:
-- 1. Empty string ('')
-- 2. portateis_cozinha_e_preparadores_de_alimentos
-- 3. pc_gamer
-- The empty string is not an actual product category.
Conclusion:
-- There are 2 actual product category names without
-- corresponding translation records:
-- portateis_cozinha_e_preparadores_de_alimentos
-- pc_gamer
-- The third unmatched value identified by the query is an empty category value and should be treated as missing data.

7.10 TABLE 7 OVERALL RELATIONSHIP SUMMARY
-- The olist_products_dataset table contains product-level information and serves as a reference point for products included in customer orders.
-- Candidate identifier:
-- olist_products_dataset.product_id
-- product_id was identified as the natural identifier for products but was not confirmed as a primary key because 
-- duplicate product_id values exist in the raw table.

-- Relationship 1:
-- olist_products_dataset.product_id
--              ↓
-- olist_order_items_dataset.product_id
-- Every product_id referenced in the order-items table was successfully matched to the products table.
-- Unmatched product IDs = 0
-- Therefore, the product_id relationship demonstrated referential integrity in the assessed dataset.

-- Relationship 2:
-- olist_products_dataset.product_category_name
--              ↓
-- product_category_name_translation.product_category_name
-- The initial relationship assessment identified 1,246 unmatched product records.
-- Further investigation showed:
-- 1,220 records → empty/blank category values
-- 20 records    → portateis_cozinha_e_preparadores_de_alimentos
-- 6 records     → pc_gamer
-- Therefore, 26 records belong to actual category names without corresponding translations.
-- Overall, the products table contains a complete but non-unique product_id field. Its relationship with the
-- order-items table was successfully validated, while the category relationship contains missing category values and incomplete translation mappings.

Table 8: olist_sellers_dataset
Primary Key, Foreign Key and Relationship Assessment
8.1 CANDIDATE PRIMARY KEY IDENTIFICATION
Objective:
-- Determine whether seller_id uniquely identifies each seller record in the olist_sellers_dataset table.
SQL Query:
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_seller_ids
FROM olist_sellers_dataset;
Observation:
-- The query returned:
-- total_rows = 3,095
-- unique_seller_ids = 3,095
-- The number of unique seller_id values is equal to the total number of records in the table.
-- This indicates that no duplicate seller_id values were identified.
Conclusion:
-- seller_id is identified as a candidate primary key because it uniquely identifies each seller record in the olist_sellers_dataset table.
-- A completeness assessment is required to confirm that the candidate key also contains no NULL or blank values.
8.2 PRIMARY KEY COMPLETENESS ASSESSMENT
Objective:
-- Determine whether seller_id contains NULL or blank values that would prevent it from functioning as a primary key.
SQL Query:
SELECT
    SUM(seller_id IS NULL) AS null_seller_ids,
    SUM(TRIM(seller_id) = '') AS blank_seller_ids
FROM olist_sellers_dataset;
Observation:
-- The query returned:
-- null_seller_ids = 0
-- blank_seller_ids = 0
-- This indicates that no NULL or blank seller_id values were identified in the sellers table.
Conclusion:
-- seller_id satisfies both fundamental requirements of a primary key:
-- 1. It is unique across all 3,095 seller records.
-- 2. It contains no NULL or blank values.
-- Therefore, seller_id is confirmed as the primary key of the olist_sellers_dataset table.

8.3 FOREIGN KEY: seller_id
Objective:
-- Determine whether seller_id in the order-items table correctly references seller_id in the sellers table.
SQL Query:
SELECT
    COUNT(*) AS unmatched_seller_ids
FROM olist_order_items_dataset i
LEFT JOIN olist_sellers_dataset s
    ON i.seller_id = s.seller_id
WHERE s.seller_id IS NULL;
Observation:
-- The query returned:
-- unmatched_seller_ids = 0
-- This indicates that every seller_id recorded in the olist_order_items_dataset table has a corresponding seller_id in the olist_sellers_dataset table.
Conclusion:
-- seller_id in the olist_order_items_dataset table is identified as a foreign key referencing seller_id in the olist_sellers_dataset table.
-- The relationship was successfully validated because no unmatched seller_id values were identified.
-- The relationship represents a one-to-many relationship, where one seller can be associated with multiple order-item records.

8.4 FOREIGN KEY COMPLETENESS ASSESSMENT: seller_id
Objective:
-- Determine whether the seller_id foreign-key column in the order-items table contains NULL or blank values.
SQL Query:
SELECT
    SUM(seller_id IS NULL) AS null_seller_ids,
    SUM(TRIM(seller_id) = '') AS blank_seller_ids
FROM olist_order_items_dataset;
Observation:
-- The query returned:
-- null_seller_ids = 0
-- blank_seller_ids = 0
-- This indicates that no NULL or blank seller_id values were identified in the olist_order_items_dataset table.
-- Therefore, every order-item record contains a populated seller_id value.
Conclusion:
-- seller_id in the olist_order_items_dataset table is complete, with no NULL or blank values identified.
-- Combined with the referential-integrity assessment that returned zero unmatched seller IDs, the seller_id relationship
-- between the order-items and sellers tables is fully supported by the assessed data.
8.5 TABLE 8 OVERALL RELATIONSHIP SUMMARY
-- The olist_sellers_dataset table contains seller-level information and serves as the reference table for sellers associated with order items.
-- Primary Key:
-- olist_sellers_dataset.seller_id
-- seller_id uniquely identifies all 3,095 seller records and contains no NULL or blank values.
-- Therefore, seller_id is confirmed as the primary key of the olist_sellers_dataset table.
-- Foreign Key Relationship:
-- olist_sellers_dataset.seller_id
--              ↓
-- olist_order_items_dataset.seller_id
-- seller_id in the olist_order_items_dataset table acts as a foreign key referencing seller_id in the sellers table.
-- Referential integrity assessment:
-- unmatched seller IDs = 0
-- Foreign-key completeness assessment:
-- NULL seller IDs = 0
-- Blank seller IDs = 0
-- The relationship therefore contains no identified missing or invalid seller references.
-- The relationship is one-to-many:
-- One seller
--      ↓
-- Multiple order-item records
-- This is because a seller can provide products that appear in multiple order-item records across different orders.
Overall conclusion:
-- The olist_sellers_dataset table has a well-defined primary key in seller_id. The key is unique and complete across all 3,095 seller records.
-- Its relationship with olist_order_items_dataset was also successfully validated. Every seller referenced by the
-- order-items table exists in the sellers table, and no NULL, blank, or unmatched seller_id values were identified.
-- Therefore, the assessed seller relationship demonstrates strong referential integrity within the dataset.
