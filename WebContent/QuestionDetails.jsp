<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@page import="database.*"%>
<%
	String qID = (String) request.getParameter("questionId");

	String correctQueryID = "1";
%>
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
 <link rel="stylesheet" href="scripts/codemirror/lib/codemirror.css" />

<link rel="stylesheet" href="scripts/codemirror/addon/hint/show-hint.css" />
<script src="scripts/codemirror/addon/hint/show-hint.js"></script>
<script src="scripts/codemirror/addon/hint/sql-hint.js"></script>

<script src="scripts/codemirror/lib/codemirror.js"></script>
<script src="scripts/codemirror/mode/sql/sql.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Details of the Question</title>


<script type="text/javascript" src="scripts/ManageQuery.js"></script>
 <script>
 window.onload = function() {
	  var mime = 'text/x-mariadb';
	  // get mime type
	  if (window.location.href.indexOf('mime=') > -1) {
	    mime = window.location.href.substr(window.location.href.indexOf('mime=') + 5);
	  }
	  window.editor = CodeMirror.fromTextArea(document.getElementById('query <%= qID +" " + correctQueryID %>'), {
	    mode: mime,
	    indentWithTabs: true,
	    smartIndent: true,
	    lineNumbers: true,
	    matchBrackets : false,
	    lineWrapping: true,
	    autofocus: true,
	    extraKeys: {"Ctrl-Space": "autocomplete"},
	    hintOptions: {tables: {
	      users: {name: null, score: null, birthDate: null},
	      countries: {name: null, population: null, size: null}
	    }}
	  });
	  CodeMirror.commands.autocomplete = function(cm) {
	  }
	};
</script>
</head>
<body>

	<div>
		<br /> <br />
		<div class="fieldset">
			<fieldset>
				<legend> Assignment Details and Instructions</legend>
				<%
					if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
						response.sendRedirect("index.html");
						return;
					}
				
					String assignID = (String) request.getParameter("AssignmentID");
					String courseID = (String) request.getSession().getAttribute(
							"context_label");
					String instructions = (new CommonFunctions())
							.getAssignmnetIinstructions(courseID, assignID);
					
					out.println(instructions);
				%>
			</fieldset>
			
			<br/>
			
			<fieldset>
				<legend> Question Details</legend>

				<%
					String questionID = (String) request.getParameter("questionId");
							
							//get connection
							Connection dbcon = (new DatabaseConnection()).graderConnection();

							String output = "";

							String listButton = "<input type=\"button\" name=\"button "
									+ questionID
									+ " "
									+ assignID
									+ "\" "
									+ " onClick=\"report(this,3)\""
									+ " value=\"List Of Questions\" style=\"float:right;\"><br/>\n";

							output += listButton
									+ "<table  cellspacing=\"10\"  class=\"authors-list\" id=\"queryTable\" align=\"center\"> \n <tr> <th >Question ID</th>       <th >Question Text</th>  <th >Correct Query</th> <th> </th></tr>"
									+ "\n";
							//get query details
							try {
								PreparedStatement stmt;
								//stmt = dbcon.prepareStatement("SELECT * FROM  qinfo ,assignment where qinfo.assignment_id=? AND qinfo.assignment_id=assignment.assignment_id");
								stmt = dbcon
										.prepareStatement("SELECT * FROM  qinfo  where assignmentid=? and courseid=? and questionid=?");
								stmt.setString(1, assignID.trim());
								stmt.setString(2, courseID.trim());
								stmt.setString(3, (String) request.getParameter("questionId"));
								System.out.println("QId :" + (String) request.getParameter("questionId"));
								System.out.println("Course Id: " + courseID);
								System.out.println("AssId :" + assignID);

								ResultSet rs = stmt.executeQuery();
								
								
								while (rs.next()) {
									String query = rs.getString("correctquery");
									String description = rs.getString("querytext");
				%>
							<div class="questionelement">
								<div class="question"><span>Q<%= qID %>. </span><%= description %></div>
								<div>
									<div class="description" style='padding:10px 5px 5px 5px;float:left; width:35%;'>
										<textarea style="padding:5px;width:95%; height:290px;" name ='quesTxt' id = 'quesTxt<%= qID%>'><%= description %></textarea>
									</div>
									<div class="answer">
										<textarea name='query' id='query <%=qID +" " + correctQueryID %>'><%=query %></textarea>
									</div>
								</div>
								<div class="editbutton">
								<input type="button" onClick="report(this,1)"  value="Update Query" name="button <%=qID + " "+assignID%>"/>
								</div>
							</div>
							<%
							output += "<tr class=\" "+qID+"\"> \n <td> <p align=\"center\" name=\"qID\" id=\"qID"
									+ qID + "\" >" + qID + "</p> </td> \n";
							output += "<td> <textarea name=\"quesTxt\"  id=\"quesTxt"
									+ qID + "\" rows=\"6\" cols=\"35\" >" + description
									+ " </textarea> </td> \n";
							output += " <td><textarea name=\"query\" id=\"query " + qID +" " + correctQueryID
									+ "\"rows=\"6\" cols=\"35\">" + query
									+ " </textarea></td> \n";

							String id = "<input type=\"button\" name=\"button " + qID
									+ " " + assignID + "\" ";
							
							String buttons = id + " onClick=\"report(this,1)\""
									+ " value=\"Update Query\" ><br/>\n" + id
									+ "<onClick=\"report(this,1)\""
									+ " value=\"Generate Dataset\" >";

							output += "<td>" + buttons + "</td>\n</tr>\n";
						}
						
						rs.close();
					}

					catch (Exception err) {
						err.printStackTrace();
						out.println("Error in retrieving question details");
					}
					finally{
						dbcon.close();
					}
					//output += "</table>";
					output = "";
					out.println(output);
				%>
			</fieldset>
		</div>
	</div>

</body>
</html>