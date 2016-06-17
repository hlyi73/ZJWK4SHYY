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
	<div id="site-nav" class="navbar" style="line-height: 65px;height: 65px;">
		<%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %>
	</div>
    <jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="view site-phonebook">
		<div class="text-center wrapper" style="padding: 1em 0;">
			<c:if test="${regSucc eq 'ok'}">
				<div style="width:100%;text-align:center;">
 					<img src="<%=path %>/image/oper_success.png" width="80px" >
 				</div>
 				<br/>
				<h3 class="text-info" style="font-size: 18px;">感谢您的关注!</h3>
			    <br><br> 我们的工作人员将会联系您! <br>
			</c:if>
			
		</div>
	</div>

</body>
</html>