with payments as(
    select * from {{ ref('stg_order_payments') }}
),

aggregated as(
    select order_id,
    sum(payment_value) as total_payment_value,
    max(payment_installments) as max_installments,
    count(*) as payment_count

    from payments
    group by order_id
),

primary_payment_type as (
    select Distinct on (order_id)
    order_id,
    payment_type as primary_payment_type
    from payments
    order by order_id, payment_sequential
)

select aggregated.order_id,
        aggregated.total_payment_value,
        aggregated.max_installments,
        aggregated.payment_count,
        primary_payment_type.primary_payment_type

    from aggregated left join primary_payment_type
    on aggregated.order_id = primary_payment_type.order_id