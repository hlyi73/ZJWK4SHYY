<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
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
    	shareBtnContol();//初始化分享按钮
    	//initWeixinFunc();
    	initDatePicker();
	});
    
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
    	$('#receivedDate').val('${ga.receivedDate}').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    	var assignerid = '${ga.assignid}';
	   	 if('${crmId}'==assignerid){
	   		$("#update").css("display","");
	   	 }
			//修改按钮
	   	    $(".operbtn").click(function(){
		   		$("#update").css("display","none");
		   		$(".nextCommitExamDiv").css("display","");
		   		$(".uptShow").css("display","none");
		   	    $(".uptInput").css("display","");
		   	    
		   	});
	    	//取消按钮
	    	$(".canbtn").click(function(){
	    		$("#update").css("display","");
	    		$(".nextCommitExamDiv").css("display","none");
	    		$(".uptShow").css("display","");
	    		$(".uptInput").css("display","none");
	    	});
	    	
	    	//确定按钮
	    	$(".conbtn").click(function(){
	    		var amount = $("input[name=receivedAmount]").val();
	    		var exp = /^([1-9][0-9]*)$/;
	    		var r = exp.test(amount);
	    		if(!r){
	    			$("#receivedAmount").val('').attr("placeholder","输入的金额不合法,请重新输入");
	    		    return;
	    		}
	    		$("form[name=detailForm]").submit();
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
    	//隐藏右上角的按钮
		$(".act-secondary").css("display","none");
    }
    
    //微信网页按钮控制
	/* function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
</script>
</head>
<body>
	<div id="site-nav" class="navbar">
	    <jsp:include page="/common/back.jsp"></jsp:include>
			<div id="update" class="operbtn" style="display:none;float:right;padding:0px 12px 0px 12px;">修改</div>
		<h3 style="padding-right:45px;">${gatheringName}</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="view site-recommend detailInfo">
		<div class="recommend-box">
			<!-- <h4>详情</h4> -->
			<form action="<%=path%>/gathering/update" method="post" name="detailForm" >
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="rowid" value="${rowId}" />
				<input type="hidden" name="crmId" value="${crmId}" />
				<input type="hidden" name="contractId" value="${ga.contractId}" />
				<input type="hidden" name="gatheringtype" value="${gatheringtype}" />
				<input type="hidden" name="assignid" value="${ga.assignid}" />
				<h3 class="wrapper">基本信息</h3>
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>收款名称：</th>
									<td>${gatheringName}</td>
								</tr>
								<tr>
									<th>收款金额：</th>
									<td class="uptShow">${ga.receivedAmount}元</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="receivedAmount" id="receivedAmount" value="${ga.receivedAmount}" maxlength="30"
										placeholder="请输入收款金额"></td>
								</tr>
								<tr>
									<th>收款日期：</th>
									<td class="uptShow">${ga.receivedDate}</td>
									<td class="uptInput" style="display: none"><input name="receivedDate" id="receivedDate" value="${ga.receivedDate}" 
										    type="text" format="yy-mm-dd" placeholder="点击选择收款日期" readonly=""></td>
								</tr>
								<tr>
									<th>付款方式：</th>
									<td class="uptShow">${ga.paymentsname}</td>
									<td class="uptInput" style="display: none"><select
										name="payments" 
										style="height: 2.2em">
										<option value="" >请选择付款方式</option>
											<c:forEach var="item" items="${paymentlist}"
												varStatus="status">
												<c:if test="${item.value eq ga.paymentsname}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne ga.paymentsname}">
													<option value="${item.key}">${item.value}</option>
												</c:if>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<th>责任人：</th>
									<td>${ga.assigner}</td>
								</tr>
								<tr>
									<th>描述：</th>
									<td>${ga.desc}</td>
								</tr>
								<tr>
									<th>创建：</th>
									<td>${ga.creater}&nbsp;&nbsp;${ga.createdate}</td>
								</tr>
								<tr>
									<th>修改：</th>
									<td>${ga.modifier}&nbsp;&nbsp;${ga.modifydate}</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</form>
		</div>
		<!--确定/取消按钮-->
		<div id="confirmdiv" class="nextCommitExamDiv flooter" style="display:none;z-index:999999;opacity: 1;background: #FFF;border-top: 1px solid #ddd;height:56px;margin-top:8px;">
				<div class="button-ctrl" style="margin-top:-2px;">
				<fieldset class="">
					<div class="ui-block-a canbtn" style="padding-bottom: 4px;">
						<a href="javascript:void(0)"  class="btn btn-block"
										style="font-size: 14px;">取消</a>
					</div>
					<div class="ui-block-a conbtn" style="padding-bottom: 4px;">
						<a href="javascript:void(0)"  class="btn btn-success btn-block"
										style="font-size: 14px;">确定</a>
					</div>
				</fieldset>
			</div>
		</div>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>