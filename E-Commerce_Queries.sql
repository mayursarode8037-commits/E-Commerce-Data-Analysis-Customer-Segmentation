CREATE DATABASE rfm_analytics;
use rfm_analytics;
select * from rfm_analytics;

-- Q1) Overall Key Metrics

SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT invoice) AS total_orders,
    ROUND(SUM(quantity * price), 2) AS total_revenue,
    MIN(invoice_date) AS earliest_date,
    MAX(invoice_date) AS latest_date
FROM rfm_analytics;


-- Q2) Unit Economics & Anomaly Check

SELECT 
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    ROUND(AVG(quantity), 2) AS avg_quantity,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    ROUND(AVG(price), 2) AS avg_price
FROM rfm_analytics;


-- Q3) SQL RFM Calculation
USE rfm_analytics;

SELECT 
    customer_id,
    DATEDIFF((SELECT MAX(invoice_date) FROM rfm_analytics), MAX(invoice_date)) AS recency,
    COUNT(DISTINCT invoice) AS frequency,
    ROUND(SUM(quantity * price), 2) AS monetary
FROM rfm_analytics
GROUP BY customer_id
LIMIT 10;


-- Q4) Customer Value Tiers

select 
      customer_id,
      Round(sum(quantity * price), 2) As total_spend,
      CASE
      When sum(quantity * price) >= 5000 Then "High Value"
      When sum(quantity * price) >= 1000 Then "Low Value"
      Else "Low Value"
End as customer_tier
from rfm_analytics
group by customer_id
order by total_spend;


-- Q5) Top 10 Champion Customers & Revenue Share

select 
      customer_id,
      Count(distinct invoice) As total_orders,
      Round(sum(quantity * price) ,2) As total_spend,
      Round(
      (sum(quantity * price) * 100.0 / (select sum(quantity * price) from rfm_analytics)),
      2) As pct_of_total_revenue
from rfm_analytics
group by customer_id
order by total_spend desc
limit 10;
      
      
-- Q6) Country-wise Customer Distribution & Sales

select 
     country,
     count(distinct customer_id) As total_customers,
     count(distinct invoice) As total_orders,
     Round(sum(quantity * price),2) As total_revenue,
     round(
		  (sum(quantity * price) * 100.0 / (select sum(quantity * price) from rfm_analytics)),2
	 )As pct_global_revenue
from rfm_analytics
group by country
order by total_revenue desc
limit 10;


-- Q7) Top 10 Selling Products

select 
     stock_code,
     description,
     sum(quantity) As total_unit_sold,
     Round(sum(quantity * price) , 2) As total_revenue_generated
from rfm_analytics
group by stock_code,description
order by total_revenue_generated
limit 10;
     

-- Q8) Monthly Revenue & Growth Trend

USE rfm_analytics;

SELECT 
    DATE_FORMAT(invoice_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT invoice) AS total_orders,
    ROUND(SUM(quantity * price), 2) AS monthly_revenue,
    ROUND(
        SUM(SUM(quantity * price)) OVER (ORDER BY DATE_FORMAT(invoice_date, '%Y-%m')), 
        2
    ) AS running_total_revenue
FROM rfm_analytics
GROUP BY sales_month
ORDER BY sales_month ASC;


-- Q9) Peak Order Hours (Time-of-Day Analysis)

select 
     Hour(invoice_date) As purchase_hour,
     count(distinct invoice) As total_orders,
     Round(sum(quantity * price),2) As total_revenue
from rfm_analytics
group by purchase_hour
order by total_orders desc;


-- Q10) Day-of-Week Purchasing Patterns
select 
     dayname(invoice_date) As day_of_week,
     count(distinct invoice) As total_orders,
     Round(sum(quantity * price) , 2) As total_revenue,
     Round(Avg(quantity * price) , 2) As Avg_total_line_value
from rfm_analytics
Group by day_of_week, dayofweek(invoice_date)
order by dayofweek(invoice_date) ASC;


-- Q11) Single-Purchase vs. Repeat Customers

SELECT 
    CASE 
        WHEN invoice_count = 1 THEN 'Single-Time Buyer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers,
    ROUND(SUM(customer_spend), 2) AS total_revenue
FROM (
    SELECT 
        customer_id, 
        COUNT(DISTINCT invoice) AS invoice_count, 
        SUM(quantity * price) AS customer_spend
    FROM rfm_analytics
    GROUP BY customer_id
) AS customer_totals
GROUP BY customer_type;


-- Q12) Customer Churn & Activity Thresholds

USE rfm_analytics;

SELECT 
    customer_status,
    COUNT(customer_id) AS total_customers,
    ROUND(SUM(total_spend), 2) AS group_revenue
FROM (
    SELECT 
        customer_id,
        SUM(quantity * price) AS total_spend,
        CASE 
            WHEN DATEDIFF((SELECT MAX(invoice_date) FROM rfm_analytics), MAX(invoice_date)) > 180 THEN 'Churned (>6 Months)'
            WHEN DATEDIFF((SELECT MAX(invoice_date) FROM rfm_analytics), MAX(invoice_date)) > 90 THEN 'At-Risk (3-6 Months)'
            ELSE 'Active (0-3 Months)'
        END AS customer_status
    FROM nextrfm_analytics
    GROUP BY customer_id
) AS customer_activity
GROUP BY customer_status;


-- Q13) Average Order Value (AOV) Distribution

SELECT 
    CASE 
        WHEN basket_value < 50 THEN '1. Micro Orders (<$50)'
        WHEN basket_value BETWEEN 50 AND 200 THEN '2. Small Orders ($50-$200)'
        WHEN basket_value BETWEEN 200.01 AND 500 THEN '3. Medium Orders ($200-$500)'
        ELSE '4. Large Wholesale (> $500)'
    END AS order_value_tier,
    COUNT(invoice) AS order_count,
    ROUND(SUM(basket_value), 2) AS total_revenue
FROM (
    SELECT 
        invoice,
        SUM(quantity * price) AS basket_value
    FROM rfm_analytics
    GROUP BY invoice
) AS order_baskets
GROUP BY 1
ORDER BY 1;


-- Q14) Monthly Customer Acquisition Cohorts

SELECT 
    DATE_FORMAT(first_purchase_date, '%Y-%m') AS cohort_month,
    COUNT(customer_id) AS new_customers_acquired,
    ROUND(SUM(lifetime_spend), 2) AS total_cohort_spend,
    ROUND(AVG(lifetime_spend), 2) AS avg_cohort_ltv
FROM (
    SELECT 
        customer_id,
        MIN(invoice_date) AS first_purchase_date,
        SUM(quantity * price) AS lifetime_spend
    FROM rfm_analytics
    GROUP BY customer_id
) AS customer_cohorts
GROUP BY 1
ORDER BY 1 ASC;