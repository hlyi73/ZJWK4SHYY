<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/firstchar/slidernav.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/model/discugroup_conlist.model.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/firstchar/bar.css"/>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/firstchar/slidernav.css"/>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" />
<link rel="stylesheet" href="<%=path%>/css/model/discugroup.css">
<script type="text/javascript">
$(function(){
	new DiscuGroup_ConList();
	
	$(".backbtn").click(function(){
		window.history.back(-1);
	});
});
</script>
<style>
.slider .slider-nav{
	position: fixed;
	right: 0;
	top: 150;
	background: #eee;
	min-height: 250px;
}
.none {
	display: none
}
.g-mask {
	position: fixed;
	top: -0px;
	left: -0px;
	width: 100%;
	height: 100%;
	background: #000;
	filter: alpha(opacity = 60);
	opacity: 0.2;
	z-index: 998; 
}
</style>
</head>
<body>
	<div id="discugroup_conlist">
		<div id="site-nav" class="contact_menu" style="font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;background-color:#fff;text-align:right;line-height:35px;padding-right:8px;">
		    <a href="javascript:void(0)" class="backbtn"  style="padding:5px 8px;">取消</a>
		    <a href="javascript:void(0)" class="cannelbtn" style="padding:5px 8px;">重新筛选</a>
		    <a href="javascript:void(0)" class="okbtn" style="padding:5px 8px;">邀请</a>
		</div>
		
		<div class="selected_infos" style="font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;padding:5px 20px;color:#999;line-height:18px;">
			您选择了<span style="color:red;padding:0px 5px;font-weight:bold;" class="selected_contact_nums">0</span>个联系人。
			<Br/>
			系统将自动过滤重复邀请，请不必担心。
		</div>
		
		<!-- 搜索区域 -->
		<div style="width:100%;height:50px;line-height:50px;background-color:#fff;padding:5px;">
			<div style="height:44px;padding-top:3px;">
				<img src="<%=path %>/image/searchbtn.png" style="position: absolute;opacity: 0.3;width:30px;margin-left: 5px;">
				<input type="text" value="" placeholder="按名字、电话搜索" name="search" style="border-radius: 10px;font-size: 14px;padding-left:40px;border: 1px solid #ddd;line-height: 30px;">
				<input type="hidden" name="dgid" value="${dgid}" />
			</div>
		</div>
		<!-- 导航END -->
		<div id="slider">
			<div class="slider-content" id="div_accnt_list" style="margin-top:5px;margin-bottom:25px;font-size:14px;">
				<ul style="margin-bottom: 45px;">
					<c:forEach items="${charList }" var="char1">
						<li id="${char1}" class=""><a name="${char1}" class="title firstname_list">${char1}</a>
							<ul>
								<c:forEach items="${contactList}" var="contact" >
									<c:if test="${contact.firstname eq char1 }">
										<li class="contact_list" contactid="${contact.rowid}" conname="${contact.conname}" conmobile="${contact.phonemobile}">
											<c:if test="${contact.type eq 'friend'}">
												<a href="javascript:void(0)" style="background-color:#fff;"> 
													<div style="width:90%; background-color:#fff;float: left;">
														
														<div class="content" style="text-align: left">
															<div style="float:left;line-height:25px;">${contact.conname }</div>
															<div style="float:left;line-height: 19px;background-color: orange;color: #fff;border-radius: 10px;margin-top: 3px;margin-left: 5px;padding: 0px 3px;font-size: 12px;">友</div>
															<div style="clear:both"></div>
														</div>
														<div style="line-height:25px;">
															<c:if test="${!empty contact.conjob && '' ne contact.conjob}">
																职称：${contact.conjob }&nbsp;&nbsp;&nbsp;
															</c:if>
															
															<c:if test="${!empty contact.phonemobile && '' ne contact.phonemobile}">
																电话：${contact.phonemobile}
															</c:if>
														</div>
													</div>
													<div class="check-radio " style="float: right;"></div>
													<div style="clear:both"></div>
												</a>
											</c:if>
											<c:if test="${contact.type ne 'friend'}">
												<a href="javascript:void(0)" style="background-color:#fff;">
													<div style="width:90%; background-color:#fff;float: left">
														<div class="content" style="text-align: left">
															<div style="float:left;line-height:25px;">${contact.conname }</div>
															<div style="clear:both"></div>
														</div>
														<div style="line-height:25px;">
															<c:if test="${!empty contact.conjob && '' ne contact.conjob}">
																职称：${contact.conjob }&nbsp;&nbsp;&nbsp;
															</c:if>
															
															<c:if test="${!empty contact.phonemobile && '' ne contact.phonemobile}">
																电话：${contact.phonemobile}
															</c:if>
														</div>
													</div>
												    <div class="check-radio" style="float: right;"></div>
													<div style="clear:both"></div>
												</a>
											</c:if>
										</li>
									</c:if>	
								</c:forEach>
							</ul>
						</li>
					</c:forEach>
					<c:if test="${fn:length(contactList) == 0 }">
						<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
					</c:if>
				</ul>
			</div>
		</div>
		<!-- 按钮 -->
		<%--<div class=" flooter" style="z-index:999999;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
			<input class="btn btn-block cannelbtn" type="button" value="重&nbsp;选" style="width: 48%;margin: 3px 0px 3px 8px;float: left;">
			<input class="btn btn-block btn-success okbtn" type="button" value="确&nbsp;定" style="width: 48%;margin: 3px 0px;float: right;">
		</div>
		 --%>
		 <div class="send_msg_loading none" style="z-index:999;position:fixed;top:40%;left:50%;font-size:14px;text-align:center;line-height: 50px;width:100px;margin-left:-50px;border-radius: 10px;padding-top: 15px;background-color: #fff;border:1px solid #ddd;">
		 	<div><img src="<%=path%>/image/loading.gif"></div>
		 	发送邀请中
		 </div>
		 <div class="g-mask none">&nbsp;</div>
		<div class="none nodata" style="position:fixed;width:100%;text-align:center;top: 150px;">没有找到匹配的数据！</div>
		<div class="myMsgBox" style="display:none;"></div> 
	</div>
</body>
</html>