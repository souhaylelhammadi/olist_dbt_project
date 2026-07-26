with order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('dim_product') }}
),

seller as (
    select * from {{ ref('dim_seller') }}
),

joined as (
    select order_items.order_id,
    order_items.order_item_id,
    order_items.product_id,
    order_items.seller_id,
    order_items.shipping_limit_at,
    order_items.price,
    order_items.freight_value,
    products.product_category_name_english,
    seller.state as saller_state

    from order_items left join products
    on order_items.product_id = products.product_id left join
    seller on order_items.seller_id = seller.seller_id

)

select * from joined