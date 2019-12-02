--OUYRT join : ���� ���ῡ ���� �ϴ��� ������ �Ǵ� ���̺��� �����ʹ�
--�������� �ϴ� join
--LEFT OUTER JOIN : ���̺�1 LEFT OUTER JOIN ���̺�2
--���̺�1�� ���̺�2�� �����Ҷ� ���ο� �����ϴ��� ���̺�1�ʿ� �����ʹ�
--��ȸ�� �ǵ��� �Ѵ�
--���ο� ������ �࿡�� ���̺�2�� �÷����� �������� �����Ƿ� NULL�� ǥ�õȴ�.

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno);
           
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m
           ON (e.mgr = m.empno);
           

--
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno AND m.deptno=10);
    
           
SELECT e.empno, e.ename, e.deptno, m.empno, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno)
WHERE m.deptno=10;


--ORACLE outer join syntax
--�Ϲ����ΰ� �������� �÷��� (+)ǥ��
--(+)ǥ�� : �����Ͱ� �������� �ʴµ� ���;��ϴ� ���̺��� �÷�
--���� LEFT OUTER JOIN �Ŵ���
--  ON(����.�Ŵ�����ȣ = �Ŵ���.������ȣ)

--ORACLE OUTER
--WHERE ����.�Ŵ�����ȣ = �Ŵ���.������ȣ(+) -- �Ŵ����� �����Ͱ� �������� ����
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno(+);

--�Ŵ��� �μ���ȣ ����
--ANSI SQL WHERE ���� ����� ����
-- -->OUTER ������ ������� ���� ��Ȳ
--�ƿ��� ������ ����Ǿ�� �� ���̺��� ��� �÷��� (+)�� �پ�ߵȴ�.
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno(+)
AND m.deptno = 10;

--ansi sql�� on���� ����� ���� ����
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e , emp m
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10;


--emp ���̺��� 14���� ������ �ְ� 14���� 10, 20, 30�μ��߿� �� �μ���
--���Ѵ�
--������ dept���̺��� 10, 20, 30, 40�� �μ��� ����

--�μ���ȣ, �μ���, �ش�μ��� ���� �������� �������� ������ �ۼ�

SELECT d.deptno, d.dname, count(e.ename) cnt
FROM emp e, dept d
WHERE e.deptno(+) = d.deptno
GROUP BY d.deptno, d.dname
ORDER BY d.deptno;


--dept : deptno, dname
-- inline : deptno, cnt(������ ��)
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept,
(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) emp_cnt
WHERE dept.deptno = emp_cnt.deptno(+);

--ANSI
SELECT dept.deptno, dept.dname, NVL(emp_cnt.cnt, 0) cnt
FROM
dept LEFT OUTER JOIN (SELECT deptno, COUNT(*) cnt
                      FROM emp
                      GROUP BY deptno) emp_cnt
                ON (dept.deptno = emp_cnt.deptno);
                
                
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m
           ON (e.mgr = m.empno);

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e RIGHT OUTER JOIN emp m
           ON (e.mgr = m.empno);

--FULL OUTER : LEFT OUTER + RIGHT OUTER - �ߺ������� �ѰǸ� �����
SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e FULL OUTER JOIN emp m
           ON (e.mgr = m.empno);
           
--outerjoin1
SELECT TO_CHAR(buy_date,'yy/mm/dd') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM
(SELECT *
FROM buyprod
WHERE TO_CHAR(buy_date,'yyyy/mm/dd') = TO_DATE('2005/01/25','yyyy/mm/dd')) b
RIGHT OUTER JOIN prod
ON (prod_id = buy_prod);




--outerjoin2
SELECT NVL(TO_CHAR(buy_date,'yy/mm/dd'),TO_CHAR(TO_DATE('05/01/25','yy/mm/dd'),'yy/mm/dd')) buy_date
    , buy_prod, prod_id, prod_name, buy_qty
FROM
(SELECT *
FROM buyprod
WHERE TO_CHAR(buy_date,'yyyy/mm/dd') = TO_DATE('2005/01/25','yyyy/mm/dd')) b
RIGHT OUTER JOIN prod
ON (prod_id = buy_prod);

--outerjoin3
SELECT NVL(TO_CHAR(buy_date,'yy/mm/dd'),TO_CHAR(TO_DATE('05/01/25','yy/mm/dd'),'yy/mm/dd')) buy_date
    , buy_prod, prod_id, prod_name, NVL(buy_qty,0) buy_qty
FROM
(SELECT *
FROM buyprod
WHERE TO_CHAR(buy_date,'yyyy/mm/dd') = TO_DATE('2005/01/25','yyyy/mm/dd')) b
RIGHT OUTER JOIN prod
ON (prod_id = buy_prod);



--outerjoin4
SELECT product.pid, pnm, NVL(cid,1) cid, NVL(day,0) day, NVL(cnt,0)
FROM product LEFT OUTER JOIN 
                            (SELECT pid, cid, day, cnt
                            FROM cycle c
                            WHERE cid = 1)a 
    ON (a.pid = product.pid);



--outerjoin5

SELECT p.pid, p.pnm, p.cid, cnm, p.day, p.cnt
FROM
(SELECT product.pid, pnm, NVL(cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt
FROM product LEFT OUTER JOIN 
                            (SELECT pid, cid, day, cnt
                            FROM cycle c
                            WHERE cid = 1)a 
    ON (a.pid = product.pid))p JOIN customer ON (p.cid = customer.cid);




