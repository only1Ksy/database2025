package DB2025Team07;

import java.io.*;
import java.sql.*;
import java.util.*;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/SupportsServlet") // URL 매핑
public class DB2025Team07_SupportsServlet extends HttpServlet {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC";
    static final String USER = "DB2025Team07";
    static final String PASS = "DB2025Team07";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("user_id");
        String recruitIdParam = request.getParameter("recruit_id");

        // 파라미터 null값 체크
        if (userId == null) {
            response.sendRedirect("signup.html");
            return;
        }

        if (recruitIdParam == null || recruitIdParam.trim().isEmpty()) {
            PrintWriter out = response.getWriter();
            out.println("<script>alert('recruit_id가 없습니다.'); history.back();</script>");
            out.flush();
            return;
        }

        int recruitId;
        try {
            recruitId = Integer.parseInt(recruitIdParam);
        } catch (NumberFormatException e) {
            PrintWriter out = response.getWriter();
            out.println("<script>alert('잘못된 recruit_id 형식입니다.'); history.back();</script>");
            out.flush();
            return;
        }

        // 해당 모집글의 지원글을 담을 리스트 생성
        List<Map<String, Object>> supportList = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            
            String sql = "SELECT * FROM DB2025_SupportDetailView WHERE RECRUIT_ID = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recruitId);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>(); // hashmap 형태로 이름과 값을 리스트에 담음
                row.put("USER_ID", rs.getString("USER_ID"));
                row.put("nickname", rs.getString("nickname"));
                row.put("email", rs.getString("email"));
                row.put("phone", rs.getString("phone"));
                row.put("rating", rs.getBigDecimal("rating"));
                row.put("RECRUITMENT_STATE", rs.getString("RECRUITMENT_STATE"));
                row.put("SUPPORT_TEXT", rs.getString("SUPPORT_TEXT"));
                row.put("SUPPORT_CREATED_AT", rs.getTimestamp("SUPPORT_CREATED_AT"));
                row.put("RECRUIT_ID", rs.getInt("RECRUIT_ID"));
                supportList.add(row);
            }

        } catch (ClassNotFoundException e) {
            System.err.println("[SupportListServlet] JDBC 드라이버 로딩 실패: " + e.getMessage());
            throw new ServletException("JDBC 드라이버 로딩 실패", e);
        } catch (SQLException e) {
            System.err.println("[SupportListServlet] 데이터베이스 오류: " + e.getMessage());
            e.printStackTrace(); // 콘솔에 전체 스택 트레이스 출력
            throw new ServletException("데이터베이스 오류: " + e.getMessage(), e);
        } finally { // 자원 해제
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmt != null) pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
        
        // 자원 jsp 파일에 전달
        request.setAttribute("userId", userId);
        request.setAttribute("recruitId", recruitId);
        request.setAttribute("supportList", supportList);

        request.getRequestDispatcher("/supports.jsp").forward(request, response);
    }
}
