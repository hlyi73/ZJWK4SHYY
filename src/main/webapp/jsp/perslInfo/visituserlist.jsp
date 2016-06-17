<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@page import="com.takshine.wxcrm.domain.WxuserInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<!-- comlibs page -->
<%@ include file="/common/comlibs.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js"></script>
<script src="<%=path%>/scripts/plugin/arttemp.js"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/model/visituser.model.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css">
<link rel="stylesheet" href="<%=path%>/css/personalmsg.css">
<script type="text/javascript">
	$(function() {
		//访客历史列表
    	var visitUser = new VisitUser({
    		con: 'visitusercon',
    		visitname:'${visitUser.nickname}',
    		currpartyid:'${user.party_row_id}',
    		bcpartyid:'${visitUser.party_row_id}'
    	});
	});

</script>
</head>
<body style="min-height: 100%;">
	<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right: 45px;">访客历史列表</h3>
	</div>
	<div class="site-recommend-list page-patch visit_list">
		<div class="list-group1 listview">
			<!-- 最近访客 -->
	 		<div class="list-group-item listview-item" style="padding-top:0px;">
				<div class="visitusercon w100">
					<div class="content" style="float:left; margin-top:10px;width: 100%;font-size: 14px;line-height:25px;">
					</div>
					<div class="showAll none" style="cursor: pointer; color: #51BBEC; padding-top: 5px; padding-bottom: 5px;font-size: 14px; text-align: center; padding-top: 5px; padding-bottom: 5px;">
						查看全部&nbsp;↓
					</div>
					<div class="content_more none" style="float:left;width: 100%;font-size: 14px;line-height:25px;">
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>