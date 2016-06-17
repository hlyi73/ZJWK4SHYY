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
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />
 </head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">角色列表</h3>
	</div>

	<div style="clear: both"></div>
	<div class="site-recommend-list page-patch acclist">
		<div class="list-group listview" id="div_accnt_list">
			<c:forEach items="${roleList }" var="role">
				<a href="<%=path%>/userFunc/role?roleId=${role.roleId}&orgId=${orgId}"
					class="list-group-item listview-item">
					<div class="list-group-item-bd">
						 ${role.funName }
					</div>
					<div class="list-group-item-fd">
						<span class="icon icon-uniE603"></span>
					</div>
				</a>
			</c:forEach>
			<c:if test="${fn:length(roleList) == 0 }">
				<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
			</c:if>
		</div>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>

</body>
</html>