/*
	A. where 조건절
	
	1. 비교연산
		=
		!=, <>
		>
		>=
		<
		<=
	
	2. 기타연산자
		a and b : 논리곱
		a or b : 논리합
		not a : 부정
		between A and B : A와 B사이의 데이터 검색. A는 B보다 작은값이어야함
		in(a,b,c...) : a,b,c 등의 값을 가지고 있는 데이터를 검색
		like (%, _와 같이사용) : 특정 패턴을 가진 데이터 검색
			-> '%A' A로 끝나는 데이터, 'A%'A로 시작, '%A%' A를 포함
		is null/ in not null : null값 여부를 가지고 있는 데이터를 검색
*/

/* A. 비교연산자 */
-- 1. 급여(sal)가 5000인 사원 조회하기
select * from emp;
select * from emp where sal = 5000;
select * from emp where sal = 1600;

-- 2. 급여(sal)가 900보다 작은 사원
select * from emp where sal < 900;
select * from emp where sal >= 900;
select * from emp where sal <> 900;

-- 3. 이름이 smith인 사원 조회하기
select * from emp where ename = 'SMITH'; --따옴표 없으면 열이름으로 인식

-- 대소문자 변환함수 upper(), lower()
select * from emp where ename = 'smith';
select ename from emp where ename = upper('smith');
select ename from emp where lower(ename) = 'smith';

-- 4. 입사일자(hiredate)
-- 입사일자가 1980-12-17인 사원을 조회
-- hint : date타입은 비교할 때 문자열로 간주
select * from emp where hiredate in '1980-12-17';