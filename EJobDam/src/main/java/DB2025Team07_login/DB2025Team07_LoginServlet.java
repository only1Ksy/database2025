package DB2025Team07_login;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

public class DB2025Team07_LoginServlet extends HttpServlet {
	static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/EJobDam?serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "root";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String userId = request.getParameter("user_id");
        String pwd = request.getParameter("pwd");

        try {
            // JDBC 드라이버 로드 (중요!)
            Class.forName(JDBC_DRIVER);

            Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
            PreparedStatement pstmt = conn.prepareStatement(
                "SELECT * FROM DB2025_Users WHERE id = ? AND pwd = ?");

            pstmt.setString(1, userId);
            pstmt.setString(2, pwd);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                HttpSession session = request.getSession();
                session.setAttribute("user_id", userId);
                session.setAttribute("nickname", rs.getString("nickname"));

                response.sendRedirect("mypage.jsp"); // 로그인 성공 → 마이페이지
            } else {
                PrintWriter out = response.getWriter();
                out.println("<script>alert('학번 또는 비밀번호가 틀렸습니다.');history.back();</script>");
            }

            // 자원 해제
            rs.close();
            pstmt.close();
            conn.close();

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("JDBC 드라이버 로드 실패: " + e.getMessage());
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("데이터베이스 오류: " + e.getMessage());
        }
    }

}
