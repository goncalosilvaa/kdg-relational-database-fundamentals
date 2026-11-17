-- Enterprise Table Creation

CREATE TABLE departments(
    department_id NUMERIC(2)
        CONSTRAINT pk_departments PRIMARY KEY,
    department_name VARCHAR(20) NOT NULL,
    manager_id CHAR(9),
    mgr_start_date DATE
);

CREATE TABLE employees(
    employee_id CHAR(9)
        CONSTRAINT pk_employees PRIMARY KEY,
    last_name   VARCHAR(25) NOT NULL,
    first_name  VARCHAR(25) NOT NULL,
    infix       VARCHAR(25),
    street      VARCHAR(50),
    location    VARCHAR(25),
    province    CHAR(2),
    postal_code VARCHAR(7),
    birth_date  DATE,
    salary      NUMERIC(7, 2)
        CONSTRAINT ch_employees_salary CHECK(salary<=85000),
    parkingspot NUMERIC(4) UNIQUE,
    gender      VARCHAR(50) NOT NULL,
    department_id   NUMERIC(2)
        CONSTRAINT fk_employees_department_id REFERENCES departments(department_id),
    manager_id      CHAR(9)
        CONSTRAINT fk_employees_manager_id REFERENCES employees(employee_id)
);

CREATE TABLE projects(
    project_id      NUMERIC(2)
        CONSTRAINT pk_projects PRIMARY KEY,
    project_name    VARCHAR(25) NOT NULL,
    location        VARCHAR(25),
    department_id   NUMERIC(2)
        CONSTRAINT fk_projects_department_id REFERENCES departments(department_id)
);

CREATE TABLE locations(
    department_id   NUMERIC(2)
        CONSTRAINT fk_locations_department_id REFERENCES departments(department_id),
    location    VARCHAR(20) NOT NULL,
    CONSTRAINT pk_locations PRIMARY KEY(department_id, location)
);

CREATE TABLE tasks(
    employee_id CHAR(9)
        CONSTRAINT fk_tasks_employee_id REFERENCES employees(employee_id),
    project_id  NUMERIC(2)
        CONSTRAINT fk_tasks_project_id REFERENCES projects(project_id),
    hours       NUMERIC(5,1)
        CONSTRAINT ch_tasks_hours CHECK(hours BETWEEN 0 AND 9999),
    CONSTRAINT pk_tasks PRIMARY KEY(employee_id, project_id)
);

CREATE TABLE family_members(
    employee_id CHAR(9)
        CONSTRAINT fk_family_members_employee_id REFERENCES employees(employee_id),
    name        VARCHAR(50) NOT NULL,
    gender      VARCHAR(50) NOT NULL,
    birth_date  DATE
        CONSTRAINT ch_family_members_birth_date CHECK(birth_date BETWEEN TO_DATE('20-03-1950', 'DD-MM-YYYY') AND TO_DATE('01-01-2018', 'DD-MM-YYYY')),
    relationship VARCHAR(10) NOT NULL,
    CONSTRAINT pk_family_members PRIMARY KEY(employee_id, name)
);
