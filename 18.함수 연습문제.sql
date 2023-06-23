/* 연습문제 */
-- ex01) 두 숫자를 제공하면 덧셈을 해서 결과값을 반환하는 함수를 정의
-- 함수명은 add_num

create or replace function add_num(p_num1 in number,p_num2 in number) return number is
begin

	return p_num1+p_num2;

end;

select add_num(1,2) from dual;




-- ex02) 부서번호를 입력하면 해당 부서에서 근무하는 사원 수를 반환하는 함수를 정의
-- 함수명은 get_emp_count
select * from emp;

create or replace function get_emp_count(p_deptno in number) return number is
 v_result number;
begin
 select count(ename)
	into v_result
	from emp
	where deptno = p_deptno
	group by deptno;
	
 return v_result;

end;

select get_emp_count(30) from dual;




-- ex03) emp에서 사원번호를 입력하면 해당 사원의 관리자 이름을 구하는 함수
-- 함수명 get_mgr_name
select * from emp;
-- 1) 관리자번호 구하기
-- select mgr 관리자번호 from emp where empno = 7369;
-- 2) 1번을 서브쿼리로 사용해서 관리자 이름 구하기
-- select ename
-- 	from emp
-- 	where empno = (select mgr 관리자번호 from emp where empno = 7369);
-- 

create or replace function get_mgr_name(p_empno in number) return varchar2 is
	v_name varchar2(30);
	
begin
	select ename
		into v_name
		from emp
		where empno = (select mgr 관리자번호 from emp where empno = 7369);
	
	return v_name;

end;

select get_mgr_name(30) from dual;





-- ex04) emp테이블을 이용해서 사원번호를 입력하면 급여 등급을 구하는 함수
-- 4000~5000 A, 3000~4000미만 B, 2000~3000미만 C, 1000~200미만 D, 1000미만 F 
-- 함수명 get_sal_grade
select * from emp;



create or replace function get_sal_grade(p_empno in number) return varchar2 is
	v_sal emp.sal%type;
	v_rank varchar2(10);
begin

	select sal
		into v_sal
		from emp
		where empno = p_empno;
		
	if v_sal between 4000 and 5000 then v_rank := 'A';
		elsif v_sal between 3000 and 4000 then v_rank := 'B';
		elsif v_sal between 2000 and 3000 then v_rank := 'C';
		elsif v_sal between 1000 and 2000 then v_rank := 'D';
		elsif v_sal < 1000 then v_rank := 'F';	
	end if;

	return v_rank;

end;

select get_sal_grade(7369) from dual;




-- ex05) star_wars에 episode를 신규추가등록
-- episode_id = 7, episode_name = '새로운 공화국(New Republic)', open_year=2009
-- 새로운 에피소드를 추가하는 new_star_wars프로시저를 생성
create or replace procedure new_star_wars(p_ep in number, p_ep_name in varchar2, p_year in number) is

begin
	insert into star_wars values(p_ep,p_ep_name,p_year);
end;

call new_star_wars(7, '새로운 공화국(New Republic)',2009);




select * from STAR_WARS;



