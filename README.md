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

        Insight: Revealed regions with the highest sales activity (e.g., California, Texas).

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
