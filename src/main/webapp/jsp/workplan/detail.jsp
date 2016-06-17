<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	Object rowId = request.getAttribute("rowId");
	Object orgId = request.getAttribute("orgId");
	String shortUrl = PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+"/entr/access?orgId="+orgId+"&parentId="+rowId+"&parentType=workplan");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery.jBox-2.3.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
	<!--框架样式-->
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/jquery/jbox.css" />
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
    	var obj = $(".remark");
    	if(obj)
    	{
    		autoTextAreaDetail();
		} 
	});  
    
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
		var day = parseInt(start_date.substring(start_date.lastIndexOf("-")+1,start_date.lastIndexOf("-")+3))+7;
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
    
    //初始化按钮
    function initButton(){
    	//评价点击事件
    	$(".appraise").click(function(){
    		showorhidden('display');
    	});
    	
    	$(".update_appraise_lead").click(function(){
    		showorhidden('display');
    	});
    	
    	//修改
    	$(".updateworkplan").click(function(){
//     		if(confirm("更新操作将复制记录，原来的工作计划将不能再操作，确定要更新吗？")){
//     			$.ajax({
//     	    		type: 'post',
<%--     	    		url: '<%=path%>/workplan/updworkplan', --%>
//     	    		data: {rowId:'${rowId}',orgId:'${orgId}'},
//     	    		dataType: 'text',
//     	    		success: function(data){
//     	    			if(!data){
//     	    				$(".myMsgBox").css("display","").html("更新失败");
//     	   	    		 	$(".myMsgBox").delay(2000).fadeOut();
//     	   	    		 	return;
//     	    			}
//     	    			var d = JSON.parse(data);
//     	    			if(!d || d.errorCode != "0" || !d.rowId){
//     	    				$(".myMsgBox").css("display","").html("更新失败");
//     	   	    		 	$(".myMsgBox").delay(2000).fadeOut();
//     	   	    		 	return;
//     	    			}
<%--     	    			window.location.replace("<%=path%>/workplan/modify?rowId="+d.rowId+"&orgId=${orgId}"); --%>
//     	    		}
//     	    	});
//     		}
			//20150306
			    $.ajax({
    	    		type: 'post',
    	    		url: '<%=path%>/workplan/updstatus',
    	    		data: {rowId:'${rowId}',status:'upd'},
    	    		dataType: 'text',
    	    		success: function(data){
    	    			if('fail'==data){
    	    				$(".myMsgBox").css("display","").html("修改失败");
    	   	    		 	$(".myMsgBox").delay(2000).fadeOut();
    	   	    		 	return;
    	    			}else if('success'==data){
	    	    			window.location.reload();
    	    			}
    	    		}
    	    	});
    	});
    	
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
        			var startdate = res.startdate.substr(0,10);
        			var val = '<div style="border-bottom: 1px solid rgba(238, 238, 238, 0.56);"class="subtask task_'+res.rowid+'">'
							+ '<div style="margin-left:10px;text-align:left;line-height:30px;padding:3px;">'
						    + '<a href="<%=path%>/schedule/detail?orgId=${orgId}&schetype=task&workId=${workReport.id}&workFlag=${flag}&workViewtype=${viewtype}&workIndex=${index}&rowId='+res.rowid+'">'+res.title+'</a>&nbsp;(<span id='+res.rowid+'>'+res.statusname+'</span>)'
							+ '</div>'
							+ '<div taskid="'+res.rowid+'" style="float:right;margin-top: -32px;padding-right:15px;" class="modify_sub_task">'
							+ '<img src="<%=path %>/image/expense_status_new.png" width="20px"></div>'
							+ '<div class="radio" date="'+startdate+'" taskid ="'+res.rowid+'" style="display:none;float:right;margin-top: -32px;padding-right:15px;" >'
							+ '<div class="input-radio" title="选择该条记录"></div></div>';
					if(res.desc){
						val += '<div style="margin-left:10px;text-align:left;">'+res.desc+'</div>';
					}
					val += '</div>';
					var obj = $("#"+startdate);
        			if(obj.html()){
        				$("#"+startdate).append(val);
        			}else{
        				var html = '<div id="'+startdate+'"><span style="text-align:left;line-height:30px;padding:3px 10px;font-size: 16px;font-weight: bold;">'+
        				startdate.substr(5,5)+'&nbsp;&nbsp;'+getWeek(res.startdate)+'</span>'+val+'</div>';
        				$(".subtasklist").prepend(html);
        			}
        			$(".subtasklist").find(".radio").css("display","none");
	  				$(".modify_sub_task").css("padding-right","15px");
	  				$(".subtasklist").find(".radio").removeClass("checked");
	  				$(":hidden[name=deltaskflag]").val("1");
					initDel();
					initTaskBtn();
        		}
        	});
    	});
    	
    	
    	//删除工作计划
    	$("#livebtn").click(function(){
    		if(""!=$(".total_evaluation_avg").html()||""!=$(".lead_avg").html()){
    			$(".myMsgBox").css("display","").html("您的工作计划已经有人做出评价，不能删除！");
    	    	$(".myMsgBox").delay(2000).fadeOut();	
    			return;
    		}
   			var submit = function (v, h, f) {
   	        if (v == true){
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
   	        }else{
   	        }
   	        return true;
   	    };
    	    jBox.confirm("您确定要删除这个工作计划吗？", "提示", submit, { id:'hahaha', showScrolling: false, buttons: { '取消': false, '确定': true } });
	
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
    	
    	var status = '${workReport.status}';
    	if('upd'!=status && 'draft'!=status){
    		$(".rela_work_task").find("img").css("display","none");
    	}
    	if('Y'=='${authority}' && 'draft' == status){
	    	$(".updshow").css("display","");
	    	$(".updnone").css("display","none");
    	}
    	
    	//上一页或者下一页
    	$(".img").click(function(){
    		var optype = $(this).attr("key");
    		window.location.href="<%=path%>/workplan/detail?flag=${flag}&viewtype=${viewtype}&index=${index}&operate="+optype;
    	});
    	
    	initTaskBtn();
    }
    
    function initTaskBtn(){
    	//快速编辑任务状态
    	$(".modify_sub_task").unbind("click").click(function(){
    		var taskid = $(this).attr("taskid");
    		lovjs_choose('statusDom',{
        		success: function(res){
        			$.ajax({
        	    		url:'<%=path%>/schedule/asyUpdTask',
        	    		type:'post',
        	    		dataType:'text',
        	    		data:{rowId:taskid,status:res.key,schetype:'task',orgId:'${orgId}'},
        	    		success:function(data){
        	    			if("success"==data){
        	    				$(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("修改任务成功！");
        				   	    $(".myDefMsgBox").delay(2000).fadeOut();
        	    				$("#"+taskid).html(res.val);
        	    			}else{
        	    				$(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("异步更新任务失败！");
        				   	    $(".myDefMsgBox").delay(2000).fadeOut();
        	    			}
        	    		}
        	    	});
        		}
        	});
    	});
    	
    	//批量选择子任务
    	$(".subtasklist").find(".radio").unbind("click").click(function(){
    		if($(this).hasClass("checked")){
    			$(this).removeClass("checked");
    		}else{
    			$(this).addClass("checked");
    		}
    		if($(".subtasklist").find(".checked").size()>0){
    			$(".saveTaskBtn").css("display","");
    			$(".addsubtask").css("display","none");
    			$(".delsubtask").css("display","none");
    		}else{
    			$(".saveTaskBtn").css("display","none");
    			$(".addsubtask").css("display","");
    			$(".delsubtask").css("display","");
    		}
    		return false;
    	});
    }
    
	function getWeek(str){
		str = str.replace(/-/g,"/");
		var date = new Date(str);
		var weekDay = ["星期天", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"];
		return weekDay[date.getDay()];
	}
    
	  function initDel(){
		  //删除子任务
		  $(".delsubtask").unbind("click").click(function(){
			  var goback = $(":hidden[name=deltaskflag]").val();
			  if("1"==goback){
				  $(".subtasklist").find(".radio").css("display","");
				  $(".modify_sub_task").css("padding-right","50px");
				  goback="2";
			  }else if("2"==goback){
				  $(".subtasklist").find(".radio").css("display","none");
				  $(".modify_sub_task").css("padding-right","15px");
				  $(".subtasklist").find(".radio").removeClass("checked");
				  goback="1";
			  }
			  $(":hidden[name=deltaskflag]").val(goback);
		  });
		  
		  //批量删除任务
		  $(".saveTaskBtn").unbind("click").click(function(){
			  if($(".subtasklist").find(".checked").size()<=0){
				  $(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("请选择需要删除的任务！");
			   	  $(".myDefMsgBox").delay(2000).fadeOut(); 
			   	  return;
			  }
			  var taskid = '';
			  var date = '';
			  $(".subtasklist").find(".checked").each(function(){
				  taskid += $(this).attr("taskid")+",";
	    		  date += $(this).attr("date")+",";
	    		  $(".task_"+$(this).attr("taskid")).remove();
	    		  if($("#"+$(this).attr("date")).find(".subtask").size()==0){
	    			  $("#"+$(this).attr("date")).remove(); 
	    		  }
			  });
			  if(confirm("确定要删除这批子任务吗？")){
	    		  if(taskid){
	    				var dataObj = [];
	    				dataObj.push({name:"rowid",value:taskid});
	    				dataObj.push({name:"optype",value:'del'});
	    				dataObj.push({name:"tasksource",value:'workplan'});
	    				$.ajax({
	    				    type: 'post',
	    				      url: '<%=path%>/schedule/delSchedule',
	    				      data: dataObj,
	    				      dataType: 'text',
	    				      success: function(data){
	    				    	  if(data && data == 'success'){
	    				    		  $(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("操作成功！");
	          				   	      $(".myDefMsgBox").delay(2000).fadeOut();
		          				   	  $(".saveTaskBtn").css("display","none");
		          	    			  $(".addsubtask").css("display","");
		          	    			  $(".delsubtask").css("display","");
	    				    		  if($(".subtask").size()==0){
	    				    			  $(".subtasklist").html('<div style="width:100%;text-align:center;line-height:35px;color:#999;font-size:14px;" class="_nosubtaskdata">无计划任务</div>');
	    				    			  $(".delsubtask").css("display","none");
	    				    		  }
	    				    	  }else{
	    				    		  $(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("删除计划任务失败！");
	    						   	  $(".myDefMsgBox").delay(2000).fadeOut(); 
	    				    	  }
	    				      }
	    				});
	    			}
			  }
		  });
	    }

    
    //显示或隐藏
    function showOrHidden(type){
    	if('task'==type){
    		$("#customerDetail").css("display","none");
    		$("#taskdiv_").css("display","");
    		$("#gobackbtn").css("display","");
    		$(".img").css("display","none");
    	}else if('comments'==type){
    		$("#customerDetail").css("display","none");
    		$(".comments_div_").css("display","");
    		$("#gobackbtn").css("display","");
    		$(".img").css("display","none");
    	}
    	$(":hidden[name=goback]").val('2');
    }
    
    //回退按钮
    function goBack(){
    	var goback = $(":hidden[name=goback]").val();
    	if('1'==goback){
    		window.history.go(-1);
    	}else{
    		$("#customerDetail").css("display","");
    		$("#taskdiv_").css("display","none");
    		$(".comments_div_").css("display","none");
    		$(":hidden[name=goback]").val('1');
    	}
    	$("#gobackbtn").css("display","none");
    	$(".img").css("display","");
    }
    
    function toShare(){
    	if($(".subtask").size() == 0){
			 $(".myMsgBox").css("display","").html("请添加相关任务!");
   		 	$(".myMsgBox").delay(2000).fadeOut();
   		 	$(".g-mask").trigger("click");
   		 	return;
		}
    		
		var submit = function (v, h, f) {
	        if (v == true){
		    	//修改任务状态为已分享
		    	$.ajax({
		    		type: 'post',
		    		url: '<%=path%>/workplan/updstatus',
		    		data: {rowId:'${rowId}',status:'share'},
		    		dataType: 'text',
		    		success: function(data){
		    			if(data == "success"){
				 			$(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("提交成功");
					   	    $(".myDefMsgBox").delay(2000).fadeOut();
					   		window.location.replace("<%=path%>/workplan/detail?rowId=${rowId}&orgId=${orgId}");
				 		}else{
				 			$(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("提交失败");
					   	    $(".myDefMsgBox").delay(2000).fadeOut();
				 		}
		    		}
		    	});
	        }else{
	        }
	        return true;
	    };
	    jBox.confirm("确定要提交吗？", "提示", submit, { id:'hahaha', showScrolling: false, buttons: { '取消': false, '确定': true } });
		
		
		
		
		
    }
    
    //修改工作计划
    function modifyWork(){
    	var title = $("#title").val();
    	if(!title){
    		$(".myMsgBox").css("display","").html("请填写标题！");
	  		$(".myMsgBox").delay(2000).fadeOut();
	  		return;
    	}
    	var dataObj = [];
		$("form[name=workReportForm]").find("input").each(function(){
			var name = $(this).attr("name");
			var v = $(this).val();
			dataObj.push({name:name,value:v});
		});
		var remark = $("textarea[name=remark]").val();
		dataObj.push({name:'remark',value:remark});
		$.ajax({
			url:'<%=path%>/workplan/modify',
			type:'post',
			dataType:'text',
			data:dataObj,
			success:function(data){
				if(data == "success"){
		 			$(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("修改成功");
			   	    $(".myDefMsgBox").delay(2000).fadeOut();
			   		window.location.replace("<%=path%>/workplan/detail?rowId=${rowId}&orgId=${orgId}");
		 		}else{
		 			$(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("修改失败");
			   	    $(".myDefMsgBox").delay(2000).fadeOut();
		 		}
				
			}
		});
    }
    
    
    function autoTextAreaDetail(elemid){
	    //新建一个textarea用户计算高度
	    if(!document.getElementById("_textareacopy")){
	        var t = document.createElement("textarea");
	        t.id="_textareacopy";
	        t.style.position="absolute";
	        t.style.left="-9999px";
	        t.rows = "1";
	        t.style.lineHeight="20px";
	        t.style.fontSize="14px";
	        document.body.appendChild(t);
	    }
	    change(true);
	    function change(flag){
	    	document.getElementById("_textareacopy").value= $(".remark").val();
	    	var height = document.getElementById("_textareacopy").scrollHeight;
	    	if(height>200)
	    	{
	    		return;
	    	}
	    	if(document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height < 40)
	    	{
	    		$(".remark").css("height",40);
	    	}
	    	else
	    	{
	    		if (flag)
	    		{
	    			$(".remark").css("height",document.getElementById("_textareacopy").scrollHeight * 1.6);
	    		}
	    		else
	    		{
	    			$(".remark").css("height",document.getElementById("_textareacopy").scrollHeight);
	    		}
	    	}
	    }
	    
	    $(".remark").bind("propertychange",function(){
	    	change(false);
	    });
	    $(".remark").bind("onfocus",function(){
	    	change(false);
	    });
	
	    $(".remark").css("overflow","hidden");
	    $(".remark").css("resize","none");
	    //document.getElementById("desc").style.overflow="hidden";//一处隐藏，必须的。
	    //document.getElementById("desc").style.resize="none";//去掉textarea能拖拽放大/缩小高度/宽度功能
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
		<div id="site-nav" class="workplan_menu zjwk_fg_nav">
		   <div style="float: left;">
		   <c:if test="${planLength ne '1'}">
			   <c:if test="${shownext ne 'none'}">
			   		<a class="img" key="pre" style="margin-left: 10px;"><img src="<%=path%>/image/pre.gif"></a>
			   		<a class="img" key="next" style="margin-left: 10px;"><img src="<%=path%>/image/next.gif"></a>
				</c:if>
			</c:if>
				<a id="gobackbtn"  href="javascript:void(0)" onclick="goBack();" style="padding:10px 5px;display:none">
					后退
				</a>
			</div>
			<input type="hidden" name="goback" value="1">
			<input type="hidden" name="deltaskflag" value="1">
			<c:if test="${authority eq 'Y' && workReport.status eq 'draft' }">
				 <a href="javascript:void(0)" onclick='modifyWork()' style="padding:5px 8px;">保存</a>
				 <a href="javascript:void(0)" onclick='toShare()' style="padding:5px 8px;">提交</a>
				 <c:if test="${authority eq 'Y'}">
					 <a id="livebtn" href="javascript:void(0)" style="padding:5px 8px;">删除</a>
				 </c:if>
			</c:if>
			<c:if test="${authority eq 'Y' && workReport.status eq 'share' }">
				 <a href="javascript:void(0)" class="updateworkplan" style="padding:5px 8px;">修改</a>
				 <c:if test="${authority eq 'Y'}">
					 <a id="livebtn" href="javascript:void(0)" style="padding:5px 8px;">删除</a>
				 </c:if>
			</c:if>
		    <c:if test="${authority eq 'Y' && workReport.status eq 'upd' }">
				 <a href="javascript:void(0)" onclick="toShare()" style="padding:5px 8px;">提交</a>
				 <c:if test="${authority eq 'Y'}">
					 <a id="livebtn" href="javascript:void(0)" style="padding:5px 8px;">删除</a>
				 </c:if>
			</c:if>
		</div>
		<div style="clear:both;"></div>
		<c:if test="${workReport.status eq 'refresh' && workReport.rela_workid ne '' }">
			<div style="width:100%;text-align:center;font-size:14px;padding:10px 0px;color:red;">工作计划已更新，不能进行任何操作</div>
		</c:if>
		
		<div id="customerDetail" >
		   <div class="recommend-box crmDetailForm">
				<!-- <h4>详情</h4> -->
					<div id="view-list" class="list list-group1 listview accordion"
						style="margin: 0;border-bottom: 1px solid #ddd;">
						<div class="site-card-view">
							<div class="card-info">
								<form name="workReportForm" method="post">
								<table>
									<tbody>
										
										<input type="hidden" name="id" value="${workReport.id}">
										<tr>
											<th style="text-align: left;padding-left: 10px;width:80px;">标&nbsp;&nbsp;&nbsp;题：</th>
											<td class="updshow" style="display:none">
												<input type="text" name="title" id="title" value="${workReport.title}" maxlength="30"
														style="border:0px;" placeholder="请输入标题">
											</td>
											<td class="updnone">
												${workReport.title}
											</td>
										</tr>
										<tr>
											<c:if test="${workReport.type ne 'day'}">
												<th style="text-align: left;padding-left: 10px;width:80px;">期&nbsp;&nbsp;&nbsp;间：</th>
												<td class="updshow" style="display:none">
													<input name="start_date" id="start_date" placeholder="开始时间" value="${workReport.start_date }" type="text" format="yy-mm-dd" readonly="readonly"
																	class="form-control" style="border:none;width:35%;float:left;cursor:pointer"/>
													<div style="float:left;margin-right: 10px;line-height: 30px;text-align: center;"> — </div> 
													<input name="end_date" id="end_date"  placeholder="结束时间" value="${workReport.end_date }" type="text" format="yy-mm-dd" readonly="readonly"
																	class="form-control" style="border:none;width:35%;float:left;cursor:pointer"/>
												</td>
												<td class="updnone">
													${workReport.start_date}&nbsp;&nbsp;至${workReport.end_date}
												</td>
											</c:if>
											<c:if test="${workReport.type eq 'day'}">
												<th style="text-align: left;padding-left: 10px;width:80px;">日&nbsp;&nbsp;&nbsp;期：</th>
													<td class="updshow" style="display:none">
														<input name="start_date" id="start_date" value="${workReport.start_date}" type="text" class="form-control" readonly="readonly" style="border: 0px;cursor:pointer" />
														<input name="end_date" id="end_date" value="${workReport.end_date}" type="hidden" class="form-control" readonly="readonly" style="border: 0px;" />
													</td>
													<td class="updnone">
														${workReport.start_date}
													</td>
											</c:if>
										</tr>
									</tbody>
									</table>
									</form>
								<table>
									<tbody>
										<tr>
											<th style="text-align: left;padding-left: 10px;width:80px;">责任人：</th>
											<td>${workReport.creator}</td>
										</tr>
										<tr style="border:0px;">
											<td colspan="2" style="padding-left: 3px;">
												<jsp:include page="/common/teamlist.jsp">
													<jsp:param value="WorkReport" name="relaModule"/>
													<jsp:param value="${rowId}" name="relaId"/>
													<jsp:param value="${crmId }" name="crmId"/>
													<jsp:param value="${workReport.title}" name="relaName"/>
													<jsp:param value="${authority}" name="assFlg"/>
													<jsp:param value="${orgId}" name="orgId"/>
												</jsp:include>
											</td>
										</tr>
<!-- 										<tr onclick="showOrHidden('task');" style="cursor:pointer"> -->
<!-- 											<th style="text-align: left;padding-left: 10px;width:80px;">相关任务：</th> -->
<%-- 											<td style="float:right">${fn:length(slist)}&nbsp;&nbsp;<span class="icon icon-uniE603"></span></td> --%>
<!-- 										</tr> -->
										<tr>
											<th style="text-align: left;padding-left: 10px;width:80px;">状态：</th>
											<td>
												<c:if test="${workReport.status eq 'draft'}">
												   	新建
												</c:if>
												<c:if test="${workReport.status eq 'share'}">
												   	已提交
												</c:if>
												<c:if test="${workReport.status eq 'audit'}">
												   	已评价
												</c:if>
												<c:if test="${workReport.status eq 'upd'}">
												   	修改
												</c:if>
											</td>
										</tr>
<!-- 										<tr onclick="showOrHidden('comments');"style="cursor:pointer"> -->
<!-- 											<th style="text-align: left;padding-left: 10px;width:80px;">评价：</th> -->
<!-- 											<td><span class="total_evaluation_avg"></span>&nbsp;&nbsp;<span class="total_evaluation_lead"></span><span style="float:right;" class="icon icon-uniE603"></span></td> -->
<!-- 										</tr> -->
										<tr>
											<th style="text-align: left;padding-left: 10px;width:80px;">备注：</th>
											<td class="updshow" style="display:none">
												<textarea name="remark" id="remark" rows="2" class="remark"
													style="border: none; min-height: 2em" class="form-control"
													placeholder="在此处可以对工作计划进行说明和总结">${workReport.remark}</textarea>
											</td>
											<td class="updnone remark">
												${workReport.remark}
											</td>
										</tr>
									</tbody>
								   </table>
								</div>
							</div>	
						</div>
				</div>
			<!-- 子任务 -->
		<div id="taskdiv_" style="width:100%;background-color:#fff;font-size:14px;border-bottom: 1px solid #ddd;">
			<div style="line-height:30px;">
				<div style="background-color:#eee;color:#666;padding-left:1px;padding:5px 8px;">相关任务
					<c:if test="${(workReport.status eq 'upd'||workReport.status eq 'draft') && authority eq 'Y'}">
						<div class="delsubtask" style="cursor: pointer;float:right;padding:5px;font-size:25px;font-weight:bold;margin-top: -10px;">-</div>
						<div class="addsubtask" style="margin-right: 15px;cursor: pointer;float:right;padding:5px;font-size:25px;font-weight:bold;margin-top: -9px;">+</div>
						<div class="saveTaskBtn" style="display:none;cursor: pointer;float:right;padding:5px;font-size:14px;font-weight:bold;margin-top: -8px;">确定</div>
					</c:if>
				</div>
				<div style="font-size:14px;color:#666;" class="subtasklist">
					<c:if test="${fn:length(slist) >0 }">
					<c:forEach var ="chart" items="${map}">
						<div id="${chart.key}">
							<span style="text-align:left;line-height:30px;padding:3px 10px;font-size: 16px;font-weight: bold;">${chart.value}</span>
								 <c:forEach var="task" items="${slist}">
									<c:if test="${task.startdate eq chart.key}"> 
										<div class="subtask task_${task.rowid } " style="border-bottom: 1px solid rgba(238, 238, 238, 0.56);">
										    <div style="margin-left:10px;text-align:left;line-height:30px;padding:3px;">
									             <a href="<%=path%>/schedule/detail?orgId=${orgId}&schetype=task&rowId=${task.rowid}&workId=${workReport.id}&workFlag=${flag}&workViewtype=${viewtype}&workIndex=${index}<c:if test="${authority eq 'Y' && (workReport.status eq 'share' || workReport.status eq 'upd') }">&sign=ytj</c:if>">${task.title }</a>&nbsp;(<span id="${task.rowid }">${task.statusname}</span>)
											</div>
											<c:if test="${authority eq 'Y'}">
												<div taskid="${task.rowid}" style="float:right;margin-top: -32px;padding-right:15px;" class="modify_sub_task">
													<img src="<%=path %>/image/expense_status_new.png" width="20px">
												</div>
											</c:if>
											<div class="radio" date="${chart.key}" taskid ="${task.rowid}" style="display:none;float:right;margin-top: -32px;padding-right:15px;" >
												<div class="input-radio" title="选择该条记录"></div>
											</div>
											<c:if test="${task.desc ne ''}">
												<div style="margin-left:10px;text-align:left;">
										             ${task.desc}
												</div>
											</c:if>
										</div>
									 </c:if>
								 </c:forEach>
							</div>
						 </c:forEach>
					</c:if>
					<c:if test="${fn:length(slist) ==0 }">
						<div style="width:100%;text-align:center;line-height:35px;color:#999;font-size:14px;" class="_nosubtaskdata">无计划任务</div>
					</c:if>
				</div>
			</div>
		</div>
		</br>
		<!-- 评价 -->
		<div class="uptShow comments_div_" style="background-color: #fff;">
			<div class="pldiv" style="line-height:40px;font-size:14px;padding-left:8px;border-bottom:1px solid #ddd;">
				<span style="color:#666">评价</span>&nbsp;&nbsp;<span class="total_evaluation_avg"></span>
					<span class="appraise" style="float: right;font-size: 14px;color:blue;margin-right: 10px;cursor:pointer;">
					<img src="<%=path %>/image/expense_status_new.png" width="20px">写评价
				</span>
			</div>
			<div class="appraiseDiv"  style="font-size: 14px;background: #fff;">
				<div style="width:100%;text-align:center;line-height:45px;color:#999;font-size:14px;" class="_nocommentsdata">还没有评价</div>
				<div class="lead_list_title" style="line-height:35px;font-size:14px;color:red;display:none;padding-left: 10px;border-top:1px solid #eee;">上级评价&nbsp;&nbsp;<span class="lead_avg"></span></div>
				<ul class="lead_list">
				</ul>
				<div class="friend_list_title" style="line-height:35px;font-size:14px;color:red;display:none;padding-left: 10px;border-top:1px solid #eee;">好友评价&nbsp;&nbsp;<span class="friend_avg"></span></div>
				<ul class="friend_list">
				</ul>
				<div class="partner_list_title" style="line-height:35px;font-size:14px;color:red;display:none;padding-left: 10px;border-top:1px solid #eee;">同事评价&nbsp;&nbsp;<span class="partner_avg"></span></div>
				<ul class="partner_list">
				</ul>
				<div class="owner_list_title" style="line-height:35px;font-size:14px;color:red;display:none;padding-left: 10px;border-top:1px solid #eee;">自我评价&nbsp;&nbsp;<span class="owner_avg"></span></div>
				<ul class="owner_list">
				</ul>
				<div class="update_appraise_lead" style="width:100%;text-align:center;line-height:35px;font-size:14px;display:none;">修改</div>
			</div>
		</div>
		</br>
			<!-- 消息显示区域 -->
			<jsp:include page="/common/msglist.jsp">
				<jsp:param value="WorkReport" name="relaModule"/>
				<jsp:param value="${rowId}" name="relaId"/>
			</jsp:include>
			
			<!-- 底部操作区域 -->
			<div class="flooter" id="flootermenu" 
				style="z-index: 99999; background: #FFF; border-top: 1px solid #ddd; opacity: 1;">
				<!--发送消息的区域  -->
				<jsp:include page="/common/sendmsg.jsp">
					<jsp:param value="WorkReport" name="relaModule"/>
					<jsp:param value="${rowId}" name="relaId"/>
					<jsp:param value="${workReport.title}" name="relaName"/>
				</jsp:include>
			</div>
		</div>
	</div>
	<div class="g-mask none">&nbsp;</div>
	<%--团队成员列表 --%>
	<jsp:include page="/common/teamform.jsp"></jsp:include>
	<!-- 增加任务 -->
	<jsp:include page="/common/add/addtask.jsp"></jsp:include>
	<%--消息@符号处理 --%>
	<jsp:include page="/common/ertuserlist.jsp">
		<jsp:param value="WorkReport" name="relaModule"/>
	</jsp:include>
	<!-- 评价 -->
	<jsp:include page="/common/comments.jsp">
		<jsp:param value="${rowId}" name="rowId"/>
		<jsp:param value="WorkReport" name="rela_type"/>
		<jsp:param value="${eval_type}" name="eval_type"/>
		<jsp:param value="${crmId}" name="crmId"/>
		<jsp:param value="${orgId}" name="orgId"/>
	</jsp:include>
	<!-- 任务状态 -->
	<jsp:include page="/common/rela/lov.jsp"></jsp:include>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<!--tips提示框 -->
	<div class="myDefMsgBox none" >&nbsp;</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	<!-- 分享JS区域 -->
	<jsp:include page="/common/wxjs.jsp" /> 
	<script type="text/javascript">
	  wx.ready(function (){
		  wxjs_showOptionMenu();
		  var opt = {
			  title: "分享工作计划",
			  desc: "${workReport.title}",
			  link: "<%=shortUrl%>",
			  imgUrl: "http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png" 
		  };
		  wxjs_initMenuShare(opt);
	  });
	  </script>
</body>
</html>