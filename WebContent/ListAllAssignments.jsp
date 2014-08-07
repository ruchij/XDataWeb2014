<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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

label
span,.required {
	color: red;
	font-weight: bold;
	font-size: 17px;
}

a:link {
	color: #E96D63;
	font: 15px/15px Arial, Helvetica, sans-serif;
}
/* unvisited link */
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

</head>
<body>

	<div>

		<div class="fieldset">
		<br/>
		
			<fieldset>
				<legend> List of Assignments</legend>
				<%
					String courseID = (String) request.getSession().getAttribute("context_label");
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

							output += "<a class=\"header\" target=\"rightPage\" href=\"asgnmentList.jsp?assignmentid="+rs.getString("assignmentid")+"\" ><li> Assignment "
									+ rs.getString("assignmentid") + "</li></a>";
						}

						output += "</ul>";

						out.println(output);
						rs.close();
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