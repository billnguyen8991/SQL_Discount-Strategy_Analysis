**<h1 align="center"> Discount Strategy Analysis </h1>**

**Purpose**

This project aims to explore Discount Strategy of the company on a several range of office products to understand employees performance and products, sales trend of different products on different level of discount so that the organisation can improve and optimise their strategy.

**Task**

**<h2>Requirement 1:</h2>** Analyze the sales trend of furniture products based on quarterly performance.

**Overall Sales by Year**
| Order_Year | Total_Sales | Total_Quantity |
|------------|-------------|----------------|
| 2014       | 484,247.50  | 7,581          |
| 2015       | 470,532.51  | 7,979          |
| 2016       | 609,205.60  | 9,837          |
| 2017       | 733,215.25  | 12,476         |

### Annual Product Profit and Profit Percentage
| Order Year | Product Name     | Total Profit | Profit Percentage |
|------------|------------------|--------------|--------------------|
| 2017       | Technology       | 50684.26     | 54                |
| 2016       | Technology       | 39773.99     | 48.63             |
| 2017       | Office Supplies  | 39736.62     | 42.34             |
| 2016       | Office Supplies  | 35061.23     | 42.86             |
| 2015       | Technology       | 33503.87     | 54.37             |
| 2015       | Office Supplies  | 25099.53     | 40.73             |
| 2014       | Office Supplies  | 22593.42     | 45.6              |
| 2014       | Technology       | 21492.83     | 43.38             |
| 2016       | Furniture        | 6959.95      | 8.51              |
| 2014       | Furniture        | 5457.73      | 11.02             |
| 2017       | Furniture        | 3438.39      | 3.66              |
| 2015       | Furniture        | 3015.2       | 4.89              |

### Sales and Profit of Furniture Product

| Order Year | Total Sales | Total Profit | Profit Percentage |
|------------|-------------|--------------|--------------------|
| 2017       | 215387.27   | 3438.39      | 3.66               |
| 2016       | 198901.44   | 6959.95      | 8.51               |
| 2015       | 170518.24   | 3015.2       | 4.89               |
| 2014       | 157192.85   | 5457.73      | 11.02              |

**Insight:**
In general, revenue is increasing over the year for all kind of product except for Furniture.
Technology and Office Supply are the most profitable, they take around half of profit in 2017. Furniture consistently has the lowest profit percentage across all years, with a notable dip in 2017 at only 3.66%. This may indicate that while Furniture contributes to sales volume, it has lower profitability, potentially due to higher costs or lower margins.

Recommend
**Focus on Technology and Office Supplies** as they bring the highest profit contribution.
Evaluate the Furniture category to determine if cost reductions or pricing adjustments could improve profitability.
**Monitor Technology trends** to ensure the category continues to grow or maintain high profitability.


**<h2> Requirement 2:</h2>** Analyze the impact of different discount levels on sales performance across product categories followed the defined discount level.

Discount level condition:\
No Discount = 0\
0 < Low Discount < 0.2\
0.2 < Medium Discount < 0.5\
High Discount > 0.5

**Result:**
| Category     | Discount_Level   | Total_Orders | Total_Profit |
|--------------|------------------|--------------|--------------|
| Accessories  | Medium Discount   | 304          | 6647         |
| Accessories  | No Discount       | 471          | 35289        |
| Appliances   | High Discount     | 67           | -8630        |
| Appliances   | Low Discount      | 16           | 1086         |
| Appliances   | Medium Discount   | 112          | 2498         |
| Appliances   | No Discount       | 271          | 23184        |
...
...
...
| Machines     | Low Discount      | 2            | 832          |
| Machines     | Medium Discount   | 61           | -5006        |
| Phones       | No Discount       | 311          | 34365        |
| Storage      | No Discount       | 530          | 25528        |
| Supplies     | Medium Discount   | 73           | -2907        |
| Supplies     | No Discount       | 117          | 1718         |
| Tables       | Medium Discount   | 247          | -30582       |
| Tables       | No Discount       | 72           | 13276        |


**Requirement 3:** Determine the top-performing product categories within each customer segment based on sales and profit.


**Result:**


| Segment        | Category    | Sales_Rank | Profit_Rank |
|----------------|-------------|------------|-------------|
| Consumer       | Copiers     | 8          | 1           |
| Consumer       | Phones      | 2          | 2           |
| Corporate      | Accessories  | 7          | 2           |
| Corporate      | Copiers     | 8          | 1           |
| Home Office    | Copiers     | 7          | 1           |
| Home Office    | Phones      | 1          | 2           |


**Requirement 4:** Analyze each employee's performance across different product categories.

**Result:**

| ID_EMPLOYEE | CATEGORY      | TOTAL_SALES | TOTAL_PROFIT | PROFIT_PERCENTAGE |
|-------------|---------------|-------------|--------------|--------------------|
| 1           | Copiers       | 9699.77     | 4360.9       | 19.25              |
| 1           | Phones        | 21480.05    | 3262.29      | 14.4               |
| 1           | Binders       | 10505.17    | 3212.77      | 14.18              |
| 1           | Accessories   | 11505.6     | 2929.34      | 12.93              |
| 1           | Paper         | 3594.96     | 1643.98      | 7.26               |
| 1           | Envelopes     | 747.34      | 339.7        | 1.5                |
...
...
...
| 9           | Copiers       | 27699.62    | 8912.88      | 21.55              |
| 9           | Accessories   | 27200.33    | 6937.45      | 16.77              |
| 9           | Chairs        | 61514.25    | 6338.22      | 15.32              |
| 9           | Phones        | 45079.29    | 5671.05      | 13.71              |
| 9           | Paper         | 11427.22    | 4996.81      | 12.08              |
| 9           | Storage       | 34866.65    | 3321.65      | 8.03               |
| 9           | Binders       | 20157.74    | 2463.12      | 5.95               |


**Requirement 5:** Analyze the profitability ratio for each product category an employee has sold.

**Result:**

| Employee ID | Category    | Total Sales | Total Profit | Profitability Ratio |
|-------------|-------------|-------------|--------------|---------------------|
| 1           | Labels      | 1289.38     | 617.49       | 0.48                |
| 1           | Paper       | 3594.96     | 1643.98      | 0.46                |
| 1           | Envelopes   | 747.34      | 339.7        | 0.45                |
| 1           | Copiers     | 9699.77     | 4360.9       | 0.45                |
| 1           | Fasteners   | 164.55      | 62.42        | 0.38                |
| 1           | Binders     | 10505.17    | 3212.77      | 0.31                |
| 1           | Accessories | 11505.6     | 2929.34      | 0.25                |
...
| 8           | Chairs       | 60808.64    | 4188.40      | 0.07                |
| 8           | Binders      | 42225.52    | 1016.88      | 0.02                |
| 8           | Supplies     | 8501.11     | 5.03         | 0                   |
| 8           | Bookcases    | 19329.13    | -1545.43     | -0.08               |
| 9           | Chairs       | 61514.25    | 6338.22      | 0.10                |
| 9           | Machines     | 31060.70    | 147.76       | 0                   |
| 9           | Tables       | 34634.10    | -2155.57     | -0.06               |
| 9           | Bookcases    | 14477.13    | -963.15      | -0.07               |
| 9           | Supplies     | 5040.55     | -695.37      | -0.14               |


**Requirement 6:** Analyse customer pattern based on their order history.

**Result:**
| Discount Level  | Total Orders | Total Sales | Total Profit | Sales Per Order | Profit Per Order | Avg Discount Percentage |
|-----------------|--------------|-------------|--------------|-----------------|------------------|-------------------------|
| High Discount   | 856          | 64,229      | -76,559      | 75.03           | -89.44           | 0.72                    |
| Medium Discount | 4,194        | 1,063,136   | 31,940       | 253.49          | 7.62             | 0.22                    |
| Low Discount    | 146          | 81,928      | 10,448       | 561.15          | 71.56            | 0.12                    |
| No Discount     | 4,798        | 1,087,908   | 320,988      | 226.74          | 66.9             | 0                       |

**Requirement 7:** Write a query to analyse customer pattern based on their order history.


**Results:**
| ID   | Value |
|------|-------|
| 111  | 6     |
| 112  | 14    |
| 113  | 9     |
| 114  | 13    |
| 115  | 8     |
| 121  | 6     |
...
| 544  | 10    |
| 545  | 5     |
| 551  | 29    |
| 552  | 12    |
| 553  | 9     |
| 554  | 6     |
| 555  | 13    |


**<h1 align="center"> Suggestion </h1>**
