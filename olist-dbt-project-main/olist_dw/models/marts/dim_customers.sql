with customers as (
    select * from {{ ref('stg_customer') }}
)

select customer_id,
    customer_unique_id,
    zip_code_prefix,
    city,
    state
from customers