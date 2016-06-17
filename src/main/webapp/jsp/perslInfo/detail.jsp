<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@page import="com.takshine.wxcrm.base.util.ZJWKUtil"%>
<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	boolean showNameFlag = false;
	if (((String)request.getAttribute("crmId")).equals(UserUtil.getCurrUser(request).getCrmId()))
	{
		showNameFlag = true;
	}
	request.setAttribute("showNameFlag", showNameFlag);

	Object openId = request.getAttribute("openId");
	Object crmId = request.getAttribute("crmId");
	String shortUrl = PropertiesUtil.getAppContext("zjwk.short.url") + ZJWKUtil.shortUrl(PropertiesUtil.getAppContext("app.content")+"/entr/access?fopenId="+openId+"&parentId="+crmId+"&parentType=dcCrm");

%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/jquery.flip.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/jquery/script.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/flip.styles.css" id="style_color"/>
<script type="text/javascript">
    $(function () {
    	shareBtnContol();//初始化分享按钮
    	initWeixinFunc();
    	initButton();
    	
    	/* var share = "${flag}";
    	if(share && share == "share"){
    		$(".myMsgBox").css("display","").html("您与${dc.opName}已建立好友关系！");
 		    $(".myMsgBox").delay(2000).fadeOut();
    	} */
    	
    	initUserTagElem();
    	changeColor();
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
	function initWeixinFunc(){
		var share = "${flag}";
		if(share && share == "share"){
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('hideOptionMenu');
			});
		}else{
			document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
				WeixinJSBridge.call('showOptionMenu');
			});
		}
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	}
    
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
    	
    	//确定按钮
    	$(".conbtn").click(function(){
    		$(":hidden[name=dateclosed]").val($("#bxDateInput").val());
    		$(":hidden[name=nextstep]").val($("#nextStep").val());
    		$(":hidden[name=desc]").val($("#expDesc").val());
    		$(":hidden[name=modifyDate]").val(new Date());
    		$("form[name=customerModify]").submit();
    	});
    	
    	//入群同意按钮
    	$(".groupAgree").click(function(){
    		groupAgree();
    	});
    	//入群拒绝按钮
    	$(".groupRefuse").click(function(){
    		groupRefuse();
    	});
    	
    	//交换名片按钮
    	$(".changecard").click(function(){
    		var obj = [];
        	obj.push({name :'userId', value :'${userRela.rela_user_id}'});
        	obj.push({name :'username', value :'${userRela.rela_user_name}'});
        	obj.push({name :'targetUId', value :'${userRela.user_id}'});
        	obj.push({name :'targetUName', value :''});
        	obj.push({name :'msgType', value :'txt'});
        	obj.push({name :'content', value :'${userRela.rela_user_name}请求与您交换名片！'});
        	obj.push({name :'relaModule', value :'System_ChangeCard'});
        	obj.push({name :'relaId', value: '${userRela.rela_user_id}'});
        	//发送名片交换申请
        	$.ajax({
    	  	      url: '<%=path%>/dcCrm/changecard',
    	  	      data: obj,
    	  	      success: function(data){
    	  	    	    if(data && data === "success"){
    	  	    	    	$(".changecard").css("display","none");
    	  	    	    	$(".gohome").css("width", "100%");
    	  	    	    	$(".myMsgBox").css("display","").html("申请发送成功！");
    	  	   		    	$(".myMsgBox").delay(2000).fadeOut();
    	  	    	    }
    	  	      }
    	  	});
    		
    	});
    	
    	//交换名片拒绝
    	$(".cancelcard").click(function(){
    		var obj = [];
        	obj.push({name :'userId', value :'${userRela.rela_user_id}'});
        	obj.push({name :'username', value :'${userRela.rela_user_name}'});
        	obj.push({name :'targetUId', value :'${userRela.user_id}'});
        	obj.push({name :'targetUName', value :''});
        	obj.push({name :'msgType', value :'txt'});
        	obj.push({name :'content', value :'${userRela.rela_user_name}拒绝了与您交换名片的请求！'});
        	obj.push({name :'relaModule', value :'System_RejectCard'});
        	obj.push({name :'relaId', value: '${userRela.rela_user_id}'});
        	//发送名片交换申请
        	$.ajax({
    	  	      url: '<%=path%>/dcCrm/changecard',
    	  	      data: obj,
    	  	      success: function(data){
    	  	    	    if(data && data === "success"){
    	  	    	    	$(".auditchangecard").css("display","none");
    	  	    	    	$(".myMsgBox").css("display","").html("发送成功！");
    	  	   		    	$(".myMsgBox").delay(2000).fadeOut();
    	  	    	    }else{
    	  	    	    	$(".auditchangecard").css("display","none");
    	  	    	    	$(".myMsgBox").css("display","").html("发送失败！");
    	  	   		    	$(".myMsgBox").delay(2000).fadeOut();
    	  	    	    }
    	  	      }
    	  	});
    		
    	});
    	
    	//同意交换名片
    	$(".agreecard").click(function(){
    		var obj = [];
        	obj.push({name :'rela_user_id', value :'${userRela.rela_user_id}'});
        	obj.push({name :'rela_user_name', value :'${userRela.rela_user_name}'});
        	obj.push({name :'user_id', value :'${userRela.user_id}'});
        	//发送名片交换申请
        	$.ajax({
    	  	      url: '<%=path%>/dcCrm/agreecard',
    	  	      data: obj,
    	  	      success: function(data){
    	  	    	    if(data && data === "success"){
    	  	    	    	$(".auditchangecard").css("display","none");
    	  	    	    	$(".myMsgBox").css("display","").html("交换名片成功！");
    	  	   		    	$(".myMsgBox").delay(2000).fadeOut();
    	  	    	    }else{
    	  	    	    	$(".auditchangecard").css("display","none");
    	  	    	    	$(".myMsgBox").css("display","").html("操作失败！");
    	  	   		    	$(".myMsgBox").delay(2000).fadeOut();
    	  	    	    }
    	  	      }
    	  	});
    		
    	});
    }
    
    //入群同意
    function groupAgree(){
    	var obj = [];
    	obj.push({name :'userId', value :'${at_party_row_id}'});
    	obj.push({name :'username', value :'${userRela.rela_user_name}'});
    	obj.push({name :'targetUId', value :'${party_row_id}'});
    	obj.push({name :'targetUName', value :''});
    	obj.push({name :'content', value :'/group/in_detail?id=${group_id}'});
    	obj.push({name :'relaId', value: '${group_id}'});
    	//发送名片交换申请
    	$.ajax({
	  	      url: '<%=path%>/dcCrm/groupAgree',
	  	      data: obj,
	  	      success: function(data){
	  	    	    if(data && data === "success"){
	  	    	    	$(".buttomBtn").css("display","none");
	  	    	    	$(".myMsgBox").css("display","").html("发送成功！");
	  	   		    	$(".myMsgBox").delay(2000).fadeOut();
	  	    	    }else{
	  	    	    	$(".myMsgBox").css("display","").html("操作失败！");
	  	   		    	$(".myMsgBox").delay(2000).fadeOut();
	  	    	    }
	  	      }
	  	});
    }
    
    //拒绝入群
    function groupRefuse(){
    	var obj = [];
    	obj.push({name :'userId', value :'${at_party_row_id}'});
    	obj.push({name :'username', value :'${userRela.rela_user_name}'});
    	obj.push({name :'targetUId', value :'${party_row_id}'});
    	obj.push({name :'targetUName', value :''});
    	obj.push({name :'content', value :'/group/out_detail?id=${group_id}'});
    	obj.push({name :'relaId', value: '${group_id}'});
    	//发送名片交换申请
    	$.ajax({
	  	      url: '<%=path%>/dcCrm/groupRefuse',
	  	      data: obj,
	  	      success: function(data){
	  	    	    if(data && data === "success"){
	  	    	    	$(".buttomBtn").css("display","none");
	  	    	    	$(".myMsgBox").css("display","").html("发送成功！");
	  	   		    	$(".myMsgBox").delay(2000).fadeOut();
	  	    	    }else{
	  	    	    	$(".myMsgBox").css("display","").html("操作失败！");
	  	   		    	$(".myMsgBox").delay(2000).fadeOut();
	  	    	    }
	  	      }
	  	});
    }
    
    function goBack(){
    	window.location.href = "<%=path%>/dcCrm/list?openId=${openId}&publicId=${publicId}";
    }
    
  //tag事件点击事件
    function initUserTagElem(){
    	$(".tagList span:not(.addBtn)").unbind("click").click(function(){
    		if($(this).hasClass("tagchecked")){
    			$(this).removeClass("tagchecked");
    			$(this).addClass("tagunchecked");
    		}else{
    			$(this).removeClass("tagunchecked");
    			$(this).addClass("tagchecked");
    		}
    	});
    }

    //随机获得 候选背景颜色 
    function randomColor(){
    	var arrHex = ["#4A148C","#01579B","#004D40","#00838F","#33691E"];
    	var strHex = arrHex[Math.floor(Math.random() * arrHex.length + 1)-1];
    	 
    	//新建一个数组,将传入的数组复制过来,用于运算,而不要直接操作传入的数组;
        /* var temp_array = new Array();
        for (arrHex index in arr) {
            temp_array.push(arrHex[index]);
        } */
    	
    	return strHex;
    }

    //改变个人标签背景色
    function changeColor() {
    	$(".tagchecked").each(function() {
    		var hex = randomColor();
    		$(this).css("color", hex);
    	});	 
    }
    
    //检查查看者的必填信息 add by zhihe
    function checkLooker(name, moblie)
    {
    	if(''==name || 'null'==name || 'null'==moblie ||''==moblie)
   		{
    		window.location.href = "<%=path%>/dcCrm/modify?rowId=${looker.crmId}&openId=${looker.openId}&publicId=${publicId}";
   		}
    }
    //添加引导 add by zhihe
    function goHome()
    {
    	window.location.href = "<%=path%>/home/index?openId=${looker.openId}&publicId=${publicId}";
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
			<h3><c:if test="${dc.opName ne '' && !empty(dc.opName)}">${dc.opName}的名片</c:if><c:if test="${dc.opName eq '' || empty(dc.opName)}">${wxuser.nickname }的名片</c:if></h3>
		</c:if>
		<c:if test="${flag eq '' || empty(flag)}">
			<c:if test="${showNameFlag ne 'true'}">
				<h3 style="padding-right:45px;">我的名片</h3>
			</c:if>
			<c:if test="${showNameFlag eq 'true'}">
				<h3><c:if test="${dc.opName ne '' && !empty(dc.opName)}">${dc.opName}的名片</c:if><c:if test="${dc.opName eq '' || empty(dc.opName)}">${wxuser.nickname }的名片</c:if></h3>
			</c:if>
		</c:if>
	</div>
	
	<div class="sponsorListHolder">

				<div class="sponsor">
					<div class="sponsorFlip">
						<div style="margin:5px;background-color:#fff;font-size:14px;min-height:180px;border-left:1px solid #ddd;border-top:1px solid #ddd;border-right:2px solid #ccc;border-bottom:2px solid #bbb;"> 
							<div style="width:100%;">
								<div style="float:left;width:85px;padding:13px;">
									<img src="${wxuser.headimgurl }" style="border-radius:0px; width: 60px; height: 60px; ">
								</div>
							<!-- begin二维码 -->
							<div style="margin-top: -30px;float: right;">   
								<jsp:include page="../qrcode/msg.jsp">
									<jsp:param value="true" name="includeFlag"/>
								</jsp:include>
							</div>
							<!-- end二维码 -->
								<div style="padding:8px;line-height:23px;">
									<span style="">${dc.opName}</span><br/>
									<span style="color:#999;">${dc.opCompany}</span><br/> 
									<span style="color:#999;">${dc.opDuty}</span>
								</div>
							</div>
							<div style="clear:both;"></div>
							<div style="padding: 0px 0px 0px 10px;font-size:14px;margin-top: -30px;">
								<div style="float:left;line-height: 20px;">
									<c:if test="${isMy == 'true' }">
										<span style="color:#AAA;">手机：&nbsp;</span><span style="color:#888;"><a href="tel:${dc.opMobile}">${dc.opMobile}</a></span><br/>
									</c:if>
									<span style="color:#AAA;">邮箱：&nbsp;</span><span style="color:#888;">${dc.opEmail}</span><br/>
									<span style="color:#AAA;">微信：&nbsp;</span><span style="color:#888;">${dc.opWeixin}</span> 
								</div>
								<div style="float:right;">
									
								</div>
							</div>

						</div>
					</div>
					
					<div class="sponsorData">
						<div class="sponsorDescription">
							${dc.opSignature }
						</div>
						<div class="sponsorURL">
							${dc.opAddress }
						</div>
					</div>
				</div>

    	<div class="clear"></div>
    </div>
	
		

	<div class="site-recommend-list" style="display:none;">
		<div class="list-group1 listview" style="margin:20px 5px;border:1px solid #ddd;">
			<%--<a href="<%=path%>/userRela/urelalist?userId=${party_row_id}"
					class="list-group-item listview-item" style="border-top: 1px solid #ddd;height:70px;">
				<div style="width:100%;">
				<div style="margin-left:10px;">教育背景</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			 --%>
			<a href="${zjrm_url}/out/group/sharelist/${party_row_id}"
					class="list-group-item listview-item" style="height:70px;">
				<div style="width:100%;">
				<c:if test="${flag eq '' || empty(flag)}">
				<div style="">我的社区</div>
				</c:if>
				
				<c:if test="${flag ne '' && !empty(flag)}">
				<div style="">TA的社区</div>
				</c:if>
				
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
		</div>
	</div>			
	
	<c:if test="${fn:length(tagList) >0 }">
	<div style="width:100%;padding:10px 10px;font-size:14px;color:#666;">
		个人标签	
		<c:if test="${flag eq '' || empty(flag)}">
			<div style="float:right;"><a href="${zjrm_url}/out/user/tags/${party_row_id}">编辑标签</a></div>
		</c:if>
	</div> 
	<div class="site-recommend-list" style="margin:5px;">
		<div class="tagList ui-body-d ui-corner-all info" style="padding: 0.8em;float: left;width: 100%;background-color:#fff;border:1px solid #ddd;">
			<c:forEach items="${tagList}" var="tag">
			    <span class="tagchecked" style="line-height:20px;float: left;margin-top:10px;">${tag.tagName}</span>
			</c:forEach>
		</div>
	</div> 
	</c:if>
	
	<!-- 入群申请审核 -->
	<c:if test="${btnFlag == 'approval_group' && isInGroupFlag != 'isInGroup'}">
		<div class="flooter buttomBtn" >
			<div class="button-ctrl" style=" margin-top: -2px;">
				<fieldset class="">
					<div class="ui-block-a groupRefuse">
						<a href="javascript:void(0)" class="btn btn-default btn-block"
							style="font-size: 14px;">拒绝</a>
					</div>
					<div class="ui-block-a groupAgree">
						<a href="javascript:void(0)" class="btn btn-success btn-block"
							style="font-size: 14px;">同意入群</a>
					</div>
				</fieldset>
			</div>
			<%--
			<span class="ui-block-a groupAgree buttomLeft" >
				同意入群
			</span>
			<span class="ui-block-a groupRefuse buttomRight" >
				拒绝
			</span>
			 --%>
		</div>
	</c:if>
	
	<!-- 交换名片 -->
	<c:if test="${isfriend == 'false'}">
			<div class="flooter" style="width: 100%"
					style="z-index: 99999; opacity: 1; background: #FFF; border-top: 1px solid #ddd;">
					<div class="button-ctrl"
						style="margin-bottom: 5px">
						<fieldset class="">
							<div class="ui-block-a  changecard">
								<a href="javascript:void(0)" class="btn" onclick="checkLooker('${looker.opMobile}','${looker.opName}')"
									style="font-size: 14px; width: 100%; background-color:RGB(75, 192, 171)">跟TA交换名片</a>
							</div>
							<div class="ui-block-a gohome">
								<a href="javascript:void(0)" class="btn" onclick="goHome()"
									style="font-size: 14px; width: 100%; background-color:RGB(75, 192, 171)">去首页</a>
							</div>
						</fieldset>
					</div>
				</div>
	
	
	
		<%-- <div class="flooter changecard" style="width: 50%">
			<div class="ui-block-a "
						style="width: 100%; margin: 5px 0px 1px 0px; margin-bottom: 5px;">
						<a href="javascript:void(0)" class="btn" onclick="checkLooker('${looker.opMobile}','${looker.opName}')"
							style="font-size: 14px; width: 100%; background-color:RGB(75, 192, 171)">跟TA交换名片</a>
			</div>
		</div>
		<div class="gohome" style="width: 48%; margin-top: 136px;margin-left: 160px;position: fixed;">
			<div class="ui-block-a "
						style="width: 100%; margin: 5px 0px 1px 0px; margin-bottom: 5px;">
						<a href="javascript:void(0)" class="btn" onclick="goHome()"
							style="font-size: 14px; width: 100%; background-color:RGB(75, 192, 171)">去首页</a>
			</div>
		</div> --%>
	</c:if>
	
	<!-- 交换名片审核 -->
	<c:if test="${changecardflag == 'true'}">
		<div class="flooter auditchangecard">
			<div class="button-ctrl" style=" margin-top: -2px;">
				<fieldset class="">
					<div class="ui-block-a cancelcard">
						<a href="javascript:void(0)" class="btn btn-default btn-block"
							style="font-size: 14px;">拒绝</a>
					</div>
					<div class="ui-block-a agreecard">
						<a href="javascript:void(0)" class="btn btn-success btn-block"
							style="font-size: 14px;">同意</a>
					</div>
				</fieldset>
			</div>
		</div>
	</c:if>

	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">&nbsp;</div>
	
	<jsp:include page="/common/wxjs.jsp" />
	<script type="text/javascript">
		<%--link: "https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=PropertiesUtil.getAppContext("wxcrm.appid")%>&redirect_uri="+encodeURIComponent('<%=PropertiesUtil.getAppContext("app.content")%>/entr/access?fopenId=${openId}&parentId=${crmId}&parentType=dcCrm')+"&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect",//window.location.href + "&shareBtnContol=yes--%>
	    var img = "${wxuser.headimgurl}";
	    if(!img){
	    	img = "http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png";
	    }
		wx.ready(function () {
		  var opt = {
			  title : "${dc.opName}的名片",
		      desc : "公司：${dc.opCompany}\r\n  职位：${dc.opDuty}",
			  link: "<%=shortUrl%>",
			  imgUrl: img 
		  };
		  wxjs_initMenuShare(opt);
	  });
	</script>
</body>
</html>