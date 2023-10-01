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

### Q1. What assumptions are you making about each model? (i.e. why are you adding each test?)

...

### Q2. Did you find any “bad” data as you added and ran tests on your models? How did you go about either cleaning the data in the dbt model or adjusting your assumptions/tests?

...

