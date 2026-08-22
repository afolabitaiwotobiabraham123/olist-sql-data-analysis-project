Invalid Value Assessment
Table 1: olist_customers_dataset
1.1 INVALID VALUE ASSESSMENT: customer_zip_code_prefix — RANGE INSPECTION
Objective:
-- Determine the minimum and maximum values of customer_zip_code_prefix to identify any obvious values outside the expected numerical structure 
-- of Brazilian ZIP code prefixes.
SQL Query:
SELECT
    MIN(customer_zip_code_prefix) AS minimum_zip_prefix,
    MAX(customer_zip_code_prefix) AS maximum_zip_prefix
FROM olist_customers_dataset;
Observation:
-- The query returned:
-- minimum_zip_prefix = 1,003
-- maximum_zip_prefix = 99,990
-- The observed values fall within the expected five-digit numerical structure.
-- No obviously abnormal minimum or maximum value was identified during the range inspection.
Conclusion:
-- No obvious range violation was identified in customer_zip_code_prefix based on the minimum and maximum values.
-- However, a range inspection alone does not confirm that every individual ZIP prefix is valid. A direct range validation was therefore performed.

1.2 INVALID VALUE ASSESSMENT: customer_zip_code_prefix — RANGE VALIDATION
Objective:
-- Identify customer_zip_code_prefix values that fall outside the expected five-digit numerical range.
SQL Query:
SELECT
    COUNT(*) AS invalid_zip_prefixes
FROM olist_customers_dataset
WHERE customer_zip_code_prefix < 0
   OR customer_zip_code_prefix > 99999;
Observation:
-- The query returned 0 invalid ZIP prefixes.
-- This indicates that no customer_zip_code_prefix values were identified below 0 or above 99,999.
Conclusion:
-- No numerical range violations were identified in customer_zip_code_prefix.
-- All assessed ZIP prefix values fall within the defined five-digit numerical range.

1.3 INVALID VALUE ASSESSMENT: customer_state
Objective:
-- Identify distinct customer_state values and determine whether any values fall outside the expected Brazilian state and Federal District abbreviations.
SQL Query:
SELECT DISTINCT
    customer_state
FROM olist_customers_dataset
ORDER BY customer_state;
Observation:
-- The query returned 27 distinct state codes:
-- AC, AL, AM, AP, BA, CE, DF, ES, GO, MA, MG, MS, MT,
-- PA, PB, PE, PI, PR, RJ, RN, RO, RR, RS, SC, SE, SP, TO
-- These correspond to the 26 Brazilian states and the Federal District (DF).
-- No unexpected state codes were identified.
Conclusion:
-- No invalid customer_state values were identified.
-- All 27 distinct values correspond to valid Brazilian state or Federal District abbreviations.

1.4 INVALID VALUE ASSESSMENT: customer_city — NUMERIC-ONLY VALUES
Objective:
-- Identify customer_city values that contain only numeric characters and may therefore represent malformed city names.
SQL Query:
SELECT
    customer_city,
    COUNT(*) AS occurrence_count
FROM olist_customers_dataset
WHERE customer_city REGEXP '^[0-9]+$'
GROUP BY customer_city
ORDER BY occurrence_count DESC;
Observation:
-- The query returned no rows.
-- This indicates that no customer_city values containing only numeric characters were identified.
Conclusion:
-- No numeric-only customer_city values were identified.
-- Therefore, no obvious numeric-format violations were detected in the customer_city field based on this assessment.

1.5 INVALID VALUE ASSESSMENT: customer_city — MALFORMED VALUES
Objective:
-- Identify customer_city values that contain no alphabetic characters and may therefore represent malformed city names.
SQL Query:
SELECT
    customer_city,
    COUNT(*) AS occurrence_count
FROM olist_customers_dataset
WHERE customer_city REGEXP '^[^a-zA-ZÀ-ÿ]+$'
GROUP BY customer_city
ORDER BY occurrence_count DESC;
Observation:
-- The query returned no rows.
-- This indicates that no customer_city values containing only numbers, symbols, or other non-alphabetic characters were identified.
Conclusion:
-- No obvious malformed customer_city values were identified based on the assessed character-format rule.
-- The city values therefore showed no detected violations of the applied character-format validation.

1.6 TABLE 1 OVERALL INVALID VALUE ASSESSMENT SUMMARY
The following invalid-value assessments were performed on
-- olist_customers_dataset:
-- 1. customer_zip_code_prefix
--    Minimum value = 1,003
--    Maximum value = 99,990
--    Invalid values outside the defined range = 0
--    No numerical range violations were identified.
-- 2. customer_state
--    27 distinct state codes were identified.
--    All correspond to valid Brazilian states or the Federal District.
--    No invalid state codes were identified.
-- 3. customer_city
--    Numeric-only city values = 0
--    Malformed non-alphabetic city values = 0
--    No obvious malformed city values were identified
--    based on the applied validation rules.
-- Overall conclusion:
-- No obvious invalid values were identified in the assessed customer attributes of olist_customers_dataset.
-- customer_zip_code_prefix showed no numerical range violations, customer_state contained only recognized Brazilian state and Federal District codes, and no
-- obviously malformed customer_city values were identified.
-- These findings indicate that the assessed customer attributes contain no detected invalid values based on the defined validation rules.


Table 2: olist_geolocation_dataset
Invalid Value Assessment
2.1 INVALID VALUE ASSESSMENT: geolocation_zip_code_prefix — RANGE INSPECTION
Objective:
-- Determine the minimum and maximum values of geolocation_zip_code_prefix to identify any obvious values outside the expected numerical structure of Brazilian
-- ZIP code prefixes.
SQL Query:
SELECT
    MIN(geolocation_zip_code_prefix) AS minimum_zip_prefix,
    MAX(geolocation_zip_code_prefix) AS maximum_zip_prefix
FROM olist_geolocation_dataset;
Observation:
-- The query returned:
-- minimum_zip_prefix = 1,001
-- maximum_zip_prefix = 99,990
-- The observed values fall within the expected five-digit numerical structure.
-- No obviously abnormal minimum or maximum value was identified during the range inspection.
Conclusion:
-- No obvious range violation was identified in geolocation_zip_code_prefix based on the minimum and maximum values.
-- However, a range inspection alone does not confirm that every individual ZIP prefix is valid. A direct range validation was therefore performed.

2.2 INVALID VALUE ASSESSMENT: geolocation_zip_code_prefix — RANGE VALIDATION
Objective:
-- Identify geolocation_zip_code_prefix values that fall outside the expected five-digit numerical range.
SQL Query:
SELECT
    COUNT(*) AS invalid_zip_prefixes
FROM olist_geolocation_dataset
WHERE geolocation_zip_code_prefix < 0
   OR geolocation_zip_code_prefix > 99999;
Observation:
-- The query returned 0 invalid ZIP prefixes.
-- This indicates that no geolocation_zip_code_prefix values were identified below 0 or above 99,999.
Conclusion:
-- No numerical range violations were identified in geolocation_zip_code_prefix.
-- All assessed ZIP prefix values fall within the defined five-digit numerical range.

2.3 INVALID VALUE ASSESSMENT: geolocation_lat — RANGE VALIDATION
Objective:
-- Determine whether geolocation_lat contains values outside the mathematically valid latitude range of -90 to +90 degrees.
SQL Query:
SELECT
    COUNT(*) AS invalid_latitudes
FROM olist_geolocation_dataset
WHERE geolocation_lat < -90
   OR geolocation_lat > 90;
Observation:
-- The query returned 0 invalid latitudes.
-- This indicates that no geolocation_lat values were found below -90 degrees or above +90 degrees.
 Conclusion:
-- No numerical range violations were identified in geolocation_lat.
-- All assessed latitude values fall within the valid geographic range of -90 to +90 degrees.

2.4 INVALID VALUE ASSESSMENT: geolocation_lng — RANGE VALIDATION
Objective:
-- Determine whether geolocation_lng contains values outside the mathematically valid longitude range of -180 to +180 degrees.
SQL Query:
SELECT
    COUNT(*) AS invalid_longitudes
FROM olist_geolocation_dataset
WHERE geolocation_lng < -180
   OR geolocation_lng > 180;
Observation:
-- The query returned 0 invalid longitudes.
-- This indicates that no geolocation_lng values were found below -180 degrees or above +180 degrees.
Conclusion:
-- No numerical range violations were identified in geolocation_lng.
-- All assessed longitude values fall within the valid geographic range of -180 to +180 degrees.
2.5 INVALID VALUE ASSESSMENT: geolocation_state
Objective:
-- Identify the distinct geolocation_state values and determine whether any values fall outside the expected Brazilian state and Federal District abbreviations.
SQL Query:
SELECT DISTINCT
    geolocation_state
FROM olist_geolocation_dataset
ORDER BY geolocation_state;
Observation:
-- The query returned 27 distinct state codes:
-- AC, AL, AM, AP, BA, CE, DF, ES, GO, MA, MG, MS, MT,
-- PA, PB, PE, PI, PR, RJ, RN, RO, RR, RS, SC, SE, SP, TO
-- These correspond to the 26 Brazilian states and the Federal District (DF).
-- No unexpected state codes were identified.
Conclusion:
-- No invalid geolocation_state values were identified.
-- All 27 distinct values correspond to valid Brazilian state or Federal District abbreviations.

2.6 INVALID VALUE ASSESSMENT: geolocation_city — NUMERIC-ONLY VALUES
Objective:
-- Identify geolocation_city values that contain only numeric characters and may therefore represent malformed city names.
SQL Query:
SELECT
    geolocation_city,
    COUNT(*) AS occurrence_count
FROM olist_geolocation_dataset
WHERE geolocation_city REGEXP '^[0-9]+$'
GROUP BY geolocation_city
ORDER BY occurrence_count DESC;
Observation:
-- The query returned no rows.
-- This indicates that no geolocation_city values containing only numeric characters were identified.
Conclusion:
-- No numeric-only geolocation_city values were identified.
-- Therefore, no obvious numeric-format violations were detected in the geolocation_city field based on this assessment.

2.7 INVALID VALUE ASSESSMENT: geolocation_city — MALFORMED VALUES
Objective:
-- Identify geolocation_city values that contain no alphabetic characters and may therefore represent malformed city names.
SQL Query:
SELECT
    geolocation_city,
    COUNT(*) AS occurrence_count
FROM olist_geolocation_dataset
WHERE geolocation_city REGEXP '^[^a-zA-ZÀ-ÿ]+$'
GROUP BY geolocation_city
ORDER BY occurrence_count DESC;
Observation:
-- The query returned no rows.
-- This indicates that no geolocation_city values containing only numbers, symbols, or other non-alphabetic characters were identified.
Conclusion:
-- No obvious malformed geolocation_city values were identified based on the assessed character-format rule.

2.8 TABLE 2 OVERALL INVALID VALUE ASSESSMENT SUMMARY
The following invalid-value assessments were performed on
-- olist_geolocation_dataset:
-- 1. geolocation_zip_code_prefix
--    Minimum value = 1,001
--    Maximum value = 99,990
--    Invalid values outside the defined range = 0
--    No numerical range violations were identified.
-- 2. geolocation_lat
--    Invalid latitude values = 0
--    All assessed latitude values fall within the valid geographic range of -90 to +90 degrees.
-- 3. geolocation_lng
--    Invalid longitude values = 0
--    All assessed longitude values fall within the valid geographic range of -180 to +180 degrees.
-- 4. geolocation_state
--    27 distinct state codes were identified.
--    All correspond to valid Brazilian states or the Federal District.
--    No invalid state codes were identified.
-- 5. geolocation_city
--    Numeric-only city values = 0
--    Malformed non-alphabetic city values = 0
--    No obviously malformed city values were identified
--    based on the applied validation rules.
-- Overall conclusion:
-- No obvious invalid values were identified in the assessed fields of olist_geolocation_dataset.
-- The ZIP code prefixes showed no numerical range violations,latitude and longitude values remained within their valid
-- geographic ranges, all state codes corresponded to validBrazilian state or Federal District abbreviations, 
-- and no obviously malformed city values were identified.
-- These findings indicate that the assessed geolocation attributes contain no detected invalid values based on the defined validation rules.

Table 3: olist_order_items_dataset
Invalid Value Assessment
3.1 INVALID VALUE ASSESSMENT: order_item_id — NON-NUMERIC AND NON-POSITIVE VALUES
Objective:
-- Determine whether order_item_id contains non-numeric values or numeric values that are zero or negative.
-- The column is stored as VARCHAR(32), therefore the assessment first checks whether the values can be interpreted as numbers
-- before evaluating whether they are positive.
SQL Query:
SELECT
    COUNT(*) AS invalid_order_item_ids
FROM olist_order_items_dataset
WHERE order_item_id IS NOT NULL
  AND (
        order_item_id NOT REGEXP '^[0-9]+$'
        OR CAST(order_item_id AS UNSIGNED) <= 0
      );
Observation:
-- The query returned 0 invalid order_item_ids.
-- This indicates that no non-numeric order_item_id values and no numeric order_item_id values equal to zero or less than zero were identified.
Conclusion:
-- No invalid order_item_id values were identified based on the applied format and positivity rules.
-- Although order_item_id is stored as VARCHAR(32), the assessed values follow the expected positive numerical format for item positions within an order.

3.2 INVALID VALUE ASSESSMENT: price — NEGATIVE VALUES
Objective:
-- Determine whether price contains negative values that would represent invalid product prices.
SQL Query:
SELECT
    COUNT(*) AS invalid_prices
FROM olist_order_items_dataset
WHERE price < 0;
Observation:
-- The query returned 0 invalid prices.
-- This indicates that no price values below zero were identified in the order-items table.
-- The price column is stored using the FLOAT data type.
-- Therefore, differences in displayed decimal formatting, such as 58.9 versus 58.90, are not treated as invalid
-- values because they represent the same numerical amount.
Conclusion:
-- No negative price values were identified.
-- The assessed price values therefore satisfy the expected non-negative numerical condition.
-- Decimal display differences were not classified as invalid because they do not change the underlying numerical value.

3.3 INVALID VALUE ASSESSMENT: freight_value — NEGATIVE VALUES
Objective:
-- Determine whether freight_value contains negative values that would represent invalid freight or shipping costs.
SQL Query:
SELECT
    COUNT(*) AS invalid_freight_values
FROM olist_order_items_dataset
WHERE freight_value < 0;
Observation:
-- The query returned 0 invalid freight values.
-- This indicates that no freight_value values below zero were identified in the order-items table.
-- The freight_value column is stored using the FLOAT data type.
-- Therefore, differences in displayed decimal formatting do not automatically represent invalid values.
Conclusion:
-- No negative freight values were identified.
-- The assessed freight_value values therefore satisfy the expected non-negative numerical condition.

3.4 INVALID VALUE ASSESSMENT: shipping_limit_date — CHRONOLOGICAL VALIDATION
Objective:
-- Determine whether shipping_limit_date occurs before the corresponding order's purchase timestamp, which would represent an invalid chronological sequence.
SQL Query:
SELECT
    COUNT(*) AS invalid_shipping_limit_dates
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o
    ON oi.order_id = o.order_id
WHERE oi.shipping_limit_date < o.order_purchase_timestamp;
Observation:
-- The query returned 0 invalid shipping limit dates.
-- This indicates that no shipping_limit_date values were identified as occurring before the corresponding order's purchase timestamp.
Conclusion:
-- No chronological violations were identified between order purchase time and shipping limit date.
-- The assessed shipping deadlines therefore follow the expected chronological sequence relative to orderpurchase.

3.5 DATA TYPE OBSERVATION: price AND freight_value
Objective:
-- Document the storage data types of the monetary fields assessed in olist_order_items_dataset.
SQL Query:
DESCRIBE olist_order_items_dataset;
Observation:
-- The query showed that:
-- price          = FLOAT
-- freight_value  = FLOAT
-- Both monetary fields are therefore stored using floating-point numeric representation.
-- Values such as 58.9 and 58.90 represent the same numerical amount. Therefore, the absence of a trailing zero is not considered an invalid value.
Conclusion:
-- No invalid-value finding was assigned based solely on the number of displayed decimal places.
-- The FLOAT data type should, however, be recognized as a schema/design consideration for monetary data because floating-point representation can introduce small
-- precision differences during calculations.
-- This observation does not indicate that the existing price or freight_value records are invalid.

3.6 TABLE 3 OVERALL INVALID VALUE ASSESSMENT SUMMARY
The following invalid-value assessments were performed on
-- olist_order_items_dataset:
-- 1. order_item_id
--    Invalid format or non-positive values = 0
--    No non-numeric values and no zero or negative values were identified.
--    Although the column is stored as VARCHAR(32), the assessed values follow the expected positive numerical format for item positions.
-- 2. price
--    Negative values = 0
--    No negative product prices were identified.
--    Decimal display differences such as 58.9 versus 58.90 were not classified as invalid because both represent the same numerical amount.
-- 3. freight_value
--    Negative values = 0
--    No negative freight values were identified.
-- 4. shipping_limit_date
--    Chronological violations = 0
--    No shipping_limit_date values were identified as occurring before the corresponding order_purchase_timestamp.
-- 5. Monetary data type observation
--    price and freight_value are stored as FLOAT.
--    This does not constitute an invalid-value finding.
--    However, it is a schema/design consideration because floating-point data types can introduce small precision differences during numerical calculations.
-- Overall conclusion:
-- No obvious invalid values were identified in the assessed fields of olist_order_items_dataset.
-- order_item_id values followed the expected positive numerical format, price and freight_value contained no negative values,
-- and shipping_limit_date maintained the expected chronological relationship with order purchase time.
-- The monetary fields are stored as FLOAT, which is documented as a data-type consideration rather than an invalid-value finding.
-- These findings indicate that the assessed order-item attributes contain no detected invalid values based on the defined validation rules.

Table 4: olist_order_payments_dataset
Invalid Value Assessment
4.1 INVALID VALUE ASSESSMENT: payment_sequential — NON-POSITIVE VALUES
Objective:
-- Determine whether payment_sequential contains zero or negative values that would represent invalid payment sequence numbers.
SQL Query:
SELECT
    COUNT(*) AS invalid_payment_sequential
FROM olist_order_payments_dataset
WHERE payment_sequential <= 0;
Observation:
-- The query returned 0 invalid payment_sequential values.
-- This indicates that no payment_sequential values equal to zero or less than zero were identified.
Conclusion:
-- No non-positive payment_sequential values were identified.
-- All assessed payment sequence values satisfy the expected positive numerical condition for payment sequencing.
4.2 INVALID VALUE ASSESSMENT: payment_type — UNDEFINED CATEGORY
Objective:
-- Identify payment_type values that do not represent a defined payment method and determine the number of affected records.
SQL Query:
SELECT
    payment_type,
    COUNT(*) AS occurrence_count
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY occurrence_count DESC;
Observation:
-- The query identified five distinct payment types:
-- credit_card    = 76,795
-- boleto         = 19,784
-- voucher        = 5,775
-- debit_card     = 1,529
-- not_defined    = 3
-- The values credit_card, boleto, voucher and debit_card represent defined payment categories.
-- However, not_defined does not identify an actual payment method and therefore represents an undefined categorical value.
-- The undefined value occurred in 3 payment records.
Conclusion:
-- 3 payment records contain an undefined payment_type value of not_defined.
-- These records are identified as invalid or incomplete categorical values for payment method analysis.
-- The remaining payment_type values represent defined payment categories.

4.3 INVALID VALUE ASSESSMENT: payment_installments — NON-POSITIVE VALUES
Objective:
-- Determine whether payment_installments contains zero or negative values that would represent an invalid number of payment installments.
SQL Query:
SELECT
    COUNT(*) AS invalid_payment_installments
FROM olist_order_payments_dataset
WHERE payment_installments <= 0;
Observation:
-- The query returned 2 invalid payment installment records.
-- Further investigation identified the following records:
-- order_id                           payment_type    installments    payment_value
-- ---------------------------------------------------------------------------------
-- 744bade1fcf9ff3f31d860ace076d422   credit_card     0               58.69
-- 1a57108394169c0b47d8f876acc9ba2d   credit_card     0               129.94
-- Both records have payment_type = credit_card but contain payment_installments = 0.
-- Since a payment cannot have zero installments, these values represent invalid installment counts.
Conclusion:
-- 2 payment records contain invalid payment_installments values of 0.
-- Both affected records are associated with credit_card payments.
-- These records should be flagged as data-quality issues because payment_installments is expected to contain a positive number of installments.

4.4 INVALID VALUE ASSESSMENT: payment_value — NEGATIVE VALUES
Objective:
-- Determine whether payment_value contains negative values that would represent invalid payment amounts.
SQL Query:
SELECT
    COUNT(*) AS invalid_payment_values
FROM olist_order_payments_dataset
WHERE payment_value < 0;
Observation:
-- The query returned 0 invalid payment values.
-- This indicates that no payment_value values below zero were identified in the payment table.
Conclusion:
-- No negative payment values were identified.
-- The assessed payment_value records therefore satisfy the expected non-negative numerical condition.

4.5 INVALID VALUE ASSESSMENT: payment_installments — RANGE BY PAYMENT TYPE
Objective:
-- Examine the minimum and maximum payment_installments values for each payment type in order to identify unusual installment
-- patterns and provide additional context for previously identified invalid values.
SQL Query:
SELECT
    payment_type,
    MIN(payment_installments) AS minimum_installments,
    MAX(payment_installments) AS maximum_installments
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY payment_type;
Observation:
-- The query returned the following ranges:
-- boleto       → minimum = 1, maximum = 1
-- credit_card  → minimum = 0, maximum = 24
-- debit_card   → minimum = 1, maximum = 1
-- not_defined  → minimum = 1, maximum = 1
-- voucher      → minimum = 1, maximum = 1
-- The credit_card payment type is the only category with a minimum installment value of 0.
-- The previously identified 2 records with zero installments therefore belong to the credit_card payment category.
-- The maximum value of 24 installments for credit_card was not classified as invalid because no validation rule was
-- established that would make 24 installments invalid.
-- All other payment types have a minimum and maximum of 1,indicating single-installment payments in the assessed data.
Conclusion:
-- The range assessment confirms that the 2 previously identified zero-installment records are isolated to credit_card payments.
-- No additional invalid installment values were identified through the payment-type range assessment.
-- The maximum credit_card installment value of 24 was retained as a valid observed value because it does not violate the defined validation rule.

4.6 TABLE 4 OVERALL INVALID VALUE ASSESSMENT SUMMARY
-- The following invalid-value assessments were performed on olist_order_payments_dataset:
-- 1. payment_sequential
--    Invalid non-positive values = 0
--    No zero or negative payment sequence values were identified.
-- 2. payment_type
--    Undefined values = 3
--    Three records contain payment_type = not_defined.
--    This represents an undefined payment category and should be flagged as a data-quality issue for payment method analysis.
-- 3. payment_installments
--    Invalid non-positive values = 2
--    Two credit_card payment records contain payment_installments = 0.
--    These records represent invalid installment counts because a payment should have at least one installment.
-- 4. payment_value
--    Negative values = 0
--    No negative payment amounts were identified.
-- 5. payment_installments by payment_type
--    boleto       → 1 to 1
--    credit_card  → 0 to 24
--    debit_card   → 1 to 1
--    not_defined  → 1 to 1
--    voucher      → 1 to 1
--    The range assessment confirmed that the zero-installment values occur only within credit_card payments.
Overall conclusion:
-- The invalid-value assessment identified two types of data quality issues in olist_order_payments_dataset.
-- First, 3 records contain the undefined payment_type value not_defined.
-- Second, 2 credit_card payment records contain payment_installments = 0, which does not represent a valid installment count.
-- No invalid payment_sequential values and no negative payment_value values were identified.
-- Overall, the payment table is largely consistent with the defined validation rules, with 5 records requiring attention 
-- due to undefined payment categories or invalid installment counts.

Table 5: olist_order_reviews_dataset
Invalid Value Assessment
5.1 INVALID VALUE ASSESSMENT: review_score — RANGE VALIDATION
Objective:
-- Determine whether review_score contains values outside the expected rating range of 1 to 5.
SQL Query:
SELECT
    COUNT(*) AS invalid_review_scores
FROM olist_order_reviews_dataset
WHERE review_score < 1
   OR review_score > 5;
Observation:
-- The query returned 0 invalid review scores.
-- This indicates that no review_score values below 1 or above 5 were identified.
Conclusion:
-- No invalid review scores were identified.
-- All assessed review_score values fall within the expected
-- rating range of 1 to 5.
5.2 INVALID VALUE ASSESSMENT: review_creation_date — ZERO DATE
Objective:
-- Identify records containing the zero date value 0000-00-00 00:00:00, which does not represent a valid calendar date.
SQL Query:
SELECT
    COUNT(*) AS zero_review_creation_dates
FROM olist_order_reviews_dataset
WHERE YEAR(review_creation_date) = 0;
Observation:
-- The query returned 1 zero review creation date.
-- This confirms that 1 record contains the invalid zero-date value 0000-00-00 00:00:00.
-- The zero date does not represent a valid calendar date and therefore cannot accurately indicate when the review was created.
Conclusion:
-- 1 review record contains an invalid zero date in review_creation_date.
-- This record should be flagged as a data-quality issue because the value does not represent a valid review creation date.

5.3 INVALID VALUE ASSESSMENT: review_creation_date — CHRONOLOGICAL VALIDATION
Objective:
-- Determine whether any review_creation_date values occur before the corresponding order_purchase_timestamp.
SQL Query:
SELECT
    COUNT(*) AS invalid_review_creation_dates
FROM olist_order_reviews_dataset r
JOIN olist_orders_dataset o
    ON r.order_id = o.order_id
WHERE r.review_creation_date < o.order_purchase_timestamp;
Observation:
-- The query returned 75 records where review_creation_date occurs before the corresponding order_purchase_timestamp.
-- Further investigation confirmed that several of these records have review creation dates occurring days, weeks or months
-- before the corresponding order was purchased.
-- One of the 75 records contains the invalid zero date 0000-00-00 00:00:00.
-- The 75 records therefore represent the total number of records affected by this chronological assessment.
Conclusion:
-- 75 review records were identified with chronological inconsistencies between review_creation_date and order_purchase_timestamp.
-- One of these records contains the invalid zero date.
-- These records should be flagged for further investigation because a review should normally be created after the corresponding order has been placed.

5.4 INVALID VALUE ASSESSMENT: review_answer_timestamp — CHRONOLOGICAL VALIDATION
Objective:
-- Determine whether any review_answer_timestamp values occur before the corresponding review_creation_date.
SQL Query:
SELECT
    COUNT(*) AS invalid_review_answer_timestamps
FROM olist_order_reviews_dataset
WHERE review_answer_timestamp < review_creation_date;
Observation:
-- The query returned 0 invalid review answer timestamps.
-- This indicates that no review_answer_timestamp values were identified as occurring before their corresponding review_creation_date.
Conclusion:
-- No chronological inconsistencies were identified between review_creation_date and review_answer_timestamp.
-- The assessed review response timestamps therefore follow the expected chronological sequence relative to review creation.

5.5 INVALID VALUE ASSESSMENT: review_answer_timestamp — ZERO DATE
Objective:
-- Identify records containing a zero date value in review_answer_timestamp.
SQL Query:
SELECT
    COUNT(*) AS zero_review_answer_timestamps
FROM olist_order_reviews_dataset
WHERE YEAR(review_answer_timestamp) = 0;
Observation:
-- The query returned 1 zero review answer timestamp.
-- This confirms that 1 record contains the zero-date value 0000-00-00 00:00:00.
-- The zero date does not represent a valid calendar timestamp and therefore cannot accurately indicate when the review response occurred.
Conclusion:
-- 1 review record contains an invalid zero value in review_answer_timestamp.
-- This record should be flagged as a data-quality issue because the value does not represent a valid response timestamp.

5.6 INVALID VALUE ASSESSMENT: review_comment_title — BLANK VALUES
Objective:
-- Identify review_comment_title values that contain only whitespace characters and therefore do not provide meaningful review title information.
SQL Query:
SELECT
    COUNT(*) AS blank_review_titles
FROM olist_order_reviews_dataset
WHERE review_comment_title IS NOT NULL
  AND TRIM(review_comment_title) = '';
Observation:
-- The query returned 87,657 blank/whitespace-only review titles.
-- This indicates that a substantial number of review records contain a non-NULL title field that does not contain meaningful text.
-- However, an empty review title does not necessarily represent an invalid review because customers may submit reviews without providing a title.
Conclusion:
-- 87,657 review records contain blank/whitespace-only values in review_comment_title.
-- These values should be classified as blank or incomplete optional fields rather than invalid review records.
-- They should be considered during data cleaning and text-based review analysis.

5.7 INVALID VALUE ASSESSMENT: review_comment_message — BLANK VALUES
Objective:
-- Identify review_comment_message values that contain only whitespace characters and therefore do not provide meaningful review message information.
SQL Query:
SELECT
    COUNT(*) AS blank_review_messages
FROM olist_order_reviews_dataset
WHERE review_comment_message IS NOT NULL
  AND TRIM(review_comment_message) = '';
Observation:
-- The query returned 58,256 blank/whitespace-only review messages.
-- This indicates that a substantial number of review records contain a non-NULL message field that does not contain meaningful text.
-- However, an empty review message does not necessarily represent an invalid review because customers may submit ratings without providing written comments.
Conclusion:
-- 58,256 review records contain blank/whitespace-only values in review_comment_message.
-- These values should be classified as blank or incomplete optional fields rather than invalid review records.
-- They should be considered during data cleaning and text-based review analysis.

5.8 NULL VALUE CONFIRMATION: REVIEW TEXT FIELDS
Objective:
-- Determine whether review_comment_title and review_comment_message contain NULL values in addition to the identified blank/whitespace-only values.
SQL Query:
SELECT
    SUM(review_comment_title IS NULL) AS null_review_titles,
    SUM(review_comment_message IS NULL) AS null_review_messages
FROM olist_order_reviews_dataset;
Observation:
-- The query returned:
-- null_review_titles   = 0
-- null_review_messages = 0
-- Therefore, neither review_comment_title nor review_comment_message contains NULL values.
-- The missing textual content identified in these fields is represented by blank/whitespace values rather than NULL.
Conclusion:
-- No NULL values were identified in either review text field.
-- The blank values identified in sections 5.6 and 5.7 should therefore be treated separately from NULL values.

5.9 TABLE 5 OVERALL INVALID VALUE ASSESSMENT SUMMARY
The following invalid-value and data-quality assessments were
-- performed on olist_order_reviews_dataset:
-- 1. review_score
--    Invalid values = 0
--    All review scores fall within the expected range of 1 to 5.
-- 2. review_creation_date
--    Zero dates = 1
--    One record contains the invalid zero date
--    0000-00-00 00:00:00.
-- 3. review_creation_date vs order_purchase_timestamp
--    Chronological anomalies = 75
--    75 records contain review_creation_date values earlier than their corresponding order_purchase_timestamp.
--    One of these records contains the invalid zero date.
-- 4. review_answer_timestamp vs review_creation_date
--    Chronological anomalies = 0
--    No review response timestamps were found to occur before their corresponding review creation dates.
-- 5. review_answer_timestamp
--    Zero dates = 1
--    One record contains the invalid zero date
--    0000-00-00 00:00:00.
-- 6. review_comment_title
--    Blank/whitespace-only values = 87,657
--    NULL values = 0
--    These are classified as blank optional fields rather than automatically invalid reviews.
-- 7. review_comment_message
--    Blank/whitespace-only values = 58,256
--    NULL values = 0
--    These are classified as blank optional fields rather than automatically invalid reviews.
-- Overall Conclusion:
-- The invalid-value assessment identified several data-quality issues in olist_order_reviews_dataset.
-- No invalid review scores were identified, and all review scores fall within the expected 1-to-5 range.
-- One invalid zero date was identified in review_creation_date, while one invalid zero date was identified in review_answer_timestamp.
-- In addition, 75 records were identified where review_creation_date occurs before the corresponding order_purchase_timestamp. Further investigation showed that
-- several of these discrepancies represent substantial chronological inconsistencies rather than simple same-day time differences.
-- No chronological inconsistencies were identified between review_creation_date and review_answer_timestamp.
-- The review text fields contain no NULL values, but 87,657 review titles and 58,256 review messages contain 
-- blank/whitespace-only values. These should be treated as incomplete optional text fields rather than automatically classified as invalid reviews.
-- Overall, the review table is largely valid in terms of review scores and response chronology, but the identified
-- date anomalies and blank text fields should be considered during subsequent data cleaning and analytical preparation.

TABLE 6: olist_orders_dataset
INVALID VALUE ASSESSMENT
Objective:
-- Assess the olist_orders_dataset table for invalid, inconsistent,and contextually inappropriate values that could affect downstream analysis and reporting.

6.1 ORDER STATUS VALIDATION
Objective:
-- Identify the distinct values present in order_status and verify that they represent recognized order lifecycle states.
SQL Query:
SELECT DISTINCT
    order_status
FROM olist_orders_dataset;
Observation:
-- The following order status values were identified:
-- approved
-- canceled
-- created
-- delivered
-- invoiced
-- processing
-- shipped
-- unavailable
-- All observed values represent recognized order lifecycle states within the dataset.
Conclusion:
-- No unexpected order_status values were identified.

6.2 order_approved_at — ZERO DATE ASSESSMENT
Objective:
-- Identify invalid zero timestamps in order_approved_at.
SQL Query:
SELECT
    COUNT(*) AS zero_approval_timestamps
FROM olist_orders_dataset
WHERE YEAR(order_approved_at) = 0;
Observation:
-- The query returned 160 zero approval timestamps.
-- These records contain the invalid zero timestamp 0000-00-00 00:00:00.
Conclusion:
-- 160 records contain invalid zero values in order_approved_at.

6.3 order_approved_at — CHRONOLOGICAL VALIDATION
Objective:
-- Determine whether valid approval timestamps occur before the corresponding order purchase timestamp.
SQL Query:
SELECT
    COUNT(*) AS genuine_invalid_approval_timestamps
FROM olist_orders_dataset
WHERE YEAR(order_approved_at) <> 0
  AND order_approved_at < order_purchase_timestamp;
Observation:
-- The query returned 0 records.
Conclusion:
-- No genuine chronological inconsistencies were identified between order_purchase_timestamp and valid order_approved_at values.

6.4 order_delivered_carrier_date — ZERO DATE ASSESSMENT
Objective:
-- Identify invalid zero timestamps in order_delivered_carrier_date.
SQL Query:
SELECT
    COUNT(*) AS zero_carrier_delivery_dates
FROM olist_orders_dataset
WHERE YEAR(order_delivered_carrier_date) = 0;
Observation:
-- The query returned 1,783 zero carrier delivery dates.
Conclusion:
-- 1,783 records contain invalid zero values in order_delivered_carrier_date.

6.5 order_delivered_carrier_date — CHRONOLOGICAL VALIDATION
Objective:
-- Identify valid carrier delivery timestamps occurring before the corresponding order purchase timestamp.
SQL Query:
SELECT
    COUNT(*) AS genuine_invalid_carrier_dates
FROM olist_orders_dataset
WHERE YEAR(order_delivered_carrier_date) <> 0
  AND order_delivered_carrier_date < order_purchase_timestamp;
Observation:
-- The query returned 166 records.
-- Sample inspection confirmed that these records contain valid dates, but the carrier delivery timestamp occurs before the order purchase timestamp.
Conclusion:
-- 166 records contain chronological inconsistencies between order_purchase_timestamp and order_delivered_carrier_date.
-- These records should be flagged as data-quality issues.

6.6 order_delivered_customer_date — ZERO DATE ASSESSMENT
Objective:
-- Identify invalid zero timestamps in order_delivered_customer_date.
SQL Query:
SELECT
    COUNT(*) AS zero_customer_delivery_dates
FROM olist_orders_dataset
WHERE YEAR(order_delivered_customer_date) = 0;
Observation:
-- The query returned 2,965 zero customer delivery dates.
Conclusion:
-- 2,965 records contain invalid zero values in order_delivered_customer_date.

6.7 order_delivered_customer_date — CHRONOLOGICAL VALIDATION
Objective:
-- Determine whether valid customer delivery timestamps occur before the corresponding order purchase timestamp.
SQL Query:
SELECT
    COUNT(*) AS genuine_invalid_customer_delivery_dates
FROM olist_orders_dataset
WHERE YEAR(order_delivered_customer_date) <> 0
  AND order_delivered_customer_date < order_purchase_timestamp;
Observation:
-- The query returned 0 records.
Conclusion:
-- No chronological inconsistencies were identified between order_purchase_timestamp and valid order_delivered_customer_date values.

6.8 DELIVERY SEQUENCE VALIDATION
Objective:
-- Determine whether a valid customer delivery timestamp occurs before the corresponding carrier delivery timestamp.
SQL Query:
SELECT
    COUNT(*) AS invalid_delivery_sequence
FROM olist_orders_dataset
WHERE YEAR(order_delivered_carrier_date) <> 0
  AND YEAR(order_delivered_customer_date) <> 0
  AND order_delivered_customer_date < order_delivered_carrier_date;
Observation:
-- The query returned 23 records.
-- Sample inspection confirmed that these records contain valid timestamps but the customer delivery date occurs before the carrier delivery date.
Conclusion:
-- 23 records contain chronological inconsistencies in the delivery sequence.
-- These records should be flagged because customer delivery should normally occur after carrier handover.

6.9 order_estimated_delivery_date — ZERO DATE ASSESSMENT
Objective:
-- Identify invalid zero timestamps in
-- order_estimated_delivery_date.
SQL Query:
SELECT
    COUNT(*) AS zero_estimated_delivery_dates
FROM olist_orders_dataset
WHERE YEAR(order_estimated_delivery_date) = 0;
Observation:
-- The query returned 0.
Conclusion:
-- No zero or invalid estimated delivery dates were identified.

6.10 ORDER STATUS vs CUSTOMER DELIVERY DATE
Objective:
-- Identify orders marked as 'delivered' that do not contain a valid customer delivery timestamp.
SQL Query:
SELECT
    COUNT(*) AS delivered_without_delivery_date
FROM olist_orders_dataset
WHERE order_status = 'delivered'
  AND YEAR(order_delivered_customer_date) = 0;
Observation:
-- The query returned 8 records.
-- These orders are marked as 'delivered' but contain the invalid zero timestamp in order_delivered_customer_date.
Conclusion:
-- 8 records contain a status/timestamp inconsistency.
-- These records should be flagged because a delivered order would normally be expected to have a valid customer delivery timestamp.

6.11 ORDER STATUS vs CUSTOMER DELIVERY DATE
Objective:
-- Identify canceled orders that contain a valid customer delivery timestamp.
SQL Query:
SELECT
    COUNT(*) AS canceled_with_delivery_date
FROM olist_orders_dataset
WHERE order_status = 'canceled'
  AND YEAR(order_delivered_customer_date) <> 0;
Observation:
-- The query returned 6 records.
-- Inspection confirmed that these orders are marked as 'canceled' but contain valid customer delivery timestamps.
Conclusion:
-- 6 records contain status/timestamp inconsistencies.
-- Although the delivery timestamps themselves are valid, their presence alongside a 'canceled' order status violates
-- the expected order lifecycle logic.
-- These records should be flagged during data cleaning and considered when performing order-status and delivery analysis.

OVERALL TABLE 6 ASSESSMENT
Summary of identified issues:
-- 160  invalid zero order_approved_at timestamps
-- 0    genuine approval-before-purchase inconsistencies
-- 1,783 invalid zero order_delivered_carrier_date timestamps
-- 166  carrier-delivery-before-purchase inconsistencies
-- 2,965 invalid zero order_delivered_customer_date timestamps
-- 0    customer-delivery-before-purchase inconsistencies
-- 23   customer-delivery-before-carrier-delivery inconsistencies
-- 0    invalid zero order_estimated_delivery_date values
-- 8    delivered orders without a valid customer delivery date
-- 6    canceled orders with a valid customer delivery date
Overall Conclusion:
-- The olist_orders_dataset contains several timestamp and business-rule inconsistencies that should be considered
-- during data cleaning and downstream analysis.
-- The most significant issues are the zero timestamps found in order_delivered_carrier_date and order_delivered_customer_date.
-- The identified chronological and status/timestamp inconsistencies should also be flagged because they may
-- affect delivery-time calculations, order lifecycle analysis, and supply chain performance metrics.

Table 7: olist_products_dataset
Invalid Value Assessment

7.1 NEGATIVE PRODUCT WEIGHT ASSESSMENT
Objective:
-- Determine whether any product records contain negative values in product_weight_g.
SQL Query:
SELECT
    COUNT(*) AS negative_product_weights
FROM olist_products_dataset
WHERE product_weight_g < 0;
Observation:
-- The query returned 0 records.
-- This indicates that no negative product weight values were identified in the olist_products_dataset table.
Conclusion:
-- No invalid negative values were identified in product_weight_g.
-- The product weight values do not contain negative measurements.

7.2 ZERO PRODUCT WEIGHT ASSESSMENT
Objective:
-- Determine whether any product records contain a product weight value of zero, which may represent an invalid or incomplete physical product measurement.
SQL Query:
SELECT
    COUNT(*) AS zero_product_weights
FROM olist_products_dataset
WHERE product_weight_g = 0;
Observation:
-- The query returned 12 product rows with a product weight of zero.
-- Further assessment showed that these records correspond to 5 unique product IDs because some product records occur more than once in the table.
-- Therefore, the 12 affected rows represent 5 unique products.
Conclusion:
-- 5 unique products contain a product weight of zero.
-- A zero product weight is flagged as a potential data-quality issue because a physical product would normally be expected to have a measurable positive weight.
-- These values should be reviewed during data cleaning and considered when performing weight-dependent analysis.

7.3 NEGATIVE PRODUCT DIMENSION ASSESSMENT
Objective:
-- Determine whether any product records contain negative values in product_length_cm, product_height_cm, or product_width_cm.
SQL Query:
SELECT
    SUM(product_length_cm < 0) AS negative_lengths,
    SUM(product_height_cm < 0) AS negative_heights,
    SUM(product_width_cm < 0) AS negative_widths
FROM olist_products_dataset;
Observation:
-- The query returned 0 for all three product dimensions.
-- No negative length, height, or width values were identified in the olist_products_dataset table.
Conclusion:
-- No invalid negative product dimension values were identified.
-- All observed product dimension values are non-negative.

7.4 ZERO PRODUCT DIMENSION ASSESSMENT
Objective:
-- Determine whether any product records contain zero values in product_length_cm, product_height_cm, or product_width_cm,
-- which may represent invalid or incomplete physical measurements.
SQL Query:
SELECT
    SUM(product_length_cm = 0) AS zero_lengths,
    SUM(product_height_cm = 0) AS zero_heights,
    SUM(product_width_cm = 0) AS zero_widths
FROM olist_products_dataset;
Observation:
-- The query returned 4 zero-value occurrences for each of the three product dimensions.
-- Further assessment showed that these occurrences correspond to 2 unique product IDs because some product records occur more than once in the table.
-- The affected products contain zero values across their physical measurement fields.
Conclusion:
-- 2 unique products contain zero values across their physical dimension fields.
-- Zero values in physical product dimensions are flagged as potential data-quality issues because a physical product would
-- normally be expected to have positive length, height, and width.
-- These values should be reviewed during data cleaning and considered when performing dimensional or logistics analysis.

7.5 NEGATIVE PRODUCT PHOTO QUANTITY ASSESSMENT
Objective:
-- Determine whether any product records contain negative values in product_photos_qty.
SQL Query:
SELECT
    COUNT(*) AS negative_photo_quantities
FROM olist_products_dataset
WHERE product_photos_qty < 0;
Observation:
-- The query returned 0 records.
-- No negative product photo quantities were identified in the olist_products_dataset table.
Conclusion:
-- No invalid negative values were identified in
-- product_photos_qty.
-- All observed product photo quantities are non-negative.

7.6 ZERO PRODUCT PHOTO QUANTITY ASSESSMENT
Objective:
-- Determine whether any products have a product photo quantity recorded as zero and assess whether such values may represent incomplete product metadata.
SQL Query:
SELECT
    COUNT(*) AS zero_photo_quantities
FROM olist_products_dataset
WHERE product_photos_qty = 0;
Observation:
-- The query returned 1,220 product rows with a product photo quantity of zero.
-- Further assessment showed that these records correspond to 610 unique product IDs because some product records occur more than once in the table.
Conclusion:
-- 610 unique products have zero recorded product photos.
-- A zero photo quantity is not necessarily an invalid value because a product may legitimately have no associated image.
-- However, these values are flagged as potentially incomplete product metadata and should be considered when performing
-- analyses involving product image availability.

7.7 NEGATIVE PRODUCT NAME LENGTH ASSESSMENT
Objective:
-- Determine whether any product records contain negative values in product_name_lenght.
SQL Query:
SELECT
    COUNT(*) AS negative_product_name_lengths
FROM olist_products_dataset
WHERE product_name_lenght < 0;
Observation:
-- The query returned 0 records.
-- No negative product name lengths were identified in the olist_products_dataset table.
Conclusion:
-- No invalid negative values were identified in product_name_lenght.
-- Product name lengths do not contain negative values.

7.8 ZERO PRODUCT NAME LENGTH ASSESSMENT
Objective:
-- Determine whether any products have a product name length recorded as zero.
SQL Query:
SELECT
    COUNT(*) AS zero_product_name_lengths
FROM olist_products_dataset
WHERE product_name_lenght = 0;
Observation:
-- The query returned 1,220 product rows with a product name length of zero.
-- Further assessment showed that these records correspond to 610 unique product IDs because some product records occur more than once in the table.
Conclusion:
-- 610 unique products have a product name length of zero.
-- A product name length of zero indicates that the corresponding product name is empty or contains no characters.
-- These values are therefore flagged as potentially invalid product metadata and should be reviewed during data cleaning.

7.9 NEGATIVE PRODUCT DESCRIPTION LENGTH ASSESSMENT
Objective:
-- Determine whether any product records contain negative values in product_description_lenght.
SQL Query:
SELECT
    COUNT(*) AS negative_product_description_lengths
FROM olist_products_dataset
WHERE product_description_lenght < 0;
Observation:
-- The query returned 0 records.
-- No negative product description lengths were identified in the olist_products_dataset table.
Conclusion:
-- No invalid negative values were identified in product_description_lenght.
-- Product description lengths do not contain negative values.

7.10 ZERO PRODUCT DESCRIPTION LENGTH ASSESSMENT
Objective:
-- Determine whether any products have a product description length recorded as zero.
SQL Query:
SELECT
    COUNT(*) AS zero_product_description_lengths
FROM olist_products_dataset
WHERE product_description_lenght = 0;
Observation:
-- The query returned 1,220 product rows with a product description length of zero.
-- Further assessment showed that these records correspond to 610 unique product IDs because some product records occur more than once in the table.
Conclusion:
-- 610 unique products have a product description length of zero.
-- A zero description length indicates that the corresponding product description is empty or contains no characters.
-- These values are therefore flagged as potentially invalid product metadata and should be reviewed during data cleaning.

7.11 EMPTY PRODUCT CATEGORY ASSESSMENT
Objective:
-- Determine whether any product records contain empty or whitespace-only values in product_category_name.
SQL Query:
SELECT
    COUNT(*) AS empty_product_categories
FROM olist_products_dataset
WHERE TRIM(product_category_name) = '';
Observation:
-- The query returned 1,220 product rows with empty or whitespace-only product category values.
-- Further assessment showed that these records correspond to 610 unique product IDs.
-- These values are not SQL NULL values. They contain empty or whitespace-only category values.
Conclusion:
-- 610 unique products contain an empty product category.
-- Empty product category values represent invalid or incomplete categorical information because the affected products cannot
-- be assigned to a meaningful product category.
-- These records should be flagged during data cleaning and considered when performing product-category analysis.

7.12 OVERALL INVALID VALUE ASSESSMENT
Objective:
-- Summarize the invalid-value findings identified in the olist_products_dataset table.
Observation:
The assessment identified the following findings:
-- 1. No negative product weight values were identified.
-- 2. 12 product rows contain zero product weight values, corresponding to 5 unique product IDs.
-- 3. No negative product dimension values were identified.
-- 4. 4 zero-value occurrences were identified for each of the three product dimensions, corresponding to 2 unique product IDs.
-- 5. No negative product photo quantities were identified.
-- 6. 1,220 product rows contain zero product photo quantities, corresponding to 610 unique product IDs.
-- 7. No negative product name lengths were identified.
-- 8. 1,220 product rows contain zero product name lengths, corresponding to 610 unique product IDs.
-- 9. No negative product description lengths were identified.
-- 10. 1,220 product rows contain zero product description lengths, corresponding to 610 unique product IDs.
-- 11. 1,220 product rows contain empty product categories, corresponding to 610 unique product IDs.
Conclusion:
-- The olist_products_dataset table contains no negative values across the assessed product measurements, product photo
-- quantities, product name lengths, or product description lengths.
-- However, several zero and empty values were identified that may represent invalid or incomplete product information.
-- The most notable findings are the 610 unique products with zero recorded product photo quantities, zero product name
-- lengths, zero product description lengths, and empty product categories.
-- In addition, 5 unique products contain zero product weights,while 2 unique products contain zero values across their physical dimensions.
-- Zero product photo quantities should not automatically be treated as invalid because a product may legitimately have
-- no associated image. However, zero physical measurements, zero text lengths, and empty product categories should be flagged for further review.
-- These identified values should be considered during data cleaning and transformation to prevent potential distortion
-- of product, logistics, and supply chain analyses.

Table 8: olist_sellers_dataset
Invalid Value Assessment
8.1 NEGATIVE SELLER ZIP CODE PREFIX ASSESSMENT
Objective:
-- Determine whether any seller records contain negative values in seller_zip_code_prefix.
SQL Query:
SELECT
    COUNT(*) AS negative_seller_zip_codes
FROM olist_sellers_dataset
WHERE seller_zip_code_prefix < 0;
Observation:
-- The query returned 0 records.
-- This indicates that no negative seller ZIP code prefix values were identified in the olist_sellers_dataset table.
Conclusion:
-- No invalid negative values were identified in seller_zip_code_prefix.

8.2 ZERO SELLER ZIP CODE PREFIX ASSESSMENT
Objective:
-- Determine whether any seller records contain a seller ZIP code prefix value of zero.
SQL Query:
SELECT
    COUNT(*) AS zero_seller_zip_codes
FROM olist_sellers_dataset
WHERE seller_zip_code_prefix = 0;
Observation:
-- The query returned 0 records.
-- This indicates that no seller ZIP code prefix values of zero were identified in the table.
Conclusion:
-- No zero seller ZIP code prefix values were identified.
-- Therefore, no potentially invalid zero values were identified in seller_zip_code_prefix.

8.3 EMPTY SELLER CITY ASSESSMENT
Objective:
-- Determine whether any seller records contain empty or whitespace-only values in seller_city.
SQL Query:
SELECT
    COUNT(*) AS empty_seller_cities
FROM olist_sellers_dataset
WHERE TRIM(seller_city) = '';
Observation:
-- The query returned 0 record.
-- This indicates that no empty or whitespace-only seller city values were identified in the table.
Conclusion:
-- No empty seller city values were identified in seller_city.

8.4 SELLER STATE VALUE ASSESSMENT
Objective:
-- Identify the distinct values present in seller_state and determine whether they represent recognized Brazilian state or federal district abbreviations.
SQL Query:
SELECT DISTINCT
    seller_state
FROM olist_sellers_dataset
ORDER BY seller_state;
Observation:
The query returned the following distinct seller_state values:
-- AC
-- AM
-- BA
-- CE
-- DF
-- ES
-- GO
-- MA
-- MG
-- MS
-- MT
-- PA
-- PB
-- PE
-- PI
-- PR
-- RJ
-- RN
-- RO
-- RS
-- SC
-- SE
-- SP
-- All observed values correspond to recognized Brazilian state or federal district abbreviations.
Conclusion:
-- No unexpected seller_state values were identified.
-- The observed seller_state values conform to the expected Brazilian state and federal district abbreviation format.

8.5 INVALID SELLER STATE VALUE ASSESSMENT
Objective:
-- Determine whether any seller records contain seller_state values outside the recognized Brazilian state and federal district abbreviations.
SQL Query:
SELECT
    seller_state,
    COUNT(*) AS occurrence_count
FROM olist_sellers_dataset
WHERE seller_state NOT IN (
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF',
    'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA',
    'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS',
    'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
)
GROUP BY seller_state
ORDER BY occurrence_count DESC;
Observation:
-- The query returned an empty result.
-- This indicates that no seller_state values were found outside the recognized Brazilian state and federal district abbreviations.
Conclusion:
-- No invalid seller_state values were identified in the olist_sellers_dataset table.

8.6 SELLER CITY PLACEHOLDER VALUE ASSESSMENT
Objective:
-- Determine whether seller_city contains suspicious placeholder values such as unknown, undefined, not_defined, n/a, or null.
SQL Query:
SELECT
    seller_city,
    COUNT(*) AS occurrence_count
FROM olist_sellers_dataset
WHERE LOWER(TRIM(seller_city)) IN (
    'unknown',
    'undefined',
    'not_defined',
    'n/a',
    'na',
    'null'
)
GROUP BY seller_city
ORDER BY occurrence_count DESC;
Observation:
-- The query returned an empty result.
-- This indicates that no suspicious placeholder values were identified in seller_city.
Conclusion:
-- No suspicious placeholder values were identified in seller_city.

8.7 OVERALL INVALID VALUE ASSESSMENT
Objective:
-- Summarize the invalid value findings identified in the olist_sellers_dataset table.
Observation:
-- The invalid value assessment identified no negative or zero seller ZIP code prefix values.
-- No empty or whitespace-only seller city values were identified.
-- All observed seller_state values correspond to recognized Brazilian state or federal district abbreviations.
-- No invalid seller_state values were identified.
-- No suspicious placeholder values were identified in seller_city.
Conclusion:
-- The olist_sellers_dataset table contains no identified invalid values across the assessed seller ZIP code, city, and state attributes.
-- No negative or zero seller ZIP code prefix values, empty seller city values, invalid seller state codes, or suspicious seller
-- city placeholder values were identified.
-- Therefore, no invalid value treatment is required for the assessed fields at this stage of the Data Quality Assessment.

Table 9: product_category_name_translation
9.1 EMPTY PRODUCT CATEGORY NAME ASSESSMENT
Objective:
-- Determine whether any records contain empty or whitespace-only values in product_category_name.
SQL Query:
SELECT
    COUNT(*) AS empty_product_categories
FROM product_category_name_translation
WHERE TRIM(product_category_name) = '';
Observation:
-- The query returned 0 records.
-- This indicates that no empty or whitespace-only values were identified in product_category_name.
Conclusion:
-- No empty product category names were identified in product_category_name.

9.2 EMPTY ENGLISH PRODUCT CATEGORY ASSESSMENT
Objective:
-- Determine whether any records contain empty or whitespace-only values in product_category_name_english.
SQL Query:
SELECT
    COUNT(*) AS empty_english_categories
FROM product_category_name_translation
WHERE TRIM(product_category_name_english) = '';
Observation:
-- The query returned 0 records.
-- This indicates that no empty or whitespace-only values were identified in product_category_name_english.
Conclusion:
-- No empty English product category values were identified in product_category_name_english.

9.3 PRODUCT CATEGORY PLACEHOLDER VALUE ASSESSMENT
Objective:
-- Determine whether either product category column contains suspicious placeholder values such as unknown, undefined, not_defined, n/a, or null.
SQL Query:
SELECT
    product_category_name,
    product_category_name_english
FROM product_category_name_translation
WHERE LOWER(TRIM(product_category_name)) IN (
    'unknown',
    'undefined',
    'not_defined',
    'n/a',
    'na',
    'null'
)
OR LOWER(TRIM(product_category_name_english)) IN (
    'unknown',
    'undefined',
    'not_defined',
    'n/a',
    'na',
    'null'
);
Observation:
-- The query returned an empty result.
-- This indicates that no suspicious placeholder values were identified in either product category column.
Conclusion:
-- No suspicious placeholder category values were identified in the product_category_name_translation table.

9.4 ENGLISH PRODUCT CATEGORY CHARACTER VALIDATION
Objective:
-- Determine whether any English product category values contain no alphabetic characters and may therefore represent invalid category values.
SQL Query:
SELECT
    product_category_name,
    product_category_name_english
FROM product_category_name_translation
WHERE product_category_name_english NOT REGEXP '[A-Za-z]';
Observation:
-- The query returned an empty result.
-- This indicates that all product_category_name_english values contain at least one alphabetic character.
Conclusion:
-- No English product category values consisting entirely of non-alphabetic characters were identified.

9.5 OVERALL INVALID VALUE ASSESSMENT
Objective:
-- Summarize the invalid value findings identified in the product_category_name_translation table.
Observation:
-- No empty or whitespace-only values were identified in product_category_name.
-- No empty or whitespace-only values were identified in product_category_name_english.
-- No suspicious placeholder values such as unknown, undefined, not_defined, n/a, or null were identified in either category column.
-- No English product category values consisting entirely of non-alphabetic characters were identified.
Conclusion:
-- The product_category_name_translation table contains no identified invalid values across the assessed category fields.
-- The assessed product category values are populated and do not contain suspicious placeholder values or structurally invalid English category values.
-- Therefore, no invalid value treatment is required for the assessed fields at this stage of the Data Quality Assessment.
-- Cross-table category mapping issues, such as product categories in olist_products_dataset without corresponding translation
-- records, are assessed separately under reference-data and cross-table consistency assessments.
