## Dataset Description

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

## Outcome: 

A clean, standardized dataset ready for analyzing sales trends, dealer performance, and customer demographics.
