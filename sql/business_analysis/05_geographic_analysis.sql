USE ecommerce_customer_intelligence;

-- ANALYSIS 1: City-wise Sales Performance
SELECT
    c.customer_state,
    c.customer_city,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price),2) AS total_revenue,
    ROUND(SUM(oi.freight_value),2) AS total_freight,
    ROUND(SUM(oi.price + oi.freight_value),2) AS total_order_value,
    ROUND(
    SUM(oi.price) / COUNT(DISTINCT o.order_id),2
    ) AS average_product_revenue_per_order
FROM olist_customers_dataset AS c
JOIN olist_orders_dataset AS o
ON c.customer_id=o.customer_id
JOIN olist_order_items_dataset AS oi
ON o.order_id=oi.order_id
WHERE o.order_status='delivered'
GROUP BY c.customer_state, c.customer_city
ORDER BY average_product_revenue_per_order DESC
LIMIT 20;

-- ANALYSIS 2: State-wise Average Order Value
SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_product_revenue_per_order
FROM olist_customers_dataset AS c
JOIN olist_orders_dataset AS o
    ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING COUNT(DISTINCT o.order_id) >= 100
ORDER BY average_product_revenue_per_order DESC;

-- ANALYSIS 3: State-wise Freight Burden
SELECT
    c.customer_state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(SUM(oi.freight_value), 2) AS total_freight,
    ROUND(
        SUM(oi.freight_value) / NULLIF(SUM(oi.price), 0) * 100,
        2
    ) AS freight_percentage_of_product_revenue
FROM olist_customers_dataset AS c
JOIN olist_orders_dataset AS o
    ON c.customer_id = o.customer_id
JOIN olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
HAVING COUNT(DISTINCT o.order_id) >= 100
ORDER BY freight_percentage_of_product_revenue DESC;

-- ANALYSIS 4: Customer Concentration by State
SELECT
    c.customer_state,
    COUNT(DISTINCT c.customer_unique_id) AS total_customers,
    ROUND(
        COUNT(DISTINCT c.customer_unique_id) * 100.0 /
        (
            SELECT COUNT(DISTINCT c2.customer_unique_id)
            FROM olist_customers_dataset AS c2
            JOIN olist_orders_dataset AS o2
                ON c2.customer_id = o2.customer_id
            WHERE o2.order_status = 'delivered'
        ),
        2
    ) AS customer_percentage
FROM olist_customers_dataset AS c
JOIN olist_orders_dataset AS o
    ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY total_customers DESC;

-- VALIDATION: City-wise Revenue Ranking
WITH city_sales AS (
    SELECT
        c.customer_state,
        c.customer_city,
        COUNT(DISTINCT c.customer_unique_id) AS total_customers,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price), 2) AS product_revenue,
        ROUND(SUM(oi.freight_value), 2) AS total_freight
    FROM olist_customers_dataset AS c
    JOIN olist_orders_dataset AS o
        ON c.customer_id = o.customer_id
    JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        c.customer_state,
        c.customer_city
)
SELECT
    customer_state,
    customer_city,
    total_customers,
    total_orders,
    product_revenue,
    total_freight
FROM city_sales
ORDER BY product_revenue DESC
LIMIT 20;


















































