--outerjoin4
--100, 400
--포함되지 않은 모든 컬럼에 (+)
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


--도시발전지수
--(맥+버+k)/롯데리아
--순위 / 시도 / 시군구 / 도시발전지수(소수점 둘째 자리에서 반올림)
-- 1 / 서울특별시 / 서초구 / 7.5
-- 2 / 서울특별시 / 강남구 / 7.2

SELECT *
FROM fastfood;


SELECT rownum 순위, dd.sido 시도, dd.sigungu 시군구, dd.cnt 도시발전지수
FROM
    (SELECT rownum, a.sido, a.sigungu, round(bcnt/lcnt,1) cnt
    FROM
        (SELECT sido, sigungu, count(sigungu) bcnt
         FROM fastfood
         WHERE gb IN ('버거킹','맥도날드','KFC')
         GROUP BY sido, sigungu)a,
        (SELECT sido, sigungu, count(sigungu) lcnt
         FROM fastfood
         WHERE gb = '롯데리아'
         GROUP BY sido, sigungu)b
    WHERE a.sido = b.sido
    AND a.sigungu = b.sigungu
    ORDER BY cnt DESC)dd;
    



--선생님 답
--해당 시도, 시군구별 프렌차이즈별 건수가 필요

SELECT ROWNUM rn, sido, sigungu, 도시발전지수
FROM
(SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt,1) as 도시발전지수
FROM
    (SELECT sido, sigungu, COUNT(*) cnt --버거킹, KFC, 맥도날드 건수
    FROM fastfood
    WHERE gb IN ('KFC', '버거킹', '맥도날드')
    GROUP BY sido, sigungu) a,
    
    (SELECT sido, sigungu, COUNT(*) cnt --롯데리아
    FROM fastfood
    WHERE gb = '롯데리아'
    GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY 도시발전지수 DESC);

