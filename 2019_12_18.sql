SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH  deptcd = 'dept0' --시작점은 deptcd = 'dept0' --> xx회사(최상위조직)
CONNECT BY PRIOR deptcd = p_deptcd;

--*********XX회사
--         XX회사
SELECT LPAD('XX회사', 15, '*'),
        LPAD('XX회사', 15)
FROM dual;
/*
  dept0(xx회사)
    dept0_00(디자인부)
        dept0_00_0(디자인팀)
    dept0_01(정보기획부)
        dept0_01_0(기획팀)
            dept0_01_0_0(기획파트)
    dept0_02(정보시스템부)
        dept0_02_0(개발1팀)
        dept0_02_1(개발2팀)
*/

--실습 h_2
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH  deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

-- 디자인팀(dept0_00_0)을 기준으로 상향식 계층쿼리 작성
-- 자기 부서의 부모 부서와 연결을 한다.
SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd AND PRIOR deptnm LIKE '디자인팀%';


--h_3
SELECT deptcd, LPAD(' ',(LEVEL-1)*4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd;

--h_4
--테이블 생성
create table h_sum as
select '0' s_id, null ps_id, null value from dual union all
select '01' s_id, '0' ps_id, null value from dual union all
select '012' s_id, '01' ps_id, null value from dual union all
select '0123' s_id, '012' ps_id, 10 value from dual union all
select '0124' s_id, '012' ps_id, 10 value from dual union all
select '015' s_id, '01' ps_id, null value from dual union all
select '0156' s_id, '015' ps_id, 20 value from dual union all

select '017' s_id, '01' ps_id, 50 value from dual union all
select '018' s_id, '01' ps_id, null value from dual union all
select '0189' s_id, '018' ps_id, 10 value from dual union all
select '11' s_id, '0' ps_id, 27 value from dual;


SELECT LPAD(' ',(LEVEL-1)*4) || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

SELECT *
FROM h_sum;


--h_5
--테이블 생성
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XX회사', null, 1);
insert into no_emp values('정보시스템부', 'XX회사', 2);
insert into no_emp values('개발1팀', '정보시스템부', 5);
insert into no_emp values('개발2팀', '정보시스템부', 10);
insert into no_emp values('정보기획부', 'XX회사', 3);
insert into no_emp values('기획팀', '정보기획부', 7);
insert into no_emp values('기획파트', '기획팀', 4);
insert into no_emp values('디자인부', 'XX회사', 1);
insert into no_emp values('디자인팀', '디자인부', 7);

commit;

SELECT LPAD(' ',(LEVEL-1)*4) || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;


-- pruning branch (가지치기)
-- 계층 쿼리의 실행순서
-- FROM -> START WITH ~ CONNECT BY --> WHERE
-- 조건을 CONNECT BY 절에 기술한 경우
-- . 조건에 따라 다음 ROW로 연결이 안되고 종료
-- 조건을 WHERE 절에 기술한 경우
-- . START WITH ~ CONNECT BY 절에 의해 계층형으로 결과에
--  WHERE 절에 기술한 결과 값에 해당하는 데이터만 조회

-- 최상위 노드에서 하향식으로 탐색
-- CONNECT BY 절에 deptnm != '정보기획부' 조건을 기술한 경우
SELECT *
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '정보기획부';

-- WHERE 절에 deptnm != '정보기획부' 조건을 기술한 경우
-- 계층쿼리를 실행하고 나서 최종 결과에 WHERE 절 조건을 적용
SELECT *
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- 계층 쿼리에서 사용 가능한 특수 함수
-- CONNECT_BY_ROOT(col) 가장 최상위 row의 col 정보 값 조회
-- SYS_CONNECT_BY_PATH(col,구분자) : 최상위 row에서 현재 로우까지 col값을
-- 구분자로 연결해준 문자열 (ex : xx회사-디자인부-디자인팀)
-- CONNECT_BY_ISLEAF : 해당 ROW가 마지막 노드인지(leaf Node)
-- leaf node : 1, node : 0
SELECT deptcd, LPAD(' ' ,4*(LEVEL-1)) || deptnm,
    CONNECT_BY_ROOT(deptnm) c_root,
    LTRIM(SYS_CONNECT_BY_PATH(deptnm,'-'),'-') sys_path,
    CONNECT_BY_ISLEAF isleaf
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--실습 h6
--테이블 생성
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, '첫번째 글입니다');
insert into board_test values (2, null, '두번째 글입니다');
insert into board_test values (3, 2, '세번째 글은 두번째 글의 답글입니다');
insert into board_test values (4, null, '네번째 글입니다');
insert into board_test values (5, 4, '다섯번째 글은 네번째 글의 답글입니다');
insert into board_test values (6, 5, '여섯번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (7, 6, '일곱번째 글은 여섯번째 글의 답글입니다');
insert into board_test values (8, 5, '여덜번째 글은 다섯번째 글의 답글입니다');
insert into board_test values (9, 1, '아홉번째 글은 첫번째 글의 답글입니다');
insert into board_test values (10, 4, '열번째 글은 네번째 글의 답글입니다');
insert into board_test values (11, 10, '열한번째 글은 열번째 글의 답글입니다');
commit;

SELECT *
FROM board_test;

SELECT seq, LPAD(' ',(LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

--h7
SELECT seq, LPAD(' ',(LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq DESC;

--h8
--SIBLINGS은 계층에서만 사용 가능
SELECT seq, LPAD(' ',(LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

--h9 정렬 과제
SELECT seq, LPAD(' ',(LEVEL-1)*4) || title title, LEVEL
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;


