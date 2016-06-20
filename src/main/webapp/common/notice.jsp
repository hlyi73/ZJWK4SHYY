<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>

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

<script type="text/javascript">
	var timeout = undefined;
	var msgcount = 0;
    $(function () {
    	//天气
    	loadWeather();
    	
    	$("input[name=currpage]").val('0');
    	countMessages();
    	
    	loadTask();
    	
    	loadActivity();
		
		loadGroup();
		
		loadResource();
		
	});
	//总数
    function countMessages(){
    	$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/msgs/count',
	    	   data: {readFlag:'N'},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(data){
	    			   if(parseInt(data) >0){
	    				   msgcount = parseInt(data);
	    				   loadMessagesData('feedsReplayCon',5);
	    			   }else{
	    				   //$(".feedsReplayCon").append('<div class="" style="text-align:center;padding: 1em 0;font-size:14px;color:#999;">无</div>');
	    				   $(".div_more_notice").css("display","");
	    				   $(".indexmsg_loading").css("display","none");
	    			   }
	    			   
	    		   }else{
	    			  // $(".feedsReplayCon").append('<div class="" style="text-align:center;padding: 1em 0;font-size:14px;color:#999;">无</div>');
	    			   $(".div_more_notice").css("display","");
	    			   $(".indexmsg_loading").css("display","none");
	    		   }
	    		}
 		});
    }
    //加载消息
    function loadMessagesData(divclassid,pagecount){
    	var divObj = $("."+divclassid);
    	if(divclassid == 'feedsReplayCon'){
    		$("#nextpage").attr("src","<%=path%>/image/loading.gif");
			$(".nextspan").text('努力加载中...');
    	}
    	var currpage = $(":hidden[name=currpage]").val();
	    	var dataObj = [];
	    	dataObj.push({name:'currpage', value:currpage});
	    	dataObj.push({name:'pagecount', value:pagecount}); 
	    	dataObj.push({name:'readFlag',value:'N'});
	    	$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/msgs/readmsg',
	    	   data: dataObj || {},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(!data){
	    			  //divObj.append('<div class="" style="text-align:center;padding: 1em 0;font-size:14px;color:#999;">无</div>');
	    			   $(".div_more_notice").css("display","");
	    			   $(".indexmsg_loading").css("display","none");
	    			   return;
	    		   }
	    		   var d = JSON.parse(data);
	    		   
	    		   if(!d || d.length == 0){
	    			  // divObj.append('<div class="" style="text-align:center;padding: 1em 0;font-size:14px;color:#999;">无</div>');
	    			   $(".div_more_notice").css("display","");
	    			   $(".indexmsg_loading").css("display","none");
		   	    	   return;
   		 		   }
	    		   if(msgcount > (parseInt(currpage)+1)*d.length){
	    			   if(divclassid=='feedsReplayConAll'){
	    			   		$(":hidden[name=currpage]").val(parseInt(currpage)+1); 
	    			   		$("#div_next").css("display","");
	    			   }
	    			   
	    		   }else{
	    			   if(divclassid=='feedsReplayConAll'){
	    			   	   $("#div_next").css("display","none");
	    			   }
	    		   }
	    		   
	    		   $("#div_more").css("display","");
	    		   
	    		   if(divclassid=='feedsReplayConAll'){
	    		   		$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
				   		$(".nextspan").text('下一页');
	    		   }
	    		   $(".updatereadflagdiv").css("display","");
	    		   initMessages(d,divObj);
	    		}
    		});
    	
    }
    
    //组装消息
    function initMessages(d,divObj){
    	$(d).each(function(){
    		var relaModule = this.relaModule;
    		var msgtmp = message_template();
    		var dateStr = dateFormat(new Date(this.createTime.time), "MM-dd hh:mm");
    		var username = this.username;
    		var title = "";
    		if(!username){
    			username = '小薇';
    		}
    		msgtmp = msgtmp.replace("$$MESSAGE_ID",this.id);
    		msgtmp = msgtmp.replace("$$MESSAGE_DATETIME",dateStr);
    		if(this.headimgurl){
    			msgtmp = msgtmp.replace("$$MESSAGE_HEAD_IMAGE",this.headimgurl);
    		}else{
    			msgtmp = msgtmp.replace("$$MESSAGE_HEAD_IMAGE",'<%=path%>/scripts/plugin/wb/css/images/dc.png');
    		}

    		var msglink = "";
    		var msgType = this.msgType;
    		var relaName = this.relaName;
    		
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
				//msglink = '<%=path%>/businesscard/detail?flag=0&partyId='+this.userId;
				msglink = '<%=path%>/personalmsg/personalmsglist?bcpartyid=${curr_user.party_row_id}';
			}
			else if(relaModule == 'System_Personal_Msg'){//私信
				title = "【私信】";
				//msglink = '<%=path%>/businesscard/detail?flag=0&partyId='+this.userId;
			    msglink = '<%=path%>/personalmsg/personalmsglist?bcpartyid=${curr_user.party_row_id}';
			}
			else if(relaModule == 'System_LiuPer_Msg_Reply'){//留言回复
				title = "【留言】";
				//msglink = '<%=path%>/businesscard/detail?flag=0&partyId='+this.userId;
				msglink = '<%=path%>/personalmsg/personalmsglist?bcpartyid=${curr_user.party_row_id}';
			}
			else if(relaModule == 'Discugroup_Join' 
					|| relaModule == 'Discugroup_SetMgnUser' 
					|| relaModule == 'Discugroup_topicMsgTip'
					|| relaModule == 'Discugroup_ExitGroup'//退出了讨论组
					||	relaModule == 'Discugroup_AgreeJoinGroup'
					|| relaModule == 'Discugroup_AgreeAddEss')
			{//讨论组邀请消息
				title = "【讨论组】";
				msglink = '<%=path%>/discuGroup/detail?rowId='+this.relaId;
			}
			else if (relaModule == 'Discugroup_ApplyAddEss'
					||	relaModule == 'Discugroup_ApplyJoinGroup'
					|| relaModule == 'Discugroup_ApplyMass')//申请群发文章
			{
				title = "【讨论组】";
				msglink = '<%=path%>/discuGroup/manage?dgid='+this.relaId;
			}
			else if(relaModule == 'Discugroup_Mass'){//讨论组群发信息
				title = "【讨论组】";
				if(this.subRelaId == 'activity'){//活动
					msglink = "<%=path%>/zjwkactivity/detail?id="+this.relaId+"&source=wkshare&sourceid=${curr_user.party_row_id}";
					
				}else if(this.subRelaId == 'article'){//文章
					msglink = '<%=path%>/discuGroup/detail?rowId='+this.relaId;
				}
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
    			title = "【名片】";
				msgtmp = msgtmp.replace("$$MESSAGE_CONTENT",'申请与您交换名片');
			}else if(msgType == 'exchange_apply'){
				title = "【名片】";
				msgtmp = msgtmp.replace("$$MESSAGE_CONTENT",'同意与您的交换名片');
			}else if(msgType == 'exchange_reject'){
				title = "【名片】";
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
    		divObj.append(msgtmp);
    	});
    	//设置偶数行背景
    	//$(".feed_row:odd").css("background-color","#FAFAFA");
    	
    	$(".indexmsg_loading").css("display","none");
    	
		//点击消息时更新该消息的未读标志
		$("#sysmsglist").find("a").each(function(){
			var msgid = $(this).attr("msgid");
		    $(this).unbind("click").bind("click",function(){
				updateReadFlg(msgid);
		    });
		})
    }
    
    //更多通知
    function loadMoreMessages(){
    	$(".feedsReplayConAll").css("display","");
    }

    //消息模板
    var message_template = function(){
    	var html = ['<a href="$$MESSAGE_LINK" msgid="$$MESSAGE_ID" class="_sysmsglist">',
    		          '<div class="feed_row">',
    			          '<div class="feed_img_header_1">',
    			          	 '$$MESSAGE_READ_FLAG',
    			             '<img src="$$MESSAGE_HEAD_IMAGE" width="36px" style="border-radius: 5px;">',
    			          '</div>', 
    			          '<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:16px;color:#000;">',
    			             '<div class="" style="float:left;font-size:14px;">',
    			                '$$MESSAGE_TITLE',
    			             '</div>',
    			             '<div style="font-size:12px;float:right;color:#888;">$$MESSAGE_DATETIME</div>',
    			          '</div>',
    			          '<div style="font-size:14px;color:#888;">',
    			          	 '$$MESSAGE_CONTENT',
    			          '</div>',
    	              '</div>',
    		       '</a><div style="clear:both;"></div>'];
    	
       return html.join("");
    };
    
    var new_msg_title = function(){
    	var html = ['<div class="noreadflag" style="width:10px;height:10px;border-radius:5px;background-color:red;position: absolute;margin-left: 36px;margin-top:-2px;">&nbsp;</div>'];
    	return html.join("");
    }
    
    //加载天气
 	function loadWeather(){
 		$.ajax({
	    	type: 'post',
	    	url: '<%=path%>/home/getweather',
	    	data: {partyId:'${partyId}'},
	    	dataType: 'text',
	    	success: function(data){
	    		if(!data){
	    			return;
	    		}
	    		if($(window).width() > 640){
	    			$(".zjwk_fg_wrap .txt").css("width",640 - 110);
	    		}else{
	    			$(".zjwk_fg_wrap .txt").css("width",$(window).width() - 110);
	    		}
	    		var d=  JSON.parse(data);
	    		if(d && d.status == 'success'){
	    	   		var w1  = d.results[0].weather_data[0];
	    	   		var w2 = d.results[0].weather_data[1];
					$(".weather").append(d.results[0].currentCity+"：");
					$(".zjwk_fg_wrap .weather_div .icon1").css("backgroundImage","url("+w1.dayPictureUrl+")");
					$(".zjwk_fg_wrap .weather_div .icon1").html(w1.weather);
					$(".weather").append(" 温度"+w1.temperature+"，" + w1.wind +"，");
					$(".weather").append("预计明天"+w2.weather  + "，温度"+w2.temperature+"，" + w2.wind +"。");
	    		}
	    	}
 		});
 	}
 	
 	function formatDate(date){
 		var a = new Date(date);
 		var em=a.getMonth() + 1 ,ed = a.getDate();
 		if(em < 10){
 			em = '0' + em;
 		}
 		if(ed < 10){
 			ed = '0' + ed;
 		}
 		return a.getFullYear()+"-"+em+"-"+ed;
 	}
 	
    //加载未完成的任务
 	function loadTask(){
 		var startDate = formatDate(new Date());
 		var endDate = startDate;
 		var dataObj = [];
		dataObj.push({name:'startDate',value:startDate});
 		dataObj.push({name:'endDate', value:endDate});
 		dataObj.push({name:'currpage', value:'1'});
 		dataObj.push({name:'pagecount', value:'5'});
 		dataObj.push({name:'status',value:'In Progress,Planned,Not Started'});
 		dataObj.push({name:'viewtype', value:'calendarview'});
 		dataObj.push({name:'schetype', value:'task'});
 		$.ajax({
 			type: 'post',
 			url: '<%=path%>/schedule/tasklist',
 				data : dataObj || {},
 				dataType : 'text',
 				success : function(data) {
 					if(!data){
 						$(".todaytask").append('<div class="" style="text-align:center;padding: 0.8em 0;font-size:14px;color:#999;">今天没有任务！</div>');
						return;
 					}
 					var d = JSON.parse(data);
 					if(!d || $(d).size() == 0){
 						$(".todaytask").append('<div class="" style="text-align:center;padding: 0.8em 0;font-size:14px;color:#999;">今天没有任务！</div>');
 						return;
 					}else{
 						var i = 0;
 						var count=0;
 						$(d).each(function(i){
 							var shareusername = "";
 							if(d[i].desc=="1" || d[i].desc==""){
 								count++;
	 							//	shareusername = this.assigner;
	 							//i++;
	 							var val = '';
	 							if(d[i].relaname && d[i].relaname.length>8){
	 								d[i].relaname = d[i].relaname.substr(8)+"...";
	 							}
	 							val += '<div style="font-size:14px;color:#666;">';
	 							if(this.startdate.substr(11,5) == this.enddate.substr(11,5) || this.startdate.substr(11,5) == "00:00"){
	 								val += '<div style="float:left;width:50px;text-align:center;line-height:30px;padding:3px 10px;">全天</div>';   
	 							}else if(this.startdate.substr(0,10)<startDate&&startDate<this.enddate.substr(0,10)){
	 								val += '<div style="float:left;width:50px;text-align:center;line-height:30px;padding:3px 10px;">全天</div>';
	 							}else{
	 								val += '<div style="float:left;width:110px;text-align:center;line-height:30px;padding:3px 10px;">'+this.startdate.substr(11,5)+' - '+this.enddate.substr(11,5)+'</div>';
	 							}
	 							
	 							val += '<div style="margin-left:80px;text-align:left;line-height:30px;padding:3px;"><a href="<%=path%>/schedule/detail?orgId='+this.orgId+'&schetype='+this.schetype+'&rowId='+this.rowid+'">'+this.title+'<span style="margin-left:10px;">'+this.relaname+''+'</span></a>&nbsp;<span style="color:#999;font-size:12px;">('+shareusername+' '+this.statusname+')</span></div>';
	 							val += '</div>';
	 							$(".todaytask").append(val);
 							}
 						});
 						
						if( count == 0){
								$(".todaytask").append('<div class="" style="text-align:center;padding: 0.8em 0;font-size:14px;color:#999;">今天没有任务！</div>');
						}
						$("#div_more_task").css("display","");
 					}
 				}
 		});
 	}
    
 	//更新所有未读标志
    function updateReadFlg(msgid){
    	$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/msgs/updReadFlg',
	    	   data: {msgid:msgid},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(data && data == 'success'){
	    		   	  $(".noreadflag").remove();
	    		   	  $(".updatereadflagdiv").css("display","none");
	    		   }else{
 	    			   alert("更新失败！");
 	    		   }
	    	   }
    	});
    }
 	
 	//加载推荐活动
 	function loadActivity(){
 		$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/zjwkactivity/recomlist',
	    	   data: {},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(!data){
	    		   	  return;
	    		   }
	    		   var d = JSON.parse(data);
	    		   if(!d){
	    			   return;
	    		   }
	    		   
	    		   $(".activitylist_div").css("display","");
	    		   $(d).each(function(){
	    			   var val = '<a href="<%=path%>/zjwkactivity/detail?id='+this.id+'&source=WK&sourceid=${partyId}">';
	    			   val += '<div style="padding:8px 0px;font-size:14px;border-bottom:1px solid #eee;">';
	    			    if(this.headImageUrl){
							val += '<div style="float:left;"><a href="<%=path %>/businesscard/detail?partyId='+ this.create_by +'"><img src="'+this.headImageUrl +'" width="36px" style="border-radius:5px;"/></a></div>';
						}else{
							val += '<div style="float:left;"><img src="<%=path %>/image/defailt_person.png" width="36px" style="border-radius:5px;"/></div>';
						}
	    			   
	    			   val += '<div style="line-height:20px;">【活动】'+this.title+'</div>';
	    			   val += '<div style="padding-left:45px;line-height:20px;color:#999;">阅读 '+this.readnum +'&nbsp;&nbsp;&nbsp;赞 '+this.praisenum+'&nbsp;&nbsp;&nbsp;评论 '+this.commentnum +'&nbsp;&nbsp;&nbsp;报名 '+this.joinnum +'</div>';
	    			   val += '</div></a>';
					   val += '<div style="clear:both;"></div>'; 
	    			   $(".activitylist").append(val);
	    		   });
	    	   }
 		});
 	}
 	
 	//加载推荐讨论组
 	function loadGroup(){
 		$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/discuGroup/weightlist',
	    	   data: {currpages:'0',pagecounts:'3'},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(!data){
	    		   	  return;
	    		   }
	    		   var d = JSON.parse(data);
	    		   if(!d){
	    			   return;
	    		   }
	    		   
	    		   $(".activitylist_div").css("display","");
	    		   $(d).each(function(){
	    			   var val = '<a href="<%=path%>/discuGroup/detail?rowId='+this.id+'">';
	    			   val += '<div style="padding:8px 0px;font-size:14px;border-bottom:1px solid #eee;">';
	    			    if(this.head_img_url){
							val += '<div style="float:left;"><a href="<%=path %>/businesscard/detail?partyId='+ this.creator +'"><img src="'+this.head_img_url +'" width="36px" style="border-radius:5px;"/></a></div>';
						}else{
							val += '<div style="float:left;"><img src="<%=path %>/image/mygroup.png" width="36px" style="border-radius:5px;"/></div>';
						}
	    			   
	    			   val += '<div style="line-height:20px;">【讨论组】'+this.name+'</div>';
	    			   val += '<div style="padding-left:45px;line-height:20px;color:#999;">发起人：'+this.creator_name+'&nbsp;&nbsp;用户：'+this.dis_user_count +'&nbsp;&nbsp;话题：'+this.dis_topic_count+'</div>';
	    			   val += '</div></a>';
					   val += '<div style="clear:both;"></div>';
	    			   $(".activitylist").append(val);
	    		   });
	    	   }
 		});
 	}
 	
 	//加载文章
 	function loadResource(){
 		$.ajax({
	    	   type: 'post',
	    	   url: '<%=path%>/resource/syncsyslist',
	    	   data: {currpages:'0',pagecounts:'3'},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(!data){
	    		   	  return;
	    		   }
	    		   var d = JSON.parse(data);
	    		   if(!d){
	    			   return;
	    		   }
	    		   
	    		   $(".activitylist_div").css("display","");
	    		   $(d).each(function(){
	    			   var val = '<a href="<%=path%>/resource/detail?id='+this.resourceId+'">';
	    			   val += '<div style="padding:8px 0px;font-size:14px;border-bottom:1px solid #eee;">';
	    			    if(this.createUrl){
							val += '<div style="float:left;"><a href="<%=path %>/businesscard/detail?partyId='+ this.creator +'"><img src="${filepath}/'+this.createUrl +'" width="36px" style="border-radius:5px;"/></a></div>';
						}else{
							val += '<div style="float:left;"><img src="<%=path %>/image/mygroup.png" width="36px" style="border-radius:5px;"/></div>';
						}
	    			   
	    			   val += '<div style="line-height:20px;padding-left:42px;">【文章】'+this.resourceTitle+'</div>';
	    			   val += '<div style="padding-left:45px;line-height:20px;color:#999;">推荐人：'+this.createName+'&nbsp;&nbsp;阅读：'+this.readnum +'</div>';
	    			   val += '</div></a>';
					   val += '<div style="clear:both;"></div>';
	    			   $(".activitylist").append(val);
	    		   });
	    	   }
 		});
 	}
 	
 	
</script>
	<input name="currpage" type="hidden" value="0">	
<div class="zjwk_fg_wrap">
	<%--日期 --%>
	<div class="weather_div">
		<div class="icon icon1">&nbsp;</div>
		<div class="txt">
			<div class="year">${lunar }</div>
			<div style="padding-top:10px"> 
				<span>${currtime }</span>${currweek }
			</div>
			<div class="weather" style="padding-top:10px;"></div>
		</div>
	</div>

	<%--今日任务 --%>
	<div class="tmod titbox">
         <div style="float:right;" id="div_more_task"><a href="<%=path%>/calendar/calendar">更多</a></div> 
         <h3>今天日程</h3>
     </div>
     <div class="todaytask" style="">
			
	 </div>	

	<div class="tmod titbox">
         <div style="float:right;"><a href="javascript:void(0)" class="updatereadflagdiv" onclick="updateReadFlg();" style="display:none;">全部标志为已读</a></div>
         <h3>未读通知</h3>
     </div>
	
	<div style="padding:0px 10px;">
			<div class="feedsReplayCon" id="sysmsglist" style="-wekit-user-select:none;-moz-user-select:none;">
				
			</div>
			<div style="width: 100% auto; text-align:right; background-color: #fff;padding: 8px;display:none" id="div_more">
				<a href="<%=path%>/home/more"> 
					<span class="morenotice" style="font-size:14px;">更多</span>
				</a>
			</div>	
			<div class="div_more_notice" style="display:none;">
				<span style="color:#999;">没有新通知，</span><a href="<%=path%>/home/more"> 
					<span class="morenotice" style="font-size:14px;">查看历史通知</span>
				</a>
			</div>			
			<div class="gotop" style="display: none;"  id="gotop">
				<i class="icon icon-arrow-up"></i> 
			</div>
			<script type="text/javascript">
				window.$CONFIG = {};
				window.APP_PARAMS = null;
			</script> 	
		<div style="clear: both;"></div>
	</div>
	
	<div class="activitylist_div">
	   <div class="tmod titbox">
           <h3>系统推荐</h3>
       </div>
	   <div class="activitylist">
			
	   </div>	
	</div>
</div>	
<div class="indexmsg_loading"  style="position:fixed;top:30%;left:50%;margin-left:-10px;"><img src="<%=path%>/image/loading_data_027.gif"></div>

	