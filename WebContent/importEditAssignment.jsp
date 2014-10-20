<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>XData &middot; Assignment</title>



<!-- Meta Tags -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<!-- JavaScript -->
<script type="text/javascript" src="scripts/wufoo.js"></script>
<!-- <script src="jQuery.ui.datepicker.js"></script>
 <script src="jquery.ui.datepicker.mobile.js"></script>
-->


<!-- CSS -->
<link rel="stylesheet" href="css/structure.css" type="text/css" />
<link rel="stylesheet" href="css/form.css" type="text/css" />
<link rel="stylesheet" href="css/theme.css" type="text/css" />

<link rel="canonical"
	href="http://www.wufoo.com/gallery/designs/template.html">


<style>

/*Defaults Styling*/
html,body {
	background: #ccc;
	width: 80%;
	margin: 0 auto;
	border-style: none;
	border: none;
}

body {
	font: 12px/17px Arial, Helvetica, sans-serif;
	color: #333;
	background: #ccc;
	border: none;
}

fieldset {
	background: #f2f2e6;
	padding: 10px;
	border: 1px solid #fff;
	border-color: #fff #666661 #666661 #fff;
	margin-bottom: 36px;
}

textarea {
	font: 12px/12px Arial, Helvetica, sans-serif;
	padding: 0;
	display: inline-block;
	float: left;
	clear: left;
	text-align: left;
	margin-bottom: 11px;
}

select {
	font: 12px/12px Arial, Helvetica, sans-serif;
	padding: 0;
	display: inline-block;
	float: left;
	text-align: left;
	margin-bottom: 11px;
}

input {
	font: 15px/15px Arial, Helvetica, sans-serif;
	padding: 0;
	display: inline-block;
	float: left;
	clear: both;
	text-align: left;
	margin-bottom: 11px;
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
	font: 18px/18px Arial, Helvetica, sans-serif;
	font-weight: bold;
	color: #666;
	display: inline-block;
	float: left;
	clear: both;
	text-align: left;
	margin-bottom: 11px;
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
	background: #ccc;
	width: 80%;
	margin: 0 auto;
	border: none;
}

label span,.required {
	color: red;
	font-weight: bold;
	font-size: 17px;
	margin-bottom: 11px;
}

.required {
	text-align: left;
}

.assgnmentForm {
	margin: 0 auto;
	align: center;
}
</style>

<script type="text/javascript">
	function defaultDate() {
		var today = new Date();

		var smin = today.getMinutes();
		var shr = today.getHours();

		var dd = today.getDate();
		var mm = today.getMonth() + 1;

		var yyyy = today.getFullYear();
		today = dd + '-' + mm + '-' + yyyy;

		var ed = dd + 2;
		var em, eeee;

		if (parseInt(ed) > 28)
			em = mm + 1;
		else
			em = mm;

		if (parseInt(em) > 12)
			eeee = yyyy + 1;
		else
			eeee = yyyy;

		if (dd.toString().length == 1)
			dd = "0" + dd;

		if (mm.toString().length == 1)
			mm = "0" + mm;

		if (ed.toString().length == 1)
			ed = "0" + ed;

		if (em.toString().length == 1)
			em = "0" + em;

		if (shr.toString().length == 1)
			shr = "0" + shr;

		smin = parseInt(smin / 10) * 10;
		if(parseInt(smin) == 0)
			smin = "00";
	
		document.getElementById("startday").value = dd;
		document.getElementById("startmonth").value = mm;
		document.getElementById("startyear").value = yyyy;
		document.getElementById("starthour").value = shr;
		document.getElementById("startmin").value = smin;

		document.getElementById("endday").value = ed;
		document.getElementById("endmonth").value = em;
		document.getElementById("endyear").value = eeee;
		document.getElementById("endhour").value = shr;
		document.getElementById("endmin").value = smin;
		
		/* if (parseInt(shr) < 13) {
		document.getElementById("endampam").value = "0" + "0";
		document.getElementById("startampam").value = "0" + "0";
	} else {
		document.getElementById("endampam").value = "1" + "2";
		document.getElementById("startampam").value = "1" + "2";
	} */
	}

	function defaultTime() {
		var today = new Date();
		var smin = today.getMinutes();
		var shr = today.getHours();
		alert(shr + "-" + smin);

	}
</script>
</head>
<body id="public" onload="defaultDate()">




	<div>
			
		<form class="assgnmentForm" name="assignmentForm"
			action="importAssignmentQuestions.jsp" method="post" style="border: none">
			<p class="required">* Required</p>

			<div class="fieldset">
				<fieldset>
					<legend> Imported Assignment Details</legend>
					<%
					String oldAssignID = (String) request.getParameter("assignment_id");
					String oldCourseID = (String) request.getParameter("course_id");
					System.out.println("Assignment:"+oldAssignID+" Course:"+oldCourseID);
					String instructions = (new CommonFunctions()).getAssignmnetIinstructions(oldCourseID, oldAssignID);
					
					out.println(instructions);
					
					String description=(String) request.getParameter("description");
					String connection=(String) request.getParameter("connection_id");
					String schema=(String) request.getParameter("default_schema_id");
					String filename=(String) request.getParameter("file");
					
					System.out.println(" Description is "+ description);
					
					String output="";
					
					output += "</fieldset> <fieldset>"
								+ "<legend> Edit Imported Assignment</legend>"
								+ "<label><span>*</span><strong>Assignment Name/Id</strong></label>";
					
					output += "<textarea style=\"width: 50%; height: 10%;\" placeholder=\"Give a new name to assignment\" name=\"AssignID\" required></textarea>";
					output += "<label><span>*</span><strong>Assignment Description</strong></label>";
					output = output + "<textarea style=\"width: 60%; height: 50px;\" name=\"description\" required>"+description+"</textarea>";
					output += "<input type=\"hidden\" id=\"oldAssignID\" name=\"oldAssignID\" value=\""+oldAssignID+"\">";	
					output += "<input type=\"hidden\" id=\"oldCourseID\" name=\"oldCourseID\" value=\""+oldCourseID+"\">";
					output += "<input type=\"hidden\" id=\"filename\" name=\"filename\" value=\""+filename+"\">";
					String courseId = (String) request.getSession().getAttribute(
								"context_label");
						//get database properties
						DatabaseProperties dbp = new DatabaseProperties();
						String username = dbp.getUsername1();
						String username2 = dbp.getUsername2();
						String passwd = dbp.getPasswd1();
						String passwd2 = dbp.getPasswd2();
						String hostname = dbp.getHostname();
						String dbName = dbp.getDbName();

						//get the connection for testing1
						Connection dbcon = (new DatabseConnection()).dbConnection(hostname,
								dbName, username, passwd,"5432");

						try {

							PreparedStatement stmt;
							stmt = dbcon
									.prepareStatement("SELECT connection_id,connection_name FROM database_connection");
							// stmt.setString(1, courseId);

							// String output = "";
							ResultSet rs = stmt.executeQuery();
							
							output += "<label><span>*</span><strong>Database Connection</strong></label>  <select name=\"connID\" style=\"clear:both;\">";
							while (rs.next()) {
								output += " <option ";
								if (rs.getInt("connection_id")==Integer.parseInt(connection))
									output += "selected=\"selected\"";
								output += " value = \""
										+ rs.getInt("connection_id") + "\"> "
										+ rs.getInt("connection_id") + "-"
										+ rs.getString("connection_name") + " </option> ";
							}
							output += " </select>";
							out.println(output);
							
							output = "";
							
							stmt = dbcon
									.prepareStatement("SELECT schema_id,schema_name FROM schemainfo WHERE course_id = ?");
							stmt.setString(1, courseId);
							rs = stmt.executeQuery();
							
							while (rs.next()) {
								output += " <option ";
								if (rs.getInt("schema_id")==Integer.parseInt(schema))
									output += "selected=\"selected\"";
								output += " value = \"" + rs.getInt("schema_id")
										+ "\"> " + rs.getInt("schema_id") + "-"
										+ rs.getString("schema_name") + " </option> ";
							}
							//output +=" <option value = \"1\" required> 1-Test Schema</option> ";
							out.println("<label><span>*</span><strong>Database Schema</strong></label>  <select name=\"schemaID\" style=\"clear:both;\"> "
									+ output + "</select> ");
							
							
						} catch (Exception err) {

							err.printStackTrace();
							out.println("ERROR OCCURRED");
						}
					%>
					<%
					// putting in default values 
						
					
					%>
					
					
					<p>
						<label class="field"><span>*</span>Starts at: </label>
					</p>
					<select style="clear: both;" name="startday" id="startday" required>
						<option value="01">1</option>
						<option value="02">2</option>
						<option value="03">3</option>
						<option value="04">4</option>
						<option value="05">5</option>
						<option value="06">6</option>
						<option value="07">7</option>
						<option value="08">8</option>
						<option value="09">9</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23">23</option>
						<option value="24">24</option>
						<option value="25">25</option>
						<option value="26">26</option>
						<option value="27">27</option>
						<option value="28">28</option>
						<option value="29">29</option>
						<option value="30">30</option>
						<option value="31">31</option>
					</select> &nbsp <select name="startmonth" id="startmonth" required>
						<option value="01">January</option>
						<option value="02">February</option>
						<option value="03">March</option>
						<option value="04">April</option>
						<option value="05">May</option>
						<option value="06">June</option>
						<option value="07">July</option>
						<option value="08">August</option>
						<option value="09">September</option>
						<option value="10">October</option>
						<option value="11">November</option>
						<option value="12">December</option>
					</select> &nbsp <select name="startyear" id="startyear" required>
						<option value="2012">2012</option>
						<option value="2013">2013</option>
						<option value="2014">2014</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2017">2017</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
					</select> &nbsp
					<!-- <label><strong>Start Time</strong></label> <br />  -->
					<!-- <input type="datetime"  name="starttime" placeholder="HH:MM:SS(24hr)"><br/> -->
					<select name="starthour" id="starthour" required>

						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>


					</select> &nbsp <select name="startmin" id="startmin" required>
						<option value="00">00</option>
						<option value="10">10</option>
						<option value="20">20</option>
						<option value="30">30</option>
						<option value="40">40</option>
						<option value="50">50</option>
					</select> &nbsp <select name="startampm" id="startampm" required>
						<option value="00">AM</option>
						<option value="12">PM</option>
					</select> <label class="field"><span>*</span><strong>Ends
							at </strong></label>
					<!--  <input type="datetime"  name="enddate" placeholder="DD-MM-YYYY"><br/> -->

					<select style="clear: both;" name="endday" id="endday" required>
						<option value="01">1</option>
						<option value="02">2</option>
						<option value="03">3</option>
						<option value="04">4</option>
						<option value="05">5</option>
						<option value="06">6</option>
						<option value="07">7</option>
						<option value="08">8</option>
						<option value="09">9</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
						<option value="13">13</option>
						<option value="14">14</option>
						<option value="15">15</option>
						<option value="16">16</option>
						<option value="17">17</option>
						<option value="18">18</option>
						<option value="19">19</option>
						<option value="20">20</option>
						<option value="21">21</option>
						<option value="22">22</option>
						<option value="23">23</option>
						<option value="24">24</option>
						<option value="25">25</option>
						<option value="26">26</option>
						<option value="27">27</option>
						<option value="28">28</option>
						<option value="29">29</option>
						<option value="30">30</option>
						<option value="31">31</option>
					</select> &nbsp <select name="endmonth" id="endmonth" required>
						<option value="01">January</option>
						<option value="02">February</option>
						<option value="03">March</option>
						<option value="04">April</option>
						<option value="05">May</option>
						<option value="06">June</option>
						<option value="07">July</option>
						<option value="08">August</option>
						<option value="09">September</option>
						<option value="10">October</option>
						<option value="11">November</option>
						<option value="12">December</option>
					</select> &nbsp <select name="endyear" id="endyear" required>
						<option value="2012">2012</option>
						<option value="2013">2013</option>
						<option value="2014">2014</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2017">2017</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
					</select> &nbsp
					<!-- <label><strong>End Time</strong></label> <br /> -->
					<!--  <input type="datetime"  name="endtime" placeholder="HH:MM:SS(24hr)"><br/> -->
					<select name="endhour" id="endhour" required>

						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>

					</select> &nbsp <select name="endmin" id="endmin" required>
						<option value="00">00</option>
						<option value="10">10</option>
						<option value="20">20</option>
						<option value="30">30</option>
						<option value="40">40</option>
						<option value="50">50</option>

					</select> &nbsp <select name="endampm" id="endampm" required>
						<option value="00">AM</option>
						<option value="12">PM</option>
						<br />
						<br />
						<input type="submit" value="Submit">
				</fieldset>		
			</div>
		</form>

	</div>

	<!--container-->

</body>
</html>