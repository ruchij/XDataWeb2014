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
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
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

a:link {
	color: #E96D63;
	font: 15px/15px Arial, Helvetica, sans-serif;
}
/* unvisited link */
a:hover {
	color: #7FCA9F;
	font: 15px/15px Arial, Helvetica, sans-serif;
} /* mouse over link */
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
					String port = dbp.getPortNumber();

					//get connection
					Connection dbcon = (new DatabseConnection()).dbConnection(hostname,
							dbName, username, passwd, port);
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