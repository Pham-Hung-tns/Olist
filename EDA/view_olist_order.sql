CREATE VIEW vw_cleaned_orders AS
SELECT o.*
FROM olist_orders_dataset o
INNER JOIN (
    SELECT DISTINCT order_id 
    FROM olist_order_items_dataset
) oi ON o.order_id = oi.order_id