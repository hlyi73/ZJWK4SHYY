<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String followPath = request.getContextPath();
	String parenttype = request.getParameter("parenttype");
	String parentid = request.getParameter("parentid");
	String crmId = request.getParameter("crmId");
	String orgId = request.getParameter("orgId");
	request.setAttribute("parentid",parentid);
	request.setAttribute("crmId",crmId);
	request.setAttribute("parenttype",parenttype);
	request.setAttribute("orgId",orgId);
	
	String newFlag = request.getParameter("newFlag");
	request.setAttribute("newFlag", newFlag);
%>
<style>
.total_div{
	float:left;
	border-right:1px solid #ddd;
	width:25%;
	height:50px;
	line-height:25px;
	text-align:center;
	font-size:14px;
	background-color:#fff;
	cursor:pointer;
}
</style>
<script>
var opptynum = 0,mxquotenum=0,contactnum =0,tasknum=0,partnernum =0,compnum =0,docnum=0,quotenum=0,plannum=0,recenum=0,coutsnum=0;
$(function(){
	var totalnum = "${fn:length(auditList)}";
	if(!totalnum || totalnum ==0){
		return;
	}
	
	//如果是回款计划
	var parenttype = "${parenttype}";
	if(parenttype == 'Plan'){
		return;
	}
		
	$(".audit_list_div").find("dt").each(function(){
		var audittype = $(this).attr('audittype');
		if(audittype.indexOf("task")!= -1){
			tasknum += 1;
		}else if(audittype.indexOf("oppty")!= -1){
			opptynum += 1;
		}else if(audittype == 'contact'){
			contactnum += 1;
		}else if(audittype == 'plan'){
			plannum += 1;
		}else if(audittype == 'receivable'){
			recenum += 1;
		}else if(audittype == 'q_item'){
			mxquotenum += 1;
		}else if(audittype == 'account'){
			coutsnum += 1;
		}
	});
	
	if ('${newFlag}' == 'true')
	{
		$(".imgTitle").html("跟进历史");
		$(".imgTitle").find("img").attr("src","");
	}
	else
	{
		$(".follow_total_div").append('<div class="total_div total_all"><div>全部</div><div>'+totalnum+'</div></div>');
		
		if(parenttype == 'Accounts'){
			$(".follow_total_div").append('<div class="total_div total_opportunities"><div>机会</div><div>'+opptynum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_contact"><div>联系人</div><div>'+contactnum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_task"><div>任务</div><div>'+tasknum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_doc"><div>资料</div><div>'+docnum+'</div></div>');
			$(".total_div").css("width","20%");
		}else if(parenttype == 'Opportunities'){
			$(".follow_total_div").append('<div class="total_div total_contact"><div>联系人</div><div>'+contactnum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_task"><div>任务</div><div>'+tasknum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_quote"><div>报价</div><div>'+quotenum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_doc"><div>资料</div><div>'+docnum+'</div></div>');
			$(".total_div").css("width","20%");
		}else if(parenttype == 'Activity'){
			$(".follow_total_div").append('<div class="total_div total_account"><div>客户</div><div>'+coutsnum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_opportunities"><div>机会</div><div>'+opptynum+'</div></div>');
	/* 		$(".follow_total_div").append('<div class="total_div total_contact"><div>联系人</div><div>'+contactnum+'</div></div>'); */
			$(".follow_total_div").append('<div class="total_div total_task"><div>任务</div><div>'+tasknum+'</div></div>');
	/* 		$(".follow_total_div").append('<div class="total_div total_quote"><div>报价</div><div>'+quotenum+'</div></div>'); */
			$(".total_div").css("width","25%");
		}else if(parenttype == 'Contacts'){
			$(".follow_total_div").append('<div class="total_div total_task"><div>任务</div><div>'+tasknum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_doc"><div>资料</div><div>'+docnum+'</div></div>');
			$(".total_div").css("width","33.333333%");
		}else if(parenttype == 'Contracts'){
			$(".follow_total_div").append('<div class="total_div total_plan"><div>计划</div><div>'+plannum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_rece"><div>回款</div><div>'+recenum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_task"><div>任务</div><div>'+tasknum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_doc"><div>资料</div><div>'+docnum+'</div></div>');
			$(".total_div").css("width","20%");
		}else if(parenttype == 'Quote'){
			$(".follow_total_div").append('<div class="total_div total_task"><div>任务</div><div>'+tasknum+'</div></div>');
			$(".follow_total_div").append('<div class="total_div total_mxquote"><div>明细</div><div>'+mxquotenum+'</div></div>');
			$(".total_div").css("width","33.333333%");
		}	}

	//
	$(".follow_total_div").css("border-top","1px solid #ddd");
	$(".follow_total_div").css("border-left","1px solid #ddd");
	selectTag();
});

function selectTag(){
   //所有
   $(".total_all").click(function(){
	   $("#more_div").css("display","");
	   $("#more_list").css("display","none");
	   $(".audit_list_div").find("dt").each(function(){
		   $(this).css("display","");
	  	});
	  	$(".audit_list_div").find("dd").each(function(){
	  		$(this).css("display","");
	  	});
   });
   //商机
   $(".total_opportunities").click(function(){
	   $("#more_div").css("display","none");
	   $("#more_list").css("display","");
	  	$(".audit_list_div").find("dt").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("oppty")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
	  	$(".audit_list_div").find("dd").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("oppty")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
   });
   //联系人
   $(".total_contact").click(function(){
	   $("#more_div").css("display","none");
	   $("#more_list").css("display","");
	  	$(".audit_list_div").find("dt").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("contact")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
	  	$(".audit_list_div").find("dd").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("contact")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
   });
   //任务
   $(".total_task").click(function(){
	   $("#more_div").css("display","none");
	   $("#more_list").css("display","");
	  	$(".audit_list_div").find("dt").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("task")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
	  	$(".audit_list_div").find("dd").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("task")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
   });
   //报价
   $(".total_quote").click(function(){
	   $("#more_div").css("display","none");
	   $("#more_list").css("display","");
	  	$(".audit_list_div").find("dt").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("quote")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
	  	$(".audit_list_div").find("dd").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("quote")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
   });
   //客户
   $(".total_account").click(function(){
	   $("#more_div").css("display","none");
	   $("#more_list").css("display","");
	  	$(".audit_list_div").find("dt").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("account")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
	  	$(".audit_list_div").find("dd").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("account")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
   });
   //资料
   $(".total_doc").click(function(){
	   $("#more_div").css("display","none");
	   $("#more_list").css("display","");
	  	$(".audit_list_div").find("dt").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("document")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
	  	$(".audit_list_div").find("dd").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("document")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
   });
   //计划
   $(".total_plan").click(function(){
	   $("#more_div").css("display","none");
	   $("#more_list").css("display","");
	  	$(".audit_list_div").find("dt").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("plan")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
	  	$(".audit_list_div").find("dd").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("plan")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
   });
   //回款
   $(".total_rece").click(function(){
	   $("#more_div").css("display","none");
	   $("#more_list").css("display","");
	  	$(".audit_list_div").find("dt").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("receivable")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
	  	$(".audit_list_div").find("dd").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("receivable")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
   });
   //报价明细
   $(".total_mxquote").click(function(){
	   $("#more_div").css("display","none");
	   $("#more_list").css("display","");
	  	$(".audit_list_div").find("dt").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("q_item")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
	  	$(".audit_list_div").find("dd").each(function(){
	  		var audittype = $(this).attr('audittype');
			if(audittype.indexOf("q_item")!= -1){
				$(this).css("display","");
			}else{
				$(this).css("display","none");
			}
	  	});
   });
}
</script>
<c:if test="${fn:length(auditList) > 0 }">
				<div style="padding-left:5px;padding-right:5px;">
					<div style="line-height:50px;font-size:16px;font-weight:bold;padding-left:8px;" class="imgTitle">
							<img src="<%=followPath%>/image/title-feed.png" width="20px" style="margin-bottom:3px;opacity:0.3;">&nbsp;跟进历史
					</div>
					<div style="width:100%;max-height:5px;" class="follow_total_div">
						 
					</div>
					<div id="div_audit" class="container hy bgcw conBox _border_ audit_list_div">
						<dl class="hyrc" id="tc01" >
							<c:forEach items="${auditList }" var="audit" varStatus="stat">
								<!-- 序号等于5的情况 -->
								<c:if test="${stat.index == 5}">
									<div id="more_div" style="width: 100%; text-align: center;">
										<div style="clear: both"></div>
										<div style="padding: 8px; font-size: 14px;text-align: center;">
											<a href="javascript:void(0)"
												onclick='$("#more_div").css("display","none");$("#more_list").css("display","");'>查看全部&nbsp;↓</a>
										</div>
									</div>
									<div id="more_list" style="display: none;">
								</c:if>
								
								<!-- 序号大于5的情况 -->
								<c:if test="${stat.index >= 5 }">
									<dt style="line-height: 34px;" audittype="${audit.optype}">
										${audit.opdate}<span style="top: 16px;"></span>
									</dt>
									<dd style="width: 70%;cursor: pointer" audittype="${audit.optype}">
										<div style="border: 1px solid #ededed;border-radius: 3px;background: #f8f8f8;line-height: 24px;text-indent: 0;padding: 4px 4px 4px 6px;">
											<ul class="">
									     			<span style="color: #3e6790"> ${audit.opname}</span>
											<c:if test="${audit.optype eq 'accnt_accnttype' }">
													修改客户类型，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'plan_rece_amount'}">
													修改收款金额，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'plan_rece_date' }">
													修改收款日期，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'receiv_type' }">
													修改收款类型，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'ticket_status' }">
													修改开票状态，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'q_status' }">
													修改报价状态，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'q_discount' }">
													修改报价折扣，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'q_effectdate' }">
													修改报价有效期，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'q_amount' }">
													修改报价金额，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'q_date' }">
													修改报价日期，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'q_item' }">
													创建了一个报价明细：
													<a href="<%=followPath %>/quote/mxdetail?crmId=${crmId}openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }&parentId=${parentid}">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'delitem' }">
													删除报价明细：${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'contact'}">
													关联了一个联系人：
													<a href="<%=followPath %>/contact/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
													<c:if test="${audit.opid eq crmId}">
														<a href="<%=followPath%>/contact/del?crmId=${crmId}&openId=${openId}&publicId=${publicId}&parentId=${parentid}&parentType=${parenttype}&rowid=${audit.parentid}" style="padding: 2px 5px 2px 5px;background-color: #FCE0E0;border-radius: 8px">删除关系</a>
													</c:if>
											</c:if>
											<c:if test="${audit.optype eq 'account'}">
													创建了一个客户：
													<a href="<%=followPath %>/customer/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'tasks'}">
													创建了一个任务：
													<a href="<%=followPath %>/schedule/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'plan'}">
													创建了一个回款计划：
													<a href="<%=followPath %>/gathering/detail?crmId=${crmId}&gatheringtype=plan&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'receivable'}">
													创建了一个回款明细：
													<a href="<%=followPath %>/gathering/detail?crmId=${crmId}&gatheringtype=detail&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'oppty'}">
													创建了一个商机：<a href="<%=followPath %>/oppty/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'assign'}">
													修改责任人：${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_amount'}">
													修改生意金额：${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_closed'}">
													修改生意关闭日期：${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_event'}">
													添加强制性事件：${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_value'}">
													添加价值主张：${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_stage'}">
													修改生意阶段：${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_competitor'}">
													调整竞争策略：${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_rival'}">
													添加竞争对手：<a href="<%=followPath %>/customer/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'oppty_partner'}">
													添加合作伙伴：<a href="<%=followPath %>/customer/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'share'}">
													添加团队成员：${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'sharefriends'}">
													添加指尖好友：<a href="<%=followPath%>/businesscard/detail?partyId=${audit.opid}">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'cancel_share'}">
													删除团队成员：${audit.aftervalue}
											</c:if>
											</ul>
										</div>
									</dd>
								</c:if>
								<!-- 序号小于5的情况 -->
								<c:if test="${stat.index < 5 }">
									<dt style="line-height: 34px;" audittype="${audit.optype}">
										${audit.opdate}<span style="top: 16px;"></span>
									</dt>
									<dd style="width: 70%;cursor: pointer" audittype="${audit.optype}" >
										<div style="border: 1px solid #ededed;border-radius: 3px;background: #f8f8f8;line-height: 24px;text-indent: 0;padding: 4px 4px 4px 6px;">
										   	<ul class="">
									     			<span style="color: #3e6790"> ${audit.opname}</span>
											<c:if test="${audit.optype eq 'accnt_accnttype' }">
													修改客户类型，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'plan_rece_amount'}">
													修改收款金额，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'plan_rece_date' }">
													修改收款日期，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'receiv_type' }">
													修改收款类型，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'ticket_status' }">
													修改开票状态，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'contact'}">
													关联了一个联系人：
													<a href="<%=followPath %>/contact/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
													<c:if test="${audit.opid eq crmId}">
														<a href="<%=followPath%>/contact/del?crmId=${crmId}&openId=${openId}&publicId=${publicId}&parentId=${parentid}&parentType=${parenttype}&rowid=${audit.parentid}" style="padding: 2px 5px 2px 5px;background-color: #FCE0E0;border-radius: 8px">删除关系</a>
													</c:if>
											</c:if>
											<c:if test="${audit.optype eq 'account'}">
													创建了一个客户：
													<a href="<%=followPath %>/customer/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'tasks'}">
													创建了一个任务：
													<a href="<%=followPath %>/schedule/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'plan'}">
													创建了一个回款计划：
													<a href="<%=followPath %>/gathering/detail?crmId=${crmId}&gatheringtype=plan&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'receivable'}">
													创建了一个回款明细：
													<a href="<%=followPath %>/gathering/detail?crmId=${crmId}&gatheringtype=detail&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'oppty'}">
													创建了一个商机：<a href="<%=followPath %>/oppty/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'assign'}">
													修改责任人：${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_amount'}">
													修改生意金额：${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_closed'}">
													修改生意关闭日期：${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_event'}">
													添加强制性事件：${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_value'}">
													添加价值主张：${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_stage'}">
													修改生意阶段：${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_competitor'}">
													调整竞争策略：${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'oppty_rival'}">
													添加竞争对手：<a href="<%=followPath %>/customer/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'oppty_partner'}">
													添加合作伙伴：<a href="<%=followPath %>/customer/detail?orgId=${orgId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'q_status' }">
													修改报价状态，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'q_discount' }">
													修改报价折扣，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'q_effectdate' }">
													修改报价有效期，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'q_amount' }">
													修改报价金额，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'q_date' }">
													修改报价日期，${audit.beforevalue }<img src="<%=followPath%>/image/navigation-forward.png" width="20px;">${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'q_item' }">
													创建了报价明细：
													<a href="<%=followPath %>/quote/mxdetail?crmId=${crmId}&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }&parentId=${parentid}"">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'delitem' }">
													删除报价明细：${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'share'}">
													添加团队成员：${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'sharefriends'}">
													添加指尖好友：<a href="<%=followPath%>/businesscard/detail?partyId=${audit.opid}">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'cancel_share'}">
													删除团队成员：${audit.aftervalue}
											</c:if>
											</ul>
										</div>
									</dd>
								</c:if>
								
							</c:forEach>
						</dl>
					</div>
					<div style="clear: both"></div>
					</div>
</c:if>



