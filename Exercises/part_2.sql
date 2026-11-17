-- SELECT STATEMENT


-- SELECT without table
-- a. query for today's date
SELECT CURRENT_DATE;
SELECT CURRENT_TIMESTAMP;
SELECT CURRENT_TIME;

-- b. calculate a 15% discount on 150.
SELECT 150*0.85;
SELECT 150-150*0.15;

-- c. use the separate words
SELECT 'Data Retrieval', 'Chapter 3-4', 'SQL';
SELECT 'Data Retrieval', 'Chapter 3-4', 'SQL', NULL;
SELECT CONCAT('Data Retrieval', 'Chapter 3-4'); -- Doesn't have a separator
SELECT CONCAT_WS(' ', 'Data Retrieval', 'Chapter 3-4'); -- Has a separator on the first argument
SELECT CONCAT_WS(' ', 'Data Retrieval', 'Chapter 3-4') AS "Best course"; -- Has a table name

-- Which people belong to the family of employee 999111111? You must obtain exactly
-- the following table of results.
SELECT first_name, last_name
FROM employees
WHERE employee_id='999111111';

SELECT employee_id AS employee, name "NAME FAMILY MEMBER", relationship, gender
FROM family_members
WHERE employee_id='999111111'
ORDER BY 2;

SELECT *
FROM employees
WHERE birth_date=TO_DATE('01-09-1965', 'DD-MM-YYYY');

SELECT INITCAP('this is a test');

-- Provide all information about the administration department?
SELECT *
FROM departments
WHERE department_name='Administration';

-- We would like an overview of all employees with residence in Maastricht and use the
-- following instruction
SELECT employee_id, last_name, location
FROM employees
WHERE LOWER(location)='maastricht';

-- Which employees worked between 20 and 35 hours (both inclusive) on project 10?
-- Display the employee number, project number, and number of hours worked.
SELECT *
FROM tasks
WHERE project_id=10
AND hours BETWEEN 20 AND 35;

SELECT *
FROM tasks
WHERE project_id=10
AND hours>=20
AND hours <=35;

-- On which projects did employee 999222222 work less than 10 hours? Provide project
-- number and number of hours.
SELECT project_id, hours
FROM tasks
WHERE employee_id='999222222'
AND hours<10;

-- Which employees are from the province of Groningen (GR) or Noord Brabant (NB)?
-- Solve in 2 ways!
SELECT employee_id, last_name, province
FROM employees
WHERE UPPER(province)='GR'
OR UPPER(province)='NB'
ORDER BY 2;

SELECT employee_id, last_name, province
FROM employees
WHERE UPPER(province) IN('GR', 'NB')
ORDER BY 2;

-- Are there any employees with first name Suzan, Martina, Henk or Douglas and in which
-- department do they work? Sort by department number (in descending order) and within
-- that alphabetically by first name.
SELECT department_id, first_name
FROM employees
WHERE LOWER(first_name) IN ('suzan', 'martina', 'henk', 'douglas')
ORDER BY 1 DESC, first_name;

-- We want to include in our results table:
-- Name, department number, and salary of employees in department 7 earning less than
-- 40000
-- + name, department number, and salary of employee 999666666
SELECT last_name, salary, department_id
FROM employees
WHERE (department_id=7
    AND salary<40000)
    OR employee_id='999666666'
ORDER BY department_id, last_name;

SELECT CONCAT_WS(' ', last_name, first_name) AS name, department_id, salary
FROM employees
WHERE (department_id=7
    AND salary<40000)
    OR employee_id='999666666'
ORDER BY department_id, last_name;

-- Which employees do not live in Maarssen and neither in Eindhoven?
SELECT last_name, department_id
FROM employees
WHERE LOWER(location) NOT IN('eindhoven' , 'maarssen')
ORDER BY location;

-- Summarize the contents of the table TASKS.
-- a. Sort by HOURS in ascending order.
-- Ensure that rows with a NULL value for HOURS are displayed first.
SELECT *
FROM tasks
ORDER BY hours DESC NULLS LAST
OFFSET 3 ROWS
FETCH NEXT 3 ROWS WITH TIES;