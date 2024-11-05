Office Sales Data Analysis

**Purpose**

This project aims to explore Discount Strategy of the company on a several range of office products to understand employees performance and products, sales trend of different products on different level of discount so that the organisation can improve and optimise their strategy.

**Task**
-- Question 1: 
/* Write a SQL query to calculate the total sales of furniture products, grouped by each quarter of the year, and order the results chronologically? */

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
