import java.sql.*;
import java.util.Scanner;

public class CreateRecruitmentPost {
    public static void post(Connection conn, String loginUserId) {  // ★ userId를 매개변수로 받음
        PreparedStatement pstmt = null;
        Scanner scanner = new Scanner(System.in);

        try {
            // Recruitment 테이블 삽입 쿼리
            String insertSQL = "INSERT INTO Recruitment (id, user_id, work_place, start_day, work_period, category, salary) VALUES (?, ?, ?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertSQL);

            // 사용자 입력
            System.out.print("모집글 ID (숫자): ");
            int id = Integer.parseInt(scanner.nextLine());  // ID는 int 타입

            System.out.print("근무 장소: ");
            String workPlace = scanner.nextLine();

            System.out.print("근무 시작일시 (yyyy-mm-dd hh:mm:ss): ");
            String startDay = scanner.nextLine();

            System.out.print("근무 기간 (예: 1시간, 3일 등): ");
            String workPeriod = scanner.nextLine();

            System.out.print("카테고리: ");
            String category = scanner.nextLine();

            System.out.print("사례금 (숫자만 입력): ");
            int salary = Integer.parseInt(scanner.nextLine());

            // 입력값 세팅
            pstmt.setInt(1, id);
            pstmt.setString(2, loginUserId);  // 현재 로그인한 사용자 ID를 자동 세팅 (login 했다는 가정 하)
            pstmt.setString(3, workPlace);
            pstmt.setString(4, startDay);
            pstmt.setString(5, workPeriod);
            pstmt.setString(6, category);
            pstmt.setInt(7, salary);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                System.out.println("모집글 작성 성공!");
            } else {
                System.out.println("모집글 작성 실패...");
            }

        } catch (SQLIntegrityConstraintViolationException dup) {
            System.out.println("실패! 이미 존재하는 모집글 ID입니다.");
        } catch (SQLException se) {
            se.printStackTrace();
        } finally {
            scanner.close();
            try { if (pstmt != null) pstmt.close(); } catch (SQLException se2) {}
        }
    }
}
