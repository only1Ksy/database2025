package Fashion;

import java.util.*;
import java.io.*;

class Runner {
	Scanner key;
	
	
	void menuPrint() {		
		System.out.println("\n--- 이화Job담 ---");
		System.out.println("0. Join User");
		System.out.println("1. Post a Recruitment post");
		System.out.println("2. ...");
		System.out.println("3. ...");
		System.out.println("4. ...");
		System.out.println("5. Exit");
		System.out.println("-------------------");
		System.out.print("Choose an option: ");
	}
	
	private int getMenu() {
		key = new Scanner(System.in);
		int menu;
		while (true) {
			menuPrint();

			try {
				menu = key.nextInt();
				return menu;
			} catch (InputMismatchException e){
				System.out.println("[ERROR] Input Type 오류입니다. 정수만 입력하세요.");
				key.nextLine();
			}
		}
	}
	
	public void run() {
		
		while (true) {
			int choice = getMenu();
			
			switch (choice) {
				case 0:
					JoinUser.join(conn);
					break;
				case 1:
					CreateRecruitmentPost.post(conn, currentUserID);
					break;
				case 2:
					break;
				case 3:
					break;
				case 4:
					break;
				case 5:
					break;
				case 6:
					break;
				case 7:
					break;
				case 8:
					System.out.println("종료합니다.");
					return;
				default:
					System.out.println("[ERROR] 잘못 입력하셨습니다.");
			}
		}
	}
}