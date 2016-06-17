<%@page import="com.takshine.wxcrm.base.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String msgpath = request.getContextPath();
	String isatten ="N";
	String crmId=request.getParameter("crmId"); 
	if(StringUtils.isNotNullOrEmptyStr(crmId)){
	     request.setAttribute("crmId", crmId);
	}
%>
<%--<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
 <script src="<%=msgpath%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> --%>
<script src="<%=msgpath%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=msgpath%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=msgpath%>/css/style.css"/>
<script src="<%=msgpath%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=msgpath%>/scripts/util/takshine.util.js" type="text/javascript"></script>

<script type="text/javascript">
//加载模块类型 
var msg = {};
//查看所有的消息
function loadAllMessage(){
	var obj = {
		crmId: msgsenduserid,
    	relamodel: p.msgModelType.val(), 
    	relaid: '${rowId}',
    	subrelaid: '',
    	currpage: '0',
    	pagecount: '9999'
    };
    //加载消息
	loadMessage_MsgCore(obj);
}

function loadMessage(){
	var obj = {
		crmId: msgsenduserid,
    	relamodel: p.msgModelType.val(), 
    	relaid: '${rowId}'
    };
    //加载消息
    loadMessage_MsgCore(obj);
}

function loadOpptyMessage(){
	//遍历业务机会跟进数据列表
	$(".opptyReplayCon").each(function(){
		var opptyReplayRstCon = $(this).siblings(".opptyReplayRst");
		var subRelaId = $(this).attr("subRelaId");
		
		var obj = {
			crmId: msgsenduserid,
			relamodule: p.msgModelType.val(), 
			relaid: '${rowId}',
			subrelaid: subRelaId,
	    	invokeSucc: function(d){
	    		opptyReplayRstCon.empty();
	   	    	$(d).each(function(i){
		   	    	  var username = "";
				 	  if(this.userId == obj.crmId){
				 		  username = "我";
				 	  }else{
				 		  username = this.username;
				 	  }
	       	    	  var html = opptyMsgTemp(this.userId, this.subRelaId, this.targetUId, username,
	       	    	    		this.targetUName, this.content, true);
	   	    		  opptyReplayRstCon.css("display", "").append(html);
	   	    	});
	   	    	initOpptyReplyMsg();//初始化业务机会回复消息
	    	}
	    };
	    //加载消息
		loadMessage_MsgCore(obj);
	});
}

//商机点对点消息发送
function befOpptySendMessage(){
	if(p.subRelaId.val()){
		var dateStr = dateFormat(new Date(), "MM-dd hh:mm");
		
		var html = opptyMsgTemp(msgsenduserid, p.subRelaId.val(), p.targetUId.val(), msgsendusername,
				                    p.targetUName.val(), p.inputTxt.val(), true);
		//点击某一个子项目
		var parObj = $("ul.opptyReplayRst > li[selectThis=true]").parent();
    	var fstli = parObj.find("li:eq(0)");
    	if(fstli && fstli.length > 0){
    		$(html).insertBefore(fstli);
    	}else{
    		parObj.find("ul").css("display","").append(html);
    	}
    	//点击一个业务机会跟进大项目
    	var parObj2 = $(".opptyReplayCon[selectThis=true]").parent();
    	var fstli2 = parObj2.find("ul > li:eq(0)");
    	if(fstli2 && fstli2.length > 0){
    		$(html).insertBefore(fstli2);
    	}else{
    		parObj2.find("ul.opptyReplayRst").css("display","").append(html);
    	}
    	//初始化
    	initOpptyReplyMsg();
	}
}

function sendMessage(){
	var content = '';
	var t = p.msgType.val();
	var subfv = sfs.sfsfileval.attr("atrsubfile");
	var sfv =sfs.sfsfileval.attr("atrsharefile");
	if(t === "txt"){
		content = p.inputTxt.val();
	}else if(t === 'img'){//
		var img = "<img onclick='showSourceImg(\""+sfv+"\")' src='<%=msgpath%>/sharefiles/download?fileName="+ sfv + "&subfilename=" + subfv + "' />";
		
		content = img;
	}else if(t === 'doc'){
		var img = "<a href='<%=msgpath%>/sharefiles/downdoc?fileName="+ sfv + "&subfilename=" + subfv + "'>"+ subfv +"</a>";
		content = img;
	}
	var re=/\r\n/;  
	var contentValue=content.replace(re,"\n");  
	//消息为空则不发送
	if(!contentValue.trim()){ return; }
	//alert('msgsenduserid' + msgsenduserid);
	_initMessageControl();
	var obj = {
   		crmId: '${crmId}',
   		openid: '${openId}',
   		orgId: '${orgId}',
   		userid: msgsenduserid,
   		username: msgsendusername,
   		targetuid: p.targetUId.val(), 
   		targetuname: p.targetUName.val(), 
   		msgtype: p.msgType.val(),
   		content: content, 
   		relamodel: p.msgModelType.val(),
   		relaid: '${rowId}', 
   		subrelaid: p.subRelaId.val(), 
   		assignerid: '${assignerid}'
	 };
	
   	//发送消息
   	sendMessage_MsgCore(obj);
   	
   	p.inputTxt.attr("placeholder","回复  ").val('');
   	p.targetUId.val('');
   	p.targetUName.val('');
   	p.subRelaId.val('');
}

//消息模板
function opptyMsgTemp(userId, subRelaId, targetUId, username, targetUName, content, lastFlag){
	var html = '<li style="margin: 4px 0px 4px 8px;width: 90%;padding-right: 10px;">';
	    html += '   <input type="hidden" name="opid" value="'+ userId +'"/>';
	    html += '   <input type="hidden" name="subRelaId" value="'+ subRelaId +'"/>';
	    if(targetUId != ''){
	    	html += '<a>'+ username +'</a>&nbsp;回复 <a>'+ targetUName +'</a>';
	    }else{
	    	html += '<a>'+ username +'</a>';
	    }
	    html += '   <span> : '+ content +'.</span>';
	    html += '</li>';
	    //追加 下划线
	    if(lastFlag){
	    	html += '<li style="border-bottom: 1px solid #F0EAEA;margin: 4px 0px 4px 8px;width: 90%;line-height: 1px;">&nbsp;</li>';
	    }
	
    	return html;
}

<%-- var attenopenid = '';
var attennickname = ''; --%>
var msgsenduserid = '${crmId}';
var msgsendusername = '${sessionScope.CurrentUser.name}';

$(function(){
	//如果是分享给关注用户的 id 则 用关注用户发送消息
	/* if(attenopenid){
		msgsenduserid = attenopenid;
		msgsendusername = attennickname;
	} */
	
	loadMessage();
	if(p.msgModelType.val() === "Opportunities"){
		loadOpptyMessage();	
	}
	
});

var getContentPath = function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
};

/**
* [loadMessage 加载消息 ]
* @param {String} crmId [用户id]
* @param {String} model [模块类型]
* @param {String} relaId [关联ID]
* @param {String} subRelaId [子关联ID]
* @param {String} currpage [当前页]
* @param {String} pagecount [每页数量]
*/
var loadMessage_MsgCore = function(obj){
	
	var dataObj = [];
	dataObj.push({name:'crmId', value: obj.crmId || ''});
	dataObj.push({name:'relaModule', value: obj.relamodel || ''});
	dataObj.push({name:'relaId', value: obj.relaid || ''});
	dataObj.push({name:'subRelaId', value: obj.subrelaid || '' });
	dataObj.push({name:'currpage', value: obj.currpage || '0' });
	dataObj.push({name:'pagecount', value: obj.pagecount || '5' });
	
	$.ajax({
	   type: 'get',
	   url: getContentPath() + '/msgs/asynclist',
	   data: dataObj || {},
	   dataType: 'text',
	   success: function(data){
		   var d = JSON.parse(data);
		   if(obj.invokeSucc){
			   obj.invokeSucc(d);
		   }else{
			   compaileComMsgData_MsgCore(obj, d);
		   }
	   }
	});
};

/**
* 显示普通的消息数据
*/
var compaileComMsgData_MsgCore = function(obj, d){
	  $(".msgListContainer ul").empty();
     $(d).each(function(){
	 	  var username = "";
	 	  if(this.userId == obj.crmId){
	 		  username = "我";
	 	  }else{
	 		  username = this.username;
	 	  }
	 	  var dateStr = dateFormat(new Date(this.createTime.time), "MM-dd hh:mm");
	      //追加单条消息
	 	  appendSingleMsg_MsgCore(this.userId, username, dateStr, this.content);
	  });
	      
     //控制显示与隐藏 按钮
     if(d.length === 0){
   	  $(".msgTitle").css("display","none");//标头
     }else{
   	  $(".msgTitle").css("display","");//标头
     }
     if(d.length === 5){
   	  $(".msgListShowAll").css("display",""); //查看全部
	  }else{
		  $(".msgListShowAll").css("display","none"); //查看全部
	  }
};

/**
* 发送消息
*/
var sendMessage_MsgCore = function(obj){
	//追加到DOM节点
	if(!obj.subrelaid){
		appendSingleMsg_MsgCore(obj.userid, "我", dateFormat(new Date(), "MM-dd hh:mm"), obj.content, "desc");
	}
	
	var dataObj = [];
	dataObj.push({name:'ownerCrmId', value: obj.crmId});
	dataObj.push({name:'ownerOpenId', value: obj.openid});
	dataObj.push({name:'openId', value: obj.openid});
	dataObj.push({name:'userId', value: obj.userid});
	dataObj.push({name:'username', value: obj.username});
	dataObj.push({name:'targetUId', value: obj.targetuid});
	dataObj.push({name:'targetUName', value: obj.targetuname});
	dataObj.push({name:'msgType', value: obj.msgtype});
	dataObj.push({name:'content', value: obj.content });
	dataObj.push({name:'relaModule', value: obj.relamodel});
	dataObj.push({name:'relaId', value: obj.relaid});
	dataObj.push({name:'subRelaId', value: obj.subrelaid });
	dataObj.push({name:'readFlag', value: 'N'});
	dataObj.push({name:'createTime', value: new Date()});
	dataObj.push({name:'assignerid', value: obj.assignerid});
	dataObj.push({name:'isatten', value: '<%=isatten%>'});
	dataObj.push({name:'schetype', value: '${schetype}'});
	dataObj.push({name:'orgId', value:obj.orgId});
	//异步调用保存数据
	$.ajax({
		url: getContentPath() + '/msgs/save',
		type: 'get',
		data: dataObj,
		dataType: 'text',
	    success: function(data){
	    	if(!data){
	    		return;
	    	}
	    }
	});
};

/**
* 追加单条消息
*/
var appendSingleMsg_MsgCore = function(userid, username, date, content, order){
	 var tmp = msgTemplate_MsgCore();
    tmp = tmp.replace("$$userId", userid);
    tmp = tmp.replace("$$defaultImg", getContentPath() + '/image/defailt_person.png');
    tmp = tmp.replace("$$username", username);
    tmp = tmp.replace("$$dateStr", date);
    content = content.replace(new RegExp(/(\n)/g),"</br>");
    tmp = tmp.replace("$$content", content);
    var node = $(".msgListContainer ul").find("li:eq(0)");
    if(order && order === "desc" && node && node.length > 0){
   	 //第一个li
        $(tmp).insertBefore($(".msgListContainer ul").find("li:eq(0)"));
    }else{
   	 $(".msgListContainer ul").append(tmp);
    }
    
    if($(".msgListContainer ul li").size() > 0){
   	 	$(".msgTitle").css("display", "");
   	 	$(".msgListContainer").addClass("_border_");
    }
    
    //追加单条图像数据
    loadMsgImg_MsgCore(userid, $(".msgListContainer").find("img[userid="+ userid +"]"));
};

/**
* 消息模板 
*/
var msgTemplate_MsgCore = function(){
	var html = ['<li  style="border-bottom: #eee solid 1px;display: block;position: relative;padding: 15px 0px">',
		          '<div class="ct-box" style="display: block;margin-left: 0px;">',
			          '<div style="float:left">',
			             '<img class="msgheadimg" style="border-radius:5px" userid="$$userId" src="$$defaultImg" width="40px">',
			          '</div>', 
			          '<div style="margin-left:60px">',
			            '<p class="ct-user" style="margin-bottom: 6px;">',
			              '<a target="_blank" style="margin-left: 0px;" href="javascript:void(0)">$$username</a> :',
			              '<span style="color: #bdbdbd;float: right;font-size: 12px;">$$dateStr</span>',
			            '</p>',
			            '<p class="ct-reply" style="color: #555;min-height: 15px;padding-right: 10px;padding-top:5px;">$$content</p>',
			          '</div>',
	              '</div>',
		       '</li>',
	           '<div style="clear:both;"></div>'];
	
   return html.join("");
};

//显示单个图片头像
var loadMsgImg_MsgCore = function(userId, img){
  	if(sessionStorage.getItem(userId + "_headImg")){
  		$(img).attr("src", sessionStorage.getItem(userId + "_headImg"));
  		return;
  	}
	if(userId){
  		//异步调用获取消息数据
      	$.ajax({
   		url: getContentPath() + '/wxuser/getImgHeader',
   		type: 'get',
   		data: {crmId: userId},
   		dataType: 'text',
   	    success: function(data){
   	    	if(data){
    	    	  $(img).attr("src",data);
    	    	  //本地缓存
    	          sessionStorage.setItem(userId + "_headImg",data);
    	    	}
   	    }
   	});
	}
};

</script>

<!-- 消息回复 -->
<div style="padding-left:5px;padding-right:5px;">
<div class="examineInfo msgTitle" style="line-height:50px;font-size:16px;font-weight:bold;padding-left:8px;display:none;">
	<img src="<%=msgpath%>/image/title-message.png" width="20px" style="margin-bottom:3px;">&nbsp;消息
</div>
<!-- <h3 class="wrapper examineInfo msgTitle" style="display:none;">消息</h3> -->
<div class="container hy bgcw msgListContainer" style="font-size: 14px;background: #fff;">
	<ul style="margin-top: 5px;"></ul>
</div> 
<div class="container hy bgcw msgListShowAll"
	style="display:none;font-size: 14px; text-align: center; padding-top: 5px; padding-bottom: 5px">
	<a class="showAllMsg"
		style="cursor: pointer; color: #51BBEC; padding-top: 5px; padding-bottom: 5px;"
		onclick="loadAllMessage();" href="javascript:void(0)">查看全部&nbsp;↓</a>
</div>
</div>