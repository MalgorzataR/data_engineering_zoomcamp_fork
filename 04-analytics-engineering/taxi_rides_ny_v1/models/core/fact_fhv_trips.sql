{{
    config(
        materialized='table'
    )
}}

with fhv_tripdata as (
    select *,
    'Fhv' as service_type
    from {{ ref('stg__fhv_tripdata') }}

),
dim_zones as (
    select * from {{ ref('dim_zones') }}
    where borough != 'Unknown'
)

select
    fhv.dispatching_base_num,
    fhv.service_type,
    fhv.pickup_datetime,
    fhv.dropoff_datetime,
    fhv.pickup_locationid,
    fhv.dropoff_locationid,
    fhv.sr_flag,
    fhv.affiliated_base_number,
    pickup_zone.borough as pickup_bourough, 
    pickup_zone.zone as pickup_zone,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone
from fhv_tripdata fhv
inner join dim_zones dropoff_zone
on fhv.pickup_locationid = dropoff_zone.locationid
inner join dim_zones pickup_zone
on fhv.dropoff_locationid = pickup_zone.locationid