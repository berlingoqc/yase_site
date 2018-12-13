/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios.api;

import ca.wquintal.helios.AccountDB;
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
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

/**
 *
 * @author wq
 */
public class BaseServlet<T> extends HttpServlet {
	Gson gson = null;

	public BaseServlet() {
		gson = new Gson();
	}
	
	public AccountDB.IdentityToken getUserToken(HttpServletRequest req) {
		AccountDB.IdentityToken tk = null;
		
		HttpSession s = req.getSession();
		if(s != null) {
			String tkAttr = (String)s.getAttribute("identity");
			if(tkAttr != null) {
				try {
					tk = gson.fromJson(tkAttr, AccountDB.IdentityToken.class);
				} catch(JsonSyntaxException e) {
					e.printStackTrace();
					return null;
				}
			}
		}
		return tk;
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
	public String extractFileName(Part part) {
		// form-data; name="file"; filename="C:\file1.zip"
		// form-data; name="file"; filename="C:\Note\file2.zip"
		String contentDisp = part.getHeader("content-disposition");
		String[] items = contentDisp.split(";");
		for (String s : items) {
			if (s.trim().startsWith("filename")) {
				// C:\file1.zip
				// C:\Note\file2.zip
				String clientFileName = s.substring(s.indexOf("=") + 2, s.length() - 1);
				clientFileName = clientFileName.replace("\\", "/");
				int i = clientFileName.lastIndexOf('/');
				// file1.zip
				// file2.zip
				return clientFileName.substring(i + 1);
			}
		}
		return null;
	}
}
