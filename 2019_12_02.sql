--OUYRT join : 조인 연결에 실패 하더라도 기준이 되는 테이블의 데이터는
--나오도록 하는 join
--LEFT OUTER JOIN : 테이블1 LEFT OUTER JOIN 테이블2
--테이블1과 테이블2를 조인할때 조인에 실패하더라도 테이블1쪽에 데이터는
--조회가 되도록 한다
--조인에 실패한 행에서 테이블2의 컬럼값은 존재하지 않으므로 NULL로 표시된다.

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno);
           
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m
           ON (e.mgr = m.empno);
           

--
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno AND m.deptno=10);
    
           
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno)
WHERE m.deptno=10;


--ORACLE outer join syntax
--일반조인과 차이점은 컬럼명에 (+)표시
--(+)표시 : 데이터가 존재하지 않는데 나와야하는 테이블의 컬럼
--직원 LEFT OUTER JOIN 매니저
--  ON(직원.매니저번호 = 매니저.직원번호)

--ORACLE OUTER
--WHERE 직원.매니저번호 = 매니저.직원번호(+) -- 매니저쪽 데이터가 존재하지 않음
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno(+);

--매니저 부서번호 제한
--ANSI SQL WHERE 절에 기술한 형태
-- -->OUTER 조인이 적용되지 않은 상황
--아우터 조인이 적용되어야 할 테이블의 모든 컬럼에 (+)가 붙어야된다.
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

--ansi sql의 on절에 기술한 경우와 동일
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;


--emp 테이블에는 14명의 직원이 있고 14명은 10, 20, 30부서중에 한 부서에
--속한다
--하지만 dept테이블엔는 10, 20, 30, 40번 부서가 존재

--부서번호, 부서명, 해당부서에 속한 직원수가 나오도록 쿼리를 작성

SELECT d.deptno, d.dname, count(e.ename) cnt
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno
GROUP BY d.deptno, d.dname
ORDER BY d.deptno;


--dept : deptno, dname
-- inline : deptno, cnt(직원의 수)
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) emp_cnt
WHERE dept.deptno = emp_cnt.deptno(+);

--ANSI
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept LEFT OUTER JOIN (SELECT deptno, COUNT(*) cnt
                      FROM emp
                      GROUP BY deptno) emp_cnt
                ON (dept.deptno = emp_cnt.deptno);
                
                
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno);

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m
           ON (e.mgr = m.empno);

--FULL OUTER : LEFT OUTER + RIGHT OUTER - 중복데이터 한건만 남기기
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m
           ON (e.mgr = m.empno);
           
--outerjoin1
SELECT TO_CHAR(buy_date,'yy/mm/dd') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM
(SELECT *
FROM buyprod
WHERE TO_CHAR(buy_date,'yyyy/mm/dd') = TO_DATE('2005/01/25','yyyy/mm/dd')) b
RIGHT OUTER JOIN prod
ON (prod_id = buy_prod);




--outerjoin2
SELECT NVL(TO_CHAR(buy_date,'yy/mm/dd'),TO_CHAR(TO_DATE('05/01/25','yy/mm/dd'),'yy/mm/dd')) buy_date
    , buy_prod, prod_id, prod_name, buy_qty
FROM
(SELECT *
FROM buyprod
WHERE TO_CHAR(buy_date,'yyyy/mm/dd') = TO_DATE('2005/01/25','yyyy/mm/dd')) b
RIGHT OUTER JOIN prod
ON (prod_id = buy_prod);

--outerjoin3
SELECT NVL(TO_CHAR(buy_date,'yy/mm/dd'),TO_CHAR(TO_DATE('05/01/25','yy/mm/dd'),'yy/mm/dd')) buy_date
    , buy_prod, prod_id, prod_name, NVL(buy_qty,0) buy_qty
FROM
(SELECT *
FROM buyprod
WHERE TO_CHAR(buy_date,'yyyy/mm/dd') = TO_DATE('2005/01/25','yyyy/mm/dd')) b
RIGHT OUTER JOIN prod
ON (prod_id = buy_prod);



--outerjoin4
SELECT product.pid, pnm, NVL(cid,1) cid, NVL(day,0) day, NVL(cnt,0)
FROM product LEFT OUTER JOIN 
                            (SELECT pid, cid, day, cnt
                            FROM cycle c
                            WHERE cid = 1)a 
    ON (a.pid = product.pid);



--outerjoin5

SELECT p.pid, p.pnm, p.cid, cnm, p.day, p.cnt
FROM
(SELECT product.pid, pnm, NVL(cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt
FROM product LEFT OUTER JOIN 
                            (SELECT pid, cid, day, cnt
                            FROM cycle c
                            WHERE cid = 1)a 
    ON (a.pid = product.pid))p JOIN customer ON (p.cid = customer.cid);




