--sub1
--평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요.

SELECT count(*)
FROM emp
WHERE sal > (SELECT AVG(sal)
                FROM emp);
                
                
--sub2
--평균 급여보다 높은 급여를 받는 직원의 정보를 조회하세요.

SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
                FROM emp);
                
                
--sub3
SELECT *
FROM emp
WHERE deptno IN(SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH','WARD'));
                
--sub5
SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                    FROM cycle
                   WHERE cid =1);
                   
--sub6

SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
            FROM cycle
            WHERE cid = 2);


--sub7
SELECT a.cid, cnm, a.pid, pnm, day, cnt
FROM
(SELECT *
FROM cycle
WHERE cid = 1
AND pid IN (SELECT pid
              FROM cycle
             WHERE cid =2))a, customer, product
WHERE a.cid = customer.cid
AND a.pid = product.pid;