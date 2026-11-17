--***********************
--Combo exercises week 5
--***********************


------------
--Exercise 2
------------
--List the projects, for which the total hours worked is more than 30, and display
--  how many employees worked (ie. performed tasks) on this project
--  and the project name
--  and the name of the department that supports this project
--Sort by project name.
-- Make sure the you get exactly the output as shown below.
--   (e.g. 3 columns, aliases, constants and concatenations)

/*
+-----------+-------------------------------------+------------------------------------------+
|#employees |project                              |department                                |
+-----------+-------------------------------------+------------------------------------------+
|3 employees|perform tasks on Debtors             |which is supported by dept. Administration|
|3 employees|perform tasks on Inventory           |which is supported by dept. Administration|
|3 employees|perform tasks on Ordermanagement     |which is supported by dept. Production    |
|3 employees|perform tasks on Salaryadministration|which is supported by dept. Production    |
|2 employees|perform tasks on Warehouse           |which is supported by dept. Production    |
+-----------+-------------------------------------+------------------------------------------+
*/

-----------------------
-- ANSWER QUESTION 2 --
-----------------------
    SELECT CONCAT(COUNT(t.employee_id), ' employees') "#employees",
           CONCAT('perform tasks on ', p.project_name) project,
           CONCAT('which is supported by dept. ', d.department_name) department
    FROM projects p
    JOIN tasks t ON(p.project_id=t.project_id)
    JOIN departments d ON(p.department_id=d.department_id)
    GROUP BY p.project_name, d.department_name
    HAVING SUM(t.hours)>30
    ORDER BY p.project_name;
