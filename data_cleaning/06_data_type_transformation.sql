FILE: 06_data_type_transformation.sql
PROJECT: Olist E-Commerce Data Analysis
PHASE: Data Cleaning
TOPIC: Data Type Transformation

OBJECTIVE
Transform columns whose existing SQL data types are not appropriate for their business meaning, while preserving the underlying business values and all
previously completed data-cleaning decisions.
This phase focuses on DATA REPRESENTATION, not invalid-value cleaning.
The objective is to ensure that:
1. Sequence identifiers that represent numeric values use numeric data types.
2. Monetary values use fixed-precision DECIMAL data types instead of FLOAT.
3. Existing clean-table transformations from previous phases are preserved.
4. No records or meaningful business values are lost or changed.
5. The resulting clean tables are appropriate for downstream SQL analysis, Python/Pandas processing, and Power BI reporting.

IMPORTANT
Invalid values were already investigated and handled in:
03_invalid_value_cleaning.sql
Data-type evidence was established in:
05_data_type_assessment.sql
This phase does NOT repeat invalid-value cleaning.

SOURCE ASSESSMENT
Primary assessment reference:
05_data_type_assessment.sql
Supporting assessment:
04_invalid_value_assessment.sql

DATA-TYPE TRANSFORMATIONS IDENTIFIED
The data-type assessment identified the following transformations:
TABLE: olist_order_items_dataset
order_item_id - VARCHAR(32) -> INT
price - FLOAT -> DECIMAL(10,2)
freight_value - FLOAT -> DECIMAL(10,2)

TABLE: olist_order_payments_clean
payment_value - FLOAT -> DECIMAL(10,2)

WHY THESE TRANSFORMATIONS ARE REQUIRED
order_item_id - The column contains numeric item-sequence values but was stored as VARCHAR(32). A numeric data type is more appropriate for this field.
price - Price is a monetary field. FLOAT is not ideal for financial analysis because binary floating-point representation can introduce small precision artifacts.
DECIMAL(10,2) is more appropriate because monetary values are represented using fixed decimal precision.
freight_value - Freight cost is also a monetary field and should use fixed decimal precision.
payment_value - Payment value is a monetary field and should also use fixed decimal precision.
DECIMAL(10,2) provides two decimal places while providing substantially more range than required by the observed Olist values.

SECTION 1: ORDER_ITEM_ID INVESTIGATION

OBJECTIVE
Confirm that order_item_id contains only numeric values before converting it from VARCHAR(32) to INT.

QUERY 1: SAMPLE CONVERSION
SQL QUERY :
SELECT
    order_item_id,
    CAST(order_item_id AS UNSIGNED) AS order_item_id_converted
FROM olist_order_items_dataset
LIMIT 20;

OBSERVATION
The sampled values converted correctly.
Examples:
    1 -> 1
    2 -> 2
    3 -> 3
The displayed values remained unchanged after conversion.

QUERY 2: CHECK FOR NON-NUMERIC VALUES
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN order_item_id REGEXP '^[0-9]+$'
            THEN 0
            ELSE 1
        END
    ) AS non_numeric_records
FROM olist_order_items_dataset;

RESULT
total_records      = 112650
non_numeric_records = 0

DECISION
All 112,650 records contain numeric order_item_id values.
The earlier invalid-value assessment also confirmed that there were no order_item_id values <= 0.
Therefore:
    VARCHAR(32) -> INT is safe and justified.

SECTION 2: PRICE INVESTIGATION

OBJECTIVE
Determine whether FLOAT representation introduces apparent precision beyond two decimal places before converting price to DECIMAL(10,2).

QUERY 3: INITIAL PRECISION CHECK
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN price <> ROUND(price, 2)
            THEN 1
            ELSE 0
        END
    ) AS values_with_more_than_2_decimal_places
FROM olist_order_items_dataset;

RESULT
total_records = 112650
values_with_more_than_2_decimal_places = 76713

OBSERVATION
The initial result suggested that many values differed from their two-decimal rounded representation.
However, because price is stored as FLOAT, this does not automatically mean that the source values contain genuine monetary precision beyond two decimals.
FLOAT can introduce very small binary representation differences.
Therefore, the differences needed further investigation.

QUERY 4: INSPECT FLOAT DIFFERENCES
SQL QUERY : 
SELECT
    price,
    ROUND(price, 2) AS price_rounded,
    price - ROUND(price, 2) AS difference
FROM olist_order_items_dataset
WHERE price <> ROUND(price, 2)
LIMIT 20;

OBSERVATION
The sampled records showed values such as:
    58.90 -> 58.90
    239.90 -> 239.90
    12.99 -> 12.99
while the underlying FLOAT difference was extremely small.
Therefore, the apparent extra precision was primarily caused by FLOAT representation.

QUERY 5: CHECK FOR MEANINGFUL ROUNDING CHANGES
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN ROUND(price, 2) <> price
             AND ABS(price - ROUND(price, 2)) > 0.0001
            THEN 1
            ELSE 0
        END
    ) AS meaningful_rounding_changes
FROM olist_order_items_dataset;

RESULT
total_records = 112650
meaningful_rounding_changes = 8

QUERY 6: INVESTIGATE THE 8 RECORDS
SQL QUERY : 
SELECT
    order_id,
    order_item_id,
    price,
    ROUND(price, 2) AS price_rounded,
    price - ROUND(price, 2) AS difference
FROM olist_order_items_dataset
WHERE ABS(price - ROUND(price, 2)) > 0.0001
ORDER BY ABS(price - ROUND(price, 2)) DESC;

OBSERVATION
The eight records included values such as:
    4099.99 -> 4099.99
    4399.87 -> 4399.87
    2999.89 -> 2999.89
    2120.39 -> 2120.39
The differences were approximately:
    0.000234375
    0.0001171875
    0.000107421875
These differences are substantially smaller than one cent and do not represent meaningful changes to the monetary values.

DECISION
The values are suitable for conversion to DECIMAL(10,2).
No manual value correction is required.

Transformation: price FLOAT -> DECIMAL(10,2)

SECTION 3: FREIGHT_VALUE INVESTIGATION

OBJECTIVE
Determine whether freight_value contains meaningful precision beyond two decimal places.

QUERY 7: INITIAL PRECISION CHECK
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN freight_value <> ROUND(freight_value, 2)
            THEN 1
            ELSE 0
        END
    ) AS values_with_more_than_2_decimal_places
FROM olist_order_items_dataset;

RESULT
total_records = 112650
values_with_more_than_2_decimal_places = 108367

OBSERVATION
As with price, this large count does not mean the source values genuinely contain more than two decimal places.
The column is FLOAT, so FLOAT representation artifacts must be investigated.

QUERY 8: INSPECT FLOAT DIFFERENCES
SQL QUERY : 
SELECT
    order_id,
    order_item_id,
    freight_value,
    ROUND(freight_value, 2) AS freight_value_rounded,
    freight_value - ROUND(freight_value, 2) AS difference
FROM olist_order_items_dataset
WHERE freight_value <> ROUND(freight_value, 2)
LIMIT 20;

OBSERVATION
Examples included:
    13.29 -> 13.29
    19.93 -> 19.93
    17.87 -> 17.87
    12.79 -> 12.79
    18.14 -> 18.14
The differences were extremely small FLOAT representation artifacts.

QUERY 9: CHECK FOR MEANINGFUL ROUNDING CHANGES
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN ABS(freight_value - ROUND(freight_value, 2)) > 0.0001
            THEN 1
            ELSE 0
        END
    ) AS meaningful_rounding_changes
FROM olist_order_items_dataset;

RESULT
total_records = 112650
meaningful_rounding_changes = 0

DECISION
No meaningful monetary rounding changes exist.

Transformation: freight_value FLOAT -> DECIMAL(10,2)

SECTION 4: PAYMENT_VALUE INVESTIGATION

OBJECTIVE
Transform payment_value in the existing clean payment table without recreating the table or repeating Phase 03 cleaning.
The existing table already contains the results of invalid-value cleaning.

QUERY 10: INSPECT EXISTING CLEAN TABLE
SQL QUERY : 
DESCRIBE olist_order_payments_clean;

RESULT
order_id              VARCHAR(32)
payment_sequential    INT
payment_type          VARCHAR(32)
payment_installments  INT
payment_value         FLOAT

DECISION
The existing clean table is retained.
Only payment_value requires data-type transformation.

QUERY 11: INITIAL PRECISION CHECK
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN payment_value <> ROUND(payment_value, 2)
            THEN 1
            ELSE 0
        END
    ) AS values_with_more_than_2_decimal_places
FROM olist_order_payments_clean;

RESULT
total_records = 103886
values_with_more_than_2_decimal_places = 96499

OBSERVATION
The apparent precision differences required further investigation because payment_value is stored as FLOAT.

QUERY 12: INSPECT FLOAT DIFFERENCES
SQL QUERY : 
SELECT
    order_id,
    payment_value,
    ROUND(payment_value, 2) AS payment_value_rounded,
    payment_value - ROUND(payment_value, 2) AS difference
FROM olist_order_payments_clean
WHERE payment_value <> ROUND(payment_value, 2)
LIMIT 20;

OBSERVATION
Examples included:
    99.33 -> 99.33
    24.39 -> 24.39
    65.71 -> 65.71
    107.78 -> 107.78
    128.45 -> 128.45
The underlying differences were very small and consistent with FLOAT representation artifacts.

QUERY 13: MEANINGFUL DIFFERENCE CHECK
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN ABS(payment_value - ROUND(payment_value, 2)) > 0.0001
            THEN 1
            ELSE 0
        END
    ) AS meaningful_rounding_changes
FROM olist_order_payments_clean;

RESULT
total_records = 103886
meaningful_rounding_changes = 32

QUERY 14: INVESTIGATE THE 32 RECORDS
SQL QUERY : 
SELECT
    order_id,
    payment_sequential,
    payment_value,
    ROUND(payment_value, 2) AS payment_value_rounded,
    payment_value - ROUND(payment_value, 2) AS difference
FROM olist_order_payments_clean
WHERE ABS(payment_value - ROUND(payment_value, 2)) > 0.0001
ORDER BY ABS(payment_value - ROUND(payment_value, 2)) DESC;

OBSERVATION
All 32 records retained the same two-decimal monetary value after rounding.
Examples included:
    4175.26 -> 4175.26
    4163.51 -> 4163.51
    4681.78 -> 4681.78
    4513.32 -> 4513.32
Therefore, the differences are FLOAT representation artifacts rather than meaningful business-value changes.

QUERY 15: FINAL BUSINESS-VALUE SAFETY CHECK
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN ROUND(payment_value, 2)
                 <> CAST(payment_value AS DECIMAL(10,2))
            THEN 1
            ELSE 0
        END
    ) AS business_value_changes
FROM olist_order_payments_clean;

RESULT
total_records = 103886
business_value_changes = 0

DECISION
Converting payment_value to DECIMAL(10,2) will not change any business-level monetary value.

Transformation : payment_value FLOAT -> DECIMAL(10,2)

SECTION 5: CREATE ORDER ITEMS CLEAN TABLE

OBJECTIVE
Create the clean order-items table using the validated target data types.
First, confirm that the clean table does not already exist.

QUERY 16: CHECK FOR EXISTING CLEAN TABLE
SQL QUERY : 
SHOW TABLES LIKE 'olist_order_items_clean';

RESULT
0 rows returned.

DECISION
The clean table does not exist, so it is safe to create it.

QUERY 17: CONFIRM SOURCE ROW COUNT
SQL QUERY : 
SELECT COUNT(*) AS total_records
FROM olist_order_items_dataset;

RESULT
112650

QUERY 18: CREATE CLEAN TABLE
SQL QUERY : 
CREATE TABLE olist_order_items_clean (
    order_id VARCHAR(32),
    order_item_id INT,
    product_id VARCHAR(32),
    seller_id VARCHAR(32),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2)
);

RESULT
0 rows affected.
This is expected because the query creates an empty table.

QUERY 19: INSERT TRANSFORMED DATA
SQL QUERY : 
INSERT INTO olist_order_items_clean (
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    price,
    freight_value
)
SELECT
    order_id,
    CAST(order_item_id AS UNSIGNED),
    product_id,
    seller_id,
    shipping_limit_date,
    CAST(price AS DECIMAL(10,2)),
    CAST(freight_value AS DECIMAL(10,2))
FROM olist_order_items_dataset;

RESULT
Records inserted = 112650
Duplicates = 0
Warnings = 0

SECTION 6: VALIDATE ORDER ITEMS CLEAN TABLE

QUERY 20: CONFIRM DATA TYPES
SQL QUERY : 
DESCRIBE olist_order_items_clean;

RESULT
order_id            VARCHAR(32)
order_item_id       INT
product_id          VARCHAR(32)
seller_id           VARCHAR(32)
shipping_limit_date DATETIME
price               DECIMAL(10,2)
freight_value       DECIMAL(10,2)

DECISION
The target data types were successfully applied.

QUERY 21: COMPARE ROW COUNTS
SQL QUERY : 
SELECT
    (SELECT COUNT(*) FROM olist_order_items_dataset) AS raw_records,
    (SELECT COUNT(*) FROM olist_order_items_clean) AS clean_records;

RESULT
raw_records   = 112650
clean_records = 112650

DECISION
No records were lost during transformation.

QUERY 22: CHECK PRICE AND FREIGHT VALUE CHANGES
SQL QUERY : 
SELECT
    COUNT(*) AS records_with_value_changes
FROM olist_order_items_dataset AS r
JOIN olist_order_items_clean AS c
    ON r.order_id = c.order_id
    AND CAST(r.order_item_id AS UNSIGNED) = c.order_item_id
WHERE
    ABS(r.price - c.price) > 0.0001
    OR ABS(r.freight_value - c.freight_value) > 0.0001;

RESULT
records_with_value_changes = 8

OBSERVATION
The eight differences came from price only, not freight_value.
These are the same eight FLOAT representation artifacts already investigated.

QUERY 23: SEPARATE PRICE AND FREIGHT VALIDATION
SQL QUERY : 
SELECT
    SUM(
        CASE
            WHEN ABS(r.price - c.price) > 0.0001
            THEN 1
            ELSE 0
        END
    ) AS price_changes,

    SUM(
        CASE
            WHEN ABS(r.freight_value - c.freight_value) > 0.0001
            THEN 1
            ELSE 0
        END
    ) AS freight_value_changes
FROM olist_order_items_dataset AS r
JOIN olist_order_items_clean AS c
    ON r.order_id = c.order_id
    AND CAST(r.order_item_id AS UNSIGNED) = c.order_item_id;

RESULT
price_changes = 8
freight_value_changes = 0

DECISION
The eight price differences are FLOAT representation artifacts.
There are no meaningful freight_value changes.

QUERY 24: VALIDATE ORDER_ITEM_ID
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    SUM(
        CASE
            WHEN CAST(r.order_item_id AS UNSIGNED) <> c.order_item_id
            THEN 1
            ELSE 0
        END
    ) AS order_item_id_changes
FROM olist_order_items_dataset AS r
JOIN olist_order_items_clean AS c
    ON r.order_id = c.order_id
    AND CAST(r.order_item_id AS UNSIGNED) = c.order_item_id;

RESULT
total_records = 112650
order_item_id_changes = 0

DECISION
No order_item_id business values changed during transformation.

SECTION 7: MODIFY EXISTING PAYMENT CLEAN TABLE

OBJECTIVE
Modify the existing olist_order_payments_clean table without recreating it.
This preserves all cleaning decisions made during Phase 03.

QUERY 25: CONFIRM EXISTING STRUCTURE
SQL QUERY : 
DESCRIBE olist_order_payments_clean;

RESULT BEFORE TRANSFORMATION
payment_value = FLOAT

QUERY 26: MODIFY PAYMENT_VALUE
SQL QUERY : 
ALTER TABLE olist_order_payments_clean
MODIFY COLUMN payment_value DECIMAL(10,2);

RESULT
0 rows affected.
This is expected because ALTER TABLE changes the column definition rather than updating individual records.

QUERY 27: CONFIRM FINAL PAYMENT DATA TYPES
SQL QUERY : 
DESCRIBE olist_order_payments_clean;

RESULT
payment_value = DECIMAL(10,2)

SECTION 8: FINAL PAYMENT TABLE VALIDATION
  
QUERY 28: VALIDATE ROW COUNT AND EXISTING NULL VALUES
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END)
        AS null_payment_values,
    SUM(CASE WHEN payment_type IS NULL THEN 1 ELSE 0 END)
        AS null_payment_types,
    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END)
        AS null_payment_installments
FROM olist_order_payments_clean;

RESULT
total_records = 103886
null_payment_values = 0
null_payment_types = 3
null_payment_installments = 2

DECISION
The payment table retained all 103,886 records.
The three NULL payment_type values and two NULL payment_installments values are expected results from Phase 03 Invalid Value Cleaning.
They were not introduced by the data-type transformation.
The payment_value column contains no NULL values.

FINAL PHASE 06 SUMMARY
TRANSFORMATIONS COMPLETED
1. olist_order_items_clean.order_item_id
   BEFORE : VARCHAR(32)
   AFTER : INT
   JUSTIFICATION : All 112,650 values were numeric and the previous invalid-value assessment confirmed no values <= 0.
2. olist_order_items_clean.price
   BEFORE: FLOAT
   AFTER: DECIMAL(10,2)
   JUSTIFICATION: Monetary field requiring fixed decimal precision.
   The eight apparent differences identified during validation were FLOAT representation artifacts. The displayed two-decimal business values remained unchanged.
3. olist_order_items_clean.freight_value
   BEFORE: FLOAT
   AFTER: DECIMAL(10,2)
   JUSTIFICATION: Monetary field requiring fixed decimal precision.
   Meaningful rounding changes = 0.
4. olist_order_payments_clean.payment_value
   BEFORE: FLOAT
   AFTER: DECIMAL(10,2)
   JUSTIFICATION: Monetary field requiring fixed decimal precision.
   Business-value changes after conversion = 0.

FINAL VALIDATION
Order items:
    Raw records       = 112650
    Clean records     = 112650
    Order item changes = 0
    Freight changes    = 0
Payments:
    Clean records             = 103886
    NULL payment_value        = 0
    NULL payment_type         = 3
    NULL payment_installments = 2
The existing NULL values in payment_type and payment_installments were preserved from the previous cleaning phase.
  
FINAL DECISION
Phase 06 Data Type Transformation is COMPLETE.
The cleaned tables now use data types that better represent their business meaning and are suitable for downstream SQL analysis, Python/Pandas
processing, and Power BI reporting.
No additional numeric cleaning phase is required.
Numeric VALUE validation was already addressed through: 03_invalid_value_cleaning.sql
Numeric DATA TYPE transformation was addressed here through: 06_data_type_transformation.sql
