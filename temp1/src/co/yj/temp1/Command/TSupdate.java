package co.yj.temp1.Command;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.yj.temp1.TablespaceDAO;
import co.yj.temp1.Common.Command;
import co.yj.temp1.Common.HttpRes;

public class TSupdate implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String sql = request.getParameter("sql");
		String[] sqls = sql.split(";");
		
		TablespaceDAO dao = new TablespaceDAO();
		dao.update(sqls);
		
		String viewPage = "TSlist.do";
		HttpRes.forward(request, response, viewPage);
	}
}
