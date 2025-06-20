
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=Tableau&logoColor=white)


#  US Car Sales — SQL Cleaning, Analysis, and Tableau Dashboard

This project focuses on cleaning, analyzing, and visualizing US car sales data using SQL and Tableau. The goal is to transform raw sales records into meaningful insights that highlight trends, performance, and buyer profiles.


## Dataset

The raw dataset contained:

- Source: [car_data.csv](https://github.com/kChe626/Car_Sales/blob/main/Car%20Sales.xlsx%20-%20car_data.csv)
- Columns: car_id, sale_date, customer_name, gender, annual_income, dealer_name, company, model, engine, transmission, color, price_usd, dealer_no, body_style, phone, dealer_region

## Objectives

- Clean and standardize the dataset for analysis
- Remove duplicate records
- Convert date fields to proper SQL DATE type
- Analyze sales trends and performance metrics
- Visualize results in Tableau

## Key SQL Techniques Used

- ROW_NUMBER() for duplicate detection
- STR_TO_DATE() for date conversion
- LOWER(), TRIM() for text standardization
- Aggregations for revenue, volume, and trend analysis

## Data Cleaning with SQL

See [Car_Sales_SQL_Cleaning.sql ](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_cleaning.sql)for the full, well-commented SQL script.

## Example snippets

Standardize text fields
```sql
UPDATE car_staging
SET 
    dealer_name = LOWER(TRIM(dealer_name)),
    customer_name = LOWER(TRIM(customer_name)),
    company = LOWER(TRIM(company)),
    model = LOWER(TRIM(model)),
    engine = LOWER(TRIM(engine)),
    transmission = LOWER(TRIM(transmission)),
    color = LOWER(TRIM(color)),
    dealer_region = LOWER(TRIM(dealer_region));
```
Identify and remove duplicates
```sql
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY car_id, sale_date, customer_name, annual_income,
                            dealer_name, phone
           ) AS row_num
    FROM car_staging
)
DELETE FROM car_staging
WHERE car_id IN (
    SELECT car_id FROM (
        SELECT car_id, row_num
        FROM (
            SELECT car_id,
                   ROW_NUMBER() OVER (
                       PARTITION BY car_id, sale_date, customer_name, annual_income,
                                    dealer_name, phone
                   ) AS row_num
            FROM car_staging
        ) t
        WHERE row_num > 1
    ) sub
);
```

Convert sale_date to DATE type
```sql
SET sale_date_temp = STR_TO_DATE(sale_date, '%m/%d/%Y');
```

[See full cleaning code](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_cleaning.sql)

## SQL Analysis Script

See [Car_Sales_SQL_Analysis.sql ](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_analysis.sql)for the full, well-commented SQL script.


## Example SQL Analysis Snippets

Top-Selling Car Models
```sql
SELECT payment_method, COUNT(*) AS no_payments, SUM(quantity) AS no_qty_sold
FROM car_sales
GROUP BY payment_method;
```
Revenue by Dealer Region
```sql
SELECT 
    dealer_region,
    SUM(price_usd) AS total_revenue
FROM car_staging
GROUP BY dealer_region
ORDER BY total_revenue DESC;
```

Monthly Sales Trend
```sql
SELECT 
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    COUNT(*) AS cars_sold
FROM car_staging
GROUP BY sale_year, sale_month
ORDER BY sale_year, sale_month;
```

[See full analysis code](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_analysis.sql)

---

## Tableau Dashboard

![Dashboard Overview](https://github.com/kChe626/Snapshots/blob/main/Car%20Sales%20Tab.gif)

### Dashboard Highlights
- CYTD vs. PYTD Total Sales
- Monthly Sales Trend
- Top Companies by Revenue
- Car Body Type Performance
- Model Price Distribution

[Download full Tableau_dashboard](https://github.com/kChe626/Melbourne-Housing-Project/blob/main/Power_Bi_melb_data.pbix)


## Files
[car_sales_cleaned — SQL code for cleaning](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_cleaning.sql)

[sql_car_sales_analysis — MySQL anaylsis](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_analysis.sql)

[Power_BI_dashboard](https://github.com/kChe626/Melbourne-Housing-Project/blob/main/Power_Bi_melb_data.pbix)


## Dataset Source
- Car Sales dataset from [https://www.kaggle.com/datasets/missionjee/car-sales-report]

