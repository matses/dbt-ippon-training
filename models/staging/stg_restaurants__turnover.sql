{% set queryPM %}
    select distinct payment_method from {{ source('restau', 'orders') }}
{% endset %}


{% if execute %}
    {% set payment_methods = run_query(queryPM).columns[0].values() %}
{% else %}
    {% set payment_methods = [] %}
{% endif %}
select
    r.name,
    {% for payment_method in payment_methods %}
        sum(case when o.payment_method = '{{payment_method}}' then amount end) as {{payment_method}}_amount,
    {% endfor %}
    sum(amount) as turnover
from {{ ref('base_orders') }} as o
left join {{ ref('base_restaurants') }} as r on o.RESTAURANT_IDENTIFIER = r.identifier  
group by r.name
