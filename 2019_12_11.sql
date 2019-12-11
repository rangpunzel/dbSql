--INDEX만 조회하여 사용자의 요구사항에 만족하는 데이터를 만들어
--낼 수 있는 경우

SELECT rowid,emp.* 
FROM emp;

--emp 테이블의 모든 컬럼을 조회
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);

--emp 테이블의 empno 컬럼을 조회
EXPLAIN PLAN FOR
SELECT empno
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE (dbms_xplan.display);

--기존 인덱스 제거
--pk_emp 제약조건 삭제-->unique 제약 삭제 -->pk_emp 인덱스 삭제
--iNDEX 종류 (컬럼 중복 여부)
--UNIQUE INDEX : 인덱스 컬럼의 값이 중복될 수 없는 인덱스
--              (emp.empno,dept.deptno)
--NON-UNIQUE INDEX(default) : 인덱스 컬럼의 값이 중복될 수 있는 인덱스
--                            (emp.job)
ALTER TABLE emp DROP CONSTRAINT pk_emp;

-- CREATE UNIQUE INDEX idx_n_emp_01 ON emp (empno);

--위쪽 상황이랑 달라진 것은 EMPNO컬럼으로 생성된 인덱스가
--UNIQUE -> NON-UNIQUE 인덱스로 변경됨
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



--emp 테이블에 job 컬럼으로 non_unique 인덱스 생성
--인덱스명 : idx_n_emp_02
CREATE INDEX idx_n_emp_02 ON emp (job);

SELECT job, rowid
FROM emp
ORDER BY job;

-- emp 테이블에는 인덱스가 2개 존재
-- 1. empno
-- 2. job
SELECT *
FROM emp
WHERE job = 'MANAGER';

SELECT *
FROM emp
WHERE empno=7369;

--IDX_02 인덱스
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

--idx_n_emp_03
--emp 테이블의 job, ename 컬럼으로 non-unique 인덱스 생성
CREATE INDEX idx_n_emp_03 ON emp (job, ename);

--idx_n_emp_04
--ename, job 컬럼으로 emp 테이블에 non-unique 인덱스 생성
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

-- JOIN 쿼리에서의 인덱스
-- emp 테이블은 empno컬럼으로 PRIMARY KEY 제약조건이 존재
-- dept 테이블은 deptno 컬럼으로 PRIMARY KEY 제약조건이 존재
-- emp 테이블은 PRIMARY KEY 제약을 삭제한 상태이므로 재생성
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