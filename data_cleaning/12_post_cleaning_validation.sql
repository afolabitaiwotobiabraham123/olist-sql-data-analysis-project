Olist E-commerce Data Analysis
Post-Cleaning Validation Documentation

1. Introduction
1.1 Objective
The purpose of post-cleaning validation was to determine whether the cleaning operations applied to the six Olist tables produced datasets, 
that satisfy the data-quality requirements established during the earlier assessment and cleaning stages.
The validation process examined record counts, identifier integrity, missing values, duplicates, invalid values, data formats, relationships between tables,
and suspicious business events. The objective was not to force every field to appear perfect. 
Where a value was suspicious but could not be conclusively identified as incorrect, the record was retained and the limitation documented.

1.2 Validation Scope
The six cleaned tables covered in this document are:
1. `olist_geolocation_clean`
2. `olist_order_items_clean`
3. `olist_order_payments_clean`
4. `olist_order_reviews_clean`
5. `olist_orders_clean`
6. `olist_products_clean`

1.3 Validation Approach
Each table was validated using the following workflow:
1. **Assessment:** Identify the quality dimension to be checked.
2. **Validation query:** Execute SQL against the cleaned table.
3. **Observation/result:** Record the actual result.
4. **Conclusion/decision:** Determine whether the check passed, further cleaning was required, or an anomaly should be preserved.
5. **Documentation:** Record the final condition of the table and any remaining limitations.

2. Geolocation Table Validation
Table: `olist_geolocation_clean`
2.1 Record Count Validation
Objective
To compare the raw and cleaned table sizes and verify that the reduction in records was consistent with the earlier deduplication stage.

SQL Query:
SELECT
    (SELECT COUNT(*)
     FROM olist_geolocation_dataset) AS raw_records,

    (SELECT COUNT(*)
     FROM olist_geolocation_clean) AS clean_records,

    (SELECT COUNT(*)
     FROM olist_geolocation_dataset)
    -
    (SELECT COUNT(*)
     FROM olist_geolocation_clean) AS record_difference;

Observation / Result
| Metric | Result |
|---|---:|
| Raw records | 1,000,163 |
| Clean records | 720,496 |
| Difference | 279,667 |

Conclusion / Decision
The cleaned table contains 279,667 fewer records than the raw table, consistent with the earlier deduplication process. 
The subsequent formatting corrections did not require further record deletion.

2.2 Postal-Code Prefix Validation
Objective
To ensure that postal-code prefixes are consistently represented as five-character values, including leading zeros.

SQL Query : 
SELECT
    COUNT(*) AS total_records,
    SUM(geolocation_zip_code_prefix IS NULL)
        AS missing_prefixes,
    SUM(
        CHAR_LENGTH(geolocation_zip_code_prefix) <> 5
    ) AS invalid_prefix_lengths,
    COUNT(DISTINCT geolocation_zip_code_prefix)
        AS distinct_prefixes
FROM olist_geolocation_clean;

Observation / Result

| Metric | Result |
|---|---:|
| Total records | 720,496 |
| Missing prefixes | 0 |
| Prefixes not five characters | 0 |
| Distinct prefixes | 19,015 |
The column was changed from an integer type to `CHAR(5)`, and 149,564 four-character values were padded with a leading zero. The update returned no warnings.

Conclusion / Decision
Postal-code formatting validation passed. All prefixes contain exactly five characters, and leading zeros are preserved.

2.3 Coordinate Completeness and Range Validation
Objective
To identify missing coordinates and latitude or longitude values outside legal global ranges.

SQL Query : 
SELECT
    COUNT(*) AS total_records,
    SUM(geolocation_lat IS NULL)
        AS missing_latitudes,
    SUM(geolocation_lng IS NULL)
        AS missing_longitudes,
    MIN(geolocation_lat) AS minimum_latitude,
    MAX(geolocation_lat) AS maximum_latitude,
    MIN(geolocation_lng) AS minimum_longitude,
    MAX(geolocation_lng) AS maximum_longitude,
    SUM(
        geolocation_lat < -90
        OR geolocation_lat > 90
        OR geolocation_lng < -180
        OR geolocation_lng > 180
    ) AS invalid_coordinate_pairs
FROM olist_geolocation_clean;

Observation / Result
| Metric | Result |
|---|---:|
| Missing latitudes | 0 |
| Missing longitudes | 0 |
| Minimum latitude | -36.60537441070610 |
| Maximum latitude | 45.06593318269697 |
| Minimum longitude | -101.46676644931476 |
| Maximum longitude | 121.10539381057764 |
| Invalid coordinate pairs | 0 |

Conclusion / Decision
Coordinate completeness and legal-range checks passed. 
However, valid global coordinate ranges do not independently prove that each coordinate corresponds to the correct geographic location.

2.4 Duplicate and Repeated Coordinate Validation
Objective
To confirm that exact duplicate records have been removed and distinguish them from records that legitimately share coordinates.

SQL Query : 
SELECT
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state,
    COUNT(*) AS record_count
FROM olist_geolocation_clean
GROUP BY
    geolocation_zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    geolocation_city,
    geolocation_state
HAVING COUNT(*) > 1;

Observation / Result
The query returned 0 rows.
A separate coordinate-pair check identified 718,463 distinct coordinate pairs and 2,033 repeated coordinate rows among 720,496 records.

Conclusion / Decision
No exact duplicate combinations remained across the five checked fields.
Repeated coordinates were retained because shared coordinates do not necessarily represent duplicate records.

2.5 City and State Quality Validation
Objective
To validate city/state completeness, state-code length, city-name whitespace, and case consistency.

Observation / Result
- Missing or blank city values: 0.
- Missing or blank state values: 0.
- State codes with a length other than two characters: 0.
- Distinct state codes: 27.
- City names with leading or trailing whitespace: 3 before cleaning, 0 after cleaning.
- City names inconsistent with lowercase formatting: 0.
Three city-name values were trimmed, affecting three records. The update returned no warnings.

Conclusion / Decision
City and state completeness checks passed. The whitespace correction was successful, and no additional case-normalization operation was necessary.

2.6 City-Name Variations
Objective
To investigate city names appearing in multiple states and differences in accent usage.

Observation / Result
Some city names appeared under multiple state codes, including `bom jesus` and `sao domingos`. The investigation also identified two stored variants:
| City name | Records |
|---|---:|
| `sao domingos` | 75 |
| `são domingos` | 12 |
| Total | 87 |

Conclusion / Decision
The variants were documented but not automatically standardized. Different municipalities can share names, and Portuguese accents can be meaningful.
Authoritative geographic verification would be needed before correcting potentially inaccurate city/state assignments.

Overall Table Conclusion
The geolocation table passed the principal structural and formatting checks. 
The remaining geographic uncertainties were documented rather than corrected without sufficient evidence.

3. Order Items Table Validation
Table: `olist_order_items_clean`
3.1 Record Count and Identifier Validation
Objective
To confirm that the cleaned table retained the expected number of order-item records and that the composite identifier `(order_id, order_item_id)` is unique.

SQL Query — Composite Identifier
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS record_count
FROM olist_order_items_clean
GROUP BY
    order_id,
    order_item_id
HAVING COUNT(*) > 1;

Observation / Result
- Raw records: 112,650.
- Clean records: 112,650.
- Record-count difference: 0.
- Duplicate `(order_id, order_item_id)` combinations: 0.

Conclusion / Decision
The table retained all 112,650 records, and the composite identifier check passed.

3.2 Required-Field Completeness
Objective
To verify that the core order-item fields are populated.

SQL Query :
SELECT
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(order_item_id IS NULL) AS missing_item_id,
    SUM(product_id IS NULL) AS missing_product_id,
    SUM(seller_id IS NULL) AS missing_seller_id,
    SUM(price IS NULL) AS missing_price,
    SUM(freight_value IS NULL) AS missing_freight
FROM olist_order_items_clean;

Observation / Result
All six checked fields had **0 missing values.

Conclusion / Decision
Required-field completeness passed. No additional missing-value cleaning was required for these fields.

3.3 Price and Freight Validation
Objective
To identify nonpositive item prices, negative freight charges, zero-freight records, and unusually high freight-to-price relationships.

Observation / Result
| Metric | Result |
|---|---:|
| Nonpositive prices | 0 |
| Negative freight values | 0 |
| Zero freight values | 383 |
| Freight greater than item price | 4,124 |
| Minimum price | 0.85 |
| Maximum price | 6,735.00 |
| Average price | 120.65 |
| Minimum freight | 0.00 |
| Maximum freight | 409.68 |
| Average freight | 19.99 |
The maximum observed freight-to-price ratio was approximately 26.24.

Conclusion / Decision
No nonpositive prices or negative freight charges were identified. Zero freight was preserved because it can represent a legitimate shipping arrangement.
Records where freight exceeded item price were treated as candidates for business review rather than automatically corrected.
A high freight-to-price ratio does not, by itself, prove that either value is wrong.

3.4 Order and Seller Referential Integrity
Objective
To determine whether order-item records reference existing orders and sellers.
  
Observation / Result
- Order items with unmatched order IDs: 0.
- Order items with seller IDs that did not match the sellers table: 0.
- Order items with product IDs that did not match `olist_products_clean`: 0.
A join between order items and the clean product table preserved all 112,650 order-item records.

Conclusion / Decision
The checked relationships passed referential-integrity validation. No unmatched order, seller, or product identifiers were found.

Overall Table Conclusion
`olist_order_items_clean` passed the recorded checks for row-count preservation, composite identifier uniqueness, core-field completeness,
basic price/freight validity, and table relationships. Unusual freight relationships were preserved for further business interpretation.

4. Order Payments Table Validation
Table: `olist_order_payments_clean`
4.1 Record Count and Identifier Validation

Objective
To confirm record-count preservation and validate the composite payment identifier `(order_id, payment_sequential)`.

SQL Query : 
SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS record_count
FROM olist_order_payments_clean
GROUP BY
    order_id,
    payment_sequential
HAVING COUNT(*) > 1;

Observation / Result
- Raw records: 103,886.
- Clean records: 103,886.
- Record-count difference: 0.
- Duplicate composite identifiers: 0.

Conclusion / Decision
The table retained its original row count, and the composite identifier check passed.

4.2 Payment-Field Completeness
Objective
To validate missing values in payment identifiers, payment type, installments, and payment amount.

Observation / Result
| Field | Missing records |
|---|---:|
| `order_id` | 0 |
| `payment_sequential` | 0 |
| `payment_type` | 3 |
| `payment_installments` | 2 |
| `payment_value` | 0 |
The three missing payment types belonged to canceled orders with zero payment value.
Two original zero installment values were changed to `NULL` because zero was not a valid installment count for those credit-card records.

Conclusion / Decision
Missing-value handling preserved the meaning of the data.
The three undefined payment types were retained as `NULL` because the source did not provide a reliable payment method. 
The two invalid installment values were also represented as `NULL`.

4.3 Payment-Value Validation
Objective
To identify negative, zero, and positive payment amounts and investigate zero-value payments.

Observation / Result
| Metric | Result |
|---|---:|
| Negative payment values | 0 |
| Zero payment values | 9 |
| Positive payment records | 103,877 |
| Total payment value | 16,008,872.12 |
| Minimum payment value | 0.00 |
| Maximum payment value | 13,664.08 |
| Average payment value | 154.10 |
The nine zero-value records comprised three canceled orders with undefined payment types, four voucher payments associated with delivered orders,
and two voucher records associated with a shipped order.

Conclusion / Decision
No negative payment amounts were identified. Zero-value payments were retained because their presence alone did not establish that the records were invalid.
The total payment value is the sum of the recorded payment transactions, not necessarily the total value of distinct orders, 
because an order may contain multiple payment records.

4.4 Installment Validation
Objective
To ensure that nonmissing installment counts are positive and do not exceed the observed maximum of 24.

Observation / Result
- Missing installment values after cleaning: 2.
- Minimum nonmissing installment count: 1.
- Maximum nonmissing installment count: 24.
- Nonmissing installment values above 24: 0.

Conclusion / Decision
The remaining nonmissing installment values were within the observed valid range. 
The two invalid original zero values were represented as `NULL` rather than assigned invented installment counts.

4.5 Order Referential Integrity
Objective
To verify that each payment record references an existing cleaned order.

Observation / Result
Unmatched order IDs: **0**.

Conclusion / Decision
Payment-to-order referential integrity passed.

Overall Table Conclusion
`olist_order_payments_clean` passed the recorded checks for row-count preservation, composite identifier uniqueness, payment amount validity, installment validity, and order relationships. Three undefined payment types and two invalid original installment values were handled without inventing replacement information.

5. Order Reviews Table Validation
Table:`olist_order_reviews_clean`
5.1 Record Count and Identifier Validation
Objective
To confirm row-count preservation and check uniqueness of the `(review_id, order_id)` combination.

SQL Query:
SELECT
    review_id,
    order_id,
    COUNT(*) AS record_count
FROM olist_order_reviews_clean
GROUP BY
    review_id,
    order_id
HAVING COUNT(*) > 1;

Observation / Result
- Raw records: 99,223.
- Clean records: 99,223.
- Record-count difference: 0.
- Duplicate `(review_id, order_id)` combinations: 0.

Conclusion / Decision
The table retained its original record count, and the checked composite identifier was unique.

5.2 Review-Score Validation
Objective
To determine whether review scores are missing or fall outside the expected range of 1 to 5.

SQL Query : 
SELECT
    COUNT(*) AS total_records,
    SUM(review_score IS NULL) AS missing_scores,
    SUM(
        review_score < 1
        OR review_score > 5
    ) AS out_of_range_scores,
    MIN(review_score) AS minimum_score,
    MAX(review_score) AS maximum_score
FROM olist_order_reviews_clean;

Observation / Result
- Missing review scores: 0.
- Scores outside the range 1–5: 0.
- Minimum score: 1.
- Maximum score: 5.

Score distribution:
| Review score | Records |
|---:|---:|
| 1 | 11,424 |
| 2 | 3,151 |
| 3 | 8,179 |
| 4 | 19,142 |
| 5 | 57,327 |

Conclusion / Decision
Review-score validation passed. All scores were present and within the expected range. The distribution indicates that score 5 was the most frequent rating.

5.3 Review-Timestamp Validation
Objective
To identify missing review timestamps and verify that the review creation date does not occur after the review answer timestamp.

Observation / Result
- Missing `review_creation_date`: 1.
- Missing `review_answer_timestamp`: 1.
- Records where creation occurred after answer: 0.
Both missing timestamps occurred in the same record:
- `review_id`: `636b237e87574ba29654deaba9eb9797`
- `order_id`: `d7361a834a2dd8db2f6f133ce291ab6`
- `review_score`: 2.

Conclusion / Decision
The two missing timestamp fields were retained as missing because reliable replacement timestamps were not available.
No creation-after-answer anomalies were identified in the checked records.

Overall Table Conclusion
`olist_order_reviews_clean` passed the recorded checks for row-count preservation, composite identifier uniqueness, review-score validity,
and timestamp ordering. One review record retained two missing timestamp values, which were documented rather than replaced with invented dates.

6. Orders Table Validation
Table:`olist_orders_clean`
6.1 Record Count and Order-Identifier Validation
Objective
To confirm row-count preservation and uniqueness of the order identifier.

SQL Query
SELECT
    order_id,
    COUNT(*) AS record_count
FROM olist_orders_clean
GROUP BY order_id
HAVING COUNT(*) > 1;

Observation / Result
- Raw records: 99,441.
- Clean records: 99,441.
- Record-count difference: 0.
- Distinct order IDs: 99,441.
- Duplicate order IDs: 0.

Conclusion / Decision
The table retained its original row count, and `order_id` was unique across all 99,441 records.
  
6.2 Required-Field and Timestamp Completeness
Objective
To check missing values in order identifiers, customer identifiers, order status, and order timestamps.

Observation / Result
| Field | Missing records |
|---|---:|
| `order_id` | 0 |
| `customer_id` | 0 |
| `order_status` | 0 |
| `order_purchase_timestamp` | 0 |
| `order_estimated_delivery_date` | 0 |
| `order_approved_at` | 160 |
| `order_delivered_carrier_date` | 1,783 |
| `order_delivered_customer_date` | 2,965 |

Conclusion / Decision
Core identifiers, status, purchase timestamps, and estimated delivery dates were populated. 
Missing approval and delivery timestamps remained in the cleaned table where reliable replacement values were unavailable.
These missing values require interpretation in the context of order status and operational events; they should not automatically be treated as errors.

6.3 Order-Status Distribution
Objective
To validate the observed order-status categories and understand the composition of the cleaned dataset.

Observation / Result
| Order status | Records |
|---|---:|
| Delivered | 96,478 |
| Shipped | 1,107 |
| Canceled | 625 |
| Unavailable | 609 |
| Invoiced | 314 |
| Processing | 301 |
| Created | 5 |
| Approved | 2 |
| **Total** | **99,441** |

Conclusion / Decision
The status counts reconcile to the total number of records. 
Non-delivered statuses were retained because they represent legitimate order lifecycle states rather than inherently invalid data.

6.4 Timestamp-Sequence Anomalies
Objective
To investigate unusual event sequences in the order lifecycle, including carrier handover before approval and customer delivery before carrier handover.

Observation / Result
The investigations identified:
- 1,359 records where carrier handover preceded approval: 1,350 delivered orders and 9 shipped orders.
- 22 records where customer delivery preceded carrier handover.
- 8 delivered orders with a missing customer-delivery timestamp.
- 14 delivered orders with a missing approval timestamp.
- 2 delivered orders with a missing carrier-handover timestamp.
The counts above describe different anomaly categories and should not be added together as though they represented unique orders.

Conclusion / Decision
The timestamp anomalies were retained because the available data did not establish their correct replacement values. 
The findings were documented for further investigation rather than automatically reordering timestamps or assigning fabricated dates.

6.5 Estimated Delivery Performance
Objective
To evaluate delivery performance by comparing actual customer-delivery timestamps with estimated delivery dates.

Observation / Result
Among the 96,470 delivered orders with both relevant timestamps:
| Delivery outcome | Records |
|---|---:|
| Delivered after estimate | 6,534 |
| Delivered on estimate | 1,292 |
| Delivered before estimate | 88,644 |
| **Total with both dates** | **96,470** |
Approximately 6.77% of these orders were delivered after the estimated date.
A further investigation identified 71 delivered orders with a carrier-to-customer delivery interval exceeding 90 days. 
Of those, 70 were also delivered after the estimated date.

Conclusion / Decision
The delivery-performance checks identified late deliveries and unusually long delivery intervals that may warrant operational investigation.
These observations were not automatically treated as data-entry errors.
Further investigation would be needed to determine whether the timestamps reflect genuine delays, recording issues, or other operational circumstances.

Overall Table Conclusion
`olist_orders_clean` passed the recorded row-count and order-identifier checks. 
Missing timestamps and unusual event sequences remain documented. 
Delivery performance analysis also identified late deliveries and long carrier-to-customer intervals that may be useful for subsequent operations analytics.

7. Products Table Validation
Table: `olist_products_clean`
7.1 Record Count and Product-Identifier Validation
Objective
To confirm the expected number of cleaned product records and validate product identifier completeness.

Observation / Result
- Clean product records: 32,951.
- Missing `product_id` values: 0.
- Distinct product identifiers: 32,951.
- Full-row signatures: 32,951 distinct signatures across 32,951 records.

Conclusion / Decision
The product identifier completeness check passed. The full-row signature comparison found no repeated complete-row signatures among the cleaned records.

7.2 Product-Attribute Completeness
Objective
To assess missing product categories, names, descriptions, photographs, weights, and dimensions.

Observation / Result
| Attribute | Missing records |
|---|---:|
| `product_id` | 0 |
| `product_category_name` | 610 |
| `product_name_length` | 610 |
| `product_description_lenght` | 0 |
| `product_photos_qty` | 6 |
| Weight and dimension attributes | 6 affected products |
The original column name `product_description_lenght` contains a spelling error in the source schema. 
The intended corrected name is `product_description_length`.
The 610 missing category values coincided with the 610 missing product-name-length values.
The six products with missing physical attributes were associated with 26 order-item records.

Conclusion / Decision
Product identifiers remained complete. The 610 missing category/name-length values and the six products with incomplete physical attributes were documented.
Missing product metadata was not filled with fabricated categories, lengths, or physical measurements. 
Where the column-name correction was applied, the corrected name should be used consistently in subsequent SQL and documentation.

7.3 Product Measurement Validation
Objective
To identify nonpositive product weight or dimension values that could indicate invalid physical measurements.

Observation / Result
Nonpositive physical measurement values: 0.

Conclusion / Decision
The nonpositive-measurement check passed. No additional correction was justified by this validation.
This result does not establish that every positive measurement is physically accurate; it only confirms that the checked fields did not contain nonpositive values.

7.4 Product-Category Consistency
Objective
To identify blank category values and investigate missing category translations.

Observation / Result
- Missing category values: 610.
- Blank category values after the earlier cleaning: 0.
- Distinct non-NULL product categories: 73.
- Products missing an English translation: 13 across two category values.
The two category values identified without translation coverage were:
- `portateis_cozinha_e_preparadores_de_alimentos`: 10 products.
- `pc_gamer`: 3 products.

Conclusion / Decision
Blank-category validation passed, but missing categories and translation gaps remained.
The 13 products were not assigned invented English category labels. 
These gaps should be handled using a verified translation reference if complete English category coverage is required.

7.5 Product-to-Order-Items Referential Integrity
Objective
To verify that order-item product identifiers match the cleaned product table and that joining the tables does not lose order-item records.

Observation / Result
- Unmatched product identifiers in order items: 0.
- Order-item records before joining: 112,650.
- Records preserved by the checked join: 112,650.

Conclusion / Decision
Product-to-order-items referential integrity passed. All order-item product references matched the cleaned products table in the investigation.

Overall Table Conclusion
`olist_products_clean` passed the recorded checks for product identifier completeness, full-row signature uniqueness, nonpositive measurements, 
and order-item relationships. Missing product metadata and translation coverage gaps remain documented limitations rather than being filled with unsupported values.

8. Consolidated Post-Cleaning Validation Summary
| Table | Key checks passed | Outstanding observations |
|---|---|---|
| `olist_geolocation_clean` | Postal-code format, coordinate completeness/ranges, exact duplicate check, city/state completeness | Repeated coordinates, city/state combinations, accent variations |
| `olist_order_items_clean` | Row-count preservation, composite identifier, required fields, price/freight checks, relationships | High freight-to-price ratios and zero-freight records retained |
| `olist_order_payments_clean` | Row-count preservation, composite identifier, payment values, installments, order relationship | Three undefined payment types and two invalid original installment values represented as NULL |
| `olist_order_reviews_clean` | Row-count preservation, composite identifier, scores, timestamp ordering | One record with two missing review timestamps |
| `olist_orders_clean` | Row-count preservation, unique order IDs, status counts, delivery analysis | Missing timestamps, event-sequence anomalies, late deliveries |
| `olist_products_clean` | Product identifiers, full-row signatures, measurement checks, category and relationship checks | Missing metadata and 13 products without translation coverage |

9. Final Project Conclusion
The post-cleaning validation stage assessed six cleaned Olist tables using the results of the SQL investigations carried out during the project.
The validation confirmed several important improvements, including standardized five-character geolocation postal prefixes, 
removal of the three identified city-name whitespace inconsistencies, uniqueness of the checked order and composite identifiers,
and valid ranges for the examined review scores, prices, freight values, installment counts, and geographic coordinates.
The checks also confirmed that the cleaned order-item, payment, review, and order tables retained their original row counts. 
The geolocation table's reduction in record count was consistent with its earlier deduplication stage.
However, the validation did not establish that every record is completely accurate. Missing product metadata, missing timestamps, undefined payment types, 
geographic naming variations, and suspicious delivery sequences remain relevant limitations. 
These were documented and preserved where the available evidence did not justify further correction.

Final decision: 
The six tables have completed the post-cleaning validation checks documented here. 
The remaining observations should be carried forward as documented data limitations and potential areas for further investigation.
The tables can now support the next stage of the portfolio project, subject to the requirements of each subsequent analysis.
