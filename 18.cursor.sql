/*
	1. Cursor(커서)?
		오라클 서버는 sql문을 실행하고 처리한 정보를 저장하기 위해 private sql area라는 메모리 작업공간을 이용함.
		이 영역에 이름을 부여하고 저장된 정보를 처리할 수 있게 해주는데, 이것을 커서(cursor)라고 함
		
		cursor에는 dml문과 dql(select)문에 의해 내부적으로 선언되는 묵시적커서와 명시적커서가 있음
		PL/SQL에서는 select문은 한개의 row만 검색할 수 있기 때문에 하나 이상의 row를 검색하기 위해선 명시적커서를 사용해야함.
		
		묵시적커서의 정의는 PL/SQL 블럭의 begin~end에 sql문이 있다면 PL/SQL은 "SQL"이라는 이름의 커서를 자동으로 생성함
		
		
	2. Cursor의 종류
		1) 묵시적(암묵적, implicit)커서
			오라클이나 PL/SQL실행 매커니즘에 의해 처리되는 sql문장이 처리되는 곳에 대한 익명의 주소.
			오라클데이터베이스에서 실행되는 모든 SQL문장은 묵시적 커서가 생성되면 커서속성을 사용가능함.
			
			묵시적커서는 SQL문이 실행되는 순간 자동으로 open과 close가 됨. 암묵적커서의 속성은
				sql%rowcount : 해당 sql문에서 영향을 받는 행의 갯수 
				sql%found 	 : 해당 sql문에서 행의 개수가 한개 이상일때 true를 리턴
				sql%notfound : 해당 sql문에서 행의 개수가 없을 때 true를 리턴
				sql%isopen 	 : 항상 false, 묵시적커서가 open여부를 리턴
				
		2) 명시적(explicit)
			개발자에 의해 선언되고 이름이 부여되는 커서를 의미. 명시적 커서의 진행순서는
			"선언 -> open -> fetch -> close"로 진행함
			
			a. 문법 : cursor 커서명 is select문(=서브쿼리)
			b. 사용
				 1) 커서열기(open)
						...커서의 열기는 open문을 사용
						...커서에서 검색이 실행되면 데이터가 추출되지 않아도 에러는 발생하지 않음
						...문법 : open 커서명
						
				 2) 커서패치(fetch)
						...커서의 fetch는 현재 데이터행을 output변수에 반환
						...커서의 select문의 컬럼개수와 output변수의 개수가 동수여야함
						...커서컬럼의 타입과 output변수의 타입은 동일해야함
						...문법 : fetch 커서명 into 변수1... 변수n
						
				 3) 커서닫기(close)
						...사용이 끝난 커서는 반드시 닫아야함
						...커서를 닫은 경우엔 fetch 불가
						...필요한 경우 커서를 다시 open 가능
						...문법 : close 커서명
*/

-- 1. 묵시적커서
-- 사원번호를 전달받아서 사원의 유무를 리턴하는 프로시저 작성
create or replace procedure pro_19(p_empno in emp.empno%type) is
	v_ename			emp.ename%type;
	v_sal				emp.sal%type;
	v_row				number;
begin
	select ename, sal
		into v_ename, v_sal
		from emp
		where empno = p_empno;
		
		--자료가 있는 경우, 없는 경우
		-- sql%found / sql%notfound
	if sql%found
		then dbms_output.put_line(v_ename || '의 급여는 ' || v_sal || '원 입니다');
		else dbms_output.put_line(p_empno ||'사원번호는 존재하지 않습니다');
	end if;
	
		--데이터행의 개수
		update emp
			set comm = 0
			where empno = p_empno;

		v_row := sql%rowcount;
		dbms_output.put_line('급여가 수정된 사원의 수 = ' || v_row);
		
		
	exception when no_data_found then
		dbms_output.put_line('Exception: 사원자료가 없습니다');
end pro_19;


call pro_19(7369);
call pro_19(9999);



-- 2. 명시적커서
-- 1) 한건만 처리 : 특정 부서의 평균급여와 사원수를 출력

create or replace procedure pro_20(p_deptno in dept.deptno%type) is
-- 1. 커서선언
	cursor avg_by_dept is
	select dpt.dname
			 , count(emp.empno)
			 , round(avg(sal), 0)
		 from emp emp, dept dpt
		 where emp.deptno = p_deptno
			 and emp.deptno = dpt.deptno
			 group by dpt.dname;
			 
-- 변수선언
	v_dname dept.dname%type;
	v_cnt number;
	v_avg number;

begin
-- 2. 커서열기
	open avg_by_dept;
	
-- 3. 커서 fetch
	fetch avg_by_dept into v_dname, v_cnt, v_avg;
	dbms_output.put_line('부서명 = ' || v_dname || ', 사원수 = ' || v_cnt || ', 평균급여 = ' || v_avg);
	
	
-- 4. 커서닫기
	close avg_by_dept;
	

	exception when others then
		dbms_output.put_line('Exception: 부서번호가 없습니다');
end pro_20;

call pro_20(20);


-- 2) 여러건
-- for문을 사용하면 커서의 open, fetch, close가 자동실행됨.
-- 따라서 별도로 기술할 필요 없음. 레코드이름도 자동선언되므로 별도로 선언할 필요 없음
-- for 레코드명 in 커서명 loop
-- 		자동으로 open, fetch...
-- end loop


-- 부서별 인원수와 급여합계 출력
create or replace procedure pro_21 is
	cursor sum_by_dept is
	select dpt.dname				부서이름
			 , count(emp.empno) 사원수
			 , sum(emp.sal)			급여합계
		from emp emp, dept dpt
		where emp.deptno = dpt.deptno
		group by dpt.dname;

begin
	for dept_list in sum_by_dept loop
		dbms_output.put_line('부서명 = ' || dept_list.부서이름 ||
											 ', 사원수 = ' || dept_list.사원수 ||
											 ', 평균급여 = ' || dept_list.급여합계);
		
	end loop;

end pro_21;

call pro_21();



-- 3.명시적커서 속성 사용하기
create or replace procedure pro_22 is
	cursor emp_list is
	select empno, ename, sal
		from emp;
	
	v_empno		emp.empno%type;
	v_ename		emp.ename%type;
	v_sal			emp.sal%type;
	
begin
	
	open emp_list;
	loop
		fetch emp_list into v_empno, v_ename, v_sal;
		exit when emp_list%notfound;
		dbms_output.put_line('사원번호 = '||v_empno||
											 ', 사원이름 = '||v_ename||
											 ', 사원급여 = '||v_sal);
	end loop;
	dbms_output.put_line('전체 사원수 = '|| emp_list%rowcount);
	
	close emp_list;


	exception when others then
		dbms_output.put_line('예외가 발생했습니다');
end pro_22;


call pro_22();



-- 4. 매개변수가 있는 커서사용하기
-- 커서가 오픈된 후 질의가 실행되면 매개변수값을 커서에 전달할 수 있음

-- 부서번호를 전달받아서 해당 부서 사원이름을 출력
create or replace procedure pro_23(p_deptno in dept.deptno%type) is
	cursor c_emplist(v_deptno in dept.deptno%type) is
	select ename
		from emp
		where deptno = v_deptno;

begin
	dbms_output.put_line(p_deptno || '부서의 사원명부');
	dbms_output.put_line('-------------------------');
	
	for emplist in c_emplist(p_deptno) loop
		dbms_output.put_line('사원이름 = '||emplist.ename);
	end loop;
	
	exception when others then
		dbms_output.put_line('예외가 발생했습니다');
end pro_23;


call pro_23(10);





-- 5. 커서를 이용해서 데이터의 행을 수정하거나 삭제하기
-- "where current of" 명령
-- 1) 특정조건을 사용하지 않고도 현재 참조된 자료의 행을 수정하거나 삭제할 수 있음
-- 2) fetch문으로 최근에 사용된 행을 참조하기 위해 사용되는 명령
-- 3) delete, update 사용가능
-- 4) "where current of" 명령을 사용할 땐 참조하는 커서가 있어야함
-- 			for update절이 커서선언 안에 정의되어있어야 함. 없으면 에러 발생

-- 7369사원의 급여를 800으로 수정
create or replace procedure pro_24 is
	cursor c_emp is
	select empno
			 , ename
			 , sal
		 from emp
		 where empno = 7369
		 for update; --커서가 오픈될때 해당 레코드를 lock걸어둠. 커서가 close되면 unlock;
begin
	for l_emp in c_emp loop
		update emp
			set sal = 800
			where current of c_emp;
	end loop;

	exception when others then
		dbms_output.put_line('예외가 발생했습니다');
end pro_24;


call pro_24();

select empno, ename, sal from emp where empno = 7369;





--실습 1. 성적관리 프로그램(pl/sql)
-- 1. sungjuk파일을    커서 c_sungjuk    로 정의
-- 2. sungresult파일을 커서 c_sungresult
-- 3. >=95 A+, >=90 A0, >=85 B+ 5점단위... >= 60 D0 else 'F
-- 4. 성적의 평균이 >= 70 pass= 'pass' else pass='fail';
-- 5. insert into sungresult() value()
-- 6. update sungresult rank = 순위를 update
select * from sungjuk;
select * from sungresult;

create or replace procedure pro_25 is
	
begin



	exception when others then
		dbms_output.put_line('예외가 발생했습니다');
end pro_25;
call pro_25();

select count(*) +1 from sungresult where tot>180;


----------선생님 풀이

create or replace procedure pro_25 is

	cursor c_sungjuk is select * from sungjuk;--1.얘를 읽고
	cursor c_sungresult is select hakbun, tot from sungresult;--2.여기에 result를 insert
																										-- 3. rank update
	
	v_hakbun sungjuk.hakbun%type;
	v_name	 sungjuk.name%type;
	v_kor		 sungjuk.kor%type;
	v_eng		 sungjuk.eng%type;
	v_mat		 sungjuk.mat%type;
	
	v_tot		 sungresult.tot%type;  --그냥 number로 해도 상관없음
	v_avg		 sungresult.avg%type;
	v_hak		 sungresult.hak%type;
	v_pass 	 sungresult.pass%type;
	v_rank 	 sungresult.rank%type;

begin
	-- 1. 성적결과 초기화
	delete from sungresult;
	
	-- 2. 성적결과를 생성
	open c_sungjuk;
	
	loop
		fetch c_sungjuk into v_hakbun, v_name, v_kor, v_eng, v_mat;
		exit when c_sungjuk%notfound;
		
		v_tot := v_kor + v_eng + v_mat;
		v_avg := round(v_tot/3,2);
		
		if v_avg >= 95 then v_hak := 'A+';
			elsif v_avg >= 90 then v_hak := 'A0';
			elsif v_avg >= 85 then v_hak := 'B+';
			elsif v_avg >= 80 then v_hak := 'B0';
			elsif v_avg >= 75 then v_hak := 'C+';
			elsif v_avg >= 70 then v_hak := 'C0';
			elsif v_avg >= 65 then v_hak := 'D+';
			elsif v_avg >= 60 then v_hak := 'D0';
			else v_hak := 'F';
		end if;
		
		if v_avg >= 70
			then v_pass := 'pass';
			else v_pass := 'fail';
		end if;
		
		insert into sungresult(hakbun, name, kor, eng, mat, tot, avg, hak, pass)
		            values(v_hakbun, v_name, v_kor, v_eng, v_mat, v_tot, v_avg, v_hak, v_pass);		
	end loop;
	
	close c_sungjuk;
	
	
	-- 3. 성적별 등수 만들기
	open c_sungresult;
	
	loop
	
		fetch c_sungresult into v_hakbun, v_tot;
		exit when c_sungresult%notfound;
		
		select count(*) + 1
		  into v_rank
		  from sungresult
		 where tot > v_tot;
		 
	  update sungresult
		   set rank = v_rank
		 where hakbun = v_hakbun;
	end loop;

  close c_sungresult;



	exception when others then
		dbms_output.put_line('예외가 발생했습니다');
end pro_25;
call pro_25();

select * from sungresult;
select count(*) +1 from sungresult where tot>180;




--for문으로 실습하기









