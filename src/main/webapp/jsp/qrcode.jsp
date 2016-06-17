<%@page import="com.takshine.wxcrm.base.util.cache.RedisCacheUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Meta -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
	<%@ include file="/common/jquerylibs.jsp"%><!-- jquerylibs.jsp page -->
	
	<script type="text/javascript">
			//页面初始化
			function init() {
				//initWeixinFunc();
				initFormBtn();
				rstFunc();
			}
	/* 		//微信网页按钮控制
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
			//初始化查询区域按钮
			function initFormBtn(){
				//TODO 
			}
			function rstFunc(){
		        //TODO 
		    }
	</script>
	<!-- 初始化调用 -->
	<script type="text/javascript">
	$(function() {
		init();
		
		var focusurl = "${focus_url}";
		if(focusurl){
			window.location.replace(focusurl);
		}else{
			$(".focus_div").css("display","");
		}
	});
	</script>
</head>

<body>
<div>
	<div class="focus_div" style="display:none;margin-top:80px;text-align:center;font-size:16px;">
		<img src="<%=path %>/image/oper_success.png">
		<div style="text-align:center;width:100%;margin-top:20px;color:#555;font-size:16px;font-family:'Microsoft Yahei'">扫码登陆操作已完成，请关闭！</div>
	</div>
</div>

</body>
</html>