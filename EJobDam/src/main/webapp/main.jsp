<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String, Object>> recruitList = (List<Map<String, Object>>) request.getAttribute("recruitList");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>모집글 목록</title>
</head>
<body>
  <nav>
    <a href="main.jsp">Main</a> |
    <a href="mypage.jsp">마이페이지</a> |
    <a href="login.html">로그인</a> / <a href="signup.html">회원가입</a>
  </nav>

  <h2>모집글 모아보기</h2>

  <form action="post_recruits.jsp" method="get">
    <input type="submit" value="모집글 작성하기">
  </form>

  <table border="1" cellpadding="10">
    <tr>
      <th>작성자</th>
      <th>근무 장소</th>
      <th>시작 일시</th>
      <th>근무 기간</th>
      <th>시급/급여</th>
      <th>상태</th>
      <th>지원하기</th>
    </tr>
    <%
      if (recruitList != null) {
          for (Map<String, Object> post : recruitList) {
    %>
    <tr>
      <td><%= post.get("nickname") %></td>
      <td><%= post.get("place") %></td>
      <td><%= post.get("date") %></td>
      <td><%= post.get("period") %></td>
      <td><%= post.get("salary") %>원</td>
      <td><%= post.get("status") %></td>
      <td>
        <form action="apply.jsp" method="get">
          <input type="hidden" name="recruit_id" value="<%= post.get("id") %>">
          <input type="submit" value="지원하기">
        </form>
      </td>
    </tr>
    <%
          }
      }
    %>
  </table>
</body>
</html>
