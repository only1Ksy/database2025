package PostRecruitServlet;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

/**
 * 모집글 작성 서블릿.
 * 
 * - GET 요청 시: 모집글 작성 폼(post_recruits.jsp) 페이지를 보여줍니다.
 * - POST 요청 시: 입력된 모집글 정보를 DB에 저장하고, 저장에 성공하면 메인 페이지로 리디렉션합니다.
 * 
 * 세션에 로그인 정보(user_id)가 없으면 login.html로 리디렉션됩니다.
 */

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
        String description = request.getParameter("description");

        try {
            int salary = Integer.parseInt(salaryStr);
            String startDateTime = startDay + " " + startTime + ":00";

            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC", "root", "root")) {

                String sql = "INSERT INTO DB2025_Recruitment " +
                             "(user_id, work_place, start_day, work_period, salary, recruitment_text) " +
                             "VALUES (?, ?, ?, ?, ?, ?)";

                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, userId);
                    pstmt.setString(2, workPlace);
                    pstmt.setString(3, startDateTime);
                    pstmt.setString(4, workPeriod);
                    pstmt.setInt(5, salary);
                    pstmt.setString(6, description);

                    int result = pstmt.executeUpdate();

                    if (result > 0) {
                        response.sendRedirect("main");
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
