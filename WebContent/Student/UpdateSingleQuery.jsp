<%@page import="database.CommonFunctions"%>
<%@page import="testDataGen.TestAssignment"%>
<%@page import="testDataGen.QueryStatusData" %>
<%@page import="testDataGen.QueryStatusData.QueryStatus" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.text.*"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="../css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Update a single query</title>

<style>

</style>

</head>
<body>


	<%
		Boolean interactiveMode = false;
			String queryID = (String) request.getParameter("questionId");
			String asID = (String) request.getParameter("assignmentId");
			String courseID = (String) request.getSession().getAttribute(
			"context_label");
			String studentID = (String) request.getParameter("studentId");
			String correctquery = (String) request.getParameter("query");
			
			correctquery = correctquery.replaceAll("[ ;]+$", "");
			
			Connection dbcon = null;

			dbcon = (new DatabaseConnection()).graderConnection();
			
			Connection testConn = (new DatabaseConnection()).testConnection();
			
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
			interactiveMode = rs.getBoolean("learning_mode");
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
				//rs.close();
				//dbcon.close();
				
				TestAssignment ta = new TestAssignment();
				String args[] = {String.valueOf(asID), String.valueOf(queryID.trim()), studentID};
				
				QueryStatusData status;
				if(interactiveMode){
					 status = ta.evaluateQuestion(dbcon, testConn, args);
				}
				else{
					status = ta.testQuery(args);
				}
				
				System.out.println("TestQueryOuput" + status.toString());
				String remoteLink = "";
				if(interactiveMode){
					session.setAttribute("dbConn", dbcon);
					session.setAttribute("testConn", testConn);	
					session.setAttribute("displayTestCase", true);
				}
				else{
					session.setAttribute("displayTestCase", false);						
				}
				
				remoteLink = "/XDataWeb2013/StudentTestCase?user_id=" + studentID +"&assignment_id=" + asID 
						+ "&question_id=" + queryID +"&query=" + CommonFunctions.encodeURIComponent(correctquery) + "&status=" + status.Status.toString();
				
				if(status.Status == QueryStatus.Error){
					remoteLink += "&Error=" + CommonFunctions.encodeURIComponent(status.ErrorMessage);
				}
				
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
	%>
</body>
</html>