--outerjoin4
--100, 400
--���Ե��� ���� ��� �÷��� (+)
SELECT product.pid, product.pnm,   --product
       :cid cid, NVL(cycle.day,0) day, NVL(cycle.cnt,0) cnt   --cycle
FROM cycle, product
WHERE cycle.cid(+)= :cid
AND cycle.pid(+) = product.pid;

--200, 300
SELECT *
FROM product;


--outerjoin5
SELECT a.pid, a.pnm, a.cid, customer.cnm, a.day, a.cnt
FROM
    (SELECT product.pid, product.pnm,   --product
           :cid cid, NVL(cycle.day,0) day, NVL(cycle.cnt,0) cnt   --cycle
    FROM cycle, product
    WHERE cycle.cid(+)= :cid
    AND cycle.pid(+) = product.pid) a, customer
WHERE a.cid = customer.cid;



--crossjoin1
SELECT *
FROM customer, product;


--���ù�������
--(��+��+k)/�Ե�����
--���� / �õ� / �ñ��� / ���ù�������(�Ҽ��� ��° �ڸ����� �ݿø�)
-- 1 / ����Ư���� / ���ʱ� / 7.5
-- 2 / ����Ư���� / ������ / 7.2

SELECT *
FROM fastfood;


SELECT rownum ����, dd.sido �õ�, dd.sigungu �ñ���, dd.cnt ���ù�������
FROM
    (SELECT rownum, a.sido, a.sigungu, round(bcnt/lcnt,1) cnt
    FROM
        (SELECT sido, sigungu, count(sigungu) bcnt
         FROM fastfood
         WHERE gb IN ('����ŷ','�Ƶ�����','KFC')
         GROUP BY sido, sigungu)a,
        (SELECT sido, sigungu, count(sigungu) lcnt
         FROM fastfood
         WHERE gb = '�Ե�����'
         GROUP BY sido, sigungu)b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY cnt DESC)dd;
    



--������ ��
--�ش� �õ�, �ñ����� ��������� �Ǽ��� �ʿ�

SELECT ROWNUM rn, sido, sigungu, ���ù�������
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
ORDER BY ���ù������� DESC);

