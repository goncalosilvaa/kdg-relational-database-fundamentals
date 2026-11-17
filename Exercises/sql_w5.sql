-- Total of hours in the Tasks table
    SELECT SUM(hours)
    FROM tasks;

-- Salary by department
    SELECT department_id, salary, COUNT(*)
    FROM employees
    GROUP BY department_id, salary
    ORDER BY department_id;

-- Calculate the average wage cost per department
    SELECT department_id,
           ROUND(AVG(salary)) "avg salary"
    FROM employees
    GROUP BY department_id, salary
    ORDER BY 2;

-- Exercise 1
    -- This query is incorrect because we're using an aggregate function in the WHERE clause
    SELECT *
    FROM employees
    WHERE AVG(salary)>30000;

    -- A GROUP BY clause is missing from this query
    SELECT employee_id, SUM(hours)
    FROM tasks;

-- Exercise 2
    SELECT hours
    FROM tasks
    WHERE employee_id='999444444';

    SELECT COUNT(hours)
    FROM tasks
    WHERE employee_id='999444444';

    SELECT SUM(hours)
    FROM tasks
    WHERE employee_id='999444444';

    -- Conclusion: The first query tells us the hours that the employee has in the Tasks table, the
    -- second one gives us the number of rows from the hours that belongs to that employee and the
    -- third one gives us back the total amount of hours that the employee have worked.

-- Exercise 3
    SELECT SUM(salary)
    FROM employees;

    SELECT COUNT(salary)
    FROM employees;

    -- Conclusion: The first query gives us back the SUM of all the wages and the second query gives
    -- us the amount of rows where the salary appears.

-- Exercise 4
    SELECT COUNT(*)
    FROM tasks;

    SELECT COUNT(hours)
    FROM tasks;

    -- Conclusion: The first query counts the number of records in the Tasks table and the second query
    -- gives us back how many records with "hours" are in the Tasks table.

-- Exercise 5: Return the number of projects that staff are currently working on.
    SELECT COUNT(DISTINCT project_id)
    FROM tasks;

-- Exercise 6: How many hours were spent on average on project 30?
    SELECT ROUND(AVG(hours)) "number_of_hours"
    FROM tasks
    WHERE project_id=30;

-- Exercise 7: How many staff members have children?
    SELECT COUNT(DISTINCT employee_id) "employees_with_kids"
    FROM family_members
    WHERE UPPER(relationship) IN('SON', 'DAUGHTER');

-- Exercise 8: What is the highest number of hours spent on Project 20?
    SELECT MAX(hours) "highest amount hours"
    FROM tasks
    WHERE project_id=20;

    -- With ORDER BY and FETCH
    SELECT hours "highest amount hours"
    FROM tasks
    WHERE project_id=20
    ORDER BY hours DESC NULLS LAST
    FETCH FIRST 1 ROW ONLY;

-- Exercise 9: What is the date of birth of employee 999111111’s youngest child?
    SELECT MAX(birth_date) "youngest child"
    FROM family_members
    WHERE employee_id='999111111'
        AND UPPER(relationship) IN('SON', 'DAUGHTER');

    -- With ORDER BY and FETCH/LIMIT
    SELECT birth_date "youngest child"
    FROM family_members
    WHERE employee_id='999111111'
        AND UPPER(relationship) IN('SON', 'DAUGHTER')
    ORDER BY birth_date DESC
    LIMIT 1;

    SELECT birth_date "youngest child"
    FROM family_members
    WHERE employee_id='999111111'
      AND UPPER(relationship) IN('SON', 'DAUGHTER')
    ORDER BY birth_date DESC NULLS LAST
    FETCH FIRST 1 ROW ONLY;

-- Exercise 10: What is the average length of employees’ surnames?
    SELECT ROUND(AVG(LENGTH(last_name))) "Average length last_name"
    FROM employees;

-- Exercise 11: For each project, give the number of staff working on that project.
    SELECT project_id, COUNT(*) "number_of_employees"
    FROM tasks
    GROUP BY project_id
    ORDER BY project_id;

-- Exercise 12: For each department, state the number of staff who come from the province of Limburg
-- (LI).
    SELECT department_id, COUNT(*) "number_employees"
    FROM employees
    WHERE UPPER(province)='LI'
    GROUP BY department_id
    ORDER BY department_id;

-- Exercise 13: State the number of subordinates for each manager.
    SELECT me.manager_id, COUNT(*) "number_employees"
    FROM employees me
    INNER JOIN employees e ON(me.employee_id=e.employee_id)
    WHERE me.manager_id IS NOT NULL
    GROUP BY me.manager_id;

-- Exercise 14: How many projects does a department support per location?
    SELECT department_id, location, COUNT(*) "number of projects"
    FROM projects
    GROUP BY department_id, location
    ORDER BY department_id;

-- Part III (OUTER JOINS)
-- Exercise 23: Which type of join do I need to achieve the following: left outer join, right outer
-- join, inner join or full outer join? The following attributes must be in the result set.

                            -- EMPLOYEES        DEPARTMENTS
                            -- employee_id      department_id
                            -- last_name        department_id department_id
                            -- department_name
                            -- department_id

-- 1. Show only employees who are linked to an existing department - INNER JOIN
-- 2. Show all employees, including those without a department. -- LEFT JOIN
-- 3. Show all departments, including those without employees. -- RIGHT JOIN
-- 4. Show both all employees and all departments, even if there is no match on
-- either side. -- FULL JOIN

-- Exercise 24
-- Given:
    SELECT d.department_name, e.last_name
    FROM departments d
    LEFT JOIN employees e ON d.department_id = e.department_id;
-- Query:
-- Suppose the Research department has no staff.
-- What value(s) would you expect in the results row for Research for ‘department_name’
-- and ‘last_name’?
    -- NULL value to the "Research" department.
-- Which table does the temporary NULL row come from?
    -- The "last_name" table.

-- Exercise 25: We are looking for staff members who are not working on any projects. The proposed
-- solution is as follows:
    SELECT e.employee_id, e.last_name, p.project_id, t.hours
    FROM employees e
        LEFT JOIN tasks t ON e.employee_id = t.employee_id
        LEFT JOIN projects p ON t.project_id = p.project_id
    WHERE t.hours IS NULL;
-- 1. Is this solution always safe? Try running the query without the WHERE clause.
    -- The solution is safe the way is structured.
-- 2. What information about ‘hours’ do you need to know first?
    -- The 'hours' must be NULL so that means the employee is not working on that project.
-- 3. Which attribute would you prefer to use to establish with certainty that no
-- ‘tasks’ row exists?
    -- On the WHERE clause we would use "WHERE t.project_id IS NULL" so we have no rows in tasks
    -- connecting to projects.

-- Exercise 26:
-- Given:
-- EMPLOYEES
-- employee_id      PRIMARY KEY
-- last_name        NOT NULL
-- parking_spot     NULL allowed
-- Which statements are correct? Which statement is incorrect and why?
-- 1. employee_id can never be NULL in a real table.
-- 2. last_name can never be NULL in a real row.
-- 3. ‘parking_spot IS NULL’ automatically means that the row was created by an
-- OUTER JOIN.
-- 4. After an OUTER JOIN, `employee_id` from the unmatched table may still appear
-- as `NULL` in the result.
-- 5. A PRIMARY KEY automatically has a NOT NULL property. (X)

-- Exercise 29: For each employee aged between 30 and 35, state the number of projects they have
-- worked on. Take a critical look at your results table!
    SELECT e.last_name, e.first_name, COUNT(t.project_id) "number of Projects"
    FROM employees e
    LEFT JOIN tasks t ON(e.employee_id=t.employee_id)
    WHERE DATE_PART('year', AGE(e.birth_date)) BETWEEN 30 AND 35
    GROUP BY e.last_name, e.first_name;

-- Exercise 30: List all departments and the projects they support (if any).
-- The results table should include: department name, project name and project location.
    SELECT d.department_name, p.project_name, p.location
    FROM departments d
    LEFT JOIN projects p ON(d.department_id=p.department_id);

-- Exercise 31:
-- a. List all employees whose surname begins with the letter ‘G’ or ‘J’ and also state the
-- name of the department in which they work. Also provide the names of their family
-- members.
    -- USING LIKE
    SELECT e.employee_id, e.last_name, d.department_name, fm.name
    FROM employees e
    LEFT JOIN departments d ON(e.department_id=d.department_id)
    LEFT JOIN family_members fm ON(e.employee_id=fm.employee_id)
    WHERE UPPER(e.last_name) LIKE 'G%'
    OR UPPER(e.last_name) LIKE 'J%'
    ORDER BY e.last_name;

    -- USING SUBSTRING
    SELECT e.employee_id, e.last_name, d.department_name, fm.name
    FROM employees e
    LEFT JOIN departments d ON(e.department_id=d.department_id)
    LEFT JOIN family_members fm ON(e.employee_id=fm.employee_id)
    WHERE SUBSTRING(UPPER(e.last_name) for 1) IN('G', 'J')
    ORDER BY e.last_name;

    -- USING LEFT
    SELECT e.employee_id, e.last_name, d.department_name, fm.name
    FROM employees e
    LEFT JOIN departments d ON(e.department_id=d.department_id)
    LEFT JOIN family_members fm ON(e.employee_id=fm.employee_id)
    WHERE LEFT(UPPER(e.last_name), 1) IN('G', 'J')
    ORDER BY e.last_name;

-- b. Suppose that each employee is always assigned to a department. (Let’s assume for
-- the moment that there is a NOT NULL constraint on the `department_id` column in the
-- `employees` table).
-- How can we then adapt the previous solution?
    SELECT e.employee_id, e.last_name, d.department_name, fm.name
    FROM employees e
    INNER JOIN departments d ON(e.department_id=d.department_id)
    LEFT JOIN family_members fm ON(e.employee_id=fm.employee_id)
    WHERE SUBSTRING(UPPER(e.last_name) for 1) IN('G', 'J')
    ORDER BY e.last_name;

-- Then LEFT JOIN is not necessary.

-- Exercise 32:
-- List all employees whose first name begins with the letter B, D, G, L or M, along with the
-- projects they are working on.
-- In the results table, we want the surname, first name, project name and the number of
-- hours that employee worked on that project. Note the order.
    SELECT e.last_name, e.first_name, p.project_name, t.hours
    FROM employees e
    LEFT JOIN tasks t ON(e.employee_id=t.employee_id)
    LEFT JOIN projects p ON(t.project_id=p.project_id)
    WHERE SUBSTRING(UPPER(e.first_name) for 1) IN('B', 'D', 'G', 'L', 'M')
    ORDER BY p.project_name, t.hours DESC, e.last_name DESC;

-- Exercise 33:
-- List all employees who are not managers of any other employee.
    SELECT m.employee_id, m.last_name
    FROM employees e
    RIGHT JOIN employees m ON(e.manager_id=m.employee_id)
    WHERE e.employee_id IS NULL
    ORDER BY m.employee_id;

-- Exercise 34:
-- List all employees who are not the manager of another employee or who do not have a
-- manager. Tip: Think carefully first about what type of join you need.
    SELECT e.last_name "has no manager", m.last_name "Does not manage employees"
    FROM employees e
    FULL JOIN employees m ON(e.manager_id=m.employee_id)
    WHERE e.employee_id IS NULL
    OR m.employee_id IS NULL
    ORDER BY m.last_name;
