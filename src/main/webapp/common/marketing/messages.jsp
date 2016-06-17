<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String msgpath = request.getContextPath();
	String attenopenid = request.getParameter("atten_openid");
			attenopenid = (attenopenid == null) ? "" : attenopenid;
	String attennickname = request.getParameter("atten_nickname");
		   attennickname = (attennickname == null) ? "" : attennickname;
		   attennickname = new String(attennickname.getBytes("iso-8859-1"), "utf-8");
		   
    String parenttype = request.getParameter("parenttype");
    request.setAttribute("parenttype", parenttype);
    String parentid = request.getParameter("parentid");
    request.setAttribute("id", parentid);
		   
%>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<%-- <script src="<%=msgpath%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script> --%>
<script src="<%=msgpath%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=msgpath%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=msgpath%>/css/style.css"/>
<script src="<%=msgpath%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=msgpath%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<style>
	.dt_review_topR{
		display: inline-block;
		float: right;
		overflow: hidden;
	}
	.dt_review_topR span{
		display: inline-block;
		float: right;
		margin-left: 5px;
		color: #49b7e8;
		width: 35px;
	}
	.dt_review_topR a{
		overflow: hidden;
		display: inline-block;
		width: 20px;
		height: 20px;
		float: right;
		position: relative;
	}
	.dt_review_topR a img{
		position: absolute;
		width: 20px;
		height: 40px;
		top: 0;
		left: 0;
	}
</style>
<script type="text/javascript">
//加载模块类型
var msg = {};

//查看所有的消息
function loadAllMessage(){
	var obj = {
		senduserid: msgsenduserid,
    	relaModel: p.msgModelType.val(), 
    	relaId: '${id}',
    	subRelaId: '',
    	currpage: '0',
    	pagecount: '9999',
    	optype:"all"
    };
    //加载消息
	loadMessage_MsgCore(obj);
}

function loadMessage(){
	
	var obj = {
		senduserid: msgsenduserid, 
    	relaModel: p.msgModelType.val(), 
    	relaId: '${id}'
    };
    //加载消息
    loadMessage_MsgCore(obj);
}

function sendMessage(){
	var content = '';
	var t = p.msgType.val();
// 	var subfv = sfs.sfsfileval.attr("atrsubfile");
// 	var sfv =sfs.sfsfileval.attr("atrsharefile");
	
// 	if(t === "txt"){
		content = p.inputTxt.val();
// 	}else if(t === 'img'){//
<%-- 		var img = "<img onclick='showSourceImg(\""+sfv+"\")' src='<%=msgpath%>/sharefiles/download?fileName="+ sfv + "&subfilename=" + subfv + "' />"; --%>
		
// 		content = img;
// 	}else if(t === 'doc'){
<%-- 		var img = "<a href='<%=msgpath%>/sharefiles/downdoc?fileName="+ sfv + "&subfilename=" + subfv + "'>"+ subfv +"</a>"; --%>
// 		content = img;
// 	}
	var re=/\r\n/;  
	var contentValue=content.replace(re,"\n"); 
	//消息不为空则不发送
	if(!contentValue.trim()){ return; }
	//alert('msgsenduserid' + msgsenduserid);
	_initMessageControl();
	var obj = {
   		/* crmid: '${crmId}',
   		openid: '${openId}', */
   		userid: msgsenduserid,
   		username: msgsendusername,
   		targetuid: p.targetUId.val(), 
   		targetuname: p.targetUName.val(), 
   		msgtype: p.msgType.val(),
   		content: content, 
   		relamodel: p.msgModelType.val(),
   		relaid: '${id}', 
   		subrelaid: p.subRelaId.val(), 
   		assignerid:''
	 };
	
	//alert('222='+obj.openid);
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

var attenopenid = '<%=attenopenid%>';
var attennickname = '<%=attennickname%>';
var msgsenduserid = '${sourceid}';
var msgsendusername = '${sessionScope.CurrentUser.name}';

$(function(){
	//如果是分享给关注用户的 id 则 用关注用户发送消息
	if(attenopenid){
		msgsenduserid = attenopenid;
		msgsendusername = attennickname;
	}
	
	loadMessage();
	
	//setInterval
	setInterval(function(){
		loadMessage();
	}, 60000);
	
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
/* 	dataObj.push({name:'crmId', value: obj.crmId || ''}); */
	dataObj.push({name:'relaModule', value: obj.relaModel || ''});
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
	 	  if(this.userId == obj.senduserid){
	 		  username = "我";
	 	  }else{
	 		  username = this.username;
	 	  }
	 	  var dateStr = dateFormat(new Date(this.createTime.time), "MM-dd hh:mm");
	      //追加单条消息
	 	  appendSingleMsg_MsgCore(this.headImageUrl,this.userId, username, dateStr, this.content);
	  });
	      
     //控制显示与隐藏 按钮
      	if(d.length === 0){
      		if ('${parenttype}' == 'expense')
   			{
      			$("#msgtitlespan").html("还没有消息");
   			}
      		else
   			{
      			$("#msgtitlespan").html("还没有人评论");
   			}
      	}else{
      		if ('${parenttype}' == 'expense')
   			{
      			$("#msgtitlespan").html(d.length +"条消息");
   			}
      		else
   			{
          		$("#msgtitlespan").html(d.length+"人评论");
   			}
      	}
     
     if(d.length >= 5){
    	 $(".msgListShowAll").css("display",""); //查看全部
	  }else{
		  $(".msgListShowAll").css("display","none"); //查看全部
	  }
   	 if("all"==obj.optype){
  	  	  $(".msgListShowAll").css("display","none"); //查看全部
   	 }
};

/**
* 发送消息
*/
var sendMessage_MsgCore = function(obj){
	 //追加到DOM节点
	if(!obj.subrelaid){
		appendSingleMsg_MsgCore('',obj.userid, "我", dateFormat(new Date(), "MM-dd hh:mm"), obj.content, "desc");
	}
	
	var dataObj = [];
	//alert('444='+obj.openid);
	 dataObj.push({name:'source', value:'${source}'});
	dataObj.push({name:'sourceid', value:'${sourceid}'});
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
var appendSingleMsg_MsgCore = function(headImage,userid, username, date, content, order){
	 var tmp = msgTemplate_MsgCore();
    tmp = tmp.replace("$$userId", userid);
    if(headImage==''){
    	tmp = tmp.replace("$$defaultImg", getContentPath() + '/image/defailt_person.png');
    }
    else{
    tmp = tmp.replace("$$defaultImg",headImage);
    }
    tmp = tmp.replace("$$username", username);
    tmp = tmp.replace("$$dateStr", date);
    content = content.replace(new RegExp(/(\n)/g),"</br>");
    tmp = tmp.replace("$$content", content);
    tmp = tmp.replace("$$busiCardUrl", "<%=msgpath%>/businesscard/detail?partyId="+userid);
    
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
    var content = $("#msgtitlespan").html();
    var reg = /^[0-9]+/;  
    var result =  reg.exec(content); 
    if(null==result){
    	if ('${parenttype}' == 'expense')
		{
  			$("#msgtitlespan").html("1条消息");
		}
  		else
		{
  	    	 $("#msgtitlespan").html("1人评论");
		}
    }else{
    	if ('${parenttype}' == 'expense')
		{
      	     $("#msgtitlespan").html((parseInt(result)+1)+"条消息");
		}
  		else
		{
  	   	     $("#msgtitlespan").html((parseInt(result)+1)+"人评论");
		}
    }
   // $(".msgListContainer").find("img[userid="+ userid +"]").attr("src",headImage);
    
    //追加单条图像数据
     loadMsgImg_MsgCore(userid, $(".msgListContainer").find("img[userid="+ userid +"]"));
};

/**
* 消息模板 
*/
var msgTemplate_MsgCore = function(){
	var html = ['<li  style="border-bottom: #eee solid 1px;display: block;position: relative;padding: 8px 0;">',
		          '<div class="ct-box" style="display: block;margin-left: 0px;">',
			          '<div style="float:left">',
			             '<img class="msgheadimg" style="border-radius:5px" userid="$$userId" src="$$defaultImg" width="36px">',
			          '</div>', 
			          '<div style="margin-left:55px">',
			            '<p class="ct-user" style="margin-bottom: 6px;">',
			              '<a target="_self" style="margin-left: 0px;" href="$$busiCardUrl">$$username</a> :',
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
   		url: getContentPath() + '/wxuser/getHeader',
   		type: 'get',
   		data: {partyId: userId},
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

$(function(){
	if(!document.getElementById("inputMsg")){
		return;
	}
	$("#inputMsg").bind("propertychange",function(){
    	var v = $(this).val();
		if(v !== ''){
    		$(".examinerSend").css("display","");
    		$(".addBtn").css("display","none");
    	}else{
    		//$(".examinerSend").css("display","none");
    		$(".addBtn").css("display","");
    	}
		
// 		handlerErtUserList(v, getTeamLeas());//输入@符号作的处理
    });
	$("#inputMsg").bind("input",function(){
    	var v = $(this).val();
		if(v !== ''){
    		$(".examinerSend").css("display","");
    		$(".addBtn").css("display","none");
    	}else{
    		//$(".examinerSend").css("display","none");
    		$(".addBtn").css("display","");
    	}
		
// 		handlerErtUserList(v, getTeamLeas());//输入@符号作的处理
    });
	
	autoTextArea("inputMsg");
});
    
function autoTextArea(elemid){
    //新建一个textarea用户计算高度
    if(!document.getElementById("_textareacopy")){
        var t = document.createElement("textarea");
        t.id="_textareacopy";
        t.style.position="absolute";
        t.style.left="-9999px";
        t.rows = "1";
        t.style.lineHeight="20px";
        t.style.fontSize="16px";
        document.body.appendChild(t);
    }
    function change(){
    	document.getElementById("_textareacopy").value= document.getElementById("inputMsg").value;
    	var height = document.getElementById("_textareacopy").scrollHeight;
    	if(height>100){
    		return;
    	}
    	if(document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height < 40){
    		document.getElementById("inputMsg").style.height= "40px";
    	}else{
        	document.getElementById("inputMsg").style.height= document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height+"px";
    	}
    }
    
    $("#inputMsg").bind("propertychange",function(){
    	change();
    });
    $("#inputMsg").bind("input",function(){
    	change();
    });

    document.getElementById("inputMsg").style.overflow="hidden";//一处隐藏，必须的。
    document.getElementById("inputMsg").style.resize="none";//去掉textarea能拖拽放大/缩小高度/宽度功能
}

function _initMessageControl(){
	if(document.getElementById("inputMsg")){
		document.getElementById("inputMsg").style.height = "40px";
		document.getElementById("inputMsg").value = "";
		document.getElementById("inputMsg").rows = "1";
		document.body.removeChild(document.getElementById("_textareacopy"));
    	autoTextArea("inputMsg");
	}
}


</script>

<!-- 消息回复 -->
<h3 class="wrapper examineInfo msgTitle" style="background: #F0F0F0;">
	<c:if test="${parenttype ne 'expense' }">
		<span id="msgtitlespan">评论</span>
		<p class="dt_review_topR">
			<span ontouchstart="">评论</span>
			<a><img src="<%=msgpath%>/image/dt_review.png" title="评论"></a>
		</p>
	</c:if>
	
	<c:if test="${parenttype eq 'expense' }">
		<span id="msgtitlespan">消息</span>
		<p class="dt_review_topR">
			<span ontouchstart="">消息</span>
			<a><img src="<%=msgpath%>/image/dt_review.png" title="消息"></a>
		</p>
	</c:if>
	
</h3>
<div class="container hy bgcw msgListContainer" style="font-size: 14px;background: #fff;">
	<ul style=""></ul>
</div> 
<div class="container hy bgcw msgListShowAll"
	style="display:none;font-size: 14px; text-align: center; padding-top: 5px; padding-bottom: 5px">
	<a class="showAllMsg"
		style="cursor: pointer; color: #51BBEC; padding-top: 5px; padding-bottom: 5px;"
		onclick="loadAllMessage();" href="javascript:void(0)">展开更多&nbsp;↓</a>
</div>
<div style="height:35px;background-color:#fff;width:100%;" class="nocommentsdata"></div>