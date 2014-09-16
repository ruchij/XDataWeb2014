<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="javax.servlet.http.HttpServletRequest"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="net.oauth.OAuth"%>
<%@ page import="net.oauth.OAuthMessage"%>
<%@ page import="net.oauth.OAuthConsumer"%>
<%@ page import="net.oauth.OAuthAccessor"%>
<%@ page import="net.oauth.OAuthValidator"%>
<%@ page import="net.oauth.SimpleOAuthValidator"%>
<%@ page import="net.oauth.signature.OAuthSignatureMethod"%>
<%@ page import="net.oauth.server.HttpRequestMessage"%>
<%@ page import="net.oauth.server.OAuthServlet"%>
<%@ page import="net.oauth.signature.OAuthSignatureMethod"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>

<%
	Enumeration en = request.getParameterNames();
	while (en.hasMoreElements()) {
		String paramName = (String) en.nextElement();
		out.println(paramName + " = " + request.getParameter(paramName));

	}

	int DEBUG = 1;

	String userId, name, email, role;

	OAuthValidator oav = new SimpleOAuthValidator();
	OAuthMessage oam = null;
	OAuthConsumer cons = null;
	OAuthAccessor acc = null;

	if (DEBUG == 0) {
		oam = OAuthServlet.getMessage(request, null);

		String oauth_consumer_key = request
				.getParameter("oauth_consumer_key");
		if (oauth_consumer_key == null) {
			out.println("<b>Missing oauth_consumer_key</b>\n");
			return;
		}

		cons = null;
		if ("iitb.ac.in".equals(oauth_consumer_key)) {
			cons = new OAuthConsumer("http://moodle.iitb.ac.in/",
					"iitb.ac.in", "xd387sec", null);
			//} else if ( "12345".equals(oauth_consumer_key) ) {
			//cons = new OAuthConsumer("http://call.back.url.com/", "12345", "secret", null);
		} else {
			out.println("<b>oauth_consumer_key=" + oauth_consumer_key
					+ " not found.</b>\n");
			return;
		}

		userId = request.getParameter("user_id");
		name = request.getParameter("lis_person_name_full");
		email = request
				.getParameter("lis_person_contact_email_primary");

		acc = new OAuthAccessor(cons);
		System.out.println("Req :"
				+ request.getParameter("lis_person_name_full"));
		session.setAttribute("user_id", userId);
		session.setAttribute("context_label",
				request.getParameter("context_label"));
		session.setAttribute("resource_link_id",
				request.getParameter("resource_link_id"));
		session.setAttribute("lis_result_sourcedid",
				request.getParameter("lis_result_sourcedid"));
		session.setAttribute("lis_outcome_service_url",
				request.getParameter("lis_outcome_service_url"));
		session.setAttribute("lis_person_name_full", name);
		session.setAttribute("lis_person_contact_email_primary", email);
		session.setAttribute("roles", request.getParameter("roles"));
	} else {

		if (session.getAttribute("LOGIN_USER") == "ADMIN") {
			userId = "007";
			name = "Instructor";
			email = "instructor@icde.com";
			role = "instructor";
		} else {
			userId = "14";
			name = "Student";
			email = "student@icde.com";
			role = "student";
		}
		
		session.setAttribute("user_id", userId);
		session.setAttribute("context_label", "CS631");
		session.setAttribute("resource_link_id", "10");
		session.setAttribute("lis_person_name_full", name);
		session.setAttribute("lis_person_contact_email_primary", email);
		session.setAttribute("roles", role);
	}

	try {
		DatabaseProperties properties = new DatabaseProperties();
		Connection dbcon = null;

		dbcon = (new DatabseConnection()).dbConnection(
				properties.getHostname(), properties.getDbName(),
				properties.getUsername1(), properties.getPasswd1(), properties.getPortNumber());

		PreparedStatement stmt;
		ResultSet rs = null;
		stmt = dbcon
				.prepareStatement("SELECT * FROM  users where id=?");
		stmt.setString(1, userId);
		rs = stmt.executeQuery();

		if (!rs.next()) {
			stmt = dbcon
					.prepareStatement("INSERT INTO users VALUES(?, ?, ?)");
			stmt.setString(1, userId);
			stmt.setString(2, name);
			stmt.setString(3, email);
			stmt.executeUpdate();
		}

		stmt.close();
		rs.close();
		dbcon.close();
	} catch (Exception e) {
		out.println("<b>Error inserting/retrieving user information</b>\n");
		out.println(e);
	}

	if (DEBUG == 0) {

		try {
			out.println("\n<b>Base Message</b>\n</pre><p>\n");
			out.println(OAuthSignatureMethod.getBaseString(oam));
			out.println("<pre>\n");
			oav.validateMessage(oam, acc);
			out.println("Message validated");
		} catch (Exception e) {
			out.println("<b>Error while valdating message:</b>\n");
			out.println(e);
		}
	}

	System.out.println("updated2");
%>
<jsp:forward page="/InitAssignment" />
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<title>IMS Basic Learning Tools Interoperability</title>
</head>
<body style="font-family: sans-serif">
	<img src="http://www.sun.com/images/l2/l2_duke_java.gif" align="right">
	<p>
		<b>IMS BasicLTI Java Provider</b>
	</p>
	<p>This is a very simple reference implementaton of the tool side
		(i.e. provider) for IMS BasicLTI.</p>
	<p>This tool is configured with an LMS-wide guid of
		"lmsng.school.edu" protected by a secret of "secret". For this tool,
		all resource level secrets are also "secret".</p>
	</p>
</body>
</html>
