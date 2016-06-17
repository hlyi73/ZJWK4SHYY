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
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
$(function() {
	$(".sex_type").click(function(){
		$(".sex_type").removeClass("selected").addClass("noselected");
		$(this).removeClass("noselected").addClass("selected");
		$(":hidden[name=sex]").val($(this).attr('key'));
	});
	
	$(".savecardbtn").click(function(){
		var name = $("input[name=name]").val();
		var phone = $("input[name=phone]").val();
		var company = $("input[name=company]").val();
		var position = $("input[name=position]").val();
		var sex = $(":hidden[name=sex]").val();
	//	if($.trim(name)=='' || $.trim(sex)=='' || $.trim(phone) == ''){
		if($.trim(name)=='' || $.trim(sex)==''){
			$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请填写完整");
  		    $(".myMsgBox").delay(1000).fadeOut();
			return;
		}
		 var regPhone = /^1[3|4|5|7|8][0-9]{9}$/;//验证手机号码
		if($.trim(phone)!='' &&  !regPhone.test(phone)){
			$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("手机号码填写不正确");
  		    $(".myMsgBox").delay(1000).fadeOut();
			return;
		} 
		$(".savecardbtn").addClass("none");
		$(".g-mask").removeClass("none");
		$(".save_card_loading").removeClass("none");
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/businesscard/savecard',
		      data: {name:name,phone:phone,company:company,position:position,sex:sex},
		      dataType: 'text',
		      success: function(data){
		    	 
		    	  if(data && data == 'success'){
		    		  $(".save_card_info").html('保存成功');
		    		  var url = "${redirectUrl}";
		    		  if(url == ''){
		    			  window.location.replace("<%=path%>/businesscard/detail");
		    		  }else{
		    		  	   window.location.replace("<%=path%>/${redirectUrl}");
		    		  }
		    	  }else{
		    		  $(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("保存失败");
		    		  $(".myMsgBox").delay(1000).fadeOut();
		    		  $(".savecardbtn").removeClass("none");
		    	  }
		      }
		});
	});
});
</script>
<style>
.selected{
	background-color: rgb(21, 190, 120);
	color: #fff;
}

.noselected{
	background-color: #fff;
	color: #555;
}

.sex_type{
	padding: 3px 5px;
}

.none {
	display:none;
}

.g-mask {
	position: fixed;
	top: -0px;
	left: -0px;
	width: 100%;
	height: 100%;
	background: #000;
	filter: alpha(opacity = 60);
	opacity: 0.2;
	z-index: 998; 
}
</style>
</head>

<body style="font-size:14px;">
	<div style="width:100%;margin-top:20px;">
		<div style="line-height: 28px;text-indent: 2em;font-size:16px;margin-top:10px;padding-bottom: 15px;padding:10px;color:rgb(111, 111, 111);">
			您好！我是指尖微客小秘书——小薇。在您正式使用指尖微客之前，请先让大家认识您吧。
		</div>
		<Br/><Br/>
		<form name="cardform">
			<div style="line-height:30px;background-color:#fff;padding:3px 10px;">
				<div style="color:#999;">姓名<span style="color:red;">*</span>：</div>
				<div>
					<input type="text" name="name" value="${busicard.name}" placeholder="您的真实姓名" style="margin-left: 60px;width: 80%;margin-top: -30px;border: 0;float: left;">
				</div>
			</div>
			<div style="clear:both;"></div>
			<div style="line-height:30px;margin-top:10px;background-color:#fff;padding:3px 10px;">
				<div style="float:left;color:#999;">性别<span style="color:red;">*</span>：</div>
				<input type="hidden" name="sex" value="${busicard.sex }">
				<div style="padding-left:68px;">
					<c:if test="${busicard.sex eq ''}">
						<a href="javascript:void(0)" class="sex_type" key='0' style="">男</a>
						<a href="javascript:void(0)" class="sex_type" key='1' style="">女</a>
					</c:if>
					<c:if test="${busicard.sex ne ''}">
						<c:if test="${busicard.sex eq '0'}">
							<a href="javascript:void(0)" class="selected sex_type" key='0' style="">男</a>
							<a href="javascript:void(0)" class="sex_type" key='1' style="">女</a>
						</c:if>
						<c:if test="${busicard.sex eq '1'}">
							<a href="javascript:void(0)" class="sex_type" key='0' style="">男</a>
							<a href="javascript:void(0)" class="selected sex_type" key='1' style="">女</a>
						</c:if>
					</c:if>
				</div>
			</div>
			<div style="clear:both;"></div>
			<div style="line-height:30px;margin-top:10px;background-color:#fff;padding:3px 10px;">
				<!-- <div style="color:#999;">手机<span style="color:red;">*</span>：</div> -->
				<div style="color:#999;">手机<span style="color:red;"></span>：</div>
				<div><input type="text" name="phone" value="${busicard.phone }" placeholder="您的手机号码" style="margin-left: 60px;width: 80%;margin-top: -30px;border: 0;float: left;"></div>
			</div>
			<div style="clear:both;"></div>
			<div style="line-height:30px;margin-top:10px;background-color:#fff;padding:3px 10px;">
				<div style="color:#999;">公司：</div>
				<div><input type="text" name="company" value="${busicard.company }" style="margin-left: 60px;width: 80%;margin-top: -30px;border: 0;float: left;"></div>
			</div>
			<div style="clear:both;"></div>
			<div style="line-height:30px;margin-top:10px;background-color:#fff;padding:3px 10px;">
				<div style="color:#999;">职务：</div>
				<div><input type="text" name="position" value="${busicard.position }" style="margin-left: 60px;width: 80%;margin-top: -30px;border: 0;float: left;"></div>
			</div>
			<div style="clear:both;"></div>
			<div style="width:100%;text-align:center;margin-top:20px;">
				<a href="javascript:void(0)" class="btn savecardbtn" style="line-height:2.5em;height:2.5em;padding:0px 50px;">确定</a>
			</div>
		</form>
	</div>
	
	<div class="save_card_loading none" style="z-index:999;position:fixed;top:40%;left:50%;font-size:14px;text-align:center;line-height: 30px;width:100px;margin-left:-50px;border-radius: 10px;padding-top: 10px;background-color: #fff;border:1px solid #ddd;">
		 	<div><img src="<%=path%>/image/loading.gif"></div>
		 	<span class="save_card_info">保存中...</span>
	</div>
	<div class="g-mask none">&nbsp;</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;"></div> 
</body>
</html>