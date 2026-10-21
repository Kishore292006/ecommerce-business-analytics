
USE ecommerce_customer_intelligence;

-- Task 1: Top product categories by revenue
SELECT
    COALESCE(
        pct.product_category_name_english,
        'Unknown'
    ) AS product_category,
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM olist_order_items_dataset AS oi
JOIN olist_orders_dataset AS o
    ON oi.order_id = o.order_id
JOIN olist_products_dataset AS p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation AS pct
    ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY
    COALESCE(
        pct.product_category_name_english,
        'Unknown'
    )
ORDER BY product_revenue DESC
LIMIT 10;


-- Task 2: Top product categories by number of items sold
SELECT
    COALESCE(
        pct.product_category_name_english,
        'Unknown'
    ) AS product_category,
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM olist_order_items_dataset AS oi
JOIN olist_orders_dataset AS o
    ON oi.order_id = o.order_id
JOIN olist_products_dataset AS p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation AS pct
    ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY
    COALESCE(
        pct.product_category_name_english,
        'Unknown'
    )
ORDER BY total_order_items DESC
LIMIT 10;


-- Task 3: Average item price by product category
SELECT
    COALESCE(
        pct.product_category_name_english,
        'Unknown'
    ) AS product_category,
    COUNT(*) AS total_order_items,
    ROUND(AVG(oi.price), 2) AS average_item_price,
    ROUND(SUM(oi.price), 2) AS product_revenue
FROM olist_order_items_dataset AS oi
JOIN olist_orders_dataset AS o
    ON oi.order_id = o.order_id
JOIN olist_products_dataset AS p
    ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation AS pct
    ON p.product_category_name = pct.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY
    COALESCE(
        pct.product_category_name_english,
        'Unknown'
    )
ORDER BY average_item_price DESC
LIMIT 10;


-- Task 4: Product revenue contribution by category
WITH category_sales AS (
    SELECT
        COALESCE(
            pct.product_category_name_english,
            'Unknown'
        ) AS product_category,
        SUM(oi.price) AS product_revenue
    FROM olist_order_items_dataset AS oi
    JOIN olist_orders_dataset AS o
        ON oi.order_id = o.order_id
    JOIN olist_products_dataset AS p
        ON oi.product_id = p.product_id
    LEFT JOIN product_category_name_translation AS pct
        ON p.product_category_name = pct.product_category_name
    WHERE o.order_status = 'delivered'
    GROUP BY
        COALESCE(
            pct.product_category_name_english,
            'Unknown'
        )
)
SELECT
    product_category,
    ROUND(product_revenue, 2) AS product_revenue,
    ROUND(
        product_revenue /
        NULLIF(SUM(product_revenue) OVER (), 0) * 100,
        2
    ) AS revenue_contribution_percentage
FROM category_sales
ORDER BY product_revenue DESC
LIMIT 10;











































