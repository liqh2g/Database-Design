-- To get the column names of the dataset
DESCRIBE TblNorthwind;

-- TO CREATE THE CUSTOMER TABLE
CREATE TABLE IF NOT EXISTS customers AS
SELECT DISTINCT customerID,
	   companyName,
       contactName,
       contactTitle       
FROM TblNorthwind;

-- To check if the table was created and the data was loaded
SELECT *
FROM customers;

-- TO CREATE THE CATEGORIES TABLE
CREATE TABLE IF NOT EXISTS categories AS 
SELECT DISTINCT categoryID,
	   categoryName
FROM TblNorthwind
ORDER BY categoryID;

-- To check if the table was created and the data was loaded
SELECT *
FROM categories;

-- TO CREATE THE SUPPLIERS TABLE
CREATE TABLE IF NOT EXISTS suppliers AS
SELECT DISTINCT supplierID,
	   suppliers_companyName AS companyName,
       suppliers_contactName AS contactName,
       suppliers_contactTitle AS contactTitle
FROM TblNorthwind
ORDER BY supplierID;


-- To check if the table was created and the data was loaded
SELECT *
FROM suppliers;

-- TO CREATE THE PRODUCT TABLE
CREATE TABLE IF NOT EXISTS products AS
SELECT DISTINCT productID,
	   productName,
       categoryID,
       supplierID,
       quantityPerUnit,
       product_unitPrice,
	   unitsInStock,
	   unitsOnOrder,
	   reorderLevel,
	   discontinued
FROM TblNorthwind
ORDER BY productID;

-- To check if the table was created and the data was loaded
SELECT *
FROM products;


-- TO CREATE THE EMPLOYEES TABLE
CREATE TABLE IF NOT EXISTS employees AS
SELECT DISTINCT employeeID,
       employees_lastName,
       employees_firstName,
       CONCAT(employees_firstName, ' ', employees_lastName) AS full_name,
       employees_title
FROM TblNorthwind
ORDER BY employeeID;

-- To check if the table was created and the data was loaded
SELECT *
FROM employees;

-- TO CREATE THE ORDERS TABLE
CREATE TABLE IF NOT EXISTS orders AS
SELECT orderID,
	   customerID,
       employeeID,
       STR_TO_DATE(orderDate, '%m/%d/%Y') orderDate,
       STR_TO_DATE(requiredDate, '%m/%d/%Y') requiredDate,
       STR_TO_DATE(shippedDate, '%m/%d/%Y') shippedDate,
       shipVia,
       Freight,
       productID,
       unitPrice,
       quantity,
       discount
FROM TblNorthwind
ORDER BY orderID;


-- To check if the table was created and the data was loaded
SELECT *
FROM orders;

-- ALTER TABLE CONSTRAINTS
/* 
In this section, I would be altering the table constraints of the respective tables in the database
*/

-- FOR THE CATEGORIES TABLE
DESCRIBE categories;

-- From observing the table, the category ID should be a Primary key (NOT NULL & UNIQUE) and AUTO INCREMENT. 
-- The CategoryName column should be not be null and it should be Unique. The datatype should be VARCHAR(255)
-- To Alter the table constraints below

ALTER TABLE categories
MODIFY categoryID INT AUTO_INCREMENT PRIMARY KEY, -- For Category ID
MODIFY categoryName VARCHAR(255) NOT NULL UNIQUE; -- For Category Name

-- FOR THE CUSTOMERS TABLE
DESCRIBE customers;

/* 
From observing the table, the customerID is the Primary Key. The Company Name, Contact Name and Contact Title
column should not be null. 
*/

ALTER TABLE customers 
CHANGE COLUMN customerID customerID CHAR(5) NOT NULL ,
CHANGE COLUMN companyName companyName VARCHAR(255) NOT NULL ,
CHANGE COLUMN contactName contactName VARCHAR(255) NOT NULL ,
CHANGE COLUMN contactTitle contactTitle VARCHAR(255) NOT NULL ,
ADD PRIMARY KEY (customerID);
;

-- FOR THE SUPPLIERS TABLE
DESCRIBE suppliers;

/* 
From observing the columns in the table, the supplierID is the Primary Key and AUTO INCREMENT. The companyname, contactname 
and contactTitle should not be null
*/

ALTER TABLE suppliers 
CHANGE COLUMN supplierID supplierID INT NOT NULL AUTO_INCREMENT ,
CHANGE COLUMN companyName companyName VARCHAR(255) NOT NULL ,
CHANGE COLUMN contactName contactName VARCHAR(255) NOT NULL ,
CHANGE COLUMN contactTitle contactTitle VARCHAR(255) NOT NULL ,
ADD PRIMARY KEY (supplierID),
ADD UNIQUE INDEX supplierID_UNIQUE (supplierID ASC) VISIBLE;
;


-- FOR THE EMPLOYEES TABLE
DESCRIBE employees;

/* 
From observing the table, the Employee ID is the Primary Key & Auto Increment then other columns are Not Null and the Data type
would be changed to VARCHAR(255)
*/

ALTER TABLE employees
CHANGE COLUMN employeeID employeeID INT NOT NULL AUTO_INCREMENT ,
CHANGE COLUMN employees_lastName employees_lastName VARCHAR(255) NOT NULL ,
CHANGE COLUMN employees_firstName employees_firstName VARCHAR(255) NOT NULL ,
CHANGE COLUMN full_name full_name VARCHAR(255) NOT NULL ,
CHANGE COLUMN employees_title employees_title VARCHAR(255) NOT NULL ,
ADD PRIMARY KEY (employeeID);
;


-- FOR THE PRODUCTS TABLE
DESCRIBE products;

/* 
From my Observation, Product ID is the Primary Key, Category ID and Supplier ID are Foreign keys. Discontinued is a Boolean 
so it would be TinyINT since MySQL doesnt support Boolean. The Unit Price should be a Decimal Data Type. 
*/ 

ALTER TABLE products 
CHANGE COLUMN productID productID INT NOT NULL ,
CHANGE COLUMN productName productName VARCHAR(255) NOT NULL ,
CHANGE COLUMN quantityPerUnit quantityPerUnit VARCHAR(255) NULL DEFAULT NULL ,
CHANGE COLUMN product_unitPrice product_unitPrice DECIMAL(10,2) NULL DEFAULT NULL ,
CHANGE COLUMN discontinued discontinued TINYINT NULL DEFAULT NULL ,
ADD PRIMARY KEY (productID),
ADD UNIQUE INDEX productName_UNIQUE (productName ASC) VISIBLE,
ADD INDEX Supplier_fk_idx (supplierID ASC) VISIBLE,
ADD INDEX Category_fk_idx (categoryID ASC) VISIBLE;
;

-- To Include the Foreign key for Supplier ID and Category ID
ALTER TABLE products 
ADD CONSTRAINT Supplier_fk
  FOREIGN KEY (supplierID)
  REFERENCES db_northwind.suppliers (supplierID)
  ON DELETE CASCADE 
  ON UPDATE RESTRICT,
ADD CONSTRAINT Category_fk
  FOREIGN KEY (categoryID)
  REFERENCES db_northwind.categories (categoryID)
  ON DELETE CASCADE 
  ON UPDATE RESTRICT;
  

-- FOR THE ORDERS TABLE
DESCRIBE orders;

/* AFter observing the tabel, the following constraints were added to the table */

ALTER TABLE orders 
CHANGE COLUMN orderID orderID INT NOT NULL ,
CHANGE COLUMN customerID customerID CHAR(5) NULL DEFAULT NULL ,
CHANGE COLUMN productID productID INT NOT NULL ,
CHANGE COLUMN unitPrice unitPrice DOUBLE NOT NULL ,
CHANGE COLUMN quantity quantity INT NOT NULL ,
ADD INDEX employee_fk_idx (employeeID ASC) VISIBLE,
ADD INDEX customer_fk_idx (customerID ASC) VISIBLE,
ADD INDEX product_fk_idx (productID ASC) VISIBLE;


-- To add the foreign key to the tables
ALTER TABLE db_northwind.orders 
ADD CONSTRAINT employee_fk
  FOREIGN KEY (employeeID)
  REFERENCES db_northwind.employees (employeeID)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT customer_fk
  FOREIGN KEY (customerID)
  REFERENCES db_northwind.customers (customerID)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT product_fk
  FOREIGN KEY (productID)
  REFERENCES db_northwind.products (productID)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;