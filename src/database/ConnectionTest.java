package database;
import java.sql.*;
import java.io.*;
import java.util.*;
import java.text.*;
import static java.lang.System.out;

public class ConnectionTest {
	
	
	public static void main(String[] args) { 
	      System.out.println("Hello, World");
	      
	  	//String courseID = (String) request.getSession().getAttribute("context_label");
		//get database properties
		//DatabaseProperties dbp = new DatabaseProperties();
		//String username = dbp.getUser1Name(); //change user name according to your db user -testing1
		//String username2 = dbp.getUser2Name();//This is for testing2
		//String passwd = dbp.getPassword1(); //change user passwd according to your db user passwd
		//String passwd2 = dbp.getPassword2();
		//String hostname = dbp.getHostName();
		//String dbName = dbp.getDbName();

		//get connection
		Connection dbcon = (new DatabseConnection()).dbConnection("localhost",
				"sonu", "testing1", "testing1","8432");
		String output = "<ul>";

		try {
			PreparedStatement stmt;
			stmt = dbcon
					.prepareStatement("SELECT * FROM  assignment");
			//	stmt.setString(2, (String)request.getSession().getAttribute("context_label"));
			//stmt.setString(1, courseID);
			ResultSet rs;
			rs = stmt.executeQuery();
			while (rs.next()) {

				output += "<a class=\"header\" target=\"rightPage\" href=\"asgnmentList.jsp?assignmentid="+rs.getString("assignment_id")+"\" ><li> Assignment "
						+ rs.getString("assignment_id") + "</li></a>";
			}

			output += "</ul>";

			out.println(output);
		} catch (Exception err) {

			err.printStackTrace();
			out.println("Error in getting list of assignments");
		}
	   }

}
