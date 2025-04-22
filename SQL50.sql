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

--- Employee Bonus

SELECT Employee.name, Bonus.bonus
FROM Employee
LEFT JOIN Bonus on Employee.empId = Bonus.empId
WHERE Bonus.bonus < 1000 OR Bonus.bonus is null

-- Students and examinations
Select s.student_id, s.student_name, sb.subject_name, (count(ex.subject_name)) as attended_exams
FROM Students s
CROSS JOIN Subjects sb
LEFT JOIN Examinations ex on s.student_id = ex.student_id AND sb.subject_name = ex.subject_name
GROUP by 1,2,3
order by s.student_id, sb.subject_name

-- Managers


WITH tables as (
    SELECT managerId, count(*) as cc 
    from Employee  
    group by 1 
    HAVING count(*) > 4)  

SELECT name from employee
inner join tables on employee.id = tables.managerId

-- confirmation rate

SELECT 
  s.user_id, 
  IFNULL(
    ROUND(
      SUM(CASE WHEN c.action = 'confirmed' THEN 1 ELSE 0 END) / 
      NULLIF(SUM(CASE WHEN c.action IN ('timeout', 'confirmed') THEN 1 ELSE 0 END), 0),
    2),
  0) AS confirmation_rate
FROM Signups s
LEFT JOIN Confirmations c ON c.user_id = s.user_id
GROUP BY s.user_id;

-- NOT boring movies

SELECT id, movie, description, rating
FROM Cinema
WHERE description <> "boring" and mod(id,2) <> 0
order by rating desc

-- Average selling price

SELECT
    p.product_id,
    COALESCE(                                             
        ROUND(
            SUM(p.price * i.units)                        
            / NULLIF(SUM(i.units), 0),                    
        2),
    0) AS average_price
FROM Prices      AS p                                     
LEFT JOIN UnitsSold AS i
       ON i.product_id = p.product_id
      AND i.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY
    p.product_id;

-- Project employees

# Write your MySQL query statement below
SELECT project_id, 
        ROUND (
            sum(e.experience_years) / count(p.employee_id)
        ,2) as average_years
FROM Project p
LEFT JOIN Employee e on e.employee_id = p.employee_id
group by project_id

-- Contest

WITH total_users AS (                 
    SELECT COUNT(*) AS total
    FROM   Users
)
SELECT
    r.contest_id,
    ROUND(100.0 * COUNT( r.user_id)
                / t.total, 2)                    AS PERCENTAGE
FROM   Register r                                
CROSS  JOIN total_users t                        
GROUP  BY
    r.contest_id,
    t.total
ORDER BY
    percentage DESC,
    r.contest_id ASC



