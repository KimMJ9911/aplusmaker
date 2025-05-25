-- ========================
-- 0. 데이터베이스 및 초기화
-- ========================
SET foreign_key_checks = 0;
DROP TABLE IF EXISTS problem_records;
DROP TABLE IF EXISTS problem_record_group;
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS problems;

SET foreign_key_checks = 1;

-- ========================
-- 1. users
-- ========================
CREATE TABLE IF NOT EXISTS users (
                                     id BIGINT NOT NULL AUTO_INCREMENT,
                                     username VARCHAR(100) NOT NULL,
                                     password VARCHAR(255) NOT NULL,
                                     name VARCHAR(100) NOT NULL,
                                     nickname VARCHAR(100),
                                     birth_date DATE,
                                     email VARCHAR(255) NOT NULL,
                                     phone VARCHAR(50),
                                     college_auth VARCHAR(65) NOT NULL,
                                     created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                     CONSTRAINT pk_users PRIMARY KEY (id),
                                     CONSTRAINT uk_users_user_id UNIQUE (username),
                                     CONSTRAINT uk_users_email UNIQUE (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================
-- 2. articles
-- ========================
CREATE TABLE IF NOT EXISTS articles (
                                        article_id BIGINT NOT NULL AUTO_INCREMENT,
                                        user_id BIGINT,
                                        subject_name VARCHAR(100) NOT NULL,
                                        keywords VARCHAR(255),
                                        question_text TEXT NOT NULL,
                                        answer_text TEXT,
                                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                        CONSTRAINT pk_articles PRIMARY KEY (article_id),
                                        CONSTRAINT fk_articles_users_id FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================
-- 3. problems
-- ========================
CREATE TABLE IF NOT EXISTS problems (
                                        problem_id BIGINT NOT NULL AUTO_INCREMENT,
                                        subject VARCHAR(100) NOT NULL,
                                        keywords VARCHAR(255),
                                        question_text TEXT NOT NULL,
                                        answer_text TEXT,
                                        question_type INT NOT NULL,
                                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                        CONSTRAINT pk_problems PRIMARY KEY (problem_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================
-- 4. comments
-- ========================
CREATE TABLE IF NOT EXISTS comments (
                                        comment_id BIGINT NOT NULL AUTO_INCREMENT,
                                        article_id BIGINT,
                                        user_id BIGINT,
                                        content TEXT NOT NULL,
                                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                        CONSTRAINT pk_comments PRIMARY KEY (comment_id),
                                        CONSTRAINT fk_comments_articles_id FOREIGN KEY (article_id) REFERENCES articles(article_id),
                                        CONSTRAINT fk_comments_users_id FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================
-- 5. likes
-- ========================
CREATE TABLE IF NOT EXISTS likes (
                                     like_id BIGINT NOT NULL AUTO_INCREMENT,
                                     article_id BIGINT,
                                     user_id BIGINT,
                                     created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                     CONSTRAINT pk_likes PRIMARY KEY (like_id),
                                     CONSTRAINT fk_likes_articles_id FOREIGN KEY (article_id) REFERENCES articles(article_id),
                                     CONSTRAINT fk_likes_users_id FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================
-- 6. problem_record_group
-- ========================
CREATE TABLE IF NOT EXISTS problem_record_group (
                                                    problem_record_group_id BIGINT NOT NULL AUTO_INCREMENT,
                                                    user_id BIGINT NOT NULL,
                                                    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                                                    keyword VARCHAR(255),
                                                    question_type INT,
                                                    subject VARCHAR(100),
                                                    CONSTRAINT pk_problem_record_group PRIMARY KEY (problem_record_group_id),
                                                    CONSTRAINT fk_record_group_user FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================
-- 7. problem_records
-- ========================
CREATE TABLE IF NOT EXISTS problem_records (
                                               problem_record_id BIGINT NOT NULL AUTO_INCREMENT,
                                               group_id BIGINT NOT NULL,
                                               problem_id BIGINT NOT NULL,
                                               CONSTRAINT pk_problem_records PRIMARY KEY (problem_record_id),
                                               CONSTRAINT fk_record_group FOREIGN KEY (group_id) REFERENCES problem_record_group(problem_record_group_id),
                                               CONSTRAINT fk_record_problem FOREIGN KEY (problem_id) REFERENCES problems(problem_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ========================
-- 6. 초기 데이터 삽입
-- ========================
-- users
INSERT IGNORE INTO users (id, username, password, name, nickname, birth_date, email, phone, college_auth, created_at)
VALUES
    (1, 'user001', 'pass1234', '김훈', '훈이', '2000-01-01', 'hoon@example.com', '01012345678', 1, CURRENT_TIMESTAMP),
    (2, 'user002', 'pass5678', '태훈', '태훈짱', '1999-05-05', 'taehoon@example.com', '01087654321', 0, CURRENT_TIMESTAMP);

-- articles
-- ========================
-- 추가 articles 데이터 1~20
-- ========================
INSERT INTO articles (article_id, user_id, subject_name, keywords, question_text, answer_text, created_at)
VALUES (1, 1, '웹프로그래밍', 'spring,boot,java', 'Spring Boot는 무엇인가요?', 'Spring Boot는 Java 기반 웹 애플리케이션 개발을 쉽게 해주는 프레임워크입니다.',
        '2025-04-12 10:00:00'),
       (2, 2, '자료구조', 'stack,queue', '스택과 큐의 차이는?', '스택은 LIFO, 큐는 FIFO입니다.', '2025-04-13 10:00:00'),
       (3, 1, '알고리즘', 'dfs,bfs', 'DFS는 언제 사용하나요?', '그래프에서 깊이 우선 탐색을 할 때 사용됩니다.', '2025-04-14 10:00:00'),
       (4, 2, '네트워크', 'tcp,udp', 'TCP와 UDP의 차이점은?', 'TCP는 신뢰성이 있고, UDP는 빠르지만 비신뢰성입니다.', '2025-04-15 10:00:00'),
       (5, 1, '운영체제', 'process,thread', '프로세스와 스레드의 차이?', '프로세스는 독립된 실행 단위, 스레드는 경량 프로세스입니다.', '2025-04-16 10:00:00'),
       (6, 2, 'DB', 'sql,join', 'SQL JOIN에는 어떤 것이 있나요?', 'INNER, LEFT, RIGHT, FULL JOIN이 있습니다.', '2025-04-17 10:00:00'),
       (7, 1, '컴퓨터구조', 'cpu,alu', 'ALU는 무엇인가요?', '산술 및 논리 연산을 수행하는 장치입니다.', '2025-04-18 10:00:00'),
       (8, 2, '자료구조', 'tree,heap', '힙과 트리의 차이는?', '힙은 우선순위 큐에 사용되는 특수한 트리입니다.', '2025-04-19 10:00:00'),
       (9, 1, '알고리즘', 'sort', '퀵정렬의 평균 시간 복잡도는?', 'O(n log n)입니다.', '2025-04-20 10:00:00'),
       (10, 2, '보안', 'hash,encrypt', '해시와 암호화의 차이?', '해시는 단방향, 암호화는 복호화 가능.', '2025-04-21 10:00:00'),
       (11, 1, '웹', 'http,https', 'HTTPS의 장점은?', '데이터 암호화로 보안성이 높습니다.', '2025-04-22 10:00:00'),
       (12, 2, '자료구조', 'graph', '그래프의 인접 행렬이란?', '정점 간 연결을 2차원 배열로 표현한 것.', '2025-04-23 10:00:00'),
       (13, 1, '운영체제', 'paging', '페이징 기법이란?', '가상 메모리를 일정 크기 페이지로 나누는 기법.', '2025-04-24 10:00:00'),
       (14, 2, 'DB', 'normalization', '정규화란?', '데이터 중복을 줄이고 무결성을 유지하기 위한 설계.', '2025-04-25 10:00:00'),
       (15, 1, '네트워크', 'dns', 'DNS의 역할은?', '도메인 이름을 IP 주소로 변환.', '2025-04-26 10:00:00'),
       (16, 2, '보안', 'ssl', 'SSL이란?', '네트워크 통신을 암호화하는 보안 프로토콜.', '2025-04-27 10:00:00'),
       (17, 1, '웹', 'cookie,session', '쿠키와 세션 차이점은?', '쿠키는 클라이언트, 세션은 서버에 저장.', '2025-04-28 10:00:00'),
       (18, 2, '알고리즘', 'greedy', '그리디 알고리즘이란?', '매 단계 최선의 선택을 하는 방식.', '2025-04-29 10:00:00'),
       (19, 1, '컴퓨터구조', 'cache', '캐시 메모리란?', '자주 사용하는 데이터를 임시 저장하는 고속 메모리.', '2025-04-30 10:00:00'),
       (20, 2, '운영체제', 'scheduling', 'CPU 스케줄링이란?', '프로세스에 CPU를 할당하는 방법.', '2025-05-01 10:00:00');

-- problems
INSERT INTO problems (problem_id, subject, keywords, question_text, answer_text, question_type, created_at)
VALUES (1, '자료구조', 'stack,queue', '자료구조 주관식 문제 1는 무엇인가요?', '자료구조 주관식 문제 1의 정답입니다.', 0, CURRENT_TIMESTAMP),
       (2, '자료구조', 'stack,queue', '자료구조 주관식 문제 2는 무엇인가요?', '자료구조 주관식 문제 2의 정답입니다.', 0, CURRENT_TIMESTAMP),
       (3, '자료구조', 'stack,queue', '자료구조 주관식 문제 3는 무엇인가요?', '자료구조 주관식 문제 3의 정답입니다.', 0, CURRENT_TIMESTAMP),
       (4, '자료구조', 'stack,queue', '자료구조 주관식 문제 4는 무엇인가요?', '자료구조 주관식 문제 4의 정답입니다.', 0, CURRENT_TIMESTAMP),
       (5, '자료구조', 'stack,queue', '자료구조 주관식 문제 5는 무엇인가요?', '자료구조 주관식 문제 5의 정답입니다.', 0, CURRENT_TIMESTAMP),
       (6, '자료구조', 'stack,queue', '자료구조 주관식 문제 6는 무엇인가요?', '자료구조 주관식 문제 6의 정답입니다.', 0, CURRENT_TIMESTAMP),
       (7, '자료구조', 'stack,queue', '자료구조 주관식 문제 7는 무엇인가요?', '자료구조 주관식 문제 7의 정답입니다.', 0, CURRENT_TIMESTAMP),
       (8, '자료구조', 'stack,queue', '자료구조 주관식 문제 8는 무엇인가요?', '자료구조 주관식 문제 8의 정답입니다.', 0, CURRENT_TIMESTAMP),
       (9, '자료구조', 'stack,queue', '자료구조 주관식 문제 9는 무엇인가요?', '자료구조 주관식 문제 9의 정답입니다.', 0, CURRENT_TIMESTAMP),
       (10, '자료구조', 'stack,queue', '자료구조 주관식 문제 10는 무엇인가요?', '자료구조 주관식 문제 10의 정답입니다.', 0, CURRENT_TIMESTAMP),

       (11, '알고리즘', 'dfs,bfs', '알고리즘 객관식 문제 1는 무엇인가요?', '알고리즘 객관식 문제 1의 정답입니다.', 1, CURRENT_TIMESTAMP),
       (12, '알고리즘', 'dfs,bfs', '알고리즘 객관식 문제 2는 무엇인가요?', '알고리즘 객관식 문제 2의 정답입니다.', 1, CURRENT_TIMESTAMP),
       (13, '알고리즘', 'dfs,bfs', '알고리즘 객관식 문제 3는 무엇인가요?', '알고리즘 객관식 문제 3의 정답입니다.', 1, CURRENT_TIMESTAMP),
       (14, '알고리즘', 'dfs,bfs', '알고리즘 객관식 문제 4는 무엇인가요?', '알고리즘 객관식 문제 4의 정답입니다.', 1, CURRENT_TIMESTAMP),
       (15, '알고리즘', 'dfs,bfs', '알고리즘 객관식 문제 5는 무엇인가요?', '알고리즘 객관식 문제 5의 정답입니다.', 1, CURRENT_TIMESTAMP),
       (16, '알고리즘', 'dfs,bfs', '알고리즘 객관식 문제 6는 무엇인가요?', '알고리즘 객관식 문제 6의 정답입니다.', 1, CURRENT_TIMESTAMP),
       (17, '알고리즘', 'dfs,bfs', '알고리즘 객관식 문제 7는 무엇인가요?', '알고리즘 객관식 문제 7의 정답입니다.', 1, CURRENT_TIMESTAMP),
       (18, '알고리즘', 'dfs,bfs', '알고리즘 객관식 문제 8는 무엇인가요?', '알고리즘 객관식 문제 8의 정답입니다.', 1, CURRENT_TIMESTAMP),
       (19, '알고리즘', 'dfs,bfs', '알고리즘 객관식 문제 9는 무엇인가요?', '알고리즘 객관식 문제 9의 정답입니다.', 1, CURRENT_TIMESTAMP),
       (20, '알고리즘', 'dfs,bfs', '알고리즘 객관식 문제 10는 무엇인가요?', '알고리즘 객관식 문제 10의 정답입니다.', 1, CURRENT_TIMESTAMP),

       (21, '컴퓨터구조', 'cpu,register', '컴퓨터구조 서술형 문제 1는 무엇인가요?', '컴퓨터구조 서술형 문제 1의 정답입니다.', 2, CURRENT_TIMESTAMP),
       (22, '컴퓨터구조', 'cpu,register', '컴퓨터구조 서술형 문제 2는 무엇인가요?', '컴퓨터구조 서술형 문제 2의 정답입니다.', 2, CURRENT_TIMESTAMP),
       (23, '컴퓨터구조', 'cpu,register', '컴퓨터구조 서술형 문제 3는 무엇인가요?', '컴퓨터구조 서술형 문제 3의 정답입니다.', 2, CURRENT_TIMESTAMP),
       (24, '컴퓨터구조', 'cpu,register', '컴퓨터구조 서술형 문제 4는 무엇인가요?', '컴퓨터구조 서술형 문제 4의 정답입니다.', 2, CURRENT_TIMESTAMP),
       (25, '컴퓨터구조', 'cpu,register', '컴퓨터구조 서술형 문제 5는 무엇인가요?', '컴퓨터구조 서술형 문제 5의 정답입니다.', 2, CURRENT_TIMESTAMP),
       (26, '컴퓨터구조', 'cpu,register', '컴퓨터구조 서술형 문제 6는 무엇인가요?', '컴퓨터구조 서술형 문제 6의 정답입니다.', 2, CURRENT_TIMESTAMP),
       (27, '컴퓨터구조', 'cpu,register', '컴퓨터구조 서술형 문제 7는 무엇인가요?', '컴퓨터구조 서술형 문제 7의 정답입니다.', 2, CURRENT_TIMESTAMP),
       (28, '컴퓨터구조', 'cpu,register', '컴퓨터구조 서술형 문제 8는 무엇인가요?', '컴퓨터구조 서술형 문제 8의 정답입니다.', 2, CURRENT_TIMESTAMP),
       (29, '컴퓨터구조', 'cpu,register', '컴퓨터구조 서술형 문제 9는 무엇인가요?', '컴퓨터구조 서술형 문제 9의 정답입니다.', 2, CURRENT_TIMESTAMP),
       (30, '컴퓨터구조', 'cpu,register', '컴퓨터구조 서술형 문제 10는 무엇인가요?', '컴퓨터구조 서술형 문제 10의 정답입니다.', 2, CURRENT_TIMESTAMP),

       (31, '데이터베이스', 'sql,join', '데이터베이스 O/X 문제 1는 무엇인가요?', '데이터베이스 O/X 문제 1의 정답입니다.', 3, CURRENT_TIMESTAMP),
       (32, '데이터베이스', 'sql,join', '데이터베이스 O/X 문제 2는 무엇인가요?', '데이터베이스 O/X 문제 2의 정답입니다.', 3, CURRENT_TIMESTAMP),
       (33, '데이터베이스', 'sql,join', '데이터베이스 O/X 문제 3는 무엇인가요?', '데이터베이스 O/X 문제 3의 정답입니다.', 3, CURRENT_TIMESTAMP),
       (34, '데이터베이스', 'sql,join', '데이터베이스 O/X 문제 4는 무엇인가요?', '데이터베이스 O/X 문제 4의 정답입니다.', 3, CURRENT_TIMESTAMP),
       (35, '데이터베이스', 'sql,join', '데이터베이스 O/X 문제 5는 무엇인가요?', '데이터베이스 O/X 문제 5의 정답입니다.', 3, CURRENT_TIMESTAMP),
       (36, '데이터베이스', 'sql,join', '데이터베이스 O/X 문제 6는 무엇인가요?', '데이터베이스 O/X 문제 6의 정답입니다.', 3, CURRENT_TIMESTAMP),
       (37, '데이터베이스', 'sql,join', '데이터베이스 O/X 문제 7는 무엇인가요?', '데이터베이스 O/X 문제 7의 정답입니다.', 3, CURRENT_TIMESTAMP),
       (38, '데이터베이스', 'sql,join', '데이터베이스 O/X 문제 8는 무엇인가요?', '데이터베이스 O/X 문제 8의 정답입니다.', 3, CURRENT_TIMESTAMP),
       (39, '데이터베이스', 'sql,join', '데이터베이스 O/X 문제 9는 무엇인가요?', '데이터베이스 O/X 문제 9의 정답입니다.', 3, CURRENT_TIMESTAMP),
       (40, '데이터베이스', 'sql,join', '데이터베이스 O/X 문제 10는 무엇인가요?', '데이터베이스 O/X 문제 10의 정답입니다.', 3, CURRENT_TIMESTAMP),

       (41, '네트워크', 'ip,tcp', '네트워크 단답형 문제 1는 무엇인가요?', '네트워크 단답형 문제 1의 정답입니다.', 4, CURRENT_TIMESTAMP),
       (42, '네트워크', 'ip,tcp', '네트워크 단답형 문제 2는 무엇인가요?', '네트워크 단답형 문제 2의 정답입니다.', 4, CURRENT_TIMESTAMP),
       (43, '네트워크', 'ip,tcp', '네트워크 단답형 문제 3는 무엇인가요?', '네트워크 단답형 문제 3의 정답입니다.', 4, CURRENT_TIMESTAMP),
       (44, '네트워크', 'ip,tcp', '네트워크 단답형 문제 4는 무엇인가요?', '네트워크 단답형 문제 4의 정답입니다.', 4, CURRENT_TIMESTAMP),
       (45, '네트워크', 'ip,tcp', '네트워크 단답형 문제 5는 무엇인가요?', '네트워크 단답형 문제 5의 정답입니다.', 4, CURRENT_TIMESTAMP),
       (46, '네트워크', 'ip,tcp', '네트워크 단답형 문제 6는 무엇인가요?', '네트워크 단답형 문제 6의 정답입니다.', 4, CURRENT_TIMESTAMP),
       (47, '네트워크', 'ip,tcp', '네트워크 단답형 문제 7는 무엇인가요?', '네트워크 단답형 문제 7의 정답입니다.', 4, CURRENT_TIMESTAMP),
       (48, '네트워크', 'ip,tcp', '네트워크 단답형 문제 8는 무엇인가요?', '네트워크 단답형 문제 8의 정답입니다.', 4, CURRENT_TIMESTAMP),
       (49, '네트워크', 'ip,tcp', '네트워크 단답형 문제 9는 무엇인가요?', '네트워크 단답형 문제 9의 정답입니다.', 4, CURRENT_TIMESTAMP),
       (50, '네트워크', 'ip,tcp', '네트워크 단답형 문제 10는 무엇인가요?', '네트워크 단답형 문제 10의 정답입니다.', 4, CURRENT_TIMESTAMP);

-- comments & likes
-- comments: 분산된 패턴으로 수정
INSERT INTO comments (comment_id, article_id, user_id, content, created_at)
VALUES (1, 1, 2, '댓글 내용 1', '2025-04-12 00:00:00'),
       (2, 1, 1, '댓글 내용 2', '2025-04-12 00:00:00'),
       (3, 2, 2, '댓글 내용 3', '2025-04-13 00:00:00'),
       (4, 3, 1, '댓글 내용 4', '2025-04-14 00:00:00'),
       (5, 3, 2, '댓글 내용 5', '2025-04-14 00:00:00'),
       (6, 3, 1, '댓글 내용 6', '2025-04-14 00:00:00'),
       (7, 4, 2, '댓글 내용 7', '2025-04-15 00:00:00'),
       (8, 4, 1, '댓글 내용 8', '2025-04-15 00:00:00'),
       (9, 4, 2, '댓글 내용 9', '2025-04-15 00:00:00'),
       (10, 5, 1, '댓글 내용 10', '2025-04-16 00:00:00'),
       (11, 6, 2, '댓글 내용 11', '2025-04-17 00:00:00'),
       (12, 6, 1, '댓글 내용 12', '2025-04-17 00:00:00'),
       (13, 6, 2, '댓글 내용 13', '2025-04-17 00:00:00'),
       (14, 6, 1, '댓글 내용 14', '2025-04-17 00:00:00'),
       (15, 7, 2, '댓글 내용 15', '2025-04-18 00:00:00'),
       (16, 8, 1, '댓글 내용 16', '2025-04-19 00:00:00'),
       (17, 8, 2, '댓글 내용 17', '2025-04-19 00:00:00'),
       (18, 8, 1, '댓글 내용 18', '2025-04-19 00:00:00'),
       (19, 8, 2, '댓글 내용 19', '2025-04-19 00:00:00'),
       (20, 8, 1, '댓글 내용 20', '2025-04-19 00:00:00'),
       (21, 9, 2, '댓글 내용 21', '2025-04-20 00:00:00'),
       (22, 10, 1, '댓글 내용 22', '2025-04-21 00:00:00'),
       (23, 10, 2, '댓글 내용 23', '2025-04-21 00:00:00'),
       (24, 11, 1, '댓글 내용 24', '2025-04-22 00:00:00'),
       (25, 11, 2, '댓글 내용 25', '2025-04-22 00:00:00'),
       (26, 11, 1, '댓글 내용 26', '2025-04-22 00:00:00'),
       (27, 11, 2, '댓글 내용 27', '2025-04-22 00:00:00'),
       (28, 12, 1, '댓글 내용 28', '2025-04-23 00:00:00'),
       (29, 13, 2, '댓글 내용 29', '2025-04-24 00:00:00'),
       (30, 14, 1, '댓글 내용 30', '2025-04-25 00:00:00'),
       (31, 14, 2, '댓글 내용 31', '2025-04-25 00:00:00'),
       (32, 14, 1, '댓글 내용 32', '2025-04-25 00:00:00'),
       (33, 14, 2, '댓글 내용 33', '2025-04-25 00:00:00'),
       (34, 14, 1, '댓글 내용 34', '2025-04-25 00:00:00'),
       (35, 14, 2, '댓글 내용 35', '2025-04-25 00:00:00');

-- likes: 각 article_id당 좋아요 수 다양하게 설정
INSERT INTO likes (like_id, article_id, user_id, created_at)
VALUES (1, 1, 1, '2025-04-12 10:00:00'),
       (2, 1, 2, '2025-04-12 10:30:00'),
       (3, 2, 1, '2025-04-13 12:00:00'),
       (4, 3, 2, '2025-04-14 14:00:00'),
       (5, 3, 1, '2025-04-14 14:05:00'),
       (6, 4, 1, '2025-04-15 15:00:00'),
       (7, 5, 2, '2025-04-16 16:00:00'),
       (8, 5, 1, '2025-04-16 16:10:00'),
       (9, 6, 1, '2025-04-17 09:00:00'),
       (10, 6, 2, '2025-04-17 09:10:00'),
       (11, 6, 1, '2025-04-17 09:15:00'),
       (12, 8, 1, '2025-04-19 10:00:00'),
       (13, 8, 2, '2025-04-19 10:05:00'),
       (14, 8, 1, '2025-04-19 10:10:00'),
       (15, 8, 2, '2025-04-19 10:15:00'),
       (16, 9, 1, '2025-04-20 11:00:00'),
       (17, 10, 2, '2025-04-21 12:00:00'),
       (18, 10, 1, '2025-04-21 12:10:00'),
       (19, 11, 1, '2025-04-22 13:00:00'),
       (20, 11, 2, '2025-04-22 13:20:00'),
       (21, 12, 1, '2025-04-23 14:00:00'),
       (22, 13, 2, '2025-04-24 15:00:00'),
       (23, 14, 1, '2025-04-25 16:00:00'),
       (24, 14, 2, '2025-04-25 16:05:00'),
       (25, 14, 1, '2025-04-25 16:10:00'),
       (26, 14, 2, '2025-04-25 16:15:00'),
       (27, 15, 1, '2025-04-26 17:00:00'),
       (28, 15, 2, '2025-04-26 17:10:00'),
       (29, 16, 1, '2025-04-27 18:00:00'),
       (30, 16, 2, '2025-04-27 18:10:00'),
       (31, 17, 1, '2025-04-28 18:20:00'),
       (32, 18, 1, '2025-04-29 19:00:00'),
       (33, 18, 2, '2025-04-29 19:10:00'),
       (34, 19, 1, '2025-04-30 20:00:00'),
       (35, 20, 2, '2025-05-01 21:00:00');

-- problem_record_group
INSERT INTO problem_record_group (problem_record_group_id, user_id, created_at, keyword, question_type, subject)
VALUES (1, 1, CURRENT_TIMESTAMP, 'tcp', 2, '컴퓨터구조'),
       (2, 1, CURRENT_TIMESTAMP, 'join', 3, '데이터베이스'),
       (3, 1, CURRENT_TIMESTAMP, 'tcp', 2, '컴퓨터구조'),
       (4, 2, CURRENT_TIMESTAMP, 'stack', 3, '데이터베이스'),
       (5, 2, CURRENT_TIMESTAMP, 'bfs', 2, '알고리즘'),
       (6, 2, CURRENT_TIMESTAMP, 'cpu', 3, '데이터베이스');

-- problem_records
INSERT INTO problem_records (problem_record_id, group_id, problem_id)
VALUES (1, 1, 21),
       (2, 1, 22),
       (3, 1, 23),
       (4, 1, 24),
       (5, 1, 25),
       (6, 2, 31),
       (7, 2, 32),
       (8, 2, 33),
       (9, 2, 34),
       (10, 2, 35),
       (11, 3, 21),
       (12, 3, 22),
       (13, 3, 23),
       (14, 3, 24),
       (15, 3, 25),
       (16, 4, 31),
       (17, 4, 32),
       (18, 4, 33),
       (19, 4, 34),
       (20, 4, 35),
       (21, 5, 21),
       (22, 5, 22),
       (23, 5, 23),
       (24, 5, 24),
       (25, 5, 25),
       (26, 6, 31),
       (27, 6, 32),
       (28, 6, 33),
       (29, 6, 34),
       (30, 6, 35);
