/* 그룹함수*/

--1. count : 조건에 맞는 행의 개수 리턴


select count(ename) from emp;
select count(comm) from emp;
select count(nvl(comm,0)) from emp;
select count(*) from emp where deptno = 10;
select count(sal), count(comm), count(nvl(comm,0)) from emp;
select count(sal), count(comm), count(nvl(comm,0)) from emp where comm is not null;


--2. sum()
select sum(sal) from emp;
select sum(comm) from emp;
select sum(ename) from emp; -- (x) 문자열은 에러
select count(ename) 총사원수
	, sum(sal) 총급여
	, round(sum(sal)/count(ename),0) 평균급여
	from emp;
	
	
--3. avg()
select count(ename) 총사원수, sum(sal) 총급여, round(sum(sal)/count(ename),0) 평균급여 from emp
union all
select count(ename) 총사원수, sum(sal) 총급여, round(avg(sal),0) 평균급여 from emp;


-- 4. min/max
select min(sal + nvl(comm,0)) 최저급여
	, max(sal + nvl(comm,0)) 최저급여
	from emp;

-- 최초입사일, 최후입사일
select min(hiredate) 최초입사일
	, max(hiredate) 최후입사일
	from emp;

-- 이름
select min(ename) 알파벳빠른사원이름
	, max(ename) 알파벳늦은사원이름
	from emp;
	
-- 최초입사자, 최후입사자
-- 최저급여자, 최대급여자
-- 사원 이름 출력
select * from emp;
select ename 최초입사자 from emp where hiredate = (select min(hiredate) from emp)
union
select ename 최후입사자 from emp where hiredate =(select max(hiredate) from emp)
union all
select ename 최저급여자 from emp where sal = (select min(sal + nvl(comm,0)) from emp)
union all
select ename 최후급여자 from emp where sal = (select max(sal + nvl(comm,0)) from emp);

/* 그룹화하기
	
	1. select절에 그룹함수 이외 컬럼이나 표현식 사용할 경우
		 반드시 group by절에 선언되어야함
	2. group by절에 선언된 컬럼은 select절에 선언되지 않아도 됨
	3. group by절엔 반드시 컬럼명이나 표현식이 사용되어야함
		 즉 컬럼의 별칭 사용 불가
	4. group by절에 사용한 열기준으로 정렬하기 위해 order by 절을 사용하는 경우
		 반드시 group by절 뒤에 선언되어야함
	5. order by절엔 컬럼의 순서, 별칭으로도 선언 가능
*/
select 10, sum(sal) from emp where deptno = 10
union all
select 20, sum(sal) from emp where deptno = 20
union all
select 30, sum(sal) from emp where deptno = 30;

select deptno, sum(sal)
	from emp
	where deptno = 10
	group by deptno;

select sum(sal)
	from emp
	where deptno = 10
	group by deptno;
	
select deptno 부서명, sum(sal)
	from emp
	where deptno = 10
	group by deptno;

select deptno 부서명, sum(sal)
	from emp
	group by deptno
	order by 부서명;

select deptno 부서명, sum(sal)
	from emp
	group by deptno
	order by sum(sal) desc;
	

-- 실습 emp
-- 01) 부서별로 사원수와 급여평균, 급여함계 구하기, 정렬은 부서(deptno)
select deptno, count(*) 사원수, round(avg(sal),0) 급여평균, sum(sal) 총급여
	from emp
	group by deptno
	order by deptno;

-- 02) 직급별로 인원수, 평균급여, 최고급여, 최소급여, 급여합계, 정렬은 직급(job)
select * from emp;
select job, count(ename) 인원수
			, round(avg(sal),0) 평균급여
			, max(sal) 최고급여
			, min(sal) 최소급여
			, sum(sal) 급여합계
	from emp
	group by job
	order by 1;
	
	
/*
	having 조건절 - 그룹결과를 조건별로 조회하기
	
	단일행 함수에서의 조건은 where 사용.
	그룹함수에서의 조건절은 having절 사용
	
	having절에는 집계함수를 가지고 조건을 비교할 경우 사용됨
	having절과 group by절은 함께 사용할 수 있으나 group by절 없이 사용 불가
*/
-- 직급별 평균급여, 평균급여>3000 직급만 조회
select job 직급
	, count(deptno)
	, sum(sal) 직급별합계급여
	, round(avg(sal),0) 직급별평균급여
	, max(sal) 최대급여
	, min(sal) 최소급여
	from emp
	group by job
	having round(avg(sal),0) >= 3000;


-- 실습
-- 1. 부서별 직업별 평균급여, 사원수
-- 2. 부서별			 평균급여, 사원수
-- 3. 총계				 평균급여, 사원수
select 부서, 직급, 평균, 사원수			--하나의 테이블로 만들었기 때문에 부서가 컬럼명임(별칭x)
	from (select deptno 부서, job 직급, round(avg(sal),0) 평균, count(*) 사원수 from emp group by deptno, job
				union all
				select deptno 부서, null, round(avg(sal),0), count(*) from emp group by deptno
				union all
				select null, null, round(avg(sal),0), count(*) from emp) t1
	order by 부서, 직급;
	

-- rollup : 자동으로 소계와 합계를 구해주는 함수
-- group by rollup(deptno, job) -> n+1의 그룹
-- 순서에 주의
select deptno
-- 	, nvl(job,'부서합계')
	, job
	, count(*) 사원수
	, round(avg(sal+nvl(comm,0))) 평균급여
	from emp
	group by rollup(deptno, job);
	
	
	select * from emp;

select deptno
	, job
	, count(*) 사원수
	, round(avg(sal+nvl(comm,0))) 평균급여
	from emp
	group by rollup(job, deptno);


-- 실습
-- professor테이블에서 deptno, postion별로 교수인원수, 급여합계구하기
-- rollup 함수 사용
select * from professor;

select count(*) from professor
group by rollup(deptno, position);

select deptno, position 
	, count(*) 교수인원수
	,sum(pay) 급여합계
	from professor
	group by rollup(deptno, position);



-- cube()
-- 1. 부서별 직급별 사원수 평균급여
-- 2. 부서별			 사원수 평균급여
-- 3.			  직급별 사원수 평균급여
-- 4. 전체				 사원수 평균급여

select deptno, position 
	, count(*) 교수인원수
	,sum(pay) 급여합계
	from professor
	group by cube(deptno, position);
	
	
select deptno
	, job
	, count(*) 사원수
	, round(avg(sal+nvl(comm,0)), 2) 평균급여
	from emp group by rollup(deptno, job);
	
select deptno
	, job
	, count(*) 사원수
	, round(avg(sal+nvl(comm,0)), 2) 평균급여
	from emp group by cube(deptno, job);


/*
	E. 순위함수
	
	1. rank()				: 순위부여함수, 동일처리 1,2,2,4
	2.dense_rank()	: 순위부여함수, 동일처리 1,2,2,3
	3. row_number() : 행번호를 제공하는 함수, 동일처리 불가 1,2,3,4
	
	※ 주의사항 ※
	순위함수는 반드시 order by와 같이 사용
*/
-- 1. rank()
-- 1) 특정자료별로 순위 : rank(조건값) within group(order by 조건값, 컬럼[asc|desc])
-- 2) 전체자료기준 순위 : rank() over(order by 조건값, 컬럼[ascc|desc])

-- 실습
-- 1) 특정조건의 순위
-- SMITH사원이 알파벳순 몇번째인지
select rownum, ename from emp;
select rownum, emp.ename from emp;
select rownum, e.ename from emp e;
select rownum, ename from emp order by ename;
select rownum 로우넘, t1.rn, t1.ename from (select rownum rn, ename from emp order by ename) t1;

select rank('SMITH') within group(order by ename) from emp;
select rank('SMITH') within group(order by ename asc) from emp;
select rank('SMITH') within group(order by ename desc) as 사원명 from emp;

-- 2) 전체자료에서의 순위
-- emp에서 각 사원들의 급여순위는?
-- 급여가 작은순(asc), 급여가 많은순(desc)
select * from emp order by sal;

select ename, sal
	, rank() over(order by sal) --급여 적은순
	, rank() over(order by sal desc) --급여 많은순
	from emp;
	
-- 2. dense_rank()
select ename, sal
	, rank() 			 over(order by sal) --rank()
	, dense_rank() over(order by sal) --dense_rank()
	from emp;

-- 3. row_number() : 행번호
select ename, sal
	, rank() 			 over(order by sal) rank --rank()
	, dense_rank() over(order by sal) dense_rank --dense_rank()
	, row_number() over(order by sal) row_number --row_number()
	from emp;


/*
 E. 누적함수
 
 1. sum(컬럼) over([partition by 컬럼...]order by 멀럼 [asc|desc]) : 누계(누적)를 구하는 함수
 2. ratio_to_report() : 비율을 구하는 함수
*/

-- 1. sum() over()
select * from panmae;
select * from panmae where p_store=1000 order by 1;

-- 1000대리점의 판매일자별 누계액 구하기
select p_date
	, p_code
	, p_qty
	, p_total
	, sum(p_total)
	from panmae
	where p_store=1000
	group by p_date, p_code, p_qty, p_total
	order by 1;
	
select p_date
	, p_code
	, p_qty
	, p_total
	, sum(p_total) over(order by p_date) 일자별판매누계액
	from panmae
	where p_store=1000 order by 1;
	
-- 판매일자별 제품별 판매누계액
select p_date
	, p_code
	, p_qty
	, p_total
	, sum(p_total) over(order by p_date, p_code) 판매누계액
	from panmae
	where p_store=1000 order by 1;
	
-- 제품별/대리점별 기준으로 누계구하기(순서는 판매일자)
select p_code
	, p_store
	, p_date
	, p_total
	, sum(p_total) over(partition by p_code, p_store order by p_date) 판매누계액
	from panmae;


-- 2. ratio_to_report()
-- 판매비율
select p_code
		 , p_store
		 , sum(p_qty) over() 총판매수량
		 , round(ratio_to_report(sum(p_qty)) over() * 100, 2) "수량(%)"
		 , p_total
		 , sum(p_total) over() 총판매금액
		 , round(ratio_to_report(sum(p_total)) over() * 100, 2) "금액(%)"
  from panmae
 group by p_code, p_qty, p_store, p_total;