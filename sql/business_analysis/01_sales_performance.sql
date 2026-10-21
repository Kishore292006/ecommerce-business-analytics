USE ecommerce_customer_intelligence;

# Check the order status distribution
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

#Overall sales performance for delivered orders
SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(*) AS total_order_items,
    ROUND(SUM(oi.price),2) AS product_revenue,
    ROUND(SUM(oi.freight_value),2) AS total_freight,
    ROUND(SUM(oi.price + oi.freight_value),2) AS sales_including_freight,
    ROUND(SUM(oi.price + oi.freight_value)/COUNT(DISTINCT o.order_id),2) AS average_order_value
FROM olist_orders_dataset AS o
JOIN olist_order_items_dataset oi
ON o.order_id=oi.order_id
WHERE o.order_status='delivered';

#Average number of items per delivered order
SELECT
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(
    COUNT(*) / COUNT(DISTINCT o.order_id),2
    ) AS average_items_per_order
FROM olist_orders_dataset AS o
JOIN olist_order_items_dataset AS oi
ON o.order_id=oi.order_id
WHERE o.order_status='delivered';

#Freight contribution to sales
SELECT
    ROUND(SUM(oi.price),2) AS product_revenue,
    ROUND(SUM(oi.freight_value),2) AS total_freight,
    ROUND(
    SUM(oi.freight_value)/
    NULLIF(SUM(oi.price + oi.freight_value),0)*100,2
    ) AS freight_percentage
FROM olist_orders_dataset AS o
JOIN olist_order_items_dataset AS oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

#Sales summary by purchase year
-- Task 5: Sales summary by purchase year

SELECT
    YEAR(o.order_purchase_timestamp) AS purchase_year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(SUM(oi.price + oi.freight_value), 2)
        AS sales_including_freight
FROM olist_orders_dataset AS o
JOIN olist_order_items_dataset AS oi
ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY purchase_year;






































