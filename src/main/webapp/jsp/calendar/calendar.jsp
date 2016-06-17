<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();

%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0 user-scalable=yes" />
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet"
	href="<%=path%>/scripts/plugin/calendar/fullcalendar2.css" />

<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script type="text/javascript"
	src="<%=path%>/scripts/plugin/calendar/fullcalendar.js"></script> 
<script type="text/javascript"
	src="<%=path%>/scripts/plugin/calendar/jquery/jquery-ui-1.10.3.custom.min.js"></script> 
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/currDate.util.js" type="text/javascript"></script>

<style>
.appoint_box{ width:100%;margin-bottom:50px;}

</style>
<script>
//缓存数据
var todayDate=formatDate(now);
var clickDate = todayDate;
//对Date的扩展，将 Date 转化为指定格式的String
//月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
//年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
//例子： 
//(new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
//(new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18 
Date.prototype.Format = function (fmt) { //author: meizz 
 var o = {
     "M+": this.getMonth() + 1, //月份 
     "d+": this.getDate(), //日 
     "h+": this.getHours(), //小时 
     "m+": this.getMinutes(), //分 
     "s+": this.getSeconds(), //秒 
     "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
     "S": this.getMilliseconds() //毫秒 
 };
 if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
 for (var k in o)
 if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
 return fmt;
}
//+--------------------------------------------------- 
//| 字符串转成日期类型 
//| 格式 MM/dd/YYYY MM-dd-YYYY YYYY/MM/dd YYYY-MM-dd 
//+--------------------------------------------------- 
function StringToDate(strDate) 
{ 
  var date = eval('new Date(' + strDate.replace(/\d+(?=-[^-]+$)/,
  function (a) { return parseInt(a, 10) - 1; }).match(/\d+/g) + ')');
  return date;
} 

function formatDateStr(date){
	var a = new Date(date);
	return a.Format("yyyy-MM-dd");
}

//计算天数差的函数，通用  
function  DateDiff(sDate1,  sDate2){    //sDate1和sDate2是2002-12-18格式
     iDays  =  parseInt(Math.abs(StringToDate(sDate1)  -  StringToDate(sDate2))  /  1000  /  60  /  60  /24)    //把相差的毫秒数转换为天数  
     return  iDays  
}

function checkDate(d){
	return isNaN(d) || d.Format("yyyy-MM-dd") == "1970-01-01" || d.Format("yyyy-MM-dd") == "0000-00-00";
}


//加载推荐活动
function loadActivity(){
    $(".activitylist_no_data").removeClass("none").addClass("none");
	$(".loading_activity_data").removeClass("none");
	$.ajax({
	   type: 'post',
	   url: '<%=path%>/zjactivity/recomlist',
	   data: {},
	   dataType: 'text',
	   success: function(data){
			$(".loading_activity_data").removeClass("none").addClass("none");
		    $(".activitylist_no_data").removeClass("none");
		   if(!data){
		   	  return;
		   }
		   var d = JSON.parse(data);
		   if(!d){
			   return;
		   }
		   $(".activitylist").empty();
		   var num  = 0;
		   $(d).each(function(){
			   try{
    			   var val = "";
    			   
    			   if (num >=3) {
			   			$(".div_more_activity").removeClass("none");
		    			val = '<a class="more_activity none" href="<%=path%>/zjwkactivity/detail?id='+this.rowid+'&source=WK&sourceid=${partyId}">';
			   	   }else{
	    			    val = '<a href="<%=path%>/zjwkactivity/detail?id='+this.id+'&source=WK&sourceid=${partyId}">';
			   	   }
				   val += '<div style="padding:5px 0px;font-size:14px;border-bottom:1px solid #eee;">';
    			    if(this.headImageUrl){
						val += '<div style="float:left;"><img src="'+this.headImageUrl +'" width="36px" style="border-radius:18px;"/></div>';
					}else{
						val += '<div style="float:left;"><img src="<%=path %>/image/defailt_person.png" width="36px" style="border-radius:18px;"/></div>';
					}
				   
				 //  val += '<div style="line-height:20px;">&nbsp;&nbsp;' + this.startdate.substr(5,5) + '&nbsp;'+this.name + '</div>';
    			   val += '<div style="line-height:20px;">【活动】'+this.title+'</div>';
    			   val += '<div style="padding-left:45px;line-height:20px;color:#999;">阅读 '+this.readnum +'&nbsp;&nbsp;&nbsp;赞 '+this.praisenum+'&nbsp;&nbsp;&nbsp;评论 '+this.commentnum +'&nbsp;&nbsp;&nbsp;报名 '+this.joinnum +'</div>';
				   val += '</div></a>';
				   $(".activitylist").append(val);
				   num = num + 1;
			   	   $(".activitylist_no_data").removeClass("none").addClass("none");
			   }catch(e){
				   
			   }
		   });
	   }
	});
}


function initStyle(){
	//$(".fc-day-header").css("height","30px");  
	$(".fc-day-header").css("font-size","14px");  
	$(".fc-day-number").css("font-size","16px");  
	$(".fc-day-number").css("font-weight","bold");  
	$(".fc-day-number").css("text-align","center");  
	//$(".fc-day-number").css("padding-top","5px");   
	$(".solarday").css("font-size","8px");   
	$(".solarday").css("color","rgb(190, 190, 190)");   
	$(".solarday").css("font-weight","normal"); 
	$(".solarday").css("padding-top","5px"); 
	$(".holiday").css("font-size","8px");   
	$(".holiday").css("color","rgb(190, 190, 190)");   
	$(".holiday").css("font-weight","normal"); 
	//$(".holiday").css("padding-top","5px");  
	$(".fc-event-inner").css("text-align","center"); 
	$(".fc-first:not(td):not(tr)").css("color","red");  
	$(".fc-last:not(td):not(tr)").css("color","red"); 
	loadActivity();
}

$(function() {
	//查询
	$(".searchtask").click(function(){
		query_schedulejs_choose();
	});
	//
	$('#calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,basicWeek'
		},
		handleWindowResize:true,
		editable: true,
		events: [
			
		],
		dayClick: function(date, allDay, jsEvent, view) { 
			   $(".fc-state-highlight").removeClass("fc-state-highlight");
			   $(this).addClass("fc-state-highlight");
			   var selDate =$.fullCalendar.formatDate(date,'yyyy-MM-dd');//格式化日期   
			   if(clickDate == "" || clickDate != selDate){
				   clickDate = selDate;
	           	 syncGetTask(selDate,selDate,true);
	           	   asyncLoadActivity(selDate);
			   }
	    }
	});
	
	//下一月/周/天
	$(".fc-button-next").click(function(){
		var view = $('#calendar').fullCalendar('getView');
		syncGetTask(formatDateStr(view.visStart),formatDateStr(view.visEnd),true);
		asyncLoadActivity(formatDateStr(view.visStart));
	});
	
	//上一月/周/天
	$(".fc-button-prev").click(function(){
		var view = $('#calendar').fullCalendar('getView');
		syncGetTask(formatDateStr(view.visStart),formatDateStr(view.visEnd),true);
		asyncLoadActivity(formatDateStr(view.visStart));
	});
	
	$(".fc-button-today").click(function(){
		$(".fc-state-highlight").removeClass("fc-state-highlight");
		$(".fc-today").addClass("fc-state-highlight");
		if(clickDate == "" || clickDate != todayDate){
			clickDate = todayDate;
			syncGetTask(todayDate,todayDate,true);
			asyncLoadActivity(todayDate);
		}
	});
	
	//切换到月
	$(".fc-button-month").click(function(){
		var view = $('#calendar').fullCalendar('getView');
		syncGetTask(formatDateStr(view.visStart),formatDateStr(view.visEnd),true);
		asyncLoadActivity(formatDateStr(now));
	});
	
	$(".fc-button-agendaWeek").click(function(){
		var view = $('#calendar').fullCalendar('getView');
		syncGetTask(formatDateStr(view.visStart),formatDateStr(view.visEnd),true);
		asyncLoadActivity(formatDateStr(now));
	});

	//切换到周
	$(".fc-button-basicWeek").click(function(){
		var view = $('#calendar').fullCalendar('getView');
		syncGetTask(formatDateStr(view.visStart),formatDateStr(view.visEnd),true);
		asyncLoadActivity(formatDateStr(now));
	});
	
	$(".div_more_activity").click(function(){
		$('.more_activity').removeClass("none");
		$(".div_more_activity").removeClass("none").addClass("none");
		$(".div_packup_activity").removeClass("none");
	});
	$(".div_packup_activity").click(function(){
		$('.more_activity').removeClass("none").addClass("none");
		$(".div_more_activity").removeClass("none");
		$(".div_packup_activity").removeClass("none").addClass("none");
	});
	click = todayDate;
	syncGetTask(todayDate,todayDate,true);
	asyncLoadActivity(todayDate);
});

var mapEvents = new TAKMap();
	
function showMark(map,toDay,focusLoadFlag){
	if(focusLoadFlag == false) return;
	var calendarObj = $('#calendar');
	var view = $('#calendar').fullCalendar('getView');
	var start = formatDateStr(view.visStart);
	var end = formatDateStr(view.visEnd);
	map.each(function (datestr,list,index) {
		try{
			$(list).each(function(){
				if(this.desc =="2" || this.desc == "3"){ 
					return;
				}
				if (datestr < start || datestr > end){
					return ;
				}
				var obj = mapEvents.get(datestr); 
				if (obj == null || typeof(obj) == "undefined")
				{
					copiedEventObject =new Object();   
					copiedEventObject.start = datestr;
					copiedEventObject.title='*';
					copiedEventObject.id= datestr;
					//全天性事件
					copiedEventObject.allDay = true; 
					calendarObj.fullCalendar('renderEvent', copiedEventObject, true);
					mapEvents.put(datestr,copiedEventObject);
				}
			});
		}catch(e){
			
		}
	});
}
function sortTodayList(list){
	return list.sort(function(left, right) {
		var b = StringToDate(left.startdate) > StringToDate(right.startdate);
		return b ? 1 : -1;
	});
}
function getDelayDays(start,end){
	if(checkDate(StringToDate(end))){
		var begin = formatDateStr(StringToDate(start));
		var nday = DateDiff(begin,clickDate);
		return isNaN(nday) ? 0 : nday;
	}
	var end = formatDateStr(StringToDate(end));
	if("1900-01-31"==end){
		end = start;
	}
	var nday = DateDiff(end,clickDate);
	return isNaN(nday) ? 0 : nday;
}
function sortDelayList(list){
	return list.sort(function(left, right) {
		var a = getDelayDays(left.startdate,left.enddate);
		var b = getDelayDays(right.startdate,right.enddate);
		return (a>b) ? -1 : 1;
	});
}
function getItem(date,content){
	return '<div style="float:left;width:100%;text-align:left;line-height:20px;padding:1px 3px 1px 10px;border-bottom: 1px solid #ddd;">' + date + '&nbsp;' + content + '</div>';   
}
function showToDay(map,toDay){
	var showtext = "";
	var flag = false;
	map.each(function (datestr,list,index) {
		try{
			if (datestr.substr(0,10) != clickDate){
				return;
			}
			var tlist = sortTodayList(list);
			$(tlist).each(function(j){
				try{
					var shareusername = "";
				/* 	if("${openId}" != this.openId){
						shareusername = this.assigner;
					} */
					if(!this.desc || this.desc =="" || this.desc =="1"){ 
						showtext += '<div style="font-size:14px;color:#999;" >';
						var begin = formatDateStr(StringToDate(this.startdate));
						var end = formatDateStr(StringToDate(this.enddate));
						if(this.relaname && this.relaname.length>8){
							this.relaname = this.relaname.substr(8)+"...";
						}
						var content = '<a href="<%=path%>/schedule/detail?orgId='+this.orgId+'&schetype='+this.schetype+'&rowId='+this.rowid+'">'+this.title+'<span style="margin-left:10px;">'+this.relaname+''+'</span></a>&nbsp;<span style="color:#999;">' + '('+shareusername + '&nbsp;' + this.statusname+') </span>';
						if(begin < end){
							showtext += getItem("全天&nbsp;" + "(" + this.startdate.substr(5,5) + " ~ " + this.enddate.substr(5,5) + ")",content);
						}else if(begin == end && this.startdate.substr(11,5) == "00:00"){
							showtext += getItem("全天",content);
						}else if(begin == end){
							showtext += getItem("(" + this.startdate.substr(11,5) + ")",content);
						}else{
							if(this.enddate){
								showtext += getItem(this.startdate.substr(11,5)+' ~ '+this.enddate.substr(11,5),content);   
							}else{
								showtext += getItem(this.startdate.substr(11,5),content);   
							}
						}
						flag = true;
						showtext += '</div>';
					}
				}catch(e1){
					
				}
			});
		}catch(e){
			
		}

	});
	$(".tasklist").empty();
	if (flag == false){
		$(".tasklist_no_data").removeClass("none");
		$(".tasklist_no_data").attr("flag","nodata");
	}else{
		$(".tasklist").html(showtext);
		$(".tasklist_no_data").attr("flag","");
	}
}
<%-- 
function showDelayTask(map,list,datestr){
	var showtext = "";
	var flag = false;
	var tlist;
	try{
		tlist = sortDelayList(list);
	}catch(e){
		tlist = list;
	}
	$(tlist).each(function(j){
		try{
			var shareusername = "";
			if(!this.desc || this.desc =="" || this.desc =="1"){
			/* 	if("${openId}" != this.openId){
					shareusername = this.assigner;
				} */
				
				showtext += '<div style="font-size:14px;color:#999;">';
				var begin = formatDateStr(StringToDate(this.startdate));
				var end = formatDateStr(StringToDate(this.enddate));
				var day = getDelayDays(this.startdate,this.enddate);
				alert(1);
				if(day>0){
					var content = '<a href="<%=path%>/schedule/detail?orgId='+this.orgId+'&schetype='+this.schetype+'&rowId='+this.rowid+'">'+this.title+'</a>&nbsp;<span style="color:#999;">' + '('+shareusername + '&nbsp;延期' + day + '天) </span>';
						if (checkDate(StringToDate(this.enddate)) && this.startdate.substr(11,5) == "00:00"){
							showtext += getItem("全天(" + this.startdate.substr(5,5) + ")",content);   
						}else if(checkDate(StringToDate(this.enddate))){
							showtext += getItem("(" + this.startdate.substr(5,11) + ")",content);   
						}else if(begin < end){
							showtext += getItem("(" + this.startdate.substr(5,5) + " ~ " + this.enddate.substr(5,5) + ")",content);   
						}else if(begin == end && this.startdate < this.enddate){
		//					showtext += getItem("(" + this.startdate.substr(5,11) + " ~ " + this.enddate.substr(5,11) + ")<br/>&nbsp;&nbsp;",content);   
							showtext += getItem("(" + this.startdate.substr(5,5) + " ~ " + this.enddate.substr(5,5) + ")",content);   
						}else if (begin == end && this.startdate.substr(11,5) == "00:00"){
							showtext += getItem("全天(" + this.startdate.substr(5,5) + ")",content);   
						}else{
							showtext += getItem("(" + this.startdate.substr(5,11) + ")",content);   
						}
						flag = true;
						showtext += '</div>';
					}
			  }
			}catch(e1){
				
			}
		});		
		$(".delaytasklist").empty();
		if (flag == false){
			$(".delaytasklist_no_data").removeClass("none");
		}else{
			
			 $(".delaytasklist").html(showtext);
		}
	}
	 --%>
//延期活动
function showDelayTask(map,list,datestr){
	var showtext = "";
	var flag = false;
	var tlist;
	try{
		tlist = sortDelayList(list);
	}catch(e){
		tlist = list;
	}
	$(tlist).each(function(j){
		try{
			var shareusername = "";
			if(this.desc =="" || this.desc =="1"){
			/* 	if("${openId}" != this.openId){
					shareusername = this.assigner;
				} */
				showtext += '<div style="font-size:14px;color:#999;">';
				var begin = formatDateStr(StringToDate(this.startdate));
				var end = formatDateStr(StringToDate(this.enddate));
				var day = getDelayDays(this.startdate,this.enddate);
				if(day>0){
					var content = '<a href="<%=path%>/schedule/detail?orgId='+this.orgId+'&schetype='+this.schetype+'&rowId='+this.rowid+'">'+this.title+'</a>&nbsp;<span style="color:#999;">' + '('+shareusername + '&nbsp;延期' + day + '天) </span>';
						if (checkDate(StringToDate(this.enddate)) && this.startdate.substr(11,5) == "00:00"){
							showtext += getItem("全天(" + this.startdate.substr(5,5) + ")",content);   
						}else if(checkDate(StringToDate(this.enddate))){
							showtext += getItem("(" + this.startdate.substr(5,11) + ")",content);   
						}else if(begin < end){
							showtext += getItem("(" + this.startdate.substr(5,5) + " ~ " + this.enddate.substr(5,5) + ")",content);   
						}else if(begin == end && this.startdate < this.enddate){
		//					showtext += getItem("(" + this.startdate.substr(5,11) + " ~ " + this.enddate.substr(5,11) + ")<br/>&nbsp;&nbsp;",content);   
							showtext += getItem("(" + this.startdate.substr(5,5) + " ~ " + this.enddate.substr(5,5) + ")",content);   
						}else if (begin == end && this.startdate.substr(11,5) == "00:00"){
							showtext += getItem("全天(" + this.startdate.substr(5,5) + ")",content);   
						}else{
							showtext += getItem("(" + this.startdate.substr(5,11) + ")",content);   
						}
						flag = true;
						showtext += '</div>';
					}
				}
			}catch(e1){
				
			}
		});		
		$(".delaytasklist").empty();
		if (flag == false){
			$(".delaytasklist_no_data").removeClass("none");
		}else{
			
			 $(".delaytasklist").html(showtext);
		}
	}	
	
	
//下属日程
function showSubordinateTask(map,list,datestr){
	var showtext = "";
	var flag = false;
	var tlist;
	try{
		tlist = sortDelayList(list);
	}catch(e){
		tlist = list;
	}
	$(tlist).each(function(j){
		try{
			var shareusername = "";
			
			if(this.desc =="2"){
				if("${openId}" != this.openId){
					shareusername = this.assigner;
				}
				if(this.relaname && this.relaname.length>8){
					this.relaname = this.relaname.substr(8)+"...";
				}
				showtext += '<div style="font-size:14px;color:#999;">';
				var begin = formatDateStr(StringToDate(this.startdate));
				var end = formatDateStr(StringToDate(this.enddate));
				var day = getDelayDays(this.startdate,this.enddate);
				var content = "";
				if(day > 0){
					if(getDelayDays(formatDateStr(date),this.enddate) < 0){
						content = '<a href="<%=path%>/schedule/detail?orgId='+this.orgId+'&schetype='+this.schetype+'&rowId='+this.rowid+'">'+this.title+'<span style="margin-left:10px;">'+this.relaname+''+'</span></a>&nbsp;<span style="color:#999;">' + '('+shareusername + '&nbsp;延期' + day + '天) </span>';
					}else{
						return false;
					}
				}else{
					content = '<a href="<%=path%>/schedule/detail?orgId='+this.orgId+'&schetype='+this.schetype+'&rowId='+this.rowid+'">'+this.title+'<span style="margin-left:10px;">'+this.relaname+''+'</span></a>&nbsp;<span style="color:#999;">' + '('+shareusername + ') </span>';
				}
					if (checkDate(StringToDate(this.enddate)) && this.startdate.substr(11,5) == "00:00"){
						showtext += getItem("全天(" + this.startdate.substr(5,5) + ")",content);   
					}else if(checkDate(StringToDate(this.enddate))){
						showtext += getItem("(" + this.startdate.substr(5,11) + ")",content);   
					}else if(begin < end){
						showtext += getItem("(" + this.startdate.substr(5,5) + " ~ " + this.enddate.substr(5,5) + ")",content);   
					}else if(begin == end && this.startdate < this.enddate){
	//					showtext += getItem("(" + this.startdate.substr(5,11) + " ~ " + this.enddate.substr(5,11) + ")<br/>&nbsp;&nbsp;",content);   
						showtext += getItem("(" + this.startdate.substr(5,5) + " ~ " + this.enddate.substr(5,5) + ")",content);   
					}else if (begin == end && this.startdate.substr(11,5) == "00:00"){
						showtext += getItem("全天(" + this.startdate.substr(5,5) + ")",content);   
					}else{
						showtext += getItem("(" + this.startdate.substr(5,11) + ")",content);   
					}
					flag = true;
					showtext += '</div>';
				}
			}catch(e1){
				
			}
		});		
		$(".subordinatelist").empty();
		if (flag == false){
			$(".subordinatelist_no_data").removeClass("none");
		}else{
			
			 $(".subordinatelist").html(showtext);
		}
	}	

//分享日程
function showShareTask(map,list,datestr){
	var showtext = "";
	var flag = false;
	var tlist;
	try{
		tlist = sortDelayList(list);
	}catch(e){
		tlist = list;
	}
	$(tlist).each(function(j){
		try{
			var shareusername = "";
			
			if(this.desc =="3"){
				if("${openId}" != this.openId){
					shareusername = this.assigner;
				}
				if(this.relaname && this.relaname.length>8){
					this.relaname = this.relaname.substr(8)+"...";
				}
				showtext += '<div style="font-size:14px;color:#999;">';
				var begin = formatDateStr(StringToDate(this.startdate));
				var end = formatDateStr(StringToDate(this.enddate));
				var day = getDelayDays(this.startdate,this.enddate);
				var content = "";
				if(day > 0){
					if(getDelayDays(formatDateStr(date),this.enddate) < 0){
						content = '<a href="<%=path%>/schedule/detail?orgId='+this.orgId+'&schetype='+this.schetype+'&rowId='+this.rowid+'">'+this.title+'<span style="margin-left:10px;">'+this.relaname+''+'</span></a>&nbsp;<span style="color:#999;">' + '('+shareusername + '&nbsp;延期' + day + '天) </span>';
					}else{
						return false;
					}
				}else if(shareusername && shareusername!=""){
					content = '<a href="<%=path%>/schedule/detail?orgId='+this.orgId+'&schetype='+this.schetype+'&rowId='+this.rowid+'">'+this.title+'<span style="margin-left:10px;">'+this.relaname+''+'</span></a>&nbsp;<span style="color:#999;">' + '('+shareusername + ') </span>';
				}else{
					content = '<a href="<%=path%>/schedule/detail?orgId='+this.orgId+'&schetype='+this.schetype+'&rowId='+this.rowid+'">'+this.title+'<span style="margin-left:10px;">'+this.relaname+''+'</span></a>&nbsp;<span style="color:#999;"></span>';
				}
					if (checkDate(StringToDate(this.enddate)) && this.startdate.substr(11,5) == "00:00"){
						showtext += getItem("全天(" + this.startdate.substr(5,5) + ")",content);   
					}else if(checkDate(StringToDate(this.enddate))){
						showtext += getItem("(" + this.startdate.substr(5,11) + ")",content);   
					}else if(begin < end){
						showtext += getItem("(" + this.startdate.substr(5,5) + " ~ " + this.enddate.substr(5,5) + ")",content);   
					}else if(begin == end && this.startdate < this.enddate){
	//					showtext += getItem("(" + this.startdate.substr(5,11) + " ~ " + this.enddate.substr(5,11) + ")<br/>&nbsp;&nbsp;",content);   
						showtext += getItem("(" + this.startdate.substr(5,5) + " ~ " + this.enddate.substr(5,5) + ")",content);   
					}else if (begin == end && this.startdate.substr(11,5) == "00:00"){
						showtext += getItem("全天(" + this.startdate.substr(5,5) + ")",content);   
					}else{
						showtext += getItem("(" + this.startdate.substr(5,11) + ")",content);   
					}
					flag = true;
					showtext += '</div>';
				}
			}catch(e1){
				
			}
		});		
		$(".sharelist").empty();
		if (flag == false){
			$(".sharelist_no_data").removeClass("none");
		}else{
			
			 $(".sharelist").html(showtext);
		}
	}		

	//异步获取日程数据
	function syncGetTask(startDate, endDate, focusLoadFlag) {
		$(".subordinatelist_no_data").removeClass("none").addClass("none");
	    $(".delaytasklist_no_data").removeClass("none").addClass("none");
	    $(".tasklist_no_data").removeClass("none").addClass("none");
	    $(".sharelist_no_data").removeClass("none").addClass("none");
		var view = $('#calendar').fullCalendar('getView');
		var start = formatDateStr(view.visStart);
		var end = formatDateStr(view.visEnd);

		
		var dataObj = [];
		dataObj.push({
			name : 'crmId',
			value : '${crmId}'
		});

		
		dataObj.push({
			name : 'startDate',
			value : startDate
		});
		dataObj.push({
			name : 'endDate',
			value : end
		});
		//dataObj.push({name:'startDate', value:startDate});
		//dataObj.push({name:'endDate', value:endDate});

		dataObj.push({
			name : 'currpage',
			value : '1'
		});
		dataObj.push({
			name : 'pagecount',
			value : '1000'
		});
		dataObj.push({
			name : 'viewtype',
			value : 'calendarview'
		});
		dataObj.push({
			name : 'schetype',
			value : 'task'
		});
		 $(".subordinatelist_div").removeClass("none").addClass("none");
		 $(".sharelist_div").removeClass("none").addClass("none");
	    $(".delaytasklist_div").removeClass("none").addClass("none");
	    $(".tasklist_div").removeClass("none").addClass("none");
		$(".tasklist").empty();
		
		//$(".delaytasklist").html("");

		$(".loading_task_data").removeClass("none");
		$(".loading_delaytask_data").removeClass("none");
		$(".loading_calendar_data").removeClass("none");
		$(".loading_subordinate_data").removeClass("none");
		$(".loading_share_data").removeClass("none");
		$.ajax({
			type : 'post',
			url : '<%=path%>/schedule/synctasklist',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				$(".loading_task_data").removeClass("none").addClass("none");
				$(".loading_delaytask_data").removeClass("none").addClass("none");
				$(".loading_subordinate_data").removeClass("none").addClass("none");
				$(".loading_share_data").removeClass("none").addClass("none");
				if(!data){
					$(".delaytasklist_no_data").removeClass("none");
				    $(".tasklist_no_data").removeClass("none");
				    $(".tasklist_no_data").attr("flag","nodata");
				    $(".loading_subordinate_data").attr("flag","nodata");
				    $(".loading_subordinate_data").removeClass("none");
				    $(".loading_share_data").attr("flag","nodata");
				    $(".loading_share_data").removeClass("none");
					$(".loading_calendar_data").removeClass("none").addClass("none");
					return;
				}
				var d = JSON.parse(data); 
				if(!d || $(d).size() == 0){
					$(".delaytasklist_no_data").removeClass("none");
				    $(".tasklist_no_data").removeClass("none");
				    $(".tasklist_no_data").attr("flag","nodata");
				    $(".subordinate_no_data").removeClass("none");
				    $(".share_no_data").removeClass("none");
					$(".loading_calendar_data").removeClass("none").addClass("none");
					return;
				}else{
					var map = new TAKMap();
					var tlist = new Array();
					$(d).each(function(i){
						var start_dt = StringToDate(formatDateStr(StringToDate(this.startdate)));
						var end_dt = StringToDate(formatDateStr(StringToDate(this.enddate)));
						var theday;
						if (checkDate(StringToDate(this.enddate))){
							end_dt = start_dt;
							theday = formatDateStr(StringToDate(this.startdate));
						}else{
							theday = formatDateStr(StringToDate(this.enddate));
						}
						if (clickDate >= theday){
							tlist.push(this);
						}
					
						for(var dt = start_dt ; dt <=end_dt ;dt =dt.DateAdd("d",1)){
							try{
								var datestr = formatDateStr(dt);
								var list = map.get(datestr);
								if (list == null){
									list = new Array();
								}
								var found = false;
								var dthis = this;
								$(list).each(function(j){
									if (dthis.rowid == this.rowid){
										found = true;
										return;
									}
								});
								if (found == false){
									list.push(this);
									map.put(datestr,list);
								}
							}catch(e){
								
							}
						}
						
					});
					map = sortByKeys(map);
					try{
						showMark(map,clickDate,focusLoadFlag);
					}catch(e){
						
					}
					try{
						showToDay(map,clickDate);
					}catch(e){
					    $(".tasklist_no_data").removeClass("none");
					    $(".tasklist_no_data").attr("flag","nodata");
					}
					try{
						//if (!$(".delaytasklist").html())
						//{
							showDelayTask(map,tlist,clickDate);
						//}
					}catch(e){
						$(".delaytasklist_no_data").removeClass("none");
					}
					try{
					//	if (!$(".subordinatelist").html())
					//	{
							showSubordinateTask(map,tlist,clickDate);
					//	}
					}catch(e){
						$(".subordinatelist_no_data").removeClass("none");
					}
					try{
						//	if (!$(".subordinatelist").html())
						//	{
								showShareTask(map,tlist,clickDate);
						//	}
						}catch(e){
							$(".share_no_data").removeClass("none");
						}
					
				
					$(".loading_calendar_data").removeClass("none").addClass("none");
				}
			}
	});
	
	//初始化样式
	initStyle();
}
	
function add(value){
	if(value=='task'){
		
		var str="/schedule/get?schetype="+value+"&clickDate="+clickDate;
		window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent(str);
	}
}


//异步加载与我相关的活动列表
function asyncLoadActivity(startdate){
	$.ajax({
		url:'<%=path%>/zjactivity/asylist',
		method:'post',
		dataType:'text',
		data:{flag:'calendar',startdate:startdate},
		success:function(data){
			if(!data){
				return;
			}else{
				var d = JSON.parse(data);
				var showtext = '';
				var flag =  false;
				$(d).each(function(){
					showtext += '<div style="font-size:14px;color:#999;">';
					var content = '<a id="'+this.id+'" href="<%=path%>/zjwkactivity/detail?source=wkshare&id='+this.id+'">'+this.title+'</a>';
					if(this.place){
						content += '---'+this.place;
					}
					content += '&nbsp;<span style="color:#999;">' + '('+this.createName+') </span>';
					if(this.type == 'meet'){
						showtext += getItem("聚会 &nbsp;(" + this.start_date.substr(5,5)+ ")",content);
					}else{
						showtext += getItem("会议 &nbsp;(" + this.start_date.substr(5,5) + " ~ " + this.act_end_date.substr(5,5) + ")",content);
					}
					showtext += '</div>';
					flag = true;
				});
				var taskflag = $(".tasklist_no_data").attr("flag");
				if(flag == true){
					if("nodata"==taskflag){
						$(".tasklist_no_data").addClass("none");
						$(".tasklist").html(showtext);
					}else{
						$(".tasklist").append(showtext);
					}
				}
			}
		}
	});
}

function searchDataByOrgId(orgId){
   window.location.replace("<%=path%>/calendar/calendar?orgId="+orgId);
}

</script>
<style type='text/css'>
	#calendar {
		width: 100%;
		margin-top: 5px; 
		padding-right:5px;
		padding-left:5px;
	}
	.schedule_month{
		height:65px; 
	}
	.schedule_week{
		height:20px;
	}
	
	.none {
		display: none
	}
	
</style>
</head>
<body>
	
<%-- <jsp:include page="/common/rela/org.jsp">
	<jsp:param value="Discugroup" name="relaModule"/>
</jsp:include> --%>
<div class="site-recommend-list page-patch calendar-list">
	<input type="hidden" name="crmId" value="${crmId }" /> 
	<input type="hidden" name="assignerid" value="${crmId }" /> 
	<input type="hidden" name="assignername" value="" /> 
	<input type="hidden" name="mindate" value="" /> 
	<input type="hidden" name="maxdate" value="" /> 
	<input type="hidden" name="startdate" value="" /> 
	<input type="hidden" name="enddate" value="" />
	<div id="site-nav" class="zjwk_fg_nav">
	    <a href="javascript:void(0)" class="searchtask" style="padding:5px 8px;">筛选</a>
		<a href="javascript:void(0)" onclick="add('task')" style="padding:5px 8px;">新增</a>
	</div>

	<div id='calendar'> 
		<div class="loading_calendar_data"></div>
 	</div>
	<div style="clear: both"></div>

	<div class="appoint_box" style="border-top:1px solid #ddd;margin-top: 5px;">
		<div class="listContainer">
			<div class="div_task_list" id="div_task_list">
				<div style="line-height: 25px;margin: 5px 10px;border-bottom: 2px solid #aaaaaa;">
					日程
				</div>
				<div class="tasklist"></div>	
				<div class="loading_task_data none" style="text-align: center; padding-top: 5px;"><img src="<%=path%>/image/loading.gif"></div>
				<div class="tasklist_no_data"  style="text-align: center; padding-top: 5px;">没有找到数据</div>
			</div>
			<div style="clear: both"></div>
			<div class="div_delaytask_list" id="div_task_list">
				<div style="line-height: 25px;margin: 5px 10px;border-bottom: 2px solid #aaaaaa;">
					延期任务
				</div>
				<div class="delaytasklist"></div>	
				<div class="loading_delaytask_data none" style="text-align: center; padding-top: 5px;"><img src="<%=path%>/image/loading.gif"></div>
				<div class="delaytasklist_no_data" style="text-align: center; padding-top: 5px;">没有找到数据</div>
			</div>
			<div style="clear: both"></div>
			<div class="div_activity_list">
				<div style="line-height: 25px;margin: 5px 10px;border-bottom: 2px solid #aaaaaa;">
					推荐活动
					<div style="float:right;" class="div_more_activity none"><a>更多</a></div> 
					<div style="float:right;" class="div_packup_activity none"><a>收起</a></div> 
				</div>
				<div class="activitylist" style="padding-left: 10px;">
				</div>	
				<div class="loading_activity_data none" style="text-align: center; padding-top: 5px;"><img src="<%=path%>/image/loading.gif"></div>
				<div class="activitylist_no_data" style="text-align: center; padding-top: 5px;">没有找到数据</div>
			</div>
			<div style="clear: both"></div>
			<div class="div_subordinate_list" id="div_task_list">
				<div style="line-height: 25px;margin: 5px 10px;border-bottom: 2px solid #aaaaaa;">
					下属日程
				</div>
				<div class="subordinatelist"></div>	
				<div class="loading_subordinate_data none" style="text-align: center; padding-top: 5px;"><img src="<%=path%>/image/loading.gif"></div>
				<div class="subordinatelist_no_data" style="text-align: center; padding-top: 5px;">没有找到数据</div>
			</div>
			<div style="clear: both"></div>
			<div class="div_share_list" id="div_task_list">
				<div style="line-height: 25px;margin: 5px 10px;border-bottom: 2px solid #aaaaaa;">
					分享日程
				</div>
				<div class="sharelist"></div>	
				<div class="loading_share_data none" style="text-align: center; padding-top: 5px;"><img src="<%=path%>/image/loading.gif"></div>
				<div class="sharelist_no_data" style="text-align: center; padding-top: 5px;">没有找到数据</div>
			</div>
			<div style="clear: both"></div>
		</div>
	</div>
</div>
	<jsp:include page="/common/query/qrytask.jsp"></jsp:include>
	<jsp:include page="/common/footer.jsp"></jsp:include>		
</body>
</html>