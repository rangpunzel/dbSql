-- WITH
-- WITH ����̸� As (
-- ��������
--  )
-- SELECT *
-- FROM ����̸�

-- deptno, avg(sal) avg_sal
-- �ش� �μ��� �޿������ ��ü ������ �޿� ��պ��� ���� �μ��� ���� ��ȸ
SELECT deptno, avg(sal) avg_sal
FROM emp
GROUP BY deptno
HAVING avg(sal) > (SELECT AVG(sal) FROM emp);

--WITH ���� ����Ͽ� ���� ������ �ۼ�
WITH dept_sal_avg AS (
    SELECT deptno, avg(sal) avg_sal
    FROM emp
    GROUP BY deptno),
    emp_sal_avg AS 
    (SELECT AVG(sal) avg_sal FROM emp)
SELECT *
FROM dept_sal_avg
WHERE avg_sal > (SELECT avg_sal FROM emp_sal_avg);

WITH test AS(
    SELECT 1, 'TEST' FROM DUAL UNION ALL
    SELECT 2, 'TEST2' FROM DUAL UNION ALL
    SELECT 3, 'TEST3' FROM DUAL)
SELECT *
FROM test;


-- ���� ����
-- �޷¸����
-- CONNECT BY LEVEL <= N
-- ���̺��� ROW �Ǽ��� N ��ŭ �ݺ��Ѵ�
-- CONNECT BY LEVEL ���� ����� ����������
-- SELECT ������ LEVEL�̶�� Ư�� �÷��� ����� �� �ִ�.
-- ������ ǥ���ϴ� Ư�� �÷����� 1���� �����ϸ� ROWNUM�� �����ϳ�
-- ���� ���� �� START WITH, CONNECT BY ������ �ٸ� ���� ���� �ȴ�.

-- 2019�� 11���� 30�ϱ��� ����
-- 201911
-- ���� + ���� = ������ŭ �̷��� ����
-- 1-��, 2-�� .... 7-��


(SELECT iw,
       MAX(DECODE(d, 1, dt)) s,MAX(DECODE(d, 2, dt)) m,MAX(DECODE(d, 3, dt)) t,
       MAX(DECODE(d, 4, dt)) w,MAX(DECODE(d, 5, dt)) t1,MAX(DECODE(d, 6, dt)) f,
       MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT TO_DATE(:yyyymm,'YYYYMM') + (LEVEL -1) dt, 
            TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') + (LEVEL -1), 'D')d,
            TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') + (LEVEL), 'IW')IW
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD'))
GROUP BY iw
)ORDER BY sat;


SELECT 
       MAX(DECODE(d, 1, dt)) s,MAX(DECODE(d, 2, dt)) m,MAX(DECODE(d, 3, dt)) t,
       MAX(DECODE(d, 4, dt)) w,MAX(DECODE(d, 5, dt)) t1,MAX(DECODE(d, 6, dt)) f,
       MAX(DECODE(d, 7, dt)) sat
FROM
    (SELECT TO_DATE(:yyyymm,'YYYYMM') + (LEVEL -1) dt, 
            TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') + (LEVEL -1), 'D')d,
            TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') + (LEVEL), 'IW')IW
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD'))
GROUP BY dt - (d-1)
ORDER BY dt - (d-1)
;


SELECT IW, MIN(DECODE(d, 1, dt)) SUN, MIN(DECODE(d, 2, dt)) MON, 
       MIN(DECODE(d, 3, dt)) TUE, MIN(DECODE(d, 4, dt)) WED, 
       MIN(DECODE(d, 5, dt)) THU, MIN(DECODE(d, 6, dt)) FRI, 
       MIN(DECODE(d, 7, dt)) SAT 
FROM   (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + ( LEVEL - 1 ) dt, 
               TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + ( LEVEL - 1 ), 'd') d,
               --TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + ( LEVEL ), 'IW') IW,
               CASE WHEN TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + ( LEVEL ), 'IW') = 1 AND
                         TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + ( LEVEL - 1 ), 'MM') = '12'
                         THEN TO_CHAR(TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + ( LEVEL ), 'IW') + 55)
                    ELSE TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + ( LEVEL ), 'IW')
               END IW
        FROM   dual 
        CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')) 
GROUP  BY IW 
ORDER  BY IW; 


--����
(SELECT iw,
       MAX(DECODE(d, 1, dt)) s,MAX(DECODE(d, 2, dt)) m,MAX(DECODE(d, 3, dt)) t,
       MAX(DECODE(d, 4, dt)) w,MAX(DECODE(d, 5, dt)) t1,MAX(DECODE(d, 6, dt)) f,
       MAX(DECODE(d, 7, dt)) sat
FROM
(SELECT TO_DATE(:yyyymm,'YYYYMM')-(SELECT TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') , 'D')-1 d 
                                   FROM dual) + (LEVEL -1) dt, 
       TO_CHAR(TO_DATE(:yyyymm,'YYYYMM')-(SELECT TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') , 'D')-1 d 
                                          FROM dual) + (LEVEL -1), 'D')d,
       TO_CHAR(TO_DATE(:yyyymm,'YYYYMM')-(SELECT TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') , 'D')-1 d 
                                          FROM dual) + (LEVEL), 'IW')IW
    FROM dual
    CONNECT BY LEVEL <= 35)
GROUP BY iw
)ORDER BY sat;


(SELECT TO_CHAR(TO_DATE(:yyyymm,'YYYYMM') , 'D')-1 d
    FROM dual);



--���̺� ����� ����
create table sales as 
select to_date('2019-01-03', 'yyyy-MM-dd') dt, 500 sales from dual union all
select to_date('2019-01-15', 'yyyy-MM-dd') dt, 700 sales from dual union all
select to_date('2019-02-17', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-02-28', 'yyyy-MM-dd') dt, 1000 sales from dual union all
select to_date('2019-04-05', 'yyyy-MM-dd') dt, 300 sales from dual union all
select to_date('2019-04-20', 'yyyy-MM-dd') dt, 900 sales from dual union all
select to_date('2019-05-11', 'yyyy-MM-dd') dt, 150 sales from dual union all
select to_date('2019-05-30', 'yyyy-MM-dd') dt, 100 sales from dual union all
select to_date('2019-06-22', 'yyyy-MM-dd') dt, 1400 sales from dual union all
select to_date('2019-06-27', 'yyyy-MM-dd') dt, 1300 sales from dual;


SELECT MAX(DECODE(mm,1,s)) JAN, MAX(DECODE(mm,2,s)) FEB, NVL(MAX(DECODE(mm,3,s)),0) mar,
       MAX(DECODE(mm,4,s)) apr, MAX(DECODE(mm,5,s)) jun, MAX(DECODE(mm,6,s)) jul
FROM
    (SELECT mm, sum(sales) s
     FROM
        (SELECT TO_CHAR(dt,'mm') MM ,DT, SALES
         FROM sales)
     GROUP BY mm);


SELECT NVL(MIN(DECODE(mm,1,sales_sum)),0) JAN,  NVL(MIN(DECODE(mm,2,sales_sum)),0) FEB, 
       NVL(MIN(DECODE(mm,3,sales_sum)),0) mar,  NVL(MIN(DECODE(mm,4,sales_sum)),0) apr, 
       NVL(MIN(DECODE(mm,5,sales_sum)),0) jun,  NVL(MIN(DECODE(mm,6,sales_sum)),0) jul
FROM
    (SELECT TO_CHAR(dt,'mm') MM , sum(SALES) sales_sum
     FROM sales
     GROUP BY TO_CHAR(dt,'mm') );
     

--���̺� ����
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);
insert into dept_h values ('dept0', 'XXȸ��', '');
insert into dept_h values ('dept0_00', '�����κ�', 'dept0');
insert into dept_h values ('dept0_01', '������ȹ��', 'dept0');
insert into dept_h values ('dept0_02', '�����ý��ۺ�', 'dept0');
insert into dept_h values ('dept0_00_0', '��������', 'dept0_00');
insert into dept_h values ('dept0_01_0', '��ȹ��', 'dept0_01');
insert into dept_h values ('dept0_02_0', '����1��', 'dept0_02');
insert into dept_h values ('dept0_02_1', '����2��', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '��ȹ��Ʈ', 'dept0_01_0');
commit;

SELECT dept_h.*, LEVEL 
FROM dept_h
START WITH  deptcd = 'dept0' --�������� deptcd = 'dept0' --> xxȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd
;

/*
  dept0(xxȸ��)
    dept0_00(�����κ�)
        dept0_00_0(��������)
    dept0_01(������ȹ��)
        dept0_01_0(��ȹ��)
            dept0_01_0_0(��ȹ��Ʈ)
    dept0_02(�����ý��ۺ�)
        dept0_02_0(����1��)
        dept0_02_1(����2��)
*/


