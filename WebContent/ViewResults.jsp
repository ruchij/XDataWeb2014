<%@page import="java.sql.PreparedStatement"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Get Results Of Assignment</title>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="database.DatabaseProperties"%>
<style>

</style>
</head>
<body>
	<div>
		<br /> <br />
		<div class="fieldset">
			<%
				if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
					response.sendRedirect("index.html");
					return;
				}
				
				String courseId = (String) request.getSession().getAttribute(
						"context_label");
				String assignId = (String) request.getParameter("assignmentid");
				if (assignId == null)
					assignId = (String) request.getSession().getAttribute(
							"resource_link_id");
			%>
			<fieldset>
				<legend> Details of Assignment <%=assignId%>
				</legend>
				<%
					String output = "";
							output += "<table align=\"center\" text-align=\"center\"> ";
							output += "<tr style='background: #E4E4E4; text-align: center;font-weight: bold;'>" 
									+ "<th><label>Question</label></th>"
									+ "<th><label>Question Description</label></th>"
									+ "<th><label>Correct Answer</label></th>"
									+ "<th><label>Incorrect Answers</label></th>"
									+ "</tr>";

							Connection dbcon = (new DatabaseConnection()).graderConnection();

							//get list of questions in assignment
							String questions = "select * from qinfo where courseid = ? and assignmentid = ? order by assignmentid,questionid";
							PreparedStatement stmt = dbcon.prepareStatement(questions);
							stmt.setString(1, courseId);
							stmt.setString(2, assignId);

							ResultSet rs = stmt.executeQuery();
							while (rs.next()) {

								String qID = rs.getString("questionid");
								String correct = rs.getString("correctquery");
								String desc = rs.getString("querytext");

								String getCount = "select count(distinct rollnum) as count from queries where queryid = ? and tajudgement = 'f'";
								stmt = dbcon.prepareStatement(getCount);

								String queryid = "A" + assignId.trim() + "Q" + qID;
								stmt.setString(1, queryid);

								ResultSet rs1 = stmt.executeQuery();
								int count = 0;
								if (rs1.next())
									count = Integer.parseInt(rs1.getString("count"));
								output += "<tr> <td>" + qID + "</td><td> " + desc
										+ "</td><td>  " + correct + " </td><td> " + count
										+ "</td>" + "</tr>";
							}
							
							rs.close();
							out.println(output);
							dbcon.close();
				%>
			</fieldset>
		</div>
	</div>
</body>
</html>