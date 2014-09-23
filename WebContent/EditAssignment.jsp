<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@page import="database.CommonFunctions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<link rel="stylesheet" href="css/structure.css" type="text/css" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Edit Assignment</title>
<style>


.fieldset fieldset{
	padding-left: 30px;
	padding-top:30px;
}

.fieldset div label{
	float:left;
	width: 250px;
}

.fieldset div{
	margin-bottom: 20px;
	height:20px;
	width:100%;
}

.fieldset div input{
	width: 400px;
	height: 20px;
	float:left;
}

</style>
<script type="text/javascript" src="scripts/ManageQuery.js"></script>
</head>
<body>

	<div>
		<br /> <br />

		<%
			if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
				response.sendRedirect("index.html");
				return;
			}
				
			String assignID = (String) request.getParameter("AssignmentID");
			String courseID = (String) request.getSession().getAttribute(
					"context_label");

			//get connection
			Connection dbcon = (new DatabaseConnection()).graderConnection();

			/**store details of assignment*/
			String asDescription = "", dbType = "", jdbcUrl = "", dbUser = "", dbPassword = "", schemaId = "";
			/**get time stamp details*/
			Timestamp start = null;
			Timestamp end = null;
			try {
				PreparedStatement stmt;
				ResultSet rs;
				stmt = dbcon
						.prepareStatement("SELECT * FROM  assignment where assignmentid=? and courseid=?");
				stmt.setString(1, assignID);
				stmt.setString(2, courseID);
				rs = stmt.executeQuery();
				if (rs.next()) {
					start = rs.getTimestamp("starttime");
					end = rs.getTimestamp("endtime");
					//start=rs.getString("end_date");
				}
				
				rs.close();

			} catch (Exception err) {
				out.println("Error in getting assignment details");
				err.printStackTrace();
				return;
			}

			String output = "";

			output += "<form class=\"assgnmentForm\" name=\"assgnmentForm\" action=\"UpdateExistingAssignment.jsp?AssignmentID="
					+ assignID
					+ "\" method=\"post\" onsubmit=\"return(validate());\" > \n"

					+ "<div class=\"fieldset\">	<fieldset>	<legend> Editing Assignment Details</legend> \n"
					+ "<label  style='font-weight:bold;'>Asssignment ID: <label>"
					+ assignID
					+ "</label></label> <br/><br/>"

					+ "<div><label >Assignment Description</label>"
					+ "<input placeholder='Give description of this assignment, if any' value = '"+asDescription + "' name='description'/></div>";

			PreparedStatement stmt = dbcon
					.prepareStatement("SELECT connection_id,connection_name FROM database_connection WHERE course_id = ?");
			stmt.setString(1, courseID);

			String outp = "";
			ResultSet rs = stmt.executeQuery();
			while (rs.next()) {
				outp += " <option value = \"" + rs.getInt("connection_id")
						+ "\"> " + rs.getInt("connection_id") + "-"
						+ rs.getString("connection_name") + " </option> ";
			}
			
			rs.close();

			outp += "<label>Database Connection</label>  <select name=\"dbConnection\" style=\"clear:both;\"> "
					+ out + "</select> ";
			//output += outp;
			outp = "";

			stmt = dbcon
					.prepareStatement("SELECT schema_id,schema_name FROM schemainfo WHERE course_id = ?");
			stmt.setString(1, courseID);
			/* rs = stmt.executeQuery();
			
			while (rs.next()) {
				outp += " <option value = \"" + rs.getInt("schema_id")
						+ "\"> " + rs.getInt("schema_id") + "-"
						+ rs.getString("schema_name") + " </option> ";
			}  */
			outp += " <option value = \"1\" required> 1-Test Schema</option> ";
			outp += "<label>Database Schema</label>  <select name=\"schemaid\" style=\"clear:both;\"> "
					+ outp + "</select> ";
			//output += outp;
			
			output += "<div><label >Assignment Opens at</label>";

			database.CommonFunctions util = new database.CommonFunctions();
			output += util.getTimeDetails(start, true);
			output += "</div><div><label >Assignment Closes at</label>";

			output += util.getTimeDetails(end, false);
			output += "</div><input  type=\"submit\" id=\"sub\" value=\"Update\">   <br/>";

			out.println(output);
			dbcon.close();
		%>
		</fieldset>
	</div>
	</div>
</body>
</html>