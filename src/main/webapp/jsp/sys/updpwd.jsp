<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<script>

$(function(){
	$(".savepwd").click(function(){
		//系统
		var orgId = "${orgId}";		
		var oldpwd = $("input[name=oldpwd]").val();
		var newpwd = $("input[name=newpwd]").val();
		var confnewpwd = $("input[name=confnewpwd]").val();
		
		if(!oldpwd){
			$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请输入原始密码!");
  		    $(".myMsgBox").delay(2000).fadeOut();
  		    return;
		}
		
		if(!newpwd || !confnewpwd){
			$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请输入新密码!");
  		    $(".myMsgBox").delay(2000).fadeOut();
  		    return;
		}
		
		if(newpwd != confnewpwd){
			$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("确认密码不一致!");
  		    $(".myMsgBox").delay(2000).fadeOut();
  		    return;
		}
		
		//判断老密码
		$.ajax({
    		url: '<%=path%>/register/validuser',
    		type: 'post',
    		data: {orgId:orgId,userpwd:oldpwd},
    		dataType: 'text',
    	    success: function(data){
    	    	if(data && data == 'success'){
    	    		updatePwd(orgId,newpwd);
    	    	}else{
    	    		$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("验证原始密码失败!");
    	  		    $(".myMsgBox").delay(2000).fadeOut();
    	    	}
    	    }
    	});
		
	});
	
	//修改新密码
	function updatePwd(orgId,newpwd){
		$.ajax({
    		url: '<%=path%>/register/updpassword',
    		type: 'post',
    		data: {orgId:orgId,userpwd:newpwd},
    		dataType: 'text',
    	    success: function(data){
    	    	if(data && data == 'success'){
    	    		$(".myMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("修改成功!");
    	  		    $(".myMsgBox").delay(2000).fadeOut();
    	  		    window.location.replace("<%=path %>/sys/detail?orgId="+orgId);
    	    	}else{
    	    		$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("修改密码失败!");
    	  		    $(".myMsgBox").delay(2000).fadeOut();
    	    	}
    	    }
    	});
	}
	
});
</script>
<style type="text/css">

.none {
	display: none
}
.g-mask {
	position: fixed;
	top: -0px;
	left: -0px;
	width: 100%;
	height: 100%;
	background: #000;
	filter: alpha(opacity = 60);
	opacity: 0.5;
	z-index: 998;
}
</style>
</head>
<body style="min-height:100%;font-size:14px;">
	
	<div style="width: 100%; padding: 5px 10px; background-color: #fff;margin-top:10px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;">
		<div style="padding: 3px 5px; border-bottom: 1px solid #eee;">
			<div style="position: absolute; line-height: 30px; color: #999;">原&nbsp;&nbsp;密&nbsp;码</div>
			<input name="oldpwd" id="oldpwd" value=""
				type="password" class="form-control"
				style="border: 0px; padding-left: 100px;" />
		</div>
		<div style="padding: 3px 5px; border-bottom: 1px solid #eee;">
			<div style="position: absolute; line-height: 30px; color: #999;">新&nbsp;&nbsp;密 码</div>
			<input name="newpwd" id="newpwd" value=""
				type="password" class="form-control"
				style="border: 0px; padding-left: 100px;" />
		</div>
		<div style="padding: 3px 5px;">
			<div style="position: absolute; line-height: 30px; color: #999;">确认密码</div>
			<input name="confnewpwd" id="confnewpwd" value=""
				type="password" class="form-control"
				style="border: 0px; padding-left: 100px;" />
		</div>
	</div>

	<div class="wrapper" style="margin-top: 30px;">
		<div class="button-ctrl">
			<fieldset class="">
				<div class="ui-block-a" style="width: 100%; padding: 0 5em;">
					<a class="btn btn-success btn-block savepwd"
						href="javascript:void(0)"
						style="background-color: #49af53; font-size: 14px; margin-left: 10px; margin-right: 10px;">
						修改</a>
				</div>

			</fieldset>
	</div>
	<div class="g-mask none">&nbsp;</div>

	<div class="myMsgBox" style="display:none">
		
	</div> 

</body>
</html>