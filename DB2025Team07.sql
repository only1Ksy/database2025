DROP DATABASE if exists DB2025Team07;
DROP USER if exists DB2025Team07@localhost;
CREATE USER 'DB2025Team07'@'localhost' IDENTIFIED BY 'DB2025Team07';
CREATE DATABASE DB2025Team07;
GRANT ALL PRIVILEGES ON DB2025Team07.* TO 'DB2025Team07'@'localhost';
USE DB2025Team07;

CREATE TABLE DB2025_Users(
	id VARCHAR(7) PRIMARY KEY,
    pwd VARCHAR(20) NOT NULL,
    nickname VARCHAR(20) NOT NULL,
    email VARCHAR(40) UNIQUE NOT NULL,
    phone VARCHAR(13) UNIQUE NOT NULL,
    rating DECIMAL(3,2) DEFAULT 0.00 CHECK (
    rating >= 0.00 AND rating <= 5.00)
);
Describe DB2025_Users;

INSERT INTO DB2025_Users (id, pwd, nickname, email, phone)
VALUES ('2276012', 'hellokim', '화요니._.', 'hellokim@ewhain.net', '010-1234-2276'),
	('2276123', 'pwd123', '빵애예요', 'bbangae@ewha.ac.kr', '010-1234-5678'),
	('2103123', 'test21ggam', '깜지공듀', 'ggamji@ewhain.net', '010-2103-0123'),
	('1955034', '1004@@!!', '소금빵천사', 'saltbreadangel@ewha.ac.kr', '010-3456-7890'),
	('2003076','password2003','주니어00', 'junior00@ewha.ac.kr', '010-4567-8901'),
	('2271055','abcd1111', '자구요정','dsking@ewhain.net', '010-1111-2222');
    
SELECT * FROM DB2025_Users;

# 모집글 id 자동으로 설정되게 변경함
CREATE TABLE DB2025_Recruitment(
	id INT AUTO_INCREMENT PRIMARY KEY, 
	user_id VARCHAR(7),
    work_place VARCHAR(20) NOT NULL,
    start_day DATETIME NOT NULL,
    work_period VARCHAR(20) NOT NULL,
    salary INT NOT NULL,
    # rating은 고유값이 아니라, 동적 값이라 외래키로 받아올 수 없음
    # user_id로 user 테이블 조인해서 받아오는 형식으로 참조 가능
    # rating을 자주 보여줘야 하는 경우 여기서 view 사용 가능
    recruitment_status VARCHAR(10) DEFAULT '모집중'
    	CHECK (recruitment_status IN ('모집중', '모집마감', '근무완료')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES DB2025_Users(id) ON DELETE CASCADE
);

Describe DB2025_Recruitment;

INSERT INTO DB2025_Recruitment (user_id, work_place, start_day, work_period, salary, recruitment_status, created_at) VALUES
('2276123', '이화여대 학관', '2025-06-01 09:00:00', '1시간', 5000, '모집중', NOW()),
('2103123', '서울 마포구', '2025-06-15 10:00:00', '3일', 100000, '모집마감', NOW()),
('1955034', '이화여대 이하우스', '2025-07-01 09:30:00', '1일', 50000, '근무완료', NOW()),
('2003076', '이화여대 한우리집', '2025-06-20 08:00:00', '1시간', 10000, '모집중', NOW()),
('2271055', '서울 종로구', '2025-07-10 09:00:00', '2일', 80000, '모집중', NOW());

SELECT * FROM DB2025_Recruitment;

# 지원 상태 테이블 (지원 상태의 id, 지원 상태) 생성
# 상태 id는 자동 설정
CREATE TABLE DB2025_SupportStatus (
	id INT AUTO_INCREMENT PRIMARY KEY ,
    status_name VARCHAR(20) UNIQUE NOT NULL
);

INSERT INTO DB2025_SupportStatus (status_name) VALUES 
	('대기'),
    ('채택됨'),
    ('탈락');

SELECT * FROM DB2025_SupportStatus;

# 지원 테이블 생성
CREATE TABLE DB2025_SUPPORT (
    RECRUIT_ID INT NOT NULL,
    USER_ID VARCHAR(20) NOT NULL,
    RECRUITMENT_STATE INT NOT NULL DEFAULT 1,
    SUPPORT_TEXT TEXT,
    SUPPORT_CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (RECRUIT_ID, USER_ID),
    FOREIGN KEY (RECRUIT_ID) REFERENCES DB2025_RECRUITMENT(id) ON DELETE CASCADE,
    FOREIGN KEY (USER_ID) REFERENCES DB2025_USERS(id) ON DELETE CASCADE,
    FOREIGN KEY (RECRUITMENT_STATE) REFERENCES DB2025_SupportStatus(id) ON DELETE CASCADE
);

DESCRIBE DB2025_SUPPORT;

INSERT INTO DB2025_SUPPORT (
    RECRUIT_ID, USER_ID, SUPPORT_TEXT, SUPPORT_CREATED_AT
) VALUES
(1, '1955034', '바로 도와드릴 수 있어요!', NOW()),
(2, '2276123', '오늘 오후에 가능해요!', NOW()),
(3, '1955034', '제가 해본 적 있어요. 잘할 수 있습니다.', NOW()),
(4, '2003076', '시간 맞춰 드릴 수 있어요!', NOW()),
(5, '2276123', '경험 많아요. 믿고 맡겨주세요!', NOW());

INSERT INTO DB2025_SUPPORT (
    RECRUIT_ID, USER_ID, RECRUITMENT_STATE, SUPPORT_TEXT, SUPPORT_CREATED_AT
) VALUES
(6, '1955034', 1, '바로 도와드릴 수 있어요!', NOW()),
(6, '2276123', 1, '오늘 오후에 가능해요!', NOW());

SELECT * FROM DB2025_SUPPORT;

# 내가 작성한 모집글 보기 (뷰) 생성
CREATE OR REPLACE VIEW DB2025_MyRecruits AS
SELECT R.*, U.nickname
FROM DB2025_Recruitment R
JOIN DB2025_Users U ON R.user_id = U.id;

SELECT * FROM DB2025_MyRecruits WHERE user_id = '2276123';

# 내가 작성한 지원글 보기 (뷰) 생성
# 지원한 모집글, 지원자 ID, 지원자 닉네임, 모집글 관련 정보, 채택 여부, 코멘트 내용, 지원시각
CREATE OR REPLACE VIEW DB2025_MySupportApplications AS
SELECT 
    S.RECRUIT_ID,
    S.USER_ID,
    U.nickname AS supporter_nickname,
    R.work_place,
    R.start_day,
    R.salary,
    ASL.status_name, # 정수값인 RECRUITMENT_STATE를 지원상태 테이블과 조인하여 문자형태로 나타냄
    S.SUPPORT_TEXT,
    S.SUPPORT_CREATED_AT
FROM DB2025_SUPPORT S
LEFT JOIN DB2025_RECRUITMENT R ON S.RECRUIT_ID = R.id
LEFT JOIN DB2025_USERS U ON S.USER_ID = U.id
LEFT JOIN DB2025_SupportStatus ASL ON S.RECRUITMENT_STATE = ASL.id; # 정수값인 RECRUITMENT_STATE를 지원상태 테이블과 조인하여 문자형태로 나타냄
# LEFT JOIN 사용하여 지원글 기준으로 전체 기록 보존

SELECT * FROM DB2025_MySupportApplications WHERE USER_ID = '2276123';

# 특정 모집글의 지원글 모아보기 뷰 생성
CREATE VIEW DB2025_SupportDetailView AS
SELECT 
	S.RECRUIT_ID,
    U.id AS USER_ID,
    U.nickname,
    U.email,
    U.phone,
    U.rating,
    SS.status_name AS RECRUITMENT_STATE,
    S.SUPPORT_TEXT,
    S.SUPPORT_CREATED_AT
FROM DB2025_SUPPORT S
JOIN DB2025_Users U
    ON S.USER_ID = U.id
JOIN DB2025_SupportStatus SS
    ON S.RECRUITMENT_STATE = SS.id;
    
SELECT * FROM DB2025_SupportDetailView WHERE RECRUIT_ID = 6;


# DROP VIEW DB2025_SupportDetailView;

# 평가 테이블 (평가글 아이디, 평가자 학번, 평가대상 학번, 점수, 평가 내용, 생성시각) 생성
CREATE TABLE DB2025_Evaluation (
	recruitment_id INT NOT NULL,
    evaluator_id  VARCHAR(7) NOT NULL,
    target_id VARCHAR(7) NOT NULL,
    score INT CHECK (score BETWEEN 1 AND 5) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, #추가하는 게 맞을 것 같아서 넣었습니다
    PRIMARY KEY (recruitment_id, evaluator_id),
    FOREIGN KEY (recruitment_id) REFERENCES DB2025_Recruitment(id) ON DELETE CASCADE,
    FOREIGN KEY (evaluator_id) REFERENCES DB2025_Recruitment(user_id) ON DELETE CASCADE,
    FOREIGN KEY (target_id) REFERENCES DB2025_Recruitment(user_id) ON DELETE CASCADE
);

Describe DB2025_Evaluation;

INSERT INTO DB2025_Evaluation (recruitment_id, evaluator_id, target_id, score, description) VALUES
	(1, 2276123, 2103123, 5, '정확한 시간 개념과 탁월한 업무 태도를 보여줬습니다.'),
	(2, 2103123, 1955034, 4, '전반적으로 만족스러웠지만 약간의 세부 개선이 필요합니다.'),
	(3, 1955034, 2003076, 3, '일은 어느 정도 했지만 결과물의 퀄리티가 부족했습니다.'),
	(4, 2003076, 2271055, 5, '적극적이고 책임감 있는 태도가 매우 인상 깊었습니다.'),
	(5, 2276123, 1955034, 3, '업무 처리 속도가 약간 느리고 소극적이었습니다.');
    
INSERT INTO DB2025_Recruitment (user_id, work_place, start_day, work_period, salary, recruitment_status, created_at) VALUES
('2344009', '이화여대 학관', '2025-06-01 09:00:00', '1시간', 5000, '모집중', NOW());

SELECT * FROM DB2025_Evaluation;