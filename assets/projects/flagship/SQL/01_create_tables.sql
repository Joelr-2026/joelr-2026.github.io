-- =========================================================
-- Flagship End-to-End Analytics Project
-- File: 01_create_tables.sql
-- Purpose: Create core relational tables
-- Database: flagship_analytics
-- =========================================================


-- =========================================================
-- CUSTOMERS TABLE
-- Purpose:
-- Stores customer profile, signup, location,
-- acquisition channel and loyalty information.
-- =========================================================

CREATE TABLE customers (
    customer_id VARCHAR(20) PRIMARY KEY,
    signup_date DATE,
    city VARCHAR(100),
    age_band VARCHAR(50),
    gender VARCHAR(20),
    acquisition_channel VARCHAR(50),
    loyalty_tier VARCHAR(50)
);


-- =========================================================
-- PRODUCTS TABLE
-- Purpose:
-- Stores product master data including category,
-- pricing, cost and supplier details.
-- =========================================================

CREATE TABLE products (
    product_id VARCHAR(20) PRIMARY KEY,
    category VARCHAR(100),
    product_type VARCHAR(100),
    product_name VARCHAR(150),
    list_price NUMERIC(10,2),
    unit_cost NUMERIC(10,2),
    supplier VARCHAR(100)
);


-- =========================================================
-- ORDERS TABLE
-- Purpose:
-- Stores transaction-level order data.
--
-- Note:
-- order_id is NOT set as PRIMARY KEY yet because
-- duplicate Order_ID values were found in the raw dataset.
-- =========================================================

CREATE TABLE orders (
    order_id VARCHAR(20),
    order_date DATE,
    ship_date DATE,
    customer_id VARCHAR(20),
    product_id VARCHAR(20),
    quantity INTEGER,
    unit_price NUMERIC(10,2),
    discount_pct NUMERIC(5,2),
    revenue NUMERIC(12,2),
    cost NUMERIC(12,2),
    profit NUMERIC(12,2),
    order_status VARCHAR(50),
    payment_mode VARCHAR(50),
    sales_channel VARCHAR(50),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_orders_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);


-- =========================================================
-- IMPORT VERIFICATION
-- Purpose:
-- Verify that all CSV files were imported successfully.
-- =========================================================

SELECT COUNT(*) AS customers_count
FROM customers;

SELECT COUNT(*) AS products_count
FROM products;

SELECT COUNT(*) AS orders_count
FROM orders;