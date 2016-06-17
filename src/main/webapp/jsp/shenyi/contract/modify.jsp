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
    	var flag = $(":hidden[name=assignerflag]").val();
    	initSystemData(flag);
    	initControl();
    	initDatePicker();
    	//initWeixinFunc();
    	shareBtnContol();//初始化分享按钮
    	initGoBackBtn();//初始化后退按钮
	});
    
    var systemObj={};
    function initSystemForm(){
    	systemObj.fstchar = $(":hidden[name=assignerfstChar]");
    	systemObj.currtype = $(":hidden[name=assignercurrType]");
    	systemObj.currpage = $(":hidden[name=assignercurrPage]");
    	systemObj.pagecount = $(":hidden[name=assignerpageCount]");
    	systemObj.assignerflag = $(":hidden[name=assignerflag]");
    	systemObj.chartlist = $(".assignerChartList");
    	systemObj.chartslist = $(".assignersChartList");
    	systemObj.assignerlist = $("#div_user_list");
    	systemObj.assignerslist = $("#div_users_list");
    	systemObj.assignerNoData = $("#assignerNoData");
    	systemObj.assignersNoData = $("#assignersNoData");
    }

    //异步加载首字母
    function initSystemFriChar(){
    	var flag = systemObj.assignerflag.val();
    	systemObj.chartlist.empty();
    	systemObj.fstchar.val('');
    	var type=systemObj.currtype.val();
    	$.ajax({
    	      type: 'get',
    	      url: '<%=path%>/fchart/list',
    	      data: {orgId:'${con.orgId}',flag:flag,openId:'${openId}',publicId:'${publicId}',crmId: '${crmId}',type: type},
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
    	    	    	ahtml += '<a href="javascript:void(0)" onclick="chooseSystemFristCharts(\''+ flag +"','"+this+'\')" style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
    	    	    });
    	    	    systemObj.chartlist.html(ahtml);
    	      }
    	 });
    }

    //选择字母查询
    function chooseSystemFristCharts(flag,obj){
    	systemObj.currpage.val(1);
    	systemObj.fstchar.val(obj);
    	initSystemData(flag);
    }

    //异步查询责任人
    function initSystemData(flag){
    	var currpage = systemObj.currpage.val();
    	var pagecount = systemObj.pagecount.val();
    	var firstchar = systemObj.fstchar.val();
    	$.ajax({
    	      type: 'get',
    	      url: '<%=path%>/lovuser/userlist',
    	      //async: false,
    	      data: {orgId:'${con.orgId}',flag:flag,openId:'${openId}',publicId:'${publicId}',crmId: '${crmId}',viewtype: 'teamview',firstchar:firstchar, currpage:currpage,pagecount:pagecount},
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
    						val += '<a href="javascript:void(0)" class="list-group-item listview-item radio">'
    							+  '<div class="list-group-item-bd"><input type="hidden" name="userId" value="'+this.userid+'"/>'
    							+  '<input type="hidden" name="userName" value="'+this.username+'"/>'
    							+  '<input type="hidden" name="email" value="'+this.email+'"/>'
    							+  '<h2 class="title assName">'+this.username+'</h2><p>职称：'+this.title+'</p><p>部门：<b>'+this.department+'</b>'
    							+  '</p></div><div class="input-radio" title="选择该条记录"></div></a>';
    						});
    						systemObj.chartlist.css("display",'');
    		    	}
   	    	    	systemObj.assignerlist.html(val);
    	    	    initUserCheck();
    	      }
    	 });
    }
    
    //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			return false;
    		});
    	}
    }
    
  //初始化日期控件
    function initDatePicker(){
    	var opt = {
    		date : {preset : 'date' , minDate: new Date(2000,1,1),maxDate: new Date(2099,12,30)},
    		datetime : { preset : 'datetime', minDate: new Date(2012,3,10,9,22), maxDate: new Date(2024,7,30,15,44), stepMinute: 5  },
    		time : {preset : 'time'},
    		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
    		image_text : {preset : 'list', labels: ['Cars']},
    		select : {preset : 'select'}
    	};
    	//类型 date  datetime
    	$('#bxDateInput').val('${con.endDate}').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    	$('#bxstartDateInput').val('${con.startDate}').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    }
    
    //微信网页按钮控制
	/* function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
	  function initControl(){
	    	var status = '${con.contractstatus}',//审批状态 新建 待审批 已批准 驳回 已完工 撤回
	    	    assignid = '${con.assignerid}',//费用对象ID
	    	    auditor = '${con.auditor}',//费用的审批人ID
	    	    crmId = '${crmId}',//查看界面的用户
	    	    commeitId = $("#div_audit dd:last").attr("id"), //最后一个提交人
	    	    lststatus = $("#div_audit dd:last").attr("st");//最后一个提交人 的审批状态
	    	  //新建状态,可以修改,作废或者提交
	    	 if(status === "draft"){
	    		if(assignid === crmId){
		    		$(".expenser").css('display','');//提交人
		    		$(".examiner").css('display','none');//审批人
		    		$(".examineInfo").css('display','none');//审批信息
	    		}else{
	    			$(".expenser").css('display','none');//提交人
		    		$(".examiner").css('display','none');//审批人
		    		$(".examineInfo").css('display','none');//审批信息
	    		}
	    	}else if(status === "approving"){//待审批两种情况:  1.审批申请人查看   2.审批人进行审批的查看
	    		if(auditor === crmId){
	    			$(".expenser").css('display','none');//提交人
	        		$(".examiner").css('display','');//审批人
	        		$(".examineInfo").css('display','');
	    		}else if(assignid === crmId){
	    			$(".expenser").css('display','');//提交人
	        		$(".examiner").css('display','none');//审批人
	        		$(".examineInfo").css('display','');
	        		$("#cancel").css("width","50%");//出现作废按钮
	        		$("#recall").css("display","");
	        		$("#recall").css("width","50%");//出现撤回按钮
	        		$("#operate").css('display','none');
	        		$("#commit").css('display','none');
	    		}else{
	    			$(".expenser").css('display','none');//提交人
	        		$(".examiner").css('display','none');//审批人
	        		$(".examineInfo").css('display','none');
	    		}
	    		//初始化审批人控件区域内容
	    		initExaminerEle();
	    	}else if(status === "reject"){//驳回状态分支
	    		initRejectBtn(assignid,commeitId,crmId);
	    	}else if(status === "recall"){//撤回状态分支
	    		if(assignid === crmId){
	    			$(".expenser").css('display','');//提交人
		    		$(".examiner").css('display','none');//审批人
		    		$(".examineInfo").css('display','');//审批信息
	    		}else{
	    			$(".expenser").css('display','none');//提交人
	        		$(".examiner").css('display','none');//审批人
	        		$(".examineInfo").css('display','');//审批历史
	    		}
	    	}else if('cancel'==status){
	    		$(".expenser").css('display','none');//提交人
        		$(".examiner").css('display','none');//审批人
        		$(".examineInfo").css('display','');//审批历史
	    	}else{//已批准状态分支
	        	//如果最后一个 提交人 是 自己 , 且状态为"已批准",则出现"驳回"按钮  (驳回 即不同意)
	       		if(commeitId === crmId && "approved" === lststatus){
	       			$(".expenser").css('display','none');//提交人
	    	    	$(".examiner").css('display','');//审批人区域
	    	    	$(".examineInfo").css('display','');//审批历史
	    	    	//同意 以及 同意 并下一审批人 按钮 隐藏
	    	    	$(".examinerRefuse").css({'width':'100%',"display":""});//不同意(驳回)按钮
	    			$("#agree").css('display','none');
	    			$("#agreeAnd2Next").css('display','none');
	    			initExaminerEle();
	       		}else{
	       			$(".expenser").css('display','none');//提交人
	        		$(".examiner").css('display','none');//审批人
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
	    			var obj = $("#div_audit dd:gt(0)");
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
	    	}
	    }
	    String.prototype.trim=function(){
			return this.replace(/(^\s*)|(\s*$)/g, "");
		};
		
	    //初始化审批人控件区域内容
	    function initExaminerEle(){
	    	var ec = $(".examiner"),
	    	    msgc = ec.find(".msgContainer"),
	    	    btnc = ec.find(".btnContainer"),
	    	    refc = ec.find(".refuseContainer"),
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
	    	    toOthersInput = $(":hidden[name=toOthers]");
	    	//外层审批按钮
	    	examinerBtn.click(function(){
	    		msgc.css("display", "none");
	    		btnc.css("display", "");
	    	});
	    	//不同意按钮
	    	examinerRefuse.click(function(){
	    		btnc.css("display", "none");
	    		refc.css("display", "");
	    		//给返回btn赋值
		    	$(":hidden[name=gobackbtn]").val("yes");
	    	});
	    	//提交到其他人审批
	    	toOthers.click(function(){
	    		//审批字段
    			$(":hidden[name=commitid]").val('${crmId}');
				$(":hidden[name=commitname]").val('${con.assigner}');
				$(":hidden[name=approvalstatus]").val('approving');//审批状态为待审批
	    		//提交到下一个审批人
				$(".userList").css('display', '');//所选审批人列表
				$(".detailInfo").css("display", "none");//详情页面
				//区域显示
		    	$(".commitExamDiv").css("display",'none');//合同申请人 提交区域
		    	$(".nextCommitExamDiv").css("display",'');//合同审批人 提交区域
		    	//头赋值 与 gback
		    	$("#site-nav h3").html("请选择转给其他人审批人");//标头
		    	$(".goBack").css("display", "");//go back 按钮显示
		    	initUserCheck();
		    	//记录提交给其它人审批的状态
		    	toOthersInput.val("yes");
		    	//给返回btn赋值
		    	$(":hidden[name=gobackbtn]").val("toOthers");
	    	});
	    	//取消审批效果按钮
	    	examinerCannel.click(function(){
	    		//显示影音层
	    		btnc.css("display", "none");
	    		msgc.css("display", "");
	    		//给返回btn赋值
		    	$(":hidden[name=gobackbtn]").val("");
	    	});
	    	//拒绝取消按钮
	    	refuseCannel.click(function(){
	    		//显示影音层
	    		refc.css("display", "none");
	    		btnc.css("display", "");
	    		$(":hidden[name=approvaldesc]").val('');
	    		$("#contract_description").val('');
	    	});
	    }
	    //申请人修改费用信息  不做数据库的保存动作
	    function updateExprense(obj){
	    	//禁用提交按钮
	    	$(".commitLink").attr("disabled","disabled");
	    	$(".uptShow").css("display", 'none');
	    	$(".uptInput").css("display", '');
	    	$("a[name=updExpenBtn]").css("display", 'none');
	    	$("a[name=saveExpenBtn]").css("display", '');
	    	$(".sysInfo").css("display", 'none');
	    	$(":hidden[name=gobackbtn]").val('updateExprense');
	    }
	    //申请人保存费用信息
	    function saveExprense(obj){
	    	$(":hidden[name=commitid]").val('');
			$(":hidden[name=commitname]").val('');
			$(":hidden[name=approvalid]").val('');
			$(":hidden[name=approvalname]").val('');
			$(":hidden[name=approvaldesc]").val('');
			$(":hidden[name=approvalstatus]").val('');
			$(":hidden[name=modifydate]").val(new Date());
			var title = $("input[name=title]").val();
			if(!title){
				$(".myMsgBox").css("display","").html("请输入合同名称!");
				$(".myMsgBox").delay(2000).fadeOut();
	    		return;
			}
			var start = date2utc($("#bxstartDateInput").val());
			var end = date2utc($("#bxDateInput").val()); 
			if(end<start){
				$(".myMsgBox").css("display","").html("结束时间不能晚于开始时间,请重新选择结束时间!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			$(":hidden[name=startDate]").val($("#bxstartDateInput").val());
			$(":hidden[name=endDate]").val($("#bxDateInput").val());
			$(":hidden[name=desc]").val($("#expDesc").val());
			$(":hidden[name=type]").val('update');
			$(":hidden[name=contractstatus]").val('draft');
			//提交表单
	    	$("form[name=contractform]").submit();
	    }
	    
	    //申请人提交审批 之前选择审批人
	    function commitExamBef(){
	    	$(".userList").css('display', '');//提交审批的用户列表
			$(".detailInfo").css("display", "none");//详情信息
			$(".goBack").css("display", "");//go back 按钮显示
			//审批字段赋值
			$(":hidden[name=commitid]").val('${crmId}');
			$(":hidden[name=commitname]").val('${con.assigner}');
			$(":hidden[name=approvalstatus]").val('approving');
			$(":hidden[name=modifydate]").val(new Date());
			$("#site-nav h3").html("请选择审批人");
			$(":hidden[name=gobackbtn]").val("commitExamBef");
			initUserCheck();//初始化用户列表选择事件
	    }
	    
	    //作废按钮
	    function cancelExamBef(){
	    	$("input[name=type]").val("cancel");
	    	$("form[name=contractform]").submit();
	    }
	    
	    //撤回按钮
	    function recallExamBef(){
	    	//审批字段
	    	$(":hidden[name=commitid]").val('${crmId}');
			$(":hidden[name=commitname]").val('${con.assigner}');
	    	$(":hidden[name=type]").val('update');
	    	$(":hidden[name=approvalstatus]").val('recall');
	    	$("form[name=contractform]").submit();
	    }
	    
	    //申请人提交审批
	    function commitExam(){
	    	var approvalid = $(":hidden[name=approvalid]").val();
	    	if(!approvalid){
	    		$(".myMsgBox").css("display","").html("请选择审批责任人!");
				$(".myMsgBox").delay(2000).fadeOut();
	    		return;
	    	}
	    	$(":hidden[name=type]").val('update');
	    	$("form[name=contractform]").submit();
	    }
	    
	    //领导审批
	    function approExam(r){
	    	//审批字段
	    	$(":hidden[name=commitid]").val('${crmId}');
			$(":hidden[name=commitname]").val('${con.assigner}');
			$(":hidden[name=approvalid]").val('${crmId}');
			$(":hidden[name=approvalname]").val('');
			$(":hidden[name=approvaldesc]").val($("#contract_description").val());
			$(":hidden[name=type]").val("update");
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
		    	//给返回btn赋值
		    	$(":hidden[name=gobackbtn]").val("approved");
			}else if(r === 'n'){//不同意
				$(":hidden[name=approvalstatus]").val('reject');
				$(":hidden[name=gobackbtn]").val("reject");
				//提交
		    	$("form[name=contractform]").submit();
			}
			
	    }
	    //选择审批人
	    function initUserCheck(){
	    	//勾选某个责任人的超链接
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
	    
	    //审批同意,直接提交
	    function approNextExam(){
	    	//审批字段
   			$(":hidden[name=commitid]").val('${crmId}');
			$(":hidden[name=commitname]").val('${con.assigner}');
			$(":hidden[name=approvalstatus]").val('approved');
			$(":hidden[name=approvalid]").val('');
			$(":hidden[name=approvalname]").val('');
			$(":hidden[name=approvaldesc]").val($("#contract_description").val());
			$(":hidden[name=type]").val('update');
			$("form[name=contractform]").submit();
	    }
	 	 //修改金额数
	    function updateAmountVali(){
	    	var amobj = $("input[name=input_amount]");
	    	if(amobj.val() == "" || !validate(amobj.val())){
	    		amobj.val('');
	    		amobj.attr('placeholder','请输入正确的金额！');
	    		return;
	    	}
	    	$(":hidden[name=cost]").val(amobj.val());
	    }
		    
	    //验证正数
	    function validate(num){
	      var reg = /^\d+(?=\.{0,1}\d{0,2}$|$)/;
	      if(reg.test(num)) return true;
	      return false ;  
	    }
	   	
	    //结算审批
	    function approEndExam(){
	    	$(":hidden[name=type]").val('update');
	    	//提交
	    	$("form[name=contractform]").submit();
	    }
	 	 
	    //初始化后退按钮
	    function initGoBackBtn(){
	    	//goBack
	    	$(".goBack").click(function(){ //申请人修改费用信息  不做数据库的保存动作
	    		var flag = $(":hidden[name=gobackbtn]").val();
	    		if("commitExamBef"==flag){//点击提交按钮
	    			$(".userList").css('display', 'none');//提交审批的用户列表
	    			$(".detailInfo").css("display", "");//详情信息
	    			$(".goBack").css("display", "");//go back 按钮显示
	    			$("#site-nav h3").html("合同详情");
	    		}else if("updateExprense"==flag){//点击修改按钮
	    			$(".commitLink").removeAttr("disabled");
	    	    	$(".uptShow").css("display", '');
	    	    	$(".uptInput").css("display", 'none');
	    	    	$("a[name=updExpenBtn]").css("display", '');
	    	    	$("a[name=saveExpenBtn]").css("display", 'none');
	    	    	$(".sysInfo").css("display", '');
	    		}else if('approved'==flag){
	    			$(".userList").css('display', 'none');//所选审批人列表
					$(".detailInfo").css("display", "");//详情页面
					//区域显示
			    	$(".commitExamDiv").css("display",'');//报销申请人 提交区域
			    	$(".nextCommitExamDiv").css("display",'none');//报销审批人 提交区域
			    	//头赋值 与 gback
			    	$("#site-nav h3").html("合同详情");//标头
	    		}else if('toOthers'==flag){
	    			$(".userList").css('display', 'none');//所选审批人列表
					$(".detailInfo").css("display", "");//详情页面
					//区域显示
			    	$(".commitExamDiv").css("display",'');//合同申请人 提交区域
			    	$(".nextCommitExamDiv").css("display",'none');//合同审批人 提交区域
			    	//头赋值 与 gback
			    	$("#site-nav h3").html("合同详情");//标头
	    		}else{
	    			window.location.href="<%=path%>/contract/detail?openId=${openId}&publicId=${publicId}&rowId=${rowId}";
	    		}
	    		$(":hidden[name=gobackbtn]").val('');
	    	});
	    }
	    
	    //删除实体对象
	    function delContract(){
	    	if(!confirm("确定删除吗?")){
				return;
			}
		  	$.ajax({
	    		url: '<%=path%>/contract/delOppty',
	    		type: 'post',
	    		data: {rowid:'${rowId}',openId:'${openId}',publicId:'${publicId}',optype:'del'},
	    		dataType: 'text',
	    	    success: function(data){
	    	    	window.location.href = "<%=path%>/contract/list?openId=${openId}&publicId=${publicId}";
	    	    }
	    	});
	    }
    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<div style="float: left">
			<a href="javascript:void(0)" class="goBack" style="color: #fff;padding:5px 5px 5px 0px;">
				<img src="<%=path %>/image/back.png" width="40px" style="padding:5px;">
			</a>
		</div>
		<h3 style="padding-right:45px;">合同详情</h3>
		<c:if test="${assignerid == con.assignerid}">
			<a onclick="delContract()" style="font-size: 14px; font-weight: bold; color: #fff; padding: 0px 10px 0px 10px;margin-top: -50px;float: right;">删除</a>
		</c:if>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="view site-recommend detailInfo">
		<div class="recommend-box">
			<!-- <h4>详情</h4> -->
			<form name="contractform" action="<%=path%>/contract/update" method="post"
				novalidate="true">
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="rowId" value="${rowId}" />
				<input type="hidden" name="crmId" value="${crmId}" />
				<input type="hidden" name="orgId" value="${con.orgId}" />
				<input type="hidden" name="contractCode" value="${con.contractCode}" />
				<input type="hidden" name="contract_source" value="${con.contract_source}" />
				<input type="hidden" name="parent_name" value="${con.parent_name}" />
				<input type="hidden" name="parent_id" value="${con.parent_id}" />
				<input type="hidden" name="parent_type" value="${con.parent_type}" />
				<input type="hidden" name="creater" value="${con.creater}" />
				<input type="hidden" name="createdate" value="${con.createdate}" />
				<input type="hidden" name="modifier" value="${con.modifier}" />
				<input type="hidden" name="modifydate" value="${con.modifydate}" />
				<input type="hidden" name="startDate" value="${con.startDate}" />
				<input type="hidden" name="endDate" value="${con.endDate}" />
				<input type="hidden" name="cost" value="${con.cost}" />
				<input type="hidden" name="assigner" value="${con.assigner}" />
				<input type="hidden" name="contractstatus" value="${con.contractstatus}" />
				<input type="hidden" name="contractstatusname" value="${con.contractstatusname}" />
				<input type="hidden" name="recivedAmount" value="${con.recivedAmount}" />
				<input type="hidden" name="assignerid" value="${con.assignerid}" />
				<input type="hidden" name="desc" value="${con.desc}" />
				<input type="hidden" name="type" value="" />
				<!-- 审批字段 -->
				<input type="hidden" name="commitid" value="" ><!-- 提交人ID -->
				<input type="hidden" name="commitname" value="" ><!-- 提交人名字 -->
				<input type="hidden" name="approvalid" value="" ><!-- 提交给谁 -->
				<input type="hidden" name="approvalname" value="" ><!-- 提交给谁的名字 -->
				<input type="hidden" name="approvalstatus" value="" ><!-- 提交的状态 new approving待审批 approved已批准 reject驳回-->
				<input type="hidden" name="approvaldesc" value="" ><!-- 审批的意见 -->
				<input type="hidden" name="recordid" value="${rowId}" ><!-- 费用记录ID-->
				
				<!-- 控制返回按钮 -->
				<input type="hidden" name="gobackbtn" value="">
				<br/>
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>合同名称：</th>
									<td class="uptShow">${con.title}</td>
									<td class="uptInput" style="display:none">
									    <input name="title" value="${con.title}" 
									      type="text" placeholder="请输入合同名称">
									</td>
								</tr>
								<tr>
									<th>状态：</th>
									<td>${con.contractstatusname}</td>
								</tr>
								<tr>
									<th>合同编号：</th>
									<td>${con.contractCode}</td>
								</tr>
								<tr>
									<th>开始日期：</th>
									<td class="uptShow">${con.startDate}</td>
									<td class="uptInput" style="display:none">
										<input name="bxstartDateInput" id="bxstartDateInput" value="${con.startDate}" 
										     type="text" placeholder="点击选择日期" readonly="">
									</td>
								</tr>
								<tr>
								<th>结束日期：</th>
									<td class="uptShow">${con.endDate}</td>
									<td class="uptInput" style="display:none">
										<input name="bxDateInput" id="bxDateInput" value="${con.endDate}" 
										     type="text" placeholder="点击选择日期" readonly="">
									</td>
								</tr>
								<tr>
									<th>金额：</th>
									<td class="uptShow">￥${con.cost}</td>
									<td class="uptInput" style="display:none">
									    <input name="input_amount" onblur="updateAmountVali()" value="${con.cost}" 
									      type="number" placeholder="输入金额">
									</td>
								</tr>
								<c:if test="${con.parent_type eq 'Accounts'}">
									<tr>
										<th>相关：</th>
										<td><img src="<%=path%>/image/acounts.png" width="20px" border=0>
											<a href="<%=path%>/customer/detail?rowId=${con.parent_id}&openId=${openId}&publicId=${publicId}"
											class="list-group-item listview-item">${con.parent_name}</a></td>
									</tr>
								</c:if>
								<c:if test="${con.parent_type eq 'Opportunities'}">
									<tr>
										<th>相关：</th>
										<td>
											<img src="<%=path%>/image/opptys.png" width="20px" border=0>
											<a href="<%=path%>/oppty/detail?rowId=${con.parent_id}&openId=${openId}&publicId=${publicId}"
											class="list-group-item listview-item">${con.parent_name}</a></td>
									</tr>
								</c:if>
								<tr>
									<th>责任人：</th>
									<td>${con.assigner}</td>
								</tr>
								<tr>
									<th>描述：</th>
									<td class="uptShow">${con.desc}</td>
									<td class="uptInput" style="display:none">
									    <textarea name="expDesc" id="expDesc" rows="" cols="" placeholder="请输入备注信息" >${con.desc}</textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</div></div>
					<Br/>
					<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>创建：</th>
									<td>${con.creater}&nbsp;&nbsp;${con.createdate}</td>
								</tr>
								<tr>
									<th>修改：</th>
									<td>${con.modifier}&nbsp;&nbsp;${con.modifydate}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<!-- 审批历史 -->
				<c:if test="${fn:length(approves)>0 }">
				<h3 class="wrapper examineInfo">审批历史</h3>
					<div id="div_audit" class="container hy bgcw">
						<div class="conBox">
							<dl class="hyrc" id="tc01">
								<c:forEach items="${approves }" var="app">
									<c:if test="${app.approvalstatus eq 'approving'}">
										<dt style="line-height: 34px;width:100px;">
											${app.commitdate}<span style="top: 16px;"></span>
										</dt>
										<dd id="${app.commitid}" st="${app.approvalstatus}"style="width:60%;padding-right:5px;">
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
										<dd id="${app.commitid}" st="${app.approvalstatus}" style="width:60%;padding-right:5px;">
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
										<dd id="${app.commitid}" st="${app.approvalstatus}" style="width:60%;padding-right:5px;">
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
								</c:forEach>
							</dl>
						</div>
					</div>
				</c:if>
				<!-- 审批人 -->
				<!-- <h3 class="wrapper examiner">审批</h3> -->
				<div class="examiner" style="display:none;margin-top:5px;text-align:center;">
					<div class="shade" style="display: none"></div>
					<div class="flooter" style="z-index: 99999;background: #FFF;background: rgb(242, 242, 243);border-top: 1px solid #A2A2A2;opacity: 1;">
						<div class="msgContainer">
							<div class="ui-block-a operbtn" style="float: left;width: 100%;margin: 5px 0px 5px 0px;padding-right:10px;">
								<a href="javascript:void(0)"  class="btn btn-block examinerBtn" style="font-size: 14px;padding:0px;margin-left: 5px;">审批</a>
							</div>
						</div>
						<!--按钮的区域  -->
						<div class="btnContainer" style="display: none">
							
							<div class="ui-block-a agree" id="agree" style="margin: 10px 12px 10px 12px;padding-bottom: 5px; ">
								<a href="javascript:void(0)"  class="btn btn-success btn-block" style="font-size: 14px;padding:0px;margin:0px;" onclick="approNextExam()">同意</a>
							</div>
							<div class="ui-block-a agreeAnd2Next" id="agreeAnd2Next" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
								<a href="javascript:void(0)"  class="btn btn-success btn-block" style="font-size: 14px;padding:0px;margin:0px;" onclick="approExam('y')">同意，并提交下一审批人</a>
							</div>
							<div class="ui-block-a examinerRefuse" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
								<a href="javascript:void(0)"  class="btn btn-block btn-danger" style="font-size: 14px;padding:0px;margin:0px;">不同意</a>
							</div>
							<div class="ui-block-a toOthers" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
								<a href="javascript:void(0)"  class="btn  btn-block btn-warning" style="font-size: 14px;padding:0px;margin:0px;" onclick="">转给其他人审批</a>
							</div>
							<div class="ui-block-a cannel" style="margin: 10px 12px 10px 12px;padding-bottom: 10px;padding-top:10px;font-family: 'Microsoft YaHei';color: #878C91;font-size: 14px;cursor: pointer;">
								<span>取             &nbsp;消</span>
							</div>
						</div>
						<!--不同意按钮的区域  -->
						<div class="refuseContainer" style="display: none">
							<div class="ui-block-a " style="margin-left: 12px">
							    <textarea  name="contract_description" id="contract_description" style="width:98%" rows="3"  placeholder="请填写驳回意见" class="form-control"></textarea>
							</div>
							<div class="ui-block-a " id="" style="margin: 10px 12px 10px 12px;padding-bottom: 5px;">
								<li href="javascript:void(0)"  
								     class="btn btn-default btn-block refuseCannel" 
								       style="width: 48%;float:left;font-size: 14px;padding:0px;margin-bottom: 5px;">取&nbsp;&nbsp;消</li>
								<li href="javascript:void(0)"  
								     class="btn  btn-block btn-danger refuseSubmit" 
								       style="width: 48%;float:right;font-size: 14px;padding:0px;margin-bottom: 5px;" onclick="approExam('n')">提&nbsp;&nbsp;交</li>
							</div>
						</div>
					</div>
				</div>
				<!-- 费用合同申请人 -->
				<div class="expenser" style="display:none;margin-top:5px;text-align:center;">
					<div class="flooter" style="padding-bottom:2px;z-index: 99999;background: #FFF;background: rgb(242, 242, 243);border-top: 1px solid #A2A2A2;opacity: 1;"> 
						<div class="button-ctrl">
							<fieldset class="margin:auto;">
								<div class="ui-block-a" id="cancel"style="width:33%">
									<a href="javascript:void(0)"  class="btn btn-block"
										style="font-size: 14px;" onclick="cancelExamBef()">作&nbsp;&nbsp;废</a>
								</div>
								<div class="ui-block-a" id="recall"style="width:33%;display:none">
									<a href="javascript:void(0)"  class="btn btn-block"
										style="font-size: 14px;" onclick="recallExamBef()">撤&nbsp;&nbsp;回</a>
								</div>
								<div class="ui-block-a" id="operate" style="width:33%">
									<a href="javascript:void(0)" name="updExpenBtn"  class="btn btn-block"
										style="font-size: 14px;" onclick="updateExprense()">修&nbsp;&nbsp;改</a>
									<a href="javascript:void(0)" name="saveExpenBtn"  class="btn btn-block"
										style="font-size: 14px;display:none" onclick="saveExprense()">保&nbsp;&nbsp;存</a>
								</div>
								<div class="ui-block-a" id="commit" style="width:33%">
									<a href="javascript:void(0)"  class="btn btn-block commitLink"
										style="font-size: 14px;" onclick="commitExamBef()">提&nbsp;&nbsp;交</a>
								</div>
							</fieldset>
						</div>
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- 审批列表 -->
	<div class=" userList" style="display:none;padding-bottom:50px;">
		<input type="hidden" name="assignerfstChar" />
	    <input type="hidden" name="assignercurrType" value="userList" />
	    <input type="hidden" name="assignercurrPage" value="1" />
	    <input type="hidden" name="assignerpageCount" value="1000" />
	    <input type="hidden" name="assignerflag" value="approve" />
		<!-- 字母区域 -->
		<div class="list-group-item listview-item radio assignerChartList" style="background: #fff;padding: 10px;line-height: 30px;">
		</div>
		<div class="list-group listview listview-header" style="margin:0" id="div_user_list">
		</div>
		<div id="assignerNoData" style="text-align: center; padding-top: 50px;display:none">没有找到数据</div>
		<!-- 合同申请人 提交 -->
		<div class=" commitExamDiv flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
			<a class="btn btn-block " type="button" onclick="commitExam();"
			     style="width: 95%;margin: 3px 0px 3px 8px;font-size: 14px;height:2.8em;line-height: 2.8em">确&nbsp定</a>
		</div>
		<!-- 合同审批人 提交 -->
		<div class="nextCommitExamDiv flooter" style="display:none;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;">
			<div class="button-ctrl">
				<a href="javascript:void(0)"  class="btn btn-block"
								style="width: 95%;margin: 3px 0px 3px 8px;" onclick="approEndExam()">提交</a>
			</div>
		</div>
	</div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<br><br><br><br><br>
	<!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href + "&shareBtnContol=yes",  
			title:"",  
			desc:"",  
			fakeid:"",  
			callback:function(){}  
		}; 
	</script> --%>
</body>
</html>