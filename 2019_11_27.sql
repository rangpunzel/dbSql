--con1
--CASE
--WHEN condition THEN return1
--END
--DECODE(col|expr, search1, return1m search2, return2...,default)
SELECT empno, ename, 
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
        END dename,
            
         DECODE(deptno, 10, 'ACCOUNTING',
                        20, 'RESEARCH',
                        30, 'SALES',
                        40, 'OPERATIONS','DDIT') dcode
FROM emp;


--cond2
--�ǰ����� ����� ��ȸ ����
--1. ���س⵵�� ¦��/Ȧ��������
--2. hiredate���� �Ի�⵵�� ¦��/Ȧ������

--1. TO_CHAR(SYSDATE,'YYYY')
-->���س⵵ ���� ( 0:¦����, 1:Ȧ����)
SELECT MOD(TO_CHAR(SYSDATE,'YYYY'),2)    
FROM dual;

--2.
SELECT empno, ename, 
       CASE
            WHEN MOD(TO_CHAR(hiredate,'YYYY'),2) =
                 MOD(TO_CHAR(SYSDATE,'YYYY'),2) 
            THEN '�ǰ����� �����'
            ELSE '�ǰ����� ������'
        END contact_to_doctor,
        DECODE(MOD(TO_CHAR(hiredate,'YYYY'),2),
               MOD(TO_CHAR(SYSDATE,'YYYY'),2),
               '�ǰ����� �����','�ǰ����� ������') decode
FROM emp;

--2.
--����(2020)�� �ǰ����� ����ڸ� ��ȸ�ϴ� ������ �ۼ��غ�����.
SELECT empno, ename, 
       CASE
            WHEN MOD(TO_CHAR(hiredate,'YYYY'),2) =
                 MOD(TO_CHAR(TO_DATE('2020','YYYY'),'YYYY'),2) 
            THEN '�ǰ����� �����'
            ELSE '�ǰ����� ������'
        END contact_to_doctor
FROM emp;

SELECT empno, ename, 
       CASE
            WHEN MOD(TO_CHAR(hiredate,'YYYY'),2) =
                 MOD(2020,2)   --> OR MOD(TO_CHAR(SYSDATE, 'YYYY')+1,2)
            THEN '�ǰ����� �����'
            ELSE '�ǰ����� ������'
        END contact_to_doctor
FROM emp;

--cond3
SELECT userid, usernm, alias, reg_dt,
      CASE WHEN MOD(TO_CHAR(reg_dt,'YYYY'),2) = 
                MOD(TO_CHAR(SYSDATE,'YYYY'),2)
           THEN '�ǰ����� �����'
           ELSE '�ǰ����� ������'
      END contacttodoctor,
      
      DECODE(MOD(TO_CHAR(reg_dt,'YYYY'),2),MOD(TO_CHAR(SYSDATE,'YYYY'),2),'�ǰ����� �����','�ǰ����� ������') decode
FROM users;

SELECT a.userid, a.usernm, a.alias, 
       DECODE (MOD(a.yyyy,2),MOD(a.this_yyyy, 2), '�ǰ��������','�ǰ���������') contacttodoctor
FROM   (SELECT userid, usernm, alias, TO_CHAR(reg_dt, 'YYYY') yyyy,
               TO_CHAR(SYSDATE, 'YYYY') this_yyyy
        FROM users) a;
        
        
--GROUP FUNCTION
--Ư�� �÷��̳�, ǥ���� �������� �������� ���� ������ ����� ����
--COUNT-�Ǽ�, SUM-�հ�, AVG-���, MAX-�ִ밪, MIN-�ּҰ�
--��ü ������ ������� (14�� -> 1��)
DESC emp;


SELECT MAX(sal) max_sal,  --���� ���� �޿�
       MIN(sal) min_sal,   --���� ���� �޿�
       ROUND(AVG(sal),2) avg_sal,  --�� ������ �޿� ���
       SUM(sal) sum_sal, -- �� ������ �޿� �հ�
       COUNT(sal) count_sal,  --�޿� �Ǽ�(null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr,  --������ ������ �Ǽ�(KING�� ��� MGR�� ����)
       COUNT(*) count_row     --Ư�� �÷��� �Ǽ��� �ƴ϶� ������ �˰� ������
FROM emp;


--�μ���ȣ�� �׷��Լ� ����
SELECT deptno, 
       MAX(sal) max_sal,  --�μ����� ���� ���� �޿�
       MIN(sal) min_sal,   --�μ����� ���� ���� �޿�
       ROUND(AVG(sal),2) avg_sal,  --�μ� ������ �޿� ���
       SUM(sal) sum_sal, -- �μ� ������ �޿� �հ�
       COUNT(sal) count_sal,  --�μ��� �޿� �Ǽ�(null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr,  --�μ� ������ ������ �Ǽ�(KING�� ��� MGR�� ����)
       COUNT(*) count_row     --�μ��� ��������
FROM emp
GROUP BY deptno;



SELECT deptno, ename,
       MAX(sal) max_sal,  --�μ����� ���� ���� �޿�
       MIN(sal) min_sal,   --�μ����� ���� ���� �޿�
       ROUND(AVG(sal),2) avg_sal,  --�μ� ������ �޿� ���
       SUM(sal) sum_sal, -- �μ� ������ �޿� �հ�
       COUNT(sal) count_sal,  --�μ��� �޿� �Ǽ�(null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr,  --�μ� ������ ������ �Ǽ�(KING�� ��� MGR�� ����)
       COUNT(*) count_row     --�μ��� ��������
FROM emp
GROUP BY deptno, ename;


--SELECT������ GROUP BY ���� ǥ���� �÷� �̿��� �÷��� �� �� ����.
--�������� ������ ���� ����(�������� ���� ������ �Ѱ��� �����ͷ� �׷���)
--�� ���������� ��������� SELECT ���� ǥ���� ����
SELECT deptno, 1, '���ڿ�', SYSDATE,
       MAX(sal) max_sal,  --�μ����� ���� ���� �޿�
       MIN(sal) min_sal,   --�μ����� ���� ���� �޿�
       ROUND(AVG(sal),2) avg_sal,  --�μ� ������ �޿� ���
       SUM(sal) sum_sal, -- �μ� ������ �޿� �հ�
       COUNT(sal) count_sal,  --�μ��� �޿� �Ǽ�(null�� �ƴ� ���̸� 1��)
       COUNT(mgr) count_mgr,  --�μ� ������ ������ �Ǽ�(KING�� ��� MGR�� ����)
       COUNT(*) count_row     --�μ��� ��������
FROM emp
GROUP BY deptno;


--�׷��Լ������� NULL �÷��� ��꿡�� ���ܵȴ�.
--emp ���̺��� comm�÷��� null�� �ƴ� �����ʹ� 4���� ����, 9���� NULL)
SELECT COUNT(comm) count_comm, --NULL�� �ƴ� ���� ���� 4
       SUM(comm) sum_comm,   --NULL���� ����, 300 + 500 + 1400 + 0 = 2200
       SUM(sal) sum_sal,
       SUM(sal + comm) tot_sal_sum,
       SUM(sal + NVL(comm,0)) tot_sal_sum
FROM emp;


--WHERE������ GROUP �Լ��� ǥ�� �� �� ����.
--1.�μ��� �ִ� �޿� ���ϱ�
--2.�μ��� �ִ� �޿� ���� 3000 �Ѱų� ���� �ุ ���ϱ�
--deptno, �ִ� �޿�
SELECT deptno, MAX(sal) m_sal
FROM emp
WHERE MAX(sal) > 3000  --ORA-00934 WHERE������ GROUP �Լ��� �� �� ����
GROUP BY deptno;

SELECT deptno, MAX(sal) m_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal) >= 3000;

--grp1
SELECT MAX(sal) max_sal,
       MIN(sal) min_sal,
       ROUND(AVG(sal),2) avg_sal,
       SUM(sal) sum_sal,
       COUNT(sal) count_sal,
       COUNT(MGR) count_mgr,
       COUNT(*) count_all
FROM emp;

--grp2
SELECT deptno, MAX(sal) max_sal,
               MIN(sal) min_sal,
               ROUND(AVG(sal),2) avg_sal,
               SUM(sal) sum_sal,
               COUNT(sal) count_sal,
               COUNT(mgr) count_mgr,
               COUNT(*) count_all
FROM emp
GROUP BY deptno;

--grp3
SELECT deptno, 
               CASE WHEN deptno = 30 THEN 'ACCOUNTING'
                    WHEN deptno = 20 THEN 'RESEARCH'
                    WHEN deptno = 10 THEN 'SALES'
                           END dname,
               MAX(sal) max_sal,
               MIN(sal) min_sal,
               ROUND(AVG(sal),2) avg_sal,
               SUM(sal) sum_sal,
               COUNT(sal) count_sal,
               COUNT(mgr) count_mgr,
               COUNT(*) count_all,
               
FROM emp
GROUP BY deptno;



--grp4
--1. hiredate �÷��� ���� YYYYMM �������� �����
--date Ÿ���� ���ڿ��� ���� (YYYYMM)

SELECT TO_CHAR(hiredate,'YYYYMM') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');


SELECT hire_yyyymm, COUNT(*) cnt
FROM
    (SELECT TO_CHAR(hiredate,'YYYYMM') hire_yyyymm
     FROM emp)
GROUP BY hire_yyyymm;


--grp5
SELECT TO_CHAR(hiredate,'YYYY') hire_yyyy, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY');


--grp6
--��ü �μ��� ���ϱ�(
SELECT COUNT(*) CNT, COUNT(deptno), COUNT(loc)
FROM dept;

--��ü ������ ���ϱ�(emp)
SELECT COUNT(*), COUNT(empno)
FROM emp;


--grp7
SELECT COUNT(*) cnt
FROM (SELECT deptno
      FROM emp
      GROUP BY DEPTNO);
      
SELECT COUNT(COUNT(deptno)) cnt
FROM emp
GROUP BY deptno;

--DISTINCT �ߺ��� ����
SELECT COUNT(DISTINCT deptno)
FROM emp;


--JOIN
--1. ���̺� ��������(�÷� �߰�)
--2. �߰��� �÷��� ���� update
--dname �÷��� emp ���̺� �߰�
DESC emp;
DESC dept;

--�÷��߰�(dname, VARCHAR2(14))

ALTER TABLE emp ADD (dname VARCHAR2(14));
DESC emp;

SELECT * 
FROM emp;

UPDATE emp SET dname = CASE
                            WHEN deptno = 10 THEN 'ACCOUNTING'
                            WHEN deptno = 20 THEN 'RESEARCH'
                            WHEN deptno = 30 THEN 'SALES'
                        END;
                        
COMMIT;


SELECT empno, ename, deptno, dname
FROM emp;


--SALES -- > MARKET SALES
--�� 6���� ������ ������ �ʿ��ϴ�
--���� �ߺ��� �ִ� ����(�� ������)
UPDATE emp SET dname = 'MARKET SALES'
WHERE dname = 'SALES';


--emp ���̺�, dept ���̺� ����
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;