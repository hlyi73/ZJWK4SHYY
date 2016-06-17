<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
	<head>
	    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
	    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
		<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
		<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
		<!--框架样式-->
		<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
		<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
	    <title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>   
	</head>
<body>
	<div id="site-nav" class="navbar" style="line-height: 65px;height: 70px;">
		<c:if test="${bindSucc eq 'ok' || bindSucc eq 'already'}">
			<div class="act-secondary" data-toggle="navbar"
				data-target="nav-collapse">
<!-- 				<i class="icon-menu"><b></b></i> -->
			</div>
		</c:if>
		<%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %>
	</div>
    <jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="view site-phonebook">
		<div class="text-center wrapper" style="padding: 1em 0;">
			<c:if test="${bindSucc eq 'ok'}">
				<div style="width:100%;text-align:center;">
 					<img src="<%=path %>/image/oper_success.png" width="80px" >
 				</div>
 				<br/>
				<h3 class="text-info" style="font-size: 18px;">账户绑定成功!</h3>
			    <br><br> 如需使用请联系管理员!<br>
			</c:if>
			<c:if test="${bindSucc eq 'already'}">
				<div style="width:100%;text-align:center;">
 					<img src="<%=path %>/image/oper_fail.png" width="100px" >
 				</div>
 				<br/>
			    <h3 class="text-info" style="font-size: 18px;color:red">您的账户已被占用!</h3>
			     <br><br>  请退出并重新访问，如有问题请联系管理员！<br>
			</c:if>
			<c:if test="${bindSucc eq 'fail'}">
				<div style="width:100%;text-align:center;">
 					<img src="<%=path %>/image/oper_fail.png" width="100px" >
 				</div>
 				<br/>
			    <h3 class="text-info" style="font-size: 18px;color:red">账户绑定失败!</h3>
			    <br> 请与管理员联系<br> 确认您在crm系统中是否已经开户<br>
			</c:if>
			<c:if test="${bindSucc eq 'sources'}">
				<div style="width:100%;text-align:center;">
 					<img src="<%=path %>/image/oper_fail.png" width="100px" >
 				</div>
 				<br/>
			    <h3 class="text-info" style="font-size: 18px;color:red">系统异常!</h3>
			    <br> 请与管理员联系<br> openId 和 publickId 不能为空<br>
			</c:if>
		</div>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>