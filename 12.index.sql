/*
	인덱스란?
	
	인덱스는 특정 데이터가 HDD의 어느 위치(메모리)에 저장되어 있는지에 대한 정보를 가진 주소와 같은 개념.
	인덱스는 데이터와 위치주소(rowid)정보를 key와 value의 형태의 한쌍으로 저장되어 관리됨.
	인덱스의 가장 큰 목적은 데이터를 보다 빠르게 검색/조회할 수 있기위함.
	
	1. rowid 구조
		rowid는 데이터의 위치정보 즉, HDD에 저장되어 있는 메모리주소로서 Oracle에선 총 18bytes길이의 정보.
		rowid는 예를들어 AAAW5jAAEAAAAFbAAA의 형태
		1) 데이터오브젝트번호(6) : AAAW5j
		2) 파일번호				(3) : AAE
		3) block번호			(6) : AAAAFb
		4) 행번호					(3) : AAA
	
	
	2. index 사용이유
		1) 데이터를 보다 신속하게 검색하도록 사용함(검색속도를 향상)
		2) 보통 index테이블의 특정 컬럼에 한 개 이상을 주게 되면 index table이 별도로 생성됨.
				이 index테이블에는 인덱스 컬럼의 row값과 rowid가 저장되고 row값은 정렬된 b-tree구조로 저장시켜서
				검색시 보다 빠르게 데이터 검색이 가능하게함
		3) 하지만 update, delete, insert시에 속도가 느려지는 단점.
	
	
	3. index가 필요한 이유
		1) 데이터가 대용량일때
		2) where 조건절에 자주 사용되는 컬럼일 경우
		3) 조회결과 전체 데이터베이스의 3~5%미만일 경우 인덱스 검색이 효율적이고
				보다 적은 비용으로 빠르게 검색할 수 있음
	
	
	4. index가 필요하지 않은 경우
		1) 데이터가 적을 경우(수천건 미만)엔 인덱스 설정 안하는게 되려 성능좋음
		2) 검색보다 update, delete, insert가 빈번하게 일어나는 테이블엔 인덱스가 없는 게 좋을 수 있음
		3) 조회결과 전체 행의 15%이상인 경우엔 사용안하는 게 좋음
	
	
	5. index가 자동생성되는 경우
		테이블 정의시 PK, UK의 제약조건으로 정의할 때 자동생성됨
	
	
	6. 문법
		1) 생성방법 : create [unique] index 인덱스명 on 테이블명(컬럼1, ...컬컬n)
		2) 삭제방법 : drop index 인덱스명
				--> index는 테이블에 종속되어 있기 때문에 테이블이 삭제될 때 자동으로 삭제됨
*/


-- 1. rowid는 오라클 DB에서만 사용하는 개념. rowid 검색할 수 있다.
-- 만약 rowid를 지원안하는 프로그램에선 rowidtochar(rowid)함수 이용해서 조회가능
select rowid, ename from emp;
select rowidtochar(rowid), ename from emp;
select length(rowid) from emp;


select length(rowid)
				, rowid 			-- 7521데이터가 저장되어있는 HDD의 메모리주소
				, ename
				, empno
			from emp
			where empno = 7521
union all
select length(rowid)
				, rowid 			-- WARD가 저장되어있는 HDD의 메모리주소
				, ename
				, empno
			from emp
			where ename = 'WARD';


-- 2. index 조회 : data dictionary
select * from all_indexes;
select * from user_indexes;
select * from user_indexes where table_name = 'DEPT2';
select * from user_ind_columns where table_name = 'DEPT2';
select * from user_ind_columns where table_name = 'EMP';

-- 3. index 생성(1) - unique index
create unique index idx_dept2_dname on dept2(dname);
create unique index xxxx on dept2(area); --(x) cannot CREATE UNIQUE INDEX; duplicate keys found
select * from user_indexes where table_name = 'DEPT2';
select * from user_ind_columns where table_name = 'DEPT2';

-- 4. index 생성(2) - non unique index
select * from dept2;
create index idx_dept2_area on dept2(area); 
select * from user_indexes where table_name = 'DEPT2';
select * from user_ind_columns where table_name = 'DEPT2';

-- 5. index 생성(3) - 결합인덱스
select ename, sal, job from emp where ename = 'SMITH' and job = 'CLERK';
select ename, sal, job from emp where job = 'CLERK' and ename = 'SMITH';
select count(*) from emp where job = 'CLERK';
select count(*) from emp where ename = 'SMITH';
select * from user_indexes where table_name = 'EMP';
select * from user_ind_columns where table_name = 'EMP';

create index idx_emp_ename_job on emp(ename, job);
select * from user_indexes where table_name = 'EMP';
select * from user_ind_columns where table_name = 'EMP';

-- 6. index rebuilding 하기
-- 1) index 생성
drop table idx_test;
create table idx_test(no number);
select * from idx_test;

--pl/sql
begin
	for i in 1..100000 loop
		insert into idx_test values(i);
	end loop;
	commit;
end;

select count(*) from idx_test;


-- a. 인덱스 없이 조회하기
select * from idx_test order by no; -- 0.124s
select * from idx_test where no = 9000; -- 0.023s

-- b. 인덱스 생성후 조회하기
create index idx_test_no on idx_test(no);

select * from idx_test order by no; -- 0.115s
select * from idx_test where no = 9000; -- 0.004s