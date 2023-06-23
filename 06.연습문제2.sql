/* 연습문제 */
-- ex01) emp테이블에서 ename, hiredate, 근속년, 근속월, 근속일수 출력, deptno = 10;
-- months_between, round, turnc, 개월수계산(/12), 일수계산(/365, /12)
select * from emp;
select ename
	, round(months_between(sysdate, hiredate)/12) 근속년
	, round(months_between(sysdate, hiredate)) 근속월
	, round(months_between(sysdate, hiredate)/12*365) 근속일수
	from emp
	where deptno = 10;


-- ex02) student에서 birthday중 생일 1월의 학생의 이름과 생일을 출력(YYYY-MM-DD)
select name 이름
	, to_char(birthday, 'YYYY-MM-DD') 생일
	from student
	where substr(birthday,4,2) = '01';

-- ex03) emp에서 hiredate가 1,2,3월인 사람들의 사번, 이름, 입사일을 출력
select empno 사번, ename 이름, to_char(hiredate, 'YYYY-MM-DD') 입사일
	from emp
	where substr(hiredate,4,2) <= '03';


-- ex04) emp 테이블을 조회하여 이름이 'ALLEN' 인 사원의 사번과 이름과 연봉을 
--       출력하세요. 단 연봉은 (sal * 12)+comm 로 계산하고 천 단위 구분기호로 표시하세요.
--       7499 ALLEN 1600 300 19,500     
select empno 사번, ename 이름, to_char((sal * 12)+comm, '99,999') 연봉
	from emp
	where ename = 'ALLEN';


-- ex05) professor 테이블을 조회하여 201 번 학과에 근무하는 교수들의 이름과 
--       급여, 보너스, 연봉을 아래와 같이 출력하세요. 단 연봉은 (pay*12)+bonus
--       로 계산합니다.
--       name pay bonus 6,970
select * from professor;
select 
	name 이름
	, pay 급여
	, nvl(bonus, 0) 보너스
	, pay*12+nvl(bonus, 0) 연봉
	from professor
	where deptno = 201;


-- ex06) emp 테이블을 조회하여 comm 값을 가지고 있는 사람들의 empno , ename , hiredate ,
--       총연봉,15% 인상 후 연봉을 아래 화면처럼 출력하세요. 단 총연봉은 (sal*12)+comm 으로 계산하고 
--       15% 인상한 값은 총연봉의 15% 인상 값입니다.
--      (HIREDATE 컬럼의 날짜 형식과 SAL 컬럼 , 15% UP 컬럼의 $ 표시와 , 기호 나오게 하세요)

select * from emp;
select empno
	, ename
	, to_char(hiredate, 'YYYY-MM-DD') hiredate
	, sal
	, sal*12+comm 총연봉
	, concat('$', to_char((sal*12+comm)*1.15, '99,999')) 인상후연봉
	from emp
	where comm is not null;