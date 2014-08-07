<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Updating the assignment</title>
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
	width: 90%;
	height: 100%;
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
</style>
</head>
<body>

	<%
		String asgnmentID = (String) request.getParameter("AssignmentID");
		String courseID = (String) (String) request.getSession()
				.getAttribute("context_label");
		//getting parameters
		String description = request.getParameter("description");
		String schemaId = request.getParameter("schemaId");
		String dbPassword = request.getParameter("dbPassword");
		String dbuserName = request.getParameter("dbuserName");
		String jdbcUrl = request.getParameter("jdbcurl");
		String dbType = request.getParameter("dbaseType");

		String startmonth = request.getParameter("startmonth");
		String startday = request.getParameter("startday");
		String startyear = request.getParameter("startyear");
		String starthour = request.getParameter("starthour");
		String startmin = request.getParameter("startmin");
		String startampm = request.getParameter("startampm");

		int starttime = (Integer.parseInt(starthour))
				+ (Integer.parseInt(startampm));

		String endmonth = request.getParameter("endmonth");
		String endday = request.getParameter("endday");
		String endyear = request.getParameter("endyear");
		String endhour = request.getParameter("endhour");
		String endmin = request.getParameter("endmin");
		String endampm = request.getParameter("endampm");

		int endtime = (Integer.parseInt(endhour))
				+ (Integer.parseInt(endampm));

		String startDate = startday + "-" + startmonth + "-" + startyear
				+ " " + starttime + ":" + startmin + ":" + "00";
		String endDate = endday + "-" + endmonth + "-" + endyear + " "
				+ endtime + ":" + endmin + ":" + "00";

		//get database properties
		DatabaseProperties dbp = new DatabaseProperties();
		String username = dbp.getUsername1(); 
		String username2 = dbp.getUsername2();
		String passwd = dbp.getPasswd1(); 
		String passwd2 = dbp.getPasswd2();
		String hostname = dbp.getHostname();
		String dbName = dbp.getDbName();
		//get connection
		Connection dbcon = (new DatabseConnection()).dbConnection(hostname,
				dbName, username, passwd);

		try {
			PreparedStatement stmt;
			/*//below code is for new assignment table 	
			stmt = dbcon.prepareStatement("UPDATE assignment SET course_id = ?, description = ?, database_type = ?, jdbc_url = ?, database_user = ?, database_password = ?, default_schema_id = ?, start_time=to_timestamp(?,'dd-mm-yyyy hh24:mi:ss'),end_time=to_timestamp(?,'dd-mm-yyyy hh24:mi:ss') WHERE assignment_id=?");
					
				
				
				stmt.setString(1, courseID);
				stmt.setString(2, description);
				stmt.setString(3, dbType);
				stmt.setString(4, jdbcUrl);
				stmt.setString(5, dbuserName);
				stmt.setString(6, dbPassword);
				stmt.setString(7, schemaId);
				stmt.setString(8, startDate);
				stmt.setString(9, endDate);
				stmt.setString(10,asgnmentID); */

			stmt = dbcon
					.prepareStatement("UPDATE assignment SET starttime=to_timestamp(?,'dd-mm-yyyy hh24:mi:ss'),endtime=to_timestamp(?,'dd-mm-yyyy hh24:mi:ss') WHERE assignmentid=? and courseid = ?");

			stmt.setString(1, startDate);
			stmt.setString(2, endDate);
			stmt.setString(3, asgnmentID);
			stmt.setString(4, courseID);

			stmt.executeUpdate();
			
			//response.sendRedirect("Welcome.jsp");
			out.println("<p align=\"center\" style=\"font-size:18px;\"><marquee>Assignment Updated Successfully </marquee></p>");
		}

		catch (SQLException sep) {
			System.out.println("Could not connect to database: " + sep);
			out.println("Error in uploading assignment");
		}
		dbcon.close();
	%>
</body>
</html>