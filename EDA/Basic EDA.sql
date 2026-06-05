-- Question: How many orders are there in the system?
-- Insight: There are 99441 unique orders in the system
SELECT COUNT(DISTINCT order_id)
FROM olist_orders_dataset

-- Question: How many customer in the system?
-- Insight: There are 96096 customers in the system
SELECT COUNT(distinct customer_unique_id)
FROM olist_customers_dataset

-- Question: How many sellers in the system?
-- Insight: There are 3095 sellers in the system
SELECT COUNT(distinct seller_id)
FROM olist_sellers_dataset

-- Question: How many products in the system
-- Insight: There are 32951 products in the system
SELECT COUNT (product_id)
FROM olist_products_dataset

-- Question: The earliest and latest order dates are mentioned in the system.
-- Insight: Earliest date is 2016-09-04 and Latest date is 2018-10-17
SELECT 
	MIN(order_purchase_timestamp::DATE) AS earliest_date,
	MAX(order_purchase_timestamp::DATE) AS latest_date
FROM olist_orders_dataset
WHERE order_purchase_timestamp != ''

-- Question: Number of orders by status
-- Insight: 
--		+ delivered: 96478
--		+ shipped: 1107
--		+ canceled: 625
--		+ unavailable: 609
--		+ invoiced: 314
--		+ processing: 301
--		+ created: 5
--		+ approved: 2
SELECT order_status, count(*) as number_of_orders
FROM olist_orders_dataset
GROUP BY order_status
order by number_of_orders DESC

-- Question: How many orders are missing (NULL) the successful delivery date information (order_delivered_customer_date) but the status remains 'delivered'?.
-- Insight: We have 8 orders that meet the above conditions (2 orders in 2017 and 6 orders in 2018).
SELECT *
FROM olist_orders_dataset
WHERE order_delivered_customer_date = '' AND order_status = 'delivered'

