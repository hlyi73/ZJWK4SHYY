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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/css/style.css">
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css">
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
    	//initWeixinFunc();
    	initButton();
	});
    
    //初始化按钮
    function initButton(){
    	//初始部门
    	
    	$(".initDep").click(function(){
    		//var size = $("#div_rssnews_list").find("div").size();
    		//判断免费版的用户是否超过5人
    		//if(null!=size&&'${orgId}'!='1'&&parseInt(size)>5){
    		//	$(".myMsgBox").css("display","").html("免费版用户不能超过五个！以此给您带来的不便敬请谅解，请联系指尖微客公司！");
			//    $(".myMsgBox").delay(2000).fadeOut();
			//	return;
    		//}
    		window.location.href="<%=path%>/register/initDep?crmId=${crmId}&orgId=${orgId}";
    	})
		
    	
    	//添加用户
		$(".addUser").click(function(){
			//var size = $("#div_rssnews_list").find("div").size();
			//判断免费版的用户是否超过5人
    		//if(null!=size&&'${orgId}'!='1'&&parseInt(size)>5){
    		//	$(".myMsgBox").css("display","").html("免费版用户不能超过五个！以此给您带来的不便敬请谅解，请联系指尖微客公司！");
			//    $(".myMsgBox").delay(2000).fadeOut();
			//	return;
    		//}
    		window.location.href="<%=path%>/register/addUser?crmId=${crmId}&orgId=${orgId}";
    	});
    	
    	//删除用户
    	$(".del").click(function(){
    		var userid = $(this).attr("crmid");
    		var dataObj=[];
    		dataObj.push({name:'crmId',value:userid});
    		dataObj.push({name:'orgId',value:'${orgId}'});
    		dataObj.push({name:'currCrmId',value:'${curruser.userid}'});
    		if(confirm("您确定要删除此用户吗？")){
    			$.ajax({
    				url:'<%=path%>/register/delUser',
    				data:dataObj,
    				type: 'post',
    				success: function(data){
    			    	  if(!data){
    			    		  $(".myMsgBox").css("display","").html("禁用操作失败！请联系管理员");
    						  $(".myMsgBox").delay(2000).fadeOut();
    						  return;
    			    	  }
    			    	  var d = JSON.parse(data);
    			    	  if(d.errorCode&&'0'!=d.errorCode){
    			    		  $(".myMsgBox").css("display","").html("禁用操作失败！请联系管理员");
    						  $(".myMsgBox").delay(2000).fadeOut();
    						  return;
    			    	  }else{
    			    		  $(".myMsgBox").css("display","").html("操作成功！");
    						  $(".myMsgBox").delay(2000).fadeOut();
    						  $("#"+userid).remove();
    						  var size = $("#div_rssnews_list").find("div").size();
    						  if(size<=0){
    							  $("#div_rssnews_list").html('<div style="text-align: center; padding-top: 80px;">没有用户！</div>');  
    						  }
    			    	  }
    			      }
    			});
    		}
    	});
    }
    
    //微信网页按钮控制
	/* function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">企业详情</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="view site-recommend detailInfo" style="border-bottom:1px solid #ddd;">
		<div class="recommend-box">
			<div class="site-card-view">
				<div class="card-info">
					<table>
						<tbody>
							<tr>
								<th>企业名称：</th>
								<td>${org.name}</td>
							</tr>
							<tr>
								<th>所属行业：</th>
								<td>${org.industry}</td>
							</tr>
							<tr>
								<th>企业地址：</th>
								<td>${org.address}</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<c:if test="${fn:length(userList) > 0 }">
	<div style="padding:10px;text-align:center;width:100%;font-size:16px;">用户列表</div>
	</c:if>
	<!-- 用户列表 -->
	<div class="site-recommend-list page-patch">
		<div id="div_rssnews_list" class="list-group listview">
			<c:forEach items="${userList}" var="user" varStatus="stat">
			
					<div id = "${user.userid }" class="list-group-item listview-item" style="margin:1px;padding:5px;">
						<div style="width:100%;margin-right: -50px;padding-right:80px;">
						<a href="javascript:void(0)" >
							<input type="hidden" name="userid" value="${user.userid}">
							<div class="list-group-item-bd">
								<div class="content" style="text-align: left">
									<h1>${user.username}</h1> 
									<div>职称： ${user.title}</div> 
									<div>部门： ${user.department}</div>
								</div> 
							</div>
							
						</a> 
						</div>
						<c:if test="${curruser.adminflag == 1}"> 
						<div class="list-group-item-fd" style="background-color: red;padding:2px;border-radius:5px;">
							<span class="del" crmid="${user.userid}" style="cursor:pointer;color:#fff;z-index:99999;font-size:16px;">&nbsp;禁用&nbsp;</span>
						</div>
						</c:if>
						<div style="clear:both;"></div>
					</div>
				
			</c:forEach>
			<c:if test="${fn:length(userList) == 0 }">
				<div style="text-align: center; padding-top: 80px;">没有用户！</div>
			</c:if>
		</div>
	</div>
	<c:if test="${curruser.adminflag == 1}">
	<!-- 是否为管理员 -->
	<div class="admin" style="margin-top:5px;text-align:center;">
		<div class="flooter" style="padding-bottom:2px;z-index: 99999;background: #FFF;background: rgb(242, 242, 243);border-top: 1px solid #A2A2A2;opacity: 1;"> 
			<div class="button-ctrl">
				<fieldset class="margin:auto;">
					<div class="ui-block-a" style="width:50%">
						<a href="javascript:void(0)"  class="btn btn-block initDep"
							style="font-size: 14px;">初&nbsp;始&nbsp;部&nbsp;门</a>
					</div>
					<div class="ui-block-a" style="width:50%">
						<a href="javascript:void(0)" class="btn btn-block addUser"
							style="font-size: 14px;">添&nbsp;加&nbsp;用&nbsp;户</a>
					</div>
				</fieldset>
			</div>
		</div>
	</div>
	</c:if>
	<%--<jsp:include page="/common/footer.jsp"></jsp:include> --%>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height:auto;padding: 5px 0px 2px 0px;">&nbsp;</div>
	<br><br><br><br><br>
</body>
</html>