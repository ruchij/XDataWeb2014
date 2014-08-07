<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="scripts/wufoo.js"></script>
<link rel="stylesheet" href="css/structure.css" type="text/css" />
<link rel="stylesheet" href="css/form.css" type="text/css" />
<link rel="stylesheet" href="css/theme.css" type="text/css" />
<link rel="canonical"
	href="http://www.wufoo.com/gallery/designs/template.html">
<title>Upload Sample Data</title>
<style>
/*Defaults Styling*/
body {
	font: 12px/17px Arial, Helvetica, sans-serif;
	color: #333;
	background: #ccc;
	padding: 40px 20px 100% 20px;
	margin: 0;
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
	text-align: left;
	background: #bfbf30;
	color: #fff;
	font: 17px/21px Calibri, Arial, Helvetica, sans-serif;
	padding: 0 10px;
	margin: -26px 0 0 -11px;
	font-weight: bold;
	border: 1px solid #fff;
	border-color: #e5e5c3 #505014 #505014 #e5e5c3;
}

label {
	font-size: 15px;
	font-weight: bold;
	color: #666;
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
	width: 100%;
	margin: 0 auto;
}

label span,.required {
	color: red;
	font-weight: bold;
	text-align: left;
	font-size: 17px;
}

.stop-scrolling {
	height: 100%;
	overflow: hidden;
}
</style>
<script>
	function checkValue1() {

		if (document.getElementById("upload").value != "") {
			return true;
		} else {
			alert("Please upload file");
			return false;
		}

	}

	function trim(str, chars) {
		return ltrim(rtrim(str, chars), chars);
	}

	function ltrim(str, chars) {
		chars = chars || "\\s";
		return str.replace(new RegExp("^[" + chars + "]+", "g"), "");
	}

	function rtrim(str, chars) {
		chars = chars || "\\s";
		return str.replace(new RegExp("[" + chars + "]+$", "g"), "");
	}
</script>

</head>
<body>


	<div>


		<form class="wufoo" name="dataForm" enctype="multipart/form-data"
			action="dataUpload.jsp" method="post">

			<p class="required">* Required</p>

			<div class="fieldset">
				<fieldset>
					<legend> Upload Data File</legend>

					<p>
						<label class="field">Upload the SQL script containing the
							initial data </label>
					</p>
					<p></p>

					<%
						//get database properties
						DatabaseProperties dbp = new DatabaseProperties();
						String username = dbp.getUsername1();
						String username2 = dbp.getUsername2();
						String passwd = dbp.getPasswd1();
						String passwd2 = dbp.getPasswd2();
						String hostname = dbp.getHostname();
						String dbName = dbp.getDbName();

						//get the connection for testing1
						Connection dbcon = (new DatabseConnection()).dbConnection(hostname,
								dbName, username, passwd);

						try {

							PreparedStatement stmt;
							stmt = dbcon
									.prepareStatement("SELECT schema_id,schema_name FROM schemainfo WHERE course_id = ?");
							stmt.setString(1, (String) (String) request.getSession()
									.getAttribute("context_label"));
							

							String output = "";
							ResultSet rs = stmt.executeQuery();
							while (rs.next()) {
								output += " <option value = \"" + rs.getInt("schema_id")
										+ "\"> " + rs.getInt("schema_id") + "-"
										+ rs.getString("schema_name") + " </option> ";
							} 
							
							rs.close();

							

							out.println("<label style=\"text-align:left;float:left;\"><strong>Schema Name</strong></label> <br/> ");
							out.println(" <select name=\"schemaid\" required> " + output
									+ "</select> &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
							out.println("<label class=\"field\"><span>*</span>Choose File: </label> <input	type=\"file\" required name=\"dataFile\" size=\"20\"> <input name=\"submit\" onclick=\"return checkValue1();\" type=\"submit\"	id=\"upload\" value=\"Upload\">");
						} catch (Exception err) {

							err.printStackTrace();
							out.println("<p style=\"color:red;font-size: 17px;\">Error in retrieving schema file details<p>");
						}
						finally{
							dbcon.close();
						}
					%>
					
				</fieldset>

			</div>
		</form>
	</div>

</body>
</html>