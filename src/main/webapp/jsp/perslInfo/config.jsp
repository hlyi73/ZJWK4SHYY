<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
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
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
var temp="";
	$(function() {
		var width = $(window).width();
		if (width > 640) {
			width = 640;
		}
		$(".bgimg").attr("width", width);

		
		  $(".contact").click(function(){
	          	$(".contact").attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	var s = $(this).attr("src");
	          	if(s.indexOf("checkbox2x") !== -1){
	          		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	}else{
	          		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
	          	}
	          });
		  $(".msm").click(function(){
	          	$(".msm").attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	var s = $(this).attr("src");
	          	if(s.indexOf("checkbox2x") !== -1){
	          		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	}else{
	          		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
	          	}
	          });
		  $(".message").click(function(){
	          	$(".message").attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	var s = $(this).attr("src");
	          	if(s.indexOf("checkbox2x") !== -1){
	          		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	}else{
	          		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
	          	}
	          });
		  $(".validation").click(function(){
	          	$(".validation").attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	var s = $(this).attr("src");
	          	if(s.indexOf("checkbox2x") !== -1){
	          		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	}else{
	          		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
	          	}
	          });
		  
		  $(".task").click(function(){
	          	$(".task").attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	var s = $(this).attr("src");
	          	if(s.indexOf("checkbox2x") !== -1){
	          		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	}else{
	          		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
	          	}
	          });
		  
		  $(".tasktype").click(function(){
	          	$(".tasktype").attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	var s = $(this).attr("src");
	          	if(s.indexOf("checkbox2x") !== -1){
	          		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	}else{
	          		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
	          	}
	          });
		  
		  $(".taskbook").click(function(){
	          	$(".taskbook").attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	var s = $(this).attr("src");
	          	if(s.indexOf("checkbox2x") !== -1){
	          		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	}else{
	          		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
	          	}
	          });
		  
		  $("#conbtn").click(function(){
	            save();
	          });
		 
		  
		

	});

	function is_form_changed() 
	{ 
	    //检测页面是否有保存按钮
	    var t_save = jQuery("#businessCardModify");  
	    //检测到保存按钮,继续检测元素是否修改
	    if(t_save.length>0) 
	    {  
	        var is_changed = false; 
	        $("#businessCardModify input").each(function() 
	        { 
	            var _v = $(this).attr('_value'); 
	            if(typeof(_v) == 'undefined')
	                 _v = ''; 
	                 
	            if(_v != $(this).val()) 
	                is_changed = true; 
	        }); 
	        
	        return is_changed; 
	    } 
	    return false; 
	} 

function save(){
  	var h = '';
  	
  	//处理名片设置
	$("#config img").each(function(){
	  	var s = $(this).attr("src");
      	if(s.indexOf("checkbox2x") !== -1){
      		h+=$(this).attr("class")+"|"+$(this).attr("val")+",";
      	}
	});
	
	//处理日程设置
	$("#taskConfig img").each(function(){
		var s = $(this).attr("src");
      	if(s.indexOf("checkbox2x") !== -1){
      		h+=$(this).attr("class")+"|"+$(this).attr("val")+",";
      	}
	});
	
	$.ajax({
		url:"<%=path%>/urperf/savemenuurperf",
		data: {
			contents: h,
			category:"config"
		},
	 	success: function(data){
	 		if(data === 'success'){
	 			$(".successMsgBox").css("display","").html("保存成功");
	   	    	$(".successMsgBox").delay(2000).fadeOut();
	 			window.location.href="<%=path %>/businesscard/get";
	 		}else{
	 			$(".errMsgBox").css("display","").html("保存失败");
	   	    	$(".errMsgBox").delay(2000).fadeOut();
	 		}
	    }
	});
}

function showDetail(obj)
{
	var temp = $("." + obj);
	if (temp.hasClass("down"))
	{
		temp.removeClass("down");
		temp.addClass("folder");
		temp.empty();
		var html = ">";
		temp.append(html);
		temp.parent().siblings().css("display","none");
	}
	else
	{
		temp.removeClass("folder");
		temp.addClass("down");
		temp.empty();
		var html = "v";
		temp.append(html);
		temp.parent().siblings().css("display","");
	}	
}

function showSub(flag)
{
	if ("false" == flag)
	{
		$(".taskClose").parent().parent().siblings(".listview-item").css("display","none");
	}
	
	if ("true" == flag)
	{
		$(".taskOpen").parent().parent().siblings(".listview-item").css("display","");
	}
}
</script>
<style>
.none {
	display: none
}
</style>
</head>

<body style="min-height: 100%;">
	<!-- <div id="site-nav" class="navbar" style="">
		<div style="float: left;line-height:50px;">
			<a href="<%=path %>/businesscard/get" style="padding:10px 5px;">
				<img src="<%=path %>/image/back.png" width="30px">
			</a>
		</div>
		<h3 style="padding-right: 45px;">我的隐私设置</h3>
			<div id="conbtn" class="act-secondary menu-group" style="margin-right:10px;">
				保存
		</div>
	</div> -->
	<div class="zjwk_fg_nav">
		<a href="javascript:void(0)" onclick="history.go(-1);">取消</a>&nbsp;&nbsp;&nbsp;
		<a href="javascript:void(0)" id="conbtn">保存</a>&nbsp;&nbsp;
	</div>
	<div class="site-recommend-list page-patch acclist">
		<div class="list-group1 listview" style="font-size:14px;">
			<!-- 名片设置 -->
			<div name="config" id="config"  class="businesscardConfig">
				<div class="zjwk_fg_nav_left"  onclick="showDetail('businessSpan')">名片设置<span class="businessSpan folder" style="float: right;margin-right: 10px;">></span></div> 
				<div class="list-group-item listview-item" style="display:none">
					<div style="width: 100%;">
			         <p style="margin-bottom: 5px;padding: 1px;margin-top:-5px">谁可以看到我的联系信息   (手机,邮箱等)</p>
								<c:if test="${user.contactConfig  eq 'friend'}">
								<div style="margin-left: 5px; float: left;">
									好友
										<img src="<%=path%>/image/checkbox2x.png"
											style="cursor: pointer; margin-left: 5px; width: 25px;"
											class="contact" val="friend">
								</div>
								<div style="margin-left: 100px; float: left;">
									所有人
										<img src="<%=path%>/image/checkbox-no2x.png"
											style="cursor: pointer; margin-left: 5px; width: 25px;"
											class="contact" val="all">
								</div>
								</c:if>	
								<c:if test="${user.contactConfig  ne 'friend'}">
								<div style="margin-left: 5px; float: left;">
									好友
										<img src="<%=path%>/image/checkbox-no2x.png"
											style="cursor: pointer; margin-left: 5px; width: 25px;"
											class="contact" val="friend">
								</div>
								<div style="margin-left: 100px; float: left;">
									所有人
										<img src="<%=path%>/image/checkbox2x.png"
											style="cursor: pointer; margin-left: 5px; width: 25px;"
											class="contact" val="all">
								</div>
								</c:if>			
					</div>
				</div> 
				<div class="list-group-item listview-item" style="display:none">
					<div style="width: 100%;">
			         <p style="margin-bottom: 5px;padding: 1px;margin-top:-5px">谁可以给我发私信</p>
			         	<c:if test="${user.msmConfig  eq 'friend'}">
								<div style="margin-left: 5px; float: left;">
									好友
										<img src="/ZJWK/image/checkbox2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="msm" val="friend">
								</div>
								<div style="margin-left: 100px; float: left;">
									所有人
										<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="msm" val="all">
								</div>
								</c:if>
							<c:if test="${user.msmConfig  ne 'friend'}">
							<div style="margin-left: 5px; float: left;">
									好友
										<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="msm" val="friend">
								</div>
								<div style="margin-left: 100px; float: left;">
									所有人
										<img src="/ZJWK/image/checkbox2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="msm" val="all">
								</div>
							</c:if>
					</div>
				</div>
				<div class="list-group-item listview-item" style="display:none">
					<div style="width: 100%;">
			         <p style="margin-bottom: 5px;padding: 1px;margin-top:-5px">谁可以给我留言</p>
			         	<c:if test="${user.messageConfig  eq 'friend'}">
								<div style="margin-left: 5px; float: left;">
									好友
										<img src="/ZJWK/image/checkbox2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="message" val="friend">
								
								</div>
								<div style="margin-left: 100px; float: left;">
									所有人
										<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="message" val="all">
							
								</div>
						
				</c:if>
					<c:if test="${user.messageConfig  ne 'friend'}">
					<div style="margin-left: 5px; float: left;">
									好友
										<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="message" val="friend">
								
								</div>
								<div style="margin-left: 100px; float: left;">
									所有人
										<img src="/ZJWK/image/checkbox2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="message" val="all">
							
								</div>
					</c:if>
	
					</div>
				</div>
				<div class="list-group-item listview-item" style="display:none">
				<div style="width: 100%;">
				<p style="margin-bottom: 5px;padding: 1px;margin-top:-5px">谁可以加我为好友</p>
				<c:if test="${user.validationConfig  eq 'my'}">
							<div style="margin-left: 5px; float: left;">
								需要我验证
									<img src="/ZJWK/image/checkbox2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="my">
							</div>
							<div style="margin-left: 20px; float: left;">
								问题验证
									<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="question">
							</div>
								<div style="margin-left: 20px; float: left;">
								所有人
									<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="all">
							</div>
					</c:if>
					<c:if test="${user.validationConfig  eq 'question'}">
					<div style="margin-left: 5px; float: left;">
								需要我验证
									<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="my">
							</div>
							<div style="margin-left: 20px; float: left;">
								问题验证
									<img src="/ZJWK/image/checkbox2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="question">
							</div>
								<div style="margin-left: 20px; float: left;">
								所有人
									<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="all">
							</div>
					</c:if>
					<c:if test="${user.validationConfig  eq 'all'}">
					<div style="margin-left: 5px; float: left;">
								需要我验证
									<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="my">
							</div>
							<div style="margin-left: 20px; float: left;">
								问题验证
									<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="question">
							</div>
								<div style="margin-left: 20px; float: left;">
								所有人
									<img src="/ZJWK/image/checkbox2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="all">
							</div>
					</c:if>
			
				<c:if test="${user.validationConfig  ne 'all' and user.validationConfig  ne 'question' and user.validationConfig  ne 'my'}">
					<div style="margin-left: 5px; float: left;">
								需要我验证
									<img src="/ZJWK/image/checkbox2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="my">
							</div>
							<div style="margin-left: 20px; float: left;">
								问题验证
									<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="question">
							</div>
								<div style="margin-left: 20px; float: left;">
								所有人
									<img src="/ZJWK/image/checkbox-no2x.png" style="cursor: pointer; margin-left: 5px; width: 25px;" class="validation" val="all">
							</div>
					</c:if>
				</div>
			</div>		
			</div>
			
			<div style="clear: both"></div>
			<!-- 日程设置 -->
			<div class="taskConfig" id="taskConfig">
				<div class="zjwk_fg_nav_left"  onclick="showDetail('taskSpan')">日程设置<span class="taskSpan folder" style="float: right;margin-right: 10px;">></span></div>
				<div class="list-group-item listview-item" style="display:none">
					<div style="width: 100%;">
			         <p style="margin-bottom: 5px;padding: 1px;margin-top:-5px">日程提醒</p>
								<div style="margin-left: 5px; float: left;" onclick="showSub('true')" class="taskOpen">
									开启
										<img src="<%=path%>/image/checkbox2x.png"
											style="cursor: pointer; margin-left: 5px; width: 25px;"
											class="task" val="open">
								</div>
								<div style="margin-left: 100px; float: left;" onclick="showSub('false')" class="taskClose">
									关闭
										<img src="<%=path%>/image/checkbox-no2x.png"
											style="cursor: pointer; margin-left: 5px; width: 25px;"
											class="task" val="close">
								</div>	
					</div>
				</div>  
				<div class="list-group-item listview-item" style="display:none">
					<div style="width: 100%;">
			         <p style="margin-bottom: 5px;padding: 1px;margin-top:-5px">提醒类型</p>
								<div style="margin-left: 5px; float: left;">
									微信提醒
										<img src="<%=path%>/image/checkbox2x.png"
											style="cursor: pointer; margin-left: 5px; width: 25px;"
											class="tasktype" val="wx">
								</div>
								<div style="margin-left: 100px; float: left;">
									短信提醒
										<img src="<%=path%>/image/checkbox-no2x.png"
											style="cursor: pointer; margin-left: 5px; width: 25px;"
											class="tasktype" val="msg">
								</div>	
					</div>
				</div> 
				<div class="list-group-item listview-item" style="display:none">
					<div style="width: 100%;">
			         <p style="margin-bottom: 5px;padding: 1px;margin-top:-5px">定时提醒</p>
								<div style="margin-left: 5px; float: left;">
									默认
										<img src="<%=path%>/image/checkbox2x.png"
											style="cursor: pointer; margin-left: 5px; width: 25px;"
											class="taskbook" val="default">
								</div>
					</div>
				</div> 
			</div>
		</div>
	</div>
<div class="errMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 14px; text-align: center; height: 30px; line-height:30px;">&nbsp;</div>
	<div class="successMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(44, 234, 39); top: 0px; left: 0px; z-index: 1000; font-size: 14px; text-align: center; height: 30px; line-height:30px;">&nbsp;</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>