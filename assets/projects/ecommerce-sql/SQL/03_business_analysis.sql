-- =========================================================
-- E-COMMERCE SQL ANALYSIS
-- FILE: 03_business_analysis.sql
-- PURPOSE: Basic Business Analysis
-- =========================================================


-- =========================================================
-- 1. TOTAL NET SALES
-- Purpose:
-- Calculate total Net_Amount across all clean records.
-- =========================================================

SELECT
    ROUND(SUM(Net_Amount), 2) AS total_net_sales
FROM ecommerce_orders;


-- =========================================================
-- 2. TOTAL UNIQUE ORDERS
-- Purpose:
-- Count total unique orders.
-- =========================================================

SELECT
    COUNT(DISTINCT Order_ID) AS total_orders
FROM ecommerce_orders;


-- =========================================================
-- 3. AVERAGE ORDER VALUE
-- Purpose:
-- Calculate average Net_Amount per order record.
-- =========================================================

SELECT
    ROUND(AVG(Net_Amount), 2) AS average_order_value
FROM ecommerce_orders;


-- =========================================================
-- 4. TOP 10 PRODUCTS BY NET SALES
-- Purpose:
-- Find products generating the highest Net_Amount.
-- =========================================================

SELECT
    Product_ID,
    ROUND(SUM(Net_Amount), 2) AS total_sales
FROM ecommerce_orders
GROUP BY Product_ID
ORDER BY total_sales DESC
LIMIT 10;


-- =========================================================
-- 5. TOP DEPARTMENTS BY NET SALES
-- Purpose:
-- Compare sales performance across departments/categories.
-- =========================================================

SELECT
    Department,
    ROUND(SUM(Net_Amount), 2) AS total_sales
FROM ecommerce_orders
GROUP BY Department
ORDER BY total_sales DESC;


-- =========================================================
-- 6. TOP 10 CUSTOMERS BY NET SALES
-- Purpose:
-- Find customers with the highest total purchase value.
-- =========================================================

SELECT
    User_ID,
    ROUND(SUM(Net_Amount), 2) AS total_spent
FROM ecommerce_orders
GROUP BY User_ID
ORDER BY total_spent DESC
LIMIT 10;


-- =========================================================
-- 7. SALES BY STATE
-- Purpose:
-- Find which states generate the highest Net_Amount.
-- =========================================================

SELECT
    State,
    ROUND(SUM(Net_Amount), 2) AS total_sales
FROM ecommerce_orders
GROUP BY State
ORDER BY total_sales DESC;


-- =========================================================
-- 8. MONTHLY SALES TREND
-- Purpose:
-- Track Net_Amount month by month.
-- =========================================================

SELECT
    DATE_TRUNC('month', Order_Date) AS month,
    ROUND(SUM(Net_Amount), 2) AS total_sales
FROM ecommerce_orders
GROUP BY DATE_TRUNC('month', Order_Date)
ORDER BY month;


-- =========================================================
-- 9. PAYMENT MODE USAGE
-- Purpose:
-- Find the most commonly used payment method.
-- =========================================================

SELECT
    Payment_Mode,
    COUNT(*) AS total_orders
FROM ecommerce_orders
GROUP BY Payment_Mode
ORDER BY total_orders DESC;


-- =========================================================
-- 10. ORDER STATUS DISTRIBUTION
-- Purpose:
-- Understand how many orders are delivered, shipped,
-- returned or cancelled.
-- =========================================================

SELECT
    Order_Status,
    COUNT(*) AS total_orders
FROM ecommerce_orders
GROUP BY Order_Status
ORDER BY total_orders DESC;


-- =========================================================
-- 11. NET SALES BY ORDER STATUS
-- Purpose:
-- Compare Net_Amount across different order statuses.
-- Important:
-- Do not automatically treat cancelled/returned orders
-- as realized revenue.
-- =========================================================

SELECT
    Order_Status,
    ROUND(SUM(Net_Amount), 2) AS total_sales
FROM ecommerce_orders
GROUP BY Order_Status
ORDER BY total_sales DESC;


-- =========================================================
-- 12. DELIVERED ORDER REVENUE
-- Purpose:
-- Calculate Net_Amount only for successfully delivered orders.
-- =========================================================

SELECT
    ROUND(SUM(Net_Amount), 2) AS delivered_revenue
FROM ecommerce_orders
WHERE Order_Status = 'Delivered';


-- =========================================================
-- 13. TOTAL QUANTITY SOLD BY DEPARTMENT
-- Purpose:
-- Compare product volume across departments.
-- =========================================================

SELECT
    Department,
    SUM(Quantity) AS total_quantity
FROM ecommerce_orders
GROUP BY Department
ORDER BY total_quantity DESC;


-- =========================================================
-- 14. AVERAGE RATING BY DEPARTMENT
-- Purpose:
-- Compare customer ratings across departments.
-- NULL ratings are ignored automatically by AVG().
-- =========================================================

SELECT
    Department,
    ROUND(AVG(Rating), 2) AS average_rating
FROM ecommerce_orders
GROUP BY Department
ORDER BY average_rating DESC;


-- =========================================================
-- 15. AVERAGE SHIPPING DAYS BY STATE
-- Purpose:
-- Compare shipping performance across states.
-- =========================================================

SELECT
    State,
    ROUND(AVG(Shipping_Days), 2) AS avg_shipping_days
FROM ecommerce_orders
GROUP BY State
ORDER BY avg_shipping_days DESC;

UPDATE ecommerce_orders
SET Department = INITCAP(TRIM(Department));

SELECT DISTINCT Department
FROM ecommerce_orders
ORDER BY Department;


-- =========================================================
-- 16. DEPARTMENTS WITH HIGH SALES
-- Purpose:
-- Use HAVING to show only departments with sales above 6,000,000.
-- =========================================================

SELECT
    Department,
    ROUND(SUM(Net_Amount), 2) AS total_sales
FROM ecommerce_orders
GROUP BY Department
HAVING SUM(Net_Amount) > 6000000
ORDER BY total_sales DESC;


-- =========================================================
-- 17. CUSTOMER SPENDING CATEGORY USING CASE
-- Purpose:
-- Classify customers based on total spending.
-- =========================================================

SELECT
    User_ID,
    ROUND(SUM(Net_Amount), 2) AS total_spent,
    CASE
        WHEN SUM(Net_Amount) >= 150000 THEN 'High Value'
        WHEN SUM(Net_Amount) >= 100000 THEN 'Medium Value'
        ELSE 'Regular'
    END AS customer_segment
FROM ecommerce_orders
GROUP BY User_ID
ORDER BY total_spent DESC;


-- =========================================================
-- 18. PRODUCTS ABOVE AVERAGE SALES
-- Purpose:
-- Use a subquery to find products whose total sales
-- are above the average product sales.
-- =========================================================

SELECT
    Product_ID,
    ROUND(SUM(Net_Amount), 2) AS total_sales
FROM ecommerce_orders
GROUP BY Product_ID
HAVING SUM(Net_Amount) > (
    SELECT AVG(product_sales)
    FROM (
        SELECT
            Product_ID,
            SUM(Net_Amount) AS product_sales
        FROM ecommerce_orders
        GROUP BY Product_ID
    ) p
)
ORDER BY total_sales DESC;


-- =========================================================
-- 19. CTE - TOP CUSTOMERS
-- Purpose:
-- Use a CTE to calculate customer spending first,
-- then filter high-value customers.
-- =========================================================

WITH customer_sales AS (
    SELECT
        User_ID,
        SUM(Net_Amount) AS total_spent
    FROM ecommerce_orders
    GROUP BY User_ID
)

SELECT
    User_ID,
    ROUND(total_spent, 2) AS total_spent
FROM customer_sales
WHERE total_spent > 150000
ORDER BY total_spent DESC;


-- =========================================================
-- 20. DELIVERED VS NON-DELIVERED SALES USING CASE
-- Purpose:
-- Compare delivered and non-delivered order value.
-- =========================================================

SELECT
    CASE
        WHEN Order_Status = 'Delivered' THEN 'Delivered'
        ELSE 'Not Delivered'
    END AS delivery_group,
    ROUND(SUM(Net_Amount), 2) AS total_sales
FROM ecommerce_orders
GROUP BY delivery_group
ORDER BY total_sales DESC;