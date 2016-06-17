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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/firstchar/slidernav.js"
	type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/firstchar/bar.css" />
<link rel="stylesheet"
	href="<%=path%>/scripts/plugin/firstchar/slidernav.css" />
<script src="<%=path%>/scripts/plugin/hcharts/highcharts.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />
<link rel="stylesheet" href="/ZJWK/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="/ZJWK/css/page.css" id="style_color">

<style>
a {
	color: #666;
}
</style>

<script type="text/javascript">
	$(function () {
		initForm()
   		$('#slider').sliderNav();
		$('#transformers').sliderNav({items:['autobots','decepticons'], debug: false, height: '300', arrows: true});
		$(".nulldiv").css("display","none");
		
		//计算字母列表的高度
		//$(".slider .slider-nav").css("top", $(window).height()-54-60-25-320);
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
	//	新增
	function add(){
		window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent('contact/add?flag=addCon');
	}
//搜索联系人
	function searchContact(){
		var searchContent = $("input[name=search]").val();
		if(searchContent){
			var isSearch = false;
			$(".firstname_list").css("display","none");
			$(".contact_list").css('display',"none");
			$(".contact_list").each(function(){
				var name = $(this).attr("conname");
				var mobile = $(this).attr("conmobile");
				if(name.indexOf(searchContent) != -1 || mobile.indexOf(searchContent) != -1){
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
			$(".firstname_list").css("display","");
			$(".contact_list").css('display',"");
			$(".nodata").addClass("none");
		}
	}
	//导出联系人
	function exportContact(){
		
		$(".g-mask").trigger("click");
		
		if($(".contact_list").length == 0){
			$(".myMsgBox").css("display","").html("没有数据!");
   	    	$(".myMsgBox").delay(2000).fadeOut();
   	    	return;
		}
		
		$.ajax({
			type : 'post',
			url : '<%=path%>/cbooks/export',
			async : false,
			data : {},
			dataType : 'text',
			success:function(data){
				if(data && data == 'success'){
					$(".myMsgBox").css("display","").html("导出成功，请查收邮件!");
	   	    		$(".myMsgBox").delay(2000).fadeOut();
				}else if(data && data == 'noemail'){
					if(confirm("您的邮箱不完整，现在去完善？")){
						window.location.replace("<%=path%>/businesscard/modify");
					}
				}
			},
			error : function() {
				$(".myMsgBox").css("display", "").html("导出失败!");
				$(".myMsgBox").delay(2000).fadeOut();
			}
		});
	}

	//导入联系人
	function importContact() {
		$.ajax({
			type : 'post',

		});

	}
</script>
</head>
<body>
	<div id="site-nav" class="contact_menu"
		style="font-size: 14px; width: 100%; margin-top: 5px; margin-bottom: 5px; border-bottom: 1px solid #ddd; border-top: 1px solid #ddd; background-color: #fff; text-align: right; line-height: 35px; padding-right: 8px;">
		<a href="javascript:void(0)" onclick="add()" style="padding: 5px 8px;">新增</a>
		<a href="<%=path%>/businesscard/modify" style="padding: 5px 8px;">完善个人资料</a>
		<a href="javascript:void(0)" onclick='exportContact()'
			style="padding: 5px 8px;">导出通讯录</a>
	</div>

	<!-- 搜索区域 -->
	<div
		style="width: 100%; height: 40px; background-color: #fff; padding: 5px;">
		<div style="height: 44px; padding-top: 3px;">
			<img src="<%=path%>/image/searchbtn.png"
				style="position: absolute; opacity: 0.3; width: 30px; margin-left: 5px;">
			<input type="text" value="" placeholder="按名字、电话搜索" name="search"
				style="border-radius: 10px; font-size: 14px; padding-left: 40px; border: 1px solid #ddd; line-height: 30px;">
		</div>
	</div>

	<%-- <div
		style="width: 100%; height: 40px; background-color: #fff; padding: 5px;">
		<div style="height: 44px; padding-top: 3px;">
			<a href="" style="margin-top: 10px;"> <img
				src="<%=path%>/image/contact/person.png"
				style="position: absolute; opacity: 0.3; width: 30px; margin-left: 5px;">
				<div
					style="font-size: 14px; padding-left: 40px; border: 1px solid #ddd; line-height: 30px;">账户：个人账户</div>
			</a>

		</div>
	</div> --%>

	<div
		style="width: 100%; height: 40px; background-color: #fff; padding: 5px;">
		<div style="height: 44px; padding-top: 3px;">
			<a href="<%=path%>/cbooks/conlist_group" style="margin-top: 10px;">
				<img src="<%=path%>/image/contact/group1.png"
				style="position: absolute; opacity: 0.3; width: 30px; margin-left: 5px;">
				<div style="font-size: 14px; padding-left: 40px; border: 1px solid #ddd; line-height: 30px;">自动分组</div>
			</a>

		</div>
	</div>

	<div
		style="width: 100%; height: 40px; background-color: #fff; padding: 5px;">
		<div style="height: 44px; padding-top: 3px;">
			<a href="<%=path%>/cbooks/hand_group" style="margin-top: 10px;">
				<img src="<%=path%>/image/contact/group1.png"
				style="position: absolute; opacity: 0.3; width: 30px; margin-left: 5px;">
				<div
					style="font-size: 14px; padding-left: 40px; border: 1px solid #ddd; line-height: 30px;">人工分组</div>
			</a>

		</div>
	</div>





	<!-- 导航END -->
	<div id="slider">
		<div class="slider-content" id="div_accnt_list"
			style="margin-top: 5px; margin-bottom: 65px; font-size: 14px;">
			<ul>
				<c:forEach items="${charList}" var="char1">
					<li id="${char1}" class=""><a name="${char1}"
						class="title firstname_list">${char1}</a>
						<ul>
							<c:forEach items="${contactList}" var="contact">
								<c:if test="${contact.firstname eq char1 }">
									<li class="contact_list" contactid="${contact.rowid}"
										conname="${contact.conname}"
										conmobile="${contact.phonemobile}"><c:if
											test="${contact.type eq 'friend'}">
											<a
												href="<%=path%>/out/user/card?partyId=${contact.rowid}&flag=RM"
												style="background-color: #fff;">
												<div style="width: 100%; background-color: #fff;">

													<div class="content" style="text-align: left">
														<div style="float: left; line-height: 25px;">${contact.conname }</div>
														<div
															style="float: left; line-height: 19px; background-color: orange; color: #fff; border-radius: 10px; margin-top: 3px; margin-left: 5px; padding: 0px 3px; font-size: 12px;">友</div>
														<div style="clear: both"></div>
													</div>
													<div style="line-height: 25px;">
														<c:if
															test="${!empty contact.conjob && '' ne contact.conjob}">
															职称：${contact.conjob }&nbsp;&nbsp;&nbsp;
														</c:if>

														<c:if
															test="${!empty contact.phonemobile && '' ne contact.phonemobile}">
															电话：${contact.phonemobile}
														</c:if>
													</div>
												</div>

												<div style="clear: both"></div>
											</a>
										</c:if> <c:if test="${contact.type ne 'friend'}">
											<a
												href="<%=path%>/contact/detail?rowId=${contact.rowid}&orgId=${contact.orgId}"
												style="background-color: #fff;">
												<div style="width: 100%; background-color: #fff;">
													<div class="content" style="text-align: left">
														<div style="float: left; line-height: 25px;">${contact.conname }</div>
														<div style="clear: both"></div>
													</div>
													<div style="line-height: 25px;">
														<c:if
															test="${!empty contact.conjob && '' ne contact.conjob}">
															职称：${contact.conjob }&nbsp;&nbsp;&nbsp;
														</c:if>

														<c:if
															test="${!empty contact.phonemobile && '' ne contact.phonemobile}">
															电话：${contact.phonemobile}
														</c:if>
													</div>
												</div>

												<div style="clear: both"></div>
											</a>
										</c:if></li>
								</c:if>
							</c:forEach>
						</ul></li>
				</c:forEach>
				<c:if test="${fn:length(contactList) == 0 }">
					<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
				</c:if>
			</ul>
		</div>
	</div>
	<jsp:include page="/common/menu.jsp"></jsp:include>
	<div class="none nodata"
		style="position: fixed; width: 100%; text-align: center; top: 150px;">没有找到匹配的数据！</div>
	<div class="g-mask none">&nbsp;</div>
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 14px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">&nbsp;</div>
</body>
</html>