/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ca.wquintal.helios.filter;

import ca.wquintal.helios.AccountDB;
import ca.wquintal.helios.SettingsDB;
import ca.wquintal.helios.User;
import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author wq
 */
public class LoginFilter implements Filter {
	
	private String contextPath;
	private Gson gson;
	
	private Boolean isConfigurate = false;

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		gson = new Gson();
		contextPath = filterConfig.getServletContext().getContextPath();
	}
	
	
	private void onFail(Exception ex,HttpServletRequest req, HttpServletResponse res) throws IOException, ServletException {
		Logger.getLogger(LoginFilter.class.getName()).log(Level.SEVERE, null, ex);
		res.getWriter().append("error="+ex.getMessage()+"&on="+req.getServletPath()).flush();
		req.getRequestDispatcher("/oups.jsp").forward(req, res);
	}
        

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest)request;
		HttpServletResponse res = (HttpServletResponse)response;
		
		String servletPath = req.getServletPath();
				// permet d'acceder au page public

		if(!isConfigurate) {

			// Initialize mon SettingsDB s'il n'existe pas redirige vers une page pour

			// crée les settings

			if(servletPath.matches("/api/init/.*")) {

				chain.doFilter(request, response);

				return;

			}

			SettingsDB set = new SettingsDB();

			if(!set.OpenConfig()) {

				// mets un cookie pour dire qu'il n'est pas configurer

				Cookie notset = new Cookie("isconf","false");

				notset.setMaxAge(60*60*10);

				res.addCookie(notset);

				// redirige vers la page

				req.getRequestDispatcher("/init/index.jsp").forward(request,response);

				return;

			}

			// si la bd est configurer regarde que l'account admin soit bien crée si on redirige vers la page de config admin

			try {

				AccountDB db = AccountDB.getAccountDBInstance();

				if(db != null && !db.DoesAccountExists("admin")) {

					// admin n'est pas encore configurer on renvoie vers la page de configuration

					req.getRequestDispatcher("/init/setup.jsp").forward(request, response);

					return;

				}

			} catch(SQLException | ClassNotFoundException e) {

				// affiche un message d'erreur pour dire que les tables ne sont pas

				// crée dans la bd

				response.getWriter().append(e.getMessage()).flush();

				req.getRequestDispatcher("/public/oups.jsp").forward(request, response);

				return;

			}

			// Si tout ca est beau, on va regarder si connecter sinon redirige vers login

			isConfigurate = true;

		}		
		// Si on va vers les logions on laisse continuer
		if(servletPath.startsWith("/assets")) {
			chain.doFilter(request, response);
			return;
		}
		// Si on va vers les logions on laisse continuer
		if(servletPath.startsWith("/account")) {
			chain.doFilter(request, response);
			return;
		}
		if(servletPath.matches("/index.html") || servletPath.matches("/index.jsp")) {
			chain.doFilter(request, response);
			return;
		}
		
		if(servletPath.startsWith("/api/account")) {
			chain.doFilter(request,response);
			return;
		}
		
	
		// si on n'a pas de identity on est retourner a la page des logins
		String tkAttr = (String)req.getSession().getAttribute("identity");
		if( tkAttr == null) {
			req.getRequestDispatcher("/account/login.jsp").forward(req, res);
		} else {
			// Get notre identiter et valide avec la db qu'il est valide
			AccountDB db = null;
                        AccountDB.IdentityToken tk = null;
			try {
				db = AccountDB.getAccountDBInstance();
				db.OpenIfClose();
			} catch (SQLException | ClassNotFoundException ex) {
				onFail(ex, req, res);
				return;
			}
			
			try {
				tk = gson.fromJson(tkAttr, AccountDB.IdentityToken.class);
				if(!db.IsValidUser(tk.getId(), tk.getIdentityHash())) {
					// le token n'est pas valide va faire la page de denied
					req.getRequestDispatcher("/account/login.jsp").forward(req, res);
										db.Close();
					return;
				}
				// valide que le token est toujours bon , sinon retourne vers les logins
				
			} catch(JsonSyntaxException | SQLException ex) {
				onFail(ex, req, res);
				return;
			}
			
                        
                        // si on n'accede dashboard regarde si on n'est admin et redirige vers
                        // dashboard admin
                        if(servletPath.startsWith("/dashboard") && tk.getRole() == User.ROLE_ADMIN) {
                            req.getRequestDispatcher("/dashboard_admin.jsp").forward(req, res);
                            return;
                        }

			// si tout est beau on continue notre chemin
			if(servletPath.equals("/reset.jsp"))  {
				try {
					db.DeleteAll();
					(new SettingsDB()).Delete();
				} catch(Exception e) {
				
				}
								req.getRequestDispatcher("/init/index.jsp").forward(request,response);
								isConfigurate = false;
								return;
			}
			db.Close();
			chain.doFilter(request, response);
		}
		
	}
	
	

	@Override
	public void destroy() {
		
	}
	
}
