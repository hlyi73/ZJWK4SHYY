<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
	<title>指尖微客</title>
	<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
	<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
	
	<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
	
	<script type="text/javascript">
	$(function(){
		//initWeixinFunc();
		display();
		initForm();
	});
	
	//微信网页按钮控制
	/* function initWeixinFunc(){
		//隐藏顶部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
	
	function display(){
		var bindSucc = '${bindSucc}';
		if(bindSucc === "success"){
			$(".bindFormDiv").css("display",'none');
			$(".bindMsgDiv").css("display",'none');
			
			$(".topdiv").css("display",'');
			$(".icon-menu").css("display",'');
		}
		if(bindSucc !== "success"){
			$(".bindFormDiv").css("display",'');
			$(".bindMsgDiv").css("display",'');
		}
	}
	
	function initForm(){
		var bForm = $("form[name=bandingForm]"),
			crmAcc = $("input[name=crmAccount]"),
			crmPass = $("input[name=crmPass]"),
		    bindFormBtn = $("input[name=bandingFormBtn]");
		
		bindFormBtn.click(function(){
			if(!crmAcc.val()){
				crmAcc.attr("placeholder", "请输入CRM账号");
				return;
			}
			crmAcc.css("border-color", "#b5b5b5");
			if(!crmPass.val()){
				crmPass.attr("placeholder", "请输入crm密码");
				return;
			}
			bForm.submit();
		});
	}
	
	</script>
</head>
<body style="background-color:#fff;height:100%;">
	<div class="topdiv" style="display:none;">
	   	<div id="site-nav" class="navbar"  style="line-height: 65px;height: 65px;">
			<div class="act-secondary" data-toggle="navbar"
				data-target="nav-collapse" >
				<i style="display:none;"class="icon-menu"><b></b></i>
			</div>
			帐户绑定
		</div>
	</div>
	
	
	
	<div class="page-patch">
		<div class="wrapper bindFormDiv" style="margin:0;padding-left:30px;padding-right:30px;">
			<form name="bandingForm" action="<%=path%>/operMobile/save"
				method="post" novalidate="true">
				<!-- openId and publicId -->
<%--  				<input type="hidden" name="openId" value="${openId}"/>
 				<input type="hidden" name="publicId" value="${publicId}"/> --%>
				<!-- token  -->
				<input type="hidden" name="springMVC_token" value="${springMVC_token}"/><br>
 				<div style="width:100%;text-align:center;margin-top:60px;">
 					<img src="<%=path %>/image/takshine_logo.png" width="260px" >
 				</div>
 				<c:if test="${fn:length(orgList) == 0 }">
					<div style="margin-top:100px;text-align:center;font-size:18px;color:blue;font-weight:bold;">暂时没有企业可以绑定！</div>
				</c:if>
 				<c:if test="${fn:length(orgList) >0 }">
 				<input type="hidden" name="entId" value="1"/>
					<div class="form-group" style="margin-top:50px;margin-bottom:0px;border:1px solid #D2E9FF;height:45px;line-height:45px;">
						<div style="float:left;width:35px;margin-left:10px;"><img src="<%=path %>/image/login_user.png" width="18px"></div>
						<div style="margin-left:45px;">
							<input name="crmAccount" id="crmAccount" required="" value="" type="text"
								class="form-control" placeholder="crm帐号"  style="margin-top:4px;border:0px solid #D2E9FF;font-size:16px;">
							<div class="help-block empty">请输入crm帐号</div>
						</div>
					</div>
					<div class="form-group" style="margin-top:10px;margin-bottom:0px;border:1px solid #D2E9FF;height:45px;line-height:45px;">
						<div style="float:left;width:35px;margin-left:10px;"><img src="<%=path %>/image/login_pwd.png" width="18px"></div>
						<div style="margin-left:45px;">
						<input name="crmPass" id="crmPass" required="" value="" type="password"
							class="form-control" placeholder="crm密码(区分大小写)" style="margin-top:4px;border:0px solid #D2E9FF;font-size:16px;width:100%;">
						<div class="help-block empty">请输入crm密码</div>
						</div>
					</div>
					<div class="form-group" style="margin-top:10px;margin-bottom:0px;border:1px solid #D2E9FF;height:45px;line-height:45px;">
						<div style="float:left;width:35px;margin-left:10px;"><img src="<%=path %>/image/login_group.png" width="18px"></div>
						<div style="margin-left:45px;margin-right:10px;">
						<select name="orgId" style="border:0px solid #D2E9FF;color:#999;margin-left:5px;margin-right:5px;font-size:16px;">
							
								<c:forEach items="${orgList}" var="org">
									<option value="${org.orgId}">${org.orgName}</option>
								</c:forEach>
							
						</select>
						<div class="help-block empty">请选择所属公司</div>
						</div>
					</div>
					<div style="margin-top:20px;">
						<input type="button" name="bandingFormBtn" class="btn btn-success btn-block" style="font-size: 18px;font-weight: bold;height: 40px;line-height: 40px;" value="绑  定">
					</div>
					</c:if>
			</form>
		</div>
		
		<!-- 消息提示 -->
		<div class="wells text-center wrapper bindMsgDiv" style="padding: 1em 0;display:none;">
			<c:if test="${bindSucc eq 'success'}">
				<div style="width:100%;text-align:center;">
 					<img src="<%=path %>/image/oper_success.png" width="80px" >
 				</div>
 				<br/>
				<h3 class="text-info" style="font-size: 18px;">账户绑定操作成功!</h3>
			    <br>  如需使用请联系管理员!<br>
			</c:if>
			<c:if test="${bindSucc eq 'already'}">
				<div style="width:100%;text-align:center;">
 					<img src="<%=path %>/image/oper_fail.png" width="100px" >
 				</div>
 				<br/>
			    <h3 class="text-info" style="font-size: 18px;color:red">您的账户已被占用!</h3>
			    <br><br> 如需使用请联系管理员!<br>
			</c:if>
			<c:if test="${bindSucc eq 'fail'}">
			  <div style="border-top:1px solid #eee;width:100%;padding-top:10px;">
			    <h3 class="text-info" style="font-size: 18px;color:red">账户绑定失败!</h3>
			 </div>
			    <div style="width:100%;margin-top:15px;color:#666;font-size:14px;text-align:center;">
			    	如有问题，请联系管理员联系,确认您的账户是否正确!
			    </div>
			</c:if>
			<c:if test="${bindSucc eq 'sources'}">
				<div style="width:100%;text-align:center;">
 					<img src="<%=path %>/image/oper_fail.png" width="100px" >
 				</div>
 				<br/>
			    <h3 class="text-info" style="font-size: 18px;color:red">系统异常!</h3>
			    <br> 请与管理员联系<br> 
			</c:if>
		</div>
	</div>
    
</body>
</html>