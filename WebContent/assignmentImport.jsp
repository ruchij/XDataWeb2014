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
<script type="text/javascript" src="scripts/ManageQuery.js"></script>

</head>
<body>

	<div>
		<br /> <br />
		<div class="fieldset">



			<fieldset>
				<legend> Assignment Details</legend>
				<%
					String assignID = (String) request.getParameter("assignment_id");
					String courseID = (String) request.getParameter("course_id");
					String instructions = (new CommonFunctions()).getAssignmentDetails(courseID, assignID);
					
					out.println(instructions);
				%>
			</fieldset>

			<fieldset>
				<legend> List of Questions</legend>

				<%
					//out.println("Hi"+asgnmentID);
					//get database properties
					DatabaseProperties dbp = new DatabaseProperties();
					String username = dbp.getUser1Name(); //change user name according to your db user -testing1
					String username2 = dbp.getUser2Name();//This is for testing2
					String passwd = dbp.getPassword1(); //change user passwd according to your db user passwd
					String passwd2 = dbp.getPassword2();
					String hostname = dbp.getHostName();
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
								.prepareStatement("SELECT * FROM  assignment where assignment_id=? and course_id=?");
						stmt.setInt(1, Integer.valueOf(assignID));
						stmt.setString(2, courseID);
						rs = stmt.executeQuery();
						if (rs.next()) {
							start = rs.getTimestamp("start_time");
							end = rs.getTimestamp("end_time");
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
					if (current.compareTo(oldDate) < 0) {
						yes = true;
					}

					String output = "<table  cellspacing=\"20\"  class=\"authors-list\" id=\"queryTable\" align=\"center\"> <tr> <th >Question ID</th>       <th >Question Description</th>  <th >Correct Query</th> <th> </th></tr>";
					try {
						PreparedStatement stmt;
						//stmt = dbcon.prepareStatement("SELECT * FROM  qinfo ,assignment where qinfo.assignment_id=? AND qinfo.assignment_id=assignment.assignment_id");
						stmt = dbcon
								.prepareStatement("SELECT * FROM  queries  where assignment_id=? and course_id=? order by question_id;");
						stmt.setInt(1, Integer.valueOf(assignID));
						stmt.setString(2, courseID);
						ResultSet rs = stmt.executeQuery();
						String prevqID=null;
						
						
						while (rs.next()) {

							String qID = rs.getString("question_id");
							String desc = rs.getString("query_desc");
							String correctQuery = rs.getString("correct_query");
							System.out.println(qID + ": " + correctQuery);

							
							if(!qID.equals(prevqID)) {
								output += "</tr><tr class=\""
									+ qID
									+ "\"><td>Question: "
									+ qID
									+ "</td>"
									+ "<td>"
									+ desc
									+ "</td>"
									+ "<td>";
							}
							else
								output += "</tr><tr><td></td><td></td><td>";
								
							output += correctQuery
									+ "</td>";
									
							prevqID = qID;
						}
					} catch (Exception err) {
						err.printStackTrace();
						out.println("Error in retriveing query details");
					}

					output += "</table>";
					output += "<input type=\"button\" onClick=\"window.location.href='importEditAssignment.jsp?assignment_id="+assignID+"&&course_id="+courseID+"'\"target = \"rightPage\" value=\"Import This Assignment\" > <br/> \n ";
					out.println(output);
				%>
			</fieldset>
		</div>
	</div>
</body>
</html>