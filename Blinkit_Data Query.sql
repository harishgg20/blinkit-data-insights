
-- See all the data imported
select * from blinkit_data

select count(*) from blinkit_data

-- Data Cleaning

update blinkit_data
set Item_Fat_Content = 
case
when Item_Fat_Content IN ('LF','low fat') then 'Low Fat'
when Item_Fat_Content = 'reg' then 'Regular'
else Item_Fat_Content
end

-- Query To Check Data has been cleaned or not

select distinct (Item_Fat_Content)  from blinkit_data

-- KPI'S
-- 1.Total Sales: The overall revenue generated from all items sold

select cast(sum(Total_Sales)/ 1000000 as decimal(10,2)) [Total_Sales_Millions]
from blinkit_data

select cast(sum(Total_Sales)/ 1000000 as decimal(10,2)) [Total_Sales_Millions]
from blinkit_data
where Outlet_Establishment_Year = 2022

-- 2.Average Sales: The average revenue per sale.

select cast(avg(Total_Sales) as decimal(10,0)) [Avg_Sales] from blinkit_data
where Outlet_Establishment_Year = 2022

-- 3.Number of Items: The total count of different items sold.

select count(*)  [No_of_items]
from blinkit_data
where Outlet_Establishment_Year = 2022

-- 4.Average Rating: The average customer rating for items sold. 

select cast(AVG(Rating) as decimal(10,2)) [Avg_Rating]
from blinkit_data

----Granular Requirements

select * from blinkit_data

-- 1.Total Sales by Fat Content:
	/* 
	Objective: Analyze the impact of fat content on total sales.
	Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.
    */
select Item_Fat_Content,
	cast(sum(Total_Sales)/1000 as decimal(10,2)) [Total_Sales_Thousands],
	cast(avg(Total_Sales) as decimal(10,1)) [Avg_Sales],
	count(*)  [No_of_items],
	cast(AVG(Rating) as decimal(10,2)) [Avg_Rating]
from blinkit_data
group by Item_Fat_Content

-- 2. Total Sales by Item Type:
	/*
	Objective: Identify the performance of different item types in terms of total sales.
	Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.
    */
select Item_Type,
	cast(sum(Total_Sales) as decimal(10,2)) [Total_Sales],
	cast(avg(Total_Sales) as decimal(10,1)) [Avg_Sales],
	count(*)  [No_of_items],
	cast(AVG(Rating) as decimal(10,2)) [Avg_Rating]
from blinkit_data
group by Item_Type

-- 3.Fat Content by Outlet for Total Sales:
    /*
	Objective: Compare total sales across different outlets segmented by fat content.
	Additional KPI Metrics: Assess how other KPIs (Average Sales, Number of Items, Average Rating) vary with fat content.
    */
	select Outlet_Location_Type,Item_Fat_Content,
	cast(sum(Total_Sales) as decimal(10,2)) [Total_Sales]
from blinkit_data
group by Outlet_Location_Type,Item_Fat_Content
 
     --    OR

	SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type

 -- 4.Total Sales by Outlet Establishment:
	/*
	Objective: Evaluate how the age or type of outlet establishment influences total sales.
	*/

select Outlet_Establishment_Year,
	cast(sum(Total_Sales) as decimal(10,2)) [Total_Sales],
	cast(avg(Total_Sales) as decimal(10,1)) [Avg_Sales],
	count(*)  [No_of_items],
	cast(AVG(Rating) as decimal(10,2)) [Avg_Rating]
from blinkit_data
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year



-- CHART'S REQUIREMENT
-- 1.Percentage of Sales by Outlet Size:
	/*
	Objective: Analyze the correlation between outlet size and total sales.
	*/

select Outlet_Size,
       cast(sum(Total_Sales) as decimal(10,2)) as Total_Sales,
	   cast((sum(Total_Sales) * 100.0 / sum(sum(Total_Sales)) over()) as decimal(10,2) ) as Sales_Percentage
from blinkit_data
group by Outlet_Size
order by Total_Sales Desc

-- 2.Sales by Outlet Location:
	/*
	Objective: Assess the geographic distribution of sales across different locations.
	*/
	select Outlet_Location_Type,
	cast(sum(Total_Sales) as decimal(10,2)) [Total_Sales],
	cast((sum(Total_Sales) * 100.0 / sum(sum(Total_Sales)) over()) as decimal(10,2) ) as Sales_Percentage,
	cast(avg(Total_Sales) as decimal(10,1)) [Avg_Sales],
	count(*)  [No_of_items],
	cast(AVG(Rating) as decimal(10,2)) [Avg_Rating]
from blinkit_data
group by Outlet_Location_Type
order by Total_Sales desc

-- 3.All Metrics by Outlet Type:
	/*
	Objective: Provide a comprehensive view of all key metrics (Total Sales, Average Sales, Number of 	Items, Average Rating) broken down by different outlet types.
	*/

SELECT Outlet_Type, 
		CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC

