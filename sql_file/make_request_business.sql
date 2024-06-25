-- TASK: Create a View to show the number of Quantity sold and The Revenue made by Each Employee
CREATE OR REPLACE VIEW employee_record AS
SELECT e.employeeID,
	   e.full_name AS "Full Name",
       e.employees_title AS "Title",
	   SUM(o.quantity) AS "Quantity Sold",
       CONCAT( '$',
		  ROUND(SUM(o.unitPrice * o.quantity), 2)
          ) AS Revenue
FROM employees e JOIN
	 orders o 
     ON e.employeeID = o.employeeID
GROUP BY e.employeeID,
		 e.full_name,
         e.employees_title
ORDER BY SUM(o.unitPrice * o.quantity) DESC
;

-- To check the results of the view
SELECT *
FROM employee_record;

-- TASK: Create a Trigger on the products table that automatically removes the number of Units of product in stock, after 
-- an order has been made

-- To fist drop the Trigger if it exists
DROP TRIGGER update_products;

-- To create the trigger
DELIMITER //
CREATE TRIGGER update_products
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
UPDATE products
SET unitsInStock = products.unitsInStock - NEW.quantity
WHERE productID = NEW.productID;
END //
DELIMITER ;

-- To test the trigger, rows would be added to the Orders table
INSERT INTO orders (orderID, customerID, employeeID, orderDate, requiredDate, shippedDate, shipVia, Freight, 
	productID, unitPrice, quantity, discount)
VALUES
(10626, 'WARTH', 2, '2023-07-30', '2023-08-10', '2023-08-05', 3, 25.50, 14, 10.99, 5, 0),
(2, 102, 202, '2023-07-31', '2023-08-11', '2023-08-06', 2, 15.75, 1002, 12.49, 2, 0.05),
(3, 103, 203, '2023-08-01', '2023-08-12', '2023-08-07', 1, 10.00, 1003, 8.99, 8, 0)

;

-- TASK: Write a Procedure to list the products that needs to be restocked
/* 
Products that needs to be restocked are products that the amount of unit in stock is less
than the reorder level. So a procedure would be used to generate the list of products that fall
into this category. 

This helps the business Owner identify the products that need to be restocked
*/
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