--Ư�� ���̺��� �÷� ��ȸ
--1.DESC ���̺��
--2. SELECT * FROM user_tab_columns;

--prod ���̺��� �÷���ȸ
DESC prod;

VARCHAR2, CHAR -->���ڿ� (Character)
NUMBER --> ����
CLOB --> Character Larhe OBject, ���ڿ� Ÿ���� ���� ������ ���ϴ� Ÿ��
       -- �ִ� ������ : VARCHAR2(4000), CLOB : 4GB
DATE --> ��¥(�Ͻ� = ��,��,�� + �ð�,��,��)

--date Ÿ�Կ� ���� ������ �����?
'2019/11/20 09:16:20' + 1 = ?

--USERS ���̺��� ��� �÷��� ��ȸ �غ�����.

SELECT *
FROM users;

--userid, usernm, reg_dr ������ �÷��� ��ȸ
SELECT userid, usernm, reg_dt
FROM users;

--������ ���� ���ο� �÷��� ���� (reg_dr�� ���� ������ �� ���ο� ���� �÷�)
--��¥ + ���� ���� ==> ���ڸ� ���� ��¥Ÿ���� ����� ���´�.
--��Ī : ���� �÷����̳� ������ ���� ������ ���� �÷��� ������ �÷��̸��� �ο�
--       col | express [AS] ��Ī��
SELECT userid, usernm, reg_dt reg_date, reg_dt+5 AS after5day
FROM users;

-- ���� ���, ���ڿ� ��� ( oracle '', java : '', "" )
-- table�� ���� ���� ���Ƿ� �÷����� ����
-- ���ڿ� ���� ���� ( +, -, /, *)
-- ���ڿ� ���� ���� ( +�� �������� ����, ==> || )
SELECT (10-2)*2, 'DB SQL ����', 
        /* userid + '_modified', ���ڿ� ������ ���ϱ� ������ ����*/
        usernm || '_modified', reg_dt
FROM users;


--NULL : ���� �𸣴� ��
--NULL�� ���� ���� ����� �׻� NULL �̴�
--DESC ���̺�� : NOT NULL�� �����Ǿ� �ִ� �÷����� ���� �ݵ�� �����Ѵ�

--users ���ʿ��� ������ ����
SELECT *
FROM users;

DELETE users
WHERE userid NOT IN ('brown', 'sally', 'cony', 'moon', 'james');

rollback;

--commit�� �ϸ� rollback�� ����Ҽ� ����. Ȯ��
commit;

SELECT userid, usernm, reg_dt
FROM users;

--null ������ �����غ��� ���� moon�� reg_dt �÷��� null�� ����
UPDATE users SET reg_dt = NULL
WHERE userid = 'moon';

ROLLBACK;
COMMIT;

--users ���̺��� reg_dt �÷����� 5���� ���� ���ο� �÷��� ����
--NULL���� ���� ������ ����� NULL�̴�
SELECT userid, usernm, reg_dt, reg_dt + 5
FROM users;


--prod���̺��� prod_id, prod_name �� �÷��� ��ȸ�ϴ� ���� �ۼ�
--�� prod_id -> id, prod_name -> name ���� �÷� ��Ī�� ����

SELECT prod_id id, prod_name name
FROM prod;

--lprod���̺��� lprod_gu, lprod_nm �� �÷��� ��ȸ�ϴ� ������ �ۼ�
--�� lprod_gu -> gu, lprod_nm -> nm���� �÷� ��Ī ����

SELECT lprod_gu gu, lprod_nm nm
FROM lprod;

--buyer ���̺��� buyer_id, buyer_name �� �÷��� ��ȸ�ϴ� ������ �ۼ�
--buyer_id ->���̾���̵�, buyer_name->�̸����� �÷� ��Ī�� ����

SELECT buyer_id AS ���̾���̵�, buyer_name AS �̸�
FROM buyer;

--���ڿ� �÷��� ����     (�÷� || �÷�, '���ڿ����' || �÷�)
--                     ( CONCAT(�÷�, �÷�) )
SELECT userid, usernm,
       userid || usernm AS id_nm,
       CONCAT(userid, usernm) con_id_nm,
       -- ||�� �̿��ؼ� userid, usernm, pass
       userid || usernm || pass id_nm_pass,
       --CANCAT�� �̿��ؼ� userid, usernm, pass
       CONCAT(CONCAT(userid, usernm), pass) con_id_nm_pass
FROM users;


--����ڰ� ������ ���̺� �����ȸ
--LPROD --> SELECT * FROM LPROD;
SELECT 'SELECT * FROM ' || table_name || ';' QUERY,
        --CONCAT�Լ��� �̿��ؼ�
        --1.'SELECT * FROM '
        --2. tabla_name
        --3. ';'
        CONCAT(CONCAT('SELECT * FROM ', table_name), ';') CON_QUERY
FROM user_tables;


SELECT * FROM MEMBER;


--WHERE : ������ ��ġ�ϴ� �ุ ��ȸ�ϱ� ���� ���
--        �࿡ ���� ��ȸ ������ �ۼ�
--WHERE���� ������ �ش� ���̺��� ��� �࿡ ���� ��ȸ
SELECT userid, usernm, alias, reg_dt
FROM users;

SELECT userid, usernm, alias, reg_dt
FROM users
WHERE userid = 'brown'; -- userid �÷��� 'brown'�� ��(row)�� ��ȸ

--emp���̺��� ��ü ������ ��ȸ (��� ��(row), ��(column))

SELECT *
FROM emp;

--�μ���ȣ(deptno)�� 20���� ũ�ų� ���� �μ����� ���ϴ� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno >= 20;

--�����ȣ(empno)�� 7700���� ũ�ų� ���� ����� ������ ��ȸ
SELECT *
FROM emp
WHERE empno >= 7700;

--����Ի�����(hiredate)�� 1982�� 1�� 1�� ������ ��� ���� ��ȸ
--���ڿ�--> ��¥ Ÿ������ ���� TO_DATE('��¥���ڿ�', '��¥���ڿ�����')
--�ѱ� ��¥ ǥ�� : ��-��-��
--�̱� ��¥ ǥ�� : ��-��-�� (01-01-2020)
SELECT empno, ename, hiredate,
       2000 no, '���ڿ����' str, TO_DATE('19810101', 'yyyymmdd')
FROM emp
WHERE hiredate >= TO_DATE('19820101', 'YYYYMMDD');


--���� ��ȸ (BETWEEN ���۱��� AND �������)
--���۱���, ��������� ����
--����߿��� �޿�(sal)�� 1000���� ũ�ų� ����, 2000���� �۰ų� ���� ��� ������ȸ
SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

--BETWEEN AND �����ڴ� �ε�ȣ �����ڷ� ��ü ����
SELECT *
FROM emp
WHERE sal >= 1000
AND sal <= 2000;

--emp ���̺��� �Ի� ���ڰ� 1982�� 1�� 1�� ���ĺ��� 1983�� 1�� 1�� ������ ����� 
--ename, hiredate �����͸� ��ȸ�ϴ� ���� �ۼ�
--�� �����ڴ� between�� ���
SELECT ename, hiredate
FROM emp
WHERE hiredate BETWEEN TO_DATE('19820101','YYYYMMDD') AND 
                       TO_DATE('19830101','YYYYMMDD');
                       
-- �񱳿����� ���
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD')
AND hiredate <= TO_DATE('19830101','YYYYMMDD');
