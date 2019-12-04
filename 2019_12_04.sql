--1.tax ���̺��� �̿� �õ�/�ñ����� �δ� �������� �Ű�� ���ϱ�
--2. �Ű���� ���� ������ ��ŷ �ο��ϱ�
--��ŷ �õ� �ñ��� �δ翬������Ű��-�Ҽ��� ��°�ڸ����� �ݿø�
--1 ����Ư���� ���ʱ� 70
--2 ����Ư���� ������ 68

SELECT ��ŷ, a1.sido �õ�, a1.sigungu �ñ���, a1.���ù�������, a2.�õ�, a2.�ñ���, a2.�δ翬������Ű��  
FROM
    (SELECT ROWNUM ��ŷ, ss.*
    FROM
    (SELECT sido �õ�, sigungu �ñ���, round(sal/people,1) �δ翬������Ű��
    FROM tax
    ORDER BY �δ翬������Ű�� DESC)ss) a2,

    (SELECT ROWNUM rn, sido, sigungu, ���ù�������
    FROM
    (SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt,1) as ���ù�������
    FROM
        (SELECT sido, sigungu, COUNT(*) cnt --����ŷ, KFC, �Ƶ����� �Ǽ�
        FROM fastfood
        WHERE gb IN ('KFC', '����ŷ', '�Ƶ�����')
        GROUP BY sido, sigungu) a,
        (SELECT sido, sigungu, COUNT(*) cnt --�Ե�����
        FROM fastfood
        WHERE gb = '�Ե�����'
        GROUP BY sido, sigungu) b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY ���ù������� DESC))a1
WHERE a1.rn(+) = a2.��ŷ
ORDER BY a2.��ŷ;



-- ���ù������� �õ�, �ñ����� �������� ���Աݾ��� �õ�, �ñ�����
-- ���� �������� ����
-- ���ļ����� tax ���̺��� id �÷������� ����
-- 1 ����Ư���� ������ 5.6 ����Ư���� ������ 70.3
SELECT *
fROM tax;


SELECT a1.id, a2.sido, a2.sigungu, a2.���ù�������, a1.sido, a1.sigungu, a1.�δ翬������Ű��
FROM
    (SELECT id, sido, sigungu, round(sal/people,1) �δ翬������Ű��
    FROM tax
    ORDER BY id) a1,
    
    (SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt,1) as ���ù�������
      FROM
        (SELECT sido, sigungu, COUNT(*) cnt --����ŷ, KFC, �Ƶ����� �Ǽ�
        FROM fastfood
        WHERE gb IN ('KFC', '����ŷ', '�Ƶ�����')
        GROUP BY sido, sigungu) a,
        (SELECT sido, sigungu, COUNT(*) cnt --�Ե�����
        FROM fastfood
        WHERE gb = '�Ե�����'
        GROUP BY sido, sigungu) b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu) a2
WHERE a1.sigungu = a2.sigungu(+);

--SMITH�� ���� �μ� ã��
SELECT deptno
FROM emp
WHERE ename = 'SMITH';

SELECT *
FROM emp
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename = 'SMITH');

SELECT empno, ename, deptno, 
      (SELECT dname FROM dept WHERE dept.deptno = emp.deptno) dname
FROM emp;


--SCALAR SUBQUERY
--SELECT ���� ǥ���� ���� ����
--�� ��, �� COLUMN�� ��ȸ�ؾ� �Ѵ�.
SELECT empno, ename, deptno, 
      (SELECT dname FROM dept) dname
FROM emp;

--INLINE VIEW
--FROM���� ���Ǵ� ���� ����

--SUBQUERY
--WHERE�� ���Ǵ� ��������

--sub1
SELECT COUNT(*) cnt
FROM emp
WHERE sal > (SELECT avg(sal)
             FROM emp);
             

--sub2
SELECT *
FROM emp
WHERE sal > (SELECT avg(sal)
             FROM emp);
             
--sub3
--1. SMITH, WARD�� ���� �μ� ��ȸ
--2. 1���� ���� ������� �̿��Ͽ� �ش� �μ���ȣ�� ���ϴ� ���� ��ȸ

SELECT *
FROM emp
WHERE deptno IN (SELECT deptno
                   FROM emp
                   WHERE ename IN('SMITH','WARD'));
                   
--SMITH Ȥ�� WARD ���� �޿��� ���� �޴� ������ȸ
SELECT *
FROM emp
WHERE sal <= ANY (SELECT sal    --800,1250 -->1250���� ���� ��� 
                    FROM emp 
                    WHERE ename IN('SMITH','WARD'));
                    
                    
SELECT *
FROM emp
WHERE sal <= All (SELECT sal    --800,1250 -->800���� ���� ��� 
                    FROM emp 
                    WHERE ename IN('SMITH','WARD'));
                    

--������ ������ ���� �ʴ� ��� ���� ��ȸ

--�������� ���
SELECT *
FROM emp --��� ���� ��ȸ --> �����ڿ����� ���� �ʴ�
WHERE empno IN
                (SELECT mgr
                FROM emp);
                
--�����ڰ� �ƴ� ���
--NOT IN ������ ���� NULL�� �����Ϳ� �������� �ʾƾ� ������ �Ѵ�.
SELECT *
FROM emp 
WHERE empno NOT IN
                  (SELECT NVL(mgr,-1)  --NULL ���� �������� ���� ���� �����ͷ� ġȯ
                     FROM emp);
                     
SELECT *
FROM emp 
WHERE empno NOT IN
                  (SELECT mgr 
                     FROM emp
                     WHERE mgr IS NOT null);
                     
                     
--pair wise (���� �÷��� ���� ���ÿ� ���� �ؾ��ϴ� ���)
--ALLEN, CLARK�� �Ŵ����� �μ���ȣ�� ���ÿ� ���� ��� ���� ��ȸ
--(7698, 30)
--(7839, 10)
SELECT *
FROM emp
WHERE(mgr, deptno) IN (SELECT mgr, deptno
                       FROM emp
                       WHERE empno In ( 7499, 7782));
                       
                       
--�Ŵ����� 7698�̰ų� 7839 �̸鼭
--�ҼӺμ��� 10�� �̰ų� 30���� ���� ���� ��ȸ
--7698, 10
--7698, 30
--7839, 10
--7839, 30
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                FROM emp
               WHERE empno In ( 7499, 7782))
AND deptno IN (SELECT deptno
                 FROM emp
                WHERE empno In ( 7499, 7782));    
                

--���ȣ ���� ���� ����
--���������� �÷��� ������������ ������� �ʴ� ������ ���� ����

--���ȣ ���� ���������� ��� ������������ ����ϴ� ���̺�, �������� ��ȸ ������
--���������� ������������ �Ǵ��Ͽ� ������ �����Ѵ�.
--���������� emp ���̺��� ���� �������� �ְ�, ���������� emp ���̺���
--���� ���� ���� �ִ�.

--���ȣ ���� ������������ ���������� ���̺��� ���� ���� ����
--���������� ������ ������ �ߴٶ�� �� �������� ǥ��.
--���ȣ ���� ������������ ���������� ���̺��� ���߿� ���� ����
--���������� Ȯ���� ������ �ߴٶ�� �� �������� ǥ��.

--������ �޿� ��պ��� ���� �޿��� �޴� ���� ���� ��ȸ
--������ �޿� ���
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal)
               FROM emp);

--��ȣ���� ��������
--�ش������� ���� �μ��� �޿���պ��� ���� �޿��� �޴� ���� ��ȸ

SELECT *
FROM emp m
WHERE sal > (SELECT AVG(sal)
                FROM emp
                WHERE deptno = m.deptno);
                

--10���μ��� �޿� ���
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;

