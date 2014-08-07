<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Welcome Message</title>

<style>
body {
	font: 12px/17px Arial, Helvetica, sans-serif;
	color: #333;
	background: #ccc;
	padding: 40px 20px 20px 20px;
}
</style>
</head>
<body>

<strong font-size:15px>XData</strong>

<%

String name = (String) request.getSession().getAttribute("lis_person_name_full");

String email = (String) request.getSession().getAttribute("lis_person_contact_email_primary");

String output = "<p><label> " + name + "(" + email + ")</label></p>";

out.println(output);


%>
</body>
</html>