/* 연습문제 */
-- ex01) professor, department을 join 교수번호, 교수이름, 소속학과이름 조회 View
create or replace view pro_dpt_01 as
select pro.profno 교수번호
	  , pro.name 교수이름
	  , dpt.dname 소속학과이름
	from professor pro, department dpt
	where pro.deptno = dpt.deptno;

select * from pro_dpt_01;
drop view pro_dpt_01;



-- ex02) inline view를 사용, student, department를 사용 학과별로 
-- 학생들의 최대키, 최대몸무게, 학과명을 출력

-- select절 inline view
create or replace view std_dpt_01 as
select max(height) 최대키, max(weight) 최대몸무게, deptno1 학과번호, (select dname from department dpt where student.deptno1 = dpt.deptno) 학과명
	from student
	group by deptno1
	order by deptno1;

select * from std_dpt_01;

-- from절 inline view
create or replace view std_dpt_01 as
select std.*, dpt.dname 학과명
	from department dpt, (select deptno1, max(height) 최대키, max(weight) 최대몸무게 from student group by deptno1 order by deptno1) std
	where dpt.deptno = std.deptno1;

select * from std_dpt_01;
drop view std_dpt_01;






-- ex03) inline view를 사용, 학과명, 학과별최대키, 학과별로 가장 키가 큰 학생들의
-- 이름과 키를 출력

-- from절 inline view
-- 최대키와 학과번호(원본과 비교,매핑을 위함)만 있는 inline view std1과
-- 원본 student테이블 std1, department테이블 dpt2을 조인.
-- where절에서 std1의 최대키와 키가 같으면서 학과번호도 같은 학생의 이름을 출력
select std1.deptno1, std2.name, std1.최대키
	from (select deptno1, max(height) 최대키 from student group by deptno1) std1
		, student std2
		, department dpt
	where std1.최대키 = std2.height
	  and std2.deptno1= std1.deptno1
	  and dpt.deptno = std2.deptno1
	 order by std1.deptno1;





-- ex04) student에서 학생키가 동일학년의 평균키보다 큰 학생들의 학년과 이름과 키
-- 해당 학년의 평균키를 출력 단, inline view로

-- 1. 학년별 평균키
select * from student;
select grade, round(avg(height),1) 평균키 from student group by grade;
	
-- 2. 동일학년, 학생신장이 평균키보다 큰학생
-- 학년별 평균키와 학년(비교,매핑할 컬럼)만 추출한 inline view 테이블 std1과 원본테이블 조인
-- 조인할때 평균키와 학생들 키 비교해서 평균키보다 크고 학년이 같은 학생만 추출
select std1.grade, std2.name, std2.height, std1.평균키
	from (select grade, round(avg(height),1) 평균키 from student group by grade) std1
		, student std2
	where std2.height > std1.평균키
	  and std2.grade = std1.grade
	 order by std1.grade;




-- ex05) professor에서 교수들의 급여순위와 이름, 급여출력 단, 급여순위 1~5위까지
-- create.....
select rownum, pro.*
	from (select name, pay from professor order by pay desc) pro
	where rownum <=5;





-- ex06) 교수번호정렬후 3건씩해서 급여합계와 급여평균을 출력
-- hint) 
select ceil(rownum/3) "번호(3건씩묶음)", sum(pay) 급여합계, round(avg(pay),0) 급여평균
	from (select rownum 번호, profno, name, pay from professor)
	group by ceil(rownum/3)
	order by ceil(rownum/3);
