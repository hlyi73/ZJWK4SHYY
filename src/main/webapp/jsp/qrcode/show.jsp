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
    <title>查看公司二维码</title>
    
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">

</head>

<body>
	<div class="wrapper">
		<p class="well text-center">
			二维码<br>（请扫描二维码）
		</p>
		<p style="text-align: center" class="alert alert-warning">
		    <img alt="" style="width:258px;height:258px" src="<%=path%>/download/gQHP7zoAAAAAAAAAASxodHRwOi8vd2VpeGluLnFxLmNvbS9xL0hFelFPaGJtM3d5bW1xS1V3bURHAAIEs0sSUwMEAAAAAA==.jpg">
		</p>
	</div>
    <!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://www.8191.cn/upload/201312/20/small_201312201808548042.jpeg",  
			TLImg:"http://www.8191.cn/upload/201312/20/small_201312201808548042.jpeg",  
			url: window.location.href,  
			title:"二维码",  
			desc:"分享二维码信息",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>