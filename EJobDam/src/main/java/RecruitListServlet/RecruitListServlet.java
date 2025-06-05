package RecruitListServlet;

import java.io.*;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

/**
 * 메인 페이지 출력용 서블릿.
 *
 * - 경로: /main
 * - 역할: DB에서 모집글 목록을 조회하고, main.jsp에 전달합니다.
 * - 전달 데이터: recruitList (List<Map<String, Object>>)
 *
 * DB 연결 실패 등 오류 발생 시 error 메시지를 request에 포함합니다.
 */

@WebServlet("/main")
public class RecruitListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String jdbcUrl = "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC";
        String dbUser = "root"; // ← 본인 계정으로 수정
        String dbPass = "root"; // ← 본인 비번으로 수정

        List<Map<String, Object>> recruitList = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // 드라이버 로딩!
            try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);
                 PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT R.id, R.work_place, R.start_day, R.work_period, R.salary, R.recruitment_status, U.nickname, R.recruitment_text " +
                     "FROM DB2025_Recruitment R JOIN DB2025_Users U ON R.user_id = U.id ORDER BY R.created_at DESC");
                 ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("id", rs.getInt("id"));
                    map.put("place", rs.getString("work_place"));
                    map.put("date", rs.getString("start_day"));
                    map.put("period", rs.getString("work_period"));
                    map.put("salary", rs.getInt("salary"));
                    map.put("status", rs.getString("recruitment_status"));
                    map.put("nickname", rs.getString("nickname"));
                    map.put("description", rs.getString("recruitment_text"));
                    recruitList.add(map);
                }
            }

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        request.setAttribute("recruitList", recruitList);
        request.getRequestDispatcher("/main.jsp").forward(request, response);
    }
}
