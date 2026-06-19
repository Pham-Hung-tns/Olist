WITH clean_reviews AS (
	SELECT
		review_id,
		order_id,
		review_score,
		review_comment_title,
		review_comment_message,
		review_creation_date,
		review_answer_timestamp,
		ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY review_answer_timestamp DESC) as row_num
	from olist_order_reviews_dataset
)

WITH clean_orders AS(
	SELECT *
	FROM olist_orders_dataset AS o
	WHERE o.order_status = 'delivered' 
			AND o.order_delivered_customer_date != '' 
)


-- Question: Điểm đánh giá trung bình của các đơn hàng
-- Insight: Có 98673 đơn hàng có đánh giá, và điểm đánh giá trung bình là 4.09 (trên thang điểm 5)
SELECT 
    ROUND(AVG(review_score), 2) AS average_score_of_platform,
    COUNT(order_id) AS total_reviewed_orders
FROM clean_reviews
WHERE row_num = 1;


-- Question: Phân bổ số lượng đơn hàng theo mức điểm đánh giá
-- Insight: 
--			5*: 57009
--			4*: 19040
--			3*: 8133
--			2*: 3130
--			1*: 11361
SELECT review_score, count(order_id)
FROM clean_reviews
WHERE row_num = 1
GROUP BY review_score



-- Question: tổng số đơn hàng và thời gian giao hàng trung bình theo từng bang
-- Insight: "SP" là nơi có tổng số đơn hàng cao nhất (40494) và thời gian giao hàng trung bình thấp nhất (8.76 ngày)
SELECT 
    c.customer_state,
    COUNT(o.order_id) AS total_orders,
    -- Tính khoảng cách giữa ngày giao thực tế và ngày mua (đơn vị: Ngày)
    -- Postgres trừ 2 timestamp sẽ ra kiểu Interval. Cần chuyển đổi ra số ngày.
    ROUND(
        AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date::TIMESTAMP - o.order_purchase_timestamp::TIMESTAMP)) / 86400)::numeric, 
        2
    ) AS avg_delivery_time_days
FROM clean_orders o
JOIN olist_customers_dataset c 
    ON o.customer_id = c.customer_id

GROUP BY c.customer_state
ORDER BY avg_delivery_time_days ASC;

-- Question: Tính tỉ lệ giao hàng trễ (Ngày giao thực tế > Ngày giao dự kiến)
-- Insight: Có 7826 đơn hàng giao trễ, tỉ lệ giao trễ là 8.11%
SELECT
	ROUND((
		SELECT count(*)
		FROM clean_orders
		WHERE order_delivered_customer_date > order_estimated_delivery_date
	) / COUNT(*)::NUMERIC * 100,2) AS late_percent
FROM clean_orders AS c


-- Questions:
-- Insight:
SELECT 
    CASE 
        WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date THEN 'Late Delivery (Giao trễ)'
        ELSE 'On-time / Early Delivery (Đúng hạn/Sớm)'
    END AS delivery_status,
    COUNT(o.order_id) AS total_orders,
    -- Tính điểm trung bình
    ROUND(AVG(r.review_score), 2) AS average_review_score,
    -- Tính tỷ lệ % số đơn bị đánh giá 1 sao trong từng nhóm (Điểm cộng lớn cho Portfolio)
    ROUND(SUM(CASE WHEN r.review_score = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(o.order_id), 2) AS percent_1_star_reviews
FROM clean_orders o
JOIN clean_reviews r 
    ON o.order_id = r.order_id AND r.row_num = 1
GROUP BY 1;


, Delivery_Calculations AS (
    -- Tính số ngày giao hàng thực tế
    SELECT 
        o.order_id,
        r.review_score,
        EXTRACT(EPOCH FROM (o.order_delivered_customer_date::TIMESTAMP - o.order_purchase_timestamp::TIMESTAMP))/86400 AS delivery_days
    FROM clean_orders o
    JOIN clean_reviews r ON o.order_id = r.order_id AND r.row_num = 1
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
)

-- Chia nhóm (Bucketing) và tính điểm
SELECT 
    CASE 
        WHEN delivery_days <= 7 THEN '1. Fast (< 7 days)'
        WHEN delivery_days <= 14 THEN '2. Normal (8 - 14 days)'
        WHEN delivery_days <= 21 THEN '3. Slow (15 - 21 days)'
        ELSE '4. Very Slow (> 21 days)'
    END AS delivery_speed_category,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(review_score), 2) AS average_score
FROM Delivery_Calculations
GROUP BY 1
ORDER BY 1;