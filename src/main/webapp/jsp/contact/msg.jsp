<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Meta -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
</head>
<body>
	<div class="wrapper" style="margin-right:0px;margin-left:0px;margin-top:0px;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<p class="text-center" style="width:100%;color:white;height:50px;line-height:50px;background-color:#3e6790">
			二维码名片
		</p>
		<div style="padding-left:20px;padding-top:20px;">
		<c:if test="${contactAdd.filename eq ''}">
			<img  style="height:60px;width:60px;float:left;" src="<%=path%>/image/defailt_person.png"/>
		</c:if>
		<c:if test="${contactAdd.filename ne ''}">
			<img  style="height:60px;width:60px;float:left;" src="<%=path%>/contact/download?fileName=${contactAdd.filename}"/>
		</c:if>
			<div style="float:clear;"></div>
			<div style="float:left;margin-left:20px;line-height:20px;font-size:14px;">
				<c:if test="${conname ne ''}">
					<p>姓名：${conname}</p>
				</c:if>
				<c:if test="${contactAdd.conaddress ne ''}">
					<p>地址：${contactAdd.conaddress}</p>
				</c:if>
			</div>
		</div>
		</div>	
		<div style="padding-top:60px;border-bottom: 1px solid #DDD;margin: 4px 4px 4px 8px;width: 96%;">&nbsp;</div>
		<div style="text-align: center;padding-top:30px;">
		    <img src="<%=path%>/cache/${filename}">
		</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
    
</body>
</html>