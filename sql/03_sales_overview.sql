-- Delivered orders purchased from 2017-01-01 to 2018-08-31 inclusive.
-- total_sales includes item price only, excludes freight.
SELECT COUNT(DISTINCT o.order_id) AS total_orders,
       COUNT(DISTINCT o.customer_id) AS total_customer_records,
       ROUND(SUM(oi.price), 2) AS total_sales,
       ROUND(SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= DATE '2017-01-01'
  AND o.order_purchase_timestamp < DATE '2018-09-01';
-- customer_id identifies order-specific customer records, NOT unique people.
