import java.sql.*;
import java.util.Scanner;

public class Main {
	final static String DB_URL = "jdbc:mysql://cecs-db01.coe.csulb.edu:3306/cecs323j20";
	//final static String DB_URL = "jdbc:mysql://localhost:3306/Game Studio";
	static String USER = "";
	static String PASS = "";

	public static void main(String[] args) throws SQLException {
		Connection conn = null;
		Statement stmt = null;
		ResultSet rs = null;

		try {
			// Prompt for username and password.
			getUserPass();

			// Register for JDBC Driver.
			Class.forName("com.mysql.jdbc.Driver");
			System.out.println("\nConnecting to database...");

			// Open a connection.
			conn = DriverManager.getConnection(DB_URL, USER, PASS);
			conn.setAutoCommit(false);
			System.out.println("Connected.\n");

			boolean loop = true;
			while (loop) {
				
				// Prompt user with instructions.
				System.out.println("************************************");
				System.out.println("Welcome to the Game Studio database.");
				System.out.println("Please choose from the following: ");
				System.out.println("1. Execute a query.");
				System.out.println("2. Insert a row.");
				System.out.println("3. Remove a row.");
				System.out.println("4. Commit work done.");
				System.out.println("5. Rollback abort.");
				System.out.println("6. Quit the program.");
				System.out.println("************************************");

				// Grab input.
				int x = checkInt(1,6);
				System.out.println();

				switch (x) {
				case 1:
					executeQueries(conn, stmt, rs);
					break;
				case 2:
					insertRow(conn, stmt);
					break;
				case 3:
					deleteRow(conn, stmt);
					break;
				case 4:
					System.out.println("Commiting data...\n");
					conn.commit();
					break;
				case 5:
					System.out.println("Rolling back data...\n");
					conn.rollback();
					break;
				case 6:
					saveOnExit(conn);
					loop = false;
					break;
				default: 
					System.out.println("Error, invalid input.\n");
				}
			}

			// Close connection when done.
			conn.close();

		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			System.out.println(e.getMessage());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println(e.getMessage());
		} finally {
			try {
				if (rs != null)
					rs.close();
			} catch (SQLException se) {}
			
			try {
				if (stmt != null)
					stmt.close();
			} catch (SQLException se1) {}

			try {
				if (conn != null)
					conn.close();
			} catch (SQLException se2) {}
		}
	}

	public static void getUserPass() {
		Scanner console = new Scanner(System.in);
		System.out.println("Please enter username:");
		USER = console.nextLine();
		System.out.println("Please enter password:");
		PASS = console.nextLine();	
	}

	public static void executeQueries(Connection c, Statement s, ResultSet r)
			throws SQLException {
		
		System.out.println("Which query would you like to execute?");
		System.out.println("1. Query 1");
		System.out.println("\tList the first name, last name, & phone number\n\tand role name of the employees who have worked \n\ton at least one project and the sum of the \n\thours worked. ");
		System.out.println("2. Query 2");
		System.out.println("\tList the employees who have not worked on any \n\tprojects, along with the number of employees who \n\thave the same role.");
		System.out.println("3. Query 3");
		System.out.println("\tList the projects name and cost whos associated \n\tgame genre is ‘shooter’ and 'racing'.");
		int choice = checkInt(1,3);
		
		System.out.println("\nCreating statement...\n");
		switch(choice) {
			case 1:
				// Query 1.
				s = c.createStatement();
				String sql1 = "SELECT first_name, last_name, phone, role_name, SUM(hours_worked) AS grand_total FROM Employee "
						+ "INNER JOIN Role ON Employee.role_id = Role.role_id "
						+ "INNER JOIN WorkLog ON Employee.employee_id = WorkLog.employee_id "
						+ "INNER JOIN Project ON WorkLog.project_id = Project.project_id "
						+ "GROUP BY Employee.employee_id";
				r = s.executeQuery(sql1);
		
				while (r.next()) {
					String first_name = r.getString("first_name");
					String last_name =  r.getString("last_name");
					String phone = r.getString("phone");
					String role_name =  r.getString("role_name");
					int grand_total = r.getInt("grand_total");
					
					System.out.println("First name: " + first_name);
					System.out.println("Last name: " + last_name);
					System.out.println("Phone: " + phone);
					System.out.println("Role: " + role_name);
					System.out.println("Total Hours: " + grand_total);
					System.out.println("");
				}

				// Clean up environment.
				r.close();
				s.close();
				break;
			case 2:
				s = c.createStatement();
				String sql2 = "SELECT first_name, last_name, emprole.EmpCount "
						+ "FROM Employee " 
						+ "INNER JOIN "
						+ "(SELECT Role.role_id, COUNT(Employee.employee_id) AS 'EmpCount' "
						+ "FROM Role "
						+ "LEFT OUTER JOIN Employee ON Employee.role_id = Role.role_id "
						+ "GROUP BY Role.role_id) AS emprole "
						+ "ON Employee.role_id = emprole.role_id "
						+ "LEFT OUTER JOIN WorkLog ON Employee.employee_id = WorkLog.employee_id "
						+ "WHERE WorkLog.employee_id IS NULL;";
				r = s.executeQuery(sql2);
			
				while(r.next()) {
					String first_name = r.getString("first_name");
					String last_name = r.getString("last_name");
					int EmpCount = r.getInt("EmpCount");
					
					System.out.println("First name: " + first_name);
					System.out.println("Last name: " + last_name);
					System.out.println("Employee Count: " + EmpCount);
					System.out.println("");
				}
				
				// Clean up environment.
				r.close();
				s.close();
				break;
			case 3:
				// Query 3.
				s = c.createStatement();
				String sql3 = "SELECT Project.name AS 'project_name', Game.genre, sum(Project.cost) AS 'project_cost' "
						+ "FROM Game "
						+ "INNER JOIN GameProject ON Game.game_id = GameProject.game_id "
						+ "INNER JOIN Project     ON GameProject.project_id = Project.project_id "
						+ "WHERE Game.genre IN ('shooter', 'racing') "
						+ "GROUP BY Project.name, Game.genre;";
				r = s.executeQuery(sql3);
				
				while (r.next()) {
					String project_name = r.getString("project_name");
					String genre = r.getString("genre");
					int project_cost = r.getInt("project_cost");
					
					System.out.println("Project Name: " + project_name);
					System.out.println("Genre:  " + genre);
					System.out.println("Project Cost: " + project_cost);
					System.out.println("");
				}

				// Clean up environment.
				r.close();
				s.close();
				break;
			default: 
				System.out.println("Error, invalid input.");
		}
	}
	
	public static void insertRow(Connection c, Statement s) throws SQLException {
		System.out.println("Insert into child table called Role:\n");
		
		while (true) {
			try {
				
				Scanner console = new Scanner(System.in);
				System.out.println("Insert Role ID Number (int)");
				int role_number = console.nextInt();
				console.nextLine();
				System.out.println("Insert Role Name (string)");
				String role_name = console.nextLine();
				System.out.println("Insert Depart ID (int)");
				int department_id = console.nextInt();
				System.out.println("Insert PayRate (int)"); 
				int payRate = console.nextInt();
				console.nextLine();
				System.out.println("Insert Reponsibilities (string)");
				String responsibilities = console.nextLine();
				System.out.println("\nInserting record into the table...\n");
					
				s = c.createStatement();
				String sql = "INSERT INTO Role(role_id, role_name, department_id, payrate, responsibilities) "
						+ "Values(?, ?, ?, ?, ?)";
				
				PreparedStatement preparedStmt = c.prepareStatement(sql);
				preparedStmt.setInt     (1, role_number);
				preparedStmt.setString  (2, role_name);
				preparedStmt.setInt     (3, department_id);
				preparedStmt.setInt     (4, payRate);
				preparedStmt.setString  (5, responsibilities);
				
				preparedStmt.execute();
				break;
			} catch (SQLException e){ 
				System.out.println(e.getMessage());
				System.out.println("Try again:\n ");	
			}
		}
		System.out.println("Updated!\n");
	}
	
	public static void deleteRow(Connection c, Statement s) throws SQLException {
		System.out.println("Row from Project removed.");
		System.out.println("Child tables are automatically updated\n"
				+ "since the FK Constraint Cascades.");
		
		try {
			s = c.createStatement();
			String sql = "DELETE FROM Project " +
	                   "WHERE project_id = 11";
			s.executeUpdate(sql);
		} catch(SQLException e) {
			System.out.println(e.getMessage());
		}
		System.out.println("Row removed.\n");
	}
	
	public static void saveOnExit(Connection c) throws SQLException {
		
		System.out.println("Would you like to commit your work before exiting?");
		System.out.println("1. Yes, commit.");
		System.out.println("2. No, rollback abort.");
		
		int exitChoice = checkInt(1,2);
		switch(exitChoice) {
			case 1: c.commit(); 
					System.out.println("\nCommitted.");
					break;
			case 2: c.rollback();
					System.out.println("\nRolled back!");
					break;
			default: 
				System.out.println("Error, invalid input.");
		}
	
		System.out.println("Goodbye!");
	}
	
	public static int checkInt( int low, int high ) { 
		Scanner in = new Scanner(System.in);
		boolean valid = false;
		int validNum = 0;
		while( !valid ){
			if(in.hasNextInt()){
				validNum = in.nextInt();
				if( validNum >= low && validNum <= high ){
					valid = true; 
				}else{
					System.out.print("Invalid- Retry: ");
					System.out.println();	
				}
			}else{
				//clear buffer of junk input
				in.next();
				System.out.print("Invalid input- Retry: ");
				System.out.println();
			}
		}
		return validNum; 
	}

}
