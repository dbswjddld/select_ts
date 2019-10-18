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
	//////////////// 테이블스페이스 수정
	public void update(String[] sql) {
		int num = sql.length;
		try {
			conn = ConnectionManager.connect();
			for(int i = 0; i < num; i++) {
				System.out.println(sql[i]);
				psmt = conn.prepareStatement(sql[i]);
				psmt.execute();
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
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
	public ArrayList<TablespaceDTO> search(String keyword){
		ArrayList<TablespaceDTO> list = new ArrayList<TablespaceDTO>();
		TablespaceDTO dto = null;
		String sql1;
		String sql2;
		try {
			
			conn = ConnectionManager.connect();
			cs = conn.prepareCall("{call p_ts_list(?,?)");
			cs.setString(1, keyword);
			cs.registerOutParameter(2, oracle.jdbc.OracleTypes.CURSOR);
			cs.execute();
			rs = (ResultSet)cs.getObject(2);
			while(rs.next()) {
				dto = new TablespaceDTO();
				dto.setTablespaceName(rs.getString("tablespace_name"));
				dto.setStatus(rs.getString("status"));
				dto.setContents(rs.getString("contents"));
				list.add(dto);
			}
			
			for(TablespaceDTO data : list) {
				String name = data.getTablespaceName();
				String contents = data.getContents();
				if(contents.equals("TEMPORARY")) {
					System.out.println("temporary 입니다");
					sql1 = "select sum(bytes/1024/1024) as total "
							+ "from dba_temp_files where tablespace_name = ? group by tablespace_name";
					
					sql2 = "select tablespace_name, sum(free_space/1024/1024) as free "
							+ "from dba_temp_free_space where tablespace_name = ? group by tablespace_name";
				} else {
					sql1 = "select sum(bytes/1024/1024) as total "
							+ "from dba_data_files where tablespace_name = ? group by tablespace_name";
					
					sql2 = "select sum(bytes/1024/1024) as free "
							+ "from dba_free_space where tablespace_name = ? group by tablespace_name";
				}
				psmt = conn.prepareStatement(sql1);
				psmt.setString(1, name);
				rs = psmt.executeQuery();
				if(rs.next()) data.setTotal(rs.getInt("total"));
				
				psmt = conn.prepareStatement(sql2);
				psmt.setString(1, name);
				rs = psmt.executeQuery();
				if(rs.next()) data.setFree(rs.getInt("free"));

				data.setUsed(data.getTotal() - data.getFree());
				data.setUsedPer(((float)data.getUsed()/(float)data.getTotal()*100));
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
	
	//////////////// 테이블스페이스 정보 (수정 폼 가져오기)
	public TablespaceDTO select(String tsName) {
		TablespaceDTO ts = null;
		String sql = "SELECT status, contents FROM dba_tablespaces WHERE tablespace_name = '" + tsName + "'";
		try {
			conn = ConnectionManager.connect();
			psmt = conn.prepareStatement(sql);
			rs = psmt.executeQuery();
			if(rs.next()) {
				ts = new TablespaceDTO();
				ts.setStatus(rs.getString("status"));
				ts.setContents(rs.getString("contents"));
				ts.setTablespaceName(tsName);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			close();
		}
		return ts;
	};
}
