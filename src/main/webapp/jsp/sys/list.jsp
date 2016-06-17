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
<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script>
function unbinding(orgId){
	if(confirm("确认要解除绑定吗？")){
		window.location.replace("<%=path%>/sys/cancel?orgId="+orgId);
	}
}

$(function(){
	$(".menu-group").click(function() {
		if ($(".dropdown-menu-group").hasClass("none")) {
			$(".dropdown-menu-group").removeClass("none");
			$(".g-mask").removeClass("none");
		} else {
			$(".dropdown-menu-group").addClass("none");
			$(".g-mask").addClass("none");
		} 
	});
	
	$(".g-mask").click(function() {
		$(".dropdown-menu-group").addClass("none");
		$(".g-mask").addClass("none");
		//隐藏按钮
		$(".menu-group").css("display","");
	});
});
</script>
<style type="text/css">
.dropdown-menu-group {
	font-size: 14px;
	position: absolute;
	width: 150px;
	right: 2px;
	left: auto;
	top: 45px;
	text-align: left;
	z-index: 999;
	background-color: RGB(75, 192, 171);
	-webkit-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-moz-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-ms-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-o-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
}

.dropdown-menu-group li {
	white-space: nowrap;
	margin-left: 10px;
	font-weight: 900;
	word-wrap: normal;
	border-bottom: 1px solid #365a7e;
}

.dropdown-menu-group li a {
	color: #fff
}
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
<body style="font-size:14px;">
	<%--<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">帐号管理</h3>
		<div class="act-secondary menu-group">
			<a href="javascript:void(0)"> <img
				src="<%=path%>/image/func_menu.png" width="36px;">
			</a>
		</div>
		<div class="dropdown-menu-group none">
			<li><a href="<%=path%>/operMobile/get"
				style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">
					<i class="iconPost f21 cf"></i> 添加绑定
			</a></li>
			<c:if test="${fn:length(orgList) > 0 }">	
			<li><a href="<%=path %>/sys/updpwd"
				style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">
					<i class="iconPost f21 cf"></i> 修改密码
			</a></li>
			</c:if>
		</div>
	</div>
	 --%>
	<a href="<%=path%>/operMobile/get">
		<div class="zjwk_fg_nav">
			绑定到企业版账户
		</div>
	</a>
	<div style="clear:both;"></div>
	
	
	<div style="line-height:30px;margin-top:10px;width: 100%; padding: 5px 10px; background-color: #fff;margin-top:10px;border-bottom:1px solid #ddd;">
		账户
	</div>
	<div class="site-recommend-list page-patch acclist">
		<div class="list-group1 listview">	
			<a href="<%=path%>/sys/detail?orgId=Default Organization">
			<div style="width:100%;background-color:#fff;height:45px;line-height:45px;padding:0px 10px 0px 10px;border-bottom:1px solid #ddd;">
							<div style="float:left;font-size:14px;"><img src="<%=path %>/image/icon_cirle.png">&nbsp;&nbsp;
						私有账户
						</div>
						<div style="float:right;">
							<c:if test="${DefaultOrg eq '' || empty(DefaultOrg) || DefaultOrg eq 'Default Organization'}"><span style="color:red;">默认</span>&nbsp;&nbsp;&nbsp; </c:if>
							<img src="<%=path%>/image/arrow_normal.png" style="width: 8px;opacity: 0.5;">
						</div>
			</div></a>
			<div style="clear:both;"></div>
			<c:if test="${fn:length(orgList) > 0 }">	
				<c:forEach items="${orgList }" var="org">
				<a href="<%=path%>/sys/chooselist?orgId=${org.orgId}">
						<div style="width:100%;background-color:#fff;height:45px;line-height:45px;padding:0px 10px 0px 10px;border-bottom:1px solid #ddd;">
						<div style="float:left;font-size:14px;"><img src="<%=path %>/image/icon_cirle.png">&nbsp;&nbsp;
							${org.orgName}
						</div>
						<div style="float:right;">
							<c:if test="${DefaultOrg ne '' && !empty(DefaultOrg) && DefaultOrg eq org.orgId}"><span style="color:red;">默认</span>&nbsp;&nbsp;&nbsp; </c:if>
							<img src="<%=path%>/image/arrow_normal.png" style="width: 8px;opacity: 0.5;">
						</div>
						</div>
						</a>
						<div style="clear:both;"></div>
				</c:forEach>
				
				<!-- 
				<c:forEach items="${auditOrgList }" var="org">
						<div style="width:100%;background-color:#fff;height:45px;line-height:45px;padding:0px 10px 0px 10px;border-bottom:1px solid #ddd;">
						<div style="float:left;font-size:14px;"><img src="<%=path %>/image/icon_cirle.png">&nbsp;&nbsp;
							<a href="<%=path%>/register/detail?orgId=${org.org_id}">${org.org_name}</a>
						</div>
						<div style="float:right;">
							<c:if test="${org.enabledflag eq 'apply'}">
								申请中
							</c:if>
						</div>
						</div>
						<div style="clear:both;"></div>
				</c:forEach>
				 -->
			</c:if>		
			
			
			<div class="wrapper" style="margin-top: 30px;">
				<div class="button-ctrl">
					<fieldset class="">
						<%--<div class="ui-block-a" style="width: 100%;padding:0 3em;">
							<a class="btn btn-success btn-block" href="<%=path%>/operMobile/get"
									style="background-color: #49af53;font-size: 14px;margin-left:10px;margin-right:10px;"> 添加绑定 </a>
						</div>
						
						<c:if test="${applyflag eq 'NO'}">
						<div class="ui-block-a">
							<a href="javascript:void(0)" onclick="alert('1个人只能申请一次，您不能再申请了！');" class="btn btn-block btn-default " 
							    style="font-size: 14px;margin-left:10px;margin-right:10px;">注册企业</a>
						</div>
						</c:if>
						<c:if test="${applyflag ne 'NO'}">
						<div class="ui-block-a">
							<a href="<%=path%>/register/get" class="btn btn-block " 
							    style="font-size: 14px;margin-left:10px;background-color: #49af53;margin-right:10px;">注册企业</a>
						</div>
						</c:if>
						 --%>
					</fieldset>
			</div>
		</div>
	</div>
	<div class="g-mask none">&nbsp;</div>
<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>