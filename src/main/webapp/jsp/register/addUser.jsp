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
		var flag= false;
		$("#sysform").find("input").each(function(){
			 var n = $(this).val();
			 var name = $(this).attr("name");
			 if("title"!=name){
				 if(null==n||''==n){
					 flag = true;
				 }
			 }
		});
		
		if(flag){
			$(".myMsgBox").css("display","").html("填写不完整!");
	    	$(".myMsgBox").delay(2000).fadeOut();
    	    return;
		}
		//验证邮箱地址是否合法
		var v = $("input[name=email]").val();
		//var exp = /^\w+((-\w+)|(\.\w+))*\@[A-Za-z0-9]+((\.|-)[A-Za-z0-9]+)*\.[A-Za-z0-9]+$/;
		var exp = /^([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+@([a-zA-Z0-9]+[_|\_|\.]?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,3}$/;
		var r = exp.test(v);
		if(!r){
			 $("input[name=email]").val('').attr("placeholder","邮箱不正确，请重新输入");
			 return;
		}
		$("#sysform").submit();
	}
</script>
</head>

<body>
	<div id="task-create" class=" ">
		<div id="site-nav" class="navbar">
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">添加用户</h3>
		</div>
		<div class="wrapper">
			<form id="sysform" name="sysform" action="<%=path%>/register/saveuser" method="post">
			    <input type="hidden" name="crmId" value="${crmId}"/>
			    <input type="hidden" name="orgId" value="${orgId}"/>
				<div class="form-group">
					<label class="control-label" for="realname">用户名称<span style="color:red;">*</span>&nbsp;</label>
					<input name="username" id="username" value="" type="text"
						class="form-control" placeholder="用户名称" />
				</div>
				<div class="form-group">
					<label class="control-label" for="realname">登录用户名<span style="color:red;">*</span>&nbsp;</label>
					<input name="crmAccount" id="crmAccount" value="" type="text"
						class="form-control" placeholder="登录用户名" />
				</div>
				<div class="form-group">
					<label class="control-label" for="realname">登录密码<span style="color:red;">*</span>&nbsp;</label>
					<input name="crmPass" id="crmPass" value="" type="password"
						class="form-control" placeholder="登录密码" />
				</div>
				<div class="form-group">
					<label class="control-label" for="realname">邮箱<span style="color:red;">*</span>(邮箱可用来接收信息)&nbsp;</label>
					<input name="email" id="email" value="" type="text"
						class="form-control" placeholder="请输入邮箱地址" />
				</div>
				<div class="form-group">
					<label class="control-label" for="status">部门<span style="color:red;">*</span>&nbsp;</label>
					<div class="form-control select">
						<div class="select-box"></div>
						<select name="department" id="department">
							<c:forEach var="item" items="${departs}">
							   <option value="${item.key}" >${item.value}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label" for="status">汇报对象<span style="color:red;">*</span>&nbsp;</label>
					<div class="form-control select">
						<div class="select-box"></div>
						<select name="reportto" id="reportto">
							<c:forEach var="item" items="${userList}">
							   <option value="${item.userid}" >${item.username}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label" for="status">是否有审批权限？<span style="color:red;">*</span>&nbsp;</label>
					<div class="form-control select">
						<div class="select-box"></div>
						<select name="audit" id="audit">
							  <option value="0" >无</option>
							  <option value="1" >有</option>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label" for="realname">职位</label>
					<input name="title" id="title" value="" type="text"
						class="form-control" placeholder="职位" />
				</div>
				<div>
					<input type="button" onclick="initButton()" class="btn btn-block" value="保存">
				</div>
			</form>
		</div>
	</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
</body>
</html>