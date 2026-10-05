# E-commerce SQL Analysis using PostgreSQL

## Project Objective

The objective of this project is to analyze an e-commerce dataset using PostgreSQL and SQL.

The project focuses on:

- Data validation
- Data cleaning
- Sales analysis
- Customer analysis
- Product and department performance
- Payment method analysis
- Order status analysis
- Monthly sales trends
- Advanced SQL using CTEs and window functions

---

## Tools Used

- PostgreSQL
- SQL
- VS Code
- pgAdmin
- CSV Dataset
- GitHub

---

## Dataset Overview

The dataset contains e-commerce order-level information.

Main columns include:

- Order_ID
- User_ID
- Order_Date
- State
- Department
- Product_ID
- Quantity
- Unit_Price
- Discount_Pct
- Gross_Amount
- Net_Amount
- Order_Status
- Shipping_Days
- Rating
- Payment_Mode

### Dataset Size

Raw records:

**2,505 rows**

After removing exact duplicate rows:

**2,500 clean rows**

Date range:

**2024-07-01 to 2026-08-30**

---

## Project Structure

```text
Ecommerce_SQL_Analysis/
│
├── Data/
│   └── 02_Ecommerce_SQL_Data.csv
│
├── SQL/
│   ├── 01_create_table.sql
│   ├── 02_data_validation.sql
│   ├── 03_business_analysis.sql
│   └── 04_advanced_analysis.sql
│
├── Images/
│
├── Output/
│
└── README.md
```

---

## Data Validation

Before starting the analysis, the raw dataset was validated.

Checks performed:

- Total row count
- Missing Order_ID values
- Duplicate Order_ID values
- Exact duplicate rows
- Minimum and maximum order dates
- Missing values in important columns
- Invalid numeric values
- Zero values
- Negative values
- Category inconsistencies
- Payment mode values
- Order status values
- State values
- Suspicious numeric ranges

### Validation Findings

- Total raw rows: **2,505**
- Missing Order_ID: **0**
- Extra exact duplicate rows: **5**
- Clean rows after duplicate removal: **2,500**
- Minimum date: **2024-07-01**
- Maximum date: **2026-08-30**

Observed ranges:

- Quantity: **1 to 5**
- Unit Price: **₹106.94 to ₹11,997.88**
- Gross Amount: **₹108.22 to ₹59,720.55**
- Net Amount: **₹91.99 to ₹58,738.55**
- Shipping Days: **1 to 8**
- Rating: **1 to 5**

---

## Data Cleaning

A raw table and a clean table were used.

### Raw Table

`ecommerce_orders_raw`

The raw table was used to preserve the original imported dataset.

### Clean Table

`ecommerce_orders`

The clean table was created after:

- Removing exact duplicate rows
- Converting Order_Date to DATE
- Removing ₹ symbols
- Removing commas from numeric values
- Converting discount percentages to numeric format
- Converting blank values to NULL
- Standardizing Department names

Example:

`beauty` → `Beauty`

---

## Basic SQL Analysis

The following business questions were analyzed:

1. Total Net Amount
2. Total Orders
3. Average Order Value
4. Top Products by Sales
5. Department Sales
6. Top Customers
7. Sales by State
8. Monthly Sales Trend
9. Payment Mode Usage
10. Order Status Distribution
11. Sales by Order Status
12. Delivered Revenue
13. Quantity by Department
14. Average Rating by Department
15. Average Shipping Days by State

---

## Key Business Results

### Total Net Amount

**₹39,519,711.31**

Note:

This includes Net Amount from all order statuses, including Delivered, Returned, Cancelled and Shipped orders.

Therefore, it should not automatically be treated as realized revenue.

### Delivered Revenue

**₹19,960,124.91**

### Total Orders

**2,500**

### Average Order Value

**₹15,807.88**

---

## Product Analysis

Top overall product by Net Amount:

**P0238 — ₹347,551.47**

Top product by department:

| Department | Product | Net Amount |
|---|---|---:|
| Beauty | P0039 | ₹147,096.95 |
| Electronics | P0047 | ₹140,618.35 |
| Fashion | P0024 | ₹122,960.72 |
| Grocery | P0141 | ₹121,651.56 |
| Home | P0120 | ₹119,516.95 |
| Sports | P0093 | ₹110,884.89 |

---

## Department Analysis

Department sales:

| Department | Net Amount |
|---|---:|
| Beauty | ₹7,023,961.40 |
| Electronics | ₹6,839,973.52 |
| Home | ₹6,836,875.07 |
| Fashion | ₹6,804,705.83 |
| Sports | ₹6,191,793.46 |
| Grocery | ₹5,822,402.03 |

Beauty generated the highest Net Amount.

Grocery generated the lowest Net Amount among the departments.

---

## Customer Analysis

Top customer:

**U00828 — ₹189,579.85**

Customer spending was also categorized using SQL CASE statements.

Example segments:

- High Value
- Medium Value
- Regular

---

## State Analysis

Highest Net Amount state:

**West Bengal — ₹4,229,392.07**

Other high-performing states included:

- Rajasthan
- Gujarat
- Maharashtra
- Uttar Pradesh

---

## Payment Analysis

Most commonly used payment method:

**COD — 638 orders**

Other payment methods:

- Wallet — 624
- UPI — 619
- Card — 619

---

## Order Status Analysis

Order distribution:

- Delivered — **1,237**
- Returned — **444**
- Cancelled — **430**
- Shipped — **389**

Delivered orders represent the largest order-status group.

---

## Monthly Sales Analysis

Average monthly Net Amount:

**₹1,519,988.90**

Highest monthly Net Amount:

**March 2026 — ₹1,937,895.73**

Largest Month-over-Month increase:

**August 2025 — +57.01%**

Largest Month-over-Month decline:

**June 2026 — -27.34%**

---

## Rating Analysis

Average rating by department:

| Department | Average Rating |
|---|---:|
| Home | 3.03 |
| Beauty | 2.99 |
| Sports | 2.98 |
| Fashion | 2.97 |
| Electronics | 2.94 |
| Grocery | 2.87 |

Home had the highest average rating.

Grocery had the lowest average rating.

---

## Shipping Analysis

Highest average shipping duration:

**Karnataka — 4.69 days**

This can be used to investigate possible logistics or fulfillment delays by location.

---

## Intermediate SQL Used

This project includes:

- GROUP BY
- HAVING
- CASE
- Subqueries
- CTEs

Examples:

- Departments with sales above a threshold
- Customer segmentation
- Products with above-average sales
- High-value customer analysis

---

## Advanced SQL Used

Advanced SQL concepts used:

- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- SUM() OVER()
- AVG() OVER()
- LAG()

These were used for:

- Customer ranking
- Product ranking
- Top product per department
- Running monthly sales
- Previous-month comparison
- Month-over-month change
- Average monthly sales comparison

---

## Key Insights

### 1. Beauty is the highest-value department

Observation:

Beauty generated **₹7.02M** in Net Amount.

Insight:

Beauty was the strongest department by total sales value.

Business Recommendation:

Analyze the successful products, pricing and promotions within Beauty and test similar strategies in lower-performing departments.

---

### 2. Sales show strong monthly fluctuations

Observation:

March 2026 generated **₹1.94M**, while the average monthly Net Amount was approximately **₹1.52M**.

Insight:

Sales performance changes significantly between months.

Business Recommendation:

Investigate seasonality, campaigns and category performance during high-performing months.

---

### 3. Month-over-month volatility is high

Observation:

August 2025 increased by **57.01%**, while June 2026 declined by **27.34%**.

Insight:

There are significant changes in monthly sales performance.

Business Recommendation:

Compare discounts, order volumes, product mix and marketing activity during months with large changes.

---

### 4. Customer ratings are moderate

Observation:

Department ratings are mostly around 3.

Insight:

There is room to improve overall customer satisfaction.

Business Recommendation:

Investigate low-rated products and orders, especially within Grocery.

---

### 5. Certain products dominate their departments

Observation:

Each department has identifiable top-performing products.

Insight:

These products are important contributors to department sales.

Business Recommendation:

Maintain availability of strong products and compare their pricing and discount strategy with weaker products.

---

## Business Recommendations

1. Increase focus on high-performing Beauty products.
2. Investigate lower-performing Grocery products and customer ratings.
3. Analyze large month-over-month sales changes for seasonality and campaign impact.
4. Monitor top products and high-value customers separately.
5. Investigate returned and cancelled orders before treating total Net Amount as actual realized revenue.

---

## How to Run

1. Install PostgreSQL.
2. Create a database.
3. Import the CSV into the raw table.
4. Run `01_create_table.sql`.
5. Run `02_data_validation.sql`.
6. Run `03_business_analysis.sql`.
7. Run `04_advanced_analysis.sql`.
8. Review outputs and insights.

---

## Conclusion

This project demonstrates an end-to-end SQL analysis workflow using PostgreSQL.

The project covers data importing, validation, cleaning, business analysis and advanced SQL techniques.

It also demonstrates how SQL can be used to convert raw e-commerce data into meaningful business insights.
```

