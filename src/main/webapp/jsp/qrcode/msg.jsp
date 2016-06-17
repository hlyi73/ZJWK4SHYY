<%@page import="com.takshine.wxcrm.base.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String includeFlag = request.getParameter("includeFlag");
	if(StringUtils.isNotNullOrEmptyStr(includeFlag))
	{
		request.setAttribute("inFlag", includeFlag);
	}
	
	if (null != includeFlag)
	{
		%>
		<div style="text-align: center;padding-top:30px;">
		    <img style="height: 120px; width: 120px;" src="<%=path%>/cache/${filename}">
		</div>
		<%
	}
	else
	{
		%>
<html lang="en">
<head>
	<!-- Meta -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
    <%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
	<script type="text/javascript">
		$(function(){
			$(".menu-group").click(function() {
				if ($(".dropdown-menu-group").hasClass("none")) {
					$(".dropdown-menu-group").removeClass("none");
					$(".g-mask").removeClass("none");
				} else {
					$(".dropdown-menu-group").addClass("none");
					$(".g-mask").addClass("none");
				} 
			});
		});
	</script>
</head>
<body>
	<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">我的二维码名片</h3>
		<%-- <div class="act-secondary">
			<a href="<%=path%>/dcCrm/modify?partyId=${partyId}"
				style=""><img src="<%=path%>/image/edit_btn_bg_pressed.png" width="28px;"></a>
		</div> --%>
		<div class="act-secondary menu-group">
			<a href="javascript:void(0)">
				<img src="<%=path%>/image/func_menu.png" width="36px;">
			</a> 
		</div>
		<div class="dropdown-menu-group none">
			<li><a href="<%=path%>/cbooks/list" style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">
					<i class="iconPost f21 cf"></i> &nbsp;我的通讯录
				</a>
			</li>
			<li><a href="<%=path%>/businesscard/detail" style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">
					<i class="iconPost f21 cf"></i> &nbsp;我的主页
				</a>
			</li>
		</div>
	</div>
	<div class="wrapper" style="margin-right:0px;margin-left:0px;margin-top:0px;">
		<div style="padding-left:20px;padding-top:20px;">
			<c:if test="${logoPath eq ''}">
				<img  style="height:60px;width:6px;float:left;" src="<%=path%>/image/defailt_person.png"/>
			</c:if>
			<c:if test="${logoPath ne ''}">
				<img  style="height:60px;width:60px;float:left;" src="${logoPath}"/>
			</c:if>
			<div style="float:clear;"></div>
			<div style="float:left;margin-left:20px;line-height:20px;font-size:14px;">
				<p>
				姓名：
				<c:if test="${opname ne '' && !empty(opname)}">
					${opname}
				</c:if>
				<c:if test="${opname eq '' || empty(opname)}">
					未填写
				</c:if>
				</p>
				<p>
				公司：
				<c:if test="${dcCrmOperator.company ne '' && !empty(dcCrmOperator.company)}">
					${dcCrmOperator.company}
				</c:if>
				<c:if test="${dcCrmOperator.company eq '' || empty(dcCrmOperator.company)}">
					未填写
				</c:if>
				</p>
				<p>
				职称：
				<c:if test="${dcCrmOperator.position ne '' && !empty(dcCrmOperator.position)}">
					${dcCrmOperator.position}
				</c:if>
				<c:if test="${dcCrmOperator.position eq '' || empty(dcCrmOperator.position)}">
					未填写
				</c:if>
				</p>
				<p>
				手机：
				<c:if test="${dcCrmOperator.phone ne '' && !empty(dcCrmOperator.phone)}">
					${dcCrmOperator.phone}
				</c:if>
				<c:if test="${dcCrmOperator.phone eq '' || empty(dcCrmOperator.phone)}">
					未填写
				</c:if>
				</p>
				<p>
				邮箱：
				<c:if test="${dcCrmOperator.email ne '' && !empty(dcCrmOperator.email)}">
					${dcCrmOperator.email}
				</c:if>
				<c:if test="${dcCrmOperator.email eq '' || empty(dcCrmOperator.email)}">
					未填写
				</c:if>
				</p>
				<p>
				地址：
				<c:if test="${dcCrmOperator.address ne '' && !empty(dcCrmOperator.address)}">
					${dcCrmOperator.address}
				</c:if>
				<c:if test="${dcCrmOperator.address eq '' || empty(dcCrmOperator.address)}">
					未填写
				</c:if>
				</p>
			</div>
		</div>
	</div>	
		<div style="padding-top:120px;border-bottom: 1px solid #DDD;margin: 4px 4px 4px 8px;width: 96%;">&nbsp;</div>
		<div style="text-align: center;padding-top:30px;">
		    <img src="<%=path%>/cache/${filename}">
		</div>

	
	<div style="text-align: center;padding-top:30px;padding-left:50px;padding-right:50px;color:#666;line-height:35px;">
		 <p>
		 	<a herf="<%=path%>/dcCrm/detail?partyId=${partyId}">${msg1}</a>
		 </p>
	</div>
	<c:if test="${user.party_row_id eq partyId}">
	<div align="center">
			<a href="<%=path%>/businesscard/share?partyId=${partyId}&shareType=msg&qrCode=true"><span style="background-color:RGB(75, 192, 171);border-radius: 5px;padding: 1px;margin-left: 5px;margin-top:-5px;">短信分享</span></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="<%=path%>/businesscard/share?partyId=${partyId}&shareType=mail&qrCode=true"><span style="background-color:RGB(75, 192, 171);border-radius: 5px;padding: 1px;margin-left: 5px;margin-top:-5px;">邮件分享</span></a>&nbsp;&nbsp;
	</div>
	</c:if>
	<br><br><br><br>
    <!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href,  
			title:"二维码",  
			desc:"分享二维码信息",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
		wx.ready(function () {
		  var url = window.location.href;
		  var opt = {
			  title : "${opname}的二维码名片",
		      desc : "欢迎扫描${opname}的二维码名片",
			  link: url,
			  imgUrl: '${logoPath}' 
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>
		
		
		<%
	}
%>



