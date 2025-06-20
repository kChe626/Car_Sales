-- US Car Sales Data Cleaning SQL Script
-- Description: Cleans and prepares car sales dataset for analysis

-- Create staging table to protect raw data
CREATE TABLE car_staging LIKE car_sales;

-- Insert raw data into staging

INSERT INTO car_staging
SELECT *
FROM car_sales;

-- Review column names
SHOW COLUMNS FROM car_staging;

-- Rename columns for clean schema
ALTER TABLE car_staging
CHANGE `Car_id` car_id VARCHAR(50),
CHANGE `Date` sale_date TEXT,
CHANGE `Customer Name` customer_name VARCHAR(100),
CHANGE `Gender` gender VARCHAR(20),
CHANGE `Annual Income` annual_income INT,
CHANGE `Dealer_Name` dealer_name VARCHAR(100),
CHANGE `Company` company VARCHAR(50),
CHANGE `Model` model VARCHAR(50),
CHANGE `Engine` engine VARCHAR(100),
CHANGE `Transmission` transmission VARCHAR(50),
CHANGE `Color` color VARCHAR(50),
CHANGE `Price ($)` price_usd INT,
CHANGE `Dealer_No` dealer_no VARCHAR(20),
CHANGE `Body Style` body_style VARCHAR(50),
CHANGE `Phone` phone BIGINT,
CHANGE `Dealer_Region` dealer_region VARCHAR(50);

-- Standardize text fields
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
    
-- Identify and remove duplicates
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

-- Convert sale_date to proper DATE type
ALTER TABLE car_staging ADD COLUMN sale_date_temp DATE;

UPDATE car_staging
SET sale_date_temp = STR_TO_DATE(sale_date, '%m/%d/%Y');

-- Check for bad dates
SELECT sale_date
FROM car_staging
WHERE sale_date_temp IS NULL AND sale_date IS NOT NULL;

-- Replace old column
ALTER TABLE car_staging DROP COLUMN sale_date;
ALTER TABLE car_staging CHANGE sale_date_temp sale_date DATE;

-- Remove unwanted characters from engine
UPDATE car_staging
SET engine = REPLACE(engine, 'Ã‚Â', ' ')
WHERE engine LIKE '%Ã‚Â%';

UPDATE car_staging
SET engine = REPLACE(engine, 'ã‚â', '')
WHERE engine LIKE '%ã‚â%';

-- Final validation
SELECT COUNT(*) AS cleaned_row_count 
FROM car_staging;

SELECT MIN(sale_date), MAX(sale_date) 
FROM car_staging;
