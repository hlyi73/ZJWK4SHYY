<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
	initSystemForm();
	initSystemFriChar();
	initSystemData();
	initRela();	
	cacheExpSubTpeData();//缓存子类型的所有数据
	initDatePicker();
	initDate();
	initUserCheck();//初始化提交用户
	initSkipParent();
	removeGoTop();
	loadTaskForm();//新增任务初始化form
	
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
	      data: {flag:'approve',openId:'${openId}',publicId:'${publicId}',crmId: '${crmId}',type: type,orgId:'${orgId}'},
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
	      data: {flag:'approve',openId:'${openId}',publicId:'${publicId}',crmId: '${crmId}',orgId:'${orgId}',viewtype: 'teamview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
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
// 						if(this.userid!='${crmId}'){
						val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
							+  '<div class="list-group-item-bd"><input type="hidden" name="userId" value="'+this.userid+'"/>'
							+  '<input type="hidden" name="userName" value="'+this.username+'"/>'
							+  '<input type="hidden" name="email" value="'+this.email+'"/>'
							+  '<h2 class="title assName">'+this.username+'</h2><p>职称：'+this.title+'</p><p>部门：<b>'+this.department+'</b>'
							+  '</p></div><div class="input-radio" title="选择该条记录"></div></a>';
// 						}
						});
					systemObj.chartlist.css("display",'');
		    	}
	    	    systemObj.assignerlist.html(val);
	    	    initUserCheck();
	      }
	 });
}

//从指尖活动页面进来
function initRela(){
	if('Campaigns'=='${parentType}' || 'Activity'=='${parentType}'){
		$("#div_parent_label").css("display","none");
		$("#div_expense_parent").css("display","");
		$("#expense_parent").html('${parentName}');
		//日期
		$("#div_expense_date_label").css("display",'');
		if($("input[name=expensedate]").val() == ""){
			$('#div_date_operation').css("display",'');
		}
		$(":hidden[name=parenttype]").val('${parentType}');
		$(":hidden[name=parentid]").val('${parentId}');
		$(":hidden[name=parentidName]").val('${parentName}');
	}
}

function initDate(){   
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
	//过滤子类别的数据
	//filterSubTyeData();
} 

//过滤子类别的数据
function filterSubTyeData(t,cname,type){
	
	if(!t) t === "销售";

	//初始化缓存数据到  子类型面板
	var ec ="";

	ec = $(cname).find(".expSubTyeContainer");
	ec.empty();
	$.each(cache, function(){
	    if(this.type === t){
	    	var htm = '<a href="javascript:void(0)" ';
	    	if(type=='main'){
				htm += '      onclick="expenseSelect(\''+ this.key +'\',\''+ this.val +'\')" '; 
	    	}
			htm += '         atrId="'+ this.key +'">'+ this.val +'</a>';
			ec.append(htm);
		}else if((this.type == 'Public' && t != '实施') || this.type == 'ALL'){
			var htm = '<a href="javascript:void(0)" ';
			if(type=='main'){
				htm += '      onclick="expenseSelect(\''+ this.key +'\',\''+ this.val +'\')" '; 
			}
			htm += '         atrId="'+ this.key +'">'+ this.val +'</a>';
			ec.append(htm);
		}
	});
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
	//初始化任务日期控件
	$('#taskstartdate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	$('#taskenddate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	
}

function removeGoTop(){
	$(".goTop").remove();
	$("._menu").remove();
}

//初始化表单按钮和控件
function loadTaskForm(){
	//任务相关的选择 
	$(".taskParCho").click(function(){
		$("#task-create").addClass("modal");
		$("#parent-more").removeClass("modal");
		
		var v = $("#taskParentType").val();
		if(v === "Accounts"){
			$(".opptyList").addClass("modal");
			$(".customerList").removeClass("modal");
		}else if(v === "Opportunities"){
			$(".customerList").addClass("modal");
			$(".opptyList").removeClass("modal");
		}
	});
	//相关退回
	$(".parentGoBak").click(function(){
		$("#task-create").removeClass("modal");
		$("#parent-more").addClass("modal");
	});
	
	//任务退回
	$(".taskGoBak").click(function(){
		$("#task-create").addClass("modal");
		$("#expense-create").removeClass("modal");
		initSchedulePage();
	});
	
	//审批责任人退回
	$(".assignerGoBak").click(function(){
		$(".userList").css("display", "none");
		$("#expense-create").css("display", "");
		scrollToButtom($("#expense-create"));
	});
	
	//勾选某个 客户 的超链接
	$(".customerList > a").click(function(){
		$(".customerList > a").removeClass("checked");
		$("#taskparentId").val($(this).find(":hidden[name=customerId]").val());
		$("#taskparentName").val($(this).find(":hidden[name=customerName]").val());
		$(this).addClass("checked");
		$("#task-create").removeClass("modal");
		$("#parent-more").addClass("modal");
		return false;
	});
	//勾选某个 业务机会  的超链接
	$(".opptyListSub > a").click(function(){
		$(".opptyListSub > a").removeClass("checked");
		$("#taskparentId").val($(this).find(":hidden[name=opptyId]").val());
		$("#taskparentName").val($(this).find(":hidden[name=opptyName]").val());
		$(this).addClass("checked");
		$("#task-create").removeClass("modal");
		$("#parent-more").addClass("modal");
		return false;
	});
	$(".createTaskContainer select[name=parentType]").change(function(){
		$("#taskparentId").val("");
		$("#taskparentName").val("");
	});
	//取消任务
	$(".createTaskContainer .taskcannel").click(function(){
		//显示与隐藏数据层
		$("#task-create").addClass("modal");
		$("#expense-create").removeClass("modal");
		return false;
	});
}

//创建新的任务
function confirmSchedule(){
	var form=$("form[name=taskForm]");
	var dataObj = [];
	form.find("input").each(function(){
		var n = $(this).attr("name");
		var v = $(this).val();
		dataObj.push({name: n, value: v});					
	});
	asyncInvoke({
		url: '<%=path%>/schedule/asynsave',
		type: 'post',
		data: dataObj,
	    callBackFunc: function(data){
	    	if(!data) return;
 	    	var o  = JSON.parse(data);
	    	if(o.errorCode !== '0'){
    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + o.errorCode + "错误描述:" + o.errorMsg);
    		   $(".myMsgBox").delay(2000).fadeOut();
    		   return;
    		}
	    	if(o.rowId){
	    		var title = $(".createTaskContainer input[name=title]").val();
	    		$("#div_expense_parent").css("display","");
	    		$("#expense_parent").html(title);
	    		//给隐藏域赋值
	    		$(":hidden[name=parentid]").val(o.rowId);
	    		$(":hidden[name=parentidName]").val(title);
	    		//显示与隐藏数据层
	    		$("#task-create").addClass("modal");
	    		$("#expense-create").removeClass("modal");
	    		//日期
	    		$("#div_expense_date_label").css("display",'');
	    		if($("input[name=expensedate]").val() == ""){
	    			$('#div_date_operation').css("display",'');
	    		}
	    	}
	    	initSchedulePage();
	    }
	});
}

//缓存 子类型数据 
var cache = [];
function cacheExpSubTpeData(){
	var arr = $(".subTypeCache input");
	arr.each(function(i){
		var t = this.value;
		var tarr = t.split("_");
		cache.push({key: this.lang, type: tarr[0], val: tarr[1] });
	});
}

//子类型
function expenseSelect(id,val){
	currTime = null;
	$("#expensesubtype").val(id);
	$("#expensesubtypeName").val(val);
	//组合费用类别和费用金额
	var t = "<span style='color:blue'>" + $("#expensetypeName").val() + "</span>";
	var t1 = "<span style='color:blue'>" + $("#expensesubtypeName").val() + "</span>";
	var t2 = "￥" + "<span style='color:blue'>" + $("#expenseamount").val() + "</span>";
	$("#expense_subtype").html(t +'-'+ t1 +':'+ t2);
	//报销类型
	$("#div_expense_subtype").css("display",'');
	//报销金额
	$('#div_amount_operation').css("display",''); 
	$("input[name=input_amount]").attr('placeholder','输入金额！');
	$('#div_expense_message_operation').css("display",'none'); 
	
	displayMsg();
}

//大类型
function expenseTypeSelect(id,val){
	currTime = null;
	$("#expensetype").val(id);
	$("#expensetypeName").val(val);
	
	//过滤数据
	filterSubTyeData(val,'#div_expense_type','main');
	//组合费用类别和费用金额
	var t = "<span style='color:blue'>" + $("#expensetypeName").val() + "</span>";
	var t1 = "<span style='color:blue'>" + $("#expensesubtypeName").val() + "</span>";
	var t2 = "￥" + "<span style='color:blue'>" + $("#expenseamount").val() + "</span>";
	$("#expense_subtype").html(t + '--' + t1 + '' + t2);
	//报销类型
	$("#div_expense_subtype").css("display",'');
	$('#div_expense_message_operation').css("display",'none'); 
	
	displayMsg();
}

//费用部门选择
function expDeptSelect(id,val){
	currTime = null;
	$("#depart").val(id);
	$("#departName").val(val);
	//组合费用类别和费用金额
	var t2 = $("#departName").val();
	$("#div_expense_deptResp").css("display","");
	$("#expense_deptResp").html(t2);
	
	//费用对象
	$("#div_expense_users").css("display","");
	//显示
	displayMsg();
}

//选择费用对象
function chooseExpUsers(type){
	if(type == "me"){
		$("#expense_usersResp").html("${assigner}");
		$(":hidden[name=expUserName]").val("${assigner}");
		$(".expUsersRespDiv").css("display","");
		//费用类型和金额
		$("#div_expense_type").css("display","");
		$("#div_expusers_operation").css("display","none");
		//显示
		displayMsg();
	}else if(type=="other"){
		$("input[name=input_users]").val('');
		$("#div_expusers_operation").css("display","");
	}
}
//其他费用对象
function chooseExpOthers(){
	var inputusr = $("input[name=input_users]").val();
	if(inputusr == ""){
		$("input[name=input_users]").val('');
		$("input[name=input_users]").attr('placeholder','请输入请费用对象！');
		return;
	}
	$("#expense_usersResp").html(inputusr);
	$(":hidden[name=expUserName]").val(inputusr);
	$(".expUsersRespDiv").css("display","");
	$("#div_expusers_operation").css("display","none");
	//费用类型和金额
	$("#div_expense_type").css("display","");
	//显示
	displayMsg();
}

//日期
function expenseDate(){
	$("input[name=expensedate]").val($("input[name=bxDateInput]").val());
	$("#div_expense_date").css("display","");
	$("#expense_date").html($("input[name=bxDateInput]").val());
	$('#div_date_operation').css("display",'none');
	//报销费用部门
	$("#div_expense_depart").css("display","");
	displayMsg();
	scrollToButtom();//滚动到底部
}

//金额
function expenseAmount(){
	if($("input[name=input_amount]").val() == ""||!validateAmt($("input[name=input_amount]").val())||$("input[name=input_amount]").val().length>10){
		$("input[name=input_amount]").val('');
		$("input[name=input_amount]").attr('placeholder','请输入正确的金额！');
		return;
	}
	var o, t ,t1, t2 ;
	if(!currTime){
		$("#expenseamount").val($("input[name=input_amount]").val());
		//组合费用类别和费用金额
		t1 = "<span style='color:blue'>" + $("#expensetypeName").val() + "</span>";
		t =  "<span style='color:blue'>" + $("#expensesubtypeName").val() + "</span>";
		t2 = " ￥" + "<span style='color:blue'>" + $("#expenseamount").val() + "</span>";
		o = "#div_expense_subtype";
	}else{
		$("#expenseamount_"+ currTime).val($("input[name=input_amount]").val());
		//组合费用类别和费用金额
		t1 = "<span style='color:blue'>" + $("#expensetypeName_"+ currTime).val() + "</span>";
		t =  "<span style='color:blue'>" + $("#expensesubtypeName_"+ currTime).val() + "</span>";
		t2 = " ￥" + "<span style='color:blue'>" + $("#expenseamount_"+ currTime).val() + "</span>";
		o = "#div_expense_subtype_" + currTime;
	}
	$(o).find("#expense_subtype").html(t1 +'-'+t +':'+ t2);
	
	$("#div_expense_message").css("display",'');
	$('#div_amount_operation').css("display",'none');
	$('#div_expense_message_operation').css("display",''); 
	$("input[name=input_amount]").val('');//情空输入框
	//可以再次添加一条报销
	$(".addExpType").removeAttr("disabled");
	//显示费用部门
	$("#div_expense_depart").css("display","");
	
	displayMsg();
}


//相关
function expenseReleation(type,oper){
	$("#div_expense_parent_list").css("display",'');
// 	$("#expense_parent_list").html("加载中...");
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

		var parenttype = "Opportunities";
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/oppty/list' || '',
		      //async: false,
		      data: {crmId: '${crmId}',viewtype: 'myallview',orgId:'${orgId}',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = '';
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	       $("#expense_parent_list").html('没有找到数据');
			    	   return;
			    	}
					if(d == ""){
		    	    	val = "没有找到数据";
		    	    	$("#div_next").css("display",'none');
		    	    	$("#expense_parent_list").empty();
		    	    	if(currpage === "1"){
		    	    		$("#fristChartsList").css("display",'none');
		    	    	}
		    	    }else{
		    	    		if($(d).size() == pagecount){
		    	    			$("#div_next").css("display",'');
		    	    		}else{
		    	    			$("#div_next").css("display",'none');
		    	    		}
							$(d).each(function(i){
								val += '<span style="height:25px;line-height:25px;"><a href="javascript:void(0)" onclick="expenseParentSel(\''+parenttype+'\',\''+this.rowid+'\',\''+this.name+'\')">'+ this.name +'</a></span><br>';
							});
							$("#fristChartsList").css("display",'');
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
		      data: {crmId: '${crmId}',viewtype: 'myallview',orgId:'${orgId}',firstchar:firstchar, currpage:currpage,pagecount:pagecount} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = '';
		    	    var d = JSON.parse(data);
		    	    if(d == ""){
		    	    	val = "没有找到数据";
		    	    	$("#div_next").css("display",'none');
		    	    	$("#expense_parent_list").empty();
		    	    	if(currpage === "1"){
		    	    		$("#fristChartsList").css("display",'none');
		    	    	}
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
								val += '<span style="height:25px;line-height:25px;"><a href="javascript:void(0)" onclick="expenseParentSel(\''+parenttype+'\',\''+this.rowid+'\',\''+this.name+'\')">'+ this.name +'</a></span><br>';
							});
							$("#fristChartsList").css("display",'');
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
		      data: {openId:'$openId',crmId: '${crmId}',viewtype: 'myview',orgId:'${orgId}',currpage:currpage,startDate:startDate,endDate:endDate,status:status,pagecount:pagecount} || {},
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
		    	    	$("#expense_parent_list").empty();
		    	    	$(":hidden[name=status]").val('');
		    			$(":hidden[name=startDate]").val('');
		    			$(":hidden[name=endDate]").val('');
		    			if(currpage === "1"){
		    	    		$("#fristChartsList").css("display",'none');
		    	    	}
		    	    }else{
		    	    	if($(d).size() == pagecount){
	    	    			$("#div_next").css("display",'');
	    	    		}else{
	    	    			$("#div_next").css("display",'none');
	    	    		}
						$(d).each(function(i){
							var title = escape(this.title);
							val += '<span style="height:25px;line-height:25px;"><a href="javascript:void(0)" onclick="expenseParentSel(\''+parenttype+'\',\''+this.rowid+'\',\''+title+'\')">'+ this.title +'</a></span><br>';
						});
						$("#fristChartsList").css("display",'');
			    	}
					$("#expense_parent_list").html(val);
					displayMsg();
		      }
		 });
		$("input[name=parenttype]").val(parenttype);
		
	}else if(type == "projectList"){//项目列表
		
		var parenttype = "Project";
	
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/project/asyList',
		      //async: false,
		      data: {crmId: '${crmId}',viewtype: 'myallview', currpage:currpage,orgId:'${orgId}', firstchar:firstchar, pagecount:pagecount},
		      dataType: 'text',
		      success: function(data){
		    	        if(!data) return;
			    	    var d = JSON.parse(data);
			    	    
			    	    var val = '';
			    	    if(d == ""){
			    	    	val = "没有找到数据";
			    	    	$("#div_next").css("display",'none');
			    	    	$("#expense_parent_list").empty();
			    	    	if(currpage === "1"){
			    	    		$("#fristChartsList").css("display",'none');
			    	    	}
			    	    }else{
			    	    	if($(d).size() == pagecount){
		  	    				$("#div_next").css("display",'');
			  	    		}else{
			  	    			$("#div_next").css("display",'none');
			  	    		}
							$(d).each(function(i){
								var name = escape(this.name);
								val += '<span style="height:25px;line-height:25px;"><a href="javascript:void(0)" onclick="expenseParentSel(\''+parenttype+'\',\''+this.rowid+'\',\''+name+'\')">'+ this.name +'</a></span><br>';
							});
							$("#fristChartsList").css("display",'');
				    	}
			    	    
						$("#expense_parent_list").html(val);
						displayMsg();
		      }
		 });
		$("input[name=parenttype]").val(parenttype);
	}else if(type == "campaignsList"){//项目列表
		var parenttype = "Activity";
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/campaigns/asyList',
		      //async: false,
		      data: {crmId: '${crmId}', openId:'${openId}',currpage:currpage,orgId:'${orgId}', firstchar:firstchar, pagecount:pagecount},
		      dataType: 'text',
		      success: function(data){
		    	        if(!data){
		    	        	if(currpage === "1"){
			    	        	$("#expense_parent_list").empty();
		    	        	}
		    	        	$("#div_next").css("display",'none');
		    	        	return;
		    	        }
			    	    var d = JSON.parse(data);
			    	    var val = '';
			    	    if(null==d||d == ""){
			    	    	val = '<span style="height:25px;line-height:25px;">没有找到数据</span>';
			    	    	$("#div_next").css("display",'none');
			    	    	$("#expense_parent_list").empty();
			    	    	if(currpage === "1"){
			    	    		$("#fristChartsList").css("display",'none');
			    	    	}
			    	    }else{
			    	    	if($(d).size() == pagecount){
		  	    				$("#div_next").css("display",'');
			  	    		}else{
			  	    			$("#div_next").css("display",'none');
			  	    		}
							$(d).each(function(i){
								var name = escape(this.name);
								val += '<span style="height:25px;line-height:25px;"><a href="javascript:void(0)" onclick="expenseParentSel(\''+parenttype+'\',\''+this.rowid+'\',\''+name+'\')">'+ this.name +'</a></span><br>';
							});
							$("#fristChartsList").css("display",'');
				    	}
			    	    
						$("#expense_parent_list").html(val);
						displayMsg();
		      }
		 });
		$("input[name=parenttype]").val(parenttype);
	}
}

//初始化跳过按钮
function initSkipParent(){
	$(".skipParentType").click(function(){
		//$("#div_parent_label").css("display","none");//父列表内容
		$("#div_expense_parent_list").css("display","none");//相关的ID
		$("#div_expense_parent").css("display","none");//相关的回复
		//清空值
		$("#expense_parent_list").html("");
		//首字母
		$("#fristChartsList").empty();
		$(":hidden[name=firstchar]").val('');
		//父ID
		$(":hidden[name=parenttype]").val('');
		$(":hidden[name=parentid]").val('');
		$(":hidden[name=parentidName]").val('');
		
		//显示费用时间
		$("#div_expense_date_label").css("display","");
		var d = $(":hidden[name=expensedate]").val();
		if(!d){
			$("#div_date_operation").css("display","");
		}
		displayMsg();
	});
}

//任务查询
function initTaskSearch(){
	$("#fristChartsList").empty();
	var ahtml = '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'curmonth\')">当月任务</a>';
	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'process\')">进行中任务</a><br/>';
	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'premonth\')">上月任务</a>';
	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'finish\')">已结束任务</a>';
	ahtml += '<a href="javascript:void(0)" onclick="chooseTaskSearch(\'create\')"><span style=" color: #FFF;font-weight: 800;border:1px solid #DDDDDD;background-color:#106c8e;padding-left:3px;padding-right:3px; ">新任务<span></a>';
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
	}else if(type === "create"){//穿件任务
		initSchedulePage();
		$("#expense-create").addClass("modal");
		$("#task-create").removeClass("modal");
		$("._submenu").css("display","none");
// 		scrollToButtom($(".createTaskContainer"));
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
	      data: {crmId: '${crmId}',orgId:'${orgId}',type: type,openId:'${openId}'},
	      dataType: 'text',
	      success: function(data){
	    	    if(!data) return;
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
	}else if(parenttype == "Project"){
		expenseReleation("projectList","CHAR");
	}else if(parenttype == "Activity"){
		expenseReleation("campaignsList","CHAR");
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
	//日期
	$("#div_expense_date_label").css("display",'');
	if($("input[name=expensedate]").val() == ""){
		$('#div_date_operation').css("display",'');
	} 
	scrollToButtom();//滚动到底部
	displayMsg();
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
	      data: {crmId: '${crmId}', viewtype: 'myallview',orgId:'${orgId}', currpage:currpage,pagecount:pagecount},
	      dataType: 'text',
	      success: function(data){
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode !== '0'){
	    	       $("#expense_assigner_list").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
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
						if(this.userid !== '${crmId}')
						   val += '<div><a href="javascript:void(0)" onclick="expenseAssignerSel(\''+this.userid+'\',\''+this.username+'\')">'+ this.username +'</a></div>';
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
	$('#div_amount_operation').css("display",'none'); 
	scrollToButtom();//滚动到底部
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
	//所选模块类型
	var mName = "";
	if(type == "Opportunities") mName = "跟进业务机会";
	else if(type == "Accounts") mName = "跟进企业";
	else if(type == "Tasks") mName = "处理任务";
	else if(type == "Project") mName = "跟进项目";
	//消息
	var msg = "";
	msg = "您于<span style='color:blue;'>" + $("input[name=expensedate]").val() + "</span>，" ;
	msg += "在<span style='color:blue;'>" + $("#departName").val() +"</span>";
	if(type){
		msg += mName + "【<span style='color:blue;'>" + $("input[name=parentidName]").val() +"</span>】过程中";
	}
	msg += "产生了:<br>";
	//费用名称和费用金额集合
	var expObjs = $("input[name^=expensesubtypeName]");
	expObjs.each(function(){
		var t = $(this).attr("id").split("_")[1];
		//名字
		var n = "一笔<span style='color:blue;'>" + $(this).val() + "</span>";
		//金额
		var amt = '';
		if(t) amt = "（<span style='color:red;'>￥"+$("#expenseamount_"+ t).val()  +"</span>）";
		else amt = "（<span style='color:red;'>￥"+$("#expenseamount").val()  +"</span>）";
		//追加
		msg += n + amt + "<br>";
	});
	//msg += "费用部门:<span style='color:red;'>" + $("#departName").val() + "</span>";
	//追加尾部
	msg += " 申请报销，请点击下面【提交】按钮完成操作。";
	//赋值到视图
	$("#expense_message").html(msg);
}

//添加一个报销
function addAmtSubType(){
	var t = new Date().getTime();
	var a = htmlTemp01.join("");
	var b = htmlTemp02.join("");
	$(a).attr("id", "div_expense_type_" + t).insertBefore("#div_expense_assigner_label");
	$(b).attr("id", "div_expense_subtype_" + t).insertBefore("#div_expense_assigner_label");
	//
	var hvp01 = '<input type="hidden" id="expensetype_'+ t +'" name="expensetype" value="" />';
	var hvNp01 = '<input type="hidden" id="expensetypeName_'+ t +'" name="expensetypeName" value="" />';
	var hv = '<input type="hidden" id="expensesubtype_'+ t +'" name="expensesubtype" value="" />';
	var hvN = '<input type="hidden" id="expensesubtypeName_'+ t +'" name="expensesubtypeName" value="" />';
	var hv2 = '<input type="hidden" id="expenseamount_'+ t +'" name="expenseamount" value="" />';
	$(hvp01).insertAfter("#expensetype");
	$(hvNp01).insertAfter("#expensetypeName");
	$(hv).insertAfter("#expensesubtype");
	$(hvN).insertAfter("#expensesubtypeName");
	$(hv2).insertAfter("#expenseamount");
	$(".addExpType").attr("disabled","disabled");
	
	//关闭面板
	$("#div_expense_type_" + t).find(".closePanl").click(function(){
		$("#div_expense_type_" + t).remove();
		$("#div_expense_subtype_" + t).remove();
		$("#expensetype_" + t).remove();
		$("#expensetypeName_" + t).remove();
		$("#expensesubtype_" + t).remove();
		$("#expensesubtypeName_" + t).remove();
		$("#expenseamount_" + t).remove();
		//报销金额
		$('#div_amount_operation').css("display",'none'); 
		$('#div_expense_message_operation').css("display",'');
		$(".addExpType").removeAttr("disabled");
		displayMsg();	
	});

	//关联父类型
	$("#div_expense_type_" + t).find(".expenseType > a").click(function(){
		$("#expensetype_" + t).val($(this).attr("atrId"));
		$("#expensetypeName_" + t).val($(this).html());
        currTime = t; 
        //过滤数据
    	filterSubTyeData($(this).html(),"#div_expense_type_" + t,'sub');
		//组合费用类别和费用金额
		var txt = "<span style='color:blue'>" + $("#expensetypeName_" + t).val() + "</span>";
		var txt1 = "<span style='color:blue'>" + $("#expensesubtypeName_" + t).val() + "</span>";
		var txt2 = "￥" + "<span style='color:blue'>" + $("#expenseamount_"+ t).val() + "</span>";
		$("#div_expense_subtype_" + t).css('display','').find("#expense_subtype").html(txt +"-"+ txt1 +':'+ txt2);
		//提交区域
		$('#div_expense_message_operation').css("display",'none'); 
		
		//关联子类型
		$("#div_expense_type_" + t).find(".expSubTyeContainer > a").click(function(){
			$("#expensesubtype_" + t).val($(this).attr("atrId"));
			$("#expensesubtypeName_" + t).val($(this).html());
	        currTime = t; 
			//组合费用类别和费用金额
			var txt = "<span style='color:blue'>" + $("#expensetypeName_" + t).val() + "</span>";
			var txt1 = "<span style='color:blue'>" + $("#expensesubtypeName_" + t).val() + "</span>";
			var txt2 = "￥" + "<span style='color:blue'>" + $("#expenseamount_"+ t).val() + "</span>";
			$("#div_expense_subtype_" + t).css('display','').find("#expense_subtype").html(txt +"--"+ txt1 + txt2);
			//报销金额
			$("input[name=input_amount]").attr('placeholder','请输入金额！');
			$('#div_amount_operation').css("display",''); 
			//提交区域
			$('#div_expense_message_operation').css("display",'none'); 
			
		});
	});
	
}

//业务验证
function busiValidate(){
	var fobj = $("form[name=bxForm]");
	
	//报销类别为 "实施"时, 需指定  跟进的项目
	var expTypeNames = fobj.find(":hidden[name=expensetypeName][value='实施']");
	var parenttype = fobj.find(":hidden[name=parenttype]");
	if(expTypeNames.length > 0 
			&& parenttype.val() !== "Project"){
		$(".myMsgBox").css("display","").html("报销类别为 '实施'时, 需指定  跟进的项目!");
		$(".myMsgBox").delay(2000).fadeOut();
		return false;
	}
	
	//other paddition
	//TODO 
	
	return true;
}

//预提交  选择审批人
function commitExamBef(){
	//提交前验证业务是否合理
	if(!busiValidate()) return;
	$(":hidden[name=desc]").val($("#expense_description").val());
	//提交用户列表隐藏
	$(".userList").css("display", "");
	$("#expense-create").css("display", "none");
	//滚动到顶部
	scrollToButtom($(".userList"));
}

//选择好责任人后 提交审批
function commitExam(){
	var approvalid = $(":hidden[name=approvalid]").val();
	if(!approvalid){
		$(".myMsgBox").css("display","").html("请选择审批责任人!");
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
	$(":hidden[name=approvalstatus]").val('new');//new 新建状态
	//责任人清空
	$(":hidden[name=approvalid]").val('');
	$(":hidden[name=approvalname]").val('');
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
	}else if(parenttype == "Project"){
		expenseReleation("projectList","XXX");
	}else if(parenttype == "Activity"){
		expenseReleation("campaignsList","XXX");
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
function validateAmt(num){
  var reg = /^[1-9][0-9]*(?=\.{0,1}\d{0,2}$|$)/;
  if(reg.test(num)) return true;
  return false ;  
}

function initUserCheck(){
	//勾选某个 业务机会  的超链接
	$("#div_user_list > a").click(function(){
		$("#div_user_list > a").removeClass("checked");
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
			var userId = $(this).find(":hidden[name=userId]").val();
			var userName = $(this).find(":hidden[name=userName]").val();
			var email = $(this).find(":hidden[name=email]").val();
			$(":hidden[name=approvalid]").val(userId);
			$(":hidden[name=approvalname]").val(userName);
			$(":hidden[name=approvaemail]").val(email);
		}
		return false;
	});
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

//初始化添加金额和子类别区域
var currTime = null;

//模板
var htmlTemp01 = ['<div id="" class="chatItem you expTypeDiv" style="background: #FFF;display:\'\';">',
					'<div class="chatItemContent">',
						'<img class="avatar" src="<%=path%>//scripts//plugin//wb//css//images//dc.png">',
						'<div class="cloud cloudText">',
							'<div class="cloudPannel">',
								'<div class="cloudBody">',
									'<div class="cloudContent links">',
										'<div style="word-wrap: break-word; font-family: \'Microsoft YaHei\';">',
											'<div style="margin-bottom: 5px;">请输入 费用类别 及 金额 【5/5】  ',
												'<img style="width:12px;height:12px;cursor:pointer" class="closePanl"',
										             'src="<%=path%>//scripts//plugin//wb//css//images//delamt.png"',
										               'align="right">',
											'</div>',
											'<div class="expenseType" style="border-bottom: 1px solid #CCCCCC;padding-bottom: 5px">',
												'<c:forEach var="item" items="${expenseTypeList}" varStatus="status">',
													'<a href="javascript:void(0)" atrId="${item.key}">${item.value}</a>',
												'</c:forEach>',
											'</div>',
											'<div class="expSubTyeContainer" style="line-height:25px"></div>',
										'</div>',
									'</div>',
								'</div>',
								'<div class="cloudArrow "></div>',
							'</div>',
						'</div>',
					'</div>',
				'</div>'];

//模板
var htmlTemp02 = ['<div id="" class="chatItem me expSubTypeDiv" style="background: #FFF;display:none;">',
					'<div class="chatItemContent">',
						'<img class="avatar" width="40px" height="40px"',
							'src="${headimgurl}">',
						'<div class="cloud cloudText" style="margin: 0 15px 0 0;">',
							'<div class="cloudPannel" >',
								'<div class="cloudBody">',
									'<div class="cloudContent">',
										'<div id="expense_subtype" style="white-space: pre-wrap; font-family: \'Microsoft YaHei\';"></div>',
									'</div>',
								'</div>',
								'<div class="cloudArrow "></div>',
							'</div>',
						'</div>',
					'</div>',
				'</div>'];

</script>
</head>

<body>
	<!-- 日程创建FORM DIV -->
	<div id="expense-create">
		<div id="site-nav" class="navbar">
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:30px;">费用报销</h3>
		</div>
		<!-- 报销流程内容 -->
		<div class="site-card-view bxFlowContent">
			<!-- 提交报销数据的表单 -->
			<form name="bxForm" action="<%=path%>/expense/batchSave" method="post">
				<input type="hidden" name="crmId" value="${crmId}" /> 
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="currpage" value="1" />
				<input type="hidden" name="pagecount" value="10"/>
				<!-- operType-->
				<input type="hidden" name="operType" value="add">
				<input type="hidden" name="type" value="add">
				<!-- add expense form data -->
				<input type="hidden" id="expensetype" name="expensetype" value=""> 
				<input type="hidden" id="expensetypeName" name="expensetypeName" value=""> 
				<input type="hidden" id="expensesubtype" name="expensesubtype" value=""> 
				<input type="hidden" id="expensesubtypeName" name="expensesubtypeName" value=""> 
				<input type="hidden" name="expensedate" value=""> 
				<input type="hidden" id="expenseamount" name="expenseamount" value=""> 
				<input type="hidden" id="email" name="email" value="${email}"> 
				<!-- 费用部门 -->
				<input type="hidden" id="depart" name="depart" value=""> 
				<input type="hidden" id="departName" name="departName" value=""> 
				<!-- 费用对象 -->
				<input type="hidden" id="expUserName" name="expUserName" value=""> 
				<!-- 类型   三个值  Accounts Opportunities Tasks Project-->
				<input type="hidden" name="parenttype" value="" >
				<!-- 类型的ID -->
				<input type="hidden" name="parentid" value="" >
				<input type="hidden" name="parentidName" value="" >
				<input type="hidden" name="desc" value="" >
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
				<input type="hidden" name="approvaemail" value="" ><!-- 责任人邮箱-->
				<!-- 任务查询条件 -->
				<input type="hidden" name="startDate" value="" >
				<input type="hidden" name="endDate" value="" >
				<input type="hidden" name="status" value="" >
				<input type="hidden" name="orgId" value="${orgId}" >
			</form>

		</div>
		
		<!-- 花到哪去了？ -->
		<div id="div_parent_label" class="chatItem you" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									您做了什么事情?【1/5】
									   <span class="skipParentType" style="margin-left:-8px;cursor:pointer;color:#106c8e">跳过</span>
									<div style="clear:both;"></div>
									<br/>
									<a href="javascript:void(0)" onclick="expenseReleation('taskList','new')">处理任务</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onclick="expenseReleation('opptyList','new')">跟进业务机会 </a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onclick="expenseReleation('accntList','new')">跟进企业 </a>
									<%--<a href="javascript:void(0)" onclick="expenseReleation('projectList','new')">跟进项目 </a> --%>
									<a href="javascript:void(0)" onclick="expenseReleation('campaignsList','new')">指尖活动</a>
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
								<div id="expense_parent_list" style="word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;">
									
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

		<!-- 哪天产生的费用 -->
		<div id="div_expense_date_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">哪天发生的?【2/5】</div>
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
		
		<!-- 费用部门 -->
		<div id="div_expense_depart" class="chatItem you expDepartDiv" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">请输入费用部门【3/5】  
									</div>
									<div style="line-height: 25px;">
										<c:forEach var="item" items="${expenseDepartList}" varStatus="status">
											<a href="javascript:void(0)" onclick="expDeptSelect('${item.key}','${item.value}')">${item.value}</a>
										</c:forEach>
									</div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 费用部门回复 -->
		<div id="div_expense_deptResp" class="chatItem me expDeptRespDiv" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel" >
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="expense_deptResp" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 费用对象 -->
		<div id="div_expense_users" class="chatItem you expUsersDiv" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>//scripts//plugin//wb//css//images//dc.png">
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">请输入费用对象【4/5】  
									</div>
									<a href="javascript:void(0)" onclick="chooseExpUsers('me')">本人</a>&nbsp;&nbsp;
									<a href="javascript:void(0)" onclick="chooseExpUsers('other')">外部对象 </a>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 费用对象回复 -->
		<div id="div_expense_userResp" class="chatItem me expUsersRespDiv" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px" src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel" >
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="expense_usersResp" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 报销类型 -->
		<div id="div_expense_type" class="chatItem you expTypeDiv" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
									<div style="margin-bottom: 5px;">请输入费用类别及金额【5/5】  
									</div>
									<div class="expenseType" style="border-bottom: 1px solid #CCCCCC;padding-bottom: 5px;line-height:25px;">
										<c:forEach var="item" items="${expenseTypeList}" varStatus="status">
											<a href="javascript:void(0)" onclick="expenseTypeSelect('${item.key}','${item.value}')">${item.value}</a>
										</c:forEach>
									</div>
									<!-- 子类别容器 -->
									<div class="expSubTyeContainer" style="line-height:25px"></div>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 报销类型回复 -->
		<div id="div_expense_subtype" class="chatItem me expSubTypeDiv" style="background: #FFF;display:none;">
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

		<!-- 提交审批的责任人-->
		<div id="div_expense_assigner_label" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>/scripts/plugin/wb/css/images/dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="width:100%;text-align:left;margin-bottom:3px;">
									请选择审批责任人?【5/5】&nbsp;&nbsp;<a href="javascript:void(0)" onclick="skipAsigner()">跳过</a>
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_prev_assigner" >
									<a href="javascript:void(0)" onclick="topageAssign('prev')">
									<img src="<%=path%>/image/prevpage.png" width="32px" >
									</a>
								</div>
								<div id="expense_assigner_list" style="word-wrap: break-word; font-family: 'Microsoft YaHei';min-width:240px;">
								</div>
								<div style="width:100%;text-align:center;display:none;" id="div_next_assigner">
									<a href="javascript:void(0)" onclick="topageAssign('next')">
									<img src="<%=path%>/image/prevpage.png" width="32px" >
									</a>
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

		<div id="div_date_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input name="bxDateInput" id="bxDateInput" value="" style="width:100%" type="text" class="form-control" placeholder="点击选择日期" readonly="">
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" onclick="expenseDate()" class="btn btn-block " style="font-size: 14px;">确&nbsp;&nbsp;认</a>
			</div>
		</div>
		<div id="div_amount_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input type="number" name="input_amount" id="input_amount"  value="" style="width:100%" type="text" class="form-control" placeholder="输入金额">
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" onclick="expenseAmount()" class="btn btn-block " style="font-size: 14px;">确&nbsp;&nbsp;认</a>
			</div>
		</div>
		<div id="div_expusers_operation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 100%;margin-top: 2px; margin-left: 5px; padding: 5px 100px 5px 5px;">
				<input name="input_users" id="input_users" value="" maxlength="30" style="width:100%" type="text" class="form-control" placeholder="请输入费用对象">
			</div>
			<div style="width:80px;float:right;margin: -47px 8px 5px 5px;">
				<a href="javascript:void(0)" onclick="chooseExpOthers()" class="btn btn-block bxDateInputBtn" style="font-size: 14px;">确&nbsp;&nbsp;认</a>
			</div>
		</div>
		<div id="div_expense_message_operation" style="display:none;margin-top:5px;text-align:center;">
			<div style="width: 96%;margin:10px;">
				<textarea name="expense_description" id="expense_description" style="width:100%" rows = "3"  placeholder="补充说明，可选" class="form-control"></textarea>
			</div>
			<div style="width: 100%;">
				
			</div>
			<div class="button-ctrl">
				<fieldset class="">
					<div class="ui-block-a">
						<a href="javascript:void(0)" onclick="addAmtSubType()" class="btn btn-block addExpType" 
						    style="font-size: 16px;margin-left:10px;margin-right:10px;">
						    添&nbsp;&nbsp;&nbsp;加</a>
					</div>
					<div class="ui-block-a">
						<a href="javascript:void(0)" onclick="commitExamBef()" class="btn btn-block " 
						    style="font-size: 16px;margin-left:10px;margin-right:10px;">提&nbsp;&nbsp;&nbsp;交</a>
					</div>
				</fieldset>
			</div>
		</div>
	</div>
	<div style="clear:both;"></div>
	<!-- 用户列表 -->
	<div class=" userList" style="display:none"	>
		<div  class="navbar">
		<a href="#" onclick="javascript:void(0)" class="act-primary assignerGoBak"><i class="icon-back"></i></a>
			选择审批责任人		
		</div>
		<input type="hidden" name="assignerfstChar" />
	    <input type="hidden" name="assignercurrType" value="userList" />
	    <input type="hidden" name="assignercurrPage" value="1" />
	    <input type="hidden" name="assignerpageCount" value="1000" />
		<!-- 字母区域 -->
		<div class="list-group-item listview-item radio assignerChartList" style="background: #fff;padding: 10px;line-height: 30px;">
		</div>
		<div class="list-group listview listview-header" id="div_user_list" style="margin:0px;">
		</div>
		<div id="assignerNoData" style="text-align: center; padding-top: 50px;display:none">没有找到数据</div>
		<div class="nextCommitExamDiv flooter" style="display:''">
			<div class="button-ctrl" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 1px;">
				<fieldset class="">
					<div class="ui-block-a" style="padding-bottom: 4px;">
						<a href="javascript:void(0)" class="btn btn-block"
										style="font-size: 14px;" onclick="skipeExam()">跳过</a>
					</div>
					<div class="ui-block-a" style="padding-bottom: 4px;">
						<a href="javascript:void(0)" class="btn btn-success btn-block"
										style="font-size: 14px;" onclick="commitExam()">确定</a>
					</div>
				</fieldset>
			</div>
		</div>
	</div>
	<!-- 任务容器  费用报销时 有需要添加任务 -->
	<div class="createTaskContainer">
		<div id="task-create" class="modal">
			<div id="task_title" class="navbar">
				<a href="#" onclick="javascript:void(0)" class="act-primary taskGoBak"><i class="icon-back"></i></a>
				新建任务
			</div>
			<jsp:include page="/common/scheduleform.jsp"></jsp:include>
		</div>
		<!-- 相关列表DIV -->
		<div id="parent-more" class=" modal">
			<div id="" class="navbar">
			    <a href="#" onclick="javascript:void(0)" class="act-primary parentGoBak"><i class="icon-back"></i></a>
				数据列表
			</div>
			<div class="page-patch">
				<!-- 客户 -->
				<div class="list-group listview listview-header customerList">
					<c:forEach items="${cList }" var="customer">
						<a href="javascript:void(0)"
							class="list-group-item listview-item radio">
							<div class="list-group-item-bd">
							    <input type="hidden" name="customerId" value="${customer.rowid }"/>
							    <input type="hidden" name="customerName" value="${customer.name }"/>
								<h2 class="title">${customer.name }&nbsp;
								   <span style="color: #AAAAAA; font-size: 12px;">${customer.assigner }</span>
								</h2>
								<p style="margin-left:1.5em;"></p>	
							</div> 
							<div class="input-radio" title="选择该条记录"></div>
						</a>
					</c:forEach>
					<c:if test="${fn:length(cList) == 0}">
						<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>
					</c:if>
				</div>
				<!-- 业务机会 -->
				<div class="site-recommend-list page-patch opptyList">
					<div class="list-group listview opptyListSub">
						<c:forEach items="${oppList }" var="opp">
							<a href="javascript:void(0)" 
								class="list-group-item listview-item radio">
								<div class="list-group-item-bd">
									<div class="thumb list-icon">
										<b>${opp.probability}%</b>
									</div>
									<div class="content">
									    <input type="hidden" name="opptyId" value="${opp.rowid }"/>
							            <input type="hidden" name="opptyName" value="${opp.name }"/>        
										<h1>${opp.name }&nbsp;<span
												style="color: #AAAAAA; font-size: 12px;">${opp.assigner }</span></h1>
										<p class="text-default">预期:￥${opp.amount }&nbsp;&nbsp;&nbsp;&nbsp;销售阶段:${opp.salesstage}</p>
										<p>关闭日期:${opp.dateclosed }&nbsp;&nbsp;&nbsp;&nbsp;跟进天数:${opp.createdate }</p>
									</div>
								</div>
								<div class="input-radio" title="选择该条记录"></div>
							</a>
						</c:forEach>
						<c:if test="${fn:length(oppList) == 0}">
							<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- 任务结束 -->
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<br/><br/><br/><br/><br/><br/><br/><br/>
	<!-- 缓存数据 -->
	<div style="display:none" class="subTypeCache">
		<c:forEach var="item" items="${expenseSubTypeWXList}">
			<input type="hidden" lang="${item.key}" value="${item.value}">
	    </c:forEach>
	</div>
</body>
</html>