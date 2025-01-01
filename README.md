# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `Retail_sales_analysis`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `Retail_sales_analysis`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE Retail_sales_analysis;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
-- Determine the total number of records in the dataset.
SELECT COUNT(*) FROM retail_sales;

-- Find out how many unique customers are in the dataset.
select count(distinct customer_id) as no_of_Customers
from retail_sales;

-- Identify all unique product categories in the dataset.
select distinct category
from retail_sales;

-- Check for any null values in the dataset
select * from retail_sales
where transactions_id is null
or sale_date is null
or sale_time is null
or gender is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;

-- Delete records with missing data.
DELETE FROM 
where transactions_id is null
or sale_date is null
or sale_time is null
or gender is null
or category is null
or quantiy is null
or price_per_unit is null
or cogs is null
or total_sale is null;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```SQL
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
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022**:
```sql
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
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category, sum(total_sale) as total_sale,
count(Transactions_id) as total_order
from retail_sales
group by category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select round(avg(age),1) as average_age
from retail_sales
where category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select category, gender,count(Transactions_id) as no_of_transactions
from retail_sales
group by 1,2
order by 1;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select customer_id, sum(total_sale) as totalsale
from retail_sales
group by customer_id
order by customer_id,totalsale desc
limit 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select category, count(distinct customer_id) no_of_unique_customers
from retail_sales
group by category;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

