--hash join 
SELECT *
FROM dept, emp
WHERE dept.detpno = emp.deptno;

--dept 먼저 읽는 형태
--join컬럼을 hash 함수로 돌려서 해당 해쉬 함수에 해당하는 bucket에 데이터를 넣는다
-- 10 --> ccc1122 (hashwalue)

--emp 테이블에 대해 위의 진행을 동일하게 진행
--10 --> ccc1122 (hashvalue)


-- 사원번호, 사원이름, 부서번호, 급여, 부서원의 전체 급여합
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal 
       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum, -- 가장 처음부터 현재행까지
       SUM(sal) OVER (ORDER BY sal
       ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) c_sum2
FROM emp
ORDER BY sal;

--ana7
SELECT empno, ename, deptno, sal,
        sum(sal) OVER(PARTITION BY deptno ORDER BY sal, empno) c_sum
FROM emp;

-- ROWS vs RANGE 차이 확인하기
SELECT empno, ename, deptno, sal,
       SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) rows_sum,
       SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_sum,
       SUM(sal) OVER (ORDER BY sal) c_sum 
       --ORDER BY절 뒤에 WINDOWING을 적용하지 않았을떄 RANGE UNBOUNDED PRECEDING를 기본값으로 사용
FROM emp;

-- PL/SQL
-- PL/SQL 기본구조
-- DECLARE : 선언부, 변수를 선언하는 부분
-- BEGIN : PL/SQL의 로직이 들어가는 부분
-- EXCEQPTION : 예외처리부

--DBMS_OUTPUT.PUT_LINE 함수가 출력하는 결과를 화면에 보여주도록 활성화
SET SERVEROUTPUT ON; 
DECLARE --선언부
    -- java : 타입 변수명; 
    -- pl/sql : 변수명 타입;
    /*v_dname VARCHAR2(14);
    v_loc VARCHAR2(13);*/
    --테이블 컬럼의 정의를 참조하여 데이터 타입을 선언한다
    v_dname dept.dname %TYPE;
    v_loc dept.loc %TYPE;
BEGIN
    -- DEPT 테이블에서 10번 부서의 부서 이름, LOC 정보를 조회
    SELECT dname, loc
    INTO v_dname, v_loc
    FROM dept
    WHERE deptno = 10;
    --String a = "t";
    --Stringt b = "c";
    --Sysout.out.println(a + b);
    DBMS_OUTPUT.PUT_LINE(v_dname || v_loc);
END;
/ 
-- PL/SQL 블록을 실행


-- 10번 부서의 부서이름, 위치지역을 조회해서 변수에 담고
-- 변수를 DBMS_OUTPUT.PUT_LINE함수를 이용하여 consol에 출력
CREATE OR REPLACE PROCEDURE printdept 
--파라미터명 IN/OUT 타입
-- p_파라미터이름
(p_deptno IN dept.deptno%TYPE)
IS
--선언부(옵션)
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
--실행부
BEGIN
    SELECT dname, loc
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    DBMS_OUTPUT.PUT_LINE(dname || ' ' || loc);
--예외처리부(옵션)
END;
/

exec printdept(50);


CREATE OR REPLACE PROCEDURE printemp 
    (p_empno IN emp.empno%TYPE)
IS
    ename emp.ename%TYPE;
    dname dept.dname%TYPE;

BEGIN
    SELECT ename, dname
    INTO ename, dname
    FROM emp, dept
    WHERE emp.deptno = dept.deptno
    AND empno = p_empno;
    
    DBMS_OUTPUT.PUT_LINE(ename || ' ' || dname);
END;
/

exec printemp(7782);

SELECT *
FROM dept_test;



--pro_2
CREATE OR REPLACE PROCEDURE registdept_test 
    (p_deptno IN dept.deptno%TYPE,
    p_dname IN dept.dname%TYPE,
    p_loc IN dept.loc%TYPE)
IS 


BEGIN

    INSERT INTO dept_test VALUES (p_deptno, p_dname, p_loc);

END;
/

exec registdept_test(99,'ddit','daejeon');

SELECT *
FROM dept_test;

rollback;

commit;