with source as (
    select * from {{ source('raw', 'olist_order_payments_dataset') }}
),

renamed as(
    select order_id,
    payment_sequential,
    payment_type,
    payment_installments ::integer as payment_installments,
    payment_value :: numeric as payment_value
    from source
)

select * from renamed