# EJobDam.sql과 동일 (실제 수행 시 생략)
Create Database EJobDam;
Show databases;
Use EJobDam;

# 평가 테이블 (평가글 아이디, 평가자 학번, 평가대상 학번, 점수, 평가 내용, 생성시각)
CREATE TABLE DB2025_Evalution (
	recruitment_id INT NOT NULL,
    evaluator_id  VARCHAR(7) NOT NULL,
    target_id VARCHAR(7) NOT NULL,
    score INT CHECK (score BETWEEN 1 AND 5) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, #추가하는 게 맞을 것 같아서 넣었습니다
    PRIMARY KEY (recruitment_id, evaluator_id, target_id),
    FOREIGN KEY (recruitment_id) REFERENCES DB2025_Recruitment(id) ON DELETE CASCADE,
    FOREIGN KEY (evaluator_id) REFERENCES DB2025_Recruitment(user_id) ON DELETE CASCADE,
    FOREIGN KEY (target_id) REFERENCES DB2025_Recruitment(user_id) ON DELETE CASCADE
);

Describe DB2025_Evalution;

INSERT INTO DB2025_Evalution (recruitment_id, evaluator_id, target_id, score, description) VALUES
	(1, 2276123, 2103123, 5, '정확한 시간 개념과 탁월한 업무 태도를 보여줬습니다.'),
	(2, 2103123, 1955034, 4, '전반적으로 만족스러웠지만 약간의 세부 개선이 필요합니다.'),
	(3, 1955034, 2003076, 3, '일은 어느 정도 했지만 결과물의 퀄리티가 부족했습니다.'),
	(4, 2003076, 2271055, 5, '적극적이고 책임감 있는 태도가 매우 인상 깊었습니다.'),
	(5, 2276123, 1955034, 3, '업무 처리 속도가 약간 느리고 소극적이었습니다.');

SELECT * FROM DB2025_Evalution;

#특정 사용자의 평점 조회
SELECT target_id, AVG(score) AS average_score
FROM DB2025_Evalution
WHERE target_id = 'user2'
GROUP BY target_id;

#전체 사용자의 평점 조회
SELECT target_id, AVG(score) AS average_score
FROM DB2025_Evalution
GROUP BY target_id;

#특정 모집글에서 평점 높은 순으로 조회
SELECT * 
FROM DB2025_Evalution
WHERE recruitment_id = 1
ORDER BY score DESC;
