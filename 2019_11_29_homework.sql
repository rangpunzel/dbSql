--join8
SELECT c.region_id, region_name, country_name
FROM countries c, regions r
WHERE c.region_id = r.region_id
AND region_name = 'Europe';



--join9
SELECT c.region_id, region_name, country_name, l.city
FROM countries c JOIN regions r ON (c.region_id = r.region_id)
                 JOIN locations l ON (c.country_id = l.country_id)
WHERE region_name = 'Europe';


--join10
SELECT c.region_id, region_name, country_name, l.city, d.department_name
FROM countries c JOIN regions r ON (c.region_id = r.region_id)
                 JOIN locations l ON (c.country_id = l.country_id)
                 JOIN departments d ON (d.location_id = l.location_id)
WHERE region_name = 'Europe';

--join11
SELECT c.region_id, region_name, country_name, l.city, d.department_name, first_name || last_name name
FROM countries c JOIN regions r ON (c.region_id = r.region_id)
                 JOIN locations l ON (c.country_id = l.country_id)
                 JOIN departments d ON (d.location_id = l.location_id)
                 JOIN employees e ON (e.department_id = d.department_id)
WHERE region_name = 'Europe';

--join12
SELECT employee_id, first_name || last_name name, e.job_id, job_title
FROM employees e JOIN jobs j ON (e.job_id = j.job_id);


--join13

SELECT m.employee_id,  m.first_name || m.last_name name, 
       e.employee_id, e.first_name || e.last_name name, e.job_id, j.job_title
FROM employees e JOIN jobs j ON (e.job_id = j.job_id)
                 JOIN employees m ON (e.manager_id = m.employee_id);