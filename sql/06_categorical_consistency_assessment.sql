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
