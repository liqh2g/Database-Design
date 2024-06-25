-- DB creation

DROP DATABASE IF EXISTS db_northwind;

-- creating the database using character encoding of utf-8
CREATE DATABASE db_northwind DEFAULT CHARACTER SET utf8mb4;

-- to check if the database was created 
SELECT * 
FROM information_schema.columns
WHERE TABLE_SCHEMA = "northwind"

-- CREATING THE TABLE

USE db_northwind;

-- To drop the table if it exists
DROP TABLE IF EXISTS TblNorthwind;

-- TO create the table for the northwind data
CREATE TABLE TblNorthwind (
    orderID INT,
    customerID INT,
    employeeID INT,
    orderDate DATE,
    requiredDate DATE,
    shippedDate DATE,
    shipVia INT,
    Freight DECIMAL(10,2),
    productID INT,
    unitPrice DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    companyName VARCHAR(255),
    contactName VARCHAR(255),
    contactTitle VARCHAR(255),
    lastName VARCHAR(255),
    firstName VARCHAR(255),
    title VARCHAR(255),
    productName VARCHAR(255),
    supplierID INT,
    categoryID INT,
    quantityPerUnit VARCHAR(255),
    unitPrice_1 DECIMAL(10,2),
    unitsInStock INT,
    unitsOnOrder INT,
    reorderLevel INT,
    discontinued TINYINT,
    categoryName VARCHAR(255),
    supplierCompanyName VARCHAR(255),
    supplierContactName VARCHAR(255),
    supplierContactTitle VARCHAR(255)
);

-- INSERTING DATA INTO THE CREATED TABLE

LOAD DATA LOCAL INFILE './data/Northwind.csv' -- table path
INTO TABLE TblNorthwind
FIELDS TERMINATED BY ',' -- csv file
ENCLOSED BY '"' -- for the strings
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- ignore the headers

-- to check the table for the loaded data
SELECT *
FROM TblNorthwind;