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
 
	<form method="post" action="/helios/api/yase/model"
		enctype="multipart/form-data">
		Nom du model:
		<input type="text" name="description" size="100" />
		<br />
		Selectionner le model a ajouter:
		<br />
		<input  type="file" name="file"  />
		<br />
		Selectionner les texture qui l'accompagne:
		<input  type="file" name="file"  />
		<br />
		<input  type="file" name="file"  />
		<br />
		<input type="submit" value="Upload" />
	</form>
    
	<h2>Vos textures</h2>
	<%
	YaseDB ys = YaseDB.getDBInstance();
	String tk = (String)session.getAttribute("identity");
	Gson g = new Gson();
	AccountDB.IdentityToken t = g.fromJson(tk,AccountDB.IdentityToken.class);
	List<String> texture = ys.GetModelList(t.getId());
	%>

	<ul>	
	<%for(String s : texture) {%>
	<li ><a href="/helios/api/yase/model?name=<%=s%>"><%=s%></a></li>
	
	<% 
	}
	ys.Close();
	%>
	</ul>
	</div>
	<jsp:include page="/shared/footer.jsp"/>
    </body>
</html>
