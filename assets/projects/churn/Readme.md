# Customer Churn Analysis

## Objective

The objective of this project is to analyze customer behavior, identify patterns associated with churn, and provide business recommendations that may help improve customer retention.

## Tools Used

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- Jupyter Notebook
- VS Code

## Dataset Overview

The dataset contains 1,500 customer records and 15 columns.

The data includes customer information such as:

- Age
- City
- Plan
- Contract Type
- Tenure
- Monthly Charges
- Monthly Usage
- Support Calls
- Complaints
- Late Payments
- Credit Score
- Monthly Income
- Signup Channel
- Churn Status

The target variable for this analysis is `Churn`.

## Data Cleaning

The following data quality checks and cleaning steps were performed:

- Checked missing values
- Checked duplicate records
- Checked blank strings
- Checked categorical consistency
- Checked numeric ranges for suspicious values
- Found 20 missing values in the `City` column
- Replaced missing city values with `Unknown`
- Found inconsistent capitalization in the `Plan` column
- Standardized plan categories such as `standard`, `basic`, and `premium`
- No duplicate rows were found
- No obvious invalid or negative numeric values were found

## Analysis Performed

The project includes:

- Overall churn rate analysis
- Churn by contract type
- Churn by customer plan
- Churn by signup channel
- Churn by city
- Tenure analysis
- Monthly charge analysis
- Complaints analysis
- Support calls analysis
- Late payments analysis
- Credit score analysis
- Monthly income analysis
- Monthly usage analysis

## Visualizations

The following visualizations were created:

- Customer churn count plot
- Churn percentage chart
- Churn by contract type
- Churn by customer plan
- Churn by signup channel
- Churn by city
- Complaints vs churn boxplot
- Late payments vs churn boxplot
- Tenure distribution histogram
- Correlation heatmap

## Key Insights

1. The overall customer churn rate is **26.4%**.

2. Customers with monthly contracts have the highest churn rate at approximately **31.98%**.

3. Standard plan customers have the highest churn rate at approximately **29.98%**.

4. Chennai has the highest churn rate among known cities at approximately **32.86%**, followed by Jaipur at approximately **31.68%**.

5. Churned customers have more complaints on average than retained customers.

6. Churned customers also have more late payments on average.

7. Support calls are slightly higher among churned customers.

8. Tenure shows very little difference between churned and retained customers.

9. Monthly charges, monthly usage, credit score, and monthly income do not show strong standalone differences between churned and retained customers.

## Business Recommendations

1. Focus retention efforts on customers using monthly contracts.

2. Investigate the Standard plan to understand why its churn rate is higher than other plans.

3. Prioritize customers with repeated complaints and improve issue resolution time.
