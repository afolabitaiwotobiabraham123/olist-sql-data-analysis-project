FILE: 07_outlier_investigation.sql
PROJECT: Olist E-Commerce Data Analysis
PHASE: Data Cleaning
TOPIC: Outlier Investigation

OBJECTIVE
Identify unusually low or high values in numerical product, order-item, and payment columns using the Interquartile Range (IQR) method.
This phase focuses on INVESTIGATION, not automatic data modification.
The objective is to:
1. Identify values that are statistically unusual compared with the rest of the data.
2. Determine the number of records affected by each potential outlier.
3. Inspect extreme values to understand their possible business meaning.
4. Distinguish legitimate business variation from potential data-quality issues.
5. Identify records that may require further business-rule validation.
6. Preserve valid business values and avoid deleting legitimate records.

IMPORTANT
Outliers are not automatically errors.
For example:
- An expensive product may be legitimate.
- A high freight charge may relate to a heavy or bulky item.
- A large payment may represent a high-value order.
- A product with many photographs may have a detailed product listing.
This phase does NOT automatically delete, replace, or cap outlier values.
The investigation results will support informed decisions in subsequent cleaning and analytical phases.

SOURCE TABLES
1. olist_order_items_dataset
2. olist_order_payments_dataset
3. olist_products_dataset

METHODOLOGY
The Interquartile Range (IQR) method was used to identify potential outliers.
IQR = Q3 - Q1
Lower threshold = Q1 - (1.5 * IQR)
Upper threshold = Q3 + (1.5 * IQR)
Where:
Q1 = First quartile, representing approximately the 25th percentile.
Q3 = Third quartile, representing approximately the 75th percentile.
IQR = The spread of the middle 50% of the observations.
Values below the lower threshold or above the upper threshold are flagged as potential statistical outliers.

IMPORTANT INTERPRETATION
The IQR method identifies statistical unusualness, not business invalidity.
A value can be statistically unusual and still be completely correct.

All flagged values therefore require interpretation before any corrective action is considered.
For product-level investigations, DISTINCT product_id records were used where appropriate because the raw product table contains duplicate product records.

SECTION 1: ORDER ITEM PRICE INVESTIGATION
OBJECTIVE
Identify unusually high product prices in the order-items table and determine whether the extreme prices should be considered potential data-quality issues.

QUERY 1: SUMMARY STATISTICS
SQL QUERY :
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS distinct_orders,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    AVG(price) AS average_price,
    STDDEV_POP(price) AS population_std_dev
FROM olist_order_items_dataset;

RESULT
total_records       = 112650
distinct_orders     = 98666
minimum_price       = 0.85
maximum_price       = 6735.00
average_price       = 120.65
population_std_dev  = 183.63

OBSERVATION
The maximum item price is substantially higher than the average item price.
This indicates that a small number of items have prices considerably above the typical price.
However, the difference alone does not prove that the prices are invalid.

QUERY 2: INVESTIGATE PRICE IQR THRESHOLDS
SQL QUERY : 
WITH ranked_prices AS (
    SELECT
        price,
        NTILE(4) OVER (ORDER BY price) AS quartile
    FROM olist_order_items_dataset
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN price END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN price END) AS q3
    FROM ranked_prices
),
iqr_values AS (
    SELECT
        q1,
        q3,
        q3 - q1 AS iqr
    FROM quartiles
)
SELECT
    q1,
    q3,
    iqr,
    q1 - (1.5 * iqr) AS lower_threshold,
    q3 + (1.5 * iqr) AS upper_threshold
FROM iqr_values;

RESULT
Q1               approximately 39.90
Q3               approximately 134.90
IQR              approximately 95.00
Lower threshold  approximately -102.60
Upper threshold  approximately 277.40

OBSERVATION
Prices above approximately 277.40 fall beyond the calculated upper IQR threshold.
The lower threshold is negative, while observed item prices are positive.
Therefore, the IQR method does not identify a meaningful low-price outlier boundary for this dataset.

QUERY 3: COUNT POTENTIAL HIGH-PRICE OUTLIERS
SQL QUERY : 
WITH ranked_prices AS (
    SELECT
        price,
        NTILE(4) OVER (ORDER BY price) AS quartile
    FROM olist_order_items_dataset
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN price END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN price END) AS q3
    FROM ranked_prices
),
thresholds AS (
    SELECT
        q3 + 1.5 * (q3 - q1) AS upper_threshold
    FROM quartiles
)
SELECT
    COUNT(*) AS potential_outlier_item_records,
    COUNT(DISTINCT order_id) AS affected_orders,
    MIN(price) AS lowest_flagged_price,
    MAX(price) AS highest_flagged_price,
    AVG(price) AS average_flagged_price
FROM olist_order_items_dataset
WHERE price > (SELECT upper_threshold FROM thresholds);

RESULT
potential_outlier_item_records = 8427
affected_orders                = 8055
lowest_flagged_price            = 277.45
highest_flagged_price           = 6735.00
average_flagged_price            = 574.29

OBSERVATION
A total of 8,427 order-item records were flagged as potential high-price outliers, affecting 8,055 orders.
The highest observed item price was 6,735.00.
Several extreme prices were associated with product categories such as computers, electronics, games, watches, sports and household products.

DECISION
The flagged prices are potential statistical outliers, not confirmed errors.
Expensive products can legitimately have prices substantially higher than the typical product price.
No price records are automatically deleted or modified in this phase.
Further investigation should compare unusually high prices with product details, order information, and relevant business rules.

SECTION 2: FREIGHT VALUE INVESTIGATION
OBJECTIVE
Identify unusually low and high freight charges and determine whether the extreme values may require additional business validation.

QUERY 4: FREIGHT SUMMARY STATISTICS
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS distinct_orders,
    MIN(freight_value) AS minimum_freight,
    MAX(freight_value) AS maximum_freight,
    AVG(freight_value) AS average_freight,
    STDDEV_POP(freight_value) AS population_std_dev
FROM olist_order_items_dataset;

RESULT
total_records       = 112650
distinct_orders     = 98666
minimum_freight     = 0.00
maximum_freight     = 409.68
average_freight     = 19.99
population_std_dev  = 15.81

OBSERVATION
Freight values range from zero to 409.68.
The maximum is substantially higher than the average freight charge.
Zero and unusually low freight charges may also require investigation, depending on the applicable shipping and order rules.

QUERY 5: INVESTIGATE FREIGHT IQR THRESHOLDS
SQL QUERY : 
WITH ranked_freight AS (
    SELECT
        freight_value,
        NTILE(4) OVER (ORDER BY freight_value) AS quartile
    FROM olist_order_items_dataset
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN freight_value END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN freight_value END) AS q3
    FROM ranked_freight
),
iqr_values AS (
    SELECT
        q1,
        q3,
        q3 - q1 AS iqr
    FROM quartiles
)
SELECT
    q1,
    q3,
    iqr,
    q1 - (1.5 * iqr) AS lower_threshold,
    q3 + (1.5 * iqr) AS upper_threshold
FROM iqr_values;

RESULT
Q1               approximately 13.08
Q3               approximately 21.15
IQR              approximately 8.07
Lower threshold  approximately 0.975
Upper threshold  approximately 33.255

OBSERVATION
Freight charges below approximately 0.975 or above approximately 33.255 fall outside the calculated IQR boundaries.
The lower boundary is positive, making zero and some low freight charges potential low-end outliers.

QUERY 6: COUNT LOW AND HIGH FREIGHT OUTLIERS
SQL QUERY :
WITH ranked_freight AS (
    SELECT
        freight_value,
        NTILE(4) OVER (ORDER BY freight_value) AS quartile
    FROM olist_order_items_dataset
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN freight_value END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN freight_value END) AS q3
    FROM ranked_freight
),
thresholds AS (
    SELECT
        q1 - 1.5 * (q3 - q1) AS lower_threshold,
        q3 + 1.5 * (q3 - q1) AS upper_threshold
    FROM quartiles
)
SELECT
    SUM(
        CASE
            WHEN freight_value < lower_threshold THEN 1
            ELSE 0
        END
    ) AS low_freight_outlier_records,

    SUM(
        CASE
            WHEN freight_value > upper_threshold THEN 1
            ELSE 0
        END
    ) AS high_freight_outlier_records,

    SUM(
        CASE
            WHEN freight_value < lower_threshold
              OR freight_value > upper_threshold
            THEN 1
            ELSE 0
        END
    ) AS total_potential_outlier_records
FROM olist_order_items_dataset
CROSS JOIN thresholds;

RESULT
low_freight_outlier_records  = 521
high_freight_outlier_records = 11613
total_potential_outlier_records = 12134

OBSERVATION
A total of 12,134 order-item records fell outside the freight IQR boundaries.
Of these:
    521 records had freight below the lower threshold.
    11,613 records had freight above the upper threshold.
The highest freight charge was 409.68.

DECISION
High freight charges may be associated with heavy, bulky, distant, or otherwise expensive-to-ship products.
Zero or low freight charges may also be legitimate, depending on shipping arrangements and promotions.
These records should not be automatically removed.
Further validation should compare freight charges with product weight, product dimensions, order details, and shipping rules.

SECTION 3: PAYMENT VALUE INVESTIGATION

OBJECTIVE
Identify unusually high payment records and determine whether their values may represent legitimate high-value purchases or potential data-quality issues.

QUERY 7: PAYMENT SUMMARY STATISTICS
SQL QUERY : 
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT order_id) AS distinct_orders,
    MIN(payment_value) AS minimum_payment,
    MAX(payment_value) AS maximum_payment,
    AVG(payment_value) AS average_payment,
    STDDEV_POP(payment_value) AS population_std_dev
FROM olist_order_payments_dataset;

RESULT
total_records       = 103886
distinct_orders     = 99440
minimum_payment     = 0.00
maximum_payment     = 13664.10
average_payment     = 154.10
population_std_dev  = 217.49

OBSERVATION
The maximum payment value is much higher than the average payment value.
The payment table also contains more records than distinct orders because an order can have multiple payment records.

QUERY 8: INVESTIGATE PAYMENT IQR THRESHOLDS
SQL QUERY : 
WITH ranked_payments AS (
    SELECT
        payment_value,
        NTILE(4) OVER (ORDER BY payment_value) AS quartile
    FROM olist_order_payments_dataset
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN payment_value END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN payment_value END) AS q3
    FROM ranked_payments
),
iqr_values AS (
    SELECT
        q1,
        q3,
        q3 - q1 AS iqr
    FROM quartiles
)
SELECT
    q1,
    q3,
    iqr,
    q1 - (1.5 * iqr) AS lower_threshold,
    q3 + (1.5 * iqr) AS upper_threshold
FROM iqr_values;

RESULT
Q1               approximately 56.79
Q3               approximately 171.84
IQR              approximately 115.05
Lower threshold  approximately -115.78
Upper threshold  approximately 344.415

OBSERVATION
Payment values above approximately 344.415 fall beyond the upper IQR threshold.
The lower threshold is negative, while observed payment values are non-negative. 
Therefore, the IQR method does not identify a meaningful low-payment outlier boundary for this dataset.

QUERY 9: COUNT POTENTIAL HIGH-PAYMENT OUTLIERS
SQL QUERY : 
WITH ranked_payments AS (
    SELECT
        payment_value,
        NTILE(4) OVER (ORDER BY payment_value) AS quartile
    FROM olist_order_payments_dataset
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN payment_value END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN payment_value END) AS q3
    FROM ranked_payments
),
thresholds AS (
    SELECT
        q3 + 1.5 * (q3 - q1) AS upper_threshold
    FROM quartiles
)
SELECT
    COUNT(*) AS potential_outlier_payment_records,
    COUNT(DISTINCT order_id) AS affected_orders,
    MIN(payment_value) AS lowest_flagged_payment,
    MAX(payment_value) AS highest_flagged_payment,
    AVG(payment_value) AS average_flagged_payment
FROM olist_order_payments_dataset
WHERE payment_value > (SELECT upper_threshold FROM thresholds);

RESULT
potential_outlier_payment_records = 7981
affected_orders                  = 7945
lowest_flagged_payment            = 344.44
highest_flagged_payment           = 13664.10
average_flagged_payment           = 683.29

OBSERVATION
A total of 7,981 payment records were flagged as potential high-payment outliers, affecting 7,945 distinct orders.
The highest observed payment value was 13,664.10.
Inspection of the largest payment records showed different payment types, including credit card, debit card, and boleto. 
Some records also involved multiple payment installments.

DECISION
High payment values are not automatically invalid.
They may represent legitimate high-value purchases.
Further validation should compare payment records with order totals and the applicable payment business rules.
No payment values are automatically deleted or modified in this phase.

SECTION 4: PRODUCT WEIGHT INVESTIGATION
OBJECTIVE
Identify unusually heavy products and investigate whether their weights appear reasonable in the context of their product categories and dimensions.

IMPORTANT
The raw product table contains duplicate product records.
Product-level statistics in this section use DISTINCT product_id records to avoid counting duplicate product records as separate products.

QUERY 10: PRODUCT WEIGHT SUMMARY
SQL QUERY : 
SELECT
    COUNT(*) AS total_product_records,
    SUM(
        CASE
            WHEN product_weight_g IS NULL THEN 1
            ELSE 0
        END
    ) AS null_weights,
    SUM(
        CASE
            WHEN product_weight_g = 0 THEN 1
            ELSE 0
        END
    ) AS zero_weights,
    MIN(product_weight_g) AS minimum_weight,
    MAX(product_weight_g) AS maximum_weight,
    AVG(product_weight_g) AS average_weight,
    STDDEV_POP(product_weight_g) AS population_std_dev
FROM (
    SELECT DISTINCT
        product_id,
        product_weight_g
    FROM olist_products_dataset
) AS distinct_products;

RESULT
total_product_records = 32951
null_weights          = 0
zero_weights          = 6
minimum_weight        = 0
maximum_weight        = 40425
average_weight        = 2276.33
population_std_dev    = 4281.88

OBSERVATION
The distinct-product assessment identified six products with zero weight.
The maximum recorded weight was 40,425 grams.
The substantial difference between the average and maximum weight indicates that some products are much heavier than the typical product.

QUERY 11: INVESTIGATE PRODUCT WEIGHT IQR THRESHOLDS
SQL QUERY : 
WITH distinct_products AS (
    SELECT DISTINCT
        product_id,
        product_weight_g
    FROM olist_products_dataset
),
ranked_weights AS (
    SELECT
        product_weight_g,
        NTILE(4) OVER (ORDER BY product_weight_g) AS quartile
    FROM distinct_products
    WHERE product_weight_g IS NOT NULL
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN product_weight_g END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN product_weight_g END) AS q3
    FROM ranked_weights
),
iqr_values AS (
    SELECT
        q1,
        q3,
        q3 - q1 AS iqr
    FROM quartiles
)
SELECT
    q1,
    q3,
    iqr,
    q1 - (1.5 * iqr) AS lower_threshold,
    q3 + (1.5 * iqr) AS upper_threshold
FROM iqr_values;

RESULT
Q1               = 300
Q3               = 1900
IQR              = 1600
Lower threshold  = -2100
Upper threshold  = 4300

OBSERVATION
Products weighing more than 4,300 grams fall beyond the upper IQR threshold.
The lower threshold is negative, so non-negative product weights cannot fall below this lower boundary.

QUERY 12: COUNT POTENTIAL HIGH-WEIGHT OUTLIERS
SQL QUERY : 
WITH distinct_products AS (
    SELECT DISTINCT
        product_id,
        product_weight_g
    FROM olist_products_dataset
),
ranked_weights AS (
    SELECT
        product_weight_g,
        NTILE(4) OVER (ORDER BY product_weight_g) AS quartile
    FROM distinct_products
    WHERE product_weight_g IS NOT NULL
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN product_weight_g END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN product_weight_g END) AS q3
    FROM ranked_weights
),
thresholds AS (
    SELECT
        q3 + 1.5 * (q3 - q1) AS upper_threshold
    FROM quartiles
)
SELECT
    COUNT(*) AS potential_outlier_products,
    MIN(product_weight_g) AS lowest_flagged_weight,
    MAX(product_weight_g) AS highest_flagged_weight,
    AVG(product_weight_g) AS average_flagged_weight
FROM distinct_products
WHERE product_weight_g > (SELECT upper_threshold FROM thresholds);

RESULT
potential_outlier_products = 4551
lowest_flagged_weight      = 4315
highest_flagged_weight     = 40425
average_flagged_weight    = 10938.93

OBSERVATION
A total of 4,551 distinct products were flagged as potential high-weight outliers.
Inspection of the largest weights showed multiple products recorded at 30,000 grams across different product categories.
Some heavy products may be legitimate furniture, sports equipment, household items, or other bulky goods.
However, repeated extreme weights may also justify checking product dimensions and source-data conventions.

QUERY 13: CHECK FOR NEGATIVE PRODUCT WEIGHTS
SQL QUERY : 
SELECT
    product_id,
    product_weight_g
FROM olist_products_dataset
WHERE product_weight_g < 0;

RESULT
0 rows returned.

DECISION
No negative product weights were identified.
The six zero-weight products and the unusually heavy products remain investigation candidates.
No weight values are automatically modified in this phase.
Further validation should compare weights with product dimensions, categories, and source-data expectations.

SECTION 5: PRODUCT DIMENSION INVESTIGATION

OBJECTIVE
Identify unusually large product dimensions and investigate zero-length, zero-height, or zero-width records.

QUERY 14: PRODUCT DIMENSION SUMMARY
SQL QUERY : 
SELECT
    'length' AS dimension_name,
    COUNT(*) AS total_products,
    SUM(
        CASE
            WHEN product_length_cm = 0 THEN 1
            ELSE 0
        END
    ) AS zero_values,
    MIN(product_length_cm) AS minimum_value,
    MAX(product_length_cm) AS maximum_value
FROM (
    SELECT DISTINCT
        product_id,
        product_length_cm
    FROM olist_products_dataset
) AS products

UNION ALL

SELECT
    'height',
    COUNT(*),
    SUM(CASE WHEN product_height_cm = 0 THEN 1 ELSE 0 END),
    MIN(product_height_cm),
    MAX(product_height_cm)
FROM (
    SELECT DISTINCT
        product_id,
        product_height_cm
    FROM olist_products_dataset
) AS products

UNION ALL

SELECT
    'width',
    COUNT(*),
    SUM(CASE WHEN product_width_cm = 0 THEN 1 ELSE 0 END),
    MIN(product_width_cm),
    MAX(product_width_cm)
FROM (
    SELECT DISTINCT
        product_id,
        product_width_cm
    FROM olist_products_dataset
) AS products;

RESULT
DIMENSION   ZERO VALUES   MINIMUM   MAXIMUM
length      2             0         105
height      2             0         105
width       2             0         118

OBSERVATION
Each dimension contains two zero values among the distinct product records.
The maximum observed dimensions were:
    Length = 105 cm
    Height = 105 cm
    Width  = 118 cm
Zero dimensions may indicate incomplete product measurements or special source-data conventions. They should be checked before being treated as confirmed errors.

QUERY 15: INVESTIGATE DIMENSION IQR THRESHOLDS
SQL QUERY : 
WITH distinct_products AS (
    SELECT DISTINCT
        product_id,
        product_length_cm,
        product_height_cm,
        product_width_cm
    FROM olist_products_dataset
),
ranked_dimensions AS (
    SELECT
        'length' AS dimension_name,
        product_length_cm AS dimension_value,
        NTILE(4) OVER (ORDER BY product_length_cm) AS quartile
    FROM distinct_products
    WHERE product_length_cm IS NOT NULL

    UNION ALL

    SELECT
        'height',
        product_height_cm,
        NTILE(4) OVER (ORDER BY product_height_cm)
    FROM distinct_products
    WHERE product_height_cm IS NOT NULL

    UNION ALL

    SELECT
        'width',
        product_width_cm,
        NTILE(4) OVER (ORDER BY product_width_cm)
    FROM distinct_products
    WHERE product_width_cm IS NOT NULL
),
quartiles AS (
    SELECT
        dimension_name,
        MAX(CASE WHEN quartile = 1 THEN dimension_value END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN dimension_value END) AS q3
    FROM ranked_dimensions
    GROUP BY dimension_name
)
SELECT
    dimension_name,
    q1,
    q3,
    q3 - q1 AS iqr,
    q1 - 1.5 * (q3 - q1) AS lower_threshold,
    q3 + 1.5 * (q3 - q1) AS upper_threshold
FROM quartiles
ORDER BY dimension_name;

RESULT
DIMENSION   Q1    Q3    IQR   LOWER     UPPER
length      18    38    20    -12       68
height      8     21    13    -11.5     40.5
width       15    30    15    -7.5      52.5

OBSERVATION
The upper IQR boundaries were:
    Length > 68 cm
    Height > 40.5 cm
    Width  > 52.5 cm
The lower boundaries are negative. Therefore, non-negative dimensions do not fall below the lower IQR boundaries.

QUERY 16: COUNT HIGH-DIMENSION OUTLIERS
SQL QUERY :
WITH distinct_products AS (
    SELECT DISTINCT
        product_id,
        product_length_cm,
        product_height_cm,
        product_width_cm
    FROM olist_products_dataset
),
ranked_dimensions AS (
    SELECT
        'length' AS dimension_name,
        product_length_cm AS dimension_value,
        NTILE(4) OVER (ORDER BY product_length_cm) AS quartile
    FROM distinct_products
    WHERE product_length_cm IS NOT NULL

    UNION ALL

    SELECT
        'height',
        product_height_cm,
        NTILE(4) OVER (ORDER BY product_height_cm)
    FROM distinct_products
    WHERE product_height_cm IS NOT NULL

    UNION ALL

    SELECT
        'width',
        product_width_cm,
        NTILE(4) OVER (ORDER BY product_width_cm)
    FROM distinct_products
    WHERE product_width_cm IS NOT NULL
),
quartiles AS (
    SELECT
        dimension_name,
        MAX(CASE WHEN quartile = 1 THEN dimension_value END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN dimension_value END) AS q3
    FROM ranked_dimensions
    GROUP BY dimension_name
),
thresholds AS (
    SELECT
        dimension_name,
        q3 + 1.5 * (q3 - q1) AS upper_threshold
    FROM quartiles
)
SELECT
    d.dimension_name,
    COUNT(*) AS potential_outlier_products,
    MIN(d.dimension_value) AS lowest_flagged_dimension,
    MAX(d.dimension_value) AS highest_flagged_dimension
FROM ranked_dimensions AS d
JOIN thresholds AS t
    ON d.dimension_name = t.dimension_name
WHERE d.dimension_value > t.upper_threshold
GROUP BY d.dimension_name
ORDER BY d.dimension_name;

RESULT
DIMENSION   POTENTIAL OUTLIERS   LOWEST FLAGGED   HIGHEST FLAGGED
length      1380                 69               105
height      1892                 41               105
width       912                  53               118

OBSERVATION
A number of products have dimensions above the calculated IQR boundaries.
These values may be legitimate for large or bulky products.
The zero dimension values are also candidates for completeness and business-rule validation.


DECISION
No dimension values are automatically deleted or changed.
Further validation should compare product dimensions with product weight, category, and expected physical measurements.

SECTION 6: PRODUCT PHOTO COUNT INVESTIGATION
OBJECTIVE
Identify products with unusually high photo counts and investigate listings that contain no product photographs.

QUERY 17: PRODUCT PHOTO COUNT SUMMARY
SQL QUERY : 
SELECT
    COUNT(*) AS total_products,
    SUM(
        CASE
            WHEN product_photos_qty = 0 THEN 1
            ELSE 0
        END
    ) AS zero_photo_products,
    MIN(product_photos_qty) AS minimum_photo_count,
    MAX(product_photos_qty) AS maximum_photo_count,
    AVG(product_photos_qty) AS average_photo_count,
    STDDEV_POP(product_photos_qty) AS population_std_dev
FROM (
    SELECT DISTINCT
        product_id,
        product_photos_qty
    FROM olist_products_dataset
) AS distinct_products;

RESULT
total_products       = 32951
zero_photo_products  = 610
minimum_photo_count = 0
maximum_photo_count = 20
average_photo_count = 2.15
population_std_dev  = 1.75

OBSERVATION
A total of 610 distinct products have zero recorded photos.
The maximum photo count is 20, compared with an average of approximately 2.15 photos per product.

QUERY 18: INVESTIGATE PHOTO COUNT IQR THRESHOLDS
SQL QUERY :
WITH distinct_products AS (
    SELECT DISTINCT
        product_id,
        product_photos_qty
    FROM olist_products_dataset
),
ranked_photos AS (
    SELECT
        product_photos_qty,
        NTILE(4) OVER (ORDER BY product_photos_qty) AS quartile
    FROM distinct_products
    WHERE product_photos_qty IS NOT NULL
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN product_photos_qty END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN product_photos_qty END) AS q3
    FROM ranked_photos
)
SELECT
    q1,
    q3,
    q3 - q1 AS iqr,
    q1 - 1.5 * (q3 - q1) AS lower_threshold,
    q3 + 1.5 * (q3 - q1) AS upper_threshold
FROM quartiles;

RESULT
Q1               = 1
Q3               = 3
IQR              = 2
Lower threshold  = -2
Upper threshold  = 6

QUERY 19: COUNT HIGH PHOTO COUNT OUTLIERS
SQL QUERY
WITH distinct_products AS (
    SELECT DISTINCT
        product_id,
        product_photos_qty
    FROM olist_products_dataset
),
ranked_photos AS (
    SELECT
        product_photos_qty,
        NTILE(4) OVER (ORDER BY product_photos_qty) AS quartile
    FROM distinct_products
    WHERE product_photos_qty IS NOT NULL
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN product_photos_qty END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN product_photos_qty END) AS q3
    FROM ranked_photos
),
thresholds AS (
    SELECT
        q3 + 1.5 * (q3 - q1) AS upper_threshold
    FROM quartiles
)
SELECT
    COUNT(*) AS potential_outlier_products,
    MIN(product_photos_qty) AS lowest_flagged_photo_count,
    MAX(product_photos_qty) AS highest_flagged_photo_count,
    AVG(product_photos_qty) AS average_flagged_photo_count
FROM distinct_products
WHERE product_photos_qty > (SELECT upper_threshold FROM thresholds);

RESULT
potential_outlier_products       = 849
lowest_flagged_photo_count       = 7
highest_flagged_photo_count      = 20
average_flagged_photo_count      = 8.55

OBSERVATION
A total of 849 products have more than six photos and are flagged as potential high-count outliers.
A high photo count may reflect a detailed product listing rather than a data-quality problem.
In contrast, the 610 products with zero photos may require a completeness review, depending on the dataset's listing rules.

DECISION
High photo counts are retained because they may be legitimate.
Zero-photo products are recorded as candidates for further completeness investigation.
No photo counts are automatically modified in this phase.

SECTION 7: PRODUCT NAME AND DESCRIPTION LENGTH INVESTIGATION
OBJECTIVE
Identify unusually short product names, unusually long descriptions, and products with empty name or description fields.

QUERY 20: PRODUCT TEXT LENGTH SUMMARY
SQL QUERY : 
SELECT
    COUNT(*) AS total_products,
    SUM(
        CASE
            WHEN CHAR_LENGTH(product_name) = 0 THEN 1
            ELSE 0
        END
    ) AS zero_name_length,
    MIN(CHAR_LENGTH(product_name)) AS minimum_name_length,
    MAX(CHAR_LENGTH(product_name)) AS maximum_name_length,
    AVG(CHAR_LENGTH(product_name)) AS average_name_length,

    SUM(
        CASE
            WHEN CHAR_LENGTH(product_description) = 0 THEN 1
            ELSE 0
        END
    ) AS zero_description_length,

    MIN(CHAR_LENGTH(product_description)) AS minimum_description_length,
    MAX(CHAR_LENGTH(product_description)) AS maximum_description_length,
    AVG(CHAR_LENGTH(product_description)) AS average_description_length

FROM (
    SELECT DISTINCT
        product_id,
        product_name,
        product_description
    FROM olist_products_dataset
) AS distinct_products;

RESULT
total_products                = 32951
zero_name_length              = 610
minimum_name_length           = 0
maximum_name_length           = 76
average_name_length           = 47.58
zero_description_length      = 610
minimum_description_length   = 0
maximum_description_length   = 3992
average_description_length   = 757.21

OBSERVATION
A total of 610 distinct products have zero-length names, and 610 have zero-length descriptions.
Product names range from zero to 76 characters.
Product descriptions range from zero to 3,992 characters.
The empty text fields may represent missing product information and deserve further completeness investigation.

QUERY 21: INVESTIGATE PRODUCT NAME LENGTH IQR
SQL QUERY : 
WITH distinct_products AS (
    SELECT DISTINCT
        product_id,
        CHAR_LENGTH(product_name) AS name_length
    FROM olist_products_dataset
),
ranked_names AS (
    SELECT
        name_length,
        NTILE(4) OVER (ORDER BY name_length) AS quartile
    FROM distinct_products
    WHERE name_length IS NOT NULL
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN name_length END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN name_length END) AS q3
    FROM ranked_names
)
SELECT
    q1,
    q3,
    q3 - q1 AS iqr,
    q1 - 1.5 * (q3 - q1) AS lower_threshold,
    q3 + 1.5 * (q3 - q1) AS upper_threshold
FROM quartiles;

RESULT
Q1               = 41
Q3               = 57
IQR              = 16
Lower threshold  = 17
Upper threshold  = 81

OBSERVATION
Names shorter than 17 characters fall below the lower IQR boundary.
The maximum observed name length is 76 characters, which is below the calculated upper boundary of 81 characters.

QUERY 22: COUNT SHORT AND LONG PRODUCT NAME OUTLIERS
SQL QUERY : 
WITH distinct_products AS (
    SELECT DISTINCT
        product_id,
        CHAR_LENGTH(product_name) AS name_length
    FROM olist_products_dataset
),
ranked_names AS (
    SELECT
        name_length,
        NTILE(4) OVER (ORDER BY name_length) AS quartile
    FROM distinct_products
    WHERE name_length IS NOT NULL
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN name_length END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN name_length END) AS q3
    FROM ranked_names
),
thresholds AS (
    SELECT
        q1 - 1.5 * (q3 - q1) AS lower_threshold,
        q3 + 1.5 * (q3 - q1) AS upper_threshold
    FROM quartiles
)
SELECT
    SUM(
        CASE
            WHEN name_length < lower_threshold THEN 1
            ELSE 0
        END
    ) AS short_name_outliers,

    SUM(
        CASE
            WHEN name_length > upper_threshold THEN 1
            ELSE 0
        END
    ) AS long_name_outliers,

    MIN(
        CASE
            WHEN name_length < lower_threshold THEN name_length
        END
    ) AS minimum_flagged_name_length,

    MAX(
        CASE
            WHEN name_length < lower_threshold THEN name_length
        END
    ) AS maximum_flagged_name_length
FROM distinct_products
CROSS JOIN thresholds;

RESULT
short_name_outliers          = 740
long_name_outliers           = 0
minimum_flagged_name_length  = 0
maximum_flagged_name_length  = 16

OBSERVATION
A total of 740 products have names shorter than the lower IQR boundary.
The flagged group includes zero-length names and names containing between one and 16 characters.
No product names exceed the calculated upper IQR boundary.

QUERY 23: INVESTIGATE DESCRIPTION LENGTH IQR
SQL QUERY : 
WITH distinct_products AS (
    SELECT DISTINCT
        product_id,
        CHAR_LENGTH(product_description) AS description_length
    FROM olist_products_dataset
),
ranked_descriptions AS (
    SELECT
        description_length,
        NTILE(4) OVER (ORDER BY description_length) AS quartile
    FROM distinct_products
    WHERE description_length IS NOT NULL
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN description_length END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN description_length END) AS q3
    FROM ranked_descriptions
)
SELECT
    q1,
    q3,
    q3 - q1 AS iqr,
    q1 - 1.5 * (q3 - q1) AS lower_threshold,
    q3 + 1.5 * (q3 - q1) AS upper_threshold
FROM quartiles;

RESULT
Q1               = 326
Q3               = 961
IQR              = 635
Lower threshold  = -626.5
Upper threshold  = 1913.5

OBSERVATION
Descriptions longer than approximately 1,913.5 characters fall above the upper IQR boundary.
The lower threshold is negative, so non-negative description lengths cannot fall below this boundary.

QUERY 24: COUNT LONG DESCRIPTION OUTLIERS
SQL QUERY : 
WITH distinct_products AS (
    SELECT DISTINCT
        product_id,
        CHAR_LENGTH(product_description) AS description_length
    FROM olist_products_dataset
),
ranked_descriptions AS (
    SELECT
        description_length,
        NTILE(4) OVER (ORDER BY description_length) AS quartile
    FROM distinct_products
    WHERE description_length IS NOT NULL
),
quartiles AS (
    SELECT
        MAX(CASE WHEN quartile = 1 THEN description_length END) AS q1,
        MAX(CASE WHEN quartile = 3 THEN description_length END) AS q3
    FROM ranked_descriptions
),
thresholds AS (
    SELECT
        q3 + 1.5 * (q3 - q1) AS upper_threshold
    FROM quartiles
)
SELECT
    COUNT(*) AS potential_outlier_descriptions,
    MAX(description_length) AS maximum_flagged_description_length
FROM distinct_products
WHERE description_length > (SELECT upper_threshold FROM thresholds);

RESULT
potential_outlier_descriptions       = 2096
maximum_flagged_description_length   = 3992

OBSERVATION
A total of 2,096 products have descriptions longer than the upper IQR boundary.
Long descriptions may contain useful product information and are not automatically considered invalid.
The 610 zero-length descriptions are completeness candidates rather than high-length statistical outliers.

DECISION
Short product names and empty text fields should be reviewed for completeness and business usefulness.
Long descriptions are retained unless a separate business rule establishes that a description is invalid.
No product names or descriptions are automatically deleted or rewritten in this phase.

FINAL PHASE 07 SUMMARY
INVESTIGATIONS COMPLETED
1. ORDER ITEM PRICE
   Total item records: 112650
   Potential high-price outlier records: 8427
   Affected orders: 8055
   Highest item price: 6735.00
   Decision: Retain values pending business validation.

2. FREIGHT VALUE
   Total item records: 112650
   Potential low-freight outlier records: 521
   Potential high-freight outlier records: 11613
   Total potential outlier records: 12134
   Highest freight value: 409.68
   Decision: Investigate against product characteristics and shipping rules.

3. PAYMENT VALUE
   Total payment records: 103886
   Potential high-payment outlier records: 7981
   Affected orders: 7945
   Highest payment value: 13664.10
   Decision: Retain values pending comparison with order totals and payment rules.
  
4. PRODUCT WEIGHT
   Distinct products: 32951
   Zero-weight products: 6
   Potential high-weight outlier products: 4551
   Highest product weight: 40425 grams
   Negative-weight records: 0
   Decision: Investigate extreme weights against product dimensions and categories.

5. PRODUCT DIMENSIONS
   Zero length values: 2
   Zero height values: 2
   Zero width values: 2
   Potential high-length outlier products: 1380
   Potential high-height outlier products: 1892
   Potential high-width outlier products: 912
   Decision:Review unusual dimensions and zero measurements against product characteristics and expected data-entry rules.

6. PRODUCT PHOTO COUNT
   Distinct products: 32951
   Products with zero photos: 610
   Potential high-photo-count outlier products: 849
   Highest photo count: 20
   Decision: High photo counts are retained. Zero-photo products may require a completeness review.
       
7. PRODUCT NAME AND DESCRIPTION LENGTH
   Products with zero-length names: 610
   Products with zero-length descriptions: 610
   Potential short-name outliers: 740
   Potential long-description outliers: 2096
   Maximum product name length: 76 characters
   Maximum description length: 3992 characters
   Decision: Review short or empty text fields for completeness. Retain long descriptions unless business rules establish otherwise.

IMPORTANT INTERPRETATION
The counts above describe potential outliers within individual columns.
They must not be added together to calculate a total number of affected products or orders because the same product or order may be flagged by
multiple investigations.
Similarly, the IQR method does not establish that a record is incorrect.
A potential outlier becomes a confirmed data-quality issue only when additional evidence, such as business rules, source documentation,
cross-column validation, or related-table comparisons, supports that conclusion.

FINAL DECISION
Phase 07 Outlier Investigation is COMPLETE.
The investigation identified statistically unusual values in item prices, freight charges, payments, product weights, product dimensions, photo
counts, and product text lengths.
No outlier values were automatically deleted, capped, or replaced.
This preserves legitimate business variation while documenting records that may require further investigation.
The results can support subsequent data-quality validation, SQL analysis, Python/Pandas analysis, and Power BI reporting.
