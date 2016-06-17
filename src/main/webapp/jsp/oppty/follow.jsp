<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%>
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
<script src="<%=path%>/scripts/template.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/css/slider.css" />
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
.follow_menu{
	line-height:30px;
	height:30px;
	border-bottom:1px dashed #CCCCCC;
	padding-left:10px;
	color:#106c8e;
}
</style>
<script>

var objArray = new Array();

$(function (){
	removeGoTop();
	initTaskForm();
	initDatePicker();
	createMenu();
});

function removeGoTop(){
	$(".goTop").remove();
}

function initTaskForm(){
	$(".assignerChoose").click(function(){
		$("#task-create").addClass("modal");
		$("#assigner-more").removeClass("modal");
	});
	
	//责任人退回
	$(".assignerGoBak").click(function(){
		$("#task-create").removeClass("modal");
		$("#assigner-more").addClass("modal");
	});
	//相关退回
	$(".parentGoBak").click(function(){
		$("#task-create").addClass("modal");
		$("#oppty_follow").removeClass("modal");
	});
	//联系人退回
	$(".parentConGoBak").click(function(){
		$("#contact-create").addClass("modal");
		$("#oppty_follow").removeClass("modal");
	});
	// 责任人 的 确定按钮
	$(".assignerbtn").click(function(){
		$(".assignerList > a.checked").each(function(){
			var assId = $(this).find(":hidden[name=assId]").val();
			var assName = $(this).find(".assName").html();
			$("input[name=assignerId]").val(assId);
			$("input[name=assignerName]").val(assName);
			$(".assignerGoBak").trigger("click");
		});
		
	});
	//联系人
	$(".contactsubmit").click(function(){
		//后台新增联系人
		if(!valiBefAddCon()){
			return;
		} 
		$("#contact-create").addClass("modal");
		$("#oppty_follow").removeClass("modal");
		//创建联系人
		addContact();
		//菜单
		createMenu();
		scrollToButtom();
	});
	//任务
	$(".tasksubmit").click(function(){
		//后台新增任务
		if(!valiBefAddTask()){
			return;
		} 
		$("#task-create").addClass("modal");
		$("#oppty_follow").removeClass("modal");
		//创建任务
		addTask();
		//菜单
		createMenu();
		scrollToButtom();
	});
}

//初始化日期控件
function initDatePicker(){
	var opt = {
		date : {preset : 'date'},
		datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2024,7,30,15,44), stepMinute: 5  },
		time : {preset : 'time'},
		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
		image_text : {preset : 'list', labels: ['Cars']},
		select : {preset : 'select'}
	};
	//类型 date  datetime
	$('#bxDateInput').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	$('#startdate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	$('#enddate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
}

//创建菜单
function createMenu(){
	//清除所有click事件
	$.each(objArray,function(n,obj) {
    	$(obj).removeAttr("onclick");
    	$(obj).css("color","#AAAAAA");
    });
	var t = new Date().getTime();
	var a = menuTemp.join("");
	$(a).attr("id", "div_menu_" + t).insertBefore("#follow_div");
	objArray.push($("#div_menu_"+t).find("a"));
	
	//隐藏所有操作控件
	hiddenOpeartion();
}

//---------------------业务机会推进-------------------
function followOppty(){
	//div点击意见
	$(".salesStageDiv div").click(function(){
		var k = $(this).attr("key");
		var h = $(this).html();
		if(k){
			 $(".stepTickShowSp").html(h);
			 //opptyForm
			 $("form[name=opptyForm]").find(":hidden[name=salesStage]").val(k);
			 $("form[name=opptyForm]").find(":hidden[name=salesStageName]").val(h);
		}
		$(".salesStageDiv").css("display","none");
		$(".salesStageDivBotom").css("display","none");
		statusControl("salesStageShow");
	});
	//确定按钮
	$(".salesStageBar").find(".stepSave").unbind("click").bind("click", function(){//步逐保存
		//销售阶段
		var stage = $("form[name=opptyForm]").find(":hidden[name=salesStageName]").val();
		if(stage == "${oppstage}"){
			stage = "业务机会阶段没有发生变化！";
		}else{
			stage = "业务机会阶段由【${oppstage}】改为【"+stage+"】";
		}
		
		//显示回复消息
		var t = new Date().getTime();
		var a = respTemp.join("");
		$(a).attr("id", "div_resp_" + t).insertBefore("#follow_div");
		$("#div_resp_" + t).css("display","").find("#oppty_attr").append(stage);
		
		//异步调用 更新销售阶段
		smOpptyForm();
		
		//状态控制
		statusControl('salesStageHide');
		createMenu();
		scrollToButtom();
		
	});
	
	//隐藏所有操作控件
	hiddenOpeartion();
	//显示业务机会阶段选择层
	$(".salesStageDiv").css("display","");
	$(".salesStageDivBotom").css("display","");
	statusControl("salesStageHide");
	
	scrollToButtom();
}

//---------------------业务机会关闭日期----------------------------------
//修改关闭日期
function updClosedDate(){
	//状态修改
	hiddenOpeartion();
	statusControl("closeDateShow");
	statusControl("saleStageHide");
	//赋初始值
	$("input[name=bxDateInput]").val("${oppclosedate}");
}

//修改后台业务机会关闭日期
function syncOppClosedDate(){
	//关闭日期
	var closedateTxt = '',
	    cdObj = $("input[name=bxDateInput]"),
	    closedate = cdObj.val();
	if(closedate === ""){
		cdObj.attr("placeholder","请输入关闭日期");
		return;
	}
	if(closedate == "${oppclosedate}"){
		closedateTxt = "关闭日期："+closedate;
	}else{
		closedateTxt = "关闭日期由${oppclosedate}改为"+closedate;
	}
	var t = new Date().getTime();
	var a = respTemp.join("");//me 内容回复响应模板
	$(a).attr("id", "div_resp_" + t).insertBefore("#follow_div");
	$("#div_resp_" + t).css("display","").find("#oppty_attr").append(closedateTxt);
	//opptyForm 关闭日期
	$("form[name=opptyForm]").find(":hidden[name=dateClosed]").val(closedate);
	
	//异步调用 更新销售阶段
	smOpptyForm();
	
	//控件状态控制
	statusControl("closeDateHide");
	createMenu();
	scrollToButtom();
}

//---------------------业务机会金额----------------------------------
//修改业务机会金额
function updAmount(){
	$("input[name=oppamount]").val("${amount}");
	
	//状态控制
	hiddenOpeartion();
	statusControl("salesStageHide");
	statusControl("amountShow");
}

//修改后台业务机会金额
function syncOppAmount(){
	//金钱回复区域
	var amtTxt = '',
	    amount = $("input[name=oppamount]").val();
	if(amount == "${amount}"){
		amtTxt = "金额："+amount;
	}else{
		amtTxt = "金额由${amount}改为"+amount;
	}
	
	var t = new Date().getTime();
	var a = respTemp.join("");
	$(a).attr("id", "div_resp_" + t).insertBefore("#follow_div");
	$("#div_resp_" + t).css("display","").find("#oppty_attr").append(amtTxt);
	//opptyForm 金额
	$("form[name=opptyForm]").find(":hidden[name=amount]").val(amount);
	
	//异步调用 更新销售阶段
	smOpptyForm();
	
	//控制状态
	statusControl("amountHide");
	createMenu();
	scrollToButtom();
}

//---------------------添加任务----------------------------------
function toTasks(type){ 
	//隐藏所有操作控件
	hiddenOpeartion();
	
	//历史任务
	if(1 == type){
		var t = new Date().getTime();
		var a = listTemp.join("");
		$(a).attr("id", "div_task_" + t).insertBefore("#follow_div");
		loadData('taskList','task',$("#div_task_" + t));
	}
	//新增任务
	else if(2== type){
		$("#oppty_follow").addClass("modal");
		$("#task-create").removeClass("modal");
		
		//清空输入框
		$("#taskForm").find("input[type=text]").each(function(){
			$(this).val('');
		}).end().find("select").each(function(){
			$(this).val('');
		}).end().find("textarea").each(function(){
			$(this).text('');
		});
	}
}

var div_obj = null;

//任务查询
function initTaskSearch(obj){
	div_obj = obj;
	(obj.find("#fristChartsList")).empty();
	var ahtml = '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'curmonth\');">当月任务</a>';
	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'premonth\');">上月任务</a>';
	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'process\');">进行中的任务</a>';
	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'finish\');">已结束的任务</a>';
	(obj.find("#fristChartsList")).html(ahtml);
}

//选择任务的类别
function chooseTaskSearch(type){
	var curdate = new Date();
	var year = curdate.getFullYear();
	var month = curdate.getMonth()+1;
	var days = getDaysInMonth(year,month);
	
	if(type == "curmonth"){
		if(month <10){
			month = "0" + '' + month;
		}
		$(":hidden[name=startDate]").val(year+'-'+month+'-'+'01');
		$(":hidden[name=endDate]").val(year+'-'+month+'-'+days);
		$(":hidden[name=status]").val('');
		
	}else if(type == "premonth"){
		if(month <11){
			month = "0" + '' + (month-1);
		}else{
			month = month-1;
		}
		$(":hidden[name=startDate]").val(year+'-'+month+'-'+'01');
		$(":hidden[name=endDate]").val(year+'-'+month+'-'+''+days);
		$(":hidden[name=status]").val('');
		
	}else if(type == "process"){
		$(":hidden[name=status]").val('In Progress');
		$(":hidden[name=startDate]").val('');
		$(":hidden[name=endDate]").val('');
		
	}else if(type == "finish"){
		$(":hidden[name=status]").val('Completed');
		$(":hidden[name=startDate]").val('');
		$(":hidden[name=endDate]").val('');
		
	}
	
	loadData("taskList","task",div_obj);
}

//选择任务列表中某条任务
function syncOpptyTask(taskId,taskTitle){
	var t = new Date().getTime();
	var a = respTemp.join("");
	$(a).attr("id", "div_resp_" + t).insertBefore("#follow_div");
    $("#div_resp_" + t).css("display","").find("#oppty_attr").append(unescape(taskTitle));

	//控制状态
	statusControl("amountHide");
	createMenu();
	scrollToButtom();
}

//添加任务之前 验证
function valiBefAddTask(){
	var vaForm = $("#taskForm").validate({
		rules:{
			title:"required",
			startdate:"required",
			enddate:"required"
		},
		messages:{
			title:"必填",
			startdate:"请输入开始日期",
			enddate:"请输入结束日期"
		},
		errorPlacement: function(error, element) { 
	     	error.appendTo( element.parent().find(".errorLabel") );  
	    }
	
	});
	if(vaForm.form()){
		return true;
	}
	return false;
}

//添加任务
function addTask(){
	var taskForm = $("#taskForm"), dataObj = [];
	taskForm.find("input").each(function(){
		var n = $(this).attr("name");
		var v = $(this).val();
		dataObj.push({name: n, value: v});
	}).end().find("select").each(function(){
		var n = $(this).attr("name");
		var v = $(this).val();
		dataObj.push({name: n, value: v});
	}).end().find("textarea").each(function(){
		var n = $(this).attr("name");
		var v = $(this).text();
		dataObj.push({name: n, value: v});
	});
	asyncInvoke({
		url: '<%=path%>/schedule/asynsave',
		type: 'post',
		data: dataObj,
	    callBackFunc: function(data){
	    	if(!data) return;
	    	var o = JSON.parse(data);
	    	if(o.errorCode !== '0'){
    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + o.errorCode + "错误描述:" + o.errorMsg);
    		   $(".myMsgBox").delay(2000).fadeOut();
    		   return;
    		}
	    	if(o.rowId){
	    		var title = taskForm.find("input[name=title]").val();
	    		//给隐藏域赋值
	    		updateParent(title);
	    	}
	    }
	});
}

//---------------------添加联系人----------------------------------
function toContact(type){
	if(1 == type){
		
	}else if(2== type){
		$("#oppty_follow").addClass("modal");
		$("#contact-create").removeClass("modal");
		
		//清空输入框
		$("#contactForm").find("input[type=text]").each(function(){
			$(this).val('');
		}).end().find("input[type=number]").each(function(){
			$(this).val('');
		}).end().find("select").each(function(){
			$(this).val('');
		}).end().find("textarea").each(function(){
			$(this).text('');
		});
		hiddenOpeartion();//隐藏数据
	}
}

//添加联系人 之前做验证
function valiBefAddCon(){
	var vaForm = $("#contactForm").validate({
		rules:{
			conname:"required",
			phonemobile:"required",
		},
		messages:{
			conname:"必填",
			phonemobile:"请输入手机号码"
		},
		errorPlacement: function(error, element) { 
	     	error.appendTo( element.parent().find(".errorLabel") );  
	    }
	
	});
	if(vaForm.form()){
		return true;
	}
	return false;
}

//添加联系人
function addContact(){
	var contactForm = $("#contactForm"), dataObj = [];
	contactForm.find("input").each(function(){
		var n = $(this).attr("name");
		var v = $(this).val();
		var t = $(this).attr("type");
		if(t === "radio"){
			if($(this).attr("checked") === "checked"){
				dataObj.push({name: n, value: v});	
			}
		}else{
			dataObj.push({name: n, value: v});	
		}
		
	}).end().find("select").each(function(){
		var n = $(this).attr("name");
		var v = $(this).val();
		dataObj.push({name: n, value: v});
	}).end().find("textarea").each(function(){
		var n = $(this).attr("name");
		var v = $(this).text();
		dataObj.push({name: n, value: v});
	});
	asyncInvoke({
		url: '<%=path%>/contact/asynsave',
		type: 'post',
		data: dataObj,
	    callBackFunc: function(data){
	    	if(!data) return;
	    	var obj  = JSON.parse(data);
	    	if(obj.rowId){
	    		var conname = contactForm.find("input[name=conname]").val();
	    		//修改关联的数据
	    		updateParent(conname);
	    	}
	    }
	});
}

//---------------------成单结束----------------------------------
function succOppty(){
	//隐藏所有操作控件
	hiddenOpeartion();
	
	if(confirm("恭喜您，业务机会阶段将更新为成功结束！")){
		//opptyForm 成单结束
		$("form[name=opptyForm]").find(":hidden[name=salesStage]").val("Closed Won");
		$("form[name=opptyForm]").find(":hidden[name=salesStageName]").val("谈成结束");
		
		//异步调用 更新销售阶段
		smOpptyForm();
	
		//成功跳转
		window.location.href="<%=path%>/oppty/detail?openId=${openId}&publicId=${publicId}&rowId=${rowId}";
	}
}

//---------------------关闭业务机会----------------------------------
function closeOppty(){
	//隐藏所有操作控件
	hiddenOpeartion();
	
	if(confirm("确认要关闭该业务机会吗？")){
		$("input[name=close_desc]").val("");
		//状态控制 
		statusControl("closeOpptyShow"); 
	}
}

//调用后台关闭业务机会
function syncCloseOppty(){
	//opptyForm 关闭业务机会
	var loseDesc = $("input[name='close_desc']").val();//丢单原因
	$("form[name=opptyForm]").find(":hidden[name=loseDesc]").val(loseDesc);
	$("form[name=opptyForm]").find(":hidden[name=salesStage]").val("Closed Lost");
	//异步调用 更新销售阶段
	smOpptyForm();
	//成功跳转
	window.location.href="<%=path%>/oppty/detail?openId=${openId}&publicId=${publicId}&rowId=${rowId}";
}

//公共-> 修改关联内容
function updateParent(title){
	//显示内容
	var t = new Date().getTime();
	var a = respTemp.join("");
	$(a).attr("id", "div_resp_" + t).insertBefore("#follow_div");
	$("#div_resp_" + t).css("display","").find("#oppty_attr").append(title);

}

//公共-> 提交修改业务机会信息数据到后台
function smOpptyForm(){
	var dataObj = [];
	$("form[name=opptyForm]").find("input").each(function(){
		var n = $(this).attr("name");
		var v = $(this).val();
		dataObj.push({name: n, value: v});
	});
	asyncInvoke({
		url: '<%=path%>/oppty/update',
		type: 'post',
		data: dataObj,
	    callBackFunc: function(data){
	    	if(!data) return;
	    	var obj  = JSON.parse(data);
	    	if(obj.errorCode && obj.errorCode !== '0'){
    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
    		   $(".myMsgBox").delay(2000).fadeOut();
	    	}
	    }
	});
}

//公共-> 查询任务列表的方法
function loadData(type, oper, divObj){
	divObj.find("#list_item").html("加载中...");
	if(oper == "task"){
		$("input[name=currpage]").val(1);
		initTaskSearch(divObj);
	}
	
	var currpage = $("input[name=currpage]").val();
	if(currpage == 1){
		divObj.find("#div_prev").css("display",'none');
	}else{
		divObj.find("#div_prev").css("display",'');
		divObj.find("#div_prev").unbind("click");
		divObj.find("#div_prev").bind("click",function(){
			var currpage = $("input[name=currpage]").val();
			$("input[name=currpage]").val(parseInt(currpage) - 1);
			loadData(type,'prev',divObj);
		});
	}
	var pagecount = $("input[name=pagecount]").val();
	
	//查询任务列表
	if(type == "taskList"){
		//
		var startDate = $(":hidden[name=startDate]").val();
		var endDate = $(":hidden[name=endDate]").val();
		var status = $(":hidden[name=status]").val();
		
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/schedule/tasklist' || '',
		      //async: false,
		      data: {openId:'${openId}',crmId: '${crmId}',viewtype: 'myview',currpage:currpage,startDate:startDate,endDate:endDate,status:status,pagecount:pagecount} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	divObj.find("#list_item").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	   return;
	    	    	}
		    	    var val = '';
		    	    if(d == ""){
		    	    	val = "没有找到数据";
		    	    	(divObj.find("#div_next")).css("display",'none');
		    	    }else{
		    	    	if($(d).size() == pagecount){
		    	    		(divObj.find("#div_next")).css("display",'');
		    	    		(divObj.find("#div_next")).unbind("click");
		    	    		(divObj.find("#div_next")).bind("click",function(){
		    	    			var currpage = $("input[name=currpage]").val();
	    	    				$("input[name=currpage]").val(parseInt(currpage) + 1);
	    	    				loadData(type,'prev',divObj);
		    	    		});
	    	    		}else{
	    	    			(divObj.find("#div_next")).css("display",'none');
	    	    		}
						$(d).each(function(i){
							var title = escape(this.title);
							val += '<div><a href="javascript:void(0)" onclick="syncOpptyTask(\''+this.rowid+'\',\''+title+'\')">'+ this.title +'</a></div>';
						});
			    	}
		    	    divObj.find("#list_item").html(val);
		      }
		 });
	}
	
	scrollToButtom();
}

//获得月份中的天数
function getDaysInMonth(year,month){
	var new_date = new Date(year,month,1); //取当年当月中的第一天     
	var date_count =  (new Date(new_date.getTime()-1000*60*60*24)).getDate();//获取当月的天数     
	return date_count;
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

//隐藏所有操作控件
function hiddenOpeartion(){
	$("input[name=oppamount]").val('');
	$("#div_amount_operation").css("display","none");
	$("input[name=bxDateInput]").val('');
	$("#div_date_operation").css("display","none");
	$("input[name=close_desc]").val('');
	$("#div_close_operation").css("display","none");
	$("input[name=opp_stage]").val('');
	$("#div_stage_operation").css("display","none");
	$(".salesStageBar").css("display","none");
}

//控件状态控制 控制控件的显示与隐藏
function statusControl(s){
	if(s === "salesStageHide"){//销售阶段条  salesStageBar
		$(".salesStageBar").css("display","none");//隐藏显示条
	}else if(s === "salesStageShow"){
		$(".salesStageBar").css("display","");
	}else if(s === "closeDateShow"){//显示关闭日期
		$("#div_date_operation").css("display",'');
	}else if(s === "closeDateHide"){//隐藏关闭日期
		$("#div_date_operation").css("display","none");
	}else if(s === "amountHide"){//金额操作区隐藏
		$("#div_amount_operation").css("display","none");
	}else if(s === "amountShow"){//金额操作区显示
		$("#div_amount_operation").css("display","");
	}else if(s === "closeOpptyShow"){//关闭业务机会显示
		$("#div_close_operation").css("display",'');
	}else if(s === "saleStageHide"){//销售阶段隐藏
		$(".salesStageBar").css("display",'none');
	}
}

</script>
</head>

<body>
	<div id="oppty_follow" class="">
		<div id="site-nav" class="navbar">
			${oppname }
		</div>
		<input type="hidden" name="currpage" value="1" />
		<input type="hidden" name="pagecount" value="10"/>
		<!-- 任务查询条件 -->
		<input type="hidden" name="startDate" value="" >
		<input type="hidden" name="endDate" value="" >
		<input type="hidden" name="status" value="" >
		<!-- 修改业务机会 提交表单 -->
		<form name="opptyForm" action="">
		    <!-- rowId crmId -->
			<input type="hidden" name="rowId" value="${rowId}" >
			<input type="hidden" name="crmId" value="${crmId}" >
		    <!-- 业务机会的阶段 -->
			<input type="hidden" name="salesStage" value="${oppstage}" >
			<input type="hidden" name="salesStageName" value="" >
		    <!-- 业务机会的调整关闭日期 -->
			<input type="hidden" name="dateClosed" value="" >
		    <!-- 业务机会的调整金额 -->
			<input type="hidden" name="amount" value="" >
		    <!-- 关闭业务机会 -->
			<input type="hidden" name="loseDesc" value="" >
		</form>
		<div class="site-card-view" style="height:30px;line-height:30px;color:#999999;font-size:14px;text-align:center;">
			￥${amount}元
			&nbsp;&nbsp;&nbsp;${oppstagename }(${oppprobability}%)
			&nbsp;&nbsp;&nbsp;&nbsp;计划于${oppclosedate }关闭
		</div>
		<div id="follow_div"></div>
		<!-- 日期操作 -->
		<div id="div_date_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
				<div style="width: 75%;float:left;margin-top:2px;margin-left:5px;">
					<input name="bxDateInput" id="bxDateInput" value="" style="width:100%" type="text" class="form-control" placeholder="点击选择日期" readonly="">
				</div>
				<div style="width: 20%;float:right;margin-right:5px;margin-top:4px;">
					<a href="javascript:void(0)" onclick="syncOppClosedDate()" class="btn btn-block " style="font-size: 14px;">确&nbsp;&nbsp;&nbsp;认</a>
				</div>
		</div>
		<!-- 金额操作 -->
		<div id="div_amount_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
				<div style="width: 75%;float:left;margin-top:2px;margin-left:5px;">
					<input type="number" name="oppamount" id="oppamount" value="" style="width:100%" type="text" class="form-control" placeholder="输入金额">
				</div>
				<div style="width: 20%;float:right;margin-right:5px;margin-top:4px;">
					<a href="javascript:void(0)" onclick="syncOppAmount()" class="btn btn-block " style="font-size: 14px;">确&nbsp;&nbsp;&nbsp;认</a>
				</div>
		</div>
		<!-- 关闭操作 -->
		<div id="div_close_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
				<div style="width: 75%;float:left;margin-top:2px;margin-left:5px;">
					<input name="close_desc" id="close_desc" value="" style="width:100%" type="text" class="form-control" placeholder="请输入关闭原因">
				</div>
				<div style="width: 20%;float:right;margin-right:5px;margin-top:4px;">
					<a href="javascript:void(0)" onclick="syncCloseOppty()" class="btn btn-block " style="font-size: 14px;">确&nbsp;&nbsp;&nbsp;认</a>
				</div>
		</div>
		
	</div>
	
	<!-- 任务 -->
	<div id="task-create" class="modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary parentGoBak"><i class="icon-back"></i></a>
			新建任务
		</div>
		<div class="wrapper">
			<form id="taskForm" name="taskForm" data-validate="auto" action="<%=path%>/schedule/save" method="post" novalidate="true" >
			    <input type="hidden" name="crmId" value="${crmId}" >
			    <!-- 关联的类别 和  ID 和 名字-->
				<input type="hidden" name="parentType" value="Opportunities" >
				<input type="hidden" name="parentId" value="${rowId}" >
				<input type="hidden" name="parentName" value="${parentName}" >
				<div class="form-group">
					<label class="control-label" for="realname">主题（必填）</label>
					<input name="title" required="" id="title" value="" type="text"
						class="form-control" pattern="^[^&#$%\^!]{1,30}$" placeholder="主题" />
					<div class="help-block errorLabel" style="color:red"></div>
				</div>
				<div class="form-group">
					<label class="control-label" for="startdate">开始日期（格式:1980-01-01）</label>
					<input name="startdate" id="startdate" value="" type="text"
						class="form-control" placeholder="开始日期" readonly="" />
					<div class="help-block errorLabel" style="color:red"></div>
				</div>
				<div class="form-group">
					<label class="control-label" for="enddate">结束日期（格式:1980-01-01）</label>
					<input name="enddate" id="enddate" value="" type="text"
						class="form-control" placeholder="结束日期" readonly="" />
					<div class="help-block errorLabel" style="color:red"></div>
				</div>
				<div class="form-group">
					<label class="" for="status">状态</label>
					<div class="form-control select">
						<div class="select-box"></div>
						<select name="status" id="status">
							<c:forEach var="item" items="${statusDom}">
							    <c:if test="${item.key == 'Not Started'}">
							    	<option value="${item.key}" selected>${item.value}</option>
							    </c:if>
							    <c:if test="${item.key != 'Not Started'}">
							    	<option value="${item.key}">${item.value}</option>
							    </c:if>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="control-label" for="driority">优先级</label>
					<div class="form-control select">
						<div class="select-box"></div>
						<select name="driority" id="driority">
							<c:forEach var="item" items="${priorityDom}">
								<option value="${item.key}">${item.value}</option>
							</c:forEach>
						</select>
					</div>
				</div>				
				<div class="form-group">
					<label class="control-label" for="assigner">责任人</label>
					<input name="assignerId" id="assignerId" value="" type="hidden" class="form-control" >
					<input name="assignerName" id="assignerName" value="" type="text" 
					       class="form-control assignerChoose" placeholder="【点击  选择责任人】  >>  " readonly="readonly" >
				</div>
				<div class="form-group">
					<label class="control-label" for="desc">说明</label>
					<textarea name="desc" style="min-height: 3em" id="desc" rows="4"
						class="form-control" placeholder="日程的一些描述"></textarea>
				</div>
				<div>
					<input type="button" class="btn btn-block tasksubmit" value="创建任务">
				</div>
			</form>
		</div>
	</div>
	
	<!-- 责任人列表DIV -->
	<div id="assigner-more" class="modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary assignerGoBak"><i class="icon-back"></i></a>
			责任人
		</div>
		<div class="page-patch">
			
			<div class="list-group listview listview-header assignerList">
				<c:forEach items="${userList}" var="uitem">
					<a href="javascript:void(0)" class="list-group-item listview-item radio">
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
			</div>
			<div id="phonebook-btn" class="flooter">
				<a class="btn btn-block assignerbtn" style="font-size: 14px">确&nbsp定</a>
			</div>
		</div>
	</div>
	
	<!-- 创建联系人DIV -->
	<div id="contact-create" class="modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary parentConGoBak"><i class="icon-back"></i></a>
			新建联系人
		</div>
		<div class="wrapper">
			<form id="contactForm" name="contactForm" data-validate="auto" action="<%=path%>/schedule/save" method="post" novalidate="true" >
			    <input type="hidden" name="crmId" value="${crmId}" >
			    <!-- 关联的类别 和  ID 和 名字-->
				<input type="hidden" name="parentType" value="Opportunities" >
				<input type="hidden" name="parentId" value="${crmId}" >
				<input type="hidden" name="parentName" value="${parentName}" >
				<div class="form-group">
					<label class="control-label" for="label_name">姓名（必填）</label>
					<input name="conname" required="" id="conname" value="" type="text"
						class="" pattern="^[^&#$%\^!]{1,30}$" placeholder="姓名" maxlength="30" style="min-width:150px;"/>
					&nbsp;&nbsp;
					<input name="salutation" id="salutation" required="required" value="Mr." type="radio" checked="checked">先生
					&nbsp;&nbsp;
					<input name="salutation" id="salutation" required="required" value="Ms." type="radio" >女士
					<div class="help-block errorLabel" style="color:red"></div>
				</div>
				<div class="form-group">
					<label class="control-label" for="label_mobile">手机号码</label>
					<input name="phonemobile" id="phonemobile" value="" type="number"
						class="form-control" pattern="^[^&#$%\^!]{1,30}$" placeholder="手机号码" />
					<div class="help-block errorLabel" style="color:red"></div>
				</div>
				<div class="form-group">
					<label class="control-label" for="label_office_phone">办公电话</label>
					<input name="phonework" id="phonework" value="" type="text"
						class="form-control" pattern="^[^&#$%\^!]{1,30}$" placeholder="办公电话" />
					<div class="help-block unvalid">姓名必须是30个字符以内不包括&#$%^!等特殊字符</div>
				</div>
				<div class="form-group">
					<label class="control-label" for="label_email">邮箱</label>
					<input name="email0" id="email0" value="" type="text"
						class="form-control" pattern="^[^&#$%\^!]{1,30}$" placeholder="邮箱" />
					<div class="help-block unvalid">姓名必须是30个字符以内不包括&#$%^!等特殊字符</div>
				</div>
				<div class="form-group">
					<label class="control-label" for="label_job">职称</label>
					<input name="conjob" id="conjob" value="" type="text"
						class="form-control" pattern="^[^&#$%\^!]{1,30}$" placeholder="职称" />
					<div class="help-block unvalid">职称必须是30个字符以内不包括&#$%^!等特殊字符</div>
				</div>
				<div class="form-group">
					<label class="control-label" for="label_addr">地址</label>
					<input name="conaddress" id="conaddress" value="" type="text"
						class="form-control" pattern="^[^&#$%\^!]{1,100}$" placeholder="地址" />
					<div class="help-block unvalid">请输入100个字符以内</div>
				</div>
				<div>
					<input type="button" class="btn btn-block contactsubmit" value="创建联系人">
				</div>
			</form>
		</div>
	</div>
	
	<div style="clear:both"></div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<!--脚页面  -->
	<jsp:include page="/common/footer.jsp"></jsp:include>
	<!-- 销售阶段选择 -->
    <div style="font-size:15px;color: #99CCFF;display:none" class="screenbg salesStageBar">
		<div style="float:left;padding-left: 3px;padding-top: 20px;">阶段：<span style="color:red">销售前景</span></div>
		<div style="float:left;padding-left: 3px;padding-top: 20px;">--<span style="color:red" class="stepTickShowSp" > 销售前景</span></div>
		<div style="float:right;margin: 5px 0;">
			<a class="mini-button notlog stepSave" style="height:33px;line-height: 33px;" target="_brack" href="javascript:void(0)">确定</a>
		</div>
	</div>
	<div class="salesStageDivBotom" style="display:none;z-index: 99998;position: fixed;background-color: #red;width: 100%;height: 100%;top: 0;left: 0;background-color: rgba(173, 173, 170, 0.86);"></div>
	<!-- 销售阶段数据 -->
	<div class="salesStageDiv" 
	     style="display:none;border: 1px solid rgb(224, 231, 230);position: fixed;color: #106c8e;top: 10px;width: 250px;left: 30px;text-align: center; padding: 5px 5px 5px 5px;background-color: rgb(238, 238, 238);z-index: 99999;font-size: 14px">
	    <div class="cannel" style="border-bottom:1px solid #EEEEEE;">
			<div style="float:left;padding-left:10px;height:35px;line-height:35px">请选择阶段:</div>
			<div id="analytics_close" style="float:right;padding:2px;cursor:pointer;"><img src="<%=path%>/image/del_icon.png"></div>
		</div>
		<div style="clear:both;"></div>
		<c:forEach var="item" items="${salesStageList}">
			<div key="${item.key}" style="cursor: pointer;border-bottom: 1px solid #EEEEEE;background-color: #FFF;padding: 7px 20px 7px 20px;">${item.value}</div>
	    </c:forEach>
	</div>
</body>
</html>