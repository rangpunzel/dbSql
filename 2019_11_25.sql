--row_1 : emp���̺��� ���ľ��� ��ȸ�ϰ�, ROWNUM 1~10�� �ุ ��ȸ
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

--row_2 : emp���̺��� ���ľ��� ��ȸ�ϰ�, ROWNUM 11~14�� �ุ ��ȸ
SELECT ROWNUM, a.*
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp)a
WHERE rn BETWEEN 11 AND 14;


--row_3
SELECT *
FROM   (SELECT ROWNUM rn, a.*
        FROM(SELECT empno, ename
             FROM emp
             ORDER BY ename)a)
WHERE rn BETWEEN 11 AND 14;



--DUAL ���̺� : sys ������ �ִ� ������ ��밡���� ���̺��̸� 
--�����ʹ� ���ุ �����ϸ� �÷�(dummy)�� �ϳ� ����

SELECT *
FROM dual;

-- SINGLE ROW FUNCTION : ��� �ѹ��� FUNCTION�� ����
-- 1���� �� INPUT -> 1���� ������ OUTPUT (COLUMN)
--'Hello, World'
--dual ü�̺��� �����Ͱ� �ϳ��� �ุ �����Ѵ�. ���,�� �ϳ��� ������ ���´�
SELECT LOWER('Hello, World') low, UPPER('Hello, World') upper, 
       INITCAP('Hello, World')
FROM dual;

--emp���̺��� �� 14���� ������(����)�� ���� (14���� ��)
--�Ʒ������� ����� 14���� ��
SELECT emp.*, LOWER('Hello, World') low, UPPER('Hello, World') upper, 
       INITCAP('Hello, World')
FROM emp;

--�÷��� function ����
SELECT empno, LOWER(ename) low_enm
FROM emp
WHERE ename = UPPER('smith'); --���� �̸��� smith�� ����� ��ȸ �Ϸ��� �빮�ڻ��


--���̺� �÷��� �����ص� ������ ����� ���� �� ������
--���̺� �÷� ���ٴ� ������� �����ϴ� ���� �ӵ��鿡�� ����
--�ش� �÷��� �ε����� �����ϴ��� �Լ��� �����ϰ� �Ǹ� ���� �޶����� �Ǿ�
--�ε����� Ȱ�� �� �� ���� �ȴ�
--���� : FBI (Function Based Index)
SELECT empno, LOWER(ename) low_enm
FROM emp
WHERE LOWER(ename) = 'smith'; --���� �̸��� smith�� ����� ��ȸ �Ϸ��� �빮�ڻ��

--HELLO
--,
--WORLD
--HELLO, WORLD (�� 3���� ���ڿ� ����� �̿�, CONCAT �Լ��� ����Ͽ� ���ڿ� ����)

SELECT CONCAT(CONCAT('HELLO', ', '), 'WORLD') c1,
     'HELLO' || ', ' || 'WORLD' c2,
     
     --�����ε����� 1����, �����ε��� ���ڿ����� �����Ѵ�
     SUBSTR('HELLO, WORLD', 1, 5) s1, --SUBSTR(���ڿ�, �����ε���, �����ε���)
     
     --INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ���, ������ ��� ������ �ε����� ����
     INSTR('HELLO, WORLD', 'O') i1,  -- 5, 9
     --'HELLO, WORLD' ���ڿ��� 6��° �ε��� ���Ŀ� �����ϴ� 'O'���ڿ��� �ε��� ����
     INSTR('HELLO, WORLD', 'O', 6) i2,  -- ���ڿ��� Ư�� �ε��� ���ĺ��� �˻� �ϵ��� �ɼ� ��
     
    INSTR('HELLO, WORLD', 'O', INSTR('HELLO, WORLD', 'O')+1) i3 ,
          
     --L/RPAD Ư�� ���ڿ��� ����/�����ʿ� ������ ���ڿ� ���̺��� ������ ��ŭ ���ڿ���
     --ä�� �ִ´�
     LPAD('HELLO, WORLD', 15, '*')L1,
     LPAD('HELLO, WORLD', 15)L2,  --DEFAULT ä�� ���ڴ� �����̴�
     RPAD('HELLO, WORLD', 15, '*')R1,
     
     --REPLACE(����ڿ�, �˻� ���ڿ�, ������ ���ڿ�)
     --����ڿ����� �˻� ���ڿ��� ������ ���ڿ��� ġȯ
     
     REPLACE('HELLO, WORLD', 'HELLO', 'hello')rep1,  --hello, WORLD
      
      --���ڿ� ��, ���� ������ ����
      '   HELLO, WORLD   ' before_trim,
      TRIM('   HELLO, WORLD   ') after_trim,
      TRIM('H' FROM 'HELLO, WORLD') after_trim2

FROM dual;


--���� �����Լ�
--ROUND : �ݿø� - ROUND(����, �ݿø� �ڸ�)
--TRUNC : ���� TRUNC(����, ���� �ڸ�)
--MOD : ������ ���� MOD(������, ����) //MOD(5, 2) : 1

SELECT --�ݿø������ �Ҽ��� ���ڸ����� ��������(�Ҽ��� ��°�ڸ����� �ݿø�)
        ROUND(105.54, 1) r1,
        ROUND(105.55, 1) r2,
        ROUND(105.55, 0) r3,  --�Ҽ��� ù��° �ڸ����� �ݿø�
        ROUND(105.55, -1) r4  --���� ù��° �ڸ����� �ݿø�
FROM dual;

SELECT --���� ����� �Ҽ��� ���ڸ����� ��������(�Ҽ��� ��°�ڸ����� ����)
        TRUNC(105.54, 1) t1,
        TRUNC(105.55, 1) t2,
        TRUNC(105.55, 0) t3,  --�Ҽ��� ù��° �ڸ����� ����
        TRUNC(105.55, -1) t4  --���� ù��° �ڸ����� ����
FROM dual;


--MOD(������, ����) �������� ������ ���� ������ ��
--MOD(M, 2) �� ��� ���� : 0, 1(0~����=1)
SELECT MOD(5, 2) M1 -- 5/2 = 2.5 : ���� 2, [�������� 1]
FROM dual;


--emp ���̺��� sal �÷��� 1000���� �������� ����� ������ ���� ��ȸ �ϴ� sql �ۼ�
--ename, sal, sal/1000�� ���� ��, sal/1000�� ���� ������

SELECT ename, sal, TRUNC(sal/1000), MOD(sal, 1000),
      TRUNC(sal/1000) * 1000 + MOD(sal, 1000)  sal2
FROM emp;

--DATE : �����, �ð�, ��, ��
SELECT ename, hiredate, TO_CHAR(hiredate, 'YYYY_MM_DD hh24-mi-ss') --YYYY/MM/DD
FROM emp;

--SYSDATE : ������ ���� DATE�� �����ϴ� �����Լ�, Ư���� ���ڰ� ����
--DATE ���� DATE + ����N = N���� ��ŭ ���Ѵ�
--DATE ���꿡 �־ ������ ����
-- �Ϸ�� 24�ð�
--DATE Ÿ�Կ� �ð��� ���� �� �� �ִ� 1�ð� = 1/24
SELECT TO_CHAR(SYSDATE + 5, 'YYYY-MM-DD hh24:mi:ss') AFTER5_DAYS,
       TO_CHAR(SYSDATE + 5/24, 'YYYY-MM-DD hh24:mi:ss') AFTER5_HOURS,
       TO_CHAR(SYSDATE + 5/24/60, 'YYYY-MM-DD hh24:mi:ss') AFTER5_MIN
FROM dual;


--fn1
SELECT TO_CHAR(TO_DATE('20191231'), 'yy/mm/dd') LASTDAY,
        TO_CHAR(TO_DATE('20191231')-5,'yy/mm/dd') LASTDAY_BEFORE5,
        TO_CHAR(TO_DATE(SYSDATE),'yy/mm/dd') NOW,
        TO_CHAR(TO_DATE(SYSDATE - 3 ),'yy/mm/dd') NOW_BEFORE3
FROM dual;

--fn1 ������ ��
SELECT TO_DATE('20191231', 'YYYYMMDD') LASTDAY,
      TO_DATE('20191231', 'YYYYMMDD') -5 LAST_DAY_BEFORES,
      SYSDATE NOW,
      SYSDATE -3 NOW_BEFORE3      
FROM dual;


--YYYY, MM, DD, D(������ ���ڷ�:�Ͽ��� 1, ������ 2, ȭ���� 3, ..... ����� 7)
--IW(���� 1~53), HH, MI, SS
SELECT TO_CHAR(SYSDATE, 'YYYY') YYYY --���� �⵵
      ,TO_CHAR(SYSDATE, 'MM') MM --�����
      ,TO_CHAR(SYSDATE, 'DD') DD --������
      ,TO_CHAR(SYSDATE, 'D') D --���� ����(�ְ����� 1~7)
      ,TO_CHAR(SYSDATE, 'IW') IW -- ���� ������ ����
      
      --2019�� 12�� 31���� �������� �����°�?
      ,TO_CHAR(TO_DATE('20191231','YYYYMMDD'), 'IW') IW_20191231 -- ���� ������ ����(�ش����� ������� ������ ��������)
      
FROM dual;


--fn2
--���� ��¥�� ��-��-��
--���� ��¥�� ��-��-�� �ð�(24)-��-��
--���� ��¥�� ��-��-��

SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') DT_DASH
      ,TO_CHAR(SYSDATE,'YYYY-MM-DD HH24-MI-SS') DT_DASH_WITH_TIME
      ,TO_CHAR(SYSDATE,'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;


--DATE Ÿ���� ROUND, TRUNC ����
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now
     --MM���� �ݿø� (11�� -> 1��)
     , TO_CHAR(ROUND(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY
     --DD���� �ݿø� (25�� -> 1����)
     , TO_CHAR(ROUND(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_MM
          --�ð����� �ݿø�
     , TO_CHAR(ROUND(SYSDATE, 'dd'), 'YYYY-MM-DD hh24:mi:ss') now_DD
FROM dual;

SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD hh24:mi:ss') now
     --MM���� ���� (11�� -> 1��)
     , TO_CHAR(TRUNC(SYSDATE, 'YYYY'), 'YYYY-MM-DD hh24:mi:ss') now_YYYY
     --DD���� ���� (25�� -> 11)
     , TO_CHAR(TRUNC(SYSDATE, 'MM'), 'YYYY-MM-DD hh24:mi:ss') now_MM
          --�ð����� ����(����ð� -> 0��)
     , TO_CHAR(TRUNC(SYSDATE, 'dd'), 'YYYY-MM-DD hh24:mi:ss') now_DD
FROM dual;


--��¥ ���� �Լ�
--MONTHS_BETWEEN(date1, date2) : date2�� date1 ������ ���� ��
--ADD_MONTHS(date, ������ ������) : date���� Ư�� �������� ���ϰų� �� ��¥
--NEXT_DAY(date, weekday (1~7)) : date���� ù ��° weekday ��¥
--LAST_DAY(date) : date�� ���� ���� ������ ��¥


--MONTHS_BETWEEN

SELECT MONTHS_BETWEEN(TO_DATE('2019-11-25', 'YYYY-MM-DD'),
                      TO_DATE('2019-03-31', 'YYYY-MM-DD')) m_bet,
                      -- �� ��¥ ������ ���ڼ�
                      TO_DATE('2019-11-25', 'YYYY-MM-DD') - TO_DATE('2019-03-31', 'YYYY-MM-DD') d_m  
FROM dual;


--ADD_MONTHS (date, number(+,-) )
SELECT ADD_MONTHS(TO_DATE('20191125', 'YYYYMMDD'), 5) NOW_AFTER5M
      ,ADD_MONTHS(TO_DATE('20191125', 'YYYYMMDD'), -5) NOW_BEFORE5M
      , SYSDATE + 100 -- 100�� ���� ��¥ (�� ���� 3-21, 2-28/29)
FROM dual;


--NEXT_DAY(date, weekday number(1~7))
SELECT NEXT_DAY(SYSDATE, 7) --���� ��¥(2019/11/25)�� ���� �����ϴ� ù��° �����
FROM dual;