<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>指尖微客</title>
<%@ include file="/common/comlibs.jsp"%>
<link href="<%=path%>/css/pc/zjwk.module.css" rel="stylesheet">
<link href="<%=path%>/css/pc/style.css" rel="stylesheet">
<link href="<%=path%>/css/pc/wx.css" rel="stylesheet">
<link href="<%=path%>/css/pc/wxedit.css" rel="stylesheet">
<link href="<%=path%>/css/pc/wxdetail.css" rel="stylesheet">
<link href="<%=path%>/css/pc/font-awesome.min.css" rel="stylesheet">
<link href="<%=path%>/css/pc/bootstrap.min.css" rel="stylesheet">
<link href="<%=path%>/css/pc/charts-graphs.css" rel="stylesheet">
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"></script>
<script src="<%=path%>/css/pc/bootstrap.min.js"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<meta charset="UTF-8">
<script type="text/javascript">
	$(function() {
		var height = screen.height;
		$(".dashboard-wrapper").css("min-height", parseInt(height) * 0.9);
	});
</script>
</head>
<body style="background: #0B4364;">
	<!-- 菜单 -->
	<header style="line-height: 100px;">
		<div style="float: left; padding-bottom: 80px;">
			<a href="java" class="logo" data-original-title="" title=""> <span
				style="color: #fff; font-size: 30px; font-weight: bold;">指尖活动</span>
				<span style="color: #aaa; font-size: 18px;">&nbsp;&nbsp;连接企业资源，世界尽在指尖</span>
			</a>
		</div>
	</header>
	<!-- Header End -->
	<!-- Main Container start -->
	<div class="dashboard-container" style="margin-top: 100px;">
		<div class="container">
			<!-- Top Nav Start -->
			<div class="top-nav hidden-xs hidden-sm">
				<div class="clearfix"></div>
			</div>
		</div>
	</div>
	<!-- 菜单结束 -->
	<div class="dashboard-wrapper" style="background-color: #e7e8eb;">
		<!-- Left Sidebar Start -->
		<div id="js_article" class="rich_media ">
        <div id="js_top_ad_area" class="top_banner"></div>
        <div class="rich_media_inner">
            <h2 class="rich_media_title" id="activity-name">
                dasdas 
            </h2>
            <div class="rich_media_meta_list">
                <em id="post-date" class="rich_media_meta text">2014-12-24</em>
                <em class="rich_media_meta text">dasdas</em>
                <a class="rich_media_meta link nickname" href="javascript:void(0);" id="post-user">指尖微客</a>
            </div>
            <div id="page-content">
                <div id="img-content">
                </div>
            </div>
            <div id="js_pc_qr_code" class="qr_code_pc_outer" style="display: block;top:120px">
                <div class="qr_code_pc_inner">
                    <div class="qr_code_pc">
                        <img id="js_pc_qr_code_img" class="qr_code_pc_img" src="">
                        <p>微信扫一扫<br>获得更多内容</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
	</div>
	<!-- 底栏 -->
	<footer style="margin-top: 15px;">
		<p>@2015 指尖活动</p>
	</footer>
	<!-- 底栏结束 -->
</body>
</html>