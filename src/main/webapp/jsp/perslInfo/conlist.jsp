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
<script src="<%=path%>/scripts/plugin/jquery/jquery.jBox-2.3.min.js" 
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
<link rel="stylesheet" href="<%=path%>/scripts/plugin/jquery/jbox.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />
<style>
a {
	color: #666;
}
</style>

<!--功能导航栏下拉列表样式-->
<style type="text/css"> 
* { 
padding:0; 
margin:0; 
} 
#navigation, #navigation li ul { 
list-style-type:none; 
} 
#navigation li { 
float:left; 
text-align:left; 
position:relative; 
} 
#navigation li a:link, #navigation li a:visited { 
display:block; 
text-decoration:none; 
color:#000; 
width:70px; 
height:40px; 
line-height:40px; 
border:0px solid #fff; 
border-width:1px 1px 0 0; 
background:#E1E4F5; 
font-size: 14px;
 padding-left: 10px;
} 
#navigation li a:hover { 
color:#fff; 
background:#2687eb; 
} 
#navigation li ul li a:hover { 
color:#fff; 
background:#ADEDF9; 
} 
#navigation li ul { 
display:none; 
position: fixed;
  top: 40px;
  right: 20;
  margin-top: 1px;
  width: 60px;
  position:relative; 
  z-index: 9;
} 
#navigation li ul li ul { 
display:none; 
position:absolute; 
top:0px; 
left:130px; 
margin-top:0; 
margin-left:1px; 
width:120px; 
} 
</style> 


<script type="text/javascript">

	$(function () {
		initForm();
		
   		$('#slider').sliderNav();
		$('#transformers').sliderNav({items:['autobots','decepticons'], debug: false, height: '300', arrows: true});
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
		
		$(".search_contact_btn").click(function(){
			$(".conlist_menu").css("display","none");
			$(".search_menu").css("display","");
		});
		
		$(".cancel_search_contact_btn").click(function(){
			$(".conlist_menu").css("display","");
			$(".search_menu").css("display","none");
			$("input[name=search]").val('');
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
					$(this).parent().parent().find(".firstname_list").css("display","");
					
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
		
		if($(".contact_list").length == 0){
			$(".myvisitMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("没有数据!");
	    		$(".myvisitMsgBox").delay(2000).fadeOut();
   	    	return;
		}
		
		$(".export_conlist_loading").removeClass("none");
		
		$.ajax({
			type : 'post',
			url : '<%=path%>/cbooks/export',
			data : {},
			dataType : 'text',
			success:function(data){
				if(data && data == 'success'){
					$(".myvisitMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("导出成功，请查收邮件!");
	   	    		$(".myvisitMsgBox").delay(2000).fadeOut();
				}else if(data && data == 'noemail'){
					
					var submit = function (v, h, f) {
			   	        if (v == true){
			   	        	window.location.replace("<%=path%>/businesscard/modify");
			   	        }else{
			   	        }
			   	        return true;
			   	    };
			        jBox.confirm("您的邮箱填写不完整，现在去完善？", "提示", submit, { id:'hahaha', showScrolling: false, buttons: { '取消': false, '确定': true } });
	
				}else if(data && data == 'invalidemail'){					
					
					var submit = function (v, h, f) {
			   	        if (v == true){
			   	        	window.location.replace("<%=path%>/businesscard/modify");
			   	        }else{
			   	        }
			   	        return true;
			   	    };
			        jBox.confirm("您的邮箱还未通过验证，现在去验证？", "提示", submit, { id:'hahaha', showScrolling: false, buttons: { '取消': false, '确定': true } });
					
				}
				$(".export_conlist_loading").addClass("none");
			},
			error : function() {
				$(".myvisitMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("导出失败!");
   	    		$(".myvisitMsgBox").delay(2000).fadeOut();
   	    		$(".export_conlist_loading").addClass("none");
			}
		});
	}

	function searchDataByOrgId(orgId){
		window.location.replace("<%=path%>/cbooks/list?orgId="+orgId);
	}
</script>
<style>
.none{
	display:none;
}
</style>
</head>
<body>
	
	<div style="width: 100%; line-height: 40px; background-color: #fff;">
		<jsp:include page="/common/rela/org.jsp"></jsp:include>
	</div>
	
	<!-- 搜索区域 -->
		
		<div class="zjwk_fg_nav_2" style="border-bottom:0px;">
		    <div class="search_menu" style="display:none;height:35px;padding-left:3px;">
		    	<div style="float: left;width:85%;padding-top:2px; ">
					<img src="<%=path%>/image/searchbtn.png" style="position: absolute; opacity: 0.3; width: 30px; margin-left: 5px;">
					<input type="text" value="" oninput="searchContact(event)" onpropertychange="searchContact(event)" placeholder="可根据姓名、电话搜索" name="search" style="font-size: 14px; padding-left: 30px; border: 1px solid #ddd; line-height: 30px;">
				</div>
				<a href="javascript:void(0)" class="cancel_search_contact_btn" >
				<div style="float: right; line-height: 30px;background-color: #ddd; border-radius: 5px; width:13%;margin-top:2px;color: #666;font-size: 14px;text-align:center;">
			         取消
		         </div>
		         </a>
		    </div>
		    <div style="clear:both;"></div> 
		    <div class="conlist_menu">
			    <a href="javascript:void(0)" class="search_contact_btn" style="padding:5px 8px;color:#0C79A1; ">筛选</a>
			    <a href="<%=path %>/contact/impuser" style="padding:5px 8px;color:#0C79A1;">导入</a>
			    <a href="javascript:void(0)" onclick='exportContact()' style="padding:5px 8px;color:#0C79A1;" class="a-resource">导出</a>
			    <a href="javascript:void(0)" onclick='add()' style="padding:5px 8px;color:#0C79A1;" class="a-resource">新建</a>
		    </div>
		</div>
		<div style="clear:both;"></div> 
	    <div style="float:left;width: 100%; line-height: 40px; background-color: #fff;">
				<a href="<%=path%>/cbooks/conlist_group" style="margin-top: 10px;">
					<div style="font-size: 14px; padding-left: 10px; border-top: 1px solid #ddd;">自动分组</div>
				</a>
		</div>

		<div style="float:left;width: 100%; line-height: 40px; background-color: #fff;">
				<a href="<%=path%>/cbooks/hand_group" style="margin-top: 10px;">
					<div style="font-size: 14px; padding-left: 10px; border-top: 1px solid #ddd;border-bottom: 1px solid #ddd;">人工分组</div>
				</a>
		</div>

	<!--导航END -->
	<div id="slider">
		<div class="slider-content" id="div_accnt_list"
			style=" margin-bottom: 65px; font-size: 14px;">
			<ul>
				<c:forEach items="${charList}" var="char1">
					<li id="${char1}" class=""><a name="${char1}"
						class="title firstname_list">${char1}</a>
						<ul>
							<c:forEach items="${contactList}" var="contact">
								<c:if test="${contact.firstname eq char1 }">
									<li class="contact_list" contactid="${contact.rowid}"
										conname="${contact.conname}"
										conmobile="${contact.phonemobile}">
										<c:if
											test="${contact.type eq 'friend'}">
											<a href="<%=path%>/out/user/card?partyId=${contact.rowid}&flag=RM"
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
	
	<div class="export_conlist_loading none" style="z-index:999;position:fixed;top:40%;left:50%;font-size:14px;text-align:center;line-height: 50px;width:100px;margin-left:-50px;border-radius: 10px;padding-top: 15px;background-color: #fff;border:1px solid #ddd;">
		 <div><img src="<%=path%>/image/loading.gif"></div>
		   正在导出
	</div>
	
	<jsp:include page="/common/menu.jsp"></jsp:include>
	<div class="none nodata"
		style="position: fixed; width: 100%; text-align: center; top: 230px;font-size:14px;">没有找到匹配的数据！</div>
	<div class="g-mask none">&nbsp;</div>
	<div class="myvisitMsgBox" style="display:none;position:fixed;top:40%;opacity:1;left:50%;margin-left:-90px;">&nbsp;</div>
</body>
</html>