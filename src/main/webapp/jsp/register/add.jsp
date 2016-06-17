<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script type="text/javascript">
	$(function () {
		//initWeixinFunc();
		initButton();
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
	
	//表单提交
	function initButton(){
		$(".saveBtn").click(function(){
			var flag= false;
			$("#sysform").find("input").each(function(){
				 var n = $(this).val();
				 if(null==n||''==n){
					 flag = true;
				 }
			});
			if(flag){
				$(".myMsgBox").css("display","").html("填写不完整!请您将带有*标签的字段都填上!");
		    	$(".myMsgBox").delay(2000).fadeOut();
	    	    return;
			}
			var name = $("input[name=org_name]").val();
			//检查重名
			checkName(name)			
		});
	}
	
	//检查是否有重名的情况
	function checkName(name){
		$.ajax({
			 type: 'post',
		      url: '<%=path%>/register/checkName',
		      data: {name:name},
		      ansyc:false,
		      dataType: 'text',
		      success: function(data){
		    	  var d = JSON.parse(data);
		    	  if(d.errorCode && "0"!=d.errorCode){
		    		  $("input[name=org_name]").val('');
		    		  $(".myMsgBox").css("display","").html(d.errorMsg);
					  $(".myMsgBox").delay(2000).fadeOut();
		    		  return true;
		    	  }else{
		    		  $("#sysform").submit();
		    	  }
		      },
		      error:function(){
		    	  return true;
		      }
		});
	}
	
</script>
</head>

<body>
	<div id="task-create" class=" ">
		<div id="site-nav" class="navbar">
			<div class="act-secondary" data-toggle="navbar"
				data-target="nav-collapse">
			</div>
			注册申请
		</div>
		<div class="wrapper">
			<form id="sysform" name="sysform" action="<%=path%>/register/save" method="post">
				<div class="form-group">
					<label class="control-label" for="realname">企业名称<span style="color:red;">*</span>&nbsp;</label>
					<input name="org_name" id="org_name" value="" type="text"
						class="form-control" placeholder="企业名称" />
				</div>
				<div class="form-group">
					<label class="control-label" for="realname">行业<span style="color:red;">*</span>&nbsp;</label>
					<input name="industry" id="industry" value="" type="text"
						class="form-control" placeholder="行业" />
				</div>
				<div class="form-group">
					<label class="control-label" for="realname">地址<span style="color:red;">*</span>&nbsp;</label>
					<input name="address" id="address" value="" type="text"
						class="form-control" placeholder="地址" />
				</div>
				<div class="form-group">
					<label class="control-label" for="realname">联系人<span style="color:red;">*</span>&nbsp;</label>
					<input name="conname" id="conname" value="" type="text"
						class="form-control" placeholder="联系人姓名" />
				</div>
				<div class="form-group">
					<label class="control-label" for="realname">联系电话<span style="color:red;">*</span>&nbsp;</label>
					<input name="mobile" id="mobile" value="" type="number"
						class="form-control" placeholder="联系电话" />
				</div>
				<div class="form-group">
					<label class="control-label" for="desc">说明</label>
					<textarea name="desc" style="min-height: 3em" id="desc" rows="4"
						class="form-control" placeholder="企业描述"></textarea>
				</div>
				<div class="form-group">
					<label class="control-label" for="realname">管理员用户名<span style="color:red;">*</span>&nbsp;</label>
					<input name="crmAccount" id="crmAccount" value="" type="text"
						class="form-control" placeholder="登录用户名" />
				</div>
				<div class="form-group">
					<label class="control-label" for="realname">管理员密码<span style="color:red;">*</span>&nbsp;</label>
					<input name="crmPass" id="crmPass" value="" type="password"
						class="form-control" placeholder="登录密码" />
				</div>
				
				<div>
					<input type="button" class="btn btn-block saveBtn" value="提交申请">
				</div>
			</form>
		</div>
	</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	<!--脚页面  -->
    <jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>