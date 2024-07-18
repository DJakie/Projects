
-- making adidas database as default
use adidas;

-- to see the first 1000 rows to get an understanding of what we need to clean
select * 
from adidas_sales 
limit 1000;
 
-- turning off sql safe update so that we can use UPDATE and DELETE statements without WHERE clause

set sql_safe_updates=0;

/* DATA CLEANING */

-- To Remove the "$" and "," sign from the sales, Profit , Price per unit so we can make them in integers

update adidas_sales
set Operating_Profit = replace(Operating_Profit,",","");

update adidas_sales
set Operating_Profit = replace(Operating_Profit,"$","");

update adidas_sales
set Price_per_Unit = replace(Price_per_Unit,"$","");

update adidas_sales
set Total_Sales = replace(Total_Sales,",","");

update adidas_sales
set Total_Sales = replace(Total_Sales,"$","");



-- Changing them into integers

alter table adidas_sales
modify Price_per_Unit int;

alter table adidas_sales
modify Operating_Profit int;

alter table adidas_sales
modify Total_Sales int;



-- Removing "," from Units Sold so we can convert it into integer

update adidas_sales
set Units_Sold = replace(Units_Sold,",","");

alter table adidas_sales
modify Units_Sold int;



-- Changing Operating Margin to integer

update adidas_sales
set Operating_Margin = replace(Operating_Margin,"%","");

alter table adidas_sales
modify Operating_Margin int;


-- Converting Invoice date to date format

select Invoice_date ,str_to_date(Invoice_Date,"%m/%d/%Y")
from adidas_sales
limit 1000;

update adidas_sales
set Invoice_date = str_to_date(Invoice_Date,"%m/%d/%Y");



/* BUISSNESS QUESTIONS */

-- Top 10 cities with highest sales

select City , sum(Total_Sales) as Sales
from adidas_sales
group by City
order by Sales desc;


-- Bottom 10 cities with lowest sales

select City , sum(Total_Sales) as Sales
from adidas_sales
group by City
order by Sales asc;


-- Product sales and percentage sales

with Product_Sales as 
(select Product , sum(Total_Sales) as Sales
from adidas_sales
group by Product
order by Sales desc),

Overall_Product_Sales as 
(select sum(Total_Sales) as Overall_Product_Sales
from adidas_sales)

select Product, Sales , (Sales/Overall_Product_Sales)*100 as Percentage_Sales
from Product_sales,Overall_Product_Sales;


-- Region Sales and percentage sales

with region_sales as 
(select Region , sum(Total_Sales) as Sales
from adidas_sales
group by Region
order by Sales desc),

overall_total as 
(select sum(Total_Sales) as Overall_total_sales
from adidas_sales)

select Region , Sales, (Sales/Overall_total_sales)*100 as percentage_sales
from region_sales, overall_total;


-- Region wise Product Sales

select Region , Product, sum(Total_Sales) as Sales
from adidas_sales
group by Region, Product;


-- Region wise no of units of products sold

select Region , Product, sum(Units_Sold) as Units
from adidas_sales
group by Region, Product;


-- Best Sales method 

select Sales_method, sum(Total_Sales) as Sales
from adidas_sales
group by Sales_method
order by Sales Desc
limit 1;


-- Best Performing Product in terms of sales and in terms of unit sold 

select Product ,sum(Total_Sales) as Sales,sum(Units_Sold) as Units
from adidas_sales
group by Product
order by Sales desc
limit 1;

-- Most Attractive Price 50,55,45,60,40

select Price_per_Unit, sum(Units_Sold) as Units
from adidas_sales
group by Price_per_Unit
order by Units desc
limit 10;


-- Product Operating Profit

select Product, sum(Operating_Profit) as Profit
from adidas_sales
group by Product
order by Profit desc;


-- Region wise operating profit of each product

with Regionwise_OP as (
select Region, Product, sum(Operating_Profit) as RegionWiseProfit
from adidas_sales
group by Region, Product
),

Total_OP as (
select sum(Operating_Profit) as Total_OP
from adidas_sales
)

select Region ,Product , (RegionWiseProfit/Total_OP)*100 as percentage_contribution_to_OP, RegionWiseProfit
from Regionwise_OP, Total_OP;


-- Product with lowest Operating Margin-Men Atheletic Footwear

select Product, avg(Operating_Margin) as OM
from adidas_sales
group by Product
order by OM asc;


-- Mens vs Womens Products 

select distinct(product) as MenProducts, sum(Total_Sales) as Sales
from adidas_sales
where Product like "Men%"
group by MenProducts
order by Sales desc;


select distinct(product) as WomenProducts, sum(Total_Sales) as Sales
from adidas_sales
where Product like "Women%"
group by WomenProducts
order by Sales desc;



-- Retailer performence

select Retailer, sum(Total_Sales) as Sales, sum(Operating_Profit) as OP , avg(Operating_Margin) as OM
from adidas_sales
group by Retailer
order by Sales desc;













