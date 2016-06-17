<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.min.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation/jquery.metadata.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
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
            $(".ispublish_img").click(function(){
            	var s = $(this).attr("src");
            	var con = "";
            	if(s.indexOf("checkbox2x") !== -1){
            		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
            		con = 'private';
            	}else{
            		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
            		con = 'open';
            	}
            	$(":hidden[name=ispublish]").val(con);
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
            //取消按钮操作
            $(".cancel_btn").click(function(){
            	window.location.href="<%=path%>/zjactivity/list?viewtype=owner";
            });
            //发布按钮操作
            $(".publishActivity").click(function(){
            	if(!validates()){
            		$(":hidden[name=status]").val("publish");
					$("form[name=activityform]").submit();
				}
            });
            //保存按钮操作
            $(".saveActivity").click(function(){
				if(!validates()){
					$("form[name=activityform]").submit();
				}
			});
		}
	  	function showMyMsg(t){
	  		$(".myMsgBoxSec").css("display","").html(t);
  			$(".myMsgBoxSec").css("left", $(document).width()/2 - $(".myMsgBoxSec").width() / 2);
	    	$(".myMsgBoxSec").delay(3000).fadeOut();
	  	}
	  	//验证所有的参数是否都已经填写
	  	function validates(){
  			var title = $("#title").val();
	  		if(!title){
	  			showMyMsg('请输入聚会主题');
	  			return true;
	  		}
	  		var start_date = $("#start_date").val();
	  		if(!start_date){
	  			showMyMsg('请选择聚会时间');
	  			return true;
	  		}
	  		$(":hidden[name=end_date]").val(start_date);
	  		if(!($("textarea[name=place]").val())){
	  			showMyMsg('请输入聚会地点');
	  			return true;
	  		}
	  		if(!($("textarea[name=phone]").val())){
	  			showMyMsg('请输入联系电话');
	  			return true;
	  		}
			var regPhone = /^1[3|4|5|7|8][0-9]{9}$/;//验证国内手机号码
			var mobile = $("#phone").val();
			if(!regPhone.test($.trim(mobile)))
			{
	  			showMyMsg('请务必输入正确的手机号码');
	  			return true;
			}
	  		if(!$("textarea[name=content]").val()){
	  			showMyMsg('请输入聚会简介');
	  			return true;
	  		}
	  		var content = $("textarea[name=content]").val();
	  		if(content.length>35){
	  			$(":hidden[name=remark]").val(content.substring(0,35)+"...");
	  		}else{
	  			$(":hidden[name=remark]").val(content);
	  		}
			return false;
	  	}
	  //初始化日期控件
		function initDatePicker() {
			var opt = {
				//datetime : { preset : 'datetime',minDate:new Date(),maxDate: new Date(2099,11,31,23,55), stepMinute: 5  }
			    datetime : { preset : 'date',minDate:new Date(),maxDate: new Date(2099,11,31), stepMinute: 5  }
			};
			var optSec = {
				theme: 'default', 
				mode: 'scroller', 
				display: 'modal', 
				lang: 'zh', 
				onSelect: function(){
				}
			};
			$('#start_date').val('').scroller('destroy').scroller($.extend(opt['datetime'], optSec));
		}
		
</script>
</head>

<body>
	<div id="task-create" class=" ">
		<div id="site-nav" class="resource_menu" style="height:35px;font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;background-color:#fff;line-height:35px;padding-right:8px;">
			<div style="float:right;">
				<a class="cancel_btn" href="javascript:void(0)"  style="padding:5px 8px;">取消</a>
				<a class="saveActivity" href="javascript:void(0)" style="padding:5px 8px;">保存</a>
				<a class="publishActivity" href="javascript:void(0)" style="padding:5px 8px;">发布</a>
			</div>
		</div>
		<div class="wrapper" style="margin:0px;">
			<form id="activityform" name="activityform"
				action="<%=path%>/zjwkactivity/save" method="post">
			     <input type="hidden" name="openId" value="${openId}" />
			     <input type="hidden" name="publicId" value="${publicId}" />
			     <input type="hidden" name="sourceid" value="${sourceid}" />
				 <input type="hidden" name="source" value="${source}" /> 
				 <input type="hidden" name="type" value="${type}" />
				 <input type="hidden" name="orgId" value="${orgId}" /> 
				 <input type="hidden" name="status" value="draft" />
				 <input type="hidden" name="remark" value="" />
				 <input type="hidden" name="end_date" value="" />
			     <input type="hidden" name="return_url" value="${return_url }" />
				<!-- 活动主题 -->
				<div class="form-group" style="background: #fff; height: 50px;">
					<input name="title" id="title" value="" type="text"
						class="form-control" placeholder="主题（必填）" style="border: none;height:50px;">
				</div>
				<!-- 活动开始日期 -->
				<div class="form-group"
					style="background: #fff; height: 50px; margin-top: -12px;">
					<input name="start_date" id="start_date" value="" type="text"
						format="yy-mm-dd" placeholder="时间（必填）" readonly=""
						style="border: none;height:50px;" class="">
				</div>
				<!-- 活动地址-->
				<div class="form-group" style="margin-top: -11px;">
					<textarea name="place" id="place" rows="1"
						style="border: none; min-height: 50px" class="form-control"
						placeholder="地点（必填）"></textarea>
				</div>

				<!-- 联系电话-->
				<div class="form-group" style="margin-top: -11px;">
					<textarea name="phone" id="phone" rows="1"
						style="border: none; min-height: 50px" class="form-control"
						placeholder="联系电话（必填）"></textarea>
				</div>
				
				<div class="form-group"
					style="background: #fff; height: 80px; margin-top: -15px;">
					<input type="hidden" name="isregist" value="Y">
					<div
						style="color: #939292; padding-top: 8px; font-size: 15px; height: 40px; margin-left: 5px; margin-top: 5px;">
						是否需要报名:</div>
					<div style="margin-left: 15px; float: left;">
						需要<img src="<%=path%>/image/checkbox2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="isregist_sel" val="Y">
					</div>
					<div style="margin-left: 15px; float: left;">
						不需要<img src="<%=path%>/image/checkbox-no2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="isregist_sel" val="N">
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
				<!-- 是否允许推荐 -->
				<div class="form-group"
					style="margin-top: -15px;margin-right:10px;">
					<input type="hidden" name="ispublish" value="open">
					<div
						style="padding-top: 8px; font-size: 16px; margin-left: 5px; margin-top: 5px;">
						允许指尖微客推荐
						<img src="<%=path%>/image/checkbox2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							val="Y" class="ispublish_img">
					</div>
				</div>
				<!-- 活动内容-->
				<div class="form-group">
					<textarea name="content" id="content" rows="6"
						style="border: none; min-height: 50%" class="form-control"
						placeholder="聚会简介（必填）"></textarea>
				</div>
			</form>
			<script type="text/javascript">
				window.$CONFIG = {};
				window.APP_PARAMS = null;
			</script>
		</div>
	</div>
	</br></br></br></br>
	<!-- myMsgBox 消息提示框 -->
	<div class="myMsgBoxSec" style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 99999999; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;"></div>
</body>
</html>