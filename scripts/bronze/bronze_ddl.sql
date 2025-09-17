/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' database, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' Tables
===============================================================================
*/


DROP TABLE IF EXISTS bronze.crm_cust_info;

create table bronze.crm_cust_info( cst_id int ,
cst_key varchar(50),
cst_firstname varchar(50),
cst_lastname varchar(50),
cst_marital_status varchar(50),
cst_gndr varchar(50),
cst_create_date DATE);


DROP TABLE IF EXISTS bronze.crm_prd_info;

create table bronze.crm_prd_info(
prd_id int,
prd_key varchar(50),
prd_nm varchar(50),
prd_cost int,
prd_line  varchar(50),
prd_start_dt date,
prd_end_dt date);


DROP TABLE IF EXISTS bronze.crm_sales_details;


create table bronze.crm_sales_details(
sls_ord_num varchar(50),
sls_prd_key varchar(50),
sls_cust_id int,
sls_order_dt date,
sls_ship_dt date,
sls_due_dt	date,
sls_sales int,
sls_quantity int,
sls_price float);

DROP TABLE IF EXISTS bronze.erp_CUST_AZ12;

create table bronze.erp_CUST_AZ12(
CID varchar(50),
BDATE date,
GEN varchar(50));

DROP TABLE IF EXISTS bronze.erp_LOC_A101;

create table bronze.erp_LOC_A101(
CID varchar(50),
CNTRY varchar(50)

);
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;


create table bronze.erp_px_cat_g1v2(
ID varchar(50),
CAT varchar(50),
SUBCAT varchar(50),
MAINTENANCE varchar(50)
);



SET GLOBAL local_infile = 1;

truncate bronze.crm_cust_info;
LOAD DATA LOCAL INFILE 'D:\\data_ware\\datasets\\source_crm\\crm_cust_info.csv'
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(cst_id, cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, @cst_create_date)
SET cst_create_date = STR_TO_DATE(@cst_create_date, '%Y-%m-%d');


truncate bronze.crm_prd_info;
LOAD DATA LOCAL INFILE 'D:\\data_ware\\datasets\\source_crm\\crm_prd_info.csv'
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(prd_id, prd_key, prd_nm, prd_cost, prd_line,
 @raw_prd_start_dt, @raw_prd_end_dt)
SET 
  prd_start_dt = STR_TO_DATE(TRIM(REPLACE(@raw_prd_start_dt, '\r', '')), '%d-%m-%Y'),
  prd_end_dt   = STR_TO_DATE(TRIM(REPLACE(@raw_prd_end_dt, '\r', '')), '%d-%m-%Y');



truncate bronze.crm_sales_details;
load data local infile 'D:\\data_ware\\datasets\\source_crm\\crm_sales_details.csv'
into table bronze.crm_sales_details
fields terminated by ',' 
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows
(sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price);



select count(*) from bronze.crm_sales_details;

truncate bronze.erp_cust_az12;
 load data local infile 'D:\\data_ware\\datasets\\source_erp\\erp_CUST_AZ12.csv'
 into table bronze.erp_cust_az12
 fields terminated by ','
 optionally enclosed by '"'
 lines terminated by '\r\n'
 ignore 1 rows
 (CID,@raw_BDATE,GEN)
 set
 BDATE=STR_TO_DATE(TRIM(REPLACE(@raw_BDATE, '\r', '')), '%d-%m-%Y');
 
 
  truncate bronze.erp_loc_a101;
 load data local infile 'D:\\data_ware\\datasets\\source_erp\\erp_LOC_A101.csv'
 into table bronze.erp_loc_a101
 fields terminated by ','
 optionally enclosed by '"'
 lines terminated by '\n'
 ignore 1 rows 
 (CID,CNTRY);

use bronze;
show tables;

truncate bronze.erp_px_cat_g1v2;
load data local infile 'D:\\data_ware\\datasets\\source_erp\\erp_PX_CAT_G1V2.csv'
into table bronze.erp_px_cat_g1v2
fields terminated by ','
optionally enclosed by '"'

 lines terminated by '\n'
ignore 1 rows
(ID,CAT,SUBCAT,MAINTENANCE);

