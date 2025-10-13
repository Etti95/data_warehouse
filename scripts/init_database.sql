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


