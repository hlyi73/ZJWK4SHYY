<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<!--STATUS OK-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">

</head>
<body style="background-color:#fff;">
	<div id="site-nav" class="navbar" style="display:none;">
		通知
	</div>
	<div id="content"
		style="min-height: 200px; position: inherit; top: -6px; z-index: 999; width: 100%;">
		<div id="contact" style="margin-bottom: 50px;">
			<c:if test="${type eq 'more'}">
				<jsp:include page="/common/more.jsp"></jsp:include>
			</c:if>
			<c:if test="${type ne 'more'}">
				<jsp:include page="/common/notice.jsp"></jsp:include>
			</c:if>
			
		</div>
	</div>
	<jsp:include page="/common/menu.jsp"></jsp:include>

	<br />
	<br />
	<br />
	<br />
</body>
</html>