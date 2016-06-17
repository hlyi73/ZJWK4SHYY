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
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.min.js"	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_validation/jquery.metadata.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet"	href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js"	type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js"	type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"	rel="stylesheet" type="text/css" />
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"	type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"	type="text/javascript"></script>
<!-- 追加的样式文件-->
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
		$(function () {
			initWeixinFunc();
			initForm();
			initDatePicker();
		});
		
		//微信网页按钮控制
		function initWeixinFunc(){
			//隐藏顶部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideOptionMenu');
			});
			//隐藏底部
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideToolbar');
			});
		}
		function initForm(){
			$(".submitBtn").click(function(){
				if(!validates()){
					$("form[name=activityform]").submit();
				}
			});
			//imgchoose
			$(".imgchoose").click(function(){
				var s = $(this).find("img").attr("arr");
				if(s === "down"){
					$(this).find("img").attr("src","<%=path%>/image/form_more2x-click.png");
					$(this).find("img").attr("arr","up");
					$(".imgchooselist").css("display","");
				}else{
					$(this).find("img").attr("src","<%=path%>/image/form_more2x.png");
					$(this).find("img").attr("arr","down");
					$(".imgchooselist").css("display","none");
				}
			});
            $(".imgchooselist img").click(function(){
            	var source = $(this).attr("source");
            	var src="";
            	var logo = "";
            	if("upload"==source){
            		 src="<%=path%>/mkattachment/download?fileName="+ $(this).attr("alt") + "&flag=headImage";
            		 logo = $(this).attr("alt");
            	}else{
            		 logo = $(this).attr("alt") + ".png";
            		 src = "<%=path%>/image/actbg/" + $(this).attr("alt") + ".png";
            	}
            	$(".form-logo img").attr("src",src );
            	$(":hidden[name=logo]").val(logo);
			});
            $(".charge_type_sel").click(function(){
            	$(".charge_type_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
            	var s = $(this).attr("src");
            	if(s.indexOf("checkbox2x") !== -1){
            		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
            	}else{
            		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
            		$(":hidden[name=charge_type]").val($(this).attr("val"));
            	}
            	if("other"==$(this).attr("val")){
            		$(".charges_div").css("display","");
            	}else{
            		$(".charges_div").css("display","none");
            	}
            });
            $(".ispublish_sel").click(function(){
            	$(".ispublish_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
            	var s = $(this).attr("src");
            	if(s.indexOf("checkbox2x") !== -1){
            		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
            	}else{
            		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
            		$(":hidden[name=ispublish]").val($(this).attr("val"));
            	}
            });
            $(".isregist_sel").click(function(){
            	$(".isregist_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
            	var s = $(this).attr("src");
            	if(s.indexOf("checkbox2x") !== -1){
            		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
            	}else{
            		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
            		$(":hidden[name=isregist]").val($(this).attr("val"));
            	}
            	var value = $(this).attr("val");
            	if('Y'==value){
            		$(".show_div").css("display","");
            		$(".regist_end_date").css("display","");
            		$(".limit_div").css("display","");
            	}else{
            		$(".show_div").css("display","none");
            		$(".regist_end_date").css("display","none");
            		$(".limit_div").css("display","none");
            	}
            });
            $(".islive_sel").click(function(){
            	$(".islive_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
            	var s = $(this).attr("src");
            	if(s.indexOf("checkbox2x") !== -1){
            		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
            	}else{
            		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
            		$(":hidden[name=islive]").val($(this).attr("val"));
            	}
            	var value = $(this).attr("val");
            	if("open" == value){
            		$(".live_type").css("display","");
            	}else{
            		$(".live_type").css("display","none");
            	}
            });
            $(".display_member_sel").click(function(){
            	$(".display_member_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
            	var s = $(this).attr("src");
            	if(s.indexOf("checkbox2x") !== -1){
            		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
            	}else{
            		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
            		$(":hidden[name=display_member]").val($(this).attr("val"));
            	}
            });
            $(".orgId_sel").click(function(){
            	$(".orgId_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
            	var s = $(this).attr("src");
            	if(s.indexOf("checkbox2x") !== -1){
            		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
            	}else{
            		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
            		$(":hidden[name=orgId]").val($(this).attr("val"));
            	}
            });
            $(".live_parameter_sel").click(function(){
            	$(".live_parameter_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
            	var s = $(this).attr("src");
            	if(s.indexOf("checkbox2x") !== -1){
            		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
            	}else{
            		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
            		$(":hidden[name=live_parameter]").val($(this).attr("val"));
            	}
            });
            $(".cancelBtn").click(function(){
            	window.location.replace('<%=path%>/zjactivity/list?viewtype=owner');
            });
		}
	  	function showMyMsg(t){
	  		$(".myMsgBoxSec").css("display","").html(t);
  			$(".myMsgBoxSec").css("left", $(document).width()/2 - $(".myMsgBoxSec").width() / 2);
	    	$(".myMsgBoxSec").delay(2000).fadeOut();
	  	}
	  	//验证所有的参数是否都已经填写
	  	function validates(){
  			//var flag= false ;
  			//var errorMsg='填写不完整!请您将带有*标签的字段都填上!';
  			
  			var title = $("#title").val();
	  		if(!title){
	  			showMyMsg('请填写会议标题');
	  			return true;
	  		}
	  		var start_date = $("#start_date").val();
	  		if(!start_date){
	  			showMyMsg('请输入会议开始时间');
	  			return true;
	  		}
	  		var act_end_date = $("#act_end_date").val();
	  		if(!act_end_date){
	  			showMyMsg('请输入会议结束时间');
	  			return true;
	  		}
	  		var isregist = $(":hidden[name=isregist]").val();
	  		if('Y'==isregist){
		  		var end_date = $("#end_date").val();
		  		if(!end_date){
		  			showMyMsg('请输入报名截止时间');
		  			return true;
		  		}
	  		}
	  		var live_parameter = $(":hidden[name=live_parameter]").val();
// 	  		if('regist'==live_parameter&&'N'==isregist){
// 	  			showMyMsg('您选择的直播方式与是否报名有冲突，请重新选择后在提交！');
// 	  			return true;
// 	  		}
	  		if(!($("textarea[name=content]").val()) || !($("textarea[name=place]").val())){
	  			showMyMsg('请输入会议内容以及会议地点');
	  			return true;
	  		}
	  		var content = $("textarea[name=content]").val();
	  		if(content.length>35){
	  			$(":hidden[name=remark]").val(content.substring(0,35)+"...");
	  		}else{
	  			$(":hidden[name=remark]").val(content);
	  		}
			var start = date2utc($('#start_date').val());
			var end = date2utc($('#end_date').val()); 
			var act_end = date2utc($('#act_end_date').val()); 
		    if(end > start){
		    	$('#end_date').val('').attr("placeholder","报名截止时间不能晚于活动开始时间，请重新选择!");
		    	showMyMsg('报名截止时间不能晚于活动开始时间，请重新选择！');
				return true;
			}
		    if(act_end < start){
		    	$('#act_end').val('').attr("placeholder","会议结束时间应大于开始时间，请重新选择!");
		    	showMyMsg('会议结束时间应大于开始时间，请重新选择！');
				return true;
			}
			return false;
	  	}
	  	var prefile = "";
	   //异步上传头像
	   function ajaxFileUpload(){
	  	if(prefile == ""){
	  		prefile = $(".fileInput").val();
	  	}else if(prefile == $(".fileInput").val()){
	  		return;
	  	}
	  	$.ajaxFileUpload({
	  		//处理文件上传操作的服务器端地址(可以传参数,已亲测可用)
	  		url:'<%=path%>/mkattachment/upload',
	  		secureuri:false,                       //是否启用安全提交,默认为false 
	  		fileElementId:'uploadFile',           //文件选择框的id属性
	  		dataType:'text',                       //服务器返回的格式,可以是json或xml等
	  		success:function(data, status){        //服务器响应成功时的处理函数
	  			prefile = "";
	  			$(".form-logo").empty();
	  			if(data.substring(0, 1) == 0){     //0表示上传成功(后跟上传后的文件路径),1表示失败(后跟失败描述)
	  				var path = "<%=path%>/mkattachment/download?fileName="+ data.substring(1) + "&flag=headImage";
					$(":hidden[name=logo]").val(data.substring(1));
					$(".form-logo").append('<img style="width: 100%;" src="' + path+ '"></img>');
					var modelImg = '<div source="upload" style="margin-top: 10px; margin-left: 10px; float: left;">'
								 + '<img style="width: 65px; height: 65px;border: 2px solid #F4A421;"'
								 + 'src="'+path+'" alt="'+data.substring(1)+'"></div>';
					$(".imgchooselist").append(modelImg);
				} else {
					$(".myMsgBox").css("display", "").html("图片上传失败，请重试！！");
					$(".myMsgBox").delay(2000).fadeOut();
					/* 	$("#result").css("display",'');
						$('#result').html('图片上传失败，请重试！！'); */
				}
			},
			error : function(data, status, e) { //服务器响应失败时的处理函数
				prefile = "";
				$(".myMsgBox").css("display", "").html("图片上传失败，请重试！！");
				$(".myMsgBox").delay(2000).fadeOut();
			}
		});
	}
	//初始化日期控件
	function initDatePicker() {
		var opt = {
			date : { preset : 'date',minDate:new Date(),maxDate: new Date(2099,11,31)}
		};
		var optSec = {
			theme: 'default', 
			mode: 'scroller', 
			display: 'modal', 
			lang: 'zh', 
			onSelect: function(){
				var start_date = $('#start_date').val();
			    initEndDate(start_date);
			}
		};
		$('#start_date').val('').scroller('destroy').scroller($.extend(opt['date'], optSec));
		$('#act_end_date').val('').scroller('destroy').scroller($.extend(opt['date'], optSec));
	}
	
	function initEndDate(start_date){
		var year = start_date.split("-")[0];
		var month = parseInt(start_date.split("-")[1])-1;
		if(0==month){
			month=12;
			year = parseInt(year)-1;
		}
		var day = parseInt(start_date.substring(start_date.lastIndexOf("-")+1,start_date.lastIndexOf("-")+3))-1;
		var opt = {
				date : { preset : 'date',maxDate: new Date(year,month,day) }
			};
			var optSec = {
				theme: 'default', 
				mode: 'scroller', 
				display: 'modal', 
				lang: 'zh'
			};
			$('#end_date').val('').scroller('destroy').scroller($.extend(opt['date'], optSec));
	}
	
</script>
</head>

<body>
	<div id="task-create" class=" ">
		<div id="site-nav" class="navbar none">
			<div style="float: left">
				<a href="javascript:void(0)" onclick="javascript:history.go(-1)"
					style="color: #fff; padding: 5px 5px 5px 0px;"> <img
					src="<%=path%>/image/back.png" width="40px" style="padding: 5px;">
				</a>
			</div>
			<h3 style="padding-right: 45px;">发起新活动</h3>
		</div>
		<div class="form-file"
			style="box-sizing: border-box; color: rgb(51, 51, 51); display: block; font-family: 'Microsoft YaHei'; font-size: 16px; line-height: 16px; word-wrap: break-word;">
			<div class="form-logo">
				<img style="width: 100%;" src="<%=path%>/image/default_activity.jpg"
					alt="">
			</div>
			<a href="#"
				style="position: absolute; right: 1em; margin-top: -3em; color: white">
				<span class="text"
				style="box-sizing: border-box; color: rgb(255, 255, 255); cursor: pointer; display: inline; font-family: 'Microsoft YaHei'; font-size: 16px; height: auto; line-height: 16px; width: auto; word-wrap: break-word;">
					点击更换图片 <img src="<%=path%>/image/camera.png" style="width: 24px"
					alt="">
			</span> <input type="file" onchange="ajaxFileUpload();"
				accept="image/gif,image/x-png, image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg"
				class="fileInput" name="uploadFile" id="uploadFile"
				style="height: 20px;">
			</a>
		</div>

		<div class="wrapper">
			<form id="activityform" name="activityform"
				action="<%=path%>/zjwkactivity/save" method="post">
			     <input type="hidden" name="openId" value="${openId}" />
			     <input type="hidden" name="publicId" value="${publicId}" />
			     <input type="hidden" name="sourceid" value="${sourceid}" />
				 <input type="hidden" name="source" value="${source}" /> 
				 <input type="hidden" name="type" value="${type}" />
				 <input type="hidden" name="orgId" value="${orgId}" /> 
				 <input type="hidden" name="logo" value="default_activity.jpg" /> 
				 <input type="hidden" name="status" value="publish" />
				 <input type="hidden" name="remark" value="" />
			     <input type="hidden" name="return_url" value="${return_url }" />
			     <input type="hidden" name="ispublish" value="open">
			     <input type="hidden" name="live_parameter" value="open">
				<div class="form-group"
					style="font-size: 14px; background: #fff; height: 40px;">
					<div
						style="color: #939292; padding-top: 8px; font-size: 15px; margin-left: 5px; margin-top: 5px; float: left">
						活动图片选择:</div>
					<div
						style="margin-top: 10px; margin-right: 10px; float: right; cursor: pointer;"
						class="imgchoose">
						<img src="<%=path%>/image/form_more2x.png" style="width: 16px;"
							arr="down">
					</div>
				</div>
				<div class="form-group imgchooselist"
					style="display: none; margin-top: -10px; font-size: 14px; background: #fff; min-height: 100px;">
					<div style="margin-top: 10px; margin-left: 10px; float: left;">
						<img style="width: 65px; height: 65px;
						border: 2px solid #F4A421;"
							src="<%=path%>/image/actbg/activity.png" alt="activity">
					</div>
					<div style="margin-top: 10px; margin-left: 10px; float: left;">
						<img style="width: 65px; height: 65px;
						border: 2px solid #F4A421;"
							src="<%=path%>/image/actbg/juhui.png" alt="juhui">
					</div>
					<div style="margin-top: 10px; margin-left: 10px; float: left;">
						<img style="width: 65px;height: 65px;
						 border: 2px solid #F4A421;"
							src="<%=path%>/image/actbg/meeting.png" alt="meeting">
					</div>
					<div style="margin-top: 10px; margin-left: 10px; float: left;">
						<img style="width: 65px; height: 65px;
						border: 2px solid #F4A421;"
							src="<%=path%>/image/actbg/katong.png" alt="katong">
					</div>
				</div>
				<!-- 活动主题 -->
				<div class="form-group" style="background: #fff; height: 50px;">
					<input name="title" id="title" value="" type="text"
						class="form-control" placeholder="请输入会议主题" style="border: none;height:50px;">
				</div>
				<div class="form-group"
					style="background: #fff; height: 50px; margin-top: -11px;">

					<input name="start_date" id="start_date" value="" type="text"
						format="yy-mm-dd" placeholder="点击选择会议开始日期" readonly=""
						style="border: none;height:50px;" class="">
				</div>
				<div class="form-group"
					style="background: #fff; height: 50px; margin-top: -11px;">

					<input name="act_end_date" id="act_end_date" value="" type="text"
						format="yy-mm-dd" placeholder="点击选择会议结束日期" readonly=""
						style="border: none;height:50px;" class="">
				</div>
				<div class="form-group" style="background: #fff; height: 80px;">
					<input type="hidden" name="charge_type" value="free">
					<div
						style="color: #939292; padding-top: 8px; font-size: 15px; height: 40px; margin-left: 5px; margin-top: 5px;">
						选择收费方式:</div>
					<div style="margin-left: 15px; float: left;">
						免费<img src="<%=path%>/image/checkbox2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="charge_type_sel" val="free">
					</div>
					<div style="margin-left: 15px; float: left;">
						AA制<img src="<%=path%>/image/checkbox-no2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="charge_type_sel" val="aa">
					</div>
					<div style="margin-left: 15px; float: left;">
						收费<img src="<%=path%>/image/checkbox-no2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="charge_type_sel" val="other">
					</div>
				</div>
				<div class="form-group charges_div" style="background: #fff; height: 40px;display:none;margin-top:-12px;">
					<input name="expense" id="expense" value="" type="text"
						placeholder="请输入收费标准" class="" style="border: none;">
				</div>
				<div class="form-group"
					style="background: #fff; height: 80px; margin-top: -12px;display:none;">
					<input type="hidden" name="islive" value="close">
					<div
						style="color: #939292; padding-top: 8px; font-size: 15px; height: 40px; margin-left: 5px; margin-top: 5px;">
						是否需要直播:</div>
					<div style="margin-left: 15px; float: left;">
						开启<img src="<%=path%>/image/checkbox2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="islive_sel" val="open">
					</div>
					<div style="margin-left: 15px; float: left;">
						关闭<img src="<%=path%>/image/checkbox-no2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="islive_sel" val="close">
					</div>
				</div>
				<div class="form-group"
					style="background: #fff; height: 80px; margin-top: -12px;">
					<input type="hidden" name="isregist" value="N">
					<div
						style="color: #939292; padding-top: 8px; font-size: 15px; height: 40px; margin-left: 5px; margin-top: 5px;">
						是否需要报名:</div>
					<div style="margin-left: 15px; float: left;">
						不需要<img src="<%=path%>/image/checkbox2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="isregist_sel" val="N">
					</div>
					<div style="margin-left: 15px; float: left;">
						 需要<img src="<%=path%>/image/checkbox-no2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="isregist_sel" val="Y">
					</div>
				</div>
				<div class="form-group regist_end_date"
					style="background: #fff; height: 50px; margin-top: -11px;display:none;">
					<input name="end_date" id="end_date" value="" type="text"
						format="yy-mm-dd" placeholder="点击选择报名截止日期" class="dateBtn"
						readonly="" style="border: none;height:50px;">
				</div>
				<div class="form-group limit_div" style="background: #fff; height: 40px;display:none;">
					<input name="limit_number" id="limit_number" value="" type="text"
						placeholder="请输入报名人数限制" class="" style="border: none;">
				</div>
				<div class="form-group show_div"
					style="font-size: 14px; background: #fff; height: 80px; margin-top: -11px;display:none;">
					<input type="hidden" name="display_member" value="Y">
					<div
						style="color: #939292; padding-top: 8px; font-size: 15px; height: 40px; margin-left: 5px; margin-top: 5px;">
						是否显示报名成员:</div>
					<div style="margin-left: 15px; float: left;">
						显示<img src="<%=path%>/image/checkbox2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="display_member_sel" val="Y">
					</div>
					<div style="margin-left: 15px; float: left;">
						不显示<img src="<%=path%>/image/checkbox-no2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="display_member_sel" val="N">
					</div>
				</div>
				<c:if test="${fn:length(orgList)>1}">
				<div class="form-group"
					style="background: #fff; height: 80px; margin-top: -12px;">
					<div
						style="color: #939292; padding-top: 8px; font-size: 15px; height: 40px; margin-left: 5px; margin-top: 5px;">
						选择组织:</div>
						<c:forEach items="${orgList}" var="org" varStatus="status">
						<c:if test="${status.index==0}">
							<div style="margin-left: 15px; float: left;">
								${org.name}<img src="<%=path%>/image/checkbox2x.png"
									style="cursor: pointer; margin-left: 5px; width: 25px;"
									class="orgId_sel" val="${org.id}">
							</div>
						</c:if>
						<c:if test="${status.index>0}">
							<div style="margin-left: 15px; float: left;">
								${org.name}<img src="<%=path%>/image/checkbox-no2x.png"
									style="cursor: pointer; margin-left: 5px; width: 25px;"
									class="orgId_sel" val="${org.id}">
							</div>
						</c:if>
					</c:forEach>
				</div>
				</c:if>
				<!-- 活动内容-->
				<div class="form-group">
					<textarea name="content" id="content" rows="6"
						style="border: none; min-height: 3em" class="form-control"
						placeholder="请输入活动内容"></textarea>
				</div>
				<!-- 活动地址-->
				<div class="form-group" style="margin-top: -15px;">

					<textarea name="place" id="place" rows="2"
						style="border: none; min-height: 2em" class="form-control"
						placeholder="请输入活动地址"></textarea>
				</div>
				<div class="button-ctrl" style="margin-top: -22px;" >
					<fieldset class="">
						<div class="ui-block-a" style="width: 48%;">
							<a href="javascript:void(0)" class="btn btn-block cancelBtn"
								style="font-size: 16px;"> 取消</a>
						</div>
						<div class="ui-block-a" style="width: 48%;">
							<a href="javascript:void(0)" class="btn btn-block submitBtn"
								style="font-size: 16px;"> 保存</a>
						</div>
					</fieldset>
				</div>
			</form>
			<script type="text/javascript">
				window.$CONFIG = {};
				window.APP_PARAMS = null;
			</script>
		</div>
	</div>
	<!-- myMsgBox 消息提示框 -->
	<div class="myMsgBoxSec" style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 99999999; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;"></div>
</body>
</html>