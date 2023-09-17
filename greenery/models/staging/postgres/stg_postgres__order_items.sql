with source as (

    select * from {{ source('postgres', 'order_items') }}

),

staged as (

    select
        order_id,
        product_id,
        quantity

    from source

)

select * from staged



