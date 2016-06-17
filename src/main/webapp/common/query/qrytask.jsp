<%@page import="com.takshine.wxcrm.message.sugar.ScheduleAdd"%>
<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	String qrytaskpath = request.getContextPath();
	String mycrmid = UserUtil.getCurrUser(request).getCrmId();
	String myname = UserUtil.getCurrUser(request).getName();
%>

<script
	src="<%=qrytaskpath%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"
	type="text/javascript"></script>
<script
	src="<%=qrytaskpath%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"
	type="text/javascript"></script>
<link
	href="<%=qrytaskpath%>/scripts/plugin/wb/css/mobiscroll.core-2.5.3.css"
	rel="stylesheet" type="text/css" />
<script
	src="<%=qrytaskpath%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"
	type="text/javascript"></script>
<script
	src="<%=qrytaskpath%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"
	type="text/javascript"></script>

<script type="text/javascript">
	
		$(function () {
			initQueryDatePicker();
			var viewtype = "myview";
			
			if(viewtype != 'myview'){
				$(".assigner_list_div").css("display","");
				$("#addAssigner").val("");
				$("input[name=assignerId]").val("");
			}else{
				$(".assigner_list_div").css("display","none");
				//$("#addAssigner").val("<%=myname%>");
				//$("input[name=assignerId]").val("<%=mycrmid%>");
			}

			$(".cancel").click(function(){
				hide_queryscheduleform();
			});
			
			 $(".viewtype_sel").click(function(){
		         	var type = $(this).attr("key");
		         	if(type != 'myview'){
		         		$(".assigner_list_div").css("display","");
						$("#addAssigner").val("");
						$("input[name=assignerId]").val("");
		         	}else{
		         		$(".assigner_list_div").css("display","none");
						//$("#addAssigner").val("<%=myname%>");
						//$("input[name=assignerId]").val("<%=mycrmid%>");
		         	}
		         	$(":hidden[name=viewtype]").val(type);
		         	$(".viewtype_sel").removeClass("selected").addClass("noselected");
		         	$(this).removeClass("noselected").addClass("selected");
		     });

			
			$(".query_schedule_form .status_type").click(function()
			 {
/* 			  $(".query_schedule_form .status_type").removeClass("selected").addClass("noselected");
			   $(this).removeClass("noselected").addClass("selected");
			   $(".query_schedule_form :hidden[name=query_status]").val($(this).attr('key')); */
				
			   if ($(this).hasClass("selected"))
				{
					$(this).removeClass("selected").addClass("noselected");
				}
				else
				{
					$(this).removeClass("noselected").addClass("selected");
				}
			});
			
			//选择客户
	    	$("input[name=query_parentName]").click(function(){
	    		customerjs_choose({
	        		success: function(res){
	        			$(".query_schedule_form :hidden[name=query_parentId]").val(res.key);
	        			$(".query_schedule_form input[name=query_parentName]").val(res.val);
	        		}
	        	});
	    	});
			
			$("input[name=search]").click(function(){
				if($(".search_task_filter").hasClass("none")){
					$(".search_task_filter").removeClass("none");
					$(".search_task_filter_title").addClass("none");
					$("input[name=query_title]").focus();
				}
			});
			

		   	//责任人选择事件
			$("#addAssigner").click(function(){
				$(".calendar-list").removeClass("modal").addClass("modal");
				$(".query_scheduleform").removeClass("modal").addClass("modal");
				
				$("#site-nav").removeClass("modal").addClass("modal");
				$("#assigner-more").removeClass("modal");
			});
			$(".assignerGoBak").click(function(){
				$(".calendar-list").removeClass("modal");
				$(".query_scheduleform").removeClass("modal");
				$("#assigner-more").removeClass("modal").addClass("modal");
				$("#site-nav").removeClass("modal");
			});
			
			// 责任人 的 确定按钮
			$(".assignerbtn").click(function(){
				var assId=null; 
				var assName=null;
				var assigner = "";
				$("#addAssigner").empty();
				var i=0;
				var size = $(".assignerList > a.checked").size();
				$(".assignerList > a.checked").each(function(){
					i++;
					assId += $(this).find(":hidden[name=assId]").val()+",";
					assName = $(this).find(".assName").html()+",";
					assName = assName.replace("null","");
					if(i==size){
						assName = assName.substring(0,assName.lastIndexOf(","));
					}
					assigner += assName;
				});

			/* 	if(assId==""||null==assId){
					$(".myDefMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("责任人不能为空,请您选择责任人!");
				    	    	$(".myDefMsgBox").delay(2000).fadeOut();
					    	    return;
							} */
				$("#addAssigner").val(assigner);
				if (assId == null) {
					assId = "";
				}
				assId = assId.replace("null","");
				assId = assId.substring(0,assId.lastIndexOf(","));
				$("input[name=assignerId]").val(assId);
				$(".query_scheduleform").removeClass("none");
				$("#assigner-more").addClass("modal");
				$("#site-nav").removeClass("modal");
				$(".assignerGoBak").trigger("click");
			});
			
		});
		
		function sortDupByKeys(list,bdesc){
			return list.sort(function(left, right) {
				var k1;
				var k2;
				left.each(function(key, value, index) {
					k1 = key;
				});
				right.each(function(key, value, index) {
					k2 = key;
				});
				var b = StringToDate(k1) > StringToDate(k2);
				//alert(b + " -- " + k1 + " >  " + k2);
				if (bdesc){
					b = !b;
				}
				return b ? -1 : 1;
			});
		}

/* 		function sort_task(){
			$(".cache_query_result").empty();
			$(".query_task_list_item").each(function(){
				$(".cache_query_result").prepend($(this).prop("outerHTML"));
			});
			
			$(".search_result_tasklist").empty();
			$(".query_task_list_item").each(function(){
				$(".search_result_tasklist").append($(this).prop("outerHTML"));
			});
		}
 */		
 		var desc = false;
		var dataCache = new Array();
 		function sort_task(){
			desc = !desc;
			dataCache = sortDupByKeys(dataCache,desc);
			$(".search_result_tasklist").empty();
			
			$(dataCache).each(function(j){
				this.each(function (key,val,index){
					$(".search_result_tasklist").append(val);
				});
			});
		}
		
		function query_schedulejs_choose(){			
			$(".query_scheduleform").removeClass("none");
			$(".searchtaskresult").addClass("none");	
		}
		
		//返回
		function hide_queryscheduleform(){
			$(".query_scheduleform").removeClass("none").addClass("none");
		}
		
		
		
		//异步保存
		function syncquery(){
			
			$(".searchtask_list").removeClass("none");
			$(".search_task_filter").addClass("none");
			$(".search_task_filter_title").removeClass("none");
			
			var startdate = $(".query_schedule_form input[name=query_startdate]").val();
			var enddate = $(".query_schedule_form input[name=query_enddate]").val();
			var title = $(".query_schedule_form input[name=query_title]").val();
			var status = $(".query_schedule_form input[name=query_status]").val();
			var parentId = $(".query_schedule_form input[name=query_parentId]").val();
			var viewtype = $(":hidden[name=viewtype]").val();
			var orgId = $("input[name=orgId]").val();
			var query_people =$("input[name=query_people]").val();
			var assignerIds = "";
			var viewtypestr = $(":hidden[name=viewtype]").val();
			if (viewtypestr!="myview"){
				assignerIds = $("input[name=assignerId]").val();
			}else{
				//assignerIds = "<%=mycrmid%>";
			}
			
			var dataObj = [];
			dataObj.push({name:"startDate",value:startdate});
			dataObj.push({name:"endDate",value:enddate});
			dataObj.push({name:"schetype",value:'task'});
			dataObj.push({name:"title",value:title});
			dataObj.push({name:"status",value:status});
			dataObj.push({name:"parentId",value:parentId});
			dataObj.push({name:"parentType",value:'Accounts'});
			dataObj.push({name:"viewtype",value:viewtype});
			dataObj.push({name:"assignerIds",value:assignerIds});
			dataObj.push({name:"orgId",value:orgId});
			dataObj.push({name:"assignerName",value:query_people});
			 $(".search_result_tasklist").empty();
			$(".searchloading").removeClass("none");
	 		$(".searchnodata").removeClass("none").addClass("none");
  		    $(".search_result_tasklist").removeClass("none").addClass("none"); 
			$.ajax({
			    type: 'post',
			      url: '<%=qrytaskpath%>/schedule/tlist',
			      data: dataObj,
			      dataType: 'text',
			      success: function(data){
			    	  $(".searchloading").removeClass("none").addClass("none");
			    	  if(!data){
			    		   $(".searchnodata").removeClass("none");
				    	   return;
				       }
				       var d = JSON.parse(data);
				       if(!d){
			    		   $(".searchnodata").removeClass("none");
				    	   return;
				       }
				       
				       if(d.errorCode && d.errorCode !== '0'){
			    		   $(".searchnodata").removeClass("none");
				    	   return;
				       }
				       
				       $(".search_result_tasklist").removeClass("none");
				       $(".searchtaskresult").removeClass("none");
				       $(".search_result_tasklist").css("height",$(window).height() - 100);
				      // $(".searchtaskresult").removeClass("none");
				      $(".searchnodata").addClass("none");
				      
				       var val = "";
				       dataCache = new Array();
				       $(d).each(function(){
					     //  $(".searchnodata").removeClass("none").addClass("none");
				    	    val = '<div class="query_task_list_item"><div style="float:left;width:60px;text-align:center;line-height:30px;padding:3px 10px;">'+this.startdate.substr(5,5)+'</div>'
									 +'<div style="margin-left:60px;text-align:left;line-height:30px;padding:3px;">'
									+'<a href="<%=qrytaskpath %>/schedule/detail?orgId='+this.orgId+'&schetype='+this.schetype+'&rowId='+this.rowid+'">'+this.title+'</a>&nbsp;('+ this.assigner + ' '+this.statusname+')'
									+'</div>'
									+'<p style="border-top: 1px solid #FAFAFA;"></p></div>';
							var map = new TAKMap();
							map.put(this.startdate,val);
							dataCache.push(map);
							$(".search_result_tasklist").append(val);
				       });		       
				  }
			});
			
			$(".status_type").removeClass("selected");
			$('.query_schedule_form #query_startdate').val('');
			$('.query_schedule_form #query_enddate').val('');
			$('.query_schedule_form #query_title').val('');
		}
		
		
		//初始化日期控件
		function initQueryDatePicker(){
			var opt = {
				date : {preset : 'date'},
				datetime : { preset : 'datetime', minDate: new Date(2000,3,10,9,22), maxDate: new Date(2099,7,30,15,44), stepMinute: 5  },
				time : {preset : 'time'},
				tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
				image_text : {preset : 'list', labels: ['Cars']},
				select : {preset : 'select'}
			};
			
			$('.query_schedule_form #query_startdate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
			$('.query_schedule_form #query_enddate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
			
		}
		
		function selectViewType(obj,viewtype)
		{
			var search_div=$("#search_div0");
			search_div.find("a").each(function(index){
				search_div.find("a").removeClass("selected");
		    });
			obj.className = "selected";
			$(":hidden[name=viewtype]").val(viewtype);
		}
	</script>

<style>
.query_scheduleform {
	position: fixed;
	max-width: 640px;
	width: 100%;
	z-index: 9999;
	background-color: #fff;
	top: 0px;
	height: 100%;
	font-size: 14px;
}

.none {
	display: none;
}

.cancel {
	float: left;
}

.status_type {
	padding: 3px 5px;
}

.selected {
	background-color: rgb(21, 190, 120);
	color: #fff;
}

.noselected {
	background-color: #fff;
	color: #555;
}

.viewtype_sel {
	padding: 3px 5px;
}
</style>

<!-- 日程创建FORM DIV -->
<div class="query_scheduleform none">
	<div id="site-nav" class="navbar">
		<div class="cancel">取消</div>
		<h3 style="padding-right: 45px;">查询任务</h3>

	</div>


	<div class="search_task_filter_title none"
		style="width: 100%; height: 50px; line-height: 50px; background-color: #fff; padding: 0px 5px 5px 5px;">
		<div style="height: 44px;">
			<img src="<%=qrytaskpath%>/image/searchbtn.png"
				style="position: absolute; opacity: 0.3; width: 30px; margin-left: 5px; margin-top: 10px;">
			<input type="text" value="" placeholder="搜索" name="search"
				style="border-radius: 10px; font-size: 14px; padding-left: 40px; border: 1px solid #ddd; line-height: 30px;">
		</div>
	</div>

	<div class="wrapper search_task_filter"
		style="margin: 0px; font-size: 14px;">
		<form class="query_schedule_form" id="sync_schedule_form"
			method="post">
			<input type="hidden" name="viewtype" value="myview" />
			<%--主题 --%>
			<div style="width: 100%; padding: 5px 10px; background-color: #fff;">
				<div
					style="line-height: 35px; border-bottom: 1px solid #ddd; margin-top: 0.5em; background-color: #fff;">
					<div style="color: #999; padding-left: 5px; float: left;">区间</div>
					<div style="padding-left: 50px;" id="search_div0">
						<a class="viewtype_sel selected" href="javascript:void(0)"
							onclick="selectViewType(this,'myview')" key="myview">我的</a>&nbsp;&nbsp;
						<a class="viewtype_sel noselected" href="javascript:void(0)"
							onclick="selectViewType(this,'teamview')" key="teamview">我下属的</a>&nbsp;&nbsp;
						<a class="viewtype_sel noselected" href="javascript:void(0)"
							onclick="selectViewType(this,'myallview')" key="myallview">所有</a>&nbsp;&nbsp;
							
<!-- 						<a class="viewtype_sel noselected" href="javascript:void(0)"
							onclick="selectViewType(this,'calendarview')" key="calendarview">日程</a>&nbsp;&nbsp; -->
							
					</div>
				</div>

				<div class="form-group" style="margin: 0.5em 0;">
					<div
						style="position: absolute; margin-top: 8px; margin-left: 5px; color: #666;">标题</div>
						<input name="query_title" id="query_title" value="" type="text"
							class="form-control"
							style="border: 0px; border-bottom: 1px solid #ddd; padding-left: 100px;" />
					</div>
                <div>
                	  <div style="position: absolute; margin-top: 8px; margin-left: 5px; color: #666;">创建者</div>
						<input name="query_people" id="query_people" value="" type="text"
							class="form-control"
							style="border: 0px; border-bottom: 1px solid #ddd; padding-left: 100px;" />
					</div>
                </div>
				<div
					style="line-height: 30px; border-bottom: 1px solid #ddd; margin: 0.5em 0;">
					<input name="query_status" required="required" id="query_status"
						value="" type="hidden">
					<div style="color: #666; padding-left: 5px;">状态</div>
					<div style="padding-left: 15px;">
						<c:forEach items="${statusDom}" var="p">
							<a class="status_type" href="javascript:void(0)" key="${p.key}">${p.value}</a>&nbsp;&nbsp;
							</c:forEach>
					</div>
				</div>


				<div style="padding: 3px 5px; border-bottom: 1px solid #ddd;">
					<div style="position: absolute; line-height: 40px; color: #666;">客户</div>
					<input type="hidden" name="query_parentId" id="query_parentId">
					<input name="query_parentName" id="query_parentName" value=""
						type="text" placeholder="选择客户" class="form-control"
						readonly="readonly"
						style="border: 0px; padding-left: 100px; margin-top: 6px;" />
					<div
						style="float: right; margin-right: 5px; color: #666; margin-top: -30px; max-width: 640px">
						<img src="<%=qrytaskpath%>/image/arrow_normal.png" width="8px">
					</div>
				</div>

				<div class="assigner_list_div none"
					style="padding: 3px 5px; border-bottom: 1px solid #ddd;">
					<div style="position: absolute; line-height: 40px; color: #666;">责任人</div>
					<input type="hidden" name="assignerId" id="assignerId"> <input
						name="addAssigner" id="addAssigner" value="" type="text"
						placeholder="选择责任人" class="form-control" readonly="readonly"
						style="border: 0px; padding-left: 100px; margin-top: 6px;" />
					<div
						style="float: right; margin-right: 5px; color: #666; margin-top: -30px;">
						<img src="<%=qrytaskpath%>/image/arrow_normal.png" width="8px">
					</div>
				</div>

				<div class="form-group" style="margin: 0.5em 0;">
					<div
						style="position: absolute; margin-top: 8px; margin-left: 5px; color: #666;">开始时间</div>
					<input name="query_startdate" id="query_startdate" value=""
						type="text" format="yy-mm-dd" class="form-control"
						readonly="readonly"
						style="border: 0px; border-bottom: 1px solid #ddd; padding-left: 100px;" />
				</div>

				<div class="form-group" style="margin: 0.5em 0;">
					<div
						style="position: absolute; margin-top: 8px; margin-left: 5px; color: #666;">结束时间</div>
					<input name="query_enddate" id="query_enddate" value="" type="text"
						format="yy-mm-dd" class="form-control" readonly="readonly"
						style="border: 0px; border-bottom: 1px solid #ddd; padding-left: 100px;" />
				</div>

			</div>
			<br />

			<div style="margin: 10px 80px;">
				<input type="button" onclick="syncquery();"
					class="savetaskbtn btn btn-block btn-success" value="搜索">
			</div>
		</form>
		
		<div class="searchtaskresult none" >
		<div class="searchtask_list " style="">
			<div
				style="width: 100%; border-bottom: 1px solid #ddd; line-height: 30px; height: 30px; padding: 0px 10px;"
				class="searchresult_title">
				<div style="float: left;">查询结果</div>
				<div style="float: right;">
					<span class="sort_startdate" onclick="sort_task();">时间排序</span>
				</div>
			</div>
			<div style="clear: both;"></div>
			<div class="searchnodata none"
				style="width: 100%; text-align: center; margin-top: 30px;">没有找到匹配的数据！</div>
			<div class="none searchloading"
				style="width: 100%; text-align: center; margin-top: 30px;">
				<img src="<%=qrytaskpath%>/image/loading.gif">&nbsp;查询数据中...
			</div>
			<div style="font-size: 14px; color: #666; overflow-y: auto; background-color: #fff;"
				class="search_result_tasklist">111111</div>
		</div>
	</div>

	<div class="cache_query_result none"></div>
		
	</div>

	
</div>

<div class="myDefMsgBox" style="display: none;">&nbsp;</div>



<jsp:include page="/common/rela/selcust.jsp"></jsp:include>

<!-- 责任人列表DIV -->
<jsp:include page="/common/systemuser.jsp"></jsp:include>
