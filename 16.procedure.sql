/*
	A. PL/SQL?
	오라클의 Procedure Language extension to SQL의 약자.
	SQL문장에서 변수정의, 조건처리(if), 반복처리(for, loop, while)등을 지원하며
	절차형 언어(procedure Language)라고 함
	
	declare문을 이용하여 정의하고, 선언문은 사용자가 정의한다.
	PL/SQL문은 블럭구조로 되어있고, PL/SQL에서 자체 compile엔진을 가지고 있다.
	
	1. PL/SQL의 장점
		1) block구조로 다수의 SQL문을 한번에 Oracle DB서버로 전송해서 처리하기 때문에 처리속도가 빠름
		2) PL/SQL의 모든 요소는 하나 또는 두개 이상의 블럭으로 구성하여 모듈화 가능
		3) 보다 강력한 프로그램을 작성하기 위해 큰 블럭안에 소블럭을 위치시킬 수 있음
		4) variable(변수), constant(상수), cursor(커서), exception(예외처리) 등을 정의할 수 있고
				SQL문장과 procedure문장에서 사용할 수 있다
		5) 변수선언은 테이블의 데이터구조와 컬럼명을 이용하여 동적으로 변수선언할 수가 있다.
		6) exception처리를 이용해 oracle server error처리를 할 수 있다.
		7) 사용자가 에러를 정의할 수 있고, exception처리를 할수 있다.
		
		
	2. PL/SQL의 구조
		1) PL/SQL은 프로그램을 논리적인 블럭으로 나눈 구조화된 언어.
		2) 선언부(declare, 선택), 실행부(begin ... end, 필수), 예외(exceptio, 선택)로 구성됨.
				특히, 실행부는 반드시 기술을 해야함
		3) 문법 : declare
						  -선택부분
						  -변수, 상수, 커서, 사용자예외처리
						 begin
						  -필수부분
							-PL/SQL문장을 기술(select, if, for ...)
						 exception
						  -선택부분
							-예외처리로직 기술
						 end;
						 
						 
	3. PL/SQL의 종류
		1) anonymous block(익명블럭) : 이름이 없는 블럭. 보통 1회성으로 실행되는 블럭(재사용 불가)
		2) strored procedure : 매개변수를 전달받을 수 있고 재사용 가능. 보통 연속실행하거나 구현이 복잡한 트랜직션 수행하는 pl/SQL블럭
													 "데이터베이스 서버 안에 저장"됨. 처리속도가 빠름. 저장되어있단 의미로 stored procedure라고 함
		3) function : procedure와 유사하지만 처리결과를 호출한 곳으로 반환해주는 값이 있다는 차이가 있음. 단, in 파라미터만 사용가능.
									반드시 반환될 값의 데이터타입을 return문 안에 선언 필수. PL/SQL블럭내에서 return문을 사용하여 반드시 값을 리턴해야 함
		4) package : 오라클 데이터베이스 서버에 저장되어 있는 procedure와 function의 집합.
								 선언부와 본문 두 부분으로 나누어 관리함
		5) trigger : insert, delete, update등이 특정 테이블에서 실행될 때 자동으로 수행하도록 정의한 프로시저. 트리거는 테이블과 별도로 database에 저장(객체)된다.
								 오직 table에 대해서만 정의 가능
  
	
	4. 생성문법 : create or replace procedure[function] 프로시저(펑션)명 is[as]
							begin
							end
*/

-- 1. procedure/function 생성 및 실행
create or replace procedure pro_01 is
begin
	dbms_output.put_line('Hello World');
end;


-- 실행방법
-- exec pro_01 : SQL*pluse에서 사용되는 오라클 명령. 즉, 표준명령x


-- 2. exception
create or replace procedure pro_02 is
	v_counter integer;   --변수를 선언(변수명과 데이터타입)
begin
	v_counter := 10;    -- 변수초기화
	v_counter := v_counter+10;
	dbms_output.put_line('Counter = ' || v_counter);
	v_counter := v_counter/0;
exception when others then
	dbms_output.put_line('0으로 나눌 수가 없습니다');

end;


-- 3. if
create or replace procedure pro_03 is
	isSuccess boolean;
begin
	isSuccess := true;  --true, false
	if isSuccess
		then dbms_output.put_line('성공했습니다');
		else dbms_output.put_line('실패했습니다');
	end if;
end;


-- 4. for
-- 반복문 : loop, while
create or replace procedure pro_04 is
begin

	for i in 1..10 loop
		dbms_output.put_line('i = '||i);
	end loop;
end;

-- https://coding-factory.tistory.com/452
-- loop문 등 문법



/*
	B. PL/SQL 데이터타입
	
	1. 스칼라(scalar) : 단인 data type과 데이터별수 %type이 있음
			
			일반데이터타입
			1) 선언방법 : 변수명 [constant] 데이터타입 [not null] [:= 상수값 or 표현식]
					ex) counter constant integer no null := 10 + 10;
			2) 변수명(variable or identifier)의 이름은 SQL명명규칙을 따름
			3) identifier를 상수로 지정하고 싶은 경우 constant라는 키워드로 명시적으로 선언하고
					상수는 반드시 초기값을 할당해야함
			4) not null로 정의되어 있다면 초기값을 반드시 지정, 정의되어있지 않을 경우 초기값 생략 가능
			5) 초기값은 할당연산자(:=)를 사용하여 지정
			6) 일반적으로 한줄에 한개의 identifier를 정의함
			7) 일반변수의 선언방법
					v_pi constant number(7,6) := 3.131492;
					v_price constant number(4,2) := 12.34;
					v_name varchar2(10);
					v_flag boolean not null := true;
			
			
	2. %type
			1) DB테이블의 컬럼의 데이터타입을 모를 경우에도 사용할 수 있고 테이블의 컬럼의 데이터타입이 변경될 경우에도 수정할 필요없이 사용 가능
			2) 이미 선언된 다른 변수나 테이블의 컬럼을 이용해 선언(참조)할 수 있음
			3) DB테이블과 컬럼, 이미 선언한 변수명이 %type앞에 올 수 있음.
			4) %type속성을 이용하는 장점은
					... table의 column속성을 정확히 알지 몰할 경우에도 사용가능.
					... table의 column속성이 변경되어도 PL/SQL 수정할 필요 없음
			5) 선언방법 : v_empno   emp.empno%type;
			
			
	3. %rowtype
			하나 이상의 데이터값을 갖는 데이터형으로 배열과 비슷한 역할. 재사용 가능
			%rowtype 데이터형과 PL/SQL 테이블과 레코드는 복합데이터형에 속함
			
			1) 테이블이나 뷰 내부컬럼의 데이터형, 크기, 속성등을 그대로 사용가능
			2) %rowtype 앞에는 테이블(뷰)명이 옴
			3) 지정된 테이블의 구조와 동일한 구조를 갖는 변수 선언 가능
			4) 데이터베이스 컬럼들의 갯수나 datatype을 알지 못할때 사용하면 편함
			5) 테이블의 컬럼 데이터타입이 변경되어도 PL/SQL을 변경할 필요 없음
			6) 선언방법 : v_emp   emp%rowtype;
										--> v_emp.ename;
	
	
	4. table타입
		PL/SQL에서 table타입은 db에서의 table과 성격이 다르다. PL/SQL에서 table은 1차원 배열이다
		table은 크기에 제한이 없으며 row의 수는 데이터가 추가되면 자동으로 증가된다.
		binary_integer타입(-인덱스라고 이해하면 편함-)의 인덱스번호로 순서가 정해짐. 하나의 테이블엔 한개의 컬럼데이터만 저장가능
		
		선언방법
			1) 데이터 타입(테이블)선언
					type 테이블타입명 is table of varchar2(20) index by binary_integer;  -> 사용자가 데이터타입을 새로 만든것.
			2) 변수선언
					v_emp_name_tab 테이블타입명; 			-> 사용자가 만든 새로운 데이터타입(테이블타입)으로 변수 선언.
																			 테이블타입으로 변수 선언한단 의미에서 변수명 뒤에 _tab 붙입
		  3) %rowtype으로 table타입을 선언
					type 테이블타입명 is table of emp%rowtype index by binary_integer;
					v_emp_tab 테이블타입병
		
		
	5. record타입
		1) 여러개의 데이터타입을 갖는 변수들의 집합.
		2) 스칼라, 테이블 or 레코드타입 중 하나 이상의 요소로 구성
		3) 논리적 단위로 컬럼들의 집합을 처리할 수 있도록 함
		4) PL/SQL table과는 다르게 개별 필드의 이름을 부여, 선언 시 초기화 가능함.
		5) 선언방법
				type 레코드타입명 is record(
					coll 데이터타입 [no null {:= 값 | 표현식}],
					...
					coln 데이터타입 [no null {:= 값 | 표현식}],
				)
*/
-- PL/SQL에서 사용되는 select문법은 일반 SQL의 select문법과 다름
-- a. 일반 SQL
select * from emp;

-- b. PL/SQL
select coll, ... coln into var1,...varn       --컬럼(col)과 변수(var)의 개수는 동일해야함
	from emp;



-- 1. 스칼라데이터타입
-- 1) 일반데이터타입 vs %type

create or replace procedure pro_05 is
	v_empno		number;					 -- 일반타입
	v_ename		emp.ename%type;  -- 참조타입 %type
	v_sal			emp.sal%type;     -- 참조타입 %type
begin
	-- 한 개의 사원정보를 읽어서 출력
	select emp.empno, emp.ename, emp.sal
		into v_empno, v_ename, v_sal
		from emp 
		where emp.ename = 'SMITH';
		
		dbms_output.put_line('사원번호 = ' || v_empno);
		dbms_output.put_line('사원이름 = ' || v_ename);
		dbms_output.put_line('사원급여 = ' || v_sal);
end;


select emp.empno, emp.ename, emp.sal
-- 		into v_empno, v_ename, v_sal
		from emp 
		where emp.ename = 'SMITH';


--2. %rowtype
create or replace procedure pro_06 is
	v_emp_row emp%rowtype;
begin
	select *
	into v_emp_row
	from emp 
	where emp.empno = 7499;
	
	dbms_output.put_line('사원번호 = ' || v_emp_row.empno);
	dbms_output.put_line('사원이름 = ' || v_emp_row.ename);
	dbms_output.put_line('사원급여 = ' || v_emp_row.sal);
	dbms_output.put_line('커미션 = ' || v_emp_row.comm);
	dbms_output.put_line('입사일자 = ' || v_emp_row.hiredate);
	dbms_output.put_line('부서번호 = ' || v_emp_row.deptno);
end;


--3. record type 
-- record : empno, ename, sal, hiredate을 저장할 데이터타입 선언
-- 	type 레코드명 is record(coll 데이터타입, ... coln 데이터타입);
create or replace procedure pro_07 is
--1step : 사용자가 새로운 데이터타입 작성
	type emp_rec is record(
			v_empno				number
		, v_ename				varchar2(30)
		, v_sal					number
		, v_hiredate		date
	);

-- 2step : 변수선언
v_emp_rec emp_rec;

begin
	select empno, ename, sal, hiredate
		into v_emp_rec.v_empno, v_emp_rec.v_ename, v_emp_rec.v_sal, v_emp_rec.v_hiredate
		from emp
		where emp.ename = 'KING';

	dbms_output.put_line('사원번호 = ' || v_emp_rec.v_empno);
	dbms_output.put_line('사원이름 = ' || v_emp_rec.v_ename);
	dbms_output.put_line('사원급여 = ' || v_emp_rec.v_sal);
	dbms_output.put_line('입사일자 = ' || v_emp_rec.v_hiredate);
	dbms_output.put_line('-----------------------');
	
	select empno, ename, sal, hiredate
		into v_emp_rec
		from emp
		where emp.ename = 'KING';
	
	dbms_output.put_line('사원번호 = ' || v_emp_rec.v_empno);
	dbms_output.put_line('사원이름 = ' || v_emp_rec.v_ename);
	dbms_output.put_line('사원급여 = ' || v_emp_rec.v_sal);
	dbms_output.put_line('입사일자 = ' || v_emp_rec.v_hiredate);
end;



-- 4. table 타입(한건, 한개의 컬럼을 정의)
-- type 테이블타입명 is table of 테이블한개의컬럼 index by binary_integer;
-- 1차원배열과 유사
create or replace procedure pro_08 is
	-- 1step : table타입 작성
	type tbl_emp_name is table of hr.employees.first_name%type index by binary_integer;
	
	-- 2step : 변수선언
	v_name		tbl_emp_name;	
	v_name_1		varchar2(20);   --위에거랑 랑 같지만 위에거가 index여서 속도가 빠름
begin
	select first_name
		into v_name_1
		from hr.employees
		where employee_id = 100;
		
		dbms_output.put_line('사원이름 = ' || v_name_1);
		dbms_output.put_line('-----------------------');
		
		v_name(0) := v_name_1;
		v_name(1) := '홍길동';
		v_name(2) := '손흥민';
		
		dbms_output.put_line('사원이름 = ' || v_name(0));
		dbms_output.put_line('사원이름 = ' || v_name(1));
		dbms_output.put_line('사원이름 = ' || v_name(2));
end;



-- 5. table 타입(여러건, 한개의 컬럼을 정의)
create or replace procedure pro_09 is
-- 1step : table타입 작성
	type e_table_type is table of hr.employees.first_name%type index by binary_integer;
	
	-- 2step : 변수선언
	v_tab_type		e_table_type;		--배열
	idx							binary_integer := 0;
begin
	
	for name in (select first_name || '.' || last_name as empname from hr.employees order by first_name) loop
		idx := idx+1;
		v_tab_type(idx) := name.empname;		--name은 %rowtype으로 처리됨. 그래서 name만 있으면 안됨
	end loop;
	
	for i in 1..idx loop
		dbms_output.put_line('사원이름 = ' || v_tab_type(i));
	end loop;
end;	


-- 6. table 타입(여러건, 여러개의 컬럼을 정의)
-- emp테이블에서 사원명, 직급 출력
create or replace procedure pro_10 is
	type tab_name_type is table of emp.ename%type index by binary_integer;
	type tab_job_type is table of emp.job%type index by binary_integer;
	
	v_name_table		tab_name_type;
	v_job_table			tab_job_type;
	
	idx							binary_integer := 0;
begin
	for name_job in(select ename, job from emp order by ename) loop
		idx := idx+1;
		v_name_table(idx) := name_job.ename;
		v_job_table(idx) := name_job.job;
	end loop;
	
	dbms_output.put_line('========================');
	dbms_output.put_line('사원이름' || chr(9) || '직급');
	dbms_output.put_line('========================');
	
	for i in 1..idx loop
		dbms_output.put_line(v_name_table(i) || chr(9) || v_job_table(i));
	end loop;
	
	exception when others then
		dbms_output.put_line('에러입니다');
end;



-- 실습1. hr.employees 와 hr.departments 읽어서
-- 사원이름(f_name.last_name)과 부서명 출력
-- 사원이름 chr(9) 부서이름

create or replace procedure pro_11 is
	type tab_name_type is table of hr.employees.first_name%type index by binary_integer;
	type tab_dname_type is table of hr.departments.department_name%type index by binary_integer;
	
	v_name_table		tab_name_type;
	v_dname_table		tab_dname_type;
	
	idx							binary_integer := 0;
begin
-- 	for name_dname in(select e.first_name || '.' || e.last_name as empname, d.department_name as depname from hr.employees e, hr.departments d where e.department_id = d.department_id) loop
-- 	idx := idx+1;
-- 	v_name_table(idx) := name_dname.empname;
-- 	v_dname_table(idx) := name_dname.depname;
-- 	end loop;
	
	for myname in(select first_name || '.' || last_name as empname from hr.employees),
			mydname in(select department_name as depname from hr.departments) loop
	idx := idx+1;
	v_name_table(idx) := myname.empname;
	v_dname_table(idx) := mydname.depname;
	end loop;
	
-- 	for mydname in(select department_name as depname from hr.departments) loop
-- 	v_dname_table(idx) := mydname.depname;
-- 	end loop;
	
	
	dbms_output.put_line('========================');
	dbms_output.put_line('사원이름' || chr(9) || '부서명');
	dbms_output.put_line('========================');
	
	for i in 1..idx loop
		dbms_output.put_line(v_name_table(i) || chr(9) || v_dname_table(i));
	end loop;
	
	exception when others then
		dbms_output.put_line('에러입니다');
end;

-- ↑↑↑↑풀이 안해주심



-- 7. table 타입을 %rowtype을 선언
-- dept테이블의 내용을 출력
create or replace procedure pro_11 is
	type t_dept is table of dept%rowtype index by binary_integer;
	
	v_dept						t_dept;
	idx								binary_integer := 0;
	
begin
	for dept_list in (select * from dept order by dname) loop
		idx := idx+1;
-- 		v_dept(idx).deptno := dept_list.deptno;
-- 		v_dept(idx).dname := dept_list.dname;
-- 		v_dept(idx).loc := dept_list.loc;
		v_dept(idx) := dept_list;
	end loop;
	
	for i in 1..idx loop
		dbms_output.put_line('부서번호' || v_dept(i).deptno || chr(9) ||
												 '부서이름' || v_dept(i).dname || chr(9) ||
												 '부서위치' || v_dept(i).loc);
	end loop;

	exception when others then
		dbms_output.put_line('에러입니다');
end;





/*
	C. 제어문(if, case)
	
	1. 단순 if : if ~ end if;
	2. if ~ then ~ else ~ end if;
	3. if ~ elsif ~ elsif ~ end if;
*/

-- 1. 댠순 if
-- hr.employees 에서 10=총무부, ... 40=인사부
create or replace procedure pro_12 is
	v_emp_id				hr.employees.employee_id%type;
	v_name					hr.employees.first_name%type;
	v_dept_id				hr.employees.department_id%type;
	v_dname					varchar2(20);
begin
	
	select employee_id, first_name||'.'||last_name name, department_id
		into v_emp_id, v_name, v_dept_id
		from hr.employees
		where employee_id = 203;
	
	if(v_dept_id = 10) then
		v_dname := '총무부';
		end if;
	if(v_dept_id = 20) then
		v_dname := '마켓팅';
		end if;
	if(v_dept_id = 30) then
		v_dname := '구매부';
		end if;
	if(v_dept_id = 40) then
		v_dname := '인사부';
		end if;
	
	dbms_output.put_line(v_name||'의 부서는 '||v_dname||'입니다');


	exception when others then
		dbms_output.put_line('에러입니다');
end;


--2. if ~ then ~ else ~ end if
-- hr.employees에서 commission이 있으면 보너스를 지급, 없으면 지급안하기
create or replace procedure pro_13 is
    v_name hr.employees.first_name%type;
    v_bonus hr.employees.commission_pct%type;
begin
    for emp in (select first_name||'.'||last_name name, nvl(commission_pct, 0) bonus
                from hr.employees) loop
        v_name := emp.name;
        v_bonus := emp.bonus;
        if (v_bonus <> 0) then
            dbms_output.put_line(v_name||'의 보너스는 '||v_bonus||'입니다');
        else
            dbms_output.put_line(v_name||'의 보너스는 없습니다');
        end if;
    end loop;
exception
    when others then
        dbms_output.put_line('에러입니다');
end;



-- 선생님 풀이
create or replace procedure pro_13 is
	v_emp_id		hr.employees.employee_id%type;
	v_name			hr.employees.first_name%type;
	v_sal				hr.employees.salary%type;
	v_comm			hr.employees.commission_pct%type;
	v_bonus			number;
begin
	select employee_id
			 , first_name||'.'||last_name name
			 , salary
			 , nvl(commission_pct, 0)
			 , salary * nvl(commission_pct, 0)
		into v_emp_id
			 , v_name
			 , v_sal
			 , v_comm
			 , v_bonus
		from hr.employees
		where employee_id = 145;
		
		if(v_comm > 0)
		then dbms_output.put_line(v_name||'사원의 보너스는 '||v_bonus||'입니다');
		else dbms_output.put_line(v_name||'사원의 보너스는 없습니다');
		end if;

exception
    when others then
        dbms_output.put_line('에러입니다');
end;




-- 3. if ~ elsif ~ elsif ~ end if
-- hr.employees 에서 10=총무부, ... 40=인사부
create or replace procedure pro_14 is
	v_emp_id				hr.employees.employee_id%type;
	v_name					hr.employees.first_name%type;
	v_dept_id				hr.employees.department_id%type;
	v_dname					varchar2(20);
begin
	
	select employee_id, first_name||'.'||last_name name, department_id
		into v_emp_id, v_name, v_dept_id
		from hr.employees
		where employee_id = 203;
	
	if(v_dept_id = 10) then
		v_dname := '총무부';
	elsif(v_dept_id = 20) then
		v_dname := '마켓팅';
	elsif(v_dept_id = 30) then
		v_dname := '구매부';
	elsif(v_dept_id = 40) then
		v_dname := '인사부';
		end if;
	
	dbms_output.put_line(v_name||'의 부서는 '||v_dname||'입니다');


	exception when others then
		dbms_output.put_line('에러입니다');
end pro_14;



-- 4. case
create or replace procedure pro_15 is
	v_emp_id				hr.employees.employee_id%type;
	v_name					hr.employees.first_name%type;
	v_dept_id				hr.employees.department_id%type;
	v_dname					varchar2(20);
begin
	
	select employee_id, first_name||'.'||last_name name, department_id
		into v_emp_id, v_name, v_dept_id
		from hr.employees
		where employee_id = 203;
		
	v_dname := case v_dept_id
							when 10 then '총무부'
							when 20 then '마켓팅'
							when 30 then '구매부'
							when 40 then '인사부'
							end;
	
	dbms_output.put_line(v_name||'의 부서는 '||v_dname||'입니다');


	exception when others then
		dbms_output.put_line('에러입니다');
end pro_15;




/*
	D. 반복문(loop, for, while)
	
	loop		--javascript의 do while과 동일
	end loop
	
	for i in 1..n loop
	end loop
	
	while 조건 loop
	end loop
	
*/

--1. loop
create or replace procedure pro_16 is
	cnt number := 0;
	
begin
	loop
		cnt := cnt+1;
		dbms_output.put_line('현재번호는 = '||cnt);
		exit when cnt >= 10;
	end loop;

	exception when others then
		dbms_output.put_line('에러입니다');
end pro_16;



-- 2. while
create or replace procedure pro_17 is
	cnt number := 0;
	
begin
	while cnt < 10 loop
		cnt := cnt+1;
		dbms_output.put_line('현재번호는 = '||cnt);
	end loop;

	exception when others then
		dbms_output.put_line('에러입니다');
end pro_17;


-- 함수나 프로시저를 호출 일반적인 명령
call pro_17();


-- 3. for
-- for 카운트(i) in [reverse] start..end loop
-- end loop;
-- for 객체리스트 in (select ~~) loop
-- end loop;
create or replace procedure pro_18 is
	
begin
	for cnt in 1..10 loop
		dbms_output.put_line('현재번호는 = '||cnt);
		end loop;

	exception when others then
		dbms_output.put_line('에러입니다');
end pro_18;
call pro_18();


/*
	E. in 배개변수가 있는 procedure
	
	create or replace procedure 프로시저명(arg1 in 데이터타입, ... argn in 데이터타입) is
	begin
	end;
*/

-- 1. 사원번호와 급여인상율(10%)을 전달받아서 해당사원의 급여를 인상하는 procedure
create or replace procedure update_sal_emp(p_empno in number, p_percent in number) is
	v_bef_sal 		number;
	v_aft_sal 		number;
	v_ename 			emp.ename%type;
	
begin
	dbms_output.put_line('사원번호는 = '||p_empno);
	dbms_output.put_line('인상율 = '||p_percent);
	
	select sal
		into v_bef_sal
		from emp
		where empno = p_empno;
		
	dbms_output.put_line('인상전 급여 = '||v_bef_sal);
	
	update emp
		set sal = sal+(sal*p_percent / 100)
		where empno = p_empno;
	
	commit;
	
	select sal
		into v_aft_sal
		from emp
		where empno = p_empno;
		
	dbms_output.put_line('인상후 급여 = '||v_aft_sal);
	
	select sal, ename
		into v_aft_sal, v_ename
		from emp
		where empno = p_empno;
	
	dbms_output.put_line('--------------------------------');
	dbms_output.put_line(v_ename||'('||p_empno||')'||'사원의 인상전 급여 = '||v_bef_sal ||
											', 인상후 급여 = '||v_aft_sal);	
	
	
	exception when others then
		dbms_output.put_line('에러입니다');
		
end update_sal_emp;
call update_sal_emp(7369,10);



-- 실습 emp에서 10번부서의 사원 급여를 15% 인상후 급여 출력
-- 프로시저명 : pro_sal_raise
-- for문, type is table of
-- '사원번호 chr(9) 사원이름 chr(9) 인상급여' 형태로 출력
create or replace procedure pro_sal_raise(p_deptno in number) is
	type e_sal_type is table of emp.sal%type index by binary_integer;

	v_ename 			emp.ename%type;
	v_empno 			emp.empno%type;
begin
	
	update emp
		set sal = sal+(sal*15 / 100)
		where deptno = p_deptno;
	for mycnt in (select sal, empno, ename
							from emp
							where deptno = p_deptno) loop
	
		dbms_output.put_line(empno||chr(9)||ename||chr(9)||sal);
	end loop;

	exception when others then
		dbms_output.put_line('에러입니다');
		
end pro_sal_raise;
call pro_sal_raise(10);

select * from emp;


-- 선생님 풀이
create or replace procedure pro_sal_raise(p_deptno in number, p_percent in number) is
	type t_emp is table of emp%rowtype index by binary_integer;
	v_emp 	t_emp;
	i 			binary_integer :=0;
begin
	dbms_output.put_line('부서번호 = '|| p_deptno);
	dbms_output.put_line('인상률 = '|| p_percent);
	
	update emp
		set sal = sal+(sal*p_percent / 100)
		where deptno = p_deptno;
		
	commit;
	
	for emp_list in (select * from emp where deptno = p_deptno) loop
		i := i+1;
		v_emp(i) := emp_list;
-- 		v_emp(i).empno := emp_list.empno;
-- 		v_emp(i).ename := emp_list.ename;
-- 		v_emp(i).sal := emp_list.sal;
	end loop;
	
	dbms_output.put_line('=============================');
	dbms_output.put_line('사원번호' || chr(9) || '사원이름' || chr(9) || '인상후급여');
	dbms_output.put_line('=============================');
	
	
	for j in 1..i loop
		dbms_output.put_line(v_emp(j).empno ||chr(9)|| v_emp(j).ename || chr(9) || v_emp(j).sal);
	end loop;
		


exception when others then
		dbms_output.put_line('에러입니다');
		
end pro_sal_raise;
call pro_sal_raise(10,15);


-- data dictionary
-- 소유객체 목록
select * from user_objects;
select distinct object_type from user_objects;
select * from user_objects where object_type = 'PROCEDURE' order by object_name;




/*
	F. in, out 매개변수가 있는 프로시저 생성하기
	
	create or replace procedure pro_sal_raise(p_deptno in number, p_percent out number) is
	begin
	end;
*/
-- in, out 매개변수
-- 사원번호를 전달받아서 사원명과 급여, 직책을 리턴 procedure
create or replace procedure emp_sal_job(
		p_empno in number
	, p_ename out varchar2
	, p_sal out number
	, p_job out varchar2) is
	
begin
	select ename, sal, job
		into p_ename, p_sal, p_job
		from emp
		where empno = p_empno;
		
	
	exception when others then
		dbms_output.put_line('에러입니다');
		
end emp_sal_job;

call emp_sal_job(7369); -- 에러 : wrong number or types of arguments in call to 'EMP_SAL_JOB' 매개변수 개수가 다름

-- in, out매개변수가 있는 프로시저는 PL/SQL 내부에서 사용해야함
declare
	v_ename 		varchar2(20);
	v_sal 			number;
	v_job 			varchar2(20);
begin
	-- 프로시저 내부에서는 exec, execute, call을 사용불가
	-- 프로시저명으로 호출해야함.
	emp_sal_job(7369,v_ename, v_sal, v_job);
	dbms_output.put_line('사원이름 = '||v_ename ||chr(9)|| ', 사원급여 = '||v_sal || chr(9) || ', 직급 = '||v_job);
end;