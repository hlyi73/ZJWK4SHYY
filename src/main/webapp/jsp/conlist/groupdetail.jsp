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
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/model/conlist_groupdetail.model.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />
<script type="text/javascript">
$(function(){
	new ConList_Group_Singel();
});
</script>

</head>
<body>
	<div id="site-nav" class="navbar" style="height:60px;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<input type="hidden" name="currpage" value="1" /> 
		<a href="javascript:void(0)" class="list-group-item listview-item">
			<div class="list-group-item-bd" style="width: 180px; margin: 0 auto; padding-top:10px; ">
				<p>
				<div class="form-control select _viewtype_select">
					<div class="select-box2">分组联系人</div>
				</div>
				</p>
			</div>
		</a>
	</div>
	<div class="" style="width: 100%; background-color: #fff;">
	    <c:forEach items="${singleconList}" var="s">
	    	<a href="<%=path%>/jsp/conlist/contactindex.jsp">
				<div class="" style=" width: 100%; background-color: #fff; padding-left: 25px;line-height: 40px; border-bottom: 1px solid #DBD9D9;">${s.conname}</div>
			</a>	
	    </c:forEach>
	</div>
	<!-- 查询区域End -->
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>

