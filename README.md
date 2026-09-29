### Date created
Date project was created: 09-25-2026 | Date README file was last updated: 09-29-2026
 
### Project Title
Data Bank SQL Case Study
 
### Description
This project works through Case Study 4 (Data Bank) from the 8 Week SQL Challenge. It is a focused SQL practice project covering data exploration on customer nodes and analysis of customer transactions.
 
This repo includes solutions for Part A and Part B of the case study questions.
 
The problems included are:
 
- A1 - Unique Nodes: counting the distinct nodes in the Data Bank system
- A2 - Nodes per Region: joining nodes to regions and counting nodes for each region
- A3 - Customers per Region: counting distinct customers allocated to each region
- A4 - Average Reallocation Days: summing days per customer and node, excluding open-ended assignments, then averaging
- A5 - Reallocation Days by Region: median, 80th percentile, and 95th percentile of reallocation days for each region
- B1 - Transaction Types: unique customer count and total amount for each transaction type
- B2 - Average Deposits per Customer: averaging each customer's historical deposit count and deposit amount
- B3 - Monthly Customer Activity: finding customers with multiple deposits plus a purchase or withdrawal in the same month
- B4 - Monthly Closing Balance: netting deposits against purchases and withdrawals, then carrying a running balance by month
- B5 - Balance Growth: comparing each month's closing balance to the previous month and finding the share of customers with more than 5% growth

The challenge requirements and source data are provided by the 8 Week SQL Challenge. The SQL solutions in this repository are my own.
 
### Tables
- `regions` - region_id, region_name
- `customer_nodes` - customer_id, region_id, node_id, start_date, end_date
- `customer_transactions` - customer_id, txn_date, txn_type, txn_amount
### Files
- `problem.md` - scenario, tags, skills, and tasks for each question
- `data_bank_case_study_4.sql` - solutions for Part A and Part B
### Key Takeaways
These problems reinforced:
 
- COUNT DISTINCT for unique counts
- Joining a lookup table to add readable names
- Filtering out placeholder end dates (year 9999) before calculating durations
- Date difference calculations with DATEDIFF
- CTEs for building a duration table before summarizing it
- Median and percentile calculations with PERCENTILE_CONT
- Conditional aggregation with CASE WHEN
- Subqueries for multi-step aggregation
- Extracting month from a date and grouping by it
- INNER JOIN on two CTEs to combine conditions
- Running totals with SUM OVER
- LAG for comparing a row to the previous month
- Percentage of total calculations
### Data Source
8 Week SQL Challenge, Case Study 4:
 
1. [Data Bank](https://8weeksqlchallenge.com/case-study-4/)