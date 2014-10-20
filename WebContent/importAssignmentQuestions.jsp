<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.json.simple.parser.ParseException"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Create Assignment</title>
<script type="text/javascript" src="scripts/newrow.js"></script>
<script type="text/javascript" src="scripts/wufoo.js"></script>
<script type="text/javascript" src="scripts/ManageQuery.js"></script>

<style>
html,body {
	margin: 0;
	width: 100%;
	height: 100%;
}

body {
	font: 12px/17px Arial, Helvetica, sans-serif;
	color: #333;
	background: #ccc;
	padding: 40px 20px 20px 20px;
}

fieldset {
	background: #f2f2e6;
	padding: 10px;
	border: 1px solid #fff;
	border-color: #fff #666661 #666661 #fff;
	margin-bottom: 36px;
	width: 90%;
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
}

label {
	font-size: 15px;
	font-weight: bold;
	color: #666;
}

label span,.required {
	color: red;
	font-weight: bold;
}

nav ul li {
	float: left;
}

nav ul li:hover {
	background: #4b545f;
	background: linear-gradient(top, #4f5964 0%, #5f6975 40%);
	background: -moz-linear-gradient(top, #4f5964 0%, #5f6975 40%);
	background: -webkit-linear-gradient(top, #4f5964 0%, #5f6975 40%);
}

nav ul li:hover a {
	color: #fff;
}

nav ul li a {
	display: block;
	padding: 25px 40px;
	color: #757575;
	text-decoration: none;
}

.wrapper {
    text-align: center;
}

.button {
    position: absolute:
    top: 50%;
}
</style>

<%
	/*
	 //String noOfQuestions=request.getParameter("NumberOfQuestions");
	 String startTime=request.getParameter("starttime");
	 String endTime=request.getParameter("endtime");
	 String startDate=request.getParameter("startdate");
	 String endDate=request.getParameter("enddate");
	 */

	//getting parameters 
	String file = (String) request.getParameter("filename");
	String description = (String) request.getParameter("description");
	String courseId = (String) request.getSession().getAttribute(
			"context_label");
	
	//String dbPassword = "testing2";
	//String dbuserName = "testing2";
	//String jdbcUrl = "";
	//String dbType = "";
	String connID = (String) request.getParameter("connID");
	String schemaID = (String) request.getParameter("schemaID");
	String assignID = (String) request.getParameter("AssignID");
	String oldAssignID = (String) request.getParameter("oldAssignID");
	String oldCourseID = (String) request.getParameter("oldCourseID");
	// String assignID = (String) request.getSession().getAttribute("resource_link_id");
	request.getSession().setAttribute("resource_link_id", assignID);
	String startmonth = request.getParameter("startmonth");
	String startday = request.getParameter("startday");
	String startyear = request.getParameter("startyear");
	String starthour = request.getParameter("starthour");
	String startmin = request.getParameter("startmin");
	String startampm = request.getParameter("startampm");

	int starttime = (Integer.parseInt(starthour))
			+ (Integer.parseInt(startampm));

	String endmonth = request.getParameter("endmonth");
	String endday = request.getParameter("endday");
	String endyear = request.getParameter("endyear");
	String endhour = request.getParameter("endhour");
	String endmin = request.getParameter("endmin");
	String endampm = request.getParameter("endampm");

	int endtime = (Integer.parseInt(endhour))
			+ (Integer.parseInt(endampm));

	String startDate = startday + "-" + startmonth + "-" + startyear
			+ " " + starttime + ":" + startmin + ":" + "00";
	String endDate = endday + "-" + endmonth + "-" + endyear + " "
			+ endtime + ":" + endmin + ":" + "00";
	//out.println(startDate);
	//int number = Integer.parseInt(noOfQuestions);

	//get database properties
	DatabaseProperties dbp = new DatabaseProperties();
	String username = dbp.getUsername1(); //change user name according to your db user -testing1
	String username2 = dbp.getUsername2();//This is for testing2
	String passwd = dbp.getPasswd1(); //change user passwd according to your db user passwd
	String passwd2 = dbp.getPasswd2();
	String hostname = dbp.getHostname();
	String dbName = dbp.getDbName();

	//get the assignment ID after updating the assignment table
	//int assignID=0;

	Connection dbcon = null;

	dbcon = (new DatabseConnection()).dbConnection(hostname, dbName,
			username, passwd,"5432");
	boolean err = false;
	try {
		PreparedStatement stmt, stmt1;
		//insert into assignment
		stmt = dbcon
				.prepareStatement("INSERT INTO assignment VALUES (?,?,?,?,?, to_timestamp(?,'dd-mm-yyyy hh24:mi:ss'),to_timestamp(?,'dd-mm-yyyy hh24:mi:ss'), ?);");

		stmt.setString(1, courseId);
		stmt.setInt(2, Integer.parseInt(assignID));
		stmt.setString(3, description);
		stmt.setInt(4, Integer.parseInt(connID));
		stmt.setString(5, schemaID);
		stmt.setString(6, startDate);
		stmt.setString(7, endDate);
		stmt.setString(8, null);
		//out.println(courseId+" "+assignID+" "+description+" "+connID+" "+schemaID+" "+startDate+" "+endDate);
		
		stmt.executeUpdate();

		//get the assignment id for this
		//stmt1=dbcon.prepareStatement("SELECT assign_id FROM  assignmentInfo WHERE no_of_questions=? AND start_time=? AND end_time=? ");
		/*  		stmt1=dbcon.prepareStatement("SELECT MAX(assignment_id) as assignment_id FROM  assignment WHERE  start_time=to_timestamp(?,'dd-mm-yyyy hh24:mi:ss') AND end_time=to_timestamp(?,'dd-mm-yyyy hh24:mi:ss') ");
		 //stmt1.setInt(1, number);
		 stmt1.setString(1, startDate); //to_date('1963-09-01', 'YYYY-MM-DD')
		 stmt1.setString(2, endDate);
		
		 ResultSet rs1=stmt1.executeQuery();
		
		 while(rs1.next())
		 assignID=rs1.getInt("assignment_id"); */

	} catch (SQLException sep) {
		System.out.println("SQLException: " + sep);
		out.println("<p style=\"font-family:arial;color:red;font-size:14px;background-color:white;\"> "+sep.getMessage()+" </p>");
		err = true;
	} catch (Exception sep) {
		System.out.println("Exception: " + sep);
		out.println("<p style=\"font-family:arial;color:red;font-size:14px;background-color:white;\"> Error: "+sep.getLocalizedMessage()+" </p>");
		err = true;
	}
	
	
	
	if (!err){
	BufferedReader br = null;
	String str = "";			
	
					try {
			 
						String sCurrentLine;
			 
						br = new BufferedReader(new FileReader(file));
						str += " <table   id=\"queryTable\"> <tr> <th > <label class=\"field\">Question ID</label></th>			<th >  <label class=\"field\"> Question Description </label></th>  	<th>  <label class=\"field\"> Marks</label></th>	<th> <label class=\"field\"> Additional Options</label><input type=\"hidden\" id=\"assgnID\" name=\"assgnID\" value=\""+assignID+"\"></th>	</tr> ";
						
						if ((sCurrentLine = br.readLine()) != null) {
							System.out.println("Assignment Details New: "+sCurrentLine);
							JSONParser parser = new JSONParser();
							boolean first = true;
							int j=2;
							int i=1;
							
							try {
								while ((sCurrentLine = br.readLine()) != null) {
									
									
									
								Object obj = parser.parse(sCurrentLine);
								JSONObject jsonObject = (JSONObject) obj;
								
																
								if (jsonObject.size()>6)
								{
								String course_id = (String) jsonObject.get("course_id");
								// out.println(course_id);
						 
								long assignment_id = (Long) jsonObject.get("assignment_id");
								// out.println(assignment_id);
							
								long qID = (Long) jsonObject.get("question_id");
								// out.println(qID);
																
								long schema_id = (Long) jsonObject.get("schema_id");
								// out.println(schema_id);
								
								long marks = (Long) jsonObject.get("total_marks");
								// out.println(marks);
								
								boolean learningmode = (Boolean) jsonObject.get("learning_mode");
								// out.println(learningmode);
								
								boolean ignoreduplicates = (Boolean) jsonObject.get("ignore_duplicates");
								// out.println(ignoreduplicates);
								
								boolean matchallqueries = (Boolean) jsonObject.get("match_all_queries");
								// out.println(matchallqueries);
								
								String desc = "";
								
								System.out.println("===Creating row: Question "+qID + ":  Description:"+desc+"   Correct Query:");
								System.out.println("Learning mode: "+learningmode + "   ignoreduplicates:"+ignoreduplicates+ "   matchallqueries:"+matchallqueries);
								str += " <tr id=\""+qID+"\" class =\"row "+qID+"\">	<td><label id=\"qID"+qID+"\" name=\"qlabel "+qID+"\"> Question: "+qID+"<br></label><input type=\"button\" name=\"closequestionbutton "+qID+"\" id=\"closequestionbutton "+qID+"\" onClick=\"closeQuestion(this, 'queryTable')\" value=\"Delete Question\" ><br><input type=\"button\" name=\"moveupbutton "+qID+"\" id=\"moveupbutton "+qID+"\" onClick=\"moveRowUp(this, 'queryTable')\" value=\"Move Up\" ><br><input type=\"button\" name=\"movedownbutton "+qID+"\" id=\"movedownbutton "+qID+"\" onClick=\"moveRowDown(this, 'queryTable')\" value=\"Move Down\" ></td>"+
										"<td><textarea name=\"question "+qID+"\" id=\"question "+qID+"\" rows=\"6\" cols=\"35\">"+desc+"</textarea> </td> 	<td><textarea name=\"marks "+qID+"\" id=\"marks "+qID+"\" rows=3 cols=\"20\">"+marks+"</textarea></td>"; 
								
								str += " <td> ";
								if (qID==1) {
									if (learningmode)
										str +=	" Learning Mode <br> <input type=\"radio\" name=\"learningmode\" id=\"leaningmodeY "+qID+"\" value=\"Yes\" checked>Yes <input type=\"radio\" name=\"learningmode\" id=\"leaningmodeN "+qID+"\" value=\"No\">No "; 
									else 
										str +=	" Learning Mode <br> <input type=\"radio\" name=\"learningmode\" id=\"leaningmodeY "+qID+"\" value=\"Yes\" >Yes <input type=\"radio\" name=\"learningmode\" id=\"leaningmodeN "+qID+"\" value=\"No\" checked >No ";
								}
								
								if (ignoreduplicates)
									str += " <br>	  Ignore Duplicates <br> <input type=\"radio\" name=\"ignoreduplicates"+qID+"\" id=\"ignoreduplicatesY "+qID+"\" value=\"Yes\" checked >Yes <input type=\"radio\" name=\"ignoreduplicates"+qID+"\" id=\"ignoreduplicatesN "+qID+"\" value=\"No\">No ";
								else
									str += " <br>	  Ignore Duplicates <br> <input type=\"radio\" name=\"ignoreduplicates"+qID+"\" id=\"ignoreduplicatesY "+qID+"\" value=\"Yes\">Yes <input type=\"radio\" name=\"ignoreduplicates"+qID+"\" id=\"ignoreduplicatesN "+qID+"\" value=\"No\" checked >No ";
									
								if (matchallqueries)
									str +=	"<br>	  Match All Queries <br> <input type=\"radio\" name=\"matchqueries"+qID+"\" id=\"matchallqueriesY "+qID+"\" value=\"Yes\" checked >Yes <input type=\"radio\" name=\"matchqueries"+qID+"\" id=\"matchallqueriesN "+qID+"\" value=\"No\">No </td> </tr> ";
								else
									str +=	"<br>	  Match All Queries <br> <input type=\"radio\" name=\"matchqueries"+qID+"\" id=\"matchallqueriesY "+qID+"\" value=\"Yes\">Yes <input type=\"radio\" name=\"matchqueries"+qID+"\" id=\"matchallqueriesN "+qID+"\" value=\"No\" checked >No </td> </tr> ";
									
								
								
								first = true;
								
								
								
								
								
								}
								else
								{
									String course_id = (String) jsonObject.get("course_id");
									// out.println(course_id);
							 
									long assignment_id = (Long) jsonObject.get("assignment_id");
									// out.println(assignment_id);
								
									long qID = (Long) jsonObject.get("question_id");
									// out.println(qID);
																	
									long query_id = (Long) jsonObject.get("query_id");
									// out.println(query_id);
									
									String desc = (String) jsonObject.get("query_desc");
									// out.println(desc);
									
									String correctQuery = (String) jsonObject.get("correct_query");
									// out.println(correctQuery);
									
									
									if (first){
									String buttonName = "button 1 "+"+qID+";
									j = 2;
									str += " <tr id=\""+qID+"\" class =\"row "+qID+"\"> "+ 
											"<td> </td>"+
											"<td> <label> Correct Query </label></td>"+
											"<td><textarea id=\"query "+qID+" 1\" class = \"query "+qID+"\" name = \"query"+qID+"\" rows=\"6\" cols=\"35\" >"+correctQuery+"</textarea></td>"+
											"<td><input type=\"button\" id=\"button "+qID+"\" name=\""+ buttonName+ " \" 	 value=\"Update Query\" onclick=\"report(this,1)\"> <br/>"+
											"<input type=\"button\" id=\"button1 "+qID+"\" onClick=\"addCorrectQuery(this, 'queryTable')\" value=\"Add More Correct Queries\" > <input type=\"hidden\" name=\"qID\" id=\"qID "+qID+"\" value=\""+qID+"\"></td></tr>";
											first = false;
									}
									else
									{	
											
									System.out.println("      Creating row: Question "+qID + ":  Description:"+desc+"   Correct Query:" + correctQuery);
									str += " <tr id=\""+qID+"\" class =\"row "+qID+"\"> "+ 
											"<td> </td>"+
											"<td> </td>"+
											"<td><textarea id=\"query "+qID+" "+j+"\" class = \"query "+qID+"\" name = \"query"+qID+"\" rows=\"6\" cols=\"35\" >"+correctQuery+"</textarea>"+
											"<input type=\"button\" id=\"closequery "+qID+" "+j+"\" onClick=\"closeButton(this, 'queryTable')\" value=\"close\" > </td></tr>";
									j = j+1;				
									}
								}
								}
								
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
	
	/*
	
	if (!err)
	{	
	String str = ""; // ="<form action=\"AssignmentChecker\" id=\"myForm\"> "+"\n";
	//str +="<input type=\"hidden\" name=\"query\" >";
	//str +="<input type=\"hidden\" name=\"assignment_id\"> ";
	//str +="<input type=\"hidden\" name=\"question_id\" >";

	str += " <table   id=\"queryTable\"> <tr> <th > <label class=\"field\">Question ID</label></th>			<th >  <label class=\"field\"> Question Description </label></th>  	<th>  <label class=\"field\"> Marks</label></th>	<th> <label class=\"field\"> Additional Options</label><input type=\"hidden\" id=\"assgnID\" name=\"assgnID\" value=\""+assignID+"\"></th>	</tr> ";
	
	try {
	PreparedStatement stmt1;
	//stmt = dbcon.prepareStatement("SELECT * FROM  qinfo ,assignment where qinfo.assignment_id=? AND qinfo.assignment_id=assignment.assignment_id");
	stmt1 = dbcon
			.prepareStatement("SELECT queries.question_id, queries.query_desc, queries.correct_query, query_info.total_marks, query_info.learning_mode, query_info.ignore_duplicates, query_info.match_all_queries FROM  queries, query_info  where queries.assignment_id=? and queries.assignment_id=query_info.assignment_id and queries.course_id=? and queries.course_id=query_info.course_id and queries.question_id = query_info.question_id order by queries.question_id;");
	stmt1.setInt(1, Integer.valueOf(oldAssignID));
	stmt1.setString(2, oldCourseID);
	ResultSet rs1 = stmt1.executeQuery();
	
	System.out.println("Made DB connection... for Assign:"+oldAssignID+" Course:"+oldCourseID);
	
	String oldqID="";
	int j=2;
	int i=1;
	while (rs1.next()) {

		String qID = rs1.getString("question_id");
		String desc = rs1.getString("query_desc");
		String correctQuery = rs1.getString("correct_query");
		String marks = rs1.getString("total_marks");
		Boolean learningmode = rs1.getBoolean("learning_mode");
		Boolean ignoreduplicates = rs1.getBoolean("ignore_duplicates");
		Boolean matchallqueries = rs1.getBoolean("match_all_queries");
	
		
		if (!oldqID.equals(qID)) {
			System.out.println("===Creating row: Question "+qID + ":  Description:"+desc+"   Correct Query:" + correctQuery);
			System.out.println("Learning mode: "+learningmode + "   ignoreduplicates:"+ignoreduplicates+ "   matchallqueries:"+matchallqueries);
			str += " <tr id=\""+qID+"\" class =\"row "+qID+"\">	<td><label id=\"qID"+qID+"\" name=\"qlabel "+qID+"\"> Question: "+qID+"</label><input type=\"button\" name=\"closequestionbutton "+qID+"\" id=\"closequestionbutton "+qID+"\" onClick=\"closeQuestion(this, 'queryTable')\" value=\"Delete Question\" ><input type=\"button\" name=\"moveupbutton "+qID+"\" id=\"moveupbutton "+qID+"\" onClick=\"moveRowUp(this, 'queryTable')\" value=\"Move Up\" ><input type=\"button\" name=\"movedownbutton "+qID+"\" id=\"movedownbutton "+qID+"\" onClick=\"moveRowDown(this, 'queryTable')\" value=\"Move Down\" ></td>"+
					"<td><textarea name=\"question "+qID+"\" id=\"question "+qID+"\" rows=\"6\" cols=\"35\">"+desc+"</textarea> </td> 	<td><textarea name=\"marks "+qID+"\" id=\"marks "+qID+"\" rows=3 cols=\"20\">"+marks+"</textarea></td>"; 
			
			str += " <td> ";
			if (qID.equals("1")) {
				if (learningmode)
					str +=	" Learning Mode <br> <input type=\"radio\" name=\"learningmode\" id=\"leaningmodeY "+qID+"\" value=\"Yes\" checked>Yes <input type=\"radio\" name=\"learningmode\" id=\"leaningmodeN "+qID+"\" value=\"No\">No "; 
				else 
					str +=	" Learning Mode <br> <input type=\"radio\" name=\"learningmode\" id=\"leaningmodeY "+qID+"\" value=\"Yes\" >Yes <input type=\"radio\" name=\"learningmode\" id=\"leaningmodeN "+qID+"\" value=\"No\" checked >No ";
			}
			
			if (ignoreduplicates)
				str += " <br>	  Ignore Duplicates <br> <input type=\"radio\" name=\"ignoreduplicates"+qID+"\" id=\"ignoreduplicatesY "+qID+"\" value=\"Yes\" checked >Yes <input type=\"radio\" name=\"ignoreduplicates"+qID+"\" id=\"ignoreduplicatesN "+qID+"\" value=\"No\">No ";
			else
				str += " <br>	  Ignore Duplicates <br> <input type=\"radio\" name=\"ignoreduplicates"+qID+"\" id=\"ignoreduplicatesY "+qID+"\" value=\"Yes\">Yes <input type=\"radio\" name=\"ignoreduplicates"+qID+"\" id=\"ignoreduplicatesN "+qID+"\" value=\"No\" checked >No ";
				
			if (matchallqueries)
				str +=	"<br>	  Match All Queries <br> <input type=\"radio\" name=\"matchqueries"+qID+"\" id=\"matchallqueriesY "+qID+"\" value=\"Yes\" checked >Yes <input type=\"radio\" name=\"matchqueries"+qID+"\" id=\"matchallqueriesN "+qID+"\" value=\"No\">No </td> </tr> ";
			else
				str +=	"<br>	  Match All Queries <br> <input type=\"radio\" name=\"matchqueries"+qID+"\" id=\"matchallqueriesY "+qID+"\" value=\"Yes\">Yes <input type=\"radio\" name=\"matchqueries"+qID+"\" id=\"matchallqueriesN "+qID+"\" value=\"No\" checked >No </td> </tr> ";
				
			String buttonName = "button 1 "+"+qID+";
			j = 2;
			str += " <tr id=\""+qID+"\" class =\"row "+qID+"\"> "+ 
					"<td> </td>"+
					"<td> <label> Correct Query </label></td>"+
					"<td><textarea id=\"query "+qID+" 1\" class = \"query "+qID+"\" name = \"query"+qID+"\" rows=\"6\" cols=\"35\" >"+correctQuery+"</textarea></td>"+
					"<td><input type=\"button\" id=\"button "+qID+"\" name=\""+ buttonName+ " \" 	 value=\"Update Query\" onclick=\"report(this,1)\"> <br/>"+
					"<input type=\"button\" id=\"button1 "+qID+"\" onClick=\"addCorrectQuery(this, 'queryTable')\" value=\"Add More Correct Queries\" > <input type=\"hidden\" name=\"qID\" id=\"qID "+qID+"\" value=\""+qID+"\"></td></tr>";
		}
		else {
			System.out.println("      Creating row: Question "+qID + ":  Description:"+desc+"   Correct Query:" + correctQuery);
			str += " <tr id=\""+qID+"\" class =\"row "+qID+"\"> "+ 
					"<td> </td>"+
					"<td> </td>"+
					"<td><textarea id=\"query "+qID+" "+j+"\" class = \"query "+qID+"\" name = \"query"+qID+"\" rows=\"6\" cols=\"35\" >"+correctQuery+"</textarea>"+
					"<input type=\"button\" id=\"closequery "+qID+" "+j+"\" onClick=\"closeButton(this, 'queryTable')\" value=\"close\" > </td></tr>";
					
			j = j+1;
		}
		// System.out.println("==created a row==");
		oldqID = qID;	
	}
} catch (Exception err1) {
	err1.printStackTrace();
	out.println("Error in retriveing query details");
}
*/
	//form validation code end
	//out.println("<title>Creating New Assignment</title>");
	out.println("</head>");
	out.println("<body id=\"public\">");

	out.println("<form class=\"updateQuery\" name=\"updateQuery\" action=\"updateQuery.jsp\" method=\"post\" onsubmit=\"return(validate());\" >");

	out.println("<p class=\"required\">* Required</p>"
			+ "<div class=\"fieldset\">" + "<fieldset>"
			+ "<legend> Edit Quesions: Assignment Import</legend>");

	out.println("<p><label class=\"field\">Asssignment ID: " + assignID
			+ "</label></p>");

	out.println("<p><label class=\"field\">Edit question/query details </p>");
	//String ht="alert ("+str+")";
	out.println(str);

	out.println(" </table> "+"<input type=\"button\" id=\"quer\" onClick=\"addRow('queryTable')\" value=\"New Question\" > &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
	out.println("<input type=\"submit\" name=\"submission\" value=\"Submit\"><br>");

	out.println("</fieldset></div>");
	out.println("</form>");
	}
	else
		out.println("<div class=\"wrapper\">	<input type=\"button\" onclick=\"history.back();\" align=\"middle\" value=\"Back\"></div>");
	
	//	out.println("</body>");
%>

</body>
</html>