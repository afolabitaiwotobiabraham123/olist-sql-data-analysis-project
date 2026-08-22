Table 1: olist_customers_dataset
Data Type Assessment
1.1 CUSTOMER_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of customer_id are appropriate for storing customer identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(customer_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(customer_id)) AS maximum_id_length
FROM olist_customers_dataset;
Observation:
-- The query returned a minimum and maximum customer_id length of 32 characters.
-- This indicates that all customer_id values contain exactly 32 characters.
Conclusion:
-- Since customer_id contains alphanumeric identifier values rather than numerical measures, VARCHAR(32) is an appropriate data type for the column.

1.2 CUSTOMER_UNIQUE_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of customer_unique_id are appropriate for storing unique customer identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(customer_unique_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(customer_unique_id)) AS maximum_id_length
FROM olist_customers_dataset;
Observation:
-- The query returned a minimum and maximum customer_unique_id length of 32 characters.
-- This indicates that all customer_unique_id values contain exactly 32 characters.
Conclusion:
-- Since customer_unique_id contains alphanumeric identifier values rather than numerical measures, VARCHAR(32) is an appropriate data type for the column.

1.3 CUSTOMER ZIP CODE PREFIX DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of customer_zip_code_prefix is appropriate for storing customer ZIP code prefix values.
SQL Query:
SELECT
    MIN(customer_zip_code_prefix) AS minimum_zip_code,
    MAX(customer_zip_code_prefix) AS maximum_zip_code,
    MAX(CHAR_LENGTH(CAST(customer_zip_code_prefix AS CHAR))) AS maximum_digit_length
FROM olist_customers_dataset;
Observation:
-- The query returned a minimum value of 1003 and a maximum value of 99990.
-- The maximum observed digit length is 5 characters.
-- The values are stored as numeric ZIP code prefixes in the dataset.
Conclusion:
-- The INT data type is appropriate for the representation of customer_zip_code_prefix used in this dataset.

1.4 CUSTOMER CITY DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of customer_city are sufficient for storing customer city names.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(customer_city)) AS minimum_city_length,
    MAX(CHAR_LENGTH(customer_city)) AS maximum_city_length
FROM olist_customers_dataset;
Observation:
-- The query returned a minimum city name length of 3 characters and a maximum length of 32 characters.
-- The longest observed customer city name therefore contains 32 characters, while the column is defined as VARCHAR(100).
Conclusion:
-- The VARCHAR(100) data type provides sufficient capacity for the observed customer city values and is appropriate for customer_city.

1.5 CUSTOMER STATE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of customer_state are appropriate for storing Brazilian state and federal district abbreviations.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(customer_state)) AS minimum_state_length,
    MAX(CHAR_LENGTH(customer_state)) AS maximum_state_length
FROM olist_customers_dataset;
Observation:
-- The query returned a minimum and maximum customer_state length of 2 characters.
-- This indicates that all observed customer_state values contain exactly 2 characters.
Conclusion:
-- The CHAR(2) data type is appropriate for storing the two-character Brazilian state and federal district abbreviations.

1.6 OVERALL DATA TYPE ASSESSMENT
Objective:
-- Summarize the data type assessment findings for the olist_customers_dataset table.
Observation:
-- The assessment confirmed that the assigned data types provide appropriate representations and sufficient capacity for the 
-- observed values across all five columns.
-- customer_id is stored as VARCHAR(32), with all observed values containing exactly 32 characters.
-- customer_unique_id is stored as VARCHAR(32), with all observed values containing exactly 32 characters.
-- customer_zip_code_prefix is stored as INT, with observed values ranging from 1003 to 99990 and a maximum digit length of 5.
-- customer_city is stored as VARCHAR(100), with observed values ranging from 3 to 32 characters.
-- customer_state is stored as CHAR(2), with all observed values containing exactly 2 characters.
Conclusion:
-- The assigned data types in the olist_customers_dataset tablenare appropriate for the nature and observed characteristicsmof the stored data.
-- No data type inconsistencies were identified during the assessment.
-- Therefore, no data type treatment or conversion is required for the assessed columns at this stage of the Data Quality Assessment.

Table 2: olist_geolocation_dataset
Data Type Assessment
2.1 GEOLOCATION ZIP CODE PREFIX DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of geolocation_zip_code_prefix is appropriate for storing geolocation ZIP code prefix values.
SQL Query:
SELECT
    MIN(geolocation_zip_code_prefix) AS minimum_zip_code,
    MAX(geolocation_zip_code_prefix) AS maximum_zip_code,
    MAX(CHAR_LENGTH(CAST(geolocation_zip_code_prefix AS CHAR))) AS maximum_digit_length
FROM olist_geolocation_dataset;
Observation:
-- The query returned a minimum value of 1001 and a maximum value of 99990.
-- The maximum observed digit length is 5 characters.
-- The values are stored as numeric ZIP code prefixes in the dataset.
Conclusion:
-- The INT data type is appropriate for the representation of geolocation_zip_code_prefix used in this dataset.

2.2 GEOLOCATION LATITUDE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and precision of geolocation_lat are appropriate for storing latitude coordinates.
SQL Query:
SELECT
    MIN(geolocation_lat) AS minimum_latitude,
    MAX(geolocation_lat) AS maximum_latitude
FROM olist_geolocation_dataset;
Observation:
-- The query returned a minimum latitude of -36.60537441070610 and a maximum latitude of 45.06593318269697.
-- The latitude values contain substantial decimal precision.
-- The column is defined as DECIMAL(18,14), providing 14 digits after the decimal point.
Conclusion:
-- The DECIMAL(18,14) data type provides sufficient precision and scale for storing latitude coordinates and is appropriate for geolocation_lat.

2.3 GEOLOCATION LONGITUDE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and precision of geolocation_lng are appropriate for storing longitude coordinates.
SQL Query:
SELECT
    MIN(geolocation_lng) AS minimum_longitude,
    MAX(geolocation_lng) AS maximum_longitude
FROM olist_geolocation_dataset;
Observation:
-- The query returned a minimum longitude of -101.46676644931476 and a maximum longitude of 121.10539381057764.
-- The longitude values contain substantial decimal precision.
-- The column is defined as DECIMAL(18,14), providing 14 digits after the decimal point.
Conclusion:
-- The DECIMAL(18,14) data type provides sufficient precision and scale for storing longitude coordinates and is appropriate for geolocation_lng.

2.4 GEOLOCATION CITY DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of geolocation_city are sufficient for storing city names.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(geolocation_city)) AS minimum_city_length,
    MAX(CHAR_LENGTH(geolocation_city)) AS maximum_city_length
FROM olist_geolocation_dataset;
Observation:
-- The query returned a minimum city name length of 2 characters and a maximum length of 32 characters.
-- The longest observed city value therefore contains exactly 32 characters, while the column is defined as VARCHAR(32).
Conclusion:
-- The VARCHAR(32) data type provides sufficient capacity for the observed geolocation city values and is appropriate for geolocation_city.

2.5 GEOLOCATION STATE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of geolocation_state are appropriate for storing Brazilian state and federal district abbreviations.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(geolocation_state)) AS minimum_state_length,
    MAX(CHAR_LENGTH(geolocation_state)) AS maximum_state_length
FROM olist_geolocation_dataset;
Observation:
-- The query returned a minimum and maximum state value length of 2 characters.
-- This indicates that all observed geolocation_state values contain exactly 2 characters.
Conclusion:
-- The CHAR(2) data type is appropriate for storing the two-character Brazilian state and federal district abbreviations.

2.6 OVERALL DATA TYPE ASSESSMENT
Objective:
-- Summarize the data type assessment findings for the olist_geolocation_dataset table.
Observation:
-- The assessment confirmed that the assigned data types provide appropriate representations and sufficient capacity for the
-- observed values across all five columns.
-- geolocation_zip_code_prefix is stored as INT, with observed values ranging from 1001 to 99990 and a maximum digit length of 5.
-- geolocation_lat is stored as DECIMAL(18,14), providing sufficient precision for latitude coordinates.
-- geolocation_lng is stored as DECIMAL(18,14), providing sufficient precision for longitude coordinates.
-- geolocation_city is stored as VARCHAR(32), with observed values ranging from 2 to 32 characters.
-- geolocation_state is stored as CHAR(2), with all observed values containing exactly 2 characters.
Conclusion:
-- The assigned data types in the olist_geolocation_dataset table are appropriate for the nature and observed characteristics of the stored data.
-- No data type inconsistencies were identified during the assessment.
-- Therefore, no data type treatment or conversion is required for the assessed columns at this stage of the Data Quality Assessment.

Table 3: olist_order_items_dataset
Data Type Assessment

3.1 ORDER_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of order_id are appropriate for storing order identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(order_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(order_id)) AS maximum_id_length
FROM olist_order_items_dataset;
Observation:
-- The query returned a minimum and maximum order_id length of 32 characters.
-- This indicates that all order_id values contain exactly 32 characters.
Conclusion:
-- Since order_id contains alphanumeric identifier values rather than numerical measures, VARCHAR(32) is an appropriate data type for the column.

3.2 ORDER_ITEM_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of order_item_id is appropriate for storing order item sequence values.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(order_item_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(order_item_id)) AS maximum_id_length
FROM olist_order_items_dataset;
Observation:
-- The query returned a minimum order_item_id length of 1 character and a maximum length of 2 characters.
-- This indicates that order_item_id contains short numeric sequence values.
Conclusion:
-- Although VARCHAR(32) can store the observed values, INT would be a more appropriate data type because order_item_id represents
-- a numeric item sequence rather than an alphanumeric identifier.

3.3 PRODUCT_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of product_id are appropriate for storing product identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(product_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(product_id)) AS maximum_id_length
FROM olist_order_items_dataset;
Observation:
-- The query returned a minimum and maximum product_id length of 32 characters.
-- This indicates that all product_id values contain exactly 32 characters.
Conclusion:
-- Since product_id contains alphanumeric identifier values rather than numerical measures, VARCHAR(32) is an appropriate data type for the column.

3.4 SELLER_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of seller_id are appropriate for storing seller identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(seller_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(seller_id)) AS maximum_id_length
FROM olist_order_items_dataset;
Observation:
-- The query returned a minimum and maximum seller_id length of 32 characters.
-- This indicates that all seller_id values contain exactly 32 characters.
Conclusion:
-- Since seller_id contains alphanumeric identifier values rather than numerical measures, VARCHAR(32) is an appropriate data type for the column.

3.5 SHIPPING_LIMIT_DATE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of shipping_limit_date is appropriate for storing shipping deadline date-time values.
SQL Query:
SELECT
    MIN(shipping_limit_date) AS earliest_shipping_limit,
    MAX(shipping_limit_date) AS latest_shipping_limit
FROM olist_order_items_dataset;
Observation:
-- The query returned an earliest shipping limit date of 2016-09-19 00:15:34 and a latest shipping limit date of 2020-04-09 22:35:08.
-- The values contain both date and time components.
Conclusion:
-- The DATETIME data type is appropriate for storing shipping_limit_date because both date and time information are required for shipping deadline analysis.

3.6 PRICE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of price is appropriate for storing monetary values.
SQL Query:
SELECT
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    MAX(CHAR_LENGTH(CAST(price AS CHAR))) AS maximum_value_length
FROM olist_order_items_dataset;
Observation:
-- The query returned a minimum price of 0.85 and a maximum price of 6735.
-- The price column contains monetary values requiring decimal precision.
-- The column is currently defined as FLOAT.
Conclusion:
-- Although FLOAT can represent the observed price values,
-- DECIMAL(10,2) would be a more appropriate data type for monetary values because it provides exact decimal precision
-- and reduces potential floating-point rounding issues during financial calculations.

3.7 FREIGHT_VALUE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of freight_value is appropriate for storing monetary freight values.
SQL Query:
SELECT
    MIN(freight_value) AS minimum_freight_value,
    MAX(freight_value) AS maximum_freight_value,
    MAX(CHAR_LENGTH(CAST(freight_value AS CHAR))) AS maximum_value_length
FROM olist_order_items_dataset;
Observation:
-- The query returned a minimum freight value of 0 and a maximum freight value of 409.68.
-- The freight_value column contains monetary values requiring decimal precision.
-- The column is currently defined as FLOAT.
Conclusion:
-- Although FLOAT can represent the observed freight values, 
-- DECIMAL(10,2) would be a more appropriate data type for monetary values because it provides exact decimal precision
-- and reduces potential floating-point rounding issues during financial calculations.

3.8 OVERALL DATA TYPE ASSESSMENT
Objective:
-- Summarize the data type assessment findings for the olist_order_items_dataset table.
Observation:
-- The assessment confirmed that VARCHAR(32) is appropriate for order_id, product_id, and seller_id because these columns
-- contain 32-character alphanumeric identifiers.
-- order_item_id contains numeric item sequence values with lengths ranging from 1 to 2 characters. Although VARCHAR(32)
-- can store these values, INT would provide a more appropriate representation of the numeric sequence.
-- shipping_limit_date contains date-time values, making DATETIME an appropriate data type.
-- price and freight_value contain monetary values and are currently stored as FLOAT. Although FLOAT can represent the
-- observed values, DECIMAL(10,2) would provide a more suitable representation for monetary calculations because it provides exact decimal precision.
Conclusion:
-- The olist_order_items_dataset table is generally structured with appropriate data types.
-- However, potential data type improvements were identified for order_item_id, price, and freight_value.
-- order_item_id could be converted from VARCHAR(32) to INT, while price and freight_value could be converted from FLOAT
-- to DECIMAL(10,2) during the data cleaning and transformation stage.
-- These recommendations should be considered during data preparation before performing financial and operational analysis.

Table 4: olist_order_payments_dataset
Data Type Assessment
4.1 ORDER_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of order_id are appropriate for storing order identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(order_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(order_id)) AS maximum_id_length
FROM olist_order_payments_dataset;
Observation:
-- The query returned a minimum and maximum order_id length of 32 characters.
-- This indicates that all order_id values contain exactly 32 characters.
Conclusion:
-- Since order_id contains alphanumeric identifier values rather
-- than numerical measures, VARCHAR(32) is an appropriate data
-- type for the column.

4.2 PAYMENT_SEQUENTIAL DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of payment_sequential is appropriate for storing payment sequence values.
SQL Query:
SELECT
    MIN(payment_sequential) AS minimum_payment_sequence,
    MAX(payment_sequential) AS maximum_payment_sequence
FROM olist_order_payments_dataset;
Observation:
-- The query returned a minimum payment sequence of 1 and a maximum payment sequence of 29.
-- The values are whole-number sequence values.
Conclusion:
-- The INT data type is appropriate for payment_sequential because the column represents the sequential position of a payment associated with an order.

4.3 PAYMENT_TYPE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character capacity of payment_type are appropriate for storing payment categories.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(payment_type)) AS minimum_type_length,
    MAX(CHAR_LENGTH(payment_type)) AS maximum_type_length
FROM olist_order_payments_dataset;
Observation:
-- The query returned a minimum payment type length of 6 characters and a maximum length of 11 characters.
-- All observed payment type values therefore fit within the VARCHAR(32) capacity of the column.
Conclusion:
-- The VARCHAR(32) data type provides sufficient capacity for the observed payment type values and is appropriate for storing payment categories.

4.4 PAYMENT_INSTALLMENTS DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of payment_installments is appropriate for storing the number of payment installments.
SQL Query:
SELECT
    MIN(payment_installments) AS minimum_installments,
    MAX(payment_installments) AS maximum_installments
FROM olist_order_payments_dataset;
Observation:
-- The query returned a minimum value of 0 and a maximum value of 24.
-- The values are whole-number quantities representing payment installment counts.
Conclusion:
-- The INT data type is appropriate for payment_installments because the column represents a whole-number quantity.
-- The presence and validity of zero installment values should be assessed separately under the Invalid Value Assessment.

4.5 PAYMENT_VALUE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of payment_value is appropriate for storing monetary payment values.
SQL Query:
SELECT
    MIN(payment_value) AS minimum_payment_value,
    MAX(payment_value) AS maximum_payment_value
FROM olist_order_payments_dataset;
Observation:
-- The query returned a minimum payment value of 0 and a maximum payment value of 13,664.10.
-- The payment_value column contains monetary values and is currently defined as FLOAT.
Conclusion:
-- Although FLOAT can represent the observed payment values, DECIMAL(10,2) would be a more appropriate data type for
-- monetary data because it provides exact decimal precision and reduces potential floating-point rounding issues during financial calculations.

4.6 OVERALL DATA TYPE ASSESSMENT
Objective:
-- Summarize the data type assessment findings for the olist_order_payments_dataset table.
Observation:
-- The assessment confirmed that VARCHAR(32) is appropriate for order_id because the column contains 32-character alphanumeric order identifiers.
-- payment_sequential is stored as INT and contains whole-number sequence values ranging from 1 to 29. The INT data type is appropriate for this column.
-- payment_type is stored as VARCHAR(32), with observed values ranging from 6 to 11 characters. The assigned data type
-- provides sufficient capacity for the observed categories.
-- payment_installments is stored as INT and contains whole-number values ranging from 0 to 24. INT is appropriate for representing installment quantities.
-- payment_value is currently stored as FLOAT and contains monetary values ranging from 0 to 13,664.10. DECIMAL(10,2)
-- would provide a more appropriate representation for monetary calculations.
Conclusion:
-- The olist_order_payments_dataset table is generally structured with appropriate data types.
-- However, a potential data type improvement was identified for payment_value. The current FLOAT representation can be used,
-- but DECIMAL(10,2) would be preferable for financial calculations because it provides exact decimal precision.
-- The existing data type of payment_value should therefore be considered for conversion during the data cleaning and transformation stage.
-- No other data type changes are required based on the observed values at this stage of the Data Quality Assessment.

Table 5: olist_order_reviews_dataset
Data Type Assessment
5.1 REVIEW_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of review_id are appropriate for storing review identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(review_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(review_id)) AS maximum_id_length
FROM olist_order_reviews_dataset;
Observation:
-- The query returned a minimum and maximum review_id length of 32 characters.
-- This indicates that all review_id values contain exactly 32 characters.
Conclusion:
-- Since review_id contains alphanumeric identifier values rather than numerical measures, VARCHAR(32) is an appropriate data type for the column.

5.2 ORDER_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of order_id are appropriate for storing order identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(order_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(order_id)) AS maximum_id_length
FROM olist_order_reviews_dataset;
Observation:
-- The query returned a minimum and maximum order_id length of 32 characters.
-- This indicates that all order_id values contain exactly 32 characters.
Conclusion:
-- Since order_id contains alphanumeric identifier values rather than numerical measures, VARCHAR(32) is an appropriate data type for the column.

5.3 REVIEW_SCORE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of review_score is appropriate for storing customer review ratings.
SQL Query:
SELECT
    MIN(review_score) AS minimum_review_score,
    MAX(review_score) AS maximum_review_score
FROM olist_order_reviews_dataset;
Observation:
-- The query returned a minimum review score of 1 and a maximum review score of 5.
-- The values are whole-number rating values.
Conclusion:
-- The INT data type is appropriate for review_score because the column contains whole-number customer review ratings.
-- The validity of the observed rating range should be assessed separately under the Invalid Value Assessment.

5.4 REVIEW_COMMENT_TITLE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character capacity of review_comment_title are sufficient for storing review comment titles.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(review_comment_title)) AS minimum_title_length,
    MAX(CHAR_LENGTH(review_comment_title)) AS maximum_title_length
FROM olist_order_reviews_dataset;
Observation:
-- The query returned a minimum title length of 0 characters and a maximum length of 26 characters.
-- The longest observed review comment title therefore contains 26 characters, while the column is defined as VARCHAR(255).
Conclusion:
-- The VARCHAR(255) data type provides sufficient capacity for the observed review comment title values and is appropriate for the column.
-- Empty title values should be assessed separately under the appropriate data quality assessment.

5.5 REVIEW_COMMENT_MESSAGE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character capacity of review_comment_message are sufficient for storing review comment messages.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(review_comment_message)) AS minimum_message_length,
    MAX(CHAR_LENGTH(review_comment_message)) AS maximum_message_length
FROM olist_order_reviews_dataset;
Observation:
-- The query returned a minimum message length of 0 characters and a maximum length of 208 characters.
-- The longest observed review comment message therefore contains 208 characters, while the column is defined as VARCHAR(255).
Conclusion:
-- The VARCHAR(255) data type provides sufficient capacity for the observed review comment message values and is appropriate for the column.
-- Empty message values should be assessed separately under the appropriate data quality assessment.

5.6 REVIEW_CREATION_DATE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of review_creation_date is appropriate for storing review creation timestamps.
SQL Query:
SELECT
    MIN(review_creation_date) AS earliest_review_creation,
    MAX(review_creation_date) AS latest_review_creation
FROM olist_order_reviews_dataset;
Observation:
-- The query returned an earliest value of 0000-00-00 00:00:00 and a latest value of 2018-08-31 00:00:00.
-- The column contains date and time information and is currently defined as DATETIME.
-- The zero timestamp represents an invalid date value rather than an inappropriate data type.
Conclusion:
-- The DATETIME data type is appropriate for storing review_creation_date because the column represents review creation timestamps.
-- The zero timestamp 0000-00-00 00:00:00 should be addressed separately under the Invalid Value Assessment.

5.7 REVIEW_ANSWER_TIMESTAMP DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of review_answer_timestamp is appropriate for storing review response timestamps.
SQL Query:
SELECT
    MIN(review_answer_timestamp) AS earliest_review_answer,
    MAX(review_answer_timestamp) AS latest_review_answer
FROM olist_order_reviews_dataset;
Observation:
-- The query returned an earliest value of 0000-00-00 00:00:00 and a latest value of 2018-10-29 12:27:35.
-- The column contains date and time information and is currently defined as DATETIME.
-- The zero timestamp represents an invalid date value rather than an inappropriate data type.
Conclusion:
-- The DATETIME data type is appropriate for storing review_answer_timestamp because the column represents review response timestamps.
-- The zero timestamp 0000-00-00 00:00:00 should be addressed separately under the Invalid Value Assessment.

5.8 OVERALL DATA TYPE ASSESSMENT
Objective:
-- Summarize the data type assessment findings for the olist_order_reviews_dataset table.
Observation:
-- The assessment confirmed that VARCHAR(32) is appropriate for review_id and order_id because both columns contain 32-character alphanumeric identifiers.
-- review_score is stored as INT and contains whole-number rating values ranging from 1 to 5. INT is appropriate for representing the review scores.
-- review_comment_title is stored as VARCHAR(255), with observed values ranging from 0 to 26 characters. The assigned capacity is sufficient.
-- review_comment_message is stored as VARCHAR(255), with observed values ranging from 0 to 208 characters. The assigned capacity is sufficient.
-- review_creation_date and review_answer_timestamp are stored as DATETIME, which is appropriate because both columns represent date-time information.
-- Zero timestamps were observed in both date-time columns.
-- These represent invalid date values and do not indicate a data type inconsistency.
Conclusion:
-- The assigned data types in the olist_order_reviews_dataset table are appropriate for the nature and observed characteristics of the stored data.
-- No data type inconsistencies were identified during the assessment.
-- The zero timestamps identified in review_creation_date and review_answer_timestamp should be handled separately during
-- Invalid Value Assessment and Date & Timestamp Validation.
-- Therefore, no data type treatment or conversion is required for the assessed columns at this stage of the Data Quality Assessment.

Table 6: olist_orders_dataset
Data Type Assessment
6.1 ORDER_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of order_id are appropriate for storing order identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(order_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(order_id)) AS maximum_id_length
FROM olist_orders_dataset;
Observation:
-- The query returned a minimum and maximum order_id length of 32 characters.
-- This indicates that all order_id values contain exactly 32 characters.
Conclusion:
-- Since order_id contains alphanumeric identifier values rather than numerical measures, VARCHAR(32) is an appropriate data type for the column.

6.2 CUSTOMER_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of customer_id are appropriate for storing customer identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(customer_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(customer_id)) AS maximum_id_length
FROM olist_orders_dataset;
Observation:
-- The query returned a minimum and maximum customer_id length of 32 characters.
-- This indicates that all customer_id values contain exactly 32 characters.
Conclusion:
-- Since customer_id contains alphanumeric identifier values rather than numerical measures, VARCHAR(32) is an appropriate data type for the column.

6.3 ORDER_STATUS DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character capacity of order_status are appropriate for storing order status categories.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(order_status)) AS minimum_status_length,
    MAX(CHAR_LENGTH(order_status)) AS maximum_status_length
FROM olist_orders_dataset;
Observation:
-- The query returned a minimum order status length of 7 characters and a maximum length of 11 characters.
-- The longest observed order status therefore contains 11 characters, while the column is defined as VARCHAR(20).
Conclusion:
-- The VARCHAR(20) data type provides sufficient capacity for the observed order status values and is appropriate for storing order status categories.

6.4 ORDER_PURCHASE_TIMESTAMP DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of order_purchase_timestamp is appropriate for storing order purchase timestamps.
SQL Query:
SELECT
    MIN(order_purchase_timestamp) AS earliest_purchase_timestamp,
    MAX(order_purchase_timestamp) AS latest_purchase_timestamp
FROM olist_orders_dataset;
Observation:
-- The query returned an earliest purchase timestamp of 2016-09-04 21:15:19 and a latest purchase timestamp of 2018-10-17 17:30:18.
-- The column contains both date and time information and is currently defined as DATETIME.
Conclusion:
-- The DATETIME data type is appropriate for storing order_purchase_timestamp because both date and time information are required.
6.5 ORDER_APPROVED_AT DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of order_approved_at is appropriate for storing order approval timestamps.
SQL Query:
SELECT
    MIN(order_approved_at) AS earliest_approval_timestamp,
    MAX(order_approved_at) AS latest_approval_timestamp
FROM olist_orders_dataset;
Observation:
-- The query returned an earliest value of 0000-00-00 00:00:00 and a latest value of 2018-09-03 17:40:06.
-- The column contains date and time information and is currently defined as DATETIME.
-- The zero timestamp represents an invalid date value rather than an inappropriate data type.
Conclusion:
-- The DATETIME data type is appropriate for storing order_approved_at because the column represents orderapproval timestamps.
-- The zero timestamp 0000-00-00 00:00:00 should be addressed separately under the Invalid Value Assessment and Date & Timestamp Validation.

6.6 ORDER_DELIVERED_CARRIER_DATE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of order_delivered_carrier_date is appropriate for storing carrier delivery timestamps.
SQL Query:
SELECT
    MIN(order_delivered_carrier_date) AS earliest_carrier_delivery,
    MAX(order_delivered_carrier_date) AS latest_carrier_delivery
FROM olist_orders_dataset;
Observation:
-- The query returned an earliest value of 0000-00-00 00:00:00 and a latest value of 2018-09-11 19:48:28.
-- The column contains date and time information and is currently defined as DATETIME.
-- The zero timestamp represents an invalid date value rather than an inappropriate data type.
Conclusion:
-- The DATETIME data type is appropriate for storing order_delivered_carrier_date because the column represents carrier delivery timestamps.
-- The zero timestamp 0000-00-00 00:00:00 should be addressed separately under the Invalid Value Assessment and Date & Timestamp Validation.

6.7 ORDER_DELIVERED_CUSTOMER_DATE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of order_delivered_customer_date is appropriate for storing customer delivery timestamps.
SQL Query:
SELECT
    MIN(order_delivered_customer_date) AS earliest_customer_delivery,
    MAX(order_delivered_customer_date) AS latest_customer_delivery
FROM olist_orders_dataset;
Observation:
-- The query returned an earliest value of 0000-00-00 00:00:00 and a latest value of 2018-10-17 13:22:46.
-- The column contains date and time information and is currently defined as DATETIME.
-- The zero timestamp represents an invalid date value rather than an inappropriate data type.
Conclusion:
-- The DATETIME data type is appropriate for storing order_delivered_customer_date because the column represents customer delivery timestamps.
-- The zero timestamp 0000-00-00 00:00:00 should be addressed separately under the Invalid Value Assessment and Date & Timestamp Validation.

6.8 ORDER_ESTIMATED_DELIVERY_DATE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of order_estimated_delivery_date is appropriate for storing estimated delivery timestamps.
SQL Query:
SELECT
    MIN(order_estimated_delivery_date) AS earliest_estimated_delivery,
    MAX(order_estimated_delivery_date) AS latest_estimated_delivery
FROM olist_orders_dataset;
Observation:
-- The query returned an earliest estimated delivery timestamp of 2016-09-30 00:00:00 and a latest timestamp of 2018-11-12 00:00:00.
-- The column contains both date and time information and is currently defined as DATETIME.
Conclusion:
-- The DATETIME data type is appropriate for storing order_estimated_delivery_date because the column represents estimated delivery date and time information.

6.9 OVERALL DATA TYPE ASSESSMENT
Objective:
-- Summarize the data type assessment findings for the olist_orders_dataset table.
bservation:
-- The assessment confirmed that VARCHAR(32) is appropriate for order_id and customer_id because both columns contain 32-character alphanumeric identifiers.
-- order_status is stored as VARCHAR(20), with observed values ranging from 7 to 11 characters. The assigned capacity is
-- sufficient for the observed order status categories.
-- order_purchase_timestamp is stored as DATETIME and contains valid date-time values ranging from 2016-09-04 21:15:19 to 2018-10-17 17:30:18.
-- order_approved_at, order_delivered_carrier_date and order_delivered_customer_date are also stored as DATETIME,
-- which is appropriate because they represent date-time information.
-- order_estimated_delivery_date is stored as DATETIME and contains date-time values ranging from 2016-09-30 00:00:00 to 2018-11-12 00:00:00.
-- Zero timestamps were observed in some delivery and approval timestamp columns. These represent invalid date values and do not indicate inappropriate data types.
Conclusion:
-- The assigned data types in the olist_orders_dataset table are appropriate for the nature and observed characteristics of the stored data.
-- No data type inconsistencies were identified during the assessment.
-- The zero timestamps identified in order_approved_at, order_delivered_carrier_date and order_delivered_customer_date should be handled separately
-- under the Invalid Value Assessment and Date & Timestamp Validation.
-- Therefore, no data type conversion is required for the assessed columns at this stage of the Data Quality Assessment.

Table 7: olist_products_dataset
Data Type Assessment
7.1 PRODUCT_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of product_id are appropriate for storing product identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(product_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(product_id)) AS maximum_id_length
FROM olist_products_dataset;
Observation:
-- The query returned a minimum and maximum product_id length of 32 characters.
-- This indicates that all product_id values contain exactly 32 characters.
Conclusion:
-- Since product_id contains alphanumeric identifier values rather than numerical measures, VARCHAR(32) is an appropriate data type for the column.

7.2 PRODUCT_CATEGORY_NAME DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character capacity of product_category_name are appropriate for storing product category names.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(product_category_name)) AS minimum_category_length,
    MAX(CHAR_LENGTH(product_category_name)) AS maximum_category_length
FROM olist_products_dataset;
Observation:
-- The query returned a minimum category length of 0 characters and a maximum length of 46 characters.
-- The longest observed product category value therefore contains 46 characters, while the column is defined as VARCHAR(100).
Conclusion:
-- The VARCHAR(100) data type provides sufficient capacity for the observed product category values and is appropriate for storing product category names.
-- Empty category values should be assessed separately under the Invalid Value Assessment.

7.3 PRODUCT_NAME_LENGTH DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of product_name_length is appropriate for storing product name length values.
SQL Query:
SELECT
    MIN(product_name_length) AS minimum_name_length,
    MAX(product_name_length) AS maximum_name_length
FROM olist_products_dataset;
Observation:
-- The query returned a minimum product name length of 0 and a maximum length of 76.
-- The values are whole-number character counts.
Conclusion:
-- The INT data type is appropriate for storing product name length values because the column contains whole-number measurements.
-- Zero values should be assessed separately under the Invalid Value Assessment.

7.4 PRODUCT_DESCRIPTION_LENGHT DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of product_description_lenght is appropriate for storing product description length values.
SQL Query:
SELECT
    MIN(product_description_lenght) AS minimum_description_length,
    MAX(product_description_lenght) AS maximum_description_length
FROM olist_products_dataset;
Observation:
-- The query returned a minimum product description length of 0 and a maximum length of 3,992.
-- The values are whole-number character counts.
Conclusion:
-- The INT data type is appropriate for storing product description length values because the column contains whole-number measurements.
-- Zero values should be assessed separately under the Invalid Value Assessment.

7.5 PRODUCT_PHOTOS_QTY DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of product_photos_qty is appropriate for storing product photo quantities.
SQL Query:
SELECT
    MIN(product_photos_qty) AS minimum_photo_quantity,
    MAX(product_photos_qty) AS maximum_photo_quantity
FROM olist_products_dataset;
Observation:
-- The query returned a minimum product photo quantity of 0 and a maximum quantity of 20.
-- The values are whole-number quantities.
Conclusion:
-- The INT data type is appropriate for storing product photo quantities because the column represents a whole-numbercount.
-- Zero values should be assessed separately under the Invalid Value Assessment.

7.6 PRODUCT_WEIGHT_G DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of product_weight_g is appropriate for storing product weight measurements in grams.
SQL Query:
SELECT
    MIN(product_weight_g) AS minimum_weight_g,
    MAX(product_weight_g) AS maximum_weight_g
FROM olist_products_dataset;
Observation:
-- The query returned a minimum product weight of 0 grams and a maximum weight of 40,425 grams.
-- The values are whole-number measurements in grams.
Conclusion:
-- The INT data type is appropriate for storing product weight measurements because the observed values are whole numbers.
-- Zero weight values should be assessed separately under the Invalid Value Assessment because they may represent invalid or incomplete product measurements.

7.7 PRODUCT_LENGTH_CM DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of product_length_cm is appropriate for storing product length measurements in centimeters.
SQL Query:
SELECT
    MIN(product_length_cm) AS minimum_length_cm,
    MAX(product_length_cm) AS maximum_length_cm
FROM olist_products_dataset;
Observation:
-- The query returned a minimum product length of 0 centimeters and a maximum length of 105 centimeters.
-- The values are whole-number measurements.
Conclusion:
-- The INT data type is appropriate for storing product length measurements because the observed values are whole numbers.
-- Zero values should be assessed separately under the Invalid Value Assessment because they may represent invalid or incomplete product dimensions.

7.8 PRODUCT_HEIGHT_CM DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of product_height_cm is appropriate for storing product height measurements in centimeters.
SQL Query:
SELECT
    MIN(product_height_cm) AS minimum_height_cm,
    MAX(product_height_cm) AS maximum_height_cm
FROM olist_products_dataset;
Observation:
-- The query returned a minimum product height of 0 centimeters and a maximum height of 105 centimeters.
-- The values are whole-number measurements.
Conclusion:
-- The INT data type is appropriate for storing product height
-- measurements because the observed values are whole numbers.
-- Zero values should be assessed separately under the Invalid Value Assessment because they may represent invalid or incomplete product dimensions.

7.9 PRODUCT_WIDTH_CM DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of product_width_cm is appropriate for storing product width measurements in centimeters.
SQL Query:
SELECT
    MIN(product_width_cm) AS minimum_width_cm,
    MAX(product_width_cm) AS maximum_width_cm
FROM olist_products_dataset;
Observation:
-- The query returned a minimum product width of 0 centimeters and a maximum width of 118 centimeters.
-- The values are whole-number measurements.
Conclusion:
-- The INT data type is appropriate for storing product width measurements because the observed values are whole numbers.
-- Zero values should be assessed separately under the Invalid Value Assessment because they may represent invalid or incomplete product dimensions.

7.10 OVERALL DATA TYPE ASSESSMENT
Objective:
-- Summarize the data type assessment findings for the olist_products_dataset table.
Observation:
-- The assessment confirmed that VARCHAR(32) is appropriate for product_id because the column contains 32-character alphanumeric product identifiers.
-- product_category_name is stored as VARCHAR(100), with observed values ranging from 0 to 46 characters.
--The assigned capacity is sufficient for the observed category values.
-- product_name_length and product_description_lenght are stored as INT and contain whole-number character counts. 
-- The INT data type is appropriate for both columns.
-- product_photos_qty is stored as INT and contains whole-number photo quantities ranging from 0 to 20. INT is appropriatefor representing this count.
-- product_weight_g is stored as INT and contains whole-number weight measurements ranging from 0 to 40,425 grams. 
-- INT is appropriate for the observed values.
-- product_length_cm, product_height_cm and product_width_cm are stored as INT and contain whole-number dimensional measurements. 
-- INT is appropriate for the observed values.
-- Zero values were observed in several numeric columns.
-- These represent value-quality findings rather than data type inconsistencies and should be handled separately under the Invalid Value Assessment.
Conclusion:
-- The assigned data types in the olist_products_dataset table are appropriate for the nature and observed characteristics of the stored data.
-- No data type inconsistencies were identified during the assessment.
-- The zero values identified in several product attributes should be addressed separately under the Invalid Value Assessment.
-- Therefore, no data type conversion is required for the assessed columns at this stage of the Data Quality Assessment.

Table 8: olist_sellers_dataset
Data Type Assessment
8.1 SELLER_ID DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of seller_id are appropriate for storing seller identifiers.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(seller_id)) AS minimum_id_length,
    MAX(CHAR_LENGTH(seller_id)) AS maximum_id_length
FROM olist_sellers_dataset;
Observation:
-- The query returned a minimum and maximum seller_id length of 32 characters.
-- This indicates that all seller_id values contain exactly 32 characters.
Conclusion:
-- Since seller_id contains alphanumeric identifier values rather than numerical measures, VARCHAR(32) is an appropriate data type for the column.

8.2 SELLER_ZIP_CODE_PREFIX DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type of seller_zip_code_prefix is appropriate for storing seller ZIP code prefix values.
SQL Query:
SELECT
    MIN(seller_zip_code_prefix) AS minimum_zip_code,
    MAX(seller_zip_code_prefix) AS maximum_zip_code
FROM olist_sellers_dataset;
Observation:
-- The query returned a minimum ZIP code prefix of 1001 and a maximum value of 99730.
-- The observed values are whole-number numeric values.
Conclusion:
-- The INT data type is appropriate for storing the observed seller ZIP code prefix values.
-- However, ZIP code prefixes can potentially contain leading zeros. 
-- This should be considered if such values are identified during further data quality assessment.

8.3 SELLER_CITY DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character capacity of seller_city are appropriate for storing seller city names.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(seller_city)) AS minimum_city_length,
    MAX(CHAR_LENGTH(seller_city)) AS maximum_city_length
FROM olist_sellers_dataset;
Observation:
-- The query returned a minimum city name length of 2 characters and a maximum length of 32 characters.
-- The longest observed seller city value therefore contains exactly 32 characters, which matches the defined capacity.
Conclusion:
-- The VARCHAR(32) data type provides sufficient capacity for the observed seller city values and is appropriate for storing seller city names.

8.4 SELLER_STATE DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character length of seller_state are appropriate for storing seller state codes.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(seller_state)) AS minimum_state_length,
    MAX(CHAR_LENGTH(seller_state)) AS maximum_state_length
FROM olist_sellers_dataset;
Observation:
-- The query returned a minimum and maximum state code length of 2 characters.
-- This indicates that all seller_state values contain exactly 2 characters.
Conclusion:
-- The CHAR(2) data type is appropriate for storing seller_state values because the column contains two-character Brazilian state codes.

8.5 OVERALL DATA TYPE ASSESSMENT
Objective:
-- Summarize the data type assessment findings for the olist_sellers_dataset table.
Observation:
-- The assessment confirmed that VARCHAR(32) is appropriate for seller_id because the column contains 32-character alphanumeric seller identifiers.
-- seller_zip_code_prefix is stored as INT and contains whole-number values ranging from 1,001 to 99,730. 
-- The INT data type is appropriate for the observed values.
-- seller_city is stored as VARCHAR(32), with observed values ranging from 2 to 32 characters. 
-- The assigned capacity is sufficient for the observed city names.
-- seller_state is stored as CHAR(2), with all observed values containing exactly two characters. CHAR(2) is appropriate for storing the state codes.
Conclusion:
-- The assigned data types in the olist_sellers_dataset table are appropriate for the nature and observed characteristics of the stored data.
-- No data type inconsistencies were identified during the assessment.
-- No data type conversion is required for the assessed columns at this stage of the Data Quality Assessment.
-- The potential significance of leading zeros in seller_zip_code_prefix should be considered separately if such values are identified during further data quality
-- assessment.

Table 9: product_category_name_translation
Data Type Assessment
9.1 PRODUCT_CATEGORY_NAME DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character capacity of product_category_name are appropriate for storing product category names.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(product_category_name)) AS minimum_category_length,
    MAX(CHAR_LENGTH(product_category_name)) AS maximum_category_length
FROM product_category_name_translation;
Observation:
-- The query returned a minimum product category name length of 3 characters and a maximum length of 46 characters.
-- The longest observed category name therefore contains 46 characters, while the column is defined as VARCHAR(100).
Conclusion:
-- The VARCHAR(100) data type provides sufficient capacity for the observed product category names and is appropriate for storing the values.

9.2 PRODUCT_CATEGORY_NAME_ENGLISH DATA TYPE ASSESSMENT
Objective:
-- Assess whether the assigned data type and character capacity of product_category_name_english are appropriate for storing English product category names.
SQL Query:
SELECT
    MIN(CHAR_LENGTH(product_category_name_english)) AS minimum_english_category_length,
    MAX(CHAR_LENGTH(product_category_name_english)) AS maximum_english_category_length
FROM product_category_name_translation;
Observation:
-- The query returned a minimum English product category name length of 4 characters and a maximum length of 40 characters.
-- The longest observed English category name therefore contains 40 characters, while the column is defined as VARCHAR(255).
Conclusion:
-- The VARCHAR(255) data type provides sufficient capacity for the observed English product category names and is appropriate for storing the values.

9.3 OVERALL DATA TYPE ASSESSMENT
Objective:
-- Summarize the data type assessment findings for the product_category_name_translation table.
Observation:
-- The assessment confirmed that product_category_name is stored as VARCHAR(100), with observed values ranging from 3 to 46 characters. 
-- The assigned capacity is sufficient for the observed product category names.
-- product_category_name_english is stored as VARCHAR(255), with observed values ranging from 4 to 40 characters.
-- The assigned capacity is sufficient for the observed English product category names.
Conclusion:
-- The assigned data types in the product_category_name_translation table are appropriate for the nature and observed characteristics of the stored data.
-- No data type inconsistencies were identified during the assessment.
-- No data type conversion is required for either column at this stage of the Data Quality Assessment.

