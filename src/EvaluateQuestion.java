

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

		if (session.getAttribute("LOGIN_USER") == null || !session.getAttribute("LOGIN_USER").equals("ADMIN")) {
			response.sendRedirect("index.html");
			return;
		}
		
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
			}
			r.close();
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		String s = null;
		
		String args[] = {assignment_id.trim(), question_id.trim()};
		TestAssignment.entry(args);

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
