CREATE TABLE USER_TAB (ID NUMBER,NAME VARCHAR(255));
DROP TABLE USER_TAB;

create table uSER_TAB(id number primary key not null,name varchar2(50) not null);

grant create any table to hr;
grant create any trigger to hr;

SELECT * FROM USER_TAB;

/*Your procedure should produce a new table with name of
“SOURCETABLENAME”_LOG - in this case - USER_LOG with next columns:
1. ID NUMBER
2. OPERATION_DATE DATE
3. OLD_ID NUMBER
4. NEW_ID NUMBER
5. OLD_NAME VARCHAR
6. NEW_NAME VARCHAR
7. ACTION VARCHAR
8. ACTIONAUTHOR VARCHAR*/

CREATE OR REPLACE PROCEDURE proc_log is
BEGIN
EXECUTE IMMEDIATE 'create table user_tab_LOG
                    (id number primary key not null,
                    operation_date date,
                    old_id number null,
                    new_id number null,
                    old_name varchar2(50) null,
                    new_name varchar2(50) null,
                    action varchar2(250) null,
                    action_author varchar2(250) null)';
END;


CREATE OR REPLACE PROCEDURE proc_log2 is
BEGIN
EXECUTE IMMEDIATE 'alter table user_tab add
                    (
                    operation_date date,
                    old_id number null,
                    new_id number null,
                    new_name varchar2(50) null,
                    action varchar2(250) null,
                    action_author varchar2(250) null)';
END;


BEGIN
proc_log;
END;

select * from user_tab_LOG;
select * from logtab;
SELECT * FROM USER_TAB;
/

DECLARE 
LOGTAB CHAR:= 'user_TAB_log';
LOGTAB_OLD CHAR := 'user_TAB' ;
BEGIN
PROC_LOG('user_TAB_log','user_TAB');
END;



2)
/*1. AFTER DELETE
WHEN DELETE HAPENS - YOU SHOULD PUT DELETING ROW IN
CORRESPONDING _LOG TABLE. Action should be “DELETE”, ACTIONAUTHOR
should be active session user name.
2. AFTER INSERT
WHEN INSERT HAPENS - You should put inserting row in corresponding _log
table.Action should be “INSERT”.ACTIONAUTHOR should be active session user
name. And OPERATION_DATE - should be SYSDATE
3. AFTER UPDATE
WHEN UPDATE HAPENS - You should put updated values into corresponding _new
columns, previous values into corresponding _old columns.Action should be “UPDATE”.
ACTIONAUTHOR should be active session user name.*/



CREATE OR REPLACE TRIGGER AFTER_DUIU
AFTER DELETE OR INSERT OR UPDATE ON USER_TAB FOR EACH ROW
DECLARE
UID LOGTAB.ID%TYPE;
CURSOR CURutab IS
SELECT ID FROM LOGTAB ORDER BY ID DESC;
BEGIN
FOR USERS_LOG_REC IN CURutab LOOP
UID := USERS_LOG_REC.ID; EXIT;
END LOOP;
IF UID IS NULL THEN
UID := 1;
ELSE
UID := UID + 1;
END IF;
IF DELETING THEN
INSERT INTO LOGTAB
VALUES (UID, SYSDATE, :OLD.ID, NULL, :OLD.NAME, NULL, 'DELETE', USER);
ELSIF INSERTING THEN
INSERT INTO LOGTAB
VALUES (UID, SYSDATE, NULL, :NEW.ID, NULL, :NEW.NAME, 'INSERT', USER);
ELSIF UPDATING THEN
INSERT INTO LOGTAB
VALUES (UID, SYSDATE, :OLD.ID, :NEW.ID, :OLD.NAME, :NEW.NAME, 'UPDATE', USER);
END IF;
END;

ALTER TRIGGER AFTER_DUIU DISABLE;

INSERT INTO USER_TAB VALUES (1, 'Bibi');
INSERT INTO USER_TAB VALUES (2, 'Kura');
INSERT INTO USER_TAB VALUES (3, 'Aish');

UPDATE USER_TAB
SET
NAME = 'NEW USER BK'
WHERE ID IN (1, 2);

DELETE FROM USER_TAB WHERE ID = 3;


SELECT * FROM USER_tab;

////////////////////////////////////////////////////////////////////////////////////////////////////
CREATE OR REPLACE TRIGGER AFTER_DELETE
AFTER DELETE ON USER_TAB FOR EACH ROW
DECLARE
   UNAME VARCHAR2(10); 
   NEWID NUMBER := 2;
BEGIN
   SELECT USER INTO UNAME
   FROM DUAL;   
   INSERT INTO LOGTAB
   (ID,OLD_NAME,OPERATION_DATE,NEW_ID,NEW_NAME,ACTION,ACTION_AUTHOR)
   VALUES(:OLD.ID,:OLD.NAME,SYSDATE,NEWID,'BIBI','DELETE',UNAME );     
END;

----------------------

CREATE OR REPLACE TRIGGER AFTER_INSERT
AFTER INSERT ON USER_TAB FOR EACH ROW
DECLARE
   UNAME VARCHAR2(10); 
   NEWID NUMBER := 2;
BEGIN (SELECT USER INTO UNAME FROM DUAL);   
   INSERT INTO USER_TAB_LOG
   (ID,OLD_NAME,OPERATION_DATE,NEW_ID ,NEW_NAME ,ACTION ,ACTION_AUTHOR)
   VALUES (:OLD.ID,:OLD.NAME,SYSDATE,NEWID,'BIBI','INSERT',UNAME );     
END;


CREATE OR REPLACE TRIGGER AFTER_UPDATE
AFTER UPDATE ON USER_TAB FOR EACH ROW
DECLARE
   UNAME VARCHAR2(10); 
   NEWID NUMBER := 2;
BEGIN SELECT USER INTO UNAME FROM DUAL;   
INSERT INTO USER_TAB_LOG(ID,OLD_NAME,OPERATION_DATE,NEW_ID ,NEW_NAME ,ACTION ,ACTION_AUTHOR)
   VALUES( :OLD.ID,:OLD.NAME,SYSDATE,NEWID,'BIBI','UPDATE',UNAME );     
END;


ALTER TRIGGER AFTER_DELETE DISABLE;
ALTER TRIGGER AFTER_DELETE ENABLE;
ALTER TRIGGER AFTER_INSERT DISABLE;
ALTER TRIGGER AFTER_UPDATE DISABLE;
/////////////////////////////////////////////////////////////////////////////////
/*3)AUTOMATE THIS PROCESS.
Create a schema ddl trigger that executes on create table statement. And assigns to this
table:
1. Logging table
2. All necessary triggers for source table.*/
