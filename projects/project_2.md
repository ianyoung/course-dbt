# Project 2

## Part 1 - Models

### Q: What is our user repeat rate?

_Repeat Rate = Users who purchased 2 or more times / users who purchased_

```sql
-- Find the number of orders per user
with user_orders as (

    select 
      user_id,
      count(distinct order_id) as num_orders 
    
    from stg_postgres__orders 
    group by 1
    
),

-- Count the number of orders (total & repeat with 2 plus)
order_count as (

    select
        count(distinct user_id) as total_orders,
        sum(case when num_orders >= 2 then 1 else 0 end) as two_plus_orders
    
    from user_orders

)

select 
    total_orders,
    two_plus_orders,
    (two_plus_orders / total_orders) * 100 as user_repeat_rate
from order_count

```

### Q2. What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Good indicators of a user who will likely purchase again:

- Order successfully delivered and on time.
- No customer support issues post order indicating a problem.
- On site activity since they placed their order.
- A positive review.
- Positive social media engagement following the order (likes, shares, comments) where applicable and measurable.
- Items added to shopping basket.

Indicators of users who are likely NOT to purchase again:

- Problems with their order such as not being delivered on time, incorrect item received, or a problem with the goods received.
- Customer support issues raised following the order.
- No activity or engagement since receiving the order.
- A negative review.
- Lack of social media engagement surrounding the brand where applicable and measurable.
- A promotional code for a first-time purchase might also indicate a one-time customer to take advantage of the promotion only.

If you had more data, what features would you want to look into to answer this question?

With more data I would look into customer support tickets to run them against them orders, as well as social media activity on Greenery's various social media accounts. I'd also look into the review system to get the rating and sentiment of any user reviews and match to the user where possible.

Finally, it would also be good to view our promotional campaign activity and monitor user cohorts to find any particular differences from period to period.

**Q3. Explain the product mart models you added. Why did you organize the models in the way you did?**

...

**Q4. Paste in an image of your DAG from the docs**

![Project 2 DAG](/projects/assets/uplimit-dbt-greenery-dag.png)

## Part 2 - Tests

NOTE: Currently only staging models have had tests added. Other models to follow.

### Q1. What assumptions are you making about each model? (i.e. why are you adding each test?)

ID's should all be `unique` and `not_null`. This is important to ensure every record has a unique identifier in the database.

`not_null` was added to any fields where a value was expected. This helps to ensure data quality.

`accepted_values` were added to any fields with specific accepted values such as `event_type` where the accepted values included `checkout`, `add_to_cart`, `package_shipped`, or `checkout`. Any other values would see this test fail.

`relationship` tests were added to foreign keys linking to primary keys in other tables. This is to ensure referential integrity.

Reference: [dbt generic tests](https://docs.getdbt.com/docs/build/tests#generic-tests)

### Q2. Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

For the tests so far added to the staging models most assumptions proved correct. However it was helpful to run the tests to both confirm my assumptions and to provide me with a place to dig into the data within the data warehouse to look at the values for the specified column.

### Q3. Your stakeholders at Greenery want to understand the state of the data each day. Explain how you would ensure these tests are passing regularly and how you would alert stakeholders about bad data getting through.

To ensure these tests pass regularly they would be executed on every dbt run set up on a schedule using an orchestration tool or dbt cloud.

An alert can be configured to generate an email or Slack message to inform the relevant users about the failing tests. `dbt build` will ensure that all tests are run prior to running each model and any subsequent models aren't run with failing upstream tests.

## Part 3. dbt Snapshots

### Q1. Run the product snapshot model using dbt snapshot and query it in snowflake to see how the data has changed since last week. 

Run the snapshot:
```
dbt snapshot
```
View the changes:
```sql
select *
from products_snapshot
```

### Q2. Which products had their inventory change from week 1 to week 2? 

```sql
select *
from products_snapshot
where dbt_valid_to is not null
```
The following products changed from week 1 to week 2:

- Pothos
- Bamboo
- Philodendron
- Monstera
- String of pearls
- ZZ Plant


