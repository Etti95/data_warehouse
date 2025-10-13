/*
============================================================
 Script Name:    Create_DataWarehouse.sql
 Description:    This script recreates the DataWarehouse database 
                 in SQL Server. It drops the existing database if it 
                 already exists (forcing single-user mode), then 
                 creates a new one and initializes the standard 
                 schemas for data lake architecture: bronze, silver, and gold.

 Author:         Etiosa Richmore
 Created On:     2025-10-13
 Last Updated:   2025-10-13
============================================================
*/

USE master;


IF EXISTS (SELECT 1 FROM sys.databases WHERE 'name' = 'DataWarehouse')
  BEGIN 
    ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE DataWarehouse;
END;
GO


-- create datawarehouse database
  
CREATE DATABASE DataWarehouse;

USE DataWarehouse;

-- Create Schemas

CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;



IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
    cst_id INT,
    cst_key NVARCHAR(50),
    cst_firstname NVARCHAR(50),
    cst_lastname NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr NVARCHAR(50),
    cst_create_date DATE
);

IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (

    prd_id INT, 
    prd_key NVARCHAR(50),
    prd_nm NVARCHAR(50),
    prd_cost INT,
    prd_line NVARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);

IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),
    sls_prd_key NVARCHAR(50),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales INT,
    sls_quantity INT,
    sls_price INT
    
);

IF OBJECT_ID ('bronze.erp_CUST_AZ12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_CUST_AZ12;
CREATE TABLE bronze.erp_CUST_AZ12 (
    CID VARCHAR(50),
    BDATE DATE,
    GEN NVARCHAR
);

IF OBJECT_ID ('bronze.erp_LOC_A101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_LOC_A101;
CREATE TABLE bronze.erp_LOC_A101 (
    CID VARCHAR(50),
    CNTRY VARCHAR(50)
);

IF OBJECT_ID ('bronze.erp_PX_CAT_G1V2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_PX_CAT_G1V2;
CREATE TABLE bronze.erp_PX_CAT_G1V2 (
    ID VARCHAR(50),
    CAT VARCHAR(50),
    SUBCAT NVARCHAR(50),
    MAINTENANCE VARCHAR(50)
);


