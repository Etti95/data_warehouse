/* 
============================================================
Script: bronze.load_bronze
Purpose: 
    This stored procedure automates the data loading process 
    into the Bronze Layer of the data warehouse. It performs 
    the following actions:
        - Truncates existing Bronze tables for CRM and ERP datasets
        - Loads fresh data from corresponding CSV source files
        - Logs the duration of each table load for performance tracking
        - Handles and reports any errors encountered during execution

Author: [Your Name]
Date: [Insert Date]
============================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME;
    BEGIN TRY
        PRINT '=======================';
        PRINT 'Loading Bronze Layer';
        PRINT '=======================';

        PRINT '=======================';
        PRINT 'Loading CRM Tables';
        PRINT '=======================';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM '/data/source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM '/data/source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM '/data/source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        PRINT '=======================';
        PRINT 'Loading ERP Tables';
        PRINT '=======================';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_CUST_AZ12;

        BULK INSERT bronze.erp_CUST_AZ12
        FROM '/data/source_erp/CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_LOC_A101;

        BULK INSERT bronze.erp_LOC_A101
        FROM '/data/source_erp/LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';

        SET @start_time = GETDATE();
        TRUNCATE TABLE bronze.erp_PX_CAT_G1V2;

        BULK INSERT bronze.erp_PX_CAT_G1V2
        FROM '/data/source_erp/PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>>------------------';

        SET @batch_end_time = GETDATE();
        PRINT'====================='
        PRINT 'Loading Bronze Layer is Completed';
        PRINT ' - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
        PRINT'====================='

    END TRY
    BEGIN CATCH
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
        PRINT 'Error Message' + ERROR_MESSAGE();

    END CATCH
END
