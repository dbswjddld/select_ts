package co.yj.temp1;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class DatafileDAO {
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	CallableStatement cs = null;

	private void close() {
		try {
			if(rs!=null) rs.close();
			if(psmt!=null) psmt.close();
			if(cs!=null) cs.close();
			if(conn!=null) conn.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	////////////////// 검색
	public ArrayList<DatafileDTO> select(String tsName) {
		ArrayList<DatafileDTO> list = new ArrayList<DatafileDTO>();
		DatafileDTO df = null;
		String sql = "select file_name, tablespace_name, bytes/1024/1024 from dba_data_files WHERE tablespace_name = '" + tsName + "'";
		String sql2 = "select file_name, tablespace_name, bytes/1024/1024 from dba_temp_files WHERE tablespace_name = '" + tsName + "'";

		try {
			conn = ConnectionManager.connect();
			psmt = conn.prepareStatement(sql);
			rs = psmt.executeQuery();
			while(rs.next()) {
				df = new DatafileDTO();
				df.setTablespaceName(tsName);
				df.setFileName(rs.getString("file_name"));
				df.setBytes(rs.getInt("bytes/1024/1024"));
				list.add(df);
			}
			psmt = conn.prepareStatement(sql2);
			rs = psmt.executeQuery();
			while(rs.next()) {
				df = new DatafileDTO();
				df.setTablespaceName(tsName);
				df.setFileName(rs.getString("file_name"));
				df.setBytes(rs.getInt("bytes/1024/1024"));
				list.add(df);
			}
		} catch (SQLException e) {
		e.printStackTrace();
		} finally {
			close();
		}
		return list;
	}
}
