

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import database.DatabaseProperties;


//import testDataGen.TestAnswer;

/**
 * Servlet implementation class SQLChecker
 */
//@WebServlet("/SQLChecker")
public class SQLChecker extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
	private Connection dbCon;
    public SQLChecker() {
        // TODO Auto-generated constructor stub
    	dbCon=null;
    }

    
    
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		DatabaseProperties dbp=new DatabaseProperties();
		String loginUser = dbp.getUsername1(); //change user name according to your db user
		String loginPasswd = dbp.getPasswd1(); //change user passwd according to your db user passwd
		String hostname = dbp.getHostname();
		String dbName = dbp.getDbName();
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
		
		
		
		String inst[]=new String[30];
		HttpSession session=request.getSession();
		//Connection dbCon=(Connection) session.getAttribute("dbConnection");
		if(dbCon==null)
		{
			dbCon=(new database.DatabseConnection()).dbConnection(hostname, dbName, loginUser, loginPasswd, port);
		}
		String del="delete from query where user_id=? and assignment_id=?";
		String sql="select questionid from qinfo where assignmentid=? and courseid = ?";
		try {
			PreparedStatement pstmt=dbCon.prepareStatement(del);
			pstmt.setString(1, (String) session.getAttribute("user_id"));
			pstmt.setInt(2, Integer.parseInt((String)session.getAttribute("resource_link_id")));
			pstmt.executeUpdate();
			PreparedStatement stmt=dbCon.prepareStatement(sql);
			stmt.setString(1, (String) session.getAttribute("resource_link_id"));
			stmt.setString(2, (String) session.getAttribute("context_label"));
			ResultSet rs=stmt.executeQuery();
			while(rs.next())
			{
				String insert="INSERT INTO query values (?,?,?,?,'NC')";
				PreparedStatement instmt=dbCon.prepareStatement(insert);
				instmt.setInt(1, Integer.parseInt((String)session.getAttribute("resource_link_id")));
				instmt.setInt(2, Integer.parseInt(rs.getString("questionid")));
				instmt.setString(3, (String) session.getAttribute("user_id"));
				String q_id=rs.getString("questionid");
				String query=request.getParameter(q_id);
				query=query.replaceAll("'", "''");
				query=query.trim().replaceAll("\r\n+", " ");
				query=query.trim().replaceAll("\n+", " ");
				query=query.trim().replaceAll(" +", " ");	
				instmt.setString(4, query);
				instmt.executeUpdate();
				
			}
			rs.close();
			response.setContentType("text/html");
			PrintWriter out2 = response.getWriter();
			out2.println("<html>"+
			"<header><title>Success</title></header>"+
			"<body>"+
			"Assignment updated successfully"+
			"</body>"+
			"</html>");
			out2.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try{
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
