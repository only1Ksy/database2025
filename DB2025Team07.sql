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

CREATE TABLE DB2025_SUPPORT (
    RECRUIT_ID INT NOT NULL,
    USER_ID VARCHAR(20) NOT NULL,
    RECRUITMENT_STATE ENUM('채택됨', '채택 안됨') DEFAULT '채택 안됨',
    SUPPORT_TEXT TEXT,
    SUPPORT_CREATED_AT DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (RECRUIT_ID, USER_ID),
    FOREIGN KEY (RECRUIT_ID) REFERENCES DB2025_RECRUITMENT(id) ON DELETE CASCADE,
    FOREIGN KEY (USER_ID) REFERENCES DB2025_USERS(id) ON DELETE CASCADE
);

DESCRIBE DB2025_SUPPORT;

INSERT INTO DB2025_SUPPORT (
    RECRUIT_ID, USER_ID, RECRUITMENT_STATE, SUPPORT_TEXT, SUPPORT_CREATED_AT
) VALUES
(1, '1955034', '채택됨', '바로 도와드릴 수 있어요!', NOW()),
(2, '2276123', '채택 안됨', '오늘 오후에 가능해요!', NOW()),
(3, '1955034', '채택 안됨', '제가 해본 적 있어요. 잘할 수 있습니다.', NOW()),
(4, '2003076', '채택 안됨', '시간 맞춰 드릴 수 있어요!', NOW()),
(5, '2276123', '채택됨', '경험 많아요. 믿고 맡겨주세요!', NOW());

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
    S.RECRUITMENT_STATE,
    S.SUPPORT_TEXT,
    S.SUPPORT_CREATED_AT
FROM DB2025_SUPPORT S
LEFT JOIN DB2025_RECRUITMENT R ON S.RECRUIT_ID = R.id
LEFT JOIN DB2025_USERS U ON S.USER_ID = U.id;
# LEFT JOIN 사용하여 지원글 기준으로 전체 기록 보존

SELECT * FROM DB2025_MySupportApplications WHERE USER_ID = '2276123';
