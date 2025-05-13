import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Main {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/EJobDam?serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "root";

    public static void main(String[] args) {
        Connection conn = null;
        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            System.out.println("데이터베이스 연결 성공!");
            
            // 로그인시 확인해서 받아오는 값으로 추후 변경
            String currentUserID = "2222222";

            // JoinUser의 회원가입 실행
            JoinUser.join(conn);

            // CreateRecruitmentPost의 모집글 작성 실행
            CreateRecruitmentPost.post(conn, currentUserID);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (conn != null) conn.close(); } catch (SQLException se) { se.printStackTrace(); }
            System.out.println("연결 종료. Goodbye!");
        }
    }
}
