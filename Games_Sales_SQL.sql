create database games;

use games;

select*
from video_games_sales_as_at_22_dec_2016;

set sql_safe_updates = 0;


-- Filling up blanks with relevant information 

update	video_games_sales_as_at_22_dec_2016
set Critic_Score = "Not Reviewed"
where Critic_Score = "";

update	video_games_sales_as_at_22_dec_2016
set Critic_Count = "Not Reviewed"
where Critic_Count = "";

update	video_games_sales_as_at_22_dec_2016
set User_Score = "Not Reviewed"
where User_Score = "";

update	video_games_sales_as_at_22_dec_2016
set User_Count = "Not Reviewed"
where User_Count = "";

update	video_games_sales_as_at_22_dec_2016
set Developer = "Not Recorded"
where Developer = "";

update	video_games_sales_as_at_22_dec_2016
set Rating = "Not Rated"
where Rating = "";

update	video_games_sales_as_at_22_dec_2016
set Genre = "Misc."
where Genre = "";

/* SALES ANALYSIS */


-- Top 10 companies based on global sales

with Overall_Sales as 
(select sum(Global_Sales) as Overall_Sales
from video_games_sales_as_at_22_dec_2016),


Total_Sales as 
(select Publisher, sum(Global_Sales) as Total_Sales 
from video_games_sales_as_at_22_dec_2016
group by Publisher
order by Total_Sales desc)

select Publisher , Round(Total_Sales,2), Round(Total_Sales*100/Overall_Sales,2) as Percentage_Share_in_sales
from Overall_Sales, Total_Sales
limit 10;



-- Contrbution of each region to total sales of the publisher of top 10 companies

Select Publisher, round(sum(NA_Sales)*100/sum(Global_Sales),2) as Percentage_share_of_NA_Sales, 
round(sum(EU_Sales)*100/sum(Global_Sales),2) as Percentage_share_of_EU_Sales, 
round(sum(JP_Sales)*100/sum(Global_Sales),2) as Percentage_share_of_JP_Sales, 
round(sum(Other_Sales)*100/sum(Global_Sales),2) as Percentage_share_of_sales, 
round(sum(Global_Sales),2) as Total_Sales 
from video_games_sales_as_at_22_dec_2016
group by Publisher
order by Total_Sales desc 
limit 10;

-- Total Sales of bottom 10 the publishers in each region

Select Publisher, sum(NA_Sales) as Total_NA_Sales, sum(EU_Sales) as Total_EU_Sales, sum(JP_Sales) as Total_JP_Sales, sum(Other_Sales) as Total_other_sales
from video_games_sales_as_at_22_dec_2016
group by Publisher
order by Total_NA_Sales , Total_EU_Sales , Total_JP_Sales , Total_other_sales 
limit 10;

-- Total Sales in terms of Platform

Select Platform, round(sum(Global_Sales),2) as Total_Sales_in_millions
from video_games_sales_as_at_22_dec_2016
group by Platform
order by Total_sales_in_millions desc ;

-- Total Sales in terms of Genre(take the table and color the top 5)

Select Genre, round(sum(Global_Sales),2) as Total_Sales_in_millions
from video_games_sales_as_at_22_dec_2016
group by Genre
order by Total_Sales_in_millions desc ;


-- Best performing game of Top 10 publisher with thier reviews , developer and rating

(select Publisher,Name, Global_Sales, Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer, Rating
from video_games_sales_as_at_22_dec_2016
where Publisher = "Nintendo"
order by Global_Sales desc
limit 1)

union all

(select Publisher,Name, Global_Sales, Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer, Rating
from video_games_sales_as_at_22_dec_2016
where Publisher = "Electronic Arts"
order by Global_Sales desc
limit 1)

union all

(select  Publisher, Name, Global_Sales, Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer, Rating
from video_games_sales_as_at_22_dec_2016
where Publisher = "Activision"
order by Global_Sales desc
limit 1)

union all

(select Publisher, Name, Global_Sales, Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer, Rating
from video_games_sales_as_at_22_dec_2016
where Publisher = "Sony Computer Entertainment"
order by Global_Sales desc
limit 1)

union all

(select Publisher, Name, Global_Sales, Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer, Rating
from video_games_sales_as_at_22_dec_2016
where Publisher = "Take-Two Interactive"
order by Global_Sales desc
limit 1)

union all

(select Publisher, Name, Global_Sales, Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer, Rating
from video_games_sales_as_at_22_dec_2016
where Publisher = "Ubisoft"
order by Global_Sales desc
limit 1)

union all

(select Publisher, Name, Global_Sales, Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer, Rating
from video_games_sales_as_at_22_dec_2016
where Publisher = "Microsoft Game Studios"
order by Global_Sales desc
limit 1)

union all

(select Publisher, Name, Global_Sales, Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer, Rating
from video_games_sales_as_at_22_dec_2016
where Publisher = "THQ"
order by Global_Sales desc
limit 1)

union all

(select Publisher, Name, Global_Sales, Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer, Rating
from video_games_sales_as_at_22_dec_2016
where Publisher = "Sega"
order by Global_Sales desc
limit 1)

union all

(select Publisher, Name, Global_Sales, Year_of_Release, Critic_Score, Critic_Count, User_Score, User_Count, Developer, Rating
from video_games_sales_as_at_22_dec_2016
where Publisher = "Capcom"
order by Global_Sales desc
limit 1);



-- Best performing game year wise

with Max_sales_each_year as
(select  Year_of_release, max(Global_Sales) as max_sales 
from video_games_sales_as_at_22_dec_2016
group by Year_of_Release),

Games as
(select  Name, Publisher, Global_Sales, Critic_Score, Critic_Count, User_Score, User_Count, Developer, Rating
from video_games_sales_as_at_22_dec_2016)

select Year_of_release, Name, Publisher, Global_Sales
from Max_sales_each_year,Games
where Global_Sales = max_sales
order by Year_of_release desc;


-- No of games made in each rating class

select Rating, count(Name) as Number_of_Games
from video_games_sales_as_at_22_dec_2016
group by Rating;


-- Best game according to all the review site
select Name , Platform, Publisher, Genre, Year_of_Release, Critic_Score, Critic_Count, User_Score
from video_games_sales_as_at_22_dec_2016
where Critic_Score >90 and Critic_Count>90 and  User_Score>9 ;


-- Share of each region on global market

select round(sum(NA_Sales)*100/sum(Global_Sales),2) as Percentage_Share_of_NA,
round(sum(EU_Sales)*100/sum(Global_Sales),2) as Percentage_Share_of_EU,
round(sum(JP_Sales)*100/sum(Global_Sales),2) as Percentage_Share_of_JP,
round(sum(Other_Sales)*100/sum(Global_Sales),2) as Percentage_Share_of_Others
from video_games_sales_as_at_22_dec_2016;










