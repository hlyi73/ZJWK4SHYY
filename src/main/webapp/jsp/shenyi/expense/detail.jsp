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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/css/style.css">
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css">
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
    	initSystemForm();
    	initSystemFriChar();
    	initSystemData();
    	initExaminerEle();//初始化审批区域的按钮控制
    	initControl();
    	initDatePicker();
    	//initWeixinFunc();
    	shareBtnContol();//初始化分享按钮
    	initGoBackBtn();//初始化后退按钮
    	gotopcolor();
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
    	      data: {flag:'approve',orgId:'${orgId}',crmId: '${crmId}',type: type},
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
    	      data: {flag:'approve',orgId:'${orgId}',crmId: '${crmId}',viewtype: 'teamview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
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
//    	    	    			systemObj.chartlist.css("display",'none');
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
//     						if(this.userid!='${crmId}'){
    						val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
    							+  '<div class="list-group-item-bd"><input type="hidden" name="userId" value="'+this.userid+'"/>'
    							+  '<input type="hidden" name="userName" value="'+this.username+'"/>'
    							+  '<input type="hidden" name="email" value="'+this.email+'"/>'
    							+  '<h2 class="title assName">'+this.username+'</h2><p>职称：'+this.title+'</p><p>部门：<b>'+this.department+'</b>'
    							+  '</p></div><div class="input-radio" title="选择该条记录"></div></a>';
//     						}
    						});
    						systemObj.chartlist.css("display",'');
    		    	}
    	    	    	systemObj.assignerlist.html(val);
    	    	    	initUserCheck();
    	      }
    	 });
    }
    
    function gotopcolor(){
    	$(".gotop").css("background-color","rgba(213, 213, 213, 0.6)");
    }
    
    //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			return false;
    		});
    		//隐藏右上角的按钮
    		$(".act-secondary").css("display","none");
    	}
    }
    
    //微信网页按钮控制
	/* function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
	function getTeamLeas(){
    	return [];
    }
    
    //初始化日期控件
    function initDatePicker(){
    	var opt = {
    		date : {preset : 'date' , minDate: new Date(2000,0,1), maxDate: new Date()},
    		datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2024,7,30,15,44), stepMinute: 5  },
    		time : {preset : 'time'},
    		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
    		image_text : {preset : 'list', labels: ['Cars']},
    		select : {preset : 'select'}
    	};
    	//类型 date  datetime
    	$('#bxDateInput').val('${sd.expensedate}').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    }
    
    function initControl(){
    	var status = '${sd.expensestatus}',//审批状态 新建 待审批 已批准 驳回
    	    assignid = '${sd.assignid}',//费用对象ID
    	    auditor = '${sd.auditor}',//费用的审批人ID
    	    crmId = '${crmId}';//查看界面的用户
    	    commeitId = $(".examineInfoCon dd:last").attr("id"), //最后一个提交人
    	    lststatus = $(".examineInfoCon dd:last").attr("st");//最后一个提交人 的审批状态
    	
    	if(status === "new" && assignid === crmId){//新建状态
    		$(".expenser").css('display','');//提交人
    		$(".examiner").css('display','none');//审批人
    		$(".examineInfo").css('display','none');//审批信息
    		
    	}else if(status === "approving"){//待审批两种情况:  1.审批申请人查看   2.审批人进行审批的查看
    		if(auditor === crmId){
    			$(".expenser").css('display','none');//提交人
        		$(".examiner").css('display','');//审批人
        		$(".examineInfo").css('display','');
    		}else{
    			$(".expenser").css('display','none');//提交人
        		$(".examiner").css('display','');//审批人
        		$(".examineInfo").css('display','');
        		$(".operbtn").css('display','none');//操作按钮
        		$(".replybtn").css({"margin-left":"0px","padding-left":"0px","padding-right":"80px"});
    		}
    	    
    	}else if(status === "reject"){//驳回状态分支
    		initRejectBtn(assignid,commeitId,crmId);
    		
    	}else if(status === "certified"){//已核销
    		$(".examiner").css('display','');//审批人区域
    		$(".operbtn").css('display','none');//操作按钮
//     		$(".replybtn").css("width","85%");
    		
    	}else if(status === "verifyfail"){//核销不通过
		   if(assignid === crmId){//费用对象是当前用户
			   $(".expenser").css('display','');//提交人
		   }else{
			   //核销按钮 
			   $(".examiner").css('display','');//审批人区域
			   $(".operbtn").css('display','none');//操作按钮
			   if($(".verifiBtn").length > 0){
				   $(".replybtn").css("width","70%");
			   }else{
				   $(".replybtn").css("width","85%");
			   }
		   }
    	
    	}else{//已批准状态分支
        	//如果最后一个 提交人 是 自己 , 且状态为"已批准",则出现"驳回"按钮  (驳回 即不同意)
       		if(commeitId === crmId && "approved" === lststatus){
    	    	$(".examiner").css('display','');//审批人区域
    	    	$(".examineInfo").css('display','');//审批历史
    	    	//同意 以及 同意 并下一审批人 按钮 隐藏
    	    	$(".examinerRefuse").css({"display":""});//不同意(驳回)按钮
    			$("#agree").css('display','none');
    			$("#agreeAnd2Next").css('display','none');
    			$(".toOthers").css('display','none');
       		}else{
       			$(".expenser").css('display','none');//提交人
        		$(".examiner").css('display','');//审批人
        		$(".operbtn").css('display','none');
//         		$(".replybtn").css("width","85%");
				$(".replybtn").css({"margin-left":"0px","padding-left":"0px","padding-right":"80px"});
        		$(".examineInfo").css('display','');//审批信息
       		}
    	}
    }
    
    //控制驳回状态下各操作按钮的显示状态
    function initRejectBtn(assignid,commeitId,crmId){
    	if(assignid === crmId){
    		if(commeitId === crmId){//当自己驳回自己的时候,只出现"作废"按钮
    	    	$(".expenser").css('display','');//提交人
    			$(".examiner").css('display','none');//审批人
    			$(".examineInfo").css('display','');//审批信息
        		$("#cancel").css('width','100%');
        		$("#operate").css('display','none');
        		$("#commit").css('display','none');
        		
    		}else if(commeitId !== crmId){//别人驳回的时候,若出现三个"驳回"状态,也只显示"作废"按钮
    			var obj = $(".examineInfoCon dd");
    	    	var statusCount = 0;
    	    	obj.each(function(i){
    				var st = $(this).attr("st");
    				if(st === "reject"){
    					statusCount++;
    				}
    	    	});
    	    	if(statusCount === 3){
    	    		$(".expenser").css('display','');//提交人
    				$(".examiner").css('display','none');//审批人
    				$(".examineInfo").css('display','');//审批信息
    	    		$("#cancel").css('width','100%');
    	    		$("#operate").css('display','none');
    	    		$("#commit").css('display','none');
    	    	}else{
    	    		$(".expenser").css('display','');//提交人
    				$(".examiner").css('display','none');//审批人
    				$(".examineInfo").css('display','');//审批信息
    	    	}
    		}
    	}else{
    		$(".expenser").css('display','none');//提交人
			$(".examiner").css('display','none');//审批人
			$(".examineInfo").css('display','');//审批信息
			
			$(".examiner").css('display','');//审批人区域
    		$(".operbtn").css('display','none');//操作按钮
//     		$(".replybtn").css("width","85%");
    	}
    }
    
    String.prototype.trim=function(){
		return this.replace(/(^\s*)|(\s*$)/g, "");
	};
	
	var p = {};
	
    //初始化审批人控件区域内容
    function initExaminerEle(){
    	var ec = $(".examiner"),
    	    msgc = ec.find(".msgContainer"),
    	    btnc = ec.find(".btnContainer"),
    	    refc = ec.find(".refuseContainer"),
    	    shade = ec.find(".shade"),
    	    
    	    //外层审批按钮
    	    examinerBtn = msgc.find(".examinerBtn"),
    	    //不同意按钮
    	    examinerRefuse = btnc.find(".examinerRefuse"),
    	    //提交到其他人审批
    	    toOthers = btnc.find(".toOthers"),
    	    //取消审批效果按钮
    	    examinerCannel = btnc.find(".cannel"),
    	    
    	    //拒绝取消按钮
    	    refuseCannel = refc.find(".refuseCannel"),
    	    
    	    //提交给其它审批人审批
    	    toOthersInput = $(":hidden[name=toOthers]"),
    	    //消息发送输入框
    	    inputMsgInput = msgc.find("textarea[name=inputMsg]"),
    	
    	    //核销按钮
    	    verifiBtn = msgc.find(".verifiBtn"),//核销按钮
    	    replybtn = msgc.find(".replybtn"),//回复消息按钮
    	    verifiCon = $(".verifiCon"),//核销容器
    	    
    	    vshade = $(".shade"),//shade阴影
    	    vOperCon = verifiCon.find(".verifiOperCon"),//核销操作按钮区域
    	    verifiRefuseCon = verifiCon.find(".verifiRefuseCon"),
    	    verifiRefCan = verifiRefuseCon.find(".verifiRefuseCannel"),
    	    verifiRefSub = verifiRefuseCon.find(".verifiRefuseSubmit"),
    	    
    	    vexamRefuse = vOperCon.find(".vexamRefuse"),//不同意按钮
    	    vAgrBtn = vOperCon.find(".agree"),//核销同意按钮
    	    vDisagrBtn = vOperCon.find(".disagree"),//核销不同意按钮
    	    vCannelOut = vOperCon.find(".cannelout"),//核销不同意容器
    	    
    	    vDisagrCon = verifiCon.find(".disagreeCon"),//核销不同意容器
    	    vDisDesc =   vDisagrCon.find("textarea[name=disagreeDesc]"),//输入框
    	    vDisCannel = vDisagrCon.find(".cannel"),//取消按钮
    	    vDisSubmit = vDisagrCon.find(".submit");//提交按钮
    	    
    	    p.msgModelType = msgc.find("input[name=msgModelType]");
       	    p.msgType = msgc.find("input[name=msgType]");//消息类型
      	    p.inputTxt = msgc.find("textarea[name=inputMsg]");//输入的文本框
      	    p.targetUId = msgc.find("input[name=targetUId]");//目标用户ID
      	    p.targetUName = msgc.find("input[name=targetUName]");//目标用户名
      	    p.subRelaId = msgc.find("input[name=subRelaId]");//子关联ID
      	    p.examinerSend = msgc.find(".examinerSend");//发送按钮
      	    
      	    p.nativeDiv = $("#site-nav");
            p.expenseDetailDiv = $("#expenseDetail");
            p.crmDetailForm = p.expenseDetailDiv.find(".expenseDetailForm");
    	    
    	//发送消息
    	p.examinerSend.click(function(){
    		sendMessage();
    	});
    	
    	//外层审批按钮
    	examinerBtn.click(function(){
    		//显示影音层
        	shade.css("display", "");
    		msgc.css("display", "none");
    		btnc.css("display", "");
    	});
    	//不同意按钮
    	examinerRefuse.click(function(){
    		//显示影音层
        	shade.css("display", "");
    		btnc.css("display", "none");
    		refc.css("display", "");
    	});
    	//提交到其他人审批
    	toOthers.click(function(){
    		//审批字段
    		$(":hidden[name=commitid]").val('${crmId}');
			$(":hidden[name=commitname]").val('${assigner}');
			$(":hidden[name=approvalstatus]").val('approving');//审批状态为待审批
    		
    		//提交到下一个审批人
			$(".userList").css('display', '');//所选审批人列表
			$(".detailInfo").css("display", "none");//详情页面
			//区域显示
	    	$(".commitExamDiv").css("display",'none');//报销申请人 提交区域
	    	$(".nextCommitExamDiv").css("display",'');//报销审批人 提交区域
	    	//头赋值 与 gback
	    	$("#site-nav h3").html("请选择转给其他人审批人");//标头
	    	$(".goBack").css("display", "");//go back 按钮显示
	    	
	    	initUserCheck();
	    	//记录提交给其它人审批的状态
	    	toOthersInput.val("yes");
    	});
    	//取消审批效果按钮
    	examinerCannel.click(function(){
    		//显示影音层
        	shade.css("display", "none");
    		btnc.css("display", "none");
    		msgc.css("display", "");
    	});
    	//拒绝取消按钮
    	refuseCannel.click(function(){
    		//显示影音层
        	shade.css("display", "");
    		refc.css("display", "none");
    		btnc.css("display", "");
    	});
    	
    	verifiBtn.click(function(){
			vshade.css("display", "");
    		ec.css("display","none");
    		
    		verifiCon.css("display","");
    		vOperCon.css("display","");
    		vDisagrCon.css("display","none");
    	});
    	
    	vCannelOut.click(function(){//核销取消
    		vshade.css("display", "none");
    		ec.css("display","");
    		
    		verifiCon.css("display","none");
    		vOperCon.css("display","none");
    		vDisagrCon.css("display","none");
    	});
    	vAgrBtn.click(function(){//核销同意
    		//审批字段
        	$(":hidden[name=commitid]").val('${crmId}');
    		$(":hidden[name=commitname]").val('${sd.assigner}');
    		$(":hidden[name=approvalstatus]").val('certified');//已核销
    		$(":hidden[name=approvalid]").val('');
    		$(":hidden[name=approvalname]").val('');
        	//提交
        	$("form[name=expenseForm]").submit();
    	});
    	vDisagrBtn.click(function(){//核销不同意
    		vOperCon.css("display","none");
    		vDisagrCon.css("display","");
    	});
    	vDisCannel.click(function(){//核销不同意取消
    		vOperCon.css("display","");
    		vDisagrCon.css("display","none");
    	});
    	vDisSubmit.click(function(){//核销不同意提交
    		//审批字段
        	$(":hidden[name=commitid]").val('${crmId}');
    		$(":hidden[name=commitname]").val('${sd.assigner}');
    		$(":hidden[name=approvalstatus]").val('verifyfail');//核销 不通过
    		$(":hidden[name=approvalid]").val('${crmId}');
    		$(":hidden[name=approvalname]").val('');
    		$(":hidden[name=approvaldesc]").val(vDisDesc.val());
        	//提交
        	$("form[name=expenseForm]").submit();
    	});
    	//不同意按钮
    	vexamRefuse.click(function(){
    		//显示影音层
    		$(".verifiCon").css("display","");
    		$(".verifiOperCon").css("display","none");  
    		$(".disagreeCon").css("display","none");
    		$(".verifiRefuseCon").css("display","");
    	});
    	//拒绝取消按钮
    	verifiRefCan.click(function(){
    		//显示影音层
    		$(".verifiOperCon").css("display","");
    		$(".verifiRefuseCon").css("display","none");
    	});
    }
    
    //业务机会翻页
    function topageOppty(){
		var currpage = $("input[name=currOpptyPage]").val();
		$("input[name=currOpptyPage]").val(parseInt(currpage) + 1);
		currpage = $("input[name=currOpptyPage]").val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/oppty/opplist' || '',
		      //async: false,
		      data: {viewtype:'myallview',currpage:currpage,orgId:'${orgId}',pagecount:'10'} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_oppty_list").html();
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	$("#div_oppty_list").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	   return;
	    	    	}
					if(d != ""){
		    	    	if($(d).size() == 10){
		    	    		$("#div_oppty_next").css("display",'');
		    	    	}else{
		    	    		$("#div_oppty_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							val += '<a href="<%=path%>/oppty/detail?rowId='+this.rowid+'&openId=${openId}&publicId=${publicId}" class="list-group-item listview-item radio">'
							    + '<input type="hidden" name="opptyId" value="'+ this.rowid +'" /> '
							    + '<input type="hidden" name="opptyName" value="'+ this.name +'" /> '
								+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
								+ '<b>'+this.probability+'%</b> </div>'
								+ '<div class="content" style="text-align: left">'
								+ '<h1>'+this.name+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1>'
								+ '<p class="text-default">预期:<span style="color:blue">￥'+this.amount+'</span>&nbsp;&nbsp;&nbsp;&nbsp;销售阶段:<span style="color:blue">'+this.salesstage+'</span></p>'
								+ '<p>关闭日期:'+this.dateclosed +'&nbsp;&nbsp;&nbsp;&nbsp</p>'
								+ '</div></div> '
								+ '<div class="input-radio"></div>'
								+ '</a>';
						});
		    	    }else{
		    	    	$("#div_oppty_next").css("display",'none');
		    	    	$(".opptyNoneArea").css("display",'');
		    	    }
					$("#div_oppty_list").html(val);
					initOpptyCheck();
		      }
		 });
	}
    
    //客户翻页
	function topageCust(){
		var currpage = $("input[name=currAcctPage]").val();
		$("input[name=currAcctPage]").val(parseInt(currpage) + 1);
		currpage = $("input[name=currAcctPage]").val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/customer/alist',
		      //async: false,
		      data: {viewtype:'myallview',currpage:currpage,orgId:'${orgId}',pagecount:'10'},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_accnt_list").html();
		    	    var d = JSON.parse(data);
					if(d != ""){
						if(d.errorCode && d.errorCode !== '0'){
							$("#div_accnt_list").html('<div style="text-align: center; padding-top: 50px;">操作失败!错误编码:"' + d.errorCode + "错误描述:" + d.errorMsg +'</div>');
							return;
						}
		    	    	if($(d).size() == 10){
		    	    		$("#div_acct_next").css("display",'');
		    	    	}else{
		    	    		$("#div_acct_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							val += '<a href="<%=path%>/customer/detail?rowId='+this.rowid+'&orgId=${orgId}" class="list-group-item listview-item radio">'
							    + '<input type="hidden" name="accntId" value="'+ this.rowid +'" /> '
						        + '<input type="hidden" name="accntName" value="'+ this.name +'" /> '
								+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
								+ '<b>'+this.accnttype+'</b> </div>'
								+ '<div class="content" style="text-align: left">'
								+ '<h1>'+this.name+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1>'
								+ '<p class="text-default">'+this.employees+'</p><p class="text-default">'+this.street+'</p> '
								+ '</div></div> '
								+ '<div class="input-radio"></div>'
								+ '</a>';
						});
		    	    }else{
		    	    	$("#div_acct_next").css("display",'none');
		    	    	$(".accntNoneArea").css("display",'');
		    	    }
					$("#div_accnt_list").html(val);
					initCustCheck();
		      }
		 });
	}
    
	//任务翻页
	function topageTask(){
    	var currpage = $("input[name=currTaskPage]").val();
		
    	$("input[name=currTaskPage]").val(parseInt(currpage) + 1);
    	currpage = $("input[name=currTaskPage]").val();
    	
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/schedule/tlist' || '',
		      //async: false,
		      data: {viewtype:'myallview',currpage:currpage,orgId:'${orgId}',pagecount:'10'} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_tasks_list").html();
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	$("#div_tasks_list").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	    return;
	    	    	}
					if(d != ""){
		    	    	if($(d).size() == 10){
		    	    		$("#div_task_next").css("display",'');
		    	    	}else{
		    	    		$("#div_task_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							val += '<a href="<%=path%>/schedule/detail?rowId='+this.rowid+'&orgId=${orgId}" class="list-group-item listview-item radio">'
							    + '<input type="hidden" name="taskId" value="'+ this.rowid +'" /> '
					            + '<input type="hidden" name="taskName" value="'+ this.title +'" /> '
								+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
								+ '<b>'+this.statusname+'</b> </div>'
								+ '<div class="content" style="text-align: left">'
								+ '<h1>'+this.title+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+this.assigner+'</span></h1>'
								+ '<p class="text-default">开始时间：'+this.startdate+'</p>'
								+ '</div></div> '
								+ '<div class="input-radio"></div>'
								+ '</a>';
						});
		    	    }else{
		    	    	$("#div_task_next").css("display",'none');
		    	    	$(".taskNoneArea").css("display",'');
		    	    }
					$("#div_tasks_list").html(val);
					initTaskCheck();
		      }
		 });
	}
	
	//项目翻页
	function topageProject(){
    	var currpage = $("input[name=currProjectPage]").val();
    	$("input[name=currProjectPage]").val(parseInt(currpage) + 1);
    	currpage = $("input[name=currProjectPage]").val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/project/asyList',
		      //async: false,
		      data: {viewtype:'myallview',currpage:currpage,crmId:'${crmId}',pagecount:'10',orgId:'${orgId}'},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_project_list").html();
		    	    var d = JSON.parse(data);
					if(d != ""){
		    	    	if($(d).size() == 10){
		    	    		$("#div_project_next").css("display",'');
		    	    	}else{
		    	    		$("#div_project_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							val += '<a href="<%=path%>/schedule/detail?rowId='+this.rowid+'&orgId=${orgId}" class="list-group-item listview-item radio">'
							    + '<input type="hidden" name="projectId" value="'+ this.rowid +'" /> '
					            + '<input type="hidden" name="projectName" value="'+ this.name +'" /> '
								+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
								+ '<b>项目</b> </div>'
								+ '<div class="content" style="text-align: left">'
								+ '<h1>'+this.name+'&nbsp;</h1>'
								+ '<p class="text-default">开始时间：'+ this.startdate +' 结束时间: '+ this.enddate +'</p>'
								+ '</div></div> '
								+ '<div class="input-radio"></div>'
								+ '</a>';
						});
		    	    }else{
		    	    	$("#div_project_next").css("display",'none');
		    	    	$(".projNoneArea").css("display",'');
		    	    }
					$("#div_project_list").html(val);
					initProjectCheck();
		      }
		 });
	}
	
	//活动翻页
	function topageCampaign(){
    	var currpage = $("input[name=currCampaignsPage]").val();
    	$("input[name=currCampaignsPage]").val(parseInt(currpage) + 1);
    	currpage = $("input[name=currCampaignsPage]").val();
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/campaigns/asyList',
		      //async: false,
		      data: {currpage:currpage,crmId:'${crmId}',pagecount:'10',orgId:'${orgId}'},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_campaigns_list").html();
		    	    if(null==data||''==data){
		    	    	if(currpage=='1'){
		    	    		$("#div_campaigns_list").html('<div style="text-align: center; padding-top: 50px;">没有找到数据</div>');
		    	    		return;
		    	    	}
		    	    }
		    	    var d = JSON.parse(data);
					if(d != ""){
		    	    	if($(d).size() == 10){
		    	    		$("#div_campaign_next").css("display",'');
		    	    	}else{
		    	    		$("#div_campaign_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							val += '<a href="<%=path%>/campaigns/detail?rowId='+this.rowid+'&orgId=${orgId}" class="list-group-item listview-item radio">'
						    + '<input type="hidden" name="campaignsId" value="'+ this.rowid +'" /> '
				            + '<input type="hidden" name="campaignsName" value="'+ this.name +'" /> '
				            +'<div class="list-group-item-bd">'
							+'<div class="" style="float:left;padding-right:10px;">'
							+'<img src="<%=path%>/image/default_marketing_bg.jpg" style="height:65px;"></div>'
							+'<div class="content"><h1>'+this.name+'</h1>'
							+'<p style="margin-top:5px;"><img src="<%=path%>/image/list_contract_approval.png" style="width:16px;">&nbsp;&nbsp;'+ this.startdate+'</p>'
							+'<p>&nbsp;&nbsp;'+ this.place+'</p>'
							+ '</div></div><div class="input-radio"></div></a>';
						});
		    	    }else{
		    	    	$("#div_campaign_next").css("display",'none');
		    	    	$(".campaNoneArea").css("display",'');
		    	    }
					$("#div_campaigns_list").html(val);
					initCampaign();
		      }
		 });
	}
	
	function initCustCheck(){
		//勾选某个 客户  的超链接
		$("#div_accnt_list > a").click(function(){
			$("#div_accnt_list > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
				var accntId = $(this).find(":hidden[name=accntId]").val();
				var accntName = $(this).find(":hidden[name=accntName]").val();
				$(":hidden[name=parentid]").val(accntId);
				$(":hidden[name=parentidName]").val(accntName);
				$("input[name=parentidNameInput]").val(accntName);
				
				$(".accntListDiv").css("display", "none");
				$(".detailInfo").css("display",'');
			}
			return false;
		});
    }
	
	function initTaskCheck(){
		//勾选某个 任务  的超链接
		$("#div_tasks_list > a").click(function(){
			$("#div_tasks_list > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
				var taskId = $(this).find(":hidden[name=taskId]").val();
				var taskName = $(this).find(":hidden[name=taskName]").val();
				$(":hidden[name=parentid]").val(taskId);
				$(":hidden[name=parentidName]").val(taskName);
				$("input[name=parentidNameInput]").val(taskName);
				
				$(".taskListDiv").css("display", "none");
				$(".detailInfo").css("display",'');
			}
			return false;
		});
	}
    
    function initOpptyCheck(){
    	//勾选某个 业务机会  的超链接
		$("#div_oppty_list > a").click(function(){
			$("#div_oppty_list > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
				var opptyId = $(this).find(":hidden[name=opptyId]").val();
				var opptyName = $(this).find(":hidden[name=opptyName]").val();
				$(":hidden[name=parentid]").val(opptyId);
				$(":hidden[name=parentidName]").val(opptyName);
				$("input[name=parentidNameInput]").val(opptyName);
				
				$(".opptyListDiv").css("display", "none");
				$(".detailInfo").css("display",'');
			}
			return false;
		});
    }
    
    function initProjectCheck(){
    	//勾选某个 业务机会  的超链接
		$("#div_project_list > a").click(function(){
			$("#div_project_list > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
				var projectId = $(this).find(":hidden[name=projectId]").val();
				var projectName = $(this).find(":hidden[name=projectName]").val();
				$(":hidden[name=parentid]").val(projectId);
				$(":hidden[name=parentidName]").val(projectName);
				$("input[name=parentidNameInput]").val(projectName);
				
				$(".projectListDiv").css("display", "none");
				$(".detailInfo").css("display",'');
			}
			return false;
		});
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
				var userEmail = $(this).find(":hidden[name=email]").val();
				$(":hidden[name=approvalid]").val(userId);
				$(":hidden[name=approvalname]").val(userName);
				$(":hidden[name=approvaemail]").val(userEmail);
			}
			return false;
		});
    }
    
    function initCampaign(){
    	//勾选某个 活动  的超链接
		$("#div_campaigns_list > a").click(function(){
			$("#div_campaigns_list > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
				var campaignsId = $(this).find(":hidden[name=campaignsId]").val();
				var campaignsName = $(this).find(":hidden[name=campaignsName]").val();
				$(":hidden[name=parentid]").val(campaignsId);
				$(":hidden[name=parentidName]").val(campaignsName);
				$("input[name=parentidNameInput]").val(campaignsName);
				
				$(".campaignsListDiv").css("display", "none");
				$(".detailInfo").css("display",'');
			}
			return false;
		});
    }
    
    //初始化后退按钮
    function initGoBackBtn(){
    	//goBack
    	$(".goBack").click(function(){
    		//审批状态 新建 待审批 已批准 驳回
    		var status = '${sd.expensestatus}';
    		if(status === "new"){
    			var uptInput = $(".uptInput:eq(0)").css("display");//根据修改文本地是否打开来判断 
    			if(uptInput !== "none"){
    				//报销 申请人 修改页面   选择相关后的 goBack
            		$(".detailInfo").css("display","");//详情页
            		$(".opptyListDiv").css("display","none");//业务机会列表页面
            		$(".accntListDiv").css("display","none");//客户列表页面
            		$(".taskListDiv").css("display","none");//任务列表页面
            		$(".projectListDiv").css("display","none");//项目列表页面
            		$(".campaignsListDiv").css("display","none");
    			}else{
    				//报销 申请人 修改页面   点击提交按钮 后的 出现的 用户列表 的 goBack
    				$(".userList").css('display', 'none');//提交审批的用户列表
					$(".detailInfo").css("display", "");//详情信息
    			}
    			
    		} else if(status === "approving"){
    			//提交到下一个审批人
    			$(".userList").css('display', 'none');//所选审批人列表
    			$(".detailInfo").css("display", "");//详情页面
    			//区域显示
    	    	$(".commitExamDiv").css("display",'none');//报销申请人 提交区域
    	    	$(".nextCommitExamDiv").css("display",'none');//报销审批人 提交区域
    	    	//头赋值 与 gback
    	    	$("#site-nav h3").html("${expenseName}");//标头
    		}
    		$(".goBack").css("display", "none");//隐藏回退按钮
    	});
    }
	
	//查询类别列表
	function searchParent(){
		$(".goBack").css("display", "");
		$(".accntListDiv").css("display", "none");
		$(".taskListDiv").css("display", "none");
		$(".opptyListDiv").css("display", "none");
		$(".projectListDiv").css("display", "none");
		$(".campaignsListDiv").css("display", "none");
		//biz div
		$("#div_task_next").css("display", "none");
		$("#div_accnt_next").css("display", "none");
		$("#div_oppty_next").css("display", "none");
		$("#div_project_next").css("display", "none");
		$("#div_campaign_next").css("display", "none");
		$("#div_task_list").html("");
		$("#div_accnt_list").html("");
		$("#div_oppty_list").html("");
		$("#div_project_list").html("");
		$("#div_campaigns_list").html("");

		$(".userList").css("display", "none");
		$(".detailInfo").css("display", "none");
		//hidden page
		$(":hidden[name=currTaskPage]").val(0);
		$(":hidden[name=currOpptyPage]").val(0);
		$(":hidden[name=currAccntPage]").val(0);
		$(":hidden[name=currProjectPage]").val(0);
		$(":hidden[name=currCampaignsPage]").val(0);
		
		var ptype = $("select[name=parenttypeSel]").val();
		if(ptype === "Tasks"){
			$(".taskListDiv").css("display", "");
			topageTask();
			initTaskCheck();
		}else if(ptype === "Opportunities"){
			$(".opptyListDiv").css("display", "");
			topageOppty();
			initOpptyCheck();
		}else if(ptype === "Accounts"){
			$(".accntListDiv").css("display", "");
			topageCust();
			initCustCheck();
		}else if(ptype === "Project"){
			$(".projectListDiv").css("display", "");
			topageProject();
			initProjectCheck();
		}else if(ptype === "Activity"){
			$(".campaignsListDiv").css("display", "");
			topageCampaign();
			initCampaign();
		}
	}

	//修改金额数
    function updateAmountVali(){
    	var amobj = $("input[name=input_amount]");
    	if(amobj.val() == "" || !validates(amobj.val())){
    		amobj.val('');
    		amobj.attr('placeholder','请输入正确的金额！');
    		return;
    	}
    	$(":hidden[name=expenseamount]").val(amobj.val());
    }
	    
    //验证正数
    function validates(num){
      var reg = /^\d+(?=\.{0,1}\d{0,2}$|$)/;
      if(reg.test(num)) return true;
      return false ;  
    }
    
    //修改费用子类
    function updateExpenSubType(){
    	var obj = $("select[name=expensesubtypeSel]");
    	var subv = obj.val();
    	var subn = obj.text();
    	$(":hidden[name=expensesubtype]").val(subv);
    	$(":hidden[name=expensesubtypeName]").val(subn); 
    }
    
    //修改费用大类
    function updateExpenType(){
    	var obj = $("select[name=expensetypeSel]");
    	var subv = obj.val();
    	var subn = obj.text();
    	$(":hidden[name=expensetype]").val(subv);
    	$(":hidden[name=expensetypeName]").val(subn); 
    }
    
     //修改一级部门
     function updateParentDepart(){
     	var obj = $("select[name=parentdepartSel]");
     	var subv = obj.val();
     	var subn = obj.text();
     	$(":hidden[name=parentdepart]").val(subv);
     	$(":hidden[name=parentdepartname]").val(subn); 
     }
  
    //修改二级部门
    function updateDepart(){
    	var obj = $("select[name=departSel]");
    	var subv = obj.val();
    	var subn = obj.text();
    	$(":hidden[name=depart]").val(subv);
    	$(":hidden[name=departname]").val(subn); 
    }
    
    //父类 三个值
    function updateParentType(){
    	//赋值
    	$(":hidden[name=parenttype]").val($("select[name=parenttypeSel]").val()); 
    	//清空值
    	$(":hidden[name=parentidName]").val('');
    	$("input[name=parentidNameInput]").val('');
    }
    
    //申请人修改费用信息  不做数据库的保存动作
    function updateExprense(obj){
    	//禁用提交按钮
    	$(".commitLink").attr("disabled","disabled");
    	$(".uptShow").css("display", 'none');
    	$(".uptInput").css("display", '');
    	$("a[name=updExpenBtn]").css("display", 'none');
    	$("a[name=saveExpenBtn]").css("display", '');
    	//费用子类
    	$("select[name=expensesubtypeSel]").val($(":hidden[name=expensesubtype]").val());
		$("select[name=parenttypeSel]").val('${sd.parenttype}');
    	$(".sysInfo").css("display", 'none');
    }
    
    //申请人保存费用信息
    function saveExprense(obj){
    	if($("input[name=expUserName]").val() == ""){
    		$(".myMsgBox").css("display","").html("请输入费用对象!");
			$(".myMsgBox").delay(2000).fadeOut();
    		return;
    	}
    	$(":hidden[name=commitid]").val('');
		$(":hidden[name=commitname]").val('');
		$(":hidden[name=approvalid]").val('');
		$(":hidden[name=approvalname]").val('');
		$(":hidden[name=approvaldesc]").val('');
		$(":hidden[name=approvalstatus]").val('');
		$(":hidden[name=modifydate]").val(new Date());
		$(":hidden[name=expensedate]").val($("#bxDateInput").val());
		$(":hidden[name=desc]").val($("#expDesc").val());
		$(":hidden[name=name]").val("报销"+($(":hidden[name=expensesubtypeName]").val())+($(":hidden[name=expenseamount]").val()));
		//提交表单
    	$("form[name=expenseForm]").submit();
    }
    
    //申请人提交审批 之前选择审批人
    function commitExamBef(){
    	$(".userList").css('display', '');//提交审批的用户列表
		$(".detailInfo").css("display", "none");//详情信息
		$(".goBack").css("display", "");//go back 按钮显示
		//审批字段赋值
		$(":hidden[name=commitid]").val('${crmId}');
		$(":hidden[name=commitname]").val('${sd.assigner}');
		$(":hidden[name=approvalstatus]").val('approving');
		$(":hidden[name=modifydate]").val(new Date());
		$("#site-nav h3").html("请选择审批人");
		initUserCheck();//初始化用户列表选择事件
    }
    
    //申请人提交审批 之前选择审批人
    function cancelExamBef(){
    	$("input[name=type]").val("cancel");
    	$(".myMsgBox").css("display","").html("删除成功！");
		$(".myMsgBox").delay(2000).fadeOut();
    	$("form[name=expenseForm]").submit();
    }
    
    //申请人提交审批
    function commitExam(){
    	var approvalid = $(":hidden[name=approvalid]").val();
    	if(!approvalid){
    		$(".myMsgBox").css("display","").html("请选择审批责任人!");
			$(".myMsgBox").delay(2000).fadeOut();
    		return;
    	}
    	$("form[name=expenseForm]").submit();
    }
    
    //领导审批
    function approExam(r){
    	//审批字段
    	$(":hidden[name=commitid]").val('${crmId}');
		$(":hidden[name=commitname]").val('${sd.assigner}');
		$(":hidden[name=approvalid]").val('${crmId}');
		$(":hidden[name=approvalname]").val('');
		$(":hidden[name=approvaldesc]").val($("#expense_description").val());
		
		if(r === 'y'){//同意 并提交下一个审批人 
			$(":hidden[name=approvalstatus]").val('approved');
			
			//提交到下一个审批人
			$(".userList").css('display', '');//所选审批人列表
			$(".detailInfo").css("display", "none");//详情页面
			//区域显示
	    	$(".commitExamDiv").css("display",'none');//报销申请人 提交区域
	    	$(".nextCommitExamDiv").css("display",'');//报销审批人 提交区域
	    	//头赋值 与 gback
	    	$("#site-nav h3").html("请选择下一个审批人");//标头
	    	$(".goBack").css("display", "");//go back 按钮显示
	    	
	    	initUserCheck();
	    	
		}else if(r === 'n'){//不同意
			$(":hidden[name=approvalstatus]").val('reject');
		
			//提交
	    	$("form[name=expenseForm]").submit();
		}
		
    }
    
    //领导审批同意之后 选择下一个审批人
    function approNextExam(){
    	//审批字段
    	$(":hidden[name=commitid]").val('${crmId}');
		$(":hidden[name=commitname]").val('${sd.assigner}');
		$(":hidden[name=approvalstatus]").val('approved');
		$(":hidden[name=approvalid]").val('');
		$(":hidden[name=approvalname]").val('');
		$(":hidden[name=approvaldesc]").val($("#expense_description").val());
    	//提交
    	$("form[name=expenseForm]").submit();
    }
    
    //结算审批
    function approEndExam(){
    	//提交
    	$("form[name=expenseForm]").submit();
    }
	
    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
	    <jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:30px;">${expenseName}</h3>
		<c:if test="${sd.expensestatus eq 'certified'}">
			<div class="act-secondary">
				<a href="<%=path%>/expense/original?rowId=${rowId}&original=original&orgId=${orgId}" style="font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">原始记录</a> 
			</div>
		</c:if>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div id="expenseDetail" class="view site-recommend detailInfo">
		<div class="recommend-box expenseDetailForm">
			<!-- <h4>详情</h4> -->
			<form name="expenseForm" action="<%=path%>/expense/save" method="post" novalidate="true">
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="rowId" value="${rowId}" />
				<input type="hidden" name="crmId" value="${crmId}" />
				<input type="hidden" name="orgId" value="${orgId}" />
				<!-- operType-->
				<input type="hidden" name="type" value="update"> 
				<!-- update expense form data -->
				<input type="hidden" name="expensetype" value="${sd.expensetype}"> 
				<input type="hidden" name="expensetypename" value="${sd.expensetypename}"> 
				<input type="hidden" name="expensesubtype" value="${sd.expensesubtype}"> 
				<input type="hidden" name="expensesubtypeName" value="${sd.expensesubtypename}"> 
				<input type="hidden" name="expensedate" value="${sd.expensedate}"> 
				<input type="hidden" name="expenseamount" value="${sd.expenseamount}"> 
				<input type="hidden" name="depart" value="${sd.department}"> 
				<input type="hidden" name="departname" value="${sd.departmentname}"> 
				<input type="hidden" name="parentdepart" value="${sd.parentdepart}"> 
				<input type="hidden" name="parentdepartname" value="${sd.parentdepartname}"> 
				<input type="hidden" name="modifydate" value=""> 
				<input type="hidden" name="name" value=""> 
				<input type="hidden" name="assignid" value="${sd.assignid}">
				<!-- 类型   三个值  Accounts Opportunities Tasks -->
				<input type="hidden" name="parenttype" value="${sd.parenttype}" >
				<!-- 类型的ID -->
				<input type="hidden" name="parentid" value="${sd.parentid}" >
				<input type="hidden" name="parentidName" value="" >
				<input type="hidden" name="desc" value="" >
				<!-- 审批字段 -->
				<input type="hidden" name="commitid" value="" ><!-- 提交人ID -->
				<input type="hidden" name="commitname" value="" ><!-- 提交人名字 -->
				<input type="hidden" name="approvalid" value="" ><!-- 提交给谁 -->
				<input type="hidden" name="approvalname" value="" ><!-- 提交给谁的名字 -->
				<input type="hidden" name="approvalstatus" value="" ><!-- 提交的状态 new approving待审批 approved已批准 reject驳回-->
				<input type="hidden" name="approvaldesc" value="" ><!-- 审批的意见 -->
				<input type="hidden" name="recordid" value="${rowId}" ><!-- 费用记录ID-->
				<input type="hidden" name="approvaemail" value="" ><!-- 费用记录ID-->
				<!-- 提交给其它审批人审批 -->
				<input type="hidden" name="toOthers" value="" ><!-- 提交给其它审批人审批-->
				<h3 class="wrapper">基本信息</h3>
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>发生日期：</th>
									<td class="uptShow">${sd.expensedate}</td>
									<td class="uptInput" style="display:none">
										<input name="bxDateInput" id="bxDateInput" value="${sd.expensedate}" 
										     type="text" placeholder="点击选择日期" readonly="">
									</td>
								</tr>
								<tr>
									<th>经办人：</th>
									<td>${sd.assigner}</td>
								</tr>
								<tr>
									<th>费用对象：</th>
									<td class="uptShow">${sd.expUserName}</td>
									<td class="uptInput" style="display:none">
									    <input type="text" name="expUserName" value="${sd.expUserName}" placeholder="请输入费用对象">
									</td>
								</tr>
								<tr>
									<th>一级部门：</th>
									<td class="uptShow">${sd.parentdepartname}</td>
 									<td class="uptInput" style="display:none">
										<select name="parentdepartSel" onchange="updateParentDepart()" style="height:2.2em">
									       <c:forEach var="item" items="${parentDeaprtList}" varStatus="status">
												<c:if test="${item.value eq sd.parentdepart}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.parentdepart}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
 										</select> 
									</td>  
								</tr>
								<tr>
									<th>二级部门：</th>
									<td class="uptShow">${sd.departmentname}</td>
									<td class="uptInput" style="display:none">
										<select name="departSel" onchange="updateDepart()" style="height:2.2em">
									       <c:forEach var="item" items="${departList}" varStatus="status">
												<c:if test="${item.key eq sd.department}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.key ne sd.department}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<th>费用用途：</th>
									<td class="uptShow">${sd.expensetypename}</td>
									<td class="uptInput" style="display:none">
										<select name="expensetypeSel" onchange="updateExpenType()" style="height:2.2em">
									       <c:forEach var="item" items="${expenseTypeList}" varStatus="status">
												<c:if test="${item.value eq sd.expensetypename}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.expensetypename}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<th>费用类型：</th>
									<td class="uptShow">${sd.expensesubtypename}</td>
									<td class="uptInput" style="display:none">
										<select name="expensesubtypeSel" onchange="updateExpenSubType()" style="height:2.2em">
									       <c:forEach var="item" items="${expenseSubTypeList}" varStatus="status">
												<c:if test="${item.value eq sd.expensesubtype}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne sd.expensesubtype}">
													<option value="${item.key}" >${item.value}</option>
												</c:if>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<th>金额：</th>
									<td class="uptShow" style="color:red;font-weight:bold;">￥${sd.expenseamount}</td>
									<td class="uptInput" style="display:none">
									    <input name="input_amount" onblur="updateAmountVali()" value="${sd.expenseamount}" 
									      type="number" placeholder="输入金额">
									</td>
								</tr>
								
								<c:if test="${sd.parentid !=''}">
									<tr>
									    <th>相关：</th>
										<c:if test="${sd.parentid !=null && sd.parenttype eq 'Accounts'}">
											<td class="uptShow"><img src="<%=path%>/image/acounts.png" width="20px" border=0>
												<a href="<%=path%>/customer/detail?rowId=${sd.parentid}&orgId=${orgId}"
												class="list-group-item listview-item">${sd.parentname}</a></td>
										</c:if>
										<c:if test="${sd.parentid !=null && sd.parenttype eq 'Opportunities'}">
											<td class="uptShow">
												<img src="<%=path%>/image/opptys.png" width="20px" border=0>
												<a href="<%=path%>/oppty/detail?rowId=${sd.parentid}&orgId=${orgId}"
												class="list-group-item listview-item">${sd.parentname}</a></td>
										</c:if>
										<c:if test="${sd.parentid !=null && sd.parenttype eq 'Tasks'}">
											<td class="uptShow">
												<img src="<%=path%>/image/tasks.png" width="20px" border=0>
												<a href="<%=path%>/schedule/detail?rowId=${sd.parentid}&orgId=${orgId}"
												class="list-group-item listview-item">${sd.parentname}</a></td>
										</c:if>
										<c:if test="${sd.parentid !=null && sd.parenttype eq 'Project'}">
											<td class="uptShow">
												<img src="<%=path%>/image/tasks.png" width="20px" border=0>
												<a href="<%=path%>/project/detail?rowId=${sd.parentid}&orgId=${orgId}"
												class="list-group-item listview-item">${sd.parentname}</a></td>
										</c:if>
										<c:if test="${sd.parentid !=null && sd.parenttype eq 'Activity'}">
											<td class="uptShow">
												<img src="<%=path%>/image/tasks.png" width="20px" border=0>
												<a href="<%=path%>/zjactivity/detail?rowId=${sd.parentid}orgId=${orgId}"
												class="list-group-item listview-item">${sd.parentname}</a></td>
										</c:if>
										<td class="uptInput" style="display:none">
										    <select name="parenttypeSel" onchange="updateParentType()" style="height:2.2em">
										       <option value="Tasks">任&nbsp;&nbsp;务</option>
										       <option value="Opportunities">商&nbsp;&nbsp;机</option>
										       <option value="Accounts">客&nbsp;&nbsp;户</option>
										       <%--<option value="Project">项&nbsp;&nbsp;目</option> --%>
										       <option value="Activity">活&nbsp;&nbsp;动</option>
											</select>
										    <input name="parentidNameInput" onclick="searchParent()" value="${sd.parentname}" 
										       style="cursor:pointer"
										       type="text" placeholder="点击选择相关" readonly="readonly">
										</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
				</div>
				<br/>
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>状态：</th>
									<td>${sd.expensestatusname}</td>
								</tr>
								<tr>
									<th>描述：</th>
									<td class="uptShow">${sd.desc}</td>
									<td class="uptInput" style="display:none">
									    <textarea name="expDesc" id="expDesc" rows="" cols="" placeholder="请输入备注信息" >${sd.desc}</textarea>
									</td>
								</tr>
								<tr>
									<th>创建：</th>
									<td>${sd.creater}&nbsp;&nbsp;${sd.createdate}</td>
								</tr>
								<tr>
									<th>修改：</th>
									<td>${sd.modifier}&nbsp;&nbsp;${sd.modifydate}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</form>
			
			<!-- 审批历史 -->
			<h3 class="wrapper examineInfo">审批历史</h3>
			<c:if test="${fn:length(approList) > 0 }">
				<div id="div_audit" class="container hy bgcw examineInfoCon">
					<div class="conBox">
						<dl class="hyrc" id="tc01">
							<c:forEach items="${approList }" var="app">
								<c:if test="${app.approvalstatus eq 'approving'}">
									<dt style="line-height: 34px;width:100px;">
										${app.commitdate}<span style="top: 16px;"></span>
									</dt>
									<dd id="${app.commitid}" st="${app.approvalstatus}" 
									     style="width:60%;padding-right:5px;">
										<p>
											<span style="color:#3e6790">
											<c:if test="${app.commitid eq crmId }">
												我
											</c:if>
											<c:if test="${app.commitid ne crmId }">
												${app.commitname}
											</c:if>
											</span>
											<c:if test="${app.type eq '转交' }">
												转交给
											</c:if>
											<c:if test="${app.type ne '转交' }">
												提交给
											</c:if>
											
											<span style="color:#3e6790">
											<c:if test="${app.approvalid eq crmId }">
												我
											</c:if>
											<c:if test="${app.approvalid ne crmId }">
												${app.approvalname}
											</c:if>
											</span>审批
										</p>
									</dd>
								</c:if>

								<c:if test="${app.approvalstatus eq 'approved'}">
									<dt style="line-height: 34px;width:100px;">
									${app.commitdate}<span style="top: 16px;"></span>
									</dt>
									<dd id="${app.commitid}" st="${app.approvalstatus}"
									      style="width:60%;padding-right:5px;">
										<p>
											<span style="color:#3e6790">
											<c:if test="${app.commitid eq crmId }">
												我
											</c:if>
											<c:if test="${app.commitid ne crmId }">
												${app.commitname}
											</c:if>
											</span><span style="color:green">审批通过</span>
											<c:if test="${app.approvalname ne ''}">
												,并提交给<span style="color:#3e6790">
												<c:if test="${app.approvalid eq crmId }">
													我
												</c:if>
												<c:if test="${app.approvalid ne crmId }">
													${app.approvalname }
												</c:if>
												</span>审批
											</c:if>
										</p>
									</dd>
								</c:if>
								<c:if test="${app.approvalstatus eq 'reject'}">
									<dt style="line-height: 34px;width:100px;">
									${app.commitdate}<span style="top: 16px;"></span>
									</dt>
									<dd  id="${app.commitid}" st="${app.approvalstatus}"  
									       style="width:60%;padding-right:5px;">
										<p>
											<span style="color:#3e6790">
												<c:if test="${app.commitid eq crmId }">
													我
												</c:if>
												<c:if test="${app.commitid ne crmId }">
													${app.commitname}
												</c:if>
											</span>&nbsp;<span style="color:red">已驳回</span>
											<c:if test="${app.approvaldesc ne '' }">
												(${app.approvaldesc})
											</c:if>
											
										</p>
									</dd>
								</c:if>
								<c:if test="${app.approvalstatus eq 'certified'}">
									<dt style="line-height: 34px;width:100px;">
									${app.commitdate}<span style="top: 16px;"></span>
									</dt>
									<dd  id="${app.commitid}" st="${app.approvalstatus}"  
									       style="width:60%;padding-right:5px;">
										<p>
											<span style="color:#3e6790">
												<c:if test="${app.commitid eq crmId }">
													我
												</c:if>
												<c:if test="${app.commitid ne crmId }">
													${app.commitname}
												</c:if>
											</span>&nbsp;<span style="color:green">核销通过</span>
											<c:if test="${app.approvaldesc ne '' }">
												(${app.approvaldesc})
											</c:if>
											
										</p>
									</dd>
								</c:if>
								<c:if test="${app.approvalstatus eq 'verifyfail'}">
									<dt style="line-height: 34px;width:100px;">
									${app.commitdate}<span style="top: 16px;"></span>
									</dt>
									<dd  id="${app.commitid}" st="${app.approvalstatus}"  
									       style="width:60%;padding-right:5px;">
										<p>
											<span style="color:#3e6790">
												<c:if test="${app.commitid eq crmId }">
													我
												</c:if>
												<c:if test="${app.commitid ne crmId }">
													${app.commitname}
												</c:if>
											</span>&nbsp;<span style="color:red">核销不通过</span>
											<c:if test="${app.approvaldesc ne '' }">
												(${app.approvaldesc})
											</c:if>
											
										</p>
									</dd>
								</c:if>
							</c:forEach>
						</dl>
					</div>
				</div>
			</c:if>
			
			<!-- 消息显示区域 -->
			<jsp:include page="/common/marketing/messages.jsp">
			<jsp:param value="expense" name="parenttype"/>
			<jsp:param value="${rowId}" name="parentid"/>
			</jsp:include>
		</div>
		
		<!-- 审批人 -->
		<!-- <h3 class="wrapper examiner">审批</h3> -->
		<div class="examiner" style="display:none;text-align:center;">
			<div class="flooter" style="z-index: 99999;background: #FFF;background: rgb(242, 242, 243);border-top: 1px solid #A2A2A2;opacity: 1;">
				<!--发送消息的区域  -->
				<div class="msgContainer">
					<div class="ui-block-a operbtn" style="margin:5px 0px 10px 10px;float:left;width: 60px;">
						<a href="javascript:void(0)" style="position:fixed;bottom:5px;font-size:14px;" class="btn btn-block examinerBtn" >审批</a>
					</div>
					<div class="ui-block-a replybtn" style="width: 100%;margin: 5px 40px 5px 40px;padding-right: 110px;padding-left: 40px;">
					    <!-- 目标用户ID -->
						<input type="hidden" name="targetUId" value="${sd.assignid}" />
						<!-- 目标用户名 -->
						<input type="hidden" name="targetUName" value="${sd.assigner}" />
						<!-- 子级关联ID -->
						<input type="hidden" name="subRelaId" />
						<!-- 消息模块 -->
						<input name="msgModelType" type="hidden" value="expense" />
						<!-- 消息类型 txt img doc-->
						<input name="msgType" type="hidden" value="txt" />
						<!-- 消息输入框-->
<!-- 						<input name="inputMsg" value="" style="width:98%;line-height:40px;font-size:14px;height:40px;margin-left: 5px;margin-top: 0px;"  type="text" class="form-control" placeholder="回复"> -->
						<textarea name="inputMsg" id="inputMsg" style="width: 98%;font-size: 16px; line-height:20px;height: 40px;margin-left: 5px; margin-top: 0px;" class="form-control" placeholder="回复"></textarea>
					</div>
					<div class="ui-block-a " style="float: right;width: 60px;margin: -45px 0px 5px 0px;">
						<a href="javascript:void(0)"  class="btn  btn-block examinerSend" style="font-size: 14px;width:100%;">发送</a>
					</div>
					<div style="clear: both;"></div>
				</div>
				<!--按钮的区域  -->
				<div class="btnContainer" style="display: none">
					<div class="ui-block-a agree" id="agree" style="margin: 10px 12px 10px 12px;padding-bottom: 5px; ">
						<a href="javascript:void(0)" class="btn btn-success btn-block" style="font-size: 14px;padding:0px;margin:0px;" onclick="approNextExam()">同意</a>
					</div>
					<div class="ui-block-a agreeAnd2Next" id="agreeAnd2Next" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
						<a href="javascript:void(0)" class="btn btn-success btn-block" style="font-size: 14px;padding:0px;margin:0px;" onclick="approExam('y')">同意，并提交下一审批人</a>
					</div>
					<div class="ui-block-a examinerRefuse" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
						<a href="javascript:void(0)" class="btn btn-block btn-danger" style="font-size: 14px;padding:0px;margin:0px;">不同意</a>
					</div>
					<div class="ui-block-a toOthers" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
						<a href="javascript:void(0)" class="btn  btn-block btn-warning" style="font-size: 14px;padding:0px;margin:0px;" onclick="">转给其他人审批</a>
					</div>
					<div class="ui-block-a cannel" style="margin: 10px 12px 10px 12px;padding-bottom: 10px;padding-top:10px;font-family: 'Microsoft YaHei';color: #878C91;font-size: 14px;cursor: pointer;">
						<span>取             &nbsp;消</span>
					</div>
				</div>
				<!--不同意按钮的区域  -->
				<div class="refuseContainer" style="display: none">
					<div class="ui-block-a " style="margin-left: 12px">
					    <textarea  name="expense_description" id="expense_description" style="width:98%" rows="3"  placeholder="请填写驳回意见" class="form-control"></textarea>
					</div>
					<div class="ui-block-a " id="" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
						<li href="javascript:void(0)" 
						     class="btn  btn-block refuseCannel" 
						       style="width: 48%;float:left;font-size: 14px;padding:0px;margin-bottom: 5px;">取&nbsp;&nbsp;消</li>
						<li href="javascript:void(0)" 
						     class="btn  btn-block btn-danger refuseSubmit" 
						       style="width: 48%;float:right;font-size: 14px;padding:0px;margin-bottom: 5px;" onclick="approExam('n')">提&nbsp;&nbsp;交</li>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 阴影层 -->
		<div class="shade" style="display: none"></div>

		<!-- 财务核销 区域容器 -->
		<div class="verifiCon flooter" style="display:none;z-index: 99999;background: #FFF;background: rgb(242, 242, 243);border-top: 1px solid #A2A2A2;opacity: 1;">
			<!-- 财务核销按钮 区域容器 -->
			<div class="verifiOperCon " style="display:none;">
			    <div class="ui-block-a vexamRefuse" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
					<a href="javascript:void(0)" class="btn btn-block btn-warning" style="font-size: 14px;padding:0px;margin:0px;">不同意</a>
				</div>
				<div class="ui-block-a agree" style="margin: 10px 12px 10px 12px;padding-bottom: 5px; ">
					<a href="javascript:void(0)" class="btn btn-success btn-block" style="font-size: 14px;padding:0px;margin:0px;" onclick="">核销通过</a>
				</div>
				<div class="ui-block-a disagree" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
					<a href="javascript:void(0)"  class="btn btn-danger btn-block" style="font-size: 14px;padding:0px;margin:0px;" onclick="">核销不通过</a>
				</div>
				<div class="ui-block-a cannelout" style="margin: 10px 12px 10px 12px;padding-bottom: 10px;padding-top:10px;font-family: 'Microsoft YaHei';color: #878C91;font-size: 14px;cursor: pointer;">
					<span>取             &nbsp;消</span>
				</div>
			</div>
			<!--财务核销 不同意  按钮的区域  -->
			<div class="disagreeCon" style="display:none">
				<div class="ui-block-a " style="margin-left: 12px">
				    <textarea  name="disagreeDesc" style="width:98%" rows="3"  placeholder="请填写核销不通过意见" class="form-control"></textarea>
				</div>
				<div class="ui-block-a " id="" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
					<li href="javascript:void(0)"  
					     class="btn  btn-block cannel" 
					       style="width: 48%;float:left;font-size: 14px;padding:0px;margin-bottom: 5px;">取&nbsp;&nbsp;消</li>
					<li href="javascript:void(0)" 
					     class="btn  btn-block btn-danger submit" 
					       style="width: 48%;float:right;font-size: 14px;padding:0px;margin-bottom: 5px;">提&nbsp;&nbsp;交</li>
				</div>
			</div>
			<!--不同意按钮的区域  -->
			<div class="verifiRefuseCon" style="display: none">
				<div class="ui-block-a " style="margin-left: 12px">
				    <textarea  name="expense_description" id="expense_description" style="width:98%" rows="3"  placeholder="请填写驳回意见" class="form-control"></textarea>
				</div>
				<div class="ui-block-a " id="" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
					<li href="javascript:void(0)" 
					     class="btn  btn-block verifiRefuseCannel" 
					       style="width: 48%;float:left;font-size: 14px;padding:0px;margin-bottom: 5px;">取&nbsp;&nbsp;消</li>
					<li href="javascript:void(0)" 
					     class="btn  btn-block btn-danger verifiRefuseSubmit" 
					       style="width: 48%;float:right;font-size: 14px;padding:0px;margin-bottom: 5px;" onclick="approExam('n')">提&nbsp;&nbsp;交</li>
				</div>
			</div>
		</div>
		
		<!-- 费用报销申请人 -->
		<div class="expenser" style="display:none;margin-top:5px;text-align:center;">
			<div class="flooter" style="padding-bottom:2px;z-index: 99999;background: #FFF;background: rgb(242, 242, 243);border-top: 1px solid #A2A2A2;opacity: 1;"> 
				<div class="button-ctrl">
					<fieldset class="margin:auto;">
						<div class="ui-block-a" id="cancel"style="width:33%">
							<a href="javascript:void(0)"  class="btn btn-block"
								style="font-size: 14px;" onclick="cancelExamBef()">作&nbsp;&nbsp;废</a>
						</div>
						<div class="ui-block-a" id="operate" style="width:33%">
							<a href="javascript:void(0)" name="updExpenBtn"  class="btn btn-block"
								style="font-size: 14px;" onclick="updateExprense()">修&nbsp;&nbsp;改</a>
							<a href="javascript:void(0)" name="saveExpenBtn" class="btn btn-block"
								style="font-size: 14px;display:none" onclick="saveExprense()">保&nbsp;&nbsp;存</a>
						</div>
						<div class="ui-block-a" id="commit" style="width:33%">
							<a href="javascript:void(0)" class="btn btn-block commitLink"
								style="font-size: 14px;" onclick="commitExamBef()">提&nbsp;&nbsp;交</a>
						</div>
					</fieldset>
				</div>
			</div>
		</div>
	</div>
	<!-- 业务机会  列表 -->
	<div class="site-recommend-list page-patch opptyListDiv" style="display:none">
	    <input type="hidden" name="currOpptyPage" value="0" />
		<div class="list-group listview" id="div_oppty_list" style="margin:0px;"></div>
		<div style="width:100%;text-align:center;" id="div_oppty_next">
			<a href="javascript:void(0)" onclick="topageOppty()" >
				<img src="<%=path %>/image/nextpage.png" width="32px" />
			</a>
		</div>
		<div class="opptyNoneArea" style="display:none;text-align: center">无数据</div>
	</div>
	<!-- 客户 列表 -->
	<div class="site-recommend-list page-patch accntListDiv" style="display:none">
        <input type="hidden" name="currAcctPage" value="0" />
		<div class="list-group listview" id="div_accnt_list" style="margin:0px;"></div>
		<div style="width:100%;text-align:center;" id="div_accnt_next" >
			<a href="javascript:void(0)" onclick="topageCust()">
			   <img src="<%=path %>/image/nextpage.png" width="32px"/>
			</a>
		</div>
		<div class="accntNoneArea" style="display:none;text-align: center">无数据</div>
	</div>
	<!-- 任务 日程列表 -->
	<div class="site-recommend-list page-patch taskListDiv" style="display:none">
	    <input type="hidden" name="currTaskPage" value="0" />
		<div class="list-group listview " style="margin-top:-1px;" id="div_tasks_list"></div>
		<div style="width:100%;text-align:center;" id="div_task_next">
			<a href="javascript:void(0)" onclick="topageTask()"><img src="<%=path %>/image/nextpage.png" width="32px"/></a>
		</div>
		<div class="taskNoneArea" style="display:none;text-align: center">无数据</div>
	</div>
	<!-- 项目列表 -->
	<div class="site-recommend-list page-patch projectListDiv" style="display:none">
	    <input type="hidden" name="currProjectPage" value="0" />
		<div class="list-group listview " style="margin:0px;" id="div_project_list"></div>
		<div style="width:100%;text-align:center;" id="div_project_next">
			<a href="javascript:void(0)" onclick="topageProject()"><img src="<%=path %>/image/nextpage.png" width="32px"/></a>
		</div>
		<div class="projNoneArea" style="display:none;text-align: center">无数据</div>
	</div>
	<!-- 市场活动列表 -->
	<div class="site-recommend-list page-patch campaignsListDiv" style="display:none">
	    <input type="hidden" name="currCampaignsPage" value="0" />
		<div class="list-group listview " style="margin:0px;" id="div_campaigns_list"></div>
		<div style="width:100%;text-align:center;" id="div_campaign_next">
			<a href="javascript:void(0)" onclick="topageCampaign()"><img src="<%=path%>/image/nextpage.png" width="32px"/></a>
		</div>
		<div class="campaNoneArea" style="display:none;text-align: center">无数据</div>
	</div>
	<!-- 用户列表 -->
	<div class=" userList" style="display:none;padding-bottom:50px;"	>
	<input type="hidden" name="assignerfstChar" />
	    <input type="hidden" name="assignercurrType" value="userList" />
	    <input type="hidden" name="assignercurrPage" value="1" />
	    <input type="hidden" name="assignerpageCount" value="1000" />
		<!-- 字母区域 -->
		<div class="list-group-item listview-item radio assignerChartList" style="background: #fff;padding: 10px;line-height: 30px;">
		</div>
		<div class="list-group listview listview-header" style="margin:0" id="div_user_list">
		</div>
		<div id="assignerNoData" style="text-align: center; padding-top: 50px;display:none">没有找到数据</div>
		<!-- 报销申请人 提交 -->
		<div class=" commitExamDiv flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
			<a class="btn btn-block " type="button" onclick="commitExam();"
			     style="width: 95%;margin: 3px 0px 3px 8px;font-size: 14px;height:2.8em;line-height: 2.8em">确&nbsp定</a>
		</div>
		<!-- 报销审批人 提交 -->
		<div class="nextCommitExamDiv flooter" style="display:none;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
			<div class="button-ctrl">
				<a href="javascript:void(0)"  class="btn btn-block"
								style="width: 95%;margin: 3px 0px 3px 8px;" onclick="approEndExam()">提交</a>
			</div>
		</div>
	</div>
	
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<br><br><br><br>
	<!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href + "&shareBtnContol=yes",
			title:"${sd.name}",  
			desc:"${sd.creater}"+"在"+"${sd.expensedate}"+"报销了"+"${sd.expenseamount}"+"元的"+"${sd.expensesubtypename}",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>