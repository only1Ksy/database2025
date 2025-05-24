<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page session="true" %>

<nav style="background-color: #333; padding: 10px;">
  <a href="main.jsp" style="color: white; text-decoration: none; margin-right: 20px; font-weight: bold;">EJobDam</a>

  <%
    Object nickObj = session.getAttribute("nickname");
    if (nickObj != null) {
  %>
      <a href="mypage.jsp" style="color: white; text-decoration: none; margin-right: 20px; font-weight: bold;">마이페이지</a>
      <span style="color: white; margin-right: 20px;">👋 <%= nickObj %>님 환영합니다</span>
      <a href="LogoutServlet" style="color: white; text-decoration: none; font-weight: bold;">로그아웃</a>
  <%
    } else {
  %>
      <a href="login.jsp" style="color: white; text-decoration: none; margin-right: 20px; font-weight: bold;">로그인</a>
      <a href="signup.jsp" style="color: white; text-decoration: none; font-weight: bold;">회원가입</a>
  <%
    }
  %>
</nav>
