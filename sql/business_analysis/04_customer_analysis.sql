USE ecommerce_customer_intelligence;

-- ANALYSIS 1: Customer Performance by State
SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price),2) AS product_revenue,
    ROUND(SUM(oi.freight_value),2) AS total_freight,
    ROUND(SUM(oi.price + oi.freight_value),2) AS total_order_value,
    ROUND(
    SUM(oi.price) / COUNT(DISTINCT o.order_id),2
    ) AS average_product_revenue_per_order
FROM olist_customers_dataset  AS c
JOIN olist_orders_dataset AS o
ON c.customer_id=o.customer_id
JOIN olist_order_items_dataset AS oi
ON o.order_id=oi.order_id
WHERE o.order_status='delivered'
GROUP BY c.customer_state
ORDER BY product_revenue DESC;

-- ANALYSIS 2: Repeat Customer Behavior
SELECT
    customer_order_summary.customer_type,
    COUNT(*) AS total_customers,
    SUM(customer_order_summary.total_orders) AS total_orders,
    ROUND(
        AVG(customer_order_summary.total_orders), 2
    ) AS average_orders_per_customer
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        CASE
            WHEN COUNT(DISTINCT o.order_id) > 1
                THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type
    FROM olist_customers_dataset AS c
    JOIN olist_orders_dataset AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) AS customer_order_summary
GROUP BY customer_order_summary.customer_type
ORDER BY total_customers DESC;

-- ANALYSIS 3: Revenue by Customer Type
SELECT
    customer_summary.customer_type,
    COUNT(*) AS total_customers,
    ROUND(SUM(customer_summary.customer_revenue), 2)
        AS total_product_revenue,
    ROUND(AVG(customer_summary.customer_revenue), 2)
        AS average_revenue_per_customer
FROM (
    SELECT
        c.customer_unique_id,
        SUM(oi.price) AS customer_revenue,
        CASE
            WHEN COUNT(DISTINCT o.order_id) > 1
                THEN 'Repeat Customer'
            ELSE 'One-Time Customer'
        END AS customer_type
    FROM olist_customers_dataset AS c
    JOIN olist_orders_dataset AS o
        ON c.customer_id = o.customer_id
    JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) AS customer_summary
GROUP BY customer_summary.customer_type
ORDER BY total_product_revenue DESC;

-- ANALYSIS 4: Customer Order Frequency
SELECT
    customer_order_summary.total_orders,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage
FROM (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM olist_customers_dataset AS c
    JOIN olist_orders_dataset AS o
        ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
) AS customer_order_summary
GROUP BY customer_order_summary.total_orders
ORDER BY customer_order_summary.total_orders;
























































