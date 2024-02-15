create database sales_data
use sales_data
select * from [dbo].[WalmartSalesData.csv]

 --**Feature Engineering:- used to adding new columns
 --. Add a new column name  `time_of_day` 

 --ALWAYS KEEP IN MIND THAT TO ADD NEW COLUMN ALWAYS USE ALTER TABLE---

 alter table [dbo].[WalmartSalesData.csv]
 add time_of_day date

 drop table [WalmartSalesData.csv]

 --col add krne se phle i hv to get the names of daytime 
 -- ki whether jo time h vo  btana pdega ki ye mor h , afternoon ya fir evening

--whenever we will use case then always keeeep in mind ki we will
-- phle select(col. name)fir (,)
--fir -(- ye wala bracket then use (case) statement

select time,( case
      when time between '00:00:00' and '12:00:00' then 'morning'
	  when time between '12:01:00' and '16:00:00' then 'afternoon'
	  else 'evening'
	  end) time_of_day

from [dbo].[WalmartSalesData.csv]

select * from [dbo].[WalmartSalesData.csv]

---phle hmne define krdia ki time k according kya pdega--
--then usk baad hm add kr rhe h col. k name ko vhi--
alter table [dbo].[WalmartSalesData.csv]
add time_of_day varchar(20)

--abb update krdenge name ko by time of day and usme jo case statement thi we will write that as well--

update [dbo].[WalmartSalesData.csv]
set time_of_day=( case
      when time between '00:00:00' and '12:00:00' then 'morning'
	  when time between '12:01:00' and '16:00:00' then 'afternoon'
	  else 'evening'
	  end)

alter table [dbo].[WalmartSalesData.csv]
drop  column time_of_date

select * from [dbo].[WalmartSalesData.csv]

--Add a new column named `day_name`
--sbse phle we will hav to get the date then date k naam--

select date from [dbo].[WalmartSalesData.csv]

--date k naam chahiye to will use buit-in function
--weekday mtlb uss week k day suppose 5th then uss k will thursday--

select date,datename(dd,date) day_name from [dbo].[WalmartSalesData.csv]

alter table [dbo].[WalmartSalesData.csv]
add day_name varchar(20)

update [dbo].[WalmartSalesData.csv]
set day_name=datename(weekday,date)
select * from [dbo].[WalmartSalesData.csv]


-----SETTING UP MONTH NAME-----
--Add a new column named `month_name`

select date from [dbo].[WalmartSalesData.csv]


select date, datename(mm,date)month_name from [dbo].[WalmartSalesData.csv]

alter table [dbo].[WalmartSalesData.csv]
add month_name varchar(20)

update [dbo].[WalmartSalesData.csv]
set month_name=datename(mm,date)

select * from [dbo].[WalmartSalesData.csv]


--How many unique cities does the data have?

select distinct city, COUNT(distinct city) distinct_city_name
from [dbo].[WalmartSalesData.csv]
group by  city

--2. In which city is each branch?
select * from [dbo].[WalmartSalesData.csv]

select distinct city,branch
from [dbo].[WalmartSalesData.csv]

order by branch asc

--------------------PRODUCT ANALYSIS QUESTOIONS------------------
--1. How many unique product lines does the data have?

select * from [dbo].[WalmartSalesData.csv]

select  distinct product_line
from [dbo].[WalmartSalesData.csv]
group by product_line
order by product_line asc


--2. What is the most common payment method?

select MAX(payment) common_payment_method
from [dbo].[WalmartSalesData.csv]

select payment,count(payment) payment_method
from [dbo].[WalmartSalesData.csv]
group by payment

--3. What is the most selling product line?
select * from [dbo].[WalmartSalesData.csv]

select product_line,count(product_line) most_selling
from [dbo].[WalmartSalesData.csv]
group by product_line
order by count(product_line) desc


--4. What is the total revenue by month?
--jb bhi total revenue ki baat ho always use SUM function without thinking ---

select sum(total) total_revenue,month_name
from [dbo].[WalmartSalesData.csv]
group by month_name

--5. Which month had the largest COGS?
--konse month me largest cogs ki sale thi
select * from [dbo].[WalmartSalesData.csv]

select month_name,sum(cogs) largest_cogs
from [dbo].[WalmartSalesData.csv]
group by month_name

--6. What product line had the largest revenue?
--konse product line ki largest(sbse zyada) revenue hai

select product_line,sum(total) revenue
from [dbo].[WalmartSalesData.csv]
group by product_line

--5. What is the city with the largest revenue?

select city,sum(total)
from [dbo].[WalmartSalesData.csv]
group by city


--6. What product line had the largest VAT?
select * from [dbo].[WalmartSalesData.csv]
select product_line,AVG(total) avg
from [dbo].[WalmartSalesData.csv]
group by product_line
order by AVG(total) asc


--7. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

alter table [dbo].[WalmartSalesData.csv]
add product_line1 varchar(20)

select product_line, ( case
      when product_line> (select AVG(total) from [dbo].[WalmartSalesData.csv]) then 'Good'
	   else 'Bad' 
	   end) product_line1
	   from [dbo].[WalmartSalesData.csv]
	   group by product_line

select
	product_line,
    round(avg(total),2) as avg_sales,
    (case
		when AVG(total) > (SELECT AVG(total) FROM sales) then "Good"
        else "Bad"
	end) as remarks
from [dbo].[WalmartSalesData.csv]


select * from [dbo].[WalmartSalesData.csv]
alter table [dbo].[WalmartSalesData.csv]
drop column product_line1
from [dbo].[WalmartSalesData.csv]

--8. Which branch sold more products than average product sold?

select branch,SUM(quantity)
from [dbo].[WalmartSalesData.csv]
group by branch
having SUM(quantity)> (select AVG(quantity) from [dbo].[WalmartSalesData.csv])

--9. What is the most common product line by gender?

select * from [dbo].[WalmartSalesData.csv]

select gender,product_line,COUNT(gender)
from [dbo].[WalmartSalesData.csv]
group by gender,product_line

--12. What is the average rating of each product line?
select * from [dbo].[WalmartSalesData.csv]
select AVG(rating) avg_rt,product_line
from [dbo].[WalmartSalesData.csv]
group by product_line
order by AVG(rating) desc

---------------------SALES ANALYSIS--------------------

--1. Number of sales made in each time of the day per weekday

select time_of_day,COUNT(*)
from [dbo].[WalmartSalesData.csv]
where day_name='monday'
group by time_of_day

--2. Which of the customer types brings the most revenue?

select * from [dbo].[WalmartSalesData.csv]

select customer_type,sum(total)
from [dbo].[WalmartSalesData.csv]
group by customer_type


--3. Which city has the largest tax percent/ VAT (**Value Added Tax**)?

select * from [dbo].[WalmartSalesData.csv]
select city,avg(tax_5)
from [dbo].[WalmartSalesData.csv]
group by city

--4. Which customer type pays the most in VAT?

select customer_type,avg(tax_5)  zyada
from [dbo].[WalmartSalesData.csv]
group by customer_type

----------------CUSTOMER ANALYSIS-----------------
--1. How many unique customer types does the data have?

select * from [dbo].[WalmartSalesData.csv]

select distinct customer_type,count(customer_type)
from [dbo].[WalmartSalesData.csv]
group by customer_type

2. How many unique payment methods does the data have?