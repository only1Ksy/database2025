<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인</title>
</head>
<body>

  <%@ include file="navbar.jsp" %>

  <h2>로그인</h2>
  <form action="LoginServlet" method="post">
    학번: <input type="text" name="user_id" required><br>
    비밀번호: <input type="password" name="pwd" required><br>
    <input type="submit" value="로그인">
  </form>

</body>
</html>
