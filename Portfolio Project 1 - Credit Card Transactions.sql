-- SQL porfolio project.
-- download credit card transactions dataset from below link :
-- https://www.kaggle.com/datasets/thedevastator/analyzing-credit-card-spending-habits-in-india
-- import the dataset in sql server with table name : credit_card_transcations
-- change the column names to lower case before importing data to sql server.Also replace space within column names with underscore.
-- (alternatively you can use the dataset present in zip file)
-- while importing make sure to change the data types of columns. by defualt it shows everything as varchar.

-- write 4-6 queries to explore the dataset and put your findings 
use new_schema;
-- solve below questions
-- 1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 
select city, sum(Amount) as total_amount,
CONCAT(CAST(SUM(amount)/(SELECT SUM(amount) FROM credit_card_transcations) * 100 AS DECIMAL(5,2)), '%')  Percentage_to_Total
from credit_card_transcations
group by city
order by total_amount desc
limit 5;
-- 2- write a query to print highest spend month and amount spent in that month for each card type
   

-- 3- write a query to print the transaction details(all columns from the table) for each card type when
	-- it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
    with cte as(
              select *,
              sum(amount) over (partition by card_type order by amount ) as total
              from credit_card_transcations
              ),
               cte1 as(
              select *,
              row_number() over (partition by card_type order by amount) as num
              from cte
              where total >=1000000 
              )
              select*
              from cte1
              where num =1;
              
-- 4- write a query to find city which had lowest percentage spend for gold card type
select*
from credit_card_transcations;
with cte as(
	select city, sum(Amount) as total_amount,card_type,
	CONCAT(CAST(SUM(amount)/(SELECT SUM(amount) FROM credit_card_transcations) * 100 AS DECIMAL(5,2)), '%')  Percentage_to_Total
	from credit_card_transcations
	group by city, card_type
    ),
    cte1 as (
    select city,card_type,
    dense_rank() over (partition by card_type order by Percentage_to_Total) as lowest
    from cte
    group by city,card_type
    )
    select city
    from cte1
    where lowest =1 and card_type = 'gold';

-- 5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
with highest_expense_type as(
	select city,exp_type,
	dense_rank() over( order by exp_type) as  highest_expense_type
	from credit_card_transcations
    group by city,exp_type
    ) ,
    lowest_expense_type as (
    select city,exp_type,
	dense_rank() over( order by exp_type desc) as  lowest_expense_type
	from credit_card_transcations
    group by city,exp_type
   )
   select h.city,h.exp_type,l.exp_type
   from highest_expense_type as h
   inner join lowest_expense_type as l
   on h.city = l.city;

-- 6- write a query to find percentage contribution of spends by females for each expense type

	select exp_type,
	sum(case 
			when gender = 'f' then amount else 0 end )  / sum(amount) *100 AS PER
	from credit_card_transcations
    group by exp_type;
    
-- 7- which card and expense type combination saw highest month over month growth in Jan-2014
WITH monthly_spending AS (
-- using this CTE to select the total spent per expense type, per year month in the data set
  SELECT 
    Card_Type,
    Exp_Type,
    date_format(date, 'yyyy-MM') as Month, -- this picks the year and month (2011-01)
    SUM(Amount) as Total_Spent
  FROM credit_card_transcations
  GROUP BY Card_Type, Exp_Type, date_format(date, 'yyyy-MM')
),
monthly_growth AS (
  SELECT 
    Card_Type,
    Exp_Type,
    Month,
    /* Calculating growth
      1. The "LAG" function is used to access the value of "Total_Spent" from the previous row within each partition of "Card_Type" and "Expense_Type" and ordered by "Month".
      2. LAG(Total_Spent, 1, 0), this means the previous total_spent record will be fetched and 0 when no previous record exist especially for the first record
    */
    (Total_Spent - LAG(Total_Spent, 1, 0) OVER (PARTITION BY Card_Type, Exp_Type ORDER BY Month))  -- total spend is taken from previous total spend
                      /  -- division
    LAG(Total_Spent, 1, 0) OVER (PARTITION BY Card_Type, Expense_Type ORDER BY Month) -- previous total spend
    
    as Growth -- this calculated column is called Growth
  FROM monthly_spending -- using the first CTE
)
SELECT 
  Card_Type, 
  Exp_Type,
  Month,
  Growth
FROM monthly_growth -- everything is selected from the second CTE
WHERE Month = '2014-01' -- filtered to January 2014
ORDER BY Growth DESC
LIMIT 1; -- for the highest growth

-- 8- during weekends which city has highest total spend to total no of transcations ratio 
SELECT City,SUM(amount) /count(amount) AS ratio_spend
FROM credit_card_transcations
WHERE DAYOFWEEK(date) IN (1, 7)  
GROUP BY City
ORDER BY ratio_spend DESC
LIMIT 1;

-- 9- which city took least number of days to reach its 500th transaction after the first transaction in that city
WITH city_transactions AS (
    -- this CTE uses the ROW_Number window function to rank the various transaction date
    -- the first transaction will have a Transaction_Number of 1
    SELECT 
        City,
        date,
        ROW_NUMBER() OVER (PARTITION BY City ORDER BY date) as Transaction_Number
    FROM credit_card_transcations
),
first_transaction AS (
-- this CTE stores the first transaction
    SELECT City, date as First_Transaction_Date
    FROM city_transactions
    WHERE Transaction_Number = 1
),
five_hundredth_transaction AS (
-- this CTE stores the 500 transaction
    SELECT City, date as Five_Hundredth_Transaction_Date
    FROM city_transactions
    WHERE Transaction_Number = 500
)
SELECT 
    f.City, 
    -- the datediff function calculates the days it took to achieve the first and 500 transaction per city
    datediff(h.Five_Hundredth_Transaction_Date, f.First_Transaction_Date) as Days_to_500th_Transaction
FROM first_transaction f 
JOIN five_hundredth_transaction h ON f.City = h.City
ORDER BY Days_to_500th_Transaction ASC 
LIMIT 1; -- picks the least day

-- once you are done with this create a github repo to put that link in your resume. Some example github links:
-- https://github.com/ptyadana/SQL-Data-Analysis-and-Visualization-Projects/tree/master/Advanced%20SQL%20for%20Application%20Development
-- https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/COVID%20Portfolio%20Project%20-%20Data%20Exploration.sql