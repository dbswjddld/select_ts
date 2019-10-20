package co.yj.temp1.Command;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.yj.temp1.DatafileDAO;
import co.yj.temp1.DatafileDTO;
import co.yj.temp1.TablespaceDAO;
import co.yj.temp1.TablespaceDTO;
import co.yj.temp1.Common.Command;
import co.yj.temp1.Common.HttpRes;

public class TSshow implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String tsName = request.getParameter("tablespace");
		
		TablespaceDAO tsdao = new TablespaceDAO();
		TablespaceDTO tsdto = new TablespaceDTO();
		tsdto = tsdao.select(tsName);
		
		DatafileDAO dfdao = new DatafileDAO();
		ArrayList<DatafileDTO> list = new ArrayList<DatafileDTO>();
		list = dfdao.select(tsName);
		
		request.setAttribute("ts", tsdto);
		request.setAttribute("df", list);
		
		String viewPage = "tsshow.jsp";
		HttpRes.forward(request, response, viewPage);
	}

}
