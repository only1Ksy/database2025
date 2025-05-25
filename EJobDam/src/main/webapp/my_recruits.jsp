<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("signup.html");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC", "root", "root");

        String sql = "SELECT * FROM DB2025_MyRecruits WHERE user_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, userId);
        rs = pstmt.executeQuery();
%>

<html>
<head><title>내 모집글 보기</title></head>
<body>
<h2>내가 작성한 모집글</h2>
<table border="1">
    <tr>
        <th>모집ID</th><th>장소</th><th>시작일</th><th>근무기간</th><th>시급</th><th>상태</th><th>작성일</th>
    </tr>
<%
        while (rs.next()) {
%>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("work_place") %></td>
        <td><%= rs.getTimestamp("start_day") %></td>
        <td><%= rs.getString("work_period") %></td>
        <td><%= rs.getInt("salary") %></td>
        <td><%= rs.getString("recruitment_status") %></td>
        <td><%= rs.getTimestamp("created_at") %></td>
    </tr>
<%
        }
    } catch (Exception e) {
        out.println("오류 발생: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>
</table>
<br>
<a href="mypage.jsp">← 마이페이지로 돌아가기</a>
</body>
</html>
