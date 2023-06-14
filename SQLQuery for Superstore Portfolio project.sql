
/** IMPORT DATA FROM CSV FILE**/

IF OBJECT_ID('SuperStore') IS NOT NULL DROP TABLE SuperStore
CREATE TABLE SuperStore (RowID INT,	OrderID NVARCHAR (15),	OrderDate date,	ShipDate date,	ShipMode NVARCHAR (20),	CustomerID NVARCHAR (8),	CustomerName NVARCHAR (50),	
							Segment NVARCHAR (30),	Country NVARCHAR (30),	City NVARCHAR (30),	State NVARCHAR (30),	PostalCode INT,	Region NVARCHAR (30),	ProductID NVARCHAR (15),
							Category NVARCHAR (30),	SubCategory NVARCHAR (30),	ProductName NVARCHAR (150),	Sales MONEY,	Quantity INT,	Discount DECIMAL (6,4),	Profit MONEY)


SET DATEFORMAT DMY   -- to let sql know the format of the date in the source file to be imported

BULK INSERT SuperStore
FROM 'C:\Users\User\Desktop\Portfolio Project\superstoredata - PortfolioProject.csv'
WITH (FORMAT = 'CSV') 

/** ADD COLUMN FOR INTERVAL BETWEEN ORDERDATE AND SHIPDATE AND POPULATE THE COLUMN**/

ALTER TABLE [dbo].[SuperStore] ADD ShipmentTime INT  

UPDATE [dbo].[SuperStore] SET ShipmentTime = DATEDIFF(day, [OrderDate], [ShipDate])

/** CREATE SUB-TABLES FROM THE IMPORTED TABLE namely SuperstoreOrderTable, SuperstoreCustormerTable and SuperstoreProductTable**/

SELECT [OrderID] , [CustomerID], [ProductID], [Quantity], [OrderDate], [ShipDate], [ShipMode]
INTO SuperstoreOrderTable
FROM [dbo].[SuperStore]


SELECT [CustomerID], [CustomerName], [Segment], [City], [State], [PostalCode], [Region], [Country]
INTO SuperstoreCustormerTable
FROM [dbo].[SuperStore]

SELECT [ProductID], [ProductName], [Category], [SubCategory], [Sales], [Discount], [Profit]
INTO SuperstoreProductandSalesTable
FROM [dbo].[SuperStore]


/** FORMAT DATATYPES FOR COLUMNS Sales, Discounts AND Profits TO 2 DECIMAL PLACES**/

ALTER TABLE [dbo].[SuperstoreProductandSalesTable] ALTER COLUMN [Sales] NUMERIC(17,2)

ALTER TABLE [dbo].[SuperstoreProductandSalesTable] ALTER COLUMN [profit] NUMERIC(17,2)

ALTER TABLE [dbo].[SuperstoreProductandSalesTable] ALTER COLUMN [Discount] NUMERIC(2,2)


/** ANALYSIS OF MONTHLY SALES AND PROFITS FOR EACH YEAR CAPTURED IN THE DATA**/

SELECT YEAR(OrderDate) as SalesYear, DATENAME(MONTH, DATEADD(MONTH, MONTH(OrderDate), -1)) AS SalesMonth, SUM(Sales) AS MonthlySales, SUM(Profit) AS MonthlyProfit
FROM [dbo].[SuperStore]
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate), MONTH(OrderDate)


/** ANALYSIS OF ANNUAL SALES AND PROFITS **/

SELECT YEAR(OrderDate) as SalesYear, SUM(Sales) AS YearlySales, SUM(Profit) AS YearlyProfit
FROM [dbo].[SuperStore]
GROUP BY YEAR(OrderDate)
ORDER BY YEAR(OrderDate)

/** MONTHLY SALES AND PROFITS BY CATEGORIES OF PRODUCTS**/

SELECT YEAR(OrderDate) as SalesYear, DATENAME(MONTH, DATEADD(MONTH, MONTH(OrderDate), -1)) AS SalesMonth,  Category, SUM(Sales) AS MonthlySales, SUM(Profit) AS MonthlyProfit
FROM [dbo].[SuperStore]
GROUP BY YEAR(OrderDate), MONTH(OrderDate), Category
ORDER BY YEAR(OrderDate), MONTH(OrderDate)

/** MONTHLY SALES AND PROFITS BY PRODUCTS SUB-CATEGORIES**/

SELECT YEAR(OrderDate) as SalesYear, DATENAME(MONTH, DATEADD(MONTH, MONTH(OrderDate), -1)) AS SalesMonth,  SubCategory, Category, SUM(Sales) AS MonthlySales, SUM(Profit) AS MonthlyProfit
FROM [dbo].[SuperStore]
GROUP BY YEAR(OrderDate), MONTH(OrderDate), SubCategory, Category
ORDER BY YEAR(OrderDate), MONTH(OrderDate)

/** MONTHLY SALES AND PROFITS BY REGIONS**/

SELECT YEAR(OrderDate) as SalesYear, DATENAME(MONTH, DATEADD(MONTH, MONTH(OrderDate), -1)) AS SalesMonth, Region, SUM(Sales) AS MonthlySales, SUM(Profit) AS MonthlyProfit
FROM [dbo].[SuperStore]
GROUP BY YEAR(OrderDate), MONTH(OrderDate), Region
ORDER BY YEAR(OrderDate), MONTH(OrderDate)


/** MONTHLY AVERAGE INTERVAL BETWEEN ORDER DATE AND SHIPMENT**/

SELECT YEAR(OrderDate) as SalesYear, DATENAME(MONTH, DATEADD(MONTH, MONTH(OrderDate), -1)) AS SalesMonth, AVG(DATEDIFF(day, [OrderDate], [ShipDate])) 
FROM [dbo].[SuperStore]
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate), MONTH(OrderDate)