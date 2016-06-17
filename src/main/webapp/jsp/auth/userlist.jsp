<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<script>

$(function(){
	initButton();
})

//初始化按钮
function initButton(){
	//启用或禁用的事件
	$(".del").click(function(){
		var content=null;
		var obj=$(this);
		var status = obj.attr("status");
		var crmId = obj.attr("crmid")
		if('Active'==status){
			content="您确定要禁用此用户吗?";
			status="Inactive";
		}else if('Inactive'==status){
			content="您确定要启用此用户吗?";
			status="Active";
		}
		var dataObj=[];
		dataObj.push({name:'crmid',value:crmId});
		dataObj.push({name:'userstatus',value:status});
		if(confirm(content)){
			$.ajax({
				url:'<%=path%>/userFunc/saveUserStatus',
				data:dataObj,
				type: 'post',
				success: function(data){
			    	  if(!data){
			    		  $(".myMsgBox").css("display","").html("保存失败！");
						  $(".myMsgBox").delay(2000).fadeOut();
						  return;
			    	  }
			    	  var d = JSON.parse(data);
			    	  if(d.errorCode&&'0'!=d.errorCode){
			    		  $(".myMsgBox").css("display","").html("保存失败！");
						  $(".myMsgBox").delay(2000).fadeOut();
						  return;
			    	  }else{
			    		  $(".myMsgBox").css("display","").html("保存成功！");
						  $(".myMsgBox").delay(2000).fadeOut();
						  if('Active'==status){
							  obj.parent().css("background-color","red");
							  obj.html('&nbsp;禁用&nbsp;');
							  obj.attr("status",status);
						  }else if('Inactive'==status){
							  obj.parent().css("background-color","#3e6790");
							  obj.html('&nbsp;启用&nbsp;');
							  obj.attr("status",status);
						   }
			    	  }
			      }
			});
		}
	});
}

</script>
 </head>
  <body style="width:100%;background-color:#fff;font-family:'Microsoft Yahei';">
  	  <div id="site-nav" class="navbar">
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h4 style="padding-right:30px;font-size: 16px;">用户状态</h4>
	  </div>
	  <div class="site-recommend-list page-patch">
		<div id="div_rssnews_list" class="list-group listview">
			<c:forEach items="${userlist}" var="user">
			<div class="list-group-item listview-item">
				<div style="width:100%;margin-right: -50px;padding-right:80px;">
				<a href="javascript:void(0)" >
					<input type="hidden" name="userid" value="${user.userid}">
					<div class="list-group-item-bd">
						<div class="content" style="text-align: left">
							<h1>${user.username}</h1> 
							<p class="text-default">职称： ${user.title}</p>
							<p class="text-default">部门： ${user.department}</p>
						</div> 
					</div>
					
				</a> 
				</div>
				<c:if test="${user.userstatus eq 'Active'}">
					<div class="list-group-item-fd" style="background-color: red;padding:2px;">
						<span class="del" crmid="${user.userid}" status="${user.userstatus}" style="cursor:pointer;color:#fff;z-index:99999">&nbsp;禁用&nbsp;</span>
					</div>
				</c:if>
				<c:if test="${user.userstatus ne 'Active'}">
					<div class="list-group-item-fd" style="background-color:RGB(75, 192, 171);padding:2px;">
						<span class="del" crmid="${user.userid}" status="${user.userstatus}" style="cursor:pointer;color:#fff;z-index:99999">&nbsp;启用&nbsp;</span>
					</div>
				</c:if>
				<div style="clear:both;"></div>
			</div>
			</c:forEach>
		</div>
	</div>
    <div class="myMsgBox" style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;"></div>
  </body>
</html>