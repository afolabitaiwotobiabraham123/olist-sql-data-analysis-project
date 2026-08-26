Table 1: olist_customers_dataset
Date and Timestamp Validation
Assessment:
-- Date and timestamp validation is not applicable to the olist_customers_dataset table because the table contains no DATE or DATETIME columns.
Conclusion:
-- No date or timestamp fields were identified in the table;
-- therefore, no date or timestamp validation was required.

Table 2: olist_geolocation_dataset
Date and Timestamp Validation
Assessment:
-- Date and timestamp validation is not applicable to the olist_geolocation_dataset table because the table contains no DATE or DATETIME columns.
Conclusion:
-- No date or timestamp fields were identified in the table;
-- therefore, no date or timestamp validation was required.

Table 3: olist_order_items_dataset
Date and Timestamp Validation
3.1 SHIPPING LIMIT DATE COMPLETENESS ASSESSMENT
Objective:
-- Determine whether shipping_limit_date contains missing timestamp values.
SQL Query:
SELECT
    COUNT(*) AS total_records,
    SUM(shipping_limit_date IS NULL) AS null_shipping_limit_dates
FROM olist_order_items_dataset;
Observation:
-- The query returned 112,650 total records and 0 NULL shipping_limit_date values.
-- This indicates that all order-item records contain a shipping limit timestamp.
Conclusion:
-- shipping_limit_date passes the assessed completeness validation, with no missing timestamp values identified.

3.2 SHIPPING LIMIT DATE RANGE ASSESSMENT
Objective:
-- Determine the earliest and latest observed shipping_limit_date values to assess the overall temporal range of the column.
SQL Query:
SELECT
    MIN(shipping_limit_date) AS earliest_shipping_limit_date,
    MAX(shipping_limit_date) AS latest_shipping_limit_date
FROM olist_order_items_dataset;
Observation:
-- The earliest observed shipping_limit_date was 2016-09-19 00:15:34.
-- The latest observed shipping_limit_date was 2020-04-09 22:35:08.
-- The observed timestamps span multiple calendar years.
Conclusion:
-- shipping_limit_date contains valid DATETIME values across the observed temporal range. Further chronological assessment was
-- performed against the corresponding order purchase timestamps.

3.3 SHIPPING LIMIT DATE CHRONOLOGICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether any shipping_limit_date values occur before the corresponding order purchase timestamp.
SQL Query:
SELECT
    oi.order_id,
    oi.order_item_id,
    o.order_purchase_timestamp,
    oi.shipping_limit_date
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE oi.shipping_limit_date < o.order_purchase_timestamp
ORDER BY oi.shipping_limit_date;
Observation:
-- The query returned 0 rows.
-- This indicates that no shipping_limit_date values were identified as occurring before the corresponding order purchase timestamp.
Conclusion:
-- shipping_limit_date passes the assessed chronological ordering validation, with no shipping-limit timestamps occurring before
-- their corresponding order purchase timestamps.

3.4 ANOMALOUS SHIPPING LIMIT DATE ASSESSMENT
Objective:
-- Identify shipping_limit_date values that occur substantially later than the corresponding order purchase timestamps.
SQL Query:
SELECT
    oi.order_id,
    oi.order_item_id,
    o.order_purchase_timestamp,
    oi.shipping_limit_date,
    TIMESTAMPDIFF(
        DAY,
        o.order_purchase_timestamp,
        oi.shipping_limit_date
    ) AS days_between_purchase_and_shipping_limit
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE YEAR(oi.shipping_limit_date) = 2020
ORDER BY oi.shipping_limit_date;
Observation:
-- The query identified 4 shipping_limit_date records from the year 2020.
-- All four corresponding orders were purchased in 2017.
-- Two records showed a difference of 1,056 days between the order purchase timestamp and the shipping limit timestamp.
-- Two records showed a difference of 1,052 days between the order purchase timestamp and the shipping limit timestamp.
-- These timestamps therefore represent unusually long intervals between order purchase and the assigned shipping limit date.
Conclusion:
-- Four anomalous shipping_limit_date values were identified,
-- occurring approximately 1,052 to 1,056 days after their corresponding order purchase timestamps.
-- These records should be flagged for further investigation or treatment during the data-cleaning stage rather than being
-- automatically treated as valid shipping deadlines.

3.5 OVERALL DATE AND TIMESTAMP VALIDATION
Objective:
-- Summarize the date and timestamp validation findings for olist_order_items_dataset.
Observation:
-- shipping_limit_date contains 112,650 timestamp records with no NULL values.
-- The observed timestamps range from 2016-09-19 00:15:34 to 2020-04-09 22:35:08.
-- No shipping_limit_date values were identified before their corresponding order purchase timestamps.
-- However, 4 shipping_limit_date values were identified in 2020
-- for orders purchased in 2017, with intervals of 1,052 to 1,056 days between purchase and shipping limit.
Conclusion:
-- shipping_limit_date passes the assessed completeness and basic chronological ordering validations.
-- However, 4 anomalous timestamp values were identified due to unusually long intervals between order purchase and shipping limit.
-- These records should be flagged for further investigation or treatment during the data-cleaning stage.

Table 4: olist_order_payments_dataset
-- Date and Timestamp Validation
Assessment:
-- Date and timestamp validation is not applicable to the olist_order_payments_dataset table because the table contains no DATE or DATETIME columns.
Conclusion:
-- No date or timestamp fields were identified in the table;
-- therefore, no date or timestamp validation was required.

Table 5: olist_order_reviews_dataset
Date and Timestamp Validation

5.1 REVIEW TIMESTAMP COMPLETENESS ASSESSMENT
Objective:
-- Determine whether review_creation_date and review_answer_timestamp contain missing timestamp values.
SQL Query:
SELECT
    COUNT(*) AS total_records,
    SUM(review_creation_date IS NULL) AS null_review_creation_dates,
    SUM(review_answer_timestamp IS NULL) AS null_review_answer_timestamps
FROM olist_order_reviews_dataset;
Observation:
-- The query returned 99,223 total review records.
-- Both review_creation_date and review_answer_timestamp returned 0 NULL values.
-- This indicates that no NULL timestamp values were identified in either column.
Conclusion:
-- review_creation_date and review_answer_timestamp pass the assessed NULL-value completeness validation, with no missing timestamp values identified.

5.2 REVIEW TIMESTAMP RANGE ASSESSMENT
Objective:
-- Determine the earliest and latest observed values for review_creation_date and review_answer_timestamp.
SQL Query:
SELECT
    MIN(review_creation_date) AS earliest_review_creation_date,
    MAX(review_creation_date) AS latest_review_creation_date,
    MIN(review_answer_timestamp) AS earliest_review_answer_timestamp,
    MAX(review_answer_timestamp) AS latest_review_answer_timestamp
FROM olist_order_reviews_dataset;
Observation:
-- The earliest value for both review_creation_date and review_answer_timestamp was returned as 0000-00-00 00:00:00.
-- The latest review_creation_date was 2018-08-31 00:00:00.
-- The latest review_answer_timestamp was 2018-10-29 12:27:35.
-- The zero-date values identified by the MIN() function indicate the presence of placeholder or invalid timestamp values.
Conclusion:
-- The timestamp range assessment identified zero-date values requiring further validation before the earliest valid timestamp can be established.

5.3 INVALID ZERO-DATE TIMESTAMP ASSESSMENT
Objective:
-- Determine whether review_creation_date and review_answer_timestamp contain invalid zero-date placeholder values.
SQL Query:
SELECT
    SUM(YEAR(review_creation_date) = 0) AS zero_review_creation_dates,
    SUM(YEAR(review_answer_timestamp) = 0) AS zero_review_answer_timestamps
FROM olist_order_reviews_dataset;
Observation:
-- The query identified 1 zero-date value in review_creation_date and 1 zero-date value in review_answer_timestamp.
-- Both zero-date values belong to the same review record.
Conclusion:
-- One review record contains invalid zero-date placeholder values in both review_creation_date and review_answer_timestamp.

5.4 ZERO-DATE RECORD IDENTIFICATION
Objective:
-- Identify the review record containing the invalid zero-date timestamp values.
SQL Query:
SELECT
    review_id,
    order_id,
    review_creation_date,
    review_answer_timestamp
FROM olist_order_reviews_dataset
WHERE YEAR(review_creation_date) = 0
   OR YEAR(review_answer_timestamp) = 0;
Observation:
-- The query identified one review record:
-- review_id: 636b237e87574ba29654deaba9eb9797
-- order_id: d7361a834a2dd8db2f6f133ce291ab6b
-- Both review_creation_date and review_answer_timestamp were recorded as 0000-00-00 00:00:00.
Conclusion:
-- One review record was identified with invalid zero-date values in both timestamp columns. This record should be flagged for
-- treatment during the data-cleaning stage.

5.5 REVIEW TIMESTAMP CHRONOLOGICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether any valid review answer timestamps occur before their corresponding review creation timestamps.
SQL Query:
SELECT
    review_id,
    order_id,
    review_creation_date,
    review_answer_timestamp
FROM olist_order_reviews_dataset
WHERE YEAR(review_creation_date) <> 0
  AND YEAR(review_answer_timestamp) <> 0
  AND review_answer_timestamp < review_creation_date
ORDER BY review_creation_date;
Observation:
-- The query returned 0 rows.
-- This indicates that no valid review_answer_timestamp values were identified as occurring before their corresponding review_creation_date values.
Conclusion:
-- The valid review timestamps pass the assessed chronological consistency validation, with no cases identified where a review was answered before it was created.
5.6 REVIEW CREATION YEAR DISTRIBUTION ASSESSMENT
Objective:
-- Determine the distribution of valid review creation timestamps across calendar years.
SQL Query:
SELECT
    YEAR(review_creation_date) AS review_creation_year,
    COUNT(*) AS occurrence_count
FROM olist_order_reviews_dataset
WHERE YEAR(review_creation_date) <> 0
GROUP BY YEAR(review_creation_date)
ORDER BY review_creation_year;
Observation:
-- The query returned the following valid review creation years:
-- 2016: 325 records
-- 2017: 42,733 records
-- 2018: 56,164 records
-- No valid review creation timestamps were identified for 2019 or 2020.
Conclusion:
-- Valid review creation timestamps are concentrated within the 2016–2018 period. The absence of 2019 and 2020 values is
-- documented as the observed temporal coverage of the dataset and is not independently classified as an invalid-date issue.

5.7 REVIEW ANSWER YEAR DISTRIBUTION ASSESSMENT
Objective:
-- Determine the distribution of valid review answer timestamps across calendar years.
SQL Query:
SELECT
    YEAR(review_answer_timestamp) AS review_answer_year,
    COUNT(*) AS occurrence_count
FROM olist_order_reviews_dataset
WHERE YEAR(review_answer_timestamp) <> 0
GROUP BY YEAR(review_answer_timestamp)
ORDER BY review_answer_year;
Observation:
-- The query returned the following valid review answer years:
-- 2016: 311 records
-- 2017: 42,068 records
-- 2018: 56,843 records
-- No valid review answer timestamps were identified for 2019 or 2020.
Conclusion:
-- Valid review answer timestamps are concentrated within the 2016–2018 period, consistent with the observed review creation timestamp coverage.

5.8 OVERALL DATE AND TIMESTAMP VALIDATION
Objective:
-- Summarize the date and timestamp validation findings for olist_order_reviews_dataset.
Observation:
-- The table contains 99,223 review records with no NULL values identified in either timestamp column.
-- One review record contains 0000-00-00 00:00:00 in both review_creation_date and review_answer_timestamp.
-- No valid chronological inconsistencies were identified where a review answer timestamp occurred before the corresponding review creation timestamp.
-- Valid review creation and answer timestamps are concentrated within the 2016–2018 period.
Conclusion:
-- The review timestamp columns pass the assessed completeness and chronological consistency validations.
-- However, one review record contains invalid zero-date placeholder values in both timestamp columns and should be flagged for treatment during data cleaning.

TABLE 6: olist_orders_dataset
DATE & TIMESTAMP VALIDATION

6.1 ZERO-DATE VALIDATION
OBJECTIVE: 
-- To identify invalid zero-date values represented as '0000-00-00 00:00:00' in the date and timestamp columns.
SQL QUERY:
   SELECT
       SUM(order_purchase_timestamp = '0000-00-00 00:00:00') AS
           invalid_purchase_dates,
       SUM(order_approved_at = '0000-00-00 00:00:00') AS
           invalid_approval_dates,
       SUM(order_delivered_carrier_date = '0000-00-00 00:00:00') AS
           invalid_carrier_dates,
       SUM(order_delivered_customer_date = '0000-00-00 00:00:00') AS
           invalid_customer_delivery_dates,
       SUM(order_estimated_delivery_date = '0000-00-00 00:00:00') AS
           invalid_estimated_delivery_dates
   FROM olist_orders_dataset;

OBSERVATION:
Zero-date values were identified in:
-- order_approved_at: 160
-- order_delivered_carrier_date: 1,783
-- order_delivered_customer_date: 2,965
No zero-date values were identified in:
-- order_purchase_timestamp
-- order_estimated_delivery_date
-- Further investigation identified 8 orders with an order_status of 'delivered' and a zero order_delivered_customer_date.
-- One of these records also had a zero order_delivered_carrier_date.
CONCLUSION:
-- Zero-date values are present in the dataset and represent missing or invalid timestamps.
-- They should be handled during data cleaning, while considering the order status and stage of the order process.

6.2 PURCHASE → APPROVAL VALIDATION
OBJECTIVE:
-- To determine whether any order was approved before its purchase timestamp.
SQL QUERY:
   SELECT
       order_id,
       order_purchase_timestamp,
       order_approved_at
   FROM olist_orders_dataset
   WHERE YEAR(order_purchase_timestamp) <> 0
     AND YEAR(order_approved_at) <> 0
     AND order_approved_at < order_purchase_timestamp;
OBSERVATION:
-- The query returned 0 records.
CONCLUSION:
-- No chronological inconsistencies were identified between order purchase and order approval timestamps.

6.3 APPROVAL → CARRIER VALIDATION
OBJECTIVE:
-- To identify orders where the carrier delivery timestamp occurred before the order approval timestamp.
SQL QUERY:
   SELECT
       order_id,
       order_status,
       order_purchase_timestamp,
       order_approved_at,
       order_delivered_carrier_date
   FROM olist_orders_dataset
   WHERE YEAR(order_approved_at) <> 0
     AND YEAR(order_delivered_carrier_date) <> 0
     AND order_delivered_carrier_date < order_approved_at
   ORDER BY order_approved_at
   LIMIT 20;
OBSERVATION:
-- The initial count identified 1,359 inconsistent records.
-- A sample of 20 records was reviewed and confirmed that carrier delivery timestamps occurred before approval timestamps, 
-- with differences ranging from minutes to several days.
CONCLUSION:
   The 1,359 records represent chronological inconsistencies
   between approval and carrier delivery timestamps and should
   be flagged during data cleaning.

6.4 CARRIER → CUSTOMER DELIVERY VALIDATION
OBJECTIVE:
-- To identify orders where the customer delivery timestamp occurred before the carrier delivery timestamp.
SQL QUERY:
   SELECT
       order_id,
       order_status,
       order_delivered_carrier_date,
       order_delivered_customer_date
   FROM olist_orders_dataset
   WHERE YEAR(order_delivered_carrier_date) <> 0
     AND YEAR(order_delivered_customer_date) <> 0
     AND order_delivered_customer_date < order_delivered_carrier_date
   ORDER BY order_delivered_carrier_date
   LIMIT 20;
OBSERVATION:
-- The validation identified 23 inconsistent records.
-- Sampled records confirmed that customer delivery timestamps occurred before the corresponding carrier delivery timestamps.
CONCLUSION:
-- The 23 records represent chronological inconsistencies between carrier delivery and customer delivery timestamps and should be flagged during data cleaning.

6.5 PURCHASE → CUSTOMER DELIVERY VALIDATION
OBJECTIVE:
-- To determine whether any customer delivery occurred before the corresponding order purchase timestamp.
SQL QUERY:
   SELECT
       COUNT(*) AS inconsistent_purchase_delivery
   FROM olist_orders_dataset
   WHERE YEAR(order_purchase_timestamp) <> 0
     AND YEAR(order_delivered_customer_date) <> 0
     AND order_delivered_customer_date < order_purchase_timestamp;
OBSERVATION:
-- The query returned 0 records.
CONCLUSION:
-- No chronological inconsistencies were identified between order purchase and customer delivery timestamps.

6.6 ACTUAL VS ESTIMATED DELIVERY VALIDATION
OBJECTIVE:
-- To compare the actual customer delivery date with the estimated delivery date and determine whether orders were delivered early, on time, or late.
SQL QUERY:
   SELECT
       CASE
           WHEN order_delivered_customer_date < order_estimated_delivery_date
               THEN 'early'
           WHEN order_delivered_customer_date = order_estimated_delivery_date
               THEN 'on_time'
           WHEN order_delivered_customer_date > order_estimated_delivery_date
               THEN 'late'
       END AS delivery_performance,
       COUNT(*) AS occurrence_count
   FROM olist_orders_dataset
   WHERE YEAR(order_delivered_customer_date) <> 0
     AND YEAR(order_estimated_delivery_date) <> 0
   GROUP BY delivery_performance
   ORDER BY occurrence_count DESC;
OBSERVATION:
Among orders with valid actual and estimated delivery dates:
-- Early: 88,649
-- Late: 7,827
-- On time: 0
-- A total of 96,476 orders were included in the comparison.
CONCLUSION:
-- Most orders were delivered earlier than their estimated delivery dates, while 7,827 orders were delivered later.
-- No orders were delivered exactly on the estimated delivery date.
OVERALL CONCLUSION:
-- The date and timestamp validation identified zero-date values and chronological inconsistencies in the olist_orders_dataset.
No inconsistencies were found between:
-- Purchase → Approval
-- Purchase → Customer Delivery
Chronological inconsistencies were identified in:
-- Approval → Carrier: 1,359 records
-- Carrier → Customer Delivery: 23 records
Delivery performance analysis showed:
-- 88,649 orders delivered early
-- 7,827 orders delivered late
-- 0 orders delivered exactly on the estimated date
--These findings should be considered during data cleaning before conducting delivery-time and supply-chain performance analysis.

TABLE 7: olist_products_dataset
DATE & TIMESTAMP VALIDATION
OBJECTIVE:
-- To determine whether the olist_products_dataset contains date or timestamp columns requiring date validation.
SQL QUERY:
   DESCRIBE olist_products_dataset;
OBSERVATION:
-- The table contains product attributes and measurements but does not contain any date or timestamp columns.
CONCLUSION:
-- No date or timestamp validation was required for this table.

TABLE 8: olist_sellers_dataset
DATE & TIMESTAMP VALIDATION
OBJECTIVE:
-- To determine whether the olist_sellers_dataset contains date or timestamp columns requiring date validation.
SQL QUERY:
   DESCRIBE olist_sellers_dataset;
OBSERVATION:
-- The table contains seller identification and location information but does not contain any date or timestamp columns.
CONCLUSION:
-- No date or timestamp validation was required for this table.
TABLE 9: product_category_name_translation
DATE & TIMESTAMP VALIDATION
OBJECTIVE:
-- To determine whether the product_category_name_translation table contains date or timestamp columns requiring date validation.
SQL QUERY:
   DESCRIBE product_category_name_translation;
OBSERVATION:
-- The table contains product category names and their English translations but does not contain any date or timestamp columns.
CONCLUSION:
-- No date or timestamp validation was required for this table.
