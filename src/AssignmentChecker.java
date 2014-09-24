

import java.io.IOException;
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

import database.CommonFunctions;
import database.DatabaseProperties;
import testDataGen.GenerateDataset_new;
import testDataGen.PopulateTestData;

//import testDataGen.TestAssignment;

/**
 * Servlet implementation class AssignmentChecker
 */
//@WebServlet("/AssignmentChecker")
public class AssignmentChecker extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AssignmentChecker() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		HttpSession session=request.getSession();
		
		if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
			response.sendRedirect("index.html");
			return;
		}
		
		int assignment_id = Integer.parseInt(request.getParameter("assignment_id"));
		int question_id = Integer.parseInt(request.getParameter("question_id"));
		//int query_id = Integer.parseInt(request.getParameter("query_id"));
		
		
		String query = CommonFunctions.decodeURIComponent(request.getParameter("query"));
		System.out.println("------AssignmentChecker----------");
		System.out.println("Assignment-Id :"+assignment_id);
		System.out.println("Question-Id "+question_id);
		System.out.println("Query :"+query);
		
		System.out.println("------AssignmentChecker----------");
		System.out.println("Assignment-Id :"+assignment_id);
		System.out.println("Question-Id "+question_id);
		System.out.println("Query :"+query);
		
		
		session.setAttribute("question_id", question_id);
		session.setAttribute("assignment_id", assignment_id);
		DatabaseProperties dbp=new DatabaseProperties();
		String loginUser = dbp.getUsername1(); //change user name according to your db user
		String loginPasswd = dbp.getPasswd1(); //change user passwd according to your db user passwd
		String hostname= dbp.getHostname();
		String port = dbp.getPortNumber();
		String dbName= dbp.getDbName();;
	        try {
				Class.forName("org.postgresql.Driver");
			} catch (ClassNotFoundException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
	        String loginUrl = "jdbc:postgresql://" + hostname + ":" + port + "/" + dbName;
			     
	        
		    Connection dbcon=null;
		  //  System.out.println(LdapAuthentication());
	       	try {
	    	     // Class.forName("org.postgresql.Driver");
	    	      dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
	    	      if(dbcon!=null){
	    	    	  System.out.println("Connected successfullly");
	    	    	  session.setAttribute("Connection", dbcon);
	    	    	  
	    	      }
	    	}catch (SQLException ex) {
	    	       System.err.println("SQLException: " + ex.getMessage());
	    	}	
		String deldataset="delete from queryinfo where queryid=?";
		try {
			PreparedStatement delstmt=dbcon.prepareStatement(deldataset);
			delstmt.setString(1,"A"+assignment_id+"Q"+question_id);
			delstmt.executeUpdate();
		} catch (SQLException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		deldataset="delete from datasetvalue where queryid=?";
		try {
			PreparedStatement delstmt=dbcon.prepareStatement(deldataset);
			delstmt.setString(1,"A"+assignment_id+"Q"+question_id);
			delstmt.executeUpdate();
		} catch (SQLException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		String s = null;
		//String command=" /usr/lib/jvm/java-6-openjdk-amd64/bin/java -Dfile.encoding=UTF-8 -classpath \"/home/amol/April-Xdata/mtp:/home/amol/April-Xdata/Parser/bin:/home/amol/April-Xdata/Derby-10.8/bin:/home/amol/April-Xdata/Derby-10.8/tools/java/geronimo-spec-servlet-2.4-rc4.jar:/home/amol/April-Xdata/Derby-10.8/tools/java/jakarta-oro-2.0.8.jar:/home/amol/April-Xdata/Derby-10.8/tools/java/javacc.jar:/home/amol/April-Xdata/Derby-10.8/tools/java/xml-apis.jar:/home/amol/April-Xdata/Derby-10.8/jars/ant.jar:/usr/lib/jvm/java-1.6.0-openjdk-amd64/lib/tools.jar:/home/amol/Downloads/json-20090211.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-javadoc.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-sources.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-tests.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-test-sources.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.ui.workbench.texteditor_3.8.0.v20120523-1310.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.ui.workbench_3.104.0.v20130204-164612.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.runtime.compatibility.auth_3.2.300.v20120523-2004.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.resources_3.8.1.v20121114-124432.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.runtime_3.8.0.v20120912-155025.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.runtime.compatibility_3.2.200.v20120521-2346.jar:/home/amol/Downloads/com.google.gdata.feature_1.0.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-core-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-client-meta-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-client-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-analytics-meta-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-analytics-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-calendar-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-calendar-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-appsforyourdomain-meta-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-appsforyourdomain-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-media-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-base-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-blogger-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-blogger-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-books-meta-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-books-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-codesearch-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-codesearch-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-contacts-meta-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-contacts-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-spreadsheet-meta-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-spreadsheet-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-docs-meta-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-docs-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-finance-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-finance-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-gtt-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-gtt-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-health-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-health-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-maps-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-maps-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-photos-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-photos-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-projecthosting-meta-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-projecthosting-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-sidewiki-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-sidewiki-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-sites-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-sites-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-webmastertools-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-webmastertools-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-youtube-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-youtube-2.0.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.apache.commons.collections_3.2.0.v201005080500.jar:/home/amol/April-Xdata/Parser/jars/postgresql-9.0-801.jdbc4.jar:/home/amol/April-Xdata/Parser/jars/derby-26.jar:/home/amol/April-Xdata/Parser/jars/derby.jar:/home/amol/April-Xdata/Parser/jars/pg74jdbc2.jar:/home/amol/April-Xdata/Parser/jars/uncommons-maths-1.2.jar:/home/amol/April-Xdata/mtp/jars/derby-26.jar:/home/amol/April-Xdata/mtp/jars/derby.jar:/home/amol/April-Xdata/mtp/jars/pg74jdbc2.jar:/home/amol/April-Xdata/mtp/jars/uncommons-maths-1.2.jar:/home/amol/April-Xdata/mtp/jars/postgresql-9.0-801.jdbc4.jar:/home/amol/April-Xdata/mtp/jars/google-collect-1.0-rc2.jar:/home/amol/April-Xdata/mtp/jars/automaton.jar\" testDataGen.TestAssignment";
		
		String args[] = {String.valueOf(assignment_id), String.valueOf(question_id)};
		try {
			GenerateDataset_new.entry(args);
		} catch (Exception e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
       	
		dbp=new DatabaseProperties();
		loginUser = dbp.getUsername2(); //change user name according to your db user
		loginPasswd = dbp.getPasswd2(); //change user passwd according to your db user passwd
		hostname= dbp.getHostname();
		dbName= dbp.getDbName();;
        try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
        loginUrl = "jdbc:postgresql://" + hostname + ":" + port + "/" + dbName;
		     
        
	    Connection testcon=null;
	  //  System.out.println(LdapAuthentication());
       	try {
    	     // Class.forName("org.postgresql.Driver");
       		testcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
    	      if(testcon!=null){
    	    	  System.out.println("Connected successfullly");
    	    	  session.setAttribute("TestConnection", testcon);
    	    	  
    	      }
    	}catch (SQLException ex) {
    	       System.err.println("SQLException: " + ex.getMessage());
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
		
        String datasets="Select datasetid,value,tag from datasetvalue where queryid=?";
        try {
			PreparedStatement pstmt=dbcon.prepareStatement(datasets);
			pstmt.setString(1, "A"+assignment_id+"Q"+question_id );
			ResultSet rs=pstmt.executeQuery();
			while(rs.next())
			{
				String args1[] = {rs.getString("datasetid"), "A"+assignment_id+"Q"+question_id};
				PopulateTestData.entry(args1);
		        
				out_assignment.println("<h4>"+rs.getString("tag")+"</h4>");
				out_assignment.println("<p></p>");
				String value=rs.getString("value");
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
			
			
	/*		request.setAttribute("uname", session.getAttribute("uname"));
			request.setAttribute("pwd", session.getAttribute("pwd"));*/
			out_assignment.println("<input type=\"submit\"  name=\"\" value=\"Home page\" />");
			
			out_assignment.println("</form>"+
					
				"</div>"+
				
				
				"<!-- End Page Content -->"+
				
			"</body>"+

			"</html>");
			out_assignment.close();
			rs.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
        finally{
        	try {
        		testcon.close();
				dbcon.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
