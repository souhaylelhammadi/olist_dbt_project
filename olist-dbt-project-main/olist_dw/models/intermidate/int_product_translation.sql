with products as (
    select * from {{ ref('stg_products') }}
),

category_translated as (
    select * from {{ ref('stg_product_category_name_translation') }}
),

joined as (
    select products.product_id,
            products.product_category_name,
            category_translated.product_category_name_english,
            products.product_name_lenght,
            products.product_description_lenght,
            products.product_photos_qty,
            products.product_weight_g,
            products.product_length_cm,
            products.product_height_cm,
            products.product_width_cm
 from products left join category_translated
 on products.product_category_name = category_translated.product_category_name
)

select * from joined