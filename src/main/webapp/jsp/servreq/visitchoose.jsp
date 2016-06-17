<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<style>
.type_left{
	border: 1px solid #ddd; 
	margin: 20px 10px 0px 20px; 
	padding: 10px;
	background-color:#fff;
	color:#666;
}
.type_right{
	border: 1px solid #ddd;
	margin: 20px 20px 0px 10px; 
	padding: 10px;
	background-color:#fff;
	color:#666;
}
</style>
<script>


</script>
</head>
<body>
	<!-- 日程创建FORM DIV -->
	<div id="taskCreate">
		<div id="site-nav" class="navbar" >
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">选择合同类型</h3>
		</div>
	</div>
	<!-- 任务类型 -->
	<div class="card-info"
		style="text-align: center; z-index: 99999; opacity: 1;">
		<div style="float: left; width: 50%;">
			<a
				href="<%=path%>/complaint/getvisit_zijie?openid=${openid}&publicid=${publicid}&parenttype=${parenttype}&parentid=${parentid}&flag=${flag}&parentname=${parentname}&parenttypeName=${parenttypeName}">
				<div class="type_left">
					<div>
						<img src="<%=path%>/image/wx_parnter.png"
							style="width: 36px;">
					</div>
					<div style="text-align: center; margin-top: 10px;">自接合同</div>
				</div>
			</a>
		</div>
		<div style="float: left; width: 50%;">
			<a
				href="<%=path%>/complaint/getvisit?openid=${openid}&publicid=${publicid}&parenttype=${parenttype}&parentid=${parentid}&flag=${flag}&parentname=${parentname}&parenttypeName=${parenttypeName}">
				<div class="type_right">
					<div>
						<img src="<%=path%>/image/oppty_partner.png" style="width: 36px;" />
					</div>
					<div style="text-align: center; margin-top: 10px;">非自接合同</div>
				</div>
			</a>
		</div>
		<div style="clear:both;"></div>
	</div>
</body>
</html>