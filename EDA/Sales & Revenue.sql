/*
Data Quality Note:
During the EDA process, I discovered some orders (canceled, even delivered)
have payment records but NO detailed product data (items).
To ensure the accuracy of financial metrics (GMV) and Seller performance,
I created a CTE 'Valid_Orders' to serve as the basis for the analyses below.
*/
WITH valid_orders AS (
    -- Lấy những đơn hàng hợp lệ: Có ít nhất 1 sản phẩm và không bị hủy
    SELECT DISTINCT o.order_id, o.customer_id, o.order_status, o.order_approved_at
    FROM olist_orders_dataset o
    INNER JOIN olist_order_items_dataset oi 
        ON o.order_id = oi.order_id
    WHERE o.order_status IN ('delivered', 'shipped', 'invoiced', 'processing', 'approved')
)


-- Question: Actual Total Revenue
-- Insight: total revenue = 16008872.14
SELECT ROUND(SUM(p.payment_value::numeric),2)
FROM olist_order_payments_dataset AS p
INNER JOIN valid_orders 
ON valid_orders.order_id = p.order_id


-- Question: Total Revenue by year-month
-- Business Logic:
--		1. Revenue is recognized based on the total payment value (payment_value), regardless of the number of installments.
--		2. Revenue recognition is based on when the order is approved for payment (order_approved_at).
--		3. Only orders that actually generate revenue are counted (excluding canceled and unavailable orders).
-- Insight: 
--		1. 2016-12 and 2018-09 has only 1 order
--		2. 2018-05 has highest revenue: $1171843.38, but 2017-11 has highest total orders: 7280 unique orders
,orders_with_month AS (
    SELECT 
        o.order_id,
        TO_CHAR(o.order_approved_at::TIMESTAMP, 'YYYY-MM') AS revenue_month
    FROM valid_orders o
    WHERE o.order_approved_at != ''
)
SELECT
    o.revenue_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value::numeric),2) AS total_revenue
FROM orders_with_month o
JOIN olist_order_payments_dataset p
    ON o.order_id = p.order_id
GROUP BY o.revenue_month
ORDER BY total_revenue DESC;


-- Question: Analyze the usage rate of different payment methods (payment_type). 
--			 Which method generates the highest total transaction value?
-- Insight: 
--			1. Credit cards are the payment method that generates the highest total sales, accounting for 78.47% of usage.
--			2. Conversely, debit cards are the payment method that generates the lowest total revenue, accounting for only 1.35%.
--			3. There are 3 transactions with unclear payment methods, and their total transaction value is 0.
,payment_summary AS (
    SELECT
        p.payment_type,
		count(p.order_id) as total_order,
        SUM(p.payment_value)::numeric AS total_payment_value
    FROM olist_order_payments_dataset AS p
	INNER JOIN valid_orders AS o
	ON o.order_id = p.order_id
    GROUP BY payment_type
)

SELECT
    payment_type,
	total_order,
    ROUND(total_payment_value, 2) AS total_payment_value,
    ROUND(
        100 * total_payment_value
        / SUM(total_payment_value) OVER (),
        2
    ) AS percent_share
FROM payment_summary
ORDER BY total_payment_value DESC;


-- Question: Cumulative Revenue
,payment_by_month AS (
	SELECT 
		TO_CHAR(o.order_approved_at::TIMESTAMP, 'YYYY-MM') AS revenue_month, 
		SUM(p.payment_value)::numeric AS payment_value
	FROM valid_orders AS o
	INNER JOIN olist_order_payments_dataset as p
	ON o.order_id = p.order_id
	WHERE o.order_approved_at != '' 
	GROUP BY TO_CHAR(o.order_approved_at::TIMESTAMP, 'YYYY-MM')
	ORDER BY revenue_month ASC
)

SELECT revenue_month, SUM(payment_value) OVER (ORDER BY revenue_month) AS cumulative_revenue
FROM payment_by_month


-- Question: MoM - Month over Month Growth
, payment_by_month AS (
	SELECT 
		TO_CHAR(order_approved_at::TIMESTAMP, 'YYYY-MM') AS revenue_month, 
		SUM(p.payment_value)::numeric AS payment_value
	FROM valid_orders AS o
	JOIN olist_order_payments_dataset p
	ON o.order_id = p.order_id
	WHERE order_approved_at != ''
	GROUP BY TO_CHAR(order_approved_at::TIMESTAMP, 'YYYY-MM')
),
final AS (
	SELECT 
		revenue_month,
		payment_value,
		LAG(payment_value) OVER (ORDER BY revenue_month) AS prev_month_value
	FROM payment_by_month
)

SELECT 
	revenue_month,
	payment_value,
	prev_month_value,
	CASE 
		WHEN prev_month_value = 0 THEN NULL
		ELSE ROUND(((payment_value - prev_month_value) / prev_month_value)::numeric * 100,2)
	END AS mom_growth
FROM final
ORDER BY revenue_month;
