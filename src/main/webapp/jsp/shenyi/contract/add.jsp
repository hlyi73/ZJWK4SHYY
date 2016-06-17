<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<!-- 验证控件 -->
<script src="<%=path%>/scripts/plugin/jquery/jquery_validation_1.11/jquery.validate.js" type="text/javascript"></script>
<style type="text/css">
.appmsg_add {
	text-align: center;
	padding: 12px 14px;
	line-height: 72px;
}
.appmsg_add a {
	display: block;
	font-size: 0;
	text-decoration: none;
	border-radius: 5px;
	-moz-border-radius: 5px;
	-webkit-border-radius: 5px;
	border: 3px dotted #b8b8b8;
	height: 72px;
}
.icon24_common.add_gray {
	background: url("https://res.wx.qq.com/mpres/zh_CN/htmledition/comm_htmledition/style/base/base_z.png") 0 -4616px no-repeat;
}
</style>
<script>
$(function () {
	initDatePicker();
	initDate();
// 	initSystemForm();
// 	initSystemFriChar();
// 	initSystemData();
// 	initUserCheck();//初始化提交用户
	removeGoTop();
// 	initButton();
});

var systemObj={};
function initSystemForm(){
	systemObj.fstchar = $(":hidden[name=assignerfstChar]");
	systemObj.currtype = $(":hidden[name=assignercurrType]");
	systemObj.currpage = $(":hidden[name=assignercurrPage]");
	systemObj.pagecount = $(":hidden[name=assignerpageCount]");
	systemObj.chartlist = $(".assignerChartList");
	systemObj.assignerlist = $("#div_user_list");
	systemObj.assignerNoData = $("#assignerNoData");
}

//异步加载首字母
function initSystemFriChar(){
	systemObj.chartlist.empty();
	systemObj.fstchar.val('');
	var type=systemObj.currtype.val();
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/fchart/list',
	      data: {flag:'approve',openId:'${openId}',publicId:'${publicId}',crmId: '${crmId}',type: type},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	systemObj.chartlist.html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	    	    return;
    	    	}
	    	    var ahtml = '';
	    	    $(d).each(function(i){
	    	    	ahtml += '<a href="javascript:void(0)" onclick="chooseSystemFristCharts(this)" style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
	    	    });
	    	    systemObj.chartlist.html(ahtml);
	      }
	 });
}

//选择字母查询
function chooseSystemFristCharts(obj){
	systemObj.currpage.val(1);
	systemObj.fstchar.val($(obj).html());
	initSystemData();
}

//异步查询责任人
function initSystemData(){
	var currpage = systemObj.currpage.val();
	var pagecount = systemObj.pagecount.val();
	var firstchar = systemObj.fstchar.val();
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/lovuser/userlist',
	      //async: false,
	      data: {flag:'approve',openId:'${openId}',publicId:'${publicId}',crmId: '${crmId}',viewtype: 'teamview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
	      dataType: 'text',
	      success: function(data){
	    	    var val = '';
	    	    if(null==data||""==data){
	    	    	if(currpage === "1"){
	    	    		systemObj.assignerNoData.css("display","");
	    	    		systemObj.assignerlist.empty();
	    	    	}
	    	    	return;
	    	    }
	    	    var d = JSON.parse(data);
	    	    if(d == ""){
	    	    	if(currpage === "1"){
	    	    		systemObj.assignerNoData.css("display","");
	    	    		systemObj.assignerlist.empty();
// 	    	    		systemObj.chartlist.css("display",'none');
	    	    	}
	    	    	return;
	    	    }else if(d.errorCode && d.errorCode != '0'){
	    	    	if(currpage === "1"){
	    	    		systemObj.assignerlist.empty();
	    	    		systemObj.assignerlist.html(d.errorMsg);
	    	    	}
	    	    	return;
	    	    }else{
					$(d).each(function(i){
						if(this.userid!='${crmId}'){
						val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
							+  '<div class="list-group-item-bd"><input type="hidden" name="userId" value="'+this.userid+'"/>'
							+  '<input type="hidden" name="userName" value="'+this.username+'"/>'
							+  '<input type="hidden" name="email" value="'+this.email+'"/>'
							+  '<h2 class="title assName">'+this.username+'</h2><p>职称：'+this.title+'</p><p>部门：<b>'+this.department+'</b>'
							+  '</p></div><div class="input-radio" title="选择该条记录"></div></a>';
						}});
					systemObj.chartlist.css("display",'');
		    	}
	    	    systemObj.assignerlist.html(val);
	    	    initUserCheck();
	      }
	 });
}

// function initButton(){
// 	$(".taskGoBak").click(function(){
// 		$("#task-create").addClass("modal");
// 		$("#contract-create").removeClass("modal");
// 	});
// }

//初始化日期
function initDate()   
{   
	var today = new Date();   
	var day = today.getDate();   
	var month = today.getMonth() + 1; 
	if(month < 10){
		month = '0' + month;
	}
	if(day < 10){
		day = '0' + day;
	}
	var year = today.getFullYear();
	var date = year + "-" + month + "-" + day;   
	$("input[name=bxDateInput]").val(date);
} 

//初始化日期控件
function initDatePicker(){
	var opt = {
		date : {preset : 'date',maxDate: new Date(2099,12,31)},
		datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2030,7,30,15,44), stepMinute: 5  },
		time : {preset : 'time'},
		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
		image_text : {preset : 'list', labels: ['Cars']},
		select : {preset : 'select'}
	};
	//类型 date  datetime
	$('#bxDateInput').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
}

//移除向上的箭头
function removeGoTop(){
	$(".goTop").remove();
}

//合同开始日期
function contractDate(){
	if($("input[name=startDate]").val()==""){
		$("input[name=startDate]").val($("input[name=bxDateInput]").val());
		$("#div_contract_startDate").css("display","");
		$("#contract_startDate").html($("input[name=bxDateInput]").val());
		$('#div_date_operation').css("display",'none');
		//合同结束日期
		$("#div_contract_date_end_label").css("display","");
		if($("input[name=endDate]").val() == ""){
			$('#div_date_operation').css("display",'');
		} 
// 		displayMsg();
		scrollToButtom();//滚动到底部
	}else if($("input[name=endDate]").val() == ""){
		var start = date2utc($("input[name=startDate]").val());
		var end = date2utc($("input[name=bxDateInput]").val()); 
		if(end<start){
			$("input[name=bxDateInput]").val('').attr("placeholder","结束日期不能晚于开始日期,请重新选择结束日期!");
			return;
		}
		$("input[name=endDate]").val($("input[name=bxDateInput]").val());
		$("#div_contract_endDate").css("display","");
		$("#contract_endDate").html($("input[name=bxDateInput]").val());
		$('#div_date_operation').css("display",'none');
		$("#div_contract_cost").css("display",'');
		if($("input[name=cost]").val() == ""){
			$('#div_amount_operation').css("display",'');
		} 
	}
}

//金额
function contractAmount(){
	var value=$("input[name=input_amount]").val();
	if(value == "" || !validates(value)){
		$("input[name=input_amount]").val('');
		$("input[name=input_amount]").attr('placeholder','请输入正确的金额！');
		return;
	}
	$("#div_contract_cost_reply").css("display",'');
	$("input[name=cost]").val(value);
	$("#contract_cost").html(value);
	$('#div_amount_operation').css("display",'none');
	$("input[name=input_amount]").val('');//清空输入框
	$("#div_contract_message_operation").css("display","");
	displayMsg();	
}

//创建新的任务
// function confirmSchedule(){
// 	var form=$("form[name=taskForm]");
// 	var dataObj = [];
// 	form.find("input").each(function(){
// 		var n = $(this).attr("name");
// 		var v = $(this).val();
// 		dataObj.push({name: n, value: v});					
// 	});
// 	asyncInvoke({
<%-- 		url: '<%=path%>/schedule/asynsave', --%>
// 		type: 'post',
// 		data: dataObj,
// 	    callBackFunc: function(data){
// 	    	if(!data) return;
//  	    	var o  = JSON.parse(data);
// 	    	if(o.errorCode !== '0'){
//     		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + o.errorCode + "错误描述:" + o.errorMsg);
//     		   $(".myMsgBox").delay(2000).fadeOut();
//     		   return;
//     		}
// 	    	if(o.rowId){
// 	    		var title = $(".createTaskContainer input[name=title]").val();
// 	    		$("#div_expense_parent").css("display","");
// 	    		$("#expense_parent").html(title);
// 	    		//给隐藏域赋值
// 	    		$(":hidden[name=parent_id]").val(o.rowId);
// 	    		$(":hidden[name=parent_name]").val(title);
// 	    		//显示与隐藏数据层
// 	    		$("#task-create").addClass("modal");
// 	    		$("#contract-create").removeClass("modal");
// 	    		$("#div_contract_parent").css("display","");
// 	    		$("#contract_parent").html(title);
// 	    		//日期
// 	    		$("#div_contract_date_start_label").css("display",'');
// 	    		if($("input[name=startDate]").val() == ""){
// 	    			$('#div_date_operation').css("display",'');
// 	    		}
// 	    	}
// 	    	$("#task_title").css("display","");
// 	    	initSchedulePage();
// 	    }
// 	});
// }



//相关
function contractReleation(type,oper){
	$("#div_contract_parent_list").css("display",'');
	$("#contract_parent_list").html("加载中...");
	if(oper == "new"){
		$("input[name=currpage]").val(1);
		//查询模块的首字母
		if(type !== "taskList"){
			searchFristCharts(type);
		}else{
			initTaskSearch();	
		}
	}else if(oper == "CHAR"){
		$("input[name=currpage]").val(1);
	}else if(oper == "task"){
		$("input[name=currpage]").val(1);
	}
	var currpage = $("input[name=currpage]").val();
	if(currpage == 1){
		$("#div_prev").css("display",'none');
	}else{
		$("#div_prev").css("display",'');
	}
	var pagecount = $("input[name=pagecount]").val();
	var firstchar = $("input[name=firstchar]").val();
	if(type == "opptyList"){
		var parent_type = "Opportunities";
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/oppty/list' || '',
		      //async: false,
		      data: {orgId:'${orgId}',crmId: '${crmId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
		      dataType: 'text',
		      success: function(data){
			    	  if(!data){
			    		 if(currpage=='1'){
		  		    	  	$("#contract_parent_list").html("<div style='text-align:center;width:100%;margin-top:30px;'>没有找到数据</div>");
			    		 }
	  		    	     $("#div_next").css("display",'none');
	  		    	  	 return;
	  		    	  }
		    	    var val = '';
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	if(currpage=='1'){
		  	    	  		$("#contract_parent_list").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
		    	    	}
			  	    	$("#div_next").css("display",'none');
	  	    	  		return;
			    	}
					if(d == ""||$(d).size()<0){
						if(currpage=='1'){
							$("#contract_parent_list").html("<div style='text-align:center;width:100%;margin-top:30px;'>没有找到数据</div>");
						}
		    	    	$("#div_next").css("display",'none');
		    	    	return;
		    	    }else{
	    	    		if($(d).size() == pagecount){
	    	    			$("#div_next").css("display",'');
	    	    		}else{
	    	    			$("#div_next").css("display",'none');
	    	    		}
						$(d).each(function(i){
							val += '<span><a href="javascript:void(0)" onclick="contractParentSel(\''+parent_type+'\',\''+this.rowid+'\',\''+this.name+'\')">'+ this.name +'</a></span><br>';
						});
		    	    }
					$("#contract_parent_list").html(val);
// 					displayMsg();
		      }
		 });
		 $("input[name=parent_type]").val(parent_type);
	}else if(type == "accntList"){
		var parent_type = "Accounts";
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/customer/list' || '',
		      //async: false,
		      data: {orgId:'${orgId}',crmId: '${crmId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
		      dataType: 'text',
		      success: function(data){
		    	  if(!data){
		    		  if(currpage=='1'){
	  		    	  	$("#contract_parent_list").html("<div style='text-align:center;width:100%;margin-top:30px;'>没有找到数据</div>");
		    		  }
		    		  $("#div_next").css("display",'none');
	  		    	  return;
	  		    	}
		    	    var val = '';
		    	    var d = JSON.parse(data);
		    	    if(d == ""){
		    	    	if(currpage=='1'){
		  		    	  	$("#contract_parent_list").html("<div style='text-align:center;width:100%;margin-top:30px;'>没有找到数据</div>");
			    		}
		    	    	$("#div_next").css("display",'none');
		    	    	return;
		    	    }else  if(d.errorCode && d.errorCode !== '0'){
						if(currpage=='1'){
			    	    	$("#contract_parent_list").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
						}
		  	    	  	$("#div_next").css("display",'none');
	  	    	  		return;
			    	}else{
			    	    	if($(d).size() == pagecount){
		    	    			$("#div_next").css("display",'');
		    	    		}else{
		    	    			$("#div_next").css("display",'none');
		    	    		}
							$(d).each(function(i){
								val += '<span><a href="javascript:void(0)" onclick="contractParentSel(\''+parent_type+'\',\''+this.rowid+'\',\''+this.name+'\')">'+ this.name +'</a></span><br>';
							});
			    	}
					$("#contract_parent_list").html(val);
// 					displayMsg();
		      }
		 });
		$("input[name=parent_type]").val(parent_type);
	}
// 	else if(type == "taskList"){
// 		var startDate = $(":hidden[name=startdate]").val();
// 		var endDate = $(":hidden[name=enddate]").val();
// 		var status = $("#taskstatus").val();
// 		var parent_type = "Tasks";
// 		$.ajax({
// 		      type: 'get',
<%-- 		      url: '<%=path%>/schedule/tasklist' || '', --%>
// 		      async: false,
// 		      data: {crmId: '${crmId}',viewtype: 'myview',currpage:currpage,startDate:startDate,endDate:endDate,status:status,pagecount:pagecount} || {},
// 		      dataType: 'text',
// 		      success: function(data){
// 		    	    var d = JSON.parse(data);
// 		    	    if(d.errorCode && d.errorCode !== '0'){
// 		    	    	$("#contract_parent_list").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
// 	    	    	   return;
// 	    	    	}
// 		    	    var val = '';
// 		    	    if(d == ""){
// 		    	    	val = "没有找到数据";
// 		    	    	$("#div_next").css("display",'none');
// 		    	    	$("#fristChartsList").empty();
// 		    	    }else{
// 		    	    	if($(d).size() == pagecount){
// 	    	    			$("#div_next").css("display",'');
// 	    	    		}else{
// 	    	    			$("#div_next").css("display",'none');
// 	    	    		}
// 						$(d).each(function(i){
// 							var title = escape(this.title);
// 							val += '<div><a href="javascript:void(0)" onclick="contractParentSel(\''+parent_type+'\',\''+this.rowid+'\',\''+title+'\')">'+ this.title +'</a></div>';
// 						});
// 			    	}
// 					$("#contract_parent_list").html(val);
// //  					displayMsg();
// 		      }
// 		 });
// 		$("input[name=parent_type]").val(parent_type);
// 	}
	
}

//任务查询
// function initTaskSearch(){
// 	$("#fristChartsList").empty();
// 	var ahtml = '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'curmonth\')">当月任务</a>';
// 	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'premonth\')">上月任务</a>';
// 	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'process\')">进行中的任务</a>';
// 	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'finish\')">已结束的任务</a>';
// 	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'create\')"><span style=" color: #FFF;font-weight: 800;border:1px solid #DDDDDD;background-color:#106c8e;padding-left:3px;padding-right:3px; ">新任务<span></a>';
// 	$("#fristChartsList").html(ahtml);
// }

//选择任务
// function chooseTaskSearch(type){
// 	var curdate = new Date();
// 	var year = curdate.getFullYear();
// 	var month = curdate.getMonth()+1;
// 	var days = getDaysInMonth(year,month);
// 	if(type == "curmonth"){
// 		if(month <10){
// 			month = "0" + '' + month;
// 		}
// 		$(":hidden[name=startdate]").val(year+'-'+month+'-'+'01');
// 		$(":hidden[name=enddate]").val(year+'-'+month+'-'+days);
// 		$("#taskstatus").val('');
// 	}else if(type == "premonth"){
// 		if(month <11){
// 			month = "0" + '' + (month-1);
// 		}else{
// 			month = month-1;
// 		}
// 		$(":hidden[name=startdate]").val(year+'-'+month+'-'+'01');
// 		$(":hidden[name=enddate]").val(year+'-'+month+'-'+''+days);
// 		$("#taskstatus").val('');
// 	}else if(type == "process"){
// 		$(":hidden[name=startdate]").val('');
// 		$("#taskstatus").val('In Progress');
// 	}else if(type == "finish"){
// 		$(":hidden[name=startdate]").val('');
// 		$("#taskstatus").val('Completed');
// 	}else if(type === "create"){//创建任务
// 		$("#contract-create").addClass("modal");
// 		$("#task-create").removeClass("modal");
// 		scrollToButtom($(".createTaskContainer"));
// 	}
// 	contractReleation("taskList","task");
// }

//获得当月的天数
function getDaysInMonth(year,month){
	var new_date = new Date(year,month,1); //取当年当月中的第一天     
	var date_count =  (new Date(new_date.getTime()-1000*60*60*24)).getDate();     
	return date_count;
}

//查询模块的首字母
function searchFristCharts(type){
	$("#fristChartsList").empty();
	$(":hidden[name=firstchar]").val('');
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/fchart/list',
	      data: {orgId:'${orgId}',crmId: '${crmId}',type: type},
	      dataType: 'text',
	      success: function(data){
	    	  	if(data!=""){
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
	  	    	  		$("#fristChartsList").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
			    	    return;
			    	}
		    	    var ahtml = '';
		    	    $(d).each(function(i){
		    	    	ahtml += '<a href="javascript:void(0)" onclick="chooseFristCharts(this)">'+ this +'</a>';
		    	    	//if((i+1) % 7 === 0) ahtml += "<br>";
		    	    });
		    	    $("#fristChartsList").html(ahtml);
	    	  	}
	      }
	 });
}

//点击首字母事件
function chooseFristCharts(obj){
	$(":hidden[name=firstchar]").val($(obj).html());
	var parent_type =$("input[name=parent_type]").val();
	if(parent_type == "Accounts"){
		contractReleation("accntList","CHAR");
	}else if(parent_type == "Opportunities"){
		contractReleation("opptyList","CHAR");
	}else if(parent_type == "Tasks"){
		contractReleation("taskList","CHAR");
	}
}

//相关
function contractParentSel(type,id,value){
	value = unescape(value);
	$("input[name=parent_type]").val(type);
	$("input[name=parent_id]").val(id);
	$("input[name=parent_name]").val(value);
	$("#div_contract_parent").css("display",'');
	$("#contract_parent").html(value);
	//合同名称
	$("#div_contract_name").css("display",'');
	if($("input[name=title]").val()==""){
		$("#div_name_operation").css("display",'');
	}
	scrollToButtom();
}

//合同名称
function contractName(){
	var value =$("input[name=input_name]").val();
	if(value.trim()==""||value.length>60){
		$("input[name=input_name]").val("");
		$("input[name=input_name]").attr('placeholder','请输入合理的合同名称！');
		return;
	}
	$("input[name=title]").val(value);
	$("#div_contract_name_reply").css("display",'');
	$("#contract_name").html(value);
	$("#div_name_operation").css("display","none");
	$("#div_contract_code").css("display",'');
	if($("input[name=contractCode]").val() == ""){
		$('#div_code_operation').css("display",'');
	} 
// 	displayMsg();
	scrollToButtom();//滚动到底部
}

//合同编码
function contractCode(){
	var value =$("input[name=input_code]").val();
	if(value==""||!validates(value)){
		$("input[name=input_code]").val("");
		$("input[name=input_code]").attr('placeholder','请输入合理的编码！');
		return;
	}
	$("input[name=contractCode]").val(value);
	$("#div_contract_code_reply").css("display",'');
	$("#contract_code").html(value);
	$("#div_code_operation").css("display","none");
	$("#div_contract_date_start_label").css("display",'');
	if($("input[name=startDate]").val() == ""){
		$('#div_date_operation').css("display",'');
	} 
// 	displayMsg();
	scrollToButtom();//滚动到底部
}

//汇总展示
function displayMsg(){
	var type = $("input[name=parent_type]").val();
	//所选模块类型
	var mName = "";
	if(type == "Opportunities"){
		 mName = "跟进业务机会";
	}else if(type == "Accounts"){
		mName = "跟进企业";
	}
// 	else if(type == "Tasks"){
// 		mName = "处理任务";
// 	}
	//消息
	var msg = "";
	msg = "您在" + mName+ "【<span style='color:blue;'>" + $("input[name=parent_name]").val() +"</span>】过程中签订了一个金额为：【<span style='color:blue;'>￥"+$("input[name=cost]").val()+"</span>】元的合同：【<span style='color:blue;'>"+
	$("input[name=title]").val()+"</span>】,<br>合同日期为:<span style='color:blue;'>"+ $("input[name=startDate]").val()+"</span>到<span style='color:blue;'>"
	+$("input[name=endDate]").val()+"</span>;<br>合同编码为：<span style='color:blue;'>"+ $("input[name=contractCode]").val()+"</span>"+"<br>请点击【提交】按钮完成操作。";
	//赋值到视图
	$("#div_contract_collect").css("display",'');
	$("#contract_message").html(msg);
}


//向上的按钮
function topage(type){
	var parent_type =$("input[name=parent_type]").val();
	var currpage = $("input[name=currpage]").val();
	if(type == "prev"){
		$("input[name=currpage]").val(parseInt(currpage) - 1);
	}else if(type == "next"){
		$("input[name=currpage]").val(parseInt(currpage) + 1);
	}

	if(parent_type == "Accounts"){
		contractReleation("accntList","XXX");
	}else if(parent_type == "Opportunities"){
		contractReleation("opptyList","XXX");
	}else if(parent_type == "Tasks"){
		contractReleation("taskList","XXX");
	}
}




//验证正数
function validates(num){
  var reg = /^\d+(?=\.{0,1}\d+$|$)/;
  if(reg.test(num)) return true;
  return false ;  
}


//直接提交
function commitExamBef(){
	$(":hidden[name=desc]").val($("#contract_desc").val());
	$(":hidden[name=commitid]").val('');
	$(":hidden[name=approvalstatus]").val('draft');//new 新建状态
	$("form[name=bxForm]").submit();
	//提交用户列表隐藏
// 	$(".userList").css("display", "");
// 	$("#contract-create").css("display", "none");
	//滚动到顶部
// 	scrollToButtom($(".userList"));
}

function initUserCheck(){
	//勾选某个审批人的超链接
	$("#div_user_list > a").click(function(){
		$("#div_user_list > a").removeClass("checked");
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
			var userId = $(this).find(":hidden[name=userId]").val();
			var userName = $(this).find(":hidden[name=userName]").val();
			$(":hidden[name=approvalname]").val(userName);
			$(":hidden[name=approvalid]").val(userId);
		}
		return false;
	});
}


//选择好审批人后 提交审批
function commitExam(){
	var approvalid = $(":hidden[name=approvalid]").val();
	if(!approvalid){
		$(".myMsgBox").css("display","").html("请选择审批人!");
		$(".myMsgBox").delay(2000).fadeOut();
		return;
	}
	$(":hidden[name=commitid]").val('${crmId}');
	$(":hidden[name=approvalstatus]").val('approving');//approving 待审批
	$("form[name=bxForm]").submit();
}

//跳过选择审批人 提交
function skipeExam(){
	$(":hidden[name=commitid]").val('');
	$(":hidden[name=approvalstatus]").val('draft');//new 新建状态
	//责任人清空
	$(":hidden[name=approvalid]").val('');
	$(":hidden[name=approvalname]").val('');
	$("form[name=bxForm]").submit();
}

//滚动到底部
function scrollToButtom(obj){
	if(obj){
		var y = $(obj).offset().top;
	    if(!y) y = 0;
		window.scrollTo(100, y);
	}else{
		window.scrollTo(100, 99999);
	}
    
	return false;
}

</script>
</head>

<body>
	<!-- 合同创建FORM DIV -->
	<div id="contract-create">
		<div id="site-nav" class="navbar">
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">新增合同</h3>
		</div>
		
		<input type="hidden" name="currpage" value="1" />
		<input type="hidden" name="pagecount" value="10"/>
		
		<!-- 新增合同流程内容 -->
		<div class="site-card-view bxFlowContent">
			<!-- 提交合同数据的表单 -->
			<form name="bxForm" action="<%=path%>/contract/save" method="post">
				<input type="hidden" name="crmId" value="${crmId}" /> 
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="currpage" value="1" />
				<input type="hidden" name="pagecount" value="10"/>
				<!-- add contract form data -->
				<input type="hidden" name="startDate" value=""> 
				<input type="hidden" name="endDate" value=""> 
				<input type="hidden" name="contractCode" value=""> 
				<input type="hidden" name="title" value=""> 
				<input type="hidden" id="cost" name="cost" value=""> 
				<input type="hidden" id="desc" name="desc" value=""> 
				<input type="hidden" id="assigner" name="assigner" value="${sessionScope.CurrentUser.name}"> 
				<input type="hidden" id="assignerid" name="assignerid" value="${sessionScope.CurrentUser.crmId}"> 
				<input type="hidden" id="status" name="status" value=""> 
				<!-- 类型   三个值  Accounts Opportunities Tasks -->
				<input type="hidden" name="parent_type" value="" >
				<!-- 类型的ID -->
				<input type="hidden" name="parent_id" value="" >
				<input type="hidden" name="parent_name" value="" >
				<!-- 按照字母查询 -->
				<input type="hidden" name="firstchar" value="" >
				<!-- 任务查询条件 -->
				<input type="hidden" name="startdate" value="" >
				<input type="hidden" name="enddate" value="" >
				<input type="hidden" id="taskstatus" value="" >
				<!-- 审批人 -->
				<input type="hidden" name="approvalid" value="" >
				<input type="hidden" name="commitid" value="" >
				<input type="hidden" name="commitname" value="${assigner}" >
				<input type="hidden" name="approvalname" value="" >
				<input type="hidden" name="approvalstatus" value="" >
				<input type="hidden" name="recordid" value="" ><!-- 费用记录ID-->
				<input type="hidden" name="orgId" value="${orgId}" />
			</form>

		</div>
		<!-- 相关 -->
		<div id="div_parent_label" class="chatItem you" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									 您签订了关于什么的合同?【1/6】<br> <br>
<!-- 									<a href="javascript:void(0)" onclick="contractReleation('taskList','new')">处理任务</a>&nbsp;&nbsp; -->
									<a href="javascript:void(0)" onclick="contractReleation('opptyList','new')">跟进业务机会 </a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onclick="contractReleation('accntList','new')">跟进客户 </a>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 花到哪去了列表 -->
		<div id="div_contract_parent_list" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
			    <img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText" >
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="text-align:left;float:left;">
									请选择：
								</div>
								<div style="clear:both"></div>
								<!-- 字母区域 -->
								<div id="fristChartsList" style="margin-top:12px;line-height:35px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;">
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_prev" >
									<a href="javascript:void(0)" onclick="topage('prev')">
									<img  src="<%=path%>/image/prevpage.png" width="32px" >
									</a>
								</div>
								<div id="contract_parent_list" style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_next">
									<a href="javascript:void(0)" onclick="topage('next')">
									<img  src="<%=path%>/image/nextpage.png" width="32px" >
									</a>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 相关回复 -->
		<div id="div_contract_parent" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="contract_parent" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 合同名称 -->
		<div id="div_contract_name" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">合同的名称?【2/6】</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 合同名称回复 -->
		<div id="div_contract_name_reply" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="contract_name" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 合同编码 -->
		<div id="div_contract_code" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">合同的编码?【3/6】</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 合同编码回复 -->
		<div id="div_contract_code_reply" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="contract_code" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 合同开始日期 -->
		<div id="div_contract_date_start_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">合同开始日期?【4/6】</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 合同开始日期回复 -->
		<div id="div_contract_startDate" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="contract_startDate" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 合同结束日期 -->
		<div id="div_contract_date_end_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">合同结束日期?【5/6】</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 合同结束日期回复 -->
		<div id="div_contract_endDate" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="contract_endDate" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 合同金额 -->
		<div id="div_contract_cost" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">请输入合同金额 【6/6】</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 合同金额回复 -->
		<div id="div_contract_cost_reply" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel" >
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="contract_cost" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 汇总 -->
		<div id="div_contract_collect" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>//scripts//plugin//wb//css//images//dc.png">
				<div class="cloud cloudText" >
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div id="contract_message" style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		<!-- 输入合同名称 -->
		<div id="div_name_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input name="input_name" id="input_name" maxlength="60" style="width:100%" type="text" class="form-control" placeholder="输入名称">
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" onclick="contractName()" class="btn btn-block bxDateInputBtn" style="font-size: 14px;">确&nbsp;&nbsp;&nbsp;认</a>
			</div>
		</div>
		<!-- 输入合同编码 -->
		<div id="div_code_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input name="input_code" id="input_code" style="width:100%" type="number" class="form-control" placeholder="输入编码">
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" onclick="contractCode()" class="btn btn-block bxDateInputBtn" style="font-size: 14px;">确&nbsp;&nbsp;&nbsp;认</a>
			</div>
		</div>
		<!-- 输入日期 -->
		<div id="div_date_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input name="bxDateInput" id="bxDateInput" value="" style="width:100%" type="text" class="form-control" placeholder="点击选择日期" readonly="">
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" onclick="contractDate()" class="btn btn-block bxDateInputBtn" style="font-size: 14px;">确&nbsp;&nbsp;&nbsp;认</a>
			</div>
		</div>
		<!-- 输入金额 -->
		<div id="div_amount_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input type="number" name="input_amount" id="input_amount" value="" style="width:100%" type="text" class="form-control" placeholder="输入金额">
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" onclick="contractAmount()" class="btn btn-block bxDateInputBtn" style="font-size: 14px;">确&nbsp;&nbsp;&nbsp;认</a>
			</div>
		</div>
		<!-- 合同条款 -->
		<div id="div_contract_message_operation" style="display:none;margin-top:5px;text-align:center;">
			<div style="width: 96%;margin:10px;">
				<textarea name="contract_desc" id="contract_desc" style="width:100%" rows = "3"  placeholder="补充说明" class="form-control"></textarea>
			</div>
			<div style="width: 100%;">
				<a href="javascript:void(0)" onclick="commitExamBef()" class="btn btn-block bxDateInputBtn" style="font-size: 16px;margin-left:10px;margin-right:10px;">保&nbsp;&nbsp;&nbsp;存</a>
			</div>
		</div>
		</div>
	<div style="clear:both;"></div>
	<!-- 任务容器  费用报销时 有需要添加任务 -->
<!-- 	<div class="createTaskContainer"> -->
<!-- 		<div id="task-create" class="modal"> -->
<!-- 			<div id="task_title" class="navbar"> -->
<!-- 				<a href="#" onclick="javascript:void(0)" class="act-primary taskGoBak"><i class="icon-back"></i></a> -->
<!-- 				新建任务 -->
<!-- 			</div> -->
<%-- 			<jsp:include page="/common/scheduleform.jsp"></jsp:include> --%>
<!-- 		</div> -->
<!-- 	</div> -->
	<!-- 用户列表 -->
	<div class="userList" style="display:none">
	<div id="" class="navbar">
<!-- 		    <a href="#" onclick="javascript:void(0)" class="act-primary assignerGoBak"><i class="icon-back"></i></a> -->
			审批人列表
		</div>
		<input type="hidden" name="assignerfstChar" />
	    <input type="hidden" name="assignercurrType" value="userList" />
	    <input type="hidden" name="assignercurrPage" value="1" />
	    <input type="hidden" name="assignerpageCount" value="1000" />
		<!-- 字母区域 -->
		<div class="list-group-item listview-item radio assignerChartList" style="background: #fff;padding: 10px;line-height: 30px;">
		</div>
	    <div class="page-patch">
		<div class="list-group listview listview-header" id="div_user_list">
		</div>
		<div id="assignerNoData" style="text-align: center; padding-top: 50px;display:none">没有找到数据</div>
		<div class="nextCommitExamDiv flooter" style="display:''">
			<div class="button-ctrl" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 1px;">
				<fieldset class="">
					<div class="ui-block-a" style="padding-bottom: 4px;">
						<a href="javascript:void(0)"  class="btn btn-block"
										style="font-size: 14px;" onclick="skipeExam()">保存草稿</a>
					</div>
					<div class="ui-block-a" style="padding-bottom: 4px;">
						<a href="javascript:void(0)"  class="btn btn-success btn-block"
										style="font-size: 14px;" onclick="commitExam()">确定</a>
					</div>
				</fieldset>
			</div>
		</div>
	</div>	
	</div>
	<br><br><br><br><br><br><br><br><br><br><br><br><br>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<!--脚页面  -->
<%-- 	<jsp:include page="/common/footer.jsp"></jsp:include> --%>
</body>
</html>