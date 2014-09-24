package database;
import java.util.*;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.*;
import java.text.*;

public class CommonFunctions {

	public String timeDifference(java.util.Date toDate, java.util.Date fromDate){

		long diff = toDate.getTime() - fromDate.getTime();

		long diffSeconds = diff / 1000 % 60;
		long diffMinutes = diff / (60 * 1000) % 60;
		long diffHours = diff / (60 * 60 * 1000) % 24;
		long diffDays = diff / (24 * 60 * 60 * 1000);

		String timeDiff = diffDays + " days," + diffHours + " hours, "+diffMinutes+" minutes, "+diffSeconds+ " seconds.";

		System.out.print(diffDays + " days, ");
		System.out.print(diffHours + " hours, ");
		System.out.print(diffMinutes + " minutes, ");
		System.out.print(diffSeconds + " seconds.");

		return timeDiff;
	}

	public String getTimeDetails(Timestamp start, boolean isStart){
		String output = "";
		String flag ;
		if (isStart == true) flag = "start";
		else flag = "end";
		//printing start date and time
		SimpleDateFormat formatter = new SimpleDateFormat(
				"yyyy-MM-dd HH:mm:ss");

		formatter.setLenient(false);

		String starting = formatter.format(start);
		String[] Starting = starting.split(" ");
		String[] startYear = Starting[0].split("-");
		String[] startTime = Starting[1].split(":");
		//start year
		String[] month = { "", "January", "February", "March", "April",
				"May", "June", "July", "August", "September", "October",
				"November", "December" };

		String startmonth = "<select name=\""+flag+"month\"  > " + "\n";
		for (int i = 1; i <= 12; i++) {
			//out.println(i+" "+month[i]+" "+startYear[1]+" "+String.format("%02d",Integer.parseInt("0"+Integer.toString(i)))+" "+String.format("%02d",Integer.parseInt("0"+Integer.toString(i))).equals(startYear[1]) +"<br/>");
			if (i < 10
					&& !(String.format("%02d",
							Integer.parseInt("0" + Integer.toString(i)))
							.equals(startYear[1])))
				startmonth += "<option value=\"" + '0' + (i) + "\">"
						+ month[i] + "</option>" + "\n";
			else if (i != (Integer.parseInt(startYear[1])))
				startmonth += "<option value=\"" + (i) + "\">" + month[i]
						+ "</option>" + "\n";
			else if (i < 10
					&& String.format("%02d",
							Integer.parseInt("0" + Integer.toString(i)))
							.equals(startYear[1]))
				startmonth += "<option value=\"" + '0' + (i)
				+ "\" selected>" + month[i] + "</option>" + "\n";
			else if (i == (Integer.parseInt(startYear[1])))
				startmonth += "<option value=\"" + (i) + "\" selected>"
						+ month[i] + "</option>" + "\n";
		}
		startmonth += "</select>";

		String startyear = "  <select name=\""+flag+"year\"  > " + "\n";
		String[] year = { "2012", "2013", "2014", "2015", "2016", "2017",
				"2018", "2019", "2020" };

		for (int i = 0; i < 9; i++) {
			if (year[i].equals(startYear[0]))
				startyear += " <option value=\"" + startYear[0]
						+ "\" selected>" + startYear[0] + "</option> "
						+ "\n";
			else
				startyear += " <option value=\"" + year[i] + "\">"
						+ year[i] + "</option>" + "\n";
		}
		startyear += "</select>";

		String startday = "<select name=\""+flag+"day\"  >" + "\n";
		//<option value="01">1</option>
		for (int i = 1; i < 32; i++) {

			//out.println(i+" "+String.format("%02d",Integer.parseInt("0"+Integer.toString(i)))+" "+String.format("%02d",Integer.parseInt("0"+Integer.toString(i))).equals(startYear[1]) +"<br/>");

			if (i < 10
					&& !(String.format("%02d",
							Integer.parseInt("0" + Integer.toString(i)))
							.equals(startYear[2])))
				startday += " <option value=\"" + '0' + i + "\">" + i
				+ "</option>" + "\n";
			else if (i < 10
					&& String.format("%02d",
							Integer.parseInt("0" + Integer.toString(i)))
							.equals(startYear[2]))
				startday += " <option value=\"" + '0' + i + "\" selected>"
						+ i + "</option>" + "\n";
			else if (i != (Integer.parseInt(startYear[2])))
				startday += " <option value=\"" + i + "\" >" + i
				+ "</option>" + "\n";
			else if (i == (Integer.parseInt(startYear[2])))
				startday += " <option value=\"" + i + "\" selected>" + i
				+ "</option>" + "\n";
		}
		startday += "</select>" + "\n";

		String starthour = " <select name=\""+flag+"hour\"  > " + "\n";
		String hour = startTime[0];
		boolean ampm = false;
		boolean done = false;
		if (Integer.parseInt(startTime[0]) == 0
				|| Integer.parseInt(startTime[0]) > 12) {
			ampm = true;
			if (Integer.parseInt(startTime[0]) != 0)
				hour = Integer.toString(Integer.parseInt(hour) - 12);
			else {
				//starthour += " <option value=\"12\">12</option>"+"\n";
				done = true;
			}
		}
		for (int i = 1; i < 13; i++) {
			if (i < 10
					&& !(String.format("%01d",
							Integer.parseInt(Integer.toString(i)))
							.equals(hour)))
				starthour += " <option value=\"" + '0' + i + "\">" + '0'
						+ i + "</option>" + "\n";
			else if (i < 10
					&& (String.format("%02d",
							Integer.parseInt("0" + Integer.toString(i)))
							.equals(hour)))
				starthour += " <option value=\"" + '0' + i + "\" selected>"
						+ '0' + i + "</option>" + "\n";
			else if (i != (Integer.parseInt(hour))
					&& (i != 12 || done != true)) {
				starthour += " <option value=\"" + i + "\" >" + i
						+ "</option>" + "\n";
				//System.out.println("hello");
			} else if (i == (Integer.parseInt(hour))
					&& (i != 12 || done != true))
				starthour += " <option value=\"" + i + "\" selected>" + i
				+ "</option>" + "\n";
			else if (done = true && i == 12)
				starthour += " <option value=\"12\" selected>12</option>"
						+ "\n";
		}
		starthour += "</select>" + "\n";

		String startmin = " <select name=\""+flag+"min\"  > " + "\n";
		for (int i = 0; i < 60; i += 10) {
			if (i == 0
					&& !(String.format("%02d",
							Integer.parseInt("0" + Integer.toString(i)))
							.equals(startTime[1])))
				startmin += " <option value=\"" + '0' + i + "\" >" + '0'
						+ i + "</option>" + "\n";
			else if (i == 0
					&& (String.format("%02d",
							Integer.parseInt("0" + Integer.toString(i)))
							.equals(startTime[1])))
				startmin += " <option value=\"" + '0' + i + "\" selected>"
						+ '0' + i + "</option>" + "\n";
			else if (i != (Integer.parseInt(startTime[1])))
				startmin += " <option value=\"" + i + "\" >" + i
				+ "</option>" + "\n";
			else if (i == (Integer.parseInt(startTime[1])))
				startmin += " <option value=\"" + i + "\" selected>" + i
				+ "</option>" + "\n";
		}
		startmin += "</select>" + "\n";

		String startampm = " <select name=\""+flag+"ampm\"  >" + "\n";
		if (ampm) {
			startampm += "<option value=\"00\">AM</option>" + "\n";
			startampm += "<option value=\"12\" selected>PM</option>" + "\n";
		} else {
			startampm += "<option value=\"00\" selected>AM</option>" + "\n";
			startampm += "<option value=\"12\" >PM</option>" + "\n";
		}
		startampm += "</select>" + "\n";

		output += startday + "&nbsp" + startmonth + "&nbsp" + startyear;
		output += starthour + "&nbsp" + startmin + "&nbsp" + startampm
				+ "<br/><br/>";

		return output;
	}
	
	
	public String getAssignmnetIinstructions(String courseID, String assignID) throws Exception{
				//get connection
				Connection dbcon = (new DatabaseConnection()).graderConnection();
				Timestamp start = null;
				Timestamp end = null;

				String instructions = "<label>Assignment Name: " + assignID
						+ "</label><br/>";
				try {
					PreparedStatement stmt;
					ResultSet rs = null;
					stmt = dbcon
							.prepareStatement("SELECT * FROM  assignment where assignmentid=? and courseid=?");
					stmt.setString(1, assignID);
					stmt.setString(2, courseID);
					rs = stmt.executeQuery();
					if (rs.next()) {
						start = rs.getTimestamp("starttime");
						end = rs.getTimestamp("endtime");
						//start=rs.getString("end_date");
						SimpleDateFormat formatter = new SimpleDateFormat(
								"yyyy-MM-dd HH:mm:ss");
						formatter.setLenient(false);
						String ending = formatter.format(end);
						String starting = formatter.format(start);
						//String oldTime = "2012-07-11 10:55:21";
						java.util.Date oldDate = formatter.parse(ending);
						//get current date
						Calendar c = Calendar.getInstance();

						String currentDate = formatter.format(c.getTime());
						java.util.Date current = formatter.parse(currentDate);

						//compare times
						if (current.compareTo(oldDate) >= 0) {

							CommonFunctions util = new CommonFunctions();
							String dueTime = util.timeDifference(current, oldDate);

							instructions += "<p><label> Assignment is over due by "
									+ dueTime + "</label></p>";
						} else {
							instructions += "<p><label> Assignment is due on " + end
									+ " </label></p>";
						}
						
					}
					
					rs.close();
					dbcon.close();

				} catch (Exception err) {
					err.printStackTrace();
					return "Error in retrieving list of questions";

				}
				
				//instructions += "<h2 style=\"text-align:left;\">General instructions</h2><ul><li>Do not use semicolon (;) to end the answer</li> </ul>";
				return instructions;
	}
	
	
	public static String encodeHTML(String s)
	{
	    StringBuffer out = new StringBuffer();
	    for(int i=0; i<s.length(); i++)
	    {
	        char c = s.charAt(i);
	        if(c > 127 || c=='"' || c=='<' || c=='>')
	        {
	           out.append("&#"+(int)c+";");
	        }
	        else
	        {
	            out.append(c);
	        }
	    }
	    return out.toString();
	}
	
	/**
	   * Decodes the passed UTF-8 String using an algorithm that's compatible with
	   * JavaScript's <code>decodeURIComponent</code> function. Returns
	   * <code>null</code> if the String is <code>null</code>.
	   *
	   * @param s The UTF-8 encoded String to be decoded
	   * @return the decoded String
	   */
	  public static String decodeURIComponent(String s)
	  {
	    if (s == null)
	    {
	      return null;
	    }

	    String result = null;

	    try
	    {
	      s = s.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
	      s = s.replaceAll("\\+", "%2B");
	      result = URLDecoder.decode(s, "UTF-8");
	    }

	    // This exception should never occur.
	    catch (UnsupportedEncodingException e)
	    {
	      result = s;  
	    }

	    return result;
	  }

	  /**
	   * Encodes the passed String as UTF-8 using an algorithm that's compatible
	   * with JavaScript's <code>encodeURIComponent</code> function. Returns
	   * <code>null</code> if the String is <code>null</code>.
	   * 
	   * @param s The String to be encoded
	   * @return the encoded String
	   */
	  public static String encodeURIComponent(String s)
	  {
	    String result = null;

	    try
	    {
	      result = URLEncoder.encode(s, "UTF-8");
	    }

	    // This exception should never occur.
	    catch (UnsupportedEncodingException e)
	    {
	      result = s;
	    }

	    return result;
	  }
	
}
