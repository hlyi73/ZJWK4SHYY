<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/template.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/css/slider.css" />
<script>
$(function (){
	initForm();
});

//初始化表单
function initForm(){
	//合作伙伴退回
	$(".acctGoBack").click(function(){
		$("#partner-create").removeClass("modal");
		$(".nextCommitExamDiv").removeClass("modal");
		$("#acct_more").addClass("modal");
	});
	//勾选某个 合作伙伴 的超链接
	$(".acctList > a").click(function(){
		$(".acctList > a").removeClass("checked");
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
		}
		return false;
	});
	// 合作伙伴 的 确定按钮
	$(".acctbtn").click(function(){
		$(".acctList > a.checked").each(function(){
			var assId = $(this).find(":hidden[name=assId]").val();
			var assName = $(this).find(".assName").html();
			$("input[name=customerid]").val(assId);
			$("input[name=customername]").val(assName);
			$("input[name=customerNameInput]").val(assName);
			$(".acctGoBack").trigger("click");
		});
		
	});
	
	//确定按钮
	$(".conbtn").click(function(){
		$(":hidden[name=desc]").val($("#expDesc").val());
		$("#partnerForm").submit();
	});
	
	//取消按钮
	$(".canbtn").click(function(){
		window.location.href="<%=path%>/oppty/detail?orgId=${orgId}&openId=${openId}&publicId=${publicId}&rowId=${opptyid}";
	});
}
//选择合作伙伴
function searchCustomerName(){
	$("#partner-create").addClass("modal");
	$("#acct_more").removeClass("modal");
	$(".nextCommitExamDiv").addClass("modal");
}

</script>
</head>

<body>
	<!-- 导航栏菜单 -->
	<div id="partner-create">
		<div id="" class="navbar">
			新建合作伙伴
		</div>
		<!-- 创建合作伙伴DIV -->
		<div class="wrapper">
			<form id="partnerForm"  name="partnerForm" action="<%=path%>/partner/save" method="post">
			    <input type="hidden" name="crmId" value="${crmId}" >
			    <input type="hidden" name="opptyid" value="${opptyid}" >
			    <input type="hidden" name="publicId" value="${publicId}" >
			    <input type="hidden" name="openId" value="${openId}" >
			    <input type="hidden" name="customername" value="${customername}" >
			    <input type="hidden" name="customerid" value="${customerid}" >
			    <input type="hidden" name="desc" value="" >
			    <input type="hidden" name="orgId" value="${orgId}" >
				<div class="form-group">
					<label class="control-label" for="label_name">伙伴(必填)<span style="color:red;">*</span>&nbsp;</label>
					<input name="customerNameInput" onclick="searchCustomerName();" value="${customername}" style="cursor:pointer"
				      type="text" placeholder="点击选择伙伴" readonly="readonly">
				</div>
				<div class="form-group">
					<label class="control-label" for="label_name">描述</label>
					<textarea name="expDesc" id="expDesc" rows="10"  width="100%;"placeholder="请输入描述信息" ></textarea>
				</div>
			</form>
		</div>
	</div>
	
	<!--确定/取消按钮-->
	<div class="nextCommitExamDiv flooter">
		<div class="button-ctrl" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 1px;">
			<fieldset class="">
				<div class="ui-block-a canbtn" style="padding-bottom: 4px;">
					<a href="javascript:void(0)" class="btn btn-block"
									style="font-size: 14px;">取消</a>
				</div>
				<div class="ui-block-a conbtn" style="padding-bottom: 4px;">
					<a href="javascript:void(0)" class="btn btn-success btn-block"
									style="font-size: 14px;">确定</a>
				</div>
			</fieldset>
		</div>
	</div>
	
	<!-- 客户列表DIV -->
	<div id="acct_more" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary acctGoBack"><i class="icon-back"></i></a>
			伙伴列表
			<a href="<%=path%>/customer/get?openId=${openId}&publicId=${publicId}&module=partner&opptyid=${opptyid}" style="float: right;color:#fff;">添加</a>
		</div>
		<div class="page-patch">
			<!-- <h4 class="wrapper list-title">查询结果集:</h4> -->
			<div class="list-group listview listview-header acctList">
				<c:forEach items="${acctList}" var="uitem">
					<a href="javascript:void(0)" class="list-group-item listview-item radio">
						<div class="list-group-item-bd">
							<input type="hidden" name="assId" value="${uitem.rowid}"/>
							<h2 class="title assName">${uitem.name}
								</h2>
										<span style="color: #AAAAAA; font-size: 13px;">${uitem.assigner}
										</span>
							<p>
								电话号码：<b>${uitem.phoneoffice}</b>
							</p>
						</div>
						<div class="input-radio" title="选择该条记录"></div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(acctList) == 0}">
					<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">
						无数据
					</div>
				</c:if>
			</div>
			<c:if test="${fn:length(acctList) > 0}">
				<div id="phonebook-btn" class=" flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
					<input class="btn btn-block acctbtn" type="submit" value="确&nbsp;定" style="width: 95%;margin: 3px 0px 3px 8px;">
				</div>
			</c:if>
		</div>
	</div>
	<br><br><br>
</body>
</html>