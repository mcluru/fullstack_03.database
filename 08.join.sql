/*
	Join 문법
	
	1. Oracle문법
	
		select t1.ename, t2.dname
			from emp t1, dept t2
			where t1.emptno = t2.deptno
			
	2. Ansi Join
	
		select t1.ename, t2.dname
			from emp t1 [inner|outer|full] join dept t2 on t1.deptno = t2.deptno
*/
select deptno, ename from emp;
select deptno, dname from dept;

-- oracle join
select ename, dname, e.deptno
	from emp e, dept d
	where e.deptno = d.deptno;
	
-- ansi join
select ename, dname
	from emp join dept on emp.deptno = dept.deptno;
	
select ename, dname
	from emp inner join dept on emp.deptno = dept.deptno;
	

/*
	join의 종류
	
	1. equi-join(등가조인), inner join
	2. outer join
	3. full join
*/

-- A. equi-join
-- 실습1. student, professor에서 지도교수의 이름과 학생이름 출력
-- oracle/ ansi각각
-- 학생명과 조수명만 출력해보기

select * from student;
select * from professor;
select * from department;

select std.name 학생이름, prf.name 교수이름
	from student std, professor prf
	 where deptno1 = deptno;
 
select std.name 학생이름, prf.name 교수이름
	from student std, professor prf
 where std.profno = prf.profno;

select std .name 학생이름, prf.name 교수이름
	from student std inner join professor prf on std.profno = prf.profno;

select count(*) from student;



-- 실습2. student, professor, department에서 교수명, 학생명, 학과명을 출력
-- 표준문법(where, and), ansi각각
select pro.name 교수명, std.name 학생명, dep.dname 학과명
	from student std, professor pro, department dep
	where pro.profno = std.profno and pro.deptno = dep.deptno;

select pro.name 교수명, std.name 학생명, dep.dname 학과명
	from student std inner join professor pro on pro.profno = std.profno inner join department dep on pro.deptno = dep.deptno;



-- B. outter-join
select count(*) from student;
select count(*) from student where profno is null;

-- 지도교수가 정해져있지 않은 학생까지 출력
-- 1) oracle에서만 사용되는 문법. (+) 없는쪽이 우선

-- 지도교수가 할당되지 않은 학생
select std.name 학생명, pro.name 교수명
	from student std, professor pro
	where std.profno = pro.profno(+); -- =left join

-- 학생이 할당되지 않은 지도교수까지
select std.name 학생명, pro.name 교수명
	from student std, professor pro
	where std.profno(+) = pro.profno; -- =right join
	

-- 2) ansi outer join
select std.name 학생명, pro.name 교수명
	from student std inner join professor pro on std.profno = pro.profno;
	
select std.name 학생명, pro.name 교수명
	from student std left outer join professor pro on std.profno = pro.profno;

select std.name 학생명, pro.name 교수명
	from student std right outer join professor pro on std.profno = pro.profno;


-- C. self join
select empno from emp;
select mgr from emp;

select	emp.empno, emp.ename	--사원
			, mgr.empno, mgr.ename	--해당 사원의 매니저
	from emp emp, emp mgr
	where emp.mgr = mgr.empno;