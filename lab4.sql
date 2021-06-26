create table COPY_EMP as select * from employees;
create table COPY_DEPT as select * from departments;
create table COPY_COUNT as select * from countries;
create table COPY_LOC as select * from locations;
SELECT * FROM tab;
SET SERVEROUTPUT ON;
///////1////////////////////////////////
DECLARE
dept_id NUMBER;
tsal NUMBER;
INDICATOR NUMBER;
BEGIN
SELECT department_id, SUM(salary) INTO dept_id, tsal FROM COPY_EMP WHERE department_id = 60 GROUP BY department_id;
CASE
WHEN tsal > 19000 THEN INDICATOR := 1;
ELSE INDICATOR :=0;
END CASE;
DBMS_OUTPUT.PUT_LINE(dept_id || ' ' || tsal || ' ' || INDICATOR);
END;

//////2//////////////////////////////////
DECLARE
c_num NUMBER;
BEGIN
SELECT COUNT(*) INTO c_num FROM COPY_COUNT WHERE region_id = 
(SELECT region_id FROM regions WHERE region_name IN 'Asia');
CASE
WHEN c_num > 20 THEN DBMS_OUTPUT.PUT_LINE('More than 20 countries');
WHEN c_num >= 10 AND c_num <= 20 THEN DBMS_OUTPUT.PUT_LINE('Between 10 and 20 countries');
ELSE DBMS_OUTPUT.PUT_LINE('Fewer than 10 countries');
END CASE;
END;

//////3//////////////////////
DECLARE
c_name VARCHAR2(25);
c_id CHAR(3);
counter NUMBER(2):=1;
BEGIN
LOOP
FOR C IN (SELECT country_id,country_name INTO c_id,c_name FROM countries WHERE region_id=counter)
LOOP
c_id:=C.country_id;
c_name:=C.country_name;
dbms_output.put_line(c_id || ' ' || c_name);
END LOOP;
counter:=counter+1;
EXIT WHEN counter>3;
END LOOP;
END;

///////4////////////////////
BEGIN
FOR outerloop IN 60..65 LOOP
FOR innerloop IN 100..110 LOOP
DBMS_OUTPUT.PUT_LINE(outerloop|| '-' ||innerloop);
END LOOP;
END LOOP;
END;

/////5/bonus/////////////////

///////////6-1//////////////////////
set serveroutput on
BEGIN   UPDATE COPY_EMP
SET salary = salary + 1000
WHERE department_id IN
(SELECT department_id FROM COPY_DEPT WHERE location_id IN
(SELECT location_id FROM COPY_LOC WHERE state_province IN 'California' OR state_province IN 'Alaska'));
END;


BEGIN
UPDATE COPY_EMP
SET SALARY = SALARY*1.1
WHERE DEPARTMENT_ID IN (
SELECT DEPARTMENT_ID FROM DEPARTMENTS, LOCATIONS
WHERE STATE_PROVINCE = 'California' OR STATE_PROVINCE = 'Alaska'  ); 
END;

select * from copy_emp;
select * from EMPLOYEES;


select * from copy_emp  where employee_id=155;
select * from employees  where employee_id=155;
select e.employee_id, l.state_province  from employees e, departments d, locations l 
where d.location_id=l.location_id ;


/////////6-2///////////////////
BEGIN
UPDATE COPY_EMP
SET salary = salary + (salary/10)
WHERE department_id = (SELECT department_id FROM (SELECT department_id, AVG(salary) AS minavgsal FROM employees GROUP BY department_id)
WHERE minavgsal = (SELECT MIN(avgsal) FROM (SELECT department_id, AVG(salary) AS avgsal FROM employees GROUP BY department_id)));
END;

//////////////6-3/////////////////////////
ALTER TABLE COPY_EMP
ADD status VARCHAR2(20) DEFAULT 'employee';

BEGIN
UPDATE COPY_EMP SET status = 'manager' 
WHERE EXTRACT(YEAR FROM TO_DATE(hire_date, 'DD-MON-RR')) < 2005;
END;

////////////////6-4//////////////////////
First letter of last name + name +@department name + region .us
////////////////////////////////
SET SERVEROUTPUT ON;
DECLARE
counter NUMBER := 100;
BEGIN
 WHILE counter < 207
 LOOP UPDATE COPY_EMP SET email = 
 (SELECT substr(last_name, 0, 1) 
 FROM COPY_EMP WHERE employee_id = counter) || '' || 
(SELECT substr(first_name,0,4) FROM COPY_EMP WHERE employee_id = counter) || '@' || 
(SELECT REPLACE((LOWER(department_name)), '', '') 
FROM COPY_DEPT WHERE department_id = 
(SELECT department_id FROM COPY_EMP WHERE employee_id = counter)) || '.' ||
(SELECT lower(country_id) FROM COPY_LOC WHERE location_id IN 
(SELECT location_id FROM COPY_DEPT WHERE department_id = 
(SELECT department_id FROM COPY_EMP WHERE employee_id = counter))) 
WHERE employee_id = counter;
 counter := counter + 1;
END LOOP;
END;

select * from copy_emp;
//TEACHER I GET ONLY FIRST 4 LETTER FROM NAME CAUSE ORACLE SAID IS TOO LONG FOR EMAIL//

/////////////6-5////////////////////
BEGIN
DELETE FROM COPY_EMP
WHERE EXTRACT(YEAR FROM TO_DATE(hire_date, 'DD-MON-RR')) < 1980;
END;