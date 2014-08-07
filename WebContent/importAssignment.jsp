<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.*"%>
<%@ page import="javax.swing.*"%>
<%@ page import="javax.swing.JDialog"%>
<%@ page import="javax.swing.SwingUtilities"%>
<%@ page import="javax.swing.filechooser.*"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.json.simple.parser.ParseException"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script> 

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
				<legend> Assignment Import</legend>
				<%
					String courseID = (String) request.getSession().getAttribute("context_label");
					
					JFileChooser chooser = new JFileChooser();
					FileNameExtensionFilter filter = new FileNameExtensionFilter("JSON FILES", "json");
					
					chooser.setDialogTitle("Choose a file to import assignment from");
					chooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
					chooser.setFileFilter(filter);
					
					String file = "";
				  	  if (chooser.showOpenDialog(null) == JFileChooser.APPROVE_OPTION) {
				      	    file = chooser.getSelectedFile().toString(); 
				  	}
					
				  	String redirectURL = null;  
				  	  
				  	BufferedReader br = null;
				  	 
					try {
			 
						String sCurrentLine;
			 
						br = new BufferedReader(new FileReader(file));
			 
						if ((sCurrentLine = br.readLine()) != null) {
							System.out.println("Assignment Details: "+sCurrentLine);
							JSONParser parser = new JSONParser();
							 
							try {
						 
								Object obj = parser.parse(sCurrentLine);
								JSONObject jsonObject = (JSONObject) obj;
								
								String course_id = (String) jsonObject.get("course_id");
								out.println(course_id);
						 
								long assignment_id = (Long) jsonObject.get("assignment_id");
								out.println(assignment_id);
							
								String description = (String) jsonObject.get("description");
								out.println(description);
								
								long connection_id = (Long) jsonObject.get("connection_id");
								out.println(connection_id);
								
								String default_schema_id = (String) jsonObject.get("default_schema_id");
								out.println(default_schema_id);
								
								redirectURL = "importEditAssignment.jsp?course_id="+course_id+"&&assignment_id="+assignment_id+"&&description="+description+"&&connection_id="+connection_id+"&&default_schema_id="+default_schema_id+"&&file="+file;
						
						} catch (ParseException e) {
							e.printStackTrace();
							 out.println(e.getMessage());

						}
						}	
			 		
					} catch (IOException e) {
						e.printStackTrace();
						 out.println(e.getMessage());

					} finally {
						try {
							if (br != null)br.close();
						} catch (IOException ex) {
							ex.printStackTrace();
							 out.println(ex.getMessage());

						}
					}
					
					 if (redirectURL!= null)
						 response.sendRedirect(redirectURL);
					 else
						 out.println("Import Failed!");
				%>
			</fieldset>
			
		</div>
	</div>

</body>
</html>