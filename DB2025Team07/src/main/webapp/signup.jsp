<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원가입</title>
</head>
<body>

  <%@ include file="navbar.jsp" %>

  <h2>회원가입</h2>
  <form action="JoinMemberServlet" method="post">
    학번: <input type="text" name="user_id" required><br>
    비밀번호: <input type="password" name="pwd" required><br>
    닉네임: <input type="text" name="nickname" required><br>
    이메일: <input type="email" name="email" required><br>
    전화번호: <input type="text" name="phone" required><br>
    <input type="submit" value="가입하기">
  </form>

</body>
</html>
