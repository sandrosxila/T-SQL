--1
SELECT orderid,orderdate,custid,empid FROM [Sales].Orders WHERE YEAR(orderdate) = 2007 AND MONTH(orderdate) = 6
--2
SELECT orderid,orderdate,custid,empid FROM [Sales].Orders WHERE DAY(orderdate + 1) = 1
--3
SELECT empid,firstname,lastname FROM HR.Employees WHERE LEN(lastname) - LEN(REPLACE(lastname,'a',''))= 2
--4
SELECT orderid,SUM(qty * unitprice) AS totalValue 
FROM Sales.OrderDetails 
GROUP BY orderid
HAVING SUM(qty * unitprice) > 10000
ORDER BY totalValue DESC
--5
SELECT TOP(3) shipcountry, AVG(freight) AS avgfreight
FROM Sales.Orders
WHERE YEAR(orderdate) = 2007
GROUP BY shipcountry
ORDER BY avgfreight DESC
--6
SELECT custid, orderdate, orderid, ROW_NUMBER() OVER (PARTITION BY custid ORDER BY orderdate) AS rownum
FROM Sales.Orders
ORDER BY custid
--7
SELECT empid,firstname,lastname,titleofcourtesy, 
CASE titleofcourtesy 
	WHEN 'Mr.' THEN 'Male'
	WHEN 'Ms.' THEN 'Female'
	WHEN 'Mrs.' THEN 'Female'
	ELSE 'unknown'
	END AS gender
FROM HR.Employees
--8
SELECT custid,region FROM Sales.Customers ORDER BY CASE WHEN region IS NULL THEN 1 ELSE 0 END, region