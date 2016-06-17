<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/css/style.css">
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css">
<script type="text/javascript">
    $(function () {
    	$(".cancelbinding").click(function(){
    		if(confirm("确认要解除绑定吗？")){
    			window.location.replace("<%=path%>/sys/cancel?orgId=${org.id}");
    		}
    	});
    	
    	//设置默认值
    	$(".default_account").click(function(){
    		//判断老密码
    		$.ajax({
        		url: '<%=path%>/urperf/saveaccntperf',
        		type: 'post',
        		data: {orgId:"${org.id}"},
        		dataType: 'text',
        	    success: function(data){
        	    	if(data && data == 'success'){
        	    		$(".myMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("设置成功！");
        	  		    $(".myMsgBox").delay(2000).fadeOut();
        	  		    $(".default_account").css("display","none");
        	    	}else{
        	    		$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("验证原始密码失败!");
        	  		    $(".myMsgBox").delay(2000).fadeOut();
        	    	}
        	    }
        	});
    	});
    	
    	//设置
    	$(".setmobile").click(function(){
    		$(".nobindingmobile").css("display","none");
    		$(".bindingmobile").css("display","");
    		$("#btnSendCode").css("display","");
    		$(".setmobile").css("display","none");
    	});
    	
    	$(".validatemobile").click(function(){
    		var mobile = currmobile;
    		if(code && code == $("input[name=validate_code]").val()){
    			//保存
    			$(".nobindingmobile").html(mobile).css("display","");
        		$(".bindingmobile").css("display","none");
        		$("#btnSendCode").css("display","none");
        		$(".setmobile").css("display","none");
        		$(".input_code").css('display','none'); 
        		
        		//判断老密码
        		$.ajax({
            		url: '<%=path%>/sys/upduser',
            		type: 'post',
            		data: {orgId:"${org.id}",crmId:"${crmId}",mobile:mobile},
            		dataType: 'text',
            	    success: function(data){
            	    	if(data && data == 'success'){
            	    		$(".myMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("验证手机成功");
            	  		    $(".myMsgBox").delay(2000).fadeOut();
            	    	}else{
            	    		$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("验证手机失败");
            	  		    $(".myMsgBox").delay(2000).fadeOut();
            	    	}
            	    }
            	});
        		
    		}else{
    			$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("验证码验证失败");
            	$(".myMsgBox").delay(2000).fadeOut();
    		}
    	});
	});
  
    var InterValObj; //timer变量，控制时间  
    var count = 90; //间隔函数，1秒执行  
    var curCount;//当前剩余秒数  
    var code = ""; //验证码  
    var codeLength = 6;//验证码长度 
	var currmobile = "";
    //获取短信验证码
    function sendMsg(){
         var jbPhone = $("input[name=mobile]").val();  
         var exp = /^1[3|4|5|8][0-9]{9}$/;
         var r = exp.test(jbPhone);
    	 if (!r) {
    		$("input[name=mobile]").val('').attr("placeholder", "请重新输入");
    		return;
    	 }
    	 currmobile = jbPhone;
    	
    	 $("#code").css("display",''); 
    	 $("#mobile").attr("readonly",true)
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
             data: {"phonenumber":jbPhone,"code":code,"partyId":'${partyId}',"businessCardId":'${partyId}'},  
             success: function (data){   
                 data = parseInt(data);
                 //短信获取成功
                 if(data == 0){  
         			$(".myMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("验证码已发送，请留意手机短信消息");
         			$("#isSendMsg").val("1");//短信发送成功
         			$(".myMsgBox").delay(2000).fadeOut();
         			$(".input_code").css('display','');
                 }else if(data == 1){//短信获取失败
                	$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("发送验证码失败");
                	$(".myMsgBox").delay(2000).fadeOut();
                	window.clearInterval(InterValObj);// 停止计时器  
         	        $("#btnSendCode").removeAttr("disabled");// 启用按钮  
         	        $("#btnSendCode").val("重新发送验证码"); 
         	       $("#phone").removeAttr("readonly");
                 } 
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
    </script>
</head>
<body style="font-size:14px;">
	<div style="line-height:35px;width: 100%; padding: 5px 10px; background-color: #fff;margin-top:10px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;">
		
		<c:if test="${org.id eq 'Default Organization' }">
			<div>
				<div style="float:left;">私人账户</div>
				<c:if test="${DefaultOrg ne org.id}">
					<div style="float:right;" class="default_account"><a href="javascript:void(0)" style="color:blue;">设为默认账户</a></div>
				</c:if>
			</div>
			<div style="clear:both;"></div>
			<div style="border-top:1px solid #eee;">
				<div style="float:left;width: 80px;color:#999;">账户类型</div>
				<div style="">标准版</div>
			</div>
			<div style="clear:both;"></div>
			<div style="border-top:1px solid #eee;">
				<div style="float:left;width: 80px;color:#999;">指尖账号</div>
				<div style="">${user.username }</div>
			</div>
			<div style="clear:both;"></div>
			<div style="border-top:1px solid #eee;">
				<div style="float:left;width: 80px;color:#999;">注册时间</div>
				<div style="">${user.registdate }</div>
			</div>
			<div style="clear:both;"></div>
			<div style="border-top:1px solid #eee;">
				<div style="float:left;width: 80px;color:#999;">手机号码</div>
				<div style="">
					<c:if test="${user.mobile eq ''}">
						<span class="nobindingmobile">未绑定<a href="javascript:void(0)" class="setmobile" style="color:blue;">，立即设置</a></span>
					</c:if>
					<c:if test="${user.mobile ne ''}">
						${user.mobile}
						<div style="float:right;">
							<a href="javascript:void(0)" class="setmobile" style="color:blue;">更改</a>
						</div>
					</c:if>
						<div style="clear:both;"></div>
						<div>
							<span class="bindingmobile" style="display:none;"><input type="number" name="mobile" placeholder="请输入手机号码" style="width: 150px;"></span>
							<input type="button" style="margin-top: 3px;font-size:14px;float: right;height: 2.2em;width:40%;color: #fff;font-family: Microsoft Yahei;background-color: RGB(75, 192, 171);display:none;" id="btnSendCode" name="btnSendCode" value="免费获取验证码" onclick="javascript:sendMsg()" />
						</div>
						<div class="input_code" style="display:none;">
							<input type="number" name="validate_code" placeholder="请输入验证码" style="width: 150px;" maxlength="6">
							<a href="javascript:void(0)" class="validatemobile" style="color:blue;padding:5px;">验证</a>
						</div>
					<div style="clear:both;"></div>
					<c:if test="${user.mobile eq ''}">
						<div style="color:#999;">手机号码将助于找回账户</div>
					</c:if>
				</div>
			</div>
		</c:if>
		
		<c:if test="${org.id ne 'Default Organization' }">
			<div>
				<div style="float:left;">企业账户</div>
				<c:if test="${DefaultOrg ne org.id}">
					<div style="float:right;" class="default_account"><a href="javascript:void(0)" style="color:blue;">设为默认账户</a></div>
				</c:if>
			</div>
			<div style="clear:both;"></div>
			<div style="border-top:1px solid #eee;">
				<div style="float:left;width: 80px;color:#999;">账户类型</div>
				<div style="">企业版账户</div>
			</div>
			<div style="clear:both;"></div>
			<div style="">
				<div style="float:left;width: 80px;color:#999;">企业名称</div>
				<div style="">${org.fullname }</div>
			</div>
			<div style="clear:both;"></div>
			<div style="">
				<div style="float:left;width: 80px;color:#999;">企业简称</div>
				<div style="">${org.name}</div>
			</div>
			<div style="clear:both;"></div>
			<div style="">
				<div style="float:left;width: 80px;color:#999;">企业账号</div>
				<div style="">${org.orgnum}</div>
			</div>
			<div style="clear:both;"></div>
			<div style="">
				<div style="float:left;width: 80px;color:#999;">账号</div>
				<div style="">${user.crmAccount}</div>
			</div>
			<div style="clear:both;"></div>
			<div style="">
				<div style="float:left;width: 80px;color:#999;">用户角色</div>
				<c:if test="${user.adminflag eq '1' }">
					<div style="">管理员</div>
				</c:if>
				<c:if test="${user.adminflag ne '1' }">
					<div style="">普通用户</div>
				</c:if>
			</div>
			<div style="clear:both;"></div>
			<div style="">
				<div style="float:left;width: 80px;color:#999;">注册时间</div>
				<div style="">${user.registdate}</div>
			</div>
			<div style="clear:both;"></div>
			<div style="">
				<div style="float:left;width: 80px;color:#999;">手机号码</div>
				<div style="">
					${user.mobile }
					<div style="float:right;display:none;">
						<a href="javascript:void(0)" style="color:blue;">更改</a>
					</div>
				</div>
			</div>
			<div style="clear:both;"></div>
			<div style="">
				<div style="float:left;width: 80px;color:#999;">注册邮箱</div>
				<div style="">
					${user.email }
					<div style="float:right;display:none;">
						<a href="javascript:void(0)" style="color:blue;">更改</a>
					</div>
				</div>
			</div>
			<div style="border-top:1px solid #eee;text-align:center;padding-top: 5px;">
				<span><a href="<%=path %>/sys/updpwd?orgId=${org.id}" class="updpassword" style="padding: 5px 8px;background-color: #078E46;color:#fff;border-radius:8px;">修改密码</a></span>
				&nbsp;&nbsp;&nbsp;&nbsp;
				<span><a href="javascript:void(0)" class="cancelbinding" style="padding: 5px 8px;background-color: red;color:#fff;border-radius:8px;">解除绑定</a></span>
			</div>
		</c:if>
	</div>
	
	<div style="clear:both;"></div>


	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;">&nbsp;</div>
	<br><br><br><br><br>
</body>
</html>