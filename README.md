# Car_Sales

-- DATA Cleaning

-- 1. Check for Duplicates
-- 2. Revsed Colunm Names

SELECT *
FROM car_sales;

CREATE TABLE car_staging
LIKE car_sales;

INSERT car_staging
SELECT *
FROM car_sales;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY 'date', 'Customer Name', 'Annual Income', Dealer_Name, 'date', Phone) as row_num
FROM car_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY 'Date', 'Customer Name', 'Annual Income', Dealer_Name, 'date', 
Phone, Dealer_Name, Car_id) as row_num
FROM car_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num >1;

-- No Duplicates with quick view

-- Creating staging 2 database
-- Revised colunm name with "space" to underscore
-- Special Characters Removed
-- Avoid Reseved Keywords
-- Consistent Snake_case

CREATE TABLE `car_staging` (
  `car_id` TEXT,
  `sale_date` TEXT COMMENT 'Renamed from "Date" (reserved keyword)', -- Avoid reserved keyword "DATE"
  `customer_name` TEXT,
  `gender` TEXT,
  `annual_income` INT DEFAULT NULL,
  `dealer_name` TEXT,
  `company` TEXT,
  `model` TEXT,
  `engine` TEXT,
  `transmission` TEXT,
  `color` TEXT,
  `price_usd` INT DEFAULT NULL COMMENT 'Renamed from "Price ($)"', -- Remove special characters
  `dealer_no` TEXT,
  `body_style` TEXT,
  `phone` INT DEFAULT NULL,
  `dealer_region` TEXT,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM car_staging;

INSERT INTO car_staging
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY 'Date', 'Customer Name', 'Annual Income', Dealer_Name, 'date', 
Phone, Dealer_Name, Car_id) as row_num
FROM car_sales;

-- Removed Duplicates by removing row number > 1

SELECT * 
FROM car_staging
WHERE row_num >1;

DELETE 
FROM car_staging
WHERE row_num >1;

-- Remove Any Colunms

SELECT *
FROM car_staging;

ALTER TABLE car_staging
DROP COLUMN row_num;

-- Format date string to proper DATE type

SELECT * 
FROM car_staging;

SELECT 
  COLUMN_NAME, 
  DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'car_staging' 
  AND COLUMN_NAME = 'sale_date';
  
SELECT sale_date
FROM car_staging
WHERE STR_TO_DATE(sale_date, '%m/%d/%Y') IS NULL
  AND sale_date IS NOT NULL;
  
SELECT sale_date
FROM car_staging
WHERE DATE(sale_date) IS NULL
  AND sale_date IS NOT NULL;
  
ALTER TABLE car_staging 
  ADD COLUMN sale_date_temp DATE;
  
UPDATE car_staging
SET sale_date_temp = STR_TO_DATE(sale_date, '%m/%d/%Y');

ALTER TABLE car_staging DROP COLUMN sale_date;

ALTER TABLE car_staging 
CHANGE COLUMN sale_date_temp sale_date DATE;

-- Break Dates into Separate Columns

ALTER TABLE car_staging
ADD COLUMN sale_month INT,
ADD COLUMN sale_day INT,
ADD COLUMN sale_year INT;

UPDATE car_staging
SET 
  sale_year = YEAR(sale_date),
  sale_month = MONTH(sale_date),
  sale_day = DAY(sale_date);
  
SELECT 
  sale_date, sale_year, sale_month, sale_day 
FROM car_staging 
LIMIT 10;

SELECT * 
FROM car_staging;

-- Replace unwanted special charachers from column

UPDATE car_staging
SET engine = REPLACE(engine, 'Ã‚Â', ' ')
WHERE engine LIKE '%Ã‚Â%';

SELECT DISTINCT engine
FROM car_staging
WHERE engine LIKE '%Overhead Camshaft%';


-- Objective 1: Exploring the Data

-- Count the number of car sales by the company

SELECT company,
	COUNT(*) as company_sales
FROM car_staging
GROUP BY company
ORDER BY company_sales DESC;

-- Find the most common body style customer have bought

SELECT company,body_style
FROM 
(
SELECT company, body_style,
	COUNT(*),
	RANK() OVER(PARTITION BY body_style 
	ORDER BY COUNT(*) DESC) AS ranking
FROM car_staging
GROUP BY company, body_style
) as t1
WHERE ranking = 1;

-- List all BMW sales in a specific year (e.g., 2023)
SELECT * 
FROM car_staging
WHERE company = 'BMW'
AND
sale_year = 2023;

-- What are the top 5 dealer region with the most sales?

SELECT dealer_region,
COUNT(car_id) as total_sales
FROM car_staging
GROUP BY 1
ORDER BY total_sales
LIMIT 5;

--- Identify the highest paid car sold

SELECT company, model, price_usd
FROM car_staging
WHERE price_usd = (SELECT MAX(price_usd) 
FROM car_staging );

-- What is the most sold car model?
SELECT company, model,
COUNT(*) AS total_sales
FROM car_staging
GROUP BY company, model
ORDER BY total_sales DESC;

-- Highest cars sold in price rang 15,000 USD to 40,000 USD

SELECT 
    company, 
    model, 
    COUNT(*) AS total_sales
FROM car_staging
WHERE price_usd BETWEEN 15000 AND 40000
GROUP BY company, model
ORDER BY total_sales DESC;
