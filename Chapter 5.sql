--1-1
SELECT empid, MAX(orderdate) AS maxorderdate 
FROM Sales.Orders
GROUP BY empid;
--1-2
WITH MAXDATES(empid,orderdate) AS (
	SELECT empid, MAX(orderdate) AS orderdate 
	FROM Sales.Orders
	GROUP BY empid
)
SELECT empid,orderdate, orderid, custid 
FROM Sales.Orders AS S
WHERE EXISTS (SELECT MAXDATES.orderdate FROM MAXDATES WHERE MAXDATES.empid = S.empid AND MAXDATES.orderdate = S.orderdate)
--2-1
WITH ORDEREDTABLE AS (
	SELECT O.orderid,O.orderdate,O.custid,O.empid,ROW_NUMBER() OVER (ORDER BY O.orderdate,O.orderid) AS rownum 
	FROM Sales.Orders AS O
)
SELECT ORDEREDTABLE.orderid, ORDEREDTABLE.custid, ORDEREDTABLE.empid, ORDEREDTABLE.rownum
FROM ORDEREDTABLE
WHERE ORDEREDTABLE.rownum > 10 AND ORDEREDTABLE.rownum <= 20
--3
WITH DFS(firstname,lastname,empid,mgrid) AS (
	SELECT firstname,lastname,empid,mgrid 
	FROM HR.Employees
	WHERE empid = 9

	UNION ALL

	SELECT E.firstname, E.lastname, E.empid, E.mgrid
	FROM DFS AS D
	JOIN HR.Employees AS E
	ON D.mgrid = E.empid
)
SELECT DFS.empid, DFS.mgrid, DFS.firstname, DFS.lastname
FROM DFS
GO
--4-1
CREATE VIEW Sales.VEmpOrders AS
SELECT empid,YEAR(orderdate) AS orderyear, SUM(OD.qty) AS qty
FROM Sales.Orders AS O
JOIN Sales.OrderDetails AS OD
ON O.orderid = OD.orderid
GROUP BY O.empid,YEAR(orderdate)
GO
SELECT * FROM Sales.VEmpOrders
ORDER BY empid,orderyear
GO
--DROP VIEW Sales.VEmpOrders
--GO
--4-2
SELECT empid,orderyear,qty,
SUM(qty) OVER (PARTITION BY empid ORDER BY empid,orderyear ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runqty 
FROM Sales.VEmpOrders
GO
--5-1
CREATE FUNCTION Production.TopProducts(
	@supid INT,
	@n INT
)
RETURNS TABLE
AS
RETURN(
	SELECT TOP (@n) productid, productname,unitprice 
	FROM Production.Products
	WHERE supplierid = @supid
	ORDER BY unitprice DESC
)
GO
SELECT * FROM Production.TopProducts(5,2)
GO
--5-2
SELECT DISTINCT S.supplierid,S.companyname, FN.productid,FN.productname, FN.unitprice
FROM Production.Suppliers AS S
CROSS APPLY Production.TopProducts(S.supplierid,2) AS FN

GO
DROP FUNCTION Production.TopProducts
GO