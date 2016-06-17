<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String lovpath = request.getContextPath();
%>
<script>
$(function(){
	$(".lov_list_item").click(function(){
		var key = $(this).attr("key");
		var val = $(this).html();
		var res = {
		 	key: key,
		 	val: val
		};
		if(rFunction && rFunction.success){
			rFunction.success(res);
		}
		hide_lovlist();
		rFunction = null;
	});
	
	$(".___cancel___").click(function(){
		hide_lovlist();
		rFunction = null;
	});
});

var rFunction = null;

function lovjs_choose(lov_type,setting){
	if(!setting){
		setting = {};
	}
	rFunction = setting;
	
	$("." + lov_type).removeClass("none");
	$("#lov_div").removeClass("none");
}

function hide_lovlist(){
	$("#lov_div").removeClass("none").addClass("none");
	$(".lov_list").removeClass("none").addClass("none");
}
</script>

<style>
.none{
	display:none;
}

.lov_list_item{
	width:100%;
	line-height: 35px;
	border-bottom: 1px solid #ddd;
	padding-left: 10px;
	background-color:#fff;
}

#lov_div{
	position: fixed;
	width: 100%;
	z-index: 999999;
	background-color: #FAFAFA;
	top: 0px;
	height: 100%;
	font-size:14px;
	overflow-y: auto;
	max-width: 640px;
}

</style>

<div id="lov_div" class="none">
	<!-- <div id="site-nav" class="navbar">
		<div class="cancel">取消</div>
		<h3 style="padding-right:45px">请选择</h3>
	</div> -->
	
	<div class="zjwk_fg_nav">
		<a href="javascript:void(0)" class="___cancel___" style="padding:5px 8px;">取消</a>
	</div>
	
	<%--任务状态 --%>
	<div style="width:100%;" class="lov_list statusDom none">
		<c:forEach items="${statusDom}" var="item">
			<div class="lov_list_item" key="${item.key}">${item.value}</div>
		</c:forEach>
	</div>
	
	<%--账户 --%>
	<div style="width:100%;" class="lov_list sysAccount none">
		<c:forEach items="${sysAccount}" var="item">
			<div class="lov_list_item" key="${item.key}">${item.value}</div>
		</c:forEach>
	</div>
	
	<%--入群验证 --%>
	<div style="width:100%;" class="lov_list discuGroupValidate none">
		<div class="lov_list_item" key="none">不验证</div>
		<div class="lov_list_item" key="admin">管理员验证</div>
		<div class="lov_list_item none" key="question">问题验证</div>
	</div>
	
	<%--群发消息审核--%>
	<div style="width:100%;" class="lov_list batchSendMsgAudit none">
		<div class="lov_list_item" key="no">不审核</div>
		<div class="lov_list_item" key="yes">管理员审核</div>
	</div>
	
	<%--销售阶段 --%>
	<div style="width:100%;" class="lov_list sales_stage none">
		<c:forEach items="${sales_stage}" var="item">
			<div class="lov_list_item" key="${item.key}">${item.value}</div>
		</c:forEach>
	</div>
	<%--商机来源 --%>
	<div style="width:100%;" class="lov_list lead_source none">
		<c:forEach items="${lead_source}" var="item">
			<div class="lov_list_item" key="${item.key}">${item.value}</div>
		</c:forEach>
	</div>
	<div style="width:100%;" class="lov_list lov_activity_isregist none">
		<c:forEach items="${lov_activity_isregist}" var="item">
			<div class="lov_list_item" key="${item.key}">${item.value}</div>
		</c:forEach>
	</div>
	<div style="width:100%;" class="lov_list lov_activity_displaymenber none">
		<c:forEach items="${lov_activity_displaymenber}" var="item">
			<div class="lov_list_item" key="${item.key}">${item.value}</div>
		</c:forEach>
	</div>
	<div style="width:100%;" class="lov_list lov_activity_chargetype none">
		<c:forEach items="${lov_charge_type}" var="item">
			<div class="lov_list_item" key="${item.key}">${item.value}</div>
		</c:forEach>
	</div>
	<%--会议活动推荐--%>
	<div style="width:100%;" class="lov_list activiey_tuijian none">
		<div class="lov_list_item" key="open">允许推荐</div>
		<div class="lov_list_item" key="private">不允许推荐</div>
	</div>
	<%--会议资料--%>
	<div style="width:100%;" class="lov_list act_meet_attend none">
		<div class="lov_list_item" key="0">马上公开</div>
		<div class="lov_list_item" key="1">活动结束后公开</div>
	</div>
	<%--工作计划全局开启或关闭--%>
	<div style="width:100%;" class="lov_list workplan_global_flag_div none">
		<div class="lov_list_item" key="Y">开启</div>
		<div class="lov_list_item" key="N">关闭</div>
	</div>
	<%--工作计划全局类型设置--%>
	<div style="width:100%;" class="lov_list workplan_global_type_div none">
		<div class="lov_list_item" key="day">日计划</div>
		<div class="lov_list_item" key="week">周计划</div>
	</div>
	<%--工作计划个人开启或关闭--%>
	<div style="width:100%;" class="lov_list workplan_personal_flag_div none">
		<div class="lov_list_item" key="Y">开启</div>
		<div class="lov_list_item" key="N">关闭</div>
	</div>
	<%--工作计划个人类型设置--%>
	<div style="width:100%;" class="lov_list workplan_personal_type_div none">
		<div class="lov_list_item" key="day">日计划</div>
		<div class="lov_list_item" key="week">周计划</div>
	</div>
	<div style="margin-bottom:20px"></div>
</div>