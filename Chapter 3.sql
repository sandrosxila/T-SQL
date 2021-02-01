--1-1
SELECT E.empid, E.firstname, E.lastname, N.n 
FROM HR.Employees AS E
CROSS JOIN dbo.Nums AS N 
WHERE n <= 5

SELECT E.empid, E.firstname, E.lastname, N.n 
FROM HR.Employees AS E
CROSS JOIN (
	SELECT 100 * N1.num + 10*N2.num + N3.num + 1 AS n 
		FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS N1(num)
		CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS N2(num)
		CROSS JOIN (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS N3(num)
		WHERE 100 * N1.num + 10*N2.num + N3.num + 1 <= 5
) AS N(n) 
WHERE n <= 5
ORDER BY N.n,E.empid ASC

--1-2
SELECT E.empid, DATEADD(DAY,N.n - 1, '20090612') AS dt
FROM HR.Employees AS E
CROSS JOIN dbo.Nums AS N
WHERE n <= 5
ORDER BY E.empid ASC

SELECT E.empid, DATEADD(DAY,N.n - 1, '20090612') AS dt
FROM HR.Employees AS E
CROSS JOIN 
( VALUES (1),(2),(3),(4),(5) ) AS N(n)
WHERE n <= 5

--2
SELECT C.custid, COUNT(DISTINCT O.orderid) AS numorders, SUM (OD.qty) AS totalqty FROM Sales.Customers AS C
JOIN Sales.Orders AS O ON C.custid = O.custid
JOIN Sales.OrderDetails AS OD ON OD.orderid = O.orderid
WHERE C.country = 'USA'
GROUP BY C.custid

--3
SELECT C.custid,C.companyname,O.orderid,O.orderdate FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O ON O.custid = C.custid

--4
SELECT C.custid,C.companyname FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O ON O.custid = C.custid
WHERE O.orderid IS NULL

--5
SELECT C.custid,C.companyname,O.orderid,O.orderdate 
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON O.custid = C.custid
WHERE O.orderdate = '20070212' AND O.orderdate IS NOT NULL

--6
SELECT C.custid, C.companyname, O.orderid, O.orderdate
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON O.custid = C.custid
AND O.orderdate = '20070212'

--7
SELECT C.custid, C.companyname, CASE WHEN O.orderid IS NULL THEN 'NO' ELSE 'YES' END AS HasOrderOn20070212
FROM Sales.Customers AS C
LEFT OUTER JOIN Sales.Orders AS O
ON O.custid = C.custid
AND O.orderdate = '20070212'