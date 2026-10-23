Olist E-Commerce Data Analysis
Referential Integrity Assessment — SQL Documentation  
Tables:** Orders, Customers, Order Items, Products, Sellers, Payments, Reviews, and Product Category Translations

1. Objective
The objective of this assessment was to evaluate referential integrity across related Olist dataset tables. 
The assessment investigated whether foreign-key-like relationships were maintained between records,
identified missing relationships, and established whether the observed issues originated in the original dataset or were introduced during data cleaning.
The assessment used `LEFT JOIN` queries to identify unmatched records in both directions where appropriate.
Findings were investigated before cleaning decisions were made.

2. Orders → Customers
Objective
Verify that every order references an existing customer.

SQL Query : 
SELECT
    COUNT(*) AS orders_without_matching_customers
FROM olist_orders_clean AS o
LEFT JOIN olist_customers_dataset AS c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

Observation / Result
The query returned 0 orders without matching customers.

Conclusion / Decision
Every order has a corresponding customer record in the table used for the assessment. 
The relationship passed the referential integrity check. No cleaning action was required.

3. Customers → Orders
Objective
Identify customer records without a corresponding order.

SQL Query : 
SELECT
    COUNT(*) AS customers_without_matching_orders
FROM olist_customers_dataset AS c
LEFT JOIN olist_orders_clean AS o
    ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

Observation / Result
The query returned 0 customers without matching orders.

Conclusion / Decision
Every customer record examined has at least one corresponding order.
The relationship passed the check. No cleaning action was required.
This finding does not mean that each customer has only one order.

4. Orders → Order Items
Objective
Identify orders that do not have corresponding order-item records.

SQL Query : 
SELECT
    COUNT(*) AS orders_without_matching_order_items
FROM olist_orders_clean AS o
LEFT JOIN olist_order_items_clean AS oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;

Observation / Result
The query returned 775 orders without matching order items.
A follow-up query grouped these orders by status.
| Order status | Orders without items |
|---|---:|
| unavailable | 603 |
| canceled | 164 |
| created | 5 |
| invoiced | 2 |
| shipped | 1 |
| Total | 775 |
The same status counts were obtained when the orders were compared with the original `olist_order_items_dataset`.
Eight orders with statuses `created`, `invoiced`, or `shipped` were investigated individually. Each had one matching payment record.

Conclusion / Decision
The missing order-item relationships existed in the original dataset and were not introduced by cleaning. 
Order status provides context for many of the missing relationships, but does not conclusively explain every case.
The 775 orders were preserved. No order-item records were fabricated, and no orders were deleted.

5. Order Items → Orders
Objective
Verify that every order-item record references an existing order.

SQL Query : 
SELECT
    COUNT(*) AS order_items_without_matching_orders
FROM olist_order_items_clean AS oi
LEFT JOIN olist_orders_clean AS o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

Observation / Result
The query returned 0 order items without matching orders.

Conclusion / Decision
Every order-item record references an existing order. The relationship passed the check, and no cleaning action was required.
The result does not contradict the 775 orders without items: that earlier check examined the opposite direction of the relationship.

6. Order Items → Products
Objective
Verify that each product referenced by an order item exists in the cleaned products table.

SQL Query : 
SELECT
    COUNT(*) AS order_items_without_matching_products
FROM olist_order_items_clean AS oi
LEFT JOIN olist_products_clean AS p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

Observation / Result
The query returned **0 order items without matching products.

Conclusion / Decision
Every product referenced by an order item exists in `olist_products_clean`. 
The relationship passed the check. No cleaning action was required.

7. Order Items → Sellers
Objective
Verify that every seller referenced by an order item exists in the sellers table.

SQL Query : 
SELECT
    COUNT(*) AS order_items_without_matching_sellers
FROM olist_order_items_clean AS oi
LEFT JOIN olist_sellers_dataset AS s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

Observation / Result
The query returned 0 order items without matching sellers.

Conclusion / Decision
Every seller referenced by an order item has a corresponding record in `olist_sellers_dataset`. 
The relationship passed the check. No cleaning action was required.

8. Orders → Payments
Objective
Identify orders without matching payment records.

SQL Query : 
SELECT
    COUNT(*) AS orders_without_matching_payments
FROM olist_orders_clean AS o
LEFT JOIN olist_order_payments_clean AS p
    ON o.order_id = p.order_id
WHERE p.order_id IS NULL;

Observation / Result
The query returned 1 order without a matching payment record.
The affected order was identified as follows:
| Field | Value |
|---|---|
| Order ID | `bfbd0f9bdef84302105ad712db648a6c` |
| Customer ID | `86dc2ffce2dfff336de2f386a786e574` |
| Order status | delivered |
| Purchase timestamp | 2016-09-15 12:16:38 |
| Approval timestamp | 2016-09-15 12:16:38 |
| Carrier handover | 2016-11-07 17:11:53 |
| Customer delivery | 2016-11-09 07:47:38 |
The order had an approval timestamp and was marked as delivered, but no matching payment record was found.
A validation query against the original `olist_order_payments_dataset` returned 0 matching payment records.

Conclusion / Decision
The missing payment relationship was already present in the original dataset and was not introduced by cleaning.
Because the order was delivered, the missing payment record remains an unresolved data quality finding. 
The order was preserved, and no payment record was fabricated.

9. Payments → Orders
Objective
Verify that every payment record references an existing order.

SQL Query : 
SELECT
    COUNT(*) AS payments_without_matching_orders
FROM olist_order_payments_clean AS p
LEFT JOIN olist_orders_clean AS o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

Observation / Result
The query returned 0 payment records without matching orders.

Conclusion / Decision
Every payment record references an existing order. The relationship passed the check, and no cleaning action was required.

10. Reviews → Orders
Objective
Verify that every review references an existing order.

SQL Query :
SELECT
    COUNT(*) AS reviews_without_matching_orders
FROM olist_order_reviews_clean AS r
LEFT JOIN olist_orders_clean AS o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

Observation / Result
The query returned 0 reviews without matching orders.

Conclusion / Decision
Every review references an existing order. The relationship passed the check, and no cleaning action was required.

11. Products → Category Translations
Objective
Identify distinct product categories without matching entries in the category translation table.

SQL Query : 
SELECT
    COUNT(DISTINCT p.product_category_name)
        AS categories_without_translation
FROM olist_products_clean AS p
LEFT JOIN product_category_name_translation AS t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND t.product_category_name IS NULL;

Observation / Result
The query returned 2 product categories without translations.
The missing categories were identified as:
| Product category | Finding |
|---|---|
| `pc_gamer` | No matching translation |
| `portateis_cozinha_e_preparadores_de_alimentos` | No matching translation |
Previously established product counts showed that the first category affected 3 products and the second affected 10 products, for a total of 13 products.

Conclusion / Decision
The finding represents incomplete reference data rather than proof of invalid product categories.
The category values and associated products were preserved. No product records were deleted, and no unsupported translations were added.

12. Category Translations → Products
Objective
Verify that every category in the translation table has a corresponding product category in the cleaned products table.

SQL Query : 
SELECT
    COUNT(*) AS translations_without_matching_products
FROM product_category_name_translation AS t
LEFT JOIN olist_products_clean AS p
    ON t.product_category_name = p.product_category_name
WHERE p.product_category_name IS NULL;

Observation / Result
The query returned 0 translations without matching products.

Conclusion / Decision
Every translation entry has a matching product category. The relationship passed the check, and no cleaning action was required.
This does not contradict the two missing translations identified in the previous section.
The translation table has no unused category entries, even though two product categories lack translations.

13. Products → Order Items
Objective
Identify products that do not appear in any order-item record.

SQL Query
SELECT
    COUNT(*) AS products_without_order_items
FROM olist_products_clean AS p
LEFT JOIN olist_order_items_clean AS oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

Observation / Result
The query returned 0 products without order items.

Conclusion / Decision
Every product in `olist_products_clean` appears in at least one order-item record. The relationship passed the check, and no cleaning action was required.
This establishes the presence of order-item activity, not that every product was included in a delivered order.

14. Overall Assessment Summary
The assessment identified three findings requiring documentation or further investigation.
| Finding | Result | Source-data verification | Decision |
|---|---:|---|---|
| Orders without order items | 775 | Confirmed in original order-items table | Preserve and document |
| Delivered order without payment | 1 | Confirmed absent from original payments table | Preserve and investigate |
| Product categories without translations | 2 categories; 13 products | Identified in the translation comparison | Preserve categories and document gaps |
The other assessed relationships returned zero unmatched records.

15. Final Conclusion
The referential integrity assessment evaluated relationships among orders, customers, order items, products, sellers, payments, reviews, and category translations.
Most tested relationships passed, with no unmatched records found in the assessed direction. 
Three findings were identified: 775 orders without order items, one delivered order without a payment record, and two product categories without translations
affecting 13 products.
The investigation confirmed that the missing order-item and payment relationships existed in the original dataset rather than being introduced by cleaning. 
The category translation gaps were treated as reference-data completeness issues.
No unsupported corrective changes were made. The identified records and categories were preserved to maintain data traceability and prevent the introduction 
of fabricated information.
