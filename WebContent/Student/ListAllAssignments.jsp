<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="database.DatabaseProperties"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="../css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

label
span,.required {
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
				<legend> List of Assignments</legend>
				<%
					String courseID = (String) request.getSession().getAttribute(
									"context_label");
							String user_id = (String) request.getSession().getAttribute(
									"user_id");
							
							//get connection
							Connection dbcon = (new DatabaseConnection()).graderConnection();
							String output = "<ul>";

							try {
								PreparedStatement stmt;
								stmt = dbcon
										.prepareStatement("SELECT * FROM  assignment where courseid = ?");
								//	stmt.setString(2, (String)request.getSession().getAttribute("context_label"));
								stmt.setString(1, courseID);
								ResultSet rs;
								rs = stmt.executeQuery();
								while (rs.next()) {

									output += "<a class=\"header\" target=\"rightPage\" href=\"asgnmentList.jsp?assignmentid="
											+ rs.getString("assignmentid")
											+ "&&studentId="
											+ user_id
											+ "\" ><li> Assignment "
											+ rs.getString("assignmentid") + "</li></a>";
								}
								rs.close();
								output += "</ul>";

								out.println(output);
							} catch (Exception err) {

								err.printStackTrace();
								out.println("Error in getting list of assignments");
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