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


-- Question: TOP 10 product category with the highest total orders
-- Insights: "bed_bath_table" is the highest total orders
SELECT 
    pc.product_category_name_english,
    COUNT(*) AS total_orders
FROM valid_orders AS o 
INNER JOIN olist_order_items_dataset AS i
    ON o.order_id = i.order_id
INNER JOIN olist_products_dataset p 
    ON p.product_id = i.product_id
INNER JOIN product_category_name_translation pc 
    ON pc.product_category_name = p.product_category_name
GROUP BY pc.product_category_name_english
ORDER BY total_orders DESC
LIMIT 10;


-- Question: TOP 10 product category with the highest total sales revenue
-- Business: 
--			1. price: This is the actual amount of money the Seller earned from selling the product.
--			2. freight_value: This is the amount paid to the shipping (logistics) company.
--			3. payment_value: This is the actual amount after deducting: discounts (vouchers), credit card interest charges, or system discrepancies.
SELECT 
    p.product_category_name,
    ROUND(SUM(oi.price)::numeric, 2) AS total_product_revenue,
    COUNT(oi.product_id) AS total_items_sold
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p 
    ON oi.product_id = p.product_id
JOIN olist_orders_dataset o 
    ON oi.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY p.product_category_name
ORDER BY total_product_revenue DESC
LIMIT 10;


-- Question: Top 10 Sellers with the highest total sales revenue
SELECT 
    s.seller_id,
    s.seller_city,
    s.seller_state,
    ROUND(SUM(oi.price)::numeric, 2) AS total_seller_revenue,
    COUNT(DISTINCT oi.order_id) AS total_orders_fulfilled
FROM olist_order_items_dataset oi
INNER JOIN olist_sellers_dataset s 
    ON oi.seller_id = s.seller_id
INNER JOIN olist_orders_dataset o 
    ON oi.order_id = o.order_id
WHERE o.order_status NOT IN ('canceled', 'unavailable')
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY total_seller_revenue DESC
LIMIT 10;


-- Question: 
,result_final AS (
	SELECT 
	    COUNT(*) AS total_items,
	    COUNT(DISTINCT c.customer_unique_id) AS total_customers
	FROM olist_order_items_dataset AS oi
	JOIN valid_orders AS o 
	    ON o.order_id = oi.order_id
	INNER JOIN olist_customers_dataset AS c
	ON o.customer_id = c.customer_id
	GROUP BY oi.seller_id
)

SELECT 
	ROUND(AVG(total_items)) AS avg_total_items,
	ROUND(AVG(total_customers)) AS avg_total_customers
FROM result_final AS r
