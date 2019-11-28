--emp ���̺�, dept ���̺� ����

EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT * 
FROM TABLE(DBMS_XPLAN.DISPLAY);

--�����ȹ ��� ������ 2(DEPT)-3(EMP)-1(JOIN)-0(SELECT) �ڽ�(�ڽ��� ������ �Ʒ���)�� ���� �а� �θ� ����

SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.deptno =10;


SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno != dept.deptno
AND emp.deptno =10;


SELECT ename, deptno
FROM emp;

SELECT deptno, dname
FROM dept;

--natural join : ���� ���̺� ���� Ÿ��, ���� �̸��� �÷�����
--               ���� ���� ���� ��� ����
DESC emp;
DESC dept;

ALTER TABLE emp DROP COLUMN dname;


--ANSI SQL
SELECT deptno, emp.empno, ename
FROM emp NATURAL JOIN dept;

SELECT deptno, a.empno, ename
FROM emp a NATURAL JOIN dept b;

--oracle ����
SELECT emp.deptno, emp.empno, ename
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT a.deptno, empno, ename
FROM emp a, dept b
WHERE a.deptno = b.deptno;


--JOIN USING
--join �Ϸ��� �ϴ� ���̺� �� ������ �̸��� �÷��� �ΰ� �̻��� ��
--join �÷��� �ϳ��� ����ϰ� ���� ��

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno);

--ORACLE SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI JOIN whith ON
--���� �ϰ��� �ϴ� ���̺��� �÷� �̸��� �ٸ���
--�����ڰ� ���� ������ ���� ������ ��

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--oracle
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF JOIN : ���� ���̺� ����
--emp ���̺� ���� �Ҹ��� ���� : ������ ������ ���� ��ȸ
--������ ������ ������ ��ȸ
--�����̸�, �������̸�

--ANSI
--���� �̸�, ������ ����� �̸�, ������ ������� ����� �̸�
SELECT e.ename, m.ename, mm.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
           JOIN emp mm ON(m.mgr = mm.empno) ;


--ORACLE
SELECT e.ename, m.ename, mm.ename
FROM emp e, emp m, emp mm
WHERE e.mgr = m.empno
AND m.mgr = mm.empno;

--���� �̸�, ������ ����� �̸�, ������ ������� ����� �̸�, ������ �������� �������� ������ �̸�
SELECT e.ename, m.ename, mm.ename, mmm.ename
FROM emp e, emp m, emp mm, emp mmm
WHERE e.mgr = m.empno
AND m.mgr = mm.empno
AND mm.mgr = mmm.empno;

--�������̺��� ANSI JOIN�� �̿��� JOIN
SELECT e.ename, m.ename, t.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
           JOIN emp t ON(m.mgr = t.empno)
           JOIN emp k ON(t.mgr = k.empno);
           

--������ �̸���, �ش� ������ ������ �̸��� ��ȸ�Ѵ�
--�� ������ ����� 7369~7698�� ������ ������� ��ȸ

SELECT e.empno, e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno
AND e.empno BETWEEN 7369 AND 7698;

--ANSI
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;


--NON-EQUI JOING : ���� ������ =(equal)�� �ƴ� JOIN
-- != , BETWEEN AND
SELECT *
FROM salgrade;


SELECT empno, ename, sal, grade /*�޿� grade */
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;


SELECT empno, ename, sal, grade /*�޿� grade */
FROM emp JOIN salgrade ON (emp.sal BETWEEN salgrade.losal AND salgrade.hisal);


--join0
SELECT empno, ename, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY d.deptno;


SELECT empno, ename, deptno, dname
FROM emp NATURAL JOIN dept
ORDER BY deptno;



--join0_1
SELECT empno, ename, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND d.deptno IN (10, 30);

SELECT e.empno, e.ename, d.deptno, d.dname
FROM emp e JOIN dept d ON(e.deptno = d.deptno)
AND d.deptno IN (10, 30);

--join0_2
SELECT empno, ename, sal, d.deptno, dname
FROM emp e, dept d
WHERE sal > 2500
AND e.deptno = d.deptno
ORDER BY sal DESC;

SELECT empno, ename, sal, d.deptno, dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
WHERE sal > 2500
ORDER BY sal DESC;

SELECT empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE sal > 2500
ORDER BY sal DESC;


--join0_3
SELECT empno, ename, sal, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal > 2500
AND empno > 7600;

SELECT empno, ename, sal, d.deptno, dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
WHERE sal > 2500
AND empno > 7600;


--join0_4
SELECT empno, ename, sal, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal > 2500
AND empno > 7600
AND dname = 'RESEARCH';


SELECT empno, ename, sal, d.deptno, dname
FROM emp e JOIN dept d ON (e.deptno = d.deptno)
WHERE sal > 2500
AND empno > 7600
AND dname = 'RESEARCH';
