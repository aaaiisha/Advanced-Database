1. CREATE OR REPLACE PROCEDURE employee_report
(dir IN VARCHAR2, filename IN VARCHAR2) IS
f UTL_FILE.FILE_TYPE;
CURSOR avg_csr IS
    SELECT last_name, department_id, salary FROM employees outer
        WHERE salary > (SELECT AVG(salary) FROM employees inner GROUP BY outer.department_id)
            ORDER BY department_id;
BEGIN
    f := UTL_FILE.FOPEN(dir, filename,'w');
    UTL_FILE.PUT_LINE(f, 'Employees who earn more than average salary: ');
    UTL_FILE.PUT_LINE(f, 'REPORT GENERATED ON ' ||SYSDATE);
    UTL_FILE.NEW_LINE(f);
    FOR emp IN avg_csr
    LOOP
        UTL_FILE.PUT_LINE(f,
            RPAD(emp.last_name, 30) || ' ' ||
            LPAD(NVL(TO_CHAR(emp.department_id,'9999'),'-'), 5) || ' ' ||
            LPAD(TO_CHAR(emp.salary, '$99,999.00'), 12));
    END LOOP;
    UTL_FILE.NEW_LINE(f);
    UTL_FILE.PUT_LINE(f, '*** END OF REPORT ***');
    UTL_FILE.FCLOSE(f);
END employee_report;

EXECUTE employee_report('ORACLE_HOME','sal_rptxx.txt');
eXECUTE employee_report('UTL_FILE','sal_rpt01.txt')

2.
SET SERVEROUTPUT ON
EXECUTE HTP.PRINT('hello')
EXECUTE OWA_UTIL.SHOWPAGE
BEGIN htp.print('hello'); END;

CREATE OR REPLACE PROCEDURE web_employee_report IS
    CURSOR avg_csr IS
        SELECT last_name, department_id, salary FROM employees outer
WHERE salary > (SELECT AVG(salary)
FROM employees inner
GROUP BY outer.department_id)
ORDER BY department_id;
BEGIN
htp.htmlopen;
htp.headopen;
htp.title('Employee Salary Report');
htp.headclose;
htp.bodyopen;
htp.header(1, 'Employees who earn more than average salary');
htp.print('REPORT GENERATED ON' || to_char(SYSDATE, 'DD-MON-YY'));
htp.br;
htp.hr;
htp.tableOpen;
htp.tablerowOpen;
htp.tableHeader('Last Name');
htp.tableHeader('Department');
htp.tableHeader('Salary');
htp.tablerowclose;
FOR emp IN avg_csr
LOOP
htp.tablerowOpen;
htp.tabledata(emp.last_name);
htp.tabledata(NVL(TO_CHAR(emp.department_id,'9999'),'-'));
htp.tabledata(TO_CHAR(emp.salary, '$99,999.00'));
htp.tablerowclose;
END LOOP;
htp.tableclose;
htp.hr;
htp.print('*** END OF REPORT ***');
htp.bodyclose;
htp.htmlclose;
END web_employee_report;

Declare
   param_val   owa.vc_arr;
BEGIN
   if owa.num_cgi_vars is null
   then
      param_val (1) := 1;
      owa.init_cgi_env (param_val);
   end if;
END;

set serveroutput on;


EXECUTE web_employee_report

EXECUTE owa_util.showpage


3. 
CREATE OR REPLACE PROCEDURE schedule_report(
interval VARCHAR2, minutes NUMBER := 10) IS
plsql_block VARCHAR2(200) :=
'BEGIN'||
' EMPLOYEE_REPORT(''UTL_FILE'','||
'''sal_rpt01_''||to_char(sysdate,''HH24-MI-SS'')||''.txt''); '||
'END;';
BEGIN
DBMS_SCHEDULER.CREATE_JOB(
job_name => 'EMPSAL_REPORT',
job_type => 'PLSQL_BLOCK',
job_action => plsql_block,
start_date => SYSDATE,
repeat_interval => interval,
end_date => SYSDATE + minutes/(24*60),
enabled => TRUE);
END;

EXECUTE schedule_report('FREQUENCY=MINUTELY;INTERVAL=2', 10)
SELECT job_name, enabled
FROM user_scheduler_jobs;