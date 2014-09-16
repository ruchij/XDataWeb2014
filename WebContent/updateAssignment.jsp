<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.io.*"%>
<%@page import="java.text.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@page import="database.UpdateServlet"%>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Create Assignment</title>
<script type="text/javascript" src="scripts/newrow.js"></script>
<script type="text/javascript" src="scripts/wufoo.js"></script>
<script type="text/javascript" src="scripts/ManageQuery.js"></script>

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
	String description = (String) request.getParameter("description");
	String courseId = (String) request.getSession().getAttribute(
			"context_label");

	String dbPassword = "testing2";
	String dbuserName = "testing2";
	String jdbcUrl = "";
	String dbType = "";
	String schemaId = "";
	String assignID = (String) request.getSession().getAttribute(
			"resource_link_id");

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
	
	/**FIXME: update the data base properties for this assignment for this assignmnet, courseid*/
	

	//get database properties
	DatabaseProperties dbp = new DatabaseProperties();
	String username = dbp.getUsername1(); //change user name according to your db user -testing1
	String username2 = dbp.getUsername2();//This is for testing2
	String passwd = dbp.getPasswd1(); //change user passwd according to your db user passwd
	String passwd2 = dbp.getPasswd2();
	String hostname = dbp.getHostname();
	String dbName = dbp.getDbName();
	String port = dbp.getPortNumber();

	//get the assignment ID after updating the assignment table
	//int assignID=0;

	Connection dbcon = null;

	dbcon = (new DatabseConnection()).dbConnection(hostname, dbName,
			username, passwd, port);

	try {
		PreparedStatement stmt, stmt1;
		//insert into assignment
		stmt = dbcon
				.prepareStatement("INSERT INTO assignment VALUES (?,?, ?, ?, ?, ?, ?, ?, to_timestamp(?,'dd-mm-yyyy hh24:mi:ss'),to_timestamp(?,'dd-mm-yyyy hh24:mi:ss'))");

		stmt.setString(1, courseId);
		/**FIXME: Change this*/
		stmt.setString(2, assignID);
		stmt.setString(3, description);
		stmt.setString(4, dbType);
		stmt.setString(5, jdbcUrl);
		stmt.setString(6, dbuserName);
		stmt.setString(7, dbPassword);
		stmt.setString(8, schemaId);
		stmt.setString(9, startDate);
		stmt.setString(10, endDate);
		//stmt.setString(10,"NC");

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
		System.out.println("Could not connect to database: " + sep);
		//System.exit(1);
	}
	finally{
		dbcon.close();
	}

	String str = "";//="<form action=\"AssignmentChecker\" id=\"myForm\"> "+"\n";
	//str +="<input type=\"hidden\" name=\"query\" >";
	//str +="<input type=\"hidden\" name=\"assignment_id\"> ";
	//str +="<input type=\"hidden\" name=\"question_id\" >";

	str += "<table  cellspacing=\"10\"  align=\"center\" class=\"authors-list\" id=\"queryTable\"> <tr> <th > <label class=\"field\">QueStion ID</label></th> <th >  <label class=\"field\"> Question Description </label></th>  <th > <label class=\"field\">Correct Query </label></th> <th></th> <th></th></tr>"
			+ "\n";

	//for(int i=0;i<number;i++){
	str = str
			.concat("<tr id=\"1\" class =\"1\"> <td><p name=\"qID\">Question: 1</label></td>"
					+ "\n");
	str += "<td><textarea name=\"quesTxt1\" id=\"quesTxt1\" rows=\"6\" cols=\"35\"> </textarea> </td> "
			+ "\n";
	str = str
			.concat(" <td><textarea id=\"query 1 1\" class = \"query1\" name = \"query1\" rows=\"6\" cols=\"35\" ></textarea></td>"
					+ "\n");
	//str = str.concat("<td> <nav><ul> <ol> <a href=\"javascript:void(0)\" onclick=\"submitter(this,'queryTable')\" id=\"button 1 1\">Generate DataSet</a> </ol> "+
	//				" <ol></ol> <a href=\"javascript:void(0)\" onClick=\"addCorrectQuery(this, 'queryTable')\" id=\"button 1 1\">Add Correct Query</a>  </ul> </nav> </td>");
	//str=str.concat("<td> <input type=\"button\" id=\"button 1 1\" value=\"Generate Dataset\" onclick=\"submitter(this,'queryTable')\"> </td>"+"\n");
	str = str
			.concat("<td> <input type=\"button\" id=\"button 1 "
					+ assignID
					+ "\" name=\"button 1 "
					+ assignID
					+ "\" value=\"Update Query\" onclick=\"report(this,1)\"> <br/>"
					+ "\n");
	str = str
			.concat("<input type=\"button\" id=\"button1 1\" onClick=\"addCorrectQuery(this, 'queryTable')\" value=\"Add More Correct Queries\" > <input type=\"hidden\" name=\"qID\" value=\"1\"></td> </tr>"
					+ "\n");
	str = str.concat("</table>");

	/*	
	out.println("<script type=\"text/javascript\" > ");
	
	
	 out.println("function getColumnMax(tableId, columnIndex) {");
	 out.println("var table = document.getElementById(tableId);");
	 out.println("var max = 1;");
	 out.println("for(var i = 2; i <= Number.MAX_VALUE; i++){");
	 out.println(" var list = document.getElementsByClassName(i);");
	 out.println(" if(list.length == 0) break;");
	 out.println(" max = i;");
	 out.println("}");
	 out.println("  return [max];");	
	 out.println("}");

	
	 out.println("");
	
	 //add a new row to table
	 out.println("function addRow(tableID) { ");
	
	 out.println("var table = document.getElementById(tableID);");
	 out.println("var rowCount = table.rows.length;");
	 out.println("var row = table.insertRow(rowCount);");
	 out.println("var ids = getColumnMax(tableID, 0) ;");
	 out.println("var id = ids[0] + parseInt(1); ");
	 out.println("row.id = id;");
	 out.println("row.className = id; ");
	
	 out.println("var cell1 = row.insertCell(0);");
	 out.println("var element1 = document.createElement(\"input\"); ");
	 out.println("element1.type=\"number\" ;");
	 out.println("element1.name=\"qID\" ;");
	 out.println("element1.size=\"4\" ;");	
	 out.println("element1.value = id; ");
	 out.println(" var qid=\"qID\".concat(id);");
	 out.println("element1.id=qid; ");
	 //out.println("alert(\"element1: \"+element1.id);");
	 out.println("element1.setAttribute('readOnly','readonly');");
	 out.println("cell1.appendChild(element1); ");
	
	 out.println("var cell2 = row.insertCell(1); ");
	 out.println("var element2 = document.createElement(\"textarea\"); ");
	 out.println("element2.type=\"textarea\" ;");
	 out.println("element2.name=\"quesTxt\".concat(id) ;");
	 out.println("element2.rows=\"6\" ;");
	 out.println("element2.cols=\"35\" ;");
	 out.println("cell2.appendChild(element2); ");
	 //add third cell
	 out.println("var cell3 = row.insertCell(2); ");
	 out.println("var element3 = document.createElement(\"textarea\"); ");
	 out.println("element3.type=\"textarea\" ;");	
	 out.println(" var quer=\"query\".concat(id);");
	 out.println("element3.id = quer; ");
	 out.println("element3.className = quer; ");
	 out.println("element3.name= quer ;");
	 out.println("element3.rows=\"6\" ;");
	 out.println("element3.cols=\"35\" ;");
	 out.println("cell3.appendChild(element3); ");
	 //out.println("cell2.innerHTML =<textarea name=\"quesTxt\" rows=\"6\" cols=\"57\" ></textarea>; ");
	
	 out.println("");
	
	
	
	 //add fifth cell
	 out.println("var cell4 = row.insertCell(3); ");
	 out.println("var buttonnode= document.createElement('input');");
	 out.println("buttonnode.setAttribute('type','button');");
	 out.println("buttonnode.setAttribute('name','generte');");
	 out.println("buttonnode.setAttribute('value','Generate Dataset');");
	 out.println("buttonnode.setAttribute('id',\"button \".concat(id));");
	 //out.println("buttonnode.onClick = submitter(this,'queryTable');");
	 //out.println("buttonnode.setAttribue('onclick','submitter(this,\"'+tableID+'\")' ");
	 out.println(" buttonnode.setAttribute('onclick','submitter(this,\"'+tableID+'\")' );");
	 out.println("cell4.appendChild(buttonnode);");
	
	 //add fifth cell
	 out.println("var cell5 = row.insertCell(4); ");
	 out.println("var button= document.createElement('input');");
	 out.println("button.setAttribute('type','button');");
	 out.println("button.setAttribute('name','correctQuery');");
	 out.println("button.setAttribute('value','Add More Correct Queries ');");
	 out.println("button.setAttribute('id',\"button1 \".concat(id));");
	 //out.println("buttonnode.onClick = submitter(this,'queryTable');");
	 //out.println("buttonnode.setAttribue('onclick','submitter(this,\"'+tableID+'\")' ");
	 out.println("button.setAttribute('onclick','addCorrectQuery(this,\"'+tableID+'\")' );");
	 out.println("cell5.appendChild(button);");
	
	 out.println("");
	
	 out.println("}");
	
	
	
	 out.println("function submitter(btn,tableID){");
	 out.println("var table = document.getElementById(tableID);");
	 out.println(" var quest = btn.id.split(\" \")[1];");
	 out.println(" var query = btn.id.split(\" \")[2];");
	 out.println(" var queryId = \"query \".concat(quest).concat(\" \").concat(query);");
	 //out.println(" var quer = \"query\".concat(quest);");
	 //out.println(" var Qid = \"qID\".concat(quest);");
	 //out.println("alert(Qid);");
	 //out.println(" var quer = \"query\".concat(quest);");
	 out.println("var asID = document.getElementById(\"AssID\").value;");
	 out.println("var correctQuery = document.getElementById(queryId).value; ");
	 //out.println("var qid = document.getElementById(Qid).value;");
	 String in = "AssignmentChecker?assignment_id=\"+asID+\"&question_id=\"+quest+\"&query_id=\"+query+\"&query=\"+correctQuery; ";
	 out.println("var out=\""+in+";");
	 out.println("window.open( out,\"Generating Dataset\",\"height=400,width=400\"); ");
	 out.println("}"); 
	
	 out.println(" "); 
	 ///Add a new correct query
	 out.println("function addCorrectQuery(btn,tableID){");
	
	 out.println("var table = document.getElementById(tableID);");
	 out.println("var rowCount = table.rows.length;");
	
    out.println("var cell3 = row.insertCell(3);");
    out.println("var cell3 = row.insertCell(3);");   
	out.println("var buttonnode= document.createElement('input');");
	out.println("buttonnode.setAttribute('type','button');");
	out.println("buttonnode.setAttribute('name','generte');");
	out.println("buttonnode.setAttribute('value','Generate Dataset');");
	out.println("buttonnode.setAttribute('id',\"button \".concat(rowId).concat(\" \").concat( parseInt(document.getElementsByClassName(rowId).length) + 1 ) );");
	out.println(" buttonnode.setAttribute('onclick','submitter(this,\"'+tableID+'\")' );");
	out.println("cell3.appendChild(buttonnode);");
	
	 //get maximum row of this query id
	 //	out.println("var ids =  getColumnMax(tableID, 0) ;");
	 //	out.println("var rowId = parseInt(ids[1])");
	 //remove below line and uncomment above two lines after fixing getcolumnmax
	 out.println("var rowId = parseInt( btn.id.split(\" \")[1] );");
	
	 //get the number of rows with each id <= rowId
	 out.println("var len = 0");
	 out.println("for (var i = 1; i <= rowId; i++) {");
	 out.println("  var list = document.getElementsByClassName(i);");
	 out.println("   len = parseInt(len) + parseInt(list.length);");
	 out.println("}");
	 out.println("var row = table.insertRow( parseInt(len) +1 );");
	 out.println("row.id = rowId;"); 
	 out.println("row.className = rowId;");
	 out.println("var cell0 = row.insertCell(0);");
	 out.println("var cell1 = row.insertCell(1);");
	
	 out.println("var cell2 = row.insertCell(2);");    
	 out.println("var element2 = document.createElement(\"textarea\"); ");
	 out.println("element2.type=\"textarea\" ;");
	 out.println("element2.id = \"query \".concat(rowId).concat(\" \").concat( parseInt(document.getElementsByClassName(rowId).length)  ) ;");
	 out.println(" var quer=\"query\".concat(rowId);");
	 out.println("element2.className = quer; ");
	 out.println("element2.name = quer ;");
	 out.println("element2.rows=\"6\" ;");
	 out.println("element2.cols=\"57\" ;");
	 out.println("cell2.appendChild(element2); ");
	
	
	 out.println("var cell3 = row.insertCell(3);");
	 out.println("var cell3 = row.insertCell(3);");   
	 out.println("var buttonnode= document.createElement('input');");
	 out.println("buttonnode.setAttribute('type','button');");
	 out.println("buttonnode.setAttribute('name','generte');");
	 out.println("buttonnode.setAttribute('value','Generate Dataset');");
	 out.println("buttonnode.setAttribute('id',\"button \".concat(rowId).concat(\" \").concat( parseInt(document.getElementsByClassName(rowId).length) + 1 ) );");
	 out.println(" buttonnode.setAttribute('onclick','submitter(this,\"'+tableID+'\")' );");
	 out.println("cell3.appendChild(buttonnode);");
	
	 out.println("var cell4 = row.insertCell(4);");
	 out.println("}");

	
	
	
	 out.println(" </script> "); */
	//form validation code end
	//out.println("<title>Creating New Assignment</title>");
	out.println("</head>");
	out.println("<body id=\"public\">");

	out.println("<form class=\"updateQuery\" name=\"updateQuery\" action=\"updateQuery.jsp\" method=\"post\" onsubmit=\"return(validate());\" >");

	out.println("<p class=\"required\">* Required</p>"
			+ "<div class=\"fieldset\">" + "<fieldset>"
			+ "<legend> Create a new assignment</legend>");

	out.println("<p><label class=\"field\">Asssignment ID: " + assignID
			+ "</label></p>");

	out.println("<p><label class=\"field\">Enter the query details one by one</p>");
	//String ht="alert ("+str+")";
	out.println(str);

	out.println("<input type=\"button\" id=\"quer\" onClick=\"addRow('queryTable')\" value=\"New Query\" > &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp");
	out.println("<input type=\"submit\" name=\"submission\" value=\"Submit\"><br>");

	out.println("</fieldset></div>");
	out.println("</form>");
	//	out.println("</body>");
%>

</body>
</html>