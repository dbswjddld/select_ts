package co.yj.temp1.Command;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import co.yj.temp1.Common.Command;
import co.yj.temp1.Common.HttpRes;

public class TScreateForm implements Command {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		String viewPage = "tscreateForm.jsp";
		HttpRes.forward(request, response, viewPage);
	}

}
