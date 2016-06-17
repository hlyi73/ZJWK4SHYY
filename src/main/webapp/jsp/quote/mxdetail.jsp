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
    	var assignerid = '${ga.assignerid}';
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
	    		var productnumber = $("input[name=productnumber]").val();
	    		var productdecount = $("input[name=productdecount]").val();
	    		var exp1 = /^([1-9][0-9]*)$/;
	    		var exp2 = /^([1-9][0-9]{1,2})$/;
	    		var r = exp1.test(productnumber);
	    		var t = exp2.test(productdecount);
	    		if(!r){
	    			$("input[name=productnumber]").val('').attr("placeholder","输入的数量不合法,请重新输入");
	    		    return;
	    		}
	    		if(!t){
	    			$("input[name=productdecount]").val('').attr("placeholder","输入的折扣不合法,请重新输入");
	    		    return;
	    		}
	    		$(":hidden[name=optype]").val('upd');
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
/* 	function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
    //删除
    function delData(){
    	if(confirm("您确定要删除这个报价明细吗?")){
	    	$(":hidden[name=optype]").val('del');
			$("form[name=detailForm]").submit();
    	}
    }
    
</script>
</head>
<body>
	<div id="site-nav" class="navbar">
	    <jsp:include page="/common/back.jsp"></jsp:include>
			<div id="update" class="operbtn" style="display:none;float:right;padding:0px 12px 0px 12px;">修改</div>
		<h3 style="padding-right:45px;">报价明细详情</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="view site-recommend detailInfo">
		<div class="recommend-box">
			<!-- <h4>详情</h4> -->
			<form action="<%=path%>/quote/updatemxquote" method="post" name="detailForm" >
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="openId" value="${openId}" /> 
				<input type="hidden" name="crmId" value="${crmId}" />
				<input type="hidden" name="rowid" value="${rowId}" />
				<input type="hidden" name="assignerid" value="${ga.assignerid}" />
				<input type="hidden" name="parentid" value="${parentId}" />
				<input type="hidden" name="productid" value="${ga.productid}" />
				<input type="hidden" name="optype" value="" />
				<input type="hidden" name="name" value="${ga.name}" />
				<input type="hidden" name="orgId" value="${orgId}" />
				<input type="hidden" name="productamount" value="${ga.productamount}" />
				<h3 class="wrapper">基本信息</h3>
				<div class="site-card-view">
					<div class="card-info">
						<table>
							<tbody>
								<tr>
									<th>产品名称：</th>
									<td>${ga.productname}</td>
								</tr>
								<tr>
									<th>产品型号：</th>
									<td>${ga.producttype}</td>
									
								</tr>
								<tr>
									<th>产品单价：</th>
									<td>${ga.productamount}元</td>
								</tr>
								<tr>
									<th>产品数量：</th>
									<td class="uptShow">${ga.productnumber}</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="productnumber" id="productnumber" value="${ga.productnumber}" maxlength="30"
										placeholder="请输入产品数量"></td>
								</tr>
								<tr>
									<th>产品折扣：</th>
									<td class="uptShow">${ga.productdecount}%</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="productdecount" id="productdecount" value="${ga.productdecount}" maxlength="30"
										placeholder="请输入产品折扣"></td>
								</tr>
								<tr>
									<th>合计：</th>
									<td>${ga.producttotal}元</td>
								</tr>
								<tr>
									<th>责任人：</th>
									<td>${ga.assignername}</td>
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
		
		<a href="javascript:void(0)" onclick="delData();"><div class="_index_nav" style="bottom:150px;">删除</div></a>
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