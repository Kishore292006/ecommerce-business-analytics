USE ecommerce_customer_intelligence;

-- Task 1: Monthly sales trend
SELECT
    YEAR(o.order_purchase_timestamp) AS purchase_year,
    MONTH(o.order_purchase_timestamp) AS purchase_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price),2) AS product_revenue,
    ROUND(SUM(oi.freight_value),2) AS total_freight,
    ROUND(SUM(oi.price + oi.freight_value),2) AS sales_including_freight
FROM olist_orders_dataset AS o
JOIN olist_order_items_dataset oi
ON o.order_id=oi.order_id
WHERE o.order_status='delivered'
GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp)
ORDER BY purchase_year,purchase_month;

-- Task 2: Month-over-month sales change
WITH monthly_sales AS (
    SELECT
        DATE_FORMAT(
        o.order_purchase_timestamp,'%Y-%m'
        ) AS sales_month,
        SUM(oi.price + oi.freight_value) AS monthly_sales
    FROM olist_orders_dataset AS o
    JOIN olist_order_items_dataset AS oi
    ON o.order_id=oi.order_id
    WHERE o.order_status='delivered'
    GROUP BY DATE_FORMAT(
             o.order_purchase_timestamp,'%Y-%m'
             )
),
    sales_comparison AS(
        SELECT
            sales_month,
            monthly_sales,
            LAG(monthly_sales) OVER(
                ORDER BY sales_month
                ) AS previous_month_sales
        FROM monthly_sales
    )
SELECT
    sales_month,
    ROUND(monthly_sales,2) AS monthly_sales,
    ROUND(previous_month_sales,2) AS previous_month_sales,
    ROUND(
    (monthly_sales-previous_month_sales)
    / NULLIF(previous_month_sales,0)*100,2
    ) AS sales_change_percentage
FROM sales_comparison
ORDER BY  sales_month;


-- Task 3: Year-over-year monthly sales comparison
WITH monthly_sales AS (
    SELECT
        YEAR(o.order_purchase_timestamp) AS sales_year,
        MONTH(o.order_purchase_timestamp) AS sales_month,
        SUM(oi.price + oi.freight_value) AS monthly_sales
    FROM olist_orders_dataset AS o
    JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY
        YEAR(o.order_purchase_timestamp),
        MONTH(o.order_purchase_timestamp)
)
SELECT
    current_year.sales_year,
    current_year.sales_month,
    ROUND(current_year.monthly_sales, 2) AS monthly_sales,
    ROUND(previous_year.monthly_sales, 2) AS previous_year_sales,
    ROUND(
        (current_year.monthly_sales - previous_year.monthly_sales)
        / NULLIF(previous_year.monthly_sales, 0) * 100,
        2
    ) AS yoy_change_percentage
FROM monthly_sales AS current_year
LEFT JOIN monthly_sales AS previous_year
    ON current_year.sales_year = previous_year.sales_year + 1
    AND current_year.sales_month = previous_year.sales_month
ORDER BY
    current_year.sales_year,
    current_year.sales_month;


































