# Building A Business Database
## Overview - simulated situations
A business owner approached me seeking assistance in creating a brand-new database for their company. They needed a database built from scratch to efficiently manage their business operations. I gladly accepted the challenge and embarked on the journey of designing a robust and tailored database solution to meet their unique needs.

The business data is currently on an excel file. You can download the Excel file here. A snapshot of the data is seen below. The data has 31 columns and 1000 rows. The Database Management System used for this project is MySQL (MySQL WorkBench).

After reviewing the data structure and the steps needed to help the business, I have broken down these steps into the following steps
- Creating DB and loading data
- Normalization and denormalization
- Data Modeling
- Views, Triggers, and Stored Procedures
- User Management and Privileges 
- Database Backup


## Creating DB and loading data
Before creating the database, the data on excel was examined and cleaned then saved in a CSV format.
Cleaning steps involves
- Ensuring Date types are in "yyyy-mm-dd"
- Ensuring the right number format is used. Presence of currency symbols or comma separators or any symbols are not allowed

The next step is to create a database and load the data into my database.

``` sql
-- Dropping the database if it exists 
DROP DATABASE IF EXISTS db_northwind;

-- creating the database using character encoding of utf-8
CREATE DATABASE db_northwind DEFAULT CHARACTER SET utf8mb4;

-- to check if the database was created 
SHOW DATABASES;

-- to make the db_northwind database the active database 
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
    product_unitPrice DECIMAL(10,2),
    unitsInStock INT,
    unitsOnOrder INT,
    reorderLevel INT,
    discontinued TINYINT,
    categoryName VARCHAR(255),
    supplier_CompanyName VARCHAR(255),
    supplier_ContactName VARCHAR(255),
    supplier_ContactTitle VARCHAR(255)
);

-- INSERTING DATA INTO THE CREATED TABLE
LOAD DATA LOCAL INFILE './Northwind.csv' 

INTO TABLE TblNorthwind
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS; -- ignore the headers

-- Check the table for the loaded data
SELECT *
FROM TblNorthwind;
```

## Normalization and Denormalization
---
After observing the imported data, I noticed the data is denormalized. This brings me to my next step, Data Normalization

Normalization involves organizing data based on assigned attributes as a part of a larger data model. The main objective of database normalization is to eliminate redundant data, minimize data modification errors, and simplify the query process.

After Normalizing the table, The table was sub-divided into the following entities
- `Customers`
- `Categories`
- `Suppliers`
- `Products`
- `Orders`
- `Employees`

## Data Modeling
The next step is to design an ERD. This diagram use symbols to represent entities, attributes, and relationships, which help to illustrate the relationships between the entities in the database. 

![Database Schema](./image_file/Database%20ERD%20Model.png)


## Creating Views, Triggers, and Stored Procedures

- Create a view that shows the number of Quantity sold and The Revenue made by Each Employee
- Create a Trigger on the products table that automatically removes the number of Units of product in stock, after an order has been made
- Write a Procedure to check if a certain products needs to be restocked and also list the products that needs to be restocked

Below is the scripts used to write the stored procedure

``` sql
-- Creating a stored procedure

DELIMITER $$
CREATE PROCEDURE getRestock_products ( IN product_name VARCHAR(255))
BEGIN
-- TAKING THE LOWER CASE OF THE INPUT PARAMETER
SET product_name = LOWER(product_name);
-- To check if a certain product needs to be restocked
SELECT productName,
    CASE WHEN unitsInStock < reorderLevel THEN "Restock Level reached"
       WHEN unitsInStock = reorderLevel THEN "On Restock Level"
       WHEN unitsInStock - reorderLevel <= 5 THEN "Close to Restock Level"
       ELSE "Above Restocked Level"
       END AS "Restock Status"
FROM products
WHERE LOWER(productName) LIKE CONCAT('%', product_name, '%');

-- Products that needs to be restocked
SELECT productID,
    productName,
       unitsInStock,
       reorderLevel
FROM products
WHERE unitsInStock < reorderLevel;
END $$
DELIMITER ;

```
## User Management and Privileges
The business Owner requested two users; a DBA and a DA and grant them some privileges on the database.

I created two Users and give them access to the database. The first user, "DBAmember", will be a DBA, and should get full database administrator privileges. The second user, "DAmember" is an Analyst and only need read access.

Designing a database also entails User Management, Granting and Revoking User privileges. This would be done using SQL commands GRANT and REVOKE.

## Database Backup
The primary purpose of backing up a database is to create a duplicate copy of its data and structure at a specific point in time. This process involves making a snapshot of the entire database or selected portions of it, and storing this copy in a secure location.

This database was backed up on a Hard Drive using MySQL local instance Data Export feature or using mysqldump command.