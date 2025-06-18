SELECT * FROM car_staging LIMIT 50;

---  Identify which car models are the most popular by units sold.
SELECT 
    model, 
    COUNT(*) AS total_sales
FROM car_staging
GROUP BY model
ORDER BY total_sales DESC
LIMIT 10;

--- Revenue by Dealer Region
SELECT 
    dealer_region,
    SUM(price_usd) AS total_revenue
FROM car_staging
GROUP BY dealer_region
ORDER BY total_revenue DESC;

--- Monthly Sales Trend
SELECT 
    YEAR(sale_date) AS sale_year,
    MONTH(sale_date) AS sale_month,
    COUNT(*) AS cars_sold
FROM car_staging
GROUP BY sale_year, sale_month
ORDER BY sale_year, sale_month;

--- Average Price by Body Style
SELECT 
    body_style,
    ROUND(AVG(price_usd), 2) AS avg_price
FROM car_staging
GROUP BY body_style
ORDER BY avg_price DESC;

--- Top Dealers by Volume
SELECT 
    dealer_name,
    COUNT(*) AS total_sales
FROM car_staging
GROUP BY dealer_name
ORDER BY total_sales DESC
LIMIT 5;

--- Income Distribution of Buyers
SELECT 
    CASE 
        WHEN annual_income < 30000 THEN 'Under 30k'
        WHEN annual_income BETWEEN 30000 AND 60000 THEN '30k-60k'
        WHEN annual_income BETWEEN 60001 AND 100000 THEN '60k-100k'
        ELSE 'Over 100k'
    END AS income_band,
    COUNT(*) AS buyers
FROM car_staging
GROUP BY income_band
ORDER BY buyers DESC;

--- Most Common Engine Types
SELECT 
    engine,
    COUNT(*) AS total
FROM car_staging
GROUP BY engine
ORDER BY total DESC
LIMIT 10;

--- Sales by Day of the Week
SELECT 
    DAYNAME(sale_date) AS day_name,
    COUNT(*) AS total_sales
FROM car_staging
GROUP BY day_name
ORDER BY total_sales DESC;