SELECT *
FROM pc04.users;

SELECT *
FROM jobs;

SELECT *
FROM USER_TABLES;

--78 --> 79
SELECT *
FROM ALL_TABLES
WHERE OWNER = 'pc04';

SELECT *
FROM pc04.fastfood;

--pc04.fastfood -->fastfood

CREATE SYNONYM fastfood FOR pc04.fastfood;

SELECT *
FROM fastfood;