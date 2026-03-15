--- Sales & Profitability Analysis

--- 1.Revenue, Orders & AOV  by Year
SELECT
    YEAR(OrderDate) AS Order_Year,
    COUNT(DISTINCT SalesOrderID) AS Total_Orders,
    SUM(TotalDue) AS Revenue,
    ROUND(
           SUM(TotalDue) * 1.0 / NULLIF(COUNT(DISTINCT SalesOrderID),0),
         2) AS Avg_Order_Value
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY Order_Year;

--- 2.Revenue by Territory
SELECT
	st.Name AS Territory,
	st.[Group],
	COUNT(Distinct soh.SalesOrderID) AS Total_Orders,
	ROUND(SUM(soh.TotalDue),2) AS Total_Rev
FROM SALES.SalesTerritory st
JOIN SALES.SalesOrderHeader soh
	ON st.TerritoryID = soh.TerritoryID
GROUP BY st.Name, st.[Group]
ORDER BY Total_Rev DESC;

--- 3.Product Category Performance
SELECT
	pc.Name,
	COUNT(Distinct soD.SalesOrderID) AS Total_Orders,
	ROUND(SUM(sod.LineTotal),2) AS Revenue	
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p
	on sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps
	ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc
	ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY Revenue DESC;

--- 4.Year-over-Year Growth (YoY)
WITH RevenueByYear AS (
    SELECT
        YEAR(OrderDate) AS Order_Year,
        SUM(TotalDue) AS Revenue
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate)
),
RevenueWithLag AS (
    SELECT
        Order_Year,
        Revenue,
        LAG(Revenue) OVER (ORDER BY Order_Year) AS Prev_YearRev
    FROM RevenueByYear
),
GrowthCalc AS (
    SELECT
        Order_Year,
        Revenue,
        Prev_YearRev,
        (Revenue - Prev_YearRev) * 100
            / NULLIF(Prev_YearRev, 0) AS GrowthPercent
    FROM RevenueWithLag
)

SELECT
    Order_Year,
    ROUND(Revenue,2) AS Revenue,
    ROUND(Prev_YearRev,2) AS Prev_YearRev,
    ROUND(GrowthPercent,2) AS YoY_Percent,
    CASE
        WHEN Prev_YearRev IS NULL THEN N'Không có'
        WHEN GrowthPercent > 0 THEN CONCAT(N'Tăng ', ROUND(GrowthPercent,2), '%')
        WHEN GrowthPercent < 0 THEN CONCAT(N'Giảm ', ROUND(GrowthPercent,2), '%')
        ELSE N'Không đổi'
    END AS YearGrowth_Status
FROM GrowthCalc
ORDER BY Order_Year;

--- 5.Top 10 Customers by Revenue
SELECT TOP 10
    c.CustomerID,
    COUNT(Distinct soh.SalesOrderID) AS Total_Orders,
    SUM(soh.TotalDue) AS Revenue
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh
    ON c.CustomerID = soh.CustomerID
GROUP BY c.CustomerID
ORDER BY Revenue DESC;

--- 6.CAGR 4 YEARS 
WITH RevenueByYear AS (
    SELECT
        YEAR(OrderDate) AS Order_Year,
        SUM(TotalDue) AS Revenue
    FROM Sales.SalesOrderHeader
    GROUP BY YEAR(OrderDate)
),

Last4Years AS (
    SELECT TOP 4 *
    FROM RevenueByYear
    ORDER BY Order_Year DESC
),

RankedData AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY Order_Year) AS rn_asc,
           ROW_NUMBER() OVER (ORDER BY Order_Year DESC) AS rn_desc
    FROM Last4Years
)

SELECT
    MAX(CASE WHEN rn_asc = 1 THEN Order_Year END) AS Begin_Year,
    MAX(CASE WHEN rn_desc = 1 THEN Order_Year END) AS End_Year,
    MAX(CASE WHEN rn_asc = 1 THEN Revenue END) AS Begin_Revenue,
    MAX(CASE WHEN rn_desc = 1 THEN Revenue END) AS End_Revenue,
    ROUND(
        (POWER(
            MAX(CASE WHEN rn_desc = 1 THEN Revenue END) * 1.0
            /
            NULLIF(MAX(CASE WHEN rn_asc = 1 THEN Revenue END),0),
            1.0 /
            (MAX(CASE WHEN rn_desc = 1 THEN Order_Year END)
             -
             MAX(CASE WHEN rn_asc = 1 THEN Order_Year END))
        ) - 1) * 100
    ,2) AS CAGR_Percent
FROM RankedData;

--- 7.CAGR by Territory

WITH RevenueByYear AS (
    SELECT
        st.Name AS Territory,
        YEAR(soh.OrderDate) AS Order_Year,
        SUM(soh.TotalDue) AS Revenue
    FROM Sales.SalesOrderHeader soh
    JOIN Sales.SalesTerritory st
        ON soh.TerritoryID = st.TerritoryID
    GROUP BY
        st.Name,
        YEAR(soh.OrderDate)
),

RankedYears AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Territory ORDER BY Order_Year) AS rn_asc,
           ROW_NUMBER() OVER (PARTITION BY Territory ORDER BY Order_Year DESC) AS rn_desc
    FROM RevenueByYear
),

BoundaryValues AS (
    SELECT
        Territory,
        MAX(CASE WHEN rn_asc = 1 THEN Order_Year END) AS Begin_Year,
        MAX(CASE WHEN rn_desc = 1 THEN Order_Year END) AS End_Year,
        MAX(CASE WHEN rn_asc = 1 THEN Revenue END) AS Begin_Revenue,
        MAX(CASE WHEN rn_desc = 1 THEN Revenue END) AS End_Revenue
    FROM RankedYears
    GROUP BY Territory
)

SELECT
    Territory,
    Begin_Year,
    End_Year,
    ROUND(Begin_Revenue,2) AS Begin_Revenue,
    ROUND(End_Revenue,2) AS End_Revenue,
    ROUND(
            (POWER(
                    End_Revenue * 1.0 / NULLIF(Begin_Revenue,0),
                    1.0 / NULLIF((End_Year - Begin_Year),0)
                   ) - 1) * 100
        ,2) AS CAGR_Percent
FROM BoundaryValues
ORDER BY CAGR_Percent DESC;

--- 8.Total Profit & Gross Margin by Year
WITH cte AS(
    SELECT
        YEAR(soh.OrderDate) AS Order_Year,
        sod.LineTotal AS Revenue,
        (sod.OrderQty * p.StandardCost) AS Cost,
        sod.LineTotal - (sod.OrderQty * p.StandardCost) AS Profit
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh
        ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p
        ON sod.ProductID = p.ProductID
)

SELECT
    Order_Year,
    ROUND(SUM(Revenue),2) AS Total_Rev,
    ROUND(SUM(Cost),2) AS Total_Cost,
    ROUND(SUM(Profit),2) AS Total_Profit,
    ROUND(
           SUM(Profit) *100.0 / NULLIF(SUM(Revenue),0)
        ,2) AS Gross_Margin_Percent
FROM cte
GROUP BY Order_Year
ORDER BY Order_Year;

--- 9.Profitability by Territory
WITH TerritoryFinance AS (
    SELECT
        st.Name AS Territory,
        sod.LineTotal AS Revenue,
        (sod.OrderQty * p.StandardCost) AS Cost,
        sod.LineTotal - (sod.OrderQty * p.StandardCost) AS Profit
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh
        ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Sales.SalesTerritory st
        ON soh.TerritoryID = st.TerritoryID
    JOIN Production.Product p
        ON sod.ProductID = p.ProductID
)

SELECT
    Territory,
    ROUND(SUM(Revenue),2) AS Revenue,
    ROUND(SUM(Profit),2) AS Profit,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Revenue),0),2) AS Gross_Margin_Percent,
    ROUND(SUM(Revenue) * 100.0 / SUM(SUM(Revenue)) OVER ()
            ,2) AS Revenue_Contribution_Percent,
    ROUND(SUM(Profit) * 100.0 / SUM(SUM(Profit)) OVER ()
            ,2) AS Profit_Contribution_Percent
FROM TerritoryFinance
GROUP BY Territory
ORDER BY Profit DESC;

--- 10.Top Product Category by Profit
SELECT
    pc.Name AS Category,
    ROUND(SUM(sod.LineTotal),2) AS Revenue,
    ROUND(SUM(sod.LineTotal - (sod.OrderQty * p.StandardCost)),2) AS Profit,
    ROUND(
           SUM(sod.LineTotal - (sod.OrderQty * p.StandardCost)) *100.0 / NULLIF(SUM(sod.LineTotal),0)
        ,2) AS Gross_Margin_Percent
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p
    ON sod.ProductID = p.ProductID
JOIN Production.ProductSubcategory ps
    ON p.ProductSubcategoryID = ps.ProductSubcategoryID
JOIN Production.ProductCategory pc
    ON ps.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY Profit DESC;

--- 11.Profit YoY %
WITH ProfitByYear AS (
    SELECT
        YEAR(soh.OrderDate) AS Order_Year,
        SUM(sod.LineTotal - (sod.OrderQty * p.StandardCost)) AS Profit
    FROM Sales.SalesOrderDetail sod
    JOIN Sales.SalesOrderHeader soh
        ON sod.SalesOrderID = soh.SalesOrderID
    JOIN Production.Product p
        ON sod.ProductID = p.ProductID
    GROUP BY YEAR(soh.OrderDate)
),
ProfitLag AS (
    SELECT *,
           LAG(Profit) OVER (ORDER BY Order_Year) AS Prev_Profit
    FROM ProfitByYear
)

SELECT
    Order_Year,
    ROUND(Profit,2) AS Profit,
    ROUND(
          (Profit - Prev_Profit) * 100.0 / NULLIF(Prev_Profit,0)
       ,2) AS Profit_YoY_Percent
FROM ProfitLag
ORDER BY Order_Year;

---
SELECT
    ROUND(
        SUM(LineTotal - (OrderQty * p.StandardCost)) * 100.0
        / NULLIF(SUM(LineTotal),0)
    ,2) AS Avg_Gross_Margin_Percent
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p
    ON sod.ProductID = p.ProductID;