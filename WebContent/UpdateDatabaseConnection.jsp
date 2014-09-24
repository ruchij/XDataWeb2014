<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>UPdate Database Connection</title>
<style>
</style>
</head>
<body>

	<%
		if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
		response.sendRedirect("index.html");
		return;
			}
		
			/**get parameters*/
			String courseId = (String) request.getSession().getAttribute(
			"context_label");
			String dbConnectName = (String) request.getParameter("dbConnectName");
			String databaseType = (String) request.getParameter("databaseType");
			String schemaid = (String) request.getParameter("schemaid");
			String jdbcurl = (String) request.getParameter("jdbcurl");
			String dbuserName = (String) request.getParameter("dbuserName");
			String dbPassword = (String) request.getParameter("dbPassword");

			Connection dbcon = null;

			dbcon = (new DatabaseConnection()).graderConnection();

			try {
		PreparedStatement stmt;
		stmt = dbcon
				.prepareStatement("INSERT INTO database_connection VALUES (?,DEFAULT,?,?,?,?,?)");

		stmt.setString(1, courseId);
		stmt.setString(2, dbConnectName);
		stmt.setString(3, databaseType);
		stmt.setString(4, jdbcurl);
		stmt.setString(5, dbuserName);
		stmt.setString(6, dbPassword);
		

		stmt.executeUpdate();
		out.println("<marquee>Updated Successfully</marquee>");

		
			} catch (SQLException sep) {
		System.out.println("Could not connect to database: " + sep);
		out.println("<marquee>Error in updating</marquee>");
		//System.exit(1);
			}
	%>


</body>
</html>