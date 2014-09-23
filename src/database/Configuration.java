package database;

import java.io.*;
import java.util.Properties;
import util.ConfigurationInterface;

public class Configuration implements ConfigurationInterface{
	
	 
	public static String databaseName = getProperty("databaseName");
	public static String existingDatabaseUser = getProperty("existingDatabaseUser");
	public static String existingDatabaseUserPasswd = getProperty("existingDatabaseUserPasswd");
	
	public static String testDatabaseUser = getProperty("testDatabaseUser");
	public static String testDatabaseUserPasswd = getProperty("testDatabaseUserPasswd");
	public static String databaseIP = getProperty("databaseIP");
	public static String databasePort = getProperty("databasePort");
	public static String homeDir= getProperty("homeDir");
	public static String dataDir = getProperty("dataDir");
	
	public static ConfigurationInterface object = new Configuration();
	
	public static String getProperty(String property)
	{
		if(object==null){
			object = new Configuration();
		}
		return object.getPropetyValue(property);
	}

	@Override
	public String getPropetyValue(String property) {
		Properties properties=new Properties();		
		try{
           properties.load(Configuration.class.getResourceAsStream("XData.properties"));			
		}catch(IOException e){
			e.printStackTrace();
			System.exit(1);
		}
		String prop = properties.getProperty(property);
		if (prop== null)
		{
			System.out.println("Property "+property+" not found");
			throw new NullPointerException();
		}
		return prop;
	}
}
