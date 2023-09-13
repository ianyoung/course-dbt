-- 1. How many users do we have?
select count(distinct user_id)
from stg_users
-- 130 unique users


-- 2. On average, how many orders do we receive per hour?
with orders_per_hour as (

    select
        date_trunc('hour', created_at) as order_hour,
        count(distinct order_id) as order_count
    from stg_orders
    group by 1
    
)

select 
    round(avg(order_count), 2) as avg_orders_per_hour
from orders_per_hour
-- 7.52 orders per hour


-- 3. On average, how long does an order take from being placed to being delivered?
with delivery_time as (

    select 
        order_id,
        created_at,
        delivered_at,
        timestampdiff(hour, created_at, delivered_at) AS delivery_hours
    
    from stg_orders
    where delivered_at is not null
    
)

select 
    round(avg(delivery_hours), 2) as avg_delivery_time
from delivery_time
-- 93.40 hours avg delivery time


-- 4. How many users have only made one purchase? Two purchases? Three+ purchases?
with user_orders as (

    -- regardless of whether completed or not
    select 
        user_id,
        count(user_id) as order_count
    
    from stg_orders
    group by 1
    
)

select 
    sum(case when order_count = 1 then 1 else 0 end) as one_purchase,
    sum(case when order_count = 2 then 1 else 0 end) as two_purchases,
    sum(case when order_count >= 3 then 1 else 0 end) as three_plus_purchases

from user_orders
-- 1 purchase = 25, 2 purchases = 28, 3+ purchases = 71

-- 5. On average, how many unique sessions do we have per hour?
with sessions_per_hour as (

    select 
        date_trunc('HOUR', created_at) as session_hour,
        count(distinct session_id) as session_count
    
    from stg_events
    group by 1
    
)

select 
    round(avg(session_count), 2) as avg_sessions
from sessions_per_hour
-- 16.33 sessions per hour
