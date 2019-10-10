package co.yj.temp1;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/index")
public class index extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public index() {
        super();
    }
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setAttribute("list", select());
		request.getRequestDispatcher("index.jsp").forward(request,response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

	
	
	protected ArrayList<TablespaceDTO> select() {
		Connection conn = null;
		ResultSet rs = null;
		CallableStatement cs = null;
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
			ConnectionManager.close(conn);
		}
		System.out.println(list.toString());
		return list; 
	}
}
