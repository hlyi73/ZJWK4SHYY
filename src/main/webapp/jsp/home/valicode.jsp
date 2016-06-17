<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/> 
<script type="text/javascript">
$(function(){
	$(".valibtn").click(function(){
		var v = $("input[name=valicode]").val();
		window.location.href = '<%=path%>/home/valicode?valicode=' + v;
	});
});
</script>
</head>
<body style="background-color:#fff;">
	<div style="width:100%;padding:0px 80px;margin-top:100px;">
	<div style="text-align:center;"><img src="<%=path %>/image/takshine_logo.png" style="width:150px;"></div>
	<div style="margin-top:50px;"><input name="valicode" type="text" placeholder="请输入 F码"/></div>
	<div style="text-align:center;margin:50px 50px;"><input type="button" class="valibtn btn" value="进入"/></div>
	</div>
</body>
</html>