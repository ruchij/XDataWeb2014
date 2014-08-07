

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Hashtable;
import java.util.StringTokenizer;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.unboundid.ldap.sdk.migrate.ldapjdk.LDAPAttribute;
import com.unboundid.ldap.sdk.migrate.ldapjdk.LDAPAttributeSet;
import com.unboundid.ldap.sdk.migrate.ldapjdk.LDAPConnection;
import com.unboundid.ldap.sdk.migrate.ldapjdk.LDAPEntry;
import com.unboundid.ldap.sdk.migrate.ldapjdk.LDAPException;
import com.unboundid.ldap.sdk.migrate.ldapjdk.LDAPReferralException;
import com.unboundid.ldap.sdk.migrate.ldapjdk.LDAPSearchResults;

/**
 * Servlet implementation class LoginChecker
 */
//@WebServlet("/LoginChecker")
public class LoginChecker extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
    /**
     * @see HttpServlet#HttpServlet()
     */
	private Connection dbcon;
    public LoginChecker() {
        super();
        dbcon=null;
        // TODO Auto-generated constructor stub
    }

    public void init(ServletConfig c) throws ServletException {
        //Open the connection here
    	
      }

	public String LdapAuthentication(String uname,String pwd) {	
		String qry="", mesg = " ", dn = " ";
		boolean checkFlag = false;
		//System.out.println("CheckFlag "+checkFlag);
		String empcode = null;
		//System.out.println("EmpCode "+empcode);
		try {
			LDAPConnection ldapHandle = null;
			LDAPEntry findEntry = null;
			ldapHandle = new LDAPConnection();
			String My_Host = "ldap.iitb.ac.in";
			int My_Port = 389;
			String ENTRYDN = "dc=iitb,dc=ac,dc=in";
			ldapHandle.connect(My_Host, My_Port,"","");
			LDAPSearchResults ldapResult = ldapHandle.search(ENTRYDN, LDAPConnection.SCOPE_SUB, "(uid="+uname+")",null,false);
	        	while (ldapResult.hasMoreElements()) {
    	     			findEntry = null;
	        	   	findEntry = ldapResult.next();
        	   		LDAPAttributeSet entries = findEntry.getAttributeSet();
	        	   	LDAPAttribute mms = entries.getAttribute("mailMessageStore");
				
				String[] myValue = mms.getStringValueArray();
				int myValueArraySize = myValue.length;
				//System.out.println("We are checking this->"+myValue[0]);
				StringTokenizer strtok = new StringTokenizer(myValue[0],"/");
				if(strtok.hasMoreTokens()) {
					String position = strtok.nextToken();
					String dept = strtok.nextToken();
					empcode = strtok.nextToken();
					position = position.substring(0,position.indexOf("."));
        	   			position = position.toLowerCase();
					//System.out.println("Final check.."+position+" "+dept+" "+empcode);
				}
    	        		dn = findEntry.getDN();
				ldapHandle.disconnect();
				ldapHandle.connect(My_Host, My_Port,dn,pwd);
				
			}
			if((ldapHandle != null ) && ldapHandle.isConnected() && empcode!=null && !empcode.equals(" ")) {
				mesg = "OK";
			} else {
				mesg = "NotOK";
			}
		} catch (LDAPReferralException e) {
			System.out.println("Error :"+ e.toString() );
			mesg = "Error "+e.toString();
		} catch (LDAPException e) {
			System.out.println("Error :"+ e.toString() );
			mesg = "Error "+e.toString();
		} catch(Exception gexp) {
			System.out.println("my exception"+gexp.getMessage());
			mesg = "Error "+gexp.getMessage();
			//LogFile.write(gexp.getMessage());
		}
		return mesg;
	}
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
	}

	 public void destroy() {
	     //Close the connection here
		 try {
			dbcon.close();
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
		HttpSession session=request.getSession();
		String uname="";
		String pwd="";
	    
		
		String loginUser = "testing1"; //change user name according to your db user
		String loginPasswd = "testing1"; //change user passwd according to your db user passwd
		String hostname="localhost";
		String dbName="xdata";

		try {
			Class.forName("org.postgresql.Driver");
		} catch (ClassNotFoundException e1) {
			e1.printStackTrace();
		}
		String loginUrl = "jdbc:postgresql://" + hostname +  "/" + dbName;
		try {
			dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
			if(dbcon!=null){
				System.out.println("Connected successfullly");
	    	  
			}
		}catch (SQLException ex) {
			System.err.println("SQLException: " + ex.getMessage());
		}
		
		
		
		if(request.getParameter("name")!=null)
	    {	
	    		session.invalidate();
	    		session=request.getSession();
				uname=request.getParameter("name");
				pwd=request.getParameter("password");
				session.setAttribute("uname",uname);
				session.setAttribute("pwd", pwd);
	    }
	    else
	    {
	    		uname=(String) session.getAttribute("uname");
	    		pwd=(String) session.getAttribute("pwd");
	    }
			
		if(uname.equalsIgnoreCase("instructor")&&pwd.equalsIgnoreCase("xdata!@#"))
		{
			response.setContentType("text/html");
			PrintWriter out2 = response.getWriter();
			
			session.setAttribute("LOGIN_USER", "ADMIN"); 
			
			response.sendRedirect("instructorOptions.html");
			
			return;
			/*BufferedReader reader = new BufferedReader(new FileReader(request.getSession().getServletContext().getRealPath("/")+"/instructorOptions.html"));
			String line = null;
			while ((line = reader.readLine()) != null) {
				out2.println(line);
			}
			out2.close();
			return;*/
		}
/*		if(!LdapAuthentication(uname,pwd).equalsIgnoreCase("ok"))
		{
			session.invalidate();
				response.setContentType("text/html");
				PrintWriter out2 = response.getWriter();
				out2.println("<html>"+
						"<header><title>Error</title></header>"+
						"<body>"+
						"Invalid username/password"+
						"</body>"+
						"</html>");
				out2.close();
				return;
		}*/
		

	
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


			"<form class=\"wufoo\" action=\"ViewAssignment\" method=\"get\">"+

			"<div class=\"info\">"+
			"<h2>Assignments</h2>"+
			"</div>");
		
		String assignments="select * from assignment";
		try {
			PreparedStatement pstmt=dbcon.prepareStatement(assignments);
			ResultSet rst=pstmt.executeQuery();
			out_assignment.println("<table border=\"1\">");
			out_assignment.println("<tr>"+
					"<td>Assignment Number</td>"+
             		"<td> Start time</td>"+
             		"<td> End time</td>"+
             		"<td> </td>"+
             		"<td> </td>"+
					"</tr>");
			while(rst.next())
			{
				String edit="";
				java.util.Date date= new java.util.Date();
				Timestamp ts=new Timestamp(date.getTime());
				if(ts.after(rst.getTimestamp("end_time")))
				{
					edit="";
					
				}
				else
				{
					edit="<input type=\"submit\" name="+rst.getInt("assignment_id")+"E value=\"Solve\" /> ";
				}
				out_assignment.println("<tr>"+
						"<td>Assignment "+rst.getInt("assignment_id") +"</td>"+
                 		"<td>"+rst.getTimestamp("start_time")+"</td>"+
                 		"<td>"+rst.getTimestamp("end_time")+"</td>"+
                 		"<td> "+edit+"</td>"+
                 		"<td> <input type=\"submit\" name="+rst.getInt("assignment_id")+"V Value=\"Result\" /> </td>"+
						"</tr>");
			}
			rst.close();
			out_assignment.println("</table>");
		} catch (SQLException e3) {
			// TODO Auto-generated catch block
			e3.printStackTrace();
		}
		if(session.getAttribute("login")==null)
		{
		  session.setAttribute("login", uname);
			System.out.println("login added");
		}
		
		out_assignment.println("<p><p><p><p><p><p><a href=\"index.html\">logout</a>");
		out_assignment.println("</form>"+
				
			"</div>"+
			
			
			"<!-- End Page Content -->"+
			
		"</body>"+

		"</html>");
		out_assignment.close();
		try{
			dbcon.close();
		} catch(SQLException e){}
		catch(NullPointerException e){}
       	
	}
	

}