<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<!--STATUS OK-->
<head>
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">

<script src="<%=path%>/scripts/plugin/hcharts/highcharts.js" type="text/javascript"></script>
<style type="text/css">
			 ul,li{ list-style:none; margin:0px; padding:0px;}
			.slide{width:100%;height:auto;padding:10px; background-color:#FFFFFF;margin:10px auto;margin-bottom:50px;}
			.pic{overflow:hidden;width:100%; }
			.pic li{display:none; width:100%;  position:relative;}
			.pic li img{width:240px; border:0px;}
			.pic li span{ display:block; width:220px; height:30px; line-height:30px; font-size:12px; color:#FFFFFF; background-color:#000000; padding:0px 10px; FILTER: alpha(opacity=70); opacity: 0.7; -moz-opacity: 0.7; -webkit-opacity: 0.7; position:absolute; left:0px; bottom:0px; z-index:99; overflow:hidden;}
			.cur{display:block;}
			.thumb{width:100%; height:12px;text-align:center;}
			.mjblog{ width:95px; height:12px; padding-left:5px; font-size:12px; color: #c3c3c3; float:left; font-family: "Times New Roman", Times, serif;}
			.mjblog a{color: #c3c3c3;}
			.thnav{ float:right; height:10px;}
			.thnav li{ width:10px; height:10px; line-height:0px; font-size:0px; float:left; margin-left:8px; background-image:url(http://mj.588cy.com/img/nav_libg.gif); background-repeat:no-repeat; cursor:pointer;}
			.navli{ background-position:-17px 0px;}
			.clear{ display:block; height:0px; line-height:0px; font-size:0px;clear:both;}
</style>
<!--  -->
			<style>
				.clear {
					clear: both;
				}
				
				#page-wrap {
					width: 100%;
					background: white;
				}
				
				.button {
					float: left;
					text-align:center;
					padding-bottom:5px;
					font-family:微软雅黑;
					width:32%;
					margin: 2px;
				}
				
				#home-button {
					opacity: 1.0;
					border-bottom: 1px solid #CCC;
				}
				
				#about-button {
					opacity: 0.5;
					border-bottom: 1px solid #CCC;
				}
				
				#contact-button {
					opacity: 0.5;
					border-bottom: 1px solid #CCC;
				
				}
</style>

<style>
.halo {
  position: absolute;
  top: 80px;
  left: 50%;
}
.halo:before,
.halo:after {
  content: '';
  display: block;
  position: absolute;
  width: 120px;
  height: 120px;
  left: -60px;
  top: -60px;
  border-radius: 60px;
  /*animation-name: Grow;*/  
  animation-duration: 10s;
  animation-iteration-count: infinite;
  animation-timing-function: linear;
  /* Safari and Chrome */

  /*-webkit-animation-name: Grow;*/
  -webkit-animation-duration: 10s;
  -webkit-animation-iteration-count: infinite;
  -webkit-animation-timing-function: linear;
}
.halo:before {
  box-shadow: 0px 0px 100px 10px #cccccc;
}
.halo:after {
  /*box-shadow: inset 0px 0px 100px 10px #efefef;*/
}
@-webkit-keyframes Grow {
  0% {
    transform: scale(0.1);
    -ms-transform: scale(0.1);
    /* IE 9 */
  
    -webkit-transform: scale(0.1);
    /* Safari and Chrome */
  
    opacity: 0;
  }
  50% { 
    opacity: 1;
  }
  100% {
    transform: scale(2);
    -ms-transform: scale(2);
    /* IE 9 */
  
    -webkit-transform: scale(2);
    /* Safari and Chrome */
  
    opacity: 0;
  }
</style>

<style>
._index_nav{
	position:fixed;
	right:12px;
	width:48px;
	height:48px;
	border-radius:24px;
	background-color:#3e6790;
	text-align:center;
	line-height:48px;
	font-weight:bold;
	color:#fff;	
	opacity:0.5;
}
</style>
<script>
$(function(){
	$("#refreshpng").attr("id","refreshpng1");
	$("#refreshpng1").unbind("click").bind("click",function(){
		window.location.replace("<%=path%>/home/index?openId=${openId}&publicId=${publicId}&code=");
	});
	$("input[name=opptycurrpage]").val('0');
	$("input[name=feedcurrpage]").val('0');
	dyncLoadData('oppty','30');
	feedtopage();
	//
	$(document).scroll(function(){
		var h = $(document).scrollTop();
		if(h>195){
			$("#index_tab").css("position","fixed");
			$("#index_tab").css("width",$(document.body).width());
			$("#index_tab").css("background-color","#fff");
			$("#index_tab").css("z-index","100");
			$("#index_tab").css("top","0px");
			$("#content").css("margin-top","71px");
		}else{
			$("#index_tab").css("position","");
			$("#index_tab").css("top","auto");
			$("#index_tab").css("width","auto");
			$("#index_tab").css("z-index","10");
			$("#content").css("margin-top","0px");
		}
	});
	
	$(".feeds_shade").bind("click",function(){
		$(".feeds_shade").css("display","none");
		$("._repla_messgae_area").css("display","none");
		$("._repla_messgae_area textarea[name=inputMsg]").attr("placeholder","回复 ");
	});
	
	initSendMsg();
});

//获取开始日期
function getQueryDate(theDate,days){
	if(days != 'undefined' && days){
		theDate = new Date(theDate.getTime()+ days * 24 * 60 * 60 * 1000);
	} 
    var year = theDate.getFullYear();
    var month = theDate.getMonth()+1;
    var day = theDate.getDate();
    if(month < 10){
    	month = "0"+month;
    }
    if(day < 10){
    	day = "0"+day;
    }
    return year + "-" + month + "-"+day; 
}

function opptytopage(startdate,enddate,viewtype){
	if(viewtype !='shareview'){
		viewtype='myfollowallview';
	}
	$("#opptynextpage").attr("src","<%=path%>/image/loading_data_027.gif");
	
	var currpage = $("input[name=opptycurrpage]").val();
	$("input[name=opptycurrpage]").val(parseInt(currpage) + 1);
	currpage = $("input[name=opptycurrpage]").val();
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/oppty/opplist' || '',
	      //async: false,
	      data: {viewtype:viewtype,startDate:startdate,endDate:enddate,currpage:currpage,publicId:'${publicId}',openId:'${openId}',pagecount:'25'} || {},
	      dataType: 'text',
	      success: function(data){
	    	    var val = $("#div_oppty_list").html();
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	if(currpage=="1"){
					   $("#div_oppty_list").append('<div style="text-align:center;color:#aaa;margin-top:35px;">没有业务机会要跟进哦，<a href="<%=path%>/oppty/get?openId=${openId}&publicId=${publicId}">现在添加？</a></div>');	 
	    	    	}
	    	   	   $("#div_next_oppty").css("display",'none');
    	    	   return;
    	    	}
				if(d != ""){
	    	    	if($(d).size() == 10){
	    	    		$("#div_next_oppty").css("display",'');
	    	    	}else{
	    	    		$("#div_next_oppty").css("display",'none');
	    	    	}
					$(d).each(function(i){
						val += '<a href="<%=path%>/oppty/detail?rowId='
							+ this.rowid
							+ '&openId=${openId}&publicId=${publicId}" class="list-group-item listview-item">'
							+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
							+ '<b>'
							+ this.probability
							+ '%</b> </div>'
							+ '<div class="content" style="text-align: left">'
							+ '<h1>'
							+ this.name
							+ '&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
							+ this.assigner
							+ '</span></h1>'
							+ '<p class="text-default">预期:<span style="color:blue">￥'
							+ this.amount
							+ '</span>元&nbsp;&nbsp;&nbsp;&nbsp;销售阶段:<span style="color:blue">'
							+ this.salesstage
							+ '</span></p>'
							+ '<p>关闭日期:'
							+ this.dateclosed
							+ '&nbsp;&nbsp;&nbsp;&nbsp</p>'
							+ '</div></div> '
							+ '<div class="list-group-item-fd"><span class="icon icon-uniE603"></span></div>'
							+ '</a>';							
										});
					} else {
						$("#div_next_oppty").css("display", 'none');
					}
					$("#div_oppty_list").html(val);
					
					$("#opptynextpage").attr("src","<%=path%>/image/nextpage.png");
				}
			});
}


//活动流分页
function feedtopage(){
	$("#feednextpage").attr("src","../image/loading.gif");
	var currpage = $("input[name=feedcurrpage]").val();
	$("input[name=feedcurrpage]").val(parseInt(currpage) + 1);
	currpage = $("input[name=feedcurrpage]").val();
	//获取本周时间
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/feed/feedlist',
	      async: false,
	      data: {currpage:currpage,crmId:'${crmId}',pagecount:'10',param1:"false"} || {},
	      dataType: 'text',
	      success: function(data){
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
  	    	  $("#div_next_feed").css("display",'none');
					return;
  	    	}
				if(d != ""){
	    	    	if($(d).size() == 10){
	    	    		$("#div_next_feed").css("display",'');
	    	    	}else{
	    	    		$("#div_next_feed").css("display",'none');
	    	    	}
	    	    	var feedstr = "";
					$(d).each(function(i){
						if(this.rowid == '' || this.rowid == 'undefined' ||  this.rowCount == ""){
							if(currpage == 1){
								var objdom = '<div style="text-align:center;color:#aaa;padding-top:35px;">您还没有订阅活动流消息</div>';
					    	    objdom+= '<div style="text-align:center;color:#aaa;margin-top:35px;"><a href="<%=path%>/feed/list?openId=${openId}&publicId=${publicId}">现在就去订阅!</a></div>';
						    	$("#feed_div").before(objdom);
							}
							return;				
						}
						feedstr = '<div class="_feeds_list feedsReplayCon" id="'+this.module+'_'+this.rowid+'" style="width:100% auto;margin-left:10px;margin-right:10px;margin-top:10px;background-color:#fff;font-size:16px;border:1px solid #ddd">';

						feedstr += '<div style="float:left;padding:10px;" class="imgHeader" >';
						if(sessionStorage.getItem("header_"+this.operid)){
							feedstr += '<img headerflag="Y" id="header_'+this.operid +'" style="border-radius: 10px;" src="'+sessionStorage.getItem("header_"+this.operid)+'" width="45px">';
						}else{
							feedstr += '<img headerflag="Y" id="header_'+this.operid +'" style="border-radius: 10px;" src="<%=path %>/image/defailt_person.png" width="45px">';
						}
						
						feedstr += '</div>';
						feedstr += '<div style="width:100%;line-height:25px;height:60px;padding:8px;">';
						feedstr += '<div style="font-size:12px;"><div style="float:left;"><span style="color:#3e6790;">'+this.opername+'</span></div>';
						feedstr += '<div style="font-size:12px;float:right;">'+this.createdate+'</div></div>';
						feedstr += '<div style="font-weight:bold;margin-top:28px;">';
						var name = this.name;
						if(name.length>12){
							name = name.substring(0,10)+"...";
						}
						if(this.module == 'Accounts'){
							if(this.opertype == '0'){
								feedstr +='添加客户【<a href="<%=path %>/customer/detail?rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">'+name+'</a>】';
							}
						}else if(this.module == 'Opportunities'){
							if(this.opertype == '0'){
								feedstr +='添加生意【<a href="<%=path %>/oppty/detail?rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">'+name+'</a>】';
							}
						}else if(this.module == 'Tasks'){
							if(this.opertype == '0'){
								feedstr +='添加任务【<a href="<%=path %>/schedule/detail?rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">'+name+'</a>】';
							}
						}else if(this.module == 'Contacts'){
							if(this.opertype == '0'){
								feedstr +='添加联系人【<a href="<%=path %>/contact/detail?rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">'+name+'</a>】';
							}
						}else if(this.module == 'Campaigns'){
							if(this.opertype == '0'){
								feedstr +='添加市场活动【<a href="<%=path %>/campaigns/detail?rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">'+name+'</a>】';
							}
						}else if(this.module == 'Cases'){
							if(this.opertype == '0'){
								if(this.attr.attr6 == 'case'){
									feedstr +='发起服务请求【<a href="<%=path %>/complaint/detail?rowid='+this.rowid+'&servertype=case&crmid=${crmId }&publicid=${publicId}&openid=${openId}">'+name+'</a>】';
								}else{
									feedstr +='发起投诉【<a href="<%=path %>/complaint/detail?rowid='+this.rowid+'&servertype=complaint&crmid=${crmId }&publicid=${publicId}&openid=${openId}">'+name+'</a>】';
								}
							}
						}
						feedstr += '</div></div>';
						feedstr += '<div style="width:100%;margin-top:8px;line-height:25px;padding:0px 25px 0px 25px;font-size:12px; color:#999">';
						//客户
						if(this.module == 'Accounts'){
							feedstr += '我找到了一个客户'+this.name;
							if(this.attr.attr1 != ''){
								feedstr += '，电话：'+this.attr.attr1;
							}
							if(this.attr.attr2 != ''){
								feedstr += '，地址：'+this.attr.attr2;
							}
						}
						//商机
						else if(this.module == 'Opportunities'){
							feedstr += '我发现了一个业务机会'+this.name;
							if(this.attr.attr1 != ''){
								feedstr += '，预计金额：￥'+this.attr.attr1;
							}
							if(this.attr.attr3 != ''){
								feedstr += '，预计关闭日期：'+this.attr.attr3;
							}
							if(this.attr.attr2 != ''){
								feedstr += '，目前正处于'+this.attr.attr2+'阶段。';
							}
						}
						//任务
						else if(this.module == 'Tasks'){
							feedstr += '我创建了一个任务'+this.name;
							if(this.attr.attr1 != ''){
								feedstr += '，于'+this.attr.attr1+'开始';
							}
							if(this.attr.attr2 != ''){
								feedstr += '，'+this.attr.attr2+'结束';
							}
							if(this.attr.attr3 != ''){
								feedstr += '，目前状态为：'+this.attr.attr3;
							}
						}
						//
						else if(this.module == 'Contacts'){
							feedstr += '我找到了一个联系人'+this.name;
							if(this.attr.attr1 != ''){
								feedstr += '，职位：'+this.attr.attr1;
							}
							if(this.attr.attr2 != ''){
								feedstr += '，手机：'+this.attr.attr2;
							}
							if(this.attr.attr3 != ''){
								feedstr += '，电话：'+this.attr.attr3;
							}
						}
						//
						else if(this.module == 'Campaigns'){
							feedstr += '我创建了一个市场活动'+this.name;
							if(this.attr.attr1 != ''){
								feedstr += '，开始时间：'+this.attr.attr1;
							}
							if(this.attr.attr2 != ''){
								feedstr += '，结束时间：'+this.attr.attr2;
							}
							if(this.attr.attr3 != ''){
								feedstr += '，状态：'+this.attr.attr3;
							}
						}
						//
						else if(this.module == 'Cases'){
							if(this.attr.attr6 == 'case'){
								feedstr += '我发起了一个服务请求'+this.name;
							}else{
								feedstr += '我发起了一个投诉'+this.name;
							}
							if(this.attr.attr1 != ''){
								feedstr += '，创建时间：'+this.attr.attr1;
							}
							if(this.attr.attr2 != ''){
								feedstr += '，完成时间：'+this.attr.attr2;
							}
							if(this.attr.attr3 != ''){
								feedstr += '，状态：'+this.attr.attr3;
							}
						}
						feedstr += '</div>';
						feedstr += '<div id="team_'+this.rowid+'" style="width:100%;margin-top:5px;line-height:25px;padding-left:10px;font-size:12px; color:#999;min-height:60px;"></div>';
						feedstr += '<div style="clear: both;"></div>';
						feedstr += '<div class="feedsReplayRst" style="border-top:1px solid #eee;margin:10px;padding-top:10px;margin-left:10px;padding-right:10px;text-align:right;font-size:14px;">';
						feedstr += '<span class="feedrsp" style="padding-right:10px;">';
						feedstr += '<a href="javascript:void(0)" class="commonReplyBtn" onclick="sendMsg(\''+this.module +'\',\''+this.rowid+'\')"  ><img width="25px" style="margin-top:3px;" src="<%=path%>/image/wxcrm_messages.png"><span id="_msg_count_'+this.rowid+'">0</span></a>';
						feedstr += '</span>';
						feedstr += '<span class="subfeed" style="margin-left:10px;">';
						feedstr += '<a href="javascript:void(0)" class="commonReplyBtn" id="subfeed_'+this.rowid+'" onclick="cancelSubFeed(\''+this.module+'\',\''+this.rowid+'\')"><img id="subfeed_img_'+this.rowid +'" width="22px" src="<%=path%>/image/wxcrm_cancel_dingyue.png">&nbsp;</a>';
						feedstr += '</span>';
						feedstr += '<ul class="twitterSec " style="display:none;margin-right:60px;"></ul></div>';
						feedstr += '<div id="messages_title_'+this.rowid+'" style="display:none;width:100%;text-align:left;padding:0px 10px 5px 10px;margin:0px 10px 10px 10px;border-bottom:1px solid #efefef;">全部回复</div>';
						feedstr += '<div id="messages_'+this.rowid+'" style="width:100%;text-align:left;padding:0px 10px 0px 10px;margin:0px 0px 10px 10px;"></div>';
						feedstr += '</div>';
						//追加
						$("#div_feed_list").append(feedstr);
						
						//加载团队
		    			loadShareUserData(this.module,this.rowid);
		    			//加载业务数据
		    			loadBusinessData(this.module,this.rowid);
		    			//加载图像
		    			if(!sessionStorage.getItem("header_"+this.operid)){
	    					loadImageHead("header_"+this.shareuserid,this.shareuserid);
		    			}
		    			$("#feednextpage").attr("src","../image/nextpage.png");
					});
					
	    	    }else{
	    	    	$("#feednextpage").attr("src","../image/nextpage.png");
	    	    	$("#div_next_feed").css("display",'none');
	    	    }
	      }
	 });
}

//加载分享数据
function loadShareUserData(parenttype,rowId){
	asyncInvoke({
		url: '<%=path%>/shareUser/shareUsersList',
		data: {
			openId: '${openId}',
 			publicId: '${publicId}',
 			rowId: rowId,
 			parenttype: parenttype
		},
	    callBackFunc: function(data){
	    	if(!data) return;
	    	var d = JSON.parse(data);
	    	$(d).each(function(){
	    		var team = '<div style="float:left;margin:8px;text-align:center;">';
	    		if(sessionStorage.getItem("header_"+this.shareuserid)){
	    			team += '<img readflag="Y" id="header_'+this.shareuserid+'"  style="border-radius: 10px;" src="'+sessionStorage.getItem("header_"+this.shareuserid)+'" width="40px">';
	    		}else{
	    			team += '<img id="header_'+this.shareuserid+'"  style="border-radius: 10px;" src="<%=path %>/image/defailt_person.png" width="40px">';
	    			//加载图像
	    			loadImageHead("header_"+this.shareuserid,this.shareuserid);
	    		}
	    		if(this.shareusername.length > 4){
	    			team += "<br/>"+this.shareusername.substring(0,3)+"...";
	    		}else{
	    			team += "<br/>"+this.shareusername;
	    		}
	    		team += '</div>';
	    		$("#team_"+rowId).append(team);
	    		$("#"+parenttype+"_"+rowId).attr("teamflag","N");
	    	});
	    }	
	});
}

//2. 加载业务对象变化数据
function loadBusinessData(parenttype,rowId){
	var dataObj = [];
	dataObj.push({name:'crmid', value:'${crmId}' });
	dataObj.push({name:'parenttype', value:parenttype});
	dataObj.push({name:'parentid', value: rowId});
	dataObj.push({name:'openid', value: '${openId}' });
	dataObj.push({name:'publicid', value:'${publicId}'});
	
	$.ajax({
	   type: 'get',
	   url: '<%=path%>/trackhis/asycnlist',
	   data: dataObj || {},
	   dataType: 'text',
	   success: function(data){
		    if(!data) return;
		    var d = JSON.parse(data);
		    var msgcount = 0;
	    		$(d).each(function(){
   	    		var msgs = '<div style="line-height:25px;margin-top:10px;font-size:12px;color:#666;" onclick="sendMsg(\''+parenttype+'\',\''+rowId+'\',\''+this.opid+'\',\''+this.opname+'\')">';
   	    		if(sessionStorage.getItem("header_"+this.opid)){
   	    			//msgs += '<img readflag="Y" style="border-radius: 12px;" src="'+sessionStorage.getItem("header_"+this.opid)+'" width="24px">&nbsp;';
   	    		}else{
   	    			//msgs += '<img id="header_'+this.opid+'" style="border-radius: 12px;" src="<%=path %>/image/defailt_person.png" width="24px">&nbsp;';
   	    			//loadImageHead("header_"+this.opid,this.opid);
   	    		}
   	    		
   	    		if(this.optype == 'contact'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加联系人：<a href="<%=path%>/contact/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'tasks'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加任务：<a href="<%=path%>/schedule/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'&shcetype=task">'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'oppty'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加生意：<a href="<%=path%>/oppty/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'opptyamount'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修改生意金额：'+this.beforevalue + '->￥' +this.aftervalue+'</div>';
   	    		}else if(this.optype == 'opptyclosed'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修改生意关闭日期：'+this.beforevalue + '->' +this.aftervalue+'</div>';
   	    		}else if(this.optype == 'opptyevent'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加强制性事件：'+this.aftervalue+'</div>';
   	    		}else if(this.optype == 'opptyvalue'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加价值主张：'+this.aftervalue+'</div>';
   	    		}else if(this.optype == 'opptystage'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修改生意阶段：'+this.beforevalue + '->' +this.aftervalue+'</div>';
   	    		}else if(this.optype == 'opptycompetitor'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 调整竞争策略：'+this.beforevalue + '->' +this.aftervalue+'</div>';
   	    		}else if(this.optype == 'opptyrival'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加竞争对手：<a href="<%=path%>/customer/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'opptypartner'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加合作伙伴：<a href="<%=path%>/customer/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'casevisit'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加服务回访：'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'caseexec'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加服务执行：'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'case_status'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修改服务状态：'+this.beforevalue + '->' +this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'case_finish_time'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 完成服务：'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'share'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加团队成员：'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'expense'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 报销了一笔费用：'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'cancel_share'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 删除团队成员：'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'assign'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修改责任人：'+this.beforevalue + '->'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'bugs'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 解决了一个Bug：<a href="<%=path%>/bug/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
   	    		}else if(this.optype == 'close_bugs'){
   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修复了一个Bug：<a href="<%=path%>/bug/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
   	    		}
   	    		
   	    		msgcount ++;
   	    		
   	    		$("#messages_"+rowId).prepend(msgs);
   	    		$("#messages_title"+rowId).css("display","");
   	    	});
	    		$("#_msg_count_"+rowId).html(msgcount);
	    		//加载消息
			loadMessagesData(parenttype,rowId);
	   }
	});
}

//3. 加载消息数据
function loadMessagesData(parenttype,rowId){
	var dataObj = [];
	dataObj.push({name:'crmId', value:'${crmId}' });
	dataObj.push({name:'relaModule', value:parenttype});
	dataObj.push({name:'relaId', value: rowId});
	dataObj.push({name:'subRelaId', value: '' });
	dataObj.push({name:'currpage', value:'0' });
	dataObj.push({name:'pagecount', value:'5' });
	
	$.ajax({
	   type: 'get',
	   url: '<%=path%>/msgs/asynclist',
	   data: dataObj || {},
	   dataType: 'text',
	   success: function(data){
		    if(!data) return;
		    var d = JSON.parse(data);
		    var msgcount = $("#_msg_count_"+rowId).html();
	    		$(d).each(function(){
   	    		var msgs = '<a href="javascript:void(0)" onclick="sendMsg(\''+parenttype+'\',\''+rowId+'\',\''+this.userId+'\',\''+this.username+'\')"><div style="line-height:25px;margin-top:10px;font-size:12px;color:#666;">';
   	    		if(sessionStorage.getItem("header_"+this.userId)){
   	    			//msgs += '<img readflag="Y" style="border-radius: 12px;" src="'+sessionStorage.getItem("header_"+this.userId)+'" width="24px">&nbsp;';
   	    		}else{
   	    			//msgs += '<img id="header_'+this.userId+'" style="border-radius: 12px;" src="<%=path %>/image/defailt_person.png" width="24px">&nbsp;';
   	    			//loadImageHead("header_"+this.userId,this.userId);
   	    		}
				if(this.targetUID){
					msgs += '<span style="color:#3e6790;">'+this.username+'</span> 回复'+this.targetName+'：'+this.content+'</div></a>';
				}else{
					msgs += '<span style="color:#3e6790;">'+this.username+'</span> 回复：'+this.content+'</div></a>';
				}
				msgcount ++;
   	    		$("#messages_"+rowId).append(msgs);
   	    		$("#messages_title"+rowId).css("display","");
   	    	});
	    		$("#_msg_count_"+rowId).html(msgcount);
	   }
	});
}

//取消订阅
function cancelSubFeed(module,feedid){
	var flag = null;
	if($("input[name=feedcurrpage]")!="1"&&$("#div_feed_list").find(".feedsReplayCon").length=='1'){
 		flag = "endRecoed";
  	}
	  var dataObj = [];
	  dataObj.push({name:'openId',value:'${openId}'});
	  dataObj.push({name:'crmId',value:'${crmId}'});
	  dataObj.push({name:'feedid',value:feedid});
	  dataObj.push({name:'publicId',value:'${publicId}'});
	  dataObj.push({name:'flag',value:flag});
	  $.ajax({
    		url: '<%=path%>/feed/delSub',
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
	    	    	$("#"+module+"_"+feedid).remove();
	    	    }
    	    	if($("#div_feed_list").find(".feedsReplayCon").length=='0'){
		    	    var objdom = '<div style="text-align:center;color:#aaa;padding-top:35px;">您还没有订阅活动流消息</div>';
		    	    objdom+= '<div style="text-align:center;color:#aaa;margin-top:35px;"><a href="<%=path%>/feed/list?openId=${openId}&publicId=${publicId}">现在就去订阅!</a></div>';
			    	$("#feed_div").before(objdom);
	    	    }
    	    }
    });
}

//显示消息框
function sendMsg(module,rowid,targetUID,targetName){
	//赋值
	if(targetUID){
		$("._repla_messgae_area input[name=targetUID]").val(targetUID);
	}else{
		$("._repla_messgae_area input[name=targetUID]").val('');
	}
	if(targetName){
		$("._repla_messgae_area input[name=targetUName]").val(targetName);
		$("._repla_messgae_area textarea[name=inputMsg]").attr("placeholder","回复 " + targetName);
	}else{
		$("._repla_messgae_area input[name=targetUName]").val('');
	}
	$("._repla_messgae_area input[name=relaModule]").val(module);
	$("._repla_messgae_area input[name=relaId]").val(rowid);
	//显示消息对话框
	$("._repla_messgae_area").css("display","");
	//
	$(".feeds_shade").css("display","");
}



//回复消息
function initSendMsg(){
	$("._send_message_button").bind("click",function(){
		$("._repla_messgae_area textarea[name=inputMsg]").attr("placeholder","回复 ");
		var targetUID = $("._repla_messgae_area input[name=targetUID]").val();
		var targetName = $("._repla_messgae_area input[name=targetUName]").val();
		var relaModule = $("._repla_messgae_area input[name=relaModule]").val();
		var relaId = $("._repla_messgae_area input[name=relaId]").val();
		var content = $("._repla_messgae_area textarea[name=inputMsg]").val();
		var dataObj = [];
    	dataObj.push({name:'ownerCrmId', value: '${crmId}'});
    	dataObj.push({name:'ownerOpenId', value: '${openId}'});
    	dataObj.push({name:'userId', value:'${crmId}'});
    	dataObj.push({name:'username', value: '${assigner}'});
    	dataObj.push({name:'targetUId', value: targetUID});
    	dataObj.push({name:'targetUName', value: targetName});
    	dataObj.push({name:'msgType', value:'txt'});
    	dataObj.push({name:'content', value: content });
    	dataObj.push({name:'relaModule', value: relaModule});
    	dataObj.push({name:'relaId', value: relaId});
    	dataObj.push({name:'subRelaId', value: '' });
    	dataObj.push({name:'readFlag', value: 'N'});
    	dataObj.push({name:'createTime', value: new Date()});
    	dataObj.push({name:'assignerid', value: '${assigner}'});
    	
    	//
    	$("#messages_title"+relaId).css("display","");
   	    $("._repla_messgae_area textarea[name=inputMsg]").val('');
   	    $("._repla_messgae_area").css("display","none");
   	    	
   	    _initMessageControl();
   	    $(".feeds_shade").css("display","none");
   	    
   	    //更新消息计数
   	    var msgcount = $("#_msg_count_"+relaId).html();
   	    $("#_msg_count_"+relaId).html(++msgcount);
    	//
    	//异步调用保存数据
    	$.ajax({
    		url:'<%=path%>/msgs/save',
    		type: 'get',
    		data: dataObj,
    		dataType: 'text',
    	    success: function(data){
    	    	if(!data){
    	    		return;
    	    	}
    	    	var msgs = '<a href="javascript:void(0)" onclick="sendMsg(\''+relaModule+'\',\''+relaId+'\',\'${crmId}\',\'${assigner}\')"><div style="line-height:25px;margin-top:10px;font-size:12px;color:#666;" >';
    	    	if(sessionStorage.getItem("header_${crmId}")){
         	   		//$(this).attr("src", sessionStorage.getItem("header_${crmId}"));
         	   		//msgs += '<img style="border-radius: 12px;" src="'+sessionStorage.getItem("header_${crmId}")+'" width="24px">&nbsp;';
         	   	}else{
         	   		//msgs += '<img style="border-radius: 12px;" src="<%=path %>/image/defailt_person.png" width="24px">&nbsp;';
         	   	}
				
				if(targetUID){
					msgs += '<span style="color:#3e6790;">${assigner}</span> 回复'+targetName+'：'+content+'</div></a>';
				}else{
					msgs += '<span style="color:#3e6790;">${assigner}</span> 回复：'+content+'</div></a>';
				}
				
   	    		$("#messages_"+relaId).append(msgs);
   	    		
   	    		
    	    }
    	});
	});
}

//加载图像
function loadImageHead(img,userId){
	if(sessionStorage.getItem("header_"+userId)){
 	   	$("#"+img).attr("src", sessionStorage.getItem("header_"+userId));
 	   	return;
    }
	//异步调用获取消息数据
	asyncInvoke({
		url: '<%=path%>/wxuser/getImgHeader',
		data: {crmId: userId},
	    callBackFunc: function(data){
	    	$("#"+img).attr({"src":data,"readflag":"Y"});
	    	if(data){
	    	    //本地缓存
 	            sessionStorage.setItem("header_"+userId,data);
	    	}else{
	    		sessionStorage.setItem("header_"+userId,"<%=path %>/image/defailt_person.png");
	    	}
	    }
	});
}

//按类型加载数据
function dyncLoadData(type,param){
	//任务
	if(type == 'task'){
		$("input[name=taskcurrpage]").val(0);
		$("#div_tasks_list").empty();
		if(param == '7'){
			tasktopage(getQueryDate(new Date()),getQueryDate(new Date(),7));
			$(".schedule_tags").html('未来7天及历史未完成任务');
		}else if(param == '30'){
			tasktopage(getQueryDate(new Date(),7),getQueryDate(new Date(),30));
			$(".schedule_tags").html('未来30天任务');
		}else if(param == '90'){
			tasktopage(getQueryDate(new Date(),30),getQueryDate(new Date(),90));
			$(".schedule_tags").html('未来90天任务');
		}else if(param == '-1'){
			tasktopage(getQueryDate(new Date(),-7),getQueryDate(new Date(),90),'shareview');
			$(".schedule_tags").html('我参与的任务');
		}
	}
	//业务机会
	else if(type == 'oppty'){
		$("input[name=opptycurrpage]").val(0);
		$("#div_oppty_list").empty();
		if(param == '30'){
			opptytopage(getQueryDate(new Date(),-60),getQueryDate(new Date(),30));
			$(".oppty_tags").html('未来30天及历史未关闭的生意');
		}else if(param == '90'){
			opptytopage(getQueryDate(new Date(),30),getQueryDate(new Date(),90));
			$(".oppty_tags").html('未来90天生意');
		}else if(param == '-1'){
			opptytopage(getQueryDate(new Date(),-60),getQueryDate(new Date(),120),'shareview');
			$(".oppty_tags").html('我参与的生意');
		}
	}
}

var oldstartdate;
var oldenddate;

//任务分页
function tasktopage(startdate,enddate,viewtype){
	if(!oldstartdate){
		startdate = getQueryDate(new Date());
	}
	if(!oldenddate){
		enddate = getQueryDate(new Date(),7);
	}
	oldstartdate = startdate;
	oldenddate = enddate;
	if(viewtype != 'shareview'){
		viewtype = "homeview";
	}
	$("#tasknextpage").attr("src","../image/loading.gif");
	var currpage = $("input[name=taskcurrpage]").val();
	$("input[name=taskcurrpage]").val(parseInt(currpage) + 1);
	currpage = $("input[name=taskcurrpage]").val();

	$.ajax({
	      type: 'get',
	      url: '<%=path%>/schedule/tlist' || '',
	      async: false,
	      data: {viewtype:viewtype,currpage:currpage,publicId:'${publicId}',openId:'${openId}',pagecount:'25',assignId:'${crmId}',startDate:startdate,endDate:enddate} || {},
	      dataType: 'text',
	      success: function(data){
	    	    var val = $("#div_tasks_list").html();
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	$("#div_next_task").css("display",'none');
    	    	    return;
    	    	}
				if(d != ""){
	    	    	if($(d).size() == 10){
	    	    		$("#div_next_task").css("display",'');
	    	    	}else{
	    	    		$("#div_next_task").css("display",'none');
	    	    	}
					$(d).each(function(i){
						var schetype = this.schetype;
						var img = '<img src="<%=path %>/image/schedule.png" width="16px">';
						if(schetype == 'meeting'){
							 img = '<img src="<%=path %>/image/oppty_partner.png" width="16px">';
						}else if(schetype == 'phone'){
							img = '<img src="<%=path %>/image/mb_card_contact_tel.png" width="16px">';
						}
						val += '<a href="<%=path%>/schedule/detail?rowId='+this.rowid+'&openId=${openId}&publicId=${publicId}&schetype='+schetype+'" class="list-group-item listview-item">'
							+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
							+ '<b>'+this.statusname+'</b> </div>'
							+ '<div class="content" style="text-align: left">'
							+ '<h1>'+ this.title+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1>'
							+ '<p class="text-default">'+img+' 开始时间：'+this.startdate+'</p>'
							+ '</div></div> '
							+ '<div class="list-group-item-fd"><span class="icon icon-uniE603"></span></div>'
							+ '</a>';
					});
	    	    }else{
	    	    	$("#div_next_task").css("display",'none');
	    	    }
				$("#div_tasks_list").html(val);
				$("#tasknextpage").attr("src","<%=path%>/image/nextpage.png");
	      }
	 });
}

</script>

<script type="text/javascript">
    $(function(){
    	if(!document.getElementById("inputMsg")){
    		return;
    	}
    	autoTextArea("inputMsg");
    });
        
    function autoTextArea(elemid){
        //新建一个textarea用户计算高度
        if(!document.getElementById("_textareacopy")){
            var t = document.createElement("textarea");
            t.id="_textareacopy";
            t.style.position="absolute";
            t.style.left="-9999px";
            t.rows = "1";
            t.style.lineHeight="20px";
            t.style.fontSize="16px";
            document.body.appendChild(t);
        }
        function change(){
        	document.getElementById("_textareacopy").value= document.getElementById("inputMsg").value;
        	var height = document.getElementById("_textareacopy").scrollHeight;
        	if(height>100){
        		return;
        	}
        	if(document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height < 40){
        		document.getElementById("inputMsg").style.height= "40px";
        	}else{
            	document.getElementById("inputMsg").style.height= document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height+"px";
        	}
        }
        
        $("#inputMsg").bind("propertychange",function(){
        	change();
        });
        $("#inputMsg").bind("input",function(){
        	change();
        });

        document.getElementById("inputMsg").style.overflow="hidden";//一处隐藏，必须的。
        document.getElementById("inputMsg").style.resize="none";//去掉textarea能拖拽放大/缩小高度/宽度功能
    }
    
    function _initMessageControl(){
    	if(document.getElementById("inputMsg")){
    		document.getElementById("inputMsg").style.height = "40px";
    		document.getElementById("inputMsg").value = "";
    		document.getElementById("inputMsg").rows = "1";
    		document.body.removeChild(document.getElementById("_textareacopy"));
        	autoTextArea("inputMsg");
    	}
    }
    

</script>
</head>
<body style="background-color:#fff;height:100%;">
	<input type="hidden" name="feedcurrpage" value="0">
	<input type="hidden" name="taskcurrpage" value="0">
	<input type="hidden" name="opptycurrpage" value="0">
	<form action="<%=path %>/home/index?openId=${openId}&publicId=${publicId}">
		<c:if test="${bindSucc eq 'fail' }">
			<script>
			</script>
			<div
				style="float: left; height: 48px; width: 100%;background-color:#3e6790;"> 
				<img src="<%=path%>/image/takshine_logo.png" width="64px"
					style="margin: 15px; border: 5px solid #eee;">
			</div>
			<div
				style="width: 100%; text-align: center; height: 210px; padding-top: 100px;">
				<div style="width: 100%; text-align: center;">
					<img src="${headimgurl}"
						style="border:0; border-radius: 75px; width: 150px; height: 150px;">
				</div>

				<div
					style="width: 100%; text-align: center; margin-top: 28px; color: #fff">
					<span style="color: red; font-weight: bold;">Hi&nbsp;&nbsp;${nick }</span>
				</div>

				<div class="flooter"
					style="color: #666; font-size: 16px; height: 50px; line-height: 50px; margin-bottom: 80px; font-family: 微软雅黑;">
					<span> <a
						href="<%=path %>/register/get?openId=${openId}&publicId=${publicId}"
						style="color: #3e6790; font-weight: bold; font-size: 16px;">注册试用</a>
					</span> <span style="padding-left: 8px; padding-right: 8px; color: #ddd;">|</span>
					<span> <a
						href="<%=path%>/operMobile/get?openId=${openId }&publicId=${publicId}"
						style="color: #3e6790; font-weight: bold; font-size: 16px;">用户登陆</a>
					</span>

				</div>
			</div>
			<div class="flooter"
				style="color: #666; font-size: 12px; height: 50px; line-height: 50px; margin-bottom: 20px; font-family: 微软雅黑;">
				@2014德成鸿业
			</div>

			<div class="flooter"
				style="color: #666; font-size: 12px; height: 50px; line-height: 50px; padding-bottom: 25px; font-family: 微软雅黑;">
				您身边的客户关系管理专家！
			</div>
		</c:if>
		<c:if test="${bindSucc eq 'success' }">
			<div style="width: 100%; text-align: center;background-color:#3e6790;float:left;">
			<div style="border: 0;border-radius: 80px; width: 160px; height: 160px;background-color:#fff;float:left;margin-top:20px;margin-left:40px"> 
									<div style="border: 0;border-radius: 60px; width: 120px; height: 120px;background-color:#3e6790;float:left;margin-left:20px;margin-top:20px;color:#fff;line-height:40px;vertical-align:middle;font-size: 40px;font-family: 微软雅黑;">
									 <p style="font-size: 12px;">已完成</p>
									 <b>${indexKPI.percentage}%</b>
									</div>
				</div>
				<div style="padding-left:120px;float:left;">
				                            <div style="text-align:left;line-height:30px;margin-top:10px;color:#fff;">
					                            <div style="float: left;margin-top:10px;"><b>销售：</b></div>
					                            <div style="float: left;margin-left:10px"><p>已完成 /计划</p>
				                            	<a href="#"><p style="color:#fff;">${indexKPI.salesCompleted}￥/${indexKPI.salesTargets}￥</p></a></div>
				                            </div>
											<div style="text-align:left;line-height:30px;margin-top:10px;font-size:12px;color:#fff;">  
											<div style="float: left;margin-top:10px"><b>回款：</b></div>
											<div style="float: left;margin-left:10px"><p>已完成 /计划</p>
				                            	<p>${indexKPI.collectionCompleted}￥/${indexKPI.collectionTargets}￥</p></div>				      	
				                           </div>
											<div style="text-align:left;line-height:30px;margin-top:10px;font-size:12px;color:#fff;">
											<div style="float: left;margin-top:10px"><b>任务：</b></div>
											<div style="float: left;margin-left:10px"><p>未完成</p>
				                            	<p>${indexKPI.unfinishedTask}</p></div>				  </div>
				</div>
			</div>
			<div style="clear:both;"></div>
			
			<!--  -->
			<div id="page-wrap">
				<div id="index_tab">
				<div id="home-button" class="button" style="opacity: 1; border-width: 3px;">
					  <div style="height: 30px;margin-top:5px;">
						<img src="<%=path %>/image/list_task_plan.png" width="40px;"></div>	
					  <div style="height:20px;line-height:20px;margin-top:10px;font-size:14px;color:#3e6790;">&nbsp;任&nbsp;&nbsp;务&nbsp;</div>
					  
				</div>
				<div id="about-button" class="button" style="opacity: 0.5; border-width: 1px;">
					  <div style="height: 30px;margin-top:5px;">
						<img src="<%=path %>/image/list_oppty_won.png" width="40px;"></div>	
					  <div style="height:20px;line-height:20px;margin-top:10px;font-size:14px;color:#3e6790;">&nbsp;生&nbsp;&nbsp;意&nbsp;</div>
				</div>
		
				<div id="contact-button" class="button" style="opacity: 0.5; border-width: 1px;">
					 <div style="height: 30px;margin-top:5px;">
						<img src="<%=path %>/image/list_accnt_team.png" width="40px;"></div>	
					  <div style="height:20px;line-height:20px;margin-top:10px;font-size:14px;color:#3e6790;">&nbsp;活动流&nbsp;</div>
				</div>
				</div>
				<div class="clear"></div>
				<div id="content" style="min-height:200px;">
					<div id="home" style="margin-bottom:50px;">
							<div class="site-recommend-list page-patch">
								<div class="schedule_tags" style="width:100%;padding:8px;color:#aaa;text-align:center;">未来7天及历史未完成任务</div>
								<div class="list-group1 listview tasklist" style="margin-top:-1px;" id="div_tasks_list">
									<c:if test="${fn:length(taskList) > 0}">
										
										<!-- <div style="width:100%;padding:10px 0px 10px 0px;">
											<div style="float:left;width:20%;text-align:center;">
												安排：
											</div>
											<div style="float:left;width:20%;">
												<a href="<%=path%>/schedule/add?openId=${openId}&publicId=${publicId}&scheType=task">任务</a>
											</div>
											<div style="float:left;width:20%;">
												<a href="<%=path%>/schedule/add?openId=${openId}&publicId=${publicId}&scheType=phone">电话</a>
											</div>
											<div style="float:left;width:20%;">
												<a href="<%=path%>/schedule/add?openId=${openId}&publicId=${publicId}&scheType=meeting">会议</a>
											</div>
											<div style="float:left;width:20%;">
												<a href="<%=path%>/schedule/add?openId=${openId}&publicId=${publicId}&scheType=report">日报</a>
											</div>
										</div> 
										<div style="clear:both;">&nbsp;</div>-->
										<c:forEach items="${taskList }" var="task">
											<a href="<%=path%>/schedule/detail?rowId=${task.rowid}&openId=${openId}&publicId=${publicId}&schetype=${task.schetype}" 
												class="list-group-item listview-item">
												<div class="list-group-item-bd">
													<div class="thumb list-icon" style="padding-top:0px;">
														<b>${task.statusname}</b>
													</div>
													<div class="content">
														<h1>
															${task.title }&nbsp;<span
																style="color: #AAAAAA; font-size: 12px;">${task.assigner }</span></h1>
														<p class="text-default">
															<c:if test="${task.schetype eq 'phone' }">
																<img src="<%=path %>/image/mb_card_contact_tel.png" width="16px">
															</c:if>
															<c:if test="${task.schetype eq 'meeting' }">
																<img src="<%=path %>/image/oppty_partner.png" width="16px">
															</c:if>
															<c:if test="${task.schetype ne 'phone' && task.schetype ne 'meeting'}">
																<img src="<%=path %>/image/schedule.png" width="16px">
															</c:if>
															开始时间：${task.startdate}</p>
													</div>
												</div>
												<div class="list-group-item-fd">
													<span class="icon icon-uniE603"></span>
												</div>
											</a>
										</c:forEach>
									</c:if>
									<c:if test="${fn:length(taskList) == 0 }">
											<div style="text-align:center;padding-top:50px;color:#aaa;">没有计划任务！<br/><br/><br/>
												<a href="<%=path%>/schedule/get?openId=${openId}&publicId=${publicId}">现在安排？</a></div>
									</c:if>
								</div>
								<c:if test="${fn:length(taskList) == 10 }">
									<a href="javascript:void(0)" onclick="tasktopage()">
									<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next_task">
											下一页&nbsp;<img id="tasknextpage" src="<%=path%>//image/nextpage.png" width="24px"/>
										
									</div>
									</a>
								</c:if>
							</div>
						<a href="javascript:void(0)" onclick="dyncLoadData('task','7');"><div class="_index_nav" style="bottom:250px;">7</div></a>
						<a href="javascript:void(0)" onclick="dyncLoadData('task','30');"><div class="_index_nav" style="bottom:190px;">30</div></a>
						<!-- <a href="javascript:void(0)" onclick="dyncLoadData('task','90');"><div class="_index_nav" style="bottom:170px;">90</div></a> -->
						<a href="javascript:void(0)" onclick="dyncLoadData('task','-1');"><div class="_index_nav" style="bottom:130px;"><img src="<%=path%>/image/navbar_4.png" width="30px"></div></a>
						<a href="<%=path%>/schedule/get?openId=${openId}&publicId=${publicId}"><div class="_index_nav" style="bottom:70px;font-size:25px;">+</div></a>
					</div>
					
					<div id="about" style="display:none;margin:0px;margin-bottom:50px;">
						<div class="site-recommend-list page-patch listContainer">
							<div class="oppty_tags" style="width:100%;padding:8px;color:#aaa;text-align:center;">未来30天及历史未关闭的生意</div>
							<div class="list-group1 listview" id="div_oppty_list">
							</div>
							<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;display:none" id="div_next_oppty">
								<a href="javascript:void(0)" onclick="opptytopage()">
									下一页&nbsp;<img id="opptynextpage" src="<%=path%>//image/nextpage.png" width="24px"/>
								</a>
							</div>
						</div>
						<a href="javascript:void(0)" onclick="dyncLoadData('oppty','30');"><div class="_index_nav" style="bottom:250px;">30</div></a>
						<a href="javascript:void(0)" onclick="dyncLoadData('oppty','90');"><div class="_index_nav" style="bottom:190px;">90</div></a>
						<a href="javascript:void(0)" onclick="dyncLoadData('oppty','-1');"><div class="_index_nav" style="bottom:130px;"><img src="<%=path%>/image/navbar_4.png" width="30px"></div></a>
						<a href="<%=path%>/oppty/get?openId=${openId}&publicId=${publicId}"><div class="_index_nav" style="bottom:70px;font-size:25px;">+</div></a>
					</div>
					<div id="contact" style="display:none;margin-bottom:50px;">
						<div class="site-recommend-list page-patch" id="feed_div" style="background-color:#FDFDFD">
							<!-- 列表 -->
								<div style="width:100%;padding:8px;color:#aaa;text-align:center;">&nbsp;</div>
								<div class="" id="div_feed_list">
								</div>
								<div style="display:none;width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next_feed">
								<a href="javascript:void(0)" onclick="feedtopage()">
									下一页&nbsp;<img id="feednextpage" src="<%=path%>//image/nextpage.png" width="24px"/> 
								</a>
							</div>
						</div>
				</div>
				</div>
			<br/><br/><br/>
			<!-- 消息回复 DIV -->
			<div id="flootermenu" class=" flooter msgContainer _repla_messgae_area" style="display:none;z-index:999999;opacity:1;background-color:#fff;border-top:1px solid #ddd;">
			    <!-- 目标用户ID -->
				<input type="hidden" name="targetUID" />
				<!-- 目标用户名 -->
				<input type="hidden" name="targetUName" />
				<!-- 关联relaModel -->
				<input type="hidden" name="relaModule" />
				<!-- 关联ID -->
				<input type="hidden" name="relaId" />
				<!-- 子级关联ID -->
				<input type="hidden" name="subRelaId" />
				<div class="ui-block-a"
					style="float: left;margin: 5px 0px 10px 10px;">
					<img src="<%=path%>/scripts/plugin/menu/images/downmenu1.png"
						width="30px" style="position:fixed;bottom:10px;" onclick="swicthUpMenu2('flootermenu')">
				</div>
				<div
					style="width: 100%;margin: 5px 0px 5px 40px;padding-right: 110px;">
					<textarea name="inputMsg" id="inputMsg" style="width: 98%;font-size: 16px; line-height:20px;height: 40px;margin-left: 5px; margin-top: 0px;" class="form-control" placeholder="回复"></textarea>
				</div>
				<div class="ui-block-a " style="float: right;width: 60px;margin: -45px 8px 5px 0px;">
					<a href="javascript:void(0)" class="btn  btn-block _send_message_button" style="font-size: 14px;width:100%;">发送</a>
				</div>
			</div>
			<div class="feeds_shade menu_shade" style="display: none"></div>
			<script type="text/javascript">
				$(function(){
					$("#about-button").css({
						opacity: 0.2
					});
					$("#contact-button").css({
						opacity: 0.2
					});
		            $("#page-wrap div.button").click(function(){
		            	var height = $("#flootermenu").height(); 
		            	if(height > 1){
		            		swicthUpMenu2("flootermenu");
		            	}
		            	
		            	$clicked = $(this);
		            	if ($clicked.css("opacity") != "1" && $clicked.is(":not(animated)")) {
		            		
		            		$clicked.animate({
		            			opacity: 1,
		            			borderWidth: 3
		            		}, 600 );
		            		var idToLoad = $clicked.attr("id").split('-');
		            		
		            		$("#content").children("div:visible").fadeOut("fast", function(){
		            			$(this).parent().find("#"+idToLoad[0]).fadeIn();
		            		})
		            	}
		            	$clicked.siblings(".button").animate({
		            		opacity: 0.5,
		            		borderWidth: 1
		            	}, 600 );
		            });
				});
			</script>
			<!--  -->
			<script>
			$("#refreshpng").css("display","none");
			$("#backpng").css("display","none");
			$("#homeindex").css("display","none");
			$("#_qrcode").css("display","");
			$("#_cancelbinding").css("display","");
			$("#newsindex").css("display","");
			$("#menu_switch").css("display","none");
			</script>
			<jsp:include page="/common/menu.jsp" flush="true"></jsp:include>
		</c:if>
	</form>
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>