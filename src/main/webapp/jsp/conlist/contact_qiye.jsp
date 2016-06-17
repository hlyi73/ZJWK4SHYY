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
	<div id="site-nav" class="navbar" style="height:60px;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<input type="hidden" name="currpage" value="1" /> 
		<a href="javascript:void(0)" class="list-group-item listview-item">
			<div class="list-group-item-bd" style="width: 180px; margin: 0 auto; padding-top:10px; ">
				<p>
				<div class="form-control select _viewtype_select">
					<div class="select-box2">指尖微客</div>
				</div>
				</p>
			</div>
		</a>
	</div>
	<div
		style="background: #fff; height:50px; width: 100%; margin-top: 5px; border-bottom: 1px solid #ccc;">
		<span style="height: 30px; line-height: 30px; padding-left: 15px;">基本信息</span>
		<span style="height: 30px; line-height: 30px; padding-left: 35px;">关系网</span>
		<span style="height: 30px; line-height: 30px; padding-left: 55px;">事件</span>
	</div>

	<div
		style="background: #fff; padding: 15px 0 0 0; clear: both; border-bottom: 1px solid #ccc; height: 80px;">
		<div>
			<span
				style="height: 30px; line-height: 30px; padding-left: 15px; float: left;">田国生</span>
			<span style="height: 20px; line-height: 30px; padding-left: 35px;">183225513</span>
		</div>
		<div
			style="height: 20px; line-height: 30px; padding-left: 15px; float: left;">中国大自然总区副总裁</div>
	</div>

	<div
		style="background: #fff; height: 40px; width: 100%; margin-top: 5                                                                                                                                      px; border-bottom: 1px solid #ccc;">
		<span style=" line-height: 30px; padding-left: 15px;">分组：专家</span>
	</div>
	<div
		style="background: #fff; height: 40px; width: 100%; margin-top: 5px; border-bottom: 1px solid #ccc;">
		<span style="line-height: 30px; padding-left: 15px;">负责人：王斌</span>
	</div>
	<div
		style="background: #fff; height: 40px; width: 100%; margin-top: 5px; border-bottom: 1px solid #ccc;">
		<span style="line-height: 30px; padding-left: 15px;">协同团队：王斌、熊勇</span>
	</div>
<div
		style="height: 40px; width: 100%; margin-top: 5px; border-bottom: 1px solid #ccc;margin-down: 5px; ">
		<span style=" line-height: 30px; padding-left: 15px;">跟进历史</span>
	</div>


	
</body>
</html>