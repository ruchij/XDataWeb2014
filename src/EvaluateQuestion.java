

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
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
import javax.servlet.http.HttpSession;

import testDataGen.GenerateDataset_new;
import testDataGen.TestAssignment;
import database.*;
/**
 * Servlet implementation class EvaluateQuestion
 */
//@WebServlet("/EvaluateQuestion")
public class EvaluateQuestion extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public EvaluateQuestion() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session=request.getSession();
		//get database properties
		DatabaseProperties dbp = new DatabaseProperties();
		String loginUser = dbp.getUsername1(); //change user name according to your db user -testing1
		String username2 = dbp.getUsername2();//This is for testing2
		String loginPasswd = dbp.getPasswd1(); //change user passwd according to your db user passwd
		String passwd2 = dbp.getPasswd2();
		String hostname = dbp.getHostname();
		String dbName = dbp.getDbName();
		String port = dbp.getPortNumber();
		
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

		String assignment_id = (String)request.getParameter("assignment_id");
		String question_id= (String)request.getParameter("question_id");
		String dataset_sel="select * from datasetvalue where queryid=?";
		try {
			PreparedStatement delstmt=dbcon.prepareStatement(dataset_sel);
			delstmt.setString(1, "A"+assignment_id.trim()+"Q"+question_id.trim());
			ResultSet r=delstmt.executeQuery();
			if(!r.next()){
				String s = null;
				
				String args[] = {String.valueOf(assignment_id), String.valueOf(question_id)};
				try {
					GenerateDataset_new.entry(args);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				//String command=" /usr/lib/jvm/java-6-openjdk-amd64/bin/java -Dfile.encoding=UTF-8 -classpath \"/home/amol/April-Xdata/mtp:/home/amol/April-Xdata/Parser/bin:/home/amol/April-Xdata/Derby-10.8/bin:/home/amol/April-Xdata/Derby-10.8/tools/java/geronimo-spec-servlet-2.4-rc4.jar:/home/amol/April-Xdata/Derby-10.8/tools/java/jakarta-oro-2.0.8.jar:/home/amol/April-Xdata/Derby-10.8/tools/java/javacc.jar:/home/amol/April-Xdata/Derby-10.8/tools/java/xml-apis.jar:/home/amol/April-Xdata/Derby-10.8/jars/ant.jar:/usr/lib/jvm/java-1.6.0-openjdk-amd64/lib/tools.jar:/home/amol/Downloads/json-20090211.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-javadoc.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-sources.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-tests.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-test-sources.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.ui.workbench.texteditor_3.8.0.v20120523-1310.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.ui.workbench_3.104.0.v20130204-164612.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.runtime.compatibility.auth_3.2.300.v20120523-2004.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.resources_3.8.1.v20121114-124432.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.runtime_3.8.0.v20120912-155025.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.runtime.compatibility_3.2.200.v20120521-2346.jar:/home/amol/Downloads/com.google.gdata.feature_1.0.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-core-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-client-meta-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-client-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-analytics-meta-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-analytics-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-calendar-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-calendar-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-appsforyourdomain-meta-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-appsforyourdomain-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-media-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-base-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-blogger-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-blogger-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-books-meta-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-books-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-codesearch-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-codesearch-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-contacts-meta-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-contacts-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-spreadsheet-meta-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-spreadsheet-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-docs-meta-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-docs-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-finance-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-finance-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-gtt-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-gtt-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-health-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-health-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-maps-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-maps-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-photos-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-photos-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-projecthosting-meta-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-projecthosting-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-sidewiki-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-sidewiki-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-sites-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-sites-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-webmastertools-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-webmastertools-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-youtube-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-youtube-2.0.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.apache.commons.collections_3.2.0.v201005080500.jar:/home/amol/April-Xdata/Parser/jars/postgresql-9.0-801.jdbc4.jar:/home/amol/April-Xdata/Parser/jars/derby-26.jar:/home/amol/April-Xdata/Parser/jars/derby.jar:/home/amol/April-Xdata/Parser/jars/pg74jdbc2.jar:/home/amol/April-Xdata/Parser/jars/uncommons-maths-1.2.jar:/home/amol/April-Xdata/mtp/jars/derby-26.jar:/home/amol/April-Xdata/mtp/jars/derby.jar:/home/amol/April-Xdata/mtp/jars/pg74jdbc2.jar:/home/amol/April-Xdata/mtp/jars/uncommons-maths-1.2.jar:/home/amol/April-Xdata/mtp/jars/postgresql-9.0-801.jdbc4.jar:/home/amol/April-Xdata/mtp/jars/google-collect-1.0-rc2.jar:/home/amol/April-Xdata/mtp/jars/automaton.jar\" testDataGen.TestAssignment";
				/*String command2="/home/mahesh/generateDataset.sh "+assignment_id+" "+question_id;
				System.out.println(command2);
				Process p = Runtime.getRuntime().exec(command2);

				BufferedReader stdInput = new BufferedReader(new 
						InputStreamReader(p.getInputStream()));

				BufferedReader stdError = new BufferedReader(new 
						InputStreamReader(p.getErrorStream()));

				// read the output from the command
				System.out.println("Here is the standard output of the command:\n");
				while ((s = stdInput.readLine()) != null) {
					System.out.println(s);
				}

				// read any errors from the attempted command
				System.out.println("Here is the standard error of the command (if any):\n");
				while ((s = stdError.readLine()) != null) {
					System.out.println(s);
				}*/
			}
			r.close();
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		String s = null;
		
		String args[] = {assignment_id.trim(), question_id.trim()};
		TestAssignment.entry(args);
		
		//String command=" /usr/lib/jvm/java-6-openjdk-amd64/bin/java -Dfile.encoding=UTF-8 -classpath \"/home/amol/April-Xdata/mtp:/home/amol/April-Xdata/Parser/bin:/home/amol/April-Xdata/Derby-10.8/bin:/home/amol/April-Xdata/Derby-10.8/tools/java/geronimo-spec-servlet-2.4-rc4.jar:/home/amol/April-Xdata/Derby-10.8/tools/java/jakarta-oro-2.0.8.jar:/home/amol/April-Xdata/Derby-10.8/tools/java/javacc.jar:/home/amol/April-Xdata/Derby-10.8/tools/java/xml-apis.jar:/home/amol/April-Xdata/Derby-10.8/jars/ant.jar:/usr/lib/jvm/java-1.6.0-openjdk-amd64/lib/tools.jar:/home/amol/Downloads/json-20090211.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-javadoc.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-sources.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-tests.jar:/home/amol/Documents/commons-io-2.2/commons-io-2.2-test-sources.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.ui.workbench.texteditor_3.8.0.v20120523-1310.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.ui.workbench_3.104.0.v20130204-164612.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.runtime.compatibility.auth_3.2.300.v20120523-2004.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.resources_3.8.1.v20121114-124432.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.runtime_3.8.0.v20120912-155025.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.eclipse.core.runtime.compatibility_3.2.200.v20120521-2346.jar:/home/amol/Downloads/com.google.gdata.feature_1.0.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-core-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-client-meta-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-client-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-analytics-meta-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-analytics-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-calendar-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-calendar-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-appsforyourdomain-meta-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-appsforyourdomain-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-media-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-base-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-blogger-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-blogger-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-books-meta-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-books-1.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-codesearch-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-codesearch-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-contacts-meta-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-contacts-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-spreadsheet-meta-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-spreadsheet-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-docs-meta-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-docs-3.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-finance-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-finance-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-gtt-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-gtt-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-health-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-health-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-maps-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-maps-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-photos-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-photos-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-projecthosting-meta-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-projecthosting-2.1.jar:/home/amol/Downloads/gdata/java/lib/gdata-sidewiki-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-sidewiki-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-sites-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-sites-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-webmastertools-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-webmastertools-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-youtube-meta-2.0.jar:/home/amol/Downloads/gdata/java/lib/gdata-youtube-2.0.jar:/home/amol/Documents/Eclipse java Juno/eclipse/plugins/org.apache.commons.collections_3.2.0.v201005080500.jar:/home/amol/April-Xdata/Parser/jars/postgresql-9.0-801.jdbc4.jar:/home/amol/April-Xdata/Parser/jars/derby-26.jar:/home/amol/April-Xdata/Parser/jars/derby.jar:/home/amol/April-Xdata/Parser/jars/pg74jdbc2.jar:/home/amol/April-Xdata/Parser/jars/uncommons-maths-1.2.jar:/home/amol/April-Xdata/mtp/jars/derby-26.jar:/home/amol/April-Xdata/mtp/jars/derby.jar:/home/amol/April-Xdata/mtp/jars/pg74jdbc2.jar:/home/amol/April-Xdata/mtp/jars/uncommons-maths-1.2.jar:/home/amol/April-Xdata/mtp/jars/postgresql-9.0-801.jdbc4.jar:/home/amol/April-Xdata/mtp/jars/google-collect-1.0-rc2.jar:/home/amol/April-Xdata/mtp/jars/automaton.jar\" testDataGen.TestAssignment";
		/*String command2="/home/mahesh/TestQuestion.sh "+assignment_id.trim()+" "+question_id.trim();
		System.out.println(command2);
		Process p = Runtime.getRuntime().exec(command2);

		BufferedReader stdInput = new BufferedReader(new 
				InputStreamReader(p.getInputStream()));

		BufferedReader stdError = new BufferedReader(new 
				InputStreamReader(p.getErrorStream()));

		// read the output from the command
		System.out.println("Here is the standard output of the command:\n");
		while ((s = stdInput.readLine()) != null) {
			System.out.println(s);
		}

		// read any errors from the attempted command
		System.out.println("Here is the standard error of the command (if any):\n");
		while ((s = stdError.readLine()) != null) {
			System.out.println(s);
		}*/

		// response.setContentType("text/html");



		////////////////////////////////Display result on the same table/////////////////////////////////////////////////

		/*		PrintWriter out_assignment = response.getWriter();
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


		"<form class=\"wufoo\" action=\"TestCaseDataset\" method=\"get\">"+

			"<div class=\"info\">"+
			"<h2>Result</h2>"+
			"</div>");
        String result="select * from query where assignment_id=? and q_id=?";
        try {
			PreparedStatement pstmt=dbcon.prepareStatement(result);
			pstmt.setInt(1,assignment_id);
			pstmt.setInt(2, question_id);
			ResultSet rs=pstmt.executeQuery();
			out_assignment.println("<table border=\"1\">");
			out_assignment.println("<caption>Result</caption>");
			out_assignment.println("<tr>"+
					"<td>User id</td>"+
             		"<td> SQL</td>"+
             		"<td> Status</td>"+
             		"<td> Check Test cases</td>"+
					"</tr>");
			while(rs.next())
			{
				if(rs.getString("status").equalsIgnoreCase("W"))
				{
				     out_assignment.println("<tr>"+
						"<td>"+rs.getString("user_id")+"</td>"+
	             		"<td>"+rs.getString("sql")+"</td>"+
	             		"<td>"+"Wrong"+"</td>"+
	             		"<td><a href=\"TestCaseDataset?user_id="+rs.getString("user_id")+"&assignment_id="+assignment_id+"&question_id="+question_id+"&query="+rs.getString("sql")+"\">Test Case</a></td>"+
						"</tr>");
				}
				else {

				     out_assignment.println("<tr>"+
						"<td>"+rs.getString("user_id")+"</td>"+
	             		"<td>"+rs.getString("sql")+"</td>"+
	             		"<td>"+rs.getString("status")+"</td>"+
	             		"<td> </td>"+
						"</tr>");
				}
			}
			out_assignment.println("</table>");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        out_assignment.println("<input type=\"submit\"  name=\"\" value=\"Home page\" />");
out_assignment.println("</form>"+

			"</div>"+


			"<!-- End Page Content -->"+

		"</body>"+

		"</html>");
		out_assignment.close();*/

		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



		String remote = "gradeAssignment.jsp?AssignmentID="
				+ assignment_id;

		//response.sendRedirect(remote);

		response.setContentType("text/html");
		PrintWriter out2 = response.getWriter();
		out2.println("<html>"+
				"<header><title>Error</title>"
				+ "<style> html,body {background: #ccc;} fieldset {background: #f2f2e6; padding: 10px;	border: 1px solid #fff;	border-color: #fff #666661 #666661 #fff;	margin-bottom: 36px;}</style>"
				+"</header>"+
				"<body onload=\"timer=setTimeout(function(){ window.location='"+remote+"';}, 1000)\">"+
				"Questions submitted for evaluating. Please check status."+
				"</body>"+
				"</html>");



		out2.close();
		try{
			dbcon.close();
		} catch(SQLException e){}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
