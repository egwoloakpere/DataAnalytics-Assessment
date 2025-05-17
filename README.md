# DataAnalytics-Assessment

This repository contains SQL query solutions for Cowrywise technical assessment on customer insights involving savings.

---------------------------------------------------------------------------

# Overview of Tables Used

- users_customuser: Contains customer demographic and account information.
- plans_plan: Holds savings and investment plan metadata.
- savings_savingsaccount: Records inflow deposit transactions.
- withdrawals_withdrawal: Records customer withdrawals.
  
---------------------------------------------------------------------------

# Solutions

1. High-Value Customers with Multiple Products
- The objective of this question is to identify customers with at least one funded savings plan and one funded investment plan, and sort by total deposits.
     
- I used the following approach for this problem;
      A. Join the 3 tables required for this exercise,
      B. Use CASE statements to count unique funded savings i.e., is_regular_savings = 1, and investment plans i.e., is_a_fund = 1
      C. Aggregate deposits, filter by customers having both types i.e., only users with at least 1 savings and investment plan
      D. Convert kobo to Naira and round to 2 dp.

===========================================================================

2. Transaction Frequency Analysis
- The objective of this question is to classify customers into "High", "Medium", and "Low Frequency" based on average transactions per month.
  
- I used the following approach for this problem;
    A. First, calculate the monthly transaction count per customer.
    B. Compute the average monthly transactions for each.
    C. Categorize based on thresholds (≥10, 3–9, ≤2) and count customers per category.

===========================================================================

3. Account Inactivity Alert
- The objective of this question is to find active plans that have had no inflow for over 365 days (1 year).

- I used the following approach for this problem;
   A. Join plans_plan and savings_savingsaccount using LEFT JOIN.
   B. Filter only plans with (is_deleted = 0) and valid deposits (confirmed_amount > 0).
   C. Use MAX(transaction_date) and DATEDIFF() to compute days of inactivity.
   D. Display plans with no inflow or with inflow more than 365 days ago.

===========================================================================

4. Customer Lifetime Value (CLV) Estimation

- The objective of this question is to estimate CLV using tenure and transaction volume.
   -- CLV = (total_transactions / tenure_months) * 12 * average_profit_per_transaction  
   -- Where average profit is 0.1% of average transaction value

- I used the following approach for this problem;
   A. Compute tenure using TIMESTAMPDIFF() from date_joined.
   B. Count total valid transactions i.e., confirmed_amount > 0.
   C. Calculate average transaction value and apply the CLV formula.
   D. Prevent division by zero using NULLIF(tenure, 0).

===========================================================================

# Challenges & Resolutions

- These are a few challenges I encountered during this project and how i resolved them.
  
A. Handling zero-tenure accounts during CLV calculation
    I used NULLIF() to prevent division by zero.
B. Missing names in "name" column
    I used CONCAT(first_name, last_name) to reconstruct customer names.
C. Converting confirmed_amount from kobo to Naira 
    I always divided confirmed amounts by 100

---------------------------------------------------------------------------

## Notes

- Queries are optimized and properly formatted to ensure Accuracy, Efficiency, Completeness and Readability
- Each query includes clear logical segmentation and aligns with assessment requirements.

---------------------------------------------------------------------------

# Repo Structure

- Assessment_Q1.sql
- Assessment_Q2.sql
- Assessment_Q3.sql
- Assessment_Q4.sql
- README.md (This file)
- 
---------------------------------------------------------------------------

# Author
Egwolo Akpere  

Data Analyst & BI Analyst 

egwoloakpere@gmail.com

+234(0)8137976887
