<%@page import="database.CommonFunctions"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="../css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Assignment List</title>

<link rel="canonical"
	href="http://www.wufoo.com/gallery/designs/template.html">
<style>

li {
	text-align: left
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
 /* mouse over link */
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
				<%
				String courseID = (String) request.getSession().getAttribute(
						"context_label");
				String assignID = (String) request.getParameter("assignmentid");
				
				if (assignID == null){
					assignID = (String) request.getSession().getAttribute(
							"resource_link_id");
				}
				
				String instructions = (new CommonFunctions()).getAssignmnetIinstructions(courseID, assignID);
					
				out.println(instructions);
				%>
			</fieldset>
			
			<br/>

			<div>

				<div class="fieldset">

					<fieldset>
						<legend> Assignment Details</legend>
						<%
							
							String studentId = (String) request.getParameter("studentId");
							if (studentId == null)
								studentId = (String) request.getSession().getAttribute("user_id");

							//get database properties
							DatabaseProperties dbp = new DatabaseProperties();
							String username = dbp.getUsername1(); //change user name according to your db user -testing1
							String username2 = dbp.getUsername2();//This is for testing2
							String passwd = dbp.getPasswd1(); //change user passwd according to your db user passwd
							String passwd2 = dbp.getPasswd2();
							String hostname = dbp.getHostname();
							String dbName = dbp.getDbName();
							String port = dbp.getPortNumber();
							
							//get connection
							Connection dbcon = (new DatabseConnection()).dbConnection(hostname,
									dbName, username, passwd, port);
							String output = "";
							//int assignID;
							boolean start = true;

							ArrayList<String> listOfIDs = new ArrayList<String>();
							ArrayList<String> endTimes = new ArrayList<String>();

							SimpleDateFormat formatter = new SimpleDateFormat(
									"yyyy-MM-dd HH:mm:ss");
							formatter.setLenient(false);
							//String starting=formatter.format(start);

							try {
								PreparedStatement stmt;
								stmt = dbcon
										.prepareStatement("SELECT * FROM  assignment where assignmentid = ? and courseid = ?");
								stmt.setString(1, assignID);
								stmt.setString(2, courseID);
								
								System.out.println("DEBUG" + stmt);

								ResultSet rs;
								rs = stmt.executeQuery();
								String endTime = "";
								String startTime = "";
								
								boolean noASsign = false;
								if (rs.next()) {
									endTime = formatter.format(rs.getTimestamp("endtime"));
									startTime = formatter.format(rs.getTimestamp("starttime"));
								} else {
									noASsign = true;
								}
								
								if(!noASsign){
								
									//get current date
									Calendar c = Calendar.getInstance();
	
									String currentDate = formatter.format(c.getTime());
									java.util.Date current = formatter.parse(currentDate);
									//compare times
	
									java.util.Date oldDate = formatter.parse(endTime);
									
									java.util.Date startDate = formatter.parse(startTime);
	
									if (oldDate.compareTo(current) < 0 || current.compareTo(startDate) < 0) {
										start = false;
									}
	
									if (start) {
	
										output += "<p><a target = \"rightPage\" href=\"ListOfQuestions.jsp?AssignmentID="
												+ assignID
												+ "&&studentId="
												+ studentId
												+ "\" ><span > View and Update</span> " + " </p>";
										/* 	output += "<p><a target = \"rightPageBottom\" href=\"ListOfQuestions.jsp?AssignmentID="
													+ assignID
													+ "\" ><span > Solve</span> "
													+" </p>"; */
									} else {
										CommonFunctions util = new CommonFunctions();
										
											if(oldDate.compareTo(current) < 0){
											
											String dueTime = util.timeDifference(current, oldDate);
											output += "<p><label> Assignment is over due by " + dueTime
													+ "</label></p>";
		
											/* output += "<p><a href=\"ListOfQuestions.jsp?AssignmentID="
													+ assignID
													+ "&&studentId="
													+ (String) request.getParameter("studentId")
													+ "\" target = \"rightPage\"><span > View Grades</span> </p>"; */
													output += "<p><a href=\"/xdata/ViewAssignment?assignmentid="
															+ assignID.trim()
															+"V"
															+ "\" target = \"rightPage\"><span > View Grades</span> </p>";
															
															/* <input type=\"submit\" name="+rst.getString("assignmentid")+"V Value=\"Result\" /> */
											}
											
											else if(current.compareTo(startDate) < 0){
												String dueTime = util.timeDifference(startDate, current);
												output += "<p><label> Assignment will be active in " + dueTime
														+ "</label></p>";
											}
										}
									start = false;
									
									out.println(output);
									//out.println("<input type=\"button\" id=\"home\" value=\"Home\" onClick=\"document.location.href='instructorOptions.html'\"><br>");
								}
								//out.println("hello");
								else {
									out.println(" <h3   >There are no assignments</h3>");
									//out.println("<input type=\"button\" id=\"home\" value=\"Home\" onClick=\"document.location.href='instructorOptions.html'\"><br>");
								} 
								
								rs.close();
							} catch (Exception err) {
								//out.println("<p style=\"font-family:arial;color:red;font-size:20px;background-color:white;\">"+err+" </p>");
								out.println("<p >Not updated properly </p>");
								err.printStackTrace();
							}
						
							dbcon.close();
						%>
					</fieldset>
				</div>
			</div>
</body>

</html>