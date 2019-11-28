--emp 테이블, dept 테이블 조인

EXPLAIN PLAN FOR
SELECT ename, emp.deptno, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT * 
FROM TABLE(DBMS_XPLAN.DISPLAY);

--실행계획 결과 순서는 2(DEPT)-3(EMP)-1(JOIN)-0(SELECT) 자식(자식은 위에서 아래로)을 먼저 읽고 부모를 읽음

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

--natural join : 조인 테이블간 같은 타입, 같은 이름의 컬럼으로
--               같은 값을 갖을 경우 조인
DESC emp;
DESC dept;

ALTER TABLE emp DROP COLUMN dname;


--ANSI SQL
SELECT deptno, emp.empno, ename
FROM emp NATURAL JOIN dept;

SELECT deptno, a.empno, ename
FROM emp a NATURAL JOIN dept b;

--oracle 문법
SELECT emp.deptno, emp.empno, ename
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT a.deptno, empno, ename
FROM emp a, dept b
WHERE a.deptno = b.deptno;


--JOIN USING
--join 하려고 하는 테이블 간 동일한 이름의 컬러밍 두개 이상일 때
--join 컬럼을 하나만 사용하고 싶을 때

--ANSI SQL
SELECT *
FROM emp JOIN dept USING (deptno);

--ORACLE SQL
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--ANSI JOIN whith ON
--조인 하고자 하는 테이블의 컬럼 이름이 다를때
--개발자가 조인 조건을 직접 제어할 때

SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno);

--oracle
SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--SELF JOIN : 같은 테이블간 조인
--emp 테이블간 조인 할만한 사항 : 직원의 관리자 정보 조회
--직원의 관리자 정보를 조회
--직원이름, 관리자이름

--ANSI
--직원 이름, 직원의 상급자 이름, 직원의 상급자의 상급자 이름
SELECT e.ename, m.ename, mm.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
           JOIN emp mm ON(m.mgr = mm.empno) ;


--ORACLE
SELECT e.ename, m.ename, mm.ename
FROM emp e, emp m, emp mm
WHERE e.mgr = m.empno
AND m.mgr = mm.empno;

--직원 이름, 직원의 상급자 이름, 직원의 상급자의 상급자 이름, 직원의 관리자의 관리자의 관리자 이름
SELECT e.ename, m.ename, mm.ename, mmm.ename
FROM emp e, emp m, emp mm, emp mmm
WHERE e.mgr = m.empno
AND m.mgr = mm.empno
AND mm.mgr = mmm.empno;

--여러테이블을 ANSI JOIN을 이용한 JOIN
SELECT e.ename, m.ename, t.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
           JOIN emp t ON(m.mgr = t.empno)
           JOIN emp k ON(t.mgr = k.empno);
           

--직원의 이름과, 해당 직원의 관리자 이름을 조회한다
--단 직원의 사번이 7369~7698인 직원을 대상으로 조회

SELECT e.empno, e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno
AND e.empno BETWEEN 7369 AND 7698;

--ANSI
SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;


--NON-EQUI JOING : 조인 조건이 =(equal)이 아닌 JOIN
-- != , BETWEEN AND
SELECT *
FROM salgrade;


SELECT empno, ename, sal, grade /*급여 grade */
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;


SELECT empno, ename, sal, grade /*급여 grade */
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
