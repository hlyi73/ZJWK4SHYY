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
<style>
._index_nav{
	position:fixed;
	right:12px;
	width:48px;
	height:48px;
	border-radius:24px;
	background-color:#3e6790;
	text-align:center;
	line-height:48px;
	font-weight:bold;
	color:#fff;	
	opacity:0.5;
}
</style>
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
	    		var amount = $("input[name=planAmount]").val();
	    		var exp = /^([1-9][0-9]*)$/;
	    		var r = exp.test(amount);
	    		if(!r){
	    			$("#planAmount").val('').attr("placeholder","输入的金额不合法,请重新输入");
	    		    return;
	    		}
	    		$("form[name=detailForm]").submit();
	    	});
    }
    
    //针对回款计划生成回款明细
    function copyData(){
    	var dataObj=[];
    	$("form[name=detailForm]").find("input").each(function(){
    		var name = $(this).attr("name");
    		var v = $(this).val();
    		dataObj.push({name:name,value:v});
    	});
    	dataObj.push({name:'flag',value:'plan'});
    	dataObj.push({name:'planid',value:'${rowId}'});
    	$.ajax({
	    	  type: 'post',
	   	      url: '<%=path%>/gathering/asysave',
	   	      data: dataObj,
	   	  	  dataType: 'text',
	   	      success: function(data){
				var d = JSON.parse(data);
				if(d.errorCode&&d.errorCode!='0'){
					$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	    		$(".myMsgBox").delay(2000).fadeOut();
	    	    	return;
				}else{
					$(".myMsgBox").css("display","") .html("回款计划生成回款明细成功!");
    	    		$(".myMsgBox").delay(2000).fadeOut();
    	    		$("._index_nav").css("display","none");
	    	    	return;
				}
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
				<input type="hidden" name="title" value="${gatheringName}" />
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
									<td class="uptShow">${ga.planAmount} &nbsp;元</td>
									<td class="uptInput" style="display: none">
									<input type="text" name="planAmount" id="planAmount" value="${ga.planAmount}" maxlength="30"
										placeholder="请输入收款金额"></td>
								</tr>
								<tr>
									<th>收款日期：</th>
									<td class="uptShow">${ga.planDate}</td>
									<td class="uptInput" style="display: none"><input name="planDate" id="planDate" value="${ga.planDate}" 
										    type="text" format="yy-mm-dd" placeholder="点击选择收款日期" readonly=""></td>
								</tr>
								<tr>
									<th>收款类型：</th>
									<td class="uptShow">${ga.typename}</td>
									<td class="uptInput" style="display: none"><select
										name="plantype" 
										style="height: 2.2em">
										<option value="" >请选择收款类型</option>
											<c:forEach var="item" items="${types}"
												varStatus="status">
												<c:if test="${item.value eq ga.typename}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne ga.typename}">
													<option value="${item.key}">${item.value}</option>
												</c:if>
											</c:forEach>
										</select>
									</td>
								</tr>
								<tr>
									<th>状态：</th>
									<td class="uptShow">${ga.statusname}</td>
									<td class="uptInput" style="display: none"><select
										name="status" 
										style="height: 2.2em">
										<option value="" >请选择收款状态</option>
											<c:forEach var="item" items="${status}"
												varStatus="status">
												<c:if test="${item.value eq ga.statusname}">
													<option value="${item.key}" selected>${item.value}</option>
												</c:if>
												<c:if test="${item.value ne ga.statusname}">
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
<!-- 		<!-- 跟进历史 --> 
<%-- 		<c:if test="${fn:length(audits) > 0 }"> --%>
<!-- 				<div style="padding-left:5px;padding-right:5px;"> -->
<!-- 					<div style="line-height:50px;font-size:16px;font-weight:bold;padding-left:8px;"> -->
<%-- 							<img src="<%=path%>/image/title-feed.png" width="20px" style="margin-bottom:3px;opacity:0.3;">&nbsp;跟进历史 --%>
<!-- 					</div> -->
<!-- 					<div id="div_audit" class="container hy bgcw conBox _border_"> -->
<!-- 						<dl class="hyrc" id="tc01"> -->
<%-- 							<c:forEach items="${audits }" var="audit" varStatus="stat"> --%>
<!-- 								序号等于5的情况 -->
<%-- 								<c:if test="${stat.index == 5}"> --%>
<!-- 									<div id="more_div" style="width: 100%; text- align: center;"> -->
<!-- 										<div style="clear: both"></div> -->
<!-- 										<div style="padding: 8px; font-size: 14px;text-align: center;"> -->
<!-- 											<a href="javascript:void(0)" -->
<!-- 												onclick='$("#more_div").css("display","none");$("#more_list").css("display","");'>查看全部&nbsp;↓</a> -->
<!-- 										</div> -->
<!-- 									</div> -->
<!-- 									<div id="more_list" style="display: none;"> -->
<%-- 								</c:if> --%>
								
<!-- 								序号大于5的情况 -->
<%-- 								<c:if test="${stat.index >= 5 }"> --%>
<!-- 									<dt style="line-height: 34px;"> -->
<%-- 										${audit.opdate}<span style="top: 16px;"></span> --%>
<!-- 									</dt> -->
<!-- 									<dd style="width: 70%;cursor: pointer" class="" > -->
<!-- 										<div style="border: 1px solid #ededed;border-radius: 3px;background: #f8f8f8;line-height: 24px;text-indent: 0;padding: 4px 4px 4px 6px;"> -->
<%-- 											<ul class="opptyReplayCon" opid="${audit.opid}" opname="${audit.opname}" --%>
<%-- 									     			subRelaId="${audit.parentid }" > --%>
<%-- 											<c:if test="${audit.optype eq 'plantype' }"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>修改回款计划，${audit.beforevalue }<img --%>
<%-- 														src="<%=path%>/image/navigation-forward.png" --%>
<%-- 														width="20px;">${audit.aftervalue} --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'detailtype' }"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>修改回款明细，${audit.beforevalue }<img --%>
<%-- 														src="<%=path%>/image/navigation-forward.png" --%>
<%-- 														width="20px;">${audit.aftervalue} --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'detail'}"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个回款明细： --%>
<%-- 													<a href="<%=path %>/gathering/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid}&gatheringtype=${audit.optype}">${audit.aftervalue}</a> --%>
<%-- 											</c:if>  --%>
<!-- 										</div> -->
<!-- 									</dd> -->
<%-- 								</c:if> --%>
<!-- 								序号小于5的情况 -->
<%-- 								<c:if test="${stat.index < 5 }"> --%>
<!-- 									<dt style="line-height: 34px;"> -->
<%-- 										${audit.opdate}<span style="top: 16px;"></span> --%>
<!-- 									</dt> -->
<!-- 									<dd style="width: 70%;cursor: pointer" > -->
<!-- 										<div style="border: 1px solid #ededed;border-radius: 3px;background: #f8f8f8;line-height: 24px;text-indent: 0;padding: 4px 4px 4px 6px;"> -->
<%-- 										   	<ul class="opptyReplayCon" opid="${audit.opid}" opname="${audit.opname}" --%>
<%-- 									     			subRelaId="${audit.parentid }" > --%>
<%-- 											<c:if test="${audit.optype eq 'plantype' }"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>修改回款计划，${audit.beforevalue }<img --%>
<%-- 														src="<%=path%>/image/navigation-forward.png" --%>
<%-- 														width="20px;">${audit.aftervalue} --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'detailtype' }"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>修改回款明细，${audit.beforevalue }<img --%>
<%-- 														src="<%=path%>/image/navigation-forward.png" --%>
<%-- 														width="20px;">${audit.aftervalue} --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'detail'}"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个回款明细： --%>
<%-- 													<a href="<%=path %>/gathering/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid}&gatheringtype=${audit.optype}">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<!-- 											</ul> -->
<!-- 										</div> -->
<!-- 									</dd> -->
<%-- 								</c:if> --%>
<%-- 							</c:forEach> --%>
<!-- 						</dl> -->
<!-- 					</div> -->
<!-- 					<div style="clear: both"></div> -->
<!-- 					</div> -->
<%-- 				</c:if> --%>
				
				<%--跟进历史 --%>
				<jsp:include page="/common/follow.jsp">
					<jsp:param value="Plan" name="parenttype"/>
					<jsp:param name="parentid" value="${rowId}" />
				</jsp:include>
				<c:if test="${ga.flag ne 'Y'}">
					<a href="javascript:void(0)" onclick="copyData();"><div class="_index_nav" style="bottom:160px;">明细</div></a>
				</c:if>
				
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
	<br>
	<br>
	<br>
	<br>
	<br>
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>