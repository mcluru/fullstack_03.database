/*
	테이블 생성하기
	
	1. 문법
		
		create table 테이블명(
				컬럼명1		데이터타입(크기)		default 기본값
				...
			, 컬럼명n	  데이터타입(크기)		default 기본값
		);
		
		
	2. 데이터타입
		
		1) 문자형
			a. char(n)		 : 고정길이 / 최대 2KB / 기본길이 1byte
			b. varchar2(n) : 가변길이 / 최대 4KB / 기본길이 1byte
			c. long				 : 가변길이 / 최대 2GB
			
			
		2) 숫자형
			a. number(p, s) : 가변숫자 			 / p(1~38, 기본값=38), s(-84~127, 기본값=0) / 최대 22byte
			b. float(p)			: number하위타입 / p(1~128, 기본값=128)									   / 최대 22byte
		
		
		3) 날짜형
			a. date			 : bc 4712.01.01 ! 9999.12.31까지 년월시분초까지 표현
			b. timestamp : 년월시분초밀리초까지 표현
			
			
		4) lob타입(Large OBject) : 대용량의 데이터 저장가능한 데이터타입
															그래프, 이미지, 동영상 음악파일 등 비정형 데이터 저장할 때 사용.
															문자형 대용량 데이터는 CLOB or NLOB사용.
															이미지,동영상 등 데이터는 BLOB or BFILE 타입 사용
															
			a. clob	 : 문자형 대용량 객체. 고정길이와 가변길이 문자형 지원
			b. blob	 : 이진형 대용량 객체. 주로 멀티미디어자료를 저장
			c. bfile : 대용량 이진파일의 위치와 이름 저장
*/

/* A. 테이블 생성하기 */
create table mytable(
	 no number(3,1)
	,name varchar2(10)
	,hiredate date 
);

select * from mytable;


create table 마이테이블(
	 번호 number(3,1)
	,이름 varchar2(10)
	,입사일 date 
);

select * from 마이테이블;


/*
	테이블 생성시 주의사항
	
	1. 테이블이름은 반드시 문자로 시작해야함.(중간에 숫자포함 가능)
	2. 특수문자 가능. 단, 테이블생성시 큰 따옴표로 감싸야함(권장x)
	3. 테이블명/컬럼명은 최대 30byte까지. (즉, 한글은 문자셋에 따라 utf-8 10자, euc-kr 15자)
	4. 동일 사용자(스키마) 안에서 테이블명 중복정의 불가
	5. 테이블명/컬럼명은 오라클키워드 사용가능(but 절대 사용 금지)
*/

-- 1. 테이블에 자료 추가하기(insert)
-- a. 문법
-- insert into 테이블명(컬럼1, ... 컬럼n) values(값1, ... 값n)
-- b. 제약사항
-- 1) 컬럼갯수와 값갯수는 동수여야함
-- 2) 컬럼과 값의 데이터타입은 동일해야함
--		단, 형변환(자동형변환)이 가능하다면 사용가능. 변환 불가하다면 에러 발생

select * from mytable;

insert into mytable(name) values('홍길동');
insert into mytable(name) values(1,'홍길동'); -- (x) too many values
insert into mytable(no, name) values('홍길동'); -- (x) not enough values

insert into mytable(no, name) values(1,'홍길동');
insert into mytable(no, name) values(2,'홍길순');
insert into mytable(no, name) values(3,'홍길자');
insert into mytable(no, name) values(4,'홍길성');
insert into mytable(no, name) values(5,'홍길상');
insert into mytable(no, name) values(1,'손흥민'); -- 중복제약사항 없음. 문법에러x 로직에러O
insert into mytable(no, name, hiredate) values(6,'김민재',sysdate);
insert into mytable(no, name, hiredate) values(7,10000,sysdate); -- 자동형변환 가능
insert into mytable(no, name, hiredate) values('이강인',10000,sysdate); -- (x) invalid number
insert into mytable(no, name, hiredate) values(8,'이강인','2023.03.27');
insert into mytable(no, name, hiredate) values(9,'소향','2023-03-27');
insert into mytable(no, name, hiredate) values(1000,'소향',10); -- (x) expected DATE got NUMBER
insert into mytable(no, name, hiredate) values('2023-03-27','소향','20230327'); -- (x) invalid number
insert into mytable(no, name, hiredate) values(100,'거미',sysdate); -- (x) value larger than specified precision


select * from mytable;



-- 2. 테이블복사
-- emp테이블을 temptable로 복사
-- select 명령으로 복사가능
-- create table temptable(empno 데이터타입, ename, hiredate ...); <-원래라면 이렇게 해야함

select * from emp;


-- 1) 테이블구조 및 데이터복사
create table temptable as
select * from emp;

select * from temptable;


-- 2) 테이블구조만 복사
-- 테이블이 이미 있는 경우 에러 - name is already used by an existing object
-- 테이블 삭제 명령 : drop table 테이블명;
drop table temptable;

create table temptable as
select * from emp where 1=2;

select * from temptable;


-- 3) 테이블구조 및 특정자료만 복사
drop table temptable;

create table temptable as
select * from emp where deptno = 10;

select * from temptable;


/*
	B. 테이블 수정하기 - 컬럼
	
	1. 컬럼 추가		 : alter table 테이블명 add(추가걸럼명 데이터타입)
	2. 컬럼명 변경		 : alter table 테이블명 rename column 변경전이름 to 변경후이름
	3. 데이터타입 변경 : alter table 테이블명 modify(변경할컬럼 변경할데이터타입)
	4. 컬럼 삭제		 : alter table 테이블명 drop column 삭제할컬럼명
*/

-- 실습. dept2테이블을 dept6로 복사
	create table dept6 as
	select * from dept2;

	-- 1. 컬럼 추가 : dept6 location varchar2(10)
	alter table dept6 add(location varchar2(10));
	select * from dept6;

	-- 2. 컬럼명 변경 : location -> loc로 변경
	alter table dept6 rename column location to loc;

	-- 3. 데이터타입 변경 : dname -> number, loc -> number타입
	-- 데이터타입 변경시 기존 데이터에 따라 변경가능한 타입이면 변경가능.
	--														 변경불가한 데이터가 있으면 에러발생.
	alter table dept6 modify(dname number); -- (x) column to be modified must be empty to change datatype
	alter table dept6 modify(loc number); -- 값이 없어서 변경가능

	-- 4. 오라클테이블 정보보기
	select * from all_tab_columns
		where table_name = 'DEPT6';
		
	-- 5. 컬럼추가시 기본값 세팅
	create table dept7 as select * from dept2;
	alter table dept7 add(location varchar2(10) default '서울');
	alter table dept7 add(xxx number default 0);
	alter table dept7 add(create_date date default sysdate);
	
	select * from dept7;
	
	-- 6. 컬럼의 크기 변경
	-- location 10자리 -> 1자리로 변경
	select * from all_tab_columns where table_name = 'DEPT7';
	alter table dept7 modify(location varchar2(1)); -- (x) cannot decrease column length because some value is too big
	alter table dept7 modify(location varchar2(7));
	
	-- 7. 컬럼삭제하기
	alter table dept7 drop column xxx;



/*
	C. 테이블 수정하기 - 테이블
	
	1. 테이블이름변경			 : alter table 변경전 rename to 변경후
	2. 테이블삭제(자료만)	 : truncate table 테이블명
	3. 테이블삭제(완전삭제) : drop table 테이블명
*/

-- 1. 테이블명 변경하기
alter table dept7 rename to dept777;

-- 2. 테이블 삭제 - truncate
truncate table dept777;
select * from dept777;
select * from all_tab_columns where table_name = 'DEPT777';

-- 3. 테이블 완전삭제
drop table dept777;
select * from dept777;
select * from all_tab_columns where table_name = 'DEPT777';



/*
	D. 읽기 전용 테이블 생성하기
	alter table 테이블명 read only
*/
create table tbl_read_only (
	no number
	,name varchar2(20)
);
insert into tbl_read_only values(1, '손흥민');
select * from tbl_read_only;

-- 읽기전용 테이블로 변경하기
alter table tbl_read_only read only;
insert into tbl_read_only values(2, '김민재'); --(x) update operation not allowed on table "SCOTT"."TBL_READ_ONLY"

-- 읽기전용을 읽기/쓰기로 변경
-- read write
alter table tbl_read_only read write;
insert into tbl_read_only values(2, '김민재');



/*
	E. Data Dictionary
	http://www.gurubee.net/
	
	오라클 데이터베이스의 메모리 구조와 테이블에 대한 구조 정보를 가짐.
	(오라클에서 지원하는 기능)
	
	각 객체(테이블, view, index ...)등이 사용하고 있는 공간정보, 제약조건, 사용자정보 및 권한, 프로파일, Role, 감사(Audit) 등의 정보를 제공
	
	
	1. 데이터딕셔너리
		1) 데이터베이스 자원들을 효율적으로 관리하기 위해 다양한 정보를 저장하고 있는 시스템
		2) 사용자가 테이블을 생성하거나 변경하는 등의 작업할 때 데이터베이스 서버(엔진)에 의해 자동으로 갱신되는 테이블
		3) 사용자가 데이터딕셔너리의 내용을 수정하거나 삭제할 수 없음
		4) 사용자가 데이터딕셔너리를 조회할 경우 시스템이 직접 관리하는 테이블은 암호화 되어있어 내용조회 불가.
	
	2. 데이터딕셔너리 뷰 : 오라클은 데이터딕셔너리의 내용을 사용자가 이해가능한 내용으로 변환하여 제공.
	
		1) user_xxx
			a. 자신의 계정이 소유한 객체에 대한 정보 조회.
			b. user라는 접두어가 붙은 데이터딕셔너리 중 자신이 생성한 테이블, 인덱스, 뷰 등의
					자신이 소유한 객체의 정보를 저장하는 user_tables가 있음
					--> select * from user_tables;
					
		2) all_xxx
			a. 자신계정소유와 권한을 부여 받을 객체 등의 정보를 조회
			b. 타 계정의 객체는 원칙적으로 접근 불가하지만, 그 객체의 소유자가 접근가능하도록 권한 부여한 경우 타 계정의 객체에도 접근 가능.
					--> select * from all_tables;
					--> select * from all_tables where owner = 'SCOTT';
					
		3) dba_xxx
			a. 데이터베이스 관리자만 접근 가능한 객체들의 정보 저회
			b. dba딕셔너리는 DBA권한을 가진 사용자는 모두 접근 가능.
					즉, DB에 있는 모든 객체들에 대한 정보 조회가능
			c. dba권한을 가진 sys, system계정으로 접속시 dba_xxx등의 내용 조회가능.
*/

select * from user_tables;
select * from all_tables;
select * from dba_tables;

SELECT * FROM DICTIONARY;

select * from user_cons_columns;