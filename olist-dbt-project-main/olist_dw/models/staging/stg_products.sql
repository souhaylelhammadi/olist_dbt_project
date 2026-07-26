with source as (
    select * from {{ source('raw', 'olist_products_dataset') }}
),

renamed as(
    select product_id,
    product_category_name,
    product_name_lenght :: integer as product_name_lenght,
    product_description_lenght :: integer as product_description_lenght,
    product_photos_qty :: integer as product_photos_qty,
    product_weight_g :: numeric as product_weight_g,
    product_length_cm :: numeric as product_length_cm,
    product_height_cm :: numeric as product_height_cm,
    product_width_cm :: numeric as product_width_cm
    from source
)

select * from renamed