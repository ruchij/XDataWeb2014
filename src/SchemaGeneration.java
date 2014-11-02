import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import database.*;
public class SchemaGeneration{
	private void createSchema(Connection dbcon,String cid,String schema_id){
		//String cid=(String) request.getSession().getAttribute("context_label");
		try{
		PreparedStatement pstmt=dbcon.prepareStatement("select ddltext from schemainfo where course_id=? and schema_id=?");
		pstmt.setString(1,cid);
		pstmt.setString(2,schema_id);
		ResultSet rs=pstmt.executeQuery();
		String schema=rs.getString(1);
		String queries[]=schema.split(";");
		Statement stmt=dbcon.createStatement();
		for (int i=0;i<queries.length;i++)
		{
			stmt.addBatch(queries[i]);
		}
		 stmt.executeBatch();
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	private void createSampleData(Connection dbcon,String cid,String schema_id){
		//String cid=(String) request.getSession().getAttribute("context_label");
		try{
		PreparedStatement pstmt=dbcon.prepareStatement("select sample_data from schemainfo where course_id=? and schema_id=?");
		pstmt.setString(1,cid);
		pstmt.setString(2,schema_id);
		ResultSet rs=pstmt.executeQuery();
		String schema=rs.getString(1);
		String queries[]=schema.split(";");
		Statement stmt=dbcon.createStatement();
		for (int i=0;i<queries.length;i++)
		{
			stmt.addBatch(queries[i]);
		}
		 stmt.executeBatch();
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
}