-- 연습문제-----------------------------------------------
-- ex01) student에서 jumin에 월참조해서 해당월의 분기를 출력(1Q, 2Q, 3Q, 4Q)
-- name, jumin, 분기 
select * from student;
select name
	, jumin
	,case when substr(jumin,3,2) between 01 and 03 then '1Q'
			 when substr(jumin,3,2) between 04 and 06 then '2Q'
			 when substr(jumin,3,2) between 07 and 09 then '3Q'
			 when substr(jumin,3,2) between 10 and 12 then '4Q'
			 end 분기
	from student;


-- ex02) dept에서 10=회계부, 20=연구실, 30=영업부, 40=전산실
-- 1) decode
-- 2) case
-- deptno, 부서명
select * from dept;
select deptno
	, decode(deptno, 10, '회계부', 20 , '연구실', 30 ,'영업부', 40, '전산실') 부서명
	from dept;

select deptno
	, case deptno
			when 10 then '회계부'
			when 20 then '연구실'
			when 30 then '영업부'
			when 40 then '전산실'
			end 부서명
	from dept;

-- ex03) 급여인상율을 다르게 적용하기
-- emp에서 sal < 1000 0.8%인상, 1000~2000 0.5%, 2001~3000 0.3%
-- 그 이상은 0.1% 인상분 출력
-- ename, sal(인상전급여), 인상후급여 
-- 1) decode
-- 2) case 
select * from emp;
select ename, sal 인상전급여
	, decode(sign(1000-sal), 1, sal+sal/1000*8, decode(sign(2001-sal), 1, sal+sal/1000*5,decode(sign(3001-sal), 1, sal+sal/1000*3, sal+sal/1000*1))) 인상후급여
	from emp;



select ename,sal 인상전급여
	, case when sal < 1000 then sal+sal/1000*8
				 when sal between 1000 and 2000 then sal+sal/1000*5
				 when sal between 2001 and 3000 then sal+sal/1000*3
				 else sal+sal/1000*1
	end 인상후급여
	from emp;