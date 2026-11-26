-- ============================================
-- PROJECT: EMPLOYEE DATA ANALYSIS
-- DOMAIN: DATA ENGINEERING
-- DATABASE: employee_data_project
-- TOOL: MYSQL WORKBENCH
-- PURPOSE: Practise SQL queries, data manipulation,
--          data analysis and relational database concepts
-- ============================================

USE employee_data_project;

-- ============================================
-- 1. DATABASE AND TABLE CREATION
-- Create Employees Table

CREATE TABLE employees (
    employee_id INT NOT NULL,
    employee_name VARCHAR(100) DEFAULT NULL,
    department VARCHAR(50) DEFAULT NULL,
    salary DECIMAL(10,2) DEFAULT NULL,
    hire_date DATE DEFAULT NULL,
    city VARCHAR(50) DEFAULT NULL,
    department_id INT DEFAULT NULL,
    manager_id INT DEFAULT NULL,
    PRIMARY KEY (employee_id)
);

-- Create Departments Table

CREATE TABLE departments (
    department_id INT NOT NULL,
    department_name VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (department_id)
);
-- ============================================


-- ============================================
-- 2. INSERT DATA
-- ============================================
-- Insert Employee Records

INSERT INTO employees
(employee_id, employee_name, department, salary, hire_date, city, department_id)
VALUES
(101, 'Arun', 'IT', 45000, '2024-05-10', 'Chennai', 10),
(102, 'Priya', 'HR', 35000, '2023-08-15', 'Bangalore', 20),
(103, 'Karthik', 'IT', 55000, '2022-03-20', 'Chennai', 10),
(104, 'Divya', 'Finance', 40000, '2024-01-05', 'Coimbatore', 30),
(105, 'Rahul', 'HR', 38000, '2023-11-12', 'Chennai', 20),
(106, 'Sneha', 'Finance', 48000, '2021-07-18', 'Bangalore', 30),
(107, 'Vijay', 'IT', 60000, '2020-09-25', 'Hyderabad', 10),
(108, 'Meena', 'Sales', 32000, '2024-06-01', 'Chennai', 40),
(109, 'Ajay', 'Sales', 36000, '2022-12-10', 'Coimbatore', 40),
(110, 'Nisha', 'Finance', 52000, '2021-02-14', 'Chennai', 30);

-- Insert Department Records

INSERT INTO departments
(department_id, department_name)
VALUES
(10, 'IT'),
(20, 'HR'),
(30, 'Finance'),
(40, 'Sales');

-- ============================================
-- 3. BASIC SELECT QUERIES
-- ============================================
-- Display all employee records

SELECT *
FROM employees;

-- Display employee name and salary

SELECT
    employee_name,
    salary
FROM employees;

-- Display all departments

SELECT *
FROM departments;

-- Display unique department names

SELECT DISTINCT department
FROM employees;

-- Count total employees

SELECT COUNT(*) AS TOTAL_EMPLOYEES
FROM employees;

-- ============================================
-- 4. FILTERING AND SORTING
-- ============================================
-- 1. Employees from IT department
SELECT *
FROM employees
WHERE department = 'IT';

-- 2. Employees earning more than 40000
SELECT *
FROM employees
WHERE salary > 40000;

-- 3. Employees from Chennai
SELECT *
FROM employees
WHERE city = 'Chennai';

-- 4. Employees hired in 2024
SELECT *
FROM employees
WHERE hire_date BETWEEN '2024-01-01' AND '2024-12-31';

-- 5. Sort employees by salary (highest first)
SELECT *
FROM employees
ORDER BY salary DESC;

-- 6. Display top 3 highest-paid employees
SELECT *
FROM employees
ORDER BY salary DESC
LIMIT 3;

-- ============================================
-- 5. AGGREGATE FUNCTIONS
-- ============================================
-- Total number of employees
SELECT COUNT(*) AS TOTAL_EMPLOYEES
FROM employees;

-- Total salary
SELECT SUM(salary) AS TOTAL_SALARY
FROM employees;

-- Average salary
SELECT AVG(salary) AS AVERAGE_SALARY
FROM employees;

-- Highest salary
SELECT MAX(salary) AS HIGHEST_SALARY
FROM employees;

-- Lowest salary
SELECT MIN(salary) AS LOWEST_SALARY
FROM employees;

-- ============================================
-- 6. GROUP BY AND HAVING
-- ============================================
-- Number of employees in each department
SELECT department, COUNT(*) AS EMPLOYEE_COUNT
FROM employees
GROUP BY department;

-- Average salary by department
SELECT department, AVG(salary) AS AVERAGE_SALARY
FROM employees
GROUP BY department;

-- Total salary by department
SELECT department, SUM(salary) AS TOTAL_SALARY
FROM employees
GROUP BY department;

-- Departments with more than 2 employees
SELECT department, COUNT(*) AS EMPLOYEE_COUNT
FROM employees
GROUP BY department
HAVING COUNT(*) > 2;

-- ============================================
-- 7. JOINS
-- ============================================
-- INNER JOIN
SELECT E.employee_name, D.department_name
FROM employees E
INNER JOIN departments D
ON E.department_id = D.department_id;

-- LEFT JOIN
SELECT E.employee_name, D.department_name
FROM employees E
LEFT JOIN departments D
ON E.department_id = D.department_id;

-- RIGHT JOIN
SELECT E.employee_name, D.department_name
FROM employees E
RIGHT JOIN departments D
ON E.department_id = D.department_id;

-- SELF JOIN: Employee and manager ID
SELECT
    E.employee_name AS EMPLOYEE,
    E.manager_id AS MANAGER_ID
FROM employees E
LEFT JOIN employees M
ON E.manager_id = M.employee_id;

-- SELF JOIN: Employee and manager name
SELECT
    E.employee_name AS EMPLOYEE,
    M.employee_name AS MANAGER
FROM employees E
LEFT JOIN employees M
ON E.manager_id = M.employee_id;

-- CROSS JOIN
SELECT E.employee_name, D.department_name
FROM employees E
CROSS JOIN departments D;

-- ============================================
-- 8. SUBQUERIES AND CTEs
-- ============================================
-- Employees earning above overall average salary
SELECT employee_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

-- Employees earning the highest salary
SELECT employee_name, salary
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);

-- Department-wise average salary using CTE
WITH DEPT_AVG AS (
    SELECT
        department_id,
        AVG(salary) AS AVERAGE
    FROM employees
    GROUP BY department_id
)
SELECT *
FROM DEPT_AVG;

-- Employees earning above their department average
WITH DEPT_AVG AS (
    SELECT
        department_id,
        AVG(salary) AS AVERAGE
    FROM employees
    GROUP BY department_id
)
SELECT
    E.employee_name,
    E.department_id,
    E.salary,
    D.AVERAGE AS DEPARTMENT_AVERAGE
FROM employees E
INNER JOIN DEPT_AVG D
ON E.department_id = D.department_id
WHERE E.salary > D.AVERAGE;

-- ============================================
-- 9. CASE STATEMENTS
-- ============================================
-- Categorise employees based on salary
SELECT
    employee_name,
    salary,
    CASE
        WHEN salary >= 50000 THEN 'HIGH SALARY'
        WHEN salary >= 40000 THEN 'MEDIUM SALARY'
        ELSE 'LOW SALARY'
    END AS SALARY_CATEGORY
FROM employees;

-- Categorise employees by department
SELECT
    employee_name,
    department,
    CASE
        WHEN department = 'IT' THEN 'TECHNICAL'
        WHEN department = 'HR' THEN 'HUMAN RESOURCES'
        WHEN department = 'Finance' THEN 'FINANCIAL'
        ELSE 'OTHER'
    END AS DEPARTMENT_CATEGORY
FROM employees;

-- ============================================
-- 10. WINDOW FUNCTIONS
-- ============================================
-- Average salary of all employees
SELECT
    employee_name,
    salary,
    AVG(salary) OVER() AS AVERAGE_SALARY
FROM employees;

-- Row number based on salary
SELECT
    employee_name,
    salary,
    ROW_NUMBER() OVER(ORDER BY salary DESC) AS ROW_NUM
FROM employees;

-- RANK
SELECT
    employee_name,
    salary,
    RANK() OVER(ORDER BY salary DESC) AS SALARY_RANK
FROM employees;

-- DENSE_RANK
SELECT
    employee_name,
    salary,
    DENSE_RANK() OVER(ORDER BY salary DESC) AS DENSE_RANK
FROM employees;

-- LEAD
SELECT
    employee_name,
    salary,
    LEAD(salary) OVER(ORDER BY salary) AS NEXT_SALARY
FROM employees;

-- LAG
SELECT
    employee_name,
    salary,
    LAG(salary) OVER(ORDER BY salary) AS PREVIOUS_SALARY
FROM employees;

-- Department-wise salary ranking
SELECT
    employee_name,
    department_id,
    salary,
    RANK() OVER(
        PARTITION BY department_id
        ORDER BY salary DESC
    ) AS DEPARTMENT_RANK
FROM employees;

-- ============================================
-- 11. STRING AND DATE FUNCTIONS
-- ============================================
-- Employee names in uppercase
SELECT UPPER(employee_name) AS EMPLOYEE_NAME
FROM employees;

-- Length of employee names
SELECT
    employee_name,
    LENGTH(employee_name) AS NAME_LENGTH
FROM employees;

-- Year employees joined
SELECT
    employee_name,
    YEAR(hire_date) AS JOINING_YEAR
FROM employees;

-- Employees who joined in 2024
SELECT *
FROM employees
WHERE YEAR(hire_date) = 2024;

-- Number of years since joining
SELECT
    employee_name,
    hire_date,
    TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS YEARS_WORKED
FROM employees;

-- ============================================
-- 12. CONSTRAINTS AND DATA INTEGRITY
-- ============================================ 
-- Check employees table structure
DESCRIBE employees;

-- Check departments table structure
DESCRIBE departments;

-- Check table constraints
SHOW CREATE TABLE employees;

SHOW CREATE TABLE departments;

-- Check employee records without a matching department
SELECT E.*
FROM employees E
LEFT JOIN departments D
ON E.department_id = D.department_id
WHERE D.department_id IS NULL;

-- Check duplicate employee IDs
SELECT employee_id, COUNT(*) AS ID_COUNT
FROM employees
GROUP BY employee_id
HAVING COUNT(*) > 1;

-- Check duplicate department IDs
SELECT department_id, COUNT(*) AS ID_COUNT
FROM departments
GROUP BY department_id
HAVING COUNT(*) > 1;