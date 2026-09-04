CROSS-TABLE CONSISTENCY ASSESSMENT
ORDERS ↔ ORDER ITEMS
OBJECTIVE:
-- To assess consistency between the olist_orders_dataset and olist_order_items_dataset by identifying orders without
-- corresponding order-item records and order items associated with canceled or unavailable orders.
CHECK 1: ORDERS WITHOUT ORDER ITEMS
SQL QUERY:
   SELECT
       COUNT(*) AS orders_without_items
   FROM olist_orders_dataset o
   LEFT JOIN olist_order_items_dataset oi
       ON o.order_id = oi.order_id
   WHERE oi.order_id IS NULL;
OBSERVATION:
-- The query identified 775 orders without corresponding order-item records.
FOLLOW-UP SQL QUERY:
   SELECT
       o.order_status,
       COUNT(*) AS occurrence_count
   FROM olist_orders_dataset o
   LEFT JOIN olist_order_items_dataset oi
       ON o.order_id = oi.order_id
   WHERE oi.order_id IS NULL
   GROUP BY o.order_status
   ORDER BY occurrence_count DESC;
FOLLOW-UP OBSERVATION:
-- Of the 775 orders without order items, 603 were classified as unavailable and 164 as canceled.
-- The remaining orders consisted of 5 created, 2 invoiced, and 1 shipped order.
CHECK 2: ORDER ITEMS ASSOCIATED WITH CANCELED OR UNAVAILABLE ORDERS
SQL QUERY:
   SELECT
       o.order_status,
       COUNT(*) AS order_item_records
   FROM olist_order_items_dataset oi
   INNER JOIN olist_orders_dataset o
       ON oi.order_id = o.order_id
   WHERE o.order_status IN ('canceled', 'unavailable')
   GROUP BY o.order_status;
OBSERVATION:
-- The query identified 542 order-item records associated with canceled orders and 7 order-item records associated with unavailable orders.
CONCLUSION:
-- The cross-table assessment identified 775 orders without corresponding order-item records. 
-- The majority (767) were either unavailable or canceled, suggesting that the absence of order items is largely associated with unsuccessful orders.
-- Additionally, 549 order-item records were associated with canceled or unavailable orders. 
-- This does not necessarily indicate a data inconsistency, as order items may have been recorded before the order status subsequently changed.
-- However, 8 orders with created, invoiced, or shipped statuses lack corresponding order-item records and may warrant further investigation.


CROSS-TABLE CONSISTENCY ASSESSMENT
ORDERS ↔ PAYMENTS
OBJECTIVE:
-- To assess whether orders recorded in the olist_orders_dataset have corresponding payment records in the olist_order_payments_dataset.
SQL QUERY:
   SELECT
       COUNT(*) AS orders_without_payments
   FROM olist_orders_dataset o
   LEFT JOIN olist_order_payments_dataset p
       ON o.order_id = p.order_id
   WHERE p.order_id IS NULL;
OBSERVATION:
-- The query identified 1 order without a corresponding payment record.
FOLLOW-UP SQL QUERY:
   SELECT
       o.order_id,
       o.customer_id,
       o.order_status,
       o.order_purchase_timestamp,
       o.order_approved_at,
       o.order_delivered_carrier_date,
       o.order_delivered_customer_date
   FROM olist_orders_dataset o
   LEFT JOIN olist_order_payments_dataset p
       ON o.order_id = p.order_id
   WHERE p.order_id IS NULL;
FOLLOW-UP OBSERVATION:
The unmatched order has a status of 'delivered' and contains valid purchase, approval, carrier delivery, and customer delivery timestamps.
CONCLUSION:
-- One delivered order has no corresponding payment record.
-- Since the order was approved and successfully delivered, the absence of a payment record represents a cross-table
-- consistency exception that may require further investigation.

CROSS-TABLE CONSISTENCY ASSESSMENT
ORDERS ↔ REVIEWS
OBJECTIVE:
-- To assess the presence of review records for orders that have a delivered status.
SQL QUERY:
   SELECT
       COUNT(*) AS delivered_orders_without_reviews
   FROM olist_orders_dataset o
   LEFT JOIN olist_order_reviews_dataset r
       ON o.order_id = r.order_id
   WHERE o.order_status = 'delivered'
     AND r.order_id IS NULL;
OBSERVATION:
-- The query identified 647 delivered orders without corresponding review records.
CONCLUSION:
-- A number of delivered orders do not have associated review records. 
-- This does not necessarily indicate a data inconsistency, as customers are not required to submit a review after receiving an order. 
-- The finding therefore represents an absence of customer feedback rather than confirmed data corruption.

CHECK 2: REVIEWS ASSOCIATED WITH NON-DELIVERED ORDERS
SQL QUERY:
   SELECT
       o.order_status,
       COUNT(*) AS review_records
   FROM olist_order_reviews_dataset r
   INNER JOIN olist_orders_dataset o
       ON r.order_id = o.order_id
   WHERE o.order_status <> 'delivered'
   GROUP BY o.order_status
   ORDER BY review_records DESC;
OBSERVATION:
-- Review records were found for orders with several non-delivered statuses, including shipped (1,043), canceled (609), unavailable (597), invoiced (313),
-- processing (296), created (3), and approved (2).
FOLLOW-UP SQL QUERY:
   SELECT
       r.review_id,
       r.order_id,
       o.order_status,
       o.order_purchase_timestamp,
       r.review_creation_date,
       r.review_answer_timestamp
   FROM olist_order_reviews_dataset r
   INNER JOIN olist_orders_dataset o
       ON r.order_id = o.order_id
   WHERE o.order_status = 'canceled'
   ORDER BY r.review_creation_date
   LIMIT 20;
FOLLOW-UP OBSERVATION:
-- Sample records show reviews associated with canceled orders, with review creation dates occurring after the corresponding order purchase dates.
CONCLUSION:
-- nReviews are associated with orders whose final status is not delivered.
-- This represents an unusual cross-table relationship that warrants further investigation. 
-- However, the available fields do not provide sufficient evidence to classify these records as confirmed data errors.

CROSS-TABLE CONSISTENCY ASSESSMENT
ORDER ITEMS ↔ PRODUCTS
OBJECTIVE:
-- To assess whether products referenced in the olist_order_items_dataset have corresponding product category information in the olist_products_dataset.
SQL QUERY:
   SELECT
       COUNT(*) AS order_items_with_missing_product_category
   FROM olist_order_items_dataset oi
   INNER JOIN olist_products_dataset p
       ON oi.product_id = p.product_id
   WHERE p.product_category_name IS NULL;
OBSERVATION:
-- The query returned 0, indicating that no order-item recordsare associated with products having a NULL product_category_name.
CONCLUSION:
-- No cross-table consistency issue was identified between order items and product category information. 
-- All products referenced by order items have a populated product category value in the products table.

CROSS-TABLE CONSISTENCY ASSESSMENT
ORDER ITEMS ↔ SELLERS
OBJECTIVE:
-- To assess whether sellers referenced in the olist_order_items_dataset have corresponding records in the olist_sellers_dataset.
SQL QUERY:
   SELECT
       COUNT(*) AS order_items_with_missing_sellers
   FROM olist_order_items_dataset oi
   LEFT JOIN olist_sellers_dataset s
       ON oi.seller_id = s.seller_id
   WHERE s.seller_id IS NULL;
OBSERVATION:
-- The query returned 0, indicating that all sellers referenced in the order-item records have corresponding records in the olist_sellers_dataset.
CONCLUSION:
-- No cross-table consistency issue was identified between order items and sellers. 
-- All seller references in the order-item table correspond to existing seller records.

CROSS-TABLE CONSISTENCY ASSESSMENT
-- PRODUCTS ↔ CATEGORY TRANSLATION
OBJECTIVE:
-- To assess whether non-null product categories in the olist_products_dataset have corresponding entries in the product_category_name_translation table.
SQL QUERY:
   SELECT
       COUNT(*) AS products_without_translation
   FROM olist_products_dataset p
   LEFT JOIN product_category_name_translation t
       ON p.product_category_name = t.product_category_name
   WHERE p.product_category_name IS NOT NULL
     AND t.product_category_name IS NULL;
OBSERVATION:
-- The query identified 1,246 product records whose product_category_name does not have a corresponding entry in the product_category_name_translation table.
CONCLUSION:
-- Cross-table consistency between the products and category translation tables is incomplete. 
-- The affected product categories cannot be translated into English using the available translation table. 
-- This represents a data completeness issue in the category translation relationship, rather than evidence that the underlying product records are invalid.
