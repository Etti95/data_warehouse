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
