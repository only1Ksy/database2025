package DB2025Team07;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AcceptSupportServlet") // URL 매핑
public class DB2025Team07_AcceptSupportServlet extends HttpServlet {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC";
    static final String USER = "DB2025Team07";
    static final String PASS = "DB2025Team07";

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter(); // 알림창 및 오류 메시지용

        String recruitIdParam = request.getParameter("recruit_id"); // 모집글의 ID
        String targetId = request.getParameter("user_id"); // 채택할 사용자의 ID

        // 파라미터 null값 체크
        if (recruitIdParam == null || targetId == null || 
            recruitIdParam.trim().isEmpty() || targetId.trim().isEmpty()) {
            out.println("<script>alert('필수 파라미터(recruit_id 또는 user_id)가 누락되었습니다.'); history.back();</script>");
            out.flush();
            return;
        }

        int recruitId;
        try {
            recruitId = Integer.parseInt(recruitIdParam);
        } catch (NumberFormatException e) {
            out.println("<script>alert('잘못된 recruit_id 형식입니다.'); history.back();</script>");
            out.flush();
            return;
        }

        Connection conn = null;
        PreparedStatement pstmtUpdateAccepted = null;
        PreparedStatement pstmtUpdateRejected = null;
        PreparedStatement pstmtUpdateRecruitStatus = null;

        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            conn.setAutoCommit(false); // 트랜잭션 시작

            // 1. 선택된 지원자 → 채택 상태(2)
            // RECRUITMENT_STATE 컬럼의 의미: 1=대기, 2=채택, 3=탈락
            String sqlAccept = "UPDATE DB2025_SUPPORT SET RECRUITMENT_STATE = 2 WHERE RECRUIT_ID = ? AND USER_ID = ?";
            pstmtUpdateAccepted = conn.prepareStatement(sqlAccept);
            pstmtUpdateAccepted.setInt(1, recruitId);
            pstmtUpdateAccepted.setString(2, targetId);
            pstmtUpdateAccepted.executeUpdate();

            // 2. 나머지 지원자들 → 탈락 상태(3)
            String sqlReject = "UPDATE DB2025_SUPPORT SET RECRUITMENT_STATE = 3 WHERE RECRUIT_ID = ? AND USER_ID != ?";
            pstmtUpdateRejected = conn.prepareStatement(sqlReject);
            pstmtUpdateRejected.setInt(1, recruitId);
            pstmtUpdateRejected.setString(2, targetId);
            pstmtUpdateRejected.executeUpdate();

            // 3. 모집글의 모집 상태를 '모집중' -> '모집마감'으로 변경
            String sqlRecruitStatus = "UPDATE DB2025_RECRUITMENT SET recruitment_status = '모집마감' WHERE id = ?";
            pstmtUpdateRecruitStatus = conn.prepareStatement(sqlRecruitStatus);
            pstmtUpdateRecruitStatus.setInt(1, recruitId);
            pstmtUpdateRecruitStatus.executeUpdate();

            conn.commit(); // 모든 작업 성공 시 트랜잭션 커밋

            // 리디렉션하여 SupportListServlet이 새로고침된 데이터를 가져오도록 함
            response.sendRedirect("SupportsServlet?recruit_id=" + recruitId);


        } catch (ClassNotFoundException e) {
            out.println("[AcceptSupportServlet] JDBC 드라이버 로딩 실패: " + e.getMessage());
            e.printStackTrace();
            out.flush();
        } catch (SQLException e) {
            out.println("[AcceptSupportServlet] 데이터베이스 오류: " + e.getMessage());
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // 오류 발생 시 트랜잭션 롤백
                    out.println("[AcceptSupportServlet] Transaction rolled back.");
                } catch (SQLException ex) {
                    out.println("[AcceptSupportServlet] Rollback failed: " + ex.getMessage());
                    ex.printStackTrace();
                }
            }
            out.println("오류 발생: " + e.getMessage());
            out.flush();
        } finally {
            try { if (pstmtUpdateAccepted != null) pstmtUpdateAccepted.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmtUpdateRejected != null) pstmtUpdateRejected.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmtUpdateRecruitStatus != null) pstmtUpdateRecruitStatus.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // 원래 상태로 복구
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
