with source as (

    select * from {{ source('postgres', 'promos') }}

),

staged as (

    select
        promo_id,
        discount,
        status

    from source
)

select * from staged



