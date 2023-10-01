with products_in_orders as (
    
    select 
        order_id,
        count(product_id) as products_in_order
    from {{ ref('stg_postgres__order_items') }}
    group by 1
    
)

select
    o.order_id,
    o.user_id,
    o.promo_id,
    o.address_id,
    a.country,
    o.created_at,
    o.order_cost,
    o.shipping_cost,
    o.order_total,
    o.tracking_id,
    o.shipping_service,
    o.estimated_delivery_at,
    o.delivered_at,
    o.order_status,
    p.products_in_order
from 
    {{ ref('stg_postgres__orders') }} as o
left join
    {{ ref('stg_postgres__addresses') }} as a
    on a.address_id = o.address_id
left join
    products_in_orders as p
    on p.order_id = o.order_id