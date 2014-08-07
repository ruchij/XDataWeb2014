<%@page import="testDataGen.TestAssignment"%>
<%@page import="testDataGen.TestAssignment.QueryStatus" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Update a single query</title>

<style>
html,body {
	margin: 0;
	background: #ccc;
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
		String queryID = (String) request.getParameter("questionId");
		String asID = (String) request.getParameter("assignmentId");
		String courseID = (String) request.getSession().getAttribute(
				"context_label");
		String studentID = (String) request.getParameter("studentId");
		String correctquery = (String) request.getParameter("query");
		
		correctquery = correctquery.replaceAll("[ ;]+$", "");
		
		//get database properties
		DatabaseProperties dbp = new DatabaseProperties();
		String username = dbp.getUsername1(); //change user name according to your db user -testing1
		String username2 = dbp.getUsername2();//This is for testing2
		String passwd = dbp.getPasswd1(); //change user passwd according to your db user passwd
		String passwd2 = dbp.getPasswd1();
		String hostname = dbp.getHostname();
		String dbName = dbp.getDbName();

		Connection dbcon = null;

		dbcon = (new DatabseConnection()).dbConnection(hostname, dbName,
				username, passwd);
		
		PreparedStatement stmt;
		ResultSet rs = null;
		
		Timestamp start = null;
		Timestamp end = null;
		try {
			
			stmt = dbcon.prepareStatement("SELECT * FROM  assignment where assignmentid=? and courseid=?");
			stmt.setString(1, asID.trim());
			stmt.setString(2, courseID.trim());
			rs = stmt.executeQuery();
			while (rs.next()) {
				start = rs.getTimestamp("starttime");
				end = rs.getTimestamp("endtime");
			}

		} catch (Exception err) {
			err.printStackTrace();
			out.println("Error in retrieving list of questions");

		}
		
		System.out.println("Start :" + start);
		System.out.println("End :" + end);
		//now check whether current time is less than start time.Then only assignment can be edited
		boolean expired = false;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		formatter.setLenient(false);
		String ending = formatter.format(end);
		String starting = formatter.format(start);

		java.util.Date oldDate = formatter.parse(ending);
		
		//get current date
		Calendar c = Calendar.getInstance();

		String currentDate = formatter.format(c.getTime());
		java.util.Date current = formatter.parse(currentDate);

		//compare times
		if (current.compareTo(oldDate) > 0) {
			expired = true;
		}
		
		if(expired){
			
			String remoteLink = "ListOfQuestions.jsp?AssignmentID=" + asID + "&&studentId=" + studentID
					+ "&&status=" + "expired";
			response.sendRedirect(remoteLink);
			
		}
		else{
		
			try {
					
					String questionId = "A"+asID+"Q"+queryID.trim();			
					
					stmt = dbcon.prepareStatement("select 1 from queries where queryid = ? and rollnum = ?");
					stmt.setString(1, questionId);
					stmt.setString(2, studentID);
					rs = stmt.executeQuery();
					
					if(!rs.next()){
					
						stmt = dbcon.prepareStatement("INSERT INTO queries VALUES(?,?,?,?,?,?)");
						stmt.setString(1, "dbid");/**FIXME: */
						stmt.setString(2, questionId);
						stmt.setString(3, studentID);
						stmt.setString(4, correctquery);
						stmt.setBoolean(5, true);
						stmt.setBoolean(6, false);
					}
					else{
						stmt = dbcon.prepareStatement("UPDATE queries SET querystring=? WHERE queryid=? AND rollnum=?");
						
						stmt.setString(1, correctquery);
						stmt.setString(2, questionId);
						stmt.setString(3, studentID);
					}
					
					stmt.executeUpdate();
					rs.close();
					
					TestAssignment ta = new TestAssignment();
					String args[] = {String.valueOf(asID), String.valueOf(queryID.trim()), studentID};
					
					TestAssignment.QueryStatus status = ta.testQuery(args);
					
					System.out.println("TestQueryOuput" + status.toString());
					
					String remoteLink = "ListOfQuestions.jsp?AssignmentID=" + asID + "&&studentId=" + studentID
											+ "&&status=" + status.toString();
					response.sendRedirect(remoteLink);
		
				}
				catch (SQLException sep) {
					
					String remoteLink = "ListOfQuestions.jsp?AssignmentID="+asID+"&&studentId="+studentID;
					response.sendRedirect(remoteLink);
				 	System.out.println("SQLException: " + sep);
					out.println("<p >Error in updating query </p>");
					//System.exit(1); 
				}				
		}
		
		dbcon.close();
		
	%>
</body>
</html>