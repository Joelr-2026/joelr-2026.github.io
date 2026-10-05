-- =========================================================
-- E-COMMERCE SQL ANALYSIS
-- FILE: 02_data_validation.sql
-- PURPOSE: Validate imported raw e-commerce data
-- =========================================================


-- =========================================================
-- 1. TOTAL ROW COUNT
-- Business Purpose:
-- Verify that all CSV rows were imported into PostgreSQL.
-- =========================================================

SELECT COUNT(*) AS total_rows
FROM ecommerce_orders_raw;


-- =========================================================
-- 2. CHECK MISSING ORDER IDs
-- Business Purpose:
-- Order_ID is important for identifying each order.
-- This checks for NULL or blank Order_ID values.
-- =========================================================

SELECT COUNT(*) AS missing_order_id
FROM ecommerce_orders_raw
WHERE Order_ID IS NULL
   OR TRIM(Order_ID) = '';


-- =========================================================
-- 3. CHECK DUPLICATE ORDER IDs
-- Business Purpose:
-- Find Order_ID values that appear more than once.
-- Important: Repeated Order_ID does not always mean bad data.
-- =========================================================

SELECT
    Order_ID,
    COUNT(*) AS duplicate_count
FROM ecommerce_orders_raw
GROUP BY Order_ID
HAVING COUNT(*) > 1;


-- =========================================================
-- 4. INSPECT REPEATED ORDER IDs
-- Business Purpose:
-- Check whether repeated Order_ID rows are actually identical
-- or represent different products/items.
-- =========================================================

SELECT *
FROM ecommerce_orders_raw
WHERE Order_ID IN (
    SELECT Order_ID
    FROM ecommerce_orders_raw
    GROUP BY Order_ID
    HAVING COUNT(*) > 1
)
ORDER BY Order_ID;


-- =========================================================
-- 5. CHECK FULL-ROW DUPLICATES
-- Business Purpose:
-- Find rows where every column has exactly the same value.
-- =========================================================

SELECT COUNT(*) AS duplicate_rows
FROM (
    SELECT *,
           COUNT(*) OVER (
               PARTITION BY
                   Order_ID,
                   User_ID,
                   Order_Date,
                   State,
                   Department,
                   Product_ID,
                   Quantity,
                   Unit_Price,
                   Discount_Pct,
                   Gross_Amount,
                   Net_Amount,
                   Order_Status,
                   Shipping_Days,
                   Rating,
                   Payment_Mode
           ) AS cnt
    FROM ecommerce_orders_raw
) t
WHERE cnt > 1;


-- =========================================================
-- 6. COUNT EXTRA DUPLICATE ROWS
-- Business Purpose:
-- Calculate how many duplicate rows are extra copies.
--
-- Example:
-- If the same row appears 2 times,
-- only 1 row is considered extra.
-- =========================================================

SELECT
    SUM(cnt - 1) AS extra_duplicate_rows
FROM (
    SELECT COUNT(*) AS cnt
    FROM ecommerce_orders_raw
    GROUP BY
        Order_ID,
        User_ID,
        Order_Date,
        State,
        Department,
        Product_ID,
        Quantity,
        Unit_Price,
        Discount_Pct,
        Gross_Amount,
        Net_Amount,
        Order_Status,
        Shipping_Days,
        Rating,
        Payment_Mode
    HAVING COUNT(*) > 1
) d;


-- =========================================================
-- 7. CHECK ORDER DATE RANGE
-- Business Purpose:
-- Understand the time period covered by the dataset.
-- =========================================================

SELECT
    MIN(TO_DATE(Order_Date, 'MM/DD/YYYY')) AS min_order_date,
    MAX(TO_DATE(Order_Date, 'MM/DD/YYYY')) AS max_order_date
FROM ecommerce_orders_raw;

-- =========================================================
-- 8. CHECK MISSING VALUES IN IMPORTANT COLUMNS
-- Purpose:
-- Find NULL or blank values in important columns.
-- =========================================================

SELECT
    COUNT(*) FILTER (
        WHERE User_ID IS NULL OR TRIM(User_ID) = ''
    ) AS missing_user_id,

    COUNT(*) FILTER (
        WHERE Order_Date IS NULL OR TRIM(Order_Date) = ''
    ) AS missing_order_date,

    COUNT(*) FILTER (
        WHERE State IS NULL OR TRIM(State) = ''
    ) AS missing_state,

    COUNT(*) FILTER (
        WHERE Department IS NULL OR TRIM(Department) = ''
    ) AS missing_department,

    COUNT(*) FILTER (
        WHERE Product_ID IS NULL OR TRIM(Product_ID) = ''
    ) AS missing_product_id,

    COUNT(*) FILTER (
        WHERE Quantity IS NULL OR TRIM(Quantity) = ''
    ) AS missing_quantity,

    COUNT(*) FILTER (
        WHERE Unit_Price IS NULL OR TRIM(Unit_Price) = ''
    ) AS missing_unit_price,

    COUNT(*) FILTER (
        WHERE Discount_Pct IS NULL OR TRIM(Discount_Pct) = ''
    ) AS missing_discount,

    COUNT(*) FILTER (
        WHERE Gross_Amount IS NULL OR TRIM(Gross_Amount) = ''
    ) AS missing_gross_amount,

    COUNT(*) FILTER (
        WHERE Net_Amount IS NULL OR TRIM(Net_Amount) = ''
    ) AS missing_net_amount,

    COUNT(*) FILTER (
        WHERE Order_Status IS NULL OR TRIM(Order_Status) = ''
    ) AS missing_order_status,

    COUNT(*) FILTER (
        WHERE Shipping_Days IS NULL OR TRIM(Shipping_Days) = ''
    ) AS missing_shipping_days,

    COUNT(*) FILTER (
        WHERE Rating IS NULL OR TRIM(Rating) = ''
    ) AS missing_rating,

    COUNT(*) FILTER (
        WHERE Payment_Mode IS NULL OR TRIM(Payment_Mode) = ''
    ) AS missing_payment_mode

FROM ecommerce_orders_raw;


-- =========================================================
-- 9. CHECK DEPARTMENT VALUES
-- Purpose:
-- Find spelling/case inconsistencies in product categories.
-- Example: Fashion vs fashion
-- =========================================================

SELECT
    Department,
    COUNT(*) AS total_rows
FROM ecommerce_orders_raw
GROUP BY Department
ORDER BY Department;


-- =========================================================
-- 10. CHECK ORDER STATUS VALUES
-- Purpose:
-- Check available order status categories.
-- =========================================================

SELECT
    Order_Status,
    COUNT(*) AS total_rows
FROM ecommerce_orders_raw
GROUP BY Order_Status
ORDER BY Order_Status;


-- =========================================================
-- 11. CHECK PAYMENT MODE VALUES
-- Purpose:
-- Check available payment methods and inconsistent text.
-- =========================================================

SELECT
    Payment_Mode,
    COUNT(*) AS total_rows
FROM ecommerce_orders_raw
GROUP BY Payment_Mode
ORDER BY Payment_Mode;


-- =========================================================
-- 12. CHECK STATE VALUES
-- Purpose:
-- Check location names for spelling or case problems.
-- =========================================================

SELECT
    State,
    COUNT(*) AS total_rows
FROM ecommerce_orders_raw
GROUP BY State
ORDER BY State;

-- =========================================================
-- 13. CHECK ZERO QUANTITY
-- Purpose:
-- Find orders where quantity is zero.
-- =========================================================

SELECT COUNT(*) AS zero_quantity
FROM ecommerce_orders_raw
WHERE Quantity::INTEGER = 0;


-- =========================================================
-- 14. CHECK NEGATIVE QUANTITY
-- Purpose:
-- Quantity normally negative nahi honi chahiye.
-- =========================================================

SELECT COUNT(*) AS negative_quantity
FROM ecommerce_orders_raw
WHERE Quantity::INTEGER < 0;


-- =========================================================
-- 15. CHECK ZERO OR NEGATIVE UNIT PRICE
-- Purpose:
-- Product price normally zero ya negative nahi hona chahiye.
-- Currency symbol and commas are removed before checking.
-- =========================================================

SELECT COUNT(*) AS invalid_unit_price
FROM ecommerce_orders_raw
WHERE
    REPLACE(REPLACE(Unit_Price, '₹', ''), ',', '')::NUMERIC <= 0;


-- =========================================================
-- 16. CHECK ZERO OR NEGATIVE GROSS / NET AMOUNT
-- Purpose:
-- Find suspicious sales amount values.
-- =========================================================

SELECT
    COUNT(*) FILTER (
        WHERE REPLACE(REPLACE(Gross_Amount, '₹', ''), ',', '')::NUMERIC <= 0
    ) AS invalid_gross_amount,

    COUNT(*) FILTER (
        WHERE REPLACE(REPLACE(Net_Amount, '₹', ''), ',', '')::NUMERIC <= 0
    ) AS invalid_net_amount

FROM ecommerce_orders_raw;


-- =========================================================
-- 17. CHECK DISCOUNT RANGE
-- Purpose:
-- Discount should normally stay between 0% and 100%.
-- =========================================================

SELECT *
FROM ecommerce_orders_raw
WHERE
    REPLACE(Discount_Pct, '%', '')::NUMERIC < 0
    OR
    REPLACE(Discount_Pct, '%', '')::NUMERIC > 100;


-- =========================================================
-- 18. CHECK RATING RANGE
-- Purpose:
-- Rating should normally be between 1 and 5.
-- Blank ratings are ignored.
-- =========================================================

SELECT *
FROM ecommerce_orders_raw
WHERE TRIM(Rating) <> ''
  AND (
      Rating::NUMERIC < 1
      OR Rating::NUMERIC > 5
  );


-- =========================================================
-- 19. CHECK SHIPPING DAYS
-- Purpose:
-- Shipping days should not be negative.
-- Blank values are ignored.
-- =========================================================

SELECT *
FROM ecommerce_orders_raw
WHERE TRIM(Shipping_Days) <> ''
  AND Shipping_Days::NUMERIC < 0;


-- =========================================================
-- 20. CHECK QUANTITY RANGE
-- Purpose:
-- Understand minimum and maximum quantity values.
-- =========================================================

SELECT
    MIN(Quantity::INTEGER) AS min_quantity,
    MAX(Quantity::INTEGER) AS max_quantity
FROM ecommerce_orders_raw;


-- =========================================================
-- 21. CHECK UNIT PRICE RANGE
-- Purpose:
-- Find unusually low or high product prices.
-- =========================================================

SELECT
    MIN(REPLACE(REPLACE(Unit_Price, '₹', ''), ',', '')::NUMERIC) AS min_unit_price,
    MAX(REPLACE(REPLACE(Unit_Price, '₹', ''), ',', '')::NUMERIC) AS max_unit_price
FROM ecommerce_orders_raw;


-- =========================================================
-- 22. CHECK GROSS AMOUNT RANGE
-- Purpose:
-- Understand the minimum and maximum order value.
-- =========================================================

SELECT
    MIN(REPLACE(REPLACE(Gross_Amount, '₹', ''), ',', '')::NUMERIC) AS min_gross_amount,
    MAX(REPLACE(REPLACE(Gross_Amount, '₹', ''), ',', '')::NUMERIC) AS max_gross_amount
FROM ecommerce_orders_raw;


-- =========================================================
-- 23. CHECK NET AMOUNT RANGE
-- Purpose:
-- Understand the actual sales amount range after discounts.
-- =========================================================

SELECT
    MIN(REPLACE(REPLACE(Net_Amount, '₹', ''), ',', '')::NUMERIC) AS min_net_amount,
    MAX(REPLACE(REPLACE(Net_Amount, '₹', ''), ',', '')::NUMERIC) AS max_net_amount
FROM ecommerce_orders_raw;


-- =========================================================
-- 24. CHECK SHIPPING DAYS RANGE
-- Purpose:
-- Check minimum and maximum shipping duration.
-- =========================================================

SELECT
    MIN(NULLIF(TRIM(Shipping_Days), '')::NUMERIC) AS min_shipping_days,
    MAX(NULLIF(TRIM(Shipping_Days), '')::NUMERIC) AS max_shipping_days
FROM ecommerce_orders_raw;


-- =========================================================
-- 25. CHECK RATING RANGE
-- Purpose:
-- Check minimum and maximum rating values.
-- =========================================================

SELECT
    MIN(NULLIF(TRIM(Rating), '')::NUMERIC) AS min_rating,
    MAX(NULLIF(TRIM(Rating), '')::NUMERIC) AS max_rating
FROM ecommerce_orders_raw;


-- =========================================================
-- CLEAN DATA INSERT INTO FINAL TABLE
-- =========================================================

TRUNCATE TABLE ecommerce_orders;

INSERT INTO ecommerce_orders
SELECT DISTINCT
    Order_ID,
    User_ID,
    TO_DATE(Order_Date, 'MM/DD/YYYY'),
    State,
    Department,
    Product_ID,
    Quantity::INTEGER,

    REPLACE(REPLACE(Unit_Price, '₹', ''), ',', '')::NUMERIC,

    REPLACE(Discount_Pct, '%', '')::NUMERIC / 100,

    REPLACE(REPLACE(Gross_Amount, '₹', ''), ',', '')::NUMERIC,

    REPLACE(REPLACE(Net_Amount, '₹', ''), ',', '')::NUMERIC,

    Order_Status,

    NULLIF(TRIM(Shipping_Days), '')::NUMERIC,

    NULLIF(TRIM(Rating), '')::NUMERIC,

    Payment_Mode
FROM ecommerce_orders_raw;

SELECT COUNT(*)
FROM ecommerce_orders;