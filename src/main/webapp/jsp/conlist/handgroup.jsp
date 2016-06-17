<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/model/conlist_group.model.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />
<script type="text/javascript">
	$(function() {
		new ConList_Group();
	});
</script>

</head>
<body>
	<div class="" style="width: 100%; background-color: #fff;">
		<div style="width: 100%; background-color: #fff; line-height: 40px;">
			<c:if test="${fn:length(groupList) >0 }">
				<c:forEach items="${groupList}" var="con">
						<a href="<%=path%>/contact/clist?tagtype=${con.tagName}&viewtype=myview" style="margin-top: 10px;">
							<div style="float: left; width: 100%; text-align: left; padding-left: 25px; background-color: #fff; border-bottom: 1px solid #E2E2E2;">
									${con.tagName}
								<div style="color: #A9A5A5; float: right; margin-right: 14px; font-size: 12px;">
										${con.total}人<img src="/ZJWK/image/arrow_normal.png"
										style="margin-left: 10px; height: 10px;">
								</div>
							</div>
						</a>
				</c:forEach>
			</c:if>
			<c:if test="${fn:length(groupList) == 0 }">
				<div class=" nodata " style="position: fixed; width: 100%; text-align: center; margin-top: 45px;">没有找到数据</div>
			</c:if>
		</div>

		<!-- 查询区域End -->
		<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>

