<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ page import="com.takshine.wxcrm.domain.BusinessCard" %>
<%
	String path = request.getContextPath();
	BusinessCard bc =  (BusinessCard)request.getAttribute("BusinessCard");
	String province = "";
	String city = "";
	if (bc.getCity()!=null){
		String[] arry = bc.getCity().split("-");
		if (arry.length == 2){
			province = arry[0];
			city = arry[1];
		}
	}
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
<script src="<%=path%>/scripts/util/pro_city.js"
type="text/javascript"></script>
	
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
	function showDoc(){
		var disnew = $("#newSign").css("display");
		if("none"==disnew){
			$("#oldSign").css("display","none");
			$("#newSign").css("display","");
			$("#editimg").attr("src","<%=path%>/image/oper_success.png");
		}else{
			$("#oldSign").css("display","");
			$("#newSign").css("display","none");
			//$("#editimg").attr("src","<%=path%>/image/edit_information.png");
			conform();
		}

	}
	

	function upload(){
		$(".fileInput").trigger("click");
	}
	var prefile = "";
	//异步修改
	function ajaxFileUpload(){
		if(prefile === ""){
			prefile = $(".fileInput").val();
		}else if(prefile == $(".fileInput").val()){
			return;
		}
		$.ajaxFileUpload({
			//处理文件上传操作的服务器端地址(可以传参数,已亲测可用)
			url:'<%=path%>/dcCrm/upload',
			secureuri:false,                       //是否启用安全提交,默认为false 
			fileElementId:'uploadFile',           //文件选择框的id属性
			dataType:'text',                       //服务器返回的格式,可以是json或xml等
			success:function(data, status){        //服务器响应成功时的处理函数
				prefile = "";
				$("#headImageDiv").empty();
				if(data.substring(0, 1) == 0){     //0表示上传成功(后跟上传后的文件路径),1表示失败(后跟失败描述)
					var width = $(window).width();
					if(width > 640){
						width = 640;
					}
	 				$(":hidden[name=headImageUrl]").val(data.substring(1));
					var path = "<%=path%>/contact/download?flag=dccrm&fileName="
									+ data.substring(1);
							$("#headImageDiv")
									.append(
											'<img style="height: 60px;" src="'+path+'"></img>');
						} else {
							$(".myDefMsgBox").removeClass("error_tip").addClass("error_tip").css("display","").html("图片上传失败,请重试");
							$(".myDefMsgBox").delay(2000).fadeOut();
						}
/* 						$(".uptImg")
								.append(
										'<input type="file" onchange="ajaxFileUpload();"  style="height:200px"  accept="image/gif,image/x-png, image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg"  class="fileInput" name="uploadFile" id="uploadFile">'); */
					},
					error : function(data, status, e) { //服务器响应失败时的处理函数
						prefile = "";
						$(".myDefMsgBox").removeClass("error_tip").addClass("error_tip").css("display","").html("图片上传失败,请联系管理员");
						$(".myDefMsgBox").delay(2000).fadeOut();
					/* 	$(".uptImg").empty();
						$(".uptImg")
								.append(
										'<input type="file" onchange="ajaxFileUpload();"  style="height:200px"  accept="image/gif, image/x-png,image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg"  class="fileInput" name="uploadFile" id="uploadFile">'); */
					}
				});
	}
	$(function() {
		var width = $(window).width();
		if (width > 640) {
			width = 640;
		}
		$(".bgimg").attr("width", width);

		
		  $(".display_member_sel").click(function(){
	          	$(".display_member_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	var s = $(this).attr("src");
	          	if(s.indexOf("checkbox2x") !== -1){
	          		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
	          	}else{
	          		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
	          		$(":hidden[name=sex]").val($(this).attr("val"));
	          	}
	          });
		  
		  
			//确定按钮
	    	$("#conbtn").click(function(){
	    		
	    		var opName = $("#name").val();
	    		if(!opName){
	    			$('#name').val('').attr("placeholder","请输入姓名");
	    			return;
	    		}
	    		var phone = $("#phone").val();
	    		if(!phone){
	    			$('#phone').val('').attr("placeholder","请输入手机号码");
	    			return;
	    		}else{
	    			if(!validateForm('phone',phone)){
	    				return;
	    			}
	    		}
	    		if($('#isSendMsg').val()=='1'){
	    			var code = $("#code").val();
	    			if(!code){
	    				//$('#code').val('').attr("placeholder","请输入短信验证码");
	    				$(".myDefMsgBox").removeClass("warning_tip").addClass("warning_tip").css("display","").html("请输入短信验证码");
			 		    $(".myDefMsgBox").delay(2000).fadeOut();
	    				return;
	    			}
	    		}
	    		//验证邮箱
	    		var email = $("input[name=email]").val();
	    		if(email){
	    			if(!validateForm('email',email)){
	    				return;
	    			}
	    		}
	    		//验证公司名、职位、地址
	    		var company = $("input[name=company]").val();
	    		if(!checkStr(company)){
	    			$(".myDefMsgBox").removeClass("warning_tip").addClass("warning_tip").css("display","").html("请输入正确的公司名称");
		 		    $(".myDefMsgBox").delay(2000).fadeOut();
	    			return;
	    		}
	    		var position = $("input[name=position]").val();
	    		if(!checkStr(position)){
	    			$(".myDefMsgBox").removeClass("warning_tip").addClass("warning_tip").css("display","").html("请输入正确的职位");
		 		    $(".myDefMsgBox").delay(2000).fadeOut();
	    			return;
	    		}
	    		var address = $("input[name=address]").val();
	    		if(!checkStr(address)){
	    			$(".myDefMsgBox").removeClass("warning_tip").addClass("warning_tip").css("display","").html("请输入正确的地址");
		 		    $(".myDefMsgBox").delay(2000).fadeOut();
	    			return;
	    		}
	    		$("form[name=businessCardModify]").submit();
	    	});
			
	    	  $("#businessCardModify input").each(function() 
	    	 { 
	    			  $(this).attr('_value', $(this).val()); 
	    			    }); 
	    	  			$(window).bind('beforeunload',function(){ 
	    			 if(is_form_changed()) 
	    			    { 
	    			    	save();
	    			    } 
	    	 }); 

	});
	
	//验证特殊字符
	function checkStr(str){
        var myReg = /^[^@\/\'\\\"#$%&\^\*]+$/;
        if(myReg.test(str)) return true; 
        return false; 
    }
	
	function validateForm(type,val,disp){
		if(type == 'phone'){
			var exp = /^1[3|4|5|8][0-9]{9}$/;
			var r = exp.test(val);
			if (!r) {
					//$('#phone').val('').attr("placeholder", "格式不正确,请输入11位为手机号码!");
					if(!disp){
						$(".myDefMsgBox").removeClass("warning_tip").addClass("warning_tip").css("display","").html("请输入正确的手机号码");
			 		    $(".myDefMsgBox").delay(2000).fadeOut();
					}
					return false;
				
			}else{
				return true;
			}
		}else if(type == 'email'){
			var regMail = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/; //验证邮箱
			if(!regMail.test(val))
		    {
				if(!disp){
					$(".myDefMsgBox").removeClass("warning_tip").addClass("warning_tip").css("display","").html("请输入正确的邮箱地址");
	 		   	 	$(".myDefMsgBox").delay(2000).fadeOut();
				}
		        return false;
		    }else{
		    	return true;
		    }
		}
		return true;
	}
	
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
	
/* function update(){
	var opName = $("#name").val();
		if(!opName){
			$('#name').val('').attr("placeholder","请输入姓名");
			return;
		}
		var phone = $("#phone").val();
		if(!phone){
			$('#phone').val('').attr("placeholder","请输入联系电话");
			return;
		}else{
		var exp = /^1[3|4|5|8][0-9]{9}$/;
			var r = exp.test(phone);
				if (!r) {
					$('#phone').val('').attr("placeholder", "格式不正确,请输入11位为手机号码!");
					return;
				}
			}
		if($('#isSendMsg').val()=='1'){
			var code = $("#code").val();
			if(!code){
				$('#code').val('').attr("placeholder","请输入短信验证码");
				return;
			}
		}
	$("form[name=businessCardModify]").submit();
}	 */

var InterValObj; //timer变量，控制时间  
var count = 90; //间隔函数，1秒执行  
var curCount;//当前剩余秒数  
var code = ""; //验证码  
var codeLength = 6;//验证码长度 

//获取短信验证码
function sendMsg(){
     var jbPhone = $("#phone").val();  
     var exp = /^1[3|4|5|8][0-9]{9}$/;
    
     var r = exp.test(jbPhone);
	 if (!r) {
		$("input[name=phone]").val('').attr("placeholder", "格式不正确,请输入11位手机号码!");
		return;
	 }
	
	    $("#code").css("display",''); 
	    $("#phone").attr("readonly",true)
	 curCount = count;  
      // 产生验证码  
      for ( var i = 0; i < codeLength; i++) {  
         code += parseInt(Math.random() * 9).toString();  
      }  
      // 设置button效果，开始计时  
      $("#btnSendCode").attr("disabled", "true");  
      $("#btnSendCode").val(curCount + "秒后可再次获取");  
      InterValObj = window.setInterval(SetRemainTime, 1000); // 启动计时器，1秒执行一次  
      // 向后台发送处理数据  
      $.ajax({  
         type: "post", // 用POST方式传输  
         dataType: "text", // 数据格式:JSON  
         url: "<%=path%>/businesscard/sendMsg", // 目标地址  
         data: {"phonenumber":jbPhone,"code":code,"partyId":'${BusinessCard.partyId}',"businessCardId":'${BusinessCard.id}'},  
         success: function (data){   
             data = parseInt(data);
             //短信获取成功
             if(data == 0){  
            	//$("#myDefMsgBox").css("display",'');
     			$(".myDefMsgBox").removeClass("warning_tip").addClass("warning_tip").css("display","").html("验证码已发送，请查看您的手机输入验证码！");
     			$("#isSendMsg").val("1");//短信发送成功
     			$(".myDefMsgBox").delay(2000).fadeOut();
             }else if(data == 1){//短信获取失败
            	window.clearInterval(InterValObj);// 停止计时器  
     	        $("#btnSendCode").removeAttr("disabled");// 启用按钮  
     	        $("#btnSendCode").val("重新发送验证码"); 
     	       $("#phone").removeAttr("readonly");
             } 
          }  
      });  
}


function isEmailAddress(str) {
	var reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
    return reg.test(str);
}

//发送验证邮件
function sendEmailCheckMsg(){
     var jbemail = $("#email").val();  
	 if (!isEmailAddress(jbemail)) {
		$("input[name=email]").val('').attr("placeholder", "格式不正确,请输入正确的邮箱地址!");
		return;
	 }
	 
     $("#btnSendEmailCheckMsg").attr("disabled", "true");  
     // 向后台发送处理数据  
      $.ajax({  
         type: "post", // 用POST方式传输  
         dataType: "text", // 数据格式:JSON  
         url: "<%=path%>/businesscard/sendEmailCheckMsg", // 目标地址  
         data: {"email":jbemail,"partyId":'${BusinessCard.partyId}',"businessCardId":'${BusinessCard.id}'},  
         success: function (data){   
        	 $("#btnSendEmailCheckMsg").removeAttr("disabled");// 启用按钮  
 			$(".myDefMsgBox").removeClass("warning_tip").addClass("warning_tip").css("display","").html(data);
	    	$(".myDefMsgBox").delay(2000).fadeOut();
          }  
      });  
}
//timer处理函数  
function SetRemainTime() {  
    if (curCount == 0) {                  
        window.clearInterval(InterValObj);// 停止计时器  
        $("#btnSendCode").removeAttr("disabled");// 启用按钮  
        $("#btnSendCode").val("重新发送验证码");  
    }else {  
        curCount--;  
        $("#btnSendCode").val(curCount + "秒后可再次获取");  
    }  
} 

function save(){
	if($("#phone").val()){
		if(!validateForm('phone',$("#phone").val(),'n')){
			return;
		}
	}
	
	if($("#email").val()){
		if(!validateForm('email',$("#email").val(),'n')){
			return;
		}
	}
	var obj = [];
	obj.push({name :'id', value :$("#id").val()});
	obj.push({name :'sex', value :$("#sex").val()});
	obj.push({name :'partyId', value :$("#partyId").val()});
	obj.push({name :'headImageUrl', value :$("#headImageUrl").val()});
	obj.push({name :'isSendMsg', value :$("#isSendMsg").val()});
	obj.push({name :'isValidation', value: $("#isValidation").val()});
	obj.push({name :'name', value: $("#name").val()});
	obj.push({name :'company', value: $("#company").val()});
	obj.push({name :'position', value:$("#position").val()});
	obj.push({name :'phone', value: $("#phone").val()});
	obj.push({name :'email', value: $("#email").val()});
	obj.push({name :'address', value: $("#address").val()});
	obj.push({name :'city', value: $("#province").val() + "-" + $("#city").val()});
	$.ajax({
	      type: 'post',
	      url: '<%=path%>/businesscard/save' || '',
			data : obj || {},
			dataType : 'text',
			success : function(data) {
				if(!data || data === '-1'){
				}else{
					
				}
			}
		});
}

function onload(){
	onloadprovince();
	$("#province").val("<%=province%>");
	cityName("<%=province%>");
	$("#city").val("<%=city%>");
}
</script>
</head>

<body style="min-height: 100%;background-color:#eee;"  onload="onload()">
	<!-- <div id="site-nav" class="navbar" style="">
		<div style="float: left;line-height:50px;">
			<a href="javascript:void(0)" onclick="javascript:history.go(-1)" style="padding:10px 5px;">
				<img src="<%=path %>/image/back.png" width="30px">
			</a>
		</div>
		<h3 style="padding-right: 45px;">完善个人信息</h3>
			<div id="conbtn" class="act-secondary menu-group" style="margin-right:10px;" >
				保存
		</div>
	</div>
	 -->
	<div class="zjwk_fg_nav">
		<a href="javascript:void(0)" onclick="history.go(-1);">取消</a>&nbsp;&nbsp;&nbsp;
		<a href="javascript:void(0)" id="conbtn">保存</a>&nbsp;&nbsp;
	</div>
	<div style="line-height: 35px; border-bottom: 1px solid #ddd;border-top: 1px solid #ddd;background-color:#fff; margin: 0.5em 0;">
		<div class="" style="padding-left:10px; padding-right: 40px;">
			<div class="_org_name_">资料完善度：${PerfectionRate}%</div>
		</div>
	</div>
	<div class="site-recommend-list page-patch acclist">
		<div class="list-group1 listview" style="font-size:14px;">
			<!-- <h4>详情</h4> -->
			<form name="businessCardModify" id="businessCardModify" method="post" novalidate="true"  action="<%=path%>/businesscard/update">
				<input type="hidden" name="id" id="id" value="${BusinessCard.id}" />
				<input type="hidden" name="sex" id="sex" value="${BusinessCard.sex}" />
				<input type="hidden" name="partyId" id="partyId" value="${BusinessCard.partyId}" />
			    <input type="hidden" name="headImageUrl" id="headImageUrl" value="${BusinessCard.headImageUrl}" />
			    <input type="hidden" name="isSendMsg" id="isSendMsg" value="" />
			   <input type="hidden" name="isValidation" id="isValidation" value="${BusinessCard.isValidation}" />
			 <div 
				class="list-group-item listview-item"
				style="border-top: 1px solid #ddd">
				<div style="width: 100%;">
					<div style="float: left;">
						<div id="headImageDiv">
							<c:if
								test="${BusinessCard.headImageUrl ne '' and BusinessCard.headImageUrl ne null}">
								<img id="headImg" name="headImg" src="<%=path%>/contact/download?flag=dccrm&fileName=${BusinessCard.headImageUrl}" height="60px" onclick="javascript:upload()">
							</c:if>
							<c:if
								test="${BusinessCard.headImageUrl eq '' or BusinessCard.headImageUrl eq null}">
								<img id="headImg" name="headImg"  src="${user.headimgurl}" height="60px" onclick="javascript:upload()">
							</c:if>
						</div>
							<div style="clear: both;"></div>
						<div style="padding-top: 5px; font-size: 8px; color: #fff;">
							<input type="button" value="更换头像"
								style="padding: 2px; color: #fff; border-radius: 5px;" onclick="javascript:upload()">								
										<input type="file" onchange="ajaxFileUpload();"
							accept="image/gif,image/x-png, image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg"
							class="fileInput" style="height:1px" name="uploadFile" id="uploadFile">	
						
						</div>
					</div>
					<div style="margin-left: 70px;">
				
							<div style="float: left; margin-top:5px">
							<span style="color:red">*</span>
							</div>
							<div style="float: left; width:90%">
							<input type="text" value="${BusinessCard.name}"
								placeholder="请输入姓名" style="border: none;"  id="name" name="name">
							</div>
						<c:if
							test="${BusinessCard.sex ne '' and BusinessCard.sex ne null}">
							<div style="margin-left: 15px; float: left;">
								男
								<c:if test="${BusinessCard.sex == '0'}">
									<img src="<%=path%>/image/checkbox2x.png"
										style="cursor: pointer; margin-left: 5px; width: 25px;"
										class="display_member_sel" val="0">
								</c:if>
								<c:if test="${BusinessCard.sex == '1'}">
									<img src="<%=path%>/image/checkbox-no2x.png"
										style="cursor: pointer; margin-left: 5px; width: 25px;"
										class="display_member_sel" val="0">
								</c:if>
							</div>
							<div style="margin-left: 15px; float: left;">
								女
								<c:if test="${BusinessCard.sex == '1'}">
									<img src="<%=path%>/image/checkbox2x.png"
										style="cursor: pointer; margin-left: 5px; width: 25px;"
										class="display_member_sel" val="1">
								</c:if>
								<c:if test="${BusinessCard.sex == '0'}">
									<img src="<%=path%>/image/checkbox-no2x.png"
										style="cursor: pointer; margin-left: 5px; width: 25px;"
										class="display_member_sel" val="1">
								</c:if>
							</div>
						</c:if>
						<c:if test="${BusinessCard.sex eq '' or BusinessCard.sex eq null}">
							<div style="margin-left: 15px; float: left;">
								男 <img src="<%=path%>/image/checkbox2x.png"
									style="cursor: pointer; margin-left: 5px; width: 25px;"
									class="display_member_sel" val="0">
							</div>
							<div style="margin-left: 15px; float: left;">
								女 <img src="<%=path%>/image/checkbox-no2x.png"
									style="cursor: pointer; margin-left: 5px; width: 25px;"
									class="display_member_sel" val="1">
							</div>
						</c:if>
					</div>

				</div>
			</div> 
			<Br/>
			<div style="background-color:#fff;width:100%;padding:1.2em 0 0 0em;">
			<div style="margin-top:-10px;color:#333;padding-left:0.8em;"><img src="<%=path%>/image/busi_card.png" style="height: 12px;">&nbsp;个人资料</div>
			<a href="javascript:void(0)"
				class="list-group-item listview-item">
				<div style="width: 100%;">
					<!-- <div style="float:left;padding-left:15px;"><img src="<%=path%>/image/zjwk_qrcode.png" height="20px"></div> -->
				<!-- 	<div style=""><</div>
					<div style="float: right; margin-top: -25px;">
						<span class="icon icon-uniE603"></span>
					</div> -->
						<input type="text" id="company" name="company" value="${BusinessCard.company}"
							placeholder="请输入公司名" style="border: none;height:40px;border-bottom: 1px solid #eee;" />
						<input type="text" id="shortcompany" name="shortcompany" value="${BusinessCard.shortcompany}"
							placeholder="请输入公司简称" style="border: none;height:40px;border-bottom: 1px solid #eee;" />
								<input type="text"  id="position" name="position" value="${BusinessCard.position}"
							placeholder="请输入您的职位" style="border: none;height:40px;" />
				</div>
			</a>
			<a href="javascript:void(0)"
				class="list-group-item listview-item"">
				<div style="width: 100%;">
						<div class="form-group"><span style="color:red">*</span>
				<input name="phone" id="phone"  type="number" value="${BusinessCard.phone}" 
							placeholder="请输入手机号码" style="border: none;width:55%" 
							<c:if test="${'1' eq BusinessCard.isValidation}">readonly</c:if>
							
							 />
							 <c:if test="${'1' eq BusinessCard.isValidation}">
							 <input type="button" style="font-size:12px;float: right;height: 2.2em;width:40%;color: #fff;font-family: Microsoft Yahei;background-color: RGB(75, 192, 171);" id="isv" name="isv" value="已验证"  />
							 </c:if>
							<c:if test="${'1' ne BusinessCard.isValidation}">
			<input type="button" style="font-size:12px;float: right;height: 2.2em;width:40%;color: #fff;font-family: Microsoft Yahei;background-color: RGB(75, 192, 171);" id="btnSendCode" name="btnSendCode" value="免费获取验证码" onclick="javascript:sendMsg()" />
			</c:if>
						</div>
			<input name="code" id="code" type="text" value="" style="width:55%;display:none" maxLength="6" placeholder="请输入短信验证码">
			
			<div class="form-group">
								<input type="text" id="email" name="email" value="${BusinessCard.email}"
							placeholder="请输入邮件地址" style="border: none;width:55%" />
							 <c:if test="${'1' eq BusinessCard.isEmailValidation}">
			<input type="button" style="font-size:12px;float: right;height: 2.2em;width:40%;color: #fff;font-family: Microsoft Yahei;background-color: RGB(75, 192, 171);" id="btnSendEmailCheckMsg" name="btnSendEmailCheckMsg" value="验证邮件（已验证）" onclick="javascript:sendEmailCheckMsg()" />
							 </c:if>
							 <c:if test="${'1' ne BusinessCard.isEmailValidation}">
			<input type="button" style="font-size:12px;float: right;height: 2.2em;width:40%;color: #fff;font-family: Microsoft Yahei;background-color: RGB(75, 192, 171);" id="btnSendEmailCheckMsg" name="btnSendEmailCheckMsg" value="验证邮件" onclick="javascript:sendEmailCheckMsg()" />
							 </c:if>
			</div>
			
			
			<div style="padding:0px 8px;border:1px solid #ddd;line-height:30px;background-color:#fff;margin-right:10px;margin-top:5px;">
					<div>
						<select id="province" name="province" onchange="cityName(this.value);"  style="border: 1px;border-bottom-style: ridge;height: 50px">
						            <option value="">
						             省份
						            </option>
						</select>
					<!-- <input name="province"  style="height:50px;border-bottom: 1px;border-bottom-style: ridge;width: 99%" placeholder="省份"> --></div>
					<div style="clear: both;"></div>
					<div>
						<select id="city" name="city" style="border: 1px;border-bottom-style: ridge;height: 50px">
						            <option value="">
						             城市
						            </option>
						</select>
					<!-- <input name="city"  style="height:50px;border-bottom: 1px;border-bottom-style: ridge;width: 99%" placeholder="城市"> --></div>
					<div style="clear: both;"></div>
					<div><input name="address"  style="height:50px;width: 99%" placeholder="请输入联系地址" value="${BusinessCard.address}"></div>
				</div>
				</div>
			</a>
			</div>
			</form>
			
			<Br/>
			<a href="javascript:void(0);"
				class="list-group-item listview-item" style="">
				<div style="width: 100%;">
					<div style="margin-top:-10px;color:#333;"><img src="<%=path%>/image/tags_list.png" style="height: 16px;">个人标签（建议：爱好/行业/工作方向等）</div>
					<div style="float:left; margin-top:10px;width: 100%;">
							<%--标签 --%>
					<jsp:include page="/common/tag.jsp">
						<jsp:param name="parentid" value="${BusinessCard.partyId}" />
						<jsp:param name="parenttype" value="personage" />
					</jsp:include>
					</div>
				</div>
			</a>
			<br/>
			<a href="javascript:void(0);"
				class="list-group-item listview-item" style="">
			<div style="width: 100%;">
					<div style="margin-top:-10px;color:#333;"><img src="<%=path%>/image/tags_list.png" style="height: 16px;">商品标签（建议：品类/名称/品牌等）</div>
					<div style="float:left; margin-top:10px;width: 100%;">
					<jsp:include page="/common/tag.jsp">
						<jsp:param name="parentid" value="${BusinessCard.partyId}" />
						<jsp:param name="parenttype" value="goods" />
					</jsp:include>
					</div>
				</div>
			</a>
	<%-- 		<a href="${zjrm_url}/out/group/mylist/${party_row_id}"
					class="list-group-item listview-item">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_qun.png" height="20px"></div>-->
				<div style="">我的群动态</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a> --%>

			<br /> <a
				href="javascript:void(0)"
				class="list-group-item listview-item"
				style="border-top: 1px solid #ddd">
				<div style="width: 100%;">
					<!-- <div style="float:left;padding-left:15px;"><img src="<%=path%>/image/zjwk_qrcode.png" height="20px"></div> -->
					<div style="margin-top:-10px;color:#333;"><img src="<%=path%>/image/tags_list.png" style="height: 16px;">客户群体标签（建议：行业/人群等）</div>
					<div style="float:left; margin-top:10px;width: 100%;">
					<jsp:include page="/common/tag.jsp">
						<jsp:param name="parentid" value="${BusinessCard.partyId}" />
						<jsp:param name="parenttype" value="clientBase" />
					</jsp:include>
					</div>
				</div>
			</a>

		</div>
	</div>
	<div class="myDefMsgBox" style="display:none;">&nbsp;</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>