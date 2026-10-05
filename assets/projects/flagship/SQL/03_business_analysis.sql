-- =========================================================
-- Flagship End-to-End Analytics Project
-- File: 03_business_analysis.sql
-- Purpose: Analyze core business performance
-- Database: flagship_analytics
-- =========================================================


-- =========================================================
-- OVERALL BUSINESS PERFORMANCE
-- Purpose:
-- Measure the overall scale and profitability of the business.
-- =========================================================

SELECT
    COUNT(*) AS total_order_rows,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS total_customers,
    SUM(quantity) AS total_quantity,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(cost), 2) AS total_cost,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(AVG(revenue), 2) AS average_order_value
FROM orders_clean;
-- =========================================================
-- MONTHLY REVENUE TREND
-- Purpose:
-- Track revenue performance month by month and identify
-- growth, decline and seasonality patterns.
-- =========================================================

SELECT
    DATE_TRUNC('month', order_date)::date AS order_month,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders_clean
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY order_month;
-- =========================================================
-- CATEGORY PERFORMANCE
-- Purpose:
-- Compare product categories by revenue, profit and quantity.
-- =========================================================

SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.quantity) AS total_quantity,
    ROUND(SUM(o.revenue), 2) AS total_revenue,
    ROUND(SUM(o.profit), 2) AS total_profit
FROM orders_clean o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;
-- =========================================================
-- TOP PRODUCTS BY REVENUE
-- Purpose:
-- Identify the highest-performing products based on revenue.
-- =========================================================

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(o.quantity) AS total_quantity,
    ROUND(SUM(o.revenue), 2) AS total_revenue,
    ROUND(SUM(o.profit), 2) AS total_profit
FROM orders_clean o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY total_revenue DESC
LIMIT 10;
-- =========================================================
-- TOP CUSTOMERS BY REVENUE
-- Purpose:
-- Identify the highest-value customers based on revenue.
-- =========================================================

SELECT
    c.customer_id,
    c.city,
    c.loyalty_tier,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.revenue), 2) AS total_revenue,
    ROUND(SUM(o.profit), 2) AS total_profit
FROM orders_clean o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY
    c.customer_id,
    c.city,
    c.loyalty_tier
ORDER BY total_revenue DESC
LIMIT 10;
-- =========================================================
-- CITY PERFORMANCE
-- Purpose:
-- Compare customer cities based on revenue, profit
-- and number of orders.
-- =========================================================

SELECT
    c.city,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    ROUND(SUM(o.revenue), 2) AS total_revenue,
    ROUND(SUM(o.profit), 2) AS total_profit
FROM orders_clean o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.city
ORDER BY total_revenue DESC;
-- =========================================================
-- SALES CHANNEL PERFORMANCE
-- Purpose:
-- Compare sales channels based on orders, revenue and profit.
-- =========================================================

SELECT
    sales_channel,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders_clean
GROUP BY sales_channel
ORDER BY total_revenue DESC;
-- =========================================================
-- ACQUISITION CHANNEL PERFORMANCE
-- Purpose:
-- Compare customer acquisition channels based on
-- customers, orders, revenue and profit.
-- =========================================================

SELECT
    c.acquisition_channel,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.revenue), 2) AS total_revenue,
    ROUND(SUM(o.profit), 2) AS total_profit
FROM orders_clean o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.acquisition_channel
ORDER BY total_revenue DESC;
-- =========================================================
-- LOYALTY TIER PERFORMANCE
-- Purpose:
-- Compare customer loyalty tiers based on
-- orders, revenue and profit.
-- =========================================================

SELECT
    c.loyalty_tier,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(o.revenue), 2) AS total_revenue,
    ROUND(SUM(o.profit), 2) AS total_profit
FROM orders_clean o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.loyalty_tier
ORDER BY total_revenue DESC;
-- =========================================================
-- REPEAT VS ONE-TIME CUSTOMERS
-- Purpose:
-- Understand how many customers purchase once
-- versus multiple times.
-- =========================================================

WITH customer_orders AS (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM orders_clean
    GROUP BY customer_id
)

SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM customer_orders
GROUP BY customer_type
ORDER BY total_customers DESC;
-- =========================================================
-- AVERAGE ORDER VALUE & CUSTOMER ORDER FREQUENCY
-- Purpose:
-- Measure average revenue per order and understand
-- how frequently customers place orders.
-- =========================================================

SELECT
    ROUND(
        SUM(revenue) / NULLIF(COUNT(DISTINCT order_id), 0),
        2
    ) AS average_order_value
FROM orders_clean;


SELECT
    customer_id,
    COUNT(DISTINCT order_id) AS total_orders
FROM orders_clean
GROUP BY customer_id
ORDER BY total_orders DESC;
-- =========================================================
-- PAYMENT MODE PERFORMANCE
-- Purpose:
-- Compare payment methods based on orders,
-- revenue and profit.
-- =========================================================

SELECT
    payment_mode,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders_clean
GROUP BY payment_mode
ORDER BY total_revenue DESC;
-- =========================================================
-- ORDER STATUS PERFORMANCE
-- Purpose:
-- Understand the distribution of order statuses and
-- compare their revenue impact.
-- =========================================================

SELECT
    order_status,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit
FROM orders_clean
GROUP BY order_status
ORDER BY total_orders DESC;
-- =========================================================
-- PROFIT MARGIN ANALYSIS
-- Purpose:
-- Measure overall profitability relative to revenue.
-- =========================================================

SELECT
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(
        (SUM(profit) / NULLIF(SUM(revenue), 0)) * 100,
        2
    ) AS profit_margin_pct
FROM orders_clean;