<%-- 
    Document   : logout
    Created on : Oct 17, 2018, 10:07:42 PM
    Author     : wq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
	// Get la session la reinitialise et redirige vers login
	session.removeAttribute("identity");
	response.sendRedirect("/helios/account/login.jsp");

%>