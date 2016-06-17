<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@page import="com.takshine.wxcrm.base.util.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String smsgpath = request.getContextPath();
	String relaModule = request.getParameter("relaModule");
	request.setAttribute("relaModule",relaModule);
	String relaId = request.getParameter("relaId");
	String relaName = request.getParameter("relaName");
	
	String partyId = UserUtil.getCurrUser(request).getParty_row_id();
	String username = UserUtil.getCurrUser(request).getNickname();
	
	String newFlag = request.getParameter("newFlag");
	request.setAttribute("newFlag", newFlag);
%>

<script type="text/javascript">
var p = {};

$(function(){
	initReplyMsg();
	
	if ('${newFlag}' == 'true')
	{
		$(".addBtn").css('display','none');
   		$(".examinerSend").css("display","");
	}
});
//初始化回复消息
function initReplyMsg(){ 
	 p.msgCon = $(".msgContainer");
	 p.msgModelType = p.msgCon.find("input[name=msgModelType]");
 	 p.msgType = p.msgCon.find("input[name=msgType]");//消息类型
	 p.inputTxt = p.msgCon.find("textarea[name=inputMsg]");//输入的文本框
	 p.targetUId = p.msgCon.find("input[name=targetUId]");//目标用户ID
	 p.targetUName = p.msgCon.find("input[name=targetUName]");//目标用户名
	 p.subRelaId = p.msgCon.find("input[name=subRelaId]");//子关联ID
	 p.examinerSend = p.msgCon.find(".examinerSend");//发送按钮
	    
	 p.nativeDiv = $("#site-nav");
    
     p.crmDetailForm = $(".crmDetailForm");

   	//发送消息
   	p.examinerSend.unbind("click").bind("click", function(){
   
   		var v = p.inputTxt.val();
   		var re=/\r\n/;  
   		v=v.replace(re,"\n");  
   		if(v.trim() == ""){
   			return false;
   		}
   		$(this).attr("disabled","true").css("background-color", "rgb(193, 200, 196)");
   		sendMsg({v:p.inputTxt.val(), tuid:p.targetUId.val(), 
   				      tuname: p.targetUName.val(), subRelaId: p.subRelaId.val()});
   		p.inputTxt.val('');
   	    p.inputTxt.attr("placeholder","回复  ");
   		p.targetUId.val('');
   		p.targetUName.val('');
   		p.subRelaId.val('');
   		var relaModule = "${relaModule}";
   		
   		if(relaModule != 'schedule' && relaModule != 'WorkReport'){
	   		$(".addBtn").css('display','');
	   		$(".examinerSend").css("display","none");
   		}
   		
   		$(".addBtn").css('display','none');
   		$(".examinerSend").css("display","");
   	});
   	
    //文本输入框点击事件
	/*p.inputTxt.unbind("keyup").bind("keyup", function(){//内容改变 、键盘输入完、 事件
		alert('');
		var v = $(this).val();
		if(v !== ''){
    		$(".examinerSend").css("display","");
    		$(".addBtn").css("display","none");
    	}else{
    		$(".examinerSend").css("display","none");
    		$(".addBtn").css("display","");
    	}
		
		handlerErtUserList(v, getTeamLeas());//输入@符号作的处理
	});
    */
}


//发送客户回复消息
function sendMsg(obj){
	if(!obj.v || obj.v.length > 255){
		$(".msgContainer").find("textarea[name=inputMsg]").attr("placeholder", "输入不合法!");
		return;
	}
	_initMessageControl();
	var dataObj = [];
	dataObj.push({name:'userId', value: '<%=partyId%>'});
	dataObj.push({name:'username', value: '<%=username%>'});
	dataObj.push({name:'targetUId', value: obj.tuid });
	dataObj.push({name:'targetUName', value: obj.tuname });
	dataObj.push({name:'content', value: obj.v });
	dataObj.push({name:'relaModule', value: '<%=relaModule%>'});
	dataObj.push({name:'relaName',value:'<%=relaName%>'});
	dataObj.push({name:'relaId', value: '<%=relaId%>'});
	dataObj.push({name:'subRelaId', value: obj.subRelaId });
	dataObj.push({name:'msgType',value:'txt'});
	dataObj.push({name:'readFlag', value: 'N'});
	//追加到DOM节点
	appendSingleMsg_MsgCore('<%=partyId%>', '我', dateFormat(new Date(), "MM-dd hh:mm"), obj.v, "desc");
	//异步调用保存数据
	$.ajax({
		url: '<%=smsgpath%>/msgs/save',
		type: 'get',
		data: dataObj,
		dataType: 'text',
	    success: function(data){
	    	var relaModule = "${relaModule}";
	    	if(relaModule != 'schedule'|| relaModule != 'WorkReport'){
	    		//$(".examinerSend").css("display","none");
		    	$(".addBtn").css('display','none');
	    	}
	    	$(".examinerSend").removeAttr("disabled").css({"display":"","background-color":"rgb(62, 144, 88)"});
	    	$(".addBtn").css('display','');
	    }
	});
}

</script>

<!--发送消息的区域  -->
<div class="msgContainer">
	<div class="ui-block-a" style="float: left; margin: 5px 0px 10px 10px;">
		<img id="upmenuimg"
			src="<%=smsgpath%>/scripts/plugin/menu/images/upmenu.png" width="30px"
			style="position: fixed;" onclick="swicthUpMenu('flootermenu')">
	</div>

	<div class="ui-block-a replybtn"
		style="width: 100%; margin: 5px 0px 5px 40px; padding-right: 105px;">
		<!-- 消息模块 -->
		<input name="msgModelType" type="hidden" value="<%=relaModule %>" />
		<!-- 子级关联ID -->
		<textarea name="inputMsg" id="inputMsg"
			style="width: 98%; font-size: 16px; line-height: 20px; height: 40px; margin-left: 5px; margin-top: 0px;"
			class="form-control" placeholder="回复"></textarea>
	</div>
	
	<c:if test="${relaModule ne 'schedule' && relaModule ne 'WorkReport' && relaModule ne 'Activity'}">
	<div class="ui-block-a "
		style="float: right; width: 60px; margin: -45px 5px 0px 0px;">
		<a href="javascript:void(0)" class="btn addBtn"
			style="font-size: 14px; width: 100%; background-color: RGB(255, 255, 255); border: 0px;"><img
			src="<%=smsgpath%>/image/followup.png" width="30px"></a> <a
			href="javascript:void(0)" class="btn examinerSend"
			style="font-size: 14px; display: none; width: 100%; background-color: rgb(62, 144, 88);"><b>发送</b></a>
	</div>
	</c:if>
	<c:if test="${relaModule eq 'schedule' || relaModule eq 'WorkReport' || relaModule eq 'Activity'}">
	<div class="ui-block-a " style="float: right;width: 60px;margin: -45px 5px 5px 0px;padding-left: 5px;">
						<a href="javascript:void(0)" class="btn  btn-block examinerSend" style="font-size: 14px;width:100%;">发送</a>
					</div>
		
	</c:if>
	<div style="clear: both;"></div>
</div>