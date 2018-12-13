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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

/**
 *
 * @author wq
 */

public class YaseSkyBoxServlet extends BaseServlet<Object> {

	public static String[] f_name = {"right.png", "left.png", "top.png", "bot.png","front.png","back.png"};
	
	private YaseDB db = null;
	
	public YaseSkyBoxServlet() {
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
		String face = request.getParameter("face");
		if(name == null) {
			AccountDB.IdentityToken tk = getUserToken(request);
			try {
			List<String> texture = db.GetSkyBoxList(tk.getId());
			Gson g = new Gson();
			PrintWriter out = response.getWriter();
			out.print(g.toJson(texture));
			out.flush();
		} catch(SQLException e) {
			e.printStackTrace();
			response.setStatus(400);
			response.sendRedirect(request.getContextPath()+"/img/noimage.jpg");
			return;
		}
		
		} else {
			if(face != null) {
				AccountDB.IdentityToken tk = getUserToken(request);
			try {
				int index_face = Integer.parseInt(face);
				byte[] t = db.GetSkyBoxFace(tk.getId(), name,index_face);
				String contentType = this.getServletContext().getMimeType(f_name[index_face]);
				System.out.println("Content Type: "+ contentType);
        
				response.setHeader("Content-Type", contentType);
        
				response.setHeader("Content-Length", String.valueOf(t.length));
        
				response.setHeader("Content-Disposition", "inline; filename=\"" + f_name[index_face] + "\"");
 
				// Write image data to Response.
				response.getOutputStream().write(t);
			} catch(SQLException e) {
				e.printStackTrace();
				response.setStatus(400);
				response.sendRedirect(request.getContextPath()+"/img/noimage.jpg");
				return;
			}
			}
		}
		
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
		// Get les information sur l'image dans les parametre
		String name = request.getParameter("description");
		if(name == null) {
			name = "box";
		}
		
		PrintWriter out = response.getWriter();
		InputStream[] is = new InputStream[6];
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
			int i = 0;
			for(String f : f_name) {
				if(f.equals(filename)) {
					break;
				}
				i++;
			}
			if(i == f_name.length) {
				// non de vichier invalid
				response.setStatus(400);
				out.write("SQL ERROR :"+"un des fichiers est invalide");
			}
			
			if(filename != null && filename.length() > 0) {
				is[i] = part.getInputStream();
			}
		}
		db.AddSkybox(tk.getId(), name, is[5], is[3], is[4], is[1], is[0], is[2]);
		response.setStatus(200);
		response.sendRedirect("/helios/yase_skybox.jsp");
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
