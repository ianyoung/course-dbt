with source as (

    select * from {{ source('postgres', 'addresses') }}

),

staged as (

    select 
        address_id,
        address,
        zipcode,
        state,
        country

    from source

)

select * from staged



