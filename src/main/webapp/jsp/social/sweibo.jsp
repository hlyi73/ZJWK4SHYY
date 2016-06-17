<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">

</head>
<body style="background-color: #fff;min-height:100%;">

	<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:30px;">我的微博</h3>
	</div>
	<div style="width:100%;background-color: #eee;">
		<div style="float:left;width:100px;padding:20px;border-radius: 5px; ">
			<img src="${wbuser.headimgurl}" width="60px;">
		</div>
		<div style="padding:20px;line-height:20px;">
			<p>昵称：${wbuser.nickname }</p>
				<p>关注数：${wbuser.friends_count}</p>
				<p>粉丝数：${wbuser.followers_count}</p>
		</div>
	</div>
	<div style="clear:both;margin-top:20px;"></div>
	<div class="site-recommend-list page-patch">
		<div class="list-group listview tasklist" style="margin-top: -1px;"
			id="div_tasks_list">
			<a href="<%=path%>/social/slist?openId=${openId}&publicId=${publicId}&accesstoken=${wbuser.access_token}&socialUID=${wbuser.uid}&currpage=1"
				class="list-group-item listview-item" style="height:80px;">
				<div class="list-group-item-bd">
					<div class="content" style="padding-left:20px;font-size:18px;font-weight:bold;">
						<img src="<%=path%>/image/oppty_partner.png" width="24px;">&nbsp;&nbsp;管理一度人脉（${fcount }）
					</div>
				</div>
				<div class="list-group-item-fd">
					<span class="icon icon-uniE603"></span>
				</div>
			</a>
			<a href="<%=path%>/social/slist?openId=${openId}&publicId=${publicId}&accesstoken=${wbuser.access_token}&socialUID=${wbuser.uid}&currpage=0&type=second"
				class="list-group-item listview-item" style="height:80px;">
				<div class="list-group-item-bd">
					<div class="content" style="padding-left:20px;font-size:18px;font-weight:bold;">
						<img src="<%=path%>/image/oppty_contact.png" width="24px;">&nbsp;&nbsp;发现二度人脉（${scount }）
					</div>
				</div>
				<div class="list-group-item-fd">
					<span class="icon icon-uniE603"></span>
				</div>
			</a>
			<a href="<%=path%>/social/search?openId=${openId}&publicId=${publicId}&accesstoken=${wbuser.access_token}&socialUID=${wbuser.uid}"
				class="list-group-item listview-item" style="height:80px;">
				<div class="list-group-item-bd">
					<div class="content" style="padding-left:20px;font-size:18px;font-weight:bold;">
						<img src="<%=path%>/image/oppty_contact.png" width="24px;">&nbsp;&nbsp;找人<span style="font-size:14px;">（根据名称或微博内容查找）</span>
					</div>
				</div>
				<div class="list-group-item-fd">
					<span class="icon icon-uniE603"></span>
				</div>
			</a>
		</div>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>