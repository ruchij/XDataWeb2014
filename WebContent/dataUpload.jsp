<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="database.FileToSql"%>
<%@page import="database.FileHandler"%>
<%@page import="database.DatabaseProperties" %>
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="refresh" content="0;url=instructorOptions.html" />
<title>Assignment List</title>
<script type="text/javascript" src="scripts/wufoo.js"></script>

<!-- CSS -->
<link rel="stylesheet" href="css/structure.css" type="text/css" />
<link rel="stylesheet" href="css/form.css" type="text/css" />
<link rel="stylesheet" href="css/theme.css" type="text/css" />

<link rel="canonical" href="http://www.wufoo.com/gallery/designs/template.html">
<style>
          //for saving the file name
            String file = new String(dataBytes);
            saveFile = file.substring(file.indexOf("filename=\"") + 10);
            saveFile = saveFile.substring(0, saveFile.indexOf("\n"));
            saveFile = saveFile.substring(saveFile.lastIndexOf("\\") + 1, saveFile.indexOf("\""));
            int lastIndex = contentType.lastIndexOf("=");
            String boundary = contentType.substring(lastIndex + 1, contentType.length());
            int pos;
          //extracting the index of file 
            pos = file.indexOf("filename=\"");
            pos = file.indexOf("\n", pos) + 1;
            pos = file.indexOf("\n", pos) + 1;
            pos = file.indexOf("\n", pos) + 1;
            
            int boundaryLocation = file.indexOf(boundary, pos) - 4;
            int startPos = ((file.substring(0, pos)).getBytes()).length;
            int endPos = ((file.substring(0, boundaryLocation)).getBytes()).length;
            //LINUX style of specifying the folder name
            saveFile = "/tmp/" + saveFile;
            File ff = new File(saveFile);
            
         // creating a new file with the same name and writing the content in new file
            FileOutputStream fileOut = new FileOutputStream(ff);
            fileOut.write(dataBytes, startPos, (endPos - startPos));
            fileOut.flush();
            fileOut.close();
          //Now execute the script in the database
          
          	//get database properties
			DatabaseProperties dbp=new DatabaseProperties();
			String username = dbp.getUsername1(); //change user name according to your db user -testing1
			String username2=dbp.getUsername2();//This is for testing2
			String passwd = dbp.getPasswd1(); //change user passwd according to your db user passwd
			String passwd2=dbp.getPasswd2();
			String hostname=dbp.getHostname();
			String dbName=dbp.getDbName();
			String port = dbp.getPortNumber();
	     
			//now execute this script for testing1
			ArrayList<String> listOfQueries=(new FileToSql()).createQueries(saveFile);
			String[] inst = listOfQueries.toArray(new String[listOfQueries.size()]);
	        //get the connection for testing1
	        Connection dbcon=(new DatabseConnection()).dbConnection(hostname, dbName, username, passwd, port);			
	        
	        try{
	        	
	        	String insertData = "";
	        	PreparedStatement stmt;  
	            for(int i = 0; i<inst.length; i++){  
	               // we ensure that there is no spaces before or after the request string  
	                // in order to not execute empty statements  
	                if(!inst[i].trim().equals("")){
	                	String str = inst[i].replaceAll("'","''");
	                	stmt = dbcon.prepareStatement(str+";");	                	
	                	stmt.executeUpdate();
	                	insertData += inst[i].replaceAll("'", "''").trim().replaceAll("\r\n+", " ").trim().replaceAll("\n+", " ").trim().replaceAll(" +", " ") + ";";
	                }  
	            }
	            
	            /**update this information in schema info table*/
	        	PreparedStatement stmt1;
	        	stmt1 = dbcon.prepareStatement("UPDATE schemainfo SET sample_data = ? where course_id = ? and schema_id = ?");
	        	stmt1.setString(2, "CS-101");/**FIXME: Change this*/
	    		stmt1.setInt(3, schemaId);/**FIXME: Change this*/
	    		stmt1.setString(1, insertData);
	    		//stmt1.setString(4, "schemaId");
	        	
	    		stmt1.executeUpdate();
	        	
	         }  
    		catch (Exception err) {
    			out.println("<p style=\"font-family:arial;color:red;font-size:20px;background-color:white;\">"+err+" </p>");
    			out.println("<p style=\"font-family:arial;color:red;font-size:20px;background-color:white;\">Not updated properly </p>");
      		  	 err.printStackTrace();
      		  	 x=1;
      		  	 //System.exit(1);
    		}
	        dbcon.close();
          
          
          
          //print the output
          if(x==0){

    		out.println("</head>");
    		
			out.println("<h3 class=\"wufoo\"  style=\"font-family:arial;color:red;font-size:20px;background-color:white;\"> You have successfully uploaded the file </h3> ");
           // out.println(saveFile);
            
          }
                        
      }
      else{
    	  out.println("<h3 class=\"wufoo\" style=\"font-family:arial;color:red;font-size:20px;background-color:white;\">Error in file uploading. Please verify it ! <h3>");

      }
    out.println("Wait some time....Automatically redirected");
%>
</body>
</html>