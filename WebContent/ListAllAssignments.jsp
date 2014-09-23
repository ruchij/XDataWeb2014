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
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
</style>

</head>
<body>

	<div>

		<div class="fieldset">
		<br/>
		
			<fieldset>
				<legend> List of Assignments</legend>
				<%
					if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
								response.sendRedirect("index.html");
								return;
							}
						
							String courseID = (String) request.getSession().getAttribute("context_label");

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