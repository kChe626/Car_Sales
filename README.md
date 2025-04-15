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

- **Tableau Dashboard**  
  - An interactive dashboard displays metrics such as:
    - **CYTD Total Sales** vs. **PYTD Total Sales**  
    - **Year-over-Year Sales Growth**  
    - **Total Sales by Company**  
    - **Car Sold by Month**  
    - **Body Type Sales**
    - **Model Price Sold**  


---

## Technologies Used

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

## Tableau Dashboard

Below is a preview of the Tableau dashboard created for this project:

![Dashboard Overview](https://github.com/kChe626/Snapshots/blob/main/Car%20Sales%20Tab.gif)  

**Dashboard Highlights**:
- **CYTD vs. PYTD Total Sales**: Compares current year-to-date and prior year-to-date sales.  
- **Monthly Sales Trend**: Shows how sales fluctuate over time.  
- **Top Companies**: Breaks down which manufacturers or companies are performing best.  
- **Body Type & Model Price Analysis**: Insights into the types of cars (SUV, Sedan, etc.) and their price ranges.  

## Acknowledgments

- Car Sales dateset from [https://www.kaggle.com/datasets/missionjee/car-sales-report]
