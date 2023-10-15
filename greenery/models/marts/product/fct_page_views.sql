{% set event_types = [
    'page_view',
    'add_to_cart',
    'checkout',
    'package_shipped'
] %}

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
    {%- for event_type in event_types %}
        {{ sum_of('e.event_type', event_type ) }} as {{ event_type }}s,
    {%- endfor %}
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
