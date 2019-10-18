package co.yj.temp1;

import java.io.IOException;
import java.util.HashMap;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.yj.temp1.Command.TScreate;
import co.yj.temp1.Command.TScreateForm;
import co.yj.temp1.Command.TSdelete;
import co.yj.temp1.Command.TSlist;
import co.yj.temp1.Command.TSshow;
import co.yj.temp1.Command.TSupdate;
import co.yj.temp1.Command.TSupdateForm;
import co.yj.temp1.Common.Command;

@WebServlet("/Controller")
public class Controller extends HttpServlet {
	private HashMap<String, Command> map;
	private static final long serialVersionUID = 1L;
	
    public Controller() {
        super();
    }

	public void init(ServletConfig config) throws ServletException {
		map = new HashMap<String, Command>();
		
		map.put("/TSlist.do", new TSlist());
		map.put("/TSdelete.do", new TSdelete());
		map.put("/TScreateForm.do", new TScreateForm());
		map.put("/TScreate.do", new TScreate());
		map.put("/TSupdateForm.do", new TSupdateForm());
		map.put("/TSupdate.do", new TSupdate());
		map.put("/TSshow.do", new TSshow());
	}

	protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("utf-8");
		response.setCharacterEncoding("utf-8");	
		String uri = request.getRequestURI();
		String contextPath = request.getContextPath();
		String path = uri.substring(contextPath.length());
		
		Command command = map.get(path);
		command.execute(request, response);
	}

}
