Create Database EJobDam;
Show databases;
Use EJobDam;

# 학번, 비밀번호, 닉네임, 이메일, 전화번호, 평점(0.00~5.00의 값을 가지고, 초기값은 0.00)
CREATE TABLE DB2025_Users(
	user_id VARCHAR(7) PRIMARY KEY,
    pwd VARCHAR(20) NOT NULL,
    nickname VARCHAR(20) NOT NULL,
    email VARCHAR(40) UNIQUE NOT NULL,
    phone VARCHAR(13) UNIQUE NOT NULL,
    rating DECIMAL(3,2) DEFAULT 0.00 CHECK (
    rating >= 0.00 AND rating <= 5.00)
);

Describe Users;

# 초기 생성시에는 평점이 0.00으로 부여되므로 rating을 생략하고 값을 넣어줌
INSERT INTO Users (user_id, pwd, nickname, email, phone)
VALUES('2276012', 'hellokim', '화요니._.', 'hellokim@ewhain.net', '010-1234-2276');

SELECT * FROM Users;

INSERT INTO Users (user_id, pwd, nickname, email, phone) VALUES
	('2276123', 'pwd123', '빵애예요', 'bbangae@ewha.ac.kr', '010-1234-5678'),
	('2103123', 'test21ggam', '깜지공듀', 'ggamji@ewhain.net', '010-2103-0123'),
	('1955034', '1004@@!!', '소금빵천사', 'saltbreadangel@ewha.ac.kr', '010-3456-7890'),
	('2003076','password2003','주니어00', 'junior00@ewha.ac.kr', '010-4567-8901'),
	('2271055','abcd1111', '자구요정','dsking@ewhain.net', '010-1111-2222');
    
SELECT * FROM Users;
#Drop Table Users;