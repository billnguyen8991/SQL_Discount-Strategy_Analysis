-- Question 1: 
/* Write a SQL query to calculate the total sales of furniture products, grouped by each quarter of the year, and order the results chronologically? */

with yearCTE as (
select ORDER_DATE,
		case 
		when DATEPART(Quarter, ORDER_DATE) = 1 THEN 'Q1-' + CAST(Year(ORDER_Date) as char(4))
		when DATEPART(Quarter, ORDER_DATE) = 2 THEN 'Q2-' + CAST(Year(ORDER_Date) as char(4))
		when DATEPART(Quarter, ORDER_DATE) = 3 THEN 'Q3-' + CAST(Year(ORDER_Date) as char(4))
		when DATEPART(Quarter, ORDER_DATE) = 4 THEN 'Q4-' + CAST(Year(ORDER_Date) as char(4))
		end as Quarter_Year
from Orders)

select	y.Quarter_Year,
		ROUND(sum(sales),2) as total_sales
from Orders o
join yearCTE y
on y.ORDER_DATE = o.ORDER_DATE
join Product p
on o.PRODUCT_ID = p.ID
where p.NAME = 'Furniture'
group by y.Quarter_Year
order by RIGHT(y.Quarter_Year,4), RIGHT(Left(y.Quarter_Year,2),1);


/*2. Write a query to analyze the impact of different discount levels on sales performance across product categories, 
specifically looking at the number of orders and total profit generated for each discount classification?

Discount level condition:
No Discount = 0
0 < Low Discount < 0.2
0.2 < Medium Discount < 0.5
High Discount > 0.5  */


WITH DiscountCTE AS (
    SELECT 
        DISCOUNT,
        CASE 
            WHEN DISCOUNT = 0 THEN 'No Discount'
            WHEN DISCOUNT <= 0.2 THEN 'Low Discount'
            WHEN DISCOUNT <= 0.5 THEN 'Medium Discount'
            ELSE 'High Discount'
        END AS Discount_Level
    FROM 
        Orders
)

SELECT 
    p.CATEGORY,
    d.Discount_Level,
    COUNT(distinct o.ROW_ID) AS Total_Orders,
    ROUND(SUM(o.PROFIT), 2) AS Total_Profit
FROM 
    Orders o
JOIN 
    Product p ON p.ID = o.PRODUCT_ID
JOIN 
    DiscountCTE d ON d.DISCOUNT = o.DISCOUNT
GROUP BY 
    p.CATEGORY, d.Discount_Level
ORDER BY 
    p.CATEGORY, d.Discount_Level;







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
    ROUND(SUM(o.PROFIT), 2) AS Round_Total_Profit,
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


