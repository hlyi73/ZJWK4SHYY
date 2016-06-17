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
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.min.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_validation/jquery.metadata.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet"
	href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js"
	type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"
	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"
	rel="stylesheet" type="text/css" />
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"
	type="text/javascript"></script>
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
	
</script>
</head>
<body>
	<div id="site-nav" class="navbar" style="height: 60px;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<input type="hidden" name="currpage" value="1" /> <a
			href="javascript:void(0)" class="list-group-item listview-item">
			<div class="list-group-item-bd"
				style="width: 180px; margin: 0 auto; padding-top: 10px;">
				<p>
				<div class="form-control select _viewtype_select">
					<div class="select-box2">指尖微客</div>
				</div>
				</p>
			</div>
		</a>
	</div>
	<div
		style="width: 100%; margin-top: 15px; border-bottom: 1px solid #ccc;">
		<span style="height: 30px; line-height: 30px; padding-left: 15px;">基本信息</span>
		<span style="height: 30px; line-height: 30px; padding-left: 35px;">关系网</span>
		<span style="height: 30px; line-height: 30px; padding-left: 55px;">事件</span>
	</div>

	<div style="float: right;">
		<span style="height: 30px; line-height: 30px; padding-right: 35px;">编辑</span>
		<span style="height: 30px; line-height: 30px; padding-right: 25px;">删除</span>
		<span style="height: 30px; line-height: 30px; padding-right: 15px;">短信分享</span>
	</div>


	<div
		style="background: #fff; width: 100%;height:25%; margin-top: 35px; border-bottom: 1px solid #ccc;">
		<div style="background: #fff; float: left;width:30%; height:40%;">
			<image style="float:center;width:100%; height:100%; margin-top:40px;"src="/ZJWK/image/account.png"></image>
		</div>
		<div style="background: #fff; margin-top: 35px;width:70%; float: right;height:40%;">
			<div style="background: #fff; margin-top:5px; float:left;width:70%;">王鸿CEO</div>
			<div style="background: #fff; margin-top:5px; float:left;width:70%;">北京德诚鸿业咨询有限公司</div>
			<div style="background: #fff; margin-top:5px; float:leftt;width:70%;">13389565465</div>
			<div style="background: #fff; margin-top:5px; float:leftt;width:70%;">wanghong@163.com</div>
			<div style="background: #fff; margin-top:5px; float:leftt;width:70%;">北京市朝阳区145号</div>
		</div>
	</div>



</body>
</html>