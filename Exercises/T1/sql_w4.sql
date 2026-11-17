-- Week 4 Exercises

-- Exercise 7
-- List employees who have their birth date in the same month. Note the order of the rows.
    SELECT e1.employee_id, e1.last_name, TO_CHAR(e1.birth_date, 'YYYY-MM-DD')
           -- e2.employee_id, e1.last_name, e1.birth_date
    FROM employees e1
    JOIN employees e2 ON(TO_CHAR(e1.birth_date, 'MM')=TO_CHAR(e2.birth_date, 'MM'))
                        AND e1.employee_id != e2.employee_id
    ORDER BY TO_CHAR(e1.birth_date, 'MM-DD');

-- Exercise 8
-- Which projects are supported by the same department as project (3) Warehouse? Please provide all project data
    SELECT p.*
    FROM projects wh
    JOIN projects p ON(wh.department_id=p.department_id)
                    AND wh.project_id!=p.project_id
    WHERE UPPER(wh.project_name)='WAREHOUSE'
    ORDER BY project_id;

-- Exercise 8 (enterprise_big)
-- Which projects are supported by the same department as project manager
-- as project Warehouse (Customer Retention)? Please provide all project data
    SELECT *
    FROM projects wh
    JOIN departments dwh ON(wh.department_id=dwh.department_id)
    JOIN departments d ON(dwh.manager_id=d.manager_id)
    JOIN projects p ON(d.department_id=p.department_id)
    WHERE UPPER(wh.project_name)='CUSTOMER RETENTION'
    AND wh.project_id!=p.project_id;

-- Exercise 9
-- A self join with a foreign key that points to a primary table is called recursive because
-- you can apply it multiple times.
-- Show the workers for whom Bordoloi is the boss of their boss
    -- Top down
    SELECT e.last_name employees, boss.last_name boss, uber.last_name uberboss
    FROM employees uber
    JOIN employees boss ON(uber.employee_id=boss.manager_id)
    JOIN employees e ON(boss.employee_id=e.manager_id)
    WHERE LOWER(uber.last_name)='bordoloi'
    ORDER BY boss, e.last_name;

    -- Bottom up
    SELECT e.last_name employees, boss.last_name boss, uber.last_name uberboss
    FROM employees e
             JOIN employees boss ON(e.manager_id=boss.employee_id)
             JOIN employees uber ON(boss.manager_id=uber.employee_id)
    WHERE LOWER(uber.last_name)='bordoloi'
    ORDER BY boss, e.last_name;

-- Homework
-- For employee "Douglas" give the boss of his department head's manager.

