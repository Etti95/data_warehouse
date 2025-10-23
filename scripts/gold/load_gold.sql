/*
============================================================
Script: gold_views.sql
Purpose:
    This script defines the **Gold Layer** views that provide 
    clean, analytics-ready data models for business intelligence 
    and reporting. These views are built on top of curated Silver 
    layer tables and represent the final dimensional and fact 
    structures in the data warehouse.

Views created:
    1) gold.dim_customers  
       - Combines CRM and ERP data for a unified customer dimension  
       - Standardizes fields such as gender, marital status, and location  

    2) gold.dim_products  
       - Consolidates product metadata with category and maintenance info  
       - Filters out historical product records for current active products  

    3) gold.fact_sales  
       - Integrates sales transactions with product and customer dimensions  
       - Produces a clean fact table for downstream analytics and dashboards  

Usage:
    Run this script once to create or refresh Gold Layer views.
    These views can be queried directly or used as sources in BI tools.

Notes:
    - Assumes all referenced Silver layer tables are already loaded.  
    - No data transformations are persisted; all logic is view-based.  
    - ROW_NUMBER() is used for surrogate key generation for dimensional joins.

Date: 23/10/2025
============================================================
*/

-- =========================================================
-- Customer Dimension View
-- =========================================================

CREATE VIEW gold.dim_customers AS


SELECT 
    ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.CNTRY AS country,
    ci.cst_marital_status AS marital_status,
    CASE WHEN ci.cst_gndr != 'N/A' THEN ci.cst_gndr
    ELSE COALESCE(ca.GEN, 'N/A')
    END AS gender,
    ca.BDATE AS birth_date,
    ci.cst_create_date AS create_date

FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_CUST_AZ12 ca 
    ON ci.cst_key = ca.cid 
    LEFT JOIN silver.erp_LOC_A101 la 
    ON ci.cst_key = la.CID



CREATE VIEW gold.dim_products AS 
SELECT 
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) as product_key,
    pn.prd_id as product_id,
    pn.prd_key as product_number,
    pn.prd_nm as product_name,
    pn.cat_id as category_id,
    pc.subcat as subcategory,
    pc.maintenance,
    pn.prd_cost as cost,
    pn.prd_line as product_line,
    pn.prd_start_dt as start_date
    

FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_PX_CAT_G1V2 pc ON pn.cat_id = pc.id 
WHERE prd_end_dt is NULL -- filter out all historical data 



CREATE VIEW gold.fact_sales AS 

SELECT
    sd.sls_ord_num as order_number,
    pr.product_key,
    cu.customer_key, 
    sd.sls_order_dt as order_date,
    sd.sls_ship_dt as shipping_date,
    sd.sls_due_dt due_date,
    sd.sls_sales as sales_amount,
    sd.sls_quantity as price

from silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu ON sd.sls_cust_id = cu.customer_id



