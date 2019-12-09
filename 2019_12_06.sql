SELECT *
FROM dept;

--dept���̺� �μ���ȣ 99, �μ��� ddit, ��ġ daejeon

INSERT INTO dept VALUES (99,'ddit','daejeon');
commit;

--UPDATE : ���̺� ����� �÷��� ���� ����
--UPDATE ���̺�� SET �÷���1 = �����Ϸ����ϴ°�1, �÷���2 = �����Ϸ����ϴ°�2.....
--[WHERE row ��ȸ ����] --��ȸ���ǿ� �ش��ϴ� �����͸� ������Ʈ�� �ȴ�.

--�μ���ȣ�� 99���� �μ��� �μ����� ���IT��, ������ ���κ������� ����
UPDATE dept SET dname = '���IT', loc = '���κ���'
WHERE deptno = 99;

--������Ʈ���� ������Ʈ�Ϸ��� �ϴ� ���̺��� WHERE���� ����� �������� SELECT��
--�Ͽ� ������Ʈ ��� ROW�� Ȯ���غ���.
SELECT *
FROM dept
WHERE deptno = 99;

commit;
--���� QUERY�� �����ϸ� WHERE���� ROW ���� ������ ������ ������
--dept ���̺��� ��� �࿡ ���� �μ���, ��ġ ������ �����Ѵ�.
UPDATE dept SET dname = '���IT', loc = '���κ���';


--SUBQUERY�� �̿��� UPDATE
--emp ���̺� �ű� ������ �Է�
--�����ȣ 9999, ����̸� brown, ���� : null
INSERT INTO emp (empno, ename) VALUES (9999,'brown');
COMMIT;

--�����ȣ�� 9999�� ����� �Ҽ� �μ���, �������� SMITH����� �μ�, ������ ������Ʈ
UPDATE emp SET deptno = (SELECT deptno FROM emp WHERE ename='SMITH'), 
                            job = (SELECT job FROM emp WHERE ename='SMITH')
WHERE empno=9999;
COMMIT;

SELECT *
FROM emp
WHERE empno=9999;

--DELETE : ���ǿ� �ش��ϴ� ROW(��)�� ����
--�÷��� ���� ����??(NULL)������ �����Ϸ��� --> UPDATE

--DELETE ���̺��
--[WHERE ����]

--UPDATE������ ���������� DELETE ���� ���������� �ش� ���̺��� WHERE������ ����
--�ϰ� �Ͽ� SELECT�� ����, ������ ROW�� ���� Ȯ���غ���

--emp ���̺� �����ϴ� �����ȣ 9999�� ����� ����
DELETE emp
WHERE empno = 9999;
COMMIT;

SELECT *
FROM emp;
WHERE empno=9999;


--�Ŵ����� 7698�� ��� ����� ����
--���������� ���
DELETE emp
WHERE empno IN (SELECT empno
                  FROM emp
                 WHERE mgr = 7698);
--�� ������ �Ʒ� ������ ����
DELETE emp WHERE mgr = 7698;

SELECT *
FROM emp;
WHERE mgr = 7698;

ROLLBACK;


--�б� �ϰ��� (ISOLATION LEVEL)
--DML���� �ٸ� ����ڿ��� ��� ������ ��ġ���� ������ ����(0-3)

--A����ڿ��� deptno�� 99 �� ����ڸ� �����ص� Ŀ������ ������ B������� �����ʹ� �״����..
--A����ڰ� deptno�� 99�� ����ڿ� ���� ����ϰ� ������ B����ڴ� �����������.

--ISOLATION LEVEL2
--���� Ʈ����ǿ��� ���� ������
--(FOR UPDATE)�� ����, ���� ��������.

SELECT *
FROM dept
WHERE deptno =40
FOR UPDATE;

--�ٸ� Ʈ����ǿ��� ������ ���ϱ� ������ �� Ʈ����ǿ��� 
--�ش� ROW�� �׻� ������ ��������� ��ȸ �� �� �ִ�.(�����б� phantom read)

--B�����
INSERT INTO dept VALUES (98, 'ddit2', 'seoul');
commit;
-- ���� ���� �ϸ� A����ڰ� ��ȸ������ ��ȸ�� �ȴ�.

--ISOLATION LEVEL3
--SERIALIAZBLE READ
--Ʈ������� ������ ��ȸ ������ Ʈ����� ���� �������� ��������
--�� ���� Ʈ����ǿ��� �����͸� �ű� �Է�, ����, ���� �� COMMIT�� �ϴ���
--���� Ʈ����ǿ����� �ش� �����͸� �����ʴ´�.

--Ʈ����� ���� ����(serializable read)
SET TRANSACTION isolation LEVEL SERIALIZABLE;

SET TRANSACTION isolation LEVEL READ COMMITTED;


--DDL : TABLE ����
--CREATE TABLE [����ڸ�.]���̺��(
--  �÷���1 �÷�Ÿ��1,
--  �÷���1 �÷�Ÿ��2, ....
--  �÷���N �÷�Ÿ��N
--ranger_no NUMBER          :������ ��ȣ
--ranger_nm VARCHAR2(50)    :������ �̸�
--reg_dt DATE               :������ �������
--���̺� ���� DDL : Data Defination Language(������ ���Ǿ�)
--DDL rollback�� ����(�ڵ�Ŀ�� �ǹǷ� rollback�� �� �� ����)
CREATE TABLE ranger(
    ranger_no NUMBER,
    ranger_nm VARCHAR2(50),
    reg_dt DATE );
    
DESC ranger;
--DDL ������ ROLLBACK ó���� �Ұ�!!!
ROLLBACK;

SELECT *
FROM user_tables
WHERE table_name = 'RANGER';
-- WHERE table_name = 'ranger';
--����Ŭ������ ��ü ������ �ҹ��ڷ� �����ϴ���
--���������δ� �빮�ڷ� �����Ѵ�.

INSERT INTO ranger VALUES(1, 'brown', sysdate);

SELECT *
FROM ranger;

--DML���� DDL�� �ٸ��� ROLLBACK�� �����ϴ�

ROLLBACK;
--ROLLBACK�� �߱� ������ DML������ ��ҵȴ�.


--DATE Ÿ�Կ��� �ʵ� �����ϱ�
--ExTRACT(�ʵ�� FROM �÷�/expression)
SELECT TO_CHAR(SYSDATE,'YYYY') yyyy,
        TO_CHAR(SYSDATE,'MM') mm,
        EXTRACT(year FROM SYSDATE) ex_yyyy,
        EXTRACT(month FROM SYSDATE) ex_mm
FROM dual;

--���̺� ������ �÷� ���� �������� ����
CREATE TABLE dept_test(
        deptno NUMBER(2),
        danem VARCHAR2(14),
        loc VARCHAR2(13));

DROP TABLE dept_test;

CREATE TABLE dept_test(
        deptno NUMBER(2) PRIMARY KEY,
        danem VARCHAR2(14),
        loc VARCHAR2(13));

--dept_test ���̺��� deptno �÷��� PRIMARY KEY ���������� �ֱ� ������
--deptno�� ������ �����͸� �Է��ϰų� ���� �� �� ����.
INSERT INTO dept_test VALUES(99, 'ddit','deajeon');

--dept_test �����Ϳ� deptno�� 99���� �����Ͱ� �����Ƿ�
--primary key �������ǿ� ���� �Է� �� �� ����.
--IRA-00001 unique constraint ���� ����
--����Ǵ� �������Ǹ� SYS-C007101�������� ����
--SYS-C007105 ���������� � ���� �������� �Ǵ��ϱ� ����Ƿ�
--�������ǿ� �̸��� �ڵ� �꿡 ���� �ٿ� �ִ� ���� ���������� ���ϴ�.

INSERT INTO dept_test VALUES(99, '���','����');

--���̺� ������ �������� �̸��� �߰��Ͽ� �����
--primary key : pk_���̺��
DROP TABLE dept_test;

CREATE TABLE dept_test(
        deptno NUMBER(2) CONSTRAINT pk_dept_test PRIMARY KEY,
        dname VARCHAR2(14),
        loc VARCHAR2(13));
        
INSERT INTO dept_test VALUES(99, 'ddit','deajeon');
INSERT INTO dept_test VALUES(99, '���','����');
