/*
	Function?
	
	1. function
		보통 값을 계산하고 그 결과를 반환하기 위해 사용함.
		대부분 procedure와 유사하지만
		
		1) in 파라미터만 사용가능
		2) 반드시 반환될 값의 데이터 타입을 return문에 선언해야함
		
		
	2. 문법
		1) PL/SQL 블럭안에는 적어도 한개의 return문이 있어야함
		2) 선언방법
			create or replace function 펑션이름(arg1 in 데이터타입, ...)
			return 데이터타입 is[as]
				변수선언...
			[pragma autonomous_transaction]
			begin
			end [펑션이름];
			 
			 
	3. 주의사항
		오라클함수 즉, function에선 기본적으로 DML(insert, update, delete)문 사용불가
		만약 사용하고 싶을땐 begin 바로위에 pragma autonomous_transaction을 서언하면 사용가능
		
	
	4. procedure vs function
	
		procedure															function
		--------------------------------			------------------------------------
		서버에서 실행(속도가 빠름)									클라이언트에서 실행
		return값이 있어도, 없어도 됨								return값 필수
		return값이 여러개(out 여러개)							return값 하나만 가능
		파라미터는 in, out												파라미터는 in만
		select절에 사용불가												select절에서 사용가능
		  --> call, execute											--> select 펑션() from dual;								
*/

-- 실습1. 사원번호 입력받아서 급여를 10% 인상하는 함수 작성
create or replace function fn_01(p_empno in number) return number is
	v_sal number;
	
pragma autonomous_transaction;
begin
	update emp
		set sal = sal*1.1
		where empno = p_empno;
	
	commit;
	
	select sal
		into v_sal
		from emp
		where empno = p_empno;
		
	return v_sal;

end fn_01;

select * from emp;
select fn_01(7369) from dual;
-- call fn_01(7369); --procedure는 call로 호출 가능하지만 function은 호출불가


-- 실습2. 부피를 계산하는 함수 fn_02
-- 부피 = 길이*넓이*높이
create or replace function fn_02(p_length in number, p_area in number, p_height in number) return number is
v_volume number;
begin
	v_volume := p_length * p_area * p_height;
	
	return v_volume;
end fn_02;


select fn_02(10,10,10) from dual;
-- sql*plus : execute fn_02(10,10,10);


--실습3. 현재일을 입력받아서 해당월의 마지막일자를 구하는 함수
create or replace function fn_03(mydate in date) return date is
v_lastdate date;
-- v_lastday varchar2

begin
	v_lastdate := LAST_DAY(mydate);
	
	return v_lastdate;
end fn_03;

select fn_03(sysdate) from dual;


--선생님 풀이
create or replace function fn_03(p_date in date) return date is
	v_result date;

begin
	v_result := add_months(p_date, 1) - to_char(p_date, 'dd');
	
	return v_result;
end fn_03;

select fn_03(sysdate) from dual;




-- 실습4. '홍길동'문자열을 전달받아서 '길동'만 리턴하는 함수 fn_04
create or replace function fn_04(p_name in varchar2) return varchar2 is
	v_name varchar2(50);
begin
	v_name := substr(p_name, 2);
	
	return v_name;
end fn_04;

select fn_04('홍길동') from dual;
select fn_04(ename) from emp; --활용



--실습5. fn_05:현재일 입력받아서 '2023년 04월 03일'의 형태로 리턴
create or replace function fn_05(p_date in date) return varchar2 is
	v_result varchar2(20);

begin
	v_result := to_char(p_date, 'YYYY"년 "MM"월 "DD"일"');
	
	return v_result;

end fn_05;

select fn_05(sysdate) from dual;
select name, fn_05(hiredate) 입사일 from professor;




--실습6. fn_06: ssn번호를 입력받아서 남자or여자 구분해서 리턴하는 함수
create or replace function fn_06(p_jumin in number) return varchar2 is
	v_gender			varchar2(10);
	
begin
	v_gender := substr(p_jumin,7,1);
	
	if v_gender in ('1','3') then
		return '남자';
	else return'여자';
	end if;


end fn_06;

select jumin, fn_06(jumin) from student;
select name, fn_06(jumin) 성별, fn_05(birthday) 생일 from student;




-- 실습07 fn_07 : professor에서 hiredate를 현재일 기준으로 근속년월 계산함수
-- 근속년 floor(months_between()), 근속월ceil(months_between()) -> 12년 5개월
create or replace function fn_07(p_hiredate in date) return varchar2 is
	v_year varchar2(30);
  v_month varchar2(30);
	v_result varchar2(30);
begin
	v_year := to_char(floor(months_between(sysdate, p_hiredate)/12));
	v_month:= to_char(ceil(mod(months_between(sysdate, p_hiredate),12)));
	if v_month in ('12') then
		v_year := v_year+1;
		v_month := '0';		
	end if;
	v_result := v_year || '년 ' || v_month || '개월';
	
	return v_result;
	
end fn_07;

select name, hiredate, fn_07(hiredate) from professor;
select ename, hiredate, fn_07(hiredate) from emp;

select * from emp;