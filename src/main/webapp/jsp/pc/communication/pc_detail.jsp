<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<script src="<%=path%>/scripts/navbar.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
	$(function() {
		initWeixinFunc();
		gotopcolor();

	});

	//微信网页按钮控制
	function initWeixinFunc() {
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady',
				function onBridgeReady() {
					WeixinJSBridge.call('hideToolbar');
				});
	}

	function gotopcolor() {
		$(".gotop").css("background-color", "rgba(213, 213, 213, 0.6)");
	}

</script>
</head>
<body style="background-color: #fff;">
<div id="show" class="show">
	<div id="site-nav" class="navbar">
		<div class="act-secondary" data-toggle="navbar"
			data-target="nav-collapse"></div>
		<h3>${aInfo.title}</h3>
	</div>
	<div style="margin: 10px;">
		<div style="float: left;">${aInfo.descrition}</div>
		<div style="float: right;">
			<fmt:formatDate value="${aInfo.createTime }" type="both"
				pattern="yyyy-MM-dd " />
		</div>
	</div>
	<br />
	<br />

	<div style="margin: 10px;">
		<%--  <img src="<%=path%>/contact/download?fileName=${aInfo.image}" > --%>
		<img src="${aInfo.image}" width="100%;" height="120px;">
	</div>
	<div style="clear: both; border-bottom: 1px solid #eee; margin: 10px;">&nbsp;</div>

	<div style="margin: 15px;">
		<c:if test="${aInfo.content ne ''}">
		${aInfo.content} 
	</c:if>
	</div>
</div>
	<!-- 底部操作区域 -->
	<div class="flooter"
		style="z-index: 99999; background: #FFF; background: rgb(242, 242, 243); border-top: 1px solid #A2A2A2; opacity: 1;">
		<div class="msgContainer">
			<div class="ui-block-a "
				style="float: left; width: 15%; margin: 5px 0px 5px 0px;">
				<a href="<%=path%>/pccomm/modify?&id=${aInfo.id}" 
					style="font-size: 14px; padding: 0px; margin-left: 5px; margin-right: 5px;">修改</a>
			</div>
			<div style="clear: both;"></div>
		</div>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>

</body>
</html>