import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import database.DatabaseProperties;

/**
 * Servlet implementation class QueryStatus
 */
//@WebServlet("/QueryStatus")
public class QueryStatus extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public QueryStatus() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		DatabaseProperties dbp = new DatabaseProperties();
		String loginUser = dbp.getUsername1(); //change user name according to your db user -testing1
		String username2 = dbp.getUsername2();//This is for testing2
		String loginPasswd = dbp.getPasswd1(); //change user passwd according to your db user passwd
		String passwd2 = dbp.getPasswd2();
		String hostname = dbp.getHostname();
		String dbName = dbp.getDbName();
		
		String loginUrl = "jdbc:postgresql://" + hostname +  "/" + dbName;
		
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
		"<style> html,body {background: #ccc;} fieldset {background: #f2f2e6; padding: 10px;	border: 1px solid #fff;	border-color: #fff #666661 #666661 #fff;	margin-bottom: 36px;}</style>"+
		"</head>"+

		"<body id=\"public\">"+

		"<div id=\"fieldset\">"+


		"<form class=\"wufoo\" action=\"TestCaseDataset\" method=\"get\">"+

			"<div class=\"info\">"+
			"<h2>Result</h2>"+
			"</div>");
		String assignment_id = request.getParameter("assignment_id");
		String question_id = request.getParameter("question_id");
		String result = "select * from queries left outer join users on queries.rollnum = users.id where queryid = ? order by rollnum, queryid";
        //String result="select * from queries where queryid=? order by rollnum,queryid";
        try {
        	Connection dbcon=null;
        	dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
			PreparedStatement pstmt=dbcon.prepareStatement(result);
			pstmt.setString(1,"A"+assignment_id+"Q"+question_id);
			//pstmt.setInt(2, question_id);
			ResultSet rs=pstmt.executeQuery();
			boolean present = false;
			
			out_assignment.println("<table border=\"1\">");
			out_assignment.println("<caption>Result</caption>");
			out_assignment.println("<tr>"+
					"<td>Name</td>"+
					"<td>Email</td>" +
             		"<td>Student Answer</td>"+
             		"<td>Status</td>"+
             		"<td>Failed Test cases</td>"+
					"</tr>");
			while(rs.next())
			{
				present = true;
				
				if(!rs.getBoolean("tajudgement"))
				{
				     out_assignment.println("<tr>"+
						"<td>"+rs.getString("name")+"</td>"+
						"<td>"+rs.getString("email")+"</td>"+
	             		"<td>"+rs.getString("querystring")+"</td>"+
	             		"<td>"+"Wrong"+"</td>"+
	             		"<td><a href=\"StudentTestCase?user_id="+rs.getString("rollnum")+"&assignment_id="+assignment_id+"&question_id="+question_id+"&query="+rs.getString("querystring")+"\">Test Case</a></td>"+
						"</tr>");
				}
				else {

				     out_assignment.println("<tr>"+
						"<td>"+rs.getString("name")+"</td>"+
						"<td>"+rs.getString("email")+"</td>"+
	             		"<td>"+rs.getString("querystring")+"</td>"+
	             		"<td>"+"Correct"+"</td>"+
	             		"<td> </td>"+
						"</tr>");
				}
			}
			rs.close();
			if(present)
				out_assignment.println("</table>");
			else
				out_assignment.println("Not solved");
			
			dbcon.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
        
     //   out_assignment.println("<input type=\"submit\"  name=\"\" value=\"Home page\" />");
out_assignment.println("</form>"+
				
			"</div>"+
			
			
			"<!-- End Page Content -->"+
			
		"</body>"+

		"</html>");
		out_assignment.close();
	
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
