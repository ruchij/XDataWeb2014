

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

import database.DatabaseProperties;
import testDataGen.PopulateTestData;

/**
 * Servlet implementation class TestCaseDataset
 */
//@WebServlet("/TestCaseDataset")
public class TestCaseDataset extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TestCaseDataset() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String query=request.getParameter("query");
		DatabaseProperties dbp=new DatabaseProperties();
		String loginUser = dbp.getUsername2(); //change user name according to your db user
		String loginPasswd = dbp.getPasswd2(); //change user passwd according to your db user passwd
		String hostname= dbp.getHostname();
		String dbName= dbp.getDbName();
		String port = dbp.getPortNumber();
		
        try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
        String loginUrl = "jdbc:postgresql://" + hostname + ":" + port + "/" + dbName;
		     
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
		//String user_id=request.getParameter("user_id");
		String user_id = (String)request.getSession().getAttribute("user_id");
		String dataset_sel="select datasetid from detectdataset where user_id=? and queryid=?";
		Connection dbCon=(Connection) session.getAttribute("dbConnection");
		if(dbCon==null)
		{
			dbp=new DatabaseProperties();
			loginUser = dbp.getUsername1(); //change user name according to your db user
			loginPasswd = dbp.getPasswd1(); //change user passwd according to your db user passwd
			hostname= dbp.getHostname();
			dbName= dbp.getDbName();;
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

		"</head>"+

		"<body id=\"public\">"+

		"<div id=\"container\">"+


		"<form class=\"wufoo\" action=\"LoginChecker\" method=\"post\">"+

			"<div class=\"info\">"+
			"<h2>Question: "+question_id+"</h2>"+
			"</div>");
		try {
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
		        
				out_assignment.println("<h4>Dataset ID: "+rs.getString("datasetid")+"</h4>");
				out_assignment.println("<p></p>");
				PreparedStatement pstmt=dbCon.prepareStatement("select value from datasetvalue where queryid=? and datasetid=?");
				pstmt.setString(1, "A"+assignment_id+"Q"+question_id);
				pstmt.setString(2, rs.getString("datasetid"));
				ResultSet rsi=pstmt.executeQuery();
				rsi.next();
				String value=rsi.getString("value");
				rsi.close();
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
				 PreparedStatement stmt=testcon.prepareStatement(query);
			     ResultSet r=stmt.executeQuery();
			     ResultSetMetaData metadata = r.getMetaData();
			     int no_of_columns=metadata.getColumnCount();
			     out_assignment.println("<p></p>");
			     out_assignment.println("<table border=\"1\">");
			     out_assignment.println("<caption> Result</caption>");
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
			}
			
out_assignment.println("<input type=\"submit\"  name=\"\" value=\"Home page\" />");
			
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
		}catch(SQLException e){
			
		}
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
