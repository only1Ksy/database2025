<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<%@ page session="true" %>

<%
    String userId = (String) session.getAttribute("user_id");
    String nickname = (String) session.getAttribute("nickname");

    if (userId == null) {
        response.sendRedirect("signup.html"); // 세션 없으면 다시 회원가입으로
        return;
    }

    // DB 연결 정보
    String jdbcUrl = "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC";
    String dbUser = "DB2025Team07";
    String dbPass = "DB2025Team07";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String email = "";
    String phone = "";
    double rating = 0.0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);

        pstmt = conn.prepareStatement("SELECT * FROM DB2025_Users WHERE id = ?");
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            email = rs.getString("email");
            phone = rs.getString("phone");
            rating = rs.getDouble("rating");
        }
    } catch (Exception e) {
        out.println("오류 발생: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

<html>
<head>
  <title><%= nickname %>님의 마이페이지</title>
</head>
<body>
<%@ include file="navbar.jsp" %>
  <h2><%= nickname %>님의 마이페이지</h2>
  <ul>
    <li><strong>학번:</strong> <%= userId %></li>
    <li><strong>이메일:</strong> <%= email %></li>
    <li><strong>전화번호:</strong> <%= phone %></li>
    <li><strong>평점:</strong> <%= rating %></li>
  </ul>

  <form action="my_recruits.jsp" method="get">
    <input type="submit" value="내 모집글 보기">
  </form>

  <form action="my_supports.jsp" method="get">
    <input type="submit" value="내 지원글 보기">
  </form>
</body>
</html>
