package database;

import java.io.IOException;
import java.io.FileReader;
import java.io.BufferedReader;

public class ReadFile {

	private String path;
	private String text;
		
	public String read(String pathname) throws IOException {
		path = pathname;
		FileReader fr = new FileReader(path);
		BufferedReader bf = new BufferedReader(fr);
		text="";
		String temp="";
		
		while((temp=bf.readLine())!= null) {
			text+=temp;
		}
		bf.close();
		return text;
	
	}
}
