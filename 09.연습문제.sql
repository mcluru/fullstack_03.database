-- 1.----------------------------
create table new_emp (
	no number(5)
	, name varchar2(20)
	, hiredate date
	, bonus number(6,2)
);

select * from new_emp;


-- 2.-----------------------------
create table new_emp2 as
select no, name, hiredate from new_emp;

select * from new_emp2;


-- 3.-----------------------------
create table new_emp3 as
select * from new_emp2 where 1=2;

select * from new_emp3;


-- 4.-----------------------------
alter table new_emp2 add(birthday date default sysdate);

select * from all_tab_columns
		where table_name = 'NEW_EMP2';
		
		
-- 5.-----------------------------
alter table new_emp2 rename column birthday to birth;


--6.------------------------------
alter table new_emp2 modify(no number(7));
select * from all_tab_columns
		where table_name = 'NEW_EMP2';


--7.------------------------------
alter table new_emp2 drop column birth;


--8.------------------------------
truncate table new_emp2;


--9.-------------------------------
drop table new_emp2;


--10.-----------------------------
/*
데이터 딕셔너리 종류와 특징

1. user_xxx	: 자신의 계정이 소유한 객체 등에 관한 정보 조회

2. all_xxx	: 자신의 계정이 소유하거나 권한을 부여받은 객체 등에 관한 정보 조회

3. dba_xxx	: 데이터베이스 관리자만 접근 가능한 객체 등에 관한 정보 조회
							dba 권한을 가진 사용자는 db에 있는 모든 객체 조회 가능
*/