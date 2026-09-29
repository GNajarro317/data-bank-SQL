# Data Bank: Problem Write-Up
 
## Scenario
Data Bank is a digital bank that combines banking with secure, distributed data storage. Customers are assigned to nodes in the system, and are moved between nodes over time. Customers also make deposits, purchases, and withdrawals. The goal is to explore how nodes are allocated and to analyze customer transaction behavior.
 
## Tags
`SQL` `Snowflake` `Data Exploration` `Customer Analytics` `8 Week SQL Challenge`
 
## Skills
- Distinct counts and aggregation
- Joins
- CTEs and subqueries
- Date calculations
- Median and percentiles
- Conditional aggregation
- Running totals
- Comparing rows to the previous period
## Tables
- `regions`: region lookup
- `customer_nodes`: which node and region each customer is assigned to, and for what period
- `customer_transactions`: each customer's deposits, purchases, and withdrawals
## Task
 
### A. Customer Nodes Exploration
1. Find how many different nodes exist in the Data Bank system.
2. Find how many nodes belong to each region.
3. Find how many customers are allocated to each region.
4. Find how long customers typically stay on a node before being moved to a different one.
5. For each region, describe the spread of those stay lengths using the median, the 80th percentile, and the 95th percentile.
### B. Customer Transactions
1. For each transaction type, find how many customers used it and the total amount.
2. Find the average number of deposits and the average deposit amount per customer over their full history.
3. For each month, find how many customers made multiple deposits and also made a purchase or a withdrawal in that same month.
4. Find each customer's balance at the end of every month.
5. Find the share of customers whose balance grew by more than 5% compared to the previous month.