<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head> 
 <link rel="stylesheet" href="css/structure.css" type="text/css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Welcome to XData</title>
</head>
<frameset rows=50px,* border=0 frameborder=0 framespacing=0  id="leftframeset">
	<frame src="Header.jsp"  name="rightPage1" id="right1" tabindex="60" scrolling="no" style="border-bottom: 1px solid black">
	<frameset cols=18%,* border=0 frameborder=0 framespacing=0 >
		<frame  src = "instructorMenu.html" name="leftPage" id="leftname" tabindex="1" >
		<frame src="Welcome.jsp"  name="rightPage" id="right2" tabindex="60" style="padding:10px 0 0 20px;">
	</frameset>	
</frameset>

<body>

</body>
</html>