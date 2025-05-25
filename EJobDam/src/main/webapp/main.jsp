<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>

<%
    // DB 연결 정보
    String jdbcUrl = "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC";
    String dbUser = "root";
    String dbPass = "root";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    List<Map<String, Object>> recruitList = new ArrayList<>();

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);

        String sql = "SELECT R.id, R.work_place, R.start_day, R.work_period, R.salary, R.recruitment_status, U.nickname " +
                     "FROM DB2025_Recruitment R " +
                     "JOIN DB2025_Users U ON R.user_id = U.id " +
                     "ORDER BY R.created_at DESC";

        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while (rs.next()) {
            Map<String, Object> map = new HashMap<>();
            map.put("id", rs.getInt("id"));
            map.put("place", rs.getString("work_place"));
            map.put("date", rs.getString("start_day"));
            map.put("period", rs.getString("work_period"));
            map.put("salary", rs.getInt("salary"));
            map.put("status", rs.getString("recruitment_status"));
            map.put("nickname", rs.getString("nickname"));
            recruitList.add(map);
        }
    } catch (Exception e) {
        out.println("오류: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>모집글 목록</title>
</head>
<body>
  <!-- ✅ 네비게이션 -->
  <nav>
    <a href="main.jsp">Main</a> |
    <a href="mypage.jsp">마이페이지</a> |
    <a href="login.html">로그인</a> / <a href="signup.html">회원가입</a>
  </nav>

  <h2>모집글 모아보기</h2>

  <!-- ✅ 모집글 작성 버튼 -->
  <form action="post_recruits.jsp" method="get">
    <input type="submit" value="모집글 작성하기">
  </form>

  <!-- ✅ 모집글 목록 출력 -->
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
    %>
  </table>
</body>
</html>
