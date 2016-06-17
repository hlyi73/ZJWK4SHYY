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
    	shareBtnContol();//初始化分享按钮
    	gotopcolor();
	});
    
    function gotopcolor(){
    	$(".gotop").css("background-color","rgba(213, 213, 213, 0.6)");
    }
    
    //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			return false;
    		});
    		//隐藏右上角的按钮
    		$(".act-secondary").css("display","none");
    	}
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
		<h3 style="padding-right:30px;">${expenseName}</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="view site-recommend detailInfo">
		<div class="recommend-box">
				<h3 class="wrapper">基本信息</h3>
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>发生日期：</th>
									<td class="uptShow">${sd.expensedate}</td>
								</tr>
								<tr>
									<th>经办人：</th>
									<td>${sd.assigner}</td>
								</tr>
								<tr>
									<th>费用对象：</th>
									<td class="uptShow">${sd.expUserName}</td>
								</tr>
								<tr>
									<th>一级部门：</th>
									<td class="uptShow">${sd.parentdepartname}</td>
								</tr>
								<tr>
									<th>二级部门：</th>
									<td class="uptShow">${sd.departmentname}</td>
								</tr>
								<tr>
									<th>费用用途：</th>
									<td class="uptShow">${sd.expensetypename}</td>
								</tr>
								<tr>
									<th>费用类型：</th>
									<td class="uptShow">${sd.expensesubtypename}</td>
								</tr>
								<tr>
									<th>金额：</th>
									<td class="uptShow" style="color:red;font-weight:bold;">￥${sd.expenseamount}</td>
								</tr>
								
								<c:if test="${sd.parentid !=''}">
									<tr>
									    <th>相关：</th>
										<c:if test="${sd.parentid !=null && sd.parenttype eq 'Accounts'}">
											<td class="uptShow"><img src="<%=path%>/image/acounts.png" width="20px" border=0>
												<a href="<%=path%>/customer/detail?rowId=${sd.parentid}&openId=${openId}&publicId=${publicId}"
												class="list-group-item listview-item">${sd.parentname}</a></td>
										</c:if>
										<c:if test="${sd.parentid !=null && sd.parenttype eq 'Opportunities'}">
											<td class="uptShow">
												<img src="<%=path%>/image/opptys.png" width="20px" border=0>
												<a href="<%=path%>/oppty/detail?rowId=${sd.parentid}&openId=${openId}&publicId=${publicId}"
												class="list-group-item listview-item">${sd.parentname}</a></td>
										</c:if>
										<c:if test="${sd.parentid !=null && sd.parenttype eq 'Tasks'}">
											<td class="uptShow">
												<img src="<%=path%>/image/tasks.png" width="20px" border=0>
												<a href="<%=path%>/schedule/detail?rowId=${sd.parentid}&openId=${openId}&publicId=${publicId}"
												class="list-group-item listview-item">${sd.parentname}</a></td>
										</c:if>
										<c:if test="${sd.parentid !=null && sd.parenttype eq 'Project'}">
											<td class="uptShow">
												<img src="<%=path%>/image/tasks.png" width="20px" border=0>
												<a href="javascript:void(0)"
												class="list-group-item listview-item">${sd.parentname}</a></td>
										</c:if>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div></div>
					<br/>
					<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>状态：</th>
									<td>${sd.expensestatusname}</td>
								</tr>
								<tr>
									<th>描述：</th>
									<td class="uptShow">${sd.desc}</td>
									<td class="uptInput" style="display:none">
									    <textarea name="expDesc" id="expDesc" rows="" cols="" placeholder="请输入备注信息" >${sd.desc}</textarea>
									</td>
								</tr>
								<tr>
									<th>创建：</th>
									<td>${sd.creater}&nbsp;&nbsp;${sd.createdate}</td>
								</tr>
								<tr>
									<th>修改：</th>
									<td>${sd.modifier}&nbsp;&nbsp;${sd.modifydate}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
		</div>
	</div>
	<br><br><br><br>
	<!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href + "&shareBtnContol=yes",
			title:"${sd.name}",  
			desc:"${sd.creater}"+"在"+"${sd.expensedate}"+"报销了"+"${sd.expenseamount}"+"元的"+"${sd.expensesubtypename}",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>