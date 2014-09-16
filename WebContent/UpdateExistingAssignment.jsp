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
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Updating the assignment</title>
<style>




input {
	font: 15px/15px Arial, Helvetica, sans-serif;
	padding: 0;
}

fieldset.action {
	background: #9da2a6;
	border-color: #e5e5e5 #797c80 #797c80 #e5e5e5;
	margin-top: -20px;
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
a:hover {
	color: #7FCA9F;
	font: 15px/15px Arial, Helvetica, sans-serif;
} /* mouse over link */
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
		String port = dbp.getPortNumber();
		
		//get connection
		Connection dbcon = (new DatabseConnection()).dbConnection(hostname,
				dbName, username, passwd, port);

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