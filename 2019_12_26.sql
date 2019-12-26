-- EXCEPTION
-- ���� �߻��� ���α׷��� �����Ű�� �ʰ�
-- �ش� ���ܿ� ���� �ٸ� ������ ���� ��ų�� �ְ� �� ó���Ѵ�.

-- ���ܰ� �߻��ߴµ� ����ó���� ���� ��� : pl/sql ������ ������ �Բ� ����ȴ�.
-- �������� SELECT ����� �����ϴ� ��Ȳ���� ��Į�� ������ ���� �ִ� ��Ȳ

-- emp ���̺����� ��� �̸��� ��ȸ

SET SERVEROUTPUT ON;
DECLARE
    -- ��� �̸��� ������ �� �ִ� ����
    v_ename emp.ename%TYPE;
BEGIN
    -- 14���� elect ����� ������ SQL --> ��Į�� ������ ������ �Ұ��ϴ�(����)
    SELECT ename
    INTO v_ename
    FROM emp;
EXCEPTION 
   /* WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('�������� select ����� ����');*/
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('WHEN OTHERS');
END;
/

-- ����� ���� ����
-- ����Ŭ���� ������ ������ ���� �̿ܿ��� �����ڰ� �ش� ����Ʈ���� �����Ͻ� ��������
-- ������ ���ܸ� ����, ����� �� �ִ�.
-- ���� ��� SELECT ����� ���� ��Ȳ���� ����Ŭ������ NO_DATA_FOUND ���ܸ� ������
-- �ش� ���ܸ� ��� NO_EMP��� �����ڰ� ������ ���ܷ� ������ �Ͽ� ���ܸ� ���� �� �ִ�.

-- 
DECLARE
    -- emp ���̺� ��ȸ ����� ������ ����� ����� ���� ����
    -- ���ܸ� EXCEPTION;
    no_emp EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN 
    -- NO_DATA_FOUND
    BEGIN
        SELECT ename
        INTO v_ename
        FROM emp
        WHERE empno = 7000;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE no_emp; -- java throw new NoEmpException()
    END;
EXCEPTION
    WHEN no_emp THEN
        DBMS_OUTPUT.PUT_LINE('NO_EMP');
END;
/

-- ����� �Է¹޾Ƽ� �ش� ������ �̸��� �����ϴ� �Լ�
-- getEmpName(7369) --> SMITH

CREATE OR REPLACE FUNCTION getEmpName (p_empno emp.empno%TYPE)
RETURN VARCHAR2 IS
    -- �����
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename
    FROM emp
    WHERE empno = p_empno;
    
    return v_ename;
END;
/

SELECT getempname(7369)
FROM dual;

SELECT getempname(empno)
FROM emp;

-- �ǽ� founction1
CREATE OR REPLACE FUNCTION getdeptname (p_deptno dept.deptno%TYPE)
RETURN VARCHAR2 IS
    v_dname dept.dname%type;
BEGIN
    SELECT dname
    INTO v_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN v_dname;
END;
/
-- cache : 20
-- ������ ������ :
-- deptno (�ߺ� �߻�����) : �������� ���� ���ϴ�
-- empno (�ߺ��� ����) : �������� ����

-- emp ���̺��� �����Ͱ� 100������ ���
-- 100���߿��� deptno�� ������ 4��(10~40)
SELECT getdeptname(deptno),  -- 4����(������)
       getempname(empno)   -- row����ŭ �����Ͱ� ����
FROM emp;

SELECT getdeptname(10)
FROM dual;

SELECT getdeptname(deptno)
FROM emp;


--�ǽ� function2
SELECT deptcd, LPAD(' ',(LEVEL-1)*4,' ')||deptnm deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;



CREATE OR REPLACE FUNCTION indent (p_lv NUMBER, p_dname VARCHAR2)
RETURN VARCHAR2 IS
    v_dname VARCHAR2(200);
BEGIN
    SELECT LPAD(' ',(p_lv-1)*4,' ')||p_dname
    INTO v_dname
    FROM dual;
    
    return v_dname;
END;
/

SELECT deptcd, indent(LEVEL, deptnm) deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

-- trigger
SELECT *
FROM users;

-- users ���̺��� ��й�ȣ �÷��� ������ ������ ��
-- ������ ����ϴ� ��й�ȣ �÷� �̷��� �����ϱ� ���� ���̺�
CREATE TABLE users_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt date
);

CREATE OR REPLACE TRIGGER make_history
    -- timing
    BEFORE UPDATE ON users
    FOR EACH ROW -- ��Ʈ����, ���� ������ ���� ������ �����Ѵ�.
    -- ���� ������ ���� :OLD
    -- ���� ������ ���� :NEW
    BEGIN
        -- users ���̺��� pass �÷��� ������ �� trigger ����
        IF :OLD.pass != :NEW.pass THEN
            INSERT INTO users_history
                VALUES(:OLD.userid, :OLD.pass, sysdate);
        END IF;
        
        -- �ٸ� �÷��� ���ؼ��� �����Ѵ�.
    END;
/

--USERS ���̺��� PASS �÷��� ���� ���� ��
-- trigger�� ���ؼ� users_history ���̺��� �̷��� �����Ǵ��� Ȯ��
SELECT *
FROM users_history;

UPDATE USERS set pass = '1234'
WHERE userid='brown';

SELECT *
FROM users_history;

--������ �𵨸�

-- ���� ���� ����??
-- �Խ���id(�Խ��� ��ȣ) : oricle sequence, , �Խ��� ����� ����Ͻ� �Խ��� �̸�, Ȱ��ȭ/��Ȱ��ȭ

--�Խñ�
-- �Խñ۹�ȣ : oracle sequence, �Խñ� ����, �Խñ� ����, ���� ����, �ۼ���, �ۼ��Ͻ�
-- ÷������ 5������
    -- ÷�����ϸ�
-- ��� (500�� --> �ѱ� 1���ڰ� 3byte 1500byte)
    -- ��� ��ȣ : oracle sequence, ��۳���, �ۼ���, �ۼ��Ͻ�
    
--�Խñ� ÷������*�Խñ۴� 5������)