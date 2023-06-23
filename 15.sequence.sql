/*
	Sequence
	
	시퀀스란? 순차적으로 증감하는 일련번호를 생성하는 오라클 데이터베이스의 객체
	보통 PK값에 중복을 방지하기 위해 종종 사용.
		ex) 게시판에 글이 하나 추가될때마다 글번호(PK)가 생겨야한다면, 시퀀스로 쉽고 편리하게 PK관리 가능
	
	1. 유일한 값을 생성해주는 오라클 객체 중 하나
	2. 시퀀스를 생성하면 기본키와 같이 순차적으로 증가하는 컬럼을 자동으로 생성 가능
	3. 보통 PK값을 생성하기 위해 사용
	4. 시퀀스는 테이블과 독립적으로 저장되고 생성됨
	
	
	[sequence 문법]
	1. create sequence 시퀀스명
			[start with n] 							-- 생략: 기본값 1
			[increment by n]						-- 생략: 기본값 1
			[maxvalue n | nomaxvalue] 	-- 생략: 기본값 nomaxvalue(999999999...)
			[minvalue n | nominvalue] 	-- 생략: 기본값 nominvalue
			[cycle | nocycle]						-- 생략: 기본값 nocycle
			[cache | nocache]						-- 생략: 기본값 nocache
			
			- start with : 시퀀스의 시작값을 정의. n이 1000이면 1000부터 시작. 정의 안하면 1부터 시작
			- increment by : 자동증가값을 정의, n이 10이면 10씩증가
			- maxvalue : 시퀀스의 최대값, 기본값 nomaxvalue
			- minvalue : 시퀀스의 최소값, 기본값 nominvalue
			- cycle : 최대값에 도달한 경우 처음부터(start with) 다시 시작할지 여부를 정의
			- cache : 원하는 숫자만큼 미리 생성해서 메모리에 저장했다가 하나씩 꺼내서 사용여부
			
	2. 시퀀스변경
		alter sequence 시퀀스명
			[increment by n]
			[maxvalue n | nomaxvalue]
			[minvalue n | nominvalue]
			[cycle | nocycle]
			[cache | nocache]
	
	
	3. 시퀀스 삭제
		drop sequence 시퀀스명
		
		
	4. 시퀀스 조회
		select * from user_sequences
		select * from all_sequences
*/
select * from user_sequences;
select * from all_sequences;

-- 1. 시퀀스 생성하기
create sequence jno_seq
	start with 100
	increment by 1
	maxvalue 110
	minvalue 90
	cycle
	cache 2;
	
select * from user_sequences;

-- 2. 시퀀스 실습
create table s_order(
	ord_no				number(4)
	,ord_name			varchar2(10)
	,p_name				varchar2(20)
	,p_qty					number
);
select * from s_order;

-- 시퀀스 접근명령
-- 현재번호 : 시퀀스명.currval
-- 다음번호 : 시퀀스명.nextval

select jno_seq.currval from dual; -- (x) ORA-08002: sequence JNO_SEQ.CURRVAL is not yet defined in this session
																	-- 		 사용한 적이 한번도 없기 때문에 currval 워닝에러
insert into s_order values(jno_seq.nextval, '홍길동', '홍삼',10);
select jno_seq.currval from dual;
select * from s_order;


insert into s_order values(jno_seq.nextval, '손흥민', '스카트폰',1);
select jno_seq.currval from dual;
select * from s_order;

select * from user_sequences;



-- minvalue, maxvalue 테스트
begin
	for i in 1..9 loop
		insert into s_order values(jno_seq.nextval, '소향', '노트북',1);
	end loop;
end;

select jno_seq.currval from dual;
select * from s_order;

select * from user_sequences;


-- cycle 테스트
insert into s_order values(jno_seq.nextval, '이강인', '축구공',1);
select jno_seq.currval from dual;
select * from s_order;

select * from user_sequences;



-- 별도의 시퀀스 적용하기
create sequence jno_seq_01;
select * from user_sequences;

insert into s_order values(jno_seq_01.nextval, '거미', 'mp3',1);
select jno_seq_01.currval from dual;
select * from s_order;
select * from user_sequences;



-- 감소하는 sequence
create sequence jno_seq_rev
	increment by -2
	minvalue 0
	maxvalue 20
	start with 20;
select * from user_sequences;

create table s_rev_01(no number);
select * from s_rev_01;

insert into s_rev_01 values(jno_seq_rev.nextval);
select * from s_rev_01;
select * from user_sequences;


-- 시퀀스 삭제하기
drop sequence jno_seq_01;
select * from user_sequences;

-- 보통의 경우 sequence를 PK로 사용
create sequence test_seq;
create table test_table(no number primary key);

insert into test_table values(test_seq.nextval);
insert into test_table values(test_seq.nextval);
insert into test_table values(test_seq.nextval);
insert into test_table values(test_seq.nextval);
insert into test_table values(test_seq.nextval);

select * from test_table;

insert into test_table values(6);
select * from test_table;

insert into test_table values(test_seq.nextval); --ORA-00001: unique constraint (SCOTT.SYS_C007115) violated 중복에러

 -- 1 증가된 상태
select test_seq.nextval from dual;


insert into test_table values(test_seq.nextval); -- 1증가해서 다시 정상작동됨

select test_seq.nextval from dual;
select test_seq.nextval from dual;
select test_seq.nextval from dual;
