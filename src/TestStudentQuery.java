

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Types;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class StudentTestCase
 */
@WebServlet("/TestStudentQuery")
public class TestStudentQuery extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TestStudentQuery() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String loginUser = "testing2"; //change user name according to your db user
        String loginPasswd = "testing2"; //change user passwd according to your db user passwd
        String hostname="localhost:8432";
        String dbName="sonu";
        try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
        String loginUrl = "jdbc:postgresql://" + hostname +  "/" + dbName;
		     
		   Connection testcon=null;
			  //  System.out.println(LdapAuthentication());
		       	try {
		    	     // Class.forName("org.postgresql.Driver");
		       		testcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
		    	      if(testcon!=null){
		    	    	  System.out.println("Connected successfully StudentTestCase");
		    	    	  //session.setAttribute("TestConnection", testcon);
		    	    	  
		    	      }
		    	}catch (SQLException ex) {
		    	       System.err.println("SQLException: " + ex.getMessage());
		    	}	
		HttpSession session=request.getSession();
		int assignment_id=Integer.parseInt(request.getParameter("assignment_id"));
		int question_id=Integer.parseInt(request.getParameter("question_id"));
		String user_id=request.getParameter("user_id");
		
		System.out.println("Assignment_id :"+assignment_id);
		System.out.println("Question_id :"+question_id);
		System.out.println("User id : "+user_id);
		
		String dataset_sel="select dataset_id,dataset,dataset_tag from datasets where assignment_id=? and question_id=?";
		
		Connection dbCon=(Connection) session.getAttribute("dbConnection");
		if(dbCon==null)
		{
			 loginUser = "testing1";
			 loginPasswd = "testing1"; 
			 hostname="localhost:8432";
			 dbName="sonu";
			 	try {
		    	     // Class.forName("org.postgresql.Driver");
		       		dbCon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
		    	      if(dbCon!=null){
		    	    	  System.out.println("Connected successfullly");
		    	    	  //session.setAttribute("TestConnection", testcon);
		    	    	  
		    	      }
		    	}catch (SQLException ex) {
		    	       System.err.println("SQLException: " + ex.getMessage());
		    	}	
		}
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


		"<form class=\"wufoo\" action=\"LoginChecker\" method=\"post\">"+

			"<div class=\"info\">"+
			"<h2>Question: "+question_id+"</h2>"+
			"</div>"
			+"<p align=\"left\"> <strong> Your Query: </strong>"+ (String)request.getParameter("query")+"</p>");
		
		try {
			   /**get correct query and student query*/
	        // PreparedStatement stmt2=dbCon.prepareStatement("select correctquery from qinfo where courseid = ? and assignmentid=? and questionid=? ");
	        PreparedStatement stmt2=dbCon.prepareStatement("select correct_query from queries where course_id = ? and assignment_id=? and question_id=? ");
	        
	        String course_id = (String) request.getSession().getAttribute(
					"context_label");
			stmt2.setString(1, course_id);
			stmt2.setInt(2, assignment_id);
			stmt2.setInt(3, question_id);
			ResultSet rs2 = stmt2.executeQuery();
			String out = "<p align=\"left\"> <strong>Results: </strong>";
			
					 
			out += "</p>";
			
			out += "<h3> Dataset on which the query was tested </h3>";
			out_assignment.println(out);
			
			PreparedStatement stmt1=dbCon.prepareStatement(dataset_sel);
			stmt1.setInt(1, assignment_id);
			stmt1.setInt(2, question_id);
			ResultSet rs=stmt1.executeQuery();
			while(rs.next()){
				String s=null;
				String cmd="/home/jayant/UploadDataset.sh "+rs.getString("dataset_id")+" "+"A"+assignment_id+"Q"+question_id;
				Process p2 = Runtime.getRuntime().exec(cmd);
		        
		        BufferedReader stdInput1 = new BufferedReader(new 
		             InputStreamReader(p2.getInputStream()));

		        BufferedReader stdError1 = new BufferedReader(new 
		             InputStreamReader(p2.getErrorStream()));

		        // read the output from the command
		        System.out.println("Here is the standard output of the command:\n");
		        while ((s = stdInput1.readLine()) != null) {
		            System.out.println(s);
		        }
		        
		        // read any errors from the attempted command
		        System.out.println("Here is the standard error of the command (if any):\n");
		        while ((s = stdError1.readLine()) != null) {
		            System.out.println(s);
		        }
		       
		     
				out_assignment.println("<h4>"+rs.getString("dataset_tag")+"</h4>");
				out_assignment.println("<p></p>");
				PreparedStatement pstmt=dbCon.prepareStatement("select dataset from datasets where assignment_id=? and question_id=? and dataset_id=?");
				pstmt.setInt(1, assignment_id);
				pstmt.setInt(2, question_id);
				pstmt.setString(3, rs.getString("dataset_id"));
				ResultSet rsi=pstmt.executeQuery();
				rsi.next();
				String value=rsi.getString("dataset");
				String tables[]=value.split(":::");
				System.out.println("Value: "+value);
				int i=0;
				for(String table : tables)
				{
					
					System.out.println("Tables: "+tables[i]);
					i = i+1;
					String tname,values;
					out_assignment.println("<p></p>");
					tname=table.substring(0, table.indexOf(".copy"));
					values=table.substring(table.indexOf(".copy")+5);
					/*
					String seltable="Select * from "+tname;
					PreparedStatement stmt=dbcon.prepareStatement(seltable);
					ResultSet rst=stmt.executeQuery();
					 ResultSetMetaData rsmd = rst.getMetaData();
					*/
					out_assignment.println("<table border=\"1\">");
					out_assignment.println("<caption>"+tname+"</caption>");
					String rows[]=values.split("::");
					for(String row: rows)
					{
						String columns[]=row.split("\\|");
						out_assignment.println("<tr>");
						for(String column: columns)
						{
							out_assignment.println("<td>"+column+"</td>");
						}
						out_assignment.println("</tr>");
					}
					
					out_assignment.println("</table>");
				}
				//out_assignment.println("<h5>Result of executing query</h5>");
				System.out.println("Resultset-> "+rs.getString("dataset"));
				
				
				PreparedStatement pstmt1 = null;
				ResultSet rs1 = null;
				Boolean err = false;
				String err_msg="";
				try{
				 pstmt1=testcon.prepareStatement((String)request.getParameter("query"));
				 rs1=pstmt1.executeQuery();
				 
				} catch (SQLException e){
					err = true;
					err_msg = e.getMessage();
				}
							     
/*				 PreparedStatement stmt=testcon.prepareStatement("");
			     ResultSet r=stmt.executeQuery();
			     ResultSetMetaData metadata = r.getMetaData();
			     int no_of_columns=metadata.getColumnCount();*/
			     out_assignment.println("<p></p>");
			     out_assignment.println("<table border=\"1\">");
			     out_assignment.println("<caption> Your answer</caption>");
			     out_assignment.println("<tr>");
			     
			     if (!err){			    	 
				 ResultSetMetaData metadata1 = rs1.getMetaData();
			     int no_of_columns1=metadata1.getColumnCount();
			     
			     for(int cl=1;cl<=no_of_columns1;cl++)
			     {
			    	 out_assignment.println("<th>"+metadata1.getColumnLabel(cl)+"</th>");
			     }
			     out_assignment.println("</tr>");
			     
			     while(rs1.next())
			     {
			    	 out_assignment.println("<tr>");
			    	 for(int j=1;j<=no_of_columns1;j++)
			    	 {
			    		 int type = metadata1.getColumnType(j);
			             if (type == Types.VARCHAR || type == Types.CHAR) {
			            	 out_assignment.println("<td>"+rs1.getString(j)+"</td>");
			             } else {
			            	 out_assignment.println("<td>"+rs1.getLong(j)+"</td>");
			             }
			    		
			    	 }
			    	 out_assignment.println("</tr>");
			     }
			     }
			     else
			    	 out_assignment.println("<th>"+err_msg+"</th>"+"</tr>");
			     
			     out_assignment.println("</table>");
			     
			     
			     
			     String sel_query = "select correct_query from queries where assignment_id=? and question_id=?";
			     PreparedStatement qstmt=dbCon.prepareStatement(sel_query);
			     qstmt.setInt(1,assignment_id);
			     qstmt.setInt(2, question_id);
			     ResultSet rr=qstmt.executeQuery();
			     rr.next();
			     PreparedStatement stmt=testcon.prepareStatement(rr.getString("correct_query"));
			     ResultSet r=stmt.executeQuery();
			     ResultSetMetaData metadata = r.getMetaData();
			     int no_of_columns=metadata.getColumnCount();
			     out_assignment.println("<p></p>");
			     out_assignment.println("<table border=\"1\">");
			     out_assignment.println("<caption> Expected Result</caption>");
			     out_assignment.println("<tr>");
			     for(int cl=1;cl<=no_of_columns;cl++)
			     {
			    	 out_assignment.println("<th>"+metadata.getColumnLabel(cl)+"</th>");
			     }
			     out_assignment.println("</tr>");
			     while(r.next())
			     {
			    	 out_assignment.println("<tr>");
			    	 for(int j=1;j<=no_of_columns;j++)
			    	 {
			    		 int type = metadata.getColumnType(j);
			             if (type == Types.VARCHAR || type == Types.CHAR) {
			            	 out_assignment.println("<td>"+r.getString(j)+"</td>");
			             } else {
			            	 out_assignment.println("<td>"+r.getLong(j)+"</td>");
			             }
			    		
			    	 }
			    	 out_assignment.println("</tr>");
			     }
			    
			     out_assignment.println("</table>");
				out_assignment.println("<hr>");
				
				out_assignment.println("<hr>");
			}
//out_assignment.println("<input type=\"submit\"  name=\"\" value=\"Home page\" />");
			/*
			out_assignment.println("<tr><input type=\"button\" onClick=\"window.location.href='"
									+ "Student/QuestionDetails.jsp?AssignmentID="
									+ assignment_id + "&&questionId="  
									+ question_id + "&&courseId="
									+ course_id +"&&query="
									+ (String)request.getParameter("query")
									+ "&&studentId=" + user_id
									+ "'\"target = \"rightPage\""
					 + " value=\"Back\" > <br/> \n </tr>");
			*/
			out_assignment.println("<div class=\"wrapper\">	<input type=\"button\" onclick=\"history.back();\" align=\"middle\" value=\"Back\"></div>");
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
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
