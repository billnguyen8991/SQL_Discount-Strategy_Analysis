/* Question 1: 
Write a SQL query to calculate the total sales of furniture products, grouped by each quarter of the year, and order the results chronologically? */

WITH YearCTE AS (
    SELECT 
        ORDER_DATE,
        PRODUCT_ID,
        sales,
        p.NAME, 
        CASE 
            WHEN DATEPART(Quarter, ORDER_DATE) = 1 THEN 'Q1-' + CAST(YEAR(ORDER_Date) AS VARCHAR(4))
            WHEN DATEPART(Quarter, ORDER_DATE) = 2 THEN 'Q2-' + CAST(YEAR(ORDER_Date) AS VARCHAR(4))
            WHEN DATEPART(Quarter, ORDER_DATE) = 3 THEN 'Q3-' + CAST(YEAR(ORDER_Date) AS VARCHAR(4))
            WHEN DATEPART(Quarter, ORDER_DATE) = 4 THEN 'Q4-' + CAST(YEAR(ORDER_Date) AS VARCHAR(4))
        END AS Quarter_Year
    FROM 
        Orders o
    JOIN 
        Product p ON o.PRODUCT_ID = p.ID
)

SELECT 
    Quarter_Year,
    ROUND(SUM(sales), 2) AS total_sales
FROM 
    YearCTE
WHERE 
    NAME = 'Furniture'
GROUP BY 
    Quarter_Year
ORDER BY 
    RIGHT(Quarter_Year, 4), RIGHT(LEFT(Quarter_Year, 2), 1);



/* Question 2:
Write a query to analyze the impact of different discount levels on sales performance across product categories, 
specifically looking at the number of orders and total profit generated for each discount classification?

Discount level condition:
No Discount = 0
0 < Low Discount < 0.2
0.2 < Medium Discount < 0.5
High Discount > 0.5  */


WITH DiscountCTE AS (
    SELECT 
        DISCOUNT,
		CATEGORY,
		PROFIT,
        CASE 
            WHEN DISCOUNT = 0 THEN 'No Discount'
            WHEN DISCOUNT <= 0.2 THEN 'Low Discount'
            WHEN DISCOUNT <= 0.5 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS Discount_Level
    FROM 
        Orders o
	join PRODUCT p on o.PRODUCT_ID = p.ID
)

select CATEGORY,
		Discount_Level,
		COUNT(*) as Total_Orders,
		Round(SUM(PROFIT),0) as Total_Profit
from DiscountCTE
group by CATEGORY, Discount_Level
order by CATEGORY, Discount_Level



/* Question 3:
Write a query to determine the top-performing product categories within each customer segment based on sales and profit, 
focusing specifically on those categories that rank within the top two for profitability? */



WITH RankedData AS (
    SELECT 
        c.SEGMENT,
        p.CATEGORY,
        SUM(o.SALES) AS Total_Sales,
        SUM(o.PROFIT) AS Total_Profit,
        Dense_RANK() OVER(PARTITION BY c.SEGMENT ORDER BY SUM(o.SALES) DESC) AS Sales_Rank,
        DENSE_RANK() OVER(PARTITION BY c.SEGMENT ORDER BY SUM(o.PROFIT) DESC) AS Profit_Rank
    FROM 
        Orders o
    JOIN 
        Customers c ON c.ID = o.CUSTOMER_ID
    JOIN 
        Product p ON p.ID = o.PRODUCT_ID
    GROUP BY 
        c.SEGMENT, p.CATEGORY
)
SELECT 
    SEGMENT,
    CATEGORY,
    Sales_Rank,
    Profit_Rank
FROM 
    RankedData
WHERE 
    Profit_Rank <= 2
ORDER BY 
    SEGMENT, CATEGORY;







/* Question 4:
Write a query to create a report that displays each employee's performance across different product categories, 
showing not only the total profit per category but also what percentage of their total profit each category represents, 
with the results ordered by the percentage in descending order for each employee? */


SELECT 
    e.ID_EMPLOYEE,
    p.CATEGORY,
	Round(sum(o.SALES),2) as Total_Sales,
    ROUND(SUM(o.PROFIT), 2) AS Total_Profit,
    ROUND((SUM(o.PROFIT) / SUM(SUM(o.PROFIT)) OVER (PARTITION BY e.ID_Employee)) * 100, 2) AS Profit_Percentage
FROM 
    Employees e
JOIN 
    Orders o ON e.ID_EMPLOYEE = o.ID_EMPLOYEE
JOIN 
    Product p ON p.ID = o.PRODUCT_ID
GROUP BY 
    e.ID_EMPLOYEE, p.CATEGORY
ORDER BY 
    e.ID_EMPLOYEE ASC, Round_Total_Profit DESC;




/* Question 5: 
Write a query to develop a user-defined function in SQL Server to calculate the profitability ratio for each product 
category an employee has sold, and then apply this function to generate a report that ranks each employee's product 
categories by their profitability ratio? */

CREATE FUNCTION dbo.CalculateProfitabilityRatio (@EmployeeID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        p.CATEGORY,
		ROUND(SUM(o.SALES),2) as Total_Sales,
        ROUND(SUM(o.PROFIT), 2) AS Total_Profit,
        ROUND(SUM(o.PROFIT) / NULLIF(SUM(o.SALES), 0), 2) AS Profitability_Ratio
    FROM 
        Orders o
    INNER JOIN 
        Product p ON p.ID = o.PRODUCT_ID
    WHERE 
        o.ID_EMPLOYEE = @EmployeeID
    GROUP BY 
        p.CATEGORY
);

SELECT 
    e.ID_EMPLOYEE,
    c.CATEGORY,
	COALESCE(pr.Total_Sales, 0) as Total_Sales,
    COALESCE(pr.Total_Profit, 0) AS Total_Profit,
    COALESCE(pr.Profitability_Ratio, 0) AS Profitability_Ratio
FROM 
    Employees e
CROSS JOIN 
    (SELECT DISTINCT CATEGORY FROM Product) c -- All product categories
LEFT JOIN 
    (
        SELECT 
            o.ID_EMPLOYEE,
            p.CATEGORY,
			ROUND(SUM(o.SALES),2) as Total_Sales,
            ROUND(SUM(o.PROFIT), 2) AS Total_Profit,
            ROUND(SUM(o.PROFIT) / NULLIF(SUM(o.SALES), 0), 2) AS Profitability_Ratio
        FROM 
            Orders o
        INNER JOIN 
            Product p ON p.ID = o.PRODUCT_ID
        GROUP BY 
            o.ID_EMPLOYEE, p.CATEGORY
    ) pr ON e.ID_EMPLOYEE = pr.ID_EMPLOYEE AND c.CATEGORY = pr.CATEGORY
ORDER BY 
    e.ID_EMPLOYEE, Profitability_Ratio DESC;


/* Question 6: Create a report showing order performance by discount level.*/

WITH AggregatedDiscounts AS (
    SELECT 
        CASE 
            WHEN DISCOUNT = 0 THEN 'No Discount'
            WHEN DISCOUNT <= 0.2 THEN 'Low Discount'
            WHEN DISCOUNT <= 0.5 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS Discount_Level,  -- Directly calculate Discount Level here
        COUNT(*) AS Total_Orders,
        SUM(SALES) AS Total_Sales,
        SUM(PROFIT) AS Total_Profit,
        AVG(DISCOUNT) AS Avg_Discount -- Directly aggregate values
    FROM 
        Orders o
    JOIN 
        PRODUCT p ON o.PRODUCT_ID = p.ID
    GROUP BY 
        CASE 
            WHEN DISCOUNT = 0 THEN 'No Discount'
            WHEN DISCOUNT <= 0.2 THEN 'Low Discount'
            WHEN DISCOUNT <= 0.5 THEN 'Medium Discount'
            ELSE 'High Discount'
        END
)

SELECT 
    Discount_Level,
    Total_Orders,
    ROUND(Total_Sales, 0) AS Total_Sales,
    ROUND(Total_Profit, 0) AS Total_Profit,
    ROUND(Total_Sales / NULLIF(Total_Orders, 0), 2) AS Sales_Per_Order,
    ROUND(Total_Profit / NULLIF(Total_Orders, 0), 2) AS Profit_Per_Order,
    ROUND(Avg_Discount, 2) AS Avg_Discount_Percentage
FROM 
    AggregatedDiscounts
ORDER BY 
    CASE 
        WHEN Discount_Level = 'High Discount' THEN 1
        WHEN Discount_Level = 'Medium Discount' THEN 2
        WHEN Discount_Level = 'Low Discount' THEN 3
        WHEN Discount_Level = 'No Discount' THEN 4
    END;  -- Order by Discount Level directly

/* Question 7 Write a query to analyse customer pattern based on their order history*/
--select * from Orders

with RFM_CTE as (
select CUSTOMER_ID,
		DATEDIFF(day, MAX(ORDER_DATE),'2017-12-31') as recency,
		DATEDIFF(day, MIN(order_date),'2017-12-31')/COUNT(*) as frequency,
		SUM(sales)/COUNT(*) as monetary
from Orders
group by CUSTOMER_ID)

select *,
	NTILE(5) over (order by recency) as n_tile_recency,
	PERCENTILE_DISC(0.2) within group (order by recency) over () as percent_20_recency,
	PERCENTILE_DISC(0.4) within group (order by recency) over () as percent_40_recency,
	PERCENTILE_DISC(0.6) within group (order by recency) over () as percent_60_recency,
	PERCENTILE_DISC(0.8) within group (order by recency) over () as percent_80_recency,

	ntile(5) over (order by frequency) as n_tile_frequency,
	percentile_disc(0.2) within group (order by frequency) over () as percent_20_frequency,
	percentile_disc(0.4) within group (order by frequency) over () as percent_40_frequency,
	percentile_disc(0.6) within group (order by frequency) over () as percent_60_frequency,
	PERCENTILE_DISC(0.8) within group (order by frequency) over () as percent_80_frequency,

	NTILE(5) over (order by monetary) as n_tile_monetary,
	PERCENTILE_DISC(0.2) within group (order by monetary) over () as percent_20_monetary,
	PERCENTILE_DISC(0.4) within group (order by monetary) over () as percent_40_monetary,
	PERCENTILE_DISC(0.6) within group (order by monetary) over () as percent_60_monetary,
	PERCENTILE_DISC(0.8) within group (order by monetary) over () as percent_80_monetary
into RFM_RawData
from RFM_CTE


--select * from RFM_RawData


WITH RFM_CalData AS (
    SELECT 
        Customer_ID,
        (CASE 
            WHEN recency <= (SELECT MAX(percent_20_recency) FROM RFM_RawData) THEN 1
            WHEN recency <= (SELECT MAX(percent_40_recency) FROM RFM_RawData) THEN 2
            WHEN recency <= (SELECT MAX(percent_60_recency) FROM RFM_RawData) THEN 3 
            WHEN recency <= (SELECT MAX(percent_80_recency) FROM RFM_RawData) THEN 4 
            ELSE 5 
        END) AS rb,
        
        (CASE 
            WHEN frequency <= (SELECT MAX(percent_20_frequency) FROM RFM_RawData) THEN 1
            WHEN frequency <= (SELECT MAX(percent_40_frequency) FROM RFM_RawData) THEN 2
            WHEN frequency <= (SELECT MAX(percent_60_frequency) FROM RFM_RawData) THEN 3
            WHEN frequency <= (SELECT MAX(percent_80_frequency) FROM RFM_RawData) THEN 4
            ELSE 5 
        END) AS fb, 
        
        (CASE 
            WHEN monetary <= (SELECT MAX(percent_20_monetary) FROM RFM_RawData) THEN 1
            WHEN monetary <= (SELECT MAX(percent_40_monetary) FROM RFM_RawData) THEN 2
            WHEN monetary <= (SELECT MAX(percent_60_monetary) FROM RFM_RawData) THEN 3
            WHEN monetary <= (SELECT MAX(percent_80_monetary) FROM RFM_RawData) THEN 4
            ELSE 5 
        END) AS mb
    FROM RFM_RawData
)

SELECT 
    rb * 100 + fb * 10 + mb AS rfm,  -- Calculate the RFM score
    COUNT(Customer_ID) AS Customer_Count  -- Count of customers for each RFM score
FROM RFM_CalData
GROUP BY rb * 100 + fb * 10 + mb  -- Group by the calculated RFM score
ORDER BY rfm;  -- Order by the RFM score


