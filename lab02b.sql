/*
  Lab 02: MariaDB Tutorial
  CSC 362 Database Systems
  Fronk Student Copy

  Creates DB based on figure 7.22
*/

/* Create the database (dropping the previous version if necessary */
DROP DATABASE IF EXISTS school;

CREATE DATABASE school;

USE school;


/* Create the instructors table */

CREATE TABLE instructors(
    PRIMARY KEY (instructor_id),
    instructor_id INT AUTO_INCREMENT,
    inst_first_name VARCHAR(20),
    inst_last_name VARCHAR(20),
    campus_phone VARCHAR(20)
);

/* Populate the tables with data from 7.22 */
INSERT INTO instructors (inst_first_name,inst_last_name,campus_phone)
VALUES ('Kira','Bently','363-9948'),
       ('Timothy','Ennis','527-4992'),
       ('Shannon','Black','336-5992'),
       ('Estela','Rosales','322-6992');

/* Use SELECT to display instructors table*/

 SELECT * FROM instructors;

/* End of file lab02b.sql */