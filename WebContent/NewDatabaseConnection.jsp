<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Create New Database Connection</title>
<style>

/*Defaults Styling*/




select {
	font: 12px/12px Arial, Helvetica, sans-serif;
	padding: 0;
	display: inline-block;
	float: left;
	text-align: left;
	margin-bottom: 11px;
}

input {
	font: 15px/15px Arial, Helvetica, sans-serif;
	padding: 0;
	display: inline-block;
	float: left;
	clear: both;
	text-align: left;
	margin-bottom: 11px;
}

fieldset.action {
	background: #9da2a6;
	border-color: #e5e5e5 #797c80 #797c80 #e5e5e5;
	margin-top: -20px;
}


label {
	font: 18px/18px Arial, Helvetica, sans-serif;
	font-weight: bold;
	color: #666;
	display: inline-block;
	float: left;
	clear: both;
	text-align: left;
	margin-bottom: 11px;
}

label.opt {
	font-weight: normal;
}

dl {
	clear: both;
}

dt {
	float: left;
	text-align: right;
	width: 90px;
	line-height: 25px;
	margin: 0 10px 10px 0;
}

dd {
	float: left;
	width: 475px;
	line-height: 25px;
	margin: 0 0 10px 0;
}

#footer {
	font-size: 11px;
}

#container {
	background: #ccc;
	width: 80%;
	margin: 0 auto;
	border: none;
}

label span,.required {
	color: red;
	font-weight: bold;
	font-size: 17px;
	margin-bottom: 11px;
}

.required {
	text-align: left;
}

.databaseForm {
	margin: 0 auto;
	align: center;
}
</style>
</head>
<body>

	<div>
		<form class="databaseForm" name="databaseForm"
			action="UpdateDatabaseConnection.jsp" method="post"
			style="border: none">
			<p class="required">* Required</p>

			<div class="fieldset">
				<fieldset>
					<legend> Create a New Database Connection</legend>
					<label><span>*</span><strong>Database Connection Name</strong></label>
					<textarea style="width: 400px; height: 20px;"
						placeholder="Specify database connection name"
						name="dbConnectName" required></textarea>


					<label><span>*</span><strong>Database Type</strong></label> <select
						name="databaseType" style="clear: both;" required>
						<option value="01">PostgreSqll(default)</option>
						<option value="02">MySql</option>
						<option value="03">Oracle</option>


					</select>




			<%-- 		<%
						//get database properties
						DatabaseProperties dbp = new DatabaseProperties();
						String username = dbp.getUser1Name();
						String username2 = dbp.getUser2Name();
						String passwd = dbp.getPassword1();
						String passwd2 = dbp.getPassword2();
						String hostname = dbp.getHostName();
						String dbName = dbp.getDbName();

						//get the connection for testing1
						Connection dbcon = (new DatabseConnection()).dbConnection(hostname,
								dbName, username, passwd);

						try {

							PreparedStatement stmt;
							stmt = dbcon
									.prepareStatement("SELECT schema_id,schema_name FROM schemainfo WHERE course_id = ?");
							stmt.setString(1, "CS-101");/**FIXME: Change this*/

							String output = "";
						   ResultSet rs = stmt.executeQuery();
							while (rs.next()) {
								output += " <option value = \"" + rs.getInt("schema_id")
										+ "\"> " + rs.getInt("schema_id") + "-"
										+ rs.getString("schema_name") + " </option> ";
							} 

							//output += " <option value = \"1\" required> 1-Test Schema</option> ";
							
							out.println("<label><span>*</span><strong>Database Schema</strong></label>  <select name=\"schemaid\" style=\"clear:both;\"> "
									+ output + "</select> ");
						} catch (Exception err) {

							err.printStackTrace();
							out.println("ERROR OCCURRED");
						}
					%> --%>

					<label><span>*</span><strong>JDBC URL</strong></label>
					<textarea style="width: 400px; height: 20px;"
						placeholder="Specify JDBC Url" name="jdbcurl"></textarea>


					<label><span>*</span><strong>Database User Name</strong></label>
					<textarea style="width: 400px; height: 20px;"
						placeholder="Specify database user name" name="dbuserName"></textarea>


					<label><span>*</span><strong>Database Password</strong></label> <input
						type="password" name="dbPassword" placeholder="Give Password">
			
			
			<input type="submit" value="Submit" align="middle">
			</div>
		</form>

	</div>
</body>
</html>