/*
	A. 집합연산자
	
	1. union			: 두 집합의 결과를 합쳐서 출력. 중복은 제외함
	2. union all	: 두 집합의 겸과를 합쳐서 출력. 중복 상관없이 전체 자료 조회
	3. intersect	: 두 집합의 교집합 출력(정렬)
	4. minus			: 두 집합의 차집합 출력(정렬), 선후 순서가 중요
	
	[집합연산자의 조건]
	1. 두 집합의 select절의 컬럼 수가 동일해야함
	2. 두 집합의 select절의 같은 위치의 컬럼의 데이터타입이 동일해야함
	3. 두 집합의 컬럼명이 달라도 OK. 단 먼저 정의된 컬럼명으로 정해짐
*/

select * from student;
select * from professor;

select studno 학생번호 from student;
select profno 교수번호 from professor;

-- 1. union : 학생번호와 교수번호 정보를 하나로 합치기
select studno 학생번호 from student
union
select profno 교수번호 from professor;

select name 학생명 from student
union
select profno 교수번호 from professor; --(x) 데이터타입이 다름

select studno 학생번호, name 학생이름 from student
union
select profno 교수번호 from professor; --(x) 컬럼 개수가 다름


-- 2. union/ union all
select count(*) from student; --집계함수 count(*[컬럼명])
select count(deptno1) from student;
select count(deptno2) from student; --null은 값이 아님.

select studno, name, deptno1 from student
union 
select studno, name, deptno1 from student; -- union은 중복제외

select studno, name, deptno1 from student
union all
select studno, name, deptno1 from student; -- union all은 중복제외안함


-- 3. union은 정렬하지만 union all 정렬안함
select studno, name, deptno1,1 from student where deptno1 = 101
union
select studno, name, deptno1,2 from student where deptno1 = 101; -- 정렬

select studno, name, deptno1,1 from student where deptno1 = 101
union all
select studno, name, deptno1,2 from student where deptno1 = 101; -- 정렬(x)


-- 4. 교집합 intersect
select studno, name, deptno1 from student where deptno1 = 101
intersect
select studno, name, deptno1 from student where deptno1 = 102;


-- 5. 차집합 minus
select studno, name, deptno1 from student where deptno1 = 101
minus
select studno, name, deptno1 from student where deptno1 = 102;

select studno, name, deptno1 from student where deptno1 = 102
minus
select studno, name, deptno1 from student where deptno1 = 101;