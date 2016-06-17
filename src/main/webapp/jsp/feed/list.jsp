<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>

</head>
<body>
<div id="site-nav" class="navbar">
	<jsp:include page="/common/back.jsp"></jsp:include>
	<div style="padding-right:50px;height:51px;">活动流</div>
</div>

<!-- 公共部份 -->
<jsp:include page="/common/feedlist.jsp"></jsp:include>
<!-- 底部 -->
<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>