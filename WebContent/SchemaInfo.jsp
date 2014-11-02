<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="scripts/wufoo.js"></script>
<link rel="canonical"
	href="http://www.wufoo.com/gallery/designs/template.html">
	
<title>Schema Information</title>
<style>
body {
	font: 17px/20px Arial, Helvetica, sans-serif;
	color: #333;
	
	padding: 40px 20px 20px 20px;
}
</style>
<script>
</script>
</head>
<body>
<%

if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
	response.sendRedirect("index.html");
	return;
}

//get the connection for testing1
Connection dbcon = (new DatabaseConnection()).graderConnection();

try {

	PreparedStatement stmt;
	stmt = dbcon
			.prepareStatement("SELECT schema_id,schema_name,ddltext,sample_data FROM schemainfo WHERE course_id = ?");
	stmt.setString(1, (String) (String) request.getSession()
			.getAttribute("context_label"));
	out.println("<table border=\"2\" style=\"width:90%\">");
	out.println("<tr><th>Schema Id</th><th>Schema Name</th><th>Schema Defination</th></tr>");

	String output = "";
	ResultSet rs = stmt.executeQuery();
	while (rs.next()) {
		out.println("<tr><td>"+rs.getString("schema_id")+"</td><td>"+rs.getString("schema_name")+"</td><td>"+rs.getString("ddltext").replaceAll(";","<br>").replaceAll("create temporary table","create table")+"</td></tr>");
	} 
	out.println("<br>");
	
	rs.close();
}catch(Exception e){
	e.printStackTrace();
}
out.println("<a href=initialDataUpload.jsp>Back</a>");
%>

</body>	
</html>