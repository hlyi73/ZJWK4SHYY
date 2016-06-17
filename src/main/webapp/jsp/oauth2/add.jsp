<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
	<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
	<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
	<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
	<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
	
</head>
<body>
	<a href="${url}">点我进行网页授权</a>
</body>
</html>