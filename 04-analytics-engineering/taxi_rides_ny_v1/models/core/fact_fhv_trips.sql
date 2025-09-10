{{
    config(
        materialized='table'
    )
}}

with fhv_tripdata as (
    select *
    from {{ ref('stg__fhv_tripdata') }}

),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)

select
    fhv.dispatching_base_num,
    fhv.pickup_datetime,
    fhv.dropoff_datetime,
    fhv.pickup_locationid,
    fhv.dropoff_locationid,
    fhv.sr_flag,
    fhv.affiliated_base_number,
    dz.locationid, 
    dz.borough, 
    dz.zone,
    dz.service_zone 
from fhv_tripdata fhv
inner join dim_zones dz
on fhv.pickup_locationid = dz.locationid
    and fhv.dropoff_locationid = dz.locationid