<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- comlibs page -->
<%@ include file="/common/comlibs.jsp"%>
<!-- js-->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"></script>
<script src="<%=path%>/scripts/plugin/jquery/ui/jquery.ui.js"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery.fullPage.min.js"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"></script>
<!-- css-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/acttemp/tplist.css">
<link rel="stylesheet" href="<%=path%>/css/fullstyle.css">
<link rel="stylesheet" href="<%=path%>/css/page.css">

<script type="text/javascript">
$(function () {
	initWeixinFunc();
	initFullPage();
});

//微信网页按钮控制
function initWeixinFunc(){
	//隐藏顶部
	document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
		WeixinJSBridge.call('showOptionMenu');
	});
	//隐藏底部
	document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
		WeixinJSBridge.call('hideToolbar');
	});
}

//全屏页面
function initFullPage(){
	$.fn.fullpage({
		anchors: ['page1', 'page2', 'page3', 'page4'],
		navigation: true
	});
	$(".section").each(function(){
		$(this).css("display","");
	});
	$("div").attr("contenteditable", "false");
	//close window
	$(".closeWin").click(function(){
		window.location.href = "<%=path%>/activity/list?sourceid=ecc933e6e2f34803b1dc786d36a126e5&source=RM";
	});
	//复制
	$(".activity_content").append($("#bmDiv").html());
	$("#bmDiv").remove();
	//保存按钮
	$(".saveParticipantBtn").click(function(){
		saveParticipant();
	});
}

//添加会议议程
function saveParticipant(){
	
	if(validate_participant()){
		return;
	}
	var dataObj = [];
	dataObj.push({name:'activityid', value: '${activity.id}' });
	dataObj.push({name:'sourceid', value: '${sourceid}' });
	dataObj.push({name:'source', value: '${source}' });
	dataObj.push({name:'opName', value: $("input[name=opName]").val() });
	dataObj.push({name:'opDuty', value: $("input[name=opDuty]").val()});
	dataObj.push({name:'opCompany', value: $("input[name=opCompany]").val() });
	dataObj.push({name:'opSignature', value: $("textarea[name=opSignature]").val() });
	dataObj.push({name:'opMobile', value: $("input[name=opMobile]").val() });
	$.ajax({
        type: 'get',
        url: '<%=path%>/participant/save',
		data : dataObj,
		dataType : 'text',
		success : function(data) {
			if(!data || data === '-1'){
    	    	alert("保存失败!");
			}else{
				alert("报名成功，感谢参与!");
			}
		}
	});
}

//验证所有的参数是否都已经填写
function validate_participant() {
	var flag = false;
	$("#activity_participant_form").find(":hidden").each(function() {
		var val = $(this).val();
		if (!val) {
			flag = true;
		}
	});
	$("#activity_participant_form").find("input").each(function() {
		var val = $(this).val();
		if (!val) {
			flag = true;
		}
		if( $(this).attr("name")== 'opMobile'){
				var exp = /^1[3|4|5|8][0-9]{9}$/;
				var r = exp.test($("input[name=opMobile]").val());
  				if (!r) {
  					$("input[name=opMobile]").val('').attr("placeholder", "格式不正确,请输入11位为手机号码!");
  					return true;
  				}
				}
	});
	if (flag) {
		$(".myMsgBox").css("display", "").html("填写不完整!请您将带有*标签的字段都填上!");
		$(".myMsgBox").delay(2000).fadeOut();
		return true;
	}
}

</script>
</head>
<body class="ofhide">

    <!--关闭按钮  -->
    <div class="closeWin">关闭</div>
    
    <!--内容 -->
    ${activity.content}
	<!--报名区域 统计区域  -->
	<div id="bmDiv">
	    <div class="section table">
			<div class="tableCell" >
				<div style="font-size: 15px;text-align: right;line-height: 1.4em;padding: 1em 0;margin-top:-3em;margin-right:1em;">
					<span id="read_span" style="background-color: #efefef;border-radius: 10px;padding: 5px;margin-left: 5px">阅读(${visit})</span>
					<span id="praise-span" style="background-color: #efefef;border-radius: 10px;padding: 5px;margin-left: 5px">
					<c:if test="${ispraise==true}"><a href="javascript:praise()" id="praise">赞(${praise})</a></c:if>
					<c:if test="${ispraise==false}">赞(${praise})</c:if>
					</span>
					<c:if test="${forwardcount ne '' }">
						<span id="read_span" style="background-color: #efefef;border-radius: 10px;padding: 5px;margin-left: 10px">转发(${forwardcount})</span>
					</c:if>
					<c:if test="${optype eq 'owner' }">
						<a href="<%=path%>/activity/count?id=${activity.id }&sourceid=${sourceid}&source=${source}"><span id="read_span" onclick="countActivity();" style="cursor:pointer;background-color: #efefef;border-radius: 10px;padding: 5px;margin-left: 10px">统计</span></a>
					</c:if>
				</div>
				<c:if test="${optype ne 'owner' }">
					<div class="" style="height: 260px;">
						<div class="form-group">
							<input name="opName" type="text" placeholder="您的姓名">
						</div>
						<div class="form-group">
							<input name="opMobile" type="number" placeholder="联系电话">
						</div>
						<div class="form-group">
							<input name="opCompany" type="text" placeholder="公司名称">
						</div>
						<div class="form-group">
							<input name="opDuty" type="text" placeholder="您的职位">
						</div>
						<div class="button-ctrl">
							<fieldset class="">
								<div class="ui-block-a" style="width: 100%;">
									<a href="javascript:void(0)" class="btn btn-block saveParticipantBtn" style="font-size: 16px;">提交</a>
								</div>
							</fieldset>
						</div>
					</div>
				</c:if>
			</div>
	    </div>
	</div>
	
	<!-- 分享JS区域 -->
	<script src="<%=path%>/scripts/util/share.util.js" ></script>
	<!-- 分享JS区域 -->
	<script type="text/javascript">
	    var redirectUri  = "${appcontent}activity/share%3fid%3d${activity.id}%26fopenId%3d${sourceid}";
		var dataForWeixin = {
			appId:"${appid}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",
			url : "https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appid}&redirect_uri="
					+ redirectUri
					+ "&response_type=code&scope=snsapi_userinfo&state=share#wechat_redirect",
			title : "${activity.title }",
			desc : "活动开始日期：${activity.start_date}",
			fakeid : "",
			callback : function() {}
		};
	</script>
</body>
</html>