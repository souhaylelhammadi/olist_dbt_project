with orders as (
    select * from {{ ref('stg_orders') }}
),

payment as (
    select * from {{ ref('int_order_payments_summary') }}
),

review as (
    select * from {{ ref('int_order_reviews') }}
),

joined as (
    select 
        orders.order_id,
        orders.customer_id,
        orders.order_status,
        orders.order_purchase_at,
        orders.order_approved_at,
        orders.order_delivered_carrier_at,
        orders.order_delivered_customer_at,
        orders.order_estimated_delivery_at,
        payment.total_payment_value,
        payment.payment_count,
        payment.primary_payment_type,
        review.review_score,
        date_part('day', orders.order_delivered_customer_at - orders.order_purchase_at) as delivery_days,
        date_part('day', orders.order_estimated_delivery_at - orders.order_delivered_customer_at) as delivery_days_vs_estimated

    from orders 
    left join payment on orders.order_id = payment.order_id
    left join review on orders.order_id = review.order_id
)

select *
from joined