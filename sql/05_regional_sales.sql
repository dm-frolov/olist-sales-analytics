-- Sales by customer state and average item spend per order.
SELECT c.customer_state AS state,
       COUNT(DISTINCT o.order_id) AS total_orders,
       ROUND(SUM(oi.price), 2) AS total_sales,
       ROUND(SUM(oi.price) / NULLIF(COUNT(DISTINCT o.order_id), 0), 2) AS average_order_value
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= DATE '2017-01-01'
  AND o.order_purchase_timestamp < DATE '2018-09-01'
GROUP BY c.customer_state
ORDER BY total_sales DESC;

-- Share of each state's sales.
WITH state_sales AS (
    SELECT c.customer_state AS state, SUM(oi.price) AS total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= DATE '2017-01-01'
      AND o.order_purchase_timestamp < DATE '2018-09-01'
    GROUP BY c.customer_state
)
SELECT state, ROUND(total_sales, 2) AS total_sales,
       ROUND(total_sales * 100.0 / NULLIF(SUM(total_sales) OVER (), 0), 2) AS sales_share_pct
FROM state_sales ORDER BY total_sales DESC;
