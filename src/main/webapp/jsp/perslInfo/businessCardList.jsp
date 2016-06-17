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
<script src="<%=path%>/scripts/plugin/hcharts/highcharts.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<style>
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
.g-mask {
	position: fixed;
	top: -0px;
	left: -0px;
	width: 100%;
	height: 100%;
	background: #000;
	filter: alpha(opacity = 60);
	opacity: 0.5;
	z-index: 998;
}
a{
  color:#666;
}
</style>
<script type="text/javascript">
	$(function () {
		initForm();
		$('#transformers').sliderNav({items:['autobots','decepticons'], debug: true, height: '300', arrows: false});
		$(".nulldiv").css("display","none");
	});
	
	
	
	//初始化表单
	function initForm(){
		$(".menu-group").click(function() {
			if ($(".dropdown-menu-group").hasClass("none")) {
				$(".dropdown-menu-group").removeClass("none");
				$(".g-mask").removeClass("none");
			} else {
				$(".dropdown-menu-group").addClass("none");
				$(".g-mask").addClass("none");
			}
		});
		$(".g-mask").click(function() {
			$(".dropdown-menu-group").addClass("none");
			$(".g-mask").addClass("none");
		});
		
		$("input[name=search]").keyup(function(){
			searchContact();
		});
	}
	
	function add(){
		window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent('contact/add?flag=addCon');
	}
	
	function searchContact(){
		var searchContent = $("input[name=search]").val();
		if(searchContent){
			var isSearch = false;
			$(".contact_list").css('display',"none");
			$(".contact_list").each(function(){
				var name = $(this).attr("conname");
				var mobile = $(this).attr("conmobile");
				var company = $(this).attr("concompany");
				if(name.indexOf(searchContent) != -1 || mobile.indexOf(searchContent) != -1||company.indexOf(searchContent) != -1){
					isSearch = true;
					$(this).css("display","");
				}
			});
			if(!isSearch){
				$(".nodata").removeClass("none")
			}else{
				$(".nodata").addClass("none");
			}
		}else{
			$(".contact_list").css('display',"");
			$(".nodata").addClass("none");
		}
	}	
    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">名片列表</h3>
		<div class="act-secondary menu-group" >
			<a href="javascript:void(0)"  style="">
				<img src="<%=path %>/image/func_menu.png" width="36px;"> 
			</a> 
		</div>
		<div class="dropdown-menu-group none">
			<!-- <li>
				<a href="javascript:void(0)" onclick="add()" style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">
						<i class="iconPost f21 cf"></i> &nbsp;增加联系人
				</a>
			</li> -->
			<%--<li>
				<a href="javascript:void(0)" onclick="importContact()" style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">
						<i class="iconPost f21 cf"></i> &nbsp;导入通讯录
				</a>
			</li> --%>
			<li>
				<a href="javascript:void(0)" style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">
						<i class="iconPost f21 cf"></i> &nbsp;完善个人资料
				</a>
			</li>
			<!-- <li>
				<a href="javascript:void(0)" onclick="exportContact()" style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;">
					<i class="iconPost f21 cf"></i> &nbsp;导出通讯录
				</a>
			</li> -->
		</div>		
	</div>

	 <!-- 搜索区域 -->
	<div style="width:100%;height:50px;line-height:50px;background-color:#fff;padding:5px;">
		<div style="height:44px;padding-top:3px;">
			<img src="<%=path %>/image/searchbtn.png" style="position: absolute;opacity: 0.3;width:30px;margin-left: 5px;">
			<input type="text" value="" placeholder="按名字、公司、电话搜索" name="search" style="border-radius: 10px;font-size: 14px;padding-left:40px;border: 1px solid #ddd;line-height: 30px;"> 
		</div>
	</div>
	
	   <!-- 导航END -->
		<div class="slider-content" id="div_accnt_list" style="margin-top:5px;margin-bottom:65px;font-size:14px;">
							<c:forEach items="${businessCardList}" var="bc" >
							   <li class="contact_list" contactid="${bc.id}" conname="${bc.name}" conmobile="${bc.phone}" concompany="${bc.company}">
											<a href="<%=path%>/businesscard/detail?partyId=${bc.partyId}" style="background-color:#fff;"> 
												<div style="width:100%; background-color:#fff;border-bottom: 1px solid #F2F2F2;">
													
													<div class="content" style="text-align: left;margin-left: 10px;">
														<div style="float:left;line-height:25px;color:#333;">${bc.name }</div>
<!-- 														<div style="float:left;line-height: 19px;background-color: orange;color: #fff;border-radius: 10px;margin-top: 3px;margin-left: 5px;padding: 0px 3px;font-size: 12px;">友</div> -->
														<div style="clear:both"></div>
													</div>
													<div style="line-height:25px;margin-left: 10px;color:#999;">
														<c:if test="${!empty bc.company && '' ne bc.company}">
															<div>公司：${bc.company }</div>
														</c:if>
														<div>
														<c:if test="${!empty bc.phone && '' ne  bc.phone}">
															电话：${bc.phone}&nbsp;&nbsp;&nbsp;
														</c:if>
														<c:if test="${!empty bc.position && '' ne bc.position}">
															职称：${bc.position }
														</c:if>
														</div>
													</div>
												</div>
											
												<div style="clear:both"></div>
											</a>									
							</c:forEach>
	
				<c:if test="${fn:length(businessCardList) == 0 }">
					<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
				</c:if>
		</div>
<!-- 	<div class="none nodata" style="position:fixed;width:100%;text-align:center;top: 150px;">没有找到匹配的数据！</div>
 -->	<div class="g-mask none">&nbsp;</div>
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">&nbsp;</div>
</body>
</html>