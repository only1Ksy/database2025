import java.sql.*;
import java.util.Scanner;

public class JoinMember {
    static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    static final String DB_URL = "jdbc:mysql://localhost:3306/EJobDam?serverTimezone=UTC";
    static final String USER = "root";
    static final String PASS = "root";

    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        Scanner scanner = new Scanner(System.in);

        try {
            Class.forName(JDBC_DRIVER);
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            System.out.println("데이터베이스 연결 성공!");
            
            // 학번, 비밀번호, 닉네임, 이메일, 전화번호를 DB에 넣는 쿼리 설정. 평점은 디폴트값(0.00)으로 자동 설정
            String insertSQL = "INSERT INTO Users (user_id, pwd, nickname, email, phone) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertSQL);

            // 사용자 입력 받기
            System.out.print("학번 (7자리): ");
            String userId = scanner.nextLine();

            System.out.print("비밀번호: ");
            String password = scanner.nextLine();

            System.out.print("닉네임: ");
            String nickname = scanner.nextLine();

            System.out.print("이메일: ");
            String email = scanner.nextLine();

            System.out.print("전화번호 (예: 010-1234-5678): ");
            String phone = scanner.nextLine();

            // 입력값 세팅
            pstmt.setString(1, userId);
            pstmt.setString(2, password);
            pstmt.setString(3, nickname);
            pstmt.setString(4, email);
            pstmt.setString(5, phone);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                System.out.println("회원가입 성공!");
            } else {
                System.out.println("회원가입 실패...");
            }

        } catch (SQLIntegrityConstraintViolationException dup) {
            System.out.println("실패! 이미 존재하는 학번, 이메일 또는 전화번호입니다.");
        } catch (SQLException se) {
            se.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            scanner.close();
            try { if (pstmt != null) pstmt.close(); } catch (SQLException se2) {}
            try { if (conn != null) conn.close(); } catch (SQLException se) { se.printStackTrace(); }
        }

        System.out.println("연결 종료. Goodbye!");
    }
}