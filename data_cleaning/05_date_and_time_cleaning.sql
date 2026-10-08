FILE: 05_date_and_time_cleaning.sql
PROJECT: Olist E-Commerce Data Analysis
PHASE: Data Cleaning
TOPIC: Date and Time Cleaning

OBJECTIVE
Validate date and timestamp relationships across the Olist dataset and investigate temporal anomalies that could affect the reliability of downstream analysis.
The purpose of this phase is to:
1. Validate chronological relationships between related timestamps.
2. Identify impossible or unusual date/time relationships.
3. Investigate confirmed temporal anomalies.
4. Determine whether identified anomalies can be safely corrected.
5. Preserve original values when the correct replacement cannot be known.
6. Document unresolved temporal anomalies for future analysis.

CLEANING PRINCIPLE
1. Never modify the original/raw tables directly.
2. Do not modify a timestamp unless there is sufficient evidence that the value is incorrect and the correct replacement can be determined.
3. Do not invent replacement timestamps.
4. Preserve valid business records even when temporal anomalies exist.
5. Distinguish between data-quality problems and legitimate business-analysis results.
6. Validate every cleaning decision.
7. Avoid unnecessary transformations.

IMPORTANT NOTE
Zero-date placeholders were addressed during Phase 03: Invalid Value
Cleaning and are not re-cleaned in this phase.
Date & Time Cleaning focuses on chronological consistency and temporal anomalies.

DATE/TIME ASSESSMENT SUMMARY
The date/time assessment produced the following results:
1. olist_order_items_dataset
   - shipping_limit_date contains 112,650 records.
   - 0 NULL values.
   - 0 records where shipping_limit_date occurs before order purchase.
   - 4 unusually large purchase-to-shipping-limit gaps were identified.

2. olist_order_reviews_dataset
   - 99,223 review records were assessed.
   - No valid review-answer-before-review-creation anomalies were identified.
   - Zero-date placeholders were addressed previously during Phase 03.

3. olist_orders_dataset
   - Purchase → Approval: 0 anomalies.
   - Approval → Carrier: 1,359 chronological anomalies.
   - Carrier → Customer Delivery: 23 chronological anomalies.
   - Purchase → Customer Delivery: 0 anomalies.
   - Early/late delivery results were identified as business-analysis results,not cleaning issues.
The remaining anomalies were investigated to determine whether they could be safely corrected.

TABLES REQUIRING DATE/TIME INVESTIGATION
1. olist_order_items_dataset
2. olist_orders_clean
3. olist_order_reviews_clean

TABLES ASSESSED BUT NOT REQUIRING DATE/TIME CLEANING
- olist_customers_dataset
- olist_geolocation_dataset
- olist_order_payments_clean
- olist_products_clean
- olist_sellers_dataset
- product_category_name_translation

SECTION 1: ORDER PURCHASE → APPROVAL
OBJECTIVE
Validate that an order approval timestamp does not occur before the order purchase timestamp.

BUSINESS LOGIC
An order cannot logically be approved before it was placed.

INVESTIGATION
SQL QUERY : 
SELECT
    COUNT(*) AS purchase_approval_anomalies
FROM olist_orders_clean
WHERE order_approved_at IS NOT NULL
  AND order_approved_at < order_purchase_timestamp;

OBSERVATION
Result:
purchase_approval_anomalies - 0
No records were identified where order approval occurred before order purchase.

CONCLUSION
The Purchase → Approval chronological relationship is valid.
No cleaning is required.

SECTION 2: APPROVAL → CARRIER

OBJECTIVE
Identify records where the carrier delivery/handover timestamp occurs before the order approval timestamp.

IDENTIFY ANOMALIES
SQL QUERY : 
SELECT
    COUNT(*) AS approval_carrier_anomalies
FROM olist_orders_clean
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at;

OBSERVATION
Result:
approval_carrier_anomalies - 1,359
A total of 1,359 records contain a carrier timestamp earlier than the approval timestamp.

INVESTIGATE THE ANOMALIES
SQL QUERY : 
SELECT
    order_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    TIMESTAMPDIFF(
        MINUTE,
        order_approved_at,
        order_delivered_carrier_date
    ) AS minutes_difference
FROM olist_orders_clean
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
ORDER BY minutes_difference;

OBSERVATION
The 1,359 records represent chronological inconsistencies between the approval and carrier timestamps.
The available data does not establish whether:
- the approval timestamp is incorrect,
- the carrier timestamp is incorrect,
- or the timestamps reflect a source-system timing issue.

CONCLUSION
The correct replacement value cannot be determined from the available data.

CLEANING DECISION
Preserve the original timestamps.
No UPDATE or DELETE operation is performed.
The anomalies are documented for future investigation.

SECTION 3: CARRIER → CUSTOMER DELIVERY

OBJECTIVE
Identify records where customer delivery occurs before carrier handover.

IDENTIFY ANOMALIES
SQL QUERY : 
SELECT
    COUNT(*) AS carrier_customer_anomalies
FROM olist_orders_clean
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date;

OBSERVATION
Result:
carrier_customer_anomalies - 23
A total of 23 records contain customer delivery timestamps earlier than carrier handover timestamps.

INVESTIGATE THE ANOMALIES
SQL QUERY : 
SELECT
    order_id,
    order_status,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    TIMESTAMPDIFF(
        MINUTE,
        order_delivered_carrier_date,
        order_delivered_customer_date
    ) AS minutes_difference
FROM olist_orders_clean
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date
ORDER BY minutes_difference;

OBSERVATION
The 23 records represent chronological inconsistencies between carrier handover and customer delivery.
The correct timestamp cannot be determined with sufficient confidence.

CONCLUSION
Automatically changing either timestamp would require an unsupported assumption.

CLEANING DECISION
Preserve the original timestamps.
No UPDATE or DELETE operation is performed.
The anomalies are documented for future investigation.

SECTION 4: PURCHASE → CUSTOMER DELIVERY

OBJECTIVE
Validate that customer delivery does not occur before the original order purchase.
SQL QUERY : 
SELECT
    COUNT(*) AS purchase_delivery_anomalies
FROM olist_orders_clean
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp;

OBSERVATION
Result:
purchase_delivery_anomalies - 0
No customer delivery timestamp occurs before the corresponding purchase timestamp.

CONCLUSION
The Purchase → Customer Delivery relationship is valid.
No cleaning is required.

SECTION 5: REVIEW CREATION → REVIEW ANSWER

OBJECTIVE
Validate that a review answer does not occur before the review creation timestamp.
SQL QUERY : 
SELECT
    COUNT(*) AS review_chronology_anomalies
FROM olist_order_reviews_clean
WHERE review_creation_date IS NOT NULL
  AND review_answer_timestamp IS NOT NULL
  AND review_answer_timestamp < review_creation_date;

OBSERVATION
Result:
review_chronology_anomalies - 0
No chronological inconsistency was identified.

CONCLUSION
No cleaning is required.

SECTION 6: SHIPPING LIMIT DATE

OBJECTIVE
Validate shipping_limit_date against the corresponding order purchase timestamp.

CHECK FOR SHIPPING LIMIT BEFORE PURCHASE
SQL QUERY : 
SELECT
    COUNT(*) AS shipping_limit_before_purchase
FROM olist_order_items_dataset AS oi
INNER JOIN olist_orders_clean AS o
    ON oi.order_id = o.order_id
WHERE oi.shipping_limit_date < o.order_purchase_timestamp;

OBSERVATION
Result:
shipping_limit_before_purchase - 0
No shipping limit date occurs before the corresponding order purchase.

CONCLUSION
The basic chronological relationship is valid.

SECTION 7: INVESTIGATION OF UNUSUALLY LARGE SHIPPING LIMIT GAPS

OBJECTIVE
Investigate the four unusually large gaps identified during the assessment.
SQL QUERY :
SELECT
    oi.order_id,
    oi.order_item_id,
    o.order_status,
    o.order_purchase_timestamp,
    oi.shipping_limit_date,
    TIMESTAMPDIFF(
        DAY,
        o.order_purchase_timestamp,
        oi.shipping_limit_date
    ) AS days_between_purchase_and_shipping_limit
FROM olist_order_items_dataset AS oi
INNER JOIN olist_orders_clean AS o
    ON oi.order_id = o.order_id
WHERE YEAR(oi.shipping_limit_date) = 2020
ORDER BY oi.shipping_limit_date;

OBSERVATION
Four unusual records were identified:
1. Order 9c94a4ea2f7876660fa6f1b59b69c8e6
   - Item: 1
   - Status: shipped
   - Purchase → Shipping Limit: 1,056 days
2. Order 13bdf405f961a6deec817d817f5c6624
   - Item: 1
   - Status: canceled
   - Purchase → Shipping Limit: 1,056 days
3. Order c2bb89b5c1dd978d507284be78a04cb2
   - Item: 1
   - Status: delivered
   - Purchase → Shipping Limit: 1,052 days
4. Order c2bb89b5c1dd978d507284be78a04cb2
   - Item: 2
   - Status: delivered
   - Purchase → Shipping Limit: 1,052 days

CLEANING DECISION
The four timestamps are highly unusual but cannot be conclusively proven incorrect from the available dataset.
No reliable replacement timestamps are available.
Therefore:
- Do not modify the timestamps.
- Do not delete the records.
- Preserve the original values.
- Document them as temporal anomalies.

REASON
Changing these timestamps without evidence would introduce fabricated data and could compromise the integrity of the source information.

SECTION 8: DELIVERY PERFORMANCE

OBJECTIVE
Classify delivered orders as early, late, or on-time based on the difference between actual and estimated delivery dates.

IMPORTANT
This is a business-analysis metric rather than a data-cleaning issue.
The results should therefore not be altered during this phase.
SQL QUERY : 
SELECT
    SUM(
        order_delivered_customer_date < order_estimated_delivery_date
    ) AS delivered_early,
    SUM(
        order_delivered_customer_date > order_estimated_delivery_date
    ) AS delivered_late,
    SUM(
        order_delivered_customer_date = order_estimated_delivery_date
    ) AS delivered_on_time
FROM olist_orders_clean
WHERE order_delivered_customer_date IS NOT NULL
  AND order_estimated_delivery_date IS NOT NULL;

OBSERVATION
Assessment results:
Delivered early: 88,649
Delivered late:   7,827
Delivered on time: 0
Records included: 96,476

CONCLUSION
These results describe delivery performance and are not themselves data quality problems.
No cleaning action is required.
The results should be used later during business analysis.

SECTION 9: FINAL DATE/TIME VALIDATION SUMMARY

OBJECTIVE
Summarize the final chronological validation results.
SQL QUERY : 
SELECT
    'Purchase → Approval' AS validation_check,
    COUNT(*) AS anomaly_count,
    'No cleaning required' AS decision
FROM olist_orders_clean
WHERE order_approved_at IS NOT NULL
  AND order_approved_at < order_purchase_timestamp
UNION ALL
SELECT
    'Approval → Carrier',
    COUNT(*),
    'Preserve and document'
FROM olist_orders_clean
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
UNION ALL
SELECT
    'Carrier → Customer Delivery',
    COUNT(*),
    'Preserve and document'
FROM olist_orders_clean
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date
UNION ALL
SELECT
    'Purchase → Customer Delivery',
    COUNT(*),
    'No cleaning required'
FROM olist_orders_clean
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date < order_purchase_timestamp
UNION ALL
SELECT
    'Review Creation → Review Answer',
    COUNT(*),
    'No cleaning required'
FROM olist_order_reviews_clean
WHERE review_creation_date IS NOT NULL
  AND review_answer_timestamp IS NOT NULL
  AND review_answer_timestamp < review_creation_date;

FINAL CLEANING DECISIONS
ISSUE
Zero-date placeholders

DECISION
Already addressed during Phase 03: Invalid Value Cleaning.
No duplicate cleaning operation is performed in this phase.
 
ISSUE
1,359 Approval → Carrier chronological anomalies

DECISION
Preserve and document.
The correct replacement timestamp cannot be determined reliably.

ISSUE
23 Carrier → Customer Delivery chronological anomalies

DECISION
Preserve and document.
The correct replacement timestamp cannot be determined reliably.

ISSUE
4 unusually large shipping-limit date gaps

DECISION
Preserve and document.
The timestamps are anomalous but cannot be conclusively proven invalid.

ISSUE
Valid chronological relationships

DECISION
No change.

ISSUE
Early/late delivery results

DECISION
Business analysis, not data cleaning.

FINAL CONCLUSION
Date and Time Cleaning has been completed.
The phase focused specifically on chronological consistency and temporal anomalies without duplicating the zero-date cleaning already performed during Phase 03.

The assessment confirmed:
- Purchase → Approval: 0 anomalies.
- Approval → Carrier: 1,359 anomalies identified and preserved.
- Carrier → Customer Delivery: 23 anomalies identified and preserved.
- Purchase → Customer Delivery: 0 anomalies.
- Review Creation → Review Answer: 0 anomalies.
- Shipping Limit → Purchase: 0 chronological violations.
- 4 unusually large shipping-limit gaps were investigated and preserved.
- Early/late delivery results were retained as business-analysis metrics.
No unsupported timestamps were invented.
No valid business records were deleted.
No unnecessary transformations were performed.
Known temporal anomalies have been documented for future investigation and business analysis.
