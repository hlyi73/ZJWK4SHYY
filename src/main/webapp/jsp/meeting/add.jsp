<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<script>
	$(function () {
		initPage();
		initDatePicker();
		initDate();
		initButton();
	});

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
		$("input[name=dateInput]").val(date);
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
		$('#dateInput').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	}
	
	function initButton(){
		//回款审核提交
		$(".submit").click(function(){
			//提交
			$("form[name=verifityForm]").submit();
		});
		//回款跟进提交
		$(".submitBtn").click(function(){
			$(":hidden[name=modifydate]").val(new Date());
			//提交
			$("form[name=followupForm]").submit();
		});
	}
	
	//财务审核
    function finaVerRst(r){
		//如果点击审核通过
    	if(r === 'y'){
    		//出现对话框页面
    		$("#gatheringInfo").css("display","");
    		//填写核销金额和核销日期
			initForm();
    		//核销状态为"2"
    		$(":hidden[name=verStatus]").val('2');
    		//出现确定按钮
    		$(".submit").css("display","");
    	//核销不通过
    	}else{
    		//只需要填写和谐不通过的原因
    		$("#desc").css("display","");
	    	var dec = $("textarea[name=verifityDesc]").val();
	    	$(":hidden[name=verifityRst]").val(dec);
	    	//核销状态为3
    		$(":hidden[name=verStatus]").val('3');
	    	//出现确定按钮
    		$(".submit").css("display","");
    	}
    	$(":hidden[name=invoicedId]").val('${invoicedId}');
    }

	//初始化表单
	function initForm(){
		//回款日期
		$(".dateBtn").click(function(){
			var dInObj = $("input[name=dateInput]");
			//值
			$("#dateMe").css("display","");
			$("#dateMeCont").html(dInObj.val());
			$(":hidden[name=invociedDate]").val(dInObj.val());//开票日期
			$(":hidden[name=receivedDate]").val(dInObj.val());//实际收到日期
			$(":hidden[name=verifityDate]").val(dInObj.val());//核销日期
			$("input[name=amtInput]").val(Math.abs('${obj.margin}'));//金额输入框
			//DIV显示与隐藏
			$("#dateOperation").css("display","none");
			$("#amtYou").css("display","");
			$("#amtOperation").css("display","");
		});
		//回款金额
		$(".amtBtn").click(function(){
			var amtInObj = $("input[name=amtInput]"), planAmtObj = $(":hidden[name=planAmount]"),
			    marginObj = $(":hidden[name=margin]");
			if(amtInObj.val() == "" || !validate(amtInObj.val())){
				amtInObj.val('');
				amtInObj.attr('placeholder','请输入正确的金额！');
				return;
			}
			var am = amtInObj.val().replace(",","");
			var mAm = marginObj.val().replace(",","");
			if(parseFloat(am) != Math.abs(parseFloat(mAm))){
				if(!confirm('您录入的金额与实际收款的金额不符，应收金额：￥'+Math.abs(mAm)+'，实收金额：￥'+am+'，是否继续？')){
					return;
				}
			} 
			//值
			$("#amtMe").css("display","");
			$("#amtMeCont").html("<span style='color:blue'>￥ "+ amtInObj.val() + "</span>");
			$(":hidden[name=invoicedAmount]").val(amtInObj.val());//开票金额
			$(":hidden[name=verifityAmount]").val(amtInObj.val());//核销金额
			//DIV显示与隐藏
			$("#amtOperation").css("display","none");
			$("#descOperation").css("display","");
		});
	}

	function initPage(){
		var vertifyFlag = '${verifityFlag}';	
		//财务审核
		if(vertifyFlag){
			$("#gotodiv").css("display","");
			$("#analytics_close").click(function(){
				$("#gotodiv").css("display","none");
			});
		//财务开票
		}else{
			$("#gatheringInfo").css("display","");
			$(".submitBtn").css("display","");
		}
	}
	
	//验证正数
	function validate(num){
	  var reg = /^\d+(?=\.{0,1}\d+$|$)/;
	  if(reg.test(num)) return true;
	  return false ;  
	}

</script>
</head>
<body>
	<!-- 会议创建FORM DIV -->
	<div id="meeting-create">
		
	
		<div id="meetingInfo" style="display:none;">	
		<div id="site-nav" class="navbar">
		</div>
		<!-- 会议流程内容 -->
		<div class="site-card-view bxFlowContent">
			<!-- 提交报销数据的表单 -->
			<form name="followupForm" action="<%=path%>/meeting/saveFollowup" method="post">
			    <input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="rowId" value="${rowId}" />
				<input type="hidden" name="meetingId" value="${obj.meetingId}" /><!-- 会议ID -->
				<input type="hidden" name="meetingTitle" value="${obj.planAmount}" /><!-- 会议标题 -->
				<input type="hidden" name="meetingDate" /><!-- 会议时间 -->
				<input type="hidden" name="meetingAdr" value="${obj.receivedAmount}"/><!-- 会议地址 -->
				<input type="hidden" name="meetingHost" value="${obj.margin}"/><!-- 主持人 -->
				<input type="hidden" name="meetingCost" /><!-- 会议费用-->
				<input type="hidden" name="consultation" /><!-- 咨询-->
			    <input type="hidden" name="meetingMemo"/><!-- 备注 -->
			</form>
		</div>
		
		<!-- 汇总 -->
		<div id="msgCollection" class="chatItem you" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar" src="<%=path%>//scripts//plugin//wb//css//images//dc.png">
				<div class="cloud cloudText" >
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div id="expense_message" style="word-wrap: break-word; font-family: 'Microsoft YaHei';">
								${obj.contractName}：<br/>
								摘&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;要：${obj.title}<br>收款类型：${obj.type}<br>应收日期：${obj.planDate}<br>应收金额：￥${obj.planAmount}<br/>已收金额：￥${obj.receivedAmount} 
								<br><span style="color: red">差&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;额：￥${obj.margin} </span>
								</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 哪天产生的回款 -->
		<div id="dateYou" class="chatItem you" style="background: #FFF;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">开票日期?【1/2】</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>

		<!-- 日期回复 -->
		<div id="dateMe" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="dateMeCont" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 回款金额 -->
		<div id="amtYou" class="chatItem you" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar"
					src="<%=path%>//scripts//plugin//wb//css//images//dc.png" >
				<div class="cloud cloudText">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent links">
								<div style="word-wrap: break-word; font-family: 'Microsoft YaHei';">开票金额?【2/2】</div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- 金额回复 -->
		<div id="amtMe" class="chatItem me" style="background: #FFF;display:none;">
			<div class="chatItemContent">
				<img class="avatar" width="40px" height="40px"
					src="${headimgurl}">
				<div class="cloud cloudText" style="margin: 0 15px 0 0;">
					<div class="cloudPannel">
						<div class="cloudBody">
							<div class="cloudContent">
								<div id="amtMeCont" style="white-space: pre-wrap; font-family: 'Microsoft YaHei';"></div>
							</div>
						</div>
						<div class="cloudArrow "></div>
					</div>
				</div>
			</div>
		</div>
		
		
		
	</div>
	
		<!-- 日期输入框 -->
		<div id="dateOperation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 75%;float:left;margin-top:2px;margin-left:5px;">
				<input name="dateInput" id="dateInput" value="" style="width:100%" type="text" class="form-control" placeholder="点击选择日期" readonly="">
			</div>
			<div style="width: 20%;float:right;margin-right:5px;margin-top:4px;">
				<a href="javascript:void(0)" class="btn btn-block dateBtn" style="font-size: 14px;">确&nbsp;&nbsp;&nbsp;认</a>
			</div>
		</div>
		<!-- 金额输入框 -->
		<div id="amtOperation" style="display:none;background-color:#DDDDDD;" class="flooter">
			<div style="width: 75%;float:left;margin-top:2px;margin-left:5px;">
				<input name="amtInput" id="amtInput" value="" style="width:100%" type="text" class="form-control" placeholder="输入金额">
			</div>
			<div style="width: 20%;float:right;margin-right:5px;margin-top:4px;">
				<a href="javascript:void(0)" class="btn btn-block amtBtn" style="font-size: 14px;">确&nbsp;&nbsp;&nbsp;认</a>
			</div>
		</div>
		
			<!-- 确定提交按钮 -->
			<div style="width: 100%;">
				<a href="javascript:void(0)" class="btn btn-block submitBtn" style="font-size: 16px;margin-left:10px;margin-right:10px;display:none;">提&nbsp;&nbsp;&nbsp;交</a>
			</div>
			<!-- 确定提交按钮 -->
			<div style="width: 100%;">
				<a href="javascript:void(0)" class="btn btn-block submit" style="font-size: 16px;margin-left:10px;margin-right:10px;display:none;">提&nbsp;&nbsp;&nbsp;交</a>
			</div>
			<!--核销不通过 须填写原因  -->
			<div id="desc" style="width: 96%;margin:10px;display:none;">
				<textarea name="verifityDesc" style="width:100%" rows = "3"  
			  	 placeholder="核销不通过原因,必填" class="form-control"></textarea>
			 </div>
		
<!-- 		<div id="descOperation" style="display:none;margin-top:5px;text-align:center;"> -->
<!-- 			<div style="width: 96%;margin:10px;"> -->
<!-- 				<textarea name="desc" id="desc" style="width:100%" rows = "3"  placeholder="补充说明，必填" class="form-control"></textarea> -->
<!-- 			</div> -->
<!-- 			<div style="width: 100%;"> -->
<!-- 				<a href="javascript:void(0)" class="btn btn-block submitBtn" style="font-size: 16px;margin-left:10px;margin-right:10px;">提&nbsp;&nbsp;&nbsp;交</a> -->
<!-- 			</div> -->
<!-- 		</div> -->
	</div>
	
</body>
</html>