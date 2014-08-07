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
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Grade Assignment</title>
<style>
html,body {
	margin: 0;
	width: 100%;
	height: 100%;
}

li {
	text-align: left
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
	/* 	width: 90%;
	height: 100%; */
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

td {
	text-align: center;
	vertical-align: middle;
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

<div>
	<br /> <br />
	<div class="fieldset">
		<fieldset>
			<legend> Assignment Instructions</legend>


			<%
				//int assignID=Integer.parseInt(request.getParameter("AssignmentID").trim());
				String courseID = (String) request.getSession().getAttribute(
						"context_label");
				String assignID = (String) request.getSession().getAttribute(
						"resource_link_id");
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

				String instructions = (new CommonFunctions()).getAssignmnetIinstructions(courseID, assignID);
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
							.prepareStatement("SELECT * FROM  qinfo  where assignmentid=? and courseid = ?");
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
						//output+="<td> <a href=\"AssignmentChecker?assignment_id="+assignID+"&question_id="+qID+"&query="+correct+" \" > <span style=\"color:blue;font-size:20px\">Generate Dataset</span> </a></td> "+"\n";
						/* 	output += "<td> &nbsp;<input type=\"button\" id=\"button "
									+ qID
									+ "\" value=\"Generate Dataset\"  onclick=\"submitter(this,'queryTable')\"> </td>"
									+ "\n"; */
						String generate = "AssignmentChecker?assignment_id="
								+ assignID + "&&question_id=" + qID + "&&query="
								+ correct + "'\"target = \"rightPageBottom\"";
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

						/* //evaluate
						output += "<td> &nbsp; <a href=\"EvaluateQuestion?assignment_id="
								+ assignID
								+ "&question_id="
								+ qID
								+ "\" > <span>Evaluate</span> </a> </td></tr>"
								+ "\n"; */
						//output+="<td> <input type=\"button\" id=\"button "+qID+"\" value=\"Evaluate\" onclick=\"submitter(this,'queryTable')\"> </td></tr>"+"\n";
					}
					
					rs.close();
					output += "</table>";
				} catch (Exception err) {
					err.printStackTrace();
				}
				finally{
					dbcon.close();
				}
				out.println(instructions);
			%>
		</fieldset>
		<fieldset>
			<legend> List of Questions</legend>
			<form class="wufoo" name="Form" action="evaluateAssignment.jsp"
				method="post">
				<%
					out.println(output);
					out.println("<p></p>");
					out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
							+ "<input  type=\"submit\" name=\"submission\" value=\"Evaluate Assignment\"><br>");
				%>
			</form>
		</fieldset>
	</div>
</div>
</body>
</html>