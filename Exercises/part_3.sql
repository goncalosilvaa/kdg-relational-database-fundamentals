-- Intro
SELECT TO_CHAR(CURRENT_DATE, 'Day DD Month YYYY');
SELECT TO_CHAR(CURRENT_TIMESTAMP, 'Day DD Month YYYY HH24:MI');
SELECT TO_CHAR(CURRENT_TIMESTAMP, 'Day FMDD FMMonth YYYY HH24:MI'); // "FM" makes a system date more readable

SET lc_time='nl-NL';
SELECT TO_CHAR(CURRENT_TIMESTAMP, 'Day TMDD TMMonth YYYY HH24:MI'); // "TM" -> Translation mode

INSERT INTO departments
    VALUES(9, 'KDG', '999111111', TO_DATE('01-05-1981', 'DD-MM-YYYY'));

DELETE FROM departments WHERE department_id=9;

SELECT *
    FROM departments;

show datestyle;

show lc_time;

-- Ex: 1 Give the employee numbers of those with children under 18?
SELECT *
FROM family_members
WHERE UPPER(relationship) IN('SON', 'DAUGHTER');

SELECT name, birth_date, birth_date+interval '18 years'
FROM family_members
WHERE birth_date+interval '18 years' > CURRENT_DATE;

-- Ex: 2 Which employees from Eindhoven or Maarssen are older than 30?
SELECT employee_id, last_name, location, age(birth_date)
FROM employees
WHERE LOWER(location) IN ('eindhoven', 'maarssen')
AND AGE(birth_date)>INTERVAL '30 years'
ORDER BY employee_id;

-- Ex 3: Which employees have a partner with an age between 35y and 50y? Give the
-- number of the employee and the age of that partner.
SELECT employee_id, AGE(birth_date)
FROM family_members
WHERE UPPER(relationship) = 'PARTNER'
AND AGE(birth_date) BETWEEN INTERVAL '30 years' AND INTERVAL '50 years';

-- Ex 4: For each employee, give the date when he/she will retire. Assume that the
-- retirement age is 65 and that one retires on his/her birthday.
SELECT first_name, last_name, TO_CHAR(birth_date, 'FMDD FMMonth YYYY') AS "Date of birth",
       TO_CHAR(birth_date+INTERVAL '65 years', 'FMDay FMMonth YYYY') pension
       FROM employees
       ORDER BY pension;

-- Ex 5 a. Enter the date of birth of family members in the format below. Note the
-- order.
SELECT name, TO_CHAR(birth_date, 'day DD month YYYY') AS "born on"
FROM family_members
ORDER BY birth_date DESC;

-- Ex 5 b. Do the same but provide a custom format.
SELECT name, TO_CHAR(birth_date, 'FMday FMDD FMmonth YYYY') AS "born on"
FROM family_members
ORDER BY birth_date DESC;

-- Ex 5 c. And now put this in "French”
SET lc_time='fr_FR';

SELECT name, TO_CHAR(birth_date, 'TMday FMDD TMmonth YYYY') AS "born on"
FROM family_members
ORDER BY birth_date DESC;

-- Ex 6: Provide the full name of each employee! Please provide a solution that:
-- a) Does not use a function
    SELECT first_name || '' || last_name
    FROM employees;

-- b) Only uses the function concat
    SELECT CONCAT_WS(' ', first_name, infix, last_name)
    FROM employees;

-- c) Uses functions concat, lpad (to add a blank) and length each used once
    SELECT CONCAT(first_name, LPAD(last_name, LENGTH(last_name)+1, ' '))
    FROM employees;

    SELECT LPAD('tomtomtom', 5, '*');
    SELECT LENGTH('sdqdjqs hsqdjqjs    jqk');

-- Ex 7: Get the address of all employees to which you apply the following:
-- a) Convert all characters to lowercase
    SELECT LOWER(street)
    FROM employees;

-- b) Remove the initial 'z' from the address
    SELECT TRIM(LEADING 'z' FROM LOWER(street))
    FROM employees;

-- c) Show 30 characters each, if the address is shorter complete the string
    SELECT RPAD(TRIM(LEADING 'z' FROM LOWER(street)), 30, '*')
    FROM employees;

-- with '*' characters

-- Ex 8: List all employees with the letter 'o' in their name and first name? Use a text
-- function.
    SELECT first_name, last_name
    FROM employees
    WHERE LOWER(first_name) LIKE '%o%'
    AND LOWER(last_name) LIKE '%o%';

-- Using position:
    SELECT first_name, last_name
    FROM employees
    WHERE position('o' IN LOWER(last_name))>0
        AND position('o' IN LOWER(first_name))>0;

-- Ex 9: List all employees who have 2 O's in a row in their last name and no other O's.
    SELECT last_name
           /**
             position('oo' in LOWER(last_name)),
             SUBSTRING(LOWER(last_name) for position('oo' in LOWER(last_name))-1),
             SUBSTRING(LOWER(last_name) from position('oo' in LOWER(last_name))+2)
             */
    FROM employees
    WHERE position('oo' IN LOWER(last_name))>0
    AND position('o' in SUBSTRING(LOWER(last_name) for position('oo' in LOWER(last_name))-1))=0
    AND position('o' in SUBSTRING(LOWER(last_name) from position('oo' in LOWER(last_name))+2))=0;

    UPDATE employees
    SET last_name='Omelsvoort'
    WHERE last_name='Amelsvoort';

    SELECT last_name
    FROM employees
    WHERE last_name ILIKE '%oo%'
    AND last_name NOT ILIKE '%o%o%o%';

-- Ex 10: In employees' addresses, replace all the letters 'e' with an 'o' except the first 'e'.
    SELECT street, REPLACE(LOWER(street), 'e', 'o'),
            INITCAP(CONCAT(SUBSTRING(street for POSITION('e' in street)),
            REPLACE(LOWER(SUBSTRING(street from POSITION('e' in street)+1)), 'e', 'o')))
    FROM employees;

-- Ex 11: Form an email address for each employee. Form: 3 first characters of first name + "."
-- + 3 first characters of the last name + "@" + name of the department + ".be". All
-- must be in lower case. Do not use a || sign.
    SELECT first_name, last_name, LOWER(CONCAT(SUBSTRING(first_name for 3), '.', SUBSTRING(last_name for 3), '@', d.department_name,'.be'))
    FROM employees e
    INNER JOIN departments d
    ON e.department_id=d.department_id;