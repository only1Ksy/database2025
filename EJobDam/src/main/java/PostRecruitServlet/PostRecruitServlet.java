package PostRecruitServlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/postRecruit")
public class PostRecruitServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.html");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String workPlace = request.getParameter("work_place");
        String startDay = request.getParameter("start_day"); // yyyy-MM-dd
        String startTime = request.getParameter("start_time"); // HH:mm
        String workPeriod = request.getParameter("work_period");
        String salaryStr = request.getParameter("salary");

        try {
            int salary = Integer.parseInt(salaryStr);
            String startDateTime = startDay + " " + startTime + ":00";

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC", "root", "root")) {

                String sql = "INSERT INTO DB2025_Recruitment " +
                             "(user_id, work_place, start_day, work_period, salary) " +
                             "VALUES (?, ?, ?, ?, ?)";

                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, userId);
                    pstmt.setString(2, workPlace);
                    pstmt.setString(3, startDateTime);
                    pstmt.setString(4, workPeriod);
                    pstmt.setInt(5, salary);

                    int result = pstmt.executeUpdate();

                    if (result > 0) {
                        response.sendRedirect("main.jsp");
                    } else {
                        response.sendRedirect("error.jsp");
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("error.jsp").forward(request, response);
        }
    }

    // GET 요청 시 폼 페이지 보여주기
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("user_id") == null) {
            response.sendRedirect("login.html");
            return;
        }
        request.getRequestDispatcher("post_recruits.jsp").forward(request, response);
    }
}
