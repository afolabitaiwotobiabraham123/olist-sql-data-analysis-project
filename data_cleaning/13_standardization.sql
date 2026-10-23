Olist E-commerce Data Analysis
Data Cleaning — Standardization Phase

1. Objective
The objective of this phase was to identify and correct inconsistencies in the representation of data across the six Olist clean tables.
The assessment focused on text casing, leading and trailing whitespace, inconsistent city names, URL-encoded text, categorical labels, and identifier formatting.
Corrections were made only where the evidence supported a change. Ambiguous geographic variants and missing values were preserved
rather than changed without sufficient evidence.

2. Tables Covered
The seven clean tables included in this phase are:
1. `olist_customers_clean`
2. `olist_geolocation_clean`
3. `olist_order_items_clean`
4. `olist_order_payments_clean`
5. `olist_order_reviews_clean`
6. `olist_orders_clean`
7. `olist_products_clean`

Scope clarification:
This documentation incorporates the five tables assessed in the recent standardization work and the previously standardized `olist_geolocation_clean`.
The `olist_customers_clean` table was not part of those five recent assessments, so its standardization findings are not independently documented here.

3. Geolocation Standardization
Table: `olist_geolocation_clean`
Objective : 
To standardize supported inconsistencies in city-name representation within the geolocation data while preserving geographic differences 
that could not be resolved confidently.
The clean table had previously been created using `SELECT DISTINCT` to remove completely identical records across the selected columns.
This did not mean every city-name variant was standardized.

Assessment and Findings
Ten ZIP-code prefixes were investigated for city-name inconsistencies:
`13454`, `89610`, `17970`, `06900`, `42850`, `13450`, `09780`, `45936`, `65935`, and `28950`.
The investigation identified different types of issues, including spelling variations, URL-encoded characters, and potentially conflicting geographic information.

Cleaning Decisions and Actions
| ZIP-code prefix | Decision and outcome |
|---|---|
| `13454` | Standardization completed based on the investigated city-name inconsistency. |
| `89610` | Standardization completed based on the investigated city-name inconsistency. |
| `17970` | Four variants representing São João do Pau d'Alho were identified. Fourteen records were standardized to `são joão do pau d'alho`, correcting inconsistent apostrophe representation and URL-encoded text. |
| `06900` | Standardization completed based on the investigated city-name inconsistency. |
| `42850` | Standardization completed based on the investigated city-name inconsistency. |
| `13450` | Standardization completed based on the investigated city-name inconsistency. |
| `09780` | A total of 129 records were standardized to `são bernardo do campo`. Distinct geographic labels were not assumed to be equivalent merely because they appeared related. |
| `45936` | Potential geographic anomalies were flagged. The records were preserved rather than automatically changed because the inconsistencies required further confirmation. |
| `65935` | Two records containing `senador la roque` were standardized to `senador la rocque`. Validation showed 11 records for `senador la rocque`, four for `buritirana`, and one for `buritirama`. The `buritirama` variant remained flagged for further investigation because its geographic consistency was unresolved. |
| `28950` | Partial standardization was completed where supported. Unresolved variants were preserved rather than merged without sufficient evidence. |

Validation
For prefix `17970`, the investigated variants were standardized to `são joão do pau d'alho`.
For prefix `65935`, the update affected two records with no warnings. The resulting counts were:
- `senador la rocque`: 11
- `buritirana`: 4
- `buritirama`: 1
The remaining variants were retained where the evidence did not justify a definitive correction.

Conclusion/Decision
The geolocation standardization work corrected supported city-name inconsistencies while preserving unresolved geographic anomalies for further investigation.
The work was therefore a combination of completed standardization, partial standardization, and documented exceptions.
The unresolved cases should not be described as fully standardized.

4. Order Items Standardization
Table: `olist_order_items_clean`
Objective
To assess order, product, and seller identifiers for inconsistent casing and unnecessary outer whitespace.

SQL Query : 
SELECT
    COUNT(*) AS total_rows,
    SUM(order_id <> TRIM(order_id)) AS order_id_whitespace,
    SUM(product_id <> TRIM(product_id)) AS product_id_whitespace,
    SUM(seller_id <> TRIM(seller_id)) AS seller_id_whitespace,
    SUM(
        BINARY order_id <> BINARY LOWER(order_id)
    ) AS order_id_uppercase,
    SUM(
        BINARY product_id <> BINARY LOWER(product_id)
    ) AS product_id_uppercase,
    SUM(
        BINARY seller_id <> BINARY LOWER(seller_id)
    ) AS seller_id_uppercase
FROM olist_order_items_clean;

Observation/Result
- Total records assessed: 112,650.
- Order IDs with outer whitespace: 0.
- Product IDs with outer whitespace: 0.
- Seller IDs with outer whitespace: 0.
- Uppercase characters detected in the assessed identifiers: 0.

Conclusion/Decision
The assessed identifiers were already consistently represented. 
No standardization update was required for this table.

5. Order Payments Standardization
Table: `olist_order_payments_clean`
Objective
To assess payment method labels for inconsistent casing, empty strings, and unnecessary outer whitespace.

SQL Query : 
SELECT
    payment_type,
    COUNT(*) AS record_count
FROM olist_order_payments_clean
GROUP BY payment_type
ORDER BY payment_type;

Observation/Result
| Payment type | Record count |
|---|---:|
| `credit_card` | 76,795 |
| `boleto` | 19,784 |
| `voucher` | 5,775 |
| `debit_card` | 1,529 |
| `NULL` | 3 |
The four named payment labels were lowercase and consistently formatted. 
Separate checks found zero uppercase labels, zero empty strings, and zero labels with outer whitespace.
The three `NULL` values were retained because the earlier cleaning process had already converted the `not_defined` values to `NULL`.

Conclusion/Decision
No additional standardization update was required for `olist_order_payments_clean`.

6. Order Reviews Standardization
Table:`olist_order_reviews_clean`
Objective : 
To remove unnecessary leading and trailing whitespace from review titles and messages without changing customers' original wording.

6.1 Review Title Assessment
SQL Query :
SELECT
    SUM(
        review_comment_title IS NOT NULL
        AND review_comment_title <> TRIM(review_comment_title)
    ) AS titles_with_outer_whitespace
FROM olist_order_reviews_clean;

Observation/Result
A total of 1,998 review titles contained unnecessary outer whitespace.
Examples included titles such as `Ótimo ` and `Muito bom `.

Cleaning Decision :
Remove only leading and trailing whitespace, preserving the original wording and punctuation.
Cleaning Action : 
UPDATE olist_order_reviews_clean
SET review_comment_title = TRIM(review_comment_title)
WHERE review_comment_title IS NOT NULL
  AND review_comment_title <> TRIM(review_comment_title);

Execution Result
- Rows affected: 1,998.
- Rows matched: 1,998.
- Warnings: 0.

Validation Query : 
SELECT
    SUM(
        review_comment_title IS NOT NULL
        AND review_comment_title <> TRIM(review_comment_title)
    ) AS remaining_title_whitespace
FROM olist_order_reviews_clean;

Validation result: 0 titles with remaining outer whitespace.

6.2 Review Message Assessment
SQL Query : 
SELECT
    SUM(
        review_comment_message IS NOT NULL
        AND review_comment_message <> TRIM(review_comment_message)
    ) AS messages_with_outer_whitespace
FROM olist_order_reviews_clean;

Observation/Result
A total of 8,120 review messages contained unnecessary leading or trailing whitespace.

Cleaning Decision : 
Remove outer whitespace while preserving customers' original comments and internal spacing.

Cleaning Action : 
UPDATE olist_order_reviews_clean
SET review_comment_message = TRIM(review_comment_message)
WHERE review_comment_message IS NOT NULL
  AND review_comment_message <> TRIM(review_comment_message);

Execution Result
- Rows affected: 8,120.
- Rows matched: 8,120.
- Warnings: 0.

Validation Query : 
SELECT
    SUM(
        review_comment_message IS NOT NULL
        AND review_comment_message <> TRIM(review_comment_message)
    ) AS remaining_message_whitespace
FROM olist_order_reviews_clean;

Validation result: 0 messages with remaining outer whitespace.

Conclusion/Decision
The review title and message standardization updates were completed and validated. A total of 1,998 titles and 8,120 messages were updated.

7. Orders Standardization
Table: `olist_orders_clean`
Objective
To assess order status labels and order/customer identifiers for inconsistent casing and unnecessary outer whitespace.

SQL Query — Order Status Assessment
SELECT
    order_status,
    COUNT(*) AS record_count
FROM olist_orders_clean
GROUP BY order_status
ORDER BY order_status;

Observation/Result
| Order status | Record count |
|---|---:|
| `approved` | 2 |
| `canceled` | 625 |
| `created` | 5 |
| `delivered` | 96,478 |
| `invoiced` | 314 |
| `processing` | 301 |
| `shipped` | 1,107 |
| `unavailable` | 609 |
All observed order status labels were lowercase and had no leading or trailing whitespace.
The `order_id` and `customer_id` checks also returned zero for outer whitespace and uppercase characters.
The order timestamp columns were stored using the `DATETIME` data type.

Conclusion/Decision
No additional standardization update was required for the assessed order status labels, identifiers, or datetime formats.
Missing timestamps and temporal anomalies were not automatically changed during this phase because they require separate data-quality investigation.

8. Products Standardization
Table:`olist_products_clean`
Objective
To assess product category labels and product identifiers for inconsistent casing and unnecessary outer whitespace.

8.1 Product Category Assessment
SQL Query : 
SELECT
    product_category_name,
    COUNT(*) AS record_count
FROM olist_products_clean
WHERE product_category_name IS NOT NULL
GROUP BY product_category_name
ORDER BY product_category_name;

Observation/Result
The observed non-`NULL` category labels used lowercase text with underscores separating words.
The category casing and outer-whitespace checks returned:
- Uppercase categories: 0.
- Categories with outer whitespace: 0.

Conclusion/Decision
No standardization update was required for `product_category_name`.
Similar-looking category labels, such as `casa_conforto` and `casa_conforto_2`, 
were not merged because their similarity alone did not establish that they represented the same category.
The 610 `NULL` product category values were retained. Standardization did not justify inventing missing category values.

8.2 Product Identifier Assessment
SQL Query
SELECT
    SUM(product_id <> TRIM(product_id)) AS product_id_whitespace,
    SUM(
        BINARY product_id <> BINARY LOWER(product_id)
    ) AS product_id_uppercase
FROM olist_products_clean;

Observation/Result
- Product IDs with outer whitespace: 0.
- Product IDs containing uppercase characters: 0.

Conclusion/Decision
The assessed product identifiers were already consistent. No standardization update was required.

9. Overall Standardization Summary
| Clean table | Standardization outcome |
|---|---|
| `olist_customers_clean` | Not independently assessed in this documentation |
| `olist_geolocation_clean` | Supported city-name corrections completed; unresolved geographic variants preserved and flagged |
| `olist_order_items_clean` | No identified issues in the assessed identifiers |
| `olist_order_payments_clean` | No additional standardization required |
| `olist_order_reviews_clean` | 1,998 titles and 8,120 messages trimmed |
| `olist_orders_clean` | No identified issues in the assessed statuses and identifiers |
| `olist_products_clean` | No identified issues in the assessed categories and identifiers |

10. Final Conclusion
The standardization work covered in this documentation corrected supported text inconsistencies while avoiding unnecessary changes to already consistent data.
The review text updates were completed and validated.
The geolocation work addressed supported city-name inconsistencies, while ambiguous geographic variants remained preserved for further investigation.
The other assessed tables did not require additional standardization updates based on the checks performed.
