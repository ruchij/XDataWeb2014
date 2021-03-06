

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import database.*;
/**
 * Servlet implementation class StudentAssignment
 * Used to get one assignment for the student
 */
//@WebServlet("/StudentAssignment")
public class StudentAssignment extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */

	private Connection dbCon;
	public StudentAssignment() {
		super();
		dbCon = null;
	}

	public void init(ServletConfig c) throws ServletException {
	
		super.init(c);
	 
	}
/*
	public void destroy() {
		//Close the connection here
		try {
			dbCon.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	} 
	*/
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		/**get database properties*/
		DatabaseProperties dbp=new DatabaseProperties();
		String loginUser = dbp.getUsername1(); 		
		String loginPasswd = dbp.getPasswd1(); 
		String hostname=dbp.getHostname();
		String dbName=dbp.getDbName();
		String port = dbp.getPortNumber();
		
		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e1) {
			e1.printStackTrace();
		}
		String loginUrl = "jdbc:postgresql://" + hostname + ":" + port + "/" + dbName;
		try {
			dbCon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
			if(dbCon!=null){
				System.out.println("Connected successfullly");

			}
		}catch (SQLException ex) {
			System.err.println("SQLException: " + ex.getMessage());
		}
		
		
		/**Get assignment id and course id*/
		String assignmentId = (String)request. getSession(). getAttribute("resource_link_id");
		String courseId = (String)request. getSession(). getAttribute("context_label");

		/**Get assignment details*/
		String assignments="select * from assignment where courseid = ? and assignmentid = ?";
		try {
			PreparedStatement stmt =dbCon.prepareStatement(assignments);
			
			stmt.setString(1,courseId);
			stmt.setString(2,assignmentId);

			ResultSet rst = stmt.executeQuery();
			
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

				"</head>"+

				"<body id=\"public\">"+

				"<div id=\"container\">"+


				"<form class=\"wufoo\" action=\"ViewAssignment\" method=\"get\">"+

				"<div class=\"info\">"+
				"<h2>Assignment</h2>"+
				"</div>");
			out_assignment.println("<table border=\"1\">");
			out_assignment.println("<tr>"+
					"<td>Assignment Number</td>"+
             		"<td> Start time</td>"+
             		"<td> End time</td>"+
             		"<td> </td>"+
             		"<td> </td>"+
					"</tr>");
			
			while(rst.next())
			{
				String edit="";
				java.util.Date date= new java.util.Date();
				Timestamp ts=new Timestamp(date.getTime());
				if(ts.after(rst.getTimestamp("endtime")))
				{
					edit="";
					
				}
				else
				{
					edit="<input type=\"submit\" name="+rst.getString("assignmentid")+"E value=\"Solve\" /> ";
				}
				out_assignment.println("<tr>"+
						"<td>Assignment "+rst.getString("assignmentid") +"</td>"+
                 		"<td>"+rst.getTimestamp("starttime")+"</td>"+
                 		"<td>"+rst.getTimestamp("endtime")+"</td>"+
                 		"<td> "+edit+"</td>"+
                 		"<td> <input type=\"submit\" name="+rst.getString("assignmentid")+"V Value=\"Result\" /> </td>"+
						"</tr>");
			}
			rst.close();
			out_assignment.println("</table>");
			//out_assignment.println("<p><p><p><p><p><p><a href=\"index.html\">logout</a>");
			out_assignment.println("</form>"+
					
				"</div>"+
				
				
				"<!-- End Page Content -->"+
				
			"</body>"+

			"</html>");
			out_assignment.close();
		}
		catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try{
			dbCon.close();
		}catch(SQLException e){}
	}

}
