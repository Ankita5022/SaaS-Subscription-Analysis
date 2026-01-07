-- SaaS Subscription & Churn Analysis
-- Author: ANKITA PAL
-- Tool: MySQL
-- Description: Analysis of revenue, churn, and customer behavior for a SaaS business





-- DAY 1:DATA OVERVIEW
-- Total users
SELECT COUNT(*) AS total_users
FROM users;

-- Active subscriptions
SELECT COUNT(*) AS active_subscriptions
FROM subscriptions
WHERE end_date IS NULL;



-- DAY 2: REVENUE METRICS
-- Total revenue
SELECT SUM(amount) AS total_revenue
FROM payments
WHERE status = 'Success';

-- Monthly Recurring Revenue (MRR)
SELECT SUM(monthly_fee) AS MRR
FROM subscriptions
WHERE end_date IS NULL;

-- Average Revenue Per User (ARPU)
SELECT 
  ROUND(SUM(amount) / COUNT(DISTINCT user_id), 2) AS ARPU
FROM payments
WHERE status = 'Success';




-- DAY 3: CHURN ANALYSIS
-- Churn rate percentage
SELECT 
  ROUND(
    SUM(CASE WHEN end_date IS NOT NULL THEN 1 ELSE 0 END) 
    / COUNT(*) * 100, 2
  ) AS churn_rate_percentage
FROM subscriptions;

-- Early cancellations (within 30 days)
SELECT 
  subscription_id,
  user_id,
  plan_type,
  DATEDIFF(end_date, start_date) AS days_active
FROM subscriptions
WHERE end_date IS NOT NULL
  AND DATEDIFF(end_date, start_date) <= 30;
  
  
  
  
-- DAY 4 ADVANCED SQL
  -- Revenue by plan type
SELECT 
  s.plan_type,
  SUM(p.amount) AS total_revenue
FROM subscriptions s
JOIN payments p
  ON s.user_id = p.user_id
WHERE p.status = 'Success'
GROUP BY s.plan_type;

-- Rank users by total revenue
SELECT 
  user_id,
  SUM(amount) AS total_spent,
  RANK() OVER (ORDER BY SUM(amount) DESC) AS revenue_rank
FROM payments
WHERE status = 'Success'
GROUP BY user_id;