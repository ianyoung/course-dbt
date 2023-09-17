with source as (

    select * from {{ source('postgres', 'products') }}

),

staged as (

    select
        product_id,
        name,
        price,
        inventory

    from source

)

select * from staged

