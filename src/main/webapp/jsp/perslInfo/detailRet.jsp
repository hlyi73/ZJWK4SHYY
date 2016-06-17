<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
    String appFocusUrl = PropertiesUtil.getAppContext("app_focus_url");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery.flip.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/script.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/flip.styles.css" id="style_color"/>


</head>
<body>
	<div id="site-nav" class="navbar" style="background-color:RGB(75, 192, 171);width: 100%;">
		系统提示
	</div>
	
	<c:if test="${bindedFlag eq 'true'}">
		<div style="margin-top:80px;width:100%;text-align:center;color:#666;">该用户尚未公开Ta的信息，无法查看名片!</div> 
		<jsp:include page="/common/footer.jsp"></jsp:include>	
	</c:if>
	<c:if test="${bindedFlag eq 'false'}">
		<div class="" style="margin: 80px 0px;width:100%;text-align:center;">
			<span style="color:#666;">您尚未关注指尖微客，</span><a href="<%=appFocusUrl%>">
			点击关注！
			</a>
		</div>
	</c:if>
</body>
</html>