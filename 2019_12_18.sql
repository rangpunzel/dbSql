SELECT dept_h.*, LEVEL, LPAD(' ', (LEVEL-1)*3) || deptnm
FROM dept_h
START WITH  deptcd = 'dept0' --�������� deptcd = 'dept0' --> xxȸ��(�ֻ�������)
CONNECT BY PRIOR deptcd = p_deptcd;

--*********XXȸ��
--         XXȸ��
SELECT LPAD('XXȸ��', 15, '*'),
        LPAD('XXȸ��', 15)
FROM dual;
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

--�ǽ� h_2
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH  deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

-- ��������(dept0_00_0)�� �������� ����� �������� �ۼ�
-- �ڱ� �μ��� �θ� �μ��� ������ �Ѵ�.
SELECT dept_h.*, LEVEL
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd AND PRIOR deptnm LIKE '��������%';


--h_3
SELECT deptcd, LPAD(' ',(LEVEL-1)*4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd;

--h_4
--���̺� ����
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
--���̺� ����
create table no_emp(
    org_cd varchar2(100),
    parent_org_cd varchar2(100),
    no_emp number
);
insert into no_emp values('XXȸ��', null, 1);
insert into no_emp values('�����ý��ۺ�', 'XXȸ��', 2);
insert into no_emp values('����1��', '�����ý��ۺ�', 5);
insert into no_emp values('����2��', '�����ý��ۺ�', 10);
insert into no_emp values('������ȹ��', 'XXȸ��', 3);
insert into no_emp values('��ȹ��', '������ȹ��', 7);
insert into no_emp values('��ȹ��Ʈ', '��ȹ��', 4);
insert into no_emp values('�����κ�', 'XXȸ��', 1);
insert into no_emp values('��������', '�����κ�', 7);

commit;

SELECT LPAD(' ',(LEVEL-1)*4) || org_cd org_cd, no_emp
FROM no_emp
START WITH org_cd = 'XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;


-- pruning branch (����ġ��)
-- ���� ������ �������
-- FROM -> START WITH ~ CONNECT BY --> WHERE
-- ������ CONNECT BY ���� ����� ���
-- . ���ǿ� ���� ���� ROW�� ������ �ȵǰ� ����
-- ������ WHERE ���� ����� ���
-- . START WITH ~ CONNECT BY ���� ���� ���������� �����
--  WHERE ���� ����� ��� ���� �ش��ϴ� �����͸� ��ȸ

-- �ֻ��� ��忡�� ��������� Ž��
-- CONNECT BY ���� deptnm != '������ȹ��' ������ ����� ���
SELECT *
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '������ȹ��';

-- WHERE ���� deptnm != '������ȹ��' ������ ����� ���
-- ���������� �����ϰ� ���� ���� ����� WHERE �� ������ ����
SELECT *
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

-- ���� �������� ��� ������ Ư�� �Լ�
-- CONNECT_BY_ROOT(col) ���� �ֻ��� row�� col ���� �� ��ȸ
-- SYS_CONNECT_BY_PATH(col,������) : �ֻ��� row���� ���� �ο���� col����
-- �����ڷ� �������� ���ڿ� (ex : xxȸ��-�����κ�-��������)
-- CONNECT_BY_ISLEAF : �ش� ROW�� ������ �������(leaf Node)
-- leaf node : 1, node : 0
SELECT deptcd, LPAD(' ' ,4*(LEVEL-1)) || deptnm,
    CONNECT_BY_ROOT(deptnm) c_root,
    LTRIM(SYS_CONNECT_BY_PATH(deptnm,'-'),'-') sys_path,
    CONNECT_BY_ISLEAF isleaf
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--�ǽ� h6
--���̺� ����
create table board_test (
 seq number,
 parent_seq number,
 title varchar2(100) );
 
insert into board_test values (1, null, 'ù��° ���Դϴ�');
insert into board_test values (2, null, '�ι�° ���Դϴ�');
insert into board_test values (3, 2, '����° ���� �ι�° ���� ����Դϴ�');
insert into board_test values (4, null, '�׹�° ���Դϴ�');
insert into board_test values (5, 4, '�ټ���° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (6, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (7, 6, '�ϰ���° ���� ������° ���� ����Դϴ�');
insert into board_test values (8, 5, '������° ���� �ټ���° ���� ����Դϴ�');
insert into board_test values (9, 1, '��ȩ��° ���� ù��° ���� ����Դϴ�');
insert into board_test values (10, 4, '����° ���� �׹�° ���� ����Դϴ�');
insert into board_test values (11, 10, '���ѹ�° ���� ����° ���� ����Դϴ�');
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
--SIBLINGS�� ���������� ��� ����
SELECT seq, LPAD(' ',(LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;

--h9 ���� ����
SELECT seq, LPAD(' ',(LEVEL-1)*4) || title title, LEVEL
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq DESC;


