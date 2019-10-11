package co.yj.temp1.Command;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.yj.temp1.TablespaceDAO;
import co.yj.temp1.Common.Command;
import co.yj.temp1.Common.HttpRes;

public class TSdelete implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String tsName = request.getParameter("tablespace");
		System.out.println(tsName);
		TablespaceDAO dao = new TablespaceDAO();
		dao.delete(tsName);
		
		String viewPage = "TSlist.do";
		HttpRes.forward(request, response, viewPage);
	}
}
