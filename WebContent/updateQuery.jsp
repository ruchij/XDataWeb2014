<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="refresh" content="0;url=ListAllAssignments.html" />
<title>Update Query</title>
<script type="text/javascript" src="scripts/wufoo.js"></script>

<!-- CSS -->
<link rel="stylesheet" href="css/structure.css" type="text/css" />
<link rel="stylesheet" href="css/form.css" type="text/css" />
<link rel="stylesheet" href="css/theme.css" type="text/css" />

<link rel="canonical" href="http://www.wufoo.com/gallery/designs/template.html">
<style>
body
{
background-color:#E6E6FA;
}
</style>
</head>
<body>
<%
		//get the list of questions		
		String[] queryID = (String[])request.getParameterValues("qID");
		//int asgnmentID = Integer.parseInt(request.getParameter("AssignmentID"));
		String assignmentID = (String)request.getSession().getAttribute("resource_link_id");
		String courseID = (String)request.getSession().getAttribute("context_label");
		/* String[] queryText1=(String[])request.getParameterValues("quesTxt");
		String[] correctQuery1=(String[])request.getParameterValues("query");
		
		
		if(queryText1.length != correctQuery1.length){
		out.println("Error in the query information");
		System.exit(1);
		} */
	

		//get database properties
		DatabaseProperties dbp=new DatabaseProperties();
		String username = dbp.getUsername1(); //change user name according to your db user -testing1
		String username2 = dbp.getUsername2();//This is for testing2
		String passwd = dbp.getPasswd1(); //change user passwd according to your db user passwd
		String passwd2 = dbp.getPasswd2();
		String hostname = dbp.getHostname();
		String dbName = dbp.getDbName();
	     
		Connection dbcon=null;
		
	    dbcon=(new DatabseConnection()).dbConnection(hostname, dbName,username,passwd);	
		
		//insert the details into queryInfo table
		//Its schema is assignID,queryID,queryText,correctQuery
		//For each assignment the queryId starts with 1
		//assignID,queryID forms the primary key
		int qID=1;
		
		try{
			PreparedStatement stmt;
			ResultSet rs;
			
			//for each question
			for(int i = 0; i < queryID.length; i++){
				//get the question description
				String text = "quesTxt" + queryID[i];
				String[] queryText = (String[])request.getParameterValues(text);
				
				String queryDesc = "";
				if(queryText[0] != null)
					 queryDesc = queryText[0].replaceAll("'", "''").trim().replaceAll("\r\n+", " ").trim().replaceAll("\n+", " ").trim().replaceAll(" +", " ");
				
				System.out.println("Desc: "+queryDesc);
				//get the list of ocrrect queries
				String query = "query" + queryID[i];
				
				String[] correctQuery = (String[])request.getParameterValues(query);
				
				int correctQueryId = 1;
				
				//for each correct answer
				for(int j = 0; j < correctQuery.length; j++){
					
					String correctAnswer = correctQuery[j];
					
					if(correctAnswer == null)
						continue ;
					
					String correctquery = correctAnswer.replaceAll("'", "''").trim().replaceAll("\r\n+", " ").trim().replaceAll("\n+", " ").trim().replaceAll(" +", " ");
					
					System.out.println("Correct: "+correctquery);
					//Schema: 
					//insert into query info table
					stmt = dbcon.prepareStatement("INSERT INTO qinfo VALUES (?,?,?,?,?,?,?,?,?,?)");
					stmt.setString(1,courseID);		 
					stmt.setString(2,assignmentID);
					stmt.setString(3,  queryID[i].trim());
					stmt.setString(4, "");
					stmt.setString(5, queryDesc);					
					stmt.setString(6, correctquery);
					stmt.setInt(7, 1);
					stmt.setBoolean(8, false);
					stmt.setBoolean(9, false);
					stmt.setBoolean(10, false);
					stmt.executeUpdate(); 
				}
				
			}
			
	
			//printing the data
		
			out.println("<h3  >Updated successfully</h3>");
			//out.println("WForwarding request ");
		
		}
		 catch(SQLException sep){
			System.out.println("SQLException: " + sep);
			out.println("<p style=\"font-family:arial;color:red;font-size:20px;background-color:white;\">Could not update the queries related information </p>");
		//	System.exit(1);
		} 
	dbcon.close();
%>
</body>
</html>