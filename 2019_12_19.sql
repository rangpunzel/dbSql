--����̸�, �����ȣ, ��ü�����Ǽ�
SELECT ename, empno, COUNT(*), SUM(sal)
FROM emp
GROUP BY ename, empno;

--ana0
SELECT a.*, rownum sal_rank
FROM
(SELECT ename, sal, deptno
FROM emp 
WHERE deptno = 10
ORDER BY sal DESC)a
UNION ALL
SELECT b.*, rownum
FROM
(SELECT ename, sal, deptno
FROM emp 
WHERE deptno = 20
ORDER BY sal DESC)b
UNION ALL
SELECT c.*, rownum
FROM
(SELECT ename, sal, deptno
FROM emp 
WHERE deptno = 30
ORDER BY sal DESC)c;


SELECT a.ename, a.sal, a.deptno, b.rn
FROM
(SELECT ename, sal, deptno, ROWNUM j_rn
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC))a,

(SELECT rn, ROWNUM j_rn
FROM
    (SELECT b.*, a.rn
    FROM
    (SELECT ROWNUM rn
    FROM dual
    CONNECT BY level <= (SELECT COUNT(*) FROM emp))a,
    
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno)b
    WHERE b.cnt >= a.rn
    ORDER BY b.deptno, a.rn))b
WHERE a.j_rn = b.j_rn;

-- ana0�� �м��Լ���
SELECT ename, sal, deptno,
       RANK() OVER (PARTITION BY deptno ORDER BY sal) rank,
       DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal) dense_rank,
       ROW_NUMBER() OVER (PARTITION BY deptno ORDER BY sal) row_rank
FROM emp;

--�ǽ� ana1
SELECT empno, ename, sal, deptno,
       RANK() OVER (ORDER BY sal DESC, empno) sal_rank,
       DENSE_RANK() OVER (ORDER BY sal DESC, empno) sal_dense_rank,
       ROW_NUMBER() OVER (ORDER BY sal DESC, empno) sal_row_rank
FROM emp;

--�ǽ� no_ana2
SELECT emp.empno, emp.ename, emp.deptno, cnt
FROM emp,
    (SELECT deptno, COUNT(deptno) cnt
     FROM emp
     GROUP BY deptno
     ORDER BY deptno)b
WHERE emp.deptno = b.deptno;


-- �����ȣ, ����̸�, �μ���ȣ, �μ��� ������
SELECT empno, ename, deptno,
       COUNT(*) OVER (PARTITION BY deptno) cnt
FROM emp;

--�ǽ� ana2

SELECT empno, ename, sal, deptno,
       ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg
FROM emp;

--�ǽ� ana3
SELECT empno, ename, sal, deptno,
       MAX(sal) OVER (PARTITION BY deptno) max_sal
FROM emp;

--�ǽ� ana4
SELECT empno, ename, sal, deptno,
    MIN(sal) OVER (PARTITION BY deptno) min_sal
FROM emp;

-- ��ü����� ������� �޿������� �ڽź��� �Ѵܰ� ���� ����� �޿�
-- (�޿��� ���� ��� �Ի����ڰ� ���� ����� ���� ����)
SELECT empno, ename, hiredate, sal,
        LEAD(sal) OVER (ORDER BY sal DESC, hiredate) read_sal
FROM emp;

--ana5
--�޿��� ���� ��� �޿�
SELECT empno, ename, hiredate, sal,
        LAG(sal) OVER (ORDER BY sal DESC, hiredate) rag_sal
FROM emp;

--ana6
SELECT empno, ename, hiredate, job, sal,
       LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

--no_ana3

SELECT c.empno, c.ename, c.sal, sum(d.sal)
FROM
(SELECT  a.*, rownum rn
FROM
    (SELECT empno, ename, sal, hiredate
    FROM emp
    ORDER BY sal, hiredate)a)c,

(SELECT  b.*, rownum rn
FROM
    (SELECT empno, ename, sal
    FROM emp
    ORDER BY sal, hiredate) b)d
WHERE c.rn >= d.rn
GROUP BY c.empno, c.ename, c.sal, c.hiredate
ORDER BY c.sal, c.hiredate;
