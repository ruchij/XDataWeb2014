<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Update a single query</title>

<style>
html,body {
	margin: 0;
	width: 100%;
	height: 100%;
}

body {
	font: 12px/17px Arial, Helvetica, sans-serif;
	color: #333;
	background: #ccc;
	padding: 0px 0px 0px 0px;
}
</style>

</head>
<body>


	<%
		String queryID = (String) request.getParameter("question_id");
		String asID = (String) request.getParameter("assignment_id");
		String courseID = (String) request.getSession().getAttribute(
				"context_label");

		String correctquery = (String) request.getParameter("query").trim().replaceAll("\r\n+", " ").trim().replaceAll("\n+", " ").trim().replaceAll(" +", " ");
		String queryDesc = (String) request.getParameter("desc").trim().replaceAll("\r\n+", " ").trim().replaceAll("\n+", " ").trim().replaceAll(" +", " ");
		System.out.println("Desc: "+queryDesc);
		System.out.println("Correct: "+correctquery);
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
					.prepareStatement("SELECT * from qinfo where courseid=? and assignmentid=? and questionid=?");
			stmt.setString(1, courseID);
			stmt.setString(2, asID);
			stmt.setString(3, queryID);
			ResultSet rs = stmt.executeQuery();

			if (rs.next()) {
				/**query arleady present*/

				stmt = dbcon
						.prepareStatement("UPDATE qinfo SET querytext=?, correctquery=? WHERE courseid=? and assignmentid=? and questionid=?");

				stmt.setString(3, courseID);
				stmt.setString(4, asID);
				stmt.setString(5, queryID);

				stmt.setString(1, queryDesc);
				stmt.setString(2, correctquery);

			} else {
				stmt = dbcon
						.prepareStatement("INSERT INTO qinfo VALUES (?,?,?,?,?,?,?,?,?,?)");
				stmt.setString(1, courseID);
				stmt.setString(2, asID);
				stmt.setString(3, queryID.trim());
				stmt.setString(4, "");
				stmt.setString(5, queryDesc);
				stmt.setString(6, correctquery);
				stmt.setInt(7, 1);
				stmt.setBoolean(8, false);
				stmt.setBoolean(9, false);
				stmt.setBoolean(10, false);

			}
			
			rs.close();
			stmt.executeUpdate();
			String remoteLink = "ListOfQuestions.jsp?AssignmentID=" + asID;
			response.sendRedirect(remoteLink);

		} catch (SQLException sep) {	

			System.out.println("SQLException: " + sep);
			out.println("<p >Error in updating query </p>");
			String remoteLink = "ListOfQuestions.jsp?AssignmentID=" + asID;
			response.sendRedirect(remoteLink);
		}
		finally{
			dbcon.close();
		}
	%>
</body>
</html>