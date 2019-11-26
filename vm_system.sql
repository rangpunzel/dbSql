SELECT *
FROM DBA_DATA_FILES;


--table space 생성
  CREATE TABLESPACE TS_DBSQL
   DATAFILE '\home\oracle\APP\ORACLE\ORADATA\orcl\TS_DBSQL.DBF' 
   SIZE 100M 
   AUTOEXTEND ON;
   
   
--사용자 추가
create user vm_js identified by java
default tablespace TS_DBSQL
temporary tablespace temp
quota unlimited on TS_DBSQL
quota 0m on system;


--접속, 생성권한
GRANT CONNECT, RESOURCE TO vm_js;