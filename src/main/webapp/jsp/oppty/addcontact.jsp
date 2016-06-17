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
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/slider.css" />
<script>
$(function (){
	initForm();
});

//初始化表单
function initForm(){
	//联系人退回
	$(".acctGoBack").click(function(){
		$("#partner-create").removeClass("modal");
		$(".nextCommitExamDiv").removeClass("modal");
		$("#acct_more").addClass("modal");
	});
	//勾选某个 联系人 的超链接
	$(".acctList > a").click(function(){
		$(".acctList > a").removeClass("checked");
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
		}
		return false;
	});
	// 联系人 的 确定按钮
	$(".acctbtn").click(function(){
		$(".acctList > a.checked").each(function(){
			var assId = $(this).find(":hidden[name=assId]").val();
			var assName = $(this).find(":hidden[name=conName]").val();
			$("input[name=rowid]").val(assId);
			$("input[name=contactNameInput]").val(assName);
			$(".acctGoBack").trigger("click");
		});
		
	});
	
	//确定按钮
	$(".conbtn").click(function(){
		var parentId = $(":hidden[name=parentId]").val();
		if(!parentId){
			$(".myMsgBox").css("display","").html("联系人不能为空，请选择联系人！");
			$(".myMsgBox").delay(2000).fadeOut();
			return;
		}
		$("#partnerForm").submit();
	});
	
	//取消按钮
	$(".canbtn").click(function(){
		window.location.href="<%=path%>/oppty/detail?rowId=${parentId}&orgId=${orgId}";
	});
}
//选择联系人
function searchContactName(){
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
			新建联系人
		</div>
		<!-- 创建联系人DIV -->
		<div class="wrapper">
			<form id="partnerForm"  name="partnerForm" action="<%=path%>/contact/saveContact" method="post">
			    <input type="hidden" name="crmId" value="${crmId}" >
			    <input type="hidden" name="parentId" value="${parentId}" >
			    <input type="hidden" name="parentType" value="${parentType}" >
			    <input type="hidden" name="rowid" value="${rowId}" > 
			    <input type="hidden" name="assignerId" value="${crmId}" > 
			    <input type="hidden" name="orgId" value="${orgId}" > 
				<div class="form-group">
					<label class="control-label" for="label_name">联系人</label>
					<input name="contactNameInput" onclick="searchContactName()" value="${conname}" style="cursor:pointer"
				      style="width:100%;" type="text" placeholder="点击选择联系人" readonly="readonly">
				</div>
				<div class="form-group">
					<label class="control-label" for="label_name">你的处境</label>
					<select name="plight" onchange="updatePlight()" style="width:100%;height:2.2em">
				       <c:forEach var="item" items="${plight_list}" varStatus="status">
								<option value="${item.key}" >${item.value}</option>
						</c:forEach>
					</select>
				</div>
				<div class="form-group">
					<label class="control-label" for="label_name">适应能力</label>
					<select name="adapting" onchange="updateAdapting()" style="width:100%;height:2.2em">
				       <c:forEach var="item" items="${adapting_change_list}" varStatus="status">
								<option value="${item.key}" >${item.value}</option>
						</c:forEach>
					</select>
				</div>
				<div class="form-group">
					<label class="control-label" for="label_name">用户角色</label>
					<select name="roles" onchange="updateContactRole()" style="width:100%;height:2.2em">
				       <c:forEach var="item" items="${contact_role_list}" varStatus="status">
								<option value="${item.key}" >${item.value}</option>
						</c:forEach>
					</select>
				</div>
			</form>
		</div>
	</div>
	
	<!--确定/取消按钮-->
	<div class="nextCommitExamDiv flooter">
		<div class="button-ctrl" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 1px;">
			<fieldset class="">
				<div class="ui-block-a canbtn" style="padding-bottom: 4px;">
					<a href="javascript:void(0)" class="btn btn-block" style="font-size: 14px;">取 消</a>
				</div>
				<div class="ui-block-a conbtn" style="padding-bottom: 4px;">
					<a href="javascript:void(0)"class="btn btn-success btn-block" style="font-size: 14px;">确 定</a>
				</div>
			</fieldset>
		</div>
	</div>
	
	<!-- 联系人列表DIV -->
	<div id="acct_more" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary acctGoBack"><i class="icon-back"></i></a>
			联系人列表
			<a href="<%=path%>/contact/add?orgId=${orgId}&parentId=${parentId}&parentName=${parentName}&parentType=${parentType}&flag=addRela" style="float: right;color:#fff;">添加</a>
		</div>
		<div class="page-patch">
			<!-- <h4 class="wrapper list-title">查询结果集:</h4> -->
			<div class="list-group listview listview-header acctList">
				<c:forEach items="${contactList}" var="uitem">
					<a href="javascript:void(0)" class="list-group-item listview-item radio">
						<div class="list-group-item-bd">
							<input type="hidden" name="assId" value="${uitem.rowid}"/>
							<input type="hidden" name="conName" value="${uitem.conname}"/>
							<div class="thumb list-icon" style="background-color:#ffffff;width:45px;height:45px;">
								<c:if test="${uitem.iswbuser eq 'ok'}">
									<img src="${uitem.filename}" border=0 width="60px" height="60px;"style="background-color:#ffffff;">
								</c:if>
								<c:if test="${uitem.iswbuser ne 'ok'}">
									<c:if test="${uitem.filename ne ''}">
										<img src="<%=path %>/contact/download?fileName=${uitem.filename}" border=0 width="60px" height="60px;"style="background-color:#ffffff;">
									</c:if>
									<c:if test = "${uitem.filename eq ''}">
										<img src="<%=path %>/image/defailt_person.png" border=0 width="60px" height="60px;"style="background-color:#ffffff;">
									</c:if>
								</c:if>
							</div>
							<div class="content" style="text-align: left">
								<h1>${uitem.conname }&nbsp;<span style="color: #AAAAAA; font-size: 12px;">${uitem.salutation}</span></h1>
								<p>
									${uitem.conjob }&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${uitem.phonemobile}
								</p>
							</div>
						</div>
						<div class="input-radio" title="选择该条记录"></div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(contactList) == 0}">
					<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">
						无数据
					</div>
				</c:if>
				<br/><br/><br/><br/>
			</div>
			<c:if test="${fn:length(contactList) > 0}">
				<div id="phonebook-btn" class=" flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
					<input class="btn btn-block acctbtn" type="submit" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;" >
				</div>
			</c:if>
		</div>
	</div>
</body>
</html>