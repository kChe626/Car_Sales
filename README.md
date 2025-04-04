## Car Sales Data Cleaning Summary

1. Data Deduplication

    Created staging tables (car_staging) to preserve raw data integrity.

    Used ROW_NUMBER() with PARTITION BY on composite keys (date, customer, dealer, etc.) to identify duplicates.

    Deleted records with row_num > 1 to ensure uniqueness.

2. Column Standardization

    Renamed columns to avoid reserved keywords (Date → sale_date) and special characters (Price ($) → price_usd).

    Applied snake_case naming consistently (e.g., Customer Name → customer_name).

3. Date Formatting

    Converted sale_date from text to DATE type using STR_TO_DATE('%m/%d/%Y').

    Split sale_date into separate sale_year, sale_month, and sale_day columns for granular time-based analysis.

4. Data Cleaning

    Removed unwanted special characters (e.g., Ã‚Â) from the engine column using REPLACE().

    Validated data types with INFORMATION_SCHEMA.COLUMNS.

5. Structural Cleanup

    Dropped temporary columns like row_num post-deduplication.

**Key SQL Techniques Used**

DDL/DML: CREATE TABLE, ALTER TABLE (add/drop columns), DELETE.
 
Window Functions: ROW_NUMBER() for duplicate detection.

Date Functions: STR_TO_DATE(), YEAR(), MONTH(), DAY().

String Manipulation: REPLACE(), LIKE for text cleanup.

## Car Sales Data Analysis Summary

This analysis explores key trends and patterns in car sales data using SQL. Below are the objectives, methods, and insights derived:
Objective 1: Sales Performance

    Sales by Company
    sql
    Copy

    SELECT company, COUNT(*) AS company_sales  
    FROM car_staging  
    GROUP BY company  
    ORDER BY company_sales DESC;  

        Insight: Identified top-performing companies by total sales volume (e.g., Toyota, Ford).

    Most Popular Car Model
    sql
    Copy

    SELECT company, model, COUNT(*) AS total_sales  
    FROM car_staging  
    GROUP BY company, model  
    ORDER BY total_sales DESC;  

        Insight: Highlighted the best-selling models (e.g., Honda Civic, Ford F-150).

    Top 5 Dealer Regions
    sql
    Copy

    SELECT dealer_region, COUNT(car_id) AS total_sales  
    FROM car_staging  
    GROUP BY dealer_region  
    ORDER BY total_sales DESC  
    LIMIT 5;  

        Insight: Revealed regions with the highest sales activity.

Objective 2: Customer Preferences

    Most Common Body Style
    sql
    Copy

    SELECT body_style, COUNT(*) AS total_purchases  
    FROM car_staging  
    GROUP BY body_style  
    ORDER BY total_purchases DESC;  

        Insight: SUVs and sedans dominated customer preferences.

    Price Range Analysis (Mid-Range Cars)
    sql
    Copy

    SELECT company, model, COUNT(*) AS total_sales  
    FROM car_staging  
    WHERE price_usd BETWEEN 15000 AND 40000  
    GROUP BY company, model  
    ORDER BY total_sales DESC;  

        Insight: Mid-range cars (e.g., Toyota Camry) accounted for the majority of sales.

Objective 3: Premium Sales & Luxury Market

    Highest-Priced Car Sold
    sql
    Copy

    SELECT company, model, price_usd  
    FROM car_staging  
    WHERE price_usd = (SELECT MAX(price_usd) FROM car_staging);  

        Insight: Luxury brands like Porsche or Ferrari had the highest single-sale values.

    BMW Sales in 2023
    sql
    Copy

    SELECT * FROM car_staging  
    WHERE company = 'BMW' AND sale_year = 2023;  

        Insight: Analyzed BMW’s recent sales performance and popular models.

Key SQL Techniques Used

    Aggregation: COUNT(), GROUP BY, ORDER BY.

    Subqueries: Identified max price for luxury car analysis.

    Filtering: WHERE, BETWEEN, and LIMIT for targeted insights.

    Window Functions: RANK() to determine top body styles by company.

Business Impact

    Identified top-selling brands/models to optimize inventory.

    Highlighted geographic hotspots for marketing focus.

    Uncovered customer preferences (body styles, price ranges) for strategic pricing.


## Outcome: 

A clean, standardized dataset ready for analyzing sales trends, dealer performance, and customer demographics.

----
# Car Sales Data Cleaning, SQL Analysis & Tableau Dashboard

This project focuses on cleaning and analyzing car sales data from 2022 to 2023 using SQL and then visualizing key insights in a Tableau dashboard. After detecting and fixing any data quality issues such as duplicates, missing values, or inconsistent fields—the cleaned dataset was loaded into MySQL where SQL queries explored monthly sales trends, top-performing car models, and city-level revenue. Key metrics such as current-year-to-date (CYTD) total sales, prior-year-to-date (PYTD) sales, and year-over-year growth were calculated to highlight overall performance. The Tableau dashboard further refines these insights by displaying metrics like total sales by company, body type breakdown, and model price distribution.

---

## Project Overview

- **Data Cleaning & Preparation**: 
  - Raw car sales data is imported into MySQL.
  - SQL queries are used to remove duplicates, address missing values, and standardize data formats.

- **SQL Analysis**:
  - Analysis includes:
    - Payment methods and transaction counts.
    - Highest-rated categories by branch.
    - Busiest days and monthly trends.
    - Revenue and profit calculations, including year-over-year comparisons.

- **Visualization**:
  - An interactive Tableau dashboard presents key metrics like total sales, model performance, and revenue trends.

---

## ⚙️ Technologies Used

- **MySQL**: For data cleaning and analysis.
- **Tableau**: For creating the interactive dashboard.

---


## SQL Analysis Overview

Some key SQL queries include:

- **Payment Methods & Transactions**
  ```sql
  SELECT payment_method, COUNT(*) as no_payments, SUM(quantity) as no_qty_sold
  FROM car_sales
  GROUP BY payment_method;
  ```

- **Highest-Rated Category per Branch**
  ```sql
  SELECT branch, category, AVG(rating) as avg_rating
  FROM car_sales
  GROUP BY branch, category
  ORDER BY branch, avg_rating DESC;
  ```

- **Busiest Day per Branch**
  ```sql
  SELECT branch, DATE_FORMAT(STR_TO_DATE(`date`, '%d/%m/%y'), '%W') AS day_name, COUNT(*) AS no_transactions
  FROM car_sales
  GROUP BY branch, day_name
  ORDER BY branch, no_transactions DESC;
  ```

- **Revenue Decrease Year-over-Year**
  ```sql
  WITH revenue_2022 AS (
    SELECT branch, SUM(total) AS revenue
    FROM car_sales
    WHERE EXTRACT(YEAR FROM STR_TO_DATE(date, '%d/%m/%y')) = 2022
    GROUP BY branch
  ),
  revenue_2023 AS (
    SELECT branch, SUM(total) AS revenue
    FROM car_sales
    WHERE EXTRACT(YEAR FROM STR_TO_DATE(date, '%d/%m/%y')) = 2023
    GROUP BY branch
  )
  SELECT 
    r2.branch,
    r2.revenue AS last_year_revenue,
    r3.revenue AS current_year_revenue,
    ROUND((r2.revenue - r3.revenue) / r2.revenue * 100, 2) AS revenue_difference_percentage
  FROM revenue_2022 r2
  JOIN revenue_2023 r3 ON r2.branch = r3.branch
  WHERE r2.revenue > r3.revenue
  ORDER BY revenue_difference_percentage DESC;
  ```

---
