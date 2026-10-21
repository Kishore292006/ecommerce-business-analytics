    -- Data quality checks
-- Checking the tables for missing values, duplicates, incorrect values,
-- relationship issues, and payment/order total differences.

USE ecommerce_customer_intelligence;

-- Task 1: Count the records in all 9 tables-----------------------------------------------
SELECT COUNT(*) AS total_rows
FROM olist_orders_dataset;

SELECT COUNT(*) AS total_rows
FROM olist_customers_dataset;

SELECT COUNT(*) AS total_rows
FROM olist_geolocation_dataset;

SELECT COUNT(*) AS total_rows
FROM olist_order_items_dataset;

SELECT COUNT(*) AS total_rows
FROM olist_order_payments_dataset;

SELECT COUNT(*) AS total_rows
FROM olist_order_reviews_dataset;

SELECT COUNT(*) AS total_rows
FROM olist_products_dataset;

SELECT COUNT(*) AS total_rows
FROM olist_sellers_dataset;

SELECT COUNT(*) AS total_rows
FROM product_category_name_translation;

-- Task 2: Duplicate Checks----------------------------------------------------------------
SELECT order_id,COUNT(*) AS duplicate_count
FROM olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*)>1;

SELECT customer_id,COUNT(*) AS duplicate_count
FROM olist_customers_dataset
GROUP BY customer_id
HAVING COUNT(*)>1;

SELECT product_id, COUNT(*) AS duplicate_count
FROM olist_products_dataset
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT seller_id, COUNT(*) AS duplicate_count
FROM olist_sellers_dataset
GROUP BY seller_id
HAVING COUNT(*) > 1;

SELECT order_id, order_item_id, COUNT(*) AS duplicate_count
FROM olist_order_items_dataset
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

SELECT order_id, payment_sequential, COUNT(*) AS duplicate_count
FROM olist_order_payments_dataset
GROUP BY order_id, payment_sequential
HAVING COUNT(*) > 1;

SELECT review_id, COUNT(*) AS duplicate_count
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1;  # we got duplicate count, lets investigate it

SELECT review_id, COUNT(*) AS duplicate_count
FROM olist_order_reviews_dataset
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

SELECT *  # so i took one of the duplicate
FROM olist_order_reviews_dataset
WHERE review_id = 'c444278834184f72b1484dfe47de7f97';  #one repeated ID belongs to three different orders

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_review_ids,
    COUNT(*) - COUNT(DISTINCT review_id) AS extra_review_id_rows
FROM olist_order_reviews_dataset;     # 814 rows are extra


SELECT COUNT(*) AS null_review_ids
FROM olist_order_reviews_dataset
WHERE review_id IS NULL;         # no null ids


SELECT              # determine whether any rows are identical across all columns
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp,
    COUNT(*) AS duplicate_count
FROM olist_order_reviews_dataset
GROUP BY
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC
LIMIT 10;

-- Task 3: Missing value checks------------------------------------------------------------
SELECT
    product_category_name,
    COUNT(*) AS occurrence_count
FROM product_category_name_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;

SELECT
    SUM(order_id IS NULL) AS null_order_id,
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(order_status IS NULL) AS null_order_status,
    SUM(order_purchase_timestamp IS NULL) AS null_purchase_timestamp,
    SUM(order_approved_at IS NULL) AS null_approved_at,
    SUM(order_delivered_carrier_date IS NULL) AS null_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS null_delivered_date,
    SUM(order_estimated_delivery_date IS NULL) AS null_estimated_date
FROM olist_orders_dataset;

SELECT
    order_status,
    COUNT(*) AS total_orders,
    SUM(order_approved_at IS NULL) AS missing_approval,
    SUM(order_delivered_carrier_date IS NULL) AS missing_carrier_date,
    SUM(order_delivered_customer_date IS NULL) AS missing_delivery_date
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;


-- Task 4: Timestamp Sequence and Delivery-Date Validation---------------------------------
SELECT
    order_id,
    order_status,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM olist_orders_dataset
WHERE order_status = 'delivered'
  AND (
      order_approved_at IS NULL
      OR order_delivered_carrier_date IS NULL
      OR order_delivered_customer_date IS NULL
  );

SELECT
    COUNT(*) AS delivered_orders,
    SUM(
    order_delivered_customer_date > order_estimated_delivery_date
    ) AS delivered_after_estimate,
    SUM(
    order_delivered_customer_date <= order_estimated_delivery_date
    ) AS delivered_on_or_before_estimate
FROM olist_orders_dataset
WHERE order_status='delivered'
AND order_delivered_customer_date IS NOT NULL;

# check timestamps follow a sensible sequence.
SELECT
    COUNT(*) AS invalid_timestamp_sequences
FROM olist_orders_dataset
WHERE
    (order_approved_at IS NOT NULL
        AND order_approved_at < order_purchase_timestamp)
OR
    (order_delivered_carrier_date IS NOT NULL
        AND order_approved_at IS NOT NULL
        AND order_delivered_carrier_date < order_approved_at)
OR
    (order_delivered_customer_date IS NOT NULL
        AND order_delivered_carrier_date IS NOT NULL
        AND order_delivered_customer_date < order_delivered_carrier_date);

# now we will count each query separately
SELECT
    SUM(
    order_approved_at IS NOT NULL
    AND order_approved_at < order_purchase_timestamp
    ) AS approval_before_purchase,

    SUM(
    order_delivered_carrier_date IS NOT NULL
    AND order_approved_at IS NOT NULL
    AND order_delivered_carrier_date < order_approved_at
    ) AS carrier_before_approval,

    SUM(
    order_delivered_customer_date IS NOT NULL
    AND order_delivered_carrier_date IS NOT NULL
    AND order_delivered_customer_date < order_delivered_carrier_date
    ) AS delivery_before_carrier
FROM olist_orders_dataset;


SELECT
    order_id,
    order_status,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date
FROM olist_orders_dataset
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
LIMIT 10;


SELECT
    order_status,
    COUNT(*) AS suspicious_orders
FROM olist_orders_dataset
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date < order_approved_at
GROUP BY order_status
ORDER BY suspicious_orders DESC;


SELECT
    order_status,
    COUNT(*) AS suspicious_orders
FROM olist_orders_dataset
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date < order_delivered_carrier_date
GROUP BY order_status
ORDER BY suspicious_orders DESC;

-- Task 5: Missing Identifiers and Referential Integrity Checks----------------------------
#Let's check whether any order_id values are missing
SELECT
    COUNT(*) AS null_order_ids
FROM olist_orders_dataset
WHERE order_id IS NULL;


#Check for missing identifiers in the customers, products, and sellers tables
SELECT
    (SELECT COUNT(*)
     FROM olist_customers_dataset
     WHERE customer_id IS NULL) AS null_customer_ids,

    (SELECT COUNT(*)
     FROM olist_products_dataset
     WHERE product_id IS NULL) AS null_product_ids,

    (SELECT COUNT(*)
     FROM olist_sellers_dataset
     WHERE seller_id IS NULL) AS null_seller_ids;

#check whether every order references a customer that exists in the customers table.
SELECT COUNT(*) AS orders_without_matching_customer
FROM olist_orders_dataset AS o
LEFT JOIN olist_customers_dataset AS c
ON o.customer_id=c.customer_id
WHERE c.customer_id IS NULL;

# check every order item references an order that exists.
SELECT COUNT(*) AS  order_items_without_matching_order
FROM olist_order_items_dataset AS oi
LEFT JOIN olist_orders_dataset AS o
ON oi.order_id=o.order_id
WHERE o.order_id IS NULL;

#Check order items against products
SELECT COUNT(*) AS order_items_without_matching_product
FROM olist_order_items_dataset AS oi
LEFT JOIN olist_products_dataset AS p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

#Check order items against sellers
SELECT COUNT(*) AS order_items_without_matching_seller
FROM olist_order_items_dataset AS oi
LEFT JOIN olist_sellers_dataset AS s
ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

#Check payment against orders
SELECT COUNT(*) AS payments_without_matching_order
FROM olist_order_payments_dataset AS p
LEFT JOIN olist_orders_dataset AS o
ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

#Check reviews against orders
SELECT COUNT(*) AS reviews_without_matching_order
FROM olist_order_reviews_dataset AS r
LEFT JOIN olist_orders_dataset AS o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

#verify every product category has matching entry in product_category_name_translation
SELECT COUNT(*) AS products_without_category_translation
FROM olist_products_dataset AS p
LEFT JOIN product_category_name_translation AS t
ON p.product_category_name=t.product_category_name
WHERE p.product_category_name IS NOT NULL
AND t.product_category_name IS NULL;

#Identify the 13 unmatched products
SELECT p.product_id,p.product_category_name
FROM olist_products_dataset AS p
LEFT JOIN product_category_name_translation AS t
ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NOT NULL
AND t.product_category_name IS NULL;

#check whether these categories occur in the actual orders dataset
SELECT
    p.product_category_name,
    COUNT(DISTINCT p.product_id) AS product_count,
    COUNT(DISTINCT oi.order_id) AS order_count
FROM olist_products_dataset AS p
LEFT JOIN olist_order_items_dataset AS oi
ON p.product_id=oi.product_id
WHERE p.product_category_name IN(
    'Pc_gamer',
    'portateis_cozinha_e_preparadores_de_alimentos'
    )
GROUP BY p.product_category_name;

#check whether every customer record is referenced by at least one order
SELECT
    COUNT(*) AS customers_without_orders
FROM olist_customers_dataset AS c
LEFT JOIN olist_orders_dataset AS o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

#check whether any seller records are not referenced in the order-items table
SELECT
    COUNT(*) AS sellers_without_order_items
FROM olist_sellers_dataset AS s
LEFT JOIN olist_order_items_dataset AS oi
ON s.seller_id = oi.seller_id
WHERE oi.seller_id IS NULL;

-- Task 6: Order Status and Order-Date Business Rules--------------------------------------
#Check whether every order has order items
SELECT
    COUNT(*) AS orders_without_order_items
FROM olist_orders_dataset AS o
LEFT JOIN olist_order_items_dataset AS oi
ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;

#Break down the 775 orders by status
SELECT
    o.order_status,
    COUNT(*) AS orders_without_items
FROM olist_orders_dataset AS o
LEFT JOIN olist_order_items_dataset AS oi
ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL
GROUP BY o.order_status
ORDER BY orders_without_items DESC;

#Investigate the shipped order
SELECT
    o.order_id,
    o.customer_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date
FROM olist_orders_dataset AS o
LEFT JOIN olist_order_items_dataset AS oi
ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL
AND o.order_status = 'shipped';

#payments for orders without items
SELECT
    COUNT(DISTINCT p.order_id) AS orders_without_items_with_payments
FROM olist_order_payments_dataset AS p
INNER JOIN olist_orders_dataset AS o
ON p.order_id = o.order_id
LEFT JOIN olist_order_items_dataset AS oi
ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;

#Order-status validation
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

#Check for unexpected or missing statuses
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
WHERE order_status IS NULL
   OR order_status NOT IN (
       'delivered',
       'shipped',
       'canceled',
       'unavailable',
       'invoiced',
       'processing',
       'created',
       'approved'
   )
GROUP BY order_status;

#Date validation
SELECT
    COUNT(*) AS estimated_delivery_before_purchase
FROM olist_orders_dataset
WHERE order_estimated_delivery_date < order_purchase_timestamp;

#Approval timestamp
SELECT
    COUNT(*) AS approval_before_purchase
FROM olist_orders_dataset
WHERE order_approved_at < order_purchase_timestamp;

#Carrier timestamp
SELECT
    COUNT(*) AS carrier_before_approval
FROM olist_orders_dataset
WHERE order_delivered_carrier_date < order_approved_at;

#Customer delivery before carrier handoff
SELECT
    COUNT(*) AS delivery_before_carrier
FROM olist_orders_dataset
WHERE order_delivered_customer_date < order_delivered_carrier_date;

#Check delivery before purchase
SELECT
    COUNT(*) AS delivery_before_purchase
FROM olist_orders_dataset
WHERE order_delivered_customer_date < order_purchase_timestamp;

#Check delivery before approval
SELECT
    COUNT(*) AS delivery_before_approval
FROM olist_orders_dataset
WHERE order_delivered_customer_date < order_approved_at;

#Carrier handoff before purchase
SELECT
    COUNT(*) AS carrier_before_purchase
FROM olist_orders_dataset
WHERE order_delivered_carrier_date < order_purchase_timestamp;

#Approval after carrier handoff
SELECT
    COUNT(*) AS approval_after_carrier
FROM olist_orders_dataset
WHERE order_approved_at > order_delivered_carrier_date;

#Check approval timestamp after customer delivery
SELECT
    COUNT(*) AS approval_after_customer_delivery
FROM olist_orders_dataset
WHERE order_approved_at > order_delivered_customer_date;

-- Task 7: Numeric Validation and Missing Product Attributes-------------------------------
#Numeric validation
SELECT
    SUM(CASE WHEN price < 0 THEN 1 ELSE 0 END) AS negative_prices,
    SUM(CASE WHEN freight_value < 0 THEN 1 ELSE 0 END) AS negative_freight_values,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS missing_prices,
    SUM(CASE WHEN freight_value IS NULL THEN 1 ELSE 0 END) AS missing_freight_values
FROM olist_order_items_dataset;

#Payment values
SELECT
    SUM(CASE WHEN payment_value < 0 THEN 1 ELSE 0 END) AS negative_payment_values,
    SUM(CASE WHEN payment_value IS NULL THEN 1 ELSE 0 END) AS missing_payment_values,
    SUM(CASE WHEN payment_value = 0 THEN 1 ELSE 0 END) AS zero_payment_values,
    SUM(CASE WHEN payment_installments < 0 THEN 1 ELSE 0 END) AS negative_installments,
    SUM(CASE WHEN payment_installments IS NULL THEN 1 ELSE 0 END) AS missing_installments
FROM olist_order_payments_dataset;

#Product measurements
SELECT
    SUM(CASE WHEN product_name_lenght < 0 THEN 1 ELSE 0 END) AS negative_name_lengths,
    SUM(CASE WHEN product_description_lenght < 0 THEN 1 ELSE 0 END) AS negative_description_lengths,
    SUM(CASE WHEN product_photos_qty < 0 THEN 1 ELSE 0 END) AS negative_photo_counts,
    SUM(CASE WHEN product_weight_g < 0 THEN 1 ELSE 0 END) AS negative_weights,
    SUM(CASE WHEN product_length_cm < 0 THEN 1 ELSE 0 END) AS negative_lengths,
    SUM(CASE WHEN product_height_cm < 0 THEN 1 ELSE 0 END) AS negative_heights,
    SUM(CASE WHEN product_width_cm < 0 THEN 1 ELSE 0 END) AS negative_widths
FROM olist_products_dataset;

#Missing product measurements
SELECT
    SUM(CASE WHEN product_weight_g IS NULL THEN 1 ELSE 0 END) AS missing_weights,
    SUM(CASE WHEN product_length_cm IS NULL THEN 1 ELSE 0 END) AS missing_lengths,
    SUM(CASE WHEN product_height_cm IS NULL THEN 1 ELSE 0 END) AS missing_heights,
    SUM(CASE WHEN product_width_cm IS NULL THEN 1 ELSE 0 END) AS missing_widths
FROM olist_products_dataset;

#Identify the affected products
SELECT
    product_id,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_products_dataset
WHERE product_weight_g IS NULL
   OR product_length_cm IS NULL
   OR product_height_cm IS NULL
   OR product_width_cm IS NULL;

#Missing product name and description lengths
SELECT
    SUM(CASE WHEN product_name_lenght IS NULL THEN 1 ELSE 0 END)
        AS missing_name_lengths,
    SUM(CASE WHEN product_description_lenght IS NULL THEN 1 ELSE 0 END)
        AS missing_description_lengths,
    SUM(CASE WHEN product_photos_qty IS NULL THEN 1 ELSE 0 END)
        AS missing_photo_counts
FROM olist_products_dataset;

#Identify the affected products
SELECT
    product_id,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty
FROM olist_products_dataset
WHERE product_name_lenght IS NULL
   OR product_description_lenght IS NULL
   OR product_photos_qty IS NULL
LIMIT 10;

#Verify the total number of affected products
SELECT
    COUNT(*) AS products_missing_any_catalog_attribute
FROM olist_products_dataset
WHERE product_name_lenght IS NULL
   OR product_description_lenght IS NULL
   OR product_photos_qty IS NULL;

#Review scores
SELECT
    SUM(CASE WHEN review_score < 1 OR review_score > 5 THEN 1 ELSE 0 END)
        AS invalid_review_scores,
    SUM(CASE WHEN review_score IS NULL THEN 1 ELSE 0 END)
        AS missing_review_scores
FROM olist_order_reviews_dataset;

#Geolocation coordinates
SELECT
    SUM(CASE WHEN geolocation_lat < -90
              OR geolocation_lat > 90
             THEN 1 ELSE 0 END) AS invalid_latitudes,
    SUM(CASE WHEN geolocation_lng < -180
              OR geolocation_lng > 180
             THEN 1 ELSE 0 END) AS invalid_longitudes,
    SUM(CASE WHEN geolocation_lat IS NULL
             THEN 1 ELSE 0 END) AS missing_latitudes,
    SUM(CASE WHEN geolocation_lng IS NULL
             THEN 1 ELSE 0 END) AS missing_longitudes
FROM olist_geolocation_dataset;

-- Task 8: Payment Types, Payment Values, and Installment Checks---------------------------
#Payment types
SELECT
    payment_type,
    COUNT(*) AS total_records
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY total_records DESC;

#Investigate (not_defined) payment type
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM olist_order_payments_dataset
WHERE payment_type = 'not_defined';

#Payment-method and value consistency
SELECT
    payment_type,
    COUNT(*) AS zero_value_records
FROM olist_order_payments_dataset
WHERE payment_value = 0
GROUP BY payment_type
ORDER BY zero_value_records DESC;

#Inspect the six zero-value voucher records
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM olist_order_payments_dataset
WHERE payment_value = 0
  AND payment_type = 'voucher';

#check whether any payment records have zero installments.
SELECT
    COUNT(*) AS zero_installment_records
FROM olist_order_payments_dataset
WHERE payment_installments = 0;

# Check for installment counts greater than 24.

SELECT
    payment_type,
    payment_installments,
    COUNT(*) AS total_records
FROM olist_order_payments_dataset
WHERE payment_installments > 24
GROUP BY payment_type, payment_installments
ORDER BY payment_installments DESC;

#Inspect the two zero-installment records
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM olist_order_payments_dataset
WHERE payment_installments = 0;

#Numeric validation of order-item IDs
SELECT
    COUNT(*) AS invalid_order_item_ids
FROM olist_order_items_dataset
WHERE order_item_id <= 0
   OR order_item_id IS NULL;

# Validate payment sequence numbers.
SELECT
    COUNT(*) AS invalid_payment_sequence
FROM olist_order_payments_dataset
WHERE payment_sequential <= 0
   OR payment_sequential IS NULL;

# review score validation is already done in Task 7

-- Task 9: Zero Freight, Zero Prices, and Product Measurement Anomalies--------------------
#Numeric validation progress
SELECT
    SUM(CASE WHEN price = 0 THEN 1 ELSE 0 END) AS zero_prices,
    SUM(CASE WHEN freight_value = 0 THEN 1 ELSE 0 END) AS zero_freight_values
FROM olist_order_items_dataset;

#Inspect the zero-freight records
SELECT
    COUNT(*) AS zero_freight_items,
    COUNT(DISTINCT order_id) AS affected_orders,
    COUNT(DISTINCT seller_id) AS affected_sellers
FROM olist_order_items_dataset
WHERE freight_value = 0;

#Analyze zero-freight items by seller
SELECT
    seller_id,
    COUNT(*) AS zero_freight_items,
    COUNT(DISTINCT order_id) AS affected_orders
FROM olist_order_items_dataset
WHERE freight_value = 0
GROUP BY seller_id
ORDER BY zero_freight_items DESC;

#compare each seller's zero-freight items with their total items and average freight charge
SELECT
    seller_id,
    COUNT(*) AS total_order_items,
    SUM(CASE WHEN freight_value=0 THEN 1 ELSE 0 END) AS zero_freight_items,
    ROUND(
    100.0 * SUM(CASE WHEN freight_value=0 THEN 1 ELSE 0 END)/COUNT(*),2
    ) AS zero_freight_percentage,
    ROUND(AVG(freight_value),2) AS average_freight_value
FROM olist_order_items_dataset
GROUP BY seller_id
HAVING SUM(CASE WHEN freight_value=0 THEN 1 ELSE 0 END)>0
ORDER BY zero_freight_percentage DESC;

#compare the seller's zero-freight items with their nonzero-freight items by order status
SELECT
    o.order_status,
    COUNT(*) AS total_order_items,
    SUM(CASE WHEN oi.freight_value = 0 THEN 1 ELSE 0 END
    ) AS zero_freight_items,
    ROUND(
        100.0 * SUM(CASE WHEN oi.freight_value = 0 THEN 1 ELSE 0 END) / COUNT(*),2
    ) AS zero_freight_percentage
FROM olist_order_items_dataset AS oi
JOIN olist_orders_dataset AS o
    ON oi.order_id = o.order_id
WHERE oi.seller_id = '7d13fca15225358621be4086e1eb0964'
GROUP BY o.order_status
ORDER BY zero_freight_percentage DESC;

#Compare zero-freight and nonzero-freight prices
SELECT
    CASE
        WHEN freight_value = 0 THEN 'Zero Freight'
        ELSE 'Nonzero Freight'
    END AS freight_group,
    COUNT(*) AS total_order_items,
    ROUND(AVG(price), 2) AS average_product_price,
    ROUND(AVG(freight_value), 2) AS average_freight_value
FROM olist_order_items_dataset
WHERE seller_id = '7d13fca15225358621be4086e1eb0964'
GROUP BY
    CASE
        WHEN freight_value = 0 THEN 'Zero Freight'
        ELSE 'Nonzero Freight'
    END
ORDER BY total_order_items DESC;

#Product dimensions equal to zero
SELECT
    SUM(CASE WHEN product_weight_g = 0 THEN 1 ELSE 0 END) AS zero_weights,
    SUM(CASE WHEN product_length_cm = 0 THEN 1 ELSE 0 END) AS zero_lengths,
    SUM(CASE WHEN product_height_cm = 0 THEN 1 ELSE 0 END) AS zero_heights,
    SUM(CASE WHEN product_width_cm = 0 THEN 1 ELSE 0 END) AS zero_widths
FROM olist_products_dataset;

# Previously observed: four products have zero weight; inspect the affected records.
SELECT
    product_id,
    product_category_name,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM olist_products_dataset
WHERE product_weight_g = 0;

# Summarize order-item prices and freight values.
SELECT
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price,
    AVG(price) AS average_price,
    MIN(freight_value) AS minimum_freight,
    MAX(freight_value) AS maximum_freight,
    AVG(freight_value) AS average_freight
FROM olist_order_items_dataset;

#payment totals
SELECT
    MIN(payment_value) AS minimum_payment,
    MAX(payment_value) AS maximum_payment,
    AVG(payment_value) AS average_payment,
    MIN(payment_installments) AS minimum_installments,
    MAX(payment_installments) AS maximum_installments
FROM olist_order_payments_dataset;

#Review numeric validation
SELECT
    review_score,
    COUNT(*) AS review_count
FROM olist_order_reviews_dataset
GROUP BY review_score
ORDER BY review_score;

# Summarize maximum product measurement values.
SELECT
    MAX(product_weight_g) AS maximum_weight_g,
    MAX(product_length_cm) AS maximum_length_cm,
    MAX(product_height_cm) AS maximum_height_cm,
    MAX(product_width_cm) AS maximum_width_cm
FROM olist_products_dataset;

#unusually large payment installments
SELECT
    payment_type,
    MAX(payment_installments) AS maximum_installments,
    COUNT(*) AS payment_records
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY maximum_installments DESC;

-- Task 10: Payment-to-Item Total Reconciliation and Exception Investigation----------------
#does the total payment for each order match the total value of its order items, including freight?
SELECT
    COUNT(*) AS orders_compared,
    SUM(CASE WHEN ABS(p.payment_total - i.item_total) > 1 THEN 1 ELSE 0 END
    ) AS orders_with_difference_over_1
FROM (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p
JOIN (
    SELECT
        order_id,
        SUM(price + freight_value) AS item_total
    FROM olist_order_items_dataset
    GROUP BY order_id
) i
    ON p.order_id = i.order_id;

#inspect the mismatches
SELECT
    p.order_id,
    ROUND(p.payment_total, 2) AS payment_total,
    ROUND(i.item_total, 2) AS item_total,
    ROUND(p.payment_total - i.item_total, 2) AS difference
FROM (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p
JOIN (
    SELECT
        order_id,
        SUM(price + freight_value) AS item_total
    FROM olist_order_items_dataset
    GROUP BY order_id
) i
    ON p.order_id = i.order_id
WHERE ABS(p.payment_total - i.item_total) > 1
ORDER BY ABS(p.payment_total - i.item_total) DESC
LIMIT 10;

# Inspect the payment and item records for the selected exception.
SELECT
    o.order_id,
    o.order_status,
    p.payment_type,
    p.payment_value,
    oi.price,
    oi.freight_value,
    oi.order_item_id
FROM olist_orders_dataset o
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
JOIN olist_order_items_dataset oi
    ON o.order_id = oi.order_id
WHERE o.order_id = 'ce6d150fb29ada17d2082f4847107665'
ORDER BY p.payment_sequential, oi.order_item_id;

# Inspect all payment records for the selected order.
SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
FROM olist_order_payments_dataset
WHERE order_id = 'ce6d150fb29ada17d2082f4847107665'
ORDER BY payment_sequential;

# Verify all item rows for the selected order.
SELECT
    order_id,
    order_item_id,
    product_id,
    seller_id,
    price,
    freight_value,
    ROUND(price + freight_value, 2) AS item_total
FROM olist_order_items_dataset
WHERE order_id = 'ce6d150fb29ada17d2082f4847107665'
ORDER BY order_item_id;

# Summarize reconciliation exceptions by order status.
SELECT
    o.order_status,
    COUNT(*) AS mismatched_orders,
    ROUND(
        AVG(ABS(p.payment_total - i.item_total)),
        2
    ) AS average_absolute_difference,
    ROUND(
        MAX(ABS(p.payment_total - i.item_total)),
        2
    ) AS maximum_absolute_difference
FROM olist_orders_dataset o
JOIN (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p
    ON o.order_id = p.order_id
JOIN (
    SELECT
        order_id,
        SUM(price + freight_value) AS item_total
    FROM olist_order_items_dataset
    GROUP BY order_id
) i
    ON o.order_id = i.order_id
WHERE ABS(p.payment_total - i.item_total) > 1
GROUP BY o.order_status
ORDER BY mismatched_orders DESC;

-- Task 11: Order-Item Numbering and Payment-Sequence Consistency---------------------------
#check order-item numbering
SELECT
    order_id,
    COUNT(*) AS item_rows,
    MIN(order_item_id) AS first_item_number,
    MAX(order_item_id) AS last_item_number
FROM olist_order_items_dataset
GROUP BY order_id
HAVING MIN(order_item_id) <> 1
    OR MAX(order_item_id) <> COUNT(*)
ORDER BY order_id
LIMIT 20;

#Investigate reconciliation differences
SELECT
    o.order_status,
    COUNT(*) AS orders_compared,
    SUM(
        CASE
            WHEN ABS(p.payment_total - i.item_total) > 1
            THEN 1
            ELSE 0
        END
    ) AS orders_with_difference_over_1,
    ROUND(
        AVG(ABS(p.payment_total - i.item_total)),
        2
    ) AS average_absolute_difference
FROM olist_orders_dataset o
JOIN (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p ON o.order_id = p.order_id
JOIN (
    SELECT
        order_id,
        SUM(price + freight_value) AS item_total
    FROM olist_order_items_dataset
    GROUP BY order_id
) i ON o.order_id = i.order_id
GROUP BY o.order_status
ORDER BY orders_with_difference_over_1 DESC;

#Investigate the reconciliation exceptions
SELECT
    CASE
        WHEN p.payment_total > i.item_total
            THEN 'Payment exceeds item total'
        ELSE 'Payment below item total'
    END AS difference_type,
    COUNT(*) AS affected_orders,
    ROUND(
        AVG(ABS(p.payment_total - i.item_total)),
        2
    ) AS average_difference,
    ROUND(
        MAX(ABS(p.payment_total - i.item_total)),
        2
    ) AS maximum_difference
FROM (
    SELECT
        order_id,
        SUM(payment_value) AS payment_total
    FROM olist_order_payments_dataset
    GROUP BY order_id
) p
JOIN (
    SELECT
        order_id,
        SUM(price + freight_value) AS item_total
    FROM olist_order_items_dataset
    GROUP BY order_id
) i
    ON p.order_id = i.order_id
WHERE ABS(p.payment_total - i.item_total) > 1
GROUP BY difference_type
ORDER BY affected_orders DESC;

# order item numbering is already checked above

# duplicate payment sequence is already checked in Task 2

-- Task 12: Product-Category and Translation Relationship Validation------------------------
#Product-category relationship validation
SELECT
    CASE
        WHEN p.product_category_name IS NULL
            THEN 'Missing category'
        WHEN t.product_category_name IS NULL
            THEN 'Category translation missing'
        ELSE 'Matched category'
    END AS category_status,
    COUNT(*) AS product_count
FROM olist_products_dataset p
LEFT JOIN product_category_name_translation t
ON p.product_category_name=t.product_category_name
GROUP BY category_status
ORDER BY product_count DESC;
