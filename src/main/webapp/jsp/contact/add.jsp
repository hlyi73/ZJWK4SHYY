<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/template.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/css/slider.css" />
<!-- 验证控件 -->
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.js" type="text/javascript"></script>
<script>
$(function (){
	var pid = $("input[name=parentId]").val();
	if(pid != ""){
		$("#div_contact_parent_sel").css("display","");
		$("#div_contact_name_label").css("display","");
		$("#div_contact_name_operation").css("display","");
		$("#div_contact_parent_sel").find("#user_select").html('${parentName}');
	}else{
		$("#div_contact_parent_label").css("display","");
	}
});

//保存联系人
function confirmConfirm(){
	 $("#contactForm").submit();
}

</script>
</head>

<body>
	<!-- 导航栏菜单 -->
	<div id="contact-create">
		<div id="" class="navbar">
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">新建联系人</h3>
		</div>
		<jsp:include page="/common/contactform.jsp"></jsp:include>
	</div>
	<br/><br/><br/><br/><br/><br/><br/><br/>
</body>
</html>