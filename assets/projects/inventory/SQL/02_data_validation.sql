-- Total rows
SELECT COUNT(*)
FROM inventory_demand;

-- Demand range
SELECT
    MIN(order_demand) AS min_demand,
    MAX(order_demand) AS max_demand
FROM inventory_demand;

-- Date range
SELECT
    MIN(date) AS earliest_date,
    MAX(date) AS latest_date
FROM inventory_demand;

-- Negative demand check
SELECT COUNT(*)
FROM inventory_demand
WHERE order_demand < 0;

-- Null check
SELECT
    COUNT(*) FILTER (WHERE product_code IS NULL) AS product_nulls,
    COUNT(*) FILTER (WHERE warehouse IS NULL) AS warehouse_nulls,
    COUNT(*) FILTER (WHERE product_category IS NULL) AS category_nulls,
    COUNT(*) FILTER (WHERE date IS NULL) AS date_nulls,
    COUNT(*) FILTER (WHERE order_demand IS NULL) AS demand_nulls
FROM inventory_demand;

-- Duplicate count
WITH duplicate_groups AS(
SELECT
    product_code,
    warehouse,
    product_category,
    date,
    order_demand, 
    COUNT(*) AS duplicate_count
FROM inventory_demand
GROUP BY
    product_code,
    warehouse,
    product_category,
    date,
    order_demand
HAVING COUNT(*) > 1)
SELECT
    SUM(duplicate_count - 1) AS total_duplicate_rows
FROM duplicate_groups;

-- Repeat Combination
SELECT product_code,warehouse,date,COUNT(*) AS repeat_count  
FROM inventory_demand
GROUP BY    
    product_code,
    warehouse,
    date
HAVING COUNT(*) >1;

SELECT
    product_code,
    warehouse,
    date,
    order_demand
FROM inventory_demand
WHERE product_code = 'Product_1274'
  AND warehouse = 'Whse_J'
  AND date = '2012-08-29';