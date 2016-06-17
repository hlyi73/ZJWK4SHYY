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
<script>
$(function () {
	initDatePicker();
	initDate();
});

function initDate()   
{   
	var today = new Date();   
	var day = today.getDate();   
	var month = today.getMonth() + 1; 
	if(month < 10){
		month = '0' + month;
	}
	var year = today.getFullYear();
	var date = year + "-" + month + "-" + day;   
	$("input[name=bxDateInput]").val(date);
} 

//初始化日期控件
function initDatePicker(){
	var opt = {
		date : {preset : 'date'},
		datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2014,7,30,15,44), stepMinute: 5  },
		time : {preset : 'time'},
		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
		image_text : {preset : 'list', labels: ['Cars']},
		select : {preset : 'select'}
	};
	//类型 date  datetime
	$('#bxDateInput').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
}

//类型
function expenseSelect(id,val){
	$("input[name=expensesubtype]").val(id);
	$("input[name=expensesubtypeName]").val(val);
	$("#expense_subtype").html(val);
	$("#div_expense_subtype").css("display",'');
	$("#div_expense_date_label").css("display",'');
	if($("input[name=expensedate]").val() == ""){
		$('#div_date_operation').css("display",'');
	}
	displayMsg();
}
//日期
function expenseDate(){
	$("input[name=expensedate]").val($("input[name=bxDateInput]").val());
	$("#div_expense_date").css("display","");
	$("#expense_date").html($("input[name=bxDateInput]").val());
	$('#div_date_operation').css("display",'none');
	$("#div_expense_amount_label").css("display","");
	$('#div_amount_operation').css("display",'');
	displayMsg();
}

//金额
function expenseAmount(){
	if($("input[name=input_amount]").val() == "" || !validate($("input[name=input_amount]").val())){
		$("input[name=input_amount]").val('');
		$("input[name=input_amount]").attr('placeholder','请输入正确的金额！');
		return;
	}
	$("input[name=expenseamount]").val($("input[name=input_amount]").val());
	$("#div_expense_amount").css("display","");
	$("#expense_amount").html($("input[name=input_amount]").val());
	$('#div_amount_operation').css("display",'none');
	
	//获取审批人
	expenseAsigner("first");
	
	displayMsg();	
}


//相关
function expenseReleation(type,oper){
	$("#div_expense_parent_list").css("display",'');
	$("#expense_parent_list").html("加载中...");
	if(oper == "new"){
		$("input[name=currpage]").val(1);
		//查询模块的首字母
		searchFristCharts(type);
		initTaskSearch();
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

		var parenttype = "Opportunities";
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/oppty/list' || '',
		      //async: false,
		      data: {crmId: '${crmId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = '';
		    	    var d = JSON.parse(data);
					if(d == ""){
		    	    	val = "没有找到数据";
		    	    	$("#div_next").css("display",'none');
		    	    }else{
		    	    		if($(d).size() == pagecount){
		    	    			$("#div_next").css("display",'');
		    	    		}else{
		    	    			$("#div_next").css("display",'none');
		    	    		}
							$(d).each(function(i){
								val += '<div><a href="javascript:void(0)" onclick=expenseParentSel(\''+parenttype+'\',\''+this.rowid+'\',\''+this.name+'\')>'+ this.name +'</a></div>';
							});
		    	    }
					$("#expense_parent_list").html(val);
					displayMsg();
		      }
		 });
		 $("input[name=parenttype]").val(parenttype);
	}else if(type == "accntList"){
		
		var parenttype = "Accounts";
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/customer/list' || '',
		      //async: false,
		      data: {crmId: '${crmId}',viewtype: 'myallview',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = '';
		    	    var d = JSON.parse(data);
		    	    if(d == ""){
		    	    	val = "没有找到数据";
		    	    	$("#div_next").css("display",'none');
		    	    }else if(d.errorCode && d.errorCode != '0'){
		    	    	$("#expense_parent_list").html(d.errorMsg);
		    	    	return;
		    	    }else{
			    	    	if($(d).size() == pagecount){
		    	    			$("#div_next").css("display",'');
		    	    		}else{
		    	    			$("#div_next").css("display",'none');
		    	    		}
							$(d).each(function(i){
								val += '<div><a href="javascript:void(0)" onclick=expenseParentSel(\''+parenttype+'\',\''+this.rowid+'\',\''+this.name+'\')>'+ this.name +'</a></div>';
							});
			    	}
					$("#expense_parent_list").html(val);
					displayMsg();
		      }
		 });
		$("input[name=parenttype]").val(parenttype);
	}else if(type == "taskList"){
		//
		var startDate = $(":hidden[name=startDate]").val();
		var endDate = $(":hidden[name=endDate]").val();
		var status = $(":hidden[name=status]").val();
		var parenttype = "Tasks";
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/schedule/tasklist' || '',
		      //async: false,
		      data: {openId:'${openId}',crmId: '${crmId}',viewtype: 'myview',currpage:currpage,startDate:startDate,endDate:endDate,status:status,pagecount:pagecount} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	$("#expense_parent_list").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	   return;
	    	    	}
		    	    var val = '';
		    	    if(d == ""){
		    	    	val = "没有找到数据";
		    	    	$("#div_next").css("display",'none');
		    	    }else{
		    	    	if($(d).size() == pagecount){
	    	    			$("#div_next").css("display",'');
	    	    		}else{
	    	    			$("#div_next").css("display",'none');
	    	    		}
						$(d).each(function(i){
							var title = escape(this.title);
							val += '<div><a href="javascript:void(0)" onclick=expenseParentSel(\''+parenttype+'\',\''+this.rowid+'\',\''+title+'\')>'+ this.title +'</a></div>';
						});
			    	}
					$("#expense_parent_list").html(val);
					displayMsg();
		      }
		 });
		$("input[name=parenttype]").val(parenttype);
	}
	
}

//任务查询
function initTaskSearch(){
	$("#fristChartsList").empty();
	var ahtml = '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'curmonth\')">当月任务</a>';
	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'premonth\')">上月任务</a>';
	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'process\')">进行中的任务</a>';
	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'finish\')">已结束的任务</a>';
	$("#fristChartsList").html(ahtml);
}

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
	
	expenseReleation("taskList","task");
}

function getDaysInMonth(year,month){
	var new_date = new Date(year,month,1); //取当年当月中的第一天     
	var date_count =  (new Date(new_date.getTime()-1000*60*60*24)).getDate();//获取当月的天数     
	return date_count;
}

//查询模块的首字母
function searchFristCharts(type){
	$("#fristChartsList").empty();
	$(":hidden[name=firstchar]").val('');
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/fchart/list',
	      data: {crmId: '${crmId}',type: type},
	      dataType: 'text',
	      success: function(data){
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
	 });
}

//点击首字母事件
function chooseFristCharts(obj){
	$(":hidden[name=firstchar]").val($(obj).html());
	var parenttype =$("input[name=parenttype]").val();
	if(parenttype == "Accounts"){
		expenseReleation("accntList","CHAR");
	}else if(parenttype == "Opportunities"){
		expenseReleation("opptyList","CHAR");
	}else if(parenttype == "Tasks"){
		expenseReleation("taskList","CHAR");
	}
}

//相关
function expenseParentSel(type,id,value){
	value = unescape(value);
	$("input[name=parenttype]").val(type);
	$("input[name=parentid]").val(id);
	$("input[name=parentidName]").val(value);
	
	$("#div_expense_parent").css("display",'');
	$("#expense_parent").html(value);
	
	$("#div_expense_type").css("display",'');
	
}

//查询责任人
function expenseAsigner(type){

	if(type == "first"){
		$("input[name=currpage]").val(1);
	}
	
	var currpage = $("input[name=currpage]").val();
	var pagecount = $("input[name=pagecount]").val();
	if(currpage == 1){
		$("#div_prev_assigner").css("display",'none');
	}else{
		$("#div_prev_assigner").css("display",'');
	}
	
	//审批人
	$("#div_expense_assigner_label").css("display","");
	
	$.ajax({
	      type: 'get',
	      url: '<%=path%>/lovuser/userlist',
	      data: {crmId: '${crmId}', viewtype: 'myallview', currpage:currpage,pagecount:pagecount},
	      dataType: 'text',
	      success: function(data){
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	$("#expense_assigner_list")html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	    	   return;
    	    	}
	    	    var val = '';
	    	    if(d == ""){
	    	    	val = "没有找到数据";
	    	    	$("#div_next_assigner").css("display",'none');
	    	    }else{
	    	    	if($(d).size() == pagecount){
    	    			$("#div_next_assigner").css("display",'');
    	    		}else{
    	    			$("#div_next_assigner").css("display",'none');
    	    		}
					$(d).each(function(i){
						val += '<div><a href="javascript:void(0)" onclick=expenseAssignerSel(\''+this.userid+'\',\''+this.username+'\')>'+ this.username +'</a></div>';
					});
		    	}
				$("#expense_assigner_list").html(val);
	      }
	 });
}

//选择责任人事件
function expenseAssignerSel(id,value){
	$(":hidden[name=approvalid]").val(id);
	$("#expense_assigner").html(value);
	$("#div_expense_assigner").css("display",'');
	
	$("#div_expense_message").css("display",'');
	$("#div_expense_message_operation").css("display",'');
}

//跳过审批 责任人
function skipAsigner(){
	$("#div_expense_message").css("display",'');
	$("#div_expense_message_operation").css("display",'');
	
	$(":hidden[name=approvalid]").val('');
	$("#expense_assigner").html("您未选择审批人,可以下一次再提交");
	$("#div_expense_assigner").css("display",'');
}

function displayMsg(){
	var type = $("input[name=parenttype]").val();
	var msg = "";
	if(type == "Opportunities"){
		msg = "您于<span style='color:blue;'>"+$("input[name=expensedate]").val()+"</span>，在跟进业务机会【<span style='color:blue;'>"
		+$("input[name=parentidName]").val()+"</span>】过程中产生了一笔<span style='color:blue;'>"+$("input[name=expensesubtypeName]").val()
		+"</span>（<span style='color:red;'>￥"+$("input[name=expenseamount]").val()+"</span>）申请报销，请点击【提交】按钮完成操作。";
	}else if(type == "Accounts"){
		msg = "您于<span style='color:blue;'>"+$("input[name=expensedate]").val()+"</span>，在跟进企业【<span style='color:blue;'>"
		+$("input[name=parentidName]").val()+"</span>】过程中产生了一笔<span style='color:blue;'>"+$("input[name=expensesubtypeName]").val()
		+"</span>（<span style='color:red;'>￥"+$("input[name=expenseamount]").val()+"</span>）申请报销，请点击【提交】按钮完成操作。";
	}else if(type == "Tasks"){
		msg = "您于<span style='color:blue;'>"+$("input[name=expensedate]").val()+"</span>，在处理任务【<span style='color:blue;'>"
		+$("input[name=parentidName]").val()+"</span>】时产生了一笔<span style='color:blue;'>"+$("input[name=expensesubtypeName]").val()
		+"</span>（<span style='color:red;'>￥"+$("input[name=expenseamount]").val()+"</span>）申请报销，请点击【提交】按钮完成操作。";
	}
	$("#expense_message").html(msg);
}

//提交
function commitExpense(){
	var val = $(":hidden[name=approvalid]").val();
	if(val !== ""){
		$(":hidden[name=commitid]").val('${crmId}');
		$(":hidden[name=approvalname]").val($("#expense_assigner").html());
		$(":hidden[name=approvalstatus]").val('approving');
	}
	
	$("input[name=description]").val($("input[name=expense_description]").val());
	$("form[name=bxForm]").submit();
}

function topage(type){
	var parenttype =$("input[name=parenttype]").val();
	var currpage = $("input[name=currpage]").val();
	if(type == "prev"){
		$("input[name=currpage]").val(parseInt(currpage) - 1);
	}else if(type == "next"){
		$("input[name=currpage]").val(parseInt(currpage) + 1);
	}

	if(parenttype == "Accounts"){
		expenseReleation("accntList","XXX");
	}else if(parenttype == "Opportunities"){
		expenseReleation("opptyList","XXX");
	}else if(parenttype == "Tasks"){
		expenseReleation("taskList","XXX");
	}
}

function topageAssign(type){
	var currpage = $("input[name=currpage]").val();
	if(type == "prev"){
		$("input[name=currpage]").val(parseInt(currpage) - 1);
	}else if(type == "next"){
		$("input[name=currpage]").val(parseInt(currpage) + 1);
	}
	expenseAsigner("XXX");
	
}

//验证正数
function validate(num)
{
  var reg = /^\d+(?=\.{0,1}\d+$|$)/;
  if(reg.test(num)) return true;
  return false ;  
}
</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="expense-create">
		<div id="site-nav" class="navbar">
			<div class="act-secondary" data-toggle="navbar"
				data-target="nav-collapse">
<!-- 				<i class="icon-menu"><b></b></i> -->
			</div>
			费用报销
		</div>
		<!-- 报销流程内容 -->
		<div class="site-card-view bxFlowContent">
			<!-- 提交报销数据的表单 -->
			<form name="bxForm" action="<%=path%>/expense/save" method="post">
				<input type="hidden" name="crmId" value="${crmId}" /> 
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="currpage" value="1" />
				<input type="hidden" name="pagecount" value="10"/>
				<!-- operType-->
				<input type="hidden" name="operType" value="add">
				<input type="hidden" name="type" value="add">
				<!-- add expense form data -->
				<input type="hidden" name="expensetype" value="sales"> 
				<input type="hidden" name="expensesubtype" value=""> 
				<input type="hidden" name="expensesubtypeName" value=""> 
				<input type="hidden" name="expensedate" value=""> 
				<input type="hidden" name="expenseamount" value=""> 
				<!-- 类型   三个值  Accounts Opportunities Tasks -->
				<input type="hidden" name="parenttype" value="" >
				<!-- 类型的ID -->
				<input type="hidden" name="parentid" value="" >
				<input type="hidden" name="parentidName" value="" >
				<input type="hidden" name="description" value="" >
				<!-- 按照字母查询 -->
				<input type="hidden" name="firstchar" value="" >
				<!-- 审批字段 -->
				<input type="hidden" name="commitid" value="" ><!-- 提交人ID -->
				<input type="hidden" name="commitname" value="" ><!-- 提交人名字 -->
				<input type="hidden" name="approvalid" value="" ><!-- 提交给谁 -->
				<input type="hidden" name="approvalname" value="" ><!-- 提交给谁的名字 -->
				<input type="hidden" name="approvalstatus" value="" ><!-- 提交的状态 new approving待审批 approved已批准 reject驳回-->
				<input type="hidden" name="approvaldesc" value="" ><!-- 审批的意见 -->
				<input type="hidden" name="recordid" value="${rowId}" ><!-- 费用记录ID-->
				<!-- 任务查询条件 -->
				<input type="hidden" name="startDate" value="" >
				<input type="hidden" name="endDate" value="" >
				<input type="hidden" name="status" value="" >
			</form>

		</div>
		
		<!-- 花到哪去了？ -->
		<div id="div_parent_label" class="chatItem you" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									您做了什么事情呢?【1/5】<br> <br>
									<a href="javascript:void(0)" onclick="expenseReleation('taskList','new')">处理任务</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onclick="expenseReleation('opptyList','new')">跟进业务机会 </a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onclick="expenseReleation('accntList','new')">跟进企业 </a>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 花到哪去了列表 -->
		<div id="div_expense_parent_list" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>//scripts//plugin//wb//css//images//dc.png">
				<div class="cloud cloudText" >
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="width:100%;text-align:left;margin-bottom:3px;">
									请选择：
								</div>
								<!-- 字母区域 -->
								<div id="fristChartsList" style="word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';display:'';border-bottom:solid 1px #CCCCCC;margin-bottom:5px;">
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_prev" >
									<a href="javascript:void(0)" onclick="topage('prev')"><img src="<%=path%>//image/prevpage.png" width="32px"/></a>
								</div>
								<div id="expense_parent_list" style="word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;">
									
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_next">
									<a href="javascript:void(0)" onclick="topage('next')"><img src="<%=path%>//image/nextpage.png" width="32px"/></a>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 花到哪去了--回复 -->
		<div id="div_expense_parent" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="expense_parent" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 报销类型 -->
		<div id="div_expense_type" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>//scripts//plugin//wb//css//images//dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">您报销什么费用呢?【2/5】</div>
									<c:forEach var="item" items="${expenseSubTypeList}" varStatus="status">
										<a href="javascript:void(0)" onclick="expenseSelect('${item.key}','${item.value}')">${item.value}</a>
									</c:forEach>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 报销类型回复 -->
		<div id="div_expense_subtype" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel" >
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="expense_subtype" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 哪天产生的费用 -->
		<div id="div_expense_date_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">哪天发生的?【3/5】</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 日期回复 -->
		<div id="div_expense_date" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="expense_date" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 花了多少钱 -->
		<div id="div_expense_amount_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">费用金额是多少?【4/5】</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 多少钱回复 -->
		<div id="div_expense_amount" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="expense_amount" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 提交审批的责任人-->
		<div id="div_expense_assigner_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="width:100%;text-align:left;margin-bottom:3px;">
									请选择审批责任人?【5/5】&nbsp;&nbsp;<a href="javascript:void(0)" onclick="skipAsigner()">跳过</a>
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_prev_assigner" >
									<a href="javascript:void(0)" onclick="topageAssign('prev')"><img src="<%=path%>//image/prevpage.png" width="32px"/></a>
								</div>
								<div id="expense_assigner_list" style="word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;">
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_next_assigner">
									<a href="javascript:void(0)" onclick="topageAssign('next')"><img src="<%=path%>//image/nextpage.png" width="32px"/></a>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 审批的责任人回复 -->
		<div id="div_expense_assigner" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="expense_assigner" style="word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:30px;">
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 汇总 -->
		<div id="div_expense_message" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>//scripts//plugin//wb//css//images//dc.png">
				<div class="cloud cloudText" >
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div id="expense_message" style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<div id="div_date_operation" style="display:none;margin-top:5px;">
			<div style="width: 75%;float:left;margin-top:2px;margin-left:5px;">
				<input name="bxDateInput" id="bxDateInput" value="" style="width:100%" type="text" class="form-control" placeholder="点击选择日期" readonly="">
			</div>
			<div style="width: 20%;float:right;margin-right:5px;">
				<a href="javascript:void(0)" onclick="expenseDate()" class="btn btn-block bxDateInputBtn" style="font-size: 14px;">确&nbsp;&nbsp;&nbsp;认</a>
			</div>
		</div>
		<div id="div_amount_operation" style="display:none;margin-top:5px;">
			<div style="width: 75%;float:left;margin-top:2px;margin-left:5px;">
				<input name="input_amount" id="input_amount" value="" style="width:100%" type="text" class="form-control" placeholder="输入金额">
			</div>
			<div style="width: 20%;float:right;margin-right:5px;">
				<a href="javascript:void(0)" onclick="expenseAmount()" class="btn btn-block bxDateInputBtn" style="font-size: 14px;">确&nbsp;&nbsp;&nbsp;认</a>
			</div>
		</div>
		<div id="div_expense_message_operation" style="display:none;margin-top:5px;text-align:center;">
			<div style="width: 96%;margin:10px;">
				<textarea name="expense_description" id="expense_description" style="width:100%" rows = "3"  placeholder="补充说明，可选" class="form-control"></textarea>
			</div>
			<div style="width: 100%;">
				<a href="javascript:void(0)" onclick="commitExpense()" class="btn btn-block bxDateInputBtn" style="font-size: 16px;margin-left:10px;margin-right:10px;">提&nbsp;&nbsp;&nbsp;交</a>
			</div>
		</div>
	</div>
	<div style="clear:both;"></div>
	<!--脚页面  -->
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>