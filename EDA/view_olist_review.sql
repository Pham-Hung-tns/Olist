CREATE VIEW vw_cleaned_reviews AS
WITH Ranked_Reviews AS (
    SELECT *,
           ROW_NUMBER() OVER(PARTITION BY order_id ORDER BY review_answer_timestamp DESC) as row_num
    FROM olist_order_reviews_dataset
    WHERE review_id IS NOT NULL 
)
SELECT *
FROM Ranked_Reviews WHERE row_num = 1;