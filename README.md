# 이화Job담
이화잡담은 이화여자대학교 교내 학생들 간 아르바이트 및 근로 대타를 쉽고 빠르게 구할 수 있도록 보조하는 서비스입니다.

## 🌐 EJobDam JSP/Servlet 프로젝트 환경 세팅 가이드
이 프로젝트는 JSP/Servlet 기반의 웹 어플리케이션으로, **Eclipse, Tomcat, MySQL** 환경에서 작동합니다.
---
### ✅ 개발 환경
| 항목             | 버전 / 정보 |
|------------------|-------------|
| IDE              | Eclipse IDE for Enterprise Java 2022-06 ([다운로드 링크](https://www.eclipse.org/downloads/packages/release/2022-06/r/eclipse-ide-enterprise-java-and-web-developers)) |
| Java 버전        | Java SE 17 (LTS) |
| 빌드 도구        | 사용 안 함 (수동 설정) |
| 웹 서버          | Apache Tomcat v9.0 |
| 데이터베이스     | MySQL 8.0 |
| JDBC 드라이버    | mysql-connector-java-8.0.19.jar |
| 프로젝트 구조    | Dynamic Web Project (JSP/Servlet) |
---
### ✅ 1. 프로젝트 생성
1. Eclipse 실행
2. `File > New > Dynamic Web Project` 클릭
3. 프로젝트 이름: `EJobDam`
4. Target runtime: `Apache Tomcat v9.0` 선택 (없으면 아래 참고)
5. `Finish`
---
### ✅ 2. 폴더 구조
```
EJobDam/
├── src/
│   └── main/
│       ├── java/
│       │   └── DB2025Team07/
│       │       ├── DB2025Team07_AcceptSupportServlet.java
│       │       ├── DB2025Team07_EvaluationSubmitServlet.java
│       │       ├── DB2025Team07_JoinMemberServlet.java
│       │       ├── DB2025Team07_LoginServlet.java
│       │       ├── DB2025Team07_LogoutServlet.java
│       │       └── DB2025Team07_SupportsServlet.java
│       └── webapp/
│           ├── evaluation.jsp
│           ├── joinsuccess.jsp
│           ├── login.jsp
│           ├── main.jsp
│           ├── my_recruits.jsp
│           ├── my_supports.jsp
│           ├── mypage.jsp
│           ├── navbar.jsp
│           ├── signup.jsp
│           ├── supports.jsp
│           ├── META-INF/
│           └── WEB-INF/
│               └── lib/
│                   └── mysql-connector-java-8.0.19.jar

```
---
## ✅ 3. Tomcat 서버 설정
### Tomcat이 보이지 않을 경우
1. `Window > Show View > Other...`
2. `Server > Servers` 선택
3. `Servers` 탭에서 우클릭 → `New > Server`
4. Apache → `Tomcat v9.0` 선택 후 설치 경로 지정
### 🔽 Tomcat 다운로드
- [공식 사이트](https://tomcat.apache.org/download-90.cgi)에서 다운로드
- "Core" 항목에서 `.zip` 또는 `.tar.gz` 파일 다운로드 후 압축 해제
- Eclipse에서 해당 폴더 지정
---
## ✅ 4. JDBC 드라이버 설치
1. [MySQL Connector/J 8.0.19 다운로드](https://dev.mysql.com/downloads/connector/j/)
2. `mysql-connector-java-8.0.19.jar` 파일을 `WEB-INF/lib/`에 복사
---
## ✅ 5. MySQL DB 구성
### ① 워크벤치로 SQL 파일 실행
1. **MySQL Workbench 실행**
2. `File > Open SQL Script...` → 제공된 `DB2025Team07.sql` 파일 선택
3. 실행 (`⚡` 버튼 클릭)
> 테이블 및 초기 데이터가 자동으로 생성됩니다.
### ② DB 계정 정보 수정
`servlet`, `DAO`, `JSP` 등에서 사용하는 DB 접속 정보는 다음과 같이 수정하세요:
```java
String jdbcUrl = "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC";
String dbUser = "본인의 MySQL 사용자 이름";
String dbPass = "본인의 MySQL 비밀번호";
```
> ⚠ dbUser와 dbPass는 본인의 환경에 맞게 꼭 변경해야 합니다!
---
✅ 6. 서버 실행 및 접속
1. Eclipse 하단 Servers 탭 → Tomcat v9.0 Server at localhost 우클릭
2. Start 선택
2. 웹 브라우저에서 접속:
```http://localhost:8080/EJobDam/signup.html```
