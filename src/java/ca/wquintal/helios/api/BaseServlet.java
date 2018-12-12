/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios.api;

import ca.wquintal.helios.ConnectionInfo;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author wq
 */
public class BaseServlet<T> extends HttpServlet {
	Gson gson = null;

	public BaseServlet() {
		gson = new Gson();
	}
	

	public void sendAsJson(HttpServletResponse response, Object obj) throws IOException {
		response.setContentType("application/json");
		String res = gson.toJson(obj);
		PrintWriter out = response.getWriter();
		out.print(res);
		out.flush();
	}
	
	public T parseDataJson(HttpServletRequest request,Class<T> classType) throws IOException, JsonSyntaxException{
		// Get les données json passer a la requete post
            BufferedReader br = new BufferedReader(new InputStreamReader(request.getInputStream()));
            return gson.fromJson(br, classType);
	}

}
