/*
	DML
	1. insert : 테이블에 데이터를 추가
	2. update : 테이블에 데이터를 수정
	3. delete : 테이블에 데이터를 삭제
	4. merge	: 2개 이상의 테이블을 한개의 테이블로 병합
*/

/*
	A. insert
	
	1. 테이블에 새로운 행(row, record)를 추가할 때 사용하는 명령
	2. 테이블에 새로운 데이터를 입력(추가)하기 위한 데이터 조작어
	3. 문법
		1) insert into 테이블명 (컬럽1..컬럼n) values(값1...값n);
		2) insert into 테이블명 values(값1...값n);
		3) 서브쿼리 이용해서 기존 테이블에 데이터 추가하는 방법
			 ... insert into 테이블명 select 컬럽1...컬럼n from 테이블명 where ...
			 ...동일갯수, 동일순서, 동일데이터타입일 경우 사용가능
		4) insert all
							when 조건 then into
							when 조건 then into
		5) insert all
							into 테이블명 values()
							into 테이블명 values()
*/ 

-- 1. 레코드추가
-- 실습1. dept2에 부서번호 9000, 부서명 테스트부서_1, 상위부서 1006, 지역 기타지역
-- 							부서번호 9001, 부서명 테스트부서_2, 상위부서 1006, 지역 기타지역
-- 							부서번호 9001, 부서명 테스트부서_3, 상위부서 1006, 지역 기타지역
insert into dept2(dcode, dname, pdept, area) values(9000, '테스트부서_1', 1006, '기타지역');
insert into dept2 values(9001, '테스트부서_2', 1006, '기타지역');
insert into dept2 values(9001, '테스트부서_3', 1006, '기타지역');  --unique constraint violated(중복불가)
select * from dept2;

-- 실습2. professor에 교수번호 5001, 교수명 홍길동, id hong, position 정교수, 급여 510, 입사일 sysdate
select * from professor;
insert into professor(profno, name, id, position, pay, hiredate) values(5001, '홍길동', 'hong', '정교수', 510, sysdate);

-- 실습3.
-- 1) professor의 구조만 복사해서 professor4
-- 2) professor에서 profno > 4000 교수만 professor4에 추가

create table professor4 as
select * from professor where 1=2;

insert into professor4 
select * from professor where profno > 4000;

select * from professor4;

-- 실습4.
-- professor를 기준으로 prof_3, prof_4테이블을 생성
-- 1) 각각 profno number, name varchar2(25)의 2개의 컬럼만 존재하는 테이블 생성
-- 2) prof_3엔 1000~1999번까지의 교수만
-- 3) prof_4에는 2000~2999번까지의 교수만 복사

create table prof_3 (profno number, name varchar2(25));
create table prof_4 as select * from prof_3 where 1=2;

insert into prof_3 select profno, name from professor where profno between 1000 and 1999;
insert into prof_4 select profno, name from professor where profno between 2000 and 2999;

select * from prof_3;
select * from prof_4;


-- 2. insert all(1)
drop table prof_3;
drop table prof_4;

create table prof_3 (profno number, name varchar2(25));
create table prof_4 as select * from prof_3 where 1=2;

insert all 
	when profno between 1000 and 1999 then into prof_3 values(profno, name)
	when profno between 2000 and 2999 then into prof_4 values(profno, name)
select * from professor;



-- 3. insert all(2)
-- 동일자료를 각각 다른 테이블에 추가하는 방법
drop table prof_3;
drop table prof_4;

create table prof_3 (profno number, name varchar2(25));
create table prof_4 as select * from prof_3 where 1=2;

insert all
	into prof_3 values(profno, name)
	into prof_4 values(profno, name)
select profno, name from professor
	where profno between 3000 and 3999;
	



/*
	B. update
	
	1.테이블에 있는 데이터를 수정하기 위해 사용되는 명령
	2. 기조의 행 or 열을 수정하기 위해 사용
	3. 주의사항 : where조건절에 특정 조건을 정의하지 않을 경우 전체 데이터가 수정됨
	4. 문법 : update 테이블명
						set 컬럼 = 값
						where 조건절
*/
drop table emp999;
create table emp999 as select * from emp;
select * from emp999;

-- update 주의할점
update emp999
	set ename = '스미스';

-- 1. 전체 사원의 부서번호를 10, 급여를 0으로 수정하기
update emp999
	set deptno = 10,
			sal = 0;


-- 실습1. 전체사원의 급여를 10%인상
select sal * 1.1 "10% 인상급여 "from emp999;
update emp999
	set sal = sal*1.1;
select * from emp999;

-- 실습2. 모든 사원의 입사일을 현재일로 수정하기(sysdate)
update emp999
	set hiredate = sysdate;

-- professor4로 테이블 생성한 후
-- 실습3. professor에서 직급이 assistant professor인 사람의 보너스를 200으로 인상하기
create table professor4 as select * from professor;
select * from professor4;

update professor4
	set bonus = 200
	where position = 'assistant professor';
-- 실습4. professor에서 Sharon Stone과 직급이 동일한 교수들의 급여를 15% 인상하기
-- where절에 서브쿼리를 지정. where position = (select from professor where name 샤론스톤의 position)
update professor4
	set pay = pay*1.15
	where position = (select position from professor4 where name = 'Sharon Stone');


/*
	C. delete
	
	1. 테이블에서 특정 조건의 자료 삭제
	2. 행단위로 삭제됨. 열만 삭제 불가
	2. 문법 : delete from 테이블명
						where 조건절
*/

select * from professor4;
delete from professor4;

create table professor2 as select * from professor;
select * from professor2;


select * from dept2;
-- 실습1. 부서코드가 9000인 자료 삭제
delete from dept2
	where dcode = 9000;
-- 실습2. 부서코드가 9000이상인 자료를 삭제
delete from dept2
	where dcode >= 9000;



/*
	D. merge
	
	1. 여러개의 테이블을 한 개의 테이블로 병합하는 명령
	2. 문법 : merge into 병합할테이블명
						using 테이블1 on 병합할 조건
						when matched then update set 업데이트할명령
									delete where 조건절
						when not matched then insert into values(...);
*/


create table charge_01 (
		u_date	varchar2(6)
	, cust_no number
	, u_time	number
	, charge	number
);

create table charge_02 (
		u_date	varchar2(6)
	, cust_no number
	, u_time	number
	, charge	number
);

create table charge_03 (
		u_date	varchar2(6)
	, cust_no number
	, u_time	number
	, charge	number
);
select * from tab;

insert into charge_01 values('141001', 1000, 2, 1000);
insert into charge_01 values('141001', 1001, 2, 1000);
insert into charge_01 values('141001', 1002, 1, 1000);

insert into charge_02 values('141002', 1000, 3, 1500);
insert into charge_02 values('141002', 1001, 4, 2000);
insert into charge_02 values('141002', 1003, 1, 500);

select * from charge_01
union all
select * from charge_02;

select * from charge_03;


-- 1. charge_01 + charge_03
merge into charge_03 tot
	using charge_01 c01 on (tot.u_date = c01.u_date)
	when 		 matched then update set tot.cust_no = c01.cust_no
	when not matched then insert values(c01.u_date, c01.cust_no, c01.u_time, c01.charge);

-- 2. charge_02 + charge_03
merge into charge_03 tot
	using charge_02 c02 on (tot.u_date = c02.u_date)
	when		 matched then update set tot.cust_no = c02.cust_no
	when not matched then insert values(c02.u_date, c02.cust_no, c02.u_time, c02.charge);



/*
	E. transaction
	
	실무에선 간단한 SQL작업을 하는 게 아니라 대부분 여러가지 작업을 동시에 처리하게 되는데
	처리 도중 에러 발생 시 이전 실행작업을 취소할 필요가 있음
	에러가 없을 경우 최종적으로 작업을 확정하게 됨.
	이러한 작업 취소/확정 명령 : rollback, commit
	
	rollback : 확정되지 않은 이전 작업을 취소하는 명령
	commit 	 : 작업을 최종적으로 확정하는 명령
*/


/* 연습문제 */
-- 1. dept2 테이블에 아래와 같은 내용으로 새로운 부서 정보를 입력하시오
-- 부서번호 9010, 부서명 temp_10, 상위부서 : 1006, 지역 : temp area
select * from dept2;


-- 2. dept2 테이블에 아래와 같은 내용으로 특정 컬럼에만 정보를 입력하세요
-- 부서번호 9020, 부서명 temp_20, 상위부서 Business Department (1006번 부서)
insert into dept2(dcode, dname, pdept) values(9020, 'temp_20', 1006);


-- 3. professor 테이블에서 profno가 3000번 이하의 교수들의 profno, name, pay를 가져와서
--		professor4 테이블에 한꺼번에 입력하는 쿼리(ITAS 방법 사용)
select * from professor;
select * from professor4;
drop table professor4;
create table professor4 as
	select * from professor where 1=2;
	
insert into professor4 select profno, name, pay from professor where profno <= 3000;
	
	


-- 4. professor 테이블에서 Sharon Stone 교수의 bonus를 100으로 인상

update professor
	set bonus =100
	where name = 'Sharon Stone';
select * from professor;
