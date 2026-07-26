with reviews as (
    select * from {{ ref('stg_order_reviews') }}
),

ranked as (
    select *,
    row_number() over(partition by order_id order by review_creation_at desc) as review_rank
from reviews
)



select review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_at,
    review_answer_at

from ranked
where review_rank = 1 