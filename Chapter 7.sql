--1
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
CREATE TABLE dbo.Orders
(
orderid INT NOT NULL,
orderdate DATE NOT NULL,
empid INT NOT NULL,
custid VARCHAR(5) NOT NULL,
qty INT NOT NULL,
CONSTRAINT PK_Orders PRIMARY KEY(orderid)
);
INSERT INTO dbo.Orders(orderid, orderdate, empid, custid, qty)
VALUES
(30001, '20070802', 3, 'A', 10),
(10001, '20071224', 2, 'A', 12),
(10005, '20071224', 1, 'B', 20),
(40001, '20080109', 2, 'A', 40),
(10006, '20080118', 1, 'C', 14),
(20001, '20080212', 2, 'B', 12),
(40005, '20090212', 3, 'A', 10),
(20002, '20090216', 1, 'C', 20),
(30003, '20090418', 2, 'B', 15),
(30004, '20070418', 3, 'C', 22),
(30007, '20090907', 3, 'D', 30);

GO;

SELECT custid,orderid,qty, 
RANK() OVER (PARTITION BY custid ORDER BY qty) AS rnk,
DENSE_RANK() OVER (PARTITION BY custid ORDER BY qty) AS drnk
FROM dbo.Orders
--2
SELECT custid,orderid,qty, 
LAG(qty) OVER (PARTITION BY custid ORDER BY orderdate,orderid) - qty AS diffprev,
qty - LEAD(qty) OVER (PARTITION BY custid ORDER BY orderdate,orderid) AS diffnext
FROM dbo.Orders
--3
SELECT empid, cnt2007, cnt2008, cnt2009
FROM
(
	SELECT empid,'cnt' + CAST(YEAR(orderdate) AS VARCHAR(9)) AS orderyear,orderid FROM dbo.Orders
) AS src
PIVOT(
	COUNT(orderid) FOR orderyear IN (cnt2007, cnt2008, cnt2009)
) AS pvt
--4
GO;

IF OBJECT_ID('dbo.EmpYearOrders', 'U') IS NOT NULL DROP TABLE dbo.EmpYearOrders;
CREATE TABLE dbo.EmpYearOrders
(
empid INT NOT NULL
CONSTRAINT PK_EmpYearOrders PRIMARY KEY,
cnt2007 INT NULL,
cnt2008 INT NULL,
cnt2009 INT NULL
);
INSERT INTO dbo.EmpYearOrders(empid, cnt2007, cnt2008, cnt2009)
SELECT empid, [2007] AS cnt2007, [2008] AS cnt2008, [2009] AS cnt2009
FROM (SELECT empid, YEAR(orderdate) AS orderyear
FROM dbo.Orders) AS D
PIVOT(COUNT(orderyear)
FOR orderyear IN([2007], [2008], [2009])) AS P;

GO;

SELECT empid, REPLACE(orderyear,'cnt','') AS orderyear, unpvt.numorders
FROM dbo.EmpYearOrders
UNPIVOT
(
	numorders FOR orderyear IN (cnt2007, cnt2008, cnt2009)
) AS unpvt
WHERE numorders <> 0

--5

SELECT empid, custid, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY empid, custid
UNION ALL
SELECT empid, NULL, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY empid
UNION ALL
SELECT NULL, custid, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY custid
UNION ALL
SELECT NULL, NULL, SUM(qty) AS sumqty
FROM dbo.Orders;

SELECT GROUPING_ID(empid,custid,YEAR(orderdate)) AS grpemp, 
empid,custid,YEAR(orderdate) AS orderyear, SUM(qty) AS sumqty
FROM dbo.Orders
GROUP BY GROUPING SETS(
	(empid,custid,YEAR(orderdate)),
	(empid,YEAR(orderdate)),
	(custid,YEAR(orderdate))
)

--cleanup
IF OBJECT_ID('dbo.EmpYearOrders', 'U') IS NOT NULL DROP TABLE dbo.EmpYearOrders;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
