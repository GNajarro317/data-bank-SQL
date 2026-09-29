-- Author: Gerardo Najarro
-- Created: 09-25-2026
-- 8 Week SQL Challenge, Case Study 4: Data Bank
-- Part A: Customer Nodes Exploration | Part B: Customer Transactions
 
 
-- ============================================================
-- A. Customer Nodes Exploration
-- ============================================================
 
-- A1. How many unique nodes are there on the Data Bank system?
-- Just a distinct count of node_id across the whole table.
select
    count(distinct node_id) as unique_nodes
from customer_nodes
;
 
-- A2. What is the number of nodes per region?
-- Join to regions to get the region name, then count the node rows for each region.
select
    region_name,
    count(node_id) as number_of_nodes
from customer_nodes as c
 left join regions as r
    on c.region_id = r.region_id
group by region_name
;
 
-- A3. How many customers are allocated to each region?
-- Same join as above, but this time count distinct customers so nobody is counted twice.
select
    region_name,
    count(distinct customer_id) as number_of_customers
from customer_nodes as c
 left join regions as r
    on c.region_id = r.region_id
group by region_name
;
 
-- A4. How many days on average are customers reallocated to a different node?
-- dt: total days each customer spent on each node.
-- Rows with an end_date in year 9999 are the current placeholder (still on that node), so they are filtered out.
with dt as (
select
    customer_id,
    node_id,
    sum(datediff('day', start_date, end_date)) as duration
from customer_nodes
where year(end_date) != 9999
group by all
)
 
-- Average those durations across all customers and nodes, rounded to whole days.
select
    round(avg(duration), 0) as average_days
from dt
;
 
-- A5. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
-- dt: same duration logic as A4, but now keeping region_id so we can break it out by region.
with dt as (
select
    customer_id,
    node_id,
    region_id,
    sum(datediff('day', start_date, end_date)) as duration
from customer_nodes
where year(end_date) != 9999
group by all
)
 
-- Join to regions for the name, then get the average, median, and 80th/95th percentiles per region.
select
    region_name,
    round(avg(duration), 0) as average_days,
    median(duration),
    percentile_cont(0.8) within group (order by duration) as pc_80,
    percentile_cont(0.95) within group (order by duration) as pc_95
from dt
    left join regions as r
        on dt.region_id = r.region_id
group by region_name
;
 
 
-- ============================================================
-- B. Customer Transactions
-- ============================================================
 
-- B1. What is the unique count and total amount for each transaction type?
-- Group by transaction type, count the distinct customers, and add up the amounts.
select
    txn_type,
    count(distinct customer_id) as unique_count,
    sum(txn_amount) as total_amount
from customer_transactions
group by 1
;
 
-- B2. What is the average total historical deposit counts and amounts for all customers?
-- The inner query gives each customer's total number of deposits and total deposit amount.
-- The outer query then averages those two numbers across all customers.
select
    avg(deposit_count) as avg_deposits,
    avg(total_amount) as avg_amount
from (
    select
        customer_id,
        count(customer_id) as deposit_count,
        sum(txn_amount) as total_amount
    from customer_transactions
    where txn_type = 'deposit'
    group by customer_id
)
;
 
-- B3. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
-- dt: customers with more than 1 deposit in a given month.
with dt as ( 
    select
        month(txn_date) as month,
        customer_id
    from customer_transactions
    where txn_type = 'deposit' 
    group by 
        month,
        customer_id
    having count(*) > 1 
),
 
-- pt: customers with at least 1 purchase or withdrawal in a given month.
pt as ( 
    select
        month(txn_date) as month,
        customer_id
    from customer_transactions
    where txn_type = 'purchase' or txn_type = 'withdrawal'
    group by 
        month, 
        customer_id
    having count(*) >= 1
)
 
-- Inner join keeps only customers who meet both conditions in the same month, then count them per month.
select 
    dt.month,
    count(distinct dt.customer_id) customer_count
from dt
    inner join pt
        on dt.customer_id = pt.customer_id
        and dt.month = pt.month
group by dt.month
order by dt.month
;
 
-- B4. What is the closing balance for each customer at the end of the month?
-- The inner query adds up each customer's deposits and their purchases plus withdrawals for every month.
-- The outer query subtracts the two and runs a running total by month, so each month's balance carries over from earlier months.
select
    month,
    customer_id,
    sum(deposit_amount - total_withdrawal_amount) over (
        partition by customer_id 
        order by month
    ) as closing_balance
from (
    select
        month(txn_date) as month,
        customer_id,
        sum(case when txn_type = 'deposit' then txn_amount else 0 end) as deposit_amount,
        sum(case when  txn_type = 'purchase' or txn_type = 'withdrawal' then txn_amount else 0 end) as total_withdrawal_amount
    from customer_transactions
    group by 
        month,
        customer_id
)
order by 
    customer_id,
    month
;
 
-- B5. What is the percentage of customers who increase their closing balance by more than 5%?
-- Innermost query: monthly deposit and withdrawal totals per customer (same as B4).
-- Middle query: running total by month to get each customer's closing balance (same as B4).
-- Next query: uses lag to pull in the previous month's closing balance on the same row.
-- Outer query: counts customers whose balance grew by more than 5% from the prior month (ignoring a starting balance of 0 or less),
-- then divides by all customers to get a percentage.
select 
    round(
        count(distinct case when prev_balance > 0 and ((closing_balance - prev_balance) / prev_balance) > 0.05 then customer_id end) 
        * 100.0 / count(distinct customer_id), 
    2) as pct_high_growth_customers
from (
    select 
        *,
        lag(closing_balance) over (partition by customer_id order by month) as prev_balance
    from (
        select
            month,
            customer_id,
            sum(deposit_amount - total_withdrawal_amount) over (
                partition by customer_id 
                order by month
            ) as closing_balance
        from (
            select
                month(txn_date) as month,
                customer_id,
                sum(case when txn_type = 'deposit' then txn_amount else 0 end) as deposit_amount,
                sum(case when  txn_type = 'purchase' or txn_type = 'withdrawal' then txn_amount else 0 end) as total_withdrawal_amount
            from customer_transactions
            group by 
                month(txn_date),
                customer_id
        )
    )
)
;
 