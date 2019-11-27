--20191127 연습해보자

--grp1
SELECT MAX(sal) max,
       MIN(sal) min,
       ROUND(AVG(sal),2) avg,
       SUM(sal) sum,
       COUNT(sal) count_sal,
       COUNT(mgr) count_mgr,
       COUNT(*)
FROM emp;


--grp2
SELECT deptno, MAX(sal) max,
               MIN(sal) min,
               ROUND(AVG(sal),2) avg,
               SUM(sal) sum,
               COUNT(sal) count_sal,
               COUNT(mgr) count_mgr,
               COUNT(*) count_all
FROM emp
GROUP BY deptno;



--grp3
SELECT CASE WHEN deptno = '10' THEN 'ACCOUNTING'
            WHEN deptno = '20' THEN 'RESEARCH'
            WHEN deptno = '30' THEN 'SALES'
       END dname
             , MAX(sal) max,
               MIN(sal) min,
               ROUND(AVG(sal),2) avg,
               SUM(sal) sum,
               COUNT(sal) count_sal,
               COUNT(mgr) count_mgr,
               COUNT(*) count_all
FROM emp
GROUP BY deptno;

--grp4
SELECT hire_yyyymm, COUNT(hire_yyyymm) CNT
FROM(SELECT TO_CHAR(hiredate,'YYYYMM') hire_yyyymm
FROM emp)
GROUP BY hire_yyyymm;



--grp5
SELECT hire_yyyy, COUNT(hire_yyyy) cnt
FROM(SELECT TO_CHAR(hiredate,'yyyy') hire_yyyy
FROM emp)
GROUP BY hire_yyyy;



--grp6
SELECT COUNT(deptno) cnt
FROM dept;


--grp7
SELECT COUNT(*) cnt
FROM(SELECT deptno
     FROM emp
     GROUP BY deptno);