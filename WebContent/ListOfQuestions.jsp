<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@page import="database.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>List Of Questions</title>
<style>

.separator{
	border-right:1px solid black; 
	margin:0px; 
	float: right; 
	margin-right: 3px;
	width:1px;
	margin-left: 2px;
}

</style>
<script type="text/javascript" src="scripts/ManageQuery.js"></script>

</head>
<body>

	<div>
		<br /> <br />
		<div class="fieldset">



			<fieldset>
				<legend> Assignment Instructions</legend>
				<%
				
					if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
						response.sendRedirect("index.html");
						return;
					}
					
					String assignID = (String) request.getParameter("AssignmentID");
					String courseID = (String) request.getSession().getAttribute(
							"context_label");
					String instructions = (new CommonFunctions())
							.getAssignmnetIinstructions(courseID, assignID);
					
					out.println(instructions);
				%>
			</fieldset>
			<br/>
			<fieldset>
				<legend> List of Questions</legend>

				<%
							//get connection
							Connection dbcon = (new DatabaseConnection()).graderConnection();

							Timestamp start = null;
							Timestamp end = null;
							try {
								PreparedStatement stmt;
								ResultSet rs = null;
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
							
							Calendar c = Calendar.getInstance();

							String currentDate = formatter.format(c.getTime());
							java.util.Date current = formatter.parse(currentDate);
							String output = "<table  cellspacing=\"20\"  class=\"authors-list\" id=\"queryTable\" align=\"center\"> <tr> <th >Question ID</th>       <th >Question Description</th>  <th >Correct Query</th> <th> </th></tr>";
							try {
								PreparedStatement stmt;
								stmt = dbcon
										.prepareStatement("SELECT * FROM  qinfo  where assignmentid=? and courseid=? order by questionid");
								stmt.setString(1, assignID);
								stmt.setString(2, courseID);
								ResultSet rs = stmt.executeQuery();

								while (rs.next()) {

									String qID = rs.getString("questionid");
									String desc = rs.getString("querytext");
									String correctQuery = rs.getString("correctquery");
									System.out.println(qID + ": " + correctQuery);

									String remote = "QuestionDetails.jsp?AssignmentID="
											+ assignID + "&&courseId=" + courseID
											+ "&&questionId=" + qID
											+ "'\"target = \"rightPage\"";

									String generate = "AssignmentChecker?assignment_id="
											+ assignID + "&&question_id=" + qID + "&&query="
											+ CommonFunctions.encodeURIComponent(correctQuery) + "'\"target = \"rightPage\"";

									output += "<tr class=\""
											+ qID
											+ "\"><td>Question: "
											+ qID
											+ "</td>"
											+ "<td>"
											+ desc
											+ "</td>"
											+ "<td>"
											+ correctQuery
											+ "</td>"
											+ "<td><input type=\"button\" onClick=\"window.location.href='"
											+ remote
											+ " value=\"Edit\" > <br/> \n "
											+ "<input type=\"button\" onClick=\"window.location.href='"
											+ generate
											+ " value=\"Generate Dataset\" > <br/> \n "
											//+"DATA SET GENERATION STATUS, depending on this enable generate dataset button"
											+ "</td>" + "</tr>";
				%>
							
							<div class="questionelement">
								<div class="question"><span>Q<%= qID %>. </span><%= desc %></div>
								<div class="answer"><span>Ans. </span><%= CommonFunctions.encodeHTML(correctQuery) %></div>
								<div class="editbutton"><a href=' <%=remote %>'>
								<%="Edit" %></a>
								<span class = "separator">&nbsp;</span>
								<span></span>
								<a href=' <%=generate %>'><%="Generate Dataset" %></a></div>
								
							</div>
						<%

						}
						
						rs.close();
						output = "";
					} catch (Exception err) {
						err.printStackTrace();
						out.println("Error in retriveing query details");
					}
					finally{
						dbcon.close();
					}
					
					output += "<input  type=\"button\" id=\"quer\" onClick=\"addRow(" + assignID + ",'queryTable')\" value=\"Add Question\" align=\"right\">";
					out.println(output);
				%>
			</fieldset>
		</div>
	</div>
</body>
</html>