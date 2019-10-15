package co.yj.temp1.Command;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.yj.temp1.TablespaceDAO;
import co.yj.temp1.TablespaceDTO;
import co.yj.temp1.Common.Command;
import co.yj.temp1.Common.HttpRes;

public class TSlist implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String keyword = request.getParameter("keyword");
		if(keyword == null) keyword = "";
		else keyword = keyword.toUpperCase();
		
		TablespaceDAO dao = new TablespaceDAO();
		ArrayList<TablespaceDTO> list = new ArrayList<>();
		list = dao.search(keyword);
		
		request.setAttribute("list", list);
		request.setAttribute("keyword", keyword);
		String viewPage = "tslist.jsp";
		HttpRes.forward(request, response, viewPage);
	}

}
