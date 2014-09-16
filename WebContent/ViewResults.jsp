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
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>
<style>



label {
	font-size: 16px;
	font-weight: bold;
	color: #666;
}
</style>
</head>
<body>
	<div>
		<br /> <br />
		<div class="fieldset">

			<fieldset>
				<legend> Details</legend>
				<%
					String courseId = (String) request.getSession().getAttribute(
							"context_label");
					String assignId = (String) request.getParameter("assignmentid");
					if (assignId == null)
						assignId = (String) request.getSession().getAttribute(
								"resource_link_id");

					String output = "<h2 style=\"color: #666; text-align:center;\">Number of students who got  wrong answers in assignment: "
							+ assignId + "</h2>";
					output += "<table border=\"1\"  align=\"center\" text-align=\"center\"> ";
					output += "<tr>" + "<th><label> Question Number</label></th>"
							+ "<th><label> Question Description</label></th>"
							+ "<th><label> Correct Answer</label></th>"
							+ "<th><label> Number of Incorrect Answers</label></th>"
							+ "</tr>";

					//get database properties
					DatabaseProperties dbp = new DatabaseProperties();
					String username = dbp.getUsername1(); //change user name according to your db user -testing1
					String username2 = dbp.getUsername2();//This is for testing2
					String passwd = dbp.getPasswd1(); //change user passwd according to your db user passwd
					String passwd2 = dbp.getPasswd2();
					String hostname = dbp.getHostname();
					String dbName = dbp.getDbName();
					String port = dbp.getPortNumber();
					Connection dbcon = (new DatabseConnection()).dbConnection(hostname,
							dbName, username, passwd, port);

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
						output += "<tr> <td> Question " + qID + "</td><td> " + desc
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