<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Details of the Question</title>

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

<script type="text/javascript" src="scripts/ManageQuery.js"></script>
<script>
	function report(btn, selected) {

		var sid = btn.name.split(" ")[1];
		var asID = btn.name.split(" ")[2];
		var qid = btn.name.split(" ")[3];
		var quer = "query".concat(qid);
		var que = document.getElementById(quer).value;
		if (selected == "1") {
			var out = "UpdateSingleQuery.jsp?assignmentId=" + encodeURIComponent(asID)
					+ "&questionId=" + encodeURIComponent(qid) + "&query=" + encodeURIComponent(que) + "&studentId="
					+ encodeURIComponent(sid);
			window.location.href = out;
		} else if (selected == 2) {
			alert("To be done support for grading");
		} else if (selected == 3) {
			var out = "ListOfQuestions.jsp?AssignmentID=" + encodeURIComponent(asID)
					+ "&&studentId=" + encodeURIComponent(sid);
			window.location.href = out;
		}

	}
</script>
</head>
<body>

	<div>
		<br /> <br />
		<div class="fieldset">
			<fieldset>
				<legend> Assignment Instructions</legend>
				<ul>
					<li>Click submit after entering the answer</li>
				</ul>
				<p></p>
				<p></p>
			</fieldset>
			<fieldset>
				<legend> Question Details</legend>

				<%
					String assignID = (String) request.getParameter("AssignmentID")
							.trim();
					String questionID = (String) request.getParameter("questionId")
							.trim();
					String courseID = (String) request.getParameter("courseId").trim();
					String studentId = (String) request.getParameter("studentId")
							.trim();
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

					String output = "";

					String listButton = "<input type=\"button\" name=\"button "
							+ studentId
							+ " "
							+ assignID
							+ " "
							+ questionID
							+ "\" "
							+ " onClick=\"report(this,3)\""
							+ " value=\"List Of Questions\" style=\"float:right;\"><br/>\n";

					output += listButton
							+ "<table  cellspacing=\"10\"  class=\"authors-list\" id=\"queryTable\" align=\"center\"> <tr> <th >Question ID</th>       <th >Question Text</th>  <th >Correct Query</th> <th> </th></tr>";
					//get query details
					try {
						PreparedStatement stmt;
						//stmt = dbcon.prepareStatement("SELECT * FROM  qinfo ,assignment where qinfo.assignment_id=? AND qinfo.assignment_id=assignment.assignment_id");
						stmt = dbcon
								.prepareStatement("SELECT * FROM  qinfo  where qinfo.assignmentid=? and qinfo.courseid=? and qinfo.questionid=?");
						stmt.setString(
								1,
								(String) request.getSession().getAttribute(
										"resource_link_id"));
						stmt.setString(
								2,
								(String) request.getSession().getAttribute(
										"context_label"));
						stmt.setString(3, (String) request.getParameter("questionId")
								.trim());
						System.out.println("QId :"
								+ (String) request.getParameter("questionId"));
						System.out.println("Course Id: "
								+ (String) request.getSession().getAttribute(
										"context_label"));
						System.out.println("AssId :"
								+ (String) request.getSession().getAttribute(
										"resource_link_id"));

						ResultSet rs = stmt.executeQuery();
						String qID = (String) request.getParameter("questionId");
						while (rs.next()) {

							String description = rs.getString("querytext");

							/**check if student can edit his assignment*/
							stmt = dbcon
									.prepareStatement("SELECT * FROM  assignment where assignmentid=? and courseid=?");
							stmt.setString(1, assignID.trim());
							stmt.setString(2, courseID.trim());
							ResultSet rs2 = stmt.executeQuery();
							Timestamp start = null, end = null;
							if (rs2.next()) {
								start = rs2.getTimestamp("starttime");
								end = rs2.getTimestamp("endtime");
							}

							boolean readOnly = false;
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
							if (oldDate.compareTo(current) < 0)
								readOnly = true;

							/**get student answers*/
							try {

								stmt = dbcon
										.prepareStatement("SELECT * FROM  queries  where queryid=? and rollnum=?");
								
								String queryId = "A"+assignID+"Q"+questionID.trim();
								
								stmt.setString(1, queryId);
								stmt.setString(2, studentId);
								ResultSet rs1 = stmt.executeQuery();
								String studentAnswer = "";
								if (rs1.next())
									studentAnswer = rs1.getString("querystring");

								/* 	output += "<tr> <td> <label><input type=\"number\" name=\"qID\" size=\"4\" id=\"qID"
											+ qID
											+ "\" value=\""
											+ qID
											+ "\" readonly></label> </td>"; */

								output += "<tr> \n <td> <p align=\"center\" name=\"qID\" id=\"qID"
										+ qID + "\" >" + qID + "</p> </td> \n";

								output += "<td> <label name=\"quesTxt\"  id=\"quesTxt"
										+ qID + "\" >" + description
										+ " </label> </td>";

								String id = "<input type=\"button\" name=\"button "
										+ studentId + " " + assignID + " " + qID
										+ "\" ";

								if (readOnly) {
									output += " <td><label name=\"query\" id=\"query"
											+ qID
											+ "\"rows=\"6\" cols=\"35\" readonly> "
											+ studentAnswer + "</textarea></td> ";
									/* 	output += "<td>  <select onClick=\"report(this)\" name=\"button\" id=\"button "
												+ studentId
												+ " "
												+ qID
												+ " "
												+ assignID
												+ "\"required>"
												+ "<option value=\"0\"> Select Option</option>"
												+ "<option value=\"2\"> List Questions</option>"
												+ "<option value=\"3\"> View Grades</option>"
												+ "</td>"; */

									String buttons = id + " onClick=\"report(this,2)\""
											+ " value=\"View Grades\" ><br/>\n";

									output += "<td>" + buttons + "</td>\n</tr>\n";
								} else {
									output += " <td><textarea name=\"query\" id=\"query"
											+ qID
											+ "\"rows=\"6\" cols=\"35\" > "
											+ studentAnswer + "</textarea></td> ";
									/* 	output = output
												.concat("<td> <input type=\"button\" id=\"button "
														+ qID +" "+assignID
														+ "\" value=\"Generate Dataset\" onclick=\"submitter(this,'queryTable')\"> </td></tr>"
														+ "\n");
									 */

									/* 	output += "<td>  <select onChange=\"window.location.href=this.value\" name=\"button\" id=\"button "+ qID +" "+assignID+ "\"required>" + 
											"<option value=\"Select\"> Select Option</option>"+
											"<option value=\"QuestionDetails.jsp?AssignmentID="+assignID + 
											"&&courseId="+ courseID+ "&&questionId="+ qID+ " \">Update Query</option>" +
											"<option value=\"submitter(this,'queryTable')\">Generate Dataset</option> "+
											"<td> "; */

									/* output += "<td>  <select onClick=\"report(this)\" name=\"button\" id=\"button "
											+ studentId
											+ " "
											+ qID
											+ " "
											+ assignID
											+ "\"required>"
											+ "<option value=\"0\"> Select Option</option>"
											+ "<option value=\"1\"> Update Query</option>"
											+ "<option value=\"2\"> List Questions</option>"
											+ "</td>"; */
									String buttons = id + " onClick=\"report(this,1)\""
											+ " value=\"Submit Answer\" ><br/>\n";
									output += "<td>" + buttons + "</td>\n</tr>\n";
								}
								rs1.close();
								
							} catch (Exception err) {
								err.printStackTrace();
								out.println("Error in retrieving question details");
							}
							rs2.close();
						}
						rs.close();
						output += "</table>";
						out.println(output);
					}

					catch (Exception err) {
						err.printStackTrace();
						out.println("Error in retrieving question details");
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