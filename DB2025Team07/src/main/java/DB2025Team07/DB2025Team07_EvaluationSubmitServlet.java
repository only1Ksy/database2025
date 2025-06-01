package DB2025Team07;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/EvaluationSubmitServlet")
public class DB2025Team07_EvaluationSubmitServlet extends HttpServlet {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/DB2025Team07?serverTimezone=UTC";
    static final String USER = "DB2025Team07";
    static final String PASS = "DB2025Team07";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 세션에서 평가자 id 가져오기
        HttpSession session = request.getSession();
        String evaluatorId = (String) session.getAttribute("user_id");

        // 로그인 여부 확인 
        if (evaluatorId == null) {
            out.println("<script>alert('로그인이 필요합니다.'); location.href='signup.html';</script>");
            out.flush();
            return;
        }

        // 폼에서 전달된 파라미터 가져오기
        String recruitIdParam = request.getParameter("recruit_id");
        String scoreParam = request.getParameter("score");
        String description = request.getParameter("description");

        // 파라미터 값 확인
        if (recruitIdParam == null || scoreParam == null || description == null ||
            recruitIdParam.trim().isEmpty() || scoreParam.trim().isEmpty() || description.trim().isEmpty()) {
            out.println("<script>alert('모든 필수 항목(모집 ID, 점수, 평가 내용)을 입력해주세요.'); history.back();</script>");
            out.flush();
            return;
        }

        int recruitId;
        int score;
        try {
            recruitId = Integer.parseInt(recruitIdParam);
            score = Integer.parseInt(scoreParam);
        } catch (NumberFormatException e) {
            out.println("<script>alert('잘못된 숫자 형식입니다 (모집 ID 또는 점수).'); history.back();</script>");
            out.flush();
            return;
        }

        Connection conn = null;
        PreparedStatement pstmtGetTargetId = null;
        PreparedStatement pstmtInsertEvaluation = null;
        PreparedStatement pstmtUpdateRecruitStatus = null;
        ResultSet rs = null;
        String targetId = null;

        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            conn.setAutoCommit(false); // 트랜잭션 시작

            //1. DB2025_SUPPORT 테이블에서 RECRUITMENT_STATE가 2(채택됨)인 사용자의 USER_ID (targetId) 조회
            String sqlGetTarget = "SELECT USER_ID FROM DB2025_SUPPORT WHERE RECRUIT_ID = ? AND RECRUITMENT_STATE = 2";
            pstmtGetTargetId = conn.prepareStatement(sqlGetTarget);
            pstmtGetTargetId.setInt(1, recruitId);
            rs = pstmtGetTargetId.executeQuery();

            if (rs.next()) {
                targetId = rs.getString("USER_ID");
                if (rs.next()) { // 채택된 사람이 여러 명인 경우 (정상적이지 않은 상황)
                    conn.rollback();
                    System.err.println("[EvaluationSubmitServlet] Error: Multiple users found with RECRUITMENT_STATE=2 for recruit_id=" + recruitId);
                    out.println("<script>alert('데이터 오류: 해당 모집글에 채택된 사용자가 여러 명입니다. 관리자에게 문의하세요.'); history.back();</script>");
                    out.flush();
                    return;
                }
            } else { // 채택된 사용자가 없는 경우
                conn.rollback();
                System.err.println("[EvaluationSubmitServlet] Error: No user found with RECRUITMENT_STATE=2 for recruit_id=" + recruitId);
                out.println("<script>alert('평가 대상을 찾을 수 없습니다 (채택된 사용자가 없음).'); history.back();</script>");
                out.flush();
                return;
            }
            
            // 자기 자신을 평가하는 것을 방지
            if (evaluatorId.equals(targetId)) {
                conn.rollback();
                out.println("<script>alert('자기 자신을 평가할 수 없습니다.'); history.back();</script>");
                out.flush();
                return;
            }

            // 2. DB2025_Evaluation 테이블에 평가 정보 삽입
            String sqlInsert = "INSERT INTO DB2025_Evaluation (recruitment_id, evaluator_id, target_id, score, description) VALUES (?, ?, ?, ?, ?)";
            pstmtInsertEvaluation = conn.prepareStatement(sqlInsert);
            pstmtInsertEvaluation.setInt(1, recruitId);
            pstmtInsertEvaluation.setString(2, evaluatorId);
            pstmtInsertEvaluation.setString(3, targetId);
            pstmtInsertEvaluation.setInt(4, score);
            pstmtInsertEvaluation.setString(5, description);

            int result = pstmtInsertEvaluation.executeUpdate();

            if (result > 0) {
            	 // 3. 평가 성공 시, 모집글(DB2025_RECRUITMENT) 상태를 '모집완료' -> '근무완료'로 변경
            	String sqlUpdateStatus = "UPDATE DB2025_RECRUITMENT SET recruitment_status = '근무완료' WHERE id = ?";
                pstmtUpdateRecruitStatus = conn.prepareStatement(sqlUpdateStatus);
                pstmtUpdateRecruitStatus.setInt(1, recruitId);
                int statusUpdateResult = pstmtUpdateRecruitStatus.executeUpdate();
                
                if (statusUpdateResult > 0) {
                	conn.commit(); // 성공 시 커밋
                	out.println("<script>alert('평가가 성공적으로 제출되었습니다.'); location.href='my_recruits.jsp';</script>"); // 성공 후 페이지
                } else {
                    conn.rollback(); // 실패 시 롤백
                    out.println("<script>alert('평가는 제출되었으나 모집글 상태 변경에 실패했습니다. 관리자에게 문의하세요.'); history.back();</script>");
                }
            } else {
                conn.rollback();
                out.println("<script>alert('평가 제출에 실패했습니다. 다시 시도해주세요.'); history.back();</script>");
            }
            out.flush();

        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            out.println("<script>alert('시스템 오류가 발생했습니다. (드라이버 로딩 실패)'); history.back();</script>");
            out.flush();
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            out.println("<script>alert('데이터베이스 처리 중 오류가 발생했습니다.'); history.back();</script>");
            out.flush();
        } finally {
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmtGetTargetId != null) pstmtGetTargetId.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmtInsertEvaluation != null) pstmtInsertEvaluation.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (pstmtUpdateRecruitStatus != null) pstmtUpdateRecruitStatus.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // 자동 커밋 모드로 복원
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
