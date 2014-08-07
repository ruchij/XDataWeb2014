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
<title>Insert title here</title>

<style>
html,body {
	margin: 0;
	background: #ccc;
}

label {
	font-size: 18px;
	font-weight: bold;
	color: #666;
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

fieldset {
	background: #f2f2e6;
	padding: 10px;
	border: 1px solid #fff;
	border-color: #fff #666661 #666661 #fff;
	margin-bottom: 36px;
	/* 	width: 90%;
	height: 100%; */
}

</style>

</head>
<body>
	<div>
		<br /> <br />
		<div class="fieldset">

			<fieldset>
				<legend> Grades</legend>
				<%
					String courseID = (String) request.getSession().getAttribute(
							"context_label");

					String assignID = (String) request.getSession().getAttribute(
							"resource_link_id");
					String studentId = (String) request.getSession().getAttribute(
							"user_id");

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

					try {
						PreparedStatement stmt;
						stmt = dbcon
								.prepareStatement("SELECT * FROM  assignment where assignmentid = ? and courseid = ?");
						stmt.setString(
								1,
								(String) request.getSession().getAttribute(
										"resource_link_id"));
						stmt.setString(
								2,
								(String) request.getSession().getAttribute(
										"context_label"));

						ResultSet rs;
						rs = stmt.executeQuery();
						String endTime = "";
						SimpleDateFormat formatter = new SimpleDateFormat(
								"yyyy-MM-dd HH:mm:ss");
						formatter.setLenient(false);
						if (rs.next()) {
							endTime = formatter.format(rs.getTimestamp("endtime"));
							rs.close();
						} else {
							out.println("No assignment exists");
							rs.close();
							dbcon.close();
							return;
						}

						//get current date
						Calendar c = Calendar.getInstance();

						String currentDate = formatter.format(c.getTime());
						java.util.Date current = formatter.parse(currentDate);
						//compare times

						java.util.Date oldDate = formatter.parse(endTime);

						//now check whether current time is more than end time.Then only assignment can be graded
						if (oldDate.compareTo(current) < 0) {
							String remoteLink = "/xdata/ViewAssignment?assignmentid="
									+ assignID.trim() + "V";
							response.sendRedirect(remoteLink);
						} else {
							out.println("<label>Assignment is not yet graded</label>");
						}
					} catch (Exception err) {

						out.println("<p >Error in getting assignment </p>");
						err.printStackTrace();
					}
					dbcon.close();
				%>
			</fieldset>
		</div>
	</div>
</body>
</html>