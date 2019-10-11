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
		TablespaceDAO dao = new TablespaceDAO();
		ArrayList<TablespaceDTO> list = new ArrayList<>();
		list = dao.select();
		
		request.setAttribute("list", list);
		String viewPage = "tslist.jsp";
		HttpRes.forward(request, response, viewPage);
	}

}
