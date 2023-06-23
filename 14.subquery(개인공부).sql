/* B. 단일행 sub query */
-- 실습1. 샤론스톤과 동일한 직급(instructor)인 교수들 조회하기
select * from professor;

select position																		--샤론스톤의 직급은 instrunctor
	from professor where name = 'Sharon Stone';
	
	

-- from절 서브쿼리
select pro2.name, pro2.position
	from (select position from professor where name = 'Sharon Stone') pro1
		  , professor pro2
  where pro1.position = pro2.position;
	
-- where절 서브쿼리
select name, position
	from professor
	where position = (select position												--where절에서 비교할 내용을 서브쿼리로 지정
											from professor											--서브쿼리의 select절의 결과를 where절에서 하나의 변수(상수처럼) 쓸 때 사용
											where name = 'Sharon Stone');
											


-- 실습2. hr에서 employees, departments를 join해서
-- 사원이름(first_name + last_name), 부서ID, 부서명(inline view)를 조회하기
select * from hr.employees;
select * from hr.departments;

-- select절 서브쿼리
select first_name||' '||last_name as name, e.department_id, (select department_name from hr.departments d where e.department_id=d.department_id)
	from hr.employees e;
	
	
-- 실습3. hr계정 사원테이블에서 평균급(전체사원)보다 작은 사원만 출력
-- 단일행,단일컬럼
-- where절 서브쿼리
select first_name||' '||last_name as name, salary	
	from hr.employees
	where salary < (select avg(salary) from hr.employees);
	
	
	
/* C. 다중행, 다중열 sub query */
-- 1. 다중행, 단일열

-- 실습1. 부서의 state_province가 null인 부서를 조회
-- 1) locations에서 state_province가 null인 자료(다중행, 단일컬럼)
-- 2) departments를 join해서
-- 3) 부서번호와 부서명 출력

select * from hr.locations;
select * from hr.departments;

select location_id, state_province from hr.locations where state_province is null;

	--단일행과 다중행 연산자 차이 조심
	--한개의 테이블에서의 컬럼값만을 구하므로 따로 join을 안한 것 같음
select *
	from hr.departments																									--다중행 단일열
	where location_id in (select location_id from hr.locations where state_province is null);
	
select *
	from hr.departments																									--단일행
	where location_id = (select location_id from hr.locations where state_province is null and location_id = 2400);
	
	
										
									
-- 실습2. 급여가 가장 많은 사원의 이름, 직급을 출력
-- first_name.last_name, job_title 출력
select * from hr.jobs;
select * from hr.employees;

select max(salary) from hr.employees;

	-- 다른 두개의 테이블에서의 값을 요구하므로 join을 한걸로 보임
	-- 단일행
select first_name||' '||last_name as name, job_title
	from hr.jobs job, hr.employees emp
	where emp.salary = (select max(salary) from hr.employees)
	  and job.job_id = emp.job_id;
		


-- 실습4. 급여가 평균급여보다 많은 사원
-- 미국내(us) 근무하는 사원들에 대한 평균급여
-- 사원명, salary, job_title

select * from hr.employees;
select * from hr.departments;
select * from hr.jobs;
select * from hr.locations where country_id = 'US';
--employees의 name, salary, jobs의 job_title

--us지역 평균
select round(avg(salary),0)
	from hr.departments dpt, hr.locations loc, hr.employees emp
	where loc.country_id = 'US'
	  and dpt.location_id = loc.location_id
		and dpt.department_id = emp.department_id;

--평균급여와 비교하기
--단일행
select first_name||' '||last_name as 사원명, salary, (select job_title from hr.jobs where job_id = hr.employees.job_id) job_title
	from hr.employees
	where salary > (select round(avg(salary),0)
										from hr.departments dpt, hr.locations loc, hr.employees emp
										where loc.country_id = 'US'
											and dpt.location_id = loc.location_id
											and dpt.department_id = emp.department_id);
							


-- 2. 다중행, 다중열을 이용한 update 처리
create table month_salary(
		magam_date				date not null /*마감일*/
	, department_id				number				/*부서번호*/
	, emp_count					number				/*사원수*/
	, total_salary			number				/*급여총액*/
	, average_salary		number				/*급여평균*/
);
select * from month_salary;
drop table month_salary;
delete from month_salary;


-- 실습1. 부서별 총사원수, 급여총액, 급여평균을 업데이트하기
-- a. 2 step으로 처리
-- 1) 초기화 : 현재일 기준으로 insert(부서별)를 하고, 마감일, 부서번호, 0, 0, 0
insert into month_salary									--insert values 부분에 select절 넣을 수 있음.
	select last_day(sysdate)								--근데 넣을 수 있단 내용 어디있었지?
		  , e.department_id									--'-`
		  , 0
		  , 0
		  , 0
	  from hr.EMPLOYEES e
	 where e.DEPARTMENT_ID is not null
	 group by e.DEPARTMENT_ID;

select * from month_salary;
select * from hr.EMPLOYEES;
-- 2) 초기화 후 update(사원수, 급여총액, 급여평균)
update month_salary
	set emp_count = (select count(*) from hr.EMPLOYEES where department_id = month_salary.department_id group by department_id)
	  , total_salary = (select sum(salary) from hr.EMPLOYEES where department_id = month_salary.department_id group by department_id)
		, average_salary = (select round(avg(salary),1) from hr.EMPLOYEES where department_id = month_salary.department_id group by department_id);



-- b. 1 step으로 처리
select * from month_salary;
select * from hr.EMPLOYEES;

insert into month_salary
	select last_day(sysdate)	
			 , e.department_id
			 , count(*)
			 , sum(e.salary)
			 , round(avg(salary),1)
	from hr.EMPLOYEES e
	where e.DEPARTMENT_ID is not null
	group by e.DEPARTMENT_ID;

/*
	다중행(단일열+다중열) 연산자
	in : =
	>any : 최소값 반환
	<any : 최대값 반환
	<all : 최소값 반환
	>all : 최대값 반환
*/


-- 실습1. in연산자
-- a. 비교연산
select * from hr.departments;
select * from hr.locations;

select dpt.department_name
	from hr.departments dpt
		 , hr.locations loc
	where loc.country_id = 'US'												--작은 범위로 먼저 축소시키고
	  and loc.location_id = dpt.location_id;					--테이블조인


select location_id from hr.locations where country_id = 'US';

-- b. in연산
select dpt.department_name
	from hr.departments dpt
	where dpt.location_id in (select location_id from hr.locations where country_id = 'US'); --이 쿼리가 성능이 더 좋다고함


-- c. any, all연산자
-- salary가 30부서의 최소급여보다 많은 사원을 조회
select * from hr.employees;

	-- 단일행 단일열 (<)
select min(salary)
	from hr.employees
	where department_id = 30						--먼저 30부서의 최소급여를 구하고(단일행 단일열)
	group by department_id;

select first_name||' '||last_name
			, salary
	from hr.employees										-- where절 서브쿼리로 사용
	where salary > (select min(salary) from hr.employees where department_id = 30 group by department_id);

	-- 다중행
select salary
	from hr.employees										-- 30qntjdml 급여들을 구하고 (다중행 단일열)
	where department_id = 30;

select first_name||' '||last_name
			, salary
	from hr.employees										-- 구한것의 최소값을 전체 급여와 비교함
	where salary >any (select salary from hr.employees where department_id = 30);








