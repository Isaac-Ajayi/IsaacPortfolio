
/** IMPORT DATA FROM CSV FILE**/

CREATE TABLE SuperStore (RowID INT,	OrderID NVARCHAR (15),	OrderDate date,	ShipDate date,	ShipMode NVARCHAR (20),	CustomerID NVARCHAR (8),	CustomerName NVARCHAR (50),	
							Segment NVARCHAR (30),	Country NVARCHAR (30),	City NVARCHAR (30),	State NVARCHAR (30),	PostalCode INT,	Region NVARCHAR (30),	ProductID NVARCHAR (15),
							Category NVARCHAR (30),	SubCategory NVARCHAR (30),	ProductName NVARCHAR (150),	Sales MONEY,	Quantity INT,	Discount DECIMAL (6,4),	Profit MONEY)


SET DATEFORMAT DMY   -- to let sql know the format of the date in the source file to be imported

BULK INSERT SuperStore
FROM 'C:\Users\User\Desktop\Portfolio Project\superstoredata - PortfolioProject.csv'
WITH (FORMAT = 'CSV') 

/** FORMAT DATATYPES FOR COLUMNS Sales, Discounts AND Profits TO 2 DECIMAL PLACES**/

ALTER TABLE [dbo].[Superstore] ALTER COLUMN [Sales] NUMERIC(17,2)

ALTER TABLE [dbo].[Superstore] ALTER COLUMN [profit] NUMERIC(17,2)

ALTER TABLE [dbo].[Superstore] ALTER COLUMN [Discount] NUMERIC(2,2)

/** ADD COLUMN FOR INTERVAL BETWEEN ORDERDATE AND SHIPDATE AND POPULATE THE COLUMN**/

ALTER TABLE [dbo].[SuperStore] ADD ShipmentTime INT  

UPDATE [dbo].[SuperStore] SET ShipmentTime = DATEDIFF(day, [OrderDate], [ShipDate])

/** EXTRACT AND CREATE TABLE FOR 2017 DATA FOR ANALYSIS**/

SELECT * 
INTO Superstoredata2017
FROM [dbo].[SuperStore]
WHERE YEAR(OrderDate) = 2017

/**Calculate total sales for 2017**/
SELECT SUM(Sales) AS Total_Sales
FROM Superstoredata2017

/**Calculate total orders for 2017**/
SELECT COUNT(DISTINCT OrderID) AS Total_orders
FROM [dbo].[Superstoredata2017]

/**Calculate total profit for 2017**/
SELECT SUM(Profit) AS Total_profit
FROM Superstoredata2017

/**Calculate total number of customers for 2017**/
SELECT COUNT(DISTINCT [CustomerID]) AS NumberofCustomers
FROM Superstoredata2017

/**Calculate average order value for 2017**/
SELECT CAST(SUM([Sales])/COUNT(DISTINCT [OrderID]) AS NUMERIC (17,2)) AS Average_order_Value
FROM Superstoredata2017

/**Calculate average order value per customer for 2017**/
SELECT CAST(SUM(Sales) / COUNT(DISTINCT [CustomerID]) AS NUMERIC(17,2)) AS AverageOrderValue_per_Customer
FROM [dbo].[Superstoredata2017]

/**Calculate percentage of sales by region for 2017**/
SELECT Region, CAST(SUM(Sales) *100 / (SELECT SUM(Sales) FROM Superstoredata2017) AS INT) AS PercentageofSales
FROM Superstoredata2017
GROUP BY Region

/**Calculate percentage of profit by region for 2017**/
SELECT Region, CAST(SUM(Profit) *100 / (SELECT SUM(Profit) FROM Superstoredata2017) AS INT) AS PercentageofProfit
FROM Superstoredata2017
GROUP BY Region

/**Calculate profit by subcategory for 2017**/
SELECT SubCategory, CAST(SUM(Profit) AS NUMERIC(17,2)) AS ProfitBySubcategory
FROM Superstoredata2017
GROUP BY SubCategory
ORDER BY ProfitBySubcategory

/**Find top 5 profitable products in 2017**/
SELECT TOP 5 ProductName, CAST(SUM(Profit) AS NUMERIC(17,2)) AS ProfitonProduct
FROM Superstoredata2017
GROUP BY ProductName
ORDER BY ProfitonProduct DESC

/**Find worst 5 products by losses in 2017**/
SELECT TOP 5 ProductName, CAST(SUM(Profit) AS NUMERIC(17,2)) AS LossOnProduct
FROM Superstoredata2017
GROUP BY ProductName
ORDER BY LossOnProduct 

/**Find top 5 selling products in 2017**/
SELECT TOP 5 ProductName, SUM(Quantity) AS Quantity
FROM Superstoredata2017
GROUP BY ProductName
ORDER BY  [Quantity] DESC

/**Show daily trend of orders, that is, quatity of orders by day of week in 2017**/
SELECT DATENAME(DW, OrderDate) AS WeekDay, COUNT(DISTINCT OrderID) AS TotalOrders
FROM Superstoredata2017
GROUP BY DATENAME(DW, OrderDate)
ORDER BY DATENAME(DW, OrderDate) 

/**Group number of orders by state for 2017**/
SELECT State, COUNT(DISTINCT OrderID) AS TotalOrders
FROM Superstoredata2017
GROUP BY STATE
ORDER BY TotalOrders DESC


/** Show monthly sales and profit for 2017**/
SELECT DATENAME(MONTH, DATEADD(MONTH, MONTH(OrderDate), -1)) AS SalesMonth, SUM(Sales) AS MonthlySales, SUM(Profit) AS MonthlyProfit
FROM [dbo].[Superstoredata2017]
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY YEAR(OrderDate), MONTH(OrderDate)



