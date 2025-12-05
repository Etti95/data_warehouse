INSERT INTO silver.erp_PX_CAT_G1V2
( id,
cat, 
subcat,
maintenance)

SELECT
id,
cat,
subcat,
maintenance

FROM bronze.erp_PX_CAT_G1V2

