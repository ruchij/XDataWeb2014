<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@page import="java.sql.*"%>
<%@page import="database.DatabseConnection"%>
<%@page import="database.DatabaseProperties" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>
XData &middot; Assignment
</title>



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

<link rel="canonical" href="http://www.wufoo.com/gallery/designs/template.html">


</head>
<body id="public">

<div id="container">


<form class="wufoo" name="assignmentForm" action="updateAssignment.jsp" method="post" > <!-- onsubmit="return(validate());"> -->

<!--  Name: <input type="text" name="usrname"> -->
<br />
<br/>

<label><strong>Assignment Description</strong></label> <br />
		<textarea style="width: 400px; height: 20px;" placeholder="Give description of this assignment, if any" name="description"></textarea>		
 <br />
<br/>

<label><strong>Database Type</strong></label> <br />
		<select name="databaseType" required>
		<option value="01">PostgreSqll(default)</option>
		<option value="02">MySql</option>
		<option value="03">Oracle</option>
		</select>
 <br />
<br/>

<%
	//get database properties
	DatabaseProperties dbp = new DatabaseProperties();
	String username = dbp.getUsername1(); //change user name according to your db user -testing1
	String username2 = dbp.getUsername2();//This is for testing2
	String passwd = dbp.getPasswd1(); //change user passwd according to your db user passwd
	String passwd2 = dbp.getPasswd2();
	String hostname = dbp.getHostname();
	String dbName = dbp.getDbName();
	String port = dbp.getPortNumber();
	
	//get the connection for testing1
    Connection dbcon=(new DatabseConnection()).dbConnection(hostname, dbName, username, passwd, port);
	
	try{
		
		PreparedStatement stmt;
    	stmt = dbcon.prepareStatement("SELECT schema_id,schema_name FROM schemainfo WHERE course_id = ?");
    	stmt.setString(1, "CS-101");/**FIXME: Change this*/
		
    	String output = "";
    	ResultSet rs = stmt.executeQuery();
    	while(rs.next())
    	{
    		output += " <option value = \""+rs.getInt("schema_id")+"\"> "+ rs.getInt("schema_id")+"-"+rs.getString("schema_name") +" </option> ";
    	}
    	
    	rs.close();    	
    	
    	out.println("<label><strong>Database Schema</strong></label> <br /> <select name=\"schemaid\" required> " + output+"</select> <br /> <br/>");
	}
	catch (Exception err) {
		
		err.printStackTrace();
	}
	finally{
		dbcon.close();
	}
%>

<label><strong>JDBC URL</strong></label> <br />
	<textarea style="width: 400px; height: 20px;" placeholder="Specify JDBC Url, if any" name="jdbcurl"></textarea>
 <br />
<br/>

<label><strong>Database User Name</strong></label><br /> 
	<textarea style="width: 400px; height: 20px;" placeholder="Specify database user name, if any" name="dbuserName"></textarea>
 <br />
<br/>

<label><strong>Database Password</strong></label> <br /> <input type="password" name="dbPassword" placeholder="Give Password">
<br />
<br />

<label><strong>Open Assignment</strong></label> <br />
			<!-- <input type="datetime"  name="startdate" placeholder="DD-MM-YYYY"><br/>-->
			<select name="startday" required>
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
			&nbsp
			<select name="startmonth" required>
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
			&nbsp
			
			<select name="startyear" required>
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
	&nbsp
<!-- <label><strong>Start Time</strong></label> <br />  -->
			<!-- <input type="datetime"  name="starttime" placeholder="HH:MM:SS(24hr)"><br/> -->
			<select name="starthour" required>
			
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
			&nbsp
			<select name="startmin" required>
			<option value="00">00</option>
			<option value="10">10</option>
			<option value="20">20</option>
			<option value="30">30</option>
			<option value="40">40</option>
			<option value="50">50</option>
			</select>
			
			&nbsp
			<select name="startampm" required>
			<option value="00">AM</option>
			<option value="12">PM</option>
			</select>
			<br />
			<br />
<label><strong>Close Assignment </strong></label> <br />
			<!--  <input type="datetime"  name="enddate" placeholder="DD-MM-YYYY"><br/> -->
			
<select name="endday" required>
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
	&nbsp
<select name="endmonth" required>
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
			&nbsp
	
<select name="endyear" required>
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
&nbsp
<!-- <label><strong>End Time</strong></label> <br /> -->
			<!--  <input type="datetime"  name="endtime" placeholder="HH:MM:SS(24hr)"><br/> -->
			<select name="endhour" required>
			
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
			&nbsp
			<select name="endmin" required>
			<option value="00">00</option>
			<option value="10">10</option>
			<option value="20">20</option>
			<option value="30">30</option>
			<option value="40">40</option>
			<option value="50">50</option>
			</select>
			&nbsp
			<select name="endampm" required>
			<option value="00">AM</option>
			<option value="12">PM</option>
			</select>
			<br />
			<br />
<br/>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="submit" value="Submit"><br/>

</form>


</div><!--container-->

</body>
</html>