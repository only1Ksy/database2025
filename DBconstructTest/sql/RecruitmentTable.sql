# EJobDam.sql과 동일 (실제 수행 시 생략)
Create Database EJobDam;
Show databases;
Use EJobDam;

# 학번, 비밀번호, 닉네임, 이메일, 전화번호, 평점(0.00~5.00의 값을 가지고, 초기값은 0.00)
CREATE TABLE DB2025_Recruitment(
	id INT PRIMARY KEY,
	user_id VARCHAR(7),
    work_place VARCHAR(20) NOT NULL,
    start_day DATETIME NOT NULL,
    work_period VARCHAR(20) NOT NULL,
    category VARCHAR(20) NOT NULL,
    salary INT NOT NULL,
    # rating은 고유값이 아니라, 동적 값이라 외래키로 받아올 수 없음
    # user_id로 user 테이블 조인해서 받아오는 형식으로 참조 가능
    # rating을 자주 보여줘야 하는 경우 여기서 view 사용 가능
    recruitment_status VARCHAR(10) DEFAULT '모집중'
    	CHECK (recruitment_status IN ('모집중', '모집마감', '근무완료')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

Describe Recruitment;

INSERT INTO Recruitment (id, user_id, work_place, start_day, work_period, category, salary, recruitment_status, created_at) VALUES
(1, '2276123', '이화여대 학관', '2025-06-01 09:00:00', '1시간', '프린트 대리', 5000, '모집중', NOW()),
(2, '2103123', '서울 마포구', '2025-06-15 10:00:00', '3일', '카페 알바 대타', 100000, '모집마감', NOW()),
(3, '1955034', '이화여대 이하우스', '2025-07-01 09:30:00', '1일', '교내 근로 대타', 50000, '근무완료', NOW()),
(4, '2003076', '이화여대 한우리집', '2025-06-20 08:00:00', '1시간', '택배 대리 수령', 10000, '모집중', NOW()),
(5, '2271055', '서울 종로구', '2025-07-10 09:00:00', '2일', '학원 알바 대타', 80000, '모집중', NOW());
    
SELECT * FROM Recruitment;
#Drop Table Recruitment;