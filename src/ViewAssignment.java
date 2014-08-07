

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class ViewAssignment
 */
//@WebServlet("/ViewAssignment")
public class ViewAssignment extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	private Connection dbCon;
	public ViewAssignment() {
		super();
		// TODO Auto-generated constructor stub
		dbCon=null;
	}

	public void init(ServletConfig c) throws ServletException {
		super.init(c);
		//Open the connection here
		
	}

	/*public void destroy() {
		//Close the connection here
		try {
			dbCon.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}*/

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */

	private void editAssignment(String assignment_id, String uname, HttpServletResponse response)
	{
		String map[] = new String[100];
		try {
			String submit="select * from query where user_id =? and assignment_id =?";
			PreparedStatement stmt=dbCon.prepareStatement(submit);
			stmt.setString(1, uname);
			stmt.setInt(2, Integer.parseInt(assignment_id));
			System.out.println("Uname is :"+uname);
			System.out.println("assignment_id is :"+assignment_id);
			ResultSet rst=stmt.executeQuery();
			while(rst.next())
			{
				String temp=rst.getString("sql");
				temp=temp.replaceAll("''", "'");
				map[rst.getInt("q_id")]=temp;
			}
			response.setContentType("text/html");
			PrintWriter out = response.getWriter();
			out.println("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\""+
					"\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"+

			"<html xmlns=\"http://www.w3.org/1999/xhtml\">"+
			"<head>"+

			"<title>"+
			"XData &middot; Assignment"+
			"</title>"+
			"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"+


			"<script type=\"text/javascript\" src=\"scripts/wufoo.js\"></script>"+

			"<link rel=\"stylesheet\" href=\"css/structure.css\" type=\"text/css\" />"+
			"<link rel=\"stylesheet\" href=\"css/form.css\" type=\"text/css\" />"+
			"<link rel=\"stylesheet\" href=\"css/theme.css\" type=\"text/css\" />"+

			"<link rel=\"canonical\" href=\"http://www.wufoo.com/gallery/designs/template.html\">"+
			"<style> html,body {background: #ccc;} fieldset {background: #f2f2e6; padding: 10px;	border: 1px solid #fff;	border-color: #fff #666661 #666661 #fff;	margin-bottom: 36px;}</style>"+
			"</head>"+

			"<body id=\"public\">"+
			"<div>"+
			"<div id=\"fieldset\">"+

"<fieldset>"+
"<legend> Grades</legend>"+
"<form class=\"wufoo\" action=\"SQLChecker\" method=\"get\">"+

				"<div class=\"info\">"+
				"<h2>Assignment</h2>"+
					"</div>");
			String getSQL="SELECT * from qinfo where qinfo.assignmentid=?";
			try {
				PreparedStatement stmt1 =dbCon.prepareStatement(getSQL);
				stmt1.setString(1,assignment_id);
				ResultSet rs1=stmt1.executeQuery();		  
				//	int added=1;
				while(rs1.next()){
					/*	out.println("<label for="+rs1.getInt("q_id") +">"+rs1.getString("english_desc")+"</label>)");
			   		out.println("<input type=\"name\" name="+rs1.getInt("q_id")+">");*/
					/*if(added==1)
			   		{
			   			session.setAttribute("assignment_id", rs1.getInt("assignment_id"));
			   			added=0;
			   		}*/
					if(map[Integer.parseInt(rs1.getString("questionid"))]==null)
					{
						map[Integer.parseInt(rs1.getString("questionid"))]=new String("");
					}
					out.println("<label for="+rs1.getString("questionid")+">"+rs1.getString("querytext")+"</label>");
					out.println("<br>");
					out.println("<div>");
					out.println("<textarea class=\"field textarea small\" name="+rs1.getString("questionid")+">"+map[Integer.parseInt(rs1.getString("questionid"))]+"</textarea>");
					out.println("</div>");
					out.println("<p></p>");
				}
				rs1.close();

			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			rst.close();
			
			out.println("<input type=\"submit\">");
			out.println("</form>"+

			"</div>"+

"</fieldset>"+
"</div>"+
"<!-- End Page Content -->"+

		"</body>"+

					"</html>");
			out.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

	}

	private void viewAssignment(int assignment_id, String uname, HttpServletResponse response) throws IOException
	{

		response.setContentType("text/html");
		PrintWriter out_assignment = response.getWriter();
		out_assignment.println("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\""+
				"\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"+

		"<html xmlns=\"http://www.w3.org/1999/xhtml\">"+
		"<head>"+

		"<title>"+
		"XData &middot; Assignment"+
		"</title>"+
		"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"+


		"<script type=\"text/javascript\" src=\"scripts/wufoo.js\"></script>"+

		"<link rel=\"stylesheet\" href=\"css/structure.css\" type=\"text/css\" />"+
		"<link rel=\"stylesheet\" href=\"css/form.css\" type=\"text/css\" />"+
		"<link rel=\"stylesheet\" href=\"css/theme.css\" type=\"text/css\" />"+

		"<link rel=\"canonical\" href=\"http://www.wufoo.com/gallery/designs/template.html\">"+
		//"<style> html,body {background: #ccc;} fieldset {background: #f2f2e6; padding: 10px;	border: 1px solid #fff;	border-color: #fff #666661 #666661 #fff;	margin-bottom: 36px;}</style>"+		"</head>"+
		"<style>		html,body {			margin: 0;			background: #ccc;		}		label {			font-size: 18px;			font-weight: bold;			color: #666;}"+
		"	legend {			background: #bfbf30;			color: #fff;			font: 17px/21px Calibri, Arial, Helvetica, sans-serif;			padding: 0 10px;			margin: -26px 0 0 -11px;			font-weight: bold;			border: 1px solid #fff;			border-color: #e5e5c3 #505014 #505014 #e5e5c3;			text-align: left;		}"+

		"fieldset {			background: #f2f2e6;			padding: 10px;			border: 1px solid #fff;			border-color: #fff #666661 #666661 #fff;			margin-bottom: 36px;}		</style>"+
		"<body>"+
		"<div>"+
		"<div id=\"fieldset\">"+
		"<br/><br/>"+
		"<fieldset>"+
		"<legend> Grades</legend>"+


		"<form class=\"wufoo\" action=\"LoginChecker\" method=\"post\">"+

			"<div class=\"info\">"+
			"<h2>Assignment: "+assignment_id+"</h2>"+
				"</div>");

		String output = "";
		output += "<table border=\"1\">";
		output += "<tr>"+
				"<th>Question Number</th>"+
				"<th> Question</th>"+
				"<th> Your response</th>"+
				"<th> Status</th>"+
				"<th> Test Case</th>"+
				"</tr>";
		String assignment="select * from queries,qinfo where queries.queryid LIKE ('A' || qinfo.assignmentid || '%') and queries.queryid LIKE ('%Q' || qinfo.questionid) and queries.queryid LIKE ? and rollnum=?";
		try {
			PreparedStatement stmt=dbCon.prepareStatement(assignment);
			stmt.setString(1, "A"+assignment_id+"%");
			stmt.setString(2, uname);
			ResultSet rs=stmt.executeQuery();

			boolean present = false;
			while(rs.next())
			{
				present = true;
				String status="";
				/*	if(rs.getBoolean("tajudgement").equalsIgnoreCase("NC"))
				{
					status="Not Checked";
				}
				else if(rs.getString("tajudgement").equalsIgnoreCase("I"))
				{
					status="Invalid";
				}*/
				if(rs.getBoolean("tajudgement") == false)
				{
					status="Wrong";
				}
				else if(rs.getBoolean("tajudgement") == true){
					status="Correct";
				}
				if(status.equalsIgnoreCase("wrong"))
				{
					output += "<tr>"+
							"<td>Question "+rs.getInt("questionid") +"</td>"+
							"<td>"+rs.getString("querytext").replaceAll("''", "'")+"</td>"+
							"<td>"+rs.getString("querystring").replaceAll("''", "'")+"</td>"+
							"<td>"+status+"</td>"+
							"<td><a href=\"StudentTestCase?user_id="+uname+"&assignment_id="+assignment_id+"&question_id="+rs.getInt("questionid")+"&query="+rs.getString("querystring")+"\">Test Case</a></td>"+
							"</tr>";
				}
				else
				{
					output += "<tr>"+
							"<td>Question "+rs.getInt("questionid") +"</td>"+
							"<td>"+rs.getString("querytext").replaceAll("''", "'")+"</td>"+
							"<td>"+rs.getString("querystring").replaceAll("''", "'")+"</td>"+
							"<td>"+status+"</td>"+
							"<td></td>"+
							"</tr>";
				}

			}
			if(present) output += "</table>";
			else output = "<strong>Not solved the assignment</strong>";
			//out_assignment.println("<input type=\"submit\" name=\"homepage\" Value=\"Home page\" />");
			out_assignment.println(output);
			out_assignment.println("</form>"+

		"</div>"+

		"</fieldset>"+
		"</div>"+

				"<!-- End Page Content -->"+

			"</body>"+

					"</html>");
			out_assignment.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		
		String loginUser = "testing1"; //change user name according to your db user
		String loginPasswd = "testing1"; //change user passwd according to your db user passwd
		String hostname="localhost";
		String dbName="xdata";
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e1) {
			e1.printStackTrace();
		}
		String loginUrl = "jdbc:postgresql://" + hostname +  "/" + dbName;
		try {
			dbCon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
			if(dbCon!=null){
				System.out.println("Connected successfullly");

			}
		}catch (SQLException ex) {
			System.err.println("SQLException: " + ex.getMessage());
		}
		
		
		
		
		HttpSession session=request.getSession();
		String uname=(String) session.getAttribute("user_id");
		String assgnid = (String)request.getParameter("assignmentid");
		System.out.println("Session user_id :"+uname);
		String assignments="Select * from assignment";
		//Connection dbCon=(Connection) session.getAttribute("dbConnection");
		if(dbCon==null)
			dbCon=(new database.DatabseConnection()).dbConnection("localhost", "xdata", "testing1", "testing1");
		try {
			PreparedStatement pstmt=dbCon.prepareStatement(assignments);
			ResultSet rs=pstmt.executeQuery();
			while(rs.next())
			{
				System.out.println(rs.getString("assignmentid")+": "+rs.getString("assignmentid").trim()+"V");
				if(request.getParameter(rs.getString("assignmentid").trim()+"E")!=null)
				{
					session.setAttribute("assignment_id", rs.getString("assignmentid"));
					editAssignment(rs.getString("assignmentid"),uname, response);
				}
				//else if(request.getParameter(rs.getString("assignmentid").trim()+"V")!=null)
				else if(assgnid != null && assgnid .equals(rs.getString("assignmentid").trim()+"V"))
				{
					viewAssignment(Integer.parseInt(rs.getString("assignmentid")),uname, response);
				}
			}
			rs.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		try{
			dbCon.close();
		} catch(Exception e){}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
