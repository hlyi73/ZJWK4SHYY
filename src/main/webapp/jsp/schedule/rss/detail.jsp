<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>  
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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
</head>
<body style="min-height:100%;">
	<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:63px;">相关新闻</h3>
	</div>
	<div class="site-recommend-list page-patch">
		<div id="div_rssnews_list" class="list-group listview">
			<c:forEach items="${rssnews}" var="rss">
				<a href="${rss.link}" class="list-group-item listview-item" style="padding:5px;">
					<div class="list-group-item-bd">
						<div class="thumb list-icon" style="background-color:#ffffff;">
						<c:if test="${rss.imgurl ne '' && rss.imgurl != null }">
							<img src="${rss.imgurl }" border=0 width="110px" height="64px;"style="background-color:#ffffff;max-width: 137px;  max-height: 64px;">							
						</c:if>
						<c:if test="${rss.imgurl == null || rss.imgurl eq ''}">
							<img src="<%=path%>/image/logo-news.gif" border=0 width="110px" height="64px;"style="background-color:#ffffff;max-width: 137px;  max-height: 64px;">							
						</c:if>
						</div>
						<div class="content" style="text-align: left">
							<h2>${rss.title}</h2> 
							<p class="text-default">发布日期： 
								${rss.pubdate}
							 </p>
						</div>
					</div>
					<div class="list-group-item-fd detailAprDiv" >
							<span class="icon icon-uniE603"></span>
					</div>
				</a>
				<div style="width:100%;line-height:25px;padding-left:10px;font-size:12px; color:#999">
					来源于 <a href="javascript:void(0)">【${rss.author}】</a>
				</div>
<!-- 				<div class="list-group-item-fd" style="padding:15px 10px 10px;color: #fff;float: left;"> -->
<%-- 					<span>作者：${rss.author}</span> --%>
<!-- 				</div> -->
				<div style="clear:both;"></div>
			</c:forEach>
			<c:if test="${fn:length(rssnews)==0}">
				<div style="text-align:center;padding-top:40px;">没有相关新闻</div>
			</c:if>
		</div>
	</div>
<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>