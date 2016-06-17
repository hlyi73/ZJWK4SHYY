<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
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
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />

<script type="text/javascript">
	//初始化
	$(function(){
		  $(".resourceUrlList").click(function(){
			    var url = $(this).attr("resourceUrl");
			    var id = $(this).attr("id");
			    var type = $(this).attr("resourceType");
			    var isSys = $(this).attr("isSys");
			    $(":hidden[name=resurl]").val(url);
			    $(":hidden[name=id]").val(id);
			    $(":hidden[name=restype]").val(type);
			    $(":hidden[name=isSys]").val(isSys);
			    $("form[name=resourceForm]").submit();
		  });
		  
		  //如果没有图片内容则直接将描述居左显示
		  $(".myContent").each(function(){
			  var imgs = $(this).parent().find("img");
			  if (imgs && imgs.length>0)
			  {
				  $(this).css("padding-left","100");
			  }
			  else
			  {
				  $(this).css("padding-left","0");
			  } 
		  });
		  $(".sysContent").each(function(){
			  var imgs = $(this).parent().find("img");
			  if (imgs && imgs.length>0)
			  {
				  $(this).css("padding-left","100");
			  }
			  else
			  {
				  $(this).css("padding-left","0");
			  } 
		  });
	});
	
	//搜索符合条件的资料
	function searchResource()
	{
		var searchContent = $("input[name=search]").val();
		 $(":hidden[name=resourceInfo3]").val(searchContent);
		 $("form[name=resourceForm]").attr("action","<%=path%>/resource/syslist");
		 $("form[name=resourceForm]").submit();
	}
	
	function searchRes(){
		if($(".mysearch").hasClass("modal")){
			$(".mysearch").removeClass("modal");
			$("#resContaint").addClass("none");
		}else{
			$(".mysearch").addClass("modal");
			$("#resContaint").removeClass("none");
		}
		$(".g-mask").addClass("none");
		$("#resContaint").css("opacity","1");
		$("#opArea").css("display","");
	}
	
	function getMore(currpage)
	{
		$(":hidden[name=currpage]").val(currpage+1);
		$("form[name=resourceForm]").attr("action","<%=path%>/resource/syslist");
		$("form[name=resourceForm]").submit();
	}
	
</script>
<style>
.dropdown-menu-group {
	font-size: 14px;
	position: fixed;
	width: 150px;
	right: 2px;
	left: 50%;
	top: 50%;
	text-align: left;
	z-index: 999;
	height:183px;
	margin: -150px 0px 0px -75px;
	line-height: 45px;
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
</head>
<body style="font-size:14px;">
		<div id="site-nav" class="navbar none" ></div>
		<!-- 搜索区域 -->
		<div style="width:100%;line-height:50px;background-color:#F9F7F7;border-bottom:1px solid #ddd;padding-top:5px;" id="opArea">
			<div style="height:36px;padding-top:3px;margin-right: 55px;padding-left:5px;margin-bottom: 5px;" class="mysearch"> 
				<img src="<%=path %>/image/searchbtn.png" style="position: absolute;opacity: 0.5;width:30px;margin-left: 5px;right:15px" onclick="searchResource()">
				<input type="text"  value="" placeholder="按标题、描述" name="search" style="border-radius: 10px;font-size: 14px;padding-left:10px;border: 1px solid #ddd;line-height: 30px;">
			</div>
		</div>
		<div style="clear: both"></div>
		<form name="resourceForm" action="<%=path%>/resource/detail" method="post">
			<input type="hidden" name="resurl" value="">
			<input type="hidden" name="restype" value="">
			<input type="hidden" name="id" value="">
			<input type="hidden" name="resourceInfo3" value="">
			<input type="hidden" name="currpage" value="">
			<input type="hidden" name="isSys" value="">
			<input type="hidden" name="sysIdList" value="">
		</form>
		<!-- 系统推荐 -->
		<div style="width:100%;" id="resContaint">
			<c:if test="${fn:length(sysList) >0 }">
			<c:forEach items="${sysList}" var="res" varStatus="sysIndex">
				<c:if test="${sysIndex.index == 15}">
					<div id="more_sys_praise" style="float: inherit;display: initial;line-height: 28px;"><a href="javascript:void(0)" style="float: right;margin-right: 10px;"
						onclick='getMore(${currpage})'>更多文章 ></a></div>
					<div id="more_list_sys_praise" style="display: none;float: inherit;">
				</c:if>
				<c:if test="${sysIndex.index < 15}">
					<a href="javascript:void(0)"  resourceUrl="${res.resourceUrl}" resourceType="${res.resourceType }" class="resourceUrlList" id="${res.resourceId}" isSys="1">
						<div class="resource_list_div" style="padding:0px 8px;min-height:50px;background-color:#fff;margin-top:5px;">
							<c:if test="${res.resourceImg ne '' && !empty(res.resourceImg) }">
								<div style="float:left;width:85px;padding:5px;">
									<div style="background:url(${filepath }/${res.resourceImg}) no-repeat;height:70px;width:70px;background-size: cover;"></div>
								</div>
								<div>
									<div style="font-size:16px;padding:0 10px;min-height:50px;line-height:25px;text-align:left;" id="${res.resourceId}_topic">
										<div class="massgouxuanbtn check-radio" style="float: right;margin: 10px 10px 10px 20px;" rowid="${res.resourceId}"></div>
										<c:if test="${fn:length(res.resourceTitle) > 40}">
											${fn:substring(res.resourceTitle,0,40)}...
										</c:if>
										<c:if test="${fn:length(res.resourceTitle) <= 40}">
											${res.resourceTitle}
										</c:if>
									</div>
									<div style="font-size: 10px;color: #AAA;padding-left:10px;">
										<div style="float:right;line-height:25px;padding-right:10px;color:#AAA;"><fmt:formatDate value="${res.resourceCreateDate}" type="date"/></div>
										<div style="float:left;min-height: 25px;line-height: 25px;padding:0px 8px;text-align:left;">
										   推荐人：<a href="<%=path %>/businesscard/detail?partyId=${res.creator }">${res.createName }</a>
											&nbsp;&nbsp;&nbsp;&nbsp;阅读&nbsp;&nbsp;${res.readnum }
										</div>
									</div>
								</div>
							</c:if>	
							<c:if test="${res.resourceImg eq '' || empty(res.resourceImg) }">
								<div style="float:left;width:85px;padding:5px;">
									<img src="<%=path%>/image/noneimg.jpg"  width="70px" height="70px" />
								</div>
								<div>
									<div style="font-size:16px;padding:0px 10px;min-height:40px;line-height:25px;text-align:left;" id="${res.resourceId}_topic">
										<div class="massgouxuanbtn check-radio" style="float: right;margin: 10px 10px 10px 20px;" rowid="${res.resourceId}"></div>
										<c:if test="${fn:length(res.resourceTitle) > 40}">
											${fn:substring(res.resourceTitle,0,40)}...
										</c:if>
										<c:if test="${fn:length(res.resourceTitle) <= 40}">
											${res.resourceTitle}
										</c:if>
									</div>
									<div style="font-size: 10px;color: #AAA;">
										<div style="float:right;line-height:25px;padding-right:10px;color:#AAA;"><fmt:formatDate value="${res.resourceCreateDate}" type="date"/></div>
										<div style="float:left;min-height: 25px;line-height: 25px;padding:0px 8px;text-align:left;">
										推荐人：<a href="<%=path %>/businesscard/detail?partyId=${res.creator }">${res.createName }</a>
											&nbsp;&nbsp;&nbsp;&nbsp;阅读&nbsp;&nbsp;${res.readnum }
										</div>
									</div>
								</div>
							</c:if>
							<div style="clear:both;"></div>
							<div style="height: 1px;background-color:#F6F6F6;"></div> 
						<%-- <div style="margin: 0px -10px 0px 0px;">
						       		<img src="${filepath}/${sys_res.createUrl}" style="width:70px;padding:10px;float:left;">
						       </div>
						<div style="width:100%;padding: 5px 5px 5px 5px;">
							<div style="float:right;"><fmt:formatDate value="${sys_res.resourceCreateDate}" type="date"/></div>
							<div style="font-weight:bold;padding: 0px 70px 0px 0px;text-align: left;letter-spacing: 1px;word-spacing: 1px;" class="title">
								${sys_res.resourceTitle } 
								<c:if test="${sysIndex.index < 5}">
									<img src="<%=path %>/image/hot.png">
								</c:if>
							</div>
						</div>
						<div style="clear: both"></div>
						<div style="width:100%;min-height: 70px;" id="${sys_res.resourceId}_topic">
							<div style="margin-left: 50px;margin-right: 5px;line-height: 1.7em;text-align: justify;margin-top: -10px;" id="${sys_res.resourceId}" class="myContent">
								<c:if test="${fn:length(sys_res.resourceContent) >60 }">
									${fn:substring(sys_res.resourceContent,0,58)}...
								</c:if>
								<c:if test="${fn:length(sys_res.resourceContent) <=60 }">
									${sys_res.resourceContent }
								</c:if>
							</div>
						</div>
						<div style="margin-bottom: 8px;">
							<div style="float:right;padding-right:10px;line-height: 10px"><img src="<%=path %>/image/readimg.png" style="width: 15px;margin-bottom: 3px;">&nbsp;&nbsp;${sys_res.readnum }</div>
							<div><font color="brown">推荐人：</font><a href="<%=path %>/businesscard/detail?partyId=${sys_res.creator }">${sys_res.createName }</a></div>
						</div> --%>
					</div>
					</a>
				</c:if>
				<div style="clear: both"></div>
			</c:forEach>
			</c:if>
			<c:if test="${fn:length(sysList) ==0 }">
				<div style="text-align: center; padding-top: 50px;font-size:14px;color:#999;">没有找到数据</div>
			</c:if>
		</div>
	<div class="g-mask none">&nbsp;</div>
	<%-- <jsp:include page="/common/footer.jsp"></jsp:include> --%>
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 14px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">&nbsp;</div>
</body>
</html>