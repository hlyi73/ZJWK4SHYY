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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/hcharts/highcharts.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />
<style type="text/css">
* {
	margin: 0;
	padding: 0;
}

/* .wrapper {
	width:700px;
	margin:0 auto;
	padding-bottom:50px;
} 
 */
/* analytics */
#analytics {
	left: 0px;
	width: 700px;
	min-height: 400px;
	overflow: hidden;
	position: relative;
	margin: 8px;
}

#analytics ul {
	height: 380px;
	position: absolute;
}

#analytics ul li {
	float: left;
	width: 700px;
	min-height: 400px;
	overflow: hidden;
}

#analytics .pre {
	left: 0;
}

#analytics .next {
	right: 0;
	background-position: right top;
}

#analytics .preNext {
	width: 25px;
	height: 50px;
	position: absolute;
	top: 140px;
	cursor: pointer;
	background: url('<%=path%>/image/sprite.gif') no-repeat 0 0;
}

.active {
	border-bottom: 1px solid #AAD1FD;
	opacity: 1;
    border-width: 3px;
			
}
.unactive {
	opacity: 0.5;
    border-width: 1px;
			
}
</style>

<script type="text/javascript">
$(function () {
	 initBtn();
	 //initShareUserData();
	 userChartData();
	 initInnerUser();
})
function userChartData(){
		asyncInvoke({
			url: '<%=path%>/calendar/firstCharlist',
			async: 'false',
			data: {
			   openId: '${openId}'
			},
		    callBackFunc: function(data){
		    	if(!data) return;
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	$(".myMsgBox").delay(2000).fadeOut();
		    	   return;
		    	}
	    	    var ahtml = '';
	    	    $(d).each(function(i){
	    	    	ahtml += '<a href="javascript:void(0)"  style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
	    	    });
	    	    $(".chartList").html(ahtml);
	    	    
	    	    //点击字母
	    			$(".chartList").find("a").unbind("click").bind("click", function(event){
	    			$("#fstChar").val($(this).html());
	    			 initInnerUser();
	    		}); 
		    }
		});
		
	}
function friendChartData(){
	asyncInvoke({
		url: '<%=path%>/calendar/friendFirstCharlist',
		async: 'false',
		data: {
		   openId: '${openId}'
		},
	    callBackFunc: function(data){
	    	if(!data) return;
    	    var d = JSON.parse(data);
    	    if(d.errorCode && d.errorCode !== '0'){
    	    	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	   return;
	    	}
    	    var ahtml = '';
    	    $(d).each(function(i){
    	    	ahtml += '<a href="javascript:void(0)"  style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
    	    });
    	    $(".friendChartList").html(ahtml);
    	    
    	    //点击字母
    			$(".friendChartList").find("a").unbind("click").bind("click", function(event){
    			$("#fstChar").val($(this).html());
    			initFriend();
    		}); 
	    }
	});
	
}	
	
function initInnerUser(){
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/calendar/innerUserList',
	      data: {openId:'${openId}',firstChar:$("#fstChar").val()},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    var ahtml = '';
	    	    $(d).each(function(i){
	    	    	var headImage='<%=path%>/image/defailt_person.png'
	    	    	ahtml += '<div style="padding-bottom:5px; border-bottom: 1px solid #DBD9D9;">';
	    	    	ahtml +='<div class="teamPeason" style="float:left;width:65px;">';
	    	    	ahtml +='<div style="text-align: center;">';
	    	    	if(this.headImage!=''){
	    	    		headImage=this.headImage;
	    	    	}
	    	    	ahtml +='<img src="'+headImage+'" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">';
	    	    	ahtml +='</div></div>';
	    	    	ahtml +='<div style="padding-left:70px;">';
	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">'+this.opName+'&nbsp;&nbsp;</div>';
	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">公司/职位：'+this.opCompany+'&nbsp;/&nbsp;'+this.opDuty;	
	    	    	if(this.rssId==''){
	    	    		ahtml +='<span  id="sync-span-'+this.openId+'" style="color: #bdbdbd;float: right;font-size: 12px; margin-right: 20px;" onclick="javascript:subFeed(\''+this.openId+'\',\''+this.opName+'\',\'user\')" >';
	    	    		ahtml +='<a href="javascript:void(0)">订阅</a></span>';
	    	    	}else{
	    	    		ahtml +='<span  id="sync-span-'+this.openId+'" style="color: #bdbdbd;float: right;font-size: 12px; margin-right: 20px;" >';
	    	    		ahtml +='已订阅</span>';
	    	    	}    	    	
	    	    	ahtml+='</div></div></div><div style="clear:both;border-bottom:1px solid #efefef"></div>';	
	    	    });
	    	    $("#userlist").html(ahtml);
	      }
	 });
}

function initFriend(){
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/calendar/friendList',
	      data: {openId:'${openId}',firstChar:$("#fstChar").val()},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    var ahtml = '';
	    	    $(d).each(function(i){
	    	    	var headImage='<%=path%>/image/defailt_person.png'
	    	    	ahtml += '<div style="padding-bottom:5px; border-bottom: 1px solid #DBD9D9;">';
	    	    	ahtml +='<div class="teamPeason" style="float:left;width:65px;">';
	    	    	ahtml +='<div style="text-align: center;">';
	    	    	if(this.headimgurl!=''){
	    	    		headImage=this.headimgurl;
	    	    	}
	    	    	ahtml +='<img src="'+headImage+'" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">';
	    	    	ahtml +='</div></div>';
	    	    	ahtml +='<div style="padding-left:70px;">';
	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">'+this.nickname+'&nbsp;&nbsp;</div>';
	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">省/市：'+this.province+'&nbsp;/&nbsp;'+this.city;	
	    	    	if(this.rssId==''){
	    	    		ahtml +='<span  id="sync-span-'+this.openId+'" style="color: #bdbdbd;float: right;font-size: 12px; margin-right: 20px;" onclick="javascript:subFeed(\''+this.openId+'\',\''+this.nickname+'\',\'friend\')" >';
	    	    		ahtml +='<a href="javascript:void(0)">订阅</a></span>';
	    	    	}else{
	    	    		ahtml +='<span  id="sync-span-'+this.openId+'" style="color: #bdbdbd;float: right;font-size: 12px; margin-right: 20px;" >';
	    	    		ahtml +='已订阅</span>';
	    	    	}    	    	
	    	    	ahtml+='</div></div></div><div style="clear:both;border-bottom:1px solid #efefef"></div>';	
	    	    });
	    	    $("#friendlist").html(ahtml);
	      }
	 });
}


function initGroup(){
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/calendar/groupList',
	      data: {openId:'${openId}'},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    var ahtml = '';
	    	    $(d).each(function(i){
	    	  	    	var headImage='<%=path%>/image/mygroup.png'
	    	    	    	ahtml += '<div style="padding-bottom:5px; border-bottom: 1px solid #DBD9D9;">';
	    	    	    	ahtml +='<div class="teamPeason" style="float:left;width:65px;">';
	    	    	    	ahtml +='<div style="text-align: center;">';
	    	    	    	if(this.logo!=''){
	    	    	    		headImage=this.logo;
	    	    	    	}
	    	    	    	ahtml +='<img src="'+headImage+'" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">';
	    	    	    	ahtml +='</div></div>';
	    	    	    	ahtml +='<div style="padding-left:70px;">';
	    	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">&nbsp;&nbsp;</div>';
	    	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">'+this.name;	
	    	    	    	if(this.rssId==''){
	    	    	    		ahtml +='<span  id="sync-span-'+this.id+'" style="color: #bdbdbd;float: right;font-size: 12px; margin-right: 20px;" onclick="javascript:subFeed(\''+this.id+'\',\''+this.name+'\',\'group\')" >';
	    	    	    		ahtml +='<a href="javascript:void(0)">订阅</a></span>';
	    	    	    	}else{
	    	    	    		ahtml +='<span  id="sync-span-'+this.id+'" style="color: #bdbdbd;float: right;font-size: 12px; margin-right: 20px;" >';
	    	    	    		ahtml +='已订阅</span>';
	    	    	    	}    	    	
	    	    	    	ahtml+='</div></div></div><div style="clear:both;border-bottom:1px solid #efefef"></div>';	
	    	    });
	    	    $("#activitylist").html(ahtml);
	      }
	 });
}

function initRssUser(){
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/calendar/rssUserList',
	      data: {openId:'${openId}',type:'user'},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var k=0;
	    	    var d = JSON.parse(data);
	    	    var ahtml = '<div style="text-align:center;"><h1>系统用户</h1><p style="border-top: 1px solid #ddd"></p></div>';
	    	    $(d).each(function(i){
	    	    	var headImage='<%=path%>/image/defailt_person.png'
	    	    	ahtml += '<div style="padding-bottom:5px; border-bottom: 1px solid #DBD9D9;"  class="rssUser" id="rss_div_'+this.rssId+'">';
	    	    	ahtml +='<div class="teamPeason" style="float:left;width:65px;">';
	    	    	ahtml +='<div style="text-align: center;">';
	    	    	if(this.headImage!=''){
	    	    		headImage=this.headImage;
	    	    	}
	    	    	ahtml +='<img src="'+headImage+'" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">';
	    	    	ahtml +='</div></div>';
	    	    	ahtml +='<div style="padding-left:70px;">';
	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">'+this.opName+'${user.opName}&nbsp;&nbsp;</div>';
	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">公司/职位：'+this.opCompany+'&nbsp;/&nbsp;'+this.opDuty;	
	    	    	ahtml +='<span  id="sync-span-'+this.rssId+'" style="color: #bdbdbd;float: right;font-size: 12px; margin-right: 20px;" onclick="javascript:cancelRss(\''+this.rssId+'\')" >';
	    	    	ahtml +='<a href="javascript:void(0)">取消订阅</a></span>';
	   	    	
	    	    	ahtml+='</div></div><div style="clear:both;border-bottom:1px solid #efefef"></div></div>';	
	    	      	k++;
	    	    });
	    	    if(k>0){
	    	    $("#rsslist").append(ahtml);
	      		}
	    	    initRssFriend();
	      }
	 });
}

function initRssFriend(){
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/calendar/rssFriendList',
	      data: {openId:'${openId}',type:'friend'},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    var k=0;
	    	    var ahtml = '<div style="text-align:center;margin-top:10px" id="rssFriendList"><h1>好友用户</h1><p style="border-top: 1px solid #ddd"></p></div>';
	    	    $(d).each(function(i){
	    	    	var headImage='<%=path%>/image/defailt_person.png'
	    	    	ahtml += '<div style="padding-bottom:5px; border-bottom: 1px solid #DBD9D9;" class="rssFriend"  id="rss_div_'+this.rssId+'">';
	    	    	ahtml +='<div class="teamPeason" style="float:left;width:65px;">';
	    	    	ahtml +='<div style="text-align: center;">';
	    	    	if(this.headimgurl!=''){
	    	    		headImage=this.headimgurl;
	    	    	}
	    	    	ahtml +='<img src="'+headImage+'" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">';
	    	    	ahtml +='</div></div>';
	    	    	ahtml +='<div style="padding-left:70px;">';
	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">'+this.nickname+'${user.opName}&nbsp;&nbsp;</div>';
	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">省/市：'+this.province+'&nbsp;/&nbsp;'+this.city;	
	    	    	ahtml +='<span  id="sync-span-'+this.rssId+'" style="color: #bdbdbd;float: right;font-size: 12px; margin-right: 20px;" onclick="javascript:cancelRss(\''+this.rssId+'\')" >';
	    	    	ahtml +='<a href="javascript:void(0)">取消订阅</a></span>';
	   	    	
	    	    	ahtml+='</div></div><div style="clear:both;border-bottom:1px solid #efefef"></div></div>';	
	    	      	k++;
	    	    });
	    	    if(k>0){
	    	    $("#rsslist").append(ahtml);
	      		}
	    	    initRssGrpoup();
	      }
	 });
}
function initRssGrpoup(){
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/calendar/rssGroupList',
	      data: {openId:'${openId}',type:'group'},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    var k=0;
	    	    var ahtml = '<div style="text-align:center;margin-top:10px" id="rssGroupList"><h1>群</h1><p style="border-top: 1px solid #ddd"></p></div>';
	    	    $(d).each(function(i){
	    	    	ahtml += '<div style="padding-bottom:5px; border-bottom: 1px solid #DBD9D9;" class="rssGroup"  id="rss_div_'+this.id+'">';
	    	    	ahtml +='<div class="teamPeason" style="float:left;width:65px;">';
	    	    	ahtml +='<div style="text-align: center;">';
	    	    	ahtml +='<img src="<%=path%>/image/mygroup.png" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">';
	    	    	ahtml +='</div></div>';
	    	    	ahtml +='<div style="padding-left:70px;">';
	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">&nbsp;&nbsp;</div>';
	    	    	ahtml +='<div style="margin-top: 10px;line-height:20px;height:20px;">'+this.name;
	    	    	ahtml +='<span  id="sync-span-'+this.id+'" style="color: #bdbdbd;float: right;font-size: 12px; margin-right: 20px;" onclick="javascript:cancelRss(\''+this.id+'\')" >';
	    	    	ahtml +='<a href="javascript:void(0)">取消订阅</a></span>';
	   	    	
	    	    	ahtml+='</div></div><div style="clear:both;border-bottom:1px solid #efefef"></div></div>';	
	    	    	k++;
	    	    });
	    	    if(k>0){
	    	    $("#rsslist").append(ahtml);
	      		}
	      }
	 });
}
function initBtn(){
	//TAB页切换
	$("#toptab").find("div").click(function(){
		$(this).siblings().removeClass("active");
		$(this).siblings().addClass("unactive");
		$(this).removeClass("unactive");
		$(this).addClass("active");
		if($(this).hasClass("user")){
			$("#fstChar").val('');
			$(".chartList").css("display", "");
			$("#userlist").css("display", "");
			$("#rsslist").css("display", "none");
			$("#friendlist").css("display", "none");
			$(".friendChartList").css("display", "none");
			$("#activitylist").css("display", "none");
			 userChartData();
			 initInnerUser();
		}
		if($(this).hasClass("friend")){
			$("#fstChar").val('');
			$(".chartList").css("display", "none");
			$("#userlist").css("display", "none");
			$("#rsslist").css("display", "none");
			$("#friendlist").css("display", "");
			$(".friendChartList").css("display", "");
			$("#activitylist").css("display", "none");
			friendChartData();
			initFriend();
		}
		if($(this).hasClass("activity")){
			$(".chartList").css("display", "none");
			$(".friendChartList").css("display", "none");
			$("#userlist").css("display", "none");
			$("#rsslist").css("display", "none");
			$("#friendlist").css("display", "none");
			$("#activitylist").css("display", "");
			initGroup();
		}
		if($(this).hasClass("rss")){
			$(".chartList").css("display", "none");
			$("#userlist").css("display", "none");
			$("#rsslist").css("display", "");
			$("#friendlist").css("display", "none");
			$(".friendChartList").css("display", "none");
			$("#activitylist").css("display", "none");
		    $("#rsslist").html('');
			initRssUser();
		}
	});
	
	
}
function cancelRss(rowId){
	var obj = $("#rss_div_"+rowId);
	var dataObj = [];
	dataObj.push({name:'openId',value:'${openId}'});
	dataObj.push({name:'id',value:rowId});
	$.ajax({
    	url: '<%=path%>/calendar/cancelRss',
    	type: 'post',
    	data: dataObj,
    	dataType: 'text',
    	success: function(data){
    	  	if(!data){
    	  		return;
    	  	} 
    	  	var d = JSON.parse(data);
    	  	if(d.errorCode && d.errorCode !== '0'){
    	  		$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	  		$(".myMsgBox").delay(2000).fadeOut();
	       	  	return;
	        }else{
	        	$(".myMsgBox").css("display","") .html("取消成功");
    	  		$(".myMsgBox").delay(2000).fadeOut();
    	  		var prevObj=obj.prev();
    	  		var nextObj=obj.next();
    	  		if(nextObj.attr("class")!=obj.attr("class")&&prevObj.attr("class")!=obj.attr("class")){
    	  			prevObj.remove();
    	  		}
    	  		obj.remove();
			 
	        }
    	}
    });
		
}

//订阅
function subFeed(rssId,name,type){
	var obj = $("#sync-span-"+rssId);
	var dataObj = [];
	dataObj.push({name:'openId',value:'${openId}'});
	dataObj.push({name:'rssId',value:rssId});
	dataObj.push({name:'type',value:type});
	dataObj.push({name:'name',value:name});
	$.ajax({
    	url: '<%=path%>/calendar/saveRss',
    	type: 'post',
    	data: dataObj,
    	dataType: 'text',
    	success: function(data){
    	  	if(!data){
    	  		return;
    	  	} 
    	  	var d = JSON.parse(data);
    	  	if(d.errorCode && d.errorCode !== '0'){
    	  		$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	  		$(".myMsgBox").delay(2000).fadeOut();
	       	  	return;
	        }else{
	        	obj.html("已订阅");
		    	//添加取消绑定事件
			   obj.unbind("click").bind("click",function(){
			    	//cancelSubFeed(d.rowId);
			    });
	        }
    	}
    });
}
</script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include><h3
			style="padding-right: 30px;">订阅</h3>
	</div>
	<!-- 下拉菜单选项 end -->

	<div style="clear: both"></div>
	<div class="site-recommend-list page-patch acclist">

		<div id="toptab"
			style="width: 100%; text-align: center; background-color: #fff; height: 40px; line-height: 40px; border-bottom: 1px solid #DBD9D9;">
			<div
				style="float: left; width: 25%; border-right: 1px solid #eee; cursor: pointer;"
				class="active user">公开日程</div>
			<div
				style="float: left; width: 25%; border-right: 1px solid #eee; cursor: pointer;"
				class="unactive friend">好友日程</div>
			<div
				style="float: left; width: 25%; border-right: 1px solid #eee; cursor: pointer;"
				class="unactive activity">群活动</div>
			<div style="float: left; width: 25%; cursor: pointer;" class="unactive rss">
				已订阅</div>
		</div>
		<div style="clear: both;"></div>
		<!-- 查询区域End -->
 			<input type="hidden" name="fstChar" id="fstChar"/>
		<!-- 字母区域 -->
		<div class="list-group-item listview-item radio chartList"
			style="background: #fff; padding: 10px; line-height: 30px;">
			<div
				style="font-size: 16px; line-height: 40px; word-wrap: break-word; word-break: break-all; font-family: 'Microsoft YaHei';">
				<span class="chartListSpan"></span>
			</div>
		</div>
		<div class="list-group-item listview-item radio friendChartList"
			style="background: #fff; padding: 10px; line-height: 30px;display:none;">
			<div
				style="font-size: 16px; line-height: 40px; word-wrap: break-word; word-break: break-all; font-family: 'Microsoft YaHei';">
				<span class="friendChartListSpan"></span>
			</div>
		</div>
		<div class="list-group listview" id="userlist">
				<!-- <div class="alert-info text-center "
				style="padding: 2em 0; margin: 3em 0">无数据</div> -->
		</div>
		<div class="list-group listview" id="friendlist" style="display:none">
<!-- 			<div class="alert-info text-center "
				style="padding: 2em 0; margin: 3em 0">无数据</div> -->
		</div>
		<div class="list-group listview" id="activitylist" style="display:none">
		<!-- <div class="alert-info text-center "
				style="padding: 2em 0; margin: 3em 0">无数据</div> -->
		</div>
		<div class="list-group listview" id="rsslist" style="display:none">
		<!-- <div class="alert-info text-center "
				style="padding: 2em 0; margin: 3em 0">无数据</div> -->
		</div>
		<%-- 	<c:if test="${fn:length(accList)==10 }">
			<div
				style="width: 100% auto; text-align: center; background-color: #fff; margin: 8px; padding: 8px; border: 1px solid #ddd;"
				id="div_next">
				<a href="javascript:void(0)" onclick="topage()"> 下一页&nbsp;<img
					id="nextpage" src="<%=path%>/image/nextpage.png" width="24px" />
				</a>
			</div>
		</c:if> --%>
	</div>

	<!-- 责任人列表DIV -->

	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<jsp:include page="/common/footer.jsp"></jsp:include>

</body>
</html>