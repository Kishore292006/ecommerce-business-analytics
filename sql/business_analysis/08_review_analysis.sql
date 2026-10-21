USE ecommerce_customer_intelligence;

-- ANALYSIS 1: Customer Review Score Distribution
SELECT
    review_score,
    COUNT(*) AS review_count,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (),
        2
    ) AS review_percentage
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;

-- ANALYSIS 2: Review Scores by Delivery Performance
SELECT
    CASE
        WHEN o.order_delivered_customer_date
             > o.order_estimated_delivery_date
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_performance,
    COUNT(*) AS review_count,
    ROUND(
        AVG(r.review_score),
        2
    ) AS average_review_score,
    SUM(
        CASE
            WHEN r.review_score <= 2
            THEN 1
            ELSE 0
        END
    ) AS low_score_reviews
FROM olist_orders_dataset AS o
JOIN olist_order_reviews_dataset AS r
ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY delivery_performance
ORDER BY average_review_score DESC;

-- ANALYSIS 3: Review Score Distribution by Delivery Performance
SELECT
    CASE
        WHEN o.order_delivered_customer_date
             > o.order_estimated_delivery_date
        THEN 'Late'
        ELSE 'On Time'
    END AS delivery_performance,
    r.review_score,
    COUNT(*) AS review_count,
    ROUND(
        100.0 * COUNT(*) /
        SUM(COUNT(*)) OVER (
            PARTITION BY
                CASE
                    WHEN o.order_delivered_customer_date
                         > o.order_estimated_delivery_date
                    THEN 'Late'
                    ELSE 'On Time'
                END
        ),
        2
    ) AS percentage_within_group
FROM olist_orders_dataset AS o
JOIN olist_order_reviews_dataset AS r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY
    delivery_performance,
    r.review_score
ORDER BY
    delivery_performance,
    r.review_score;

-- ANALYSIS 4: Review Scores by Delay Duration
SELECT
    CASE
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 1 AND 3
            THEN '1-3 days late'
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 4 AND 7
            THEN '4-7 days late'
        WHEN DATEDIFF(
            o.order_delivered_customer_date,
            o.order_estimated_delivery_date
        ) BETWEEN 8 AND 14
            THEN '8-14 days late'
        ELSE '15+ days late'
    END AS delay_category,
    COUNT(*) AS review_count,
    ROUND(AVG(r.review_score), 2) AS average_review_score,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN r.review_score <= 2 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS low_score_percentage
FROM olist_orders_dataset AS o
JOIN olist_order_reviews_dataset AS r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL
  AND o.order_delivered_customer_date
      > o.order_estimated_delivery_date
GROUP BY delay_category
ORDER BY
    CASE delay_category
        WHEN '1-3 days late' THEN 1
        WHEN '4-7 days late' THEN 2
        WHEN '8-14 days late' THEN 3
        ELSE 4
    END;

-- ANALYSIS 5: Monthly Average Review Score
SELECT
    YEAR(o.order_purchase_timestamp) AS order_year,
    MONTH(o.order_purchase_timestamp) AS order_month,
    COUNT(*) AS review_count,
    ROUND(
        AVG(r.review_score),
        2
    ) AS average_review_score,
    SUM(
        CASE
            WHEN r.review_score <= 2 THEN 1
            ELSE 0
        END
    ) AS low_score_reviews
FROM olist_orders_dataset AS o
JOIN olist_order_reviews_dataset AS r
    ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.order_purchase_timestamp IS NOT NULL
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp)
ORDER BY
    order_year,
    order_month;

-- ANALYSIS 6: Review Records per Order
SELECT
    COUNT(*) AS total_review_records,
    COUNT(DISTINCT order_id) AS distinct_orders,
    COUNT(*) - COUNT(DISTINCT order_id) AS records_above_one_per_order
FROM olist_order_reviews_dataset;

-- ANALYSIS 7: Orders with Multiple Review Records
SELECT
    order_id,
    COUNT(*) AS review_records
FROM olist_order_reviews_dataset
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY review_records DESC, order_id
LIMIT 20;

-- ANALYSIS 8: Summary of Multiple Review Records
SELECT
    COUNT(*) AS orders_with_multiple_reviews,
    SUM(review_records) AS review_records_for_these_orders,
    MAX(review_records) AS maximum_reviews_for_one_order
FROM (
    SELECT
        order_id,
        COUNT(*) AS review_records
    FROM olist_order_reviews_dataset
    GROUP BY order_id
    HAVING COUNT(*) > 1
) AS multiple_reviews;








































































