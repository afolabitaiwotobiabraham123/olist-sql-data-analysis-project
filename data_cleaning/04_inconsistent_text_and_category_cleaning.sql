FILE: 04_inconsistent_text_and_category_cleaning.sql
PROJECT: Olist E-Commerce Data Analysis
PHASE: Data Cleaning
TOPIC: Inconsistent Text and Category Cleaning

OBJECTIVE
Standardize confirmed inconsistent text and categorical values identified during the categorical consistency assessment while preserving the original/raw tables.
The purpose of this phase is to ensure that values representing the same business concept are stored consistently and that blank or unavailable
categorical information is represented appropriately.

CLEANING PRINCIPLE
1. Never modify the original/raw tables directly.
2. Clean only values confirmed to be inconsistent or inappropriate for analysis.
3. Do not invent replacement values when the correct value cannot be known.
4. Standardize text and categorical values only when the intended standard representation is clear.
5. Represent genuinely unavailable categorical information as NULL rather than creating artificial categories.
6. Preserve valid business records even when some attributes are incomplete.
7. Do not change values that are already consistent.
8. Validate each cleaning operation after it is performed.
9. Do not perform unnecessary transformations simply because a column was included in the categorical consistency assessment.

CATEGORICAL CONSISTENCY ASSESSMENT SUMMARY
The categorical consistency assessment identified the following results:
1. olist_products_dataset.product_category_name
   - Blank/empty category representations were identified during assessment.
   - No invalid non-blank category representations were identified.
   - No leading/trailing whitespace issue was identified.
   - The affected category information required further treatment.
2. customer_state
   - No categorical inconsistency identified.
3. geolocation_state
   - No categorical inconsistency identified.
4. payment_type
   - No categorical inconsistency identified.
5. review_score
   - Categories were consistent within the valid 1-5 range.
6. order_status
   - No categorical inconsistency identified.
7. seller_state
   - No categorical inconsistency identified.
8. product_category_name_translation
   - No categorical inconsistency identified.
9. olist_order_items_dataset
   - No categorical columns requiring this assessment.

TABLES REQUIRING INCONSISTENT TEXT/CATEGORY CLEANING
1. olist_products_clean
TABLES ASSESSED BUT NOT REQUIRING INCONSISTENT TEXT/CATEGORY CLEANING
- olist_customers_dataset
- olist_geolocation_dataset
- olist_order_payments_clean
- olist_order_reviews_clean
- olist_orders_clean
- olist_sellers_dataset
- product_category_name_translation
- olist_order_items_dataset

SECTION 1: PRODUCT CATEGORY NAME

OBJECTIVE
Ensure that missing product category information is represented consistently and that no unsupported category values are introduced into the cleaned product table.

ASSESSMENT RESULT
The categorical consistency assessment identified blank/empty category representations in: olist_products_dataset.product_category_name
The assessment also confirmed:
- No invalid non-blank category representations.
- No leading/trailing whitespace issue.
- No evidence of multiple conflicting category representations requiring standardization.
Further investigation was therefore performed before deciding how the missing category values should be treated.

INVESTIGATION: Confirm blank and NULL category values in the clean table
SQL QUERY :
SELECT
    COUNT(*) AS blank_category_values
FROM olist_products_clean
WHERE TRIM(product_category_name) = '';

OBSERVATION
Result:
blank_category_values - 0

CONCLUSION
The clean product table contains no blank or whitespace-only category values.
No text-standardization update is required for empty strings.

INVESTIGATION: Confirm NULL category values
SQL QUERY : 
SELECT
    COUNT(*) AS null_category_values
FROM olist_products_clean
WHERE product_category_name IS NULL;

OBSERVATION
Result:
null_category_values - 610
The cleaned product table contains 610 products with NULL category values.
These NULL values represent missing category information rather than inconsistent categorical representations.

INVESTIGATION: Determine whether the missing categories can be recovered
The affected product IDs were compared against the original product table to
determine whether another category value exists for the same product.
SQL QUERY : 
SELECT
    product_id,
    COUNT(DISTINCT TRIM(COALESCE(product_category_name, '')))
        AS distinct_category_values,
    GROUP_CONCAT(
        DISTINCT NULLIF(TRIM(product_category_name), '')
        ORDER BY product_category_name
        SEPARATOR ', '
    ) AS categories_found
FROM olist_products_dataset
WHERE product_id IN (
    SELECT product_id
    FROM olist_products_clean
    WHERE product_category_name IS NULL
)
GROUP BY product_id
HAVING COUNT(
    DISTINCT TRIM(COALESCE(product_category_name, ''))
) > 1;

OBSERVATION
The query returned an empty result.
No affected product was found with multiple distinct category representations.

CONCLUSION
There is no evidence of conflicting category values that can be resolved by choosing one standard category.

INVESTIGATION: Check whether any affected product has another valid category
SQL QUERY : 
SELECT
    COUNT(DISTINCT product_id) AS products_with_any_category
FROM olist_products_dataset
WHERE product_id IN (
    SELECT product_id
    FROM olist_products_clean
    WHERE product_category_name IS NULL
)
AND product_category_name IS NOT NULL
AND TRIM(product_category_name) <> '';

OBSERVATION
Result:
products_with_any_category - 0
None of the 610 products with NULL category values has another non-blank category value in the original product table.

CONCLUSION
The missing category values cannot be recovered from the original product table.
No category value should be guessed or manually assigned.

INVESTIGATION: Confirm whether the affected products appear in orders
SQL QUERY : 
SELECT
    COUNT(DISTINCT p.product_id) AS null_category_products_sold
FROM olist_products_clean AS p
INNER JOIN olist_order_items_dataset AS oi
    ON p.product_id = oi.product_id
WHERE p.product_category_name IS NULL;

OBSERVATION
Result:
null_category_products_sold - 610
All 610 products with NULL categories appear in the order-items table.

CONCLUSION
The affected products are valid business records with actual order activity.
Therefore, the products must not be deleted merely because their category information is missing.

INVESTIGATION: Determine the number of affected order-item records
SQL QUERY : 
SELECT
    COUNT(*) AS order_items_with_missing_category
FROM olist_order_items_dataset AS oi
INNER JOIN olist_products_clean AS p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NULL;

OBSERVATION
Result:
order_items_with_missing_category - 1,603
The 610 products with missing categories are associated with 1,603 order-item records.

INVESTIGATION: Determine the percentage of affected order-item records
SQL QUERY : 
SELECT
    COUNT(*) AS affected_order_items,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM olist_order_items_dataset),
        2
    ) AS affected_percentage
FROM olist_order_items_dataset AS oi
INNER JOIN olist_products_clean AS p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NULL;

OBSERVATION
Result:
affected_order_items | affected_percentage
---------------------|---------------------
1,603                | 1.42%
The affected records represent 1.42% of all order-item records.

INVESTIGATION: Determine the affected sales value
SQL QUERY : 
SELECT
    ROUND(SUM(oi.price), 2) AS affected_product_sales,
    ROUND(
        SUM(oi.price) * 100.0 /
        (SELECT SUM(price) FROM olist_order_items_dataset),
        2
    ) AS sales_percentage
FROM olist_order_items_dataset AS oi
INNER JOIN olist_products_clean AS p
    ON oi.product_id = p.product_id
WHERE p.product_category_name IS NULL;

OBSERVATION
Result:
affected_product_sales | sales_percentage
-----------------------|------------------
179,535.28             | 1.32%

CLEANING DECISION
The investigation established:
- 610 products have NULL category values.
- No affected product has another valid category value in the original product table.
- No conflicting category values were identified.
- All 610 affected products appear in order items.
- 1,603 order-item records are affected.
- The affected records represent 1.42% of all order-item records.
- The affected sales value is 179,535.28.
- The affected sales value represents 1.32% of total sales value.
Because the correct category cannot be determined from the available data, the NULL values are retained.
No artificial category such as:
- 'Unknown'
- 'Not Available'
- 'Other'
- 'Uncategorized'
is introduced.
This preserves the distinction between a genuinely known category and a category whose information is unavailable.

CLEANING ACTION
No UPDATE statement is required.
The clean table already contains:
- 0 blank/empty category values
- 610 NULL category values
Therefore, the missing category information is already represented consistently as NULL.

VALIDATION: Confirm final category consistency
SQL QUERY : 
SELECT
    SUM(
        product_category_name IS NOT NULL
        AND TRIM(product_category_name) = ''
    ) AS remaining_blank_categories,
    SUM(product_category_name IS NULL) AS null_categories
FROM olist_products_clean;

OBSERVATION
Expected result:
remaining_blank_categories | null_categories
---------------------------|----------------
0                          | 610

CONCLUSION
No blank or whitespace-only product category values remain in the clean product table.
The 610 genuinely unavailable category values remain represented as NULL.

SECTION 2: OTHER CATEGORICAL COLUMNS
The categorical consistency assessment found no confirmed inconsistencies requiring cleaning in the following columns/tables:
customer_state
No issue identified.
No transformation required.

geolocation_state
No issue identified.
No transformation required.

payment_type
No categorical inconsistency identified.
No transformation required.

review_score
Values were consistent within the valid 1-5 category range.
No transformation required.

order_status
No categorical inconsistency identified.
No transformation required.

seller_state
No issue identified.
No transformation required.

product_category_name_translation
No categorical inconsistency identified.
No transformation required.

olist_order_items_dataset
No categorical columns requiring this assessment.
No transformation required.

FINAL CONCLUSION
Inconsistent text and category cleaning was completed based on the categorical consistency assessment.
Only product_category_name required further investigation.

FINAL RESULTS
PRODUCT CATEGORY NAME
- 0 blank/whitespace-only category values remain in the clean table.
- 610 products have NULL category values.
- 0 affected products have another valid category value in the original product table.
- 0 conflicting category representations were identified.
- 610 affected products appear in actual orders.
- 1,603 order-item records are affected.
- Affected order-item records represent 1.42% of all order-item records.
- Affected sales value = 179,535.28.
- Affected sales value represents 1.32% of total sales value.
- No artificial category was introduced.
- NULL values were retained because the correct categories cannot be known.

OTHER CATEGORICAL COLUMNS
- customer_state: no issue
- geolocation_state: no issue
- payment_type: no issue
- review_score: no issue
- order_status: no issue
- seller_state: no issue
- product_category_name_translation: no issue
- order_items categorical fields: no issue requiring cleaning

IMPORTANT DATA-CLEANING PRINCIPLE
Not every missing value should be replaced, and not every unusual value should be changed.
Where a standard representation was clearly identifiable, standardization would be appropriate.
Where information is genuinely unavailable, NULL is retained rather than inventing a category.
Where no inconsistency exists, no transformation is performed.
No business records were deleted because of incomplete categorical information.
The original/raw tables remain unchanged, while the cleaned tables are used for downstream analysis.

DATA CLEANING STATUS
Inconsistent text and category cleaning: COMPLETED


