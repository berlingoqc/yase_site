/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios.api;

import ca.wquintal.helios.AccountDB;
import ca.wquintal.helios.YaseDB;
import com.google.gson.Gson;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;


/**
 *
 * @author wq
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
	maxFileSize = 1024 * 1024 * 10,
	maxRequestSize = 1024 * 1024 * 50)
public class YaseConfigServlet extends BaseServlet<Object> {
			
		
	private YaseDB db = null;
	
	public YaseConfigServlet() {
		super();
		try {
			db = YaseDB.getDBInstance();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	// Get le fichier de config d'une application YASE
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

		AccountDB.IdentityToken tk = getUserToken(request);
		try {
			byte[] d = db.GetEnvironmentConfig(tk.getId());
			if(d == null) {
				d = new byte[0];
			}
			String contentType = "application/octet-stream";
			System.out.println("Content Type: "+ contentType);
        
			response.setHeader("Content-Type", contentType);
        
			response.setHeader("Content-Length", String.valueOf(d.length));
        
			response.setHeader("Content-Disposition", "inline; filename=\"" + "env.yase" + "\"");
 
			 // Write image data to Response.
			response.getOutputStream().write(d);
		} catch(SQLException e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath()+"/img/noimage.jpg");
			return;
		}
		
	}

	/**
	 * Handles the HTTP <code>POST</code> method.
	 *
	 * @param request servlet request
	 * @param response servlet response
	 * @throws ServletException if a servlet-specific error occurs
	 * @throws IOException if an I/O error occurs
	 */
	
	// Entrepose le fichier de config d'une application yase
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
		
		try {
		// On veut juste une parte 
		for(Part part : request.getParts()) {
			String filename = extractFileName(part);
			if(filename != null && filename.length() > 0) {
				InputStream is = part.getInputStream();
				db.AddEnvironmentConfig(tk.getId(), is);
			}
			response.setStatus(200);
			return;
		}
		} catch(SQLException e) {
			response.setStatus(400);
			out.write("SQL ERROR :"+e.getLocalizedMessage());
		}
	}

	/**
	 * Returns a short description of the servlet.
	 *
	 * @return a String containing servlet description
	 */
	@Override
	public String getServletInfo() {
		return "Short description";
	}// </editor-fold>

}
