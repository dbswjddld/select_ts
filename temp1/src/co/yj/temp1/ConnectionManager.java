package co.yj.temp1;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionManager {
	public static Connection connect() {
		Connection conn = null;
		String url = "jdbc:oracle:thin:@localhost:1523:orcl"; // local PC oracle의 주소 
		String user = "yj";
		String password = "yj";
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url, user, password);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			System.out.println("!!! 연결 실패");
		}
		return conn;
	}
}
