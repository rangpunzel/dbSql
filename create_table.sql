DROP TABLE REGIONS cascade constraints  PURGE ;
DROP TABLE COUNTRIES CASCADE CONSTRAINTS PURGE;
DROP TABLE JOBS CASCADE CONSTRAINTS PURGE;
DROP TABLE EMPLOYEES  CASCADE CONSTRAINTS  PURGE;
DROP TABLE JOB_HISTORY CASCADE CONSTRAINTS PURGE;
DROP TABLE LOCATIONS  CASCADE CONSTRAINTS PURGE;
DROP TABLE DEPARTMENTS CASCADE CONSTRAINTS PURGE;


--REGIONS
CREATE TABLE regions(
        region_id NUMBER CONSTRAINT reg_id_pk PRIMARY KEY,
        region_name VARCHAR2(25));


--COUNTRIES
CREATE TABLE countries(
        country_id CHAR(2) CONSTRAINT country_c_id_pk PRIMARY KEY,
        country_name VARCHAR2(40),
        region_id NUMBER CONSTRAINT countr_reg_fk REFERENCES regions(region_id)
);

--LOCATIONS
CREATE TABLE locations(
    location_id NUMBER(4) CONSTRAINT loc_id_pk PRIMARY KEY,
    street_address VARCHAR2(40),
    postal_code VARCHAR2(12),
    city VARCHAR2(30) NOT NULL,
    state_province VARCHAR2(25),
    country_id CHAR(2) CONSTRAINT loc_c_id_fk REFERENCES countries(country_id)
);    

--DEPARTMENTS
CREATE TABLE departments(
    department_id number(4) CONSTRAINT dept_id_pk PRIMARY KEY,
    department_name VARCHAR2(30) NOT NULL,
    manager_id NUMBER(6),
    location_id NUMBER(4) CONSTRAINT dept_location_ix REFERENCES locations(location_id)
--,CONSTRAINT dept_mgr_fk FOREIGN KEY (manager_id) REFERENCES employees(employee_id) --?
);



--job
CREATE TABLE jobs(
    job_id VARCHAR2(10) CONSTRAINT job_id_pk PRIMARY KEY,
    job_title VARCHAR2(35) NOT NULL,
    min_salary NUMBER(6),
    max_salary NUMber(6)
);

--job_history
CREATE TABLE job_history(
    employee_id NUMBER(6),
    start_date date,
    end_date date NOT NULL,
    job_id VARCHAR2(10) NOT NULL,
    department_id NUMBER(4) CONSTRAINT jhist_dept_fk REFERENCES departments(department_id),
    CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY(employee_id, start_date),
    CONSTRAINT jhist_job_fk  FOREIGN KEY (job_id) REFERENCES jobs (job_id)
--,CONSTRAINT jhist_emp_fk FOREIGN KEY (employee_id) REFERENCES employees(employee_id) --??
);


--employees 
CREATE TABLE employees(
    employee_id NUMBER(6) CONSTRAINT emp_emp_id_pk PRIMARY KEY,
    first_name VARCHAR2(20),
    last_name VARCHAR2(25) NOT NULL,
    email VARCHAR2(25) NOT NULL,
    phone_number VARCHAR2(20),
    hire_date DATE NOT NULL,
    job_id VARCHAR2(10) NOT NULL,
    salary NUMBER(8, 2),
    commission_pct NUMBER(2, 2),
    manager_id NUMBER(6),
    department_id NUMBER(4),
CONSTRAINT emp_job_fk FOREIGN KEY (job_id) REFERENCES jobs(job_id),
CONSTRAINT emp_manager_fk FOREIGN KEY (manager_id) REFERENCES employees(employee_id),
CONSTRAINT emp_dept_fk FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

ALTER TABLE departments ADD CONSTRAINT dept_mgr_fk 
                            FOREIGN KEY (manager_id) REFERENCES employees(employee_id);
ALTER TABLE job_history ADD CONSTRAINT jhist_emp_fk 
                            FOREIGN KEY (employee_id) REFERENCES employees(employee_id);



