/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios.api;

import ca.wquintal.helios.AccountDB;
import ca.wquintal.helios.YaseDB;
import ca.wquintal.helios.YaseDB.Texture;
import ca.wquintal.helios.api.BaseServlet;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author wq 
 */
public class YaseTextureServlet extends BaseServlet{

	
	private YaseDB db = null;
	
	public YaseTextureServlet() {
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
		
		String list_available = request.getParameter("list");
		if(list_available != null) {
			AccountDB.IdentityToken tk = getUserToken(request);
			try {
			List<String> texture = db.GetTextureList(tk.getId());
			Gson g = new Gson();
			PrintWriter out = response.getWriter();
			out.print(g.toJson(texture));
			out.flush();
		} catch(SQLException e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath()+"/img/noimage.jpg");
			return;
		}
		
		}
				
		if(name == null || name.isEmpty()) {
			response.sendRedirect(request.getContextPath()+"/img/noimage.jpg");
			return;
		}
		AccountDB.IdentityToken tk = getUserToken(request);
		try {
			Texture t = db.GetTexture(tk.getId(), name);
			String contentType = this.getServletContext().getMimeType(t.getName());
			System.out.println("Content Type: "+ contentType);
        
			response.setHeader("Content-Type", contentType);
        
			response.setHeader("Content-Length", String.valueOf(t.getData().length));
        
			response.setHeader("Content-Disposition", "inline; filename=\"" + t.getName() + "\"");
 
          // Write image data to Response.
			response.getOutputStream().write(t.getData());
		} catch(SQLException e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath()+"/img/noimage.jpg");
			return;
		}
		
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
		// Get les information sur l'image dans les parametre
		String width = request.getParameter("width");
		String height = request.getParameter("height");
		String channels = request.getParameter("channels");
		String category = request.getParameter("category");
		String description = request.getParameter("description");
		
		PrintWriter out = response.getWriter();
		
		// Get le token du user
		AccountDB.IdentityToken tk = getUserToken(request);
		if(tk == null) {
			response.setStatus(400);
			out.write("token");
			return;
		}
		
		try {
		// On veut juste une parte 
		for(Part part : request.getParts()) {
			String filename = extractFileName(part);
			if(filename != null && filename.length() > 0) {
				InputStream is = part.getInputStream();
				db.AddNewTexture(tk.getId(),filename,"", 0, 0, 0, is);
			}
			response.sendRedirect("/helios/yase_texture.jsp");
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
