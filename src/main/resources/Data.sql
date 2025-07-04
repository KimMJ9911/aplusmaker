
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
# -- problems
# INSERT INTO problems (subject,
#                       keywords,
#                       question_text,
#                       answer_text,
#                       question_type,
#                       created_at)
# VALUES
# -- 자료구조
# ('자료구조', 'stack,queue,array',
#  '스택(Stack)과 큐(Queue)의 차이점을 설명하시오.',
#  '스택은 후입선출(LIFO) 방식으로, 마지막에 삽입된 요소를 먼저 제거하며 주로 함수 호출, 되돌리기 기능 등에 사용된다. 큐는 선입선출(FIFO) 방식으로, 먼저 삽입된 요소를 먼저 제거하며 작업 스케줄링, 너비 우선 탐색 등에 사용된다.',
#  0, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '배열(Array) 기반으로 구현된 원형 큐(Circular Queue)의 장점을 설명하시오.',
#  '고정된 크기의 배열을 순환(buffer) 형태로 사용하여 메모리 낭비 없이 연속된 공간을 효율적으로 활용할 수 있으며, 비어 있거나 가득 찼음을 간단한 인덱스 연산으로 판단할 수 있다.',
#  0, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '동적 배열(Dynamic Array)과 연결 리스트(Linked List)의 장단점을 비교하시오.',
#  '동적 배열은 인덱스로 임의 접근이 O(1)로 빠르지만, 크기 변경 시 재할당 비용이 발생할 수 있다. 연결 리스트는 삽입·삭제가 리스트 중간에서도 O(1)에 가능하지만, 임의 접근이 O(n)으로 느리고 메모리 오버헤드가 크다.',
#  0, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '이중 연결 리스트(Doubly Linked List)의 구조와 주요 연산을 설명하시오.',
#  '각 노드가 이전(prev)과 다음(next) 포인터를 모두 가지는 리스트로, 양방향 탐색이 가능하다. 삽입과 삭제가 O(1)로 빠르며, 헤드·테일 노드 관리가 편리하다.',
#  0, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '해시 테이블(Hash Table)에서 충돌(Collision) 해결 기법 두 가지를 설명하시오.',
#  '1) 체이닝(Chaining): 버킷마다 연결 리스트를 두어 충돌 시 해당 리스트에 요소를 추가한다. 2) 오픈 어드레싱(Open Addressing): 빈 슬롯이 나올 때까지 해시 값에 따라 일정 간격으로 탐색하여 저장한다.',
#  0, CURRENT_TIMESTAMP),
#
# -- 보안
# ('보안', '암호,인증,취약점',
#  '대칭키 암호화(Symmetric Encryption)와 비대칭키 암호화(Asymmetric Encryption)의 차이점을 설명하시오.',
#  '대칭키 암호화는 암호화·복호화에 같은 키를 사용하므로 속도가 빠르지만 키 분배 문제가 있다. 비대칭키 암호화는 공개키·개인키 한 쌍을 사용하며 키 분배가 용이하지만 연산 비용이 높다.',
#  0, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'SSL/TLS 프로토콜의 주요 역할을 설명하시오.',
#  'SSL/TLS는 네트워크 통신에서 기밀성, 무결성, 인증을 제공하여 중간자 공격 방지, 데이터 암호화, 서버 및 클라이언트 인증을 수행한다.',
#  0, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'SQL 인젝션(SQL Injection) 공격이란 무엇이며, 방어 기법을 하나 설명하시오.',
#  '공격자가 입력값에 SQL 구문을 삽입하여 데이터베이스를 조작하는 기법이다. 방어 기법으로는 Prepared Statement(파라미터화된 쿼리)를 사용해 입력값을 쿼리 구조와 분리하는 방법이 있다.',
#  0, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  '크로스 사이트 스크립팅(XSS) 공격의 종류를 두 가지 설명하시오.',
#  '1) Stored XSS: 악성 스크립트를 서버에 저장 후 사용자에게 전달. 2) Reflected XSS: 링크나 파라미터를 통해 악성 스크립트를 즉시 실행.',
#  0, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'OAuth 2.0 인증 방식에서 Authorization Code Grant 흐름을 간단히 설명하시오.',
#  '1) 클라이언트가 인증 서버에 인증 요청 → 2) 사용자 로그인 및 허가 → 3) 인증 서버가 Authorization Code 발급 → 4) 클라이언트가 코드로 Access Token 요청 → 5) 토큰 수령 후 API 호출.',
#  0, CURRENT_TIMESTAMP),
#
# -- 웹서비스응용
# ('웹서비스응용', 'REST,API,JSON',
#  'REST 아키텍처의 6가지 제약 조건 중 하나를 설명하시오.',
#  'Stateless: 각 요청은 독립적이어야 하며, 세션 상태를 서버에 저장하지 않아야 한다. 클라이언트가 필요한 모든 상태를 요청에 포함해야 한다.',
#  0, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'HTTP 메서드 PUT과 PATCH의 차이점을 설명하시오.',
#  'PUT은 자원 전체를 교체하며 멱등성(idempotent)을 보장한다. PATCH는 자원의 일부만 수정하며, 멱등성을 보장하지 않을 수도 있다.',
#  0, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'CORS(Cross-Origin Resource Sharing)가 필요한 이유를 설명하시오.',
#  '브라우저의 동일 출처 정책(SOP)으로 인해 다른 도메인 간 AJAX 요청이 차단된다. CORS는 서버가 허용 헤더를 통해 특정 출처의 요청을 허용하도록 설정하는 메커니즘이다.',
#  0, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'JSON과 XML 형식의 장단점을 비교하시오.',
#  'JSON은 가독성이 높고 파싱 속도가 빠르며 데이터 크기가 작다. XML은 메타데이터 및 스키마 정의 기능이 풍부하지만, 문법이 복잡하고 데이터 크기가 크다.',
#  0, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  '웹소켓(WebSocket)과 HTTP 장/단점을 비교하시오.',
#  '웹소켓은 양방향(full-duplex) 통신을 지원하며 실시간성이 뛰어나지만, 초기 핸드쉐이크가 필요하다. HTTP는 요청-응답 구조로 단방향이지만, 널리 지원되고 구현이 간단하다.',
#  0, CURRENT_TIMESTAMP),
# -- 자료구조 객관식
# ('자료구조', 'stack,queue,array',
#  '다음 중 큐(Queue)의 특징으로 옳은 것은? (A) LIFO (B) FIFO (C) 연결 리스트 기반 (D) 임의 접근(O(1))',
#  'B. FIFO',
#  1, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '다음 중 해시 테이블에서 체이닝(Chaining) 기법을 설명한 것은? (A) 빈 슬롯을 찾아 저장 (B) 동일 버킷의 리스트에 추가 (C) 이차 해싱 사용 (D) 개방 주소법 사용',
#  'B. 동일 버킷의 리스트에 추가',
#  1, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '이중 연결 리스트(Doubly Linked List)의 장점이 아닌 것은? (A) 양방향 탐색 가능 (B) 삽입·삭제가 O(1) (C) 임의 접근이 O(1) (D) 헤드·테일 관리 용이',
#  'C. 임의 접근이 O(1)',
#  1, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '스택(Stack) 오버플로우(Stack Overflow)가 발생하는 조건은? (A) 스택이 비었을 때 POP 수행 (B) 스택이 가득 찼을 때 PUSH 수행 (C) 잘못된 포인터 참조 (D) 배열 크기 변경',
#  'B. 스택이 가득 찼을 때 PUSH 수행',
#  1, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '원형 큐(Circular Queue)에서 다음 인덱스 계산식으로 옳은 것은? (A) (rear+1)%capacity (B) (front-1+capacity)%capacity (C) rear+1 (D) front-1',
#  'A. (rear+1)%capacity',
#  1, CURRENT_TIMESTAMP),
#
# -- 보안 객관식
# ('보안', '암호,인증,취약점',
#  '다음 중 비대칭키 암호화(Asymmetric Encryption) 알고리즘이 아닌 것은? (A) RSA (B) AES (C) ECC (D) DSA',
#  'B. AES',
#  1, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'SSL/TLS 핸드쉐이크 과정에 포함되지 않는 단계는? (A) ClientHello (B) Certificate (C) Data Transfer (D) ServerHello',
#  'C. Data Transfer',
#  1, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'SQL 인젝션(SQL Injection) 방어 기법이 아닌 것은? (A) Prepared Statement (B) 입력 검증 (C) ORM 사용 (D) 쿼리 문자열 직접 연결',
#  'D. 쿼리 문자열 직접 연결',
#  1, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'OAuth 2.0 Grant Types 중 Authorization Code Grant에 해당하지 않는 것은? (A) Authorization Code Grant (B) Implicit Grant (C) Resource Owner Password Credentials Grant (D) Client Credentials Grant',
#  'D. Client Credentials Grant',
#  1, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  '다음 중 크로스 사이트 스크립팅(XSS) 공격 유형이 아닌 것은? (A) Stored XSS (B) Reflected XSS (C) DOM-based XSS (D) SQL-based XSS',
#  'D. SQL-based XSS',
#  1, CURRENT_TIMESTAMP),
#
# -- 웹서비스응용 객관식
# ('웹서비스응용', 'REST,API,JSON',
#  'REST 아키텍처 제약 조건이 아닌 것은? (A) Stateless (B) Layered System (C) Client-Driven State (D) Cacheable',
#  'C. Client-Driven State',
#  1, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'HTTP GET 메서드의 특징으로 옳지 않은 것은? (A) 멱등성(idempotent) (B) 안전성(safe) (C) 요청 바디 사용 (D) 캐시 가능',
#  'C. 요청 바디 사용',
#  1, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'CORS 설정 시 사용하는 헤더가 아닌 것은? (A) Access-Control-Allow-Origin (B) Access-Control-Allow-Methods (C) Access-Control-Allow-Headers (D) Access-Control-Request-Body',
#  'D. Access-Control-Request-Body',
#  1, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'JSON과 비교했을 때 XML의 장점이 아닌 것은? (A) 스키마 정의 지원 (B) 가독성 높음 (C) 네임스페이스 지원 (D) 주석 사용 가능',
#  'B. 가독성 높음',
#  1, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  '웹소켓(WebSocket) 핸드셰이크에서 사용하는 HTTP 메서드는? (A) CONNECT (B) GET (C) POST (D) OPTIONS',
#  'B. GET',
#  1, CURRENT_TIMESTAMP),
# -- 자료구조 단답형
# ('자료구조', 'stack,queue,array',
#  'DFS와 BFS의 주요 차이점을 간단히 서술하시오.',
#  'DFS는 깊이 우선 탐색, BFS는 너비 우선 탐색.',
#  2, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '스택의 push 및 pop 연산의 시간 복잡도를 서술하시오.',
#  'O(1)',
#  2, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '해시 테이블의 평균 검색 시간 복잡도를 서술하시오.',
#  'O(1)',
#  2, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '이중 연결 리스트에서 노드 삽입 연산의 시간 복잡도를 서술하시오.',
#  'O(1)',
#  2, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '원형 큐에서 포화 상태를 판단하는 조건식을 서술하시오.',
#  '(rear+1)%capacity = front',
#  2, CURRENT_TIMESTAMP),
#
# -- 보안 단답형
# ('보안', '암호,인증,취약점',
#  '대칭키 암호화 알고리즘의 예시를 하나 서술하시오.',
#  'AES',
#  2, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'TLS(또는 HTTPS)의 기본 포트 번호를 서술하시오.',
#  '443',
#  2, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'XSS 공격 중 Stored XSS의 특징을 서술하시오.',
#  '악성 스크립트가 서버에 저장되어 모든 사용자에게 전달됨',
#  2, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'CSRF 공격을 방어하는 기법을 하나 서술하시오.',
#  'CSRF 토큰 사용',
#  2, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'OAuth 2.0에서 Access Token의 역할을 서술하시오.',
#  '리소스 서버에 대한 접근 권한을 증명함',
#  2, CURRENT_TIMESTAMP),
#
# -- 웹서비스응용 단답형
# ('웹서비스응용', 'REST,API,JSON',
#  'REST에서 리소스 식별자를 의미하는 것은?',
#  'URI(또는 URL)',
#  2, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  '멱등성(idempotent)의 의미를 간단히 서술하시오.',
#  '여러 번 수행해도 결과가 동일함',
#  2, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'CORS의 Access-Control-Allow-Origin 헤더의 역할을 서술하시오.',
#  '허용된 출처를 지정함',
#  2, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'JSON의 MIME 타입을 서술하시오.',
#  'application/json',
#  2, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  '웹소켓 연결에서 사용하는 URI 스킴을 서술하시오.',
#  'ws:// 또는 wss://',
#  2, CURRENT_TIMESTAMP),
# -- 자료구조 O/X
# ('자료구조', 'stack,queue,array',
#  '스택은 후입선출(LIFO) 방식을 사용한다.',
#  'O', 3, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '큐는 마지막에 삽입된 요소를 먼저 제거한다.',
#  'X', 3, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '이중 연결 리스트는 양방향 탐색이 가능하다.',
#  'O', 3, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '해시 테이블 충돌 해결 기법 중 오픈 어드레싱은 연결 리스트를 사용한다.',
#  'X', 3, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '원형 큐에서 (rear+1)%capacity 연산으로 다음 위치를 계산할 수 있다.',
#  'O', 3, CURRENT_TIMESTAMP),
#
# -- 보안 O/X
# ('보안', '암호,인증,취약점',
#  '대칭키 암호화는 암호화와 복호화에 동일한 키를 사용한다.',
#  'O', 3, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  '비대칭키 암호화는 키 분배 문제가 더 적다.',
#  'O', 3, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'SSL/TLS 프로토콜은 데이터 전송 시 암호화를 제공하지 않는다.',
#  'X', 3, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'Prepared Statement는 SQL 인젝션 공격 방어 기법이다.',
#  'O', 3, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'Stored XSS는 악성 스크립트를 즉시 반영하여 실행하는 공격이다.',
#  'X', 3, CURRENT_TIMESTAMP),
#
# -- 웹서비스응용 O/X
# ('웹서비스응용', 'REST,API,JSON',
#  'REST는 상태 저장(stateful)을 기본으로 한다.',
#  'X', 3, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'HTTP GET 메서드는 일반적으로 멱등성을 보장한다.',
#  'O', 3, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'CORS는 클라이언트가 임의 도메인에 요청을 보내는 것을 완전히 차단한다.',
#  'X', 3, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'PATCH는 리소스의 전체 교체를 수행한다.',
#  'X', 3, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  '웹소켓은 초기 핸드셰이크 시 HTTP GET 메서드를 사용한다.',
#  'O', 3, CURRENT_TIMESTAMP),
# -- 자료구조 서술형
# ('자료구조', 'stack,queue,array',
#  'Stack과 Queue를 구현할 때 동적 배열(Dynamic Array)과 연결 리스트(Linked List) 중 어떤 자료구조를 선택해야 하는지, 이유와 장단점을 기술하시오.',
#  '동적 배열은 임의 접근이 O(1)로 빠르며 메모리 연속성을 이용해 캐시 성능이 좋지만, 크기 변경 시 재할당 및 복사 비용이 발생합니다. 연결 리스트는 삽입·삭제가 리스트 중간에서도 O(1)로 가능하며 크기 제약이 없으나, 임의 접근이 O(n)으로 느리고 각 노드에 포인터를 저장하느라 메모리 오버헤드가 큽니다. 따라서 요소 개수가 자주 변하지 않고 임의 접근이 중요하다면 동적 배열을, 빈번한 삽입·삭제가 필요하다면 연결 리스트를 선택하는 것이 적절합니다.',
#  4, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '해시 테이블의 성능을 향상시키기 위한 로드 팩터(load factor)의 개념과 최적값 설정 기준에 대해 설명하시오.',
#  '로드 팩터는 해시 테이블에 저장된 요소 수를 버킷 수로 나눈 비율로, α = n/m 형태로 표현됩니다. α가 너무 크면 충돌 발생률이 높아지고 성능이 저하되며, α가 너무 작으면 메모리 낭비가 발생합니다. 일반적으로 개방 주소법에서는 0.5~0.7, 체이닝에서는 0.75~1.0 정도를 최적값으로 설정하여 성능과 메모리 사용의 균형을 맞춥니다.',
#  4, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '이중 연결 리스트(Doubly Linked List)와 단일 연결 리스트(Singly Linked List)를 실제 사용 사례와 함께 비교하여 설명하시오.',
#  '이중 연결 리스트는 이전(prev)과 다음(next) 포인터를 모두 가지므로 양방향 탐색이 가능하고, Tail에서부터의 탐색이나 노드 삭제 시 이전 노드 참조가 용이합니다. 반면 단일 연결 리스트는 메모리 오버헤드가 더 적고 구조가 단순해 삽입·삭제 구현이 비교적 간단합니다. 예를 들어, 캐시 구현(LRU)에서는 빈번한 양방향 탐색이 필요해 이중 연결 리스트를 사용하고, 간단한 단방향 큐나 스택에서는 단일 연결 리스트를 사용합니다.',
#  4, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '원형 큐(Circular Queue)의 구현 방법과 링 버퍼에서 발생할 수 있는 오버플로우 및 언더플로우 문제를 어떻게 방지할 수 있는지 설명하시오.',
#  '원형 큐는 고정 크기 배열을 사용해 head와 tail 포인터를 %연산으로 순환시킵니다. 오버플로우는 (tail+1)%capacity == head일 때, 언더플로우는 head == tail일 때 발생합니다. 이를 방지하려면 요소 개수를 별도로 카운팅하거나, 배열 크기를 실제 저장 가능 수보다 하나 크게 잡아 “빈 슬롯”을 구분하여 처리합니다.',
#  4, CURRENT_TIMESTAMP),
# ('자료구조', 'stack,queue,array',
#  '동적 배열에서 크기 재할당이 발생하는 과정을 예를 들어 설명하고, 암제적 확장(amortized expansion)의 의미를 서술하시오.',
#  '예를 들어 초기 용량이 4인 동적 배열에 5번째 요소를 추가할 때, 내부 배열을 새 용량(보통 ×2)인 8로 재할당하고 기존 요소를 복사합니다. 이 과정은 단일 연산으로는 O(n)이지만, 연산을 여러 번 수행했을 때 전체 비용을 연산 횟수로 나누면 평균적으로 O(1)로 떨어지는 것을 암제적 확장이라고 합니다.',
#  4, CURRENT_TIMESTAMP),
#
# -- 보안 서술형
# ('보안', '암호,인증,취약점',
#  'TLS 핸드쉐이크 과정의 주요 단계(ClientHello, ServerHello, Certificate 교환 등)를 상세히 설명하시오.',
#  '1) ClientHello: 클라이언트가 지원하는 암호화 스위트, 랜덤값을 서버에 전송. 2) ServerHello: 서버가 선택한 암호화 스위트와 랜덤값 응답. 3) Certificate: 서버 인증서 전송. 4) ServerKeyExchange(필요 시): 서버 공개키 관련 추가 정보. 5) ClientKeyExchange: 클라이언트가 프리마스터 시크릿을 서버 공개키로 암호화하여 전송. 6) ChangeCipherSpec: 이후 메시지를 새 암호화 설정으로 전송함을 알림. 7) Finished: 핸드쉐이크 무결성 검증용 해시를 주고받아 완료.',
#  4, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'OAuth 2.0의 Resource Owner Password Credentials Grant 흐름을 단계별로 설명하고, 보안 상의 단점을 논하시오.',
#  '1) 사용자가 클라이언트에 사용자명/비밀번호 제공. 2) 클라이언트가 이를 Authorization Server에 전송해 토큰 요청. 3) 서버가 자격증명을 검증 후 액세스 토큰 발급. 단점: 클라이언트가 사용자 비밀번호 취급으로 신뢰 수준이 높아야 하며, 다른 공격에 취약해 보안 리스크가 크다.',
#  4, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'CSRF(Cross-Site Request Forgery) 공격이 발생하는 원리와 이를 방지하기 위한 방법을 설명하시오.',
#  'CSRF는 사용자가 인증된 세션을 악성 사이트가 대신 사용해 요청을 보내는 공격입니다. 방지 방법으로는 1) CSRF 토큰: 폼에 숨겨진 토큰을 삽입해 서버가 검증, 2) SameSite 쿠키 속성: 타 사이트 요청 시 쿠키가 전송되지 않도록 설정, 3) Referer 헤더 검증 등을 적용합니다.',
#  4, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  'XSS 공격(Stored, Reflected, DOM-based)의 차이점을 사례를 들어 설명하고, 각 공격을 방어하기 위한 대응책을 제시하시오.',
#  'Stored XSS는 서버에 악성 스크립트가 저장되어 모든 사용자에게 전송되고, Reflected XSS는 즉시 응답 파라미터에 삽입되어 실행됩니다. DOM-based XSS는 클라이언트 측 스크립트가 DOM을 조작해 발생합니다. 방어책으로는 입력값 이스케이핑, Content Security Policy(CSP) 적용, 출력 시 HTML 이스케이프 등이 있습니다.',
#  4, CURRENT_TIMESTAMP),
# ('보안', '암호,인증,취약점',
#  '디지털 서명(Digital Signature)의 원리와 전자 문서 위·변조 방지를 위한 역할을 설명하시오.',
#  '발신자가 문서 해시를 자신의 개인키로 암호화해 서명하고, 수신자는 발신자의 공개키로 복호화해 해시를 얻은 뒤 문서 해시를 비교합니다. 일치할 경우 무결성과 발신자 인증이 보장되며, 변조 시 복호화된 해시가 달라져 위·변조를 탐지할 수 있습니다.',
#  4, CURRENT_TIMESTAMP),
#
# -- 웹서비스응용 서술형
# ('웹서비스응용', 'REST,API,JSON',
#  'RESTful API 설계에서 자원(Resource) URI 설계 원칙을 설명하고, 예시를 들어 설계 방식을 제시하시오.',
#  '자원은 명사 형태로 URI에 표현하고, 계층 구조는 슬래시(/)로 구분합니다. 예: /users/{userId}/orders/{orderId}. 동작은 HTTP 메서드(GET, POST, PUT, DELETE)로 구분하여 설계하며, 쿼리 파라미터로 필터링과 페이징을 처리합니다.',
#  4, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'HATEOAS(Hypermedia As The Engine Of Application State)의 개념과 중요성을 설명하시오.',
#  '클라이언트가 서버로부터 받은 리소스 표현에 연관된 링크(하이퍼미디어)를 포함해 이후 상태 전이를 동적으로 수행하도록 하는 원칙입니다. 이를 통해 클라이언트는 고정된 엔드포인트가 아닌 서버가 제공하는 링크를 따라가며 유연하게 API를 확장·버전 관리할 수 있습니다.',
#  4, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  '웹소켓(WebSocket)을 사용한 실시간 채팅 애플리케이션의 서버-클라이언트 통신 흐름을 설명하시오.',
#  '1) 클라이언트가 HTTP GET으로 핸드쉐이크 요청. 2) 서버가 HTTP 101 Switching Protocols로 응답, TCP 소켓이 WebSocket으로 업그레이드. 3) 이후 클라이언트와 서버 간에 메시지를 프레임 단위로 주고받으며, 양방향(full-duplex) 통신으로 채팅 데이터를 실시간으로 교환합니다.',
#  4, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  'GraphQL과 REST API의 차이점을 장단점 관점에서 비교 설명하시오.',
#  'GraphQL은 클라이언트가 필요한 필드만 요청해 오버페칭(over-fetching)을 줄이고 단일 엔드포인트로 유연한 쿼리가 가능하나, 복잡한 쿼리 최적화와 캐싱이 어렵습니다. REST는 엔드포인트별 고정된 응답으로 단순하고 캐싱이 용이하지만, 과·부적절한 데이터 전송이 발생할 수 있습니다.',
#  4, CURRENT_TIMESTAMP),
# ('웹서비스응용', 'REST,API,JSON',
#  '마이크로서비스 아키텍처에서 API Gateway의 역할과 구현 시 고려해야 할 사항을 서술하시오.',
#  'API Gateway는 클라이언트 요청을 적절한 서비스로 라우팅, 인증·인가, 로드 밸런싱, 로깅, 트래픽 제어 등을 수행합니다. 구현 시 성능 병목, 장애 격리, 보안 정책, 스케일링 전략, 버전 관리, TLS 종료(SSL offloading) 등을 고려해야 합니다.',
#  4, CURRENT_TIMESTAMP);
