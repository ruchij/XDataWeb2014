<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="database.DatabaseProperties"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Create New Database Connection</title>

<style>


.fieldset fieldset{
	padding-left: 30px;
	padding-top:30px;
}

.fieldset div span{
	float:left;
	width: 250px;
}

.fieldset div{
	margin-bottom: 20px;
}

.fieldset div input{
	width: 400px;
	height: 20px;
}

</style>

</head>
<body>

<%
	if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
		response.sendRedirect("index.html");
		return;
	}

%>

	<div>
		<form class="databaseForm" name="databaseForm"
			action="UpdateDatabaseConnection.jsp" method="post"
			style="border: none">

			<div class="fieldset">
				<fieldset>
					<legend> Create a New Database Connection</legend>
					<div>
						<span>Database Connection Name</span>
						<input placeholder="Specify database connection name"
							name="dbConnectName" required/>
					</div>
					
					<div>
					<span>Database Type</span> <select
						name="databaseType" style="clear: both;" required>
						<option value="01">PostgreSqll(default)</option>
						<option value="02">MySql</option>
						<option value="03">Oracle</option>
					</select>
					</div>
					
					<div>
					<span>JDBC URL</span>
					<input placeholder="Specify JDBC Url" name="jdbcurl"/>
					</div>
					
					<div>
					<span>Database User Name</span>
					<input placeholder="Specify database user name" name="dbuserName"/>
					</div>
					
					<div>
					<span>Database Password</span> <input
						type="password" name="dbPassword" placeholder="Give Password">
					</div>
			
			<input type="submit" value="Submit" align="middle">
			</div>
		</form>

	</div>
</body>
</html>