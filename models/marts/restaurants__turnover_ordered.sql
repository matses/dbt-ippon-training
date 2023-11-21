select * from {{ ref("stg_restaurants__turnover")}}
order by turnover desc limit {{ var('nbRestauToShow') }}