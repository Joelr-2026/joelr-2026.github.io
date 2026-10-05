-- =========================================================
-- E-COMMERCE SQL ANALYSIS
-- FILE: 04_advanced_analysis.sql
-- PURPOSE: Fresher-level Advanced SQL
-- =========================================================


-- =========================================================
-- 1. CUSTOMER RANKING BY TOTAL SPENDING
-- Purpose:
-- Rank customers from highest to lowest spending.
-- =========================================================

SELECT
    User_ID,
    ROUND(SUM(Net_Amount), 2) AS total_spent,
    RANK() OVER (
        ORDER BY SUM(Net_Amount) DESC
    ) AS customer_rank
FROM ecommerce_orders
GROUP BY User_ID
ORDER BY customer_rank;


-- =========================================================
-- 2. DENSE RANK PRODUCTS BY SALES
-- Purpose:
-- Rank products without skipping rank numbers.
-- =========================================================

SELECT
    Product_ID,
    ROUND(SUM(Net_Amount), 2) AS total_sales,
    DENSE_RANK() OVER (
        ORDER BY SUM(Net_Amount) DESC
    ) AS product_rank
FROM ecommerce_orders
GROUP BY Product_ID
ORDER BY product_rank;


-- =========================================================
-- 3. TOP PRODUCT PER DEPARTMENT
-- Purpose:
-- Find the highest-selling product inside each department.
-- =========================================================

WITH product_sales AS (
    SELECT
        Department,
        Product_ID,
        SUM(Net_Amount) AS total_sales
    FROM ecommerce_orders
    GROUP BY Department, Product_ID
),

ranked_products AS (
    SELECT
        Department,
        Product_ID,
        total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY Department
            ORDER BY total_sales DESC
        ) AS rn
    FROM product_sales
)

SELECT
    Department,
    Product_ID,
    ROUND(total_sales, 2) AS total_sales
FROM ranked_products
WHERE rn = 1
ORDER BY Department;


-- =========================================================
-- 4. MONTHLY RUNNING SALES
-- Purpose:
-- Calculate cumulative sales month by month.
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', Order_Date) AS month,
        SUM(Net_Amount) AS total_sales
    FROM ecommerce_orders
    GROUP BY DATE_TRUNC('month', Order_Date)
)

SELECT
    month,
    ROUND(total_sales, 2) AS monthly_sales,
    ROUND(
        SUM(total_sales) OVER (
            ORDER BY month
        ), 2
    ) AS running_sales
FROM monthly_sales
ORDER BY month;


-- =========================================================
-- 5. PREVIOUS MONTH SALES USING LAG
-- Purpose:
-- Compare current month sales with previous month.
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', Order_Date) AS month,
        SUM(Net_Amount) AS total_sales
    FROM ecommerce_orders
    GROUP BY DATE_TRUNC('month', Order_Date)
)

SELECT
    month,
    ROUND(total_sales, 2) AS current_month_sales,
    ROUND(
        LAG(total_sales) OVER (
            ORDER BY month
        ), 2
    ) AS previous_month_sales
FROM monthly_sales
ORDER BY month;


-- =========================================================
-- 6. MONTH-OVER-MONTH SALES CHANGE
-- Purpose:
-- Calculate percentage change compared with previous month.
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', Order_Date) AS month,
        SUM(Net_Amount) AS total_sales
    FROM ecommerce_orders
    GROUP BY DATE_TRUNC('month', Order_Date)
),

sales_with_previous AS (
    SELECT
        month,
        total_sales,
        LAG(total_sales) OVER (
            ORDER BY month
        ) AS previous_month_sales
    FROM monthly_sales
)

SELECT
    month,
    ROUND(total_sales, 2) AS current_month_sales,
    ROUND(previous_month_sales, 2) AS previous_month_sales,
    ROUND(
        ((total_sales - previous_month_sales)
        / NULLIF(previous_month_sales, 0)) * 100,
        2
    ) AS mom_change_pct
FROM sales_with_previous
ORDER BY month;


-- =========================================================
-- 7. AVERAGE MONTHLY SALES USING WINDOW FUNCTION
-- Purpose:
-- Compare each month's sales with overall monthly average.
-- =========================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', Order_Date) AS month,
        SUM(Net_Amount) AS total_sales
    FROM ecommerce_orders
    GROUP BY DATE_TRUNC('month', Order_Date)
)

SELECT
    month,
    ROUND(total_sales, 2) AS monthly_sales,
    ROUND(
        AVG(total_sales) OVER (),
        2
    ) AS average_monthly_sales
FROM monthly_sales
ORDER BY month;


