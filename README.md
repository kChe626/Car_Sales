
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=Tableau&logoColor=white)


#  Car Sales Data Cleaning, SQL Analysis & Tableau Dashboard

This project focuses on cleaning and analyzing car sales data from 2022 to 2023 using **MySQL** and visualizing key business insights in a **Tableau dashboard**. After detecting and fixing data quality issues like duplicates, missing values, and inconsistent fields, the cleaned dataset was loaded into MySQL. SQL queries were used to explore trends, top-performing car models, and calculate key performance metrics like CYTD and PYTD sales with year-over-year growth. Tableau was then used to build an interactive dashboard highlighting these metrics for better business insights.

---
## Dataset
The raw dataset contained:

    Car ID — unique identifier for each car

    Date — date of sale (string format)

    Customer Name — name of the customer

    Gender, Annual Income, Dealer Name, Dealer Region, Company, Model, Engine, Transmission, Color, Price ($), Dealer No, Body Style, Phone

---

## Cleaning Process

### Created staging tables
```sql
CREATE TABLE car_staging LIKE car_sales;
INSERT INTO car_staging SELECT * FROM car_sales;
```

### Renamed columns to snake_case
I replaced spaces and special characters for cleaner SQL:
```sql
ALTER TABLE car_staging
CHANGE `Car ID` car_id VARCHAR(50),
CHANGE `Date` sale_date TEXT,
CHANGE `Customer Name` customer_name VARCHAR(100),
CHANGE `Price ($)` price_usd INT,
...;
```
### Standardized text values
```sql
UPDATE car_staging
SET dealer_name = LOWER(TRIM(dealer_name)),
    customer_name = LOWER(TRIM(customer_name)),
    engine = LOWER(TRIM(engine)),
    ...;
```

### Removed duplicates
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
        FROM duplicate_cte
        WHERE row_num > 1
    ) sub
);
```

### Converted sale_date to DATE type
```sql
ALTER TABLE car_staging ADD COLUMN sale_date_temp DATE;
UPDATE car_staging SET sale_date_temp = STR_TO_DATE(sale_date, '%m/%d/%Y');
ALTER TABLE car_staging DROP COLUMN sale_date;
ALTER TABLE car_staging CHANGE sale_date_temp sale_date DATE;

ALTER TABLE car_staging
ADD COLUMN sale_year INT,
ADD COLUMN sale_month INT,
ADD COLUMN sale_day INT;

UPDATE car_staging
SET sale_year = YEAR(sale_date),
    sale_month = MONTH(sale_date),
    sale_day = DAY(sale_date);
```

### Removed unwanted encoding characters
```sql
UPDATE car_staging
SET engine = TRIM(REPLACE(engine, 'Ã‚Â', ''))
WHERE engine LIKE '%Ã‚Â%';
```
[See full cleaning code](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_cleaning.sql)


---

##  SQL Analysis Examples

###  Top-Selling Car Models
```sql
SELECT payment_method, COUNT(*) AS no_payments, SUM(quantity) AS no_qty_sold
FROM car_sales
GROUP BY payment_method;
```

###  Revenue by Dealer Region
```sql
SELECT 
    dealer_region,
    SUM(price_usd) AS total_revenue
FROM car_staging
GROUP BY dealer_region
ORDER BY total_revenue DESC;
```

###  Monthly Sales Trend
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

##  Tableau Dashboard

![Dashboard Overview](https://github.com/kChe626/Snapshots/blob/main/Car%20Sales%20Tab.gif)

### Dashboard Highlights
- **CYTD vs. PYTD Total Sales**
- **Monthly Sales Trend**
- **Top Companies by Revenue**
- **Car Body Type Performance**
- **Model Price Distribution**

---
## Files
[car_sales_cleaned — SQL code for cleaning](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_cleaning.sql)

[sql_car_sales_analysis — MySQL anaylsis](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_analysis.sql)

[Power_BI_dashboard](https://github.com/kChe626/Melbourne-Housing-Project/blob/main/Power_Bi_melb_data.pbix)


## Dataset Source
- Car Sales dataset from [https://www.kaggle.com/datasets/missionjee/car-sales-report]

