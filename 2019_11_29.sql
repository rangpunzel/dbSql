--join0_3
--사원번호. 사원이름. 급여, 부서번호, 부서이름
--사원번호, 사원이름, 급여 : emp
--부서번호 : emp, dept
--부서이름 : dept
SELECT empno, ename, sal, d.deptno, dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
AND sal > 2500
AND empno > 7600;

SELECT empno, ename, sal, deptno, dname
FROM emp NATURAL JOIN dept
WHERE sal > 2500
AND empno > 7600;

SELECT empno, ename, sal, e.deptno, dname
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

--join1
SELECT lprod.lprod_gu, lprod.lprod_nm, prod.prod_id, prod.prod_name
FROM prod JOIN lprod ON(prod.prod_lgu = lprod.lprod_gu);

--join2
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON (prod_buyer = buyer_id);

--join3
SELECT mem_id, mem_name, prod_id, prod_name,cart_qty
FROM member, cart, prod
WHERE mem_id = cart_member
AND prod_id = cart_prod;

--join4
SELECT cid, cnm, pid, day, cnt
FROM customer NATURAL JOIN cycle;

--join5
SELECT cycle.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
AND cnm IN ('brown', 'sally');


--join6
SELECT cycle.cid, cnm, cycle.pid, pnm, sum(cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND product.pid = cycle.pid
GROUP BY cycle.cid, cnm, cycle.pid, pnm;


--join7
SELECT product.pid, pnm, sum(cnt) cnt
FROM cycle JOIN product ON(cycle.pid = product.pid)
GROUP BY product.pid, pnm;

