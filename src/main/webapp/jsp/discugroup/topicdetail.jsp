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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />
<link rel="stylesheet" href="<%=path%>/css/style.css" id="style_color" />

<script type="text/javascript">
	jQuery(window).load(function () {  
		$(".imglist").each(function(){
			 var img = new Image();
			 img.src =$(this).attr("src") ;
			 var w = img.width;
			 if(w > $(window).width()){
				   $(this).css("width",$(window).width() - 16);
			 }
		 });  
	});  
	
</script>

</head>
<body style="background-color:#fff;height:100%;font-family:'Microsoft Yahei';font-size:14px;">
	<div id="site-nav" class="navbar" style="display:none;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;display: block;font-size:16px;-webkit-margin-after: 1em;-webkit-margin-start: 0px;-webkit-margin-end: 0px;font-weight: bold;font-family:'Microsoft Yahei'">指尖微客</h3>
	</div>
	<div style="clear: both"></div>
   <!-- 后台查询 -->
   		<div class="content" style="margin: 8px;line-height:25px;text-indent: 2em;">
			${topic.content }
		</div>
		<div style="clear: both"></div>
		<div style="width:100%;padding: 5px 8px;">
			<div style="padding-top: 5px; font-size: 8px; color: #fff;" class="imageContaint">
					<c:if test="${fn:length(imgList) >0 }">
						<c:forEach items="${imgList}" var="img">
							<span class="imgspan_${img.id}"><img class="imglist" id="${img.id }" src="${filepath }/${img.source_filename}"></span>
						</c:forEach>
					</c:if>
					<c:if test="${fn:length(imgList) ==0 }">
						  没有图片信息
					</c:if>		
			</div>
		</div>
	<!-- 话题分享 -->
	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
	    var name = '原创';
	    var desc = '${topic.content}';
		wx.ready(function () {
		  var opt = {
			  title : name,
		      desc : desc,
			  link: "${shorturl}",
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>