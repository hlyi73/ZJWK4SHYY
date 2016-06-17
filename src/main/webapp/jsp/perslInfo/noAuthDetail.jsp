<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js"></script>
<script src="<%=path%>/scripts/plugin/arttemp.js"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/model/personalmsg.model.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/model/visituser.model.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css">
<link rel="stylesheet" href="<%=path%>/css/personalmsg.css">
<!-- template -->
<style type="text/css">
.dropdown-menu-group {
	font-size: 14px;
	position: absolute;
	width: 150px;
	right: 2px;
	left: auto;
	top: 45px;
	text-align: left;
	z-index: 999;
	background-color: RGB(75, 192, 171);
	-webkit-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-moz-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-ms-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-o-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
}

.dropdown-menu-group li {
	white-space: nowrap;
	margin-left: 10px;
	font-weight: 900;
	word-wrap: normal;
	border-bottom: 1px solid #365a7e;
}

.dropdown-menu-group li a {
	color: #fff
}
.none {
	display: none
}
</style>

</head>

<body style="min-height: 100%;">
	<div id="site-nav" class="navbar" style="">
		<h3 style="padding-right: 45px;">${BusinessCard.name}的名片
		</h3>
	</div>
	<div class="site-recommend-list page-patch acclist">
		<div class="list-group1 listview">
			<!-- <h4>详情</h4> -->
				<input type="hidden" name="id" id="id" value="${BusinessCard.id}" />
				<input type="hidden" name="sex" id="sex" value="${BusinessCard.sex}" />
				<input type="hidden" name="partyId" id="partyId" value="${BusinessCard.partyId}" />
			    <input type="hidden" name="headImageUrl" id="headImageUrl" value="${BusinessCard.headImageUrl}" />
			    <input type="hidden" name="isSendMsg" id="isSendMsg" value="" />
			   <input type="hidden" name="isValidation" id="isValidation" value="${BusinessCard.isValidation}" />
			 <div class="list-group-item listview-item">
		<div style="width:100%;">
				<div style="float:left;">
					<c:if test="${BusinessCard.headImageUrl ne '' and BusinessCard.headImageUrl ne null}">
								<img id="headImg" name="headImg" src="<%=path%>/contact/download?flag=dccrm&fileName=${BusinessCard.headImageUrl}" height="60px">
					</c:if>
					<c:if
						test="${BusinessCard.headImageUrl eq '' or BusinessCard.headImageUrl eq null}">
						<img id="headImg" name="headImg"  src="${weixinHeadImage}" height="60px">
					</c:if>
				</div>
				<div style="margin-left:70px;">
					<c:if test="${BusinessCard.name ne '' and BusinessCard.name ne null}">
						${BusinessCard.name}
					</c:if>
				</div>
				<div style="margin-left:70px;margin-top:10px;color:#999;font-size:12px;">
					<c:if test="${BusinessCard.company ne '' and BusinessCard.company ne null}">
						${BusinessCard.company}
					</c:if>
					<c:if test="${BusinessCard.position ne '' and BusinessCard.position ne null}">
							/${BusinessCard.position}
					</c:if>
				</div>
					<div style="margin-left:70px;">
					<c:if test="${BusinessCard.phone ne '' and BusinessCard.phone ne null}">
						${BusinessCard.phone}
						 <c:if test="${'1' eq BusinessCard.isValidation}">
						 （已验证）
						 </c:if>
					</c:if>
				</div>
					<div style="margin-left:70px;">
					<c:if test="${BusinessCard.email ne '' and BusinessCard.email ne null}">
						${BusinessCard.email}
						 <c:if test="${'1' eq BusinessCard.isEmailValidation}">
						 （已验证）
						 </c:if>
					</c:if>
				</div>
				</div>
			</div> 
		</div>
	</div>
	
	<div class="_menu flooter">		
	</div>
</body>
</html>