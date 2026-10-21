-- payment_value includes shipping and potentially multiple payments per order.
SELECT p.payment_type,
       COUNT(DISTINCT p.order_id) AS total_orders,
       ROUND(SUM(p.payment_value), 2) AS total_payments,
       ROUND(COUNT(DISTINCT p.order_id) * 100.0 /
             NULLIF(SUM(COUNT(DISTINCT p.order_id)) OVER (), 0), 2) AS orders_share_pct
FROM order_payments p
JOIN orders o ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp >= DATE '2017-01-01'
  AND o.order_purchase_timestamp < DATE '2018-09-01'
GROUP BY p.payment_type
ORDER BY total_orders DESC;
-- Shares refer to payment-method appearances, not distinct orders overall.
