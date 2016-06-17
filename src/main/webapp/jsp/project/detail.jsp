<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>

<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
  <script type="text/javascript">
    $(function () {
    	shareBtnContol();//初始化分享按钮
    	//initWeixinFunc();
    	initTeamCon();//团队成员
    	initForm();
    	renderTeamImgHead();//显示图片头像
    	renderTeamPerm();//初始化团队的权限
    	initBottomBtn();
    	initAssignerBtn();
	});
    
    //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			return false;
    		});
    	}
    }
    
    function initForm(){
		//发送消息
    	p.examinerSend.click(function(){
    		sendMessage();
    		$(".addBtn").css('display','').html("<b>跟进</b>");
       		$(".examinerSend").css("display","none");
    	});
		
    	//文本输入框点击事件
    	p.inputTxt.unbind("keyup").bind("keyup", function(){//内容改变 、键盘输入完、 事件
    		var v = $(this).val();
    		handlerErtUserList(v, getTeamLeas());//输入@符号作的处理
    	});  	
    	//加载项目下关联的联系人个数
    	$.ajax({
    		url: '<%=path%>/contact/alist',
    		type: 'get',
    		data: {parentId:'${rowId}',parentType:"Project",openId:'${openId}',publicId:'${publicId}',currpage:'1', pagecount:'999999'},
    		dataType: 'text',
    	    success: function(data){
    	    	var obj  = JSON.parse(data);
    	    	if(obj.errorCode && obj.errorCode !== '0'){
    	    		$("#contact").html(0);
   	    		   return;
   	    		}
    	    	$("#contact").html(parseInt(obj.rowCount));
    	    }
    	});
    	//加载项目下关联的任务个数
    	$.ajax({
    		url: '<%=path%>/schedule/alist',
    		type: 'get',
    		data: {parentId:'${rowId}',openId:'${openId}',publicId:'${publicId}', currpage:'1', pagecount:'999999'},
    		dataType: 'text',
    	    success: function(data){
    	    	if(!data){
    	    		return;
    	    	}
    	    	var obj  = JSON.parse(data);
    	    	if(obj.errorCode && obj.errorCode !== '0'){
    	    		$("#task").html(0);
   	    		   return;
   	    		}
    	    	$("#task").html(parseInt(obj.rowCount));
    	    }
    	});
      	//加载项目下关联的任务个数
    	$.ajax({
    		url: '<%=path%>/schedule/alist',
    		type: 'get',
    		data: {parentId:'${rowId}',openId:'${openId}',publicId:'${publicId}',schetype:'plan',currpage:'1', pagecount:'999999'},
    		dataType: 'text',
    	    success: function(data){
    	    	if(!data){
    	    		return;
    	    	}
    	    	var obj  = JSON.parse(data);
    	    	if(obj.errorCode && obj.errorCode !== '0'){
    	    		$("#plan").html(0);
   	    		   return;
   	    		}
    	    	$("#plan").html(parseInt(obj.rowCount));
    	    }
    	});
     	//加载项目下关联的任务个数
    	$.ajax({
    		url: '<%=path%>/bug/alist',
    		type: 'get',
    		data: {parentId:'${rowId}',openId:'${openId}',publicId:'${publicId}',currpage:'1', pagecount:'999999'},
    		dataType: 'text',
    	    success: function(data){
    	    	if(!data){
    	    		return;
    	    	}
    	    	var obj  = JSON.parse(data);
    	    	if(obj.errorCode && obj.errorCode !== '0'){
    	    		$("#bug").html(0);
   	    		   return;
   	    		}
    	    	$("#bug").html(parseInt(obj.rowCount));
    	    }
    	});
   }
    
    //获取 获取团队成员
    function getTeamLeas(){
 	   	var tArr = [];
 	   	$(".teamCon > div.teamPeason").each(function(){
 	   		var uid = $(this).find(":hidden[name=assId]").val();
 	   		var uname = $(this).find(":hidden[name=assName]").val();
 	   		tArr.push({uid:uid, uname:uname});
 	   	});
 	   	return tArr;
    }
    
    //微信网页按钮控制
	/* function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
    var p = {};
    //初始化团队容器对象
    function initTeamCon(){
    	p.teamCon = $(".teamCon");
    	p.teamTitle = $(".teamTitle");
    	p.teamPeason = p.teamCon.find(".teamPeason");
    	p.teamAdd = p.teamCon.find(".teamAdd");
    	p.teamSub = p.teamCon.find(".teamSub");
   	    //分享区域
   	    p.taskCreateCon =$("#task-create");
   	    p.shareUserCon = $("#shareuser-more");
   	    p.shareUserList = p.shareUserCon.find(".shareUserList");
   	    
   	    p.shareUserFstChar = p.shareUserCon.find(":hidden[name=fstChar]");
        p.shareUserCurrType = p.shareUserCon.find(":hidden[name=currType]");
 	    p.shareUserCurrPage = p.shareUserCon.find(":hidden[name=currPage]");
 	    p.shareUserPageCount = p.shareUserCon.find(":hidden[name=pageCount]");
 	    p.shareUserChartList = p.shareUserCon.find(".chartList");
   	    
   	    p.shareBtn = p.shareUserCon.find(".shareuserbtn");
   	    p.shareUserGoBak = p.shareUserCon.find(".shareuserGoBak");
   	    
	   	p.shareusertab = p.shareUserCon.find(".shareusertab");
	    p.followUserList = p.shareUserCon.find(".followUserList");
	    p.followuserbtn = p.shareUserCon.find(".followuserbtn");
	    p.followform = $("form[name=followform]");
	    p.followuserid = p.followform.find(":hidden[name=openId]");
	    p.follownickname = p.followform.find(":hidden[name=nickName]");
		p.followrelaid = p.followform.find(":hidden[name=relaId]");
   	    
   	    p.msgCon = $(".msgContainer");
	    p.msgModelType = p.msgCon.find("input[name=msgModelType]");
	    p.msgType = p.msgCon.find("input[name=msgType]");//消息类型
	    p.inputTxt = p.msgCon.find("textarea[name=inputMsg]");//输入的文本框
	    p.targetUId = p.msgCon.find("input[name=targetUId]");//目标用户ID
	    p.targetUName = p.msgCon.find("input[name=targetUName]");//目标用户名
	    p.subRelaId = p.msgCon.find("input[name=subRelaId]");//子关联ID
	    p.examinerSend = p.msgCon.find(".examinerSend");//发送按钮
	    
	    p.nativeDiv = $("#site-nav");
        p.projectDetailDiv = $("#projectDetail");
        p.projectDetailFormDiv = p.projectDetailDiv.find(".projectDetailForm");

   	    initTeamBtn();
   	    initTeamShareBtn();
   	    initTeamDelBtn();
    }
    
    function initTeamBtn(){
    	//添加成员
    	p.teamAdd.click(function(){
    		p.shareUserCon.removeClass("modal");
    		p.taskCreateCon.addClass("modal");
    		$("._menu").css("display","none");
    		p.shareUserList.find("a").each(function(){
				if($(this).hasClass("checked")){
					$(this).removeClass("checked");
				}
			});
			p.followUserList.find("a").each(function(){
				if($(this).hasClass("checked")){
					$(this).removeClass("checked");
				}
			});
    		p.shareUserFstChar.val('');
    		initShareUserData();
    		renderAttenUser();//渲染关注用户
    		window.scrollTo(100, 0);//滚动到顶部
    	});
    	
    	//删除成员
    	p.teamSub.click(function(){
    		//删除成员
        	$(".teamCon").find(".teamPeason").each(function(){
        		var flag = $(this).find(":hidden[name=assFlag]").val();
        		if("Y"==flag){
        			var display = $(this).find(".delImg").css("display");
        			if(display=="none"){
    	    			$(this).find(".delImg").css("display","");
        			}else{
        				$(this).find(".delImg").css("display","none");
        			}
        		}
        	});
        	initTeamDelBtn();
    		/*
    		var f = p.teamSub.attr("flag");
    		if(f === "true"){
    			p.teamSub.attr("flag", "false");
    			//遍历团队成员 出现删除按钮
        		p.teamCon.find(".delImg").css("display", "none");
    		}else{
    			p.teamSub.attr("flag", "true");
    			//遍历团队成员 出现删除按钮
        		p.teamCon.find(".delImg").css("display", "");
        		initTeamDelBtn();
    		}
    		*/
    	});
    }
    
    function initTeamDelBtn(){
    	//删除按钮 点击事件
    	p.teamCon.find(".delImg").unbind("click").click(function(){
    		var assId = $(this).parent().parent().find(":hidden[name=assId]").val();
    		var assName = $(this).parent().parent().find(":hidden[name=assName]").val();
    		var type = $(this).parent().parent().find(":hidden[name=type]").val();
    		if(type === "sysuser"){
    			//数组对象
        		var dataObj = [], dataObjSec = [];
        	    	dataObj.push({name:'openId', value: '${openId}'});
        	    	dataObj.push({name:'publicId', value: '${publicId}'});
        	    	dataObj.push({name:'parentid', value: '${rowId}' });
        	    	dataObj.push({name:'parenttype', value: 'Project' });
    	        	dataObj.push({name:'type', value: 'cancel' });
    	        	dataObj.push({name:'shareuserid', value: assId });
    				dataObj.push({name:'shareusername', value: assName });
    				
    	    	//调用后台接口 发送 团队成员数据
    			renderTeamPeason(dataObj, []);
    		}else if(type === "attenuser"){
    			$("form[name=followform]").find(":hidden[name=openId]").val(assId);
    			delFollowUser();
    		}
	    	//删除节点
			$(this).parent().parent().remove();
		});
    }
    
    function initTeamShareBtn(){
    	//分享按钮 点击确定触发的事件
    	p.shareBtn.click(function(){
        	//数组对象
    		var dataObj = [], dataObjSec = [];
    	    	dataObj.push({name:'openId', value: '${openId}'});
    	    	dataObj.push({name:'publicId', value: '${publicId}'});
    	    	dataObj.push({name:'parentid', value: '${rowId}' });
    	    	dataObj.push({name:'parenttype', value: 'Project' });
    			dataObj.push({name:'type', value: 'share' });
    			dataObj.push({name:'crmname', value: '${assigner}' });
    			dataObj.push({name:'projname', value: '${sd.name}' });
			//遍历选择的人
	        p.shareUserList.find("a.checked").each(function(){
    			var assId = $(this).find(":hidden[name=assId]").val();
    			var assName = $(this).find(":hidden[name=assName]").val();
	    			dataObj.push({name:'shareuserid', value: assId });
	    			dataObj.push({name:'shareusername', value: assName });
	    			if(teamUniqJudge(assId)){
	    				dataObjSec.push({id: assId, name: assName, type: 'sysuser'});
	    			}
    		});
        	//调用后台接口 发送 团队成员数据
    		renderTeamPeason(dataObj, dataObjSec);
    		//回退
    		p.shareUserGoBak.trigger("click");
		});
    	p.shareUserGoBak.click(function(){
    		p.shareUserCon.addClass("modal");
    		p.taskCreateCon.removeClass("modal");
    		$("._menu").css("display","");
    	});
    	//关注用户确定按钮
		p.followuserbtn.click(function(){
			var shareuserid="";
			var shareusername = "";
			var data=[];
			p.followUserList.find("a").each(function(){
				if($(this).hasClass("checked")){
					var id=$(this).find(":hidden[name=userid]").val();
					var name=$(this).find(":hidden[name=username]").val();
					shareuserid += id+",";
					shareusername += name+",";
					data.push({id:id , name:name, type: 'attenuser'});
				}
			});
			if(shareuserid==""){
				$(".myMsgBox").css("display","").html("请选择共享用户!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			p.followuserid.val(shareuserid);
			p.follownickname.val(shareusername);
			//新增或者删除团队成员
			saveFollowUser(data);
		});
    	
    	//团队用户列表 TAB页切换
    	p.shareusertab.find("div").click(function(){
    		$(this).siblings().removeClass("active");
    		$(this).addClass("active");
    		if($(this).hasClass("systemuser")){
    			p.shareUserChartList.css("display", "");
    	        p.shareUserList.css("display", "");
    	        p.followUserList.css("display", "none");
    	        p.shareBtn.css("display", "");
    	        p.followuserbtn.css("display", "none");
    		}
    		if($(this).hasClass("attentionuser")){
    			p.shareUserChartList.css("display", "none");
    	        p.shareUserList.css("display", "none");
    	        p.followUserList.css("display", "");
    	        p.shareBtn.css("display", "none");
    	        p.followuserbtn.css("display", "");
    		}
    	});
    	
    	renderAttenCheckedUser();//渲染选择的关注用户
    }
    
  //加载关注用户列表
    function renderAttenUser(){
 	   asyncInvoke({
 	   		url: '<%=path%>/lovuser/attenuserlist',
	 	   	data: {
	   			relaId: '${rowId}',
	   			openId:'${openId}'
	   		},
 	   	    callBackFunc: function(data){
 	   	    	if(!data) return;
 	   	    	var d = JSON.parse(data);
 	   	    	compileAttenUserData(d);
 	   	    }	
 	   	});
    }
    
    //异步加载用户
    function compileAttenUserData(d){
 		if(d.length === 0){
 			p.followUserList.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
 	    	return;
 	    }
 		//组装数据
 		var val = '';
 		$(d).each(function(i){
 			if(!this.openId) return;
 				val += '<a href="javascript:void(0)" class="list-group-item listview-item radio" >'
 	         		+ '<div class="">'
 	         		+ '<img style="border-radius: 10px;" width="50px" src="'+ this.headImgurl +'"/>'
 	         		+ '</div>'
 	         		+ '<div class="list-group-item-bd" style="margin-left: 10px;">'
 	         		+ '<input type="hidden" name="userid" value="'+this.openId+'">'
 	         		+ '<input type="hidden" name="username" value="'+this.nickname+'">'
 	         		+ '<h2 class="title ">'+this.nickname+'</h2>'
 	         		+ '<p>地址：' + this.country + ' ' + this.province + ' ' + this.city + ' </p>'
 	         		+ '</div><div class="input-radio" title="选择该条记录"></div>'
 	         		+'</a>';
 		});
 		p.followUserList.html(val);
    }
    
    //加载选中的关注用户列表
    function renderAttenCheckedUser(){
 	   asyncInvoke({
 	   		url: '<%=path%>/teampeason/asynclist',
 	   		data: {
 	   			relaId: '${rowId}'
 	   		},
 	   	    callBackFunc: function(data){
 	   	    	if(!data) return;
 	   	    	var d = JSON.parse(data);
 	   	    	compileAttenCheckedUserData(d);
 	   	    	initTeamDelBtn();
 	   	    	renderTeamImgHead();//显示图片头像
 	   	    }	
 	   	});
    } 
    
    //异步加载选中的用户
    function compileAttenCheckedUserData(d){
 		if(d.length === 0){
 			return;
 	    }
 		//组装数据
 		$(d).each(function(i){
 			if(!this.openId) return;
        		var val = '<div id="'+ this.openId +'" class="teamPeason" style="float: left;width: 25%;margin-top: 10px;">'
        			+ '<input type="hidden" name="assId" value="'+ this.openId +'">'
        			+ '<input type="hidden" name="assName" value="'+this.nickName+'">'
        			+ '<input type="hidden" name="assFlag" value="Y">'
        			+ '<input type="hidden" name="type" value="attenuser">'
        			+ '<div style="text-align: center;">'
        			+ '<img src="<%=path%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;">'
        			+ '<img src="<%=path%>/image/defailt_person.png" class="headImg" id="'+ this.openId +'" style="width: 50px;height: 50px;border-radius: 10px;">'
        			+ '</div>'
        			+ '<div style="margin-top: 10px;text-align: center;"><span>'+this.nickName+'</span></div>'
        			+ '</div>';
 	         	
        		$(val).insertAfter(".teamCon .teamPeason:last");
 		});
    }
    
    
    //调用后台接口 发送 团队成员数据
    function renderTeamPeason(d, dSec){
    	asyncInvoke({
    		url: '<%=path%>/shareUser/upd',
    		data: d,
    	    callBackFunc: function(rst){
    	    	if(!rst) return;
    	    	rst = JSON.parse(rst);
    	    	if(rst && rst.errorCode != '0'){
    	    		return;
    	    	}
    	    	//显示层
    	    	p.shareUserCon.addClass("modal");
    	    	p.taskCreateCon.removeClass("modal");
    	    	//拼装数据到前台
    	    	compTeamPeason(dSec);
    	    }
    	});
    }
    
    //编译团队成员数据
    function compTeamPeason(d){
    	if(!d || d.length == 0) return;
    	//组装模板数据
    	var imgUrl = "<%=path%>/image/defailt_person.png";
    	var tmp =['<div class="teamPeason" style="float: left;width: 25%;margin-top: 10px;">',
					'<div style="text-align: center;">',
					  '<input type="hidden" name="assId" value="$$assId" />',
					  '<input type="hidden" name="assName" value="$$assName" />',
					  '<input type="hidden" name="assFlag" value="Y" />',
					  '<input type="hidden" name="type" value="$$type">',
					  '<img src="<%=path%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;">',
					  '<img src="$$imgUrl" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">',
					'</div>',
				    '<div style="margin-top: 10px;text-align: center;"><span>$$text</span></div>',
				'</div>'];
    	//遍历数据追加到DOM节点
    	var v = '';
    	$(d).each(function(){
    		var t = tmp.join("");
    		    t = t.replace("$$imgUrl", imgUrl);
    		    t = t.replace("$$assId", this.id);
    		    t = t.replace("$$assName", this.name);
    		    t = t.replace("$$text", this.name);
    		    t = t.replace("$$type", this.type);
    		    v += t;
    	});
    	$(v).insertBefore(p.teamAdd);
    	
    	renderTeamImgHead();//显示图片头像
    	renderTeamPerm();//初始化团队的权限
    }
    
    //保存非关注用户
    function saveFollowUser(d){
    	//组装数据
   		compTeamPeason(d);
   		
		$("#task-create").removeClass("modal");
		$("#site-nav").css("display","");
		p.shareUserCon.addClass("modal");
		$("._menu").css("display","");
		
		//初始化分享删除按钮
	    initTeamDelBtn();
			
 	 //组装数据异步提交 
 	   	var dataObj = [];
 	   	p.followform.find("input").each(function(){
 	   		var n = $(this).attr("name");
 	   		var v = $(this).val();
 	   		dataObj.push({name: n, value: v});
 	   	});
 	   	
 	   	$.ajax({
 	   		url: '<%=path%>/teampeason/save',
 	   		type: 'get',
 	   		data: dataObj,
 	   		dataType: 'text',
 	   	    success: function(data){
 	   	    	if(!data) return;
 	   	    	var obj  = JSON.parse(data);
 	   	    	if(obj.errorCode && obj.errorCode !== '0'){
 	    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
 	    		   $(".myMsgBox").delay(2000).fadeOut();
 	   	    	}
 	   	    }
 	   	});
    }
    
    //删除非关注用户
    function delFollowUser(d){
 	 //组装数据异步提交 
 	   	var dataObj = [];
 	   	p.followform.find("input").each(function(){
 	   		var n = $(this).attr("name");
 	   		var v = $(this).val();
 	   		dataObj.push({name: n, value: v});
 	   	});
 	   	
 	   	$.ajax({
 	   		url: '<%=path%>/teampeason/del',
 	   		type: 'get',
 	   		data: dataObj,
 	   		//async: false,
 	   		dataType: 'text',
 	   	    success: function(data){
 	   	    	if(!data) return;
 	   	    	var obj  = JSON.parse(data);
 	   	    	if(obj.errorCode && obj.errorCode !== '0'){
 	    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
 	    		   $(".myMsgBox").delay(2000).fadeOut();
 	   	    	}
 	   	    	renderAttenUser();
 	   	    }
 	   	});
    }
    
    //初始化团队的权限
    function renderTeamPerm(){
    	//遍历业务机会跟进数据列表
    	/*$(".teamPeason").each(function(){
    		var assId = $(this).find(":hidden[name=assId]").val();
    		var assName = $(this).find(":hidden[name=assName]").val();
    		var assFlag = $(this).find(":hidden[name=assFlag]").val();
    		if('${crmId}' === assId){
    			if(assFlag === 'Y'){
       				p.teamAdd.css("display", "none");
           			p.teamSub.css("display", "none");
       			}else{
       				p.teamAdd.css("display", "");
           			p.teamSub.css("display", "");
       			}
   			}
   			if(assFlag === 'N'){
   				var o = p.teamCon.find(":hidden[name=assId][value=" + assId + "]");
   				o.parent().find(".delImg").remove();
   			}
    	});*/
    }
    
    //显示图片头像
    function renderTeamImgHead(){
    	//遍历业务机会跟进数据列表
    	$(".teamPeason").each(function(){
    		var img = $(this).find(".headImg");
    		var readFlag = img.attr("readFlag");
    		if(readFlag === 'Y'){
    			return;
    		}
    		var userId = $(this).find(":hidden[name=assId]").val();
    		//显示单个图片头像
	   	   	if(sessionStorage.getItem(userId + "_headImg")){
	   	   		$(img).attr("src", sessionStorage.getItem(userId + "_headImg"));
	   	   		return;
	   	   	}
    		//异步调用获取消息数据
        	asyncInvoke({
        		url: '<%=path%>/wxuser/getImgHeader',
        		data: {crmId: userId},
        	    callBackFunc: function(data){
        	    	if(data)
        	    	  $(img).attr({"src":data, "readFlag":'Y'});
        	    	  //本地缓存
	     	          sessionStorage.setItem(userId + "_headImg",data);
        	    }
        	});
    	});
    }
    
    //团队用户唯一性判断
    function teamUniqJudge(assId){
    	var o = p.teamCon.find(":hidden[name=assId][value=" + assId + "]");
    	if(o && o.length > 0) return false;
    	return true;
    }
    
    //异步加载分享用户数据  shareUserList
    function initShareUserFstChart(){
		asyncInvoke({
			url: '<%=path%>/fchart/list',
			async: 'false',
			data: {
			   crmId: '${crmId}',
			   type: p.shareUserCurrType.val(),
			   parenttype:"Project",
			   parentid:'${rowId}'
			},
		    callBackFunc: function(data){
		    	if(!data) return;
	    	    var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	$(".myMsgBox").delay(2000).fadeOut();
		    	   return;
		    	}
	    	    var ahtml = '';
	    	    $(d).each(function(i){
	    	    	ahtml += '<a href="javascript:void(0)"  style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
	    	    });
	    	    p.shareUserChartList.html(ahtml);
	    	    
	    	    //点击字母
	    		$("#shareuser-more").find(".chartList").find("a").unbind("click").bind("click", function(event){
	    			p.shareUserCurrPage.val("1");
	    			p.shareUserFstChar.val($(this).html());
	    			initShareUserData();
	    		});
		    }
		});
    }
    
    //查询分享用户列表
    function initShareUserData(){
    	asyncInvoke({
    		url: '<%=path%>/lovuser/userlist',
    		data: {
    			crmId: '${crmId}',
    			firstchar: p.shareUserFstChar.val(), 
	 			flag: 'share',
	 			parentid: '${rowId}',
	 			parenttype: "Project",
	 			currpage: p.shareUserCurrPage.val(),
	 			pagecount: p.shareUserPageCount.val()  
    		},
    	    callBackFunc: function(data){
    	    	if(!data) return;
    	    	var d = JSON.parse(data);
    	    	initShareUserFstChart();
    	    	compileShareUserData(d);
    	    }	
    	});
     }
    
    function compileShareUserData(d){
 		if(d.length === 0){
 			p.shareUserList.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
 	    	return;
 	    }
 		//组装数据
 		var val = '';
 		$(d).each(function(i){
 			if(!this.userid) return;
 			val += '<a href="javascript:void(0)" class="list-group-item listview-item radio" >'
          		+ '  <div class="list-group-item-bd">'
          		+ '  <input type="hidden" name="assId" value="'+this.userid+'">'
          		+ '  <input type="hidden" name="assName" value="'+this.username+'">'
          		+ '  <h2 class="title ">'+this.username+'</h2>'
          		+ '  <p>职称：'+this.title+'</p>'
          		+ '  <p>部门：<b>'+this.department+'</b></p></div><div class="input-radio" title="选择该条记录"></div>'
          		+'</a>';
 		});
 		p.shareUserList.html(val);
 	}
  
    
    //底部操作按钮区域
    function initBottomBtn(){
    	//跟进按钮
		$(".addBtn").click(function(){
			if(!$(this).hasClass("showAddCon")){
				$(this).addClass("showAddCon");
				$("#menuimg").css("padding-bottom","245px");
				//added by pengmd
				$(".addContainer").css('display','');
// 				$(".addContainer").css('height' ,'300');
// 				$("#flootermenu").animate({height :300}, [ 1000 ]);
				//added end
				$(this).html("<b>取消</b>");	
			}else{
				$(this).removeClass("showAddCon");
				//added by pengmd
// 				$("#flootermenu").animate({height :51}, [ 1000 ]);
				//added end
				$(".addContainer").css('display','none');
// 				$(".addContainer").css('height' ,'0');
// 				$(".addContainer").animate({height :0}, [ 1000 ]);
				$(".tasContainer").css("display", "none");
				$("#menuimg").css("padding-bottom","0px");
				$(this).html("<b>跟进</b>");
			}
		});
		
		//task 任务 按钮
		$(".taskBtn").click(function(){
			window.location.href = "<%=path%>/schedule/get?publicId=${publicId}&openId=${openId}&parentId=${rowId}&parentType=Project&flag=other&parentName=${proName}";
		});
		
		//contact 联系人 按钮
		$(".contactBtn").click(function(){
			window.location.href = "<%=path%>/contact/add?parentType=Project&parentId=${rowId}&openId=${openId}&publicId=${publicId}&parentName=${proName}";
		});
		
		//plan 计划任务
		$(".planBtn").click(function(){
			window.location.href = "<%=path%>/schedule/add?publicId=${publicId}&openId=${openId}&parentId=${rowId}&parentName=${proName}&parentType=Project&schetype=plan";
		});
		
		//Bug
		$(".bugBtn").click(function(){
			window.location.href = "<%=path%>/bug/list?parentid=${rowId}&openId=${openId}&publicId=${publicId}&viewtype=allview&parentname=${proName}&parenttype=Project";
		});		
	/* 	//tas 按钮
		$(".tasBtn").click(function(){
			$(".addContainer").css("display", "none");
			$(".addContainer").css('height' ,'0');
// 			$(".addContainer").animate({height :0}, [ 1000 ]);
// 			$("#flootermenu").animate({height :51}, [ 1000 ]);
			$(".tasContainer").css("display", "");
		}); */
		//分配 按钮
		$(".distributionBtn").click(function(){
			$(".addContainer").css("display", "none");
			$("#menuimg").css("padding-bottom","0px");
// 			$(".addContainer").css('height' ,'0');
// 			$(".addContainer").animate({height :0}, [ 1000 ]);
// 			$("#flootermenu").animate({height :51}, [ 1000 ]);
			$("#projectDetail").addClass("modal");
			$("#assigner-more").removeClass("modal");
			$("#site-nav").addClass("modal");
			$(".msgContainer").addClass("modal");
		});
	<%-- 	
		//强制性事件
		$(".qzEvent").click(function(){
			var n = encodeURI('强制性事件');
			window.location.href = "<%=path%>/tas/getevt?publicId=${publicId}&openId=${openId}&crmId=${crmId}&rowId=${rowId}&pagename=" + n;
		});
		
		//价值主张
		$(".zuzanValue").click(function(){
			var n = encodeURI('价值主张');
			window.location.href = "<%=path%>/tas/getval?publicId=${publicId}&openId=${openId}&crmId=${crmId}&rowId=${rowId}&pagename=" + n;
		}); --%>
		
		//竞争策略
    }
    
    //初始化责任人按钮
    function initAssignerBtn(){
    	//分配 goback按钮
		$(".assignerGoBak").click(function(){
			$("#projectDetail").removeClass("modal");
			$("#assigner-more").addClass("modal");
			$("#site-nav").removeClass("modal");
			$(".msgContainer").removeClass("modal");
			$(".addBtn").html("<b>跟进</b>");
// 			$("#flootermenu").css("height",'51px');
			$(".addBtn").removeClass("showAddCon");
		});
		
		//分配确定按钮
		$(".assignerbtn").click(function(){
			var assId = null;
			$(".assignerList > a.checked").each(function(){
				assId = $(this).find(":hidden[name=assId]").val();
			});
			if(!assId){
				$(".myMsgBox").css("display","").html("请选择责任人!");
	    		$(".myMsgBox").delay(2000).fadeOut();
	    		return;
			}
			/* $("input[name=assignId]").val(assId);
			//组装数据异步提交 
	    	var dataObj = [];
	    	$("form[name=opptyForm]").find("input").each(function(){
	    		var n = $(this).attr("name");
	    		var v = $(this).val();
	    		dataObj.push({name: n, value: v});
	    	});
	    	dataObj.push({name:'optype',value:'allot'}); */
	    	asyncInvoke({
	    		url: '<%=path%>/project/allocation',
	    		type: 'post',
	    		data: {"rowId":'${rowId}',
	    				"openId":'${openId}',
	    				"publicId":'${publicId}',
	    				"assignId":assId},
	    	    callBackFunc: function(data){
	    	    	if(!data) return;
	    	    	var obj  = JSON.parse(data);
	    	    	if(obj.errorCode && obj.errorCode !== '0'){
		    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
		    		   $(".myMsgBox").delay(2000).fadeOut();
	    	    	}else{
			    	   window.location.href="<%=path%>/project/detail?rowId=${rowId}&openId=${openId}&publicId=${publicId}";
	    	    	}
	    	    }
	    	});
		});
    }
  </script>
</head>
<body>
	<div id="task-create">
		<div id="site-nav" class="navbar">
			<jsp:include page="/common/back.jsp"></jsp:include>
			<h3 style="padding-right:45px;">项目详情</h3>
		</div>
		<jsp:include page="/common/navbar.jsp"></jsp:include>
		<div id="projectDetail" >
			<input type="hidden" name="currpage" value="1"/>
			<input type="hidden" name="pagecount" value="10"/>
			<div class="recommend-box projectDetailForm">
					<div id="view-list" class="list list-group1 listview accordion" style="margin:0">
						<div class="card-info">
							<a href="<%=path%>/project/modify?openId=${openId}&publicId=${publicId}&rowId=${rowId}"
								class="list-group-item listview-item">
								<div class="list-group-item-bd">
									<h1 class="title">${proName}&nbsp;
									<span style="color: #AAAAAA; font-size: 13px;">${sd.assigner}
										</span>
									</h1>
									<p>开始日期: ${sd.startdate}       &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        
									 结束日期：${sd.enddate}</p>
								</div> <span class="icon icon-uniE603" ></span>
							</a>
						</div>
					</div>
					<div class="list list-group listview accordion"
						style="width:100%; background-color: white; display: inline-block; margin:0px; padding-top:14px;padding-bottom:14px;">
					<div style="float: left; width: 25%; text-align: center;">
						<a
							href="<%=path%>/contact/list?parentType=Project&parentId=${rowId}&openId=${openId}&publicId=${publicId}"
							class="list-group-item-bd">
							<div style="float: left; text-align: right; width: 50%;">
								<img src="<%=path%>/image/wx_contact.png" width="35px" border=0>
							</div>
							<div style="float: right; text-align: left; width: 50%;">
								<div id="contact" style="height: 16px; padding-left: 15px;"></div>
								<div style="height: 16px; padding-left: 5px;font-size:12px;">联系人</div>
							</div>
						</a>
					</div>
						
						<div style="float:left;width:25%;text-align:center;">
							<a
							href="<%=path%>/schedule/opptylist?parentId=${rowId}&openId=${openId}&publicId=${publicId}&viewtype=allview&parentName=${proName}&parentType=Project&schetype=plan"
							class="list-group-item-bd"> 
							<div style="float:left;text-align:right;width:50%;"><img src="<%=path%>/image/schedule.png" width="35px" border=0></div>
								<div style="float:right;text-align:left;width:50%;">
									<div id="plan" style="height:16px;padding-left:12px;"></div>
									<div style="height:16px;padding-left:5px;font-size:12px;">计划任务</div>
								</div>
							</a>
						</div>
						<div style="float:left;width:25%;text-align:center;">
							<a
							href="<%=path%>/schedule/opptylist?parentId=${rowId}&openId=${openId}&publicId=${publicId}&viewtype=allview&parentName=${proName}&parentType=Project"
							class="list-group-item-bd"> 
							<div style="float:left;text-align:right;width:50%;"><img src="<%=path%>/image/schedule.png" width="35px" border=0></div>
								<div style="float:right;text-align:left;width:50%;">
									<div id="task" style="height:16px;padding-left:12px;"></div>
									<div style="height:16px;padding-left:5px;font-size:12px;">任务</div>
								</div>
							</a>
						</div>
						<div style="float:left;width:25%;text-align:center;">
							<a
							href="<%=path%>/bug/list?parentid=${rowId}&openId=${openId}&publicId=${publicId}&viewtype=allview&parentname=${proName}&parenttype=Project"
							class="list-group-item-bd"> 
							<div style="float:left;text-align:right;width:50%;"><img src="<%=path%>/image/schedule.png" width="35px" border=0></div>
								<div style="float:right;text-align:left;width:50%;">
									<div id="bug" style="height:16px;padding-left:12px;"></div>
									<div style="height:16px;padding-left:5px;font-size:12px;">缺陷</div>
								</div>
							</a>
						</div>
					</div>
			
				<!-- 跟进历史 -->
				<c:if test="${fn:length(auditList) > 0 }">
					<h3 class="wrapper">项目跟进</h3>
					<div id="div_audit" class="container hy bgcw conBox">
						<dl class="hyrc" id="tc01">
							<c:forEach items="${auditList }" var="audit" varStatus="stat">
								<!-- 序号等于5的情况 -->
								<c:if test="${stat.index == 5}">
									<div id="more_div" style="width: 100%; text- align: center;">
										<div style="clear: both"></div>
										<div style="padding: 8px; font-size: 14px;text-align: center;">
											<a href="javascript:void(0)"
												onclick='$("#more_div").css("display","none");$("#more_list").css("display","");'>查看全部&nbsp;↓</a>
										</div>
									</div>
									<div id="more_list" style="display: none;">
								</c:if>
								
								<!-- 序号大于5的情况 -->
								<c:if test="${stat.index >= 5 }">
									<dt style="line-height: 34px;">
										${audit.opdate}<span style="top: 16px;"></span>
									</dt>
									<dd style="width: 70%;cursor: pointer" class="" >
										<div style="border: 1px solid #ededed;border-radius: 3px;background: #f8f8f8;line-height: 24px;text-indent: 0;padding: 4px 4px 4px 6px;">
											<ul class="opptyReplayCon" opid="${audit.opid}" opname="${audit.opname}"
									     			subRelaId="${audit.parentid }" >
											<c:if test="${audit.optype eq 'project_task'}">
													<span style="color: #3e6790"> ${audit.opname}</span>发布了一个计划任务：
													<a href="<%=path %>/schedule/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }&schetype=plan">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'tasks'}">
													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个任务：<a
														href="<%=path %>/schedule/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }&shcetype=task">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'contact'}">
													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个联系人：
													<a href="<%=path %>/contact/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'bugs'}">
													<span style="color: #3e6790"> ${audit.opname}</span>发现了一个Bug：<a
														href="<%=path %>/bug/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'close_bugs'}">
													<span style="color: #3e6790"> ${audit.opname}</span>解决了一个Bug：<a
														href="<%=path %>/bug/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'share'}">
													<span style="color: #3e6790"> ${audit.opname}</span>添加团队成员：${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'cancel_share'}">
													<span style="color: #3e6790"> ${audit.opname}</span>删除团队成员：${audit.aftervalue}
											</c:if>
											</ul>
											<ul class="twitter opptyReplayRst" style="display:none"></ul> 
										</div>
									</dd>
								</c:if>
								<!-- 序号小于5的情况 -->
								<c:if test="${stat.index < 5 }">
									<dt style="line-height: 34px;">
										${audit.opdate}<span style="top: 16px;"></span>
									</dt>
									<dd style="width: 70%;cursor: pointer" >
										<div style="border: 1px solid #ededed;border-radius: 3px;background: #f8f8f8;line-height: 24px;text-indent: 0;padding: 4px 4px 4px 6px;">
										   	<ul class="opptyReplayCon" opid="${audit.opid}" opname="${audit.opname}"
									     			subRelaId="${audit.parentid }" >
											<c:if test="${audit.optype eq 'project_task'}">
													<span style="color: #3e6790"> ${audit.opname}</span>发布了一个计划任务：
													<a href="<%=path %>/schedule/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }&schetype=plan">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'tasks'}">
													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个任务：<a
														href="<%=path %>/schedule/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }&shcetype=task">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'contact'}">
													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个联系人：
													<a href="<%=path %>/contact/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'bugs'}">
													<span style="color: #3e6790"> ${audit.opname}</span>发现了一个Bug：<a
														href="<%=path %>/bug/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'close_bugs'}">
													<span style="color: #3e6790"> ${audit.opname}</span>解决了一个Bug：<a
														href="<%=path %>/bug/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a>
											</c:if>
											<c:if test="${audit.optype eq 'share'}">
													<span style="color: #3e6790"> ${audit.opname}</span>添加团队成员：${audit.aftervalue}
											</c:if>
											<c:if test="${audit.optype eq 'cancel_share'}">
													<span style="color: #3e6790"> ${audit.opname}</span>删除团队成员：${audit.aftervalue}
											</c:if>
											</ul>
											<!-- 回复信息列表 -->
											<ul class="twitter opptyReplayRst" style="display:none"></ul>
										</div>
									</dd>
								</c:if>
								
							</c:forEach>
						</dl>
					</div>
					<div style="clear: both"></div>
				</c:if>
				<!-- 团队成员 -->
				<h3 class="wrapper teamTitle" style="display:'';">团队成员</h3>
				<div class="container hy bgcw teamCon" style="font-size: 14px;background: #fff;">
					<c:if test="${fn:length(shareusers) > 0}">
					    <c:forEach items="${shareusers}" var="user">
							<div class="teamPeason" style="float: left;width: 25%;margin-top: 10px;">
							    <input type="hidden" name="assId" value="${user.shareuserid}" />
						  		<input type="hidden" name="assName" value="${user.shareusername}" />
						  		<input type="hidden" name="assFlag" value="${user.flag}" />
						  		<input type="hidden" name="type" value="sysuser">
								<div style="text-align: center;">
								  <img src="<%=path%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;">
								  <img src="<%=path%>/image/defailt_person.png" class="headImg" style="width: 50px;height: 50px;border-radius: 10px;">
								</div>
							    <div style="margin-top: 10px;text-align: center;"><span>${user.shareusername}</span></div>
							</div>
						</c:forEach>
					</c:if>
					<c:if test="${sd.authority eq 'Y'}">
						<div class="teamAdd" at="teamAdd" style="cursor:pointer;float: left;width: 25%;margin-top: 10px;padding-top:10px;padding-bottom: 20px;">
							<div style="text-align: center;">
							   <img src="<%=path%>/image/mem_add.png" style="width: 50px;height: 50px;">
							</div>
						</div>
						<div class="teamSub" style="cursor: pointer;float:left;width: 25%;margin-top: 10px;padding-top:10px;padding-bottom: 20px;">
							<div style="text-align: center;">
								<img src="<%=path%>/image/mem_sub.png" style="width: 50px;height: 50px;">
							</div>
						</div>
					</c:if>
					<div style="clear: both;">&nbsp;</div>
				</div>
				
				<!-- 消息显示区域 -->
				<jsp:include page="/common/messages.jsp"></jsp:include>
			</div>
		</div>
		
		<!-- 发送消息的区域 -->
		<div class="flooter" id="flootermenu" 
		       style="z-index: 99999;background: #FFF;background: rgb(253, 253, 255);border-top: 1px solid #A2A2A2;opacity: 1;">
			<!--发送消息的区域  -->
			<div class="msgContainer">
			    <div class="ui-block-a" style="float: left;margin: 5px 0px 10px 10px;">
					<img id="menuimg" src="<%=path %>/scripts/plugin/menu/images/upmenu.png" style="position:fixed;bottom:10px;" width="30px" onclick="swicthUpMenu('flootermenu')">
				</div>
				<div class="ui-block-a msgdiv" style="width: 100%;margin: 5px 0px 5px 40px;padding-right: 110px;">
				     <!-- 目标用户ID -->
					<input type="hidden" name="targetUId" value="${sd.assignerid}" />
					<!-- 目标用户名 -->
					<input type="hidden" name="targetUName" value="${sd.assigner}" />
					<!-- 子级关联ID -->
					<input type="hidden" name="subRelaId" />
					<!-- 消息模块 -->
					<input name="msgModelType" type="hidden" value="project" />
					<!-- 消息类型 txt img doc-->
					<input name="msgType" type="hidden" value="txt" />
					<textarea name="inputMsg" id="inputMsg" style="width: 98%;font-size: 16px; line-height:20px;height: 40px;margin-left: 5px; margin-top: 0px;" class="form-control" placeholder="回复"></textarea>
				</div>
				<div class="ui-block-a " style="float: right;width: 60px;margin: -45px 0px 5px 0px;">
						<a href="javascript:void(0)"
				    		class="btn addBtn" style="font-size: 14px;width: 100%;background-color:RGB(75, 192, 171)" ><b>跟进</b></a>
						<a href="javascript:void(0)" class="btn  btn-block examinerSend" style="font-size: 14px;width:100%;display: none;">发送</a>
					</div>
				<div style="clear: both;"></div>
			</div>
			<div class="addContainer" style="display: none;background:#fff;z-index:99999;border-top-color: #E6DADA;border-top: 1px solid #C2B2B2;padding-top: 25px;">
						<div class="ui-block-a contactBtn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin:0px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/oppty_contact.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">联系人</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					<div class="ui-block-a planBtn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 0px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/schedule.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">计划任务</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					
					<div class="ui-block-a taskBtn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 0px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/schedule.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">任务</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					<div class="ui-block-a bugBtn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 0px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img  alt="" src="<%=path %>/image/schedule.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">缺陷</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					<c:if test="${sd.authority eq 'Y'}">
						<div class="ui-block-a distributionBtn" style="cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
							<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
								<img alt="" src="<%=path %>/image/assigner.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
							</div>
							<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">项目分配</div>
							<div style="line-height:20px;">&nbsp;</div>
						</div>
					</c:if>
						<div style="clear: both;"></div>
						<div class="ui-block-a " style="height: 10px"></div>
				</div>
		</div>
	</div>	
	<!-- 责任人列表DIV -->
	<jsp:include page="/common/systemuser.jsp">
		<jsp:param name="systemflag"  value="single"/>
	</jsp:include>
	
	<!-- 关注用户form -->
	<form method="post" name="followform" action="" >
		<input type="hidden" name="crmId" value="${crmId}">
		<input type="hidden" name="ownerOpenId" value="${openId}">
		<input type="hidden" name="openId" value="">
		<input type="hidden" name="nickName" value="">
		<input type="hidden" name="relaId" value="${rowId}">
		<input type="hidden" name="relaModel" value="Project">
		<input type="hidden" name="relaName" value="${proName}">
		<input type="hidden" name="assigner" value="${assigner}">
	</form>	
	
	<!-- 共享用户列表DIV -->
	<div id="shareuser-more" class="modal">
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary shareuserGoBak"><i class="icon-back"></i></a>
			用户列表
		</div>
		
		<!-- 用户类别TAB -->
		<div class="nav nav-tabs nav-normal shareusertab">
			<div class="nav-item active systemuser">
				<a href="javascript:void(0)">系统用户</a>
			</div>
			<div class="nav-item attentionuser">
				<a href="javascript:void(0)">指尖好友 </a>
			</div>
		</div>
		
		<div class="page-patch">
		    <input type="hidden" name="fstChar" />
		    <input type="hidden" name="currType" value="userList" />
		    <input type="hidden" name="currPage" value="1" />
		    <input type="hidden" name="pageCount" value="1000" />
			<!-- 字母区域 -->
			<div class="list-group-item listview-item radio chartList" style="background: #fff;padding: 10px;line-height: 30px;">
				<div style="font-size:16px;line-height:40px;word-wrap: break-word;word-break:break-all; font-family: 'Microsoft YaHei';">
					<span class="chartListSpan" ></span>
				</div>
			</div>
			<div class="list-group listview  shareUserList">
				<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0">
					无数据
				</div>
			</div>
			<!-- 关注者用户 -->
			<div class="list-group listview  followUserList" style="display:none;">
				<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0">
					无数据
				</div>
			</div>
			<div class=" flooter" style="z-index:999999;font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
				<input class="btn btn-block shareuserbtn" type="button" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;" >
				<input class="btn btn-block followuserbtn" type="button" value="确&nbsp;定" style="display:none;width: 100%;margin: 3px 0px 3px 8px;" >
			</div>
		</div>
	</div>
	
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	<!-- 关注用户权限控制JSP -->
	<jsp:include page="/common/eventmonitor.jsp"></jsp:include>
	<!-- 分享JS区域 -->
<%-- 	<script src="<%=path%>/scripts/util/share.util.js" type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:'${publicId}',  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			url: window.location.href + "&shareBtnContol=yes",  
			title:'${sd.name}',  
			desc:'${sd.desc}',  
			fakeid:'',  
			callback:function(){}  
		};
	</script> --%>
</body>
</html>