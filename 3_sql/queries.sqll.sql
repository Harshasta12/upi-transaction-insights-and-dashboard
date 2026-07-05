-- ================================================
-- UPI Transaction Insights Dashboard
-- SQL Analysis Queries
-- Tool: SQLite (DB Browser for SQLite)
-- Dataset: 9,467 cleaned UPI transactions (2024)
-- ================================================


-- ================================================
-- QUERY 1: Overall Transaction Health Check
-- Business Question: What is the baseline performance 
-- of our payment system?
-- ================================================

SELECT 
    status,
    COUNT(*) as transaction_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM cleaned_data), 2) as percentage
FROM cleaned_data
GROUP BY status
ORDER BY transaction_count DESC;

-- FINDING: 71.62% success rate, 21.35% failure rate
-- 1 in 5 transactions is failing — a serious problem


-- ================================================
-- QUERY 2: Failure Reason Breakdown
-- Business Question: Why exactly are transactions 
-- failing and which reason is most common?
-- ================================================

SELECT 
    failure_reason,
    COUNT(*) as failure_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM cleaned_data WHERE status = 'Failed'), 2) as percentage_of_failures
FROM cleaned_data
WHERE status = 'Failed'
    AND failure_reason IS NOT NULL
GROUP BY failure_reason
ORDER BY failure_count DESC;

-- FINDING: Failures are evenly distributed across all 5 reasons
-- Bank Declined (21.47%) and Network Error (19.59%) are top causes
-- Network Error + Timeout (37.8%) are infrastructure issues the company CAN fix


-- ================================================
-- QUERY 3: Payment Method Performance
-- Business Question: Which payment method is most 
-- reliable and which has highest transaction values?
-- ================================================

SELECT 
    payment_method,
    COUNT(*) as total_transactions,
    SUM(CASE WHEN status = 'Success' THEN 1 ELSE 0 END) as successful,
    SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) as failed,
    ROUND(SUM(CASE WHEN status = 'Success' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as success_rate,
    ROUND(AVG(amount), 2) as avg_transaction_value
FROM cleaned_data
GROUP BY payment_method
ORDER BY success_rate DESC;

-- FINDING: All methods have similar success rates (71-72%)
-- Failure is systemic, not method-specific
-- Net Banking has highest avg value (3,996) despite lowest volume
-- UPI dominates volume at 55% of all transactions


-- ================================================
-- QUERY 4: Transaction Patterns by Hour of Day
-- Business Question: When do failures spike? 
-- Is it a peak hour or infrastructure issue?
-- ================================================

SELECT 
    CAST(strftime('%H', transaction_date) AS INTEGER) as hour_of_day,
    COUNT(*) as total_transactions,
    SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) as failed_transactions,
    ROUND(SUM(CASE WHEN status = 'Failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as failure_rate
FROM cleaned_data
GROUP BY hour_of_day
ORDER BY hour_of_day ASC;

-- FINDING: Failure rates consistently high across all hours (20-24%)
-- This is a systemic problem, not peak-hour specific
-- 9 AM has lowest failure rate (16.24%) — morning hours most stable
-- Late night (midnight to 1 AM) highest failure rate (24.49%)


-- ================================================
-- QUERY 5: City Tier Analysis
-- Business Question: Are Tier 2/3 cities 
-- underperforming? Where is the business coming from?
-- ================================================

SELECT 
    city_tier,
    COUNT(*) as total_transactions,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM cleaned_data), 2) as volume_percentage,
    ROUND(AVG(amount), 2) as avg_transaction_value,
    ROUND(SUM(CASE WHEN status = 'Success' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as success_rate,
    ROUND(SUM(amount), 2) as total_volume
FROM cleaned_data
GROUP BY city_tier
ORDER BY total_transactions DESC;

-- FINDING: Tier 1 dominates volume (45.64%) but Tier 3 has highest avg value (3,633)
-- Success rates similar across all tiers (71-72%)
-- Opportunity: Tier 3 users spend more per transaction
-- Recommendation: Increase Tier 3 user acquisition


-- ================================================
-- QUERY 6: Cohort Retention Analysis
-- Business Question: Are we retaining users after 
-- their first payment?
-- ================================================

SELECT 
    first_transaction_month as cohort_month,
    COUNT(DISTINCT user_id) as cohort_size,
    SUM(CASE WHEN strftime('%Y-%m', transaction_date) = first_transaction_month 
        THEN 1 ELSE 0 END) as month_0_transactions,
    SUM(CASE WHEN strftime('%Y-%m', transaction_date) > first_transaction_month 
        THEN 1 ELSE 0 END) as returned_in_later_months,
    ROUND(SUM(CASE WHEN strftime('%Y-%m', transaction_date) > first_transaction_month 
        THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) as retention_rate
FROM cleaned_data
GROUP BY first_transaction_month
ORDER BY cohort_month ASC;

-- FINDING: January cohort shows 91.56% retention
-- Drops steadily to 50.33% for June cohorts
-- Newer cohorts have had less time to return (expected)
-- Sharp drop suggests newer users need better onboarding


-- ================================================
-- QUERY 7: RFM User Segmentation
-- Business Question: Who are our most valuable users?
-- ================================================

-- Full user list with segments
SELECT 
    user_id,
    COUNT(*) as frequency,
    ROUND(AVG(amount), 2) as monetary_avg,
    ROUND(SUM(amount), 2) as monetary_total,
    MAX(transaction_date) as last_transaction,
    CASE 
        WHEN COUNT(*) >= 8 AND AVG(amount) >= 3000 THEN 'High Value'
        WHEN COUNT(*) >= 5 AND AVG(amount) >= 2000 THEN 'Mid Value'
        ELSE 'Low Value'
    END as user_segment
FROM cleaned_data
WHERE status = 'Success'
GROUP BY user_id
ORDER BY monetary_total DESC;

-- Segment summary
SELECT 
    user_segment,
    COUNT(*) as user_count
FROM (
    SELECT 
        user_id,
        CASE 
            WHEN COUNT(*) >= 8 AND AVG(amount) >= 3000 THEN 'High Value'
            WHEN COUNT(*) >= 5 AND AVG(amount) >= 2000 THEN 'Mid Value'
            ELSE 'Low Value'
        END as user_segment
    FROM cleaned_data
    WHERE status = 'Success'
    GROUP BY user_id
)
GROUP BY user_segment;

-- FINDING: Only 23 users (1.2%) are High Value
-- 212 users (10.9%) are Mid Value
-- 1,693 users (87.9%) are Low Value
-- Recommendation: Loyalty program for High Value users
-- Target Mid Value users to push them into High Value tier