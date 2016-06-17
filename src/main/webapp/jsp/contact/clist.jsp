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

<script src="<%=path%>/scripts/plugin/firstchar/slidernav.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/firstchar/bar.css"/>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/firstchar/slidernav.css"/>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<style>
	/* The following styles are used only for this page - the actual plugin styles are in slidernav.css */
	* { margin: 0; padding: 0; }
	body {background: #eee;line-height: 18px; }
	a { text-decoration: none; }
	pre { background: #fff; width: 100%; padding: 10px 20px; border-left: 5px solid #ccc; margin: 0 0 20px; }
	.content h1{color:#666;font-size:16px;}
	.content p{color:#666;margin-top:10px;font-size:14px}
	
	
	* {
	margin:0;
	padding:0;
}

	
</style>
<script type="text/javascript">
	$(function () {
   		$('#slider').sliderNav();
		$('#transformers').sliderNav({items:['autobots','decepticons'], debug: true, height: '300', arrows: false});
		$(".slider-content").css("height",$(window).height() - 60);
		$(".slider-nav").css("height",$(window).height() - 70);
		$(".slider-nav").css("top",50);
		$(".nulldiv").css("display","none");
	});
	
    </script>
</head>
<body>
	<div id="site-nav" class="navbar" style="display:none">
		<input type="hidden" name="currpage" value="1" /> 
	</div>
	
	<div class="site-recommend-list page-patch contactlist">

		
	   <div id="slider">
		<div class="slider-content" id="div_accnt_list" style="margin-top:5px;margin-bottom:5px;">
			<ul>
				<c:forEach items="${charList }" var="char1">
					<li id="${char1}" class=""><a name="${char1}" class="title firstname_list">${char1}</a>
						<ul>
							<c:forEach items="${contactList}" var="contact" >
								<c:if test="${contact.firstname eq char1 }">
									<li class="contact_list" contactid="${contact.rowid}">
										<a href="<%=path%>/contact/detail?rowId=${contact.rowid}&orgId=${contact.orgId}" style="background-color:#fff;">
											<div style="width:100%; background-color:#fff;">
												<div style="float:left;width:80px;margin-left:10px;">
													<%-- <c:if test="${contact.iswbuser eq 'ok'}">
														<img src="${contact.filename}" border=0 width="60px" height="60px;"style="background-color:#ffffff;">
													</c:if>
													<c:if test="${contact.iswbuser ne 'ok'}">
														<c:if test="${contact.filename ne '' && !empty(contact.filename)}">
															<img src="<%=path %>/contact/download?fileName=${contact.filename}" border=0 width="60px" height="60px;"style="background-color:#ffffff;border-radius:8px;">
														</c:if>
														<c:if test = "${contact.filename eq '' || empty(contact.filename)}">
															<img src="<%=path %>/image/defailt_person.png" border=0 width="60px" height="60px;"style="background-color:#ffffff;border-radius:8px;">
														</c:if>
													</c:if> --%>
												</div>
												<c:if test="${contact.orgId eq 'Default Organization' }"> 
													<img src="<%=path %>/image/private.png" style="float:right;margin-right:10px;margin-top:-6px;width:40px;">
												</c:if>
												<div class="content" style="text-align: left;margin-left:10px;">
													<h1>${contact.conname }&nbsp;<span
															style="color: #AAAAAA; font-size: 12px;">${contact.salutation}</span></h1>
												<p>
													<c:if test="${!empty contact.conjob && '' ne contact.conjob}">
														职称：${contact.conjob }&nbsp;&nbsp;&nbsp;
													</c:if>
													
													<c:if test="${!empty contact.phonemobile && '' ne contact.phonemobile}">
														电话：${contact.phonemobile}
													</c:if>
													
												</p>
												
										<!-- 联系人类型-->
											<c:if test="${!empty contact.type && '' ne contact.type}">
														<p class="text-default">类型：${contact.type}</p>
											</c:if>
											
										<!-- 联系人来源 -->
											<c:if test="${!empty contact.soure && '' ne contact.soure}">
														<p class="text-default">来源：${contact.soure}</p>
											</c:if>
												
										<!-- 地址 -->
											<c:if test="${!empty contact.conaddress && '' ne contact.conaddress}">
														<p class="text-default">地址：${contact.conaddress}</p>
											</c:if>
										<!-- 联系频率 -->
											<c:if test="${!empty contact.timefrename && '' ne contact.timefrename}">
														<p class="text-default">联系频率：${contact.timefrename}</p>
											</c:if>
												</div>
											</div>
										
										<div style="clear:both"></div>
										</a>
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
	</div>
	
		<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">121212</div>
		<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>