SELECT
  strftime('%Y-%m', orders.order_date) AS order_month,
  SUM(CASE WHEN orders.order_id NOT LIKE 'C%' 
  THEN order_items.price * order_items.quantity ELSE 0 END) AS ordered_amount,
  SUM(CASE WHEN orders.order_id LIKE 'C%' 
  THEN order_items.price * order_items.quantity ELSE 0 END) AS canceled_amount,
  SUM(order_items.price * order_items.quantity) AS total_amount
FROM orders JOIN order_items ON orders.order_id = order_items.order_id
GROUP BY strftime('%Y-%m', orders.order_date)
