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


