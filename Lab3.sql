select * from tab;

create user aisha identified by 123;
grant connect to aisha;
grant all privileges to aisha identified by 123;

SET SERVEROUTPUT ON
BEGIN
DBMS_OUTPUT.PUT_LINE('Hello world');
END;


DECLARE
incentive   NUMBER(8,2);--6digits bfore come and 2 after
BEGIN
  SELECT salary * 0.12 INTO incentive
  FROM employees
  WHERE employee_id = 110;
DBMS_OUTPUT.PUT_LINE('Incentive  = ' || TO_CHAR(incentive));
END;
/
//////////////////////////
set serveroutput on
declare
     fname varchar2(50);
     surname varchar2(50);
begin
    for c in (select first_name, last_name 
    into fname, surname from employees where salary > 
    (select salary from employees where employee_id=163)) 
    loop
    fname :=c.first_name;
    surname :=c.last_name;
    end loop;
    dbms_output.put_line(fname || ' ' || surname);
end;

SELECT first_name, last_name 
FROM employees 
WHERE salary > 
( SELECT salary  
FROM employees 
WHERE employee_id=163
);

/////////6///////////////////
SET SERVEROUTPUT ON
DECLARE 
    difference number(10);
BEGIN 
    SELECT MAX(salary) - MIN(salary) into difference
    FROM employees
    WHERE salary > 0;
    DBMS_OUTPUT.PUT_LINE(difference);
END;



///////////7//////////

declare
tot number;
special number;
begin
select count(*) into tot from employees;
select count(*) into special
from employees where hire_date like '%95' 
or hire_date like '%96' 
or hire_date like '%97' 
or hire_date like '%98';
DBMS_OUTPUT.PUT_LINE(tot || ' ' || special);
end;



//////8//////////////
declare
poorguys varchar2(20);
begin
select department_name into poorguys from departments where department_id =
(select department_id from 
(select department_id, avg(salary) 
as minavgsal from employees group by department_id)
where minavgsal = (select min(avgsal) 
from (select department_id, avg(salary) 
as avgsal from employees group by department_id)));
DBMS_OUTPUT.put_line(poorguys);
end;


9. 
declare
emp_num number;
surname varchar2(25);
sal number;
begin
select employee_id, last_name, salary into emp_num, surname, sal
from employees where salary > (select avg(salary) from employees) 
and department_id in (select department_id from employees 
where last_name like '%u%');
DBMS_OUTPUT.PUT_LINE(emp_num || ' ' || surname || ' ' || sal);
exception
when too_many_rows then
DBMS_OUTPUT.PUT_LINE('Multiple rows in output...');
end;

////////////////10/////
declare
labels char;
begin
select decode(job_id, 'AD_PRES', 'A', 'ST_MAN', 'B', 'IT_PROG', 'C',
'SA_REP', 'D', 'ST_CLERK', 'E', 0) into labels from employees where employee_id = 103;
DBMS_OUTPUT.PUT_LINE(labels);
end;



 