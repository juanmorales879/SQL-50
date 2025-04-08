-- Recyclable and low fat products

SELECT product_id
FROM Products
Where low_fats = "Y"
    AND recyclable = 'Y'

-- Find customer referee


SELECT name
from Customer
where referee_id != 2 OR
    referee_id is null

-- Big countries

Select name, population, area
from World
where area >= 3000000 or population >= 25000000

-- Article views

select distinct(author_id) as id
from Views
where author_id = viewer_id
order by id asc

-- Invalid tweets

select tweet_id
from Tweets
where length(content) > 15

-- Replace employee id with unique identifier

select EmployeeUNI.unique_id, e.name from Employees as e
left join EmployeeUNI on E.id = EmployeeUNI.id

-- Product sales analysis

SELECT Product.product_name, year, price from Sales
left join Product on Sales.product_id = Product.product_id

-- Customer who visited but did not make any transactions

select customer_id, count(*) as count_no_trans from Visits
where visit_id NOT IN (Select visit_id from Transactions)
group by customer_id
order by customer_id

-- Rising temperature

SELECT id
FROM Weather w1
WHERE temperature > (
    SELECT temperature 
    FROM Weather 
    WHERE recordDate = DATE_SUB(w1.recordDate, INTERVAL 1 DAY)
);

-- Average time per processing

WITH table_summary AS (
  SELECT 
    machine_id, 
    process_id,
    SUM(CASE WHEN activity_type = 'start' THEN timestamp ELSE 0 END) AS start_time,
    SUM(CASE WHEN activity_type = 'end' THEN timestamp ELSE 0 END) AS end_time
  FROM activity
  GROUP BY machine_id, process_id
)

SELECT 
  machine_id, 
  ROUND(AVG(end_time - start_time), 3) AS processing_time
FROM table_summary
GROUP BY machine_id;


