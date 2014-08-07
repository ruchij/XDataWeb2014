<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.CommonFunctions"%>
<%@page import="database.DatabaseProperties"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>List Of Questions</title>
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
	width: 93%;
	height: 100%;
}

textarea,select {
	font: 12px/12px Arial, Helvetica, sans-serif;
	padding: 0;
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

	<div>
		<br />
		<br />
		<div class="fieldset">
			<fieldset>
				<legend> Assignment Instructions</legend>
				<ul>
					<li>Click edit to enter your answer</li>
				</ul>
				<p></p>
				<p></p>
			</fieldset>
			<fieldset>
				<legend> List of Questions</legend>

				<%
					String assignID = (String) request.getParameter("AssignmentID");
					String courseID = (String) request.getSession().getAttribute(
							"context_label");
					String studentId = (String) request.getParameter("studentId");
					
					String status = request.getParameter("status");
										
					if (studentId == null)
						studentId = (String) request.getSession().getAttribute(
								"user_id");
					//out.println("Hi"+asgnmentID);
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

					Timestamp start = null;
					Timestamp end = null;
					try {
						PreparedStatement stmt;
						ResultSet rs = null;
						stmt = dbcon
								.prepareStatement("SELECT * FROM  assignment where assignmentid=? and courseid=?");
						stmt.setString(1, assignID.trim());
						stmt.setString(2, courseID.trim());
						rs = stmt.executeQuery();
						while (rs.next()) {
							start = rs.getTimestamp("starttime");
							end = rs.getTimestamp("endtime");
							//start=rs.getString("end_date");
						}

					} catch (Exception err) {
						err.printStackTrace();
						out.println("Error in retrieving list of questions");

					}

					System.out.println("Start :" + start);
					System.out.println("End :" + end);
					//now check whether current time is less than start time.Then only assignment can be edited
					boolean yes = false;
					SimpleDateFormat formatter = new SimpleDateFormat(
							"yyyy-MM-dd HH:mm:ss");
					formatter.setLenient(false);
					String ending = formatter.format(end);
					String starting = formatter.format(start);
					//String oldTime = "2012-07-11 10:55:21";
					java.util.Date oldDate = formatter.parse(ending);
					//get current date
					Calendar c = Calendar.getInstance();

					String currentDate = formatter.format(c.getTime());
					java.util.Date current = formatter.parse(currentDate);

					//compare times
					if (current.compareTo(oldDate) > 0) {
						yes = true;
					}

					String output = "<table  cellspacing=\"20\"  class=\"authors-list\" id=\"queryTable\" align=\"center\"> <tr> <th >Question ID</th>       <th >Question Description</th>  <th >Your Answer</th> <th> </th></tr>";
					try {
						PreparedStatement stmt;
						//stmt = dbcon.prepareStatement("SELECT * FROM  qinfo ,assignment where qinfo.assignment_id=? AND qinfo.assignment_id=assignment.assignment_id");
						stmt = dbcon
								.prepareStatement("SELECT * FROM  qinfo  where assignmentid=? and courseid=? order by questionid");
						stmt.setString(1, assignID.trim());
						stmt.setString(2, courseID.trim());
						ResultSet rs = stmt.executeQuery();

						while (rs.next()) {

							String qID = rs.getString("questionid");
							System.out.println(qID);
							String desc = rs.getString("querytext");

							stmt = dbcon
									.prepareStatement("SELECT * FROM  queries  where queryid=? and rollnum=?");
							
							String queryId = "A"+assignID.trim()+"Q"+qID.trim();
							stmt.setString(1, queryId);
							stmt.setString(2, studentId.trim());
							ResultSet rs1 = stmt.executeQuery();
							String studentAnswer = "";
							if (rs1.next())
								studentAnswer = rs1.getString("querystring");

							String remote = "QuestionDetails.jsp?AssignmentID="
									+ assignID + "&&courseId=" + courseID
									+ "&&questionId=" + qID + "&&studentId="
									+ studentId + "'\"target = \"rightPage\"";

							String viewGrade = "ViewGrades.jsp?AssignmentID="
									+ assignID + "&&courseId=" + courseID
									+ "&&questionId=" + qID + "&&studentId="
									+ studentId + "'\"target = \"rightPage\"";
							if (yes == false)
								output += "<tr><td>Question: "
										+ qID
										+ "</td>"
										+ "<td>"
										+ desc
										+ "</td>"
										+ "<td>"
										+ CommonFunctions.encodeHTML(studentAnswer)
										+ "</td>"
										+ "<td><input type=\"button\" onClick=\"window.location.href='"
										+ remote + " value=\"Edit\" > <br/> \n ";
							else
								output += "<tr><td>Question: "
										+ qID
										+ "</td>"
										+ "<td>"
										+ desc
										+ "</td>"
										+ "<td>"
										+ CommonFunctions.encodeHTML(studentAnswer)
										+ "</td>"
										+ "<td><input type=\"button\" onClick=\"window.location.href='"
										+ viewGrade
										+ " value=\"View Grade\" > <br/> \n ";

							/* 	
							output += "<p><a href=\"QuestionDetails.jsp?AssignmentID="
										+ assignID
										+ "&&courseId="
										+ courseID
										+ "&&questionId="
										+ qID
										+ "&&studentId="
										+ studentId
										+ "\" target = \"rightPageBottom\"><span > Question "
										+ qID + " </span> "; */
							rs1.close();

						}
						rs.close();
						output += "</table>";
						
						if(status != null){
							if(status.equals("NoDataset")){
								
							}
							else if(status.equals("Correct")){
								output += "<p>Passed basic test cases</p>";
							}
							else if(status.equals("Incorrect")){
								output += "<p>Test case failed. Check again.</p>";
							}
							else if(status.equals("expired")){
								output += "<p>Submission not saved. Assignment expired.</p>";
							}
						}
						
						out.println(output);

					} catch (Exception err) {
						err.printStackTrace();
						out.println("Error in retriveing query details");
					}
					finally{
						dbcon.close();
					}
				%>
			</fieldset>
		</div>
	</div>
</body>
</html>