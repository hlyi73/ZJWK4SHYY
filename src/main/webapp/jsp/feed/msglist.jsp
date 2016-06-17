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
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
	<script type="text/javascript">
    $(function () {
    	
	});
    
/*     //微信网页按钮控制
	function initWeixinFunc(){
		//隐藏顶部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
     
    
    
    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<div class="act-secondary" data-toggle="navbar"
			data-target="nav-collapse">
<!-- 			<i class="icon-menu"><b></b></i> -->
		</div>
		新回复
		
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<input type="hidden" name="replyDivId" value="" />
	<input type="hidden" name="publicId" value="${publicId}" /> 
	<input type="hidden" name="openId" value="${openId}" />
	<input type="hidden" name="currpage" value="1" />
	<div class="site-recommend-list page-patch">
		<div class="list-group listview" id="div_accnt_list">
			<c:forEach items="${feedList }" var="feed">
				<a href="<%=path%>/oppty/detail?openId=${openId}&publicId=${publicId}&rowId=${feed.objid}"
					class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<div class="content">
							<h3>来自&nbsp;${feed.username }&nbsp;<span style="color: #AAAAAA; font-size: 12px;">${feed.createdate }</span></h3>
							<p class="text-default">关于【${feed.name }】的回复</p>
							<p class="text-default">${feed.reply }</p>
						</div>
					</div>
					<div class="list-group-item-fd">
						<span class="icon icon-uniE603"></span>
					</div>
				</a>
			</c:forEach>
		</div>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>

</body>
</html>