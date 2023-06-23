select * from user_role_privs;		-- 사용자 권한 조회

select * from emp;

create or replace view z_emp as			-- 기본 view 생성
select ename, job, deptno from emp;

drop view z_emp;
--------------------------------------------------------------------
create or replace view z_emp_dname as			-- 복합 view 생성
select e.ename, d.dname, e.deptno
	from emp e, dept d
	where e.deptno = d.deptno;
	
select * from z_emp_dname;

drop view z_emp_dname;
--------------------------------------------------------------------
select * from emp;

create or replace view z_emp_sal as			--view 생성
select empno 사원번호
		 , ename 사원이름
		 , job 직급
		 , sal 급여
		 , nvl(comm,0) 커미션
	 from emp;
	 
 select * from z_emp_sal;
 select * from z_emp_sal where 직급 = 'CLERK';		--view 사용해서 테이블 중 직급이 CLERK것만 조회
 
 select *
	from (select empno 사원번호											--view없이 쌩으로 비교하기(위에거랑 결과 똑같음
		 , ename 사원이름															-- from절의 서브쿼리가 위에서 view로 대체됨
		 , job 직급
		 , sal 급여
		 , nvl(comm,0) 커미션
	 from emp)
	 where 직급= 'CLERK';
	 
	drop view z_emp_sal;
 --------------------------------------------------------------------
 select * from emp;													--emp 테이블, z_emp_sal 뷰 조회
 select * from z_emp_sal;
 
 select emp.deptno, z_emp.*									--table과 view join
	from emp emp, z_emp_sal z_emp							--z_emp.* <-이런식으로 view의 전체 select 가능
	where emp.empno = z_emp.사원번호;

create or replace view z_test as
 select emp.deptno, z_emp.*									--그대로 view로 만듬 (table과 view를 조인한걸 또 view로 만듦)
	from emp emp, z_emp_sal z_emp	
	where emp.empno = z_emp.사원번호;

select * from z_test;
drop view z_test;
--------------------------------------------------------------------
-- 실습. emp에서 부서번호, dept에서 danme, z_emp_sal와 join
-- 사원번호, 사원이름, 부서명, 직급, 급여 출력
select * from emp;												--각각 테이블,뷰 조회
select * from dept;
select * from z_emp_sal;


create or replace view z_test2 as						-- emp,dept,z_emp_sal 세 가지를 조인해서
select z_emp.사원번호													-- 단순히 각 테이블의 정보를 조회해서 view로 생성
		 , z_emp.사원이름
		 , dpt.dname 부서명
		 , z_emp.직급
		 , z_emp.급여
	from emp emp
		 , dept dpt
		 , z_emp_sal z_emp
  where dpt.deptno = emp.deptno
		and emp.empno = z_emp.사원번호;

select * from z_test2;
drop view z_test2;
--------------------------------------------------------------------
-- 7. inline view															-- select절/from절에 사용
-- 제약사항 : 한개의 컬럼만 정의가능

select emp.ename, dpt.dname										--가장 단순한 테이블 조인
	from emp emp, dept dpt
	where emp.deptno = dpt.deptno;

																							--select절 서브쿼리
select emp.ename, (select dname from dept dpt where emp.deptno = dpt.deptno)
	from emp emp;																--여기서 서브쿼리문 select절의 컬럼에 테이블출처 표기 안해도 되는듯
																							--select절 서브쿼리는 한개의 컬럼만 선택가능
																				--이 경우엔 두 테이블 조인을 위한 where은 서브쿼리에 작성함.


								
select emp.ename, dpt.dname 부서번호											--from절 서브쿼리
	from emp emp, (select deptno, dname from dept) dpt		-- 또다른 테이블처럼 서브쿼리를 from절에 지정
	where emp.deptno = dpt.deptno;												--마찬가지로 서브쿼리 안의 컬럼에 테이블출처 표기안해도 됨

--------------------------------------------------------------------
-- 실습. emp와 dept를 조회 : 부서번호와 부서별최대급여 및 부서명 조회
-- 1) view를 생성
-- 2) inline view로 작성
-- deptno, dname, max_sal : 
-- view이름 : v_max_sal_01
select * from emp;
select * from dept;
--부서번호 : deptno (둘다있음)
--부서별 최대급여 : max(sal) emp테이블
--부서명 : dname dept테이블

create or replace view v_max_sal_01 as											-- select절 inline view
select emp.deptno 부서번호, max(sal) 부서별최대급여, (select dname from dept where emp.deptno = dept.deptno) 부서명
	from emp emp																		-- select절에 적은 서브쿼리는
	group by emp.deptno;																-- group by에서 따로 지정안해줘도 됨

select * from v_max_sal_01;
drop view v_max_sal_01;


create or replace view v_max_sal_01 as
select emp.deptno 부서번호, max(sal) 부서별최대급여, dpt.dname 부서명		-- from절 inline view
	from emp emp, (select dname, deptno from dept) dpt								-- from절에 적은 서브쿼리라
	where emp.deptno = dpt.deptno															-- group by에서 지정해줘야함
	group by emp.deptno, dpt.dname;

select * from v_max_sal_01;
drop view v_max_sal_01;

--선생님 풀이(1)
create or replace view v_max_sal_01 as
select emp.deptno, max_sal, dept.dname													-- from절 inline view(2)
	from dept, (select deptno, sum(sal) max_sal from emp group by deptno order by deptno) emp
	where dept.deptno = emp.deptno;														-- 서브쿼리에서 아예 groupby 로 묶어서 처리가 빠름

select * from v_max_sal_01;
drop view v_max_sal_01;

--선생님 풀이(2)
create or replace view v_max_sal_01 as
select deptno, dname, nvl((select sum(sal) from emp where dept.deptno = emp.deptno group by deptno),0) 부서별최대급여
	from dept;																					-- select절 inline view(2)
																									-- group by 를 서브쿼리에서 지정함
--explain plan for
select * from v_max_sal_01;
drop view v_max_sal_01;
	
/*
 	explain - 실행계획
 	어떤 방식이 빠른지 확인 가능
 	
 	사용 방법 1) 실행할 쿼리 앞에 explain plan for 작성
 				 2) 우클릭 -> 실행 -> 실행계획보기 ( ctrl+shift+E )
 */