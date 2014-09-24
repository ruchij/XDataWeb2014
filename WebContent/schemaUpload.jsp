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
			saveFile = "/tmp/" + saveFile;
			File ff = new File(saveFile);

			// creating a new file with the same name and writing the content in new file
			FileOutputStream fileOut = new FileOutputStream(ff);
			fileOut.write(dataBytes, startPos, (endPos - startPos));
			fileOut.flush();
			fileOut.close();
		} catch (Exception err) {
			err.printStackTrace();
		}

		//Now execute the script in the database

		ArrayList<String> listOfQueries = (new FileToSql())
				.createQueries(saveFile);
		String[] inst = listOfQueries.toArray(new String[listOfQueries
				.size()]);
		//get the connection for testing1
		Connection dbcon = (new DatabaseConnection()).graderConnection();

		try {
			PreparedStatement stmt;
			for (int i = 0; i < inst.length; i++) {
				// we ensure that there is no spaces before or after the request string  
				// in order to not execute empty statements  
				if (!inst[i].trim().equals("")) {
					stmt = dbcon.prepareStatement(inst[i] + ";");
					//stmt.setString(1, inst[i]+";");
					stmt.executeUpdate();
					//System.out.println(inst[i]+";");
				}
			}
		} catch (Exception err) {

			out.println("<p style=\"color:red;font-size: 17px;\">Not updated properly </p>");
			err.printStackTrace();
			x = 1;
			//System.exit(1);
		}
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
		if (x == 0) {
			//printing data

			out.println("<p > You have successfully uploaded the file </p> ");
			//   out.println(saveFile);

		}
			} else {

		out.println("<p > Error in file uploading. please verify it! </p> ");

			}
	%>
</body>
</html>