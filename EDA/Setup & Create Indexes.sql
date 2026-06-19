-- 1. Trục trung tâm: order_id
CREATE INDEX IF NOT EXISTS idx_items_order_id ON olist_order_items_dataset (order_id);
CREATE INDEX IF NOT EXISTS idx_payments_order_id ON olist_order_payments_dataset (order_id);
CREATE INDEX IF NOT EXISTS idx_reviews_order_id ON olist_order_reviews_dataset (order_id);

-- 2. Trục khách hàng: customer_id
CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON olist_orders_dataset (customer_id);

-- 3. Trục Sản phẩm & Người bán (dùng trong file Product & Seller Analysis)
CREATE INDEX IF NOT EXISTS idx_items_product_id ON olist_order_items_dataset (product_id);
CREATE INDEX IF NOT EXISTS idx_items_seller_id ON olist_order_items_dataset (seller_id);

-- Lọc trạng thái đơn hàng (Dùng trong hầu hết các file: WHERE order_status IN (...))
CREATE INDEX IF NOT EXISTS idx_orders_status ON olist_orders_dataset (order_status) WHERE order_status != 'delivered';

-- Lọc và tính toán thời gian mua hàng / phê duyệt 
CREATE INDEX IF NOT EXISTS idx_orders_purchase_time ON olist_orders_dataset (order_purchase_timestamp);
CREATE INDEX IF NOT EXISTS idx_orders_approved_at ON olist_orders_dataset (order_approved_at);

-- Lọc ngày giao hàng thực tế (Dùng trong Delivery & Reviews để tính ngày trễ/sớm)
CREATE INDEX IF NOT EXISTS idx_orders_delivered_date ON olist_orders_dataset (order_delivered_customer_date);

-- Tối ưu hóa truy vấn đếm số lượng khách hàng / đơn hàng theo Bang
CREATE INDEX IF NOT EXISTS idx_customers_state ON olist_customers_dataset (customer_state);