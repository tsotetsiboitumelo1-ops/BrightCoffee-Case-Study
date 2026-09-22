-- Databricks notebook source
---Checking the data---
Select *
from brightcoffee.default.shop_analysis
limit 100;

---Checking the amount of transactions---
Select 
    count(*) as total_transactions
from brightcoffee.default.shop_analysis;

---Checking the table structure---
Describe brightcoffee.default.shop_analysis;

---Counting the records---
Select count(*) AS total_records
FROM brightcoffee.default.shop_analysis;

---Checking the different products---
Select Distinct 
    product_category
From brightcoffee.default.shop_analysis
Order By product_category;

---Checking the different product types---
Select Distinct 
    product_type
From brightcoffee.default.shop_analysis
Order By product_type;

---Checking the different stores---
Select Distinct
    store_id,
    store_location
FROM brightcoffee.default.shop_analysis
ORDER BY store_id;

------------------------------------------------
---Checking for duplictaes--
------------------------------------------------
Select
    transaction_id,
    Count(*) AS transaction_count
From brightcoffee.default.shop_analysis
Group by transaction_id
Having COUNT(*) > 1
Order by transaction_count DESC;

-------------------------------------------------
---Checking for zero or negative values---
------------------------------------------------
Select *
From brightcoffee.default.shop_analysis
Where transaction_qty <= 0
   Or unit_price <= 0;
----------------------------------------------
---Checking for NULL values---
----------------------------------------------
Select
    Count(*) AS total_rows,
    Count(transaction_id) AS transaction_id_values,
    Count(transaction_date) AS date_values,
    Count(transaction_time) AS time_values,
    Count(transaction_qty) AS quantity_values,
    Count(unit_price) AS price_values,
    Count(product_category) AS category_values,
    Count(product_type) AS product_type_values,
    Count(product_detail) AS product_detail_values
FROM brightcoffee.default.shop_analysis;
------------------------------------------------------
---Cleaning the data---
------------------------------------------------------
-- Converting the unit_price column into a decimal number 
SELECT unit_price,
CAST(unit_price AS DECIMAL(10,2)) AS unit_price,

-- CALCULATE REVENUE FOR EACH TRANSACTION
    ROUND(
        unit_price * transaction_qty,
        2
    ) AS total_amount
FROM brightcoffee.default.shop_analysis;

---CREATING 3HR INTERVALS
SELECT
    transaction_id,
    TO_DATE(
        transaction_date,
        'M/D/YYYY'
    ) AS transaction_date,

    transaction_time,

    -- Get the hour from the transaction time
    HOUR(transaction_time) AS transaction_hour,
    transaction_qty,
    store_id,
    store_location,
    product_id,
    product_category,
    product_type,
    product_detail,
    Cast(unit_price AS DECIMAL(10,2)) AS unit_price,

    ROUND(
        unit_price * transaction_qty,
        2
    ) AS total_amount,

    -- Create 3-hour intervals
    CASE

        WHEN HOUR(transaction_time) Between 6 AND 8
            THEN '06:00 - 08:59'

        WHEN HOUR(transaction_time) Between 9 AND 11
            THEN '09:00 - 11:59'

        WHEN HOUR(transaction_time) Between 12 AND 14
            THEN '12:00 - 14:59'

        WHEN HOUR(transaction_time) Between 15 AND 17
            THEN '15:00 - 17:59'

        WHEN HOUR(transaction_time) Between 18 AND 20
            THEN '18:00 - 20:59'
        ELSE 'Other'
    END AS transaction_time_bucket
FROM brightcoffee.default.shop_analysis;


SELECT
    transaction_id,
    TO_DATE(
        transaction_date,
        'M/D/YYYY'
    ) AS transaction_date,
    -- Date information
    YEAR(
        TO_DATE(transaction_date, 'M/D/YYYY')
    ) AS transaction_year,
    MONTH(
        TO_DATE(transaction_date, 'M/D/YYYY')
    ) AS transaction_month,
    DATE_FORMAT(
        TO_DATE(transaction_date, 'M/D/YYYY'),
        'MMMM' ----Full month
    ) AS month_name,
    DATE_FORMAT(
        TO_DATE(transaction_date, 'M/D/YYYY'),
        'EEEE' ----full name of the day of the week.
    ) AS day_name,
    transaction_time,
    HOUR(transaction_time) AS transaction_hour,
    transaction_qty,
    store_id,
    store_location,
    product_id,
    product_category,
    product_type,
    product_detail,
    CAST(unit_price AS DECIMAL(10,2)) AS unit_price,
    ROUND(unit_price * transaction_qty, 2) AS total_amount
FROM brightcoffee.default.shop_analysis;

-------------------------------------------------
--CREATING CTE
-------------------------------------------------
WITH cleaned_coffee_sales AS (
    SELECT 
    transaction_id,
    TO_DATE(
        transaction_date,
        'M/D/YYYY'
    ) AS transaction_date,
---DATE INFORMATION
YEAR ( TO_DATE (transaction_date,'M/D/YYYY')) AS transaction_year,
MONTH (TO_DATE(transaction_date, 'M/D/YYYY')) AS transaction_month,
DATE_FORMAT (TO_DATE(transaction_date, 'M/D/YYYY'), 'EEE') AS day_name,

--TIME INFORMATION
HOUR(transaction_time) AS transaction_hour,
CASE

        WHEN HOUR(transaction_time) Between 6 AND 8
            THEN '06:00 - 08:59'

        WHEN HOUR(transaction_time) Between 9 AND 11
            THEN '09:00 - 11:59'

        WHEN HOUR(transaction_time) Between 12 AND 14
            THEN '12:00 - 14:59'

        WHEN HOUR(transaction_time) Between 15 AND 17
            THEN '15:00 - 17:59'

        WHEN HOUR(transaction_time) Between 18 AND 20
            THEN '18:00 - 20:59'
        ELSE 'Other'
    END AS transaction_time_bucket,
transaction_qty,
    store_id,
    store_location,
    product_id,
    product_category,
    product_type,
    product_detail,
    CAST(unit_price AS DECIMAL(10,2)) AS unit_price,
    ROUND(unit_price * transaction_qty, 2) AS total_amount
FROM brightcoffee.default.shop_analysis
)
SELECT * 
FROM cleaned_coffee_sales;






