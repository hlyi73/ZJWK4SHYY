<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String msgcorepath = request.getContextPath();
	String attenopenid = request.getParameter("atten_openid");
			attenopenid = (attenopenid == null) ? "" : attenopenid;
	String attennickname = request.getParameter("atten_nickname");
		   attennickname = (attennickname == null) ? "" : attennickname;
		   attennickname = new String(attennickname.getBytes("iso-8859-1"), "utf-8");
    String msg_model_type = request.getParameter("msg_model_type");
    String crmid = request.getParameter("crmid");
    String rowid = request.getParameter("rowid");
    String openid = request.getParameter("openid");
    String assignerid = request.getParameter("assignerid");
    String assigner = request.getParameter("assigner");
		   
%>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<!-- js files -->
<script src="<%=msgcorepath%>/scripts/plugin/json2.js"></script>
<script src="<%=msgcorepath%>/scripts/plugin/wb/js/wb.js"></script>
<script src="<%=msgcorepath%>/scripts/util/takshine.util.js"></script>
<!--css files -->
<link rel="stylesheet" href="<%=msgcorepath%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=msgcorepath%>/css/style.css"/>

<script type="text/javascript">
//加载模块类型

//对外提供的调用方法 隐藏 跟进历史 列表
function ivk_hideMessageList(){
	$(".msgListContainer").addClass("modal");
	$(".msgTitle").addClass("modal");
	$(".msgListShowAll").addClass("modal");
}
//对外提供的调用方法 显示 跟进历史 列表
function ivk_showMessageList(){
	$(".msgListContainer").removeClass("modal");
	$(".msgTitle").removeClass("modal");
	$(".msgListShowAll").removeClass("modal");
}

var msg = {};

//查看所有的消息
function loadAllMessage(){
	var obj = {
		crmId: msgsenduserid,
    	relamodel: '<%=msg_model_type%>',
    	relaId: '<%=rowid%>',
    	subRelaId: '',
    	currpage: '0',
    	pagecount: '9999'
    };
    //加载消息
	loadMessage_MsgCore(obj);
}

function loadMessage(){
	
	var obj = {
		crmId: msgsenduserid,
    	relamodel: '<%=msg_model_type%>',
    	relaId: '<%=rowid%>',
    };
    //加载消息
    loadMessage_MsgCore(obj);
}

function sendMessage(params){
	var content = '';
	var t = params.msg_type;
	
	if(t === "txt"){
		content = params.input_msg;
	}else if(t === 'img'){//
		var img = "<img onclick='showSourceImg(\""+sfv+"\")' src='<%=msgcorepath%>/sharefiles/download?fileName="+ sfv + "&subfilename=" + subfv + "' />";
		content = img;
	}
	//消息不为空则不发送
	if(!content.trim()){ return; }
	
	var obj = {
   		relaid: '<%=rowid%>', 
   		crmid: '<%=rowid%>',
   		openid: '<%=openid%>',
   		assignerid: '<%=assignerid%>',
   		relamodel: '<%=msg_model_type%>',
   		userid: msgsenduserid,
   		username: msgsendusername,
   		targetuid: params.target_uid, 
   		targetuname: params.target_uname, 
   		msgtype: params.msg_type,
   		subrelaid: params.sub_relaid, 
   		content: content 
	 };
	
   	//发送消息
   	sendMessage_MsgCore(obj);
}

var attenopenid = '<%=attenopenid%>';
var attennickname = '<%=attennickname%>';
var msgsenduserid = '<%=crmid%>';
var msgsendusername = '<%=assigner%>';

$(function(){
	//如果是分享给关注用户的 id 则 用关注用户发送消息
	if(attenopenid){
		msgsenduserid = attenopenid;
		msgsendusername = attennickname;
	}
	loadMessage();
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
	dataObj.push({name:'relaModule', value: obj.relaModule || ''});
	dataObj.push({name:'relaId', value: obj.relaId || ''});
	dataObj.push({name:'subRelaId', value: obj.subRelaId || '' });
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
	//alert('444='+obj.openid);
	dataObj.push({name:'ownerCrmId', value: obj.crmid});
	dataObj.push({name:'ownerOpenId', value: obj.openid});
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
    }
    
    //追加单条图像数据
    loadMsgImg_MsgCore(userid, $(".msgListContainer").find("img[userid="+ userid +"]"));
};

/**
* 消息模板 
*/
var msgTemplate_MsgCore = function(){
	var html = ['<li  style="border-bottom: #eee solid 1px;display: block;position: relative;padding: 15px 0;">',
		          '<div class="ct-box" style="display: block;margin-left: 0px;">',
			          '<div style="float:left">',
			             '<img class="msgheadimg" style="border-radius:5px" userid="$$userId" src="$$defaultImg" width="40px">',
			          '</div>', 
			          '<div>',
			            '<p class="ct-user" style="margin-bottom: 6px;">',
			              '<a target="_blank" style="margin-left: 20px;" href="javascript:void(0)">$$username</a> :',
			              '<span style="color: #bdbdbd;float: right;font-size: 12px;">$$dateStr</span>',
			            '</p>',
			            '<p class="ct-reply" style="padding-left: 40px;margin-left: 20px;color: #555;min-height: 15px;padding-right: 10px;padding-top:5px;">$$content</p>',
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
<h3 class="wrapper examineInfo msgTitle">消息</h3>
<div class="container hy bgcw msgListContainer" style="font-size: 14px;background: #fff;">
	<ul style="margin-top: 20px;"></ul>
</div> 
<div class="container hy bgcw msgListShowAll"
	style="display:none;font-size: 14px; text-align: center; padding-top: 5px; padding-bottom: 5px">
	<a class="showAllMsg"
		style="cursor: pointer; color: #51BBEC; padding-top: 5px; padding-bottom: 5px;"
		onclick="loadAllMessage();" href="javascript:void(0)">查看全部&nbsp;↓</a>
</div>