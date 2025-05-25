<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.time.*, java.time.format.*" %>
<%@ page import="javax.servlet.http.*, javax.servlet.*" %>

<%
    // 로그인 안 했으면 로그인 페이지로 이동
    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.html");
        return;
    }

    // POST 요청일 경우만 처리
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String workPlace = request.getParameter("work_place");
        String startDay = request.getParameter("start_day"); // yyyy-MM-dd
        String startTime = request.getParameter("start_time"); // HH:mm
        String workPeriod = request.getParameter("work_period");
        String salaryStr = request.getParameter("salary");

        int salary = Integer.parseInt(salaryStr);
        String startDateTime = startDay + " " + startTime + ":00"; // MySQL DATETIME 형식

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC", "root", "root");

            String sql = "INSERT INTO DB2025_Recruitment " +
                         "(user_id, work_place, start_day, work_period, salary) " +
                         "VALUES (?, ?, ?, ?, ?)";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, workPlace);
            pstmt.setString(3, startDateTime);
            pstmt.setString(4, workPeriod);
            pstmt.setInt(5, salary);

            int result = pstmt.executeUpdate();
            if (result > 0) {
                response.sendRedirect("main.jsp");
            } else {
                out.println("<p>❌ 등록에 실패했습니다.</p>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("DB 오류: " + e.getMessage());
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }

        return; // 아래 HTML은 보여주지 않음
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>모집글 작성</title>
</head>
<body>
<!-- ✅ 네비게이션 -->
  <nav>
    <a href="main.jsp">Main</a> |
    <a href="mypage.jsp">마이페이지</a> |
    <a href="login.html">로그인</a> / <a href="signup.html">회원가입</a>
  </nav>
  <h2>📝 모집글 작성</h2>
  <form method="post" action="post_recruits.jsp">
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
