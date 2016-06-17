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
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script type="text/javascript">
	$(function () {
		//initWeixinFunc();
	});
	
	/* //微信网页按钮控制
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
		<jsp:include page="/common/back.jsp"></jsp:include>
		回款列表
	</div>
		<jsp:include page="/common/navbar.jsp"></jsp:include>
		<div class="site-recommend-list page-patch">
			<div id="div_gathering_list" class="list-group listview">
				<c:forEach items="${gatheringList}" var="gath">
					<a href="#"
						class="list-group-item listview-item">
						<div class="list-group-item-bd">
							<div class="content" style="text-align: left">
								<h1>${gath.title }&nbsp;<span style="color: #AAAAAA; font-size: 12px;">${gath.assigner }</span></h1>
								<p class="text-default" style="font-size:16px;">收款日期：&nbsp;&nbsp;${gath.verifityDate}&nbsp;&nbsp;收款金额：￥${gath.verifityAmount} 万元</p>
							</div>
						</div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(gatheringList) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有找到数据</div>
				</c:if>
				</div>
		</div>
		<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>