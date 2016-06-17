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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>

<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.3.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
    	initButton();
    	initDel();
    	initWorkReportDatePicker();
	});  
    
    //初始化按钮
    function initButton(){   	
    	//新增子任务
    	$(".addsubtask").click(function(){
    		var req = {
    			relaId:"${rowId}",
    			relaType:'WorkReport',
    			orgId:'${orgId}'
    		};
    		schedulejs_choose(req,{
        		success: function(res){
        			if($("._nosubtaskdata")){
        				$("._nosubtaskdata").remove();
        			}
        			var val = '<div class="task_'+res.rowid+'">'
        					+ '<div style="float:left;width:60px;text-align:center;line-height:30px;padding:3px 10px;">'+res.startdate.substr(5,5)+'</div>'
							+ '<div style="margin-left:60px;text-align:left;line-height:30px;padding:3px;">'
						    + '<a href="<%=path%>/schedule/detail?orgId=${orgId}&schetype=task&rowId='+res.rowid+'">'+res.title+'</a>&nbsp;('+res.statusname+')'
							+ '</div>'
							+ '<div style="float:right;margin-top: -32px;padding-right: 15px;" taskid="'+res.rowid+'" workid="${rowId}" class="rela_work_task"><img src="<%=path %>/image/del_icon.png" width="20px"></div>'
							+ '</div>';
					$(".subtasklist").before(val);
					initDel();
        		}
        	});
    	});
    	
    	//分享
    	//$(".shareworkplan").click(function(){
    	//	if($(".rela_work_task").size() == 0){
    	//		 $(".myMsgBox").css("display","").html("请添加计划任务!");
	    //		 $(".myMsgBox").delay(2000).fadeOut();
	    //		 return;
    	//	}
    	//	if(confirm("分享后不能修改，确定要分享吗？")){
    	//		$(".teamAdd").trigger("click");
    	//	}
    	//});
    	
    	//删除工作计划
    	$("#livebtn").click(function(){
    		if(confirm("您确定要删除这个工作计划吗？")){
    			$.ajax({
    				type:'post',
    				url:'<%=path%>/workplan/deleteWorkPlan',
    				data:{rowId:'${rowId}'},
    				dataType:'text',
    				success:function(data){
    					if('0'==data){
    						window.location.href="<%=path%>/workplan/list";
    					}else{
    						$("#myMsgBox").css("display","").html("删除失败，请联系管理员！");
    		    	    	$("#myMsgBox").delay(2000).fadeOut();	
    					}
    				}
    			});
    		}
    	});
    	
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
			//隐藏按钮
			$(".menu-group").css("display","");
		});
    }
    
    //初始化日期
    function initWorkReportDatePicker(){
    	var opt = {
    			datetime : { preset : 'date',maxDate: new Date(2099,11,31)}
    		};
    		var optSec = {
    			theme: 'default', 
    			mode: 'scroller', 
    			display: 'modal', 
    			lang: 'zh', 
    			onSelect: function(){
    				var start_date = $('#start_date').val();
    				var type='${workReport.type}';
    				if('week'==type){
    					var enddate = '';
    					if('week' == type){
    						var d = new Date(start_date);
    						var n = d.getTime() + 7 * 24 * 60 * 60 * 1000;
    						var result = new Date(n);
    						var month = result.getMonth() + 1;
    						if(month <10){
    							month = "0"+month;
    						}
    						var day = result.getDate();
    						if(day < 10){
    							day = "0"+day;
    						}
    						enddate = result.getFullYear() + "-" + month + "-" + day; 
    					}
    					initReportEndDate(start_date,enddate);
    				}
    			}
    		};
    		$('#start_date').val('${workReport.start_date}').scroller('destroy').scroller($.extend(opt['datetime'], optSec));
    }
    
    function initReportEndDate(start_date,enddate){
		var year = start_date.split("-")[0];
		var month = parseInt(start_date.split("-")[1])-1;
		var day = parseInt(start_date.substring(start_date.lastIndexOf("-")+1,start_date.lastIndexOf("-")+3))+1;
		var opt = {
				datetime : { preset : 'date',minDate: new Date(year,month,day)}
			};
			var optSec = {
				theme: 'default', 
				mode: 'scroller', 
				display: 'modal', 
				lang: 'zh'
			};
		$('#end_date').val(enddate).scroller('destroy').scroller($.extend(opt['datetime'], optSec));
	}
    
    function toShare(){
    	if($(".rela_work_task").size() == 0){
			 $(".myMsgBox").css("display","").html("请添加计划任务!");
   		 	$(".myMsgBox").delay(2000).fadeOut();
   		 	$(".g-mask").trigger("click");
   		 	return;
		}
		if(confirm("分享后不能修改，确定要分享吗？")){
			//$(".teamAdd").trigger("click");
	    	//修改任务状态为已分享
	    	$.ajax({
	    		type: 'post',
	    		url: '<%=path%>/workplan/updstatus',
	    		data: {rowId:'${rowId}',status:'share'},
	    		dataType: 'text',
	    		success: function(data){
	    			window.location.replace("<%=path%>/workplan/detail?rowId=${rowId}&orgId=${orgId}");
	    		}
	    	});
		}
    }
    
    function initDel(){
    	//关系
    	$(".rela_work_task").click(function(){
    		if(confirm("确定要删除该任务吗？")){
    			var taskid = $(this).attr("taskid");
    			var workid = $(this).attr("workid");
    			//删除
    			if(taskid && workid){
    				var dataObj = [];
    				dataObj.push({name:"rowid",value:taskid});
    				dataObj.push({name:"optype",value:'del'});
    				$.ajax({
    				    type: 'post',
    				      url: '<%=path%>/schedule/delSchedule',
    				      data: dataObj,
    				      dataType: 'text',
    				      success: function(data){
    				    	  if(data && data == 'success'){
    				    		  $(".myMsgBox").css("display","").html("删除成功!");
    				    		  $(".myMsgBox").delay(2000).fadeOut();
    				    		  $(".task_"+taskid).remove();
    				    		  if($(".rela_work_task").size()==0){
    				    			  $(".subtasklist").html('<div style="width:100%;text-align:center;line-height:35px;color:#999;font-size:14px;" class="_nosubtaskdata">无计划任务</div>');
    				    		  }
    				    	  }else{
    				    		  $(".myMsgBox").css("display","").html("删除失败!");
    				    		  $(".myMsgBox").delay(2000).fadeOut();
    				    	  }
    				      }
    				});
    			}
    		}
    	});
    }
    
    //修改工作计划
    function modifyWork(){
    	var title = $("input[name=title]").val();
    	if(!title){
    		$(".myMsgBox").css("display","").html("请填写标题！");
	  		$(".myMsgBox").delay(2000).fadeOut();
	  		return;
    	}
    	$("form[name=workplanform]").submit();
    }
    
</script>
<style type="text/css">
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
</style>
</head>
<body>
	<div id="task-create" class="view site-recommend">
	    <div id="site-nav" class="navbar" style="display:none;">
			
		</div>
		
		<c:if test="${authority eq 'Y'}">
		<div id="site-nav" class="workplan_menu" style="font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;background-color:#fff;text-align:right;line-height:35px;padding-right:8px;">
		    <a href="javascript:void(0)" onclick='modifyWork()' style="padding:5px 8px;">保存</a>
		    <a href="javascript:void(0)" onclick='toShare()' style="padding:5px 8px;">提交</a>
		    <a id="livebtn" href="javascript:void(0)" style="padding:5px 8px;">删除</a>
		</div>
		</c:if>
		
		<div id="customerDetail" style="border-top:1px solid #ddd;margin-top:15px;">
		   <div class="recommend-box crmDetailForm">
				<!-- <h4>详情</h4> -->
					<div id="view-list" class="list list-group1 listview accordion"
						style="margin: 0;border-bottom: 1px solid #ddd;">
						<div class="site-card-view">
							<div class="card-info">
								<table>
									<tbody>
									<form type="post" name="workplanform" action="<%=path%>/workplan/modify">
										<input type="hidden" name="rowId" value="${rowId}">
										<input type="hidden" name="flag" value="upd">
										<tr>
											<th style="text-align: left;padding-left: 10px;width:80px;">标&nbsp;&nbsp;&nbsp;题：</th>
											<td class="uptShow">
												<input type="text" name="title" id="title" value="${workReport.title}" maxlength="30"
													style="border:0px;" placeholder="请输入标题">
											</td>
										</tr>
										<tr>
											<c:if test="${workReport.type ne 'day'}">
												<th style="text-align: left;padding-left: 10px;width:80px;">期&nbsp;&nbsp;&nbsp;间：</th>
												<td class="uptShow">
													<input name="start_date" id="start_date" value="${workReport.start_date}" type="text" class="form-control" readonly="readonly" style="border:0px;width:90px" />
														至 
													<input name="end_date" id="end_date" value="${workReport.end_date}" type="text" class="form-control" readonly="readonly" style="border:0px;width:auto" />
												</td>
											</c:if>
											<c:if test="${workReport.type eq 'day'}">
												<th style="text-align: left;padding-left: 10px;width:80px;">日&nbsp;&nbsp;&nbsp;期：</th>
													<td class="uptShow">
														<input name="start_date" id="start_date" value="${workReport.start_date}" type="text" class="form-control" readonly="readonly" style="border: 0px;" />
													</td>
											</c:if>
										</tr>
									</form>
										<tr>
											<th style="text-align: left;padding-left: 10px;width:80px;">责任人：</th>
											<td>${workReport.creator}</td>
										</tr>
									</tbody>
								   </table>
								</div>
							</div>	
						</div>
				<br/>
				<div style="width:100%;padding:5px 0px;background-color:#fff;font-size:14px;border-bottom: 1px solid #ddd;border-top: 1px solid #ddd;">
										<div style="line-height:30px;">
											<div style="color:#666;padding-left:1px;border-bottom:1px solid #ddd;padding:0px 8px;">子任务
												<div class="addsubtask" style="float:right;padding:5px;font-size:28px;font-weight:bold;margin-top: -10px;">+</div>
											</div>
											
											<div style="font-size:14px;color:#666;" class="subtasklist">
												<c:if test="${fn:length(slist) >0 }">
													<c:forEach var="task" items="${slist}">
														<div class="task_${task.rowid }">
															<div style="float:left;width:60px;text-align:center;line-height:30px;padding:3px 10px;">${fn:substring(task.startdate, 5, 10)}</div>
														    <div style="margin-left:60px;text-align:left;line-height:30px;padding:3px;">
													               <a href="<%=path%>/schedule/detail?orgId=${orgId}&schetype=task&rowId=${task.rowid}">${task.title }</a>&nbsp;(${task.statusname})
															</div>
															<div style="float:right;margin-top: -32px;padding-right: 15px;" taskid="${task.rowid}" workid="${rowId}" class="rela_work_task"><img src="<%=path %>/image/del_icon.png" width="20px"></div>
														</div>
													</c:forEach>
												</c:if>
												<c:if test="${fn:length(slist) ==0 }">
													<div style="width:100%;text-align:center;line-height:35px;color:#999;font-size:14px;" class="_nosubtaskdata">无计划任务</div>
												</c:if>
											</div>
										</div>
				</div>
				<br>
			</div>
		</div>
	</div>
	
	<!-- 增加任务 -->
	<jsp:include page="/common/add/addtask.jsp"></jsp:include>
	<div class="g-mask none">&nbsp;</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>

</body>
</html>