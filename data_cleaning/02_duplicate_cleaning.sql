FILE: 02_duplicate_cleaning.sql
PROJECT: Olist E-Commerce Data Analysis
PHASE: Data Cleaning
TOPIC: Duplicate Record Cleaning

OBJECTIVE
Remove confirmed redundant duplicate records from the Olist dataset while preserving the original/raw tables.

CLEANING PRINCIPLE
1. Never modify the original/raw tables directly.
2. Clean only duplicates that were confirmed during the duplicate assessment.
3. Create separate cleaned tables.
4. Validate the cleaned tables after each cleaning operation.
5. Do not treat repeated values in individual columns as duplicates unless the complete record or appropriate identifier confirms duplication.

TABLES REQUIRING DUPLICATE CLEANING
1. olist_geolocation_dataset
2. olist_products_dataset

TABLES ASSESSED BUT NOT REQUIRING DUPLICATE CLEANING
- olist_orders_dataset
- olist_order_payments_dataset
- olist_order_reviews_dataset
- olist_order_items_dataset
- olist_sellers_dataset
- product_category_name_translation

SECTION 1: GEOLOCATION DUPLICATE CLEANING
OBJECTIVE
Remove exact duplicate geolocation records while retaining one copy of each unique complete record.

ASSESSMENT RESULT
The duplicate assessment identified:
- Original rows: 1,000,163
- Unique complete records: 720,496
- Redundant duplicate rows: 279,667
Repeated geolocation_zip_code_prefix values were not treated as duplicates because a ZIP code prefix can legitimately correspond to multiple coordinates,
cities, or locations.

CLEANING METHOD
SELECT DISTINCT is used across all columns to retain one copy of each unique complete geolocation record.

--CREATE TABLE olist_geolocation_clean AS
--SELECT DISTINCT
--geolocation_zip_code_prefix,
--geolocation_lat,
--geolocation_lng,
--geolocation_city,
--geolocation_state
--FROM olist_geolocation_dataset;

OBSERVATION
The table creation returned:
Rows affected: 720,496
Duplicates: 0
Warnings: 0
This indicates that 720,496 unique complete geolocation records were retained.

VALIDATION 1: Confirm cleaned row count
--SELECT
--COUNT(*) AS cleaned_total_rows
--FROM olist_geolocation_clean;

OBSERVATION
Result:
cleaned_total_rows is 720,496

VALIDATION 2: Confirm no exact duplicate records remain
--SELECT
--geolocation_zip_code_prefix,
--geolocation_lat,
--geolocation_lng,
--geolocation_city,
--geolocation_state,
--COUNT(*) AS duplicate_count
FROM olist_geolocation_clean
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1;


/*
OBSERVATION
-----------
The query returned an empty result.

CONCLUSION
----------
No exact duplicate geolocation records remain in the cleaned table.
*/


/*
VALIDATION 3: Confirm the number of duplicate rows removed
*/

SELECT
    (SELECT COUNT(*) FROM olist_geolocation_dataset) AS original_rows,
    (SELECT COUNT(*) FROM olist_geolocation_clean) AS cleaned_rows,
    (SELECT COUNT(*) FROM olist_geolocation_dataset)
    - (SELECT COUNT(*) FROM olist_geolocation_clean) AS duplicate_rows_removed;


/*
OBSERVATION
-----------
Result:

original_rows | cleaned_rows | duplicate_rows_removed
--------------|--------------|----------------------
1,000,163     | 720,496      | 279,667

CONCLUSION
----------
279,667 redundant duplicate geolocation rows were removed while retaining
720,496 unique complete records.
*/


/*
VALIDATION 4: Final geolocation integrity check
*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT geolocation_zip_code_prefix) AS unique_zip_prefixes,
    COUNT(DISTINCT geolocation_lat) AS unique_latitudes,
    COUNT(DISTINCT geolocation_lng) AS unique_longitudes
FROM olist_geolocation_clean;


/*
OBSERVATION
-----------
Result:

total_rows | unique_zip_prefixes | unique_latitudes | unique_longitudes
-----------|---------------------|------------------|------------------
720,496    | 19,015              | 717,334          | 717,614

CONCLUSION
----------
The cleaned geolocation table contains 720,496 records.

The distinct counts for ZIP prefixes, latitudes, and longitudes do not need
to equal the total row count because different records can legitimately share
a ZIP prefix or coordinate value.
*/


/*
================================================================================
SECTION 2: PRODUCTS DUPLICATE CLEANING
================================================================================

OBJECTIVE
---------
Remove confirmed exact duplicate product records while preserving one copy
of each unique product record.

ASSESSMENT RESULT
-----------------
The duplicate assessment identified:

- Original rows: 65,902
- Unique product records: 32,951
- Redundant duplicate rows: 32,951

Every product_id appeared exactly twice in the original table, confirming that
the duplicate product records were redundant exact copies.

CLEANING METHOD
---------------
SELECT DISTINCT is used across all product columns to retain one copy of
each unique complete product record.
*/

CREATE TABLE olist_products_clean AS
SELECT DISTINCT
    product_id,
    product_category_name,
    product_name_length,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_products_dataset;


/*
OBSERVATION
-----------
The table creation returned:

Rows affected: 32,951
Duplicates: 0
Warnings: 0

This indicates that 32,951 unique complete product records were retained.
*/


/*
VALIDATION 1: Confirm cleaned row count
*/

SELECT
    COUNT(*) AS cleaned_total_rows
FROM olist_products_clean;


/*
OBSERVATION
-----------
Result:

cleaned_total_rows
------------------
32,951


VALIDATION 2: Confirm no exact duplicate records remain
*/

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
FROM olist_products_clean
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


/*
OBSERVATION
-----------
The query returned an empty result.

CONCLUSION
----------
No exact duplicate product records remain in the cleaned table.
*/


/*
VALIDATION 3: Confirm the number of duplicate rows removed
*/

SELECT
    (SELECT COUNT(*) FROM olist_products_dataset) AS original_rows,
    (SELECT COUNT(*) FROM olist_products_clean) AS cleaned_rows,
    (SELECT COUNT(*) FROM olist_products_dataset)
    - (SELECT COUNT(*) FROM olist_products_clean) AS duplicate_rows_removed;


/*
OBSERVATION
-----------
Result:

original_rows | cleaned_rows | duplicate_rows_removed
--------------|--------------|----------------------
65,902        | 32,951       | 32,951

CONCLUSION
----------
32,951 redundant duplicate product rows were removed while retaining
32,951 unique product records.
*/


/*
VALIDATION 4: Confirm every product_id is unique
*/

SELECT
    product_id,
    COUNT(*) AS product_count
FROM olist_products_clean
GROUP BY product_id
HAVING COUNT(*) > 1;


/*
OBSERVATION
-----------
The query returned an empty result.

CONCLUSION
----------
Every product_id is unique in the cleaned product table.
*/


/*
VALIDATION 5: Final product table integrity check
*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM olist_products_clean;


/*
OBSERVATION
-----------
Result:

total_rows | unique_product_ids
-----------|-------------------
32,951     | 32,951

CONCLUSION
----------
The cleaned product table contains 32,951 records and all 32,951 product IDs
are unique.
*/


/*
================================================================================
SECTION 3: TABLES NOT REQUIRING DUPLICATE CLEANING
================================================================================

The duplicate assessment found no confirmed redundant duplicate records
requiring cleaning in the following tables:

- olist_orders_dataset
- olist_order_payments_dataset
- olist_order_reviews_dataset
- olist_order_items_dataset
- olist_sellers_dataset
- product_category_name_translation

Repeated values found in some individual identifier columns were not
automatically treated as duplicates because they represent valid one-to-many
relationships or composite identifiers.

Examples include:

- Multiple payment records for one order
- Multiple items within one order
- Repeated order_item_id values across different orders
- Repeated review_id values associated with different orders
- Multiple geolocation records sharing the same ZIP code prefix
*/


/*
================================================================================
FINAL CONCLUSION
================================================================================

Duplicate cleaning was successfully completed for the two Olist tables where
redundant duplicate records were confirmed.

FINAL RESULTS
-------------

Table                         Original Rows   Cleaned Rows   Removed
---------------------------------------------------------------------------
olist_geolocation_dataset       1,000,163        720,496      279,667
olist_products_dataset             65,902         32,951       32,951
---------------------------------------------------------------------------

TOTAL                         1,066,065        753,447      312,618

Both cleaned tables were validated and confirmed to contain no remaining
exact duplicate records.

The original source tables were preserved, and separate cleaned tables were
created for downstream analysis.

DATA CLEANING STATUS
--------------------
Duplicate cleaning: COMPLETED

Next phase:
Proceed to the next relevant data-cleaning assessment based on the issues
identified in the Olist dataset.
================================================================================
*/
```

