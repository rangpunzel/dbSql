--
SELECT *
FROM emp_test;

--emp���̺� �����ϴ� �����͸� emp_test ���̺�� ����
--���� empno�� ������ �����Ͱ� �����ϸ� 
-- ename update : ename || '_merge'
--���� empno�� ������ �����Ͱ� ���� ���� �������
--emp���̺��� empno, ename, emp_test �����ͷ� insert

--emp_test �����Ϳ��� ������ �����͸� ����
DELETE emp_test
WHERE empno >= 7788;
commit;

--emp ���̺��� 14���� �����Ͱ�����
--emp_test ���̺��� ����� 7788���� ���� 7���� �����Ͱ� ����
--emp���̺��� �̿��Ͽ� emp_test ���̺��� �����ϰ� �Ǹ�
--emp ���̺��� �����ϴ� ���� (����� 7788���� ũ�ų� ���� ����) 7��
--emp_test�� ���Ӱ� insert�� �� ���̰�
--emp, emp_test�� �����ȣ�� �����ϰ� �����ϴ� 7���� �����ʹ�
--(����� 7788���� ���� ����)ename �÷��� ename || '_modify'��
--������Ʈ�� �Ѵ�.

/*
MERGE INTO ���̺��
USING ������� ���̺�|VIEW|SUBQUERY
ON (���̺��� ��������� �������)
WHEN MATCHED THEN
    UPDATE ....
WHEN NOT MATCHED THEN
    INSERT ....
*/

MERGE INTO emp_test
USING emp
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = ename || '_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES (emp.empno, emp.ename);
    
SELECT *
FROM emp_test;

-- emp_test ���̺� ����� 9999�� �����Ͱ� �����ϸ�
-- ename�� 'brown'���� update
--�������� ���� ��� empno, ename VALUES (9999, 'brown')���� insert
--���� �ó������� MERGE ������ Ȱ���Ͽ� �ѹ��� sql�� ����
-- :empno - 9999, :ename - 'brown'
MERGE INTO emp_test
USING dual
ON (emp_test.empno = :empno)
WHEN MATCHED THEN
    UPDATE SET ename = :ename || '_mod'
WHEN NOT MATCHED THEN
    INSERT VALUES (:empno, :ename);

SELECT *
FROM emp_test
WHERE empno=9999;

--���� merge ������ ���ٸ� (** 2���� SQL�� �ʿ�)
-- 1. empno = 9999�� �����Ͱ� �����ϴ��� Ȯ��
-- 2-1. 1�� ���׿��� �����Ͱ� �����ϸ� UPDATE
-- 2-2. 1�����׿��� �����Ͱ� �������� ������ INSERT

--�ǽ� GROUP_AD1
--���� ���̺��� �ι� �д´�.
SELECT deptno, sum(sal) sal
FROM emp
GROUP BY deptno
UNION ALL
SELECT NULL, sum(sal)
FROM emp;

--JOIN �������
--emp ���̺��� 14�� �����͸� 28������ ����
--������(1-14, 2-14)�� �������� group by
--������ 1 : �μ���ȣ �������� 14
--������ 2 : ��ü 14 row
SELECT DECODE(b.rn, 1, emp.deptno, 2, null) deptno,
       SUM(emp.sal) sal
FROM emp, (SELECT ROWNUM rn
            FROM dept
            WHERE ROWNUM <=2) b
GROUP BY DECODE(b.rn, 1, emp.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, emp.deptno, 2, null);


SELECT DECODE(b.rn, 1, emp.deptno, 2, null) deptno,
       SUM(emp.sal) sal
FROM emp, (SELECT 1 rn FROM dual UNION ALL
            SELECT 2 FROM dual) b
GROUP BY DECODE(b.rn, 1, emp.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, emp.deptno, 2, null);


SELECT DECODE(b.rn, 1, emp.deptno, 2, null) deptno,
       SUM(emp.sal) sal
FROM emp, (SELECT LEVEL rn 
            FROM dual 
            CONNECT BY LEVEL <=2) b
GROUP BY DECODE(b.rn, 1, emp.deptno, 2, null)
ORDER BY DECODE(b.rn, 1, emp.deptno, 2, null);

--REPORT GROUP BY
--ROLLUP
--GROUP BY ROLLUP (col1....)
--ROLLUP���� ����� �÷��� �����ʿ��� ���� ���� �����
--SUB GROUP�� �����Ͽ� �������� GROUP BY���� �ϳ��� SQL���� ����ǵ��� �Ѵ�
GROUP BY ROLLUP(jobm deptno)
--GROUP BY job, deptno
--GROUP BY job
--GROUP BY -->��ü ���� ������� GROUP BY



--emp���̺��� �̿��Ͽ� �μ���ȣ��, ��ü������ �޿� ���� ���ϴ� ������ 
--ROLLUP ����� �̿��Ͽ� �ۼ�

SELECT deptno, SUM(sal) sal
FROM emp
GROUP BY ROLLUP(deptno);

--EMP ���̺��� �̿��Ͽ� job, deptno�� sal+comm �հ�
--                    job �� sal+comm �հ�
--                    ��ü������ sal+comm �հ�
-- ROLLUP�� Ȱ���Ͽ� �ۼ�

SELECT job, deptno, SUM(sal + NVL(comm,0)) sal_sum
FROM emp
GROUP BY ROLLUP(job, deptno);
--GROUPBY job, deptno
--GROUPBY job
--GROUPBY BY -->��ü ROW���

--ROLLUP�� �÷� ������ ��ȸ ����� ������ ��ģ��
GROUP BY ROLLUP(deptno, job);
--GROUPBY deptno, job
--GROUPBY deptno
--GROUPBY BY -->��ü ROW���

--GROUP_AD2
SELECT DECODE(GROUPING(job),1,'�Ѱ�',job) job, 
      deptno, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--GROUP_AD2_1
--����
SELECT DECODE(GROUPING(job),1,'��',job) job, 
       DECODE(GROUPING(job),1,DECODE(GROUPING(deptno),1,'��',deptno),
                            1,DECODE(GROUPING(deptno),1,'��',deptno)) deptno, 
       SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--DECODE �� ����ϰ�..
SELECT DECODE(GROUPING(job),1,'��',job) job, 
       DECODE(GROUPING(job)+GROUPING(deptno),2,'��',1,'�Ұ�',deptno) deptno,     
       SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


SELECT DECODE(GROUPING(job),1,'�Ѱ�',job) job, 
        CASE
        WHEN deptno IS NULL AND job IS NULL THEN '��'
        WHEN deptno IS NULL THEN '�Ұ�'
        ELSE '' || deptno  --TO_CHAR(deptno)
        END deptno, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(job, deptno);


--GROUP_AD3
SELECT deptno, job, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

--UNION ALL�� ġȯ
SELECT deptno, job, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY deptno, job
UNION ALL
SELECT deptno, null, SUM(sal + NVL(comm,0)) sal
FROM emp
GROUP BY deptno
UNION ALL
SELECT null, null, SUM(sal + NVL(comm,0)) sal
FROM emp;


--GROUP_AD4
SELECT dname, job, SUM(sal + NVL(comm,0)) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname, job)
ORDER BY dname, job DESC;


SELECT dept.dname, a.job, a.sal
FROM
    (SELECT deptno, job, SUM(sal + NVL(comm,0)) sal
    FROM emp
    GROUP BY ROLLUP(deptno, job)) a, dept
WHERE dept.deptno(+) = a.deptno;


--GROUP_AD5
SELECT DECODE(GROUPING(dname),1,'����',dname)dname, job, SUM(sal + NVL(comm,0)) sal
FROM emp, dept
WHERE emp.deptno = dept.deptno
GROUP BY ROLLUP(dname, job)
ORDER BY dname, job DESC;

