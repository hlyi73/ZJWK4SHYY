<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
    String ossImgPath = "http://" + PropertiesUtil.getAppContext("aliyun.oss.bucket.pic").concat(".").concat(PropertiesUtil.getAppContext("aliyun.oss.endpoint")).concat("/");
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<script type="text/javascript">
	 //微信网页按钮控制
	/* function initWeixinFunc(){
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});

		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
	 
	$(function () { 
		//initWeixinFunc();
		
		initForm();
	});
	
	function initForm(){
		$(".signinbtn").click(function(){
			var latitude = $(":hidden[name=latitude]").val();
			var longitude = $(":hidden[name=longitude]").val();
			window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent('/sign/get?signType=signIn&publicId=${publicId}&openId=${openId}&signLatitude='+longitude+'&signLongitude='+latitude);
			//window.location.href="<%=path%>/sign/get?signType=signIn&publicId=${publicId}&openId=${openId}&signLatitude="+longitude+"&signLongitude="+latitude;
		});
		
		$(".signoutbtn").click(function(){
			var latitude = $(":hidden[name=latitude]").val();
			var longitude = $(":hidden[name=longitude]").val();
			window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent('/sign/get?signType=signOut&publicId=${publicId}&openId=${openId}&signLatitude='+longitude+'&signLongitude='+latitude);
			//window.location.href="<%=path%>/sign/get?signType=signOut&publicId=${publicId}&openId=${openId}&signLatitude="+longitude+"&signLongitude="+latitude;
		});
	}
	
	function searchSign(){
		if($(".searchSign").css("display") == "none"){
			$(".searchSign").css("display","");
		}else{
			$(".searchSign").css("display","none");
		}
	}
</script>
</head>
<body style="min-height:100%;background-color:#fff;">
	<input type="hidden" name="latitude" value="">
	<input type="hidden" name="longitude" value="">
	<div id="site-nav" class="navbar" style="">
		<div style="float: left;line-height:50px;">
			<a href="<%=path %>/home/index?openId=${openId}&publicId=${publicId}" style="padding:10px 5px;">
				<img src="<%=path %>/image/back.png" width="30px">
			</a>
		</div>
		<h3 style="padding-right:45px">签到表</h3>	
	</div>
	
	<%--导航 --%>
	<div
		style="width: 100%; text-align: center; background-color: #fff; height: 40px; line-height: 40px; border-bottom: 1px solid #DBD9D9;font-size:14px;">
		<div style="float: left; width: 33.33333%; border-right: 1px solid #eee;">
			<a href="<%=path%>/sign/list?openId=${openId}&publicId=${publicId}&stype=week">
				<div style="width: 100%;">
					本周<img src="<%=path%>/image/wxcrm_down.png" width="12px">
				</div>
			</a>
		</div>
		<div style="float: left; width: 33.33333%; border-right: 1px solid #eee;">
			<a href="<%=path%>/sign/list?openId=${openId}&publicId=${publicId}&stype=month">
				<div style="width: 100%;">
					本月<img src="<%=path%>/image/wxcrm_down.png" width="12px">
				</div>
			</a>
		</div>
		<div style="float: left; width: 33.33333%; border-right: 1px solid #eee;">
			<a href="javascript:void(0)" onclick='searchSign()'>
				<div style="width: 100%;">
					更多<img src="<%=path%>/image/wxcrm_down.png" width="12px">
				</div>
			</a>
		</div>
	</div>
	<div style="clear: both;"></div>

	<div class="searchSign" style="width:100%;height:35px;line-height:35px;font-size:12px;border-bottom:1px solid #efefef;display:none;">
		<a href="<%=path%>/sign/list?openId=${openId}&publicId=${publicId}&stype=search&search=30" style="width:33.33333%;float:left;">
			<div style="width:100%;float:left;text-align:center;">30天内</div>
		</a>
		<a href="<%=path%>/sign/list?openId=${openId}&publicId=${publicId}&stype=search&search=60" style="width:33.33333%;float:left;">
			<div style="width:100%;float:left;text-align:center;">60天内</div>
		</a>
		<a href="<%=path%>/sign/list?openId=${openId}&publicId=${publicId}&stype=search&search=90" style="width:33.33333%;float:left;">
			<div style="width:100%;float:left;text-align:center;">90天内</div>
		</a>
	</div>
    
	<%--没有数据 --%>
	<c:if test="${fn:length(signList) == 0 }">
		<div style="width:100%;text-align:center;font-size:12px;color:#999;padding-top:80px;">
			没有找到数据
		</div>
	</c:if>
	<%--考勤 --%>
	<div id="div_sign" class="bgcw conBox">
		<dl class="hyrc" id="tc01">
			<c:forEach items="${signList }" var="sign" varStatus="stat">
				<dt style="line-height: 34px;min-width:90px;padding: 5px 0px 5px 0px;">
					<fmt:formatDate pattern="MM-dd HH:mm" value="${sign.createTime }" type="both"/>
					<span style="top: 16px;"></span>
				</dt>
				<dd style="width: 70%; cursor: pointer;padding: 5px 0px 5px 17px;">
					<div style="border: 1px solid #ededed; border-radius: 3px; background: #f8f8f8; line-height: 24px; text-indent: 0; padding: 4px 4px 4px 6px;">
						<ul class="qd_info" style="font-size:12px;" info_name="${sign.name}" info_signType="${sign.signType}" info_sognAddr="${sign.signAddr}" info_remark="${sign.remark}"
						     info_wximgids ="${sign.wximgids}" info_date="${sign.signTime }">
							<c:if test="${sign.name ne '' && !empty(sign.name)}">
								【${sign.name}】
							</c:if>
							<c:if test="${sign.signType eq 'signIn'}">
								【签到】
							</c:if>
							<c:if test="${sign.signType eq 'signOut'}">
								【签退】
							</c:if>
							${sign.signAddr} 
						</ul>
					</div>
				</dd>

			</c:forEach>
		</dl>
	</div>
	<div style="clear:both"></div>
	<!-- 详情 info-->
    <div id="site-info" class="navbar" style="position: absolute;top:0px;display:none;background-color: #ffffff;z-index:9998;min-height: 100%;width:100%;">
		<div style="float: left;line-height:50px;">
			<a href="javascript:void(0);" id="site-info-back" style="padding:10px 5px;">
				<img src="<%=path %>/image/back.png" width="30px">
			</a>
		</div>
		<h3 style="padding-right:45px;background-color:#61C590 ">签到详情</h3>
		  <div style="color:#000000;text-align: left;padding: 5px 5px 5px 15px;">	
			
			<div style="border-bottom: solid 1px #F3F0F0;">
				<span style="font-weight: bold;">姓名：</span><span id="info_name"></span>
			</div>
			<div style="border-bottom: solid 1px #F3F0F0;">
				<span style="font-weight: bold;">签到：</span><span id="info_signType"></span>
			</div>
			<div>
				<span style="font-weight: bold;">时间：</span><span id="info_date"></span>
			</div>
			<div style="border-bottom: solid 1px #F3F0F0;">
				<div ><span style="font-weight: bold;">地址:</span>
					<span id="info_sognAddr"></span>
				</div>
				<!-- <div    id="info_sognAddr" style="width:100px;"></div> -->
			</div>
			<div style="border-bottom: solid 1px #F3F0F0;">
				<div ><span style="font-weight: bold;">备注:</span>
					<span id="info_remark"></span>
				</div>
			</div>
			<div>
				<div style="font-weight: bold;">图片</div>
				<div style="word-break:normal;" id="info_wximgids"></div>
			</div>
		</div>	
	</div>

	<br/><br/><br/><br/><br/><br/><br/>
	<div class="flooter loading" style="padding:0px 5px 5px 5px;border-top: 1px solid #efefef;"><img src="<%=path%>/image/loading.gif"></div>
	<div class="button-ctrl flooter sign_div" style="padding:0px 5px 5px 5px;border-top: 1px solid #efefef;display:none;">
		<fieldset class="">
			<div class="ui-block-a signinbtn">
				<a href="javascript:void(0)" class="btn btn-success btn-block"
					style="font-size: 14px;">签到</a>
			</div>
			<div class="ui-block-a signoutbtn">
				<a href="javascript:void(0)" class="btn btn-block"
					style="font-size: 14px;">签退</a>
			</div>
		</fieldset>
	</div>
<!-- 图片显示info -->	
	<div id="img_info"  style="z-index:9999;background-color: #ffffff;position: absolute;top:0px;display:none;width: 100%;height:100%;">
		  <div class="navbar" style="width: 100%;">
			<div style="float: left;line-height:50px;">
				<a href="javascript:void(0);" id="img_info_back" style="padding:10px 5px;">
					<img  src="<%=path %>/image/back.png" width="30px">
				</a>
			</div>	
			  
		</div>
		<div  id="img_info_div" style="width: 100%;height:100%;"">
		 	<img id="img_info_body" src="" style="width:100%;">
		</div>
	</div>
	<jsp:include page="/common/wxjs.jsp"/>
	<style>
		.addressinfo{
		white-space:normal; width:90%; 
		}
	</style>
	<script type="text/javascript">
	  wx.ready(function () {
		  wxjs_getLocation({
			  success: function(res){
				  if(res.longitude && res.latitude){
					  $(":hidden[name=longitude]").val(res.longitude);
					  $(":hidden[name=latitude]").val(res.latitude);
					  $(".loading").css("display","none");
					  $(".sign_div").css('display','');
				  }else{
					  alert('定位失败！');
				  }
			  }
		  });
	  });
	  
	  $(".qd_info").click(function(){
		  $("#info_name").text($(this).attr("info_name"));
		  if($(this).attr("info_signType")=='signIn'){
			  $("#info_signType").text("签到");
		  }else  if($(this).attr("info_signType")=='signOut'){
			  $("#info_signType").text("签退");
		  }
		 
		  $("#info_sognAddr").addClass("addressinfo");
		  $("#info_sognAddr").text($(this).attr("info_sognAddr"));
		  $("#info_remark").addClass("addressinfo");
		  $("#info_remark").text($(this).attr("info_remark"));
		  var info_date = $(this).attr("info_date");
		  
		  $("#info_date").text(dateFormat(new Date($(this).attr("info_date")),"yyyy-MM-dd hh:mm"));
		   
		  var info_wximgids =$(this).attr("info_wximgids");
		  if(info_wximgids!=''){
			  var v="";
			  var wximgids =info_wximgids.split(",");
			  if(wximgids.length>0){
				  for(var i = 0 ;i<wximgids.length-1;i++){
			 	 	v += '<div class="single_image" style="float: left;"><img style="margin:2px;" class="messages_imgs_list" onclick="zjwk_prev_img(this)" src="<%=ossImgPath%>'+wximgids[i]+'" width="64px;" height="64px" style="float:left;width:64px;height:64px;">';
				 	v += '</div>';					  
				  }
				 $("#info_wximgids").html(v); 
			  }
		  }
		  $("#info_wximgids").attr("src",$(this).attr("info_wximgids"));
		  $(".button-ctrl").hide();
		  $("#site-info").show();
	  });
	  $("#site-info-back").click(function(){
		  $("#site-info").hide();
		  $(".button-ctrl").show();
		  
	  });
	  $("#img_info_back").click(function(){
		  $("#img_info").hide();
		 
	  });
	  
	  function zjwk_prev_img(o){
	 	  $("#img_info_body").attr("src",$(o).attr("src"));
		  $("#img_info").show();
		  
	  }


	  $("#img_info_body").click(function () {
		  $("#img_info").hide();
	  });
	 
	 
	</script>
</body>
</html>