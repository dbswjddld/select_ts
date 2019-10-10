package co.yj.temp1;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConnectionManager {
	public static Connection connect() {
		Connection conn = null;
		String url = "jdbc:oracle:thin:@localhost:1521:xe"; // local PC oracle의 주소 
		String user = "sys as sysdba";
		String password = "oracle";
		
		try {
			Class.forName("oracle.jdbc.driver.OracleDriver");
			conn = DriverManager.getConnection(url, user, password);
		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			System.out.println("!!! 연결 실패");
		}
		return conn;
	}
	
	public static void close(Connection conn) {
		try {
			if(conn!=null)
				conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}
