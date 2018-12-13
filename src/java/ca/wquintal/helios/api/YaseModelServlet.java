/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios.api;

import ca.wquintal.helios.AccountDB;
import ca.wquintal.helios.YaseDB;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author wq
 */
public class YaseModelServlet extends BaseServlet<Object> {

	private YaseDB db = null;
	
	public YaseModelServlet() {
		super();
		try {
			db = YaseDB.getDBInstance();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
		String name = request.getParameter("name");
		String lt = request.getParameter("texture");
		if(lt != null) {
			AccountDB.IdentityToken tk = getUserToken(request);
			try {
			List<String> texture = db.GetLoadedTextureList(tk.getId());
			Gson g = new Gson();
			PrintWriter out = response.getWriter();
			out.print(g.toJson(texture));
			out.flush();
			return;
		} catch(SQLException e) {
			e.printStackTrace();
			response.setStatus(400);
			return;
		}
		}
		if(name == null) {
			AccountDB.IdentityToken tk = getUserToken(request);
			try {
			List<String> texture = db.GetModelList(tk.getId());
			Gson g = new Gson();
			PrintWriter out = response.getWriter();
			out.print(g.toJson(texture));
			out.flush();
		} catch(SQLException e) {
			e.printStackTrace();
			response.setStatus(400);
			return;
		}
		}
				
		if(name.isEmpty()) {
			response.setStatus(400);
			return;
		}
		AccountDB.IdentityToken tk = getUserToken(request);
		try {
			byte[] t = db.GetModelData(tk.getId(), name);
			String contentType = "application/octet-stream";
			System.out.println("Content Type: "+ contentType);
        
			response.setHeader("Content-Type", contentType);
        
			response.setHeader("Content-Length", String.valueOf(t.length));
        
			response.setHeader("Content-Disposition", "inline; filename=\"" + name + "\"");
 
          // Write image data to Response.
			response.getOutputStream().write(t);
		} catch(SQLException e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath()+"/img/noimage.jpg");
			return;
		}
		
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

		
		PrintWriter out = response.getWriter();
		
		// Get le token du user
		AccountDB.IdentityToken tk = getUserToken(request);
		if(tk == null) {
			response.setStatus(400);
			out.write("token");
			return;
		}
		
		String model_name = "";
		try {
		// On veut juste une parte 
		for(Part part : request.getParts()) {
			String filename = extractFileName(part);
			if(filename != null && filename.length() > 0) {
				String[] l = filename.split(Pattern.quote("."));
				if(l.length == 1) {
					// c'est notre model
					db.AddModel(tk.getId(), filename, part.getInputStream());
					model_name = filename;
				} else if(l.length == 2 && l[1].equals("png")) {
					db.AddLoadedTexture(tk.getId(), model_name, filename);
					InputStream is = part.getInputStream();
					db.AddNewTexture(tk.getId(),filename,"", 0, 0, 0, is);
				} else {
					response.setStatus(400);
					out.write("invalide extension");
					return;
				}
				
			}
		}
		} catch(SQLException e) {
			response.setStatus(400);
			out.write("SQL ERROR :"+e.getLocalizedMessage());
		}
	}

	@Override
	public String getServletInfo() {
		return "Short description";
	}// </editor-fold>

}
