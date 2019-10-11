package co.yj.temp1.Command;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.yj.temp1.TablespaceDAO;
import co.yj.temp1.Common.Command;
import co.yj.temp1.Common.HttpRes;

public class TScreate implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String sql = request.getParameter("sql");
		System.out.println(sql);
		TablespaceDAO dao = new TablespaceDAO();
		dao.create(sql);
		
		String viewPage = "TSlist.do";
		HttpRes.forward(request, response, viewPage);
	}

}
