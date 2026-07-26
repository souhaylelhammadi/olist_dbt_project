with source as (
    select * from {{ source('raw', 'olist_geolocation_dataset') }}
),

renamed as(
    select geolocation_zip_code_prefix as zip_code_prefix,
    geolocation_lat ::numeric as latitude,
    geolocation_lng ::numeric as longitude,
    geolocation_city as city,
    geolocation_state as state
    from source
)

select * from renamed