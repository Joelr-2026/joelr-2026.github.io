CREATE TABLE ecommerce_orders_raw (
    Order_ID VARCHAR,
    User_ID VARCHAR,
    Order_Date VARCHAR,
    State VARCHAR,
    Department VARCHAR,
    Product_ID VARCHAR,
    Quantity VARCHAR,
    Unit_Price VARCHAR,
    Discount_Pct VARCHAR,
    Gross_Amount VARCHAR,
    Net_Amount VARCHAR,
    Order_Status VARCHAR,
    Shipping_Days VARCHAR,
    Rating VARCHAR,
    Payment_Mode VARCHAR
);

CREATE TABLE ecommerce_orders (
    Order_ID VARCHAR(50),
    User_ID VARCHAR(50),
    Order_Date DATE,
    State VARCHAR(50),
    Department VARCHAR(50),
    Product_ID VARCHAR(50),
    Quantity INTEGER,
    Unit_Price NUMERIC,
    Discount_Pct NUMERIC,
    Gross_Amount NUMERIC,
    Net_Amount NUMERIC,
    Order_Status VARCHAR(50),
    Shipping_Days NUMERIC,
    Rating NUMERIC,
    Payment_Mode VARCHAR(50)
);

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


SELECT COUNT(*) AS clean_rows
FROM ecommerce_orders;