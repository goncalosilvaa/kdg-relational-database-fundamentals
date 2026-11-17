-- Creating tables from a LDM to a DDL.

CREATE TABLE students (
    student_id  CHAR(10)
            CONSTRAINT pk_students PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    street      VARCHAR(100) NOT NULL,
    nr          NUMERIC(4) NOT NULL
            CONSTRAINT ch_students_nr CHECK(nr>0),
    postalcode  NUMERIC(4) NOT NULL
            CONSTRAINT ch_students_postalcode CHECK(postalcode BETWEEN 1000 AND 9999),
    city        VARCHAR(10) NOT NULL,
    birth_date  DATE NOT NULL
            CONSTRAINT ch_students_birth_date CHECK(birth_date<CURRENT_DATE)
);
-- DROP TABLE IF EXISTS students;

CREATE TABLE classes (
    class_id    NUMERIC(4)
            CONSTRAINT pk_classes PRIMARY KEY,
    building    CHAR(2) NOT NULL
            CONSTRAINT ch_classes_building CHECK(building IN('GR', 'PH', 'SW')),
    floor       NUMERIC(1) NOT NULL
            CONSTRAINT ch_classes_floor CHECK(floor BETWEEN 0 AND 5),
    roomnumber  NUMERIC(2) NOT NULL
            CONSTRAINT ch_classes_roomnumber CHECK(roomnumber>=0)
);
-- DROP TABLE IF EXISTS classes;

CREATE TABLE student_classes (
    student_id  CHAR(10)
            CONSTRAINT fk_student_classes_student_id REFERENCES students(student_id),
    class_id    NUMERIC(4)
            CONSTRAINT fk_student_classes_class_id REFERENCES classes(class_id),
    CONSTRAINT pk_student_classes PRIMARY KEY(student_id, class_id)
);
-- DROP TABLE IF EXISTS student_classes;