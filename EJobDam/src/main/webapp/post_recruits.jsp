<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>모집글 작성</title>
</head>
<body>
  <nav>
    <a href="main.jsp">Main</a> |
    <a href="mypage.jsp">마이페이지</a> |
    <a href="login.html">로그인</a> / <a href="signup.html">회원가입</a>
  </nav>

  <h2>📝 모집글 작성</h2>
  <form method="post" action="postRecruit">
    <label>근무 장소:
      <input type="text" name="work_place" required>
    </label><br><br>

    <label>시작 날짜:
      <input type="date" name="start_day" required>
    </label><br><br>

    <label>시작 시간:
      <input type="time" name="start_time" required>
    </label><br><br>

    <label>근무 기간:
      <input type="text" name="work_period" required>
    </label><br><br>

    <label>급여:
      <input type="number" name="salary" required> 원
    </label><br><br>

    <input type="submit" value="등록하기">
  </form>
</body>
</html>
