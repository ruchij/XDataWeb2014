

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import database.DatabaseProperties;

/**
 * Servlet implementation class InitAssignment
 */
//@WebServlet("/InitAssignment")
public class InitAssignment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
	private Connection dbCon;
    public InitAssignment() {
        super();
        
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		DatabaseProperties dbp=new DatabaseProperties();
    	String loginUser = dbp.getUsername1(); //change user name according to your db user
		String loginPasswd = dbp.getPasswd1(); //change user passwd according to your db user passwd
		String hostname = dbp.getHostname();
		String dbName = dbp.getDbName();;
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
		
		
		
		System.out.println("Inside post");
		String role=(String)request.getSession().getAttribute("roles");
		if(role.equalsIgnoreCase("instructor")){
			String getAssignment = "Select * from assignment where courseid = ? and assignmentid = ?";
			try {
				PreparedStatement pstmt=dbCon.prepareStatement(getAssignment);
				pstmt.setString(1, (String) request.getSession().getAttribute("context_label"));
				pstmt.setString(2, (String) request.getSession().getAttribute("resource_link_id"));
				System.out.println("Resource: "+(String) request.getSession().getAttribute("resource_link_id") +"context: "+(String) request.getSession().getAttribute("context_label"));
				ResultSet rs=pstmt.executeQuery();
				if(rs.next()){
						RequestDispatcher rd = request.getRequestDispatcher("/InstructorHome.jsp");
						rd.include(request, response);
				} else {
						System.out.println("Creating new assignment");
						RequestDispatcher rd = request.getRequestDispatcher("/InstructorHome.jsp");
						rd.include(request, response);		
				}
				rs.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}else {
			//RequestDispatcher rd = request.getRequestDispatcher("/StudentAssignment");
			RequestDispatcher rd = request.getRequestDispatcher("Student/StudentHome.html");
			rd.include(request, response);
		}
		try{
			dbCon.close();
		} catch(SQLException e){
			
		}
	}

}
