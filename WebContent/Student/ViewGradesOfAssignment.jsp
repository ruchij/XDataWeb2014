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
<title>Insert title here</title>

<style>

label {
	font-size: 18px;
	font-weight: bold;
	color: #666;
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

							//get connection
							Connection dbcon = (new DatabaseConnection()).graderConnection();

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