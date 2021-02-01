--1
SELECT * FROM Sales.Orders
WHERE orderdate = (SELECT MAX(orderdate) FROM Sales.Orders)

--2
SELECT custid,orderid,orderdate,empid FROM Sales.Orders
WHERE custid = (
	SELECT TOP (1) T.custid FROM (
		SELECT custid, COUNT(orderid) AS orders FROM Sales.Orders
		GROUP BY custid
	) AS T
	ORDER BY T.orders DESC
)
--3
SELECT empid,firstname,lastname FROM HR.Employees
WHERE empid NOT IN (
	SELECT DISTINCT empid FROM Sales.Orders
	WHERE orderdate >= '20080501'
)
--4
SELECT DISTINCT country FROM Sales.Customers
WHERE country NOT IN (
	SELECT DISTINCT country FROM HR.Employees
)
--5
SELECT O.custid,O.orderid,O.orderdate,O.empid FROM Sales.Orders AS O
WHERE orderdate IN (
	SELECT MAX(orderdate) AS orderdate FROM Sales.Orders
	WHERE O.custid = custid
	GROUP BY custid
)
ORDER BY O.custid ASC
--6
SELECT custid, companyname FROM  Sales.Customers
WHERE custid IN (
	SELECT custid FROM Sales.Orders
	WHERE YEAR(orderdate) = '2007'
	GROUP BY custid
) AND custid NOT IN (
	SELECT custid FROM Sales.Orders
	WHERE YEAR(orderdate) = '2008'
	GROUP BY custid
)

SELECT custid, companyname FROM  Sales.Customers
WHERE custid IN (
		SELECT custid FROM Sales.Orders
		WHERE YEAR(orderdate) = '2007'
		GROUP BY custid
	EXCEPT
		SELECT custid FROM Sales.Orders
		WHERE YEAR(orderdate) = '2008'
		GROUP BY custid
)
--7
SELECT custid,companyname FROM Sales.Customers
WHERE custid IN (
	SELECT custid FROM Sales.Orders
	WHERE orderid IN (
		SELECT orderid FROM Sales.OrderDetails
		WHERE productid = 12
	)
)
--8
SELECT T.custid, T.ordermonth, T.qty, 
SUM(T.qty) OVER (PARTITION BY T.custid ORDER BY T.custid,T.ordermonth RANGE UNBOUNDED PRECEDING) AS runqty 
FROM (
	SELECT custid, DATETIMEFROMPARTS(YEAR(ordermonth), MONTH(ordermonth),1,0,0,0,0) AS ordermonth, SUM(qty) AS qty
	FROM Sales.CustOrders
	GROUP BY custid, YEAR(ordermonth), MONTH(ordermonth)
) AS T