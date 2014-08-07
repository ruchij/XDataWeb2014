package database;

public class DatabaseProperties {

		private String username1 = "testing1"; //change user name according to your db user -testing1
		private String username2 = "testing2";//This is for testing2
		private String passwd1 = "testing1"; //change user passwd according to your db user passwd
		private String passwd2 = "testing2";
		private String hostname = "localhost";
		private String dbName = "xdata";
		
		
		
		
		public String getUsername1() {
			return username1;
		}
		public void setUsername1(String username1) {
			this.username1 = username1;
		}
		public String getUsername2() {
			return username2;
		}
		public void setUsername2(String username2) {
			this.username2 = username2;
		}
		public String getPasswd1() {
			return passwd1;
		}
		public void setPasswd1(String passwd1) {
			this.passwd1 = passwd1;
		}
		public String getPasswd2() {
			return passwd2;
		}
		public void setPasswd2(String passwd2) {
			this.passwd2 = passwd2;
		}
		public String getHostname() {
			return hostname;
		}
		public void setHostname(String hostname) {
			this.hostname = hostname;
		}
		public String getDbName() {
			return dbName;
		}
		public void setDbName(String dbName) {
			this.dbName = dbName;
		}
		
		

}
