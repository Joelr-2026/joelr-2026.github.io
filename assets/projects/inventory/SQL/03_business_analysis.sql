
-- Q1. Which product has the highest total demand?

SELECT product_code,SUM(order_demand) AS total_order_demand
FROM inventory_demand
GROUP BY product_code
ORDER BY total_order_demand DESC
LIMIT 1;

-- Q2. Which product has the lowest total demand?

SELECT product_code,SUM(order_demand) AS total_order_demand
FROM inventory_demand
GROUP BY product_code
ORDER BY total_order_demand ASC
LIMIT 1;

-- Q3. Which warehouse has the highest total demand?

SELECT warehouse,SUM(order_demand) AS total_order_demand
FROM inventory_demand
GROUP BY warehouse
ORDER BY total_order_demand DESC
LIMIT 1;

-- Q4. Which warehouse has the lowest total demand?

SELECT warehouse,SUM(order_demand) AS total_order_demand
FROM inventory_demand
GROUP BY warehouse
ORDER BY total_order_demand ASC
LIMIT 1;

-- Q5. Which product category has the highest total demand?

SELECT product_category,SUM(order_demand) AS total_order_demand
FROM inventory_demand
GROUP BY product_category
ORDER BY total_order_demand DESC
LIMIT 1;

-- Q6. Which month has the highest total demand?

SELECT EXTRACT(MONTH FROM date) AS highest_Month ,SUM(order_demand) AS total_order_demand
FROM inventory_demand
GROUP BY highest_Month
ORDER BY total_order_demand DESC
LIMIT 1;

-- Q7. Which month has the lowest total demand?

SELECT EXTRACT(MONTH FROM date) AS lowest_Month ,SUM(order_demand) AS total_order_demand
FROM inventory_demand
GROUP BY lowest_Month
ORDER BY total_order_demand ASC
LIMIT 1;

-- Q8. Show the top 5 products with the highest total demand.

SELECT product_code,SUM(order_demand) AS total_order_demand
FROM inventory_demand
GROUP BY product_code
ORDER BY total_order_demand DESC
LIMIT 5;

-- Q9. Show the top 5 warehouses with the highest total demand.

SELECT warehouse,SUM(order_demand) AS total_order_demand
FROM inventory_demand
GROUP BY warehouse
ORDER BY total_order_demand DESC
LIMIT 5;

-- Q10. Which product has the highest variation in monthly demand?

WITH monthly_demand AS (
    SELECT
        product_code,
        DATE_TRUNC('month', date) AS month,
        SUM(order_demand) AS monthly_demand
    FROM inventory_demand
    GROUP BY product_code, DATE_TRUNC('month', date)
) SELECT
    product_code,
    MAX(monthly_demand) - MIN(monthly_demand) AS demand_variation
FROM monthly_demand
GROUP BY product_code
ORDER BY demand_variation DESC
LIMIT 1;

-- Q11. Which products have consistently high demand, not just one-time spikes?

WITH monthly_demand AS (
    SELECT
        product_code,
        DATE_TRUNC('month', date) AS month,
        SUM(order_demand) AS monthly_demand
    FROM inventory_demand
    GROUP BY product_code, DATE_TRUNC('month', date)
) SELECT
    product_code,
    AVG(monthly_demand)  AS avg_monthly_demand,
    COUNT(*) AS active_months
FROM monthly_demand
GROUP BY product_code
ORDER BY avg_monthly_demand DESC
LIMIT 5;

-- Q12. Which products have low average monthly demand but occasional very high spikes?

WITH monthly_demand AS (
    SELECT
        product_code,
        DATE_TRUNC('month', date) AS month,
        SUM(order_demand) AS monthly_demand
    FROM inventory_demand
    GROUP BY product_code, DATE_TRUNC('month', date)
) SELECT
    product_code,
    AVG(monthly_demand)  AS avg_monthly_demand,
    MAX(monthly_demand) AS peak_monthly_demand,MAX(monthly_demand) - AVG(monthly_demand) AS spike_gap
FROM monthly_demand
GROUP BY product_code
ORDER BY spike_gap DESC
LIMIT 5;

-- Q13. Which product-warehouse combinations have the highest total demand?

SELECT product_code,
    warehouse,
    SUM(order_demand) AS total_order_demand
FROM inventory_demand
GROUP BY product_code , warehouse
ORDER BY total_order_demand DESC
LIMIT 5;

-- Q14. Which product categories are growing or declining over time?

WITH monthly_demand AS (
    SELECT
        product_category,
        DATE_TRUNC('month', date) AS month,
        SUM(order_demand) AS monthly_demand
    FROM inventory_demand
    GROUP BY
        product_category,
        DATE_TRUNC('month', date)
),

demand_with_previous AS (
    SELECT
        product_category,
        month,
        monthly_demand,
        LAG(monthly_demand) OVER (
            PARTITION BY product_category
            ORDER BY month
        ) AS previous_month_demand
    FROM monthly_demand
)

SELECT
    product_category,
    month,
    monthly_demand,
    previous_month_demand,
    monthly_demand - previous_month_demand AS demand_change
FROM demand_with_previous
ORDER BY product_category, month;

-- Q15. Show month-wise total demand and compare it with the previous month using LAG() to identify increase or decrease.

WITH monthly_demand AS (
    SELECT
        product_category,
        DATE_TRUNC('month', date) AS month,
        SUM(order_demand) AS monthly_demand
    FROM inventory_demand
    GROUP BY
        product_category,
        DATE_TRUNC('month', date)
),

demand_compare AS (
    SELECT
        product_category,
        month,
        monthly_demand,
        LAG(monthly_demand) OVER (
            PARTITION BY product_category
            ORDER BY month
        ) AS previous_month_demand
    FROM monthly_demand
)

SELECT
    product_category,
    month,
    monthly_demand,
    previous_month_demand,
    CASE
        WHEN previous_month_demand IS NULL THEN 'No Previous Month'
        WHEN monthly_demand > previous_month_demand THEN 'Increase'
        WHEN monthly_demand < previous_month_demand THEN 'Decrease'
        ELSE 'No Change'
    END AS demand_status
FROM demand_compare
ORDER BY product_category, month;