<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
    String appFocusUrl = PropertiesUtil.getAppContext("app_focus_url");
%>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<style>
.feed_row{
	width:100% auto;
	height:65px;
	background-color:#fff;
	font-size:16px;
	border-bottom:1px solid #F2F2F2;
}

.feed_img_header{
	float: left;
	padding: 2px;
	background-color: #E5E5E5;
	margin: 5px 10px 5px 10px;
	height:50px;
	width:50px;
}

.feed_img_header_1{
	float: left;
	padding: 2px;
	margin: 5px 10px 5px 10px;
	height:50px;
	width:50px;
}
</style>
<script type="text/javascript">
	var feedMap = new TAKMap();
	var moduleMap = new TAKMap();
	var shareMap = new TAKMap();
	var msgMap = new TAKMap();
    $(function () {
    	//initForm();
    	//加载数据
    	//loadNextFeed(0);
	});

    //1. 加载团队用户列表
    function loadShareUserData(){
    	var cnt = 0;
    	moduleMap.each(function(rowId){
    		cnt ++;
    		var userids = shareMap.get(rowId);
    		if(userids){
    			var tmp = new Array();
    			var ids = userids.split(",");
    			for (var i=0;i<ids.length ;i++ ){
    				if(ids[i]){
    					tmp.push(ids[i]);
    				}
    				if(i == ids.length-1){
    					feedMap.put(rowId,tmp);
    				}
    			}
    		}
    	});
    	
    	//加载头像
    	loadImageHead();
    	
    	//加载新消息数
    	loadMessagesData();
    	
    }
       
    //2.加载图像
    function loadImageHead(){
    	moduleMap.each(function(rowId){
    		//取最后一次时间
	    	var userList = feedMap.get(rowId);
	    	var len = 0;
	    	if(userList){
	    		len = userList.length;
	    	}
	    	
	    	if(len == 0){
	    		return;
	    	}
	    	var imgs = "";
	    	for(var i=0;i<len;i++){
	    		if(i>=4){
	    			break; 
	    		}
	    		var userid = userList[i];
	    		if(sessionStorage.getItem("header_"+userid)){
	    			
	    			if(len == 1){
	    				if(sessionStorage.getItem("header_"+userid) == "<%=path %>/image/defailt_person.png"){
	    					imgs += '<img style="float:left;padding:1px;" src="<%=path %>/image/defailt_person.png" width="46px">';
		    			}else{
	    					imgs += '<img style="float:left;padding:1px;" src="data:image/jpeg;base64,'+sessionStorage.getItem("header_"+userid)+'" width="46px">';
		    			}
	    			}else{
	    				if(sessionStorage.getItem("header_"+userid) == "<%=path %>/image/defailt_person.png"){
	    					imgs += '<img style="float:left;padding:1px;" src="<%=path %>/image/defailt_person.png" width="22px">';
		    			}else{
	         	   			imgs += '<img style="float:left;padding:1px;" src="data:image/jpeg;base64,'+sessionStorage.getItem("header_"+userid)+'" width="22px">';
		    			}
	    			}
	    			$(".header_"+rowId).html(imgs);
	         	   	continue;
	            }
	    		
	    		//异步调用
	        	$.ajax({
	        		url: '<%=path%>/wxuser/getImger',
	        		data: {crmId: userid},
	        		//async: false,
	        		dataType: 'text',
	        	    success: function(data){
	        	    	if(data){
	        	    	    //本地缓存
	         	            sessionStorage.setItem("header_"+userid,data); 
	         	            if(len == 1){
	         	            	imgs += '<img style="float:left;padding:1px;" src="data:image/jpeg;base64,'+data+'" width="46px">';
		           			}else{
		           				imgs += '<img style="float:left;padding:1px;" src="data:image/jpeg;base64,'+data+'" width="22px">';
		           			}
	        	    	}else{
	        	    		if(len == 1){ 
	        	    			imgs += '<img style="float:left;padding:1px;" src="<%=path %>/image/defailt_person.png" width="46px">';
		           			}else{
		           				imgs += '<img style="float:left;padding:1px;" src="<%=path %>/image/defailt_person.png" width="22px">';
		           			}
	        	    		sessionStorage.setItem("header_"+userid,"<%=path %>/image/defailt_person.png");
	        	    	}
	        	    	$(".header_"+rowId).html(imgs);
	        	    },
	        	    error:function(){
	        	    }
	        	});
	    	}
	    	
    	});
    	
    	$(".indexmsg_loading").css("display","none");
    }
    
    //3. 加载消息数据
    function loadMessagesData(parenttype,rowId){
    	moduleMap.each(function(rowId){
	    	var dataObj = [];
	    	dataObj.push({name:'crmId', value:'${crmId}' });
	    	dataObj.push({name:'relaModule', value:moduleMap.get(rowId)});
	    	dataObj.push({name:'relaId', value: rowId});
	    	dataObj.push({name:'subRelaId', value: '' });
	    	dataObj.push({name:'currpage', value:'0' });
	    	dataObj.push({name:'pagecount', value:'1' });
	    	dataObj.push({name:'openId', value:'${openId}' });
	    	
	    	$.ajax({
	    	   type: 'get',
	    	   url: '<%=path%>/msgs/syncmsgcount',
	    	   data: dataObj || {},
	    	   dataType: 'text',
	    	   success: function(data){
	    		   if(data && data>0){
		   	    		var msg="";
		   	    		if(data > 100){
		   	    			msg='<div style="margin-top:-8px;color: #fff;font-size: 10px;position: absolute;border-radius: 18px; width: 18px; height: 18px;background-color:red;float:right;z-index:9;left: 50px;line-height:18px;text-align:center;">...</div>';
		   	    		}else{
		   	    			msg='<div style="margin-top:-8px;color: #fff;font-size: 10px;position: absolute;border-radius: 18px; width: 18px; height: 18px;background-color:red;float:right;z-index:9;left:50px;line-height:18px;text-align:center;">'+data+'</div>';
		   	    		}
		   	    		
		   	    		$(".header_"+rowId).prepend(msg);
   		 			}
	    		}
    		});
    	});
    	
    }
    
    //加载数据
    function loadNextFeed(value){
    	var currpage = $("#currpage").val();
    	if(parseInt(currpage)>=0){
    	currpage=parseInt(currpage)+parseInt(value);
    	}
    	if(parseInt(currpage)<0){
    		currpage="0";
    	}
    	$("#currpage").val(currpage);
    	if(parseInt(value)==0){
    		$("#msglist").html('');
    	}else{
    		$("#gotop").css("display",'block');
    	}
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/feed/allfeedlist',
		      //async: false,
		      data: {crmId:'${crmId}',viewtype:'myallview',openId:'${openId}',currpage:currpage,pagecount:'25'} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    
		    	    		$("#msglist").append('<div style="text-align:center;padding-top:60px;color:#999;">没有新消息</div>');
		    	    
		    	    	$(".indexmsg_loading").css("display","none");
						return;
	    	    	}
					if(d != ""){
		    	    	var feedstr = "";
		    	    	if(d[0].totalcount<1){

		    	    	$("#msglist").append('<div style="text-align:center;padding-top:60px;color:#999;">没有新消息</div>');
		    	    
		    	    	$(".indexmsg_loading").css("display","none");
						return;
		    	    	}
						$(d[0].msgFeedList).each(function(i){
							if(this.rowid == '' || this.rowid == 'undefined' ||  this.rowCount == ""){
								return;
							}
							var name = this.name;
							if(!name){
								return true;
							}
							if(name.length>12){
								name = name.substring(0,10)+"...";
							}
							feedstr = "";
							if(this.module == 'Accounts'){
								if(this.opertype == '0'){
									feedstr +='<a href="<%=path %>/customer/detail?orgId='+this.orgId+'&rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">';
								}
							}else if(this.module == 'Opportunities'){
								if(this.opertype == '0'){
									feedstr +='<a href="<%=path %>/oppty/detail?orgId='+this.orgId+'&rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">';
								}
							}else if(this.module == 'Tasks'){
								if(this.opertype == '0'){
									feedstr +='<a href="<%=path %>/schedule/detail?orgId='+this.orgId+'&rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">';
								}
							}else if(this.module == 'Contract'){
								if(this.opertype == '0'){
									feedstr +='<a href="<%=path %>/contract/detail?orgId='+this.orgId+'&rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">';
								}
							}
							feedstr += '<div class="_feeds_list feed_row" id="'+this.module+'_'+this.rowid+'">';
							feedstr += '<div class="imgHeader feed_img_header header_'+this.rowid+'" >';
							feedstr += '</div>';
							feedstr += '<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:14px;color:#333;">';
							var privateflag = "";
							if(this.orgId == 'Default Organization'){
								privateflag = '<img src="<%=path%>/image/unlock_pressed.png" width="12px">';
							}
							if(this.module == 'Accounts'){
								feedstr += '<div style="float:left;">客户'+privateflag+' | '+name + '</div>';
							}else if(this.module == 'Opportunities'){
								feedstr += '<div style="float:left;">生意'+privateflag+' | '+name + '</div>';
							}else if(this.module == 'Tasks'){
								feedstr += '<div style="float:left;">任务'+privateflag+' | '+name + '</div>';
							}else if(this.module == 'Contract'){
								feedstr += '<div style="float:left;">合同'+privateflag+' | '+name + '</div>';
							}else if(this.module == 'Quote'){
								feedstr += '<div style="float:left;">报价'+privateflag+' | '+name + '</div>';
							}else if(this.module == 'Contacts'){
								feedstr += '<div style="float:left;">联系人'+privateflag+' | '+name + '</div>';
							}else{
								feedstr += '<div style="float:left;">'+name + '</div>';
							}
							feedstr += '<div style="font-size:12px;float:right;color:#888;">'+this.msg.shorttime+'</div></div>'; 
							var content = this.msg.content;
							if(!content){
								content = "";
							}
							if(content.length>18){
								content = content.substring(0,15)+"...";
							}
							feedstr += '<div style="font-size:12px;color:#888;" class="message_'+this.rowid+'">'+this.msg.username+'：'+content+'</div>';
							feedstr += '</div>';
							feedstr += '</a>';
							feedstr += '<div style="clear: both;"></div>';
							//追加
							$("#msglist").append(feedstr);
							moduleMap.put(this.rowid,this.module);
							if(!this.shareusers){
								shareMap.put(this.rowid,this.operid);
							}else{
								shareMap.put(this.rowid,this.shareusers+","+this.operid);
							}
							
						});
						
						loadShareUserData();
						if(d[0].totalpage>parseInt(currpage)+1){
							$("#div_next").css("display",'');
						}else{
							$("#div_next").css("display",'none');
						}
		    	    }else{
		    	    
		    	    	$("#msglist").append('<div style="text-align:center;padding-top:60px;color:#999;">没有新消息</div>');
		    	    	
		    	    	$(".indexmsg_loading").css("display","none");
		    	    }
					
		      },
		      error:function(){
		    	  $(".indexmsg_loading").css("display","none");
		      }
		 });
	}
	function chooseTab(tab,type){
			$("#msgdiv").css("display","none");
			$("#sysmsglist").css("display","none");
			$(".tab2").css("display","none");	
			$(".tab11").css("background-color","rgb(130, 221, 205)");
			$(".tab12").css("background-color","rgb(130, 221, 205)");
			$(".tab11").css("color","#aaa");
			$(".tab12").css("color","#aaa");
			if(type=='msgdiv'){
				var a =$("#msglist").html();
				if(!a){
						$(".indexmsg_loading").css("display","");
						loadNextFeed(0);
				} 
			}
			$("#"+type).css("display","");
			$("."+tab).css("background-color","#efefef");
			$("."+tab).css("color","#555");
	}   
</script>


<script>
var timeout = undefined;
var msg = null;
$(function(){
    $(".del_message").css("left", (($(window).width()-$(".del_message").width()) / 2) + "px");
		$("._sysmsglist").bind("mousedown", function() {
			msg = $(this);
		    timeout = setTimeout(function() {
		        $(".del_message").css("display","");
		        $(".del_shade").css("display","");
		        $(".delmsg").attr("msgid",msg.attr("msgid"));
		    }, 800);
		});
		 
		$("._sysmsglist").bind("mouseup", function() {
		    clearTimeout(timeout);
		});
		
	
	$(".del_shade").click(function(e){
		$(".del_message").css("display","none");
		$(".del_shade").css("display","none");
		$(".delmsg").attr("msgid","");
	});
	
	$(".delmsg").click(function(){
		var msgid = $(this).attr("msgid");
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
		   	    		$(msg).remove();
		   	    		msg = null;
		   	    		$(".del_shade").trigger("click");
   		 		   }else{
   		 				msg = null;
	   	    			$(".del_shade").trigger("click");
   		 			 	alert('操作失败!');
   		 		   }
	    	   },
	    	   error:function(){
	    		   msg = null;
	   	    	   $(".del_shade").trigger("click");
	    		   alert('操作失败!');
	    	   }
    		});
		}else{
			msg = null;
	    	$(".del_shade").trigger("click");
		}
	});
});

</script>
	<!-- 活动流列表  -->
	<div>
		<input name="openId" type="hidden" value="">
		<input name="currpage" type="hidden" value="0" id="currpage">
	</div>
	<div style="margin:1px;border:1px solid RGB(75, 192, 171)	;border-radius:10px;height:35px;line-height:35px;font-size:14px;padding:0px 70px;">
	<a href="javascript:void(0)" onclick="chooseTab('tab11','sysmsglist')">
		<div class="tab11" style="background-color:#efefef;color:#555;width:50%;float:left;border-right:1px solid RGB(75, 192, 171);text-align:center;height:33px;line-height:33px;border-radius:10px 0px 0px 10px;">系统消息</div>
	</a>
	<a href="javascript:void(0)" onclick="chooseTab('tab12','msgdiv');">
		<div class="tab12" style="width:50%;float:left;text-align:center;height:33px;line-height:33px;border-radius:0px 10px 10px 0px;background-color:rgb(130, 221, 205);color:#aaa">业务消息</div>  
	</a>
</div>
	
	<div class="site-recommend-list page-patch" style="margin-top:10px;">
		<!-- 列表 -->
		<div class="" id="div_feed_list">
			<div class="feedsReplayCon" id="sysmsglist">
				<c:forEach items="${msgList }" var="msg">
					<c:if test="${msg.relaModule eq 'System_Activity' }">
						<a href="<%=PropertiesUtil.getAppContext("zjmarketing.url")%>/activity/detail?flag=share&id=${msg.relaId}&sourceid=${msg.targetUId}" msgid="${msg.id}" class="_sysmsglist">
							<div class="feed_row">
								<div class="feed_img_header_1">
									<img src="<%=path%>/scripts/plugin/wb/css/images/dc.png" width="36px">
								</div>
								<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:14px;color:#333;">
									<div class="" style="float:left;">
										<c:if test="${msg.username ne '' && !empty(msg.username)}">${msg.username }</c:if>
										<c:if test="${msg.username eq '' || empty(msg.username)}">指尖小秘书</c:if>
									</div>
									<div style="font-size:12px;float:right;color:#888;"><fmt:formatDate  value="${msg.createTime}" type="both" pattern="MM.dd HH:mm" /></div>
								</div>
								<div style="font-size:12px;color:#888;">
									${msg.content}
								</div>
							</div>
						</a>
					</c:if>
					<!-- 群 -->
					<c:if test="${msg.relaModule eq 'System_Group' }">
						<c:if test="${msg.msgType == 'exchange_apply' || msg.msgType == 'exchange_agree'  || msg.msgType == 'exchange_reject' || msg.msgType == 'group_apply' || msg.msgType=='group_notice'}">
							<a href="<%=path %>${msg.content}" userid="${msg.userId}" msgid="${msg.id}" class="_sysmsglist">
							    <div class="feed_row">
									<div class="feed_img_header_1">
										<img src="<%=path%>/scripts/plugin/wb/css/images/dc.png" width="36px">
									</div>
									<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:14px;color:#333;">
										<div class="" style="float:left;">${msg.username}</div>
										<div style="font-size:12px;float:right;color:#888;"><fmt:formatDate  value="${msg.createTime}" type="both" pattern="MM.dd HH:mm" /></div>
									</div>
									<div style="font-size:12px;color:#888;">
									   <c:if test="${msg.msgType == 'exchange_apply' }"><p style="color:#888;">申请与您交换名片</p></c:if>
									   <c:if test="${msg.msgType == 'exchange_agree' }"><p style="color:green;">同意与您的交换名片</p></c:if>
									   <c:if test="${msg.msgType == 'exchange_reject' }"><p style="color:red;">驳回了您的名片申请</p></c:if>
									   <c:if test="${msg.msgType == 'group_apply' }"><p style="color: #888;">申请加入您的群<c:if test="${msg.relaName ne '' && !empty(msg.relaName)}">【${msg.relaName}】</c:if></p></c:if>
									   <c:if test="${msg.msgType == 'group_notice' }"><p style="color:#888;">已经加入了您的群</p></c:if>
									</div>
								</div>
							</a>
						</c:if>
						
						<c:if test="${msg.msgType == 'group_agree' || msg.msgType == 'group_reject'}">
							<a href="${zjrm_url}${msg.content}&partyId=${partyId}" userid="${msg.userId}"  msgid=""${msg.id}" class="_sysmsglist">
							    <div class="feed_row">
									<div class="feed_img_header_1">
										<img src="<%=path%>/scripts/plugin/wb/css/images/dc.png" width="36px">
									</div>
									<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:14px;color:#333;">
										<div class="" style="float:left;">${msg.username}</div>
										<div style="font-size:12px;float:right;color:#888;"><fmt:formatDate  value="${msg.createTime}" type="both" pattern="MM.dd HH:mm" /></div>
									</div>
									<div style="font-size:12px;color:#888;">
									   <c:if test="${msg.msgType == 'group_agree' }"><p style="color: green;">同意了您的加群申请</p></c:if>
									   <c:if test="${msg.msgType == 'group_reject' }"><p style="color: red;">驳回了您的入群申请</p></c:if>
									</div>
								</div>
							</a>
						</c:if>
						
					</c:if>
					<c:if test="${msg.relaModule eq 'System_ChangeCard'}"> 
						<a href="<%=path%>/out/user/card?flag=Change&partyId=${msg.userId}&atten_partyId=${msg.targetUId}" msgid="${msg.id}" class="_sysmsglist">
							<div class="feed_row">
								<div class="feed_img_header_1">
									<img src="<%=path%>/scripts/plugin/wb/css/images/dc.png" width="36px">
								</div>
								<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:14px;color:#333;">
									<div class="" style="float:left;">
										<c:if test="${msg.username ne '' && !empty(msg.username)}">${msg.username }</c:if>
										<c:if test="${msg.username eq '' || empty(msg.username)}">指尖小秘书</c:if>
									</div>
									<div style="font-size:12px;float:right;color:#888;"><fmt:formatDate  value="${msg.createTime}" type="both" pattern="MM.dd HH:mm" /></div>
								</div>
								<div style="font-size:12px;color:#888;">
									${msg.content}
								</div>
							</div>
						</a>
					</c:if>
					<c:if test="${msg.relaModule eq 'System_AgreeCard'}"> 
						<a href="<%=path%>/out/user/card?flag=RM&partyId=${msg.userId}&atten_partyId=${msg.targetUId}" msgid="${msg.id}" class="_sysmsglist">
							<div class="feed_row">
								<div class="feed_img_header_1">
									<img src="<%=path%>/scripts/plugin/wb/css/images/dc.png" width="36px">
								</div>
								<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:14px;color:#333;">
									<div class="" style="float:left;">
										<c:if test="${msg.username ne '' && !empty(msg.username)}">${msg.username }</c:if>
										<c:if test="${msg.username eq '' || empty(msg.username)}">指尖小秘书</c:if>
									</div>
									<div style="font-size:12px;float:right;color:#888;"><fmt:formatDate  value="${msg.createTime}" type="both" pattern="MM.dd HH:mm" /></div>
								</div>
								<div style="font-size:12px;color:green;">
									${msg.content}
								</div>
							</div>
						</a>
					</c:if>
					<c:if test="${msg.relaModule eq 'System_RejectCard' }"> 
						<a href="<%=path%>/out/user/card?flag=RM&partyId=${msg.userId}&atten_partyId=${msg.targetUId}" msgid="${msg.id}" class="_sysmsglist">
							<div class="feed_row">
								<div class="feed_img_header_1">
									<img src="<%=path%>/scripts/plugin/wb/css/images/dc.png" width="36px">
								</div>
								<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:14px;color:#333;">
									<div class="" style="float:left;">
										<c:if test="${msg.username ne '' && !empty(msg.username)}">${msg.username }</c:if>
										<c:if test="${msg.username eq '' || empty(msg.username)}">指尖小秘书</c:if>
									</div>
									<div style="font-size:12px;float:right;color:#888;"><fmt:formatDate  value="${msg.createTime}" type="both" pattern="MM.dd HH:mm" /></div>
								</div>
								<div style="font-size:12px;color:red;">
									${msg.content}
								</div>
							</div>
						</a>
					</c:if>
					<c:if test="${msg.relaModule eq 'System_Task_Welcome' }"> 
						<a href="<%=path%>/out/user/card?flag=RM&partyId=${msg.userId}&atten_partyId=${msg.targetUId}" msgid="${msg.id}" class="_sysmsglist">
							<div class="feed_row">
								<div class="feed_img_header_1">
									<img src="<%=path%>/scripts/plugin/wb/css/images/dc.png" width="36px">
								</div>
								<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:14px;color:#333;">
									<div class="" style="float:left;">
										<c:if test="${msg.username ne '' && !empty(msg.username)}">${msg.username }</c:if>
										<c:if test="${msg.username eq '' || empty(msg.username)}">系统任务</c:if>
									</div>
									<div style="font-size:12px;float:right;color:#888;"><fmt:formatDate  value="${msg.createTime}" type="both" pattern="MM.dd HH:mm" /></div>
								</div>
								<div style="font-size:12px;color:red;">
									${msg.content}
								</div>
							</div>
						</a>
					</c:if>
					<c:if test="${msg.relaModule eq 'System_Task_CreateCard' }"> 
						<a href="<%=path%>/out/user/card?flag=RM&partyId=${msg.userId}&atten_partyId=${msg.targetUId}" msgid="${msg.id}" class="_sysmsglist">
							<div class="feed_row">
								<div class="feed_img_header_1">
									<img src="<%=path%>/scripts/plugin/wb/css/images/dc.png" width="36px">
								</div>
								<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:14px;color:#333;">
									<div class="" style="float:left;">
										<c:if test="${msg.username ne '' && !empty(msg.username)}">${msg.username }</c:if>
										<c:if test="${msg.username eq '' || empty(msg.username)}">系统任务</c:if>
									</div>
									<div style="font-size:12px;float:right;color:#888;"><fmt:formatDate  value="${msg.createTime}" type="both" pattern="MM.dd HH:mm" /></div>
								</div>
								<div style="font-size:12px;color:red;">
									${msg.content}
								</div>
							</div>
						</a>
					</c:if>
					<c:if test="${msg.relaModule eq 'System_ZJWK_Subscribe' }"> 
						<a href="<%=appFocusUrl%>" class="_sysmsglist">
							<div class="feed_row">
								<div class="feed_img_header_1">
									<img src="<%=path%>/scripts/plugin/wb/css/images/dc.png" width="36px">
								</div>
								<div style="width:100%;line-height:25px;height:35px;padding:5px;font-size:14px;color:#333;">
									<div class="" style="float:left;">
										<c:if test="${msg.username ne '' && !empty(msg.username)}">${msg.username }</c:if>
										<c:if test="${msg.username eq '' || empty(msg.username)}">关注指尖微客公众号任务</c:if>
									</div>
									<div style="font-size:12px;float:right;color:#888;"><fmt:formatDate  value="${msg.createTime}" type="both" pattern="MM.dd HH:mm" /></div>
								</div>
								<div style="font-size:12px;color:red;">
									${msg.content}
								</div>
							</div>
						</a>
					</c:if>
					<div style="clear: both;"></div>
				</c:forEach>
			</div>
				<div id="msgdiv">
				<div class="feedsReplayCon" id="msglist"></div>
				<div style="width: 100% auto; text-align: center; background-color: #fff; margin: 8px; padding: 8px; border: 1px solid #ddd;display:none" id="div_next">
				<a href="javascript:void(0)" onclick="loadNextFeed(1)"> <span class="nextspan">下一页</span>&nbsp;<img id="nextpage" src="/ZJWK/image/nextpage.png" width="24px">
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
	</div>
	<div class="indexmsg_loading"  style="position:fixed;top:50%;left:45%;display:none"><img src="<%=path %>/image/loading.gif">
	
	</div>

	
	
	