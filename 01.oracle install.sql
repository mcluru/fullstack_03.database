select * from dba_users;
select * from all_users;
alter user hr account lock;
alter user hr account unlock;
select * from t
/*
	Oracle 기본 date형식 변경하기
*/

-- 1. 오라클 환경변수 조회하기
select * from v$nls_parameters;

-- 2. 날짜형식 변경하기
-- alter session[system] set 시스템변수 = 변경할 값
alter session set nls_date_format = 'YYYY.MM.DD'; --dateformat 변경
alter session set nls_timestamp_format = 'YYYY.MM.DD HH:MI:SS'; --timestamp format 변경

-- 영구적(system 레벨)
alter system set nls_date_format = 'YYYY.MM.DD' scope=spfile; 
alter system set nls_timestamp_format = 'YYYY.MM.DD HH:MI:SS' scope=spfile;
-- scope
-- 1. both : 바로적용 or 재시작 (error확률 있음)
-- 2. spfile : 재시작
-- SQL command line에서 system사용자로 변경 후 DB 재시작

select * from hr.employees;