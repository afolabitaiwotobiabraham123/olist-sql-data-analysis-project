REFERENTIAL INTEGRITY ASSESSMENT
TABLE 6 → TABLE 1
Orders → Customers
OBJECTIVE:
-- To verify that every customer_id referenced in the olist_orders_dataset exists in the olist_customers_dataset.
SQL QUERY:
   SELECT
       COUNT(*) AS unmatched_customer_ids
   FROM olist_orders_dataset o
   LEFT JOIN olist_customers_dataset c
       ON o.customer_id = c.customer_id
   WHERE c.customer_id IS NULL;
OBSERVATION:
-- The query returned 0 unmatched customer IDs.
CONCLUSION:
-- Referential integrity between the orders and customers tables is maintained.
-- Every customer_id referenced in the olist_orders_dataset has a corresponding record in the olist_customers_dataset.


REFERENTIAL INTEGRITY ASSESSMENT
TABLE 3 → TABLE 6
Order Items → Orders
OBJECTIVE:
-- To verify that every order_id referenced in the olist_order_items_dataset exists in the olist_orders_dataset.
SQL QUERY:
   SELECT
       COUNT(*) AS unmatched_order_ids
   FROM olist_order_items_dataset oi
   LEFT JOIN olist_orders_dataset o
       ON oi.order_id = o.order_id
   WHERE o.order_id IS NULL;
OBSERVATION:
-- The query returned 0 unmatched order IDs.
CONCLUSION:
-- Referential integrity between the order items and orders tables is maintained. 
-- Every order_id referenced in the olist_order_items_dataset has a corresponding record in the olist_orders_dataset.
REFERENTIAL INTEGRITY ASSESSMENT
TABLE 3 → TABLE 7
Order Items → Products
OBJECTIVE:
-- To verify that every product_id referenced in the olist_order_items_dataset exists in the olist_products_dataset.
SQL QUERY:
   SELECT
       COUNT(*) AS unmatched_product_ids
   FROM olist_order_items_dataset oi
   LEFT JOIN olist_products_dataset p
       ON oi.product_id = p.product_id
   WHERE p.product_id IS NULL;
OBSERVATION:
-- The query returned 0 unmatched product IDs.
CONCLUSION:
-- Referential integrity between the order items and products tables is maintained. 
-- Every product_id referenced in the olist_order_items_dataset has a corresponding record in the olist_products_dataset.

REFERENTIAL INTEGRITY ASSESSMENT
TABLE 3 → TABLE 8
Order Items → Sellers
OBJECTIVE:
-- To verify that every seller_id referenced in the olist_order_items_dataset exists in the olist_sellers_dataset.
SQL QUERY:
   SELECT
       COUNT(*) AS unmatched_seller_ids
   FROM olist_order_items_dataset oi
   LEFT JOIN olist_sellers_dataset s
       ON oi.seller_id = s.seller_id
   WHERE s.seller_id IS NULL;
OBSERVATION:
-- The query returned 0 unmatched seller IDs.
CONCLUSION:
-- Referential integrity between the order items and sellers tables is maintained. 
-- Every seller_id referenced in the olist_order_items_dataset has a corresponding record in the olist_sellers_dataset.

REFERENTIAL INTEGRITY ASSESSMENT
TABLE 4 → TABLE 6
Payments → Orders
OBJECTIVE:
-- To verify that every order_id referenced in the olist_order_payments_dataset exists in the olist_orders_dataset.
SQL QUERY:
   SELECT
       COUNT(*) AS unmatched_order_ids
   FROM olist_order_payments_dataset op
   LEFT JOIN olist_orders_dataset o
       ON op.order_id = o.order_id
   WHERE o.order_id IS NULL;
OBSERVATION:
-- The query returned 0 unmatched order IDs.
CONCLUSION:
-- Referential integrity between the payments and orders tables is maintained. 
-- Every order_id referenced in the olist_order_payments_dataset has a corresponding record in the olist_orders_dataset.


REFERENTIAL INTEGRITY ASSESSMENT
TABLE 5 → TABLE 6
Reviews → Orders
OBJECTIVE:
-- To verify that every order_id referenced in the olist_order_reviews_dataset exists in the olist_orders_dataset.
SQL QUERY:
   SELECT
       COUNT(*) AS unmatched_order_ids
   FROM olist_order_reviews_dataset r
   LEFT JOIN olist_orders_dataset o
       ON r.order_id = o.order_id
   WHERE o.order_id IS NULL;
OBSERVATION:
-- The query returned 0 unmatched order IDs.
CONCLUSION:
-- Referential integrity between the reviews and orders tables is maintained. 
-- Every order_id referenced in the olist_order_reviews_dataset has a corresponding record in the olist_orders_dataset.


REFERENTIAL INTEGRITY ASSESSMENT
TABLE 7 → TABLE 9
Products → Category Translation
OBJECTIVE:
-- To verify that every non-null product_category_name referenced in the olist_products_dataset exists in the product_category_name_translation table.
SQL QUERY:
   SELECT
       COUNT(*) AS unmatched_categories
   FROM olist_products_dataset p
   LEFT JOIN product_category_name_translation t
       ON p.product_category_name = t.product_category_name
   WHERE p.product_category_name IS NOT NULL
     AND t.product_category_name IS NULL;
OBSERVATION:
-- The query returned 1,246 unmatched product categories.
-- This indicates that 1,246 product records contain category values that do not have a corresponding entry in the product_category_name_translation table.
CONCLUSION:
-- Referential integrity between the products and category translation tables is not fully maintained.
-- The unmatched categories may prevent the affected product records from being assigned an English category through the translation table.
