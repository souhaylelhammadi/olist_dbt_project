with geolocation as (
    select * from {{ ref('stg_geolocation') }}
),

aggregated as (
        select  zip_code_prefix,
    avg(latitude) as latitude,
    avg(longitude) as longitude,
    max(city) as city,
    max(state) as state
    
from geolocation
group by zip_code_prefix
)

select * from aggregated