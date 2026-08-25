Table 1: olist_customers_dataset
Categorical Consistency Assessment

1.1 CUSTOMER STATE CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether customer_state values are consistently represented using the expected Brazilian state and federal district abbreviations.
SQL Query:
SELECT
    customer_state,
    COUNT(*) AS occurrence_count
FROM olist_customers_dataset
GROUP BY customer_state
ORDER BY occurrence_count DESC;
Observation:
-- The query returned 27 distinct customer_state values.
-- The observed values represent the 26 Brazilian states and the Federal District, using consistent two-character abbreviations.
-- No alternative categorical representations were identified.
Conclusion:
-- customer_state demonstrates categorical consistency, with all observed values represented using the expected two-character
-- Brazilian state and federal district abbreviations.

1.2 INVALID CUSTOMER STATE VALUES
Objective:
-- Determine whether customer_state contains values outside the expected set of Brazilian state and federal district abbreviations.
SQL Query:
SELECT
    customer_state,
    COUNT(*) AS occurrence_count
FROM olist_customers_dataset
WHERE customer_state NOT IN (
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF',
    'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA',
    'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS',
    'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
)
GROUP BY customer_state
ORDER BY occurrence_count DESC;

Observation:
-- The query returned 0 invalid customer state values.
-- This indicates that no customer_state values were identified outside the expected set of Brazilian state and federal district abbreviations.
Conclusion:
-- customer_state passes the assessed categorical domain validation,
-- with no invalid state or federal district abbreviations identified.

1.3 CUSTOMER STATE WHITESPACE CONSISTENCY ASSESSMENT
Objective:
-- Determine whether customer_state contains leading or trailing whitespace that could result in categorical inconsistencies.
SQL Query:
SELECT
    customer_state,
    COUNT(*) AS occurrence_count
FROM olist_customers_dataset
WHERE customer_state <> TRIM(customer_state)
GROUP BY customer_state;
Observation:
-- The query returned 0 rows.
-- This indicates that no customer_state values were identified with leading or trailing whitespace.
Conclusion:
-- customer_state passes the assessed whitespace consistency validation, with no leading or trailing whitespace identified.

1.4 BLANK CUSTOMER STATE VALUES
Objective:
-- Determine whether customer_state contains blank or empty values that could affect categorical consistency.
SQL Query:
SELECT
    COUNT(*) AS blank_customer_states
FROM olist_customers_dataset
WHERE TRIM(customer_state) = '';
Observation:
-- The query returned a count of 0 blank customer_state values.
-- This indicates that no blank or empty customer_state values were identified in the dataset.
Conclusion:
-- customer_state passes the assessed blank-value validation, with no blank or empty categorical values identified.

1.5 OVERALL CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Summarize the categorical consistency assessment findings for the olist_customers_dataset table.
Observation:
-- The assessment confirmed that customer_state contains 27 distinct categorical values representing the 26 Brazilian states and the Federal District.
-- No invalid customer_state values were identified outside the expected categorical domain.
-- No leading or trailing whitespace was identified.
-- No blank or empty customer_state values were identified.

Conclusion:
-- The customer_state column demonstrates categorical consistency across the assessed values.
-- No invalid categories, whitespace inconsistencies, or blank categorical values were identified during the assessment.
-- Therefore, no categorical consistency treatment or cleaning is required for the olist_customers_dataset table at this stage of the Data Quality Assessment.

Table 2: olist_geolocation_dataset
Categorical Consistency Assessment
2.1 GEOLOCATION STATE CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether geolocation_state values are consistently represented using the expected Brazilian state and federal district abbreviations.
SQL Query:
SELECT
    geolocation_state,
    COUNT(*) AS occurrence_count
FROM olist_geolocation_dataset
GROUP BY geolocation_state
ORDER BY occurrence_count DESC;
Observation:
-- The query returned 27 distinct geolocation_state values.
-- The observed values represent the 26 Brazilian states and the Federal District, using consistent two-character abbreviations.
-- No alternative categorical representations were identified.
Conclusion:
-- geolocation_state demonstrates categorical consistency, with all observed values represented using the expected two-character
-- Brazilian state and federal district abbreviations.

2.2 INVALID GEOLOCATION STATE VALUES
Objective:
-- Determine whether geolocation_state contains values outside the  expected set of Brazilian state and federal district abbreviations.
SQL Query:
SELECT
    geolocation_state,
    COUNT(*) AS occurrence_count
FROM olist_geolocation_dataset
WHERE geolocation_state NOT IN (
    'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF',
    'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA',
    'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS',
    'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
)
GROUP BY geolocation_state
ORDER BY occurrence_count DESC;
Observation:
-- The query returned 0 invalid geolocation state values.
-- This indicates that no geolocation_state values were identified outside the expected set of Brazilian state and federal district abbreviations.
Conclusion:
-- geolocation_state passes the assessed categorical domain validation, with no invalid state or federal district abbreviations identified.

2.3 GEOLOCATION STATE WHITESPACE CONSISTENCY ASSESSMENT
Objective:
-- Determine whether geolocation_state contains leading or trailing whitespace that could result in categorical inconsistencies.
SQL Query:
SELECT
    geolocation_state,
    COUNT(*) AS occurrence_count
FROM olist_geolocation_dataset
WHERE geolocation_state <> TRIM(geolocation_state)
GROUP BY geolocation_state;

Observation:
-- The query returned 0 rows.
-- This indicates that no geolocation_state values were identified with leading or trailing whitespace.
Conclusion:
-- geolocation_state passes the assessed whitespace consistency validation, with no leading or trailing whitespace identified.

2.4 BLANK GEOLOCATION STATE VALUES
Objective:
-- Determine whether geolocation_state contains blank or empty values that could affect categorical consistency.
SQL Query:
SELECT
    COUNT(*) AS blank_geolocation_states
FROM olist_geolocation_dataset
WHERE TRIM(geolocation_state) = '';
Observation:
-- The query returned a count of 0 blank geolocation_state values.
-- This indicates that no blank or empty geolocation_state values were identified in the dataset.
Conclusion:
-- geolocation_state passes the assessed blank-value validation, with no blank or empty categorical values identified.

2.5 OVERALL CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Summarize the categorical consistency assessment findings for the olist_geolocation_dataset table.
Observation:
-- The assessment confirmed that geolocation_state contains 27 distinct categorical values representing the 26 Brazilian states and the Federal District.
-- No invalid geolocation_state values were identified outside the expected categorical domain.
-- No leading or trailing whitespace was identified.
-- No blank or empty geolocation_state values were identified.
Conclusion:
-- The geolocation_state column demonstrates categorical consistency across the assessed values.
-- No invalid categories, whitespace inconsistencies, or blank categorical values were identified during the assessment.
-- Therefore, no categorical consistency treatment or cleaning is required for the olist_geolocation_dataset table at this stage of the Data Quality Assessment.

Table 3: olist_order_items_dataset
Categorical Consistency Assessment

3.1 CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether olist_order_items_dataset contains any categorical
-- attributes requiring categorical consistency assessment.
Observation:
-- The table contains identifier columns (order_id, order_item_id, product_id,
-- and seller_id), a date/time column (shipping_limit_date), and numeric columns (price and freight_value).
-- No categorical attributes were identified in the table.
Conclusion:
-- Categorical consistency assessment is not applicable to the olist_order_items_dataset table because it contains no categorical
-- attributes requiring domain or representation validation.

Table 4: olist_order_payments_dataset
Categorical Consistency Assessment
4.1 PAYMENT TYPE CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether payment_type values are consistently represented using the expected payment method categories.
SQL Query:
SELECT
    payment_type,
    COUNT(*) AS occurrence_count
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY occurrence_count DESC;
Observation:
The query returned 5 distinct payment_type categories:
-- credit_card, boleto, voucher, debit_card, and not_defined.
-- The observed values are consistently represented using the expected categorical labels.
-- not_defined occurs 3 times and represents a defined category present in the source dataset rather than an alternative representation.
Conclusion:
-- payment_type demonstrates categorical consistency, with all observed values represented using the expected payment method categories.

4.2 INVALID PAYMENT TYPE VALUES
Objective:
-- Determine whether payment_type contains values outside the expected set of payment method categories.
SQL Query:
SELECT
    payment_type,
    COUNT(*) AS occurrence_count
FROM olist_order_payments_dataset
WHERE payment_type NOT IN (
    'credit_card',
    'boleto',
    'voucher',
    'debit_card',
    'not_defined'
)
GROUP BY payment_type
ORDER BY occurrence_count DESC;
Observation:
-- The query returned 0 invalid payment_type values.
-- This indicates that no payment_type values were identified outside the expected set of payment method categories.
Conclusion:
-- payment_type passes the assessed categorical domain validation, with no invalid payment method categories identified.

4.3 PAYMENT TYPE WHITESPACE CONSISTENCY ASSESSMENT
Objective:
-- Determine whether payment_type contains leading or trailing whitespace that could result in categorical inconsistencies.
SQL Query:
SELECT
    payment_type,
    COUNT(*) AS occurrence_count
FROM olist_order_payments_dataset
WHERE payment_type <> TRIM(payment_type)
GROUP BY payment_type;
Observation:
-- The query returned 0 rows.
-- This indicates that no payment_type values were identified with leading or trailing whitespace.
Conclusion:
-- payment_type passes the assessed whitespace consistency validation, with no leading or trailing whitespace identified.

4.4 BLANK PAYMENT TYPE VALUES
Objective:
-- Determine whether payment_type contains blank or empty values that could affect categorical consistency.
SQL Query:
SELECT
    COUNT(*) AS blank_payment_types
FROM olist_order_payments_dataset
WHERE TRIM(payment_type) = '';
Observation:
-- The query returned a count of 0 blank payment_type values.
-- This indicates that no blank or empty payment_type values were identified in the dataset.
Conclusion:
-- payment_type passes the assessed blank-value validation, with no blank or empty categorical values identified.

4.5 OVERALL CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Summarize the categorical consistency assessment findings for the olist_order_payments_dataset table.
Observation:
-- The assessment confirmed that payment_type contains 5 distinct categorical values: credit_card, boleto, voucher, debit_card, and not_defined.
-- No invalid payment_type values were identified outside the expected categorical domain.
-- No leading or trailing whitespace was identified.
-- No blank or empty payment_type values were identified.
Conclusion:
-- The payment_type column demonstrates categorical consistency across the assessed values.
-- No invalid categories, whitespace inconsistencies, or blank categorical values were identified during the assessment.
-- Therefore, no categorical consistency treatment or cleaning is required for the olist_order_payments_dataset table at this stage of the Data Quality Assessment.

Table 5: olist_order_reviews_dataset
Categorical Consistency Assessment

5.1 REVIEW SCORE CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether review_score values are consistently represented using the expected review rating categories from 1 to 5.
SQL Query:
SELECT
    review_score,
    COUNT(*) AS occurrence_count
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;
Observation:
-- The query returned 5 distinct review_score values: 1, 2, 3, 4, and 5.
-- These values represent the expected ordered review rating categories, where 1 represents the lowest rating and 5 represents the highest rating.
Conclusion:
-- review_score demonstrates categorical consistency, with all observed values represented using the expected 1-to-5 review rating categories.

5.2 INVALID REVIEW SCORE VALUES
Objective:
-- Determine whether review_score contains values outside the expected review rating range of 1 to 5.
SQL Query:
SELECT
    review_score,
    COUNT(*) AS occurrence_count
FROM olist_order_reviews_dataset
WHERE review_score NOT IN (1, 2, 3, 4, 5)
GROUP BY review_score
ORDER BY review_score;
Observation:
-- The query returned 0 invalid review_score values.
-- This indicates that no review_score values were identified outside the expected rating categories of 1 to 5.
Conclusion:
-- review_score passes the assessed categorical domain validation, with no invalid review rating values identified.

5.3 NULL REVIEW SCORE VALUES
Objective:
-- Determine whether review_score contains NULL values that could affect categorical consistency and completeness.
SQL Query:
SELECT
    COUNT(*) AS null_review_scores
FROM olist_order_reviews_dataset
WHERE review_score IS NULL;
Observation:
-- The query returned a count of 0 NULL review_score values.
-- This indicates that no missing review_score values were identified in the dataset.
Conclusion:
-- review_score passes the assessed NULL-value validation, with no missing review rating values identified.

5.4 OVERALL CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Summarize the categorical consistency assessment findings for the olist_order_reviews_dataset table.
Observation:
-- The assessment confirmed that review_score contains 5 distinct categorical values: 1, 2, 3, 4, and 5.
-- No invalid review_score values were identified outside the expected rating categories.
-- No NULL review_score values were identified.
Conclusion:
-- The review_score column demonstrates categorical consistency across the assessed values.
-- No invalid categories or missing review rating values were identified during the assessment.
--
-- Therefore, no categorical consistency treatment or cleaning is
-- required for the olist_order_reviews_dataset table at this stage
-- of the Data Quality Assessment.

Table 6: olist_orders_dataset
Categorical Consistency Assessment

6.1 ORDER STATUS CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether order_status values are consistently represented using the expected order status categories.
SQL Query:
SELECT
    order_status,
    COUNT(*) AS occurrence_count
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY occurrence_count DESC;
Observation:
The query returned 8 distinct order_status categories:
-- delivered, shipped, canceled, unavailable, invoiced, processing, created, and approved.
-- The observed values are consistently represented using the expected order status labels.
-- No alternative categorical representations were identified.
Conclusion:
-- order_status demonstrates categorical consistency, with all observed values represented using the expected order status categories.

6.2 INVALID ORDER STATUS VALUES
Objective:
-- Determine whether order_status contains values outside the expected set of order status categories.
SQL Query:
SELECT
    order_status,
    COUNT(*) AS occurrence_count
FROM olist_orders_dataset
WHERE order_status NOT IN (
    'delivered',
    'shipped',
    'canceled',
    'unavailable',
    'invoiced',
    'processing',
    'created',
    'approved'
)
GROUP BY order_status
ORDER BY occurrence_count DESC;
Observation:
-- The query returned 0 invalid order_status values.
-- This indicates that no order_status values were identified outside the expected set of order status categories.
Conclusion:
-- order_status passes the assessed categorical domain validation, with no invalid order status categories identified.

6.3 ORDER STATUS WHITESPACE CONSISTENCY ASSESSMENT
Objective:
-- Determine whether order_status contains leading or trailing whitespace that could result in categorical inconsistencies.
SQL Query:
SELECT
    order_status,
    COUNT(*) AS occurrence_count
FROM olist_orders_dataset
WHERE order_status <> TRIM(order_status)
GROUP BY order_status;
Observation:
-- The query returned 0 rows.
-- This indicates that no order_status values were identified with leading or trailing whitespace.
Conclusion:
-- order_status passes the assessed whitespace consistency validation, with no leading or trailing whitespace identified.

6.4 BLANK ORDER STATUS VALUES
Objective:
-- Determine whether order_status contains blank or empty values that could affect categorical consistency.
SQL Query:
SELECT
    COUNT(*) AS blank_order_statuses
FROM olist_orders_dataset
WHERE TRIM(order_status) = '';
Observation:
-- The query returned a count of 0 blank order_status values.
-- This indicates that no blank or empty order_status values were identified in the dataset.
Conclusion:
-- order_status passes the assessed blank-value validation, with no blank or empty categorical values identified.

6.5 OVERALL CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Summarize the categorical consistency assessment findings for the olist_orders_dataset table.
Observation:
-- The assessment confirmed that order_status contains 8 distinct categorical values:
-- delivered, shipped, canceled, unavailable, invoiced, processing, created, and approved.
-- No invalid order_status values were identified outside the expected categorical domain.
-- No leading or trailing whitespace was identified.
-- No blank or empty order_status values were identified.
Conclusion:
-- The order_status column demonstrates categorical consistency across the assessed values.
-- No invalid categories, whitespace inconsistencies, or blank categorical values were identified during the assessment.
-- Therefore, no categorical consistency treatment or cleaning is required for the olist_orders_dataset table at this stage of the Data Quality Assessment.

Table 7: olist_products_dataset
Categorical Consistency Assessment

7.1 PRODUCT CATEGORY NAME CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether product_category_name values are consistently represented using distinct product category labels.
SQL Query:
SELECT
    product_category_name,
    COUNT(*) AS occurrence_count
FROM olist_products_dataset
GROUP BY product_category_name
ORDER BY occurrence_count DESC;
Observation:
-- The query returned multiple distinct product category values.
-- The observed non-blank values are represented using consistent categorical labels within the dataset.
-- A blank category value was also identified with an occurrence count of 1,220.
Conclusion:
-- product_category_name demonstrates generally consistent categorical representation among the observed non-blank category values.
-- However, blank categorical values were identified and require further treatment.

7.2 INVALID PRODUCT CATEGORY VALUES
Objective:
-- Determine whether product_category_name contains values that are not represented as valid categorical values within the dataset.
SQL Query:
SELECT
    product_category_name,
    COUNT(*) AS occurrence_count
FROM olist_products_dataset
WHERE product_category_name IS NOT NULL
  AND TRIM(product_category_name) <> ''
GROUP BY product_category_name
ORDER BY occurrence_count DESC;
Observation:
-- The query returned the observed non-blank product category values.
-- No categorical value was identified as an invalid representation based solely on the categorical values stored in the dataset.
-- Categories such as pc_gamer and portateis_cozinha_e_preparadores_de_alimentos are present as
-- source categories and are therefore not treated as invalid values in this assessment.
Conclusion:
-- No invalid non-blank product category representations were identified during the categorical domain assessment.

7.3 PRODUCT CATEGORY NAME WHITESPACE CONSISTENCY ASSESSMENT
Objective:
-- Determine whether product_category_name contains leading or trailing whitespace that could result in categorical inconsistencies.
SQL Query:
SELECT
    product_category_name,
    COUNT(*) AS occurrence_count
FROM olist_products_dataset
WHERE product_category_name <> TRIM(product_category_name)
GROUP BY product_category_name
ORDER BY occurrence_count DESC;
Observation:
-- The query returned 0 rows.
-- This indicates that no product_category_name values were identified with leading or trailing whitespace.
Conclusion:
-- product_category_name passes the assessed whitespace consistency validation, with no leading or trailing whitespace identified.

7.4 BLANK PRODUCT CATEGORY VALUES
Objective:
-- Determine whether product_category_name contains blank or empty values that could affect categorical consistency.
SQL Query:
SELECT
    COUNT(*) AS blank_product_categories
FROM olist_products_dataset
WHERE TRIM(product_category_name) = '';
Observation:
-- The query returned a count of 1,220 blank product_category_name values.
-- This indicates that 1,220 product records contain blank or empty categorical values.
Conclusion:
-- product_category_name does not fully pass the assessed blank-value validation because 1,220 blank categorical values were identified.
-- These records require further data treatment or investigation before the categorical field can be considered complete.

7.5 OVERALL CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Summarize the categorical consistency assessment findings for the olist_products_dataset table.
Observation:
-- The assessment identified multiple product category values that are consistently represented among the non-blank records.
-- No invalid non-blank categorical representations were identified during the assessment.
-- No leading or trailing whitespace was identified.
-- However, 1,220 blank product_category_name values were identified.
Conclusion:
-- The product_category_name column demonstrates consistent categorical representation among its non-blank values.
-- However, the presence of 1,220 blank categorical values represents a categorical completeness and consistency issue.
-- Therefore, further treatment or investigation is required for the blank product_category_name values before the column can be considered
-- fully consistent at this stage of the Data Quality Assessment.

Table 8: olist_sellers_dataset
Categorical Consistency Assessment
8.1 SELLER STATE CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether seller_state values are consistently represented using valid Brazilian state and federal district abbreviations.
SQL Query:
SELECT
    seller_state,
    COUNT(*) AS occurrence_count
FROM olist_sellers_dataset
GROUP BY seller_state
ORDER BY occurrence_count DESC;
Observation:
-- The query returned 23 distinct seller_state values.
-- The observed values represent valid Brazilian state and federal district abbreviations using consistent two-character codes.
-- The absence of four possible state or federal district codes does not indicate a categorical inconsistency, as the dataset does not
-- require sellers to be represented in every Brazilian state or federal district.

Conclusion:
-- seller_state demonstrates categorical consistency, with all observed values represented using valid two-character Brazilian state and
-- federal district abbreviations.

8.2 INVALID SELLER STATE VALUES
Objective:
-- Determine whether seller_state contains values outside the expected set of Brazilian state and federal district abbreviations.
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
-- The query returned 0 invalid seller_state values.
-- This indicates that no seller_state values were identified outside the expected set of Brazilian state and federal district abbreviations.
Conclusion:
-- seller_state passes the assessed categorical domain validation, with no invalid state or federal district abbreviations identified.

8.3 SELLER STATE WHITESPACE CONSISTENCY ASSESSMENT
Objective:
-- Determine whether seller_state contains leading or trailing whitespace that could result in categorical inconsistencies.
SQL Query:
SELECT
    seller_state,
    COUNT(*) AS occurrence_count
FROM olist_sellers_dataset
WHERE seller_state <> TRIM(seller_state)
GROUP BY seller_state;
Observation:
-- The query returned 0 rows.
-- This indicates that no seller_state values were identified with leading or trailing whitespace.
Conclusion:
-- seller_state passes the assessed whitespace consistency validation, with no leading or trailing whitespace identified.

8.4 BLANK SELLER STATE VALUES
Objective:
-- Determine whether seller_state contains blank or empty values that could affect categorical consistency.
SQL Query:
SELECT
    COUNT(*) AS blank_seller_states
FROM olist_sellers_dataset
WHERE TRIM(seller_state) = '';
Observation:
-- The query returned a count of 0 blank seller_state values.
-- This indicates that no blank or empty seller_state values were identified in the dataset.
Conclusion:
-- seller_state passes the assessed blank-value validation, with no blank or empty categorical values identified.

Table 9: product_category_name_translation
Categorical Consistency Assessment
9.1 PRODUCT CATEGORY NAME CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether product_category_name values are consistently represented within the product category translation mapping.
SQL Query:
SELECT
    product_category_name,
    COUNT(*) AS occurrence_count
FROM product_category_name_translation
GROUP BY product_category_name
ORDER BY occurrence_count DESC;
Observation:
-- Each observed product_category_name value occurred exactly once.
-- This indicates that each Portuguese product category is represented as a single categorical entry within the translation table.
-- No duplicate Portuguese category representations were identified.
Conclusion:
-- product_category_name demonstrates categorical consistency within the translation table, with each observed category represented once.

9.2 PRODUCT CATEGORY NAME ENGLISH CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Determine whether product_category_name_english values are consistently represented within the product category translation mapping.
SQL Query:
SELECT
    product_category_name_english,
    COUNT(*) AS occurrence_count
FROM product_category_name_translation
GROUP BY product_category_name_english
ORDER BY occurrence_count DESC;
Observation:
-- Each observed product_category_name_english value occurred exactly once.
-- This indicates that each English product category is represented as a single categorical entry within the translation table.
-- No duplicate English category representations were identified.
Conclusion:
-- product_category_name_english demonstrates categorical consistency within the translation table, with each observed English category represented once.

9.3 DUPLICATE PORTUGUESE CATEGORY MAPPINGS
Objective:
-- Determine whether any Portuguese product category is associated with more than one English translation.
SQL Query:
SELECT
    product_category_name,
    COUNT(*) AS mapping_count
FROM product_category_name_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1
ORDER BY mapping_count DESC;
Observation:
-- The query returned 0 duplicate Portuguese category mappings.
-- This indicates that no product_category_name values were associated with multiple English translations.
Conclusion:
-- The Portuguese-to-English category mapping passes the assessed uniqueness validation, with no duplicate Portuguese category mappings identified.

9.4 DUPLICATE ENGLISH CATEGORY MAPPINGS
Objective:
-- Determine whether any English product category is associated with more than one Portuguese category.
SQL Query:
SELECT
    product_category_name_english,
    COUNT(*) AS mapping_count
FROM product_category_name_translation
GROUP BY product_category_name_english
HAVING COUNT(*) > 1
ORDER BY mapping_count DESC;
Observation:
-- The query returned 0 duplicate English category mappings.
-- This indicates that no product_category_name_english values were associated with multiple Portuguese product categories.
Conclusion:
-- The English-to-Portuguese category mapping passes the assessed uniqueness validation, with no duplicate English category mappings identified.

9.5 BLANK PRODUCT CATEGORY TRANSLATION VALUES
Objective:
-- Determine whether product_category_name or product_category_name_english contains blank or empty categorical values that could affect the translation mapping.
SQL Query:
SELECT
    SUM(TRIM(product_category_name) = '') AS blank_portuguese_categories,
    SUM(TRIM(product_category_name_english) = '') AS blank_english_categories
FROM product_category_name_translation;
Observation:
-- The query returned 0 blank Portuguese product categories and 0 blank English product categories.
-- This indicates that no blank or empty categorical values were identified in either translation column.
Conclusion:
-- Both product_category_name and product_category_name_english pass the assessed blank-value validation, with no blank or empty categorical values identified.

9.6 OVERALL CATEGORICAL CONSISTENCY ASSESSMENT
Objective:
-- Summarize the categorical consistency assessment findings for the product_category_name_translation table.
Observation:
-- Each Portuguese product category appears once within the translation table.
-- Each English product category also appears once within the translation table.
-- No duplicate Portuguese-to-English mappings were identified.
-- No duplicate English-to-Portuguese mappings were identified.
-- No blank or empty values were identified in either product_category_name or product_category_name_english.
Conclusion:
-- The product_category_name_translation table demonstrates categorical consistency across both translation columns.
-- The assessment identified no duplicate mappings, blank values,or categorical representation issues.
-- Therefore, no categorical consistency treatment or cleaning is required for the product_category_name_translation table
-- at this stage of the Data Quality Assessment.
