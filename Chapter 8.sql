--1
USE TSQL2012;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
CREATE TABLE dbo.Customers
(
custid INT NOT NULL PRIMARY KEY,
companyname NVARCHAR(40) NOT NULL,
country NVARCHAR(15) NOT NULL,
region NVARCHAR(15) NULL,
city NVARCHAR(15) NOT NULL
);
--1-1
INSERT INTO dbo.Customers
(
    custid,
    companyname,
    country,
    region,
    city
)
VALUES
(   100,   -- custid - int
    N'Coho Winery', -- companyname - nvarchar(40)
    N'USA', -- country - nvarchar(15)
    N'WA', -- region - nvarchar(15)
    N'Redmond'  -- city - nvarchar(15)
    )
--1-2
INSERT INTO dbo.Customers
(
    custid,
    companyname,
    country,
    region,
    city
)
SELECT  custid,
		companyname,
		country,
		region,
		city
FROM Sales.Customers
WHERE custid IN (SELECT DISTINCT custid FROM Sales.Orders)
--1-3
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
SELECT orderid,
       custid,
       empid,
       orderdate,
       requireddate,
       shippeddate,
       shipperid,
       freight,
       shipname,
       shipaddress,
       shipcity,
       shipregion,
       shippostalcode,
       shipcountry 
INTO dbo.Orders 
FROM Sales.Orders
WHERE YEAR(orderdate) BETWEEN 2006 AND 2008

--2
DELETE FROM dbo.Orders
		OUTPUT
			Deleted.orderid,
			Deleted.orderdate
WHERE YEAR(orderdate) <= 2006 AND MONTH(orderdate) < 8

--3
DELETE FROM O
FROM dbo.Orders AS O
JOIN Sales.Customers C ON O.custid=C.custid
WHERE C.country = 'Brazil'

--4
UPDATE	dbo.Customers SET region = '<NULL>' 
	OUTPUT
	Inserted.custid,
	Inserted.region AS newregion,
	Deleted.region AS oldregion
WHERE region IS NULL
--5

UPDATE O
SET O.shipcountry = C.country, O.shipregion = C.region, O.shipcity = C.city
FROM dbo.Orders AS O
Join Sales.Customers AS C
ON O.custid = C.custid
WHERE C.country = 'UK'
--6
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;