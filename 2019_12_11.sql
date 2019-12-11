--INDEX�� ��ȸ�Ͽ� ������� �䱸���׿� �����ϴ� �����͸� �����
--�� �� �ִ� ���

SELECT rowid,emp.* 
FROM emp;

--emp ���̺��� ��� �÷��� ��ȸ
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);

--emp ���̺��� empno �÷��� ��ȸ
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);

--���� �ε��� ����
--pk_emp �������� ����-->unique ���� ���� -->pk_emp �ε��� ����
--iNDEX ���� (�÷� �ߺ� ����)
--UNIQUE INDEX : �ε��� �÷��� ���� �ߺ��� �� ���� �ε���
--              (emp.empno,dept.deptno)
--NON-UNIQUE INDEX(default) : �ε��� �÷��� ���� �ߺ��� �� �ִ� �ε���
--                            (emp.job)
ALTER TABLE emp DROP CONSTRAINT pk_emp;

-- CREATE UNIQUE INDEX idx_n_emp_01 ON emp (empno);

--���� ��Ȳ�̶� �޶��� ���� EMPNO�÷����� ������ �ε�����
--UNIQUE -> NON-UNIQUE �ε����� �����
CREATE INDEX idx_n_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7782;

SELECT *
FROM TABLE (dbms_xplan.display);

--7782
INSERT INTO emp (empno, ename) VALUES (7782,'brown');
rollback;



--emp ���̺� job �÷����� non_unique �ε��� ����
--�ε����� : idx_n_emp_02
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT job, rowid
FROM emp
ORDER BY job;

-- emp ���̺��� �ε����� 2�� ����
-- 1. empno
-- 2. job
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM emp
WHERE empno=7369;

--IDX_02 �ε���
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

--idx_n_emp_03
--emp ���̺��� job, ename �÷����� non-unique �ε��� ����
CREATE INDEX idx_n_emp_03 ON emp (job, ename);

--idx_n_emp_04
--ename, job �÷����� emp ���̺� non-unique �ε��� ����
CREATE INDEX idx_n_emp_04 ON emp (ename, job);

SELECT ename, job, rowid
FROM emp
ORDER BY ename, job;

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'J%';


SELECT *
FROM TABLE (dbms_xplan.display);

-- JOIN ���������� �ε���
-- emp ���̺��� empno�÷����� PRIMARY KEY ���������� ����
-- dept ���̺��� deptno �÷����� PRIMARY KEY ���������� ����
-- emp ���̺��� PRIMARY KEY ������ ������ �����̹Ƿ� �����
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;

SELECT *
FROM TABLE (dbms_xplan.display);

--idx1
DROP TABLE dept_test;
CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1=1;

SELECT *
FROM dept_test;


CREATE UNIQUE INDEX idx_n_dept_test_01 ON dept_test (deptno);
CREATE INDEX idx_n_dept_test_02 ON dept_test (dname);
CREATE INDEX idx_n_dept_test_03 ON dept_test (deptno, dname);

--idx2
DROP INDEX idx_n_dept_test_01;
DROP INDEX idx_n_dept_test_02;
DROP INDEX idx_n_dept_test_03;