<%-- 
    Document   : dashboard_admin
    Created on : 2018-12-12, 12:49:23
    Author     : wq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Dashboard</title>

        <jsp:include page="/shared/import.jsp" />
	<link rel="stylesheet" href="style_global.css">
    </head>
    <body>
	<div class='container'>
        <h1>Dashboard</h1>
	<jsp:include page="/shared/yase_option.jsp"/>
        <jsp:include page="/shared/account_option.jsp" />
	</div>
    <jsp:include page="/shared/footer.jsp" />
    </body>
</html>
