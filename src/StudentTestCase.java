

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
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import testDataGen.PopulateTestData;

/**
 * Servlet implementation class StudentTestCase
 */
//@WebServlet("/StudentTestCase")
public class StudentTestCase extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StudentTestCase() {
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
        String hostname="localhost";
        String dbName="xdata";
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
		    	    	  System.out.println("Connected successfullly");
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
		String dataset_sel="select datasetid,result,tag from detectdataset natural join datasetvalue where  user_id=? and queryid=?";
		Connection dbCon=(Connection) session.getAttribute("dbConnection");
		if(dbCon==null)
		{
			 loginUser = "testing1";
			 loginPasswd = "testing1"; 
			 hostname="localhost";
			 dbName="xdata";
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
			+"<p align=\"left\"> <strong> Student Answer: </strong>"+ (String)request.getParameter("query")+"</p>");
		
		try {
			   /**get correct query and student query*/
	        PreparedStatement stmt2=dbCon.prepareStatement("select correctquery from qinfo where courseid = ? and assignmentid=? and questionid=? ");
	        String course_id = (String) request.getSession().getAttribute(
					"context_label");
			stmt2.setString(1, course_id);
			stmt2.setString(2, Integer.toString(assignment_id));
			stmt2.setString(3, Integer.toString(question_id));
			ResultSet rs2 = stmt2.executeQuery();
			String out = "<p align=\"left\"> <strong>Correct Answer: </strong>";
			while(rs2.next()){
				out += rs2.getString("correctquery");
				
			}
			out += "</p>";
			out_assignment.println(out);
			
			PreparedStatement stmt1=dbCon.prepareStatement(dataset_sel);
			stmt1.setString(1, user_id);
			stmt1.setString(2, "A"+assignment_id+"Q"+question_id);
			ResultSet rs=stmt1.executeQuery();
			while(rs.next()){
				String s=null;
				
				String args[] = {rs.getString("datasetid"), "A"+assignment_id+"Q"+question_id};
				try {
					PopulateTestData.entry(args);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				/*String cmd="/home/mahesh/UploadDataset.sh "+rs.getString("datasetid")+" "+"A"+assignment_id+"Q"+question_id;
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
		        }*/
		       
		     
				out_assignment.println("<h4>"+rs.getString("tag")+"</h4>");
				out_assignment.println("<p></p>");
				PreparedStatement pstmt=dbCon.prepareStatement("select value from datasetvalue where queryid=? and datasetid=?");
				pstmt.setString(1, "A"+assignment_id+"Q"+question_id);
				pstmt.setString(2, rs.getString("datasetid"));
				ResultSet rsi=pstmt.executeQuery();
				rsi.next();
				String value=rsi.getString("value");
				String tables[]=value.split(":::");
				for(String table : tables)
				{
					String tname,values;
					out_assignment.println("<p></p>");
					tname=table.substring(0, table.indexOf(".copy"));
					values=table.substring(table.indexOf(".copy")+5);
					/*String seltable="Select * from "+tname;
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
				 String result[]=rs.getString("result").split(":::");
				 String column_names[]=result[0].split("@@");
				 int no_of_columns=column_names.length;
/*				 PreparedStatement stmt=testcon.prepareStatement("");
			     ResultSet r=stmt.executeQuery();
			     ResultSetMetaData metadata = r.getMetaData();
			     int no_of_columns=metadata.getColumnCount();*/
			     out_assignment.println("<p></p>");
			     out_assignment.println("<table border=\"1\">");
			     out_assignment.println("<caption> Your answer</caption>");
			     out_assignment.println("<tr>");
			     for(int cl=0;cl<no_of_columns;cl++)
			     {
			    	 out_assignment.println("<th>"+column_names[cl]+"</th>");
			     }
			     out_assignment.println("</tr>");
			     int no_of_rows=result.length;
			     for(int k=1;k<no_of_rows;k++)
			     {
			    	 out_assignment.println("<tr>");
			    	 String columns[]=result[k].split("@@");
			    	 for(int j=0;j<no_of_columns;j++)
			    	 {
			    		 out_assignment.println("<td>"+columns[j]+"</td>");
			         }
			    	 out_assignment.println("</tr>");
			     }
			     out_assignment.println("</table>");
			     String sel_query = "select correctquery from qinfo where assignmentid=? and questionid=?";
			     PreparedStatement qstmt=dbCon.prepareStatement(sel_query);
			     qstmt.setString(1,assignment_id+"");
			     qstmt.setString(2, question_id+"");
			     ResultSet rr=qstmt.executeQuery();
			     rr.next();
			     PreparedStatement stmt=testcon.prepareStatement(rr.getString("correctquery"));
			     rr.close();
			     ResultSet r=stmt.executeQuery();
			     ResultSetMetaData metadata = r.getMetaData();
			     no_of_columns=metadata.getColumnCount();
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
			     r.close();
			     out_assignment.println("</table>");
				out_assignment.println("<hr>");
				
				out_assignment.println("<hr>");
			}
//out_assignment.println("<input type=\"submit\"  name=\"\" value=\"Home page\" />");
			
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
			testcon.close();
			dbCon.close();
		}catch(SQLException e){}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
