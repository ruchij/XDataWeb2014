<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="database.FileToSql"%>
<%@page import="database.FileHandler"%>
<%@page import="database.DatabaseProperties"%>
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

<title>Update Query</title>
<script type="text/javascript" src="scripts/wufoo.js"></script>

<!-- CSS -->
<link rel="stylesheet" href="css/structure.css" type="text/css" />
<link rel="stylesheet" href="css/form.css" type="text/css" />
<link rel="stylesheet" href="css/theme.css" type="text/css" />

<link rel="canonical"
	href="http://www.wufoo.com/gallery/designs/template.html">
<style>


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
</head>
<body>
	<%
		if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
		response.sendRedirect("index.html");
		return;
			}
		
			//store the data in a file
			String saveFile = "";
			int x = 0;
			String data="";
			String filename="";
			String contentType = request.getContentType();
			//here we are checking the content type is not equal to Null and as well as the passed data from mulitpart/form-data is greater than or equal to 0
			if ((contentType != null)
			&& (contentType.indexOf("multipart/form-data") >= 0)) {
		try {
			DataInputStream in = new DataInputStream(
					request.getInputStream());
			//we are taking the length of Content type data
			int formDataLength = request.getContentLength();
			byte dataBytes[] = new byte[formDataLength];
			int byteRead = 0;
			int totalBytesRead = 0;
			//this loop converting the uploaded file into byte code
			while (totalBytesRead < formDataLength) {
				byteRead = in.read(dataBytes, totalBytesRead,
						formDataLength);
				totalBytesRead += byteRead;
			}
			//for saving the file name
			String file = new String(dataBytes);
			saveFile = file.substring(file.indexOf("filename=\"") + 10);
			saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
			saveFile = saveFile.substring(
					saveFile.lastIndexOf("\\") + 1,
					saveFile.indexOf("\""));
			int lastIndex = contentType.lastIndexOf("=");
			String boundary = contentType.substring(lastIndex + 1,
					contentType.length());
			int pos;
			//extracting the index of file 
			pos = file.indexOf("filename=\"");
			pos = file.indexOf("\n", pos) + 1;
			pos = file.indexOf("\n", pos) + 1;
			pos = file.indexOf("\n", pos) + 1;

			int boundaryLocation = file.indexOf(boundary, pos) - 4;
			int startPos = ((file.substring(0, pos)).getBytes()).length;
			int endPos = ((file.substring(0, boundaryLocation))
					.getBytes()).length;
			//LINUX style of specifying the folder name
			 filename=new String(saveFile);
			//saveFile = "/tmp/" + saveFile;
			//File ff = new File(saveFile);

			// creating a new file with the same name and writing the content in new file
			//FileOutputStream fileOut = new FileOutputStream(ff);
			//fileOut.write(dataBytes, startPos, (endPos - startPos));
			/* byte dataBytes2[]=null;
			for(int i=0;i<(endPos-startPos);i++)
			{
				dataBytes2[i]=dataBytes[startPos+i];
			} */
			data=new String(dataBytes);
			data=data.substring(startPos,endPos);
			//System.out.println("New Data"+data);
			data=data.replaceAll("(?i)create(\\s)+table","create temporary table");
			data=data.replaceAll("'","''");					
			System.out.println("data  test:"+data);
			//fileOut.flush();
			//fileOut.close();
			//String data2=new String(dataBytes,"UTF-8");
			/* BufferedReader reader = new BufferedReader(
	                new FileReader("/tmp/"+saveFile));
	       String line;
	        while((line=reader.readLine()) != null){
	            //String readData = String.valueOf(buf, 0, numRead);
	            data.concat(line);
	        }
	        reader.close(); */
			//data=s;
			//System.out.println("After file making"+s);
		} catch (Exception err) {
			err.printStackTrace();
		}
			}
		//Insert in database-R
		 Connection dbcon=(new DatabaseConnection()).graderConnection();
	int i=1;
	try{
		
		PreparedStatement stmt,xstmt;
    	//xstmt = dbcon.prepareStatement("SET role testing1");
    	//xstmt.executeUpdate("set role testing1");
    	dbcon.setAutoCommit(false); 
    	stmt = dbcon.prepareStatement("SELECT max(schema_id) from schemainfo");
    	
		int max_schema_id;
    	String output = "";
    	ResultSet rs = stmt.executeQuery();
    	while(rs.next())
    	{
    		if(rs.getString("max")==null)
    		{
    			max_schema_id=0;
    			
    		}
    		else
    		{
    			max_schema_id=rs.getInt("max");
    		}
    		//String data=new String(dataBytes);
    		int next_id =max_schema_id+1;
    		String nextid=Integer.toString(next_id);
    		//System.out.println("max schema id:"+max_schema_id);
    		String courseid=(String) request.getSession().getAttribute("context_label");
    		System.out.println("courseid:"+courseid);
    		stmt = dbcon.prepareStatement("insert into schemainfo(course_id,schema_id,schema_name,ddltext) values(?,?,?,?)");
    		stmt.setString(1,courseid);
    		stmt.setString(2,nextid);
    		stmt.setString(3,filename);
    		stmt.setString(4,data);
    		//System.out.println(stmt.);
    		stmt.execute();
    		i=0;
    		
    	}
	}catch(Exception e){
		System.out.println("Error in insert database code");
		e.printStackTrace();}
		//Insert close
		//Now execute the script in the database

		/* ArrayList<String> listOfQueries = (new FileToSql())
				.createQueries(saveFile);
		String[] inst = listOfQueries.toArray(new String[listOfQueries
				.size()]); */
		//get the connection for testing1
		//Connection dbcon = (new DatabaseConnection()).graderConnection();
//creating table. not using it 
/*
		try {
			PreparedStatement stmt1;
			for (int i = 0; i < inst.length; i++) {
				//System.out.println("Error1");
				// we ensure that there is no spaces before or after the request string  
				// in order to not execute empty statements  
				if (!inst[i].trim().equals("")) {
					//System.out.println("Error2");
					stmt1 = dbcon.prepareStatement(inst[i] + ";");
					//stmt.setString(1, inst[i]+";");
					System.out.println("Error3");
					stmt1.executeUpdate();
					System.out.println("Error4");
					//System.out.println(inst[i]+";");
				}
			}
		} catch (Exception err) {

			out.println("<p style=\"color:red;font-size: 17px;\">Not updated properly </p>");
			err.printStackTrace();
			x = 1;
			//System.exit(1);
		}*/
		dbcon.commit();
		dbcon.close();
		/*	
			//now execute this script for testing2
		   dbcon=(new DatabseConnection()).dbConnection(hostname, dbName,username2,passwd2);
		    try{
		    	PreparedStatement stmt;  
		        for(int i = 0; i<inst.length; i++){  
		           // we ensure that there is no spaces before or after the request string  
		            // in order to not execute empty statements  
		            if(!inst[i].trim().equals("")){  
		            	stmt=dbcon.prepareStatement(inst[i]+";");
		            	//stmt.setString(1, inst[i]+";");
		            	stmt.executeUpdate();
		            }  
		        }  
		     }  
			catch (Exception err) {
				out.println("<p style=\"font-family:arial;color:red;font-size:20px;background-color:white;\">"+err+" </p>");
				out.println("<p style=\"font-family:arial;color:red;font-size:20px;background-color:white;\">Not updated properly </p>");
			 	dbcon.close();
			    err.printStackTrace();
			    x=1;
			  	//System.exit(1);
			}
			dbcon.close();
		 */
		if (i == 0) {
			//printing data

			out.println("<font color=blue><p> You have successfully uploaded the file </p><font> ");
			//   out.println(saveFile);

		
			} else {

		out.println("<font color=red><p> Error in file uploading. please verify it! </p></font> ");

			}
			
	%>
</body>
</html>