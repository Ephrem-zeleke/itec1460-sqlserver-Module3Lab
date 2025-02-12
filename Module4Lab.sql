--join customers and orders tables because the customer id is a field
SELECT C.CompanyName, O.OrderDate FROM Customers AS c JOIN Orders AS o ON c.CustomerID = o.CustomerID;
--query to see all customers (left table ) and the orders table(right table)
--uses a left join (order date and order id will be null if the customer exists but has no orders)
SELECT c.CustomerID, c.CompanyName, o.OrderID, o.OrderDate FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;

--example of using built in function SUM(), ROUND(), and COUNT()
SELECT OrderID, ROUND(SUM(UnitPrice * Quantity * (1-Discount)),2) AS TotalValue, COUNT(*) AS NumberOfItem FROM [Order Details] GROUP BY OrderID ORDER BY TotalValue DESC /* shows the highst value first*/

-- example of using group by with a having clause
SELECT p.ProductID, p.ProductName, COUNT(od.OrderID) AS TimesOrdered FROM Products p INNER JOIN [Order Detailes] od ON p.ProductID = od.ProductID GROUP BY p.ProductID, p.ProductName HAVING COUNT(od.OrderID) > 10
ORDER BY TimesOrdered DESC;

--subquery example
SELECT ProductName, UnitPrice FROM Products WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products) ORDER BY UnitPrice;

-- this query we limit the result to the top 5 records
SELECT TOP 5 
c.CustomerID, c.CompanyName, 
ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalPurchase 
FROM Customers c 
INNER JOIN Orders o ON c.CustomerID = o.CustomerID 
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID 
WHERE YEAR(o.OrderDate) = 1997  
GROUP BY c.CustomerID, c.CompanyName 
ORDER BY TotalPurchase DESC;
USE Northwind; -- Ensure you're in the correct database

SELECT 
    o.CustomerID, 
    CAST(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS DECIMAL(18,2)) AS TotalRevenue,
    COUNT(DISTINCT o.OrderID) AS OrderCount
FROM dbo.Orders o
JOIN dbo.[Order Details] od ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = 1997
GROUP BY o.CustomerID
ORDER BY TotalRevenue DESC;

