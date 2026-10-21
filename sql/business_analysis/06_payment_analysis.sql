USE ecommerce_customer_intelligence;

-- ANALYSIS 1: Payment Method Performance
SELECT
    op.payment_type,
    COUNT(*) AS payment_records,
    COUNT(DISTINCT op.order_id) AS total_orders,
    ROUND(SUM(op.payment_value),2) AS total_payment_value,
    ROUND(AVG(op.payment_value),2) AS average_payment_value,
    ROUND(
    SUM(op.payment_value) * 100.0 /
    SUM(SUM(op.payment_value)) OVER(),2
    ) AS payment_value_percentage
FROM olist_order_payments_dataset AS op
JOIN olist_orders_dataset AS o
ON op.order_id=o.order_id
GROUP BY op.payment_type
ORDER BY total_payment_value DESC;

-- ANALYSIS 2: Credit Card Installment Behavior
SELECT
    op.payment_installments,
    COUNT(*) AS payment_records,
    COUNT(DISTINCT op.order_id) AS total_orders,
    ROUND(SUM(op.payment_value), 2) AS total_payment_value,
    ROUND(AVG(op.payment_value), 2) AS average_payment_value
FROM olist_order_payments_dataset AS op
WHERE op.payment_type = 'credit_card'
GROUP BY op.payment_installments
ORDER BY op.payment_installments;

-- ANALYSIS 3: Payment vs Order Value Reconciliation
WITH order_item_totals AS (
    SELECT
        order_id,
        SUM(price + freight_value) AS item_total
    FROM olist_order_items_dataset
    GROUP BY order_id
),
order_payment_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
)
SELECT
    COUNT(*) AS orders_compared,
    SUM(
        CASE
            WHEN ABS(p.payment_total - i.item_total) > 1
                THEN 1
            ELSE 0
        END
    ) AS orders_with_difference_over_1,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN ABS(p.payment_total - i.item_total) > 1
                    THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS percentage_with_difference_over_1,
    ROUND(
        AVG(ABS(p.payment_total - i.item_total)),
        2
    ) AS average_absolute_difference
FROM order_item_totals AS i
JOIN order_payment_totals AS p
    ON i.order_id = p.order_id;

-- ANALYSIS 4: Largest Payment Reconciliation Differences
WITH order_item_totals AS (
    SELECT
        order_id,
        SUM(price + freight_value) AS item_total
    FROM olist_order_items_dataset
    GROUP BY order_id
),
order_payment_totals AS (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
)
SELECT
    i.order_id,
    ROUND(i.item_total, 2) AS item_total,
    ROUND(p.payment_total, 2) AS payment_total,
    ROUND(p.payment_total - i.item_total, 2)
        AS payment_minus_item_total,
    ROUND(ABS(p.payment_total - i.item_total), 2)
        AS absolute_difference
FROM order_item_totals AS i
JOIN order_payment_totals AS p
    ON i.order_id = p.order_id
WHERE ABS(p.payment_total - i.item_total) > 1
ORDER BY absolute_difference DESC
LIMIT 20;

-- VALIDATION: Payment Details for Largest Discrepancy
SELECT
    order_id,
    payment_type,
    payment_installments,
    payment_value
FROM olist_order_payments_dataset
WHERE order_id = 'ce6d150fb29ada17d2082f4847107665'
ORDER BY payment_value DESC;
























