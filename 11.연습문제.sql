/* 연습문제 */

-- ex01) 테이블명 : STAR_WARS (영화 정보를 저장한다)
--       컬럼 : EPISODE_ID : 에피소드 아이디로써, 숫자형 타입으로 기본 키가 된다.
--              EPISODE_NAME : 에피소드에 따른 영화 제목, 가변길이문자형(50 BYTE)이다.
--              OPEN_YEAR : 개봉년도로써, 숫자형 타입이다.
create table STAR_WARS (
		EPISODE_ID	 number				constraint stw_id_pk 		primary key
	, EPISODE_NAME VARCHAR2(50) 
	, OPEN_YEAR 	 number				
);
drop table STAR_WARS;
select * from STAR_WARS;
select * from user_constraints where table_name ='STAR_WARS' ;



-- ex02) 테이블명 : CHARACTERS ( 등장인물 정보를 저장한다)
--         컬럼 : CHARACTER_ID   : 등장인물 아이디로써, 숫자형 타입(5자리), 기본키
--                CHARACTER_NAME : 등장인물 명으로 가변 길이 문자형 타입(30 BYTE)이다.
--                MASTER_ID      : 등장인물이제다이일 경우 마스터아이디값, 숫자형(5자리)
--                ROLE_ID        : 등장인물의 역할 아이디로써, INTEGER 타입이다.
--                EMAIL          : 등장인물의 이메일 주소로 varchar2(40 BYTE)이다.
create table CHARACTERS (
		CHARACTER_ID number(5)			constraint char_id_pk 		 primary key
	, CHARACTER_NAME varchar2(30)	
	, MASTER_ID number(5)					
	, ROLE_ID integer							
	, EMAIL varchar2(40)					
);
drop table CHARACTERS;
select * from CHARACTERS;
select * from user_constraints where table_name ='CHARACTERS' ;



-- ex03) 테이블명 : CASTING ( 등장인물과 실제 배우의 정보를 저장한다)
--         컬럼 : EPISODE_ID: 에피소드 아이디로써, 숫자형 타입(5자리)으로 기본키
--                CHARACTER_ID: 등장인물 아이디로써, 숫자형 타입(5자리)이며 참조키
--                REAL_NAME : 등장인물의 실제 이름으로, varchar2(30 BYTE)이다.
create table CASTING (
		EPISODE_ID number(5) 				constraint cast_ep_pk		 primary key
	, CHARACTER_ID number(5)			constraint cast_char_fk	 references CHARACTERS(CHARACTER_ID)
	, REAL_NAME varchar2(30 BYTE) 
);
drop table CASTING;
select * from CASTING;
select * from user_constraints where table_name ='CASTING' ;



-- ex04) INSERT 문을 사용하여 STAR_WARS 테이블에 다음과 같이 데이터를 저장해보자. 
-- EPISODE_ID  EPISODE_NAME                                 OPEN_YEAR              
-- ----------- ---------------------------------------  --------------                
-- 1              보이지 않는 위험(The Phantom Menace)          1999                   
-- 2              클론의 습격(Attack of the Clones)             2002                   
-- 3              시스의 복수(Revenge of the Sith)              2005
-- 4              새로운 희망(A New Hope)                       1977                   
-- 5              제국의 역습(The Empire Strikes Back)          1980                   
-- 6              제다이의 귀환(Return of the Jedi)             1983 

select * from STAR_WARS;
insert into STAR_WARS values(1,'보이지 않는 위험(The Phantom Menace)',1999);
insert into STAR_WARS values(2,'클론의 습격(Attack of the Clones)',2002);
insert into STAR_WARS values(3,'시스의 복수(Revenge of the Sith)',2005);
insert into STAR_WARS values(4,'새로운 희망(A New Hope)',1977);
insert into STAR_WARS values(5,'제국의 역습(The Empire Strikes Back)',1980);
insert into STAR_WARS values(6,'제다이의 귀환(Return of the Jedi)',1983);



-- ex05) CHARACTERS 테이블에 다음의 데이터를 저장해보자.
-- CHARACTER_ID    CHARACTER_NAME       EMAIL                                    
-- --------------- -------------------- ------------------------ 
-- 1                 루크 스카이워커          luke@jedai.com                           
-- 2                 한 솔로                  solo@alliance.com                        
-- 3                 레이아 공주              leia@alliance.com                        
-- 4                 오비완 케노비            Obi-Wan@jedai.com                        
-- 5                 다쓰 베이더              vader@sith.com                           
-- 6                 다쓰 베이더(목소리)       Chewbacca@alliance.com                   
-- 7                 C-3PO                   c3po@alliance.com                        
-- 8                 R2-D2                   r2d2@alliance.com                        
-- 9                 츄바카                   Chewbacca@alliance.com                   
-- 10                랜도 칼리시안
-- 11                요다(목소리)              yoda@jedai.com                           
-- 12                다스 시디어스
-- 13                아나킨 스카이워커        Anakin@jedai.com                         
-- 14                콰이곤 진
-- 15                아미달라 여왕
-- 16                아나킨 어머니
-- 17                자자빙크스(목소리)        jaja@jedai.com 
-- 18                다스 몰          
-- 19                장고 펫 
-- 20                마스터 윈두              windu@jedai.com                          
-- 21                듀크 백작                dooku@jedai.com

select * from CHARACTERS;
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(1,'루크 스카이워커','luke@jedai.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(2,'한 솔로','solo@alliance.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(3,'레이아 공주','leia@alliance.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(4,'오비완 케노비','Obi-Wan@jedai.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(5,'다쓰 베이더','vader@sith.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(6,'다쓰 베이더(목소리)','Chewbacca@alliance.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(7,'C-3PO','c3po@alliance.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(8,'R2-D2','r2d2@alliance.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(9,'츄바카','Chewbacca@alliance.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(10,'랜도 칼리시안',null);
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(11,'요다(목소리)','yoda@jedai.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(12,'다스 시디어스',null);
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(13,'아나킨 스카이워커','Anakin@jedai.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(14,'콰이곤 진',null);
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(15,'아미달라 여왕',null);
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(16,'아나킨 어머니',null);
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(17,'자자빙크스(목소리)','jaja@jedai.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(18,'다스 몰',null);
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(19,'장고 펫',null);
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(20,'마스터 윈두','windu@jedai.com');
insert into CHARACTERS(CHARACTER_ID,CHARACTER_NAME,EMAIL) values(21,'듀크 백작','dooku@jedai.com');




-- ex06) ROLES 테이블에 다음의 데이터를 저장해보자
-- ROLE_ID(number5,0) pk, ROLE_NAME(varchar2 30)
-- 1001, '제다이'
-- 1002, '시스'
-- 1003, '반란군'
create table ROLES (
		ROLE_ID number(5,0) constraint roles_id_pk primary key
	, ROLE_NAME varchar2(30)
);
select * from roles;

insert into ROLES values(1001,'제다이');
insert into ROLES values(1002,'시스');
insert into ROLES values(1003,'반란군');



-- ex07) CHARACTERS 에는  란 컬럼, 이 값은 ROLES 테이블의 ROLE_ID 값을 참조 
-- CHARACTERS 변경하여 ROLE_ID 컬럼이 ROLES의 ROLE_ID 값을 참조하도록 참조 키를 생성
select * from ;
alter table CHARACTERS modify(ROLE_ID constraint char_role_fk references ROLES(ROLE_ID));

select * from user_constraints where table_name ='CHARACTERS' ;



-- ex08) 참조 키를 생성후, 다음으로 CHARACTERS 테이블의 ROLE_ID 값을 변경해보자. 
-- 값의 참조는 ROLES 테이블의 ROLE_ID 값을 참조한다. 예를 들면 루크 스카이워커,   
-- 오비완 캐노비, 요다 등은 제다이 기사이므로 1001 값을 가질 것이며, 
-- 다쓰 베이더, 다쓰 몰은 시스 족이므로 1002에 해당한다. 자신이 아는 범위 내에서 
-- 이 값을 갱신하는 UPDATE 문장을 작성해 보자.

select * from CHARACTERS;
select * from ROLES;

update CHARACTERS set role_id = 1001 where character_name = '루크 스카이워커';
update CHARACTERS set role_id = 1001 where character_name = '오비완 케노비';
update CHARACTERS set role_id = 1001 where character_name = '요다(목소리)';

update CHARACTERS set role_id = 1002 where character_name = '다쓰 베이더';
update CHARACTERS set role_id = 1002 where character_name = '다쓰 베이더(목소리)';
update CHARACTERS set role_id = 1002 where character_name = '다스 몰';

update characters
    set role_id = 1001
 where character_id in (1, 4, 11, 13, 14, 20, 21);
 
update characters
    set role_id = 1002
 where character_id in (5,6,12,18); 

update characters
    set role_id = 1003
 where character_id in (2,3,7,8,9); 




-- ex09) CHARACTERS MASTER_ID 란 컬럼, 이 컬럼의 용도는 EMPLOYEES 테이블의 MANAGER_ID 
-- 와 그 역할이 같다. 즉 제다이나 시스에 속하는 인물 중 그 마스터의 CHARACTER_ID 값을 
-- 찾아 이 컬럼에 갱신하는 문장을 작성
-- 
-- 제자                    마스터
-- ------------------  -------------------------
-- 아나킨 스카이워커      오비완 캐노비
-- 루크 스카이워크        오비완 캐노비
-- 마스터 윈두            요다
-- 듀크 백작              요다
-- 다쓰 베이더            다쓰 시디어스
-- 다쓰 몰                다쓰 시디어스
-- 오비완 캐노비          콰이곤 진
-- 콰이곤 진              듀크 백작
select * from CHARACTERS;

update CHARACTERS set MASTER_ID = 4 where CHARACTER_ID = 13;
update CHARACTERS set MASTER_ID = 4 where CHARACTER_ID = 1;
update CHARACTERS set MASTER_ID = 11 where CHARACTER_ID = 20;
update CHARACTERS set MASTER_ID = 11 where CHARACTER_ID = 21;
update CHARACTERS set MASTER_ID = 12 where CHARACTER_ID = 5;
update CHARACTERS set MASTER_ID = 12 where CHARACTER_ID = 6;
update CHARACTERS set MASTER_ID = 12 where CHARACTER_ID = 18;
update CHARACTERS set MASTER_ID = 14 where CHARACTER_ID = 4;
update CHARACTERS set MASTER_ID = 21 where CHARACTER_ID = 14;



-- ex010) CASTING의 PK는 EPISODE_ID와 CHARACTER_ID 이다. 
-- 이 두 컬럼은 각각 STAR_WARS와 CHARACTERS 테이블의 기본 키를 참조하고 있다. 
-- CASTING 테이블에 각각 이 두 테이블의 컬럼을 참조하도록 참조 키를 생성 
select * from casting;
select * from user_constraints where table_name ='CASTING';

alter table CASTING add constraint cast_ep_fk foreign key(EPISODE_ID) references STAR_WARS(EPISODE_ID);
alter table CASTING add constraint cast_char_fk foreign key(CHARACTER_ID) references CHARACTERS(CHARACTER_ID);



-- ex11) 다음 문장을 실행해 보자. 
DELETE ROLES
 WHERE ROLE_ID = 1001;
-- 
-- 이 문장을 실행하면 그 결과는 어떻게 되는가? 또한 그러한 결과가 나오는 이유는 
-- 무엇인지 설명해 보자.

삭제되지 않는다. CHARACTERS 테이블에 ROLES 테이블의 ROLE_ID를 참조한 자식자료가 있기 때문이다.



-- ex12) characters에 character_name 인덱스 생성하기
create index characters_ix_01 on characters(character_name);



-- ex13) 상기작업들의 data dictionary를 조회
select * from user_indexes where table_name = 'CHARACTERS';
select * from user_ind_columns where table_name = 'CHARACTERS';



/* 연습문제 */
-- ex01)  생성, no(number), name(), sal(number)
create table new_emp4 (
		NO number
	, NAME VARCHAR2(10)
	, SAL number
);

select * from new_emp4;



-- ex02) 데이터를 insert
--    1000, 'SMITH', 300
--    1001, 'ALLEN', 250
--    1002, 'KING', 430
--    1003, 'BLAKE', 220
--    1004, 'JAMES', 620
--    1005, 'MILLER', 810
insert into new_emp4 values(1000,'SMITH',300);
insert into new_emp4 values(1001,'ALLEN',250);
insert into new_emp4 values(1002,'KING',430);
insert into new_emp4 values(1003,'BLAKE',220);
insert into new_emp4 values(1004,'JAMES',620);
insert into new_emp4 values(1005,'MILLER',810);
select * from new_emp4;



-- ex03) name컬럼에 인덱스 생성
create index idx_new_emp4_name on new_emp4(name);
select * from user_indexes where table_name = 'NEW_EMP4';
select * from user_ind_columns where table_name = 'NEW_EMP4';



-- ex04) 인덱스를 사용하지 않는 일반적인 SQL
데이터가 적거나
검색보다 update, delete, insert가 빈번하게 일어나는 테이블
또는 조회결과가 전체 행의 15%이상인 경우에 인덱스를 사용하지 않습니다