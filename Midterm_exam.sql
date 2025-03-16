--1. SQL SELECT:

--You're giving awards to employees based on the year they started working at Northwind.
--Write a query to list all employees (FirstName, LastName) along with their start date.

SELECT FirstName, LastName, HireDate
FROM Employees
ORDER BY HireDate;

/* 2. sql join
Create a simple report showing which employees are handling orders. Write a query that:

1. Lists employee names (FirstName and LastName)
2. Shows the OrderID for each order they've processed
3. Shows the OrderDate
4. Sorts the results by EmployeeID and then OrderDate

This basic report will help us see which employees are actively processing orders in the Northwing system.
*/

SELECT 
    e.FirstName,
    e.LastName,
    o.OrderID,
    o.OrderDate
FROM 
    Employees e 
INNER JOIN
    Orders AS o ON e.EmployeeID = o.EmployeeID
ORDER BY
    e.EmployeeID,
    o.OrderDate;

/* 3. Functions and GROUP BY:
Create a simple report showing total sales by product category. Include the CategoryName and TotalSales 
(calculated as the sum of UnitPrice * Quantity). Sort your results by TotalSales in descending order.
*/

SELECT
    c.CategoryName,
    SUM(od.UnitPrice * od.Quantity) AS TotalSales
FROM
    Categories c 
INNER JOIN
    Products p ON c.CategoryID = p.CategoryID
INNER JOIN
    [Order Details] od ON p.ProductID = od.ProductID
GROUP BY
    c.CategoryName
ORDER BY
    TotalSales DESC;

/* 4. SQL insert statements

Complete the following tasks:

Insert a new supplier named "Northwind Traders" based in Seattle, USA.
Create a new category called "Organic Products".
Insert a new product called "Minneapolis Pizza". You can choose the category, supplier, and other values.
*/
INSERT INTO Suppliers (CompanyName, City, Country)
VALUES ('Northwind Traders', 'Seattle', 'USA');
-- the CateroryName in the Categories table doesn't have enough space to spell oragnic products 
-- so we need to update the CategorieName string character in the categories table 
ALTER TABLE Categories
ALTER COLUMN CategoryName NVARCHAR(20);


INSERT INTO Categories (CategoryName)
VALUES ('Organic Products');


INSERT INTO Products (
    ProductName,
    SupplierID,
    CategoryID,
    QuantityPerUnit,
    UnitPrice,
    UnitsInStock,
    UnitsOnOrder,
    ReorderLevel,
    Discontinued
)
VALUES(
    'Minneapolis Pizza',
    (SELECT SupplierID FROM Suppliers WHERE CompanyName = 'Northwind Traders'), -- SupplierID
    (SELECT CategoryID FROM Categories WHERE CategoryName = 'Organic Products'), -- CategoryID
    '12 slices',
    15.99,
    100,
    0,
    10,
    0
);

/* 5. SQL update statement 
Update all products from supplier "Exotic Liquids" to belong to the new "Organic Products" category.
*/

UPDATE Products
SET CategoryID = (
    SELECT CategoryID
    FROM Categories
    WHERE CategoryName = 'Organic Products'
)
WHERE SupplierID = (
    SELECT SupplierID
    FROM Suppliers
    WHERE CompanyName = 'Exotic Liquids'
);

/* 6. SQL Delete statement 
Remove the product "Minneapolis Pizza".
*/

DELETE FROM Products
WHERE ProductName = 'Minneapolis Pizza';

/* 7. creating tables and constraints 
Create a new table named "EmployeePerformance" with the following columns:

PerformanceID (int, primary key, auto-increment)
EmployeeID (int, foreign key referencing Employees table)
Year (int)
Quarter (int)
SalesTarget (decimal(15,2))
ActualSales (decimal(15,2))
Hint: Remember to add a foreign key constraint to the EmployeeID column so that 
EmployeeID is a foreign key in the Employee Performance table that references the EmployeeID that is the primary key in the employees table. 
This will establish a relationship between Employees and EmployeePerformance.
*/

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'EmployeePerformance')
    DROP TABLE EmployeePerformance;

CREATE TABLE EmployeePerformance (
    PerformanceID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT FOREIGN KEY REFERENCES Employees(EmployeeID),
    Year INT,
    Quarter INT,
    SalesTarget DECIMAL(15, 2),
    ActualSales DECIMAL(15, 2)
);

/* 8. creating views
Create a view named "vw_ProductInventory" that shows ProductName, CategoryName, UnitsInStock, and UnitsOnOrder for all products.
*/


