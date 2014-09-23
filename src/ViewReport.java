

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
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
 * Servlet implementation class ViewReport
 */
//@WebServlet("/ViewReport")
public class ViewReport extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewReport() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		int assignment_id=Integer.parseInt(request.getParameter("assignment_id"));
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


		"<form class=\"wufoo\" action=\"LoginChecker\" method=\"post\">"+

			"<div class=\"info\">"+
			"<h2>Assignment: "+assignment_id+"</h2>"+
			"</div>");
		out_assignment.println("<table border=\"1\">");
		out_assignment.println("<tr>"+
				"<td>Question Number</td>"+
         		"<td> Question</td>"+
         		"<td> Correct answer</td>"+
         		"<td> Number of students who got wrong answers</td>"+
         		"<td> Dataset for which most of the students got wrong answer</td>"+
				"</tr>");
		String query="";
		String english_desc="";
		String sel_quest="select count(user_id), q_id from query where assignment_id=? and status='W' group by q_id";
		String defect_dataset="select datasetid from detectdataset group by datasetid order by count(?) desc";
		int no_of_wrong=0;
		//String sel_perf="select count(*) from query where q_id=? and status='W'";
		String q_info="select query, english_desc from qinfo where assignment_id=? and q_id=?";
		Connection dbCon=(new database.DatabaseConnection()).graderConnection();
		try {
			PreparedStatement stmt=dbCon.prepareStatement(sel_quest);
			stmt.setInt(1, assignment_id);
			ResultSet r=stmt.executeQuery();
			while(r.next()){
				no_of_wrong=r.getInt(1);
				PreparedStatement s2=dbCon.prepareStatement(q_info);
				s2.setInt(1, assignment_id);
				s2.setInt(2, r.getInt("q_id"));
				ResultSet rs1=s2.executeQuery();
				rs1.next();
				query=rs1.getString("query");
				english_desc=rs1.getString("english_desc");
				PreparedStatement ss=dbCon.prepareStatement(defect_dataset);
				ss.setString(1,"A"+assignment_id+"Q"+r.getInt(2));
				ResultSet rt=ss.executeQuery();
				rt.next();
				String datasetid=rt.getString(1);
				out_assignment.println("<tr>"+
						"<td>"+r.getInt("q_id")+"</td>"+
		         		"<td>"+english_desc+"</td>"+
		         		"<td>"+query+"</td>"+
		         		"<td>"+no_of_wrong+"</td>"+
		         		"<td>"+"<a href=ShowDatasets?datasetid="+datasetid+"&queryid="+"A"+assignment_id+"Q"+r.getInt("q_id")+">"+datasetid+"</a></td>"+
						"</tr>");
			}
			r.close();
			out_assignment.println("</table>");
			out_assignment.println("<input type=\"submit\" name=\"homepage\" Value=\"Home page\" />");
			out_assignment.println("</form>"+
					
				"</div>"+
				"<!-- End Page Content -->"+
				
			"</body>"+

			"</html>");
			out_assignment.close();
			
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		try{
			dbCon.close();
		} catch(SQLException e){}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
