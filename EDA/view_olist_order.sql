/*
Data Quality Note:
During the EDA process, I discovered some orders (canceled, even delivered)
have payment records but NO detailed product data (items).
To ensure the accuracy of financial metrics (GMV) and Seller performance,
I created a view 'view_valid_orders' to serve as the basis for the analyses below.
*/

CREATE OR REPLACE VIEW view_valid_orders AS
SELECT o.order_id, o.customer_id, o.order_status, o.order_approved_at
FROM olist_orders_dataset o
WHERE o.order_status IN ('delivered', 'shipped', 'invoiced', 'processing', 'approved')