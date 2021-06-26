--1
CREATE A PACKAGE CALLED HELLOFROM THAT CONTAINS THREE PUBLIC PROCEDURES NAMED PROC_1, PROC_2
AND PROC_3. EACH OF THESE PROCEDURES SHOULD USE DBMS_OUTPUT.PUT_LINE() TO DISPLAY THE
MESSAGE “HELLO FROM PROC X” WHERE “X” IS 1 OR 2 OR 3, AS APPROPRIATE.
ALSO, PROC_1 SHOULD CALL PROC_2 AND PROC_2 SHOULD CALL PROC_3, SO YOU NEED TO INCLUDE A REFERENCE
TO PROC_2 FROM PROC_1, AND A REFERENCE TO PROC_3 FROM PROC_2.
YOU WILL BE MAKING CHANGES TO THIS PACKAGE SPECIFICATION AND BODY, SO MAKE SURE YOU SAVE BOTH
THE SPECIFICATION AND BODY IN YOUR APPLICATION EXPRESS SESSION.
//////////////////////////////////////////////////////////////
CREATE OR REPLACE PACKAGE HELLOFROM   --speci
AS
PROCEDURE PROC_1;
PROCEDURE PROC_2;
PROCEDURE PROC_3;
END HELLOFROM;

CREATE OR REPLACE PACKAGE BODY HELLOFROM IS  
    PROCEDURE PROC_1
        IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('HELLO FROM PROC 1');
        PROC_2;
    END PROC_1;
    PROCEDURE PROC_2
        IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('HELLO FROM PROC2');
        PROC_3;
    END PROC_2;
    PROCEDURE PROC_3
        IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('HELLO FROM PROC 3');
    END PROC_3;
END HELLOFROM;

set SERVEROUTPUT ON
BEGIN
HELLOFROM.PROC_3;
END;

--2
DESCRIBE the package to check that all three procedures are visible. Then, create and execute
an anonymous block which displays all three messages with only one procedure call.
Modify the hellofrom package specification (not the body) so that only proc_1 is public and proc_2 and
proc_3 are private. Recreate the package and then DESCRIBE it. What do you see? 
/////////////////////////////////////////////////////////////////////////////////////////////
DESCRIBE HELLOFROM;

SET SERVEROUT ON
BEGIN
HELLOFROM.PROC_1;
END;

CREATE OR REPLACE PACKAGE HELLOFROM  
AS
PROCEDURE PROC_1;
END HELLOFROM;

--3
--What will happen if you try to run hellofrom.proc_1 now, before you make any changes to the body?
--Try it
SET SERVEROUT ON
BEGIN
HELLOFROM.PROC_1;
END;
/
--What will happen if you try to run hellofrom.proc_1 now, before you make any changes to the body?
--Try it
CREATE OR REPLACE PACKAGE BODY HELLOFROM IS  
    PROCEDURE PROC_3
        IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Hello from Proc 3');
    END PROC_3;
    PROCEDURE PROC_2
        IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Hello from Proc 2');
        PROC_3;
    END PROC_2;
    PROCEDURE PROC_1
        IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Hello from Proc 1');
        PROC_2;
    END PROC_1;
END HELLOFROM;
/
--5. Try to call each of the three procedures from anonymous blocks. What happens? Explain why
--some of these calls fail.

BEGIN
HELLOFROM.PROC_1;
END;
/
BEGIN
HELLOFROM.PROC_2;
END;
/
BEGIN
HELLOFROM.PROC_3;
END;
/
--6 Look in USER_PROCEDURES for the hellofrom package. What do you see? 
SELECT * FROM USER_PROCEDURES WHERE OBJECT_NAME = 'HELLOFROM';

--7 Also have a look in USER_SOURCE. Unlike USER_PROCEDURES, USER_SOURCE shows the
entire body, including the private procedures. 

SELECT * FROM USER_SOURCE WHERE NAME = 'HELLOFROM';

--8 Make sure you have saved the hellofrom package body code from question 1. Then try to drop just
--the body. What happens? What do you see when you DESCRIBE helloform?
DROP PACKAGE BODY HELLOFROM;
DESCRIBE HELLOFROM;
/
--9. Re-create the body from your saved code. Now try to drop just the specification. What happens?
DROP PACKAGE HELLOFROM;
DESCRIBE HELLOFROM;
/

10. Name at least two advantages of enclosing these three procedures in a package
