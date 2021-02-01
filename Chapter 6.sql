--1
SELECT 1 AS N
UNION ALL
SELECT 2
UNION ALL
SELECT 3
UNION ALL
SELECT 4
UNION ALL
SELECT 5
UNION ALL
SELECT 6
UNION ALL
SELECT 7
UNION ALL
SELECT 8
UNION ALL
SELECT 9
UNION ALL
SELECT 10
--2
SELECT custid,empid FROM Sales.Orders
WHERE (YEAR(orderdate) = 2008 AND MONTH(orderdate) = 1)
EXCEPT
SELECT custid,empid FROM Sales.Orders
WHERE (YEAR(orderdate) = 2008 AND MONTH(orderdate) = 2)
--3
SELECT custid,empid FROM Sales.Orders
WHERE (YEAR(orderdate) = 2008 AND MONTH(orderdate) = 1)
INTERSECT
SELECT custid,empid FROM Sales.Orders
WHERE (YEAR(orderdate) = 2008 AND MONTH(orderdate) = 2)
--4
SELECT custid,empid FROM Sales.Orders
WHERE (YEAR(orderdate) = 2008 AND MONTH(orderdate) = 1)
INTERSECT
SELECT custid,empid FROM Sales.Orders
WHERE (YEAR(orderdate) = 2008 AND MONTH(orderdate) = 2)
EXCEPT
SELECT custid,empid FROM Sales.Orders
WHERE YEAR(orderdate) = 2007
--5
SELECT country, region, city
FROM (
	SELECT country, region, city, 1 AS TABLEID
	FROM HR.Employees
	UNION ALL
	SELECT country, region, city, 2 AS TABLEID
	FROM Production.Suppliers
) AS T
ORDER BY TABLEID,country,region,city