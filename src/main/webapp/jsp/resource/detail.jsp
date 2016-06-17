<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	String ossImgPath = "http://" + PropertiesUtil.getAppContext("aliyun.oss.bucket.pic").concat(".").concat(PropertiesUtil.getAppContext("aliyun.oss.endpoint")).concat("/");
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
<link rel="stylesheet" href="<%=path%>/css/style.css" id="style_color" />

<script type="text/javascript">
	jQuery(window).load(function () {  
		$(".imglist").each(function(){
			 var img = new Image();
			 img.src =$(this).attr("src") ;
			 var w = img.width;
			 if(w > $(window).width()){
				   $(this).css("width",$(window).width() - 16);
			 }
		 });  
	});  
	
	$(function(){
		if ($(".contentframe").length != 0)
	     {
			 if ($(window).height()-100 > 480)
			{
				 $(".contentframe").css("height","480px");
			}
			else
			{
				$(".contentframe").css("height",$(window).height()-100);
			}
	     } 
		 
		 $(".openBtn").click(function(){
			 pushToSys();
		 })
		 
		 $(".discuBtn").click(function(){
			 $("form[name=res_discu_form]").submit();
		 })
		 
		 $(".backBtn").click(function(){
			 window.location.href = "<%=path%>/resource/list";
		 })
		 
		 $(".saveBtn").click(function(){
			 saveFromSys();
		 })
		 
		 $(".nextBtn").click(function(){
			 goToNext();
		 })
		 
		 //初始化按钮是否显示
		  initOperatorBtn();
		 
	});
	
	function initOperatorBtn()
	{
		//收藏按钮
		 if('${saveBtn}' == 'true')
		 {
			 $(".saveBtn").css("display","");
		 }
		 else
		 {
			 $(".saveBtn").css("display","none");
		 }
		//回首页按钮
		 if('${backBtn}' == 'true')
		 {
			 $(".backBtn").css("display","");
		 }
		 else
		 {
			 $(".backBtn").css("display","none");
		 }
		//公开推荐按钮
		 if('${openBtn}' == 'true')
		 {
			 $(".openBtn").css("display","");
		 }
		 else
		 {
			 $(".openBtn").css("display","none");
		 }
		//推荐讨论组
		 if('${discuBtn}' == 'true')
		 {
			 $(".discuBtn").css("display","");
		 }
		 else
		 {
			 $(".discuBtn").css("display","none");
		 }
		//下一篇按钮
		 if('${nextBtn}' == 'true')
		 {
			 $(".nextBtn").css("display","");
		 }
		 else
		 {
			 $(".nextBtn").css("display","none");
		 }
		//查看原文按钮
		if('${originBtn}' == 'true')
		 {
			 $(".originBtn").css("display","");
		 }
		 else
		 {
			 $(".originBtn").css("display","none");
		 }
	}
	
	//系统文章下一篇
	function  goToNext()
	{
		if ('${lastFlag}' == 'true')
		{
			$(".myMsgBox").css("display","").html("已经是最后一篇");
    		$(".myMsgBox").delay(2000).fadeOut();
    		return;
		}
		
		$("form[name=res_discu_form]").attr("action","<%=path%>/resource/nextFromSys");
		$("form[name=res_discu_form]").submit();
	}
	
	//删除文章
	function delRes(id)
	{
		$.ajax({
	  	      type: 'post',
	  	      url: '<%=path%>/resource/del',
	  	      data: {id: id, type:'single'},
	  	      dataType: 'text',
	  	      success: function(data){
	  	    	    if(!data) return;
	  	    	    var d = JSON.parse(data);
	  	    	    if(d.errorCode && d.errorCode == '0')
	  	    	    {
	  	    	    	$(".myMsgBox").css("display","").html("删除成功");
		   	    		$(".myMsgBox").delay(2000).fadeOut();
			    	}
	  	    	    else
	  	    	    {
	  	    	    	$(".myMsgBox").css("display","").html("删除失败");
		   	    		$(".myMsgBox").delay(2000).fadeOut();
		   	    		return;
	  	    	    }
	  	    	    
	  	    	    window.location.href = '<%=path%>/resource/list';
	  	      }
	 	});
	}
	
	//公开推荐
	function pushToSys()
	{
		$.ajax({
	  	      type: 'post',
	  	      url: '<%=path%>/resource/pushToSys',
	  	      data: {id: '${resId}'},
	  	      dataType: 'text',
	  	      success: function(data){
	  	    	    if(!data) return;
	  	    	    if(data && data == '0')
	  	    	    {
	  	    	    	$(".myMsgBox").css("display","").html("公开推荐成功");
		   	    		$(".myMsgBox").delay(2000).fadeOut();
			    	}
	  	    	    else if(data && data == '2')
	  	    	    {
	  	    	    	$(".myMsgBox").css("display","").html("文章已被推荐");
		   	    		$(".myMsgBox").delay(2000).fadeOut();
	  	    	    }
	  	    	    else
	  	    	    {
	  	    	    	$(".myMsgBox").css("display","").html("公开推荐失败");
		   	    		$(".myMsgBox").delay(2000).fadeOut();
	  	    	    }
	  	      }
	 	});
	}
	
	//收藏系统文章
	function saveFromSys()
	{
		$.ajax({
	  	      type: 'post',
	  	      url: '<%=path%>/resource/saveFromSys',
	  	      data: {resId: '${resId}'},
	  	      dataType: 'text',
	  	      success: function(data){
	  	    	    if(!data) return;
	  	    	    if(data && data == '0')
	  	    	    {
	  	    	    	$(".myMsgBox").css("display","").html("收藏成功");
		   	    		$(".myMsgBox").delay(2000).fadeOut();
	  	    	    }
	  	    	    else if(data && data == '2')
	  	    	    {
	  	    	    	$(".myMsgBox").css("display","").html("已收藏");
		   	    		$(".myMsgBox").delay(2000).fadeOut();
	  	    	    }
	  	    	    else
	  	    	    {
	  	    	    	$(".myMsgBox").css("display","").html("收藏失败");
		   	    		$(".myMsgBox").delay(2000).fadeOut();
	  	    	    }
	  	      }
	 	});
	}
	
	//点赞
	function praise(){
		var dataObj = [];
		dataObj.push({name:'activityid', value: '${resId}' });
		//dataObj.push({name:'openid', value: '${openId}' });
		dataObj.push({name:'type', value: 'PRAISE' });
		dataObj.push({name:'sourceid', value: '${userId}'});
		//dataObj.push({name:'source', value: '${source}' });
		$("#praise").unbind("click");
		$("#praise").attr("href","");
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/zjwkactivity/savePrint' || '',
				data : dataObj || {},
				dataType : 'text',
				success : function(data) {
					if(!data || data === '-1'){
						$("#myMsgBox").css("display","").html("点赞失败!");
		    	    	$("#myMsgBox").delay(2000).fadeOut();
		    	    	$("#praise").attr("href","javascript:praise();");
					}else{
						var obj=$("#praise_span");
						var count =parseInt('${praiseCount}')+1;
						obj.html("赞("+count+")");
						//var obj1=$("#dt_like_list span").before("<a style='font-size:14px;margin-right:5px;' class='dt_nick'>"+data+"</a>");
						//本地缓存
		     	        sessionStorage.setItem('Resource_'+'${userId}'+"_"+'${resId}'+"_Praise","success_"+count);
					}
				}
			});
	 
 }
</script>

</head>
<body style="background-color:#fff;height:100%;font-family:'Microsoft Yahei';font-size:14px;">
	<div id="site-nav" class="navbar" style="display:none;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;display: block;font-size:16px;-webkit-margin-after: 1em;-webkit-margin-start: 0px;-webkit-margin-end: 0px;font-weight: bold;font-family:'Microsoft Yahei'">指尖微客</h3>
		<a onclick="delRes('${resId}')" class="delRes" style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;margin-top: -65px;float: right;">删除</a> 
	</div>
	<div style="clear: both"></div>
	<div>
   <%-- <c:import url="${resourceUrl }"></c:import> --%>
   <!-- 后台查询 -->
   <c:if test="${resType eq 'img' }">
   		<div class="content" style="margin: 8px;line-height:25px;text-indent: 2em;">
			${res.resourceContent }
		</div>
		<div style="clear: both"></div>
		<div style="width:100%;padding: 5px 8px;">
			<div style="padding-top: 5px; font-size: 8px; color: #fff;" class="imageContaint">
					<c:if test="${fn:length(imgList) >0 }">
						<c:forEach items="${imgList}" var="img">
							<span class="imgspan_${img.id}"><img class="imglist" id="${img.id }" src="<%=ossImgPath %>/${img.source_filename}"></span>
						</c:forEach>
					</c:if>
					<c:if test="${fn:length(imgList) ==0 }">
						  没有图片信息
					</c:if>		
			</div>
		</div>
		
		<!-- 系统内文章点赞 -->
		<div class="title_div" style="font-size: 15px;text-align: center;line-height: 1.4em;padding: 0.5em 0;  background-color: #fff;">
				<span id="read_span" style="padding: 5px;font-size: 14px; opacity: 0.8;">阅读(${res.readnum})</span>
				<span id="praise_span" style="padding: 5px;font-size: 14px; opacity: 0.8;"> 
					<c:if test="${ispraise eq 'true'}"><a href="javascript:praise()" id="praise">赞(${praiseCount})</a></c:if>
					<c:if test="${ispraise ne 'true'}">赞(${praiseCount})</c:if>
				</span>
			</div>
   </c:if>
   <!-- 直接链接 -->
   <c:if test="${resType eq 'link' }">
     <iframe class="contentframe" id="contentframe" src="${resourceUrl }" style="width: 100%;border:0px; "></iframe>
      	<%--    <c:import url="${resourceUrl }" ></c:import> --%>
   </c:if>
   <c:if test="${resType eq 'timg' }">
   	  <c:if test="${res.resourceTitle ne '' && !empty(res.resourceTitle) }">
   	  	  <div style="padding:8px 15px;margin-top:10px;font-size:18px;">${res.resourceTitle }</div>
   	  	  <div style="display:none;padding-left:15px;color:#999;line-height:20px;font-size:14px;">阅读：${res.resourceMark }</div>
   	  </c:if>
      <div class="content" style="margin: 8px;line-height:25px;text-indent: 2em;">
			${res.resourceContent }
	  </div>
	  		
		<!-- 系统内文章点赞 -->
		<div class="title_div" style="font-size: 15px;text-align: center;line-height: 1.4em;padding: 0.5em 0;  background-color: #fff;">
				<span id="read_span" style="padding: 5px;font-size: 14px; opacity: 0.8;">阅读(${res.readnum})</span>
				<span id="praise_span" style="padding: 5px;font-size: 14px; opacity: 0.8;"> 
					<c:if test="${ispraise eq 'true'}"><a href="javascript:praise()" id="praise">赞(${praiseCount})</a></c:if>
					<c:if test="${ispraise ne 'true'}">赞(${praiseCount})</c:if>
				</span>
			</div>
   </c:if>
   
   <!-- 推荐 -->
   <c:if test="${fn:length(sysList) > 0}">
   <div class="sys_div" style="margin-top:2px;padding-bottom:120px;background-color:#fff;border-top:1px solid #ddd;border-bottom:1px solid #ddd;">
      	<div class="zjwk_fg_nav_left">热点文章</div> 
   		<c:forEach items="${sysList }" var="sys">
   			<a href="<%=path%>/resource/detail?id=${sys.resourceId}">
   				<div style="padding:4px 0px;font-size:14px;border-bottom:1px solid #eee;">
   					<c:if test="${sys.createUrl ne '' }">
   						<div style="float:left;"><img src="<%=ossImgPath %>/${sys.createUrl}" width="36px" style="border-radius:5px;"/></div>
   					</c:if>
   					<c:if test="${sys.createUrl eq '' }">
   						<div style="float:left;"><img src="<%=path %>/image/mygroup.png" width="36px" style="border-radius:5px;"/></div>
   					</c:if>
   					<div style="line-height:20px;">【文章】&nbsp;${sys.resourceTitle}</div>
   					<div style="padding-left:45px;line-height:20px;color:#999;">推荐人：${sys.createName}&nbsp;&nbsp;阅读：${sys.readnum}</div>
   				</div>
   			</a>
   			<div style="clear:both;"></div>
   		</c:forEach>
   	</div>
   </c:if>
</div>
<div style="clear:both;"></div>
			<div class="gotop" style="display: none;"  id="gotop">
				<i class="icon icon-arrow-up"></i> 
			</div>
   	<!-- 控制区 -->
	<div class=" flooter" style="border-top: 1px solid #eee;padding:5px;line-height:20px;background-color:#fff;text-align: center">
			<a href="javascript:void(0)" class="btn openBtn"
					style="font-size: 14px;height:2.3em;line-height:2.3em;text-align: center;"> 公开推荐</a>
			<a href="javascript:void(0)" class="btn discuBtn"
					style="font-size: 14px;height:2.3em;line-height:2.3em;text-align: center;"> 推荐到讨论组</a>
			<a href="javascript:void(0)" class="btn backBtn" 
					style="font-size: 14px;height:2.3em;line-height:2.3em; text-align: center;"> 主&nbsp;&nbsp;&nbsp;页</a>
			<a href="javascript:void(0)" class="btn saveBtn" 
					style="font-size: 14px;height:2.3em;line-height:2.3em; text-align: center;"> 收&nbsp;&nbsp;&nbsp;藏</a>
			<a href="javascript:void(0)" class="btn nextBtn" 
					style="font-size: 14px;height:2.3em;line-height:2.3em; text-align: center;"> 下一篇</a>
			<a href="${resourceUrl }#wechat_redirect" class="btn originBtn" 
					style="font-size: 14px;height:2.3em;line-height:2.3em; text-align: center;"> 查看原文</a>		
	</div>
	<!-- 隐藏区域 -->
	<form name="res_discu_form" action="<%=path %>/resource/showDiscu" method="post">
		<input type="hidden" name="resid" value="${resId}">
		<input type="hidden" name="restype" value="${resType}">
		<input type="hidden" name="resurl" value="${resourceUrl}">
		<input type="hidden" name="isSys" value="${isSys}">
		<input type="hidden" name="creator" value="${res.creator}">
	</form>
	<!-- 消息区 -->		
	<%--<jsp:include page="/common/footer.jsp"></jsp:include> --%>
   	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 14px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">&nbsp;</div>
		
		<!-- 文章分享 -->
	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
	    var name = '${res.resourceTitle}';
	    var desc = '${res.resourceContent}';
	    var img = "${res.resourceImg}";
	    if(img){
	    	img = "<%=ossImgPath%>/"+img;
	    }
		wx.ready(function () {
			wxjs_showOptionMenu();
		  var opt = {
			  title : name,
		      desc : desc,
			  link: "${shorturl}",
			  imgUrl: img
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>