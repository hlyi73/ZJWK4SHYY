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
	
	initWorkPlanBtn();
	
});

//初始化工作计划的按钮事件
function initWorkPlanBtn(){
	//全局开启或关闭
	$(".workplan_global_flag").click(function(){
		lovjs_choose('workplan_global_flag_div',{
    		success: function(res){
   				$(":hidden[name=wpglobalflag]").val(res.key);
   				if("Y"==res.key){
   					$(".workplan_personal_flag").css("display","");
   					$(".workplan_personal_type").css("display","");
   					$(".personaltitle").css("display","");
   				}else if("N"==res.key){
   					$(".workplan_personal_flag").css("display","none");
   					$(".workplan_personal_type").css("display","none");
   					$(".personaltitle").css("display","none");
   					$(":hidden[name=wppersonaltype]").val('');
   					$(":hidden[name=wppersonalflag]").val('');
   					$(".workplan_personal_flag .content").html('');
   					$(".workplan_personal_type .content").html('');
   					$(":hidden[name=wpglobaltype]").val('');
   	    			$(".workplan_global_type .content").html('');
   				}
   				$(".workplan_global_flag .content").html(res.val);
    		}
    	});
	});
	
	//全局计划类型
	$(".workplan_global_type").click(function(){
		lovjs_choose('workplan_global_type_div',{
    		success: function(res){
    			$(":hidden[name=wpglobaltype]").val(res.key);
    			$(".workplan_global_type .content").html(res.val);
    		}
    	});
	});
	
	//个人开关
	$(".workplan_personal_flag").click(function(){
		lovjs_choose('workplan_personal_flag_div',{
    		success: function(res){
    			$(":hidden[name=wppersonalflag]").val(res.key);
    			$(".workplan_personal_flag .content").html(res.val);
    			if("N"==res.key){
    				$(":hidden[name=wppersonaltype]").val('');
        			$(".workplan_personal_type .content").html('');
    			}
    		}
    	});
	});
	
	//个人类型
	$(".workplan_personal_type").click(function(){
		lovjs_choose('workplan_personal_type_div',{
    		success: function(res){
    			$(":hidden[name=wppersonaltype]").val(res.key);
    			$(".workplan_personal_type .content").html(res.val);
    		}
    	});
	});
	
	//返回事件
	$(".goback").click(function(){
		$(".basic_info__").css("display","none");
		$(".acclist").css("display","");
		$(".goback").css("display","none");
		$(".title").css("display","");
		$(".savebtn").css("display","none");
	});
	
	//初始化显示div
	var flag = '${flag}';
	if(!flag||"N"==flag){
		$(".workplan_personal_flag").css("display","none");
		$(".workplan_personal_type").css("display","none");
		$(".personaltitle").css("display","none");
	}
	
	//工作计划设置
	$(".workplanconfig").click(function(){
		$(".basic_info__").css("display","");
		$(".acclist").css("display","none");
		$(".goback").css("display","");
		$(".savebtn").css("display","");
		$(".title").css("display","none");
	});
	
	//保存事件
	$(".savebtn").click(function(){
		var flag = false;
		var msg="";
		var wppersonalflag = $(":hidden[name=wppersonalflag]").val();
		var wppersonaltype = $(":hidden[name=wppersonaltype]").val();
		if("1"=="${adminFlag}"){
			var globalflag = $(":hidden[name=wpglobalflag]").val();
			var globaltype = $(":hidden[name=wpglobaltype]").val();
			if(!globalflag){
				flag=true;
				msg = "请设置工作计划开启或关闭状态（公司）！";
			}
			if("Y"==globalflag&&!globaltype){
				flag=true;
				msg = "请设置工作计划类型（公司）！";
			}
		}
		if("Y"==wppersonalflag&&!wppersonaltype){
			flag=true;
			msg = "请设置工作计划类型（个人）！";
		}
		if(flag){
			$(".myvisitMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html(msg); 
  		    $(".myvisitMsgBox").delay(2000).fadeOut();
  		    return;
		}
		$("form[name=workplanvconfigform]").submit();
	});
}

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
	<div style="line-height:30px;margin-top:10px;width: 100%; padding: 5px 10px; background-color: #fff;margin-top:10px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;">
		<span class="title">请选择</span>
		<span style="display:none;" class="goback">返回</span>
		<span style="display:none;float:right" class="savebtn">保存</span>
	</div>
	<!-- 账户相关信息 -->
	<div class="site-recommend-list page-patch acclist" >
		<div class="list-group1 listview">	
		<a href="<%=path%>/sys/detail?orgId=${orgId}">
			<div style="width:100%;background-color:#fff;height:45px;line-height:45px;padding:0px 10px 0px 10px;border-bottom:1px solid #ddd;">
				<div style="float:left;font-size:14px;"><img src="<%=path %>/image/icon_cirle.png">&nbsp;&nbsp;
					账户信息
				</div>
				<div style="float:right;">
					<img src="<%=path%>/image/arrow_normal.png" style="width: 8px;opacity: 0.5;">
				</div>
			</div></a>
			<div style="clear:both;"></div>
			<a href="javascript:void(0);" class="workplanconfig">
			<div style="width:100%;background-color:#fff;height:45px;line-height:45px;padding:0px 10px 0px 10px;border-bottom:1px solid #ddd;">
				<div style="float:left;font-size:14px;"><img src="<%=path %>/image/icon_cirle.png">&nbsp;&nbsp;
					工作计划设置
				</div>
				<div style="float:right;">
					<img src="<%=path%>/image/arrow_normal.png" style="width: 8px;opacity: 0.5;">
				</div>
			</div>
			</a>
			<div style="clear:both;"></div>
		</div>
	</div>
	
	<!-- 全局设置工作计划表单 -->
	<form name="workplanvconfigform" type="post" action="<%=path%>/sys/savewpconfig">
		<input type="hidden" name="wpglobalflag" value="${flag}">
		<input type="hidden" name="wpglobaltype" value="${type}">
		<input type="hidden" name="wppersonalflag" value="${perflag}">
		<input type="hidden" name="wppersonaltype" value="${pertype}">
		<input type="hidden" name="orgid" value="${orgId}">
	</form>
	
	<!-- 工作计划设置 -->
	<div class="basic_info__" style="display:none;">
		<c:if test="${adminFlag eq '1'}">
			<!--作为管理员全局开启或关闭工作计划-->
			<div style="line-height: 40px;margin-left: 10px;">管理员设置</div>
			<div class="workplan_global_flag"
				style="width: 100%; background-color: #fff; border-top: 1px solid #ddd;border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
				是否开启自动创建工作计划（公司）：&nbsp;&nbsp;&nbsp;
				<span class="content">
					<c:if test="${flag eq 'Y'}">
						开启
					</c:if>
					<c:if test="${flag eq 'N'}">
						关闭
					</c:if>
				</span>
				<span style="float: right;">
					<img src="<%=path%>/image/arrow_normal.png" width="8px">
				</span>
			</div>
			<!--作为管理员设置全局工作计划的类型-->
			<div class="workplan_global_type"
				style="width: 100%; background-color: #fff; border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; line-height: 30px;">
				工作计划类型（公司）：&nbsp;&nbsp;&nbsp;
				<span class="content">
					<c:if test="${type eq 'week'}">
						周计划
					</c:if>
					<c:if test="${type eq 'day'}">
						日计划
					</c:if>
				</span>
				<span style="float: right;">
					<img src="<%=path%>/image/arrow_normal.png" width="8px">
				</span>
			</div>
		</c:if>
		<!--作为普通用户开启或关闭工作计划-->
		<div class="personaltitle" style="line-height: 40px;margin-left: 10px;">个人设置</div>
		<div class="workplan_personal_flag"
			style="width: 100%; background-color: #fff; border-top: 1px solid #ddd;border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
			是否开启自动创建工作计划（个人）：&nbsp;&nbsp;&nbsp;
			<span class="content">
				<c:if test="${perflag eq 'Y'}">
						开启
					</c:if>
					<c:if test="${perflag eq 'N'}">
						关闭
					</c:if>
			</span>
			<span style="float: right;">
				<img src="<%=path%>/image/arrow_normal.png" width="8px">
			</span>
		</div>
		<!--作为普通用户设置工作计划的类型-->
		<div class="workplan_personal_type"
			style="width: 100%; background-color: #fff; border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; line-height: 30px;">
			工作计划类型（个人）：&nbsp;&nbsp;&nbsp;
			<span class="content">
				<c:if test="${pertype eq 'week'}">
					周计划
				</c:if>
				<c:if test="${pertype eq 'day'}">
					日计划
				</c:if>
			</span>
			<span style="float: right;">
				<img src="<%=path%>/image/arrow_normal.png" width="8px">
			</span>
		</div>
	</div>
	<div class="g-mask none">&nbsp;</div>
	<div class="myvisitMsgBox" style="display:none;position:fixed;top:40%;opacity:1;left:50%;margin-left:-90px;">&nbsp;</div>
<!-- lov选择页面 -->
<jsp:include page="/common/rela/lov.jsp"></jsp:include>
<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>