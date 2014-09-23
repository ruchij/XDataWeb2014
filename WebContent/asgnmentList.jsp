<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Assignment List</title>
<script type="text/javascript" src="scripts/wufoo.js"></script>

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
					if (assignID == null)
						assignID = (String) request.getSession().getAttribute(
								"resource_link_id");
					String instructions = (new CommonFunctions())
							.getAssignmnetIinstructions(courseID, assignID);
					
					out.println(instructions);
				%>
			</fieldset>

			<br/>

			<div>

				<div class="fieldset">

					<fieldset>
						<legend> Assignment Options</legend>
						<%

											//get connection
											Connection dbcon = (new DatabaseConnection()).graderConnection();
											String output = "";
											//int assignID;
											boolean start = false;

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

												ResultSet rs;
												rs = stmt.executeQuery();
												String endTime = "";
												boolean noASsign = false;
												if (rs.next()) {
													endTime = formatter.format(rs.getTimestamp("endtime"));
												} else {
													noASsign = true;
												}
												stmt.close();
												rs.close();
												
												if(!noASsign){
												
													//get current date
													Calendar c = Calendar.getInstance();
							
													String currentDate = formatter.format(c.getTime());
													java.util.Date current = formatter.parse(currentDate);
													//compare times
							
													java.util.Date oldDate = formatter.parse(endTime);
							
													//now check whether current time is more than end time.Then only assignment can be graded
													if (oldDate.compareTo(current) < 0) {
														start = true;
													}
							
												
							
													output += "<ul>"
															+ "<li><a href=\"EditAssignment.jsp?AssignmentID="
															+ assignID
															+ "\" target = \"rightPage\"><span > Edit Assignment </span>  </a></li>"
															+ "<li><a href=\"ListOfQuestions.jsp?AssignmentID="
															+ assignID
															+ "\" target = \"rightPage\"><span > View/Edit Questions </span> "
															+ "</a> </li> <li><a href=\"gradeAssignment.jsp?AssignmentID="
															+ assignID
															+ "\" target = \"rightPage\"><span >Grade Questions</span> </a> "
															+ "</a> </li> <li><a href=\"ViewResults.jsp?AssignmentID="
															+ assignID
															+ "\" target = \"rightPage\"><span >View Results</span> </a> </li>"
															+ "</ul>";
							
													start = false;
													
													out.println(output);
													//out.println("<input type=\"button\" id=\"home\" value=\"Home\" onClick=\"document.location.href='instructorOptions.html'\"><br>");
												}
												//out.println("hello");
												else {
													out.println(" <h3   >There are no assignments</h3>");
													//out.println("<input type=\"button\" id=\"home\" value=\"Home\" onClick=\"document.location.href='instructorOptions.html'\"><br>");
												}
												
											} catch (Exception err) {
												//out.println("<p style=\"font-family:arial;color:red;font-size:20px;background-color:white;\">"+err+" </p>");
												out.println("<p >Not updated properly </p>");
												err.printStackTrace();
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