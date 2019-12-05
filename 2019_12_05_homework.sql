--sub8
SELECT*
FROM emp a
WHERE EXISTS(SELECT 'x'
            FROM emp b
            WHERE b.empno = a.mgr);
            
            
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--sub9
SELECT *
FROM product p
WHERE  EXISTS (SELECT 'x'
                   FROM cycle c
                  WHERE cid = 1
                  AND p.pid = c.pid);
               
--sub10   
SELECT *
FROM product p
WHERE NOT EXISTS (SELECT 'x'
                   FROM cycle c
                  WHERE cid = 1
                  AND p.pid = c.pid);