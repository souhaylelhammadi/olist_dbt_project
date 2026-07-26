with products as (
    select * from {{ ref('int_product_translation') }}

)

    select  product_id,
            product_category_name,
            product_category_name_english,
            product_name_lenght,
            product_description_lenght,
            product_photos_qty,
            product_weight_g,
            product_length_cm,
            product_height_cm,
            product_width_cm

    from products