<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>UPdate Database Connection</title>
<style>
html,body {
	background: #ccc;
}
</style>
</head>
<body>

	<%
		/**get parameters*/
		String courseId = (String) request.getSession().getAttribute(
				"context_label");
		String dbConnectName = (String) request.getParameter("dbConnectName");
		String databaseType = (String) request.getParameter("databaseType");
		String schemaid = (String) request.getParameter("schemaid");
		String jdbcurl = (String) request.getParameter("jdbcurl");
		String dbuserName = (String) request.getParameter("dbuserName");
		String dbPassword = (String) request.getParameter("dbPassword");

		//get database properties
		DatabaseProperties dbp = new DatabaseProperties();
		String username = dbp.getUsername1(); //change user name according to your db user -testing1
		String username2 = dbp.getUsername2();//This is for testing2
		String passwd = dbp.getPasswd1(); //change user passwd according to your db user passwd
		String passwd2 = dbp.getPasswd2();
		String hostname = dbp.getHostname();
		String dbName = dbp.getDbName();

		Connection dbcon = null;

		dbcon = (new DatabseConnection()).dbConnection(hostname, dbName,
				username, passwd);

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