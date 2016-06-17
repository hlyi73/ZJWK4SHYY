<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
    String req_type = request.getParameter("req_type");
    req_type = (null == req_type?"":req_type);
%>

<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css" rel="stylesheet" type="text/css" />
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/style.css">
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css">
<script type="text/javascript">

    $(function () {
    	initForm();
    	//加载数据
    	loadNextFeed();
    	//loadData();
    	//发送消息
    	initSendMsg();
    	//消息框控制
    	autoTextArea("inputMsg");
	});
    
    //初始化表单
    function initForm(){
    	$(".feeds_shade").bind("click",function(){
    		$(".feeds_shade").css("display","none");
    		$("._repla_messgae_area").css("display","none");
    		$("._repla_messgae_area textarea[name=inputMsg]").attr("placeholder","回复 ");
    	});
    	$("input[name=currpage]").val(0);
    }
    
    //加载数据
    function loadData(){
    	$("._feeds_list").each(function(){
    		var id = $(this).attr("id");
    		var tmp = id.split("_");
    		if(tmp.length == 2){
    			//加载团队
    			loadShareUserData(tmp[0],tmp[1]);
    			//加载业务数据
    			loadBusinessData(tmp[0],tmp[1]);
    			//加载订阅
    			loadSubFeeds(tmp[1]);
    		}
    	});
    }

    //1. 加载团队用户列表
    function loadShareUserData(parenttype,rowId){
    	asyncInvoke({
    		url: '<%=path%>/shareUser/shareUsersList',
    		data: {
    			openId: '${openId}',
	 			publicId: '${publicId}',
	 			rowId: rowId,
	 			parenttype: parenttype
    		},
    	    callBackFunc: function(data){
    	    	if(!data) return;
    	    	var d = JSON.parse(data);
    	    	$(d).each(function(){
    	    		var team = '<div style="float:left;margin:8px;text-align:center;">';
    	    		if(sessionStorage.getItem("header_"+this.shareuserid)){
    	    			team += '<img readflag="Y" id="header_'+this.shareuserid+'"  style="border-radius: 10px;" src="'+sessionStorage.getItem("header_"+this.shareuserid)+'" width="40px">';
    	    		}else{
    	    			team += '<img id="header_'+this.shareuserid+'"  style="border-radius: 10px;" src="<%=path %>/image/defailt_person.png" width="40px">';
    	    			//加载图像
    	    			loadImageHead("header_"+this.shareuserid,this.shareuserid);
    	    		}
    	    		if(this.shareusername.length > 4){
    	    			team += "<br/>"+this.shareusername.substring(0,3)+"...";
    	    		}else{
    	    			team += "<br/>"+this.shareusername;
    	    		}
    	    		team += '</div>';
    	    		$("#team_"+rowId).append(team);
    	    		$("#"+parenttype+"_"+rowId).attr("teamflag","N");
    	    	});
    	    }	
    	});
    }
    
    //2. 加载业务对象变化数据
    function loadBusinessData(parenttype,rowId){
    	var dataObj = [];
    	dataObj.push({name:'crmid', value:'${crmId}' });
    	dataObj.push({name:'parenttype', value:parenttype});
    	dataObj.push({name:'parentid', value: rowId});
    	dataObj.push({name:'openid', value: '${openId}' });
    	dataObj.push({name:'publicid', value:'${publicId}'});
    	
    	$.ajax({
    	   type: 'get',
    	   url: '<%=path%>/trackhis/asycnlist',
    	   data: dataObj || {},
    	   dataType: 'text',
    	   success: function(data){
    		    if(!data) return;
    		    var d = JSON.parse(data);
    		    var msgcount = 0;
   	    		$(d).each(function(){
	   	    		var msgs = '<div style="line-height:25px;margin-top:10px;font-size:12px;color:#666;" onclick="sendMsg(\''+parenttype+'\',\''+rowId+'\',\''+this.opid+'\',\''+this.opname+'\')">';
	   	    		if(sessionStorage.getItem("header_"+this.opid)){
	   	    			//msgs += '<img readflag="Y" style="border-radius: 12px;" src="'+sessionStorage.getItem("header_"+this.opid)+'" width="24px">&nbsp;';
	   	    		}else{
	   	    			//msgs += '<img id="header_'+this.opid+'" style="border-radius: 12px;" src="<%=path %>/image/defailt_person.png" width="24px">&nbsp;';
	   	    			//loadImageHead("header_"+this.opid,this.opid);
	   	    		}
	   	    		
	   	    		if(this.optype == 'contact'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加联系人：<a href="<%=path%>/contact/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'tasks'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加任务：<a href="<%=path%>/schedule/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'&shcetype=task">'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'oppty'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加生意：<a href="<%=path%>/oppty/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'oppty_amount'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修改生意金额：'+this.beforevalue + '->￥' +this.aftervalue+'</div>';
	   	    		}else if(this.optype == 'oppty_closed'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修改生意关闭日期：'+this.beforevalue + '->' +this.aftervalue+'</div>';
	   	    		}else if(this.optype == 'oppty_event'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加强制性事件：'+this.aftervalue+'</div>';
	   	    		}else if(this.optype == 'oppty_value'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加价值主张：'+this.aftervalue+'</div>';
	   	    		}else if(this.optype == 'oppty_stage'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修改生意阶段：'+this.beforevalue + '->' +this.aftervalue+'</div>';
	   	    		}else if(this.optype == 'oppty_competitor'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 调整竞争策略：'+this.beforevalue + '->' +this.aftervalue+'</div>';
	   	    		}else if(this.optype == 'oppty_rival'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加竞争对手：<a href="<%=path%>/customer/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'oppty_partner'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加合作伙伴：<a href="<%=path%>/customer/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'casevisit'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加服务回访：'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'caseexec'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加服务执行：'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'case_status'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修改服务状态：'+this.beforevalue + '->' +this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'case_finish_time'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 完成服务：'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'share'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 添加团队成员：'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'expense'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 报销了一笔费用：'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'cancel_share'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 删除团队成员：'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'assign'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修改责任人：'+this.beforevalue + '->'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'bugs'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 解决了一个Bug：<a href="<%=path%>/bug/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
	   	    		}else if(this.optype == 'close_bugs'){
	   	    			msgs += '<span style="color:#3e6790;">'+this.opname+'</span> 修复了一个Bug：<a href="<%=path%>/bug/detail?openId=${openId}&publicId=${publicId}&rowId='+this.parentid+'">'+this.aftervalue+'</a></div>';
	   	    		}
	   	    		
	   	    		msgcount ++;
	   	    		
	   	    		$("#messages_"+rowId).prepend(msgs);
	   	    		$("#messages_title"+rowId).css("display","");
	   	    	});
   	    		$("#_msg_count_"+rowId).html(msgcount);
   	    		//加载消息
    			loadMessagesData(parenttype,rowId);
    	   }
    	});
    }
    
    //3. 加载消息数据
    function loadMessagesData(parenttype,rowId){
    	var dataObj = [];
    	dataObj.push({name:'crmId', value:'${crmId}' });
    	dataObj.push({name:'relaModule', value:parenttype});
    	dataObj.push({name:'relaId', value: rowId});
    	dataObj.push({name:'subRelaId', value: '' });
    	dataObj.push({name:'currpage', value:'0' });
    	dataObj.push({name:'pagecount', value:'5' });
    	
    	$.ajax({
    	   type: 'get',
    	   url: '<%=path%>/msgs/asynclist',
    	   data: dataObj || {},
    	   dataType: 'text',
    	   success: function(data){
    		    if(!data) return;
    		    var d = JSON.parse(data);
    		    var msgcount = $("#_msg_count_"+rowId).html();
   	    		$(d).each(function(){
	   	    		var msgs = '<a href="javascript:void(0)" onclick="sendMsg(\''+parenttype+'\',\''+rowId+'\',\''+this.userId+'\',\''+this.username+'\')"><div style="line-height:25px;margin-top:10px;font-size:12px;color:#666;">';
	   	    		if(sessionStorage.getItem("header_"+this.userId)){
	   	    			//msgs += '<img readflag="Y" style="border-radius: 12px;" src="'+sessionStorage.getItem("header_"+this.userId)+'" width="24px">&nbsp;';
	   	    		}else{
	   	    			//msgs += '<img id="header_'+this.userId+'" style="border-radius: 12px;" src="<%=path %>/image/defailt_person.png" width="24px">&nbsp;';
	   	    			//loadImageHead("header_"+this.userId,this.userId);
	   	    		}
					if(this.targetUID){
						msgs += '<span style="color:#3e6790;">'+this.username+'</span> 回复'+this.targetName+'：'+this.content+'</div></a>';
					}else{
						msgs += '<span style="color:#3e6790;">'+this.username+'</span> 回复：'+this.content+'</div></a>';
					}
					msgcount ++;
	   	    		$("#messages_"+rowId).append(msgs);
	   	    		$("#messages_title"+rowId).css("display","");
	   	    	});
   	    		$("#_msg_count_"+rowId).html(msgcount);
    	   }
    	});
    }
    
    //显示消息框
    function sendMsg(module,rowid,targetUID,targetName){
    	//赋值
    	if(targetUID){
    		$("._repla_messgae_area input[name=targetUID]").val(targetUID);
    	}else{
    		$("._repla_messgae_area input[name=targetUID]").val('');
    	}
    	if(targetName){
    		$("._repla_messgae_area input[name=targetUName]").val(targetName);
    		$("._repla_messgae_area textarea[name=inputMsg]").attr("placeholder","回复 " + targetName);
    	}else{
    		$("._repla_messgae_area input[name=targetUName]").val('');
    	}
    	$("._repla_messgae_area input[name=relaModule]").val(module);
    	$("._repla_messgae_area input[name=relaId]").val(rowid);
    	//显示消息对话框
    	$("._repla_messgae_area").css("display","");
    	//
    	$(".feeds_shade").css("display","");
    }
    
    
    
    //回复消息
    function initSendMsg(){
    	$("._send_message_button").bind("click",function(){
    		$("._repla_messgae_area textarea[name=inputMsg]").attr("placeholder","回复 ");
    		var targetUID = $("._repla_messgae_area input[name=targetUID]").val();
    		var targetName = $("._repla_messgae_area input[name=targetUName]").val();
    		var relaModule = $("._repla_messgae_area input[name=relaModule]").val();
    		var relaId = $("._repla_messgae_area input[name=relaId]").val();
    		var content = $("._repla_messgae_area textarea[name=inputMsg]").val();
    		var dataObj = [];
        	dataObj.push({name:'ownerCrmId', value: '${crmId}'});
        	dataObj.push({name:'ownerOpenId', value: '${openId}'});
        	dataObj.push({name:'userId', value:'${crmId}'});
        	dataObj.push({name:'username', value: '${assigner}'});
        	dataObj.push({name:'targetUId', value: targetUID});
        	dataObj.push({name:'targetUName', value: targetName});
        	dataObj.push({name:'msgType', value:'txt'});
        	dataObj.push({name:'content', value: content });
        	dataObj.push({name:'relaModule', value: relaModule});
        	dataObj.push({name:'relaId', value: relaId});
        	dataObj.push({name:'subRelaId', value: '' });
        	dataObj.push({name:'readFlag', value: 'N'});
        	dataObj.push({name:'createTime', value: new Date()});
        	dataObj.push({name:'assignerid', value: '${assigner}'});
        	
        	//
        	$("#messages_title"+relaId).css("display","");
	   	    $("._repla_messgae_area textarea[name=inputMsg]").val('');
	   	    $("._repla_messgae_area").css("display","none");
	   	    	
	   	    _initMessageControl();
	   	    $(".feeds_shade").css("display","none");
	   	    	
	   	    //更新消息计数
	   	    var msgcount = $("#_msg_count_"+relaId).html();
	   	    $("#_msg_count_"+relaId).html(++msgcount);
        	//
        	//异步调用保存数据
        	$.ajax({
        		url:'<%=path%>/msgs/save',
        		type: 'get',
        		data: dataObj,
        		dataType: 'text',
        	    success: function(data){
        	    	if(!data){
        	    		return;
        	    	}
        	    	var msgs = '<a href="javascript:void(0)" onclick="sendMsg(\''+relaModule+'\',\''+relaId+'\',\'${crmId}\',\'${assigner}\')"><div style="line-height:25px;margin-top:10px;font-size:12px;color:#666;" >';
        	    	if(sessionStorage.getItem("header_${crmId}")){
             	   		//$(this).attr("src", sessionStorage.getItem("header_${crmId}"));
             	   		//msgs += '<img style="border-radius: 12px;" src="'+sessionStorage.getItem("header_${crmId}")+'" width="24px">&nbsp;';
             	   	}else{
             	   		//msgs += '<img style="border-radius: 12px;" src="<%=path %>/image/defailt_person.png" width="24px">&nbsp;';
             	   	}
					
					if(targetUID){
						msgs += '<span style="color:#3e6790;">${assigner}</span> 回复'+targetName+'：'+content+'</div></a>';
					}else{
						msgs += '<span style="color:#3e6790;">${assigner}</span> 回复：'+content+'</div></a>';
					}
					
	   	    		$("#messages_"+relaId).append(msgs);
	   	    		
	   	    		
        	    }
        	});
    	});
    }
   
    //加载图像
    function loadImageHead(img,userId){
    	if(sessionStorage.getItem("header_"+userId)){
     	   	$("#"+img).attr("src", sessionStorage.getItem("header_"+userId));
     	   	return;
         }

    	//异步调用获取消息数据
    	asyncInvoke({
    		url: '<%=path%>/wxuser/getImgHeader',
    		data: {crmId: userId},
    	    callBackFunc: function(data){
    	    	$("#"+img).attr({"src":data,"readflag":"Y"});
    	    	if(data){
    	    	    //本地缓存
     	            sessionStorage.setItem("header_"+userId,data);
    	    	}else{
    	    		sessionStorage.setItem("header_"+userId,"<%=path %>/image/defailt_person.png");
    	    	}
    	    }
    	});
    }

    
    //下一页
    function loadNextFeed(){
    	//alert('1');
    	$("#nextpage").attr("src","../image/loading.gif");
		var currpage = $("input[name=currpage]").val();
		$("input[name=currpage]").val(parseInt(currpage) + 1);
		currpage = $("input[name=currpage]").val();
		//alert('2');
		$.ajax({
		      type: 'get',
		      url: '<%=path%>/feed/feedlist',
		      //async: false,
		      data: {currpage:currpage,crmId:'${crmId}',pagecount:'10'} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	      if(currpage == 1){
		    	    	  $(".feedsReplayCon").append('<div style="text-align:center;padding-top:40px;">没有找到数据</div>');
		    	      }
	    	    	  $("#div_next").css("display",'none');
						return;
	    	    	}
					if(d != ""){
		    	    	if($(d).size() == 10){
		    	    		$("#div_next").css("display",'');
		    	    	}else{
		    	    		$("#div_next").css("display",'none');
		    	    	}
		    	    	var feedstr = "";
						$(d).each(function(i){
							if(this.rowid == '' || this.rowid == 'undefined' ||  this.rowCount == ""){
								return;
							}
							feedstr = '<div class="_feeds_list" id="'+this.module+'_'+this.rowid+'" style="width:100% auto;margin-left:10px;margin-right:10px;margin-top:10px;background-color:#fff;font-size:16px;border:1px solid #ddd;border-radius:5px;">';
							feedstr += '<div style="float:left;padding:10px;" class="imgHeader" >';
							if(sessionStorage.getItem("header_"+this.operid)){
								feedstr += '<img headerflag="Y" id="header_'+this.operid +'" style="border-radius: 10px;" src="'+sessionStorage.getItem("header_"+this.operid)+'" width="45px">';
							}else{
								feedstr += '<img headerflag="Y" id="header_'+this.operid +'" style="border-radius: 10px;" src="<%=path %>/image/defailt_person.png" width="45px">';
							}
							
							feedstr += '</div>';
							feedstr += '<div style="width:100%;line-height:25px;height:60px;padding:8px;">';
							feedstr += '<div style="font-size:12px;"><div style="float:left;"><span style="color:#3e6790;">'+this.opername+'</span></div>';
							feedstr += '<div style="font-size:12px;float:right;">'+this.createdate+'</div></div>';
							feedstr += '<div style="font-weight:bold;margin-top:28px;border-bottom:1px solid #efefef;">';
							var name = this.name;
							if(!name){
								name = "";
							}
							if(name.length>12){
								name = name.substring(0,10)+"...";
							}
							if(this.module == 'Accounts'){
								if(this.opertype == '0'){
									feedstr +='添加客户【<a href="<%=path %>/customer/detail?rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">'+name+'</a>】';
								}
							}else if(this.module == 'Opportunities'){
								if(this.opertype == '0'){
									feedstr +='添加生意【<a href="<%=path %>/oppty/detail?rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">'+name+'</a>】';
								}
							}else if(this.module == 'Tasks'){
								if(this.opertype == '0'){
									feedstr +='添加任务【<a href="<%=path %>/schedule/detail?rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">'+name+'</a>】';
								}
							}else if(this.module == 'Contacts'){
								if(this.opertype == '0'){
									feedstr +='添加联系人【<a href="<%=path %>/contact/detail?rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">'+name+'</a>】';
								}
							}else if(this.module == 'Campaigns'){
								if(this.opertype == '0'){
									feedstr +='添加市场活动【<a href="<%=path %>/contact/detail?rowId='+this.rowid+'&publicId=${publicId}&openId=${openId}">'+name+'</a>】';
								}
							}else if(this.module == 'Cases'){
								if(this.opertype == '0'){
									if(this.attr.attr6 == 'case'){
										feedstr +='发起服务请求【<a href="<%=path %>/complaint/detail?rowid='+this.rowid+'&servertype=case&crmid=${crmId }&publicid=${publicId}&openid=${openId}">'+name+'</a>】';
									}else{
										feedstr +='发起投诉【<a href="<%=path %>/complaint/detail?rowid='+this.rowid+'&servertype=complaint&crmid=${crmId }&publicid=${publicId}&openid=${openId}">'+name+'</a>】';
									}
								}
							}
							feedstr += '</div></div>';
							feedstr += '<div style="width:100%;margin-top:8px;line-height:25px;padding:0px 25px 0px 25px;font-size:14px; color:#555;">';
							//客户
							if(this.module == 'Accounts'){
								feedstr += '我找到了一个客户'+this.name;
								if(this.attr.attr1 != ''){
									feedstr += '，电话：'+this.attr.attr1;
								}
								if(this.attr.attr2 != ''){
									feedstr += '，地址：'+this.attr.attr2;
								}
							}
							//商机
							else if(this.module == 'Opportunities'){
								feedstr += '我发现了一个业务机会'+this.name;
								if(this.attr.attr1 != ''){
									feedstr += '，预计金额：￥'+this.attr.attr1;
								}
								if(this.attr.attr3 != ''){
									feedstr += '，预计关闭日期：'+this.attr.attr3;
								}
								if(this.attr.attr2 != ''){
									feedstr += '，目前正处于'+this.attr.attr2+'阶段。';
								}
							}
							//任务
							else if(this.module == 'Tasks'){
								feedstr += '我创建了一个任务'+this.name;
								if(this.attr.attr1 != ''){
									feedstr += '，于'+this.attr.attr1+'开始';
								}
								if(this.attr.attr2 != ''){
									feedstr += ','+this.attr.attr2+'结束';
								}
								if(this.attr.attr3 != ''){
									feedstr += '，目前状态为：'+this.attr.attr3;
								}
							}
							//
							else if(this.module == 'Contacts'){
								feedstr += '我找到了一个联系人'+this.name;
								if(this.attr.attr1 != ''){
									feedstr += '，职位：'+this.attr.attr1;
								}
								if(this.attr.attr2 != ''){
									feedstr += '，手机：'+this.attr.attr2;
								}
								if(this.attr.attr3 != ''){
									feedstr += '，电话：'+this.attr.attr3;
								}
							}
							//
							else if(this.module == 'Campaigns'){
								feedstr += '我创建了一个市场活动'+this.name;
								if(this.attr.attr1 != ''){
									feedstr += '，开始时间：'+this.attr.attr1;
								}
								if(this.attr.attr2 != ''){
									feedstr += '，结束时间：'+this.attr.attr2;
								}
								if(this.attr.attr3 != ''){
									feedstr += '，状态：'+this.attr.attr3;
								}
							}
							//
							else if(this.module == 'Cases'){
								if(this.attr.attr6 == 'case'){
									feedstr += '我发起了一个服务请求'+this.name;
								}else{
									feedstr += '我发起了一个投诉'+this.name;
								}
								if(this.attr.attr1 != ''){
									feedstr += '，创建时间：'+this.attr.attr1;
								}
								if(this.attr.attr2 != ''){
									feedstr += '，完成时间：'+this.attr.attr2;
								}
								if(this.attr.attr3 != ''){
									feedstr += '，状态：'+this.attr.attr3;
								}
							}
							feedstr += '</div>';
							feedstr += '<div id="team_'+this.rowid+'" style="width:100%;margin-top:5px;line-height:25px;padding-left:10px;font-size:12px; color:#999;min-height:60px;"></div>';
							feedstr += '<div style="clear: both;"></div>';
							feedstr += '<div class="feedsReplayRst" style="border-top:1px solid #eee;margin:10px;padding-top:10px;margin-left:10px;padding-right:10px;text-align:right;font-size:14px;">';
							feedstr += '<span class="feedrsp" style="padding-right:10px;">';
							feedstr += '<a href="javascript:void(0)" class="commonReplyBtn" onclick="sendMsg(\''+this.module +'\',\''+this.rowid+'\')"  ><img width="25px" style="margin-top:3px;" src="<%=path%>/image/wxcrm_messages.png"><span id="_msg_count_'+this.rowid+'">0</span></a>';
							feedstr += '</span>';
							if("${crmId}" != this.operid){
								feedstr += '<span class="subfeed" style="margin-left:10px;">';
								feedstr += '<a href="javascript:void(0)" class="commonReplyBtn subfeed_'+this.rowid+'" id="subfeed_'+this.rowid+'"><img id="subfeed_img_'+this.rowid +'" width="22px" src="<%=path%>/image/wxcrm_dingyue.png">&nbsp;<span id="_dingyue_count_'+this.rowid +'" class="_dingyue_count_'+this.rowid +'" >0</span></a>';
								feedstr += '</span>';
								feedstr += '<span class="subfeed" style="margin-left:10px;">';
								feedstr += '<a href="javascript:void(0)" class="commonReplyBtn subfeed_'+this.operid+'" id="subfeed_'+this.operid+'"><img id="subfeed_img_'+this.operid +'" class="subfeed_img_'+this.operid +'" width="22px" src="<%=path%>/image/feed.png">&nbsp;<span id="_dingyue_count_'+this.operid +'" class="_dingyue_count_'+this.operid +'">0</span></a>';
								feedstr += '</span>';
							}
							feedstr += '<ul class="twitterSec " style="display:none;margin-right:60px;"></ul></div>';
							feedstr += '<div id="messages_title_'+this.rowid+'" style="display:none;width:100%;text-align:left;padding:0px 10px 5px 10px;margin:0px 10px 10px 10px;border-bottom:1px solid #efefef;">全部回复</div>';
							feedstr += '<div id="messages_'+this.rowid+'" style="width:100%;text-align:left;padding:0px 10px 0px 10px;margin:0px 0px 10px 10px;"></div>';
							feedstr += '</div>';
							//追加
							$(".feedsReplayCon").append(feedstr);
							
							//加载团队
			    			loadShareUserData(this.module,this.rowid);
			    			//加载业务数据
			    			loadBusinessData(this.module,this.rowid);
			    			//加载订阅
			    			loadSubFeeds(this.rowid,'recode');
			    			loadSubFeeds(this.operid,'user');
			    			//加载图像
			    			if(!sessionStorage.getItem("header_"+this.operid)){
    	    					loadImageHead("header_"+this.shareuserid,this.shareuserid);
			    			}
			    			$("#nextpage").attr("src","../image/nextpage.png");
						});
						
		    	    }else{
		    	    	$("#nextpage").attr("src","../image/nextpage.png");
		    	    	$("#div_next").css("display",'none');
		    	    }
		      }
		 });
	}
    
    //加载用户订阅
    function loadSubFeeds(feedid,type){
    	
    	var obj = $("#subfeed_img_"+feedid);
    	var dataObj=[];
    	dataObj.push({name:'crmId',value:'${crmId}'});
    	dataObj.push({name:'feedid',value:feedid});
    	$.ajax({
    		url:'<%=path%>/feed/isSub',
    		type:'post',
    		data:dataObj,
    		dataType: 'text',
    		success:function(data){
    			if(!data){
    	    		return;
    	    	} 
    	    	var d = JSON.parse(data);
    	    	if(d.errorCode && d.errorCode !== '0'){
	    	    	return;
	    	    }else{
	    	    	var flag = d.errorMsg;
	    	    	if("false"==flag){
	    	    		if('user'==type){
			    	    	obj.attr("src","<%=path%>/image/feed.png");
			    	    	}else{
			    	    	obj.attr("src","<%=path%>/image/wxcrm_cancel_dingyue.png");
			    	    	}
			        	//var dycount = $("#_dingyue_count_"+feedid).html();
				    	$("._dingyue_count_"+feedid).html(d.count);
				    	//添加取消绑定事件
					    $(".subfeed_"+feedid).unbind("click").bind("click",function(){
					    	cancelSubFeed(feedid,type);
					    });
	    	    	}else{
	    	    		$(".subfeed_"+feedid).unbind("click").bind("click",function(){
	    	    			subFeed(feedid,type);
					    });
	    	    	}
	    	    }
    		}
    	});
    }
    
    //订阅
    function subFeed(feedid,type){
    	var obj = $(".subfeed_img_"+feedid);
		var dataObj = [];
		dataObj.push({name:'openId',value:'${openId}'});
		dataObj.push({name:'crmId',value:'${crmId}'});
		dataObj.push({name:'feedid',value:feedid});
		dataObj.push({name:'type',value:type});
		dataObj.push({name:'publicId',value:'${publicId}'});
		dataObj.push({name:'createTime', value: new Date()});
		$.ajax({
	    	url: '<%=path%>/feed/saveSub',
	    	type: 'post',
	    	data: dataObj,
	    	dataType: 'text',
	    	success: function(data){
	    	  	if(!data){
	    	  		return;
	    	  	} 
	    	  	var d = JSON.parse(data);
	    	  	if(d.errorCode && d.errorCode !== '0'){
	    	  		$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	  		$(".myMsgBox").delay(2000).fadeOut();
		       	  	return;
		        }else{
		        	if('user'==type){
		    	    	obj.attr("src","<%=path%>/image/feed.png");
		    	    	}else{
		    	    	obj.attr("src","<%=path%>/image/wxcrm_cancel_dingyue.png");
		    	    	}
		        	var dycount = $("#_dingyue_count_"+feedid).html();
			    	$("._dingyue_count_"+feedid).html(++dycount);
			    	//添加取消绑定事件
				    $(".subfeed_"+feedid).unbind("click").bind("click",function(){
				    	cancelSubFeed(feedid,type);
				    });
		        }
	    	}
	    });
    }
    
    //取消订阅
    function cancelSubFeed(feedid,type){
    	  var obj = $(".subfeed_img_"+feedid);
    	  var dataObj = [];
		  dataObj.push({name:'openId',value:'${openId}'});
		  dataObj.push({name:'crmId',value:'${crmId}'});
		  dataObj.push({name:'feedid',value:feedid});
		  dataObj.push({name:'type',value:type});
		  dataObj.push({name:'publicId',value:'${publicId}'});
		  dataObj.push({name:'flag',value:''});
		  $.ajax({
	    		url: '<%=path%>/feed/delSub',
	    		type: 'post',
	    		data: dataObj,
	    		dataType: 'text',
	    	    success: function(data){
	    	    	if(!data){
	    	    		return;
	    	    	} 
	    	    	var d = JSON.parse(data);
	    	    	if(d.errorCode && d.errorCode !== '0'){
	    	    		$(".myMsgBox").css("display","") .html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    		$(".myMsgBox").delay(2000).fadeOut();
		    	    	  	return;
		    	    }else{
		    	    	if('user'==type){
		    	    	obj.attr("src","<%=path%>/image/feed_save.png");
		    	    	}else{
		    	    	obj.attr("src","<%=path%>/image/wxcrm_dingyue.png");
		    	    	}
		    	    	var dycount = $("#_dingyue_count_"+feedid).html();
				    	$("._dingyue_count_"+feedid).html(--dycount);
		    	    	$(".subfeed_"+feedid).unbind("click").bind("click",function(){
				    		subFeed(feedid,type);
				    	});
		    	    }
	    	    }
	    });
    }
    
    //消息输入框
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

	<!-- 活动流列表  -->
	<div>
		<input name="openId" type="hidden" value="">
		<input name="currpage" type="hidden" value="0">
	</div>
	<div class="site-recommend-list page-patch" id="feed_div">
		<!-- 列表 -->
		<div class="" id="div_feed_list">
			<div class="feedsReplayCon">
				
			</div>
			<div style="clear: both;"></div>
		</div>

		<a href="javascript:void(0)" onclick="loadNextFeed()">
			<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;display:none;border:1px solid #ddd;" id="div_next">
				下一页&nbsp;<img id="nextpage" src="<%=path%>/image/nextpage.png" width="24px"/>
			</div>
		</a> 
	</div>


	<!-- 消息回复 DIV -->
	<div id="flootermenu" class=" flooter msgContainer _repla_messgae_area" style="display:none;z-index:999999;opacity:1;background-color:#fff;border-top:1px solid #ddd;">
	    <!-- 目标用户ID -->
		<input type="hidden" name="targetUID" />
		<!-- 目标用户名 -->
		<input type="hidden" name="targetUName" />
		<!-- 关联relaModel -->
		<input type="hidden" name="relaModule" />
		<!-- 关联ID -->
		<input type="hidden" name="relaId" />
		<!-- 子级关联ID -->
		<input type="hidden" name="subRelaId" />
		<div class="ui-block-a"
			style="float: left;margin: 5px 0px 10px 10px;">
			<img src="<%=path%>/scripts/plugin/menu/images/downmenu1.png"
				width="30px" style="position:fixed;bottom:10px;" onclick="swicthUpMenu2('flootermenu')">
		</div>
		<div
			style="width: 100%;margin: 5px 0px 5px 40px;padding-right: 110px;">
			<textarea name="inputMsg" id="inputMsg" style="width: 98%;font-size: 16px; line-height:20px;height: 40px;margin-left: 5px; margin-top: 0px;" class="form-control" placeholder="回复"></textarea>
		</div>
		<div class="ui-block-a " style="float: right;width: 60px;margin: -45px 8px 5px 0px;">
			<a href="javascript:void(0)" class="btn  btn-block _send_message_button" style="font-size: 14px;width:100%;">发送</a>
		</div>
	</div>
	<div class="feeds_shade menu_shade" style="display: none"></div>
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
