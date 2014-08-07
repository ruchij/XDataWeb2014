<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@page import="database.CommonFunctions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Edit Assignment</title>
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

fieldset {
	background: #f2f2e6;
	padding: 10px;
	border: 1px solid #fff;
	border-color: #fff #666661 #666661 #fff;
	margin-bottom: 36px;
}

.ta {
	width: 40%;
	height: 80px;
}

input {
	font: 15px/15px Arial, Helvetica, sans-serif;
	padding: 0;
}

fieldset.action {
	background: #9da2a6;
	border-color: #e5e5e5 #797c80 #797c80 #e5e5e5;
	margin-top: -20px;
}

legend {
	background: #bfbf30;
	color: #fff;
	font: 17px/21px Calibri, Arial, Helvetica, sans-serif;
	padding: 0 10px;
	margin: -26px 0 0 -11px;
	font-weight: bold;
	border: 1px solid #fff;
	border-color: #e5e5c3 #505014 #505014 #e5e5c3;
	text-align: left;
}

label {
	font-size: 15px;
	font-weight: bold;
	color: #666;
}

label span,.required {
	color: red;
	font-weight: bold;
	font-size: 17px;
}

a:link {
	color: #E96D63;
	font: 15px/15px Arial, Helvetica, sans-serif;
} /* unvisited link */
a:visited {
	color: #E96D63;
	font: 15px/15px Arial, Helvetica, sans-serif;
} /* visited link */
a:hover {
	color: #7FCA9F;
	font: 15px/15px Arial, Helvetica, sans-serif;
} /* mouse over link */
a:active {
	color: #85C1F5;
	font: 15px/15px Arial, Helvetica, sans-serif;
} /* selected link */
.stop-scrolling {
	height: 100%;
	overflow: hidden;
}

.assgnmentForm {
	margin: 0 auto;
	align: center;
}
</style>
<script type="text/javascript" src="scripts/ManageQuery.js"></script>
</head>
<body>

	<div>
		<br /> <br />

		<%
			String assignID = (String) request.getParameter("AssignmentID");
			String courseID = (String) request.getSession().getAttribute(
					"context_label");

			//get database properties
			DatabaseProperties dbp = new DatabaseProperties();
			String username = dbp.getUsername1(); //change user name according to your db user -testing1
			String username2 = dbp.getUsername2();//This is for testing2
			String passwd = dbp.getPasswd1(); //change user passwd according to your db user passwd
			String passwd2 = dbp.getPasswd2();
			String hostname = dbp.getHostname();
			String dbName = dbp.getDbName();
			//get connection
			Connection dbcon = (new DatabseConnection()).dbConnection(hostname,
					dbName, username, passwd);

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
					+ "<label >Asssignment ID: <label style=\"color: blue;\">"
					+ assignID
					+ "</label></label> <br/><br/>"

					+ "<label ><strong>Assignment Description</strong></label> <br/>"
					+ "<textarea  class=\"ta\" placeholder=\"Give description of this assignment, if any\" name=\"description\">"
					+ asDescription + " </textarea> <br/><br/>";

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

			outp += "<label><span>*</span><strong>Database Connection</strong></label>  <select name=\"dbConnection\" style=\"clear:both;\"> "
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
			outp += "<label><span>*</span><strong>Database Schema</strong></label>  <select name=\"schemaid\" style=\"clear:both;\"> "
					+ outp + "</select> ";
			//output += outp;
			
			output += "<label ><span>*</span><strong>Assignment Opens at</strong></label><br />";

			database.CommonFunctions util = new database.CommonFunctions();
			output += util.getTimeDetails(start, true);
			output += "<label ><span>*</span><strong>Assignment Closes at</strong></label><br />";

			output += util.getTimeDetails(end, false);
			output += "<input  type=\"submit\" id=\"sub\" value=\"Update\">   <br/>";

			out.println(output);
			dbcon.close();
		%>
		</fieldset>
	</div>
	</div>
</body>
</html>