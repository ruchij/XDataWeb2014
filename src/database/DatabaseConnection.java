package database;
import java.sql.*;
public class DatabaseConnection {
	private Connection dbConnection(String hostname, String dbName, String username, String passwd, String port){
		Connection dbcon = null;
		try{
			Class.forName("org.postgresql.Driver");
		} 
		catch (ClassNotFoundException cnfe){
    	//out.println("<p style=\"font-family:arial;color:red;font-size:20px;background-color:white;\">Could not find the JDBC driver!</p>");
			System.exit(1);
		}
		String loginUrl = "jdbc:postgresql://" + hostname + ":" + port + "/" + dbName;;
		try {
     // Class.forName("org.postgresql.Driver");
			dbcon = DriverManager.getConnection(loginUrl, username, passwd);
			if(dbcon!=null){
				System.out.println("Connected successfullly+passwrd:"+passwd);
			}
		}
		catch (SQLException ex) {
			System.err.println("SQLException: " + loginUrl);
			System.err.println("SQLException: " + ex.toString());
		}
		return dbcon;
	}
	
	// Returns the database connection to be used by the grader.
	public Connection graderConnection(){
		
		DatabaseProperties prop = new DatabaseProperties();
		
		return dbConnection(prop.getHostname(), prop.getDbName(), prop.getUsername1(), prop.getPasswd1(), prop.getPortNumber());
		
	}
	
	// Returns the database connection for testing the student queries.
	public Connection testConnection(){
		
		DatabaseProperties prop = new DatabaseProperties();
		
		return dbConnection(prop.getHostname(), prop.getDbName(), prop.getUsername2(), prop.getPasswd2(), prop.getPortNumber());
		
	}

}
