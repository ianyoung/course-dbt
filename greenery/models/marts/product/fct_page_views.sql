with 
    session_timing_agg as (
        select *
        from {{ ref('int_session_timing') }}
    )

select 
    e.session_id,
    e.user_id,
    coalesce(e.product_id, oi.product_id) as product_id,
    session_started_at,
    session_ended_at,
    sum(case when e.event_type = 'page_view' then 1 else 0 end) as page_views,
    sum(case when e.event_type = 'add_to_cart' then 1 else 0 end) as add_to_carts,
    sum(case when e.event_type = 'checkout' then 1 else 0 end) as checkouts,
    sum(case when e.event_type = 'package_shipped' then 1 else 0 end) as packages_shipped,
    datediff(minute, session_started_at, session_ended_at) as session_length_minutes
from 
    {{ ref('stg_postgres__events') }} as e
left join
    {{ ref('stg_postgres__order_items') }} as oi
    on oi.order_id = e.order_id
left join
    session_timing_agg as st
    on st.session_id = e.session_id
group by all
