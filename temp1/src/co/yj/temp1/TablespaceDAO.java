package co.yj.temp1;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class TablespaceDAO {
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

	//////////////// 테이블스페이스 생성
	public void create(String sql) {
		try {
			conn = ConnectionManager.connect();
			psmt = conn.prepareStatement(sql);
			psmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
	}
	
	//////////////// 테이블스페이스 조회
	public ArrayList<TablespaceDTO> select(){
		ArrayList<TablespaceDTO> list = new ArrayList<TablespaceDTO>();
		TablespaceDTO dto = null;
		try {
			conn = ConnectionManager.connect();
			cs = conn.prepareCall("{call p_ts_list(?)}");
			cs.registerOutParameter(1, oracle.jdbc.OracleTypes.CURSOR);
			cs.execute();
			rs = (ResultSet)cs.getObject(1);
			while(rs.next()) {
				dto = new TablespaceDTO();
				dto.setTablespaceName(rs.getString("tablespace_name"));
				dto.setStatus(rs.getString("status"));
				dto.setTotal(rs.getInt("total"));
				dto.setFree(rs.getInt("free"));
				dto.setUsed(dto.getTotal() - dto.getFree());
				dto.setUsedPer(((float)dto.getUsed()/(float)dto.getTotal()*100));
				list.add(dto);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return list;
	}
	
	//////////////// 테이블스페이스 삭제
	public void delete(String tablespaceName) {
		String sql = "DROP TABLESPACE " + tablespaceName + " INCLUDING CONTENTS AND DATAFILES";
		System.out.println(sql);
		try {
			conn = ConnectionManager.connect();
			psmt = conn.prepareStatement(sql);
			psmt.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
	}
}
