select * from tab;

////////////////////////////1////////////////////////////////////////
/*Using explicit cursor with parameters select department_id, department_name.
If department has employees select their first_name, last_name and salary.*/
////////////////// 1//////////////////////////////////
set serverout on;
declare
    cursor cur_emps(d_name varchar2, d_id number) is
    select first_name, last_name, salary
    from employees e, departments d
    where e.department_id = d.department_id and d.department_id = d_id and d.department_name=d_name;
begin
    for v_emp_record in cur_emps('Marketing',20) loop
        dbms_output.put_line(v_emp_record.first_name || ' '
            || v_emp_record.last_name|| ' ' || v_emp_record.salary);
    end loop;
end;



////////////////// 2//////////////////////////////////
declare 
    cursor regs_c is 
        select region_name, count(*) sum from regions rg, countries c 
        where rg.region_id = c.region_id 
        group by region_name 
        having count(*) >= 5 
        order by region_name; 
begin 
    for regs_record in regs_c loop
        dbms_output.put_line (regs_record.region_name || ' contains '|| regs_record.sum || ' countries.'); 
    end loop; 
end;
/


////////////////// 3//////////////////////////////////
declare
    cursor date_cursor(join_date date) is
        select employee_id,last_name,hire_date from employees
        where hire_date>join_date 
        order by hire_date;
    hdate employees.hire_date%type := '&P_HIREDATE';
begin
     for date_record in date_cursor(hdate) loop
        dbms_output.put_line (date_record.employee_id || ' ' || date_record.last_name || ' ' || date_record.hire_date);
    end loop;
end;
/ 
////////////////// 4//////////////////////////////////
create table pro_raises(
    date_pro date, 
    date_app date, 
    employee_id number(6), 
    original_salary number(8,2), 
    proposed_new_salary number(8,2)
);
declare 
    cursor emp_curs (p_min_salary employees.salary%type) is 
        select employee_id, salary from employees 
        where salary < p_min_salary 
        for update; 
begin 
    for emp_record in emp_curs(5000) loop 
        insert into pro_raises (date_pro, employee_id, original_salary, proposed_new_salary) 
            values (sysdate, emp_record.employee_id, emp_record.salary, emp_record.salary * 1.05); 
    end loop; 
end;
select * from pro_raises;
/


////////////////// 5//////////////////////////////////

update countries
set area = 1000000
where country_id = 'CN';
////////////////// 5-1//////////////////////////////////
declare 
    v_country_name countries.country_name%type; 
    v_area countries.area%type;
    cursor countries_cur(reg_id number) is 
        select country_name, area from countries
        where region_id = reg_id; 
begin 
    open countries_cur(3); 
    loop 
        fetch countries_cur into v_country_name, v_area; 
        exit when countries_cur%notfound; 
        dbms_output.put_line ('Country: ' || v_country_name || ' Area: ' || v_area); 
    end loop; 
    close countries_cur; 
end;
////////////////// 5-2//////////////////////////////////
declare 
    cursor countries_cur(reg_id number) is 
        select country_name, area from countries
        where region_id = reg_id; 
begin 
    for cou_record in countries_cur(3) loop
        dbms_output.put_line ('Country: ' || cou_record.country_name || ' Area: ' || cou_record.area); 
    end loop; 
end;

////////////////// 5-3//////////////////////////////////

declare 
    cursor country_cur (p_region_id countries.region_id%type, p_area countries.area%type) is 
        select country_name, area from countries 
        where region_id = p_region_id and area > p_area; 
begin 
    for country_rec in country_cur(3,200000) loop 
        dbms_output.put_line('Name: ' || country_rec.country_name || ' Area: ' || country_rec.area); 
    end loop;
end; 


////////////////// 5-4//////////////////////////////////

declare 
    cursor country_cur (p_region_id countries.region_id%type, p_area countries.area%type) is 
        select country_name, area from countries 
        where region_id = p_region_id and area > p_area; 
    v_region_id countries.region_id%type; 
    v_min_area countries.area%type; 
begin
    v_region_id := 3; 
    v_min_area := 200000; 
    dbms_output.put_line('Region: ' || v_region_id || ' Minimum Area: ' || v_min_area); 
    for country_rec in country_cur(v_region_id, v_min_area) loop 
        dbms_output.put_line('Name: ' || country_rec.country_name || ' Area: ' || country_rec.area); 
    end loop;
    dbms_output.put_line('----------------------------------'); 
    v_region_id := 1; 
    v_min_area := 50000; 
    dbms_output.put_line('Region: ' || v_region_id || ' Minimum Area: ' || v_min_area);
for country_rec in country_cur(v_region_id, v_min_area) loop 
        dbms_output.put_line('Name: ' || country_rec.country_name || ' Area: ' || country_rec.area); 
    end loop;
end; 

////////////////// 6//////////////////////////////////
declare
    cursor emp_cur is
    select d.department_name dept_name, count(e.employee_id) nr
        from departments d, employees e
        where d.department_id=e.department_id
        group by d.department_name
        order by nr desc;
begin
    for dep_rec in emp_cur loop
        exit when emp_cur%rowcount>5;
        dbms_output.put_line(dep_rec.dept_name||', '||dep_rec.nr);
    end loop;
end; 
////////////////// 7//////////////////////////////////
declare 
    cursor dept_cur is 
    select department_id,department_name from departments 
    order by department_id; 
    
    cursor emp_cur(deptid departments.department_id%type) is 
    select first_name, last_name, salary from employees 
    where department_id = deptid 
    order by last_name; 
begin 
    for dept_record in dept_cur loop 
        dbms_output.put_line(dept_record.department_id || ' ' || dept_record.department_name); 
        dbms_output.put_line('-----------------------------'); 
        for emp_record in emp_cur(dept_record.department_id) loop 
            dbms_output.put_line (emp_record.first_name || ' ' || emp_record.last_name || ' ' || emp_record.salary); 
        end loop;
    end loop; 
end;

////8///////////////////////////////////////////////////////
explicit cursor
cursor
context area
implicit cursor
open
fetch
active set
close

//////////////////////////////////////9////////////////////////////////
declare
cursor cur9 is select * 
from copy_employees where hire_date 
between '01-JAN-01' and '31-DEC-02'
for update;
rec_row cur9%rowtype;
begin
open cur9;
loop
fetch cur9 into rec_row;
exit when cur9%notfound;
delete from copy_employees
where current of cur9;
end loop;
commit;
end;

///////////10/////////////////////////////////////////////////////////////////

declare
cursor task_10 is
select * from copy_employees 
where hire_date between '01-JAN-80' and '31-DEC-90' for update;
rec_row copy_employees%rowtype;
begin
open task_10;
loop
fetch task_10 into rec_row;
exit when task_10%notfound;
insert into archieved_emp values rec_row;
delete from copy_employees where current of task_10;
end loop;
commit;
close task_10;
end;








