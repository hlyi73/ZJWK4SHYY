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
    	//shareBtnContol();//初始化分享按钮
    	//initWeixinFunc();
    	gotopcolor();
    	
    	//消息相关
    	showMessage(0,10);//异步加载消息
//     	showCustomerMsg();//异步加载传播消息
    	
    	initCustomerReplyMsg();//初始化传播回复消息
	});
    
    
   /*  //微信网页按钮控制
	function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
	function gotopcolor(){
    	$(".gotop").css("background-color","rgba(213, 213, 213, 0.6)");
    }
    
	//查看所有的回复内容
    function showMessage(c, p){
    	var dataObj = [];
    	dataObj.push({name:'relaModule', value: 'ArticleInfo'});
    	dataObj.push({name:'relaId', value: '${id}'});
    	dataObj.push({name:'currpage', value: c || '0' });
    	dataObj.push({name:'pagecount', value: p || '10' });
    	if(c){
	     	 $(".msgListShowAll").css("display","none");
	    }
    	$.ajax({
 		   type: 'get',
 		   url: '<%=path%>/msgs/asynclist',
 		   data: dataObj || {},
 		   dataType: 'text',
 		   success: function(data){
 			  var d = JSON.parse(data);
			  $(".msgListContainer ul").empty();
		      $(d).each(function(){
			 	  var username = "";
			 	  if(this.userid == '${crmId}'){
			 		  username = "我";
			 	  }else{
			 		  username = this.username;
			 	  }
			 	  var createTime = this.createTime;
			 	  var dateStr = (parseInt(createTime.month)+1) +  '-' + createTime.date+"  "+createTime.hours+":"+createTime.minutes;
			 	  
			      var html= '';
				      html += '<li  style="border-bottom: #eff2f5 dashed 1px;display: block;position: relative;padding: 10px 0;id='+this.relaId+'>';
				      html += '  <div class="ct-box" style="display: block;margin-left: 0px;">';
				      html += '  <p class="ct-user" style="margin-bottom: 6px;">';
				      html += '    <a target="_blank" href="javascript:void(0)">';
				      if(null==this.targetUName||""==this.targetUName){
   				    	  html+= username+'</a> :';
   				      }else{
   				    	  html+= username+' 回复 '+this.targetUName+'</a> :';
   				      }
				      html += '    <span style="color: #bdbdbd;float: right;font-size: 12px;">'+ dateStr +'</span>';
				      html += '  </p>';
				      html += '  <p class="ct-reply" style="color: #555;min-height: 15px;padding-right: 10px;">';
				      html +=    this.content;
				      html += '   <span targetUId="'+ this.userId +'" targetUName="' + this.username +'" relaId="'+ this.relaId +'" class="replySinPer" style="cursor:pointer;  float:right; color: #bdbdbd;">回复</span>';
				      html += '  </p>';
				      html += '  </div>';
				      html += '</li>';
			     $(".msgListContainer ul").append(html);
			  });
		      //控制显示与隐藏 按钮
		      if(d.length === 0){
		    	  $(".msgTitle").css("display","none");//标头
		      }else{
		    	  $(".msgTitle").css("display","");//标头
		      }
		      if(d.length < 5 || p === '9999'){
				  $(".msgListShowAll").css("display","none"); //查看全部
			  }else{
				  $(".msgListShowAll").css("display",""); //查看全部
			  }
		      //
		      initCustomerReplyMsg();
 		   }
 		});
    }
    
    
    //查看所有的消息
    function showAllMessage(){
    	showMessage('0','9999');
    }
    //初始化传播回复消息
    function initCustomerReplyMsg(){
    	var msgCon = $(".msgContainer"),
    	    inputTxt = msgCon.find("input[name=inputMsg]"),//输入的文本框
    	    targetUId = msgCon.find("input[name=targetUId]"),//目标用户ID
    	    targetUName = msgCon.find("input[name=targetUName]"),//目标用户名
    	    subRelaId = msgCon.find("input[name=subRelaId]"),//子关联ID
    	    examinerSend = msgCon.find(".examinerSend");//发送按钮
    	
    	    $(".msgListContainer > span > a").unbind("click").bind("click", function(){
    	    	   var uid = $(this).attr("targetUId"),
    	    	       uname = $(this).attr("targetUName"),
    	    	       r = $(this).attr("relaId");
    	    	   inputTxt.attr("placeholder","回复  " + uname);
    	    	   targetUId.val(uid);
    	    	   targetUName.val(uname);
    	    	   relaId.val(r);
    	    	   $(".msgContainer").css("display","");
    	    	}); 
    	    	    
   	    	//点击里层 容器 中的 回复 按钮 
   	    	$(".msgListContainer").find(".replySinPer").unbind("click").bind("click", function(){
   	    		var uid = $(this).attr("targetuid"),
			 	        uname = $(this).attr("targetuname"),
			 	        r = $(this).attr("relaid");
   	    		   inputTxt.val('');
		    	   inputTxt.attr("placeholder","回复  " + uname);
		    	   targetUId.val(uid);
		    	   targetUName.val(uname);
		    	   subRelaId.val(r);
		    	   $(".msgContainer").css("display","");
   	    	});
   	    	
		//发送消息
		examinerSend.unbind("click").bind("click", function() {
			sendCustomerMsg({
				v : inputTxt.val(),
				tuid : targetUId.val(),
				tuname : targetUName.val(),
				subRelaId : subRelaId.val()
			});
			inputTxt.val('');
			inputTxt.attr("placeholder", "回复  ");
			targetUId.val('');
			targetUName.val('');
			subRelaId.val('');
		});
	}

	//发送传播回复消息
	function sendCustomerMsg(obj) {
		if (!obj.v || obj.v.length > 255) {
			$(".msgContainer").find("input[name=inputMsg]").attr("placeholder",
					"输入不合法!");
			return;
		}
		var dataObj = [];
		dataObj.push({
			name : 'userId',
			value : '${crmId}'
		});
		dataObj.push({
			name : 'username',
			value : '${userName}'
		});
		dataObj.push({
			name : 'targetUId',
			value : obj.tuid
		});
		dataObj.push({
			name : 'targetUName',
			value : obj.tuname
		});
		dataObj.push({
			name : 'content',
			value : obj.v
		});
		dataObj.push({
			name : 'relaModule',
			value : 'ArticleInfo'
		});
		dataObj.push({
			name : 'relaId',
			value : '${id}'
		});
		dataObj.push({
			name : 'subRelaId',
			value : obj.subRelaId
		});
		dataObj.push({
			name : 'readFlag',
			value : 'Y'
		});
		dataObj.push({
			name : 'createTime',
			value : new Date()
		});
		//异步调用保存数据
		$.ajax({
			url : '<%=path%>/msgs/save',
    		type: 'get',
    		data: dataObj,
    		dataType: 'text',
    	    success: function(data){
    	    	if(!data){
    	    		return;
    	    	} 
    	    	showCustomerMsg();//刷新消息
//     	    	showMessage();
    	    }
    	});
    }
    
    //查询传播列表的消息
    function showCustomerMsg(){
    	//遍历传播数据列表
    		var msgListContainer = $(".msgListContainer ul");
    		//组装异步调用查询消息的参数
    		var dataObj = [];
        	dataObj.push({name:'relaModule', value: 'ArticleInfo'});
        	dataObj.push({name:'relaId', value: '${id}'});
        	//异步调用获取消息数据
        	asyncInvoke({
        		url: '<%=path%>/msgs/asynclist',
        		type: 'post',
        		data: dataObj,
        	    callBackFunc: function(data){
        	    	if(!data) return;
        	    	var d = JSON.parse(data);
        	    	msgListContainer.empty();
        	    	$(d).each(function(i){
        	    		var username = "";
	  			 	  if(this.userid == '${crmId}'){
	  			 		  username = "我";
	  			 	  }else{
	  			 		  username = this.username;
	  			 	  }
	  			 	 var createTime = this.createTime;
				 	 var dateStr = (parseInt(createTime.month)+1) +  '-' + createTime.date+"  "+createTime.hours+":"+createTime.minutes;
        	    		var  html = '<li  style="border-bottom: #eff2f5 dashed 1px;display: block;position: relative;padding: 10px 0;id='+this.relaId+'>';
	   				      html += '  <div class="ct-box" style="display: block;margin-left: 0px;">';
	   				      html += '  <p class="ct-user" style="margin-bottom: 6px;">';
	   				      html += '    <a target="_blank" href="javascript:void(0)">';
	   				      if(null==this.targetUName||""==this.targetUName){
	   				    	  html+= username+'</a> :';
	   				      }else{
	   				    	  html+= username+' 回复 '+this.targetUName+'</a> :';
	   				      }
	   				      html += '    <span style="color: #bdbdbd;float: right;font-size: 12px;">'+ dateStr +'</span>';
	   				      html += '  </p>';
	   				      html += '  <p class="ct-reply" style="color: #555;min-height: 15px;padding-right: 10px;">';
	   				      html +=    this.content;
	   				      html += '   <span targetUId="'+ this.userId +'" targetUName="' + this.username +'" relaId="'+ this.relaId +'" class="replySinPer" style="cursor:pointer;  float:right; color: #bdbdbd;">回复</span>';
	   				      html += '  </p>';
	   				      html += '  </div>';
	   				      html += '</li>';
		        	    msgListContainer.css("display", "").append(html);
        	    	});
        	    	if(d.length < 5){
      				  $(".msgListShowAll").css("display","none"); //查看全部
      			  }else{
      				  $(".msgListShowAll").css("display",""); //查看全部
      			  }	
        	    	initCustomerReplyMsg();//初始化传播消息
        	    }
        	});
    }
    </script>
</head>
<body style="background-color: #fff;">
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:30px;">${aInfo.title}</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div style="margin: 10px;">
		<div style="float: left;">&nbsp;&nbsp;阅读(${accessAount})次</div>
		<div style="float: right;">
			<fmt:formatDate value="${aInfo.createTime }" type="both"
				pattern="yyyy-MM-dd " />
		</div>
	</div>

	<div style="clear: both; border-bottom: 1px solid #eee; margin: 10px;">&nbsp;</div>

	<input type="hidden" name="rowId" value="${rowId}" />
	<div style="margin:10px;">
		<img src="${aInfo.image}" width="100%;" height="120px;">
	</div>
	<div style="margin:15px;line-height:25px;">
		&nbsp;&nbsp;&nbsp;&nbsp;${aInfo.descrition}
	</div>
	<div style="margin: 15px;">
		<c:if test="${aInfo.content ne ''}">
		${aInfo.content} 
	</c:if>
	</div>

	<!-- 消息回复 -->
	<div style="width:100%;border-bottom:1px solid #efefef">&nbsp;</div>
	<h3 class="wrapper examineInfo msgTitle">&nbsp;评&nbsp;论&nbsp;</h3>
	<div class="container hy bgcw msgListContainer" style="font-size: 14px;margin:0 15px 0 15px">
		<ul style="margin-top: 20px;"></ul>
	</div>
	<div class="container hy bgcw msgListShowAll"
		style="font-size: 14px; text-align: center; padding-top: 5px; padding-bottom: 5px">
		<a class="showAllMsg"
			style="cursor: pointer; color: #51BBEC; padding-top: 5px; padding-bottom: 5px;"
			onclick="showAllMessage();" href="javascript:void(0)">查看全部&nbsp;↓</a>
	</div>

	<!-- 底部操作区域 -->
	<div class="flooter"
		style="z-index: 99999; background: #FFF; background: rgb(242, 242, 243); border-top: 1px solid #A2A2A2; opacity: 1;">
		<!--发送消息的区域  -->

		<div class="msgContainer">
			<div class="ui-block-a replybtn"
				style="float: left; width: 85%; margin: 5px 0px 5px 0px; padding-left: 5px;">
				<!-- 目标用户ID -->
				<input type="hidden" name="targetUId" />
				<!-- 目标用户名 -->
				<input type="hidden" name="targetUName" />
				<!-- 子级关联ID -->
				<input type="hidden" name="subRelaId" /> <input name="inputMsg"
					value=""
					style="width: 98%; line-height: 40px; font-size: 14px; height: 40px; margin-left: 5px; margin-top: 0px;"
					type="text" class="form-control" placeholder="回复">
			</div>
			<div class="ui-block-a "
				style="float: left; width: 15%; margin: 5px 0px 5px 0px;">
				<a href="javascript:void(0)" 
					class="btn  btn-block examinerSend"
					style="font-size: 14px; padding: 0px; margin-left: 5px; margin-right: 5px;">发送</a>
			</div>
			<div style="clear: both;"></div>
		</div>
	</div>
	
	<!-- myMsgBox -->
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 16px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">121212</div>

<%-- 	<!-- 分享JS区域 -->
	<script src="<%=path%>/scripts/util/share.util.js"
		type="text/javascript"></script>
	<script type="text/javascript">
	    var redirectUri  = "${appcontent}%2farticleInfo%2fdetail%3fopenId%3d${openId}%26id%3d${id}%26publicId%3d${publicId}%26shareBtnContol%3d=yes&flag%3d1";
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",
			//url : window.location.href + "&shareBtnContol=yes",
			url : "https://open.weixin.qq.com/connect/oauth2/authorize?appid=${appid}&redirect_uri="+ redirectUri  +"&response_type=code&scope=snsapi_userinfo&state=1&shareBtnContol=yes#wechat_redirect",
			title : "${aInfo.title}",
			desc : "${aInfo.descrition}",
			fakeid : "",
			callback : function() {
				
			}
		};
	</script> --%>
</body>
</html>