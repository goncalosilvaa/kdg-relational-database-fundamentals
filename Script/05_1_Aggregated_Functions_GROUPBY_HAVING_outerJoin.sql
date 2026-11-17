-- ************************************************************
-- Run this script in Entreprise (normal, not BIG)
-- ************************************************************
SELECT USER;

-- ************************************************************
-- 1. Analytical functions
-- ************************************************************
-- ******************************
-- AVG
-- ******************************
SELECT AVG(salary) "Average Salary"
FROM employees;

SELECT ROUND(AVG(salary)) "Average Salary"
FROM employees;

SELECT ROUND(AVG(DISTINCT salary)) "Average Salary"
FROM employees;

-- ******************************
-- SUM
-- ******************************
SELECT SUM(salary) total
FROM employees;

SELECT SUM(DISTINCT salary) total
FROM employees;

-- ******************************
-- MIN MAX
-- ******************************
SELECT MIN(salary) "lowest salary",
       MAX(salary) "highest salary"
FROM employees;

SELECT MIN(last_name) "first",
       MAX(last_name) "last"
FROM employees;

SELECT MIN(birth_date) "oldest",
       MAX(birth_date) "youngest"
FROM employees;

-- ******************************
-- COUNT
-- ******************************
SELECT employee_id, last_name, manager_id
FROM employees;

SELECT COUNT(*) employee_count
FROM employees;

SELECT COUNT(employee_id) employee_count
FROM employees;

SELECT COUNT(employee_id) employee_count
FROM tasks;

SELECT COUNT(DISTINCT employee_id) employee_count
FROM tasks;

SELECT COUNT(manager_id) manager_count
FROM employees;

-- ******************************
-- General
-- ******************************
SELECT last_name, department_id, salary
FROM employees
ORDER BY department_id;

SELECT ROUND(AVG(salary), 1) avg_sal_dep3
FROM employees
WHERE department_id = 3;

SELECT SUM(salary) tot_sal_dep7
FROM employees
WHERE department_id = 7;

SELECT MIN(last_name) "first in alphabet (dep3)",
       MAX(last_name) "last in alphabet (dep3)"
FROM employees
WHERE department_id = 3;

SELECT COUNT(*) emp_count
FROM employees;
SELECT COUNT(*) count_dep3
FROM employees
WHERE department_id = 3;

-- ************************************************************
-- 2. GROUP BY
-- ************************************************************
--
-- Count number of employees per department
--
-- Overview (data set)
SELECT employee_id, first_name, last_name, department_id
FROM employees
ORDER BY department_id;

-- Solution?
SELECT COUNT(*) "count dep 1"
FROM employees
WHERE department_id = 1;

SELECT COUNT(*) "count dep 3"
FROM employees
WHERE department_id = 3;

SELECT COUNT(*) "count dep 7"
FROM employees
WHERE department_id = 7;

SELECT first_name
FROM employees
WHERE department_id = 7;

-- Solution
SELECT department_id, COUNT(*) count_emp
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- SELECT list (!!)
SELECT department_id, COUNT(*) count_emp, first_name -- Nope!
FROM employees
GROUP BY department_id
ORDER BY department_id;

--
-- Calculate yearly salary cost for women per department
--
SELECT department_id, salary
FROM employees
WHERE LOWER(gender) = 'f';

SELECT department_id, SUM(salary) "yearly salary cost"
FROM employees
WHERE LOWER(gender) = 'f'
GROUP BY department_id;

--
-- Calculate the average wage cost per department.
-- Order ascending, based on average.
--
SELECT department_id, ROUND(AVG(salary)) "average salary"
FROM employees
GROUP BY department_id
ORDER BY 2;

--
-- Calculate total salary cost for men per department
-- Order by descending amounts
--
SELECT department_id, SUM(salary) "totale salary cost"
FROM employees
WHERE LOWER(gender) = 'm'
GROUP BY department_id
ORDER BY 2 DESC;

-- ********************************
-- Nesting of analytical functions
-- ********************************
--
-- Average of highest salary
--

SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary)>33000;

-- Overview (data set)
SELECT last_name, salary
FROM employees;

-- What is the highest salary?
SELECT MAX(salary) MAX_SAL
FROM employees;

-- Pointless: the average of the highest salary
-- ORA-00978: "nested group function without GROUP BY"
SELECT AVG(MAX(salary)) MAX_SAL
FROM employees;

SELECT ROUND(AVG(max_sal.max)) avg_max_sal
FROM (SELECT MAX(salary) as max
      FROM employees
      GROUP BY department_id) as max_sal;

SELECT department_id, ROUND(AVG(max_sal.max)) avg_max_sal
FROM (SELECT department_id, MAX(salary) as max
      FROM employees
      GROUP BY department_id) as max_sal
GROUP BY department_id;



--> Redefine:
-- Retrieve the average of the highest salaries per department
SELECT department_id, MAX(salary) MAX_SAL
FROM employees
GROUP BY department_id
ORDER BY department_id;

SELECT AVG(MAX(salary)) GEM_MAX_SAL
FROM employees
GROUP BY department_id;

-- Give the average of the highest salaries per department:
-- ORA-00937: "not a single-group group function"
SELECT department_id, AVG(MAX(salary)) "gem_max_sal/afdeling"
FROM employees
GROUP BY department_id;
--> Welk afdeling nummer zou er gegeven moeten worden?

SELECT x.department_id, ROUND(AVG(x.max)) gem_max_sal
FROM (SELECT MAX(salary) as max, department_id
      FROM employees
      GROUP BY department_id) as x
GROUP BY department_id;

--
-- Give the highest salary, per department 
--
SELECT department_id, MAX(salary) "max_sal/department"
FROM employees
GROUP BY department_id
ORDER BY department_id;
--> Execution of an analytical function on this result is possible


-- ************************************************************
-- 3. HAVING
-- ************************************************************
--
-- Retrieve the highest salary per department 
-- But only show values smaller than 45000
--
SELECT department_id, MAX(salary) "max_sal/department"
FROM employees
GROUP BY department_id
HAVING MAX(salary) < 45000
ORDER BY department_id;

--
-- Give an overview of the departments with an average salary that is higher than 33000
--
-- Overview (data set)
SELECT department_id, employee_id, salary
FROM employees
ORDER BY salary;

-- Nope
--SELECT department_id, employee_id, salary
--FROM employees
--WHERE salary>33000
--ORDER BY salary;

-- ORA-00934: "group function is not allowed here"
SELECT department_id, AVG(salary)
FROM employees
WHERE AVG(salary) > 33000
ORDER BY department_id;

-- Step 1
SELECT department_id, ROUND(AVG(salary)) Average_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;
-- Step 2
SELECT department_id, ROUND(AVG(salary)) Average_salary
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 33000
ORDER BY department_id;

-- Nope
--SELECT department_id, AVG(salary) Average_salary
--FROM employees
--GROUP BY department_id
--HAVING Gemiddeld_salary> 33000    --> Nope
--ORDER BY department_id;

--
-- Retrieve average salary per department
-- We're only interested in departments that have more than 2 employees 
--
SELECT department_id, ROUND(AVG(salary)) avg_salary, COUNT(*)
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

--
-- Extra
--
SELECT last_name || ' ' || first_name "Naam", department_id, salary
FROM employees
ORDER BY department_id, salary;

SELECT department_id, salary, COUNT(*)
FROM employees
GROUP BY department_id, salary
ORDER BY department_id;



-- **************************************
-- 4. OUTER JOINS
-- **************************************

-- ******************************
-- Example 1: problem
-- For every employee, retrieve the family composition (employee_id, last_name, first_name, name, relation).
-- ******************************


SELECT e.employee_id, e.last_name, e.first_name, f.name, f.relationship
FROM employees e
         JOIN family_members f ON (e.employee_id = f.employee_id)
ORDER BY e.employee_id;

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e;

SELECT f.employee_id, f.name, f.relationship
FROM employees e
         JOIN family_members f ON (e.employee_id = f.employee_id)
ORDER BY e.employee_id;

-- LEFT OUTER JOIN

SELECT e.employee_id, e.first_name, f.name, f.relationship
FROM employees e
         LEFT JOIN family_members f
                   ON (e.employee_id = f.employee_id)
ORDER BY e.employee_id;

-- RIGHT OUTER JOIN

SELECT e.employee_id, e.first_name, f.name, f.relationship
FROM family_members f
         RIGHT JOIN employees e
                    ON (e.employee_id = f.employee_id)
ORDER BY e.employee_id;

-- ******************************
-- Example 1: Can the previous query also be written as
-- ******************************

--change e.employee_id into f.employee_id
SELECT e.employee_id, e.last_name, f.name, f.relationship
FROM employees e
         LEFT JOIN family_members f
                   ON (e.employee_id = f.employee_id)
ORDER BY e.employee_id;


-- ******************************
-- Example 2 - preparation
-- ******************************

INSERT INTO family_members (employee_id, name, gender, relationship)
VALUES ('999111111', 'Anke', 'F', 'DAUGHTER');
-- error  ==>   null value in column "birth_date"

ALTER TABLE family_members
    ALTER COLUMN birth_date DROP NOT NULL;

-- try again
INSERT INTO family_members (employee_id, name, gender, relationship)
VALUES ('999111111', 'Anke', 'F', 'DAUGHTER');

-- OK ?
SELECT f.employee_id, f.name, f.gender, f.birth_date, f.relationship
FROM family_members f;

-- ******************************
-- Example 2
-- Which employees do not have family members?
-- ******************************


-- LEFT Join -> provides ALL employees,
-- Next use a WHERE clause to filter to only necessary employees
SELECT f.employee_id, e.last_name, f.name, f.birth_date
FROM employees e
         LEFT JOIN family_members f
                   ON (e.employee_id = f.employee_id)
--WHERE f.name IS NULL
ORDER BY e.employee_id;

-- Could we get to same result using other NULL columns ?
SELECT f.employee_id, e.last_name, f.name, f.birth_date
FROM employees e
         LEFT JOIN family_members f
                   ON (e.employee_id = f.employee_id)
WHERE f.birth_date IS NULL
ORDER BY e.employee_id;

-- -> This is NOT the result we expected


-- ******************************
-- PREPARATION : FULL OUTER JOIN
-- ******************************

INSERT INTO departments
VALUES (4, 'Research', '999444444', NOW());

INSERT INTO employees (employee_id, last_name, first_name)
VALUES (999999999, 'Janssens', 'Jan');

SELECT d.department_id, d.department_name, e.employee_id, e.last_name
FROM departments d
         LEFT OUTER JOIN employees e ON d.department_id = e.department_id
ORDER BY d.department_id;

-- ******************************
-- FULL OUTER JOIN
-- ******************************

SELECT d.department_id, d.department_name, e.employee_id, e.last_name
FROM departments d
         LEFT OUTER JOIN employees e ON d.department_id = e.department_id
ORDER BY d.department_id;

SELECT d.department_id, d.department_name, e.employee_id, e.last_name
FROM departments d
         RIGHT OUTER JOIN employees e ON d.department_id = e.department_id
ORDER BY d.department_id;

SELECT d.department_id, d.department_name, e.employee_id, e.last_name
FROM departments d
         FULL OUTER JOIN employees e ON d.department_id = e.department_id
ORDER BY d.department_id;
