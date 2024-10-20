------ Checking for all the values in the dataset.
select * from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

-----Checking for total available values in the dataset
select count(*) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

----- checking for max years in the dataset
select max(year_) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

----- Checking for the min year in the dataset
select min(year_) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

----- total bikes sold in the year of 2002
select sum(new + used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023 where year_=2002;

----- total bikes sold in the year of 2003
select sum(new + used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023 where year_=2003;

------ total bikes sold in the year of 2004
select sum(new + used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023 where year_=2004;

------- total bikes sold in the year of 2005
select sum(new + used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023 where year_=2005;

------- total bikes sold in the year of 2006
select sum(new + used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023 where year_=2006;

------ total number of bike sold so far
select sum(new + used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

------ max new bike sold
select max(new) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

----- min new bike sold
select min(new) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

----- total new bikes sold
select sum(new) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

---- max used bike sold
select max(used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

---- min used bike sold
select min(used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

---- total used bike sold
select sum(used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

---- total amount earned by selling both the bikes
select sum(total_sales_new + total_sales_used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

---- max amount earned 
select max(total_sales_new + total_sales_used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

---- min amount earned
select min(total_sales_new + total_sales_used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

--- avg amount earned
select avg(total_sales_new + total_sales_used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

---- total amount on sales_new
select sum(total_sales_new) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

---- total amount on sales_used
select sum(total_sales_used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

---- max amount on sales_new
select max(total_sales_new) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;

---- min amount on sales_new
select min(total_sales_new) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;


----- year wise total amount of new bikes sold
SELECT year_,SUM(total_sales_new) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023 GROUP BY year_ ORDER BY year_;


----- year wise total amount of used bikes sold
SELECT year_,SUM(total_sales_used) from MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023 GROUP BY year_ ORDER BY year_;


-------- Avg. new and used bike as per year
SELECT AVG(new) AS avg_new_sales,AVG(used) AS avg_used_sales FROM MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023;


------- year wise used and new sales data.
SELECT year_,
       SUM(new) AS total_new_sales,
       SUM(used) AS total_used_sales
FROM MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023
GROUP BY year_
ORDER BY year_;

------- Year and month wise total amount for new bike sales
SELECT month_,
       year_,
       SUM(new) AS total_new_sales
FROM MVA_Vehicle_Sales_Counts_by_Month_for_Calendar_Year_2002_through_December_2023
GROUP BY year_, month_
ORDER BY total_new_sales DESC;