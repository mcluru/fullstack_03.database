/*
	 sub query
	 
	 1. Main Query와 반대되는 개념으로 이름을 부여한 것.
	 2. Main Query를 구성하는 소단위 쿼리(종속쿼리)
	 3. subquery안에는 select, insert, delete, update 모두 사용 가능
	 4. sub query의 결과값을 메인쿼리가 사용하는 중간값으로 사용가능
	 5. sub query 자체는 일반쿼리와 같음
	 
	 
	 서브쿼리 종류
	 1. 연관성에 따른 분류
			a. 연관성 있는 쿼리
			b. 연관성 없는 쿼리
	 
	 2. 위치에 따른 분류
			a. inline view : select절/from절 안에 위치하는 쿼리
			b. 중첩쿼리 		 : where절에 위치한 쿼리
		
	 
	 제약사항
	 1. where절 연산자 오른쪽에 위치해야하며 반드시 소괄호()로 묶어야함
	 2. 특수한 경우를 제외하고 sub query절에는 order by 사용 불가
	 3. 비교연산자에 따라서 단일행 sub query(<,>,= ...) 또는 다중행 sub query(in, exists...)
			사용 가능
*/


/* A. 다른 사용자의 객체(table, view, ...) 에 접근권한 부여하기 */

	-- 1. 현재 scott은 hr의 테이블에 접근가능한 권한이 없음
	select * from hr.employees; --(x)ORA-00942: table or view does not exist

	-- 2. hr사용자가 scott에게 employees, departments에 조회권한 부여하기
	-- 1) sysdba권한 or 소유자(hr)가 다른사용자(scott)에게 권한 부여 가능
	-- 2) hr에서 scott에 권한부여
	-- 3) 사용자를 hr로 변경후에 작업하기
	-- 4) 문법 
	--		a. 권한부여 : grant 부여할명령 on 접근허용할객체 to 권한부여받을사용자
	--		b. 권한해제 : revoke 해제할명령 on 해제할객체 from 권한해제될사용자
	grant select on employees to scott;
	grant select on departments to scott;


	select * from employees; --(x) table or view does not exist
	select * from hr.employees; -- 다른사용자걸 가져오기 때문에 어디서 가져왔는지 명시해야함
	select * from hr.departments;
	select * from  hr.countries; -- scott은 hr.countries select권한 없음


	-- 권한해제(hr계정으로)
	revoke select on employees from scott;
	revoke select on departments from scott;


	-- 3. scott에 select 권한을 받은 테이블 조회하기
	-- 다른 사용자(스키마)의 객체에 접근하려면 "스키마.객체이름" 형식으로 접근해야함
	select * from hr.employees;
	select * from hr.departments;




/* B. 단일행 sub query */
-- 실습1. 샤론스톤과 동일한 직급(instructor)인 교수들 조회하기
select * from scott.professor;
select position from scott.professor where position = 'instructor';
select position from scott.professor where name = 'Sharon Stone';

select *
	from scott.professor
	where position = (select position
											from scott.professor
											where name = 'Sharon Stone');


-- 실습2. hr에서 employees, departments를 join해서
-- 사원이름(first_name + last_name), 부서ID, 부서명(inline view)를 조회하기

select * from hr.employees;
select * from hr.departments;


select first_name || '.' || last_name 사원명
		 , e.department_id 부서명
		 , (select department_name from hr.departments dpt where e.department_id = dpt.department_id) 부서이름
	from hr.employees e;



-- 실습3. hr계정 사원테이블에서 평균급(전체사원)보다 작은 사원만 출력
-- 단일행,단일컬럼
select round(avg(salary), 0) from hr.employees emp;

select first_name || '.' || last_name 사원명
		 , salary
	from hr.employees emp
	where salary < (select round(avg(salary), 0) from hr.employees);


/* C. 다중행, 다중열 sub query */
-- 1. 다중행, 단일열
-- hr의 locations, jobs 테이블에 접근할 수 있도록 권한 부여
grant select on hr.locations to scott;
grant select on hr.jobs to scott;

select * from hr.locations;
select * from hr.jobs;

-- 실습1. 부서의 state_province가 null인 부서를 조회
-- 1) locations에서 state_province가 null인 자료(다중행, 단일컬럼)
-- 2) departments를 join해서
-- 3) 부서번호와 부서명 출력

select location_id from hr.locations where state_province is null;
select * from hr.departments dpt;


select dpt.department_id
		 , dpt.department_name
	from hr.departments dpt
	where dpt.location_id in (select location_id
															from hr.locations
															where state_province is null);


-- 실습2. 급여가 가장 많은 사원의 이름, 직급을 출력
-- first_name.last_name, job_title 출력
select * from hr.jobs;
select * from hr.employees;
select max(salary) from hr.employees emp;

select e.first_name || '.' || e.last_name 사원명
		 , j.job_title
	 from hr.jobs j, hr.employees e
	 where j.job_id = e.job_id
		 and e.salary = (select max(salary) from hr.employees);
		 
-- 선생님 풀이
select first_name || '.' || last_name 사원명
		 , emp.salary
		 , job.job_title
	 from hr.employees emp
			, hr.jobs job
	 where emp.salary = (select max(salary) from hr.employees)
		 and emp.job_id = job.job_id;


-- 실습4. 급여가 평균급여보다 많은 사원
-- 미국내(us) 근무하는 사원들에 대한 평균급여
-- 사원명, salary, job_title
select first_name, salary from hr.employees where salary>(select round(avg(salary)) from hr.employees);
select round(avg(salary)) from hr.employees;
select * from hr.employees;
select * from hr.departments;
select * from hr.locations where country_id = 'US';


select first_name || '.' || last_name 사원명
		 , emp.salary
		 , job_title
	from hr.departments dep
		 , hr.locations lo
		 , hr.employees emp
		 , hr.jobs job
	where lo.country_id = 'US'
		and dep.location_id = lo.location_id
		and dep.department_id = emp.department_id
		and job.job_id = emp.job_id
		and emp.salary>(select round(avg(salary)) from hr.employees);



-- 선생님 풀이
select round(avg(emp.salary))
	from hr.employees emp
		 , hr.locations loc
		 , hr.departments dpt
	where loc.country_id = 'US'
		and loc.location_id = dpt.location_id
		and dpt.department_id = emp.department_id;
-------------
select emp.first_name || '.' || last_name 사원명
		 , emp.salary
		 , job.job_title
	 from hr.employees emp
	    , hr.jobs job
		where emp.job_id = job.job_id
				and emp.salary > (select round(avg(emp.salary))
														from hr.employees emp
															 , hr.locations loc
															 , hr.departments dpt
														where loc.country_id = 'US'
															and loc.location_id = dpt.location_id
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
-- 실습1. 부서별 총사원수, 급여총액, 급여평균을 업데이트하기
-- a. 2 step으로 처리
-- 1) 초기화 : 현재일 기준으로 insert(부서별)를 하고, 마감일, 부서번호, 0, 0, 0
-- 2) 초기화 후 update(사원수, 급여총액, 급여평균)
insert into month_salary values(sysdate, 10,0,0,0);
insert into month_salary values(sysdate, 20,0,0,0);
insert into month_salary values(sysdate, 30,0,0,0);
select * from month_salary;

select deptno,count(*) 사원수, sum(sal) 급여총액, round(avg(sal)) 급여평균
	from emp
	group by deptno
	order by deptno;
	
	select * from emp;
	

update month_salary ms
	set ms.emp_count = count(e.empno)
	  , ms.total_salary = sum(e.sal)
		, ms.average_salary = round(avg(e.sal))
	FROM emp e
	where ms.department = (select deptno
													from emp
													group by deptno
													order by deptno);


--선생님 풀이
insert into month_salary
select last_day(sysdate)
     , emp.department_id
		 , 0
		 , 0
		 , 0
  from hr.employees emp
 group by emp.department_id;
 select * from month_salary;

select emp.department_id
		 , count(*)
		 , sum(emp.salary)
		 , round(avg(emp.salary))
  from hr.employees emp
 group by emp.department_id;

update month_salary sal
   set emp_count      
					= (select count(*) from hr.employees emp where emp.department_id = sal.department_id)
     , total_salary   
					= (select sum(emp.salary) from hr.employees emp where emp.department_id = sal.department_id)
     , average_salary 
					= (select round(avg(emp.salary)) from hr.employees emp where emp.department_id = sal.department_id);

 select * from month_salary;



-- b. 1 step으로 처리
delete from month_salary;

update month_salary sal
	 set (emp_count, total_salary, average_salary) 
					= (select count(*)
								  , sum(emp.salary)
								  , round(avg(emp.salary))
							 from hr.employees emp
						  where emp.department_id = sal.department_id);

 select * from month_salary;


/*
	C. 다중행, 다중열 관련 연산자
	
	1. 비교연산자 : in, between, exists
	2. >any : 결과중에서 최소값을 반환
	3. <any : 결과중에서 최대값을 반환
	4. >all : 결과중에서 최대값을 반환
	5. <all : 결과중에서 최소값을 반환
*/

-- 실습1. in연산자
-- a. 비교연산
select dpt.department_name
	from hr.departments dpt
			, hr.locations loc
	where loc.country_id = 'US'
		and loc.location_id = dpt.location_id;
		
-- b. in연산
select dpt.department_name
	from hr.departments dpt
	where dpt.location_id in (select location_id from hr.locations loc where loc.country_id = 'US'); --여기선 이 쿼리가 성능 더 좋음

-- c. any, all연산자
-- salary가 30부서의 최소급여보다 많은 사원을 조회
select min(salary)
	from hr.employees
	where department_id = 30;
	
		-- ↓
-- 1) 비교연산자
select emp.first_name || '.' || emp.last_name 사원명
		 , emp.salary
	from hr.employees emp
	where emp.salary > (select min(salary)
												from hr.employees
												where department_id = 30);
												
		-- ↓

-- 2) >any, <all
select emp.first_name || '.' || emp.last_name 사원명
		 , emp.salary
	from hr.employees emp
	where emp.salary >any (select salary
													from hr.employees
													where department_id = 30);

select emp.first_name || '.' || emp.last_name 사원명
		 , emp.salary
	from hr.employees emp
	where emp.salary <all (select salary
													from hr.employees
													where department_id = 30)


-- salary가 30부서의 최소급여보다 많은 사원을 조회
-- 2) <any, >all
select emp.first_name || '.' || emp.last_name 사원명
		 , emp.salary
	from hr.employees emp
	where emp.salary <any (select salary
													from hr.employees
													where department_id = 30);

select emp.first_name || '.' || emp.last_name 사원명
		 , emp.salary
	from hr.employees emp
	where emp.salary >all (select salary
													from hr.employees
													where department_id = 30)






