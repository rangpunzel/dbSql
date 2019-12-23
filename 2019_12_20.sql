--hash join 
SELECT *
FROM dept, emp
WHERE dept.detpno = emp.deptno;

--dept ���� �д� ����
--join�÷��� hash �Լ��� ������ �ش� �ؽ� �Լ��� �ش��ϴ� bucket�� �����͸� �ִ´�
-- 10 --> ccc1122 (hashwalue)

--emp ���̺� ���� ���� ������ �����ϰ� ����
--10 --> ccc1122 (hashvalue)


-- �����ȣ, ����̸�, �μ���ȣ, �޿�, �μ����� ��ü �޿���
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum, -- ���� ó������ ���������
       SUM(sal) OVER (ORDER BY sal
       ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) c_sum2
FROM emp
ORDER BY sal;

--ana7
SELECT empno, ename, deptno, sal,
        sum(sal) OVER(PARTITION BY deptno ORDER BY sal, empno) c_sum
FROM emp;

-- ROWS vs RANGE ���� Ȯ���ϱ�
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) rows_sum,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum,
       SUM(sal) OVER (ORDER BY sal) c_sum 
       --ORDER BY�� �ڿ� WINDOWING�� �������� �ʾ����� RANGE UNBOUNDED PRECEDING�� �⺻������ ���
FROM emp;

-- PL/SQL
-- PL/SQL �⺻����
-- DECLARE : �����, ������ �����ϴ� �κ�
-- BEGIN : PL/SQL�� ������ ���� �κ�
-- EXCEQPTION : ����ó����

--DBMS_OUTPUT.PUT_LINE �Լ��� ����ϴ� ����� ȭ�鿡 �����ֵ��� Ȱ��ȭ
SET SERVEROUTPUT ON; 
DECLARE --�����
    -- java : Ÿ�� ������; 
    -- pl/sql : ������ Ÿ��;
    /*v_dname VARCHAR2(14);
    v_loc VARCHAR2(13);*/
    --���̺� �÷��� ���Ǹ� �����Ͽ� ������ Ÿ���� �����Ѵ�
    v_dname dept.dname %TYPE;
    v_loc dept.loc %TYPE;
BEGIN
    -- DEPT ���̺��� 10�� �μ��� �μ� �̸�, LOC ������ ��ȸ
    SELECT dname, loc
    INTO v_dname, v_loc
    FROM dept
    WHERE deptno = 10;
    --String a = "t";
    --Stringt b = "c";
    --Sysout.out.println(a + b);
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc);
END;
/ 
-- PL/SQL ����� ����


-- 10�� �μ��� �μ��̸�, ��ġ������ ��ȸ�ؼ� ������ ���
-- ������ DBMS_OUTPUT.PUT_LINE�Լ��� �̿��Ͽ� consol�� ���
CREATE OR REPLACE PROCEDURE printdept 
--�Ķ���͸� IN/OUT Ÿ��
-- p_�Ķ�����̸�
(p_deptno IN dept.deptno%TYPE)
IS
--�����(�ɼ�)
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
--�����
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(dname || ' ' || loc);
--����ó����(�ɼ�)
END;
/

exec printdept(50);


CREATE OR REPLACE PROCEDURE printemp 
    (p_empno IN emp.empno%TYPE)
IS
    ename emp.ename%TYPE;
    dname dept.dname%TYPE;

BEGIN
    SELECT ename, dname
    INTO ename, dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno
    AND empno = p_empno;
    
    DBMS_OUTPUT.PUT_LINE(ename || ' ' || dname);
END;
/

exec printemp(7782);

SELECT *
FROM dept_test;



--pro_2
CREATE OR REPLACE PROCEDURE registdept_test 
    (p_deptno IN dept.deptno%TYPE,
    p_dname IN dept.dname%TYPE,
    p_loc IN dept.loc%TYPE)
IS 


BEGIN

    INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc);

END;
/

exec registdept_test(99,'ddit','daejeon');

SELECT *
FROM dept_test;

rollback;

commit;