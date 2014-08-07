<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@page import="database.*"%>

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
	width: 90%;
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

<script type="text/javascript" src="scripts/ManageQuery.js"></script>
<!-- <script>
	function report(btn, selected) {

		var qid = btn.name.split(" ")[1];
		var asID = btn.name.split(" ")[2];
		var quer = "query".concat(qid);
		var que = document.getElementById(quer).value;
		var desc = document.getElementById("quesTxt".concat(qid)).value;
		if (selected == "1") {
			var out = "UpdateSingleQuery.jsp?assignment_id=" + asID
					+ "&question_id=" + qid + "&query=" + que + "&desc=" + desc;
			window.location.href = out;
		} else if (selected == "2") {
			var out = "AssignmentChecker?assignment_id=" + asID
					+ "&question_id=" + qid + "&query=" + que;
			window.open(out, "Generating Dataset", "height=400,width=400 ");
		} else if (selected == 3) {
			var out = "ListOfQuestions.jsp?AssignmentID=" + asID;
			window.location.href = out;
		}

	}
</script> -->
</head>
<body>

	<div>
		<br /> <br />
		<div class="fieldset">
			<fieldset>
				<legend> Assignment Details and Instructions</legend>
				<%
					String assignID = (String) request.getParameter("AssignmentID");
					String courseID = (String) request.getSession().getAttribute(
							"context_label");
					String instructions = (new CommonFunctions())
							.getAssignmnetIinstructions(courseID, assignID);
					
					out.println(instructions);
				%>
			</fieldset>
			<fieldset>
				<legend> Question Details</legend>

				<%
					
					String questionID = (String) request.getParameter("questionId");
					
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
							+ questionID
							+ " "
							+ assignID
							+ "\" "
							+ " onClick=\"report(this,3)\""
							+ " value=\"List Of Questions\" style=\"float:right;\"><br/>\n";

					output += listButton
							+ "<table  cellspacing=\"10\"  class=\"authors-list\" id=\"queryTable\" align=\"center\"> \n <tr> <th >Question ID</th>       <th >Question Text</th>  <th >Correct Query</th> <th> </th></tr>"
							+ "\n";
					//get query details
					try {
						PreparedStatement stmt;
						//stmt = dbcon.prepareStatement("SELECT * FROM  qinfo ,assignment where qinfo.assignment_id=? AND qinfo.assignment_id=assignment.assignment_id");
						stmt = dbcon
								.prepareStatement("SELECT * FROM  qinfo  where assignmentid=? and courseid=? and questionid=?");
						stmt.setString(
								1,
								((String) request.getSession().getAttribute(
										"resource_link_id")).trim());
						stmt.setString(
								2,
								((String) request.getSession().getAttribute(
										"context_label")).trim());
						stmt.setString(3, (String) request.getParameter("questionId"));
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
						
						String correctQueryID = "1";
						
						while (rs.next()) {
							String query = rs.getString("correctquery");
							String description = rs.getString("querytext");
							output += "<tr class=\" "+qID+"\"> \n <td> <p align=\"center\" name=\"qID\" id=\"qID"
									+ qID + "\" >" + qID + "</p> </td> \n";
							output += "<td> <textarea name=\"quesTxt\"  id=\"quesTxt"
									+ qID + "\" rows=\"6\" cols=\"35\" >" + description
									+ " </textarea> </td> \n";
							output += " <td><textarea name=\"query\" id=\"query " + qID +" " + correctQueryID
									+ "\"rows=\"6\" cols=\"35\">" + query
									+ " </textarea></td> \n";

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

							String update = "UpdateSingleQuery.jsp?assignment_id="
									+ assignID + "&&question_id=" + qID
									+ "'\"target = \"rightPageBottom\"";

							String generate = "AssignmentChecker?assignment_id="
									+ assignID + "&&question_id=" + qID + "&&query="
									+ query + "'\"target = \"rightPageBottom\"";

							String id = "<input type=\"button\" name=\"button " + qID
									+ " " + assignID + "\" ";

							String options = "<a href=\"" + update
									+ "\"> Update Query<a><br/>\n" + "<a href=\""
									+ generate + "\"> Generate Dataset<a><br/>\n";

							String buttons = id + " onClick=\"report(this,1)\""
									+ " value=\"Update Query\" ><br/>\n" + id
									+ "<onClick=\"report(this,1)\""
									+ " value=\"Generate Dataset\" >";

							output += "<td>" + buttons + "</td>\n</tr>\n";
							/* 	output += "<td>  <select onClick=\"report(this)\" name=\"button\" id=\"button "
										+ qID
										+ " "
										+ assignID
										+ "\"required>"
										+ "<option value=\"0\"> Select Option</option>"
										+ "<option value=\"1\"> Update Query</option>"
										+ "<option value=\"2\"> Generate DataSet</option>"
										+ "<option value=\"3\"> List Question</option>"
										+ "</td>"; */

						}
						
						rs.close();
					}

					catch (Exception err) {
						err.printStackTrace();
						out.println("Error in retrieving question details");
					}
					finally{
						dbcon.close();
					}
					output += "</table>";
					out.println(output);
				%>
			</fieldset>
		</div>
	</div>

</body>
</html>