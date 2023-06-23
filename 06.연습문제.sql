-- 연습문제
-- ex01) student 테이블의 주민등록번호 에서 성별만 추출
select substr(jumin, 7, 1)
	from student;

-- ex02) student 테이블의 주민등록번호 에서 월일만 추출
select substr(jumin, 3, 4)
	from student;
	
-- ex03)70년대에 태어난 사람만 추출
select *
	from student
	where substr(birthday, 1, 2) BETWEEN 70 and 79;
	
-- ex04) student 테이블에서 jumin컬럼을 사용, 1전공이 101번인 학생들의
--       이름과 태어난월일, 생일 하루 전 날짜를 출력
select name
	, substr(jumin, 3,2)||'월'||substr(jumin, 5,2)||'일' 태어난월일
	, substr(jumin, 3,2)||'월'||to_number(substr(jumin, 5,2)-1)||'일' 생일하루전
	from student where deptno1 = 101;