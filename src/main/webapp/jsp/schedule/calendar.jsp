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

<script>
//缓存数据
var sche_data = [];
var minDate = null;
var maxDate = null;
$(function() {

	$('#calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,agendaWeek,agendaDay'
		},
		handleWindowResize:true,
		//weekends:false,
		editable: true,
		events: [
			
		],
		dayClick: function(date, allDay, jsEvent, view) {   
	           var selDate =$.fullCalendar.formatDate(date,'yyyy-MM-dd');//格式化日期   
	           var screenHeight = document.body.clientHeight;
	           $(".showresult").css("display","");
	           $(".shade").css("display","");
	           var val = "";
	           var count = 0;
	           for(var i=0;i<sche_data.length;i++){
					if(sche_data[i]['date'] == selDate){
						var tmp = sche_data[i]['tasks'];
						for(var j =0;j<tmp.length;j++){
							val += '<div style="font-size:14px;color:#666;"><div style="float:left;width:80px;text-align:center;height:40px;line-height:40px;padding:5px;">【'+tmp[j]["startdate"].substr(11,5)+'】</div>';  
							val += '<div style="margin-left:80px;text-align:left;height:40px;line-height:40px;padding:5px;"><a href="<%=path%>/schedule/detail?openId=${openId}&publicId=${publicId}&schetype='+tmp[j]["schetype"]+'&rowId='+tmp[j]["rowid"]+'">'+tmp[j]["title"]+'</a></div>';
							val += '</div>';
							count ++;
						}
						$(".calendar_item").html(val);
						$(".showresult").animate({height : 40 * count + 110}, [ 10000 ]);
						break;
					}
				}
	            if(count ==0){
	            	$(".calendar_item").html('');
	            	$(".showresult").animate({height : 110}, [ 10000 ]);
	            }
	       }
	});
	
	//下一月/周/天
	$(".fc-button-next").click(function(){
		gotoOper();
	});
	
	//上一月/周/天
	$(".fc-button-prev").click(function(){
		gotoOper();
	});
	
	$(".fc-button-today").click(function(){
		gotoOper();
	});
	
	$(".fc-button-month").click(function(){
		gotoOper();
	});
	
	$(".fc-button-agendaWeek").click(function(){
		gotoOper();
	});
	
	$(".fc-button-agendaDay").click(function(){
		gotoOper();
	});
	//阴影层
	$(".shade").click(function(){
		$(".showresult").animate({height : 0}, [ 500 ]);
		$(".shade").css("display","none");
	});
	
	//责任人返回
	$(".goBack").click(function(){
		$("#site-nav").removeClass("modal");
		$("#calendar").removeClass("modal");
		$("#assignerMore").addClass("modal");
	});
	
	//选择责任人
	$(".calendarname").click(function(){
		$("#site-nav").addClass("modal");
		$("#calendar").addClass("modal");
		$("#assignerMore").removeClass("modal");
	});
	
	//确定
	$(".assignerbtn").click(function(){
		if($(":hidden[name=assignerid]").val() == "${crmId}"){
			$('.viewtypelabel').html('我的日程');
		}else{
			$('.viewtypelabel').html($(":hidden[name=assignername]").val()+'的日程');
		}
		$("#site-nav").removeClass("modal");
		$("#calendar").removeClass("modal");
		$("#assignerMore").addClass("modal");
		
		$('#calendar').fullCalendar('destroy');
		$('#calendar').fullCalendar({
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},
			handleWindowResize:true,
			//weekends:false,
			editable: true,
			events: [
				
			],
			dayClick: function(date, allDay, jsEvent, view) {   
		           var selDate =$.fullCalendar.formatDate(date,'yyyy-MM-dd');//格式化日期   

		           $(".showresult").css("display","");
		           $(".shade").css("display","");
		           
		           clickDate(selDate);
		       }
		});
		
		//下一月/周/天
		$(".fc-button-next").click(function(){
			gotoOper();
		});
		
		//上一月/周/天
		$(".fc-button-prev").click(function(){
			gotoOper();
		});
		
		$(".fc-button-today").click(function(){
			gotoOper();
		});
		
		$(".fc-button-month").click(function(){
			gotoOper();
		});
		
		$(".fc-button-agendaWeek").click(function(){
			gotoOper();
		});
		
		$(".fc-button-agendaDay").click(function(){
			gotoOper();
		});
		//加载数据
		gotoOper();
	});
	
	
	//选择责任人
	$(".assignerList >a").click(function(){
		$(".assignerList >a").removeClass("checked");
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(":hidden[name=assignerid]").val($(this).attr("assId"));
			$(":hidden[name=assignername]").val($(this).attr("assName"));
			$(this).addClass("checked");
		}
		return false;
	});
	
	//添加任务
	$(".addScheduleBtn").click(function(){
		$(".showresult").animate({height : 0}, [ 500 ]);
		$(".shade").css("display","none");
		addSchedule();
	});
	
	//加载数据
	gotoOper();
});

function dateOper(dd,dadd){  
	var a = new Date(dd) ; 
	a = a.valueOf()  ;
	a = a + dadd * 24 * 60 * 60 * 1000  ;
	a = new Date(a)  ;
	return a;  
} 

function clickDate(selDate){
	$(".showresult").css("display","");
    $(".shade").css("display","");
	var val = "";
    var count = 0;
    for(var i=0;i<sche_data.length;i++){
			if(sche_data[i]['date'] == selDate){
				var tmp = sche_data[i]['tasks'];
				for(var j =0;j<tmp.length;j++){
					val += '<div style="font-size:14px;color:#666;"><div style="float:left;width:80px;text-align:center;height:40px;line-height:40px;padding:5px;">【'+tmp[j]["startdate"].substr(11,5)+'】</div>';  
					val += '<div style="margin-left:80px;text-align:left;height:40px;line-height:40px;padding:5px;"><a href="<%=path%>/schedule/detail?openId=${openId}&publicId=${publicId}&schetype='+tmp[j]["schetype"]+'&rowId='+tmp[j]["rowid"]+'">'+tmp[j]["title"]+'</a></div>';
					val += '</div>';
					count ++;
				}
				$(".calendar_item").html(val);
				var screenHeight = $(window).height();
				var height = count * 40;
				if(height>screenHeight-80){
					$(".showresult").css("overflow-y","auto");
					$(".showresult").animate({height :screenHeight - 80}, [ 10000 ]);
				}else{
					$(".showresult").css("overflow-y","none");
					$(".showresult").animate({height :height + 110}, [ 10000 ]);
				}
				break;
			}
	}
    
     if(count ==0){
     	$(".calendar_item").html('');
     	$(".showresult").animate({height : 55}, [ 10000 ]);
     }
}
//
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
	syncGetTask(start.getFullYear()+'-'+sm+'-'+sd,end.getFullYear()+'-'+em+'-'+ed);
}


//异步获取日程数据
function syncGetTask(startDate,endDate){
	var crmId = $(":hidden[name=crmId]").val();
	var assignerid = $(":hidden[name=assignerid]").val();
	if(assignerid == ''){
		alert('责任人不能为空');
		return;
	}
	var dataObj = [];
	dataObj.push({name:'openId', value:'${openId}'});
	dataObj.push({name:'publicId', value:'${publicId}'});
	dataObj.push({name:'crmId', value:crmId});
	dataObj.push({name:'startDate', value:startDate});
	dataObj.push({name:'endDate', value:endDate});
	dataObj.push({name:'currpage', value:'1'});
	dataObj.push({name:'pagecount', value:'1000'});
	dataObj.push({name:'assignerid',value:assignerid});
	dataObj.push({name:'viewtype', value:'calendarview'});
	dataObj.push({name:'schetype', value:'task'});
	$.ajax({
		type: 'post',
		url: '<%=path%>/schedule/tasklist',
			data : dataObj || {},
			dataType : 'text',
			success : function(data) {
				var d = JSON.parse(data);
				if(!d){
					return;
				}else{
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
							dayTask.push({'title':this.title,'rowid':this.rowid,'startdate':this.startdate,'schetype':this.schetype,'enddate':this.enddate});
							sche_data.push({'date':tDate,'tasks':dayTask});
						}else if(tDate == this.startdate.substring(0,10)){
							for(var i=0;i<sche_data.length;i++){
								if(sche_data[i]['date'] == tDate){
									tmp = [];
									tmp = sche_data[i]['tasks'];
									tmp.push({'title':this.title,'rowid':this.rowid,'startdate':this.startdate,'schetype':this.schetype,'enddate':this.enddate});
									sche_data[i]['tasks'] = tmp;
									break;
								}
							}
						}
					});
						$('#calendar').fullCalendar( 'removeEvents');
						for(var i=0;i<sche_data.length;i++){
							var tmp = sche_data[i]['tasks'];
							var copiedEventObject;   
							if(view.name == 'agendaDay'){
								for(var j=0;j<tmp.length;j++){
									copiedEventObject =new Object();   
									copiedEventObject.start = tmp[j]['startdate'];//sche_data[i]['date'];
									//copiedEventObject.end=tmp[j]['enddate'];
									copiedEventObject.title= tmp[j]['title'].length>20?tmp[j]['title'].substring(0,19):tmp[j]['title'];
									//copiedEventObject.className='';
								/* 	if(j%2 ==0){
									copiedEventObject.backgroundColor='green';
									} */
									copiedEventObject.url = '<%=path%>/schedule/detail?openId=${openId}&publicId=${publicId}&schetype='+tmp[j]["schetype"]+'&rowId='+tmp[j]["rowid"];
									copiedEventObject.id= tmp[j]['rowid'];
									//全天性事件
									copiedEventObject.allDay = false; 
									$('#calendar').fullCalendar('renderEvent', copiedEventObject, false);  //核心的插入代码 	
								}
							}else if(view.name == 'agendaWeek'){
								for(var j=0;j<tmp.length;j++){
									copiedEventObject =new Object();   
									copiedEventObject.start = tmp[j]['startdate'];//sche_data[i]['date'];
									//copiedEventObject.end=tmp[j]['enddate'];
									copiedEventObject.title= tmp[j]['title'].length>10?tmp[j]['title'].substring(0,9):tmp[j]['title'];
									//copiedEventObject.className='';
								/* 	if(j%2 ==0){
									copiedEventObject.backgroundColor='green';
									} */
									copiedEventObject.url = '<%=path%>/schedule/detail?openId=${openId}&publicId=${publicId}&schetype='+tmp[j]["schetype"]+'&rowId='+tmp[j]["rowid"];
									copiedEventObject.id= tmp[j]['rowid'];
									//全天性事件
									copiedEventObject.allDay = false; 
									$('#calendar').fullCalendar('renderEvent', copiedEventObject, false);  //核心的插入代码 	
								}
							}else{
								copiedEventObject =new Object();   
								copiedEventObject.start = sche_data[i]['date'];
								copiedEventObject.title= '<span onclick="clickDate(\''+sche_data[i]['date']+'\')">'+tmp.length +'个任务</span>';  //标题 
								copiedEventObject.id= i+1;
								//全天性事件
								copiedEventObject.allDay = false;
								$('#calendar').fullCalendar('renderEvent', copiedEventObject, false);  //核心的插入代码 	
							}
						}					
				}
				
			}
	});
}

function addSchedule(){
	window.location.href = '<%=path%>/schedule/get?openId=${openId}&publicId=${publicId}';
} 

//导出工作报告
function genWorkReport(){
	var sd = $(":hidden[name=startdate]").val();
	var ed = $(":hidden[name=enddate]").val();
	window.location.href = '<%=path%>/schedule/genReport?openId=${openId}&publicId=${publicId}&crmId=${crmId}&startdate=' + sd + '&enddate=' + ed;
}

</script>
<style type='text/css'>
	#calendar {
		width: 100%;
		margin: 5px; 
		padding-right:10px;
	}
	.schedule_month{
		height:65px; 
	}
	.schedule_week{
		height:20px;
	}
</style>
</head>
<body style="background-color:#fff;min-height:100%;"> 
	<div id="site-nav" class="navbar" style="">
		<input type="hidden" name="crmId" value="${crmId }"/>
		<input type="hidden" name="assignerid" value="${crmId }"/>
		<input type="hidden" name="assignername" value=""/>
		<input type="hidden" name="mindate" value=""/>
		<input type="hidden" name="maxdate" value=""/>
		<input type="hidden" name="startdate" value=""/>
		<input type="hidden" name="enddate" value=""/>
		<jsp:include page="/common/back.jsp"></jsp:include>
		<div class="list-group-item-bd" style="width:180px;margin:0 auto;padding-top:10px;" >
				<p>
					<div class="form-control select _viewtype_select">
						<div class="select-box viewtypelabel" style="color:#106c8e;">我的日程表</div>
					</div>
				</p>
		</div>
		<div class="act-secondary calendarname" style="float:right;color:#fff;">
			选择
		</div>
	</div>
	
	<!-- 下拉菜单选项 -->
	<script>
	$(function () {
		$("._viewtype_select").click(function(){
			viewtypeClick();
		});	
		
		$("body").click(function(e){
			if($("#_viewtype_menu").css("display") == "block" && e.target.className == ''){
				viewtypeClick();
			}
		});
	});
	
	function viewtypeClick(){
		if($("#_viewtype_menu").css("display") == "none"){
			$("#_viewtype_menu").css("display","");
			$("#_viewtype_menu").animate({height : 155}, [ 10000 ]);
			$("#calendar").css("display","none");
			$("body").css("background-color","");
		}else{
			$("#_viewtype_menu").animate({height : 0}, [ 10000 ]);
			$("#_viewtype_menu").css("display","none");
			$("body").css("background-color","#fff");
			$("#calendar").css("display","");
		}
	}
	</script>
	<div class="_viewtype_menu_class" id="_viewtype_menu" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
		<a href="<%=path%>/schedule/calendar?openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的日程表
			</div>
		</a>
		<a href="<%=path%>/schedule/list?viewtype=todayview&openId=${openId}&publicId=${publicId}">
			<div style="float:right;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的当日任务列表
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/schedule/list?viewtype=historyview&openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的历史任务列表
			</div>
		</a>
		<a href="<%=path%>/schedule/list?viewtype=planview&openId=${openId}&publicId=${publicId}">
			<div style="float:right;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我的计划任务列表
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/schedule/list?viewtype=subview&openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我下属的任务列表
			</div>
		</a>
		<a href="<%=path%>/schedule/list?viewtype=teamview&openId=${openId}&publicId=${publicId}">
			<div style="float:right;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我团队的任务列表
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/schedule/list?viewtype=focusview&openId=${openId}&publicId=${publicId}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;我关注的任务列表
			</div>
		</a>
		<a href="javascript:void(0)">
			<div style="float:right;padding:10px;width:50%;">
				&nbsp;
			</div>
		</a>
		<div style="clear:both"></div>
	</div>
	<!-- 下拉菜单选项 end -->
	<div id='calendar' class=""></div>
	<!-- 预览数据 -->
    <div class="previewTaskCon"></div>
    
	<div id="assignerMore" class=" modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary goBack"><i class="icon-back"></i></a>
			责任人
		</div>
		<div class="page-patch">
			<!-- <h4 class="wrapper list-title">查询结果集:</h4> -->
			<div class="list-group listview listview-header assignerList">
				<c:forEach items="${userList}" var="uitem">
					<a href="javascript:void(0)" class="list-group-item listview-item radio" 
							assId="${uitem.userid}" assName="${uitem.username}">
						<div class="list-group-item-bd">
							<input type="hidden" name="assId" value="${uitem.userid}"/>
							<h2 class="title assName">${uitem.username}</h2>
							<p>职称：${uitem.title}</p>
							<p>
								部门：<b>${uitem.department}</b>
							</p>
						</div>
						<div class="input-radio" title="选择该条记录"></div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(userList) == 0}">
					<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">
						无数据
					</div>
				</c:if>
			</div>
			<br/><br/><br/>
			<c:if test="${fn:length(userList) > 0}">
				<div class=" flooter assBtn" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:35px;">
					<input class="btn btn-block assignerbtn" type="submit" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;">
				</div>
			</c:if>
		</div>
	</div>
	<div class="shade" style="display: none"></div>
	<div class="showresult flooter" style="z-index:999999;display:none;width:100%;background-color:#efefef;border-top:1px solid #aaa;opacity:1;font-size:14px;">
		<div class="calendar_item"></div>
		<div class="button-ctrl">
			<fieldset class="">
				<div class="ui-block-b" style="width:100%;">
					<a href="javascript:void(0)"  class="btn btn-success btn-block addScheduleBtn"
						style="background-color: #49af53" style="font-size: 14px;">
						添加任务 </a>
				</div>
				<div class="ui-block-b" style="width:100%;">
					<a href="javascript:void(0)" onclick="genWorkReport()" class="btn btn-warning btn-block "
						style="font-size: 14px;">
						导出本月工作报告 </a>
				</div>
			</fieldset>
		</div>
	</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="z-index:999999;display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	<!--脚页面  -->
</body>
</html>