package RecruitListServlet;

import java.io.*;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/recruit/list")
public class RecruitListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String jdbcUrl = "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC";
        String dbUser = "root";
        String dbPass = "root";

        List<Map<String, Object>> recruitList = new ArrayList<>();

        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUser, dbPass);
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT R.id, R.work_place, R.start_day, R.work_period, R.salary, R.recruitment_status, U.nickname " +
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
                recruitList.add(map);
            }

        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }

        request.setAttribute("recruitList", recruitList);
        request.getRequestDispatcher("/recruit_list.jsp").forward(request, response);
    }
}
