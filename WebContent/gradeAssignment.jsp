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
<title>Grade Assignment</title>
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

td {
	text-align: center;
	vertical-align: middle;
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

.separator{
	border-right:1px solid black; 
	margin:0px; 
	float: right; 
	margin-right: 3px;
	width:1px;
	margin-left: 2px;
}

</style>
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
			
					String courseID = (String) request.getSession().getAttribute(
						"context_label");
					String assignID = (String) request.getSession().getAttribute(
						"resource_link_id");
					String instructions = (new CommonFunctions())
							.getAssignmnetIinstructions(courseID, assignID);
					
					out.println(instructions);
				%>
		</fieldset>
		<fieldset>
			<legend> List of Questions</legend>
			<form class="wufoo" name="Form" action="evaluateAssignment.jsp"	method="post">
				<%
					//int assignID=Integer.parseInt(request.getParameter("AssignmentID").trim());

							
							//get connection
							Connection dbcon = (new DatabaseConnection()).graderConnection();
							Timestamp start = null;
							Timestamp end = null;
				%>
				<%
					String output = "<table cellspacing=\"20\"  class=\"authors-list\" id=\"queryTable\" align=\"center\">  <tr> <th >Query ID</th> <th >Question Description</th>  <th >Correct Query</th> <th> </th><th> </th></tr>"
							+ "\n";
					String qID = "";
					String text = "";
					String correct = "";
					//execute queryinfo table to get qIDs
					try {
						PreparedStatement stmt;
						stmt = dbcon
								.prepareStatement("SELECT * FROM  qinfo  where assignmentid=? and courseid = ? order by questionid");
						stmt.setString(1, assignID);
						stmt.setString(2, courseID);
						ResultSet rs;
						rs = stmt.executeQuery();
						while (rs.next()) {
							qID = rs.getString("questionid");
							text = rs.getString("querytext");
							correct = rs.getString("correctquery");
							output += "<tr> <td> <p name=\"qID\" id=\"qID" + qID
									+ "\">Question: " + qID + "</p></td> "
									+ "<td> <p name=\"quesTxt\">" + text
									+ " </p> </td> <td><p name=\"query\" id=\"query"
									+ qID + "\" p>" + correct + " </p></td>";
			
							String generate = "AssignmentChecker?assignment_id="
									+ assignID + "&&question_id=" + qID + "&&query="
									+ CommonFunctions.encodeHTML(correct) + "'\"target = \"rightPageBottom\"";
							String evaluate = "EvaluateQuestion?assignment_id="
									+ assignID + "&&question_id=" + qID
									+ "'\"target = \"rightPageBottom\"";
							String status = "QueryStatus?assignment_id=" + assignID
									+ "&&question_id=" + qID
									+ "'\"target = \"rightPageBottom\"";

							output += "<td><input type=\"button\" onClick=\"window.location.href='"
									+ generate
									+ " value=\"Generate Dataset\" > <br/> \n "

									+ "<input type=\"button\" onClick=\"window.location.href='"
									+ evaluate
									+ " value=\"Evaluate Question\" > <br/> \n "
									//+"Show status of data generation and status of question evaluation, depending on this enable buttons<br/>if already generated ask to kill it or not"
									+ "<input type=\"button\" onClick=\"window.location.href='"
									+ status
									+ " value=\"Status Of Question\" > <br/> \n "
									+ "</td>";
						
							%>
							
							<div class="questionelement">
								<div class="question"><span>Q<%= qID %>. </span><%= text %></div>
								<div class="answer"><span>Ans. </span><%= CommonFunctions.encodeHTML(correct) %></div>
								<div class="editbutton">
									<a href=' <%=generate %>'><%="Generate Dataset" %></a>
									<span class = "separator">&nbsp;</span>
									<a href=' <%=evaluate %>'><%="Evaluate Question" %></a>
									<span class = "separator">&nbsp;</span>
									<a href='<%=status %>'><%="Status of Question" %></a>
								</div>								
							</div>
							<%
									
						}
						
						rs.close();
						output = "";
					} catch (Exception err) {
						err.printStackTrace();
					}
					finally{
						dbcon.close();
					}
					
					out.println("<p></p>");
					out.println("<input  type=\"submit\" name=\"submission\" value=\"Evaluate Assignment\"><br>");
				%>
			</form>
		</fieldset>
	</div>
</div>
</body>
</html>