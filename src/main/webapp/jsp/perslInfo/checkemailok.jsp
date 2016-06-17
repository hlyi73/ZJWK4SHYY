<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"  
    pageEncoding="UTF-8"%>  
<%@ page import="java.lang.Exception"%> 
<%  
    String path = request.getContextPath();
	//String msg = e.getMessage(); 
	//String appFocusUrl = PropertiesUtil.getAppContext("app_focus_url");
%>
<!DOCTYPE html>
<html lang="en">  
	<head>  
		<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">  
		<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
		<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
		<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
		<link rel="stylesheet" href="<%=path%>/css/style.css" id="style_color">
		<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
	</head>  
	<body style="background-color:#fff;height:100%;">  
		<div id="site-nav" class="navbar">
			<h3 style="padding-right:45px;">系统提示</h3>
		  	
		</div>
		
			<div style="width:100%;min-height: 100px;margin-top:50px;text-align:center;">
				<img src="<%=path %>/image/loading.gif">${msg}
			</div>
	</body>  
</html> 


