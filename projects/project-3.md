# Project 3

## Part 1

### What is our overall conversion rate?

Answer: 62.4%

SQL:
```sql
-- 01. Overall conversion rate
select 
    count(distinct case when checkouts > 0 then session_id end) / count(distinct session_id) as conversion_rate
from
    fct_page_views
;
```

### What is our conversion rate by product?

Answer: 

![Conversion rate by product](/projects/assets/uplimit-dbt-conversion-rate-by-product.png)

SQL:
```sql
-- 02. Conversion rate by product
select
    pv.product_id,
    name as product_name,
    count(distinct case when checkouts > 0 then session_id end) / count(distinct session_id) as conversion_rate
from
    fct_page_views as pv
left join
    stg_postgres__products as p
    on p.product_id = pv.product_id
group by 1,2
;
```

## Part 5

### DAG

![Project 3 DAG](/projects/assets/uplimit-dbt-project-3-dag.png)

## Part 6

### Which products had their inventory change from week 2 to week 3? 

![Project 3 DAG](/projects/assets/uplimit-dbt-project-3-snapshot-changed.png)



