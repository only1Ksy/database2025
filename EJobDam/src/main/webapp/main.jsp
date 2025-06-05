<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String, Object>> recruitList = (List<Map<String, Object>>) request.getAttribute("recruitList");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>메인 페이지</title>
</head>
<body>
  <nav>
    <a href="main">Main</a> |
    <a href="mypage.jsp">마이페이지</a> |
    <a href="login.html">로그인</a> / <a href="signup.html">회원가입</a>
  </nav>

  <h2>모집글 모아보기</h2>

  <% if (error != null) { %>
    <p style="color:red;">오류 발생: <%= error %></p>
  <% } %>

  <form action="postRecruit" method="get">
    <input type="submit" value="모집글 작성하기">
  </form>

  <table border="1" cellpadding="10">
    <tr>
      <th>작성자</th>
      <th>근무 장소</th>
      <th>시작 일시</th>
      <th>근무 기간</th>
      <th>시급/급여</th>
      <th>근무 내용</th>
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
      <td><%= post.get("description") %></td>
      <td><%= post.get("status") %></td>
      <td>
  		<%
    		String status = (String) post.get("status");
    		if ("모집중".equals(status)) {
		  %>
	    <form action="apply.jsp" method="get">
	      <input type="hidden" name="recruit_id" value="<%= post.get("id") %>">
	      <input type="submit" value="지원하기">
	    </form>
	  <%
	    } else {
	  %>
	    <span style="color: gray;">지원 마감</span>
	  <%
	    }
	  %>
</td>

    </tr>
    <%
          }
      } else {
    %>
      <tr><td colspan="7">불러온 모집글이 없습니다.</td></tr>
    <%
      }
    %>
  </table>
</body>
</html>
