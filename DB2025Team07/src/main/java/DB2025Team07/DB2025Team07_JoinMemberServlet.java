package DB2025Team07;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/JoinMemberServlet")
public class DB2025Team07_JoinMemberServlet extends HttpServlet {
	static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC";
    static final String USER = "DB2025Team07";
    static final String PASS = "DB2025Team07";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // HTML form에서 받은 값
        String id = request.getParameter("user_id");  // DB에서는 id로 사용됨
        String pwd = request.getParameter("pwd");
        String nickname = request.getParameter("nickname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        try {
            Class.forName(JDBC_DRIVER);
            try (
                Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
                PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO DB2025_Users (id, pwd, nickname, email, phone) VALUES (?, ?, ?, ?, ?)")
            ) {
                pstmt.setString(1, id);
                pstmt.setString(2, pwd);
                pstmt.setString(3, nickname);
                pstmt.setString(4, email);
                pstmt.setString(5, phone);

                int result = pstmt.executeUpdate();
                PrintWriter out = response.getWriter();

                if (result > 0) {
                	HttpSession session = request.getSession();
                    session.setAttribute("user_id", id);
                    session.setAttribute("nickname", nickname);
                    response.sendRedirect("joinsuccess.jsp"); // <- 개인페이지 대신 success.jsp로 이동
                } else {
                    out.println("<h3>회원가입 실패...</h3>");
                }
            }
        } catch (SQLIntegrityConstraintViolationException dup) {
            response.getWriter().println("❗ 중복된 학번/이메일/전화번호입니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("DB 오류: " + e.getMessage());
        }
    }
}