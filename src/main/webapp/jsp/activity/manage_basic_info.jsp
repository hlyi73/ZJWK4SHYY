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
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/firstchar/slidernav.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/firstchar/bar.css" />
<link rel="stylesheet"
	href="<%=path%>/scripts/plugin/firstchar/slidernav.css" />
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" />
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css" />
<link rel="stylesheet" href="<%=path%>/css/style.css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"	rel="stylesheet" type="text/css" />
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"	type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"	type="text/javascript"></script>
<style>
.tabselected {
	border-bottom: 5px solid #078E46;
	color: #00D1DA;
}

.canceleditcontent {
	background-color: #999;
	color: #fff;
	padding: 5px 20px;
	border-radius: 8px;
	font-size: 14px;
}

.saveeditcontent {
	background-color: RGB(75, 192, 171);
	color: #fff;
	padding: 5px 20px;
	border-radius: 8px;
	font-size: 14px;
}

.check-radio {
	display: inline-block;
	vertical-align: middle;
	width: 1.5em;
	height: 1.5em;
	background-color: #e1e1e1;
	-webkit-border-radius: .2em;
	border-radius: .2em;
}

.rsel {
	background: url(../image/gou.png) #3e6790 no-repeat center;
	-webkit-background-size: 70% auto;
	background-size: 70% auto;
}
</style>
<script type="text/javascript">
$(function (){
	initBtnEvent();
	initDatePicker();
});  

function initBtnEvent(){
	$(".act_team").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage?id=${act.id}");
	});
	$(".act_yaoyue").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage_invit?id=${act.id}");
	});
	$(".act_analytics").click(function(){
		window.location.replace("<%=path%>/zjwkactivity/manage_analytics?id=${act.id}");
	});
	
	$(".cannelbtn").click(function(){
		window.location.href = '<%=path%>/zjwkactivity/manage_basic?id=${act.id}';
	});
	
	$(".savebtn").click(function() {
		if(!validates()){
			var dataObj = [];
			$("form[name=activityForm]").find("input").each(function(){
				var name = $(this).attr("name");
				var val = $(this).val();
				dataObj.push({name:name,value:val});
			});
			$.ajax({
				url:'<%=path%>/zjwkactivity/asyupd',
				type:'post',
				dataType:'text',
				data:dataObj,
				success:function(data){
					if('success'==data){
						$(".myvisitMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("操作成功！");
			  		    $(".myvisitMsgBox").delay(2000).fadeOut();
			  		    window.location.replace('<%=path%>/zjwkactivity/manage?id=${act.id}');
					}else{
						$(".myvisitMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("操作失败，请重试或者联系管理员!"); 
			  		    $(".myvisitMsgBox").delay(2000).fadeOut();
					}
				}
			});
		}
		
	});
	//联系人按钮
	$(".contact_con_tab").click(function() {
		$(".basic_info__").css("display", "none");
		$(".main-btn").css("display", "none");
		$(".contactlist_area").css("display", "");
	});
	//客户按钮
	$(".customer_con_tab").click(function() {
		$(".basic_info__").css("display", "none");
		$(".main-btn").css("display", "none");
		$(".customerlist_area").css("display", "");
	});
	$(".contactback").click(function() {
		$(".basic_info__").css("display", "");
		$(".main-btn").css("display", "");
		$(".contactlist_area").css("display", "none");
	});
	$(".customerback").click(function() {
		$(".basic_info__").css("display", "");
		$(".main-btn").css("display", "none");
		$(".customerlist_area").css("display", "none");
	});
	$(".contactlist_area").find(".contact_list .check-radio").click(function() {
		if ($(this).hasClass("rsel")) {
			$(this).removeClass("rsel");
		} else {
			$(this).addClass("rsel");
		}
	});
	//保存联系人
	$(".savecontact").click(function() {
		var cname = '', cid = '', injoin = '';
		var v = '';
		$(".contactlist_area").find(".contact_list .check-radio.rsel").each(function() {
			var contactid = $(this).parent().parent().attr("contactid");
			var conmobile = $(this).parent().parent().attr("conmobile");
			var conname = $(this).parent().parent().attr("conname");
			injoin += "<span style='color: #1F98FD;line-height: 20px;padding-right:10px;'>" + conname + " " + conmobile + "</span>";
			v += contactid + "|" + conname + "|" + conmobile + ",";
		});
		//统计
		$(":hidden[name=contactlistval]").val(v);
		$(".contact_con_tab .content").html(injoin);
		//出来界面
		$(".basic_info__").css("display", "");
		$(".main-btn").css("display", "");
		$(".contactlist_area").css("display", "none");
		
	});
	$(".customerlist_area").find(".customer_list .check-radio").click(function() {
		if ($(this).hasClass("rsel")) {
			$(this).removeClass("rsel");
		} else {
			$(this).addClass("rsel");
		}
	});
	
	var isregist = '${act.isregist}';
	
	
	//保存客户
	$(".savecustomer").click(function() {
		var cname = '', v = '';
		$(".customerlist_area").find(".customer_list .check-radio.rsel").each(function() {
			var rowId = $(this).parent().attr("rowId");
			var name = $(this).parent().attr("name");
			cname += "<span style='color: #1F98FD;line-height: 20px;padding-right:10px;'>" + name + "</span>";
			v += rowId + "|" + name +";";
		});
		//统计
		$(":hidden[name=customerlistval]").val(v);
		$(".customer_con_tab .content").html(cname);
		//出来界面
		$(".basic_info__").css("display", "");
		$(".main-btn").css("display", "");
		$(".customerlist_area").css("display", "none");
	});
	
	//客户回退
	$(".customerback").click(function(){
		$(".basic_info__").css("display", "");
		$(".customerlist_area").css("display", "none");
		$(".main-btn").css("display", "none");
	});
	
	//是否需要报名
	$(".isregist_con").click(function(){
		lovjs_choose('lov_activity_isregist',{
    		success: function(res){
   				$(":hidden[name=isregist]").val(res.key)
   				$(".isregist_con .content").html(res.val);
   				if('Y'==res.key){
   					$(".showDiv").css("display","none");
   					$(".registDiv").css("display","");
   					$(".displaymenber_con").css("display","");
   				}else{
   					$(".showDiv").css("display","none");
   					$(".registDiv").css("display","none");
   					$("input[name=end_date]").val('');
   					$("input[name=limit_number]").val('');
   					$(".displaymenber_con").css("display","none");
   				}
    		}
    	});
	});
	
	//收费方式
	$(".charge_type_click").click(function(){
		lovjs_choose('lov_activity_chargetype',{
    		success: function(res){
   				$(":hidden[name=charge_type]").val(res.key)
   				if("other"==res.key){
   					$(".charge_type_span").css("display","");
   					$(".charge_type_div .content").html('');
   				}else{
	   				$(".charge_type_div .content").html(res.val);
   					$(".charge_type_span").css("display","none");
   					$("input[name=expense]").val('');
   				}
    		}
    	});
	});
	
	//是否公开报名列表
	$(".displaymenber_con").click(function(){
		lovjs_choose('lov_activity_displaymenber',{
    		success: function(res){
   				$(":hidden[name=display_member]").val(res.key)
   				$(".displaymenber_con .content").html(res.val);
    		}
    	});
	});
}

	//验证所有的参数是否都已经填写
	function validates(){
		var title = $("#title").val();
		if(!title){
			showMyMsg('请填写会议标题');
			return true;
		}
		var start_date = $("#start_date").val();
		if(!start_date){
			showMyMsg('请输入会议开始时间');
			return true;
		}
		var place = $("#place").val();
		if(!place){
			showMyMsg('请输入会议地址');
			return true;
		}
		var act_end_date = $("#act_end_date").val();
		if(!act_end_date){
			showMyMsg('请输入会议结束时间');
			return true;
		}
		var isregist = $(":hidden[name=isregist]").val();
		if('Y'==isregist){
	  		var end_date = $("input[name=end_date]").val();
	  		if(!end_date){
	  			showMyMsg('请输入报名截止时间');
	  			return true;
  			}
		}
	var start = date2utc($('#start_date').val());
	var end = date2utc($('input[name=end_date]').val()); 
	var act_end = date2utc($('#act_end_date').val()); 
    if(end > start){
    	$('#end_date').val('').attr("placeholder","报名截止时间不能晚于会议开始时间，请重新选择!");
    	showMyMsg('报名截止时间不能晚于会议开始时间！');
		return true;
	}
    if(act_end < start){
    	$('#act_end').val('').attr("placeholder","会议结束时间应大于开始时间，请重新选择!");
    	showMyMsg('会议结束时间应大于开始时间！');
		return true;
	}
	return false;
	}

	function showMyMsg(t){
		$(".myvisitMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html(t); 
		$(".myvisitMsgBox").delay(2000).fadeOut();
  	}

//初始化日期控件
function initDatePicker() {
	var opt = {
		date : { preset : 'date',minDate:new Date(),maxDate: new Date(2099,11,31)}
	};
	var optSec = {
		theme: 'default', 
		mode: 'scroller', 
		display: 'modal', 
		lang: 'zh', 
		onSelect: function(){
		}
	};
	$('#start_date').val('${act.start_date}').scroller('destroy').scroller($.extend(opt['date'], optSec));
	$('#act_end_date').val('${act.act_end_date}').scroller('destroy').scroller($.extend(opt['date'], optSec));
	$('#end_date').val('${act.end_date}').scroller('destroy').scroller($.extend(opt['date'], optSec));
}

</script>
</head>
<body>
	<div id="task-create" class="font-size:14px;">
		<div id="site-nav" class="menu_activity zjwk_fg_nav">
			<a href="javascript:void(0)" class="act_team"
				style="padding: 5px 8px;">协同</a> <a href="javascript:void(0)"
				class="tabselected act_baseinfo" style="padding: 5px 8px;">基本信息</a>
			<a href="javascript:void(0)" class="act_yaoyue"
				style="padding: 5px 8px;">邀约</a> <a href="javascript:void(0)"
				class="act_analytics" style="padding: 5px 8px;">分析</a>
		</div>

		<div class="basic_info__">
			<form action="<%=path%>/zjwkactivity/asyupd" name="activityForm" method="post">
			    <!-- 联系人列表 -->
			    <input type="hidden" name="id" value="${act.id}" />
			    <input type="hidden" name="contactlistval" value="${act.contactlistval1}" />
			    <input type="hidden" name="customerlistval" value="${act.customerlistval1}" />
			    <input type="hidden" name="isregist" value="${act.isregist}" />
			    <input type="hidden" name="charge_type" value="${act.charge_type}" />
			    <input type="hidden" name="display_member" value="${act.display_member}" />
			    <input type="hidden" name="orgId" value="${act.orgId}" />
				<div class=""
					style="width: 100%; background-color: #fff; border-top: 1px solid #ddd; border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 15px; line-height: 30px;">
					<input name="title" id="title" value="${act.title}" type="text"
						class="form-control" placeholder="请输入活动主题" style="border: none;">
				</div>
				<div class=""
					style="width: 100%; background-color: #fff; border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 15px; line-height: 30px;">
					<input name="place" id="place" value="${act.place}" type="text"
						class="form-control" placeholder="请输入活动地址" style="border: none;">
				</div>
				<div class=""
					style="width: 100%; background-color: #fff; border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
					会议时间：
					 <input name="start_date" id="start_date"
						value="${act.start_date}" type="text" format="yy-mm-dd"
						style="border: none; width: 100px;"> - 
					<input
						name="act_end_date" id="act_end_date" value="${act.act_end_date}" type="text"
						format="yy-mm-dd" style="border: none; width: 100px;">
				</div>

				<div class="isregist_con"
					style="width: 100%; background-color: #fff; border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
					是否需要报名：&nbsp;&nbsp;&nbsp;
					<span class="content"><c:if test="${act.isregist eq 'Y'}">
						需要
					</c:if>
					<c:if test="${act.isregist eq 'N'}">
						不需要
					</c:if></span>
					<span style="float: right;">
						<img src="<%=path%>/image/arrow_normal.png" width="8px">
					</span>
				</div>

				<div class="none" style="display:none;width: 100%; background-color: #fff;border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
					报名填写项:
					<div style="float: right;margin-top: -25px;">
						<img src="<%=path%>/image/arrow_normal.png" width="8px">
					</div>
				</div>
				
				<c:if test="${act.isregist eq 'Y'}">
					<div class="displaymenber_con" style="width: 100%; background-color: #fff; border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
				</c:if>
				<c:if test="${act.isregist eq 'N'}">
					<div class="displaymenber_con" style="display:none;width: 100%; background-color: #fff;border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
				</c:if>
					是否公开报名列表：&nbsp;&nbsp;&nbsp;
					<span class="content">
					<c:if test="${act.display_member eq 'Y' }">
						显示
					</c:if>
					<c:if test="${act.display_member eq 'N' || empty(act.display_member) }">
						不显示
					</c:if>
					</span>
					<div style="float: right;">
						<img src="<%=path%>/image/arrow_normal.png" width="8px">
					</div>
				</div>
				
				<c:if test="${act.isregist eq 'Y'}">
					<div class="registDiv" style="width: 100%; background-color: #fff;border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
				</c:if>
				<c:if test="${act.isregist eq 'N'}">
					<div class="registDiv" style="display:none;width: 100%; background-color: #fff; border-top: 1px solid #ddd; border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
				</c:if>
					报名截止：&nbsp;&nbsp;&nbsp;<input name="end_date" id="end_date"
						value="${act.end_date}" type="text" format="yy-mm-dd"
						style="border: none; width: 60%;"></div>
						
				<div class="showDiv" style="width: 100%; background-color: #fff; border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
					人数: &nbsp;&nbsp;&nbsp;${act.limit_number}人
				</div>
				<div class="registDiv" style="display:none;width: 100%; background-color: #fff; border-top: 1px solid #ddd; border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
					人数：&nbsp;&nbsp;&nbsp;<input name="limit_number" id="limit_number"
						value="${act.limit_number}" type="text"
						style="text-align: center; border: none; width: 50px;">人
				</div>
				<div class="charge_type_div" style="width: 100%; background-color: #fff;border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
					收费：&nbsp;&nbsp;&nbsp;
					<span class="content">
						<c:if test="${act.charge_type eq 'free'}">
							免费
						</c:if>
						<c:if test="${act.charge_type eq 'aa'}">
							AA制
						</c:if>
						<c:if test="${act.charge_type eq 'other'}">
							${act.expense}&nbsp;&nbsp;元/人
						</c:if>
					</span>
					<span class="charge_type_span" style="display:none;">
						<input name="expense" id="expense"
						value="${act.expense}" type="text"
						style="text-align: center; border: none; width: 50px;">元/人</span>
					<span class="charge_type_click"style="float: right;padding:2px 0px 2px 150px;">
						<img src="<%=path%>/image/arrow_normal.png" width="8px">
					</span>
				</div>
				<div class="contact_con_tab"
					style="width: 100%; background-color: #fff;  border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
					联系人：&nbsp;&nbsp;&nbsp;
					<span class="content" >${act.contactlistval}</span>
					<div style="float: right;">
						<img src="<%=path%>/image/arrow_normal.png" width="8px">
					</div>
				</div>
				<div class="customer_con_tab"
					style="width: 100%; background-color: #fff;  border-bottom: 1px solid #ddd; padding: 5px 15px; font-size: 14px; margin-top: 5px; line-height: 30px;">
					主办：&nbsp;&nbsp;&nbsp;
					<span class="content" >${act.customerlistval}</span>
					<div style="float: right;">
						<img src="<%=path%>/image/arrow_normal.png" width="8px">
					</div>
				</div>
			</form>
		</div>
	</div>
	<div class="main-btn" style="color: #fff; margin-top: 30px; font-size: 16px; text-align: center;">
		<span class="cannelbtn" style="border-radius: 5px; padding:5px 8px; background: #A2A2A2;font-size:14px;">返回</span>&nbsp;&nbsp;&nbsp;&nbsp;
		<span class="savebtn" style="border-radius: 5px; background: #078E46; padding:5px 8px;font-size:14px;">保存</span>
	</div>
	<!-- 联系人列表区域 -->
	<div class="contactlist_area" style="display: none">
		<!-- 搜索区域 -->
		<div style="text-align: right;padding-top: 15px; font-size: 14px; color: #fff; ">
			<span class="contactback"
				style="line-height: 25px; padding: 3px; background: #C7C7C7; font-size: 14px;border-radius: 5px;">返回</span>&nbsp;&nbsp;&nbsp;&nbsp;
			<span class="savecontact"
				style="line-height: 25px; padding: 3px; background: #73E7FC; border-radius: 5px;font-size: 14px; ">确定</span>&nbsp;&nbsp;&nbsp;&nbsp;
		</div>
		<!-- 导航END -->
		<div id="slider">
			<div class="slider-content" id="div_accnt_list"
				style="margin-top: 5px; margin-bottom: 25px; font-size: 14px;">
				<ul style="margin-bottom: 45px;">
				<li id="" class="">
					<a name="" class="title firstname_list"></a>
							<ul>
								<li class="contact_list" contactid="${user.party_row_id}"
									conname="${user.name}"
									conmobile="${user.mobile}">
									
										<a href="javascript:void(0)" style="background-color: #fff;">
											<div
												style="width: 90%; background-color: #fff; float: left">
												<div class="content" style="text-align: left">
													<div style="float: left; line-height: 25px;">${user.name }</div>
													<div style="clear: both"></div>
												</div>
												<div style="line-height: 25px;">
													<c:if
														test="${!empty user.mobile && '' ne user.mobile}">
														电话：${user.mobile}
													</c:if>
												</div>
											</div>
											<div class="check-radio" style="float: right;"></div>
											<div style="clear: both"></div>
										</a>
									</li>
							</ul></li>
					<c:forEach items="${charList }" var="char1">
						<li id="${char1}" class=""><a name="${char1}"
							class="title firstname_list">${char1}</a>
							<ul>
								<c:forEach items="${contactList}" var="contact">
									<c:if test="${contact.firstname eq char1 }">
										<li class="contact_list" contactid="${contact.rowid}"
											conname="${contact.conname}"
											conmobile="${contact.phonemobile}"><c:if
												test="${contact.type eq 'friend'}">
												<a href="javascript:void(0)" style="background-color: #fff;">
													<div
														style="width: 90%; background-color: #fff; float: left;">

														<div class="content" style="text-align: left">
															<div style="float: left; line-height: 25px;">${contact.conname }</div>
															<div
																style="float: left; line-height: 19px; background-color: orange; color: #fff; border-radius: 10px; margin-top: 3px; margin-left: 5px; padding: 0px 3px; font-size: 12px;">友</div>
															<div style="clear: both"></div>
														</div>
														<div style="line-height: 25px;">
															<c:if
																test="${!empty contact.conjob && '' ne contact.conjob}">
																职称：${contact.conjob }&nbsp;&nbsp;&nbsp;
															</c:if>

															<c:if
																test="${!empty contact.phonemobile && '' ne contact.phonemobile}">
																电话：${contact.phonemobile}
															</c:if>
														</div>
													</div>
													<div class="check-radio " style="float: right;"></div>
													<div style="clear: both"></div>
												</a>
											</c:if> 
											<c:if test="${contact.type ne 'friend'}">
												<a href="javascript:void(0)" style="background-color: #fff;">
													<div
														style="width: 90%; background-color: #fff; float: left">
														<div class="content" style="text-align: left">
															<div style="float: left; line-height: 25px;">${contact.conname }</div>
															<div style="clear: both"></div>
														</div>
														<div style="line-height: 25px;">
															<c:if
																test="${!empty contact.conjob && '' ne contact.conjob}">
																职称：${contact.conjob }&nbsp;&nbsp;&nbsp;
															</c:if>

															<c:if
																test="${!empty contact.phonemobile && '' ne contact.phonemobile}">
																电话：${contact.phonemobile}
															</c:if>
														</div>
													</div>
													<div class="check-radio" style="float: right;"></div>
													<div style="clear: both"></div>
												</a>
											</c:if></li>
									</c:if>
								</c:forEach>
							</ul></li>
					</c:forEach>
					<c:if test="${fn:length(contactList) == 0 }">
						<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
					</c:if>
				</ul>
			</div>
		</div>
	</div>

	<!-- 客户列表区域 -->
	<div class="customerlist_area" style="display: none">
		<div style="padding-top: 5px; font-size: 14px; color: #fff; text-align: right;">
			<span class="customerback"
				style="line-height: 25px; padding: 3px; background: #C7C7C7; border-radius: 2px;">返回</span>&nbsp;&nbsp;&nbsp;&nbsp;
			<span class="savecustomer"
				style="line-height: 25px; padding: 3px; background: #73E7FC; border-radius: 2px; ">确定</span>&nbsp;&nbsp;&nbsp;&nbsp;
		</div>
		<div class="customer_list list-group listview"
			style="margin-top: 5px;">
			<c:if test="${orgName ne '' && !empty(orgName) }">
				<a href="javascript:void(0)" class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<div class="content">
							<h1>${orgName}
							</h1>
						</div>
					</div>
					<div class="list-group-item-fd" rowId="${act.orgId}" name="${orgName}">
						<div class="check-radio" style="float: right;"></div>
					</div>
				</a>
			</c:if>
			<c:forEach items="${accList }" var="accnt">
				<a href="javascript:void(0)" class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<c:if test="${accnt.orgId eq 'Default Organization' }">
							<img src="<%=path%>/image/private.png"
								style="float: right; margin-right: -65px; margin-top: -15px; width: 40px;">
						</c:if>
						<div class="content">
							<h1>${accnt.name }&nbsp;<span
									style="color: #AAAAAA; font-size: 12px;">(${accnt.assigner })</span>
							</h1>
							<!-- 电话 -->
							<p class="text-default">
								<c:if
									test="${accnt.phoneoffice ne '' && !empty(accnt.phoneoffice)}">
									<img src="<%=path%>/image/mb_card_contact_tel.png" width="16px">${accnt.phoneoffice}
								</c:if>
							</p>
						</div>
					</div>
					<div class="list-group-item-fd" rowId="${accnt.rowid}" name="${accnt.name}"
						orgId="${accnt.orgId}">
						<div class="check-radio" style="float: right;"></div>
					</div>
				</a>
			</c:forEach>
			<c:if test="${fn:length(accList) == 0 && orgName eq ''}">
				<div style="text-align: center; padding-top: 50px; font-size: 12px;">没有找到数据</div>
			</c:if>
		</div>
	</div>
	<jsp:include page="/common/rela/lov.jsp"></jsp:include>
	<jsp:include page="/common/menu.jsp"></jsp:include>
	<div class="myvisitMsgBox" style="display:none;position:fixed;top:40%;opacity:1;left:50%;margin-left:-90px;">&nbsp;</div>
	</br></br></br></br></br></br>
</body>
</html>