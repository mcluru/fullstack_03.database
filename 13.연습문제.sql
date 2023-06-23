/* 연습문제 */
-- ex01) professor, department을 join 교수번호, 교수이름, 소속학과이름 조회 View
create or replace view v_pro_01 as
select p.profno 교수번호, p.name 교수이름, d.dname 소속학과
	from professor p, department d
	where p.deptno = d.deptno;
	
select * from v_pro_01;



-- ex02) inline view를 사용, student, department를 사용 학과별로 
-- 학생들의 최대키, 최대몸무게, 학과명을 출력

create or replace view v_std_01 as
select max(height) 최대키, max(weight) 최대몸무게, (select dname from department d where d.deptno = std.deptno1) 학과명
	from student std
	GROUP BY std.deptno1;

select * from v_std_01;

-- 선생님 풀이 
create or replace view v_std_01 as
select dpt.deptno 학과번호, dpt.dname 학과명, std.최대신장, std.최대체중 
	from department dpt, (select deptno1, max(height) 최대신장, max(weight) 최대체중 from student group by deptno1) std
	where dpt.deptno = std.deptno1;

select * from v_std_01;
drop view v_std_01;




-- ex03) inline view를 사용, 학과명, 학과별최대키, 학과별로 가장 키가 큰 학생들의
-- 이름과 키를 출력
select * from student;
select * from department;

-- 선생님 풀이
--create or replace view v_max_by_std as

select std2.name
		, dpt.dname
		, std1.최대신장
		, std1.최대체중
	from (select deptno1
							, max(height) 최대신장
							, max(weight) 최대체중 
						from student
						group by deptno1) std1
			, student std2
			, department dpt
	where std1.최대신장 = std2.height
		and std1.최대체중 = std2.weight
		and std2.deptno1= dpt.deptno;

select * from v_max_by_std;



-- ex04) student에서 학생키가 동일학년의 평균키보다 큰 학생들의 학년과 이름과 키
-- 해당 학년의 평균키를 출력 단, inline view로

-- 선생님 풀이
-- 1. 학년별 평균키
select std.grade||'학년'
			, avg(std.height) avg_height
	from student std
	group by std.grade;
	
-- 2. 동일학년, 학생신장이 평균키보다 큰학생
create or replace view v_avg_by_grade as
select std.grade
			, std.name
			, std.height
			, grd.avg_height
	from student std
			, (select std.grade
							, avg(std.height) avg_height
					from student std
					group by std.grade) grd
	where std.grade = grd.grade
		and std.height > grd.avg_height
	order by std.grade;

select * from v_avg_by_grade;




-- ex05) professor에서 교수들의 급여순위와 이름, 급여출력 단, 급여순위 1~5위까지
-- create.....

--선생님 풀이
select rownum, t1.* 
	from (select pro.name
						 , pro.pay
					from professor pro
					order by pro.pay desc) t1
	where rownum <= 5;




-- ex06) 교수번호정렬후 3건씩해서 급여합계와 급여평균을 출력
-- hint) 
select rownum, profno, pay, ceil(rownum/3) from professor; -- rollup


select profno
		 , sum(pay)
		 , round(avg(pay), 1)
	 from (select rownum num, profno, name, pay from professor)
	 group by ceil(rownum/3), rollup(profno)
	 order by ceil(rownum/3);
	 
	 
select name
	 , sum(pay)
	 , round(avg(pay), 1)
 from (select rownum num, profno, name, pay from professor)
 group by ceil(rownum/3), rollup(name)
 order by ceil(rownum/3);


-- materialized view란 것도 있음