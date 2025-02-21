-- Exercise 1 : insert operation 
-- create a new customer, adding a new cutomer to the database 
INSERT INTO Customers (CustomerID, CompanyName, ContactName, Country) VALUES ('STUDE', 'Student Company', 'Ephrem', 'USA')
-- verify the insertion that a new cutomer is added to the Customers table of the database
SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE'
-- create a new order for the customer we add now 
--we will use the insert command 
INSERT INTO Orders (CustomerID, EmployeeID, OrderDate, ShipCountry) VALUES ('STUDE', 1, GETDATE(), 'USA')
-- to check that the order is added, let us run the next query
SELECT TOP 1 OrderID FROM Orders WHERE CustomerID = 'STUDE' ORDER BY OrderID DESC

-- update operations 
-- update customer information
-- let's change the contact name for our customer
UPDATE Customers SET ContactName = 'EPH' WHERE CustomerID = 'STUDE'
--let's verify our update for the contact name of our customer
SELECT ConatctName FROM Customers WHERE CustomerID = 'STUDE'
-- let's update the shipping country to other country by updating the order detail
UPDATE Orders SET ShipCountry = 'FRANCE' WHERE CustomerID = 'STUDE'
--verify the updated country
SELECT ShipCountry FROM Orders WHERE CustomerID = 'STUDE'

--delete operation 
-- delete the order
-- let's delete the order we created
DELETE FROM Orders WHERE CustomerID = 'STUDE'
-- let's verify that we delete the order 
SELECT OrderID, CustomerID FROM Orders WHERE CustomerID = 'STUDE'

--delete the customer
--let is remove the test customer from the database 
DELETE FROM Customers WHERE CustomerID = 'STUDE'
-- verify that the customer was deleted
SELECT CustomerID, CompanyName FROM Customers WHERE CustomerID = 'STUDE'


-- i use the sqlq shortcut when i run on the terminal 

-- part two sql practice 
--exercise 1
--adding a new supplier in to the Supliers table 
INSERT INTO Suppliers (CompanyName, ContactName, ContactTitle, Country)
VALUES ('Pop-up foods', 'Ephrem', 'Owner', 'USA' )
--verify that i added the new supplier 
SELECT * FROM Suppliers WHERE CompanyName = 'Pop-up foods'

--writing a complete insert statment in the Products table 
INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock)
VALUES ('House special pizza', 30, 2, 15.99, 50)

-- verify using the SELECT 
SELECT * FROM Products WHERE ProductName = 'House special pizza'

-- update for the product that i added in to the products table 
UPDATE Products SET UnitPrice = 13.99 WHERE ProductName = 'House special pizza'

-- verify that the unit price is updated 
SELECT UnitPrice FROM Products WHERE ProductName = 'House special pizza'

-- writing an update command to update the unit price and unit in stock 
UPDATE Products SET UnitsInStock = 25, UnitPrice = 17.99 WHERE ProductName = 'House special pizza'

-- verify the update is done 
SELECT UnitPrice, UnitsInStock FROM Products WHERE ProductName = 'House special pizza'

-- deleting the pizza that i added in to the Products table 
DELETE FROM Products WHERE ProductName = 'House special pizza'

-- verifying it is deleted
SELECT * FROM Products WHERE ProductName = 'House special pizza'

-- creating my own menu 
-- insert a new product to the Products table 
INSERT INTO Products (ProductName, SupplierID, CategoryID, UnitPrice, UnitsInStock)
VALUES ('Double cheese burger', 30, 2, 10.99, 45)

-- verifying the product is added
SELECT * FROM Products WHERE ProductName = 'Double cheese burger'

-- update the unit price and units in stock for the product that i added now 
UPDATE Products SET UnitPrice = 12.99, UnitsInStock = 30 WHERE ProductName = 'Double cheese burger'
-- verifying the values are updated 
SELECT UnitPrice, UnitsInStock FROM Products WHERE ProductName = 'Double cheese burger'

-- deleting the double cheese burger from the products table 
DELETE FROM Products WHERE ProductName = 'Double cheese burger'
-- verify the products is deleted
SELECT * FROM Products WHERE ProductName = 'Double cheese burger'



