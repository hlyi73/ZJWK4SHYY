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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%>
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>

<style>
.nav-normal .nav-item.active{
	background-color:#efefef;
	color:#555;
}

.nav-normal .nav-item.inactive{
	background-color:rgb(130, 221, 205);
	color:#aaa;
}
.navf {
	font-size: 14px;
}
</style>

<script type="text/javascript">
    $(function () {
    	initForm();
    	initButton();
    	$("input[name=currpage]").val('0');
    	topage('${viewtype}');
	});
    
	function initForm(){
		$(".nav-tabs div").click(function() {
			//tab
			$(".nav-tabs div").removeClass("active");
			//切换页签
			$(this).addClass("active");
			var viewtype='';
			if ($(this).hasClass("createListTab")) {
				viewtype='owner';
			} else if ($(this).hasClass("registListTab"))  {
				viewtype='join';
			} else {
				viewtype='shareview';
			}
			$(".createListTab").removeClass("active");
			$(".joinListTab").removeClass("active");
			$(".registListTab").removeClass("active");
			$(".joinListTab").addClass("inactive");
			$(".createListTab").addClass("inactive");
			$(".registListTab").addClass("inactive");
			$(this).addClass("active");
			$(this).removeClass("inactive");
			$(":hidden[name=currpage]").val('0');
			topage(viewtype);
		});
	}
    
    //异步加载活动列表
    function topage(viewtype){
    	$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");
    	$(".nextspan").text('努力加载中...');
		var currpage = $("input[name=currpage]").val();
		
		var dataObj = [];
		dataObj.push({name:'openId', value: '${openId}' });
		dataObj.push({name:'publicId', value: '${publicId}' });
		dataObj.push({name:'currpage', value: currpage});
		dataObj.push({name:'pagecount', value: '10' });
		dataObj.push({name:'viewtype', value: viewtype || 'owner' });
		
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/zjactivity/synclist' || '',
		      data: dataObj || {},
		      dataType: 'text',
		      success: function(data){
		    	  	if(!data && currpage == 0){
		    	  		$("#div_activity_list").empty();
		    	  		$("#div_next").css("display",'none');
		    	  		$("#div_activity_list").append('<div id="nodata" style="text-align: center; padding-top: 50px;">没有找到数据</div>');
		    	  		return;
		    	  	}
		    	  	if(!data&&currpage>=1){
		    	  		$("#div_next").css("display",'none');
		    	  		return;
		    	  	}
		    	    var d = JSON.parse(data);
		    	    var obj1 = $("#div_activity_list").find("#nodata");
		    	    if(obj1){
		    	    	obj1.remove();
		    	    }
		    	    if(currpage==0){
		    	    	$("#div_activity_list").empty();
		    	  		$("#div_next").css("display",'none');
		    	    }
		    	    var val = $("#div_activity_list").html();
					if(d != ""){
		    	    	if($(d).size() == 10){
		    	    		$("#div_next").css("display",'');
		    	    	}else{
		    	    		$("#div_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							if('shareview'==viewtype){
								val += '<a href="<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/activity/detail?openId=${openId}&publicId=${publicId}&id='+this.rowid+'&source=wkshare&sourceid=${partyId}" class="list-group-item" data-rel="popup">';
							}else{
								val += '<a href="<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/activity/detail?openId=${openId}&publicId=${publicId}&id='+this.rowid+'&source=WK&sourceid=${partyId}" class="list-group-item" data-rel="popup">';
							}
							val += '<div class="list-group-item-bd"><div class="thumb">';
							if(this.headImageUrl){
								val += '<img src="'+this.headImageUrl +'" />';
							}else{
								val += '<img src="<%=path %>/image/defailt_person.png" />';
							}
							val += '</div>';
							val += '<div class="content">'
								+ '<h2 class="title">'+this.name+'<span style="float:right;font-size: 10px;font-weight: normal;">'+this.startdate+'</span></h2>'
								+ '<p style="font-size:12px;">'+this.place+'</p>';
// 							if(this.logo){
<%-- 								val += '<p><img src="<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/attachment/download?flag=headImage&fileName='+this.logo+'" width="100%"></p>'; --%>
// 							}else{
<%-- 								val += '<p><img src="<%=path%>/image/default_activity.jpg" width="100%"></p>'; --%>
// 							}
// 							if(this.remark){
// 								if(this.remark.length > 50){
// 									val += '<p style="font-size:12px;line-height:25px;margin-top:5px;">'+this.remark.substring(0,50)+'...';
// 								}else{
// 									val += '<p style="font-size:12px;line-height:25px;margin-top:5px;">'+this.remark+'</p>';
// 								}
// 							}
							val += '<p style="font-size:12px;">'
								+  '<div style="width:100%;height:25px;line-height:25px;font-size:12px;">'
								+  '<div style="width:25%;float:left;text-align:center;">阅读 '+this.readnum +'</div>'
								+  '<div style="width:25%;float:left;text-align:center;">赞 '+this.praisenum+'</div>'
								+  '<div style="width:25%;float:left;text-align:center;">转发 '+this.forwardnum +'</div>'
								+  '<div style="width:25%;float:left;text-align:center;">参与 '+this.joinnum +'</div>'
								+  '</div></p></div></div></a>';
						});
						} else {
							$("#div_next").css("display", 'none');
						}
						$("#div_activity_list").html(val);
						$("input[name=currpage]").val(parseInt(currpage) + 1);
						$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
						$(".nextspan").text('下一页');
					}
				});
	}
    
    //初始化增加按钮
    function initButton(){
    	var source = isWeiXin();
    	$(".addActivity").click(function(){
    		if('mobile'==source){//微信内置浏览器
	    		window.location.href = "<%=path%>/operorg/list?openId=${openId}&publicId=${publicId}&redirectUrl=" + encodeURIComponent('<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/activity/get?openId=${openId}&publicId=${publicId}&source=WK&sourceid=${partyId}&return_url=<%=PropertiesUtil.getAppContext("app.content")%>/zjactivity/add');
    		}else if('windows'==source){//pc端浏览器
    			window.location.href = "<%=path%>/operorg/list?openId=${openId}&publicId=${publicId}&redirectUrl=" + encodeURIComponent('<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/activity/get?openId=${openId}&publicId=${publicId}&source=PC&sourceid=${partyId}&return_url=<%=PropertiesUtil.getAppContext("app.content")%>/zjactivity/add');
    		}
    	});
    }
    
    //判断浏览器客户端为移动端还是PC端
    function isWeiXin(){
    	var source = "";
    	var sUserAgent = navigator.userAgent.toLowerCase();
        var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
        var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
        var bIsMidp = sUserAgent.match(/midp/i) == "midp";
        var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
        var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
        var bIsAndroid = sUserAgent.match(/android/i) == "android";
        var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
        var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
        if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {//如果是上述设备就会以手机域名打开
        	source = "mobile";
        }else{//否则就是电脑域名打开
        	source = "windows";
        }
        return source;
    }
    
    //判断是否是微信内置浏览器
//     function isWeiXin(){ 
//     	var ua = window.navigator.userAgent.toLowerCase(); 
//     	if(ua.match(/MicroMessenger/i) == 'micromessenger'){ 
// 	    	return true; 
// 	    }else{ 
// 	    	return false; 
// 	   	} 
//     } 
</script>

</head>
<body>
	<div id="site-nav" class="navbar" style="z-index: 0;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="act-secondary">
			<a class="addActivity" href="javascript:void(0)" style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a> 
		</div>
	</div>
	<div class="nav nav-tabs nav-normal navf" style="margin-top:-42px;padding:0px 80px 0px 60px;">
		<div class="nav-item active createListTab" style="cursor:pointer;width:33%;border-radius: 10px 0px 0px 10px;height:35px;line-height:35px;border-right:1px solid RGB(75, 192, 171);">
			我的
		</div>
		<div id="bbsTab" class="nav-item inactive registListTab" style="cursor:pointer;width:33%;height:35px;line-height:35px;border-right:1px solid RGB(75, 192, 171);">
			报名的 
		</div>
		<div class="nav-item inactive joinListTab" style="cursor:pointer;width:33%;border-radius: 0px 10px 10px 0px;height:35px;line-height:35px;">
			参加的
		</div>
	</div>
	
	<input type="hidden" name="currpage" value="0" /> 
	
	<div class="site-recommend-list listContainer">
		<div class="list-group listview" id="div_activity_list">
		</div>
		<div class="nextpage" id="div_next" >
			<a href="javascript:void(0)" onclick="topage('${viewtype}')">
				<span class="nextspan">下一页</span>&nbsp;<img id="nextpage" src="<%=path %>/image/nextpage.png" width="24px"/>
			</a>
		</div>
	</div>
	<div style="float:both;"></div>
	<c:if test="${fn:length(recommendList) > 0}">
		<div style="margin: 0px 10px 10px 20px;padding-bottom: 10px;font-size: 16px;border-bottom: 1px solid #ddd;color: black;">推荐</div>
		<!-- 推荐的活动列表 -->
		<div class="site-recommend-list listContainer1">
			<div class="list-group listview" id="div_activity_list1">
				<c:forEach var="act" items="${recommendList}">
				<a href="<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/activity/detail?id=${act.rowid}&source=wkshare&sourceid=${partyId}" class="list-group-item" data-rel="popup">
					<div class="list-group-item-bd">
						<div class="thumb">
							<c:if test="${act.headImageUrl eq ''}">
								<img src="<%=path %>/image/defailt_person.png" />
							</c:if>
							<c:if test="${act.headImageUrl ne ''}">
								<img src="${act.headImageUrl}">
							</c:if>
						</div>
					<div class="content">
						<h2 class="title"> 
							${act.name}
							<span style="float:right;font-size: 10px;font-weight: normal;">${act.startdate }</span>
						</h2>
						<p style="font-size:12px;">${act.place}</p>
<%-- 						<c:if test="${act.logo ne ''}"> --%>
<%-- 							<p><img src="<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/attachment/download?flag=headImage&fileName=${act.logo}" width="100%"></p> --%>
<%-- 						</c:if> --%>
<%-- 						<c:if test="${act.logo eq ''}"> --%>
<%-- 							<p><img src="<%=path%>/image/default_activity.jpg" width="100%"></p> --%>
<%-- 						</c:if> --%>
						<p style="font-size:12px;line-height:25px;margin-top:5px;">
							${act.remark}
						</p>
						<p style="font-size:12px;"></p>
							<div style="width:100%;height:25px;line-height:25px;font-size:12px;">
								<div style="width:25%;float:left;text-align:center;">阅读 ${act.readnum}</div>
								<div style="width:25%;float:left;text-align:center;">赞 ${act.praisenum}</div>
								<div style="width:25%;float:left;text-align:center;">转发 ${act.forwardnum}</div>
								<div style="width:25%;float:left;text-align:center;">参与 ${act.joinnum}</div>
							</div>
						<p></p>
						</div>
						</div>
					</a>
				</c:forEach>
			</div>
		</div>
	</c:if>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>