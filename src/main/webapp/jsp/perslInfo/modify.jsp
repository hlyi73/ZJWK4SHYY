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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
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
    	shareBtnContol();//初始化分享按钮
    	//initWeixinFunc();
    	initButton();
    	
    	var share = "${flag}";
    	if(share){
    		$(".myMsgBox").css("display","").html("您与${dc.opName}已建立好友关系！");
 		    $(".myMsgBox").delay(2000).fadeOut();
    	}
	});
    
  //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			return false;
    		});
    	}
    }
    
    //微信网页按钮控制
	/* function initWeixinFunc(){
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
    //初始化按钮
    function initButton(){
    	
    	//修改按钮
    	$(".operbtn").click(function(){
    		$(".operbtn").css("display","none");
    		$("#update").css("display","none");
    		$(".nextCommitExamDiv").css("display","");
    		$(".uptShow").css("display","none");
    		$(".uptInput").css("display","");
    	});
    	
    	//取消按钮
    	$(".canbtn").click(function(){
    		$(".operbtn").css("display","");
    		$(".nextCommitExamDiv").css("display","none");
    		$("#update").css("display","");
    		$(".uptShow").css("display","");
    		$(".uptInput").css("display","none");
    	});
    	  $(".display_member_sel").click(function(){
          	$(".display_member_sel").attr("src", "<%=path%>/image/checkbox-no2x.png");
          	var s = $(this).attr("src");
          	if(s.indexOf("checkbox2x") !== -1){
          		$(this).attr("src", "<%=path%>/image/checkbox-no2x.png");
          	}else{
          		$(this).attr("src", "<%=path%>/image/checkbox2x.png");
          		$(":hidden[name=opGender]").val($(this).attr("val"));
          	}
          });
    	//确定按钮
    	$(".conbtn").click(function(){
    		
  			var opName = $("#opName").val();
	  		if(!opName){
	  			$('#opName').val('').attr("placeholder","请输入姓名");
	  			return;
	  		}
	  		var opMobile = $("#opMobile").val();
	  		if(!opMobile){
	  			$('#opMobile').val('').attr("placeholder","请输入联系电话");
	  			return;
	  		}else{
				var exp = /^1[3|4|5|8][0-9]{9}$/;
  				var r = exp.test(opMobile);
	  				if (!r) {
	  					$('#opMobile').val('').attr("placeholder", "格式不正确,请输入11位为手机号码!");
	  					return;
	  				}
  				}
    		$(":hidden[name=dateclosed]").val($("#bxDateInput").val());
    		$(":hidden[name=nextstep]").val($("#nextStep").val());
    		$(":hidden[name=desc]").val($("#expDesc").val());
    		$(":hidden[name=modifyDate]").val(new Date());
    		$("form[name=customerModify]").submit();
    	});
    	
    }
    
    function goBack(){
    	window.location.href = "<%=path%>/dcCrm/list?openId=${openId}&publicId=${publicId}";
    }
    function showDisplay(){
    	if($("#displayTable").css("display")=='none'){
      		$("#displayTable").css("display","");
      		$(".showAll").html('隐藏&nbsp;↑');
    	}else{
    		$("#displayTable").css("display","none");
    		$(".showAll").html('显示全部&nbsp;↓');
    	}
    }
    </script>

<style>
table tr td {
	text-align: center; 
	line-height: 25px; 
	vertical-align: middle;
}
.site-card-view .card-info table tr th {
	width:70px;
	font-size: 14px;
	color: #999;
	text-align: left;
	padding-left:10px;
}
.site-card-view .card-info table tr td {
	font-size: 14px;
	text-align: left;
}
</style>
</head>
<body>
	<div id="site-nav" class="navbar" style="background-color:RGB(75, 192, 171);width: 100%;">
		<c:if test="${flag eq '' || empty(flag)}"><jsp:include page="/common/back.jsp"></jsp:include></c:if>
		<c:if test="${flag ne '' && !empty(flag)}">
			<h3>${dc.opName}的资料</h3>
		</c:if>
		<c:if test="${flag eq '' || empty(flag)}">
			<h3 style="padding-right:45px;">我的资料</h3>
			<%--<div class="act-secondary">
				<a href="<%=path%>/dcCrm/make?openId=${openId}&publicId=${publicId}" style="font-size:16px;font-weight:bold;color:#fff;">
					<img src="<%=path %>/image/zjwk_qrcode_2.png" width="28px;">
				</a>  --%>
			</div>
		</c:if>
	</div>
	<div class="view site-recommend">
		<div class="recommend-box">
			<!-- <h4>详情</h4> -->
			<form name="customerModify" action="<%=path%>/dcCrm/update"
				method="post" novalidate="true">
				<input type="hidden" name="publicId" value="${publicId}" /> <input
					type="hidden" name="openId" value="${openId}" /> <input
					type="hidden" name="crmId" value="${crmId}" />
				
			<%-- 	<div class="card-info"
						style="height: 180px; background-image: url('<%=path%>/image/back-img.png');">
					</div>
					<div style="width: 100%; text-align: right; background: #fff;">
						<div style="display: inline-flex; font-size: 20px;margin-right:10px;">
								<h2 style="color: #A09E9E;">${operator.opName }</h2>
							</div>
						<img src="${wxuser.headimgurl }"
							style="border-radius:0px; width: 100px; height: 100px; margin: -50px 15px 0 0; border: 5px solid #fff;">
					</div>
					
					<div style="width:100%;text-align:center;margin-top:-180px;color:#fff;font-size:20px;font-weight:bold; font-family: 'Microsoft YaHei';">
						${dc.opSignature}
					</div> 
					<div style="clear:both;margin-top:150px"></div>--%>
				
				<div class="site-card-view">
					<div class="card-info" style="line-height:3em;font-size: 20px;">
						<table style="border-bottom:10px solid #f0f0f0;">
							<tbody>
								<tr>
									<th>姓名：</th>
									<td class=" uptShow" style="text-align: left;font-size: 16px;">${dc.opName}</td>
									<td class="uptInput" style="display: none;font-size: 16px;"><input
										type="text" name="opName" id="opName" value="${dc.opName}"
										placeholder="请输入姓名" style="border: none;"></td>
											<td class="uptInput" style="display: none;text-align: right;"><span style="color:red;">*</span></td>
								</tr>
								<tr>
									<th>性别：</th>
									<td class="uptShow" style="text-align: left;font-size: 16px;">
										<c:if test="${dc.opGender == '0'}">男</c:if>
										<c:if test="${dc.opGender == '1'}">女</c:if>
									</td>
										<input type="hidden" name="opGender" id="opGender" value="${dc.opGender}">
									<td class="uptInput" style="display: none;line-height: 25px;padding-top: 0px; font-size: 16px;">
									   <div style="margin-left: 15px; float: left;">
						男 <c:if test="${dc.opGender == '0'}"><img src="<%=path%>/image/checkbox2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="display_member_sel" val="0">
							</c:if>
							<c:if test="${dc.opGender == '1'}"> 
							<img src="<%=path%>/image/checkbox-no2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="display_member_sel" val="0"></c:if>
					</div>
					<div style="margin-left: 15px; float: left;">
						女 <c:if test="${dc.opGender == '1'}"><img src="<%=path%>/image/checkbox2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="display_member_sel" val="1">
							</c:if>
							<c:if test="${dc.opGender == '0'}"> 
							<img src="<%=path%>/image/checkbox-no2x.png"
							style="cursor: pointer; margin-left: 5px; width: 25px;"
							class="display_member_sel" val="1"></c:if>
					</div>
									   
								<%-- 	    <input type="radio" name="opGender" id="opGender" value="0" style="width:20px;"
									       <c:if test="${dc.opGender == '0'}">checked="checked"</c:if>
									    >男
										<input type="radio" name="opGender" id="opGender" value="1" style="width:20px;"
										   <c:if test="${dc.opGender == '1'}">checked="checked"</c:if>
										>女 --%>
									</td>
										
											<td class="uptInput" style="display: none;text-align: right;"><span style="color:red;">*</span></td>
								</tr>
								<tr>
									<th>手机：</th>
									<td class="uptShow" style="text-align: left;font-size: 16px;">${dc.opMobile}</td>
									<td class="uptInput" style="display: none;font-size: 16px;"><input
										type="number" name="opMobile" id="opMobile" value="${dc.opMobile}"
										placeholder="请输入手机号码" style="border: none;" ></td>
										
											<td class="uptInput" style="display: none;text-align: right;"><span style="color:red;">*</span></td>
								</tr>
								</tbody>
								</table>
								<table style="border-bottom:10px solid #f0f0f0;">
								<tbody>
									<tr>
									<th>公司：</th>
									<td class="uptShow"  style="text-align: left;font-size: 16px;">${dc.opCompany}</td>
									<td class="uptInput" style="display: none;font-size: 16px;"><input
										type="text" name="opCompany" id="opCompany"
										value="${dc.opCompany}" placeholder="请填写公司名称" style="border: none;"></td>
								</tr>
									<tr>
									<th>职位：</th> 
									<td class="uptShow"  style="text-align: left;font-size: 16px;">${dc.opDuty}</td>
									<td class="uptInput" style="display: none;font-size: 16px;"><input
										type="text" name="opDuty" id="opDuty" value="${dc.opDuty}"
										placeholder="请填写职位" style="border: none;"></td>
								</tr>
									</tbody>
								</table>
								<table style="display:none" id="displayTable">
								<tbody>
								<tr>
									<th>邮箱：</th>
									<td class="uptShow"  style="text-align: left;font-size: 16px;">${dc.opEmail}</td>
									<td class="uptInput" style="display: none;font-size: 16px;"><input
										type="text" name="opEmail" id="opEmail" value="${dc.opEmail}"
										placeholder="请输入邮箱" style="border: none;"></td>
								</tr>
								<tr>
									<th>地址：</th>
									<td class="uptShow"  style="text-align: left;font-size: 16px;">${dc.opAddress}</td>
									<td class="uptInput" style="display: none;font-size: 16px;"><textarea
											name="opAddress" id="opAddress" rows="" cols=""
											placeholder="请填写地址" style="border: none;">${dc.opAddress}</textarea></td>
								</tr>
								 <tr>
									<th>微信号：</th> 
									<td class="uptShow"  style="text-align: left;font-size: 16px;">${dc.opWeixin}</td>
									<td class="uptInput" style="display: none;font-size: 16px;"><input
										type="text" name="opWeixin" id="opDuty" value="${dc.opWeixin}"
										placeholder="请填写微信号" style="border: none;"></td>
								</tr>
							<%-- 	<tr>
									<th>签名：</th>
									<td class="uptShow" style="text-align: left;">${dc.opSignature}</td>
									<td class="uptInput" style="display: none"><textarea
											name="opSignature" id="opSignature" rows="" cols=""
											placeholder="请填写个性说明">${dc.opSignature}</textarea></td>
								</tr> --%>

							
							<%-- 	<tr>
									<th>部门：</th>
									<td class="uptShow"  style="text-align: left;">${dc.opDepart}</td>
									<td class="uptInput" style="display: none"><input
										type="text" name="opDepart" id="opDepart"
										value="${dc.opDepart}" placeholder="请填写部门"></td>
								</tr> --%>
							</tbody>
						</table>
						<div class="container hy bgcw msgListShowAll"
	style="font-size: 14px; text-align: center; padding-top: 5px; padding-bottom: 5px">
	<a class="showAll"
		style="cursor: pointer; color: #51BBEC; padding-top: 5px; padding-bottom: 5px;"
		onclick="showDisplay();" href="javascript:void(0)">显示全部&nbsp;↓</a>
</div>
					</div>
				</div>
			</form>
			
			<c:if test="${flag eq '' || empty(flag)}">
				<div id="update" class="flooter"
					style="border-top: 1px solid #ddd; background: #FFF; z-index: 99999; opacity: 1; padding-right: 45px;">
					<div class="ui-block-a"
						style="float: left; margin: 10px 0px 10px 10px;">
						<img src="<%=path%>/scripts/plugin/menu/images/upmenu.png"
							width="30px" onclick="swicthUpMenu('update')">
					</div>
					<div class="ui-block-a operbtn"
						style="width: 100%; margin: 5px 0px 1px 0px; margin-left: 50px; margin-bottom: 5px;padding-right:25px;">
						<a href="javascript:void(0)" class="btn"
							style="font-size: 14px; width: 100%; background-color:RGB(75, 192, 171)">修改</a>
					</div>
				</div>
				<!--确定/取消按钮-->
				<div id="confirmdiv" class="nextCommitExamDiv flooter"
					style="display: none; z-index: 99999; opacity: 1; background: #FFF; border-top: 1px solid #ddd;">
					<div class="ui-block-a"
						style="float: left; margin: 10px 0px 10px 10px;">
						<img src="<%=path%>/scripts/plugin/menu/images/upmenu.png"
							width="30px" onclick="swicthUpMenu('confirmdiv')">
					</div>
					<div class="button-ctrl"
						style="margin-left: 50px; margin-top: -2px;">
						<fieldset class="">
							<div class="ui-block-a canbtn">
								<a href="javascript:void(0)" 
									class="btn btn-default btn-block" style="font-size: 14px;">取消</a>
							</div>
							<div class="ui-block-a conbtn">
								<a href="javascript:void(0)" 
									class="btn btn-success btn-block" style="font-size: 14px;">确定</a>
							</div>
						</fieldset>
					</div>
				</div>
			</c:if>
		</div>
	</div>
    <div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	<br/><br/><br/><br/><br/>
</body>
</html>