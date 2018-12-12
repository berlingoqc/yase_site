/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios.api.init;

import ca.wquintal.helios.api.BaseServlet;
import ca.wquintal.helios.AccountDB;
import ca.wquintal.helios.ConnectionInfo;
import ca.wquintal.helios.MyBD;
import ca.wquintal.helios.SettingsDB;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.persistence.criteria.CriteriaBuilder;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import jdk.nashorn.internal.parser.JSONParser;
import org.apache.jasper.tagplugins.jstl.ForEach;


/**
 *
 * @author wq
 */
public class config extends BaseServlet {
	
	public config() {
		super();
	}



    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            // Get les do
        }
    }
    


    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
		processRequest(request, response);
    }

        @Override
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html;charset=UTF-8");
		//  Recoit le mot de passe pour le compte admin, crée le compte live up
		//  ajout son token d'identiter a la session et ferme cette api
		String secret = request.getParameter("secret");
		if(secret == null || secret.length() == 0) {
			response.setStatus(400);
			return;
		}
		// Get une instance de la bd et ajout le nouveau compte
		String s;
		try {
			AccountDB db = AccountDB.getAccountDBInstance();
			s = db.CreateAdminAccount(secret);
		} catch(Exception e) {
			e.printStackTrace();
			response.setStatus(400);
			return;
		}
		
		response.setStatus(201);
		// ajout le token a son object session
		HttpSession session = request.getSession(true);
		session.setAttribute("identity",s);
	}
    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
	    String secret = request.getParameter("secret");
	    if(secret != null && secret.length() > 0) {
			// Get une instance de la bd et ajout le nouveau compte
		String s;
		try {
			AccountDB db = AccountDB.getAccountDBInstance();
			s = db.CreateAdminAccount(secret);
		} catch(Exception e) {
			e.printStackTrace();
			response.setStatus(400);
			return;
		}
		
		response.setStatus(201);
		// ajout le token a son object session
		HttpSession session = request.getSession(true);
		session.setAttribute("identity",s);
			return;
	    } 
            String msg = "success";
            // Get les données json passer a la requete post
            ConnectionInfo ci = null;
	    Boolean succeed = true;
            try {
		  ci = (ConnectionInfo) parseDataJson(request, ConnectionInfo.class);
                //ci = g.fromJson(br, ConnectionInfo.class);
            } catch(JsonSyntaxException e) {
		msg = e.getMessage();
                succeed = false;
            }
            if(ci == null || !succeed) {
                response.setStatus(400);
            }
            else {
                try {
                    MyBD bd;
                    bd = new MyBD(ci);
		    bd.OpenIfClose();
                    bd.Close();
		    
		    // ajoute la config au fichier de config
		    SettingsDB s = new SettingsDB();
		    // TODO si le settings existe deja throw une erreur
		    if(!s.SaveConfig(ci)) {
			    msg = s.getLastException().getLocalizedMessage();
			    response.setStatus(400);
		    } else {
			    response.setStatus(201);
		    }
                } catch(SQLException | ClassNotFoundException e) {
                    msg = e.getLocalizedMessage();
                    response.setStatus(400);
                };
            }
            response.setContentType("text/html;charset=UTF-8");
            try (PrintWriter out = response.getWriter()) {
                out.print(msg);
                out.flush();
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
