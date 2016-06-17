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
 .tabselected {
	border-bottom: 5px solid #078E46;
	color: #00D1DA;
}
  .input-radio {
	display: inline-block;
	vertical-align: middle;
	width: 1.5em;
	height: 1.5em;
	background-color: #e1e1e1;
	-webkit-border-radius: .2em;
	border-radius: .2em;
}

.slider .slider-nav {
position: fixed;
right: 0;
top: 160;
background: #eee;
min-height: 250px;
}
</style>
<script type="text/javascript">
   var opFlag = false;

	$(function () {
		initForm();
		
   		/* $('#slider').sliderNav();
		$('#transformers').sliderNav({items:['autobots','decepticons'], debug: false, height: '280', arrows: true}); */
		
		$("#operDiv").find("a").each(function(){
    		$(this).click(function(){
    			$(this).siblings().removeClass("tabselected");
    			$(this).addClass("tabselected");
    		})
    	})
    	
    	$(".${tabClass}").addClass("tabselected");
		if ('${tabClass}' == 'con_choose' || '${tabClass}' == 'con_del')
		{
			opFlag = true;
			$(".input-radio").css("display","");
			$("#opArea").css("display","");
		}
		
		if ('${conCount}' !== '')
		{
			$(window.parent.document).find(".a-contact").html("联系人(${conCount})");
		}
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
	
	//客户关联联系人界面点击新增联系人
	function toNew()
	{
		top.window.location.href = "<%=path%>/contact/add?flag=addCon&orgId=${orgId}&parentId=${parentId}&parentType=${parentType}&source=true";
	}
	//客户关联联系人界面点击选择联系人
	function toChoose()
	{
		parent.toContact($(window.parent.document).find("input[name=parentId]").val(),$(window.parent.document).find("input[name=parentType]").val(),'con_choose');
		//parent.toContact(null,null,'con_choose');
	}
	//客户关联联系人界面点击删除联系人
	function toDelete()
	{
		parent.toContact($(window.parent.document).find("input[name=parentId]").val(),$(window.parent.document).find("input[name=parentType]").val(),'con_del');
	}
	function toCustOwner()
	{
		parent.toContact($(window.parent.document).find("input[name=parentId]").val(),$(window.parent.document).find("input[name=parentType]").val(),'con_owner');
	}
	
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
	
	function redirect(id,obj)
	{
		if (opFlag)
		{
			if ($(obj).hasClass("checked"))
			{
				$(obj).removeClass("checked");
				$(obj).removeClass("radio");
			}
			else
			{
				$(obj).addClass("checked");
				$(obj).addClass("radio");
			}
						
			return false;
		}
	}
	
	function toCancelOp()
	{
		toCustOwner();
	}
	
	function toSaveRela()
	{
		var ids = "";
		var parentId =$(window.parent.document).find("input[name=parentId]").val();
		var parentType = $(window.parent.document).find("input[name=parentType]").val();
		var orgId =  $(window.parent.document).find("input[name=orgId]").val();
		$(".slider-content").find("a").each(function(){
			if ($(this).hasClass("checked"))
			{
				ids += $(this).attr("chooseId") + ",";
			}
		})
		
		if (ids != "")
		{
			ids = ids.substring(0,ids.length - 1);

			if ('${tabClass}' == 'con_choose')
			{
				$.ajax({
			  	      type: 'post',
			  	      url: '<%=path%>/contact/saveCustRela',
			  	      data: {parentId: parentId, parentType:parentType, orgId:orgId,rowIds:ids},
			  	      dataType: 'text',
			  	      success: function(data){
			  	    	    if(!data) return;
			  	    	    //var d = JSON.parse(data);
			  	    	    if(data && data == '0')
			  	    	    {
			  	    	    	$(".myMsgBox").css("display","").html("添加关系成功");
				   	    		$(".myMsgBox").delay(2000).fadeOut();
					    	}
			  	    	    else if (data && data == '1')
			  	    	    {
			  	    	    	$(".myMsgBox").css("display","").html("添加操作成功，部分数据添加失败");
				   	    		$(".myMsgBox").delay(2000).fadeOut();
			  	    	    }
			  	    	    else if (data && data == '1')
			  	    	    {
			  	    	    	$(".myMsgBox").css("display","").html("添加关系失败");
				   	    		$(".myMsgBox").delay(2000).fadeOut();
				   	    		return;
			  	    	    }
			  	    	    
			  	    	  toCustOwner();
			  	      }
			 	});
			}
			else if ('${tabClass}' == 'con_del')
			{
				$.ajax({
			  	      type: 'post',
			  	      url: '<%=path%>/contact/delCustRela',
			  	      data: {parentId: '${parentId}', parentType:'${parentType}', orgId:'${orgId}',rowIds:ids,rowId:'${rowId}'},
			  	      dataType: 'text',
			  	      success: function(data){
			  	    	    if(!data) return;
			  	    	    //var d = JSON.parse(data);
			  	    	    if(data && data == '0')
			  	    	    {
			  	    	    	$(".myMsgBox").css("display","").html("删除关系成功");
				   	    		$(".myMsgBox").delay(2000).fadeOut();
					    	}
			  	    	    else if (data && data == '1')
			  	    	    {
			  	    	    	$(".myMsgBox").css("display","").html("删除操作成功，部分数据删除失败");
				   	    		$(".myMsgBox").delay(2000).fadeOut();
			  	    	    }
			  	    	    else if (data && data == '1')
			  	    	    {
			  	    	    	$(".myMsgBox").css("display","").html("删除关系失败");
				   	    		$(".myMsgBox").delay(2000).fadeOut();
				   	    		return;
			  	    	    }
			  	    	    
			  	    	  toCustOwner();
			  	      }
			 	});
			}
		}
		else
		{
			$(".myMsgBox").css("display","").html("没有选择任何联系人");
	    	$(".myMsgBox").delay(2000).fadeOut();
		}
		
		return;
	}
    </script>
</head>
<body>
	 <div id="operDiv" class="resource_menu zjwk_fg_nav_2">
		     <a href="javascript:void(0)" onclick='toCustOwner()' style="padding:5px 8px;" class="con_owner">已关联</a>
		    <a href="javascript:void(0)" onclick='toNew()' style="padding:5px 8px; " class="con_new">新增</a>
		    <a href="javascript:void(0)" onclick='toChoose()' style="padding:5px 8px;" class="con_choose">选择</a>
		    <a href="javascript:void(0)" onclick='toDelete()' style="padding:5px 8px;" class="con_del">删除</a>
		</div>
		<div style="width:100%;line-height:50px;background-color:#fff;padding:5px;border-bottom: 1px solid #ddd;text-align:right;padding-right:20px;display:none" id="opArea">
		<a href="javascript:void(0)" class="btn btn-default" onclick="toCancelOp()" style="height: 2em;line-height: 2em;"> 取消</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="javascript:void(0)" class="btn saveBtn" onclick="toSaveRela()" style="height: 2em;line-height: 2em;"> 确定</a>				

	</div>

	 <!-- 搜索区域 -->
	<div style="width:100%;height:50px;line-height:50px;background-color:#fff;padding:5px;">
		<div style="height:44px;padding-top:3px;">
			<img src="<%=path %>/image/searchbtn.png" style="position: absolute;opacity: 0.3;width:30px;margin-left: 5px;">
			<input type="text" value="" placeholder="按名字、电话搜索" name="search" style="border-radius: 10px;font-size: 14px;padding-left:40px;border: 1px solid #ddd;line-height: 30px;"> 
		</div>
	</div>
	
	   <!-- 导航END -->
	   <div id="slider">
		<div class="slider-content" id="div_accnt_list" style="margin-top:5px;margin-bottom:65px;font-size:14px;">
			<ul>
				<c:forEach items="${charList }" var="char1">
					<li id="${char1}" class=""><a name="${char1}" class="title firstname_list">${char1}</a>
						<ul>
							<c:forEach items="${contactList}" var="contact" >
								<c:if test="${contact.firstname eq char1 }">
									
									<li class="contact_list" contactid="${contact.rowid}" conname="${contact.conname}" conmobile="${contact.phonemobile}">
										<c:if test="${contact.type eq 'friend'}">
											<a href="<%=path%>/out/user/card?partyId=${contact.rowid}&flag=RM" onclick="return redirect('${contact.rowid}',this)" style="background-color:#fff;" chooseId='${ contact.rowid}'> 
												<div style="width:100%; background-color:#fff;">
													
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
													<div class="input-radio" title="选择该条记录" id="checkbox_${contact.rowid}" style="float:right;margin-top: -25px;display:none"></div>
												</div>
											
												<div style="clear:both"></div>
											</a>
										</c:if>
										<c:if test="${contact.type ne 'friend'}">
											<a href="<%=path%>/contact/modify?rowId=${contact.rowid}&orgId=${contact.orgId}" onclick="return redirect('${contact.rowid}',this)" style="background-color:#fff;" chooseId='${ contact.rowid}'>
												<div style="width:100%; background-color:#fff;">
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
													<div class="input-radio" title="选择该条记录" id="checkbox_${contact.rowid}" style="float:right;margin-top: -25px;display:none"></div>
												</div>
											
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
	<div class="none nodata" style="position:fixed;width:100%;text-align:center;top: 150px;">没有找到匹配的数据！</div>
	<div class="g-mask none">&nbsp;</div>
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 14px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">&nbsp;</div>
</body>
</html>