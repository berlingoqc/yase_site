<%-- 
    Document   : index
    Created on : 14-Sep-2018, 11:19:53 PM
    Author     : william
--%>

<%@page import="com.google.gson.Gson"%>
<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="ca.wquintal.helios.SettingsDB"%>
<%@page import="ca.wquintal.helios.AccountDB"%>
<%@page import="ca.wquintal.helios.ConnectionInfo"%>







<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/shared/import.jsp" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard admin</title>
	
    </head>
    
    <body>	
	<%
		// Va chercher les infos dans la session sur l'usager
		String s = (String)session.getAttribute("identity");
		Gson g = new Gson();
		AccountDB.IdentityToken t = g.fromJson(s, AccountDB.IdentityToken.class);
                
                SettingsDB ss = new SettingsDB();
                ss.OpenConfig();
		ConnectionInfo ci = ss.getConnectionInfo();
                

	%>
	<div class="container">
	        <h1>Dashboard Admin</h1>
		<h3>Emplacement configuration : <%=System.getProperty("user.dir")%></h3>
	    
		<h2>L'information de l'IdentityToken</h2>
		<ul class="list-group list-group-flush">
			<li class="list-group-item">ID <%=t.getId()%></li>
			<li class="list-group-item">Role <%=t.getRole()%> </li>
			<li class="list-group-item">Key <%=t.getIdentityHash()%></li>
		</ul>
                
                <h2>L'information de la base de donnée</h2>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">Connection  : <%=ci.GetConnection()%></li>
                    <li class="list-group-item">Utilisateur : <%=ci.GetUser()%></li>
                    <li class="list-group-item">Driver      : <%=ci.GetDriver()%></li>
                </ul>
                
                <h2>Utilisateur site web</h2>
                <ul class="list-group list-group-flush">
                    
                </ul>
		
		<jsp:include page="/shared/account_option.jsp" />
		
	</div>
    </body>
</html>
