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
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script type="text/javascript">
	$(function () {
		//initWeixinFunc();
		initDelBtn();
	});
	
	/* //微信网页按钮控制
	function initWeixinFunc(){
		//隐藏顶部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
	
	//批量删除
	function batchDel(){
		$(".batchDelDiv").css("display",'none');
		$(".detailAprDiv").css("display",'none');
		$(".calBatchDelDiv").css("display",'');
		$(".batchDelHref").css("display",'');
		$(".sglAprHref").css("display",'');
		$(".approveTip").html('');
	}
	//取消批量删除
	function calBatchDel(){
		$(".batchDelDiv").css("display",'');
		$(".detailAprDiv").css("display",'');
		$(".calBatchDelDiv").css("display",'none');
		$(".batchDelHref").css("display",'none');
		$(".sglAprHref").css("display",'none');
		$("#div_partner_list a").removeClass("checked");
		$(".approveTip").html('');
	}
	
	//初始化全选和不全选按钮
	function initDelBtn(){
		$("#div_partner_list > a").unbind("click").bind("click", function(){
			var cssval = $(".batchDelHref").css("display");
			if(cssval !== 'none'){
				var i = $(this).index();
				if(i !== 0){
					if($(this).hasClass("checked")){
						$(this).removeClass("checked");
					}else{
						$(this).addClass("checked");
					}
				}
			}else{
				window.location.href = $(this).attr("href");
			}
			
			return false;
		});
		//选择所有的数据
		$(".checkAllBtn").unbind("click").bind("click", function(){
			if($(this).parent().hasClass("checked")){
				$(this).parent().removeClass("checked");
				$("#div_partner_list a").removeClass("checked");
			}else{
				$(this).parent().addClass("checked");
				$("#div_partner_list a").addClass("checked");
			}
			return false;
		});
		//删除
		$(".approveOkDiv").unbind("click").bind("click", function(){
			var rowIds = getRowIds();
			if(!rowIds){
				$(".myMsgBox").css("display","").html("请选择记录!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
				return false;
			}
			$("form[name=batchDelForm]").submit();
		 });
		//取消
		$(".approveNoDiv").unbind("click").bind("click", function(){
			$(".batchDelDiv").css("display",'');
			$(".detailAprDiv").css("display",'');
			$(".calBatchDelDiv").css("display",'none');
			$(".batchDelHref").css("display",'none');
			$(".sglAprHref").css("display",'none');
			$("#div_partner_list a").removeClass("checked");
		});
	}
	
	//获取rowids
	function getRowIds(){
		var rowids = '';
		$("#div_partner_list a.checked").each(function(i){
			rowids += $(this).find(":hidden[name=sglRowId]").val() + ',';
		});
		$(":hidden[name=rowid]").val(rowids);
		return rowids;
	}
	
    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">伙伴列表</h3>
		<div class="act-secondary">
			<a href="<%=path%>/partner/get?opptyid=${opptyid}&openId=${openId}&publicId=${publicId}" style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a> 
		</div>
		<div class="batchDelDiv flooter" onclick="batchDel();" style="cursor:pointer;float:right;padding-right:20px;color:#000;font-size:14px;">
			<img src="<%=path %>/image/top.png" border=0 width="30px">
		</div>
		<div class="calBatchDelDiv flooter" onclick="calBatchDel();" style="display:none;cursor:pointer;float:right;padding-right:20px;color:#000;font-size:14px;margin-bottom:45px;">
			<img src="<%=path %>/image/bottom.png" border=0 width="30px">
		</div>
	</div>
		<jsp:include page="/common/navbar.jsp"></jsp:include>
		<div class="site-recommend-list page-patch">
			<div id="div_partner_list" class="list-group listview">
			
			<a href="javascript:void(0)" class="list-group-item listview-item  radio batchDelHref flooter" style="display:none;padding:.3em;padding-bottom: .3em;">
			    	<form name="batchDelForm" method="post" action="<%=path%>/partner/del?openId=${openId}&publicId=${publicId}">
			    		<!-- 审批字段 -->
						<input type="hidden" name="crmId" value="${crmId}" ><!-- crmID -->
						<input type="hidden" name="opptyid" value="${opptyid}" ><!-- 关联ID -->
						<input type="hidden" name="rowid" value="">
			    	</form>
			        <div class="list-group-item-bd ">
							<div class="thumb list-icon approveOkDiv" style="background-color:#ffffff;width:20px;height:10px;">
							 	<!-- <img src="<%=path %>/scripts/plugin/wb/css/images/approveOk.png" border="0" width="30px" title="删除"
							 	 style="background-color:#ffffff;"> -->
							 	 <input type = "button" class="btn  btn-block" style="height:2em;line-height:2em;" value="删除">
							</div>
							<div class="thumb list-icon approveNoDiv" style="background-color:#ffffff;width:20px;height:10px;margin-left:10px;">
							 	<!-- <img src="<%=path %>/scripts/plugin/wb/css/images/approveNo.png" border="0" width="30px" title="取消"
							 	 style="background-color:#ffffff;"> -->
							 	 <input type = "button" class="btn  btn-block" style="height:2em;line-height:2em;background-color: #999999;" value="取消">
							</div>
							
					</div>	
<!-- 					<div class="approveTip" style="color:red;margin-right:10px"></div> -->
					<div class="input-radio checkAllBtn" title="全选"></div>
				</a>
			
				<c:forEach items="${partnerList}" var="partner">
					<a href="<%=path%>/customer/detail?rowId=${partner.customerid}&flag=partner&openId=${openId}&publicId=${publicId}"
						class="list-group-item listview-item radio" >
						<input type="hidden" name="sglRowId" value="${partner.rowid}" ><!-- rowID -->
						<div class="list-group-item-bd">
							<div class="content" style="text-align: left">
								<h1>${partner.customername}</h1>
							<p>
								${partner.phoneoffice}
							</p>
							</div>
						</div>
						<div class="list-group-item-fd detailAprDiv" >
							<span class="icon icon-uniE603"></span>
						</div>
						<div class="input-radio none sglAprHref" style="display:none" title="选择该条记录"></div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(partnerList) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有找到数据</div>
				</c:if>
				</div>
		</div>
		<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>