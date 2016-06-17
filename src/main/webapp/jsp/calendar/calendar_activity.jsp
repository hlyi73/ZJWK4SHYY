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
	.ask_list{ width:100%; background:#faf8f6; border-bottom:1px solid #cccccc; border-top:1px solid #cccccc; padding:10px 0;}
	.ask_list .liststyle{ width:93%; margin-left:3%; border:1px solid #3a87ad; -moz-border-radius:6px; -webkit-border-radius:6px; border-radius:6px; overflow:hidden;}
	.ask_list .liststyle a{ display:block; width:50%; float:left; text-align:center; color:#999999; padding:7px 0; font-size:16px; line-height:20px;}
	.ask_list .liststyle a.hit{ background:#3a87ad; color:#fff;}
	
	</style>
<script>
//缓存数据
var clickDate=formatDate(new Date);
var sche_data = [];
var minDate = null;
var maxDate = null;
var currLoadDate="";
function initStyle(){
	$(".fc-day-header").css("height","30px");  
	$(".fc-day-header").css("font-size","14px");  
	$(".fc-day-number").css("font-size","16px");  
	$(".fc-day-number").css("font-weight","bold");  
	$(".fc-day-number").css("text-align","center");  
	$(".fc-day-number").css("padding-top","5px");   
	$(".solarday").css("font-size","8px");   
	$(".solarday").css("color","rgb(190, 190, 190)");   
	$(".solarday").css("font-weight","normal"); 
	$(".solarday").css("padding-top","5px"); 
	$(".holiday").css("font-size","8px");   
	$(".holiday").css("color","rgb(190, 190, 190)");   
	$(".holiday").css("font-weight","normal"); 
	$(".holiday").css("padding-top","5px");  
	$(".fc-event-inner").css("text-align","center"); 
	$(".fc-first:not(td):not(tr)").css("color","red");  
	$(".fc-last:not(td):not(tr)").css("color","red"); 

}
function addDays(date,n){ 
    var time=date.getTime(); 
    var newTime=time+n*24*60*60*1000; 
    return new Date(newTime); 
};  

$(function() {
	
	$('#calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,basicWeek'
		},
		handleWindowResize:true,
		//weekends:false,
		editable: true,
		events: [
			
		],
		dayDblClick:function(date,allDay,jsEvent,view){
			  $(".fc-state-highlight").removeClass("fc-state-highlight");
			  $(this).parent().addClass("fc-state-highlight");

			   var selDate =$.fullCalendar.formatDate(date,'yyyy-MM-dd');//格式化日期   
	           clickDate=selDate;
	           var val = "";
	           $("#div_task_list").html('');
	           var weekDate=date;
	           var week=new Array();
	           var days=date.getDay();

	           for(var d=days;d>0;d--){
		       	   week.push(addDays(date, -d));
		       };
		       for(var k=0;k<(7-days);k++){
		        	   week.push(addDays(date,k));
		       }
		       var tmpday = '';
		       for(var i=0;i<sche_data.length;i++){
		        	for(var w=0;w<week.length;w++){      
						if(sche_data[i]['date'] == $.fullCalendar.formatDate(week[w],'yyyy-MM-dd')){
							var tmp = sche_data[i]['tasks'];
							for(var j =0;j<tmp.length;j++){
								if(tmpday == '' || tmp[j]["startdate"].substr(5,5) != tmpday){
									tmpday = tmp[j]["startdate"].substr(5,5);
									val += '<div style="line-height: 25px;margin: 5px 10px;border-bottom: 1px solid #ddd;">'+tmp[j]["startdate"].substr(5,5)+'</div>';
								}
								val += '<div style="font-size:14px;color:#666;">';
								val += '<div style="float:left;width:120px;text-align:center;line-height:30px;padding:3px 10px;">'+tmp[j]["startdate"].substr(11,5) +' - '+tmp[j]["enddate"].substr(11,5)+'</div>';    
								val += '<div style="margin-left:80px;text-align:left;line-height:30px;padding:3px;"><a href="<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/activity/detail?id='+tmp[j]["rowid"]+'&source=wkshare&sourceid=${partyId}">'+tmp[j]["title"]+'</div>';
								val += '</div>';
							}
							val+='<p style="border-top: 1px solid #FAFAFA;margin:0px 15px;"></p>';
							break;
						}
		        	   }
		        	$("#div_task_list").html(val);
				}
		           
	        	$("#div_Rss_list").html('');
		        loadUnfinished(formatDate(date));
		        loadActivity('join',$.fullCalendar.formatDate(week[0],'yyyy-MM-dd'),$.fullCalendar.formatDate(week[6],'yyyy-MM-dd'));
	           
		},
		dayClick: function(date, allDay, jsEvent, view) { 		
			  $(".fc-state-highlight").removeClass("fc-state-highlight");
			  $(this).addClass("fc-state-highlight");
			   
			   var selDate =$.fullCalendar.formatDate(date,'yyyy-MM-dd');//格式化日期   
	           clickDate=selDate;
	           var val = "";

	           if(currLoadDate!=selDate){
	        	   $("#div_task_list").html('');
	        	   var tmpday = '';
	        	   for(var i=0;i<sche_data.length;i++){
						if(sche_data[i]['date'] == selDate){
							var tmp = sche_data[i]['tasks'];
							for(var j =0;j<tmp.length;j++){
								if(tmpday == '' || tmp[j]["startdate"].substr(5,5) != tmpday){
									tmpday = tmp[j]["startdate"].substr(5,5);
									val += '<div style="line-height: 25px;margin: 5px 10px;border-bottom: 1px solid #ddd;">'+tmp[j]["startdate"].substr(5,5)+'</div>';
								}
								val += '<div style="font-size:14px;color:#666;">';
								val += '<div style="float:left;width:120px;text-align:center;line-height:30px;padding:3px 10px;">'+tmp[j]["startdate"].substr(11,5) +' - '+tmp[j]["enddate"].substr(11,5)+'</div>';    
								val += '<div style="margin-left:80px;text-align:left;line-height:30px;padding:3px;"><a href="<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/activity/detail?id='+tmp[j]["rowid"]+'&source=wkshare&sourceid=${partyId}">'+tmp[j]["title"]+'</div>';
								val += '</div>';
							}
							val+='<p style="border-top: 1px solid #FAFAFA;margin:0px 15px;"></p>';
							break;
						}
		        	 }
		           $("#div_task_list").html(val);
	        	   
	        	   $("#div_Rss_list").html('');
		           loadActivity('join',selDate,selDate);
	           }
	       }
	});
	
	//下一月/周/天
	$(".fc-button-next").click(function(){
		  $("#div_Rss_list").html('');
		gotoOper();
	});
	
	//上一月/周/天
	$(".fc-button-prev").click(function(){
		  $("#div_Rss_list").html('');
		gotoOper();
	});
	
	$(".fc-button-today").click(function(){
		
		todayTask();
	});
	
	$(".fc-button-month").click(function(){
		 $("#div_Rss_list").html('');
		clickDate=formatDate(new Date);
		gotoOper();
	});
	
	$(".fc-button-agendaWeek").click(function(){
		clickDate=formatDate(new Date);
		gotoOper(); 
	});
	
	$(".fc-button-agendaDay").click(function(){
		clickDate=formatDate(new Date);
		gotoOper();
	});
	
	//加载数据
	gotoOper();
	//初始化样式
	initStyle();
});

function todayTask(){
	$("#div_Rss_list").html('');
	$(".fc-state-highlight").removeClass("fc-state-highlight");
	$(".fc-today").addClass("fc-state-highlight");
	clickDate=formatDate(new Date);
	gotoOper();
}


function formatDate(date){
	var a = new Date(date);
	var em=a.getMonth() + 1 ,ed = a.getDate();
	if(em < 10){
		em = '0' + em;
	}
	if(ed < 10){
		ed = '0' + ed;
	}
	return a.getFullYear()+"-"+em+"-"+ed;
}
function dateOper(dd,dadd){  
	var a = new Date(dd) ; 
	a = a.valueOf()  ;
	a = a + dadd * 24 * 60 * 60 * 1000  ;
	a = new Date(a)  ;
	return a;  
} 

//异步加载活动列表
function loadActivity(viewtype,startDate,endDate){
	var dataObj = [];
	dataObj.push({name:'crmId', value:'${crmId}'});
	dataObj.push({name:'startdate', value:startDate});
	dataObj.push({name:'enddate', value:endDate});
	dataObj.push({name:'currpage', value:'0'});
	dataObj.push({name:'pagecount', value:'1000'});
	dataObj.push({name:'viewtype', value: viewtype || 'owner' });
	$(".loading_task_data").removeClass("none");
	$(".no_task_data").removeClass("none").addClass("none");

	$.ajax({
	      type: 'get',
	      url: '<%=path%>/zjactivity/synclist' || '',
	      data: dataObj || {},
	      dataType: 'text',
	      success: function(data){
				$(".loading_task_data").removeClass("none").addClass("none");
	    	  	if(!data){
					$(".no_task_data").removeClass("none");
	    	  		return;
	    	  	}
	    	    var d = JSON.parse(data);
				if(!d){
					$(".no_task_data").removeClass("none");
					return;
				}else{
					$(".no_task_data").removeClass("none").addClass("none");
					//清空缓存数据
					sche_data = [];  
					var dayTask = [];
					var tmp = [];
					var tDate = null;
					var view = $('#calendar').fullCalendar('getView');
					$(d).each(function(i){
						if(null == tDate || tDate != this.startdate.substring(0,10)){
							dayTask = [];
							tDate = this.startdate.substring(0,10);
							dayTask.push({'title':this.name,'rowid':this.rowid,'startdate':this.startdate,'enddate':this.enddate});
							sche_data.push({'date':tDate,'tasks':dayTask});
						}else if(tDate == this.startdate.substring(0,10)){
							for(var i=0;i<sche_data.length;i++){
								if(sche_data[i]['date'] == tDate){
									tmp = [];
									tmp = sche_data[i]['tasks'];
									tmp.push({'title':this.name,'rowid':this.rowid,'startdate':this.startdate,'enddate':this.enddate});
									sche_data[i]['tasks'] = tmp;
									break;
								}
							}
						}
					});
						$('#calendar').fullCalendar( 'removeEvents');
						var currDate=new Date(clickDate);
				           var week=new Array();
				           var days=currDate.getDay();
				           for(var d=days;d>0;d--){
				        	   week.push(addDays(currDate, -d));
				           };
				           for(var k=0;k<(7-days);k++){
				        	   week.push(addDays(currDate,k));
				           }
				           var val="";
						for(var i=0;i<sche_data.length;i++){
							var tmp = sche_data[i]['tasks'];
							var copiedEventObject;   
							if(view.name == 'agendaDay'){
								for(var j=0;j<tmp.length;j++){
									copiedEventObject =new Object();   
									copiedEventObject.start = tmp[j]['startdate'];
									copiedEventObject.title='';
									copiedEventObject.id= tmp[j]['rowid'];
									//全天性事件
									copiedEventObject.allDay = false; 
									$('#calendar').fullCalendar('removeEvents',  tmp[j]['rowid']);
									$('#calendar').fullCalendar('renderEvent', copiedEventObject, false);  //核心的插入代码 	
								}
							}else if(view.name == 'agendaWeek'){
								for(var j=0;j<tmp.length;j++){
									copiedEventObject =new Object();   
									copiedEventObject.start = tmp[j]['startdate'];
									copiedEventObject.title='*';
									copiedEventObject.id= tmp[j]['rowid'];
									//全天性事件
									copiedEventObject.allDay = false; 
									$('#calendar').fullCalendar('removeEvents',  tmp[j]['rowid']);
									$('#calendar').fullCalendar('renderEvent', copiedEventObject, false);  //核心的插入代码 	
								}
							}else{
								copiedEventObject =new Object();   
								copiedEventObject.start = sche_data[i]['date'];
								copiedEventObject.title= '*';  //标题 
								copiedEventObject.url ='javascript:clickDateEvent(\''+sche_data[i]['date']+'\');';
								
								//全天性事件
								copiedEventObject.allDay = false;
								$('#calendar').fullCalendar('removeEvents',  copiedEventObject);
								$('#calendar').fullCalendar('renderEvent', copiedEventObject, false);  //核心的插入代码 												
							}
							   var tmpday = '';		
							   for(var w=0;w<week.length;w++){      
									if(sche_data[i]['date'] == $.fullCalendar.formatDate(week[w],'yyyy-MM-dd')){
										var tmp = sche_data[i]['tasks'];
										for(var j =0;j<tmp.length;j++){
											if(tmpday == '' || tmp[j]["startdate"].substr(5,5) != tmpday){
												tmpday = tmp[j]["startdate"].substr(5,5);
												val += '<div style="line-height: 25px;margin: 5px 10px;border-bottom: 1px solid #ddd;">'+tmp[j]["startdate"].substr(5,5)+'</div>';
											}
											val += '<div style="font-size:14px;color:#666;">';
											val += '<div style="float:left;width:120px;text-align:center;line-height:30px;padding:3px 10px;">'+tmp[j]["startdate"].substr(11,5) +' - '+tmp[j]["enddate"].substr(11,5)+'</div>';    
											val += '<div style="margin-left:80px;text-align:left;line-height:30px;padding:3px;"><a href="<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/activity/detail?id='+tmp[j]["rowid"]+'&source=wkshare&sourceid=${partyId}">'+tmp[j]["title"]+'</div>';
											val += '</div>';
										}
										val+='<p style="border-top: 1px solid #FAFAFA;margin:0px 15px;"></p>';
										break;
									}
					            }
					        		
						}
						$("#div_task_list").html(val);
				}
	      }
	});
	
	initStyle();
}

function clickDateEvent(selDate){
	clickDate=selDate;
    $("#div_task_list").html('');
    var tmpday = '';
    for(var i=0;i<sche_data.length;i++){
			if(sche_data[i]['date'] == selDate){
				var tmp = sche_data[i]['tasks'];
				for(var j =0;j<tmp.length;j++){
					if(tmpday == '' || tmp[j]["startdate"].substr(5,5) != tmpday){
						tmpday = tmp[j]["startdate"].substr(5,5);
						val += '<div style="line-height: 25px;margin: 5px 10px;border-bottom: 1px solid #ddd;">'+tmp[j]["startdate"].substr(5,5)+'</div>';
					}
					val += '<div style="font-size:14px;color:#666;">';
					val += '<div style="float:left;width:120px;text-align:center;line-height:30px;padding:3px 10px;">'+tmp[j]["startdate"].substr(11,5) +' - '+tmp[j]["enddate"].substr(11,5)+'</div>';    
					val += '<div style="margin-left:80px;text-align:left;line-height:30px;padding:3px;"><a href="<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/activity/detail?id='+tmp[j]["rowid"]+'&source=wkshare&sourceid=${partyId}">'+tmp[j]["title"]+'</div>';
					val += '</div>';
				}
				val+='<p style="border-top: 1px solid #FAFAFA;margin:0px 15px;"></p>';
				$("#div_task_list").html(val);
				break;
			}
		}
}

function gotoOper(){
	var view = $('#calendar').fullCalendar('getView');
	var start = new Date(view.start);
	var sm=start.getMonth() + 1 ,sd = start.getDate();
	if(sm < 10){
		sm = '0' + sm;
	}
	if(sd < 10){
		sd = '0' + sd;
	}
	var end = new Date(dateOper(view.end,-1));
	var em=end.getMonth() + 1 ,ed = end.getDate();
	if(em < 10){
		em = '0' + em;
	}
	if(ed < 10){
		ed = '0' + ed;
	}
	$(":hidden[name=startdate]").val(start.getFullYear()+'-'+sm+'-'+sd);
	$(":hidden[name=enddate]").val(end.getFullYear()+'-'+em+'-'+ed);
	loadActivity('owner',start.getFullYear()+'-'+sm+'-'+sd,end.getFullYear()+'-'+em+'-'+ed);
}

function add(value){
	if(value=='itinerary'){
		if ($(".add_itinerary").hasClass("none")) {
			$(".dropdown-menu-group").addClass("none");
			$(".add_itinerary").removeClass("none");
			$(".g-mask").removeClass("none");
		} else {
			$(".add_itinerary").addClass("none");
			$(".g-mask").addClass("none");
		}
	}
	if(value=='task'){
	var str="/schedule/get?schetype="+value;
	window.location.href = "<%=path%>/operorg/list?redirectUrl=" + encodeURIComponent(str);
	}
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
	height: 102%;
	background: #000;
	filter: alpha(opacity = 60);
	opacity: 0.5;
	z-index: 998;
}
.add_itinerary {
	font-size: 14px;
	position: absolute;
	width: 300px;
	text-align: left;
	height: auto;
	left:50%;/*FF IE7*/
	top: 80px;/*FF IE7*/
	margin-left:-150px!important;/*FF IE7 该值为本身宽的一半 */
	z-index: 1000;
	background-color: #F0F0F0;
	border-radius: 10px;
	-webkit-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-moz-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-ms-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-o-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
}
.form-group {
	text-align: left;
	margin: .8em 0}
</style>
</head>
<body style="background-color:#fff"> 
	<div id="site-nav" class="navbar" style="">
		<input type="hidden" name="crmId" value="${crmId }"/>
		<input type="hidden" name="assignerid" value="${crmId }"/>
		<input type="hidden" name="assignername" value=""/>
		<input type="hidden" name="mindate" value=""/>
		<input type="hidden" name="maxdate" value=""/>
		<input type="hidden" name="startdate" value=""/>
		<input type="hidden" name="enddate" value=""/>
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">我订阅的活动</h3>
		
		<div class="act-secondary" >
			<a href="<%=path %>/calendar/search"  style="font-size:35px;font-weight:bold;color:#fff;padding:0px 0px 0px 5px;">
				<img src="<%=path%>/image/wxsearch.png">
			</a> 
			<a href="javascript:void(0)" onclick="add('task')"  style="font-size:35px;color:#fff;padding:0px 10px 0px 0px;">+</a> 
		</div>
	</div>
	
	<div id='calendar' class="">
	
	</div>	
	<div style="clear:both"></div>
	
	<div
		style="line-height: 35px; margin-top: 5px; background-color: #FAFAFA; padding-left: 10px;">
		<a href="<%=path%>/calendar/calendar"
			class="list-group-item listview-item"
			style="border-top: 1px solid #ddd">
			<div style="width: 100%;">
				<div style="">我的任务</div>
				<div style="float: right; margin-top: -37px;">
					<span class="icon icon-uniE603"></span>
				</div>
			</div>
		</a>
	</div>

	<div class="appoint_box">
       	<div class="site-recommend-list page-patch listContainer">
           <div class="div_task_list" id="div_task_list">        
			<div class="no_task_data none" style="text-align: center; padding-top: 50px;">您没有订阅活动，当前没有任何数据</div>
			<div class="loading_task_data none" style="text-align: center; padding-top: 50px;"><img src="<%=path%>/image/loading.gif"></div>
        </div>
    </div>
	</div>	
	<br/>
	<jsp:include page="/common/footer.jsp"></jsp:include>		
</body>
</html>