<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" />
<script type="text/javascript">
$(function(){
	$(".addFriendsBtn").click(function(){
		alert('发送成功');
		$(this).remove();
		//window.location.href = "<%=path%>/dcCrm/detail";
	});
});
</script>
</head>
<body>
	<div id="site-nav" class="navbar" style="background-color:RGB(75, 192, 171);width: 100%;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3>好友邀请列表</h3>
	</div>
	<div class="view site-recommend">
		<div class="recommend-box" style="font-family: 'Microsoft YaHei';color: #202020;font-size: 12px;">
			<c:forEach items="${caconlist}" var="contact">
					<a href="javascript:void(0)" class="list-group-item listview-item radio">
						<div class="list-group-item-bd" style="margin-top: 25px;">
							<div class="thumb list-icon" style="margin-left: 10px;float: left;background-color:#ffffff;width:60px;height:40px;">
									<c:if test="${contact.filename ne '' && !empty(contact.filename)}">
										<img src="<%=path %>/contact/download?fileName=${contact.filename}" border=0 width="60px" height="60px;"style="background-color:#ffffff;border-radius:8px;">
									</c:if>
									<c:if test = "${contact.filename eq '' || empty(contact.filename)}">
										<img src="<%=path %>/image/defailt_person.png" border=0 width="60px" height="60px;"style="background-color:#ffffff;border-radius:8px;">
									</c:if>
							</div>
							<div class="content" style="text-align: left;padding-left: 10px;float: left;">
								<h1>${contact.name }&nbsp;<span
										style="color: #AAAAAA; font-size: 12px;">${contact.salutation}</span></h1>
								<p style="margin-top: 3px;">
									${contact.position }
								</p>
								<p style="margin-top: 3px;">
									${contact.mobile}
								</p>
							</div>
							<div style="float: right;margin-right: 10px;">
								<c:if test="${contact.isFriends == 'not'}">
									<input type="button" value="加好友" class="addFriendsBtn" style="margin-top: 10px;margin-top: 10px;color: #4DBEF9;border-radius: 3px;border: 1px solid #4DBEF9;background: #fff;padding: 5px;box-shadow: 1px 1px 3px #888888;" />	
								</c:if>
							</div>
						</div>
						<div style="clear: both;"></div>
					</a>
				</c:forEach>
				
				<c:if test="${fn:length(caconlist) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有找到数据</div>
				</c:if>
		</div>
	</div>
</body>
</html>