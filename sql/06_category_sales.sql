-- Category sales including categories not found in translation mapping.
SELECT COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown') AS category,
       COUNT(DISTINCT o.order_id) AS total_orders,
       ROUND(SUM(oi.price), 2) AS total_sales,
       ROUND(AVG(oi.price), 2) AS average_item_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= DATE '2017-01-01'
  AND o.order_purchase_timestamp < DATE '2018-09-01'
GROUP BY COALESCE(ct.product_category_name_english, p.product_category_name, 'unknown')
ORDER BY total_sales DESC;
-- A single order can belong to multiple categories.
