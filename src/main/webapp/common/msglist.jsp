<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@page import="com.takshine.wxcrm.base.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String msgpath = request.getContextPath();
	String relaModule = request.getParameter("relaModule");
	String relaId = request.getParameter("relaId");
	String partyId = UserUtil.getCurrUser(request).getParty_row_id();
%>
<script src="<%=msgpath%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=msgpath%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=msgpath%>/css/style.css"/>

<!--dc 基础类库-->
<script src="<%=msgpath%>/scripts/util/takshine.util.js" type="text/javascript"></script>

<script type="text/javascript">
$(function(){
	loadMessages('0','5');
	
	//setInterval
	setInterval(function(){
		loadMessages('0','999');
	}, 60000);
});

var getContentPath = function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
};

function loadMessages(currpage,pagecount){
	var dataObj = [];
	dataObj.push({name:'relaModule', value:'<%=relaModule%>'});
	dataObj.push({name:'relaId', value: '<%=relaId%>'});
	dataObj.push({name:'currpage', value: currpage });
	dataObj.push({name:'pagecount', value: pagecount });
	
	$.ajax({
	   type: 'post',
	   url: getContentPath() + '/msgs/asynclist',
	   data: dataObj || {},
	   dataType: 'text',
	   success: function(data){
		   var d = JSON.parse(data);
		   compaileComMsgData_MsgCore(d);
	   }
	});
}


/**
* 显示普通的消息数据
*/
var compaileComMsgData_MsgCore = function(d){
	 $(".msgListContainer ul").empty();
     $(d).each(function(){
	 	  var username = "";
	 	  if(this.userId == "<%=partyId%>"){
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
    
    if($(".msgListShowAll").css("display") == "none"){
	    var dataObj = [];
	 	dataObj.push({name:'relaModule', value:'<%=relaModule%>'});
	 	dataObj.push({name:'relaId', value: '<%=relaId%>'});
	 	
	 	$.ajax({
	 	   type: 'post',
	 	   url: getContentPath() + '/msgs/countmsg',
	 	   data: dataObj || {},
	 	   dataType: 'text',
	 	   success: function(data){
	 		   if(data){
	 			   if(parseInt(data) >= 5){
	 				   $(".msgListShowAll").css("display",""); //查看全部
	 			   }
	 			   $(".msgtotal").text(parseInt(data) - 5);
	 		   }
	 	   }
	 	});
    }else{
    	$(".msgListShowAll").css("display","none");
    }
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
    
    //追加单条图像数据
    loadMsgImg_MsgCore(userid, $(".msgListContainer").find("img[userid="+ userid +"]"));
};

/**
* 消息模板 
*/
var msgTemplate_MsgCore = function(){
	var html = ['<li  style="border-bottom: #eee solid 1px;display: block;position: relative;padding: 8px 0px">',
		          '<div class="ct-box" style="display: block;margin-left: 0px;">',
			          '<div style="float:left">',
			             '<img class="msgheadimg" style="border-radius:5px" userid="$$userId" src="$$defaultImg" width="40px">',
			          '</div>', 
			          '<div style="margin-left:60px">',
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


function loadAllMessage(){
	loadMessages('0','9999');
}
</script>

<!-- 消息回复 -->
<div style="">
<div class="examineInfo msgTitle" style="line-height:40px;font-size:14px;padding-left:8px;display:none;background-color:#fff;border-bottom:1px solid #ddd;">
	消息
</div>
<!-- <h3 class="wrapper examineInfo msgTitle" style="display:none;">消息</h3> -->
<div class="container hy bgcw msgListContainer" style="font-size: 14px;background: #fff;">
	<ul></ul>
</div> 
<div class="container hy bgcw msgListShowAll"
	style="display:none;font-size: 14px; text-align: center; padding-top: 5px; padding-bottom: 5px">
	<a class="showAllMsg"
		style="cursor: pointer; color: #51BBEC; padding-top: 5px; padding-bottom: 5px;"
		onclick="loadAllMessage();" href="javascript:void(0)">查看剩余<span class="msgtotal"></span>条消息&nbsp;↓</a>
</div>
</div>