<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<style>
.feed_row{
	width:100% auto;
	height:58px;
	background-color:#fff;
	font-size:14px;
	border-bottom:1px solid #F2F2F2;
}

.feed_img_header{
	float: left;
	padding: 2px;
	background-color: #E5E5E5;
	margin: 8px 10px 5px 0px;
	height:45px;
	width:45px;
}

.feed_img_header_1{
	float: left;
	padding: 2px;
	margin: 8px 10px 5px 0px;
	height:45px;
	width:45px;
}
</style>


<script>
var timeout = undefined;
function delMsg(msgid,obj){
		if(msgid){
			var dataObj = [];
	    	dataObj.push({name:'id', value:msgid });
	    	$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/msgs/delmsg',
	    	   data: dataObj || {},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(data && data == 'success'){
		   	    		$("a[msgid="+msgid+"]").remove();
		   	    		$("#"+msgid).remove();
		   	    		if($(".feedsReplayCon").html() == ''){
		   	    			$(".feedsReplayCon").append('<div class="" style="text-align:center;padding: 2em 0; margin: 3em 0;font-size:14px;color:#999;">无数据</div>');
		   	    			$(".updatereadflagdiv").css("display","none");
		    				$(".allclear").css("display","none");
		   	    		}
   		 		   }else{
   		 			 	alert('操作失败!');
   		 		   }
	    	   },
	    	   error:function(){
	    		   alert('操作失败!');
	    	   }
    		});
		}
}

</script>

<script type="text/javascript">
	var msgcount = 0;
    $(function () {    	
    	$("input[name=currpage]").val('0');
    	countMessages();
	});
	//总数
    function countMessages(){
    	$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/msgs/count',
	    	   data: {},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(data){
	    			   if(parseInt(data) >0){
	    				   msgcount = parseInt(data);
	    				   loadMessagesData();
	    			   }else{
	    				   $(".feedsReplayCon").append('<div class="" style="text-align:center;padding: 2em 0; margin: 3em 0;font-size:14px;color:#999;">无数据</div>');
	    				   $(".indexmsg_loading").css("display","none");
	    				   $(".updatereadflagdiv").css("display","none");
	    				   $(".allclear").css("display","none");
	    			   }
	    		   }else{
	    			   $(".feedsReplayCon").append('<div class="" style="text-align:center;padding: 2em 0; margin: 3em 0;font-size:14px;color:#999;">无数据</div>');
	    			   $(".indexmsg_loading").css("display","none");
	    			   $(".updatereadflagdiv").css("display","none");
    				   $(".allclear").css("display","none"); 
	    		   }
	    		}
 		});
    }
    //加载消息
    function loadMessagesData(){
    	$("#nextpage").attr("src","<%=path%>/image/loading.gif");
		$(".nextspan").text('努力加载中...');
    	var currpage = $(":hidden[name=currpage]").val();
    	cpage = parseInt(currpage) * 10;
	    	var dataObj = [];
	    	dataObj.push({name:'currpage', value:cpage});
	    	dataObj.push({name:'pagecount', value:'10'}); 
	    	
	    	$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/msgs/readmsg',
	    	   data: dataObj || {},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(!data){
	    			   if(currpage==0){
		    			   $(".feedsReplayCon").append('<div class="" style="text-align:center;padding: 2em 0; margin: 3em 0;font-size:14px;color:#999;">无数据</div>');
	    			   }
	    			   $("#div_next").css("display","none");
	    			   $(".indexmsg_loading").css("display","none");
	    			   return;
	    		   }
	    		   var d = JSON.parse(data);
	    		   
	    		   if(!d || d.length == 0){
	    			   if(currpage==0){
		    			   $(".feedsReplayCon").append('<div class="" style="text-align:center;padding: 2em 0; margin: 3em 0;font-size:14px;color:#999;">无数据</div>');
	    			   }
	    			   $("#div_next").css("display","none");
	    			   $(".indexmsg_loading").css("display","none");
		   	    	   return;
   		 		   }
// 	    		   if(msgcount > parseInt(cpage)+d.length){
// 	    			   $(":hidden[name=currpage]").val(parseInt(currpage)+1); 
// 	    			   $("#div_next").css("display","");
// 	    		   }2015-04-27修改
					if(d.length==10){
						$(":hidden[name=currpage]").val(parseInt(currpage)+1); 
						$("#div_next").css("display","");
					}
	    		   else{
	    			   $("#div_next").css("display","none");
	    		   }
	    		   $("#nextpage").attr("src","<%=path%>/image/nextpage.png");
				   $(".nextspan").text('下一页');				   
	    		   initMessages(d);
	    		}
    		});
    	
    }
    
    //组装消息
    function initMessages(d){
    	$(d).each(function(){
    		var relaModule = this.relaModule;
    		var msgtmp = message_template();
    		var dateStr = dateFormat(new Date(this.createTime.time), "MM-dd hh:mm");
    		var username = this.username;
    		if(!username){
    			username = '小薇';
    		}
    		msgtmp = msgtmp.replace("$$MESSAGE_ID",this.id).replace("$$MESSAGE_ID",this.id);
    		msgtmp = msgtmp.replace("$$MESSAGEDIV_ID",this.id).replace("$$MESSAGEDIV_ID",this.id);
    		msgtmp = msgtmp.replace("$$MESSAGE_DATETIME",dateStr);
    		if(this.headimgurl){
    			msgtmp = msgtmp.replace("$$MESSAGE_HEAD_IMAGE",this.headimgurl);
    		}else{
    			msgtmp = msgtmp.replace("$$MESSAGE_HEAD_IMAGE",'<%=path%>/scripts/plugin/wb/css/images/dc.png');
    		}
    		
    		
    		var msglink = "";
    		var msgType = this.msgType;
    		var relaName = this.relaName;
    		var title = "";
    		
    		if(relaModule == 'System_Activity'){
				title = "【活动】";
    			msglink = '<%=path%>/zjwkactivity/detail?flag=share&id='+this.relaId+'&sourceid='+this.targetUId;
    		}
    		else if(relaModule == 'ManageActivity'){
    			title = "【活动】";
    			msglink = '<%=path%>/zjwkactivity/manage?id='+this.relaId;
    		}
    		else if(relaModule == 'System_Group'){
    			if(msgType == 'exchange_apply' || msgType == 'exchange_agree'  || msgType == 'exchange_reject' || msgType == 'group_apply' || msgType=='group_notice'){
    				msglink = '<%=path %>'+this.content;
    			}
    			else if(msgType == 'group_agree' || msgType == 'group_reject'){
    				msglink = '${zjrm_url}'+this.content+'&partyId=${partyId}';
    			}
    		}
    		else if(relaModule == 'System_ChangeCard'){
				title = "【名片】";
    			msglink = '<%=path%>/out/user/card?flag=Change&partyId='+this.userId+'&atten_partyId='+this.targetUId;
    		}
    		else if(relaModule == 'System_AgreeCard' || relaModule == 'System_RejectCard'){
				title = "【名片】";
    			msglink = '<%=path%>/out/user/card?flag=RM&partyId='+this.userId+'&atten_partyId='+this.targetUId;
    		}
    		else if(relaModule == 'schedule'){
				title = "【任务】";
    			msglink = '<%=path%>/schedule/detail?rowId='+this.relaId+"&orgId="+this.orgId;
    		}
			else if(relaModule == 'customer'){
				title = "【客户】";
				msglink = '<%=path%>/customer/detail?rowId='+this.relaId+"&orgId="+this.orgId;	
			}
			else if(relaModule=='WorkReport'){
				title = "【工作计划】";
				msglink = '<%=path%>/workplan/detail?rowId='+this.relaId+"&orgId="+this.orgId;
			}
			else if(relaModule == 'Opportunities'){
				title = "【生意】";
				msglink = '<%=path%>/oppty/detail?rowId='+this.relaId+"&orgId="+this.orgId;
			}else if(relaModule == 'System_Task_CreateCard'){
				msglink = '<%=path%>/out/user/card?flag=RM&partyId='+this.userId+'&atten_partyId='+this.targetUId;
			}else if(relaModule == 'System_ZJWK_Subscribe'){
				msglink = 'http://mp.weixin.qq.com/s?__biz=MzA3MDI2NjA4OA==&mid=202735151&idx=1&sn=1a0ba66956e70132fbeeff4da6718043#rd';
			}
			else if(relaModule == 'System_Liu_Msg'){//留言
				title = "【留言】";
				msglink = '<%=path%>/businesscard/detail?flag=0&partyId='+this.userId;
			}
			else if(relaModule == 'System_Personal_Msg'){//私信
				title = "【私信】";
				msglink = '<%=path%>/businesscard/detail?flag=0&partyId='+this.userId;
			}
			else if(relaModule == 'System_LiuPer_Msg_Reply'){//留言回复
				title = "【留言】";
				msglink = '<%=path%>/businesscard/detail?flag=0&partyId='+this.userId;
			}
			else if(relaModule == 'Discugroup_Join'){//讨论组邀请消息
				title = "【讨论组】";
				msglink = '<%=path%>/discuGroup/detail?rowId='+this.relaId;
			}else if(relaModule == 'Batch_Import_Contacts'){ //批量导入联系人
				title = "【系统消息】";
				msglink = '<%=path%>/cbooks/list';
			}
    		
    		
    		if(!msglink){
    			msglink = "javascript:void(0)";
    		}
    		msgtmp = msgtmp.replace("$$MESSAGE_LINK",msglink);
    		
    		if(this.relaName && (relaModule == 'customer' || relaModule == 'schedule' || relaModule == 'Opportunities')){
    			if(this.relaName && this.relaName.length > 10){
					msgtmp = msgtmp.replace("$$MESSAGE_TITLE",title+this.relaName.substr(0,10)+"...");
				}else{
					msgtmp = msgtmp.replace("$$MESSAGE_TITLE",title+this.relaName);
				}
    		}else{
    			msgtmp = msgtmp.replace("$$MESSAGE_TITLE",title+username);
    		}
    		
    		if(msgType == 'exchange_apply'){
				msgtmp = msgtmp.replace("$$MESSAGE_CONTENT",'申请与您交换名片');
			}else if(msgType == 'exchange_apply'){
				msgtmp = msgtmp.replace("$$MESSAGE_CONTENT",'同意与您的交换名片');
			}else if(msgType == 'exchange_reject'){
				msgtmp = msgtmp.replace("$$MESSAGE_CONTENT",'驳回了您的名片申请');
			}else if(msgType == 'group_apply'){
				if(relaName){
					msgtmp = msgtmp.replace("$$MESSAGE_CONTENT",'申请加入您的群【'+relaName+'】');
				}else{
					msgtmp = msgtmp.replace("$$MESSAGE_CONTENT",'申请加入您的群');
				}
			}else if(msgType == 'group_notice'){
				msgtmp = msgtmp.replace("$$MESSAGE_CONTENT",'已经加入了您的群');
	    	}else if(msgType == 'group_agree'){
	    		msgtmp = msgtmp.replace("$$MESSAGE_CONTENT",'同意了您的加群申请');
	    	}else{
	    		if(this.content && this.content.length > 15){
	    			msgtmp = msgtmp.replace("$$MESSAGE_CONTENT",username + "："+ this.content.substr(0,12)+'...');
	    		}else{
					msgtmp = msgtmp.replace("$$MESSAGE_CONTENT",username + "："+ this.content);
	    		}
			}
    		
    		if(this.readFlag == 'N'){
    			var tip = new_msg_title();
    			msgtmp = msgtmp.replace("$$MESSAGE_READ_FLAG",tip);
    		}else{
    			msgtmp = msgtmp.replace("$$MESSAGE_READ_FLAG","");
    		}
    		//
    		$(".feedsReplayCon").append(msgtmp);
    	});
    	//设置偶数行背景
    	$(".feed_row:odd").css("background-color","#FAFAFA");
    	
    	$(".indexmsg_loading").css("display","none");
    }

    //消息模板
    var message_template = function(){
    	var html = ['<a href="$$MESSAGE_LINK" msgid="$$MESSAGE_ID" class="_sysmsglist">',
    		          '<div class="feed_row" id="$$MESSAGEDIV_ID">',
    			          '<div class="feed_img_header_1">',
    			          	 '$$MESSAGE_READ_FLAG',
    			             '<img src="$$MESSAGE_HEAD_IMAGE" width="36px" style="border-radius: 18px;">',
    			          '</div>', 
    			          '<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:16px;color:#000;">',
    			             '<div class="" style="float:left;font-size:14px;">',
    			                '$$MESSAGE_TITLE',
    			             '</div>',
    			             '<div style="font-size:12px;float:right;color:#888;">$$MESSAGE_DATETIME</div>',
    			          '</div>', 
    			          '<div style="font-size:12px;color:#888;">',
    			          	 '$$MESSAGE_CONTENT<div style="float:right;" onclick="delMsg(\'$$MESSAGE_ID\',this);return false;"><img src="<%=path%>/image/delete_msg.png" style="width: 24px;padding: 5px;">',
    			          '</div>',
    	              '</div>',
    		       '</a><div style="clear:both;"></div>'];
    	
       return html.join("");
    };
    
    var new_msg_title = function(){
    	var html = ['<div class="noreadflag" style="width:10px;height:10px;border-radius:5px;background-color:red;position: absolute;margin-left: 36px;margin-top:-2px;">&nbsp;</div>'];
    	return html.join("");
    }
    
    //更新所有未读标志
    function updateReadFlg(){
    	$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/msgs/updReadFlg',
	    	   data: {},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(data && data == 'success'){
	    		   	  $(".noreadflag").remove();
	    		   	  $(".updatereadflagdiv").css("display","none");
	    		   }else{
 	    			   alert("更新失败！");
 	    		   }
	    	   },
	    	   error:function(){
	    		   alert("更新失败！");
	    	   }
    	});
    }
    
    //全部清除
    function deleteAll(){
    	if(confirm("确定要全部删除吗？")){
    		$.ajax({
 	    	   type: 'post',
 	    	   url: '<%=path%>/msgs/delallmsg',
 	    	   data: {},
 	    	   dataType: 'text',
 	    	   success: function(data){
 	    		   if(data && data == 'success'){
 	    			   window.location.replace("<%=path%>/home/index");
 	    		   }else{
 	    			   alert("删除失败！");
 	    		   }
 	    	   },
 	    	   error:function(){
 	    		  alert("删除失败！");
 	    	   }
     		});
    	}
    }

</script>
	<input name="currpage" type="hidden" value="0">	
	<div class="notice_menu" style="font-size:14px;width:100%;margin-top:5px;margin-bottom:5px;border-bottom:1px solid #ddd;border-top:1px solid #ddd;background-color:#fff;text-align:right;line-height:35px;padding-right:8px;">
	    <a href="javascript:void(0)" class="updatereadflagdiv" onclick="updateReadFlg()" style="padding:5px 8px;">全部标志为已读</a>
	    <a href="javascript:void(0)" class="allclear" onclick='deleteAll()' style="padding:5px 8px;">全部清除</a>
	</div>
	
	<div class="site-recommend-list page-patch" style="margin-top:10px;min-height:90%;background-color:#fff;">
		<!-- 列表 -->
		<div class="" id="div_feed_list">
			<div class="feedsReplayCon" id="sysmsglist" style="-wekit-user-select:none;-moz-user-select:none;">
				
			</div>
			<div style="width: 100% auto; text-align: center; background-color: #fff;padding: 8px; border-bottom: 1px solid #ddd;display:none" id="div_next">
				<a href="javascript:void(0)" onclick="loadMessagesData()"> 
					<span class="nextspan" style="font-size:14px;">下一页</span>&nbsp;<img id="nextpage" src="<%=path%>/image/nextpage.png" width="24px">
				</a>
			</div>			
			<div class="gotop" style="display: none;"  id="gotop">
				<i class="icon icon-arrow-up"></i> 
			</div>
		
			<script type="text/javascript">
				window.$CONFIG = {};
				window.APP_PARAMS = null;
			</script> 	
		</div>
		<div style="clear: both;"></div>
	</div>
	<div class="indexmsg_loading"  style="position:fixed;top:30%;left:50%;margin-left:-10px;"><img src="<%=path%>/image/loading_data_027.gif"></div>
	
	<jsp:include page="/common/menu.jsp" flush="true"></jsp:include>
	