-- Question: Top 10 state and city by total customers
-- Insight: "sao paulo" is the city has highest total customers 
SELECT
	customer_state AS states,
	customer_city AS cities,
	COUNT(DISTINCT customer_id) AS total_customers
FROM olist_customers_dataset
GROUP BY customer_state, customer_city
ORDER BY total_customers DESC
LIMIT 10

-- Question: Average payment value by each customer
-- Insight: Average payment value by each customer is $160.99
SELECT ROUND((SUM(p.payment_value) / COUNT(distinct o.customer_id))::numeric,2) AS avg_payment_value
FROM(
	SELECT order_id, customer_id 
	FROM olist_orders_dataset
	WHERE order_approved_at != ''
) AS o
INNER JOIN olist_order_payments_dataset AS p
ON o.order_id = p.order_id


-- Question: Top 10 customers by payment_value
-- Insight: Any top 10 customers by payment value don't come from "sao paulo"
SELECT
	c.customer_unique_id,
	c.customer_city,
	c.customer_state,
	SUM(p.payment_value) AS payment_value
FROM(
	SELECT order_id, customer_id 
	FROM olist_orders_dataset
	WHERE order_approved_at != '' OR order_approved_at IS NOT NULL
) AS o
INNER JOIN olist_order_payments_dataset AS p
ON o.order_id = p.order_id
INNER JOIN olist_customers_dataset AS c 
ON o.customer_id = c.customer_id

GROUP BY c.customer_unique_id, c.customer_state, c.customer_city
ORDER BY payment_value DESC
LIMIT 10


-- Question: Repeat Customer Rate
-- Insight:  
--		total customers: 96096
--		repeat customers: 2997
--		repeat customer rate percentage = 3.12%
WITH customer_orders AS (
	SELECT 
		customer_unique_id,
		COUNT(customer_id) AS order_count
	FROM olist_customers_dataset
	GROUP BY customer_unique_id
)

SELECT 
	SUM(CASE WHEN order_count >= 2 THEN 1 ELSE 0 END) AS repeat_customers,
	SUM(CASE WHEN order_count = 1 THEN 1 ELSE 0 END) AS one_time_customers,
	COUNT(*) AS total_customers,
	
	ROUND(
		SUM(CASE WHEN order_count >= 2 THEN 1 ELSE 0 END)::numeric 
		/ COUNT(*) * 100, 
		2
	) AS repeat_customer_rate_pct
FROM customer_orders;

-- Question: Customer Segment (RFM Traditional)
-- Insight:
SELECT 
	c.customer_unique_id,
	DATE_PART('day', ( (SELECT MAX(order_purchase_timestamp) FROM olist_orders_dataset)::timestamp 
                       - MAX(o.order_purchase_timestamp)::timestamp )) AS Recency,
	COUNT(c.customer_id) AS Frequency,
	SUM(p.payment_value) AS Monetary
FROM (  
	SELECT order_id, customer_id, order_purchase_timestamp
	FROM olist_orders_dataset 
	WHERE order_status NOT IN ('canceled', 'unavailabled')
) AS o
INNER JOIN olist_order_payments_dataset AS p
ON o.order_id = p.order_id
INNER JOIN olist_customers_dataset AS c
ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id


