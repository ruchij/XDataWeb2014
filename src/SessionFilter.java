import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SessionFilter implements Filter {

  private String contextPath;

  public void init(FilterConfig fc) throws ServletException {
    contextPath = fc.getServletContext().getContextPath();
  }

  public void doFilter(ServletRequest request, ServletResponse response, FilterChain fc) throws IOException, ServletException {
    HttpServletRequest req = (HttpServletRequest) request;
    HttpServletResponse res = (HttpServletResponse) response;  
    String path = ((HttpServletRequest) request).getRequestURI();
    
    if(path.contains("asgnmentCreation.html") || path.contains("asgnmentList.jsp") || path.contains("assignment_eval.html") || path.contains("Assignment.html") || 
    		path.contains("assignmentCreation.jsp") || path.contains("dataUpload") || path.contains("evaluateAssignment.jsp") || path.contains("gradeAssignment.jsp") ||
    		path.contains("initialDataUpload.jsp") || path.contains("instructorOptions.html") || path.contains("newAssignmentCreation.jsp") || 
    		path.contains("schemaUpload") || path.contains("updateAssignment.jsp") || path.contains("UpdateExistingAssignment.jsp") || path.contains("updateQuery.jsp")){
    	
    
	    if(path.contains("LoginChecker") || path.equals(contextPath) || path.equals(contextPath + "/") || path.contains(".css")){
	    	fc.doFilter(request, response);
	    	return;
	    }
	
	    if (req.getSession().getAttribute("LOGIN_USER") == null) { //checks if there's a LOGIN_USER set in session...
	        res.sendRedirect(contextPath); //or page where you want to redirect
	    } else {
	      String userType = (String) req.getSession().getAttribute("LOGIN_USER");
	      if (!userType.equals("ADMIN")){ //check if user type is not admin
	        res.sendRedirect(contextPath); //or page where you want to  
	      }
	      fc.doFilter(request, response);
	    }
    }
    else
    	fc.doFilter(request, response);
    }

  public void destroy() {
  }
}