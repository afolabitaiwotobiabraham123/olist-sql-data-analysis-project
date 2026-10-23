Olist E-Commerce Data Analysis
Advanced SQL Cleaning — Investigation and Validation Documentation
Project: Olist E-Commerce Data Analysis
Database: MySQL
Assessment Phase: Advanced SQL Cleaning
Tables: Order Items, Order Payments, Order Reviews, Orders, Products, and Geolocation
1. Objective
The objective of this phase was to perform focused, advanced investigations on the six existing Olist clean tables after the earlier data-cleaning phases. 
The assessment examined numerical validity, timestamp consistency, duplicate identifiers, relationships between tables, incomplete product metadata, 
and geographic outliers.
The purpose was to distinguish issues inherited from the original dataset from issues introduced during cleaning.
Values were changed only where earlier cleaning rules and source evidence justified the change. Potential source-data anomalies were preserved
where the available evidence did not support a reliable correction.
  
2. Tables Covered
The six clean tables included in this phase were:
1. olist_order_items_clean
2. olist_order_payments_clean
3. olist_order_reviews_clean
4. olist_orders_clean
5. olist_products_clean
6. olist_geolocation_clean
Scope clarification: This phase documents advanced investigation and validation. It does not imply that every flagged value was corrected.
Several findings were preserved because the source data confirmed them or because the available evidence was insufficient to determine a correct replacement.
  
3. Order Items Advanced Investigation
Table: olist_order_items_clean
Objective
To assess order-item prices, freight values, shipping deadlines, composite-key uniqueness, and consistency with related order timestamps and the original dataset.

3.1 Price and Freight Value Assessment
SQL Query:
SELECT
    COUNT(*) AS total_records,
    SUM(price < 0) AS negative_prices,
    SUM(price = 0) AS zero_prices,
    SUM(price IS NULL) AS missing_prices,
    SUM(freight_value < 0) AS negative_freight,
    SUM(freight_value = 0) AS zero_freight,
    SUM(freight_value IS NULL) AS missing_freight
FROM olist_order_items_clean;
Observation / Result
- Total records: 112,650.
- Negative prices: 0.
- Zero prices: 0.
- Missing prices: 0.
- Negative freight values: 0.
- Zero freight values: 383.
- Missing freight values: 0.
- All 383 records with zero freight had positive item prices.
- Four sellers accounted for 369 of the 383 zero-freight records.
The concentration of zero-freight records among a small number of sellers was noted, but it did not by itself establish that the values were incorrect.
A comparison with olist_order_items_dataset found the same 383 zero-freight records in the raw data.
No corresponding raw records had positive or missing freight values.

Conclusion / Decision
The 383 zero-freight values were preserved because they matched the original dataset. No price or freight correction was justified by the checks performed.

3.2 Shipping Deadline Assessment
SQL Query : 
SELECT
    COUNT(*) AS total_records,
    SUM(shipping_limit_date IS NULL) AS missing_shipping_deadlines,
    SUM(shipping_limit_date < '2016-01-01')
        AS deadlines_before_dataset_period
FROM olist_order_items_clean;
Observation / Result
- Total records: 112,650.
- Missing shipping deadlines: 0.
- Shipping deadlines before 1 January 2016: 0.
  
A comparison with the related order timestamps found:
- Order items matched to existing orders: 112,650.
- Shipping deadlines before purchase timestamps: 0.
- Missing purchase timestamps for the matched records: 0.

Conclusion / Decision
No shipping-deadline correction was required based on the checks performed.

3.3 Composite Identifier Assessment
SQL Query : 
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS occurrences
FROM olist_order_items_clean
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

Observation / Result
The query returned 0 rows. No duplicate (order_id, order_item_id) groups were identified.

Conclusion / Decision
The composite order-item identifier passed the duplicate check. No records were removed.

3.4 Overall Order Items Conclusion
The assessed prices, freight values, shipping deadlines, and composite identifiers did not provide evidence supporting further cleaning changes. 
The zero-freight values were confirmed in the raw dataset and preserved.
  
4. Order Payments Advanced Investigation
Table: olist_order_payments_clean
Objective
To investigate payment-value validity, installment values, payment-type consistency, duplicate payment identifiers,
and unusually large payment values against the original dataset and related order-item totals.

4.1 Payment Value Assessment
SQL Query : 
SELECT
    COUNT(*) AS total_records,
    SUM(payment_value < 0) AS negative_payment_values,
    SUM(payment_value = 0) AS zero_payment_values,
    SUM(payment_value IS NULL) AS missing_payment_values,
    MIN(payment_value) AS minimum_payment_value,
    MAX(payment_value) AS maximum_payment_value
FROM olist_order_payments_clean;
Observation / Result
- Total payment records: 103,886.
- Negative payment values: 0.
- Zero payment values: 9.
- Missing payment values: 0.
- Minimum payment value: 0.00.
- Maximum payment value: 13,664.08.
The nine zero-value payment records were compared with the original payment table.
All nine were also zero in the raw dataset; none had a positive or missing raw payment value.
The zero-value records included:
- Three records with a NULL payment type associated with canceled orders.
- Four voucher records associated with delivered orders.
- Two voucher records associated with shipped orders.

Conclusion / Decision
The nine zero-value payment records were preserved because their values matched the source data. No payment values were fabricated or changed.

4.2 Payment Installment Assessment
SQL Query :
SELECT
    COUNT(*) AS total_records,
    SUM(payment_installments < 0) AS negative_installments,
    SUM(payment_installments = 0) AS zero_installments,
    SUM(payment_installments IS NULL) AS missing_installments
FROM olist_order_payments_clean;

Observation / Result
- Negative installment values: 0.
- Zero installment values remaining in the clean table: 0.
- Missing installment values: 2.
The two records with missing installment values were:
Order ID	Payment sequence	Payment type	Raw installments	Clean installments	Payment value
744bade1fcf9ff3f31d860ace076d422	2	credit_card	0	NULL	58.69
1a57108394169c0b47d8f876acc9ba2d	2	credit_card	0	NULL	129.94
The original payment table confirmed that both installment values had been recorded as zero.

Conclusion / Decision
The earlier cleaning action that converted these zero installment values to NULL was supported by the source comparison. 
The values were not replaced with guessed installment counts.

4.3 Payment Type Assessment
SQL Query : 
SELECT
    payment_type,
    COUNT(*) AS record_count
FROM olist_order_payments_clean
GROUP BY payment_type
ORDER BY payment_type;
Observation / Result
Payment type	Record count
credit_card	76,795
boleto	19,784
voucher	5,775
debit_card	1,529
NULL	3
The three NULL payment types resulted from the earlier conversion of not_defined to NULL. 
All three were associated with canceled orders and zero payment values.

Conclusion / Decision
The three NULL payment types were retained. The checks did not support assigning a payment method where the source label was not_defined.

4.4 Highest Payment Value Investigation
Observation / Result
The highest payment record was:
Field	Value
Order ID	03caa2c082116e1d31e67e9ae3700499
Payment type	credit_card
Installments	1
Payment value	13,664.08
Order status	delivered
The sum of the order's item prices and freight values was also 13,664.08.

Conclusion / Decision
The high payment value matched the related order-item total. It was not treated as an outlier requiring correction.

4.5 Duplicate Payment Identifier Assessment
SQL Query : 
SELECT
    order_id,
    payment_sequential,
    COUNT(*) AS occurrences
FROM olist_order_payments_clean
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;
Observation / Result
The query returned 0 rows. No duplicate (order_id, payment_sequential) groups were identified.

Conclusion / Decision
The payment composite identifier passed the duplicate check. No records were removed.

4.6 Overall Order Payments Conclusion
The advanced checks supported retaining the zero payment values, the three NULL payment types, and the high payment record. 
The two missing installment values were consistent with the earlier cleaning of raw zero values. 
No additional payment-table update was justified.

5.0 Order Reviews Advanced Investigation
Table: olist_order_reviews_clean
Objective
To validate review scores and timestamps, confirm review-to-order relationships, and investigate duplicate or missing review identifiers.

5.1 Review Score Assessment
SQL Query : 
SELECT
    COUNT(*) AS total_reviews,
    SUM(review_score IS NULL) AS missing_scores,
    SUM(review_score < 1 OR review_score > 5)
        AS out_of_range_scores,
    MIN(review_score) AS minimum_score,
    MAX(review_score) AS maximum_score
FROM olist_order_reviews_clean;
Observation / Result
- Total reviews: 99,223.
- Missing review scores: 0.
- Out-of-range scores: 0.
- Minimum score: 1.
- Maximum score: 5.

Conclusion / Decision
All assessed review scores were present and within the expected range of 1 to 5. No cleaning action was required.

5.2 Review Timestamp Assessment
SQL Query :
SELECT
    COUNT(*) AS total_reviews,
    SUM(review_creation_date IS NULL)
        AS missing_creation_dates,
    SUM(review_answer_timestamp IS NULL)
        AS missing_answer_timestamps,
    SUM(review_answer_timestamp < review_creation_date)
        AS answer_before_creation
FROM olist_order_reviews_clean;

Observation / Result
- Total reviews: 99,223.
- Missing review creation timestamps: 1.
- Missing review answer timestamps: 1.
- Answer timestamps before creation timestamps: 0.
Both missing timestamps belonged to the same review:
Field	Value
Review ID	636b237e87574ba29654deaba9eb9797
Order ID	d7361a834a2dd8db2f6f133ce291ab6b
Review score	2
The original dataset contained 0000-00-00 00:00:00 for both timestamp fields. The clean table represented these invalid zero dates as NULL.

Conclusion / Decision
The conversion of zero dates to NULL was supported by the raw data. The missing timestamps were preserved rather than replaced with invented dates.

5.3 Review-to-Order Relationship Assessment
SQL Query
SELECT
    COUNT(*) AS total_reviews,
    SUM(o.order_id IS NULL) AS reviews_without_matching_order
FROM olist_order_reviews_clean AS r
LEFT JOIN olist_orders_clean AS o
    ON r.order_id = o.order_id;
Observation / Result
- Total reviews: 99,223.
- Reviews without a matching order: 0.

Conclusion / Decision
Every review referenced an existing order. The relationship passed the check, and no cleaning action was required.

5.4 Duplicate Review ID Assessment
SQL Query : 
SELECT
    COUNT(*) AS duplicate_review_id_groups
FROM (
    SELECT review_id
    FROM olist_order_reviews_clean
    GROUP BY review_id
    HAVING COUNT(*) > 1
) AS duplicates;

Observation / Result
The query identified 789 duplicate review-ID groups.
A follow-up query quantified the rows involved:
SELECT
    COUNT(*) AS total_rows_in_duplicate_groups,
    SUM(review_count - 1) AS excess_rows,
    MAX(review_count) AS maximum_occurrences
FROM (
    SELECT
        review_id,
        COUNT(*) AS review_count
    FROM olist_order_reviews_clean
    GROUP BY review_id
    HAVING COUNT(*) > 1
) AS duplicates;

Results:
- Rows in duplicate review-ID groups: 1,603.
- Excess rows beyond one occurrence per ID: 814.
- Maximum occurrences of one review ID: 3.
The original review dataset contained the same 789 duplicate review-ID groups.

A further investigation found that all 789 duplicate-ID groups were associated with multiple distinct orders:
Finding	Result
Duplicate review-ID groups	789
Groups linked to multiple orders	789
Groups linked to one order	0
One investigated example was review ID 08528f70f579f0c830189efc523d2182, which appeared three times for different orders:
- 03310aa823a66056268a3bab36e827fb
- 53c71d3953507c6239ff73917ed358c9
- 7813842ae95e8c497fc0233232ae815a
The three records shared the same score, review text, and timestamps. The repeated ID pattern was present in the raw data.

Conclusion / Decision
The duplicate review IDs represent an unresolved source identifier-integrity concern.
Because the records refer to different orders and the available evidence does not establish which record,
if any, is incorrect, the records were preserved. No rows were deleted, and no replacement review IDs were fabricated.

5.5 Review ID Completeness Assessment
SQL Query : 
SELECT
    COUNT(*) AS total_reviews,
    SUM(review_id IS NULL) AS missing_review_ids,
    SUM(TRIM(review_id) = '') AS blank_review_ids
FROM olist_order_reviews_clean;
Observation / Result
- Total reviews: 99,223.
- Missing review IDs: 0.
- Blank review IDs: 0.

Conclusion / Decision
All review records had a non-NULL, nonblank review ID. 
The issue identified in the previous section concerns repeated IDs, not missing IDs.

5.6 Overall Order Reviews Conclusion
Review scores and review-to-order relationships passed the assessed checks. Zero-date timestamps were correctly represented as NULL. 
Duplicate review IDs were confirmed in the raw dataset and preserved as an unresolved source-data issue.

6.0 Orders Advanced Investigation
Table: olist_orders_clean
Objective
To investigate temporal inconsistencies among purchase, approval, carrier-handover, and customer-delivery timestamps;
compare suspicious values with the original orders table; and verify that missing timestamps resulted from the earlier handling of raw zero dates.

6.1 Order Timestamp Sequence Assessment
Observation / Result
The initial timestamp investigation identified:
Timestamp condition	Records
Approval timestamp before purchase timestamp	0
Carrier-handover timestamp before purchase timestamp	166
Customer-delivery timestamp before carrier-handover timestamp	23
The 166 carrier-before-purchase cases were grouped by the size of the time difference:
Time difference group	Records
0–2 hours	164
1–7 days	1
More than 7 days	1
Two of the largest carrier-before-purchase anomalies were compared with the raw dataset, and the timestamps matched the source values.

Example 1
Field	Value
Order ID	7c48bb55e8e4f7e56d412e9653db37bc
Purchase timestamp	2018-07-16 18:40:53
Approval timestamp	2018-07-16 18:50:22
Carrier-handover timestamp	2018-01-26 13:35:00
Customer-delivery timestamp	2018-07-23 20:04:45


Example 2
Field	Value
Order ID	4021cd7611d6d9ce5ffcd24817fc374f
Purchase timestamp	2018-08-18 11:49:40
Approval timestamp	2018-08-18 12:10:30
Carrier-handover timestamp	2018-08-14 06:22:00

The 23 cases where customer delivery preceded carrier handover were all compared with the raw table. All 23 of 23 had timestamps matching the original data.
A query combining the two types of temporal anomalies identified 189 distinct orders affected, with no overlap between the two groups.

Conclusion / Decision
The investigated timestamp anomalies were present in the original dataset.
The raw comparison covered all 23 customer-before-carrier cases and the two largest carrier-before-purchase cases;
it did not individually validate all 166 carrier-before-purchase cases.
The anomalous values were preserved because the available evidence did not justify a reliable replacement.

6.2 Delivered Orders with Missing Timestamps
Observation / Result
There were 96,478 delivered orders. Among them:
- Missing carrier-handover timestamps: 2.
- Missing customer-delivery timestamps: 8.
- Missing purchase timestamps: 0.
- Missing approval timestamps: 14.
The missing carrier and customer-delivery timestamps were compared with the raw data. 
The raw table contained zero dates for the corresponding missing fields, and the clean table represented them as NULL.
The two delivered orders with missing carrier-handover timestamps were:
- 2aa91108853cecb43c84a5dc5b277475
- 2d858f451373b04fb5c984a1cc2defaf
For the eight delivered orders with missing customer-delivery timestamps, the raw table confirmed zero dates for the customer-delivery field in all eight cases. 
Seven had valid carrier timestamps that matched the raw data. One order, 2d858f451373b04fb5c984a1cc2defaf, also had a raw zero date for carrier handover.
The 14 delivered orders with missing approval timestamps also had raw zero dates in the approval field.

Conclusion / Decision
The missing timestamps were consistent with the previous zero-date cleaning. They were preserved as NULL; no timestamps were invented.

6.3 Canceled Orders with Delivery-Related Timestamps
Observation / Result
There were 625 canceled orders.
- Canceled orders with carrier-handover timestamps: 75.
- Canceled orders with customer-delivery timestamps: 6.
All six canceled orders with customer-delivery timestamps had values that matched the raw data. 
The timestamps occurred after purchase and approval, but the records remained marked as canceled.
The remaining 69 canceled orders with carrier-handover timestamps and no customer-delivery timestamp were also compared with the raw dataset.
All 69 carrier timestamps matched the source.
A further check identified 141 canceled orders with missing approval timestamps.
A raw-data comparison showed that all 141 original approval values were 0000-00-00 00:00:00.
Across all order statuses, the missing approval timestamps were distributed as follows:
Order status	Missing approval timestamps
canceled	141
created	5
delivered	14
Total	160
The five created orders were also checked against the raw table; their approval timestamps were zero dates in the source.

Conclusion / Decision
The unusual status/timestamp combinations and missing approval timestamps were preserved. 
Source comparisons confirmed the investigated values were inherited from the original dataset,
but did not establish the business reason for each unusual combination. No order statuses or timestamps were changed based on assumption.

6.4 Overall Orders Conclusion
The order timestamp investigation identified temporal anomalies and missing timestamps. 
The checked anomalies were present in the raw dataset, and zero dates had been converted to NULL during earlier cleaning. 
The findings were preserved for traceability rather than automatically corrected.

7.0 Products Advanced Investigation
Table: olist_products_clean
Objective
To assess product identifier completeness and uniqueness, investigate missing or invalid product attributes, examine zero photo counts, 
and review products with incomplete physical measurements.

7.1 Product Identifier Assessment
Observation / Result
- Total product records: 32,951.
- Missing product IDs: 0.
- Blank product IDs: 0.
- Unique product IDs: 32,951.
- Duplicate product-ID groups: 0.

Conclusion / Decision
The product identifier check passed. No product records were removed.

7.2 Missing and Negative Product Attributes
Observation / Result
The assessment found the following missing numerical attributes:
Attribute	Missing records
product_name_length	610
product_description_lenght	610
product_photos_qty	0
product_weight_g	6
product_length_cm	6
product_height_cm	6
product_width_cm	6

No negative values were identified in the assessed numerical attributes.
All six records missing physical measurements had all four physical measurement fields missing. The product IDs were:
- 09ff539a621711667c43eba6a3bd8466
- 81781c0fed9fe1ad6e8c81fca1e1cb08
- 8038040ee2a71048d4bdbbdc985b69ab
- 36ba42dd187055e1fbe943b2d11430ca
- 5eb564652db742ff8f28759cd8d2652a
- e673e90efa65a5409ff4196c038bb5af
Five of these products had a populated category, while product 5eb564652db742ff8f28759cd8d2652a had a NULL category.

Conclusion / Decision
The missing physical measurements were retained. The assessment did not provide evidence for reliable replacement weights or dimensions, so no values were fabricated.

7.3 Product Text Metadata and Category Assessment
SQL Query
SELECT
    COUNT(*) AS total_products,
    SUM(
        product_name_length IS NULL
        AND product_description_lenght IS NULL
    ) AS both_lengths_missing,
    SUM(
        product_name_length IS NULL
        AND product_description_lenght IS NOT NULL
    ) AS name_only_missing,
    SUM(
        product_name_length IS NOT NULL
        AND product_description_lenght IS NULL
    ) AS description_only_missing,
    SUM(
        product_name_length IS NULL
        AND product_description_lenght IS NULL
        AND product_category_name IS NULL
    ) AS both_lengths_and_category_missing
FROM olist_products_clean;
Observation / Result
- Products missing both name and description lengths: 610.
- Products missing only name length: 0.
- Products missing only description length: 0.
- Products missing both lengths and category: 610.
All 610 products missing both text-length attributes also had a NULL product category.

Conclusion / Decision
The related missing metadata was documented as incomplete source information. No category or text-length values were inferred.

7.4 Zero Product Photo Assessment
SQL Query : 
SELECT
    COUNT(*) AS products_with_zero_photos,
    SUM(product_category_name IS NULL) AS missing_category,
    SUM(product_name_length IS NULL) AS missing_name_length,
    SUM(product_description_lenght IS NULL)
        AS missing_description_length
FROM olist_products_clean
WHERE product_photos_qty = 0;

Observation / Result
The query returned:
Finding	Count
Products with zero photos	610
Those with missing category	610
Those with missing name length	610
Those with missing description length	610
The same 610 records had zero photos, missing category, and missing name and description lengths.

Conclusion / Decision
The zero photo counts were preserved because the checks alone did not establish whether the records should have had photos. 
The associated missing metadata was documented rather than filled with guessed values.

7.5 Physical Measurement Range Assessment
Observation / Result
The observed ranges were:
Attribute	Minimum	Maximum
product_weight_g	2	40,425
product_length_cm	7	105
product_height_cm	2	105
product_width_cm	6	118
No negative values were identified in the assessed attributes. The maximum values were retained; the checks did not establish that they were invalid.

Conclusion / Decision
No physical measurement values were changed based solely on their ranges. Further changes would require stronger evidence of invalidity.

7.6 Overall Products Conclusion
The product IDs passed completeness and uniqueness checks. Missing product metadata, zero photo counts, 
and six products with incomplete physical measurements were preserved because the assessment did not establish reliable replacement values.

8.0 Geolocation Advanced Investigation
Table: olist_geolocation_clean
Objective
To assess geolocation field completeness, validate coordinate ranges, investigate records outside broad geographic bounds,
compare flagged records with the raw data, and understand repeated ZIP-code-prefix records.

8.1 Field Completeness Assessment
Observation / Result
The clean geolocation table contained 720,496 records.
The completeness checks found:
- Missing values across the assessed fields: 0.
- Blank values across the assessed fields: 0.
The assessed fields were ZIP-code prefix, latitude, longitude, city, and state.

Conclusion / Decision
The assessed fields passed the missing- and blank-value checks. No cleaning action was required for field completeness.

8.2 Coordinate Range Assessment
Observation / Result
The coordinate checks found:
- Invalid latitude values: 0.
- Invalid longitude values: 0.
- Zero latitude values: 0.
- Zero longitude values: 0.
- Records with both latitude and longitude equal to zero: 0.
Observed coordinate ranges:
Coordinate	Minimum	Maximum
Latitude	-36.60537441070610	45.06593318269697
Longitude	-101.46676644931476	121.10539381057764
Although the values were within the general numerical limits for latitude and longitude, 
some coordinates appeared inconsistent with the expected geographic extent of Brazil.

Conclusion / Decision
The numerical coordinate checks passed, but that did not prove that every coordinate represented a correct location in Brazil. 
Geographic plausibility was investigated separately.

8.3 Geographic Bounds Investigation
SQL Query — Initial Broad Bounds
SELECT
    COUNT(*) AS records_outside_brazil_bounds
FROM olist_geolocation_clean
WHERE geolocation_lat < -34
   OR geolocation_lat > 6
   OR geolocation_lng < -74
   OR geolocation_lng > -34;

Observation / Result
The initial bounds flagged 33 records.
Inspection indicated that six records associated with Fernando de Noronha were likely false positives because the initial eastern longitude boundary was too narrow.
The longitude boundary was then widened from -34 to -32.

SQL Query — Revised Bounds
SELECT
    COUNT(*) AS records_outside_revised_brazil_bounds
FROM olist_geolocation_clean
WHERE geolocation_lat < -34
   OR geolocation_lat > 6
   OR geolocation_lng < -74
   OR geolocation_lng > -32;

Observation / Result
The revised bounds flagged 27 records.
The 27 distinct records were distributed across 20 ZIP-code prefixes. Examples included:
- Prefix 68275, with three records showing latitudes around 41–42° and longitudes around -8 to -6°.
- Prefix 28155, with two records spanning approximately -34.59° to 42.44° latitude.
- Prefix 29654, with two records around 21–29° latitude and -101 to -98° longitude.
- Prefix 35179, with two records around 26° latitude and -98° longitude.
- Prefix 45936, with two records showing substantial coordinate variation.
These results were treated as geographic plausibility flags rather than automatic proof of incorrect values.

Conclusion / Decision
The 27 flagged records were retained pending stronger geographic verification. 
The six Fernando de Noronha records were not treated as confirmed anomalies solely because they fell outside the original, narrower longitude boundary.

8.4 Comparison with the Original Geolocation Dataset
Observation / Result
A comparison with the raw geolocation table produced 31 joined rows representing 27 distinct flagged clean records. 
The additional joined rows resulted from multiple raw matches.
All 27 distinct flagged records were found in the raw dataset.

Conclusion / Decision
The flagged coordinates were inherited from the original data rather than introduced during cleaning. 
They were preserved because the source comparison confirmed their presence but did not establish the correct replacement coordinates.

8.5 ZIP-Code Prefix Distribution Assessment
SQL Query :
SELECT
    COUNT(*) AS total_zip_prefixes,
    SUM(record_count > 1) AS prefixes_with_multiple_records,
    MAX(record_count) AS maximum_records_per_prefix
FROM (
    SELECT
        geolocation_zip_code_prefix,
        COUNT(*) AS record_count
    FROM olist_geolocation_clean
    GROUP BY geolocation_zip_code_prefix
) AS prefix_counts;

Observation / Result
- Distinct ZIP-code prefixes: 19,015.
- Prefixes with multiple records: 17,783.
- Maximum records for one prefix: 746.
The five prefixes with the most records were:
ZIP-code prefix	Total records	Distinct coordinate pairs
38400	746	746
11680	727	727
35500	726	726
11740	666	666
36400	627	627
Each of these five prefixes had a distinct coordinate pair for every record counted.

Conclusion / Decision
Multiple records per ZIP-code prefix were preserved. The results show that a prefix can be associated with multiple coordinate pairs; 
repeated prefixes alone are not proof of duplicate or invalid records.

8.6 Overall Geolocation Conclusion
The geolocation fields passed completeness and numerical coordinate-range checks. Geographic bounds identified 27 distinct records for further investigation,
all of which were also present in the raw dataset. 
These records were preserved because no verified replacement coordinates were established. Multiple records per ZIP-code prefix were also retained.

9.0 Overall Advanced Investigation Summary
Clean table	Main findings	Decision
olist_order_items_clean	383 zero-freight records matched raw data;
no duplicate composite identifiers or assessed shipping-deadline issues	
Preserve source values; no further update justified
olist_order_payments_clean	Nine zero-value payments matched raw data;
two zero installment values had already been converted to NULL;
duplicate payment identifiers not found	Preserve values and prior cleaning decisions
olist_order_reviews_clean	Zero dates were correctly converted to NULL;
789 duplicate review-ID groups were present in raw data	Preserve timestamp handling and duplicate-ID records; document source identifier concern
olist_orders_clean	Temporal anomalies and missing timestamps were investigated;
checked cases were consistent with raw source values	Preserve anomalies and NULL timestamps; do not invent corrections
olist_products_clean	610 products had incomplete text/category metadata and zero photos;
six lacked all four physical measurements; product IDs were unique	Preserve incomplete metadata and measurements
olist_geolocation_clean	27 distinct records were flagged by revised geographic bounds and confirmed in raw data	
Preserve flagged coordinates for further investigation

10.0 Final Conclusion
The advanced SQL cleaning phase investigated numerical values, timestamp consistency, duplicate identifiers, product metadata, 
and geographic plausibility across six Olist clean tables.
Several checks passed without identifying a need for further cleaning.
Other checks identified issues that were already present in the original dataset, including zero-freight values, duplicate review IDs, 
unusual order timestamps, incomplete product metadata, and geographically implausible coordinates.
The investigation distinguished verified cleaning outcomes from unresolved source-data concerns. 
No unsupported values were fabricated, and no records were deleted solely because they appeared unusual. 
Findings that could not be corrected confidently were preserved and documented for downstream analysis.
