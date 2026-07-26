with sellers as (
    select * from {{ ref('stg_seller') }}
)

select seller_id,
    zip_code_prefix,
    city,
    state
    from sellers