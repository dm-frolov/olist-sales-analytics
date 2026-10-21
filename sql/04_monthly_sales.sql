WITH monthly_sales AS (
    SELECT DATE_TRUNC('month', o.order_purchase_timestamp)::date AS month,
           COUNT(DISTINCT o.order_id) AS total_orders,
           ROUND(SUM(oi.price), 2) AS total_sales
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= DATE '2017-01-01'
      AND o.order_purchase_timestamp < DATE '2018-09-01'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)
SELECT month, total_orders, total_sales,
       ROUND(100.0 * (total_sales - LAG(total_sales) OVER (ORDER BY month)) /
             NULLIF(LAG(total_sales) OVER (ORDER BY month), 0), 2) AS monthly_growth_pct
FROM monthly_sales
ORDER BY month;
