<%-- 
    Document   : yase_texture
    Created on : 12-Dec-2018, 6:35:33 PM
    Author     : wq
--%>

<%@page import="java.util.List"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="ca.wquintal.helios.AccountDB"%>
<%@page import="ca.wquintal.helios.YaseDB"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Texture</title>
	<jsp:include page="/shared/import.jsp"/>
	<link rel="stylesheet" href="style_global.css">

	
    </head>
    <body>
	
	<div class="container">
	<h2>Ajouter un nouvelle texture</h2>
 
	<form method="post" action="/helios/api/yase/skybox"
		enctype="multipart/form-data">
        
		Ajouter les faces de la skybox a ajouter:
		<br />
		<input  type="file" name="file"  />
		<br />
		<input  type="file" name="file"  />
		<br />
		<input  type="file" name="file"  />
		<br />
		<input  type="file" name="file"  />
		<br />
		<input  type="file" name="file"  />
		<br />
		<input  type="file" name="file"  />
		<br />
		<input type="text" name="description" size="100" />
		<input type="submit" value="Upload" />
	</form>
    
	<h2>Vos Skybox</h2>
	<%
	YaseDB ys = YaseDB.getDBInstance();
	String tk = (String)session.getAttribute("identity");
	Gson g = new Gson();
	AccountDB.IdentityToken t = g.fromJson(tk,AccountDB.IdentityToken.class);
	List<String> texture = ys.GetSkyBoxList(t.getId());
	%>

	<ul>	
	<%for(String s : texture) {%>
	<li ><a href="/helios/api/yase/skybox?name=<%=s%>&face=0"><%=s%></a></li>
	
	<% 
	}
	ys.Close();
	%>
	</ul>
	</div>
	<jsp:include page="/shared/footer.jsp"/>
    </body>
</html>
