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

-- Queries quality

# Write your MySQL query statement below
SELECT query_name , 
        Round(    
            (SUM(rating / position)) / count(*) 
        ,2)                                         AS quality,
        ROUND(
            (100 * 
                (SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END) 
                / 
                count(*)
                )
            )
        ,2)                                         AS poor_query_percentage
FROM Queries
Group by query_name

-- Monthly transactions

SELECT
    DATE_FORMAT(trans_date, '%Y-%m') AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(state = 'approved') AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY
    month, country
ORDER BY
    month, country;

-- Inmmediate food delivery

SELECT ROUND(
         100.0 * AVG(order_date = customer_pref_delivery_date),
         2
       ) AS immediate_percentage
FROM Delivery
WHERE order_date = (
    SELECT MIN(order_date)
    FROM Delivery d2
    WHERE d2.customer_id = Delivery.customer_id
);

-- GAME PLAY

WITH first_login AS (
    SELECT player_id, MIN(event_date) AS first_date
    FROM Activity
    GROUP BY player_id
)
SELECT
    ROUND(
        COUNT(DISTINCT a.player_id) /
        COUNT(DISTINCT fl.player_id),
        2
    ) AS fraction
FROM first_login fl
LEFT JOIN Activity a
       ON a.player_id = fl.player_id
      AND a.event_date = DATE_ADD(fl.first_date, INTERVAL 1 DAY);

-- Number of subjects

SELECT teacher_id, count(distinct subject_id) as cnt
from Teacher
group by teacher_id

-- User activty

Select activity_date as day, count(distinct user_id) as active_users
FROM activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27' 
GROUP BY activity_date
    
-- Product sales analyst

WITH FirstYear AS (
  SELECT product_id, MIN(year) AS first_year
  FROM Sales
  GROUP BY product_id
)
SELECT s.product_id, s.year as first_year, s.quantity, s.price
FROM Sales s
JOIN FirstYear f
  ON s.product_id = f.product_id AND s.year = f.first_year;

-- Classes

SELECT class
FROM Courses
group by class
HAVING COUNT(class) >= 5

-- Follower count

SELECT user_id, count(user_id) as followers_count
FROM Followers
GROUP by user_id
order by user_id asc

-- Biggest single number

select(
SELECT num as num
FROM MyNumberS
GROUP BY num
HAVING count(*) = 1
ORDER BY num desc
LIMIT 1) as num

-- Number of reports

With reports AS (
    SELECT e.reports_to as Manager_id,
    COUNT(*) AS Reports,
    ROUND(AVG(age)) AS age
    FROM Employees e
    WHERE e.reports_to IS NOT NULL
    GROUP BY e.reports_to
)

SELECT e.employee_id, e.name, r.reports AS reports_count, r.age AS average_age 
FROM reports r
JOIN Employees e on e.employee_id = r.manager_id 
ORDER BY e.employee_id ASC

-- Primary department

SELECT employee_id, department_id
FROM Employee
WHERE employee_id IN (
    SELECT employee_id
    FROM Employee
    GROUP BY employee_id
    HAVING COUNT(*) = 1 OR primary_flag = "Y"
)

-- Triangle judgement

SELECT x,y,z,
  CASE 
    WHEN x + y > z AND x + z > y AND y + z > x THEN 'Yes'
    ELSE 'No'
  END AS triangle
FROM Triangle;

-- Employees whose manager left

SELECT employee_id
FROM Employees
WHERE salary < 30000 and manager_id NOT IN ( SELECT employee_id from Employees)
ORDER BY employee_id ASC

