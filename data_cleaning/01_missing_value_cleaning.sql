01_MISSING_VALUE_CLEANING.SQL

Project:
Olist E-Commerce Data Analysis

Objective:
Handle missing values identified during the data quality assessment phase.

Source Assessment:
02_null_value_assessment.sql

Assessment Result:
No NULL values were identified across the assessed Olist datasets and columns.

Cleaning Decision:
No missing-value cleaning was required.

Cleaning Principle:
NULL values should only be replaced, removed, or otherwise transformed when there is a justified business or data-quality reason to do so.

SECTION 1: MISSING VALUE CLEANING
Finding:
The NULL value assessment returned 0 NULL values across all assessed tables.

Therefore:
No UPDATE, DELETE, COALESCE, or replacement operation is required for missing values.

The original data is preserved without modification.

SECTION 2: CLEANING VALIDATION
Objective:
Confirm that the source assessment found no NULL values requiring treatment.

Validation:
The results documented in 02_null_value_assessment.sql showed 0 NULL values across all assessed columns.

Conclusion:
No missing-value cleaning was necessary for the Olist dataset.

