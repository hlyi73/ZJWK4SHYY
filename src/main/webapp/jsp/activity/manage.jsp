<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>

<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.3.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>

<script type="text/javascript">
$(function (){	
	//新增子任务
	$(".addsubtask").click(function(){
		var req = {
			relaId:"${act.id}",
			relaType:'Activity',
			orgId:'${act.orgId}'
		};
		schedulejs_choose(req,{
    		success: function(res){
    			if($("._nosubtaskdata")){
    				$("._nosubtaskdata").remove();
    			}
    			var val = '<div style="border-bottom: 1px solid rgba(238, 238, 238, 0.56);"class="task_'+res.rowid+'">'
    					+ '<div style="float:left;width:60px;text-align:center;line-height:30px;padding:3px 10px;">'+res.startdate.substr(5,5)+'</div>'
						+ '<div style="margin-left:60px;text-align:left;line-height:30px;padding:3px;">'
					    + '<a href="<%=path%>/schedule/detail?orgId=${sd.orgId}&schetype=task&rowId='+res.rowid+'">'+res.title+'</a>&nbsp;('+res.statusname+')'
						+ '</div>'
						+ '<div style="float:right;margin-top: -32px;padding-right: 15px;" taskid="'+res.rowid+'" accntid="${rowId}" class="rela_work_task"><img src="<%=path %>/image/del_icon.png" width="20px"></div>'
						+ '</div>';
				$(".subtasklist").before(val);
				initDel();
    		}
    	});
	});
	
	$(".act_baseinfo").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage_basic?id=${act.id}");
	});
	$(".act_yaoyue").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage_invit?id=${act.id}");
	});
	$(".act_analytics").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage_analytics?id=${act.id}");
	});
});  

function initDel(){
	//关系
	$(".rela_work_task").click(function(){
		if(confirm("确定要删除该任务吗？")){
			var taskid = $(this).attr("taskid");
			var accntid = $(this).attr("accntid");
			
			//删除
			if(taskid && accntid){
				var dataObj = [];
				dataObj.push({name:"rowid",value:taskid});
				dataObj.push({name:"optype",value:'del'});
				$.ajax({
				    type: 'post',
				      url: '<%=path%>/schedule/delSchedule',
				      data: dataObj,
				      dataType: 'text',
				      success: function(data){
				    	  if(data && data == 'success'){
				    		  $(".myMsgBox").css("display","").html("删除成功!");
				    		  $(".myMsgBox").delay(2000).fadeOut();
				    		  $(".task_"+taskid).remove();
				    		  if($(".rela_work_task").size()==0){
				    			  $(".subtasklist").html('<div style="width:100%;text-align:center;line-height:35px;color:#999;font-size:14px;" class="_nosubtaskdata">无计划任务</div>');
				    		  }
				    	  }else{
				    		  $(".myMsgBox").css("display","").html("删除失败!");
				    		  $(".myMsgBox").delay(2000).fadeOut();
				    	  }
				      }
				});
			}
		}
	});
}

function showTask(){
	$("#taskdiv_").css('display','');
	$("#task-create").css('display','none');
	$("#flootermenu").css('display','none');
	$("._menu").css('display','none');
}

function goback(){
	$("#taskdiv_").css('display','none');
	$("#task-create").css('display','');
	$("#flootermenu").css('display','');
	$("._menu").css('display','');
}

</script>
<style>
.tabselected {
	border-bottom: 5px solid #078E46;
	color: #00D1DA;
}
</style>
</head>
<body>
	<div id="task-create" class="font-size:14px;">
		<div id="site-nav" class="menu_activity zjwk_fg_nav">
		    <a href="javascript:void(0)" class="tabselected act_team" style="padding:5px 8px;">协同</a>
		    <a href="javascript:void(0)" class="act_baseinfo" style="padding:5px 8px;">基本信息</a>
		    <a href="javascript:void(0)" class="act_yaoyue" style="padding:5px 8px;">邀约</a>
		    <a href="javascript:void(0)" class="act_analytics" style="padding:5px 8px;">分析</a>
		</div>
		
		<div style="width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px;">
			<div style="text-align:center;font-size:16px;min-height:30px;margin-top:8px;border-bottom:2px solid #ddd;">${act.title}</div>
			<div style="">
				<div style="padding-left:10px;line-height:25px;font-size:14px;">
					<span>会议时间：${act.start_date} ~ ${act.act_end_date}</span>
				</div>
				<c:if test="${act.isregist eq 'Y' }">
					<div style="padding-left:10px;line-height:25px;font-size:14px;">
						<span>报名截止：${act.end_date}</span>
					</div>
				</c:if>
				<c:if test="${act.charge_type ne '' && !empty(act.charge_type)}">
					<div style="padding-left:10px;line-height:25px;font-size:14px;">
						<span>
							费&nbsp;&nbsp;用：${charge_type_value} 
							<c:if test="${act.charge_type eq 'other' && act.expense ne '' && !empty(act.expense)}">
								(${act.expense}元/人)
							</c:if>
						</span>
					</div>
				</c:if>
				<c:if test="${act.limit_number ne '' && !empty(act.limit_number)}">
					<div style="padding-left:10px;line-height:25px;font-size:14px;"><span>人&nbsp;&nbsp;数：${act.limit_number }人</span></div>
				</c:if>
				<!-- 联系人 -->
				<c:if test="${act.contactlistval ne '' && !empty(act.contactlistval)}">
					<div style="padding-left:10px;line-height:25px;font-size:14px;"><span>联系人：<a href="javascript:void(0)">${act.contactlistval }</a></span></div>
				</c:if>
				<!-- 主办 -->
				<c:if test="${act.customerlistval ne '' && !empty(act.customerlistval)}">
					<div style="padding-left:10px;line-height:25px;font-size:14px;"><span>主办：<a href="javascript:void(0)">${act.customerlistval }</a></span></div>
				</c:if>
				<div style="float:right;line-height:20px;font-size:16px;padding:5px;margin-top: -30px;color: blue;cursor: pointer;">
					 <a href="<%=path%>/zjwkactivity/detail?id=${act.id}&sourceid=${sourceid}">预览</a>
				</div>
			</div>
		</div>
		<!-- 相关 -->
		<div style="width:100%;background-color:#fff;border-bottom:1px solid #ddd;padding:5px;">
			<div style="line-height:35px;font-size:14px;padding:2px 10px;border-bottom:1px solid #ddd;">
				负责人：${act.createName}
			</div>
			<div class="uptShow" style="padding-left:5px;padding-right:5px;">
				<jsp:include page="/common/teamlist.jsp">
					<jsp:param value="Activity" name="relaModule"/>
					<jsp:param value="${act.id}" name="relaId"/>
					<jsp:param value="${act.crmId }" name="crmId"/>
					<jsp:param value="${act.title }" name="relaName"/>
					<jsp:param value="${authority}" name="assFlg"/>
					<jsp:param value="${act.orgId}" name="orgId"/>
				</jsp:include>
			</div>
			<div style="cursor:pointer;line-height:35px;font-size:14px;padding:2px 10px;" onclick="showTask();">
				相关任务
				<div style="float:right;">${fn:length(taskList)}&nbsp;&nbsp; <img src="<%=path %>/image/arrow_normal.png" width="8px"></div>
			</div>
		</div>
		
		<!-- 消息显示区域 -->
		<div style="margin-top:5px;">
			<jsp:include page="/common/msglist.jsp">
				<jsp:param value="ManageActivity" name="relaModule"/>
				<jsp:param value="${act.id}" name="relaId"/>
			</jsp:include>
		</div>
	</div>
	
	<!-- 底部操作区域 -->
	<div class="flooter" id="flootermenu" style="z-index: 99999; background: #FFF; border-top: 1px solid #ddd; opacity: 1;">
		<!--发送消息的区域  -->
		<jsp:include page="/common/sendmsg.jsp">
			<jsp:param value="ManageActivity" name="relaModule"/>
			<jsp:param value="${act.id}" name="relaId"/>
			<jsp:param value="${act.title}" name="relaName"/>
			<jsp:param value="true" name="newFlag"/>
		</jsp:include>
	</div>
	
	<!-- 相关任务 -->
	<div id="taskdiv_" style="display:none;width:100%;padding:0px 0px 5px 0px;background-color:#fff;height:100%;font-size:14px;border-bottom: 1px solid #ddd;border-top: 1px solid #ddd;">
		<div style="line-height:35px;font-size:14px;padding:2px 10px;background-color:rgb(177, 205, 255);text-align:center;color:#fff;line-height:50px;">
			<div style="float:left;padding:0px 5px;cursor:pointer;" onclick="goback()">返回</div> 
			<span style="font-size:16px">相关任务</span>
			<div class="addsubtask" style="cursor: pointer;float:right;padding:0px 10px;font-size:20px;font-weight:bold;">+</div>
		</div>
		<div style="clear:both;"></div>
		<div style="line-height:30px;">
			<div style="font-size:14px;color:#666;" class="subtasklist">
				<c:if test="${fn:length(taskList) >0 }">
					<c:forEach var="task" items="${taskList}">
						<div class="task_${task.rowid }" style="border-bottom: 1px solid rgba(238, 238, 238, 0.56);">
							<div style="float:left;width:60px;text-align:center;line-height:30px;padding:3px 10px;">${fn:substring(task.startdate, 5, 10)}</div>
						    <div style="margin-left:60px;text-align:left;line-height:30px;padding:3px;">
					               <a href="<%=path%>/schedule/detail?orgId=${act.orgId}&schetype=task&rowId=${task.rowid}">${task.title }</a>&nbsp;(${task.statusname})
							</div>
							<c:if test="${authority eq 'Y'}">
								<div style="float:right;margin-top: -32px;padding-right: 15px;" taskid="${task.rowid}" accntid="${rowId}" class="rela_work_task"><img src="<%=path %>/image/del_icon.png" width="20px"></div>
							</c:if>
						</div>
					</c:forEach>
				</c:if>
				<c:if test="${fn:length(taskList) ==0 }">
					<div style="width:100%;text-align:center;line-height:35px;color:#999;font-size:14px;" class="_nosubtaskdata">无计划任务</div>
				</c:if>
			</div>
		</div>
	</div>
	<!-- 增加任务 -->
	<jsp:include page="/common/add/addtask.jsp"></jsp:include>
	<%--团队成员列表 --%>
	<jsp:include page="/common/teamform.jsp"></jsp:include>
	
	<%--消息@符号处理 --%>
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	<jsp:include page="/common/menu.jsp"></jsp:include>
	</br></br></br></br></br></br>
</body>
</html>