/* 연습문제 */
-- 1. emp 테이블을 사용하여 사원 중에서 급여(sal)와 보너스(comm)를 합친 금액이 가장 많은 경우와 
--    가장 적은 경우 , 평균 금액을 구하세요. 단 보너스가 없을 경우는 보너스를 0 으로 계산하고 
--    출력 금액은 모두 소수점 첫째 자리까지만 나오게 하세요
-- MAX, MIN, AVG
select
		max(sal+nvl(comm, 0)) 가장많은경우
	 ,min(sal+nvl(comm, 0)) 가장적은경우
	 ,round(avg(sal+nvl(comm, 0)),1) 평균금액
	from emp;


-- 2. student 테이블의 birthday 컬럼을 참조해서 월별로 생일자수를 출력하세요
-- TOTAL, JAN, ...,  5 DEC
--  20EA   3EA ....
select count(*) TOTAL
	, count(case when substr(birthday,4,2)=01 then 1 end) JAN
	, count(case when substr(birthday,4,2)=02 then 1 end) FEB
	, count(case when substr(birthday,4,2)=03 then 1 end) MAR
	, count(case when substr(birthday,4,2)=04 then 1 end) APR
	, count(case when substr(birthday,4,2)=05 then 1 end) MAY
	, count(case when substr(birthday,4,2)=06 then 1 end) JUN
	, count(case when substr(birthday,4,2)=07 then 1 end) JUL
	, count(case when substr(birthday,4,2)=08 then 1 end) AUG
	, count(case when substr(birthday,4,2)=09 then 1 end) SEP
	, count(case when substr(birthday,4,2)=10 then 1 end) OCT
	, count(case when substr(birthday,4,2)=11 then 1 end) NOV
	, count(case when substr(birthday,4,2)=12 then 1 end) DEC
	from student;




-- 3. Student 테이블의 tel 컬럼을 참고하여 아래와 같이 지역별 인원수를 출력하세요.
--    단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU, 055-GYEONGNAM
--    으로 출력하세요
select * from student;
select case substr(tel, 1, instr(tel, ')')-1)
		when '02' then '02-SEOUL'
		when '031' then '031-GYEONGGI'
		when '051' then '051-BUSAN'
		when '052' then '052-ULSAN'
		when '055' then '055-GYEONGNAM'
		when '053' then '053-DAEGU'
		end 지역
	, count(*)
	from student
	group by substr(tel, 1, instr(tel, ')')-1)
	order by 1;
	
	

-- 4. emp 테이블을 사용하여 직원들의 급여와 전체 급여의 누적 급여금액을 출력,
-- 단 급여를 오름차순으로 정렬해서 출력하세요.
-- sum() over()
select ename 사원, sal 급여
	, sum(sal) over(order by sal) 전체누적급여액
	from emp;
	

-- 6. student 테이블의 Tel 컬럼을 사용하여 아래와 같이 지역별 인원수와 전체대비 차지하는 비율을 
--    출력하세요.(단, 02-SEOUL, 031-GYEONGGI, 051-BUSAN, 052-ULSAN, 053-DAEGU,055-GYEONGNAM)
select case substr(tel, 1, instr(tel, ')')-1)
		when '02' then '02-SEOUL'
		when '031' then '031-GYEONGGI'
		when '051' then '051-BUSAN'
		when '052' then '052-ULSAN'
		when '055' then '055-GYEONGNAM'
		when '053' then '053-DAEGU'
		end 지역
	, count(*) 인원수
	, RATIO_TO_REPORT(count(*)) OVER() AS 비율
	from student
	group by substr(tel, 1, instr(tel, ')')-1)
	order by 1;


-- 7. emp 테이블을 사용하여 부서별로 급여 누적 합계가 나오도록 출력하세요. 
-- ( 단 부서번호로 오름차순 출력하세요. )
select deptno 부서번호, sal 급여
	, sum(sal) over(partition by deptno order by deptno, sal) 전체누적급여액
	from emp;



-- 8. emp 테이블을 사용하여 각 사원의 급여액이 전체 직원 급여총액에서 몇 %의 비율을 
--    차지하는지 출력하세요. 단 급여 비중이 높은 사람이 먼저 출력되도록 하세요
select ename,
	sal 급여
	, round(ratio_to_report(sal) over()*100,2) "비율(%)"
	from emp
	order by sal desc;


   
-- 9. emp 테이블을 조회하여 각 직원들의 급여가 해당 부서 합계금액에서 몇 %의 비중을
--     차지하는지를 출력하세요. 단 부서번호를 기준으로 오름차순으로 출력하세요.
select * from emp;
select deptno 부서
	, sum(sal) 급여합계
	, round(ratio_to_report(sum(sal)) over()*100,2) 부서별비율
	from emp
	group by deptno
	order by 1;


