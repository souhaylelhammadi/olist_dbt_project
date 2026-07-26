--1. What's the total revenue and average review score across all orders?

select
    round(sum(total_payment_value), 2) as total_revenue,
    round(avg(review_score), 2) as avg_review_score
from dev.fact_orders;

--Which state has the most customers?

select state, count(*) as total_customers
from dev.dim_customers
group by state
order by total_customers desc
limit 1;

--Which product category generates the most revenue?

select
    dim_product.product_category_name_english,
    round(sum(fact_order_items.price), 2) as total_revenue
from dev.fact_order_items
join dev.dim_product on fact_order_items.product_id = dim_product.product_id
group by dim_product.product_category_name_english
order by total_revenue desc
limit 1;

-- In which month did revenue peak, and what happened afterward?


select
    date_trunc('month', order_purchase_at) as month,
    round(sum(total_payment_value), 2) as monthly_revenue,
    count(order_id) as monthly_orders
from dev.fact_orders
group by month
order by monthly_revenue desc
limit 5;

-- Which payment type has the highest average order value?
select
    primary_payment_type,
    round(avg(total_payment_value), 2) as avg_order_value
from dev.fact_orders
where primary_payment_type is not null
group by primary_payment_type
order by avg_order_value desc
limit 1;

--What percentage of orders are delivered vs. canceled?

select
    order_status,
    count(*) as order_count,
    round(100.0 * count(*) / sum(count(*)) over (), 2) as pct_of_total
from dev.fact_orders
group by order_status
order by order_count desc;

--How does review score differ between late and early deliveries?

select
    case
        when delivery_days_vs_estimated > 0 then 'Early'
        when delivery_days_vs_estimated = 0 then 'On Time'
        else 'Late'
    end as delivery_bucket,
    round(avg(review_score), 2) as avg_review_score
from dev.fact_orders
where delivery_days_vs_estimated is not null
group by delivery_bucket
order by avg_review_score desc;

--Who is the top seller by revenue, and how many orders did they fulfill?

select
    seller_id,
    round(sum(price), 2) as total_revenue,
    count(distinct order_id) as total_orders
from dev.fact_order_items
group by seller_id
order by total_revenue desc
limit 1;