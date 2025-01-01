-- Retail Sales Analysis - MySQL

-- Creation of database

create database Retail_sales_analysis;

-- Create TABLE

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );
select * from retail_sales
limit 10;

-- (i) Data Cleaning
select * from retail_sales
where transactions_id is null
or 
sale_date is null
or 
sale_time is null
or 
gender is null
or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null;

-- Deletion of null values

Delete from retail_sales
where 
transactions_id is null
or 
sale_date is null
or 
sale_time is null
or 
gender is null
or 
category is null
or 
quantiy is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null;

-- (ii)Data Exploaration

select * from retail_sales;
-- How many sales we have?
select count(Total_sale) from retail_sales;

-- How many customers we have?
select count(distinct customer_id) as no_of_Customers
from retail_sales;

-- How many categories we have?
select distinct category
from retail_sales;


-- (iii) Data Analysis and bysiness case senarios

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05?
select * from retail_sales
where
month(sale_date) = 11
and 
day(sale_date) = 05
and 
year(sale_date) = 2022;

-- Alternate Query
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022:
select * from retail_sales
where category = 'Clothing'
and quantiy > 2
and month(sale_date) = 11
and year(sale_date) = 2022;

-- Alternate query
select * from retail_sales
where category = 'Clothing'
and quantiy > 2
and date_format(sale_date,'%Y-%m') = '2022-11';

-- 3. Write a SQL query to calculate the total sales (total_sale) and total order(total_order) for each category?
select category, sum(total_sale) as total_sale,
count(Transactions_id) as total_order
from retail_sales
group by category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category?
select round(avg(age),1) as average_age
from retail_sales
where category = 'Beauty';

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000?
select * from retail_sales
where total_sale >1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?
select category, gender,count(Transactions_id) as no_of_transactions
from retail_sales
group by 1,2
order by 1;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

with Best_selling_month as 
(
select date_format(sale_date,'%M') as month_name, date_format(sale_date,'%Y') as Year_wise,
round(avg(total_sale),2) as Average_sale, 
dense_rank() over(partition by date_format(sale_date,'%Y') order by round(avg(total_sale),2) desc ) as rk 
from retail_sales
group by month_name,Year_wise
order by 1,2
)
select month_name,Year_wise,Average_sale
from Best_selling_month
where rk = 1
order by 2;

-- Alternate Query

with Best_selling_month as 
(
select extract(month from sale_date) as month,extract(year from sale_date) as year,
round(avg(total_sale),2) as Average_sale, 
dense_rank() over(partition by extract(year from sale_date) order by round(avg(total_sale),2) desc ) as rk 
from retail_sales
group by month,year
order by 1,2
)
select month,year,Average_sale
from Best_selling_month
where rk = 1
order by 2;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales?

select customer_id, sum(total_sale) as totalsale
from retail_sales
group by customer_id
order by customer_id,totalsale desc
limit 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category?

select category, count(distinct customer_id) no_of_unique_customers
from retail_sales
group by category;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)?

with No_of_orders as 
(select * , time_format(sale_time,'%H') as hours,  -- time_format(sale_time,'%H') '%H' for 24hrs format and '%h' for 12hr format
case
	when time_format(sale_time,'%H') <12 then 'Morning'
    when time_format(sale_time,'%H') between 12 and 17 then 'Afternoon'
	Else  'Evening'
end
as shift
from retail_sales)
select shift, count(Transactions_id) as  Total_orders
from No_of_orders
group by shift;

-- Alternate query

with No_of_orders as 
(select * , extract(hour from sale_time) as hours,
case
	when extract(hour from sale_time) <12 then 'Morning'
    when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
	Else 'Evening'
end
as shift from retail_sales)
select shift, count(Transactions_id) as Total_orders
from No_of_orders
group by shift;

-- Alternate query

select 
case 
	when hour(sale_time) < 12 then 'Morning'
    when hour(sale_time) between 12 and 17 then 'Afternoon'
    else 'Evening' 
end as Shift,
count(*) as Total_orders
from retail_sales
group by shift 
order by Total_orders desc;

-- End of the project








