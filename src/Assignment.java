

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Assignment
 */
//@WebServlet("/Assignment")
public class Assignment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Assignment() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html");
		PrintWriter out_assignment = response.getWriter();
		
		/*out_assignment.println("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\""+
		"\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"+

		"<html xmlns=\"http://www.w3.org/1999/xhtml\">"+
		"<head>"+

		"<title>"+
		"XData &middot; Assignment"+
		"</title>");

		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

		<script type="text/javascript" src="scripts/wufoo.js"></script>

		<link rel="stylesheet" href="css/structure.css" type="text/css" />
		<link rel="stylesheet" href="css/form.css" type="text/css" />
		<link rel="stylesheet" href="css/theme.css" type="text/css" />

		<link rel="canonical" href="http://www.wufoo.com/gallery/designs/template.html">

		</head>

		<body id="public">

		<div id="container">


		<form class="wufoo" action="AssignmentChecker" method="get">

			<div class="info">
			<h2>Assignment Evaluation</h2>
			</div>
			<label> Assignment Number</label>
			<br>
			<div>
				<input type="name" name="assignment_id">
				</div>
			<p></p>
		<label> Question Number</label>
			<br>
			<div>
				<input type="name" name="question_id">
				</div>
			<p></p>

		<input type="submit" value="Submit">

		</form>

		</div><!--container-->


		</body>

		</html>
*/
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
