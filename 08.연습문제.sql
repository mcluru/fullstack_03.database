/* 연습문제 */
-- ex01) student, department에서 학생이름, 학과번호, 1전공학과명출력
select std.name 학생명, std.deptno1 학과번호, dpt.dname "1전공학과명"
	from student std inner join department dpt
	on std.deptno1 = dpt.deptno;


-- ex02) emp2, p_grade에서 현재 직급의 사원명, 직급, 현재 년봉, 해당직급의 하한
--       상한금액 출력 (천단위 ,로 구분)
select emp.name 사원명, emp.position 현재직급, to_char(emp.pay, '99,999,999') 연봉
	, to_char(pgr.s_pay, '99,999,999') 하한금액 , to_char(pgr.e_pay, '99,999,999') 상한금액
	from emp2 emp left outer join p_grade pgr on emp.position = pgr.position;

    
-- ex03) emp2, p_grade에서 사원명, 나이, 직급, 예상직급(나이로 계산후 해당 나이의
--       직급), 나이는 오늘날자기준 trunc로 소수점이하 절삭 
select * from emp2;
select 
e.name 사원명,trunc(months_between(sysdate,birthday)/12) 나이, e.position 직급, p.position 예상직급
	from emp2 e inner join p_grade p on trunc(months_between(sysdate,birthday)/12) between p.s_age and p. e_age;


-- ex04) customer, gift 고객포인트보나 낮은 포인트의 상품중에 Notebook을 선택할
--       수 있는 고객명, 포인트, 상품명을 출력  
select c.gname, c.point, g.gname
from customer c left outer join gift g on c.point between g.g_start and g.g_end
where c.point > 600001 ;


select c.gname, c.point, g.gname
from customer c join gift g on c.point >= g.g_start
and g.gname = 'Notebook' ;



-- ex05) professor에서 교수번호, 교수명, 입사일, 자신보다 빠른 사람의 인원수
--       단, 입사일이 빠른 사람수를 오름차순으로
select 
	p1.profno 교수번호, p1.name 교수명, p1.hiredate, count(p2.hiredate) 빠른사람수
	from professor p1 left join professor p2
	on p1.hiredate > p2.hiredate
	group by p1.profno, p1.name, p1.hiredate
	order by 3;


 
-- ex06) emp에서 사원번호, 사원명, 입사일 자신보다 먼저 입사한 인원수를 출력
--       단, 입사일이 빠른 사람수를 오름차순 정렬
select e1.empno 사원번호, e1.ename 사원명, e1.hiredate 입사일, count(e2.hiredate) 빠른입사인원수
	from emp e1 left join emp e2
	on e1.hiredate > e2.hiredate
	group by e1.empno, e1.ename, e1.hiredate
	order by 4;
