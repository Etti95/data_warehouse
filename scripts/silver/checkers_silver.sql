--- Check for nulls

SELECT 
DISTINCT prd_id,
COUNT(*)

FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL


--- check for unwanted spaces

SELECT prd_nm
FROM silver.crm_prd_info

WHERE prd_nm != TRIM(prd_nm)


---- Data Standardization
SELECT DISTINCT prd_line
FROM silver.crm_prd_info


-- check for nulls
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Check for invalid Date Orders
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- Identify Out-of-range dates
SELECT DISTINCT 

BDATE
FROM 
    silver.erp_CUST_AZ12
    WHERE BDATE < '1924-01-01' OR BDATE > GETDATE()


--- STANDARDIZATION

SELECT DISTINCT 
GEN,
CASE WHEN UPPER(REPLACE(REPLACE(REPLACE(TRIM(GEN), CHAR(160), ''), CHAR(13), ''), CHAR(10), '')) IN ('F','FEMALE') THEN 'Female'
     WHEN UPPER(REPLACE(REPLACE(REPLACE(TRIM(GEN), CHAR(160), ''), CHAR(13), ''), CHAR(10), '')) IN ('M','MALE')   THEN 'Male'
    ELSE 'N/A'
  END AS GEN
FROM silver.erp_CUST_AZ12


-- Invalid dates

SELECT 
NULLIF(sls_due_dt, 0) sls_due_dt
FROM silver.crm_sales_details
WHERE sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 
OR sls_due_dt > 20500101
OR sls_due_dt < 19000101


-- invalid date orders

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

--- Data consistency between Sales, Quantity and Price
--> Sales = Quantity * price

SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price


FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price


SELECT * 
FROM silver.crm_sales_details