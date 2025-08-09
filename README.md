# **US Car Sales — SQL Cleaning, Analysis & Tableau Dashboard**  
![MySQL](https://img.shields.io/badge/mysql-%2300f.svg?style=for-the-badge&logo=mysql&logoColor=white)  ![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge&logo=Tableau&logoColor=white)

## **Overview**  
This project focuses on **cleaning, analyzing, and visualizing** U.S. car sales data using **MySQL** and **Tableau**.  
The objective was to transform raw sales records into meaningful insights on sales performance, regional trends, and buyer profiles.

---

## **Dataset**
- **Source:** [car_data.csv](https://github.com/kChe626/Car_Sales/blob/main/Car%20Sales.xlsx%20-%20car_data.csv)  
- **Columns:** car_id, sale_date, customer_name, gender, annual_income, dealer_name, company, model, engine, transmission, color, price_usd, dealer_no, body_style, phone, dealer_region

---

## **Data Cleaning Process (SQL)**
**Objectives:**
- Remove duplicate records
- Standardize text fields
- Convert sale_date to proper DATE type
- Prepare dataset for analysis

**Key SQL Techniques:**
- `ROW_NUMBER()` for duplicate detection  
- `STR_TO_DATE()` for date conversion  
- `LOWER()` and `TRIM()` for text standardization

**Example Snippets:**  
```sql
-- Standardize text fields
UPDATE car_staging
SET 
    dealer_name = LOWER(TRIM(dealer_name)),
    company = LOWER(TRIM(company)),
    model = LOWER(TRIM(model)),
    engine = LOWER(TRIM(engine)),
    transmission = LOWER(TRIM(transmission)),
    color = LOWER(TRIM(color)),
    dealer_region = LOWER(TRIM(dealer_region));

-- Identify duplicates
WITH duplicate_cte AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY car_id, sale_date, customer_name, annual_income, dealer_name, phone
           ) AS row_num
    FROM car_staging
)
SELECT * FROM duplicate_cte WHERE row_num > 1;

-- Convert date strings to DATE type
UPDATE car_staging
SET sale_date = STR_TO_DATE(sale_date, '%m/%d/%Y');
```

**Full Cleaning Script:** [Car_sales_SQL_cleaning.sql](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_cleaning.sql)

---

## **SQL Analysis**
**Objectives:**
- Identify top-selling models and companies
- Analyze regional sales trends
- Track monthly sales volume
- Evaluate revenue contribution by region

**Example Queries:**
```sql
-- Top-selling car models
SELECT model, COUNT(*) AS total_sold
FROM car_sales
GROUP BY model
ORDER BY total_sold DESC
LIMIT 5;

-- Revenue by dealer region
SELECT dealer_region, SUM(price_usd) AS total_revenue
FROM car_sales
GROUP BY dealer_region
ORDER BY total_revenue DESC;

-- Monthly sales trend
SELECT YEAR(sale_date) AS sale_year, MONTH(sale_date) AS sale_month, COUNT(*) AS cars_sold
FROM car_sales
GROUP BY sale_year, sale_month
ORDER BY sale_year, sale_month;
```

**Full Analysis Script:** [Car_sales_SQL_analysis.sql](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_analysis.sql)

---

## **Key Insights**
- Certain regions outperform in total revenue despite lower sales volume — higher-priced vehicles dominate those areas.  
- Seasonal spikes in sales suggest promotional or year-end clearance periods.  
- A small number of models account for a significant share of sales.

---

## **Visualization (Tableau)**
An **interactive Tableau dashboard** was created to visualize sales performance.  

**Dashboard Features:**
- CYTD vs PYTD total sales comparison
- Monthly sales trends
- Top companies by revenue
- Body style performance
- Price distribution by model

![Dashboard Overview](https://github.com/kChe626/Snapshots/blob/main/Car%20Sales%20Tab.gif)  

**Download Tableau Dashboard:** [car_sales_dashboard.twbx](https://github.com/kChe626/Melbourne-Housing-Project/blob/main/Power_Bi_melb_data.pbix)

---

## **Business Relevance**
The analysis provides sales and operations managers with regional performance metrics, revenue distribution, and product mix trends. These insights inform dealer allocation, sales forecasting, and inventory optimization strategies, improving sales efficiency and operational planning.

---

## **Files**
- [SQL Cleaning Script](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_cleaning.sql)  
- [SQL Analysis Script](https://github.com/kChe626/Car_Sales/blob/main/Car_sales_SQL_analysis.sql)  
- [Tableau Dashboard GIF](https://github.com/kChe626/Snapshots/blob/main/Car%20Sales%20Tab.gif)  

