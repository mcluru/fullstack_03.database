/* 연습문제 */
-- view문제를 기초로 자유롭게 procedure를 작성하세요!
-- 매개변수를 받아서 만드는 것을 기본으로 하고
--    dbms_output.put_line('========================================================');
--    dbms_output.put_line('교수명' || chr(9) || '교수번호' || chr(9) || '학과명');
--    dbms_output.put_line('========================================================');
-- 출력하는 프로시저를 작성해 보세요!!
-- 프로시저명 ex01~ex06

-- ex01) professor, department을 join 교수번호, 교수이름, 소속학과이름 조회 View
select * from v_pro_01;

create or replace procedure ex01 is
	type tab_v_pro_01 is table of v_pro_01%rowtype index by binary_integer;
	v_v_pro_01 		tab_v_pro_01;
	i							binary_integer := 0;
	
begin
	for my_list in (select * from v_pro_01) loop
		i := i+1;
		v_v_pro_01(i) := my_list;
		dbms_output.put_line(v_v_pro_01(i).교수이름 ||chr(9)|| v_v_pro_01(i).교수번호 || chr(9) || v_v_pro_01(i).소속학과);
	end loop;

exception when others then
		dbms_output.put_line('에러입니다');
end ex01;

------------------------------------------------


create or replace procedure ex01_1(p_profno in number) is
-- 	type tab_v_pro_01 is table of v_pro_01%rowtype index by binary_integer;
-- 	v_v_pro_01 		tab_v_pro_01;
-- 	i							binary_integer := 0;
	v_profno		v_pro_01.교수번호%type;
	v_pname			v_pro_01.교수이름%type;
	v_dname			v_pro_01.소속학과%type;
	
begin
-- 	for my_list in (select * from v_pro_01) loop
-- 		i := i+1;
-- 		v_v_pro_01(i) := my_list;
-- 		dbms_output.put_line(v_v_pro_01(i).교수이름 ||chr(9)|| v_v_pro_01(i).교수번호 || chr(9) || v_v_pro_01(i).소속학과);
-- 	end loop;

	select 교수번호, 교수이름, 소속학과
		into v_profno, v_pname, v_dname
		from v_pro_01
		where v_profno = p_profno;
		
	dbms_output.put_line(v_profno||chr(9)||v_pname||chr(9)||v_dname);

exception when others then
		dbms_output.put_line('에러입니다');
end ex01_1;

call ex01_1(1001);
