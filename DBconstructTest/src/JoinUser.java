import java.sql.*;
import java.util.Scanner;

public class JoinUser {
    public static void join(Connection conn) {
        PreparedStatement pstmt = null;
        Scanner scanner = new Scanner(System.in);

        try {
            // 회원가입 쿼리
            // 학번, 비밀번호, 닉네임, 이메일, 전화번호를 DB에 넣는 쿼리 설정. 평점은 디폴트값(0.00)으로 자동 설정
            String insertSQL = "INSERT INTO Users (user_id, pwd, nickname, email, phone) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertSQL);

            // 사용자 입력
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
        } finally {
            scanner.close();
            try { if (pstmt != null) pstmt.close(); } catch (SQLException se2) {}
        }
    }
}
