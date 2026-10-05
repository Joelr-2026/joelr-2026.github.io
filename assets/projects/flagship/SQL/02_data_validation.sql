-- =========================================================
-- Flagship End-to-End Analytics Project
-- File: 02_data_validation.sql
-- Purpose: Validate imported data quality and relationships
-- Database: flagship_analytics
-- =========================================================


-- =========================================================
-- SAMPLE DATA CHECK
-- Purpose:
-- Verify that data was imported into the correct columns.
-- =========================================================

SELECT *
FROM customers
LIMIT 5;

SELECT *
FROM products
LIMIT 5;

SELECT *
FROM orders
LIMIT 5;
-- =========================================================
-- NULL VALUE CHECK
-- Purpose:
-- Identify missing values in important columns.
-- =========================================================

SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
    COUNT(*) FILTER (WHERE signup_date IS NULL) AS signup_date_nulls,
    COUNT(*) FILTER (WHERE city IS NULL) AS city_nulls,
    COUNT(*) FILTER (WHERE age_band IS NULL) AS age_band_nulls,
    COUNT(*) FILTER (WHERE gender IS NULL) AS gender_nulls,
    COUNT(*) FILTER (WHERE acquisition_channel IS NULL) AS acquisition_channel_nulls,
    COUNT(*) FILTER (WHERE loyalty_tier IS NULL) AS loyalty_tier_nulls
FROM customers;
-- =========================================================
-- PRODUCTS NULL VALUE CHECK
-- Purpose:
-- Identify missing values in product master data.
-- =========================================================

SELECT
    COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id_nulls,
    COUNT(*) FILTER (WHERE category IS NULL) AS category_nulls,
    COUNT(*) FILTER (WHERE product_type IS NULL) AS product_type_nulls,
    COUNT(*) FILTER (WHERE product_name IS NULL) AS product_name_nulls,
    COUNT(*) FILTER (WHERE list_price IS NULL) AS list_price_nulls,
    COUNT(*) FILTER (WHERE unit_cost IS NULL) AS unit_cost_nulls,
    COUNT(*) FILTER (WHERE supplier IS NULL) AS supplier_nulls
FROM products;
-- =========================================================
-- ORDERS NULL VALUE CHECK
-- Purpose:
-- Identify missing values in transaction data.
-- =========================================================

SELECT
    COUNT(*) FILTER (WHERE order_id IS NULL) AS order_id_nulls,
    COUNT(*) FILTER (WHERE order_date IS NULL) AS order_date_nulls,
    COUNT(*) FILTER (WHERE ship_date IS NULL) AS ship_date_nulls,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS customer_id_nulls,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS product_id_nulls,
    COUNT(*) FILTER (WHERE quantity IS NULL) AS quantity_nulls,
    COUNT(*) FILTER (WHERE unit_price IS NULL) AS unit_price_nulls,
    COUNT(*) FILTER (WHERE discount_pct IS NULL) AS discount_pct_nulls,
    COUNT(*) FILTER (WHERE revenue IS NULL) AS revenue_nulls,
    COUNT(*) FILTER (WHERE cost IS NULL) AS cost_nulls,
    COUNT(*) FILTER (WHERE profit IS NULL) AS profit_nulls,
    COUNT(*) FILTER (WHERE order_status IS NULL) AS order_status_nulls,
    COUNT(*) FILTER (WHERE payment_mode IS NULL) AS payment_mode_nulls,
    COUNT(*) FILTER (WHERE sales_channel IS NULL) AS sales_channel_nulls
FROM orders;
-- =========================================================
-- DUPLICATE KEY CHECK
-- Purpose:
-- Check whether supposed ID columns contain duplicates.
-- =========================================================

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;


SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;
-- =========================================================
-- COMPLETE DUPLICATE ROW CHECK
-- Purpose:
-- Identify fully duplicated transaction rows in Orders.
-- =========================================================

SELECT
    order_id,
    order_date,
    ship_date,
    customer_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    revenue,
    cost,
    profit,
    order_status,
    payment_mode,
    sales_channel,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY
    order_id,
    order_date,
    ship_date,
    customer_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    revenue,
    cost,
    profit,
    order_status,
    payment_mode,
    sales_channel
HAVING COUNT(*) > 1;
-- =========================================================
-- FOREIGN KEY / ORPHAN RECORD CHECK
-- Purpose:
-- Verify that every Customer_ID and Product_ID in Orders
-- exists in the related master tables.
-- =========================================================

SELECT COUNT(*) AS orphan_customer_ids
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


SELECT COUNT(*) AS orphan_product_ids
FROM orders o
LEFT JOIN products p
    ON o.product_id = p.product_id
WHERE p.product_id IS NULL;
-- =========================================================
-- INVALID NUMERIC VALUE CHECK
-- Purpose:
-- Check for impossible or suspicious numeric values
-- in Orders and Products.
-- =========================================================

SELECT
    COUNT(*) FILTER (WHERE quantity <= 0) AS invalid_quantity,
    COUNT(*) FILTER (WHERE unit_price < 0) AS invalid_unit_price,
    COUNT(*) FILTER (WHERE discount_pct < 0 OR discount_pct > 100) AS invalid_discount_pct,
    COUNT(*) FILTER (WHERE revenue < 0) AS invalid_revenue,
    COUNT(*) FILTER (WHERE cost < 0) AS invalid_cost
FROM orders;


SELECT
    COUNT(*) FILTER (WHERE list_price < 0) AS invalid_list_price,
    COUNT(*) FILTER (WHERE unit_cost < 0) AS invalid_unit_cost
FROM products;
-- =========================================================
-- DATE CONSISTENCY CHECK
-- Purpose:
-- Identify records where shipping happened before ordering,
-- or where important dates look inconsistent.
-- =========================================================

SELECT COUNT(*) AS ship_before_order
FROM orders
WHERE ship_date IS NOT NULL
  AND ship_date < order_date;
-- =========================================================
-- CATEGORY / TEXT CONSISTENCY CHECK
-- Purpose:
-- Identify inconsistent text values caused by
-- spacing or capitalization differences.
-- =========================================================

SELECT DISTINCT city
FROM customers
ORDER BY city;

SELECT DISTINCT age_band
FROM customers
ORDER BY age_band;

SELECT DISTINCT gender
FROM customers
ORDER BY gender;

SELECT DISTINCT acquisition_channel
FROM customers
ORDER BY acquisition_channel;

SELECT DISTINCT loyalty_tier
FROM customers
ORDER BY loyalty_tier;

SELECT DISTINCT category
FROM products
ORDER BY category;

SELECT DISTINCT product_type
FROM products
ORDER BY product_type;

SELECT DISTINCT order_status
FROM orders
ORDER BY order_status;

SELECT DISTINCT payment_mode
FROM orders
ORDER BY payment_mode;

SELECT DISTINCT sales_channel
FROM orders
ORDER BY sales_channel;
-- =========================================================
-- MIN / MAX RANGE CHECK
-- Purpose:
-- Review numeric ranges and detect unusual values.
-- =========================================================

SELECT
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    MIN(unit_price) AS min_unit_price,
    MAX(unit_price) AS max_unit_price,
    MIN(discount_pct) AS min_discount_pct,
    MAX(discount_pct) AS max_discount_pct,
    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue,
    MIN(cost) AS min_cost,
    MAX(cost) AS max_cost,
    MIN(profit) AS min_profit,
    MAX(profit) AS max_profit
FROM orders;


SELECT
    MIN(list_price) AS min_list_price,
    MAX(list_price) AS max_list_price,
    MIN(unit_cost) AS min_unit_cost,
    MAX(unit_cost) AS max_unit_cost
FROM products;
-- =========================================================
-- CANCELLED ORDERS VS MISSING SHIP DATE
-- Purpose:
-- Verify whether missing Ship_Date values are associated
-- with cancelled orders rather than data errors.
-- =========================================================

SELECT
    order_status,
    COUNT(*) AS total_orders,
    COUNT(*) FILTER (WHERE ship_date IS NULL) AS missing_ship_dates
FROM orders
GROUP BY order_status
ORDER BY order_status;
-- =========================================================
-- CLEAN ORDERS VIEW
-- Purpose:
-- Remove exact duplicate transaction rows for analysis
-- while keeping the original raw Orders table unchanged.
-- =========================================================

CREATE OR REPLACE VIEW orders_clean AS
WITH ranked_orders AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY
                order_id,
                order_date,
                ship_date,
                customer_id,
                product_id,
                quantity,
                unit_price,
                discount_pct,
                revenue,
                cost,
                profit,
                order_status,
                payment_mode,
                sales_channel
            ORDER BY order_id
        ) AS row_num
    FROM orders
)
SELECT
    order_id,
    order_date,
    ship_date,
    customer_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    revenue,
    cost,
    profit,
    order_status,
    payment_mode,
    sales_channel
FROM ranked_orders
WHERE row_num = 1;
SELECT COUNT(*) AS cleaned_orders_count
FROM orders_clean;
-- =========================================================
-- CLEAN VIEW DUPLICATE VERIFICATION
-- Purpose:
-- Confirm that exact duplicate rows no longer exist
-- in the cleaned Orders view.
-- =========================================================

SELECT
    order_id,
    order_date,
    ship_date,
    customer_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    revenue,
    cost,
    profit,
    order_status,
    payment_mode,
    sales_channel,
    COUNT(*) AS duplicate_count
FROM orders_clean
GROUP BY
    order_id,
    order_date,
    ship_date,
    customer_id,
    product_id,
    quantity,
    unit_price,
    discount_pct,
    revenue,
    cost,
    profit,
    order_status,
    payment_mode,
    sales_channel
HAVING COUNT(*) > 1;