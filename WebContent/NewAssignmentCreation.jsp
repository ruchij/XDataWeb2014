<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabaseConnection"%>
<%@page import="database.DatabaseProperties"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
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
<link rel="canonical"
	href="http://www.wufoo.com/gallery/designs/template.html">
<style>


.fieldset fieldset{
	padding-left: 30px;
	padding-top:30px;
}

.fieldset div label{
	float:left;
	width: 250px;
}

.fieldset div{
	margin-bottom: 20px;
	height:20px;
	width:100%;
}

.fieldset div input{
	width: 400px;
	height: 20px;
	float:left;
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
			action="updateAssignment.jsp" method="post" style="border: none">
			<div class="fieldset">
				<fieldset>
					<legend> Create a new assignment</legend>
					
					<div>	
						<label>Assignment Name/Id</label>
						<input placeholder="Give name of this assignment" name="description"
							required/> <input style="width:30px" type="checkbox" name="interactive"/>
							<label style="margin-top:5px;">Interactive</label>
					</div>
					
					<div>
					<label>Assignment Description</label>
					<input placeholder="Give description of this assignment" name="description" required/>
					</div>
					<%
						if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
										response.sendRedirect("index.html");
										return;
									}
									
									String courseId = (String) request.getSession().getAttribute(
											"context_label");

									//get the connection for testing1
									Connection dbcon = (new DatabaseConnection()).graderConnection();

									try {

										PreparedStatement stmt;
										stmt = dbcon
												.prepareStatement("SELECT connection_id,connection_name FROM database_connection WHERE course_id = ?");
										stmt.setString(1, courseId);

										String output = "";
										ResultSet rs = stmt.executeQuery();
										while (rs.next()) {
											output += " <option value = \""
													+ rs.getInt("connection_id") + "\"> "
													+ rs.getInt("connection_id") + "-"
													+ rs.getString("connection_name") + " </option> ";
										}
										
										rs.close();

										out.println("<div><label>Database Connection</label>  <select name=\"dbConnection\" style=\"clear:both;\"> "
												+ output + "</select></div>");
										
										output = "";
										
										stmt = dbcon
												.prepareStatement("SELECT schema_id,schema_name FROM schemainfo WHERE course_id = ?");
										stmt.setString(1, courseId);
										/* rs = stmt.executeQuery();
										
										while (rs.next()) {
											output += " <option value = \"" + rs.getInt("schema_id")
													+ "\"> " + rs.getInt("schema_id") + "-"
													+ rs.getString("schema_name") + " </option> ";
										}  */
										output +="<option value = \"1\" required> 1-Test Schema</option> ";
										out.println("<div><label>Database Schema</label>  <select name=\"schemaid\" style=\"clear:both;\"> "
												+ output + "</select></div>");
										
										
									} catch (Exception err) {

										err.printStackTrace();
										out.println("ERROR OCCURRED");
									}
									finally{
										dbcon.close();
									}
					%>
					<div>
						<label class="field">Starts at: </label>
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
					</select>
					<select name="startmonth" id="startmonth" required>
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
					</select>
					<select name="startyear" id="startyear" required>
						<option value="2012">2012</option>
						<option value="2013">2013</option>
						<option value="2014">2014</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2017">2017</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
					</select>
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


					</select>
					<select name="startmin" id="startmin" required>
						<option value="00">00</option>
						<option value="10">10</option>
						<option value="20">20</option>
						<option value="30">30</option>
						<option value="40">40</option>
						<option value="50">50</option>
					</select> 
					<select name="startampm" id="startampm" required>
						<option value="00">AM</option>
						<option value="12">PM</option>
					</select> 
					</div>
					
					<div>
					<label class="field">Ends at </label>
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
					</select>
					<select name="endmonth" id="endmonth" required>
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
					</select>
					<select name="endyear" id="endyear" required>
						<option value="2012">2012</option>
						<option value="2013">2013</option>
						<option value="2014">2014</option>
						<option value="2015">2015</option>
						<option value="2016">2016</option>
						<option value="2017">2017</option>
						<option value="2018">2018</option>
						<option value="2019">2019</option>
						<option value="2020">2020</option>
					</select>
					
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

					</select>
					<select name="endmin" id="endmin" required>
						<option value="00">00</option>
						<option value="10">10</option>
						<option value="20">20</option>
						<option value="30">30</option>
						<option value="40">40</option>
						<option value="50">50</option>
					</select>
					
					<select name="endampm" id="endampm" required>
						<option value="00">AM</option>
						<option value="12">PM</option>
					</select>
					</div>
					
					<input type="submit" value="Submit">
				</fieldset>
			</div>
		</form>

	</div>

	<!--container-->

</body>
</html>