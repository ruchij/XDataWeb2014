<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@ page import="java.awt.*"%>
<%@ page import="java.awt.event.*"%>
<%@ page import="javax.swing.*"%>
<%@ page import="javax.swing.SwingUtilities"%>
<%@ page import="javax.swing.filechooser.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script> 
function getAssignments(courseID){
	var already = document.getElementById("assignments");
	var placeholder = document.getElementById("placeholder");
	
	if (already!=null)
		placeholder.removeChild(already);
	
	var fieldset = document.createElement("fieldset");
	fieldset.setAttribute("id", "assignments");
	fieldset.setAttribute("class", "fieldset");
	placeholder.appendChild(fieldset);
	
	var legend = document.createElement("legend");
	legend.innerHTML = "Assignments of Course:"+courseID;
	fieldset.appendChild(legend);
}


</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
html,body {
	margin: 0;
	width: 100%;
	height: 100%;
}

li {
	text-align: left
}

body {
	font: 12px/17px Arial, Helvetica, sans-serif;
	color: #333;
	background: #ccc;
	padding: 0px 0px 0px 0px;
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

label {
	font-size: 15px;
	font-weight: bold;
	color: #666;
}

label
span,.required {
	color: red;
	font-weight: bold;
	font-size: 17px;
}

a:link {
	color: #E96D63;
	font: 15px/15px Arial, Helvetica, sans-serif;
}
/* unvisited link */
a:visited {
	color: #E96D63;
	font: 15px/15px Arial, Helvetica, sans-serif;
} /* visited link */
a:hover {
	color: #7FCA9F;
	font: 15px/15px Arial, Helvetica, sans-serif;
} /* mouse over link */
a:active {
	color: #85C1F5;
	font: 15px/15px Arial, Helvetica, sans-serif;
} /* selected link */
.stop-scrolling {
	height: 100%;
	overflow: hidden;
}


</style>

</head>
<body>

	<div>

		<div class="fieldset" id="placeholder">
		<br/>
		
			<fieldset>
				<legend>JSON code</legend>
				<%
					String courseID = (String) request.getSession().getAttribute("context_label");
					String assignment_id = (String) request.getParameter("assignment_id");
				    //get database properties
					DatabaseProperties dbp = new DatabaseProperties();
					String username = dbp.getUser1Name(); //change user name according to your db user -testing1
					String username2 = dbp.getUser2Name();//This is for testing2
					String passwd = dbp.getPassword1(); //change user passwd according to your db user passwd
					String passwd2 = dbp.getPassword2();
					String hostname = dbp.getHostName();
					String dbName = dbp.getDbName();

					//get connection
					Connection dbcon = (new DatabseConnection()).dbConnection(hostname,
							dbName, username, passwd);
					String output = "<ul>";
								
					try {
			        // String sql = "SELECT version();";
					       
			        StringBuilder builder = new StringBuilder();
			        PreparedStatement stmt;
					stmt = dbcon
							.prepareStatement("select row_to_json(assignment) FROM assignment where course_id=? and assignment_id=?");
					//stmt.setString(2, (String)request.getSession().getAttribute("context_label"));
					stmt.setString(1, courseID);
					stmt.setInt(2, Integer.parseInt(assignment_id));
					
					ResultSet rs;
					rs = stmt.executeQuery();
					
					int columnCount = rs.getMetaData().getColumnCount();
			        while (rs.next()) {
			            for (int i = 0; i < columnCount;) {
			                builder.append(rs.getString(i + 1));
			                if (++i < columnCount) builder.append(",");
			            }
			            builder.append("\r\n");
			        }
			        
					stmt = dbcon
							.prepareStatement("select row_to_json(query_info) FROM query_info where course_id=? and assignment_id=?");
					//stmt.setString(2, (String)request.getSession().getAttribute("context_label"));
					stmt.setString(1, courseID);
					stmt.setInt(2, Integer.parseInt(assignment_id));
					
					ResultSet rs1;
					rs1 = stmt.executeQuery();
					
					
					int columnCount1 = rs1.getMetaData().getColumnCount();
					int ques_id = 0;
					
			        while (rs1.next()) {
			        	ques_id += 1;
			            for (int i = 0; i < columnCount1;) {
			                builder.append(rs1.getString(i + 1));
			                if (++i < columnCount1) builder.append(",");
			            }
			            builder.append("\r\n");
			            
			            
			            
			            
			            stmt = dbcon
								.prepareStatement("select row_to_json(queries) FROM queries where course_id=? and assignment_id=? and question_id=?");
						//stmt.setString(2, (String)request.getSession().getAttribute("context_label"));
						stmt.setString(1, courseID);
						stmt.setInt(2, Integer.parseInt(assignment_id));
						stmt.setInt(3, ques_id);
						
						ResultSet rs2;
						rs2 = stmt.executeQuery();
						
						int columnCount2 = rs2.getMetaData().getColumnCount();
				        while (rs2.next()) {
				            for (int i = 0; i < columnCount2;) {
				                builder.append(rs2.getString(i + 1));
				                if (++i < columnCount2) builder.append(",");
				            }
				            builder.append("\r\n");
				        }
				        
			        }
			            
			            
			        
			        
					   
			        String resultSetAsString = builder.toString();
					System.out.println("JSON Output:");
					System.out.println(resultSetAsString);
					resultSetAsString = resultSetAsString.replaceAll("\"", "&quot;");
					out.println("<form name=\"input\" action=\"exportAssignmentToFile.jsp\" method=\"post\">");
					out.println("<label for=\"lab\" >"+resultSetAsString+"</label>");
					out.println("<input type=\"hidden\" value=\""+resultSetAsString+"\" name=\"json\">");
					 
					 
					// out.println(resultSetAsString);
					} catch (Exception err) {

						err.printStackTrace();
						out.println("Error in getting list of assignments");
					}
									
									%>
			</fieldset>
			<fieldset>
				<legend>Destination File</legend>
				<%
				
				JFileChooser chooser = new JFileChooser();
				// chooser.setCurrentDirectory(new java.io.File("."));
				chooser.setDialogTitle("Choose a Folder to export assignment as a json file");
				chooser.setFileSelectionMode(JFileChooser.DIRECTORIES_ONLY);
				chooser.setAcceptAllFileFilterUsed(false);
				
				String file = "";
				    if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
				      	    file = chooser.getSelectedFile().toString(); 
				      	    file = file + "/"+courseID+"_Assignment"+assignment_id+".json";		
				      	    
				      	   	out.println("Save To <input type=\"text\" name=\"file\" size=\"50\" value=\""+file+"\">");
				      	   	out.println("<input type=\"submit\" value=\"Export\"> </form>");
				    		}
				     else 
				      		out.println("No Selection was made");
				%>
			</fieldset>				
			
		</div>
	</div>

</body>
</html>