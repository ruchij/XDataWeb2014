<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
Connection dbcon = (new DatabaseConnection()).graderConnection();

try {

	PreparedStatement stmt;
	stmt = dbcon
			.prepareStatement("SELECT sample_data,ddltext FROM schemainfo WHERE course_id = ?and schema_id =?");
	stmt.setString(1, (String) (String) request.getSession()
			.getAttribute("context_label"));
	stmt.setString(2,"3");
	String ddltext="";
	String sample_data="";
	String output = "";
	ResultSet rs = stmt.executeQuery();
	while(rs.next())
	{
	ddltext=rs.getString("ddltext");	
	sample_data=rs.getString("sample_data");
	}
	rs = stmt.executeQuery(ddltext);
	rs = stmt.executeQuery(sample_data);
	System.out.println("Completed creating tables.");
}catch(Exception e){
	
	e.printStackTrace();
}
		//get the input data
		String[] queryText=(String[])request.getParameterValues("quesTxt");
		String[] correctQuery=(String[])request.getParameterValues("query");
		String[] queryID=(String[])request.getParameterValues("qID");
		String asgnmentID =(String)request.getParameter("AssignmentID");
	
		if(queryText.length != correctQuery.length){
		out.println("Error in the query information");
		System.exit(1);
		}
	
		//out.println(asgnmentID);
		for(int i=0;i<queryText.length ; i++){
			//out.println("id "+i+": "+queryID[i]);
			//out.println("text "+i+": "+queryText[i]);
			//out.println("query "+i+": "+correctQuery[i]);
		}
%>


</body>
</html>