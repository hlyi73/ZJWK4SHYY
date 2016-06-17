<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String teampath = request.getContextPath();
	String crmId = request.getParameter("crmId");
	String relaModule = request.getParameter("relaModule");
	String isDispTeam = request.getParameter("isDispTeam");
	isDispTeam = (null == isDispTeam ? "" : isDispTeam);
	request.setAttribute("isDispTeam",isDispTeam);
	String relaId = request.getParameter("relaId");
	String relaName = request.getParameter("relaName");
	String assFlg = request.getParameter("assFlg");
	request.setAttribute("assFlg",assFlg);
	String orgId = request.getParameter("orgId");
	
	String newFlag = request.getParameter("newFlag");
	request.setAttribute("newFlag", newFlag);
	String openId = UserUtil.getCurrUser(request).getOpenId();
			
%>

<script type="text/javascript">
$(function(){
	initTeamCon();//团队成员
	renderTeamImgHead();//显示图片头像
	renderTeamPerm();//初始化团队的权限
	initExitTeamEvent();//退出按钮事件
	if ('${newFlag}' == 'true')
	{
		var html = "<h3 style='font-size: 1em;'>团队成员</h3>";
		$(".teamTitle").html(html);
	}
});

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

function clearTeamSeesion(){
    var keys=[];
	for(var i=0;i<sessionStorage.length;i++){
		var key = sessionStorage.key(i);
		if(key.indexOf("_teampeople")!=-1){
			keys[i]=sessionStorage.key(i);
		}
	}
	if(keys!=null&&keys.length>0){
		for(var i=0;i<keys.length;i++){
			sessionStorage.removeItem(keys[i]);
		}
	}
	
}

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
	p.followUserList = p.shareUserCon.find(".followUserList");
	    
	p.shareUserFstChar = p.shareUserCon.find(":hidden[name=fstChar]");
	p.followUserFstChar = p.shareUserCon.find(":hidden[name=fstChar1]");
    p.shareUserCurrType = p.shareUserCon.find(":hidden[name=currType]");
    p.followUserCurrType = p.shareUserCon.find(":hidden[name=currType1]");
	p.shareUserCurrPage = p.shareUserCon.find(":hidden[name=currPage]");
	p.followUserCurrPage = p.shareUserCon.find(":hidden[name=currPage1]");
	p.shareUserPageCount = p.shareUserCon.find(":hidden[name=pageCount]");
	p.followUserPageCount = p.shareUserCon.find(":hidden[name=pageCount1]");
	p.shareUserChartList = p.shareUserCon.find(".chartList");
	p.followUserChartList = p.shareUserCon.find(".chartList1");
	 
	p.shareBtn = p.shareUserCon.find(".shareuserbtn");
	p.shareUserGoBak = p.shareUserCon.find(".shareuserGoBak");
	    
    p.shareusertab = p.shareUserCon.find(".shareusertab");
    p.followuserbtn = p.shareUserCon.find(".followuserbtn");
    p.followform = $("form[name=followform]");
    p.followuserid = p.followform.find(":hidden[name=openId]");
    p.follownickname = p.followform.find(":hidden[name=nickName]");
    p.followrelaid = p.followform.find(":hidden[name=relaId]");
    
    initTeamBtn();
    initTeamShareBtn();
    initTeamDelBtn();
}

function initTeamBtn(){
	//添加成员
	p.teamAdd.click(function(){
		//如果是工作计划没有子任务的话，则不能添加团队
		if('WorkReport'=='<%=relaModule%>'){
			if($(".subtask").size() == 0){
				 $(".myMsgBox").css("display","").html("请添加相关任务!");
	   		 	$(".myMsgBox").delay(2000).fadeOut();
	   		 	$(".g-mask").trigger("click");
	   		 	return;
			}
		}
		
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
		p.teamCon.find(".delImg").css("display", "none");
		initShareUserData();
		renderAttenUser();//渲染关注用户
		window.scrollTo(100, 0);//滚动到顶部
	});
	
	//删除成员
	p.teamSub.click(function(){
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
	});
}

//初始化团队成员
function initTeamUserCheck(){
	p.shareUserList.find("a").click(function(){
		var userid = $(this).find(":hidden[name=assId]").val();
		var username = $(this).find(":hidden[name=assName]").val();
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
			sessionStorage.removeItem(userid+"_teampeople");
		}else{
			$(this).addClass("checked");
			sessionStorage.setItem(userid+"_teampeople",userid+";"+username);
		}
  		return false;
	});
	
	p.followUserList.find("a").click(function(){
		var userid = $(this).find(":hidden[name=userid]").val();
		var username = $(this).find(":hidden[name=username]").val();
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
			sessionStorage.removeItem(userid+"_teampeople");
		}else{
			$(this).addClass("checked");
			sessionStorage.setItem(userid+"_teampeople",userid+";"+username);
		}
  		return false;
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
    	    	dataObj.push({name:'parentid', value: '<%=relaId%>' });
    	    	dataObj.push({name:'parenttype', value: '<%=relaModule%>' });
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
	    	dataObj.push({name:'parentid', value: '<%=relaId%>' });
	    	dataObj.push({name:'parenttype', value: '<%=relaModule%>' });
			dataObj.push({name:'type', value: 'share' });
			dataObj.push({name:'projname', value: '<%=relaName%>' });
			var shareuserid="";
			var shareusername = "";
		//从缓存中得到数据
		for(var i=0;i<sessionStorage.length;i++){
				var key = sessionStorage.key(i);
				if(key.indexOf("_teampeople")!=-1){
					var value=sessionStorage.getItem(key);
					var assId =value.split(";")[0];
					var assName = value.split(";")[1];
					shareuserid += assId+",";
				shareusername += assName+",";
    			if(teamUniqJudge(assId)){
    				dataObjSec.push({id: assId, name: assName ,type: 'sysuser'});
    			}
				}
		}

		if(shareuserid==""){
			$(".myMsgBox").css("display","").html("请选择共享用户!");
	    	$(".myMsgBox").delay(2000).fadeOut();
			return;
		}
		dataObj.push({name:'shareuserid', value: shareuserid });
		dataObj.push({name:'shareusername', value: shareusername });
    	//调用后台接口 发送 团队成员数据
		renderTeamPeason(dataObj, dataObjSec);
    	
		//如果是工作计划，调用工作计划跳转到分享页面
		var isDispTeam = "${isDispTeam}";
		if(isDispTeam == 'false'){
			toShare();
		}
		
		//回退
		p.shareUserGoBak.trigger("click");
	});
	p.shareUserGoBak.click(function(){
		
		p.shareUserCon.addClass("modal");
		p.taskCreateCon.removeClass("modal");
		$("._menu").css("display","");
		clearTeamSeesion();
		
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
	        p.shareUserList.find("a").removeClass("checked");
	        p.followUserChartList.css("display","none");
	        p.followUserList.css("display", "none");
	        p.shareBtn.css("display", "");
	        p.followuserbtn.css("display", "none");
		}
		if($(this).hasClass("attentionuser")){
			p.shareUserChartList.css("display", "none");
	        p.shareUserList.css("display", "none");
	        p.followUserChartList.css("display","");
	        p.followUserList.css("display", "");
	        p.followUserList.find("a").removeClass("checked");
	        p.shareBtn.css("display", "none");
	        p.followuserbtn.css("display", "");
		}
	});
 	renderAttenCheckedUser();//渲染选择的关注用户
}

//加载关注用户列表
function renderAttenUser(){
	   asyncInvoke({
	   		url: '<%=teampath%>/lovuser/attenuserlist',
	   		data: {relaId: '<%=relaId%>'},
	   	    callBackFunc: function(data){
	   	    	if(!data){ 
	   	    		p.followUserList.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
	   	    		return;
	   	    	}
	   	    	
	   	    	var d = JSON.parse(data);
	    	    if(d.errorCode && d.errorCode !== '0'){
	    	    	p.followUserList.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
		    	    return;
		    	}
	    	    initFollowFstChart();
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
			if(!this.rela_user_id) return;
				val += '<a href="javascript:void(0)" class="list-group-item listview-item radio first_char_'+this.first_char+'">'
/* 	         		+ '<div class="">'
	         		+ '<img style="border-radius: 10px;" width="40px" src="'+ this.headImgurl +'"/>'
	         		+ '</div>' */
	         		+ '<div class="list-group-item-bd" style="margin-left: 10px;">'
	         		+ '<input type="hidden" name="userid" value="'+this.openId+'"/>'
	         		+ '<input type="hidden" name="username" value="'+this.rela_user_name+'"/>'
	         		+ '<h2 class="title ">'+this.rela_user_name+'</h2>';
	         		if(this.mobile_no_1){
	         			val += 	'<p>电话：' + this.mobile_no_1 + '</p> ';
	         		}
	         		if(this.company){
	         			val += '<p>公司：' +this.company + '</p>';
	         		}
	         		if(this.position){
	         			val += '<p>职位：' + this.position + ' </p>';
	         		}
	         		val += '</div><div class="input-radio" title="选择该条记录"></div>'
	         		+'</a>';
		});
		p.followUserList.html(val);
}

//加载选中的关注用户列表
function renderAttenCheckedUser(){
	   asyncInvoke({
	   		url: '<%=teampath%>/teampeason/asynclist',
	   		data: {
	   			relaId: '<%=relaId%>'
	   		},
	   	    callBackFunc: function(data){
	   	    	if(!data){
	   	    		return;
	   	    	}
	   	    	var d = JSON.parse(data);
	   	    	compileAttenCheckedUserData(d);
	   	    	initTeamDelBtn();
	   	        renderTeamImgHead();
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
    		var val = '<div id="'+ this.openId +'" class="teamPeason" style="float: left;padding:5px 8px;">' 
    			+ '<input type="hidden" name="assId" value="'+ this.openId +'"/>'
    			+ '<input type="hidden" name="assName" value="'+this.nickName+'"/>'
    			+ '<input type="hidden" name="assFlag" value="Y"/>'
    			+ '<input type="hidden" name="type" value="attenuser"/>'
    			+ '<div style="text-align: center;">'
    			+ '<img src="<%=teampath%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -2px;left: 0px;">'
    			//+ '<img src="<%=teampath%>/image/defailt_person.png" class="headImg" id="'+ this.openId +'" style="width: 40px;border-radius: 10px;">'
    			//+ '</div>'
    			+ '<span>'+this.nickName+'</span></div>'
    			+ '</div>';
	         	
    		$(val).insertAfter(".teamCon .teamPeason:last");
		});
}

//调用后台接口 发送 团队成员数据
function renderTeamPeason(d, dSec){
	clearTeamSeesion();
	asyncInvoke({
		url: '<%=teampath%>/shareUser/upd',
		data: d,
	    callBackFunc: function(rst){
	    	if(!rst) return;
	    	rst = JSON.parse(rst);
	    	if(rst && rst.errorCode != '0'){
	    		alert(rst.errorMsg);
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
	var imgUrl = "<%=teampath%>/image/defailt_person.png";
	var tmp =['<div class="teamPeason" style="float: left;padding:5px 8px;">',
				  '<input type="hidden" name="assId" value="$$assId" />',
				  '<input type="hidden" name="assName" value="$$assName" />',
				  '<input type="hidden" name="assFlag" value="Y" />',
				  '<input type="hidden" name="type" value="$$type"/>',
				  '<div style="text-align: center;">',
				  '<img src="<%=teampath%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -2px;left: 0px;">',
				  //'<img src="$$imgUrl" class="headImg" style="width: 40px;border-radius: 10px;">',
				  '<span>$$text</span></div>',
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
	
	//如果是工作计划，调用工作计划跳转到分享页面
	var isDispTeam = "${isDispTeam}";
	if(isDispTeam == 'false'){
		toShare();
	}
	
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
   		url: '<%=teampath%>/teampeason/save',
   		type: 'post',
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
	   		url: '<%=teampath%>/teampeason/del',
	   		type: 'post',
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
	   	    	//renderAttenUser();
	   	    }
	   	});
}
//指尖好友退出团队
function exitTeam(){
	if(confirm("确定要退出吗？")){
		var dataObj = [];
		dataObj.push({name:'openId',value:''});
		dataObj.push({name:'relaId',value:'<%=relaId%>'});
		$.ajax({
	   		url: '<%=teampath%>/teampeason/del',
	   		type: 'post',
	   		data: dataObj,
	   		dataType: 'text',
	   	    success: function(data){
	   	    	if(!data) return;
	   	    	var obj  = JSON.parse(data);
	   	    	if(obj.errorCode && obj.errorCode !== '0'){
	   	    		$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
		    		$(".myMsgBox").delay(2000).fadeOut();
	   	    	}
	   	    	
	   	    	window.history.back(-1);
	   	    }
	   	});
	}
}

//初始化团队的权限
function renderTeamPerm(){
	//遍历业务机会跟进数据列表
	$(".teamPeason").each(function(){
		var assId = $(this).find(":hidden[name=assId]").val();
		var assFlag = $(this).find(":hidden[name=assFlag]").val();
		if('<%=crmId%>' === assId){
			if(assFlag === 'N' || "<%=assFlg%>" == "Y"){
				p.teamAdd.css("display", "");
       			p.teamSub.css("display", "");
   			}else{
   				p.teamAdd.css("display", "none");
       			p.teamSub.css("display", "none");
   			}
			}
			if(assFlag === 'N'){
				var o = p.teamCon.find(":hidden[name=assId][value=" + assId + "]");
				o.parent().find(".delImg").remove();
			}
	});
}

//显示图片头像
function renderTeamImgHead(){
	//关闭加截图像
	return;
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
    		url: '<%=teampath%>/wxuser/getImgHeader',
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

//异步加载分享用户数据  shareUserList
function initShareUserFstChart(){
	$.ajax({
		url: '<%=teampath%>/fchart/list',
		async: 'false',
		data: {
		   crmId: '<%=crmId%>',
		   type: p.shareUserCurrType.val(),
		   parenttype: "<%=relaModule%>",
		   parentid: "<%=relaId%>",
		   orgId: "<%=orgId%>"
		},
	    success : function(data){
	    	if(!data) return;
    	    var d = JSON.parse(data);
    	    if(d.errorCode && d.errorCode !== '0'){
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
    	    
    	    $(".chartList").css("padding","10px");
	    }
	});
}

//获取好友的首字母列表
function initFollowFstChart(){
	$.ajax({
		url: '<%=teampath%>/fchart/flist',
		async: 'false',
		data: {relaId:"<%=relaId%>"},
	    success : function(data){
	    	if(!data) return;
    	    var d = JSON.parse(data);
    	    if(d.errorCode && d.errorCode !== '0'){
	    	   return;
	    	}
    	    var ahtml = '';
    	    $(d).each(function(i){
    	    	if(null==this||''==this){
    	    		return;
    	    	}
    	    	ahtml += '<a href="javascript:void(0)"  style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
    	    });
    	    p.followUserChartList.html(ahtml);
    	    
    	    //点击字母
    		$("#shareuser-more").find(".chartList1").find("a").unbind("click").bind("click", function(event){
    			//p.followUserCurrPage.val("1");
    			//p.followUserFstChar.val($(this).html());
    			//renderAttenUser();
    			$(".followUserList").find("a").css("display","none");
    			$(".first_char_"+$(this).html()).css("display","");
    		});
    	    
    	    $(".chartList1").css("padding","10px");
	    }
	});
}

//团队用户唯一性判断
function teamUniqJudge(assId){
	var o = p.teamCon.find(":hidden[name=assId][value=" + assId + "]");
	if(o && o.length > 0) return false;
	return true;
}

//查询分享用户列表
function initShareUserData(){
	$.ajax({
		url: '<%=teampath%>/lovuser/userlist',
		data : {
			crmId : '<%=crmId%>',
			firstchar : p.shareUserFstChar.val(),
			flag : 'share',
			parentid : "<%=relaId%>",
			parenttype : "<%=relaModule%>",
			orgId:"<%=orgId%>",
			currpage : p.shareUserCurrPage.val(),
			pagecount : p.shareUserPageCount.val()
		},
		success : function(data) {
			if (!data){ 
				p.shareUserList.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
				return;
			}
			
			var d = JSON.parse(data);
    	    if(d.errorCode && d.errorCode !== '0'){
    	    	p.shareUserList.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
	    	    return;
	    	}
    	    
			initShareUserFstChart();
			compileShareUserData(d);
			initTeamUserCheck();
		}
	});
}

function compileShareUserData(d) {
	if (d.length === 0) {
		p.shareUserList.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
		return;
	}
	//组装数据
	var val = '';
	$(d).each(function(i) {
		if (!this.userid)
			return;
		if (sessionStorage.getItem(this.userid
				+ "_teampeople")) {
			val += '<a href="javascript:void(0)" class="list-group-item listview-item radio checked" >';
		} else {
			val += '<a href="javascript:void(0)" class="list-group-item listview-item radio" >';
		}
		val += '  <div class="list-group-item-bd">'
				+ '  <input type="hidden" name="assId" value="'+this.userid+'"/>'
				+ '  <input type="hidden" name="assName" value="'+this.username+'"/>'
				+ '  <h2 class="title ">'
				+ this.username;
				
		if(this.bindFlag == "true")
		{
			 val += '&nbsp;&nbsp;<span style="background-color:#EC863D;border-radius:5px;padding:1px 5px;color:#fff;font-size:12px;">已绑定</span>';
		}		
				
		val	+= '</h2>'
				+ '  <p>职称：'
				+ this.title
				+ '</p>'
				+ '  <p>部门：<b>'
				+ this.department
				+ '</b></p></div><div class="input-radio" title="选择该条记录"></div>'
				+ '</a>';
	});
	p.shareUserList.html(val);
}

//退出团队按钮 事件
function initExitTeamEvent(){
	var assFlg = '${assFlg}';//detail页面详情的assFlag
	if(assFlg === 'Y'){
		$(".exitTeamBtn").remove();
		return;
	}
	//退出按钮事件
	$(".exitTeamBtn").click(function(){
		var utype = getExitUserType();
		if(utype === 'sysuser'){
			sysUsrExit();
		}else if(utype === 'attenuser'){
			attenUsrExit();
		}
	});
}

function getExitUserType(){
	var openId = '<%=openId%>';
	var crmId = '<%=crmId%>';
	var utype = '';
	$(".teamCon .teamPeason").each(function(){
		var assId = $(this).find(":hidden[name=assId]").val();
		var type = $(this).find(":hidden[name=type]").val();
		if(crmId === assId || openId === assId){
			utype =  type;
		}
	});
	return utype;
}

//指尖好友的用户退出
function attenUsrExit(){
	if(confirm("确定要退出吗？")){
		var dataObj = [];
		dataObj.push({name:'openId',value:'<%=openId%>'});
		dataObj.push({name:'relaId',value:'<%=relaId%>'});
		$.ajax({
	   		url: '<%=teampath%>/teampeason/del',
	   		type: 'post',
	   		data: dataObj,
	   		dataType: 'text',
	   	    success: function(data){
	   	    	if(!data) return;
	   	    	var obj  = JSON.parse(data);
	   	    	if(obj.errorCode && obj.errorCode !== '0'){
	   	    		$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
		    		$(".myMsgBox").delay(2000).fadeOut();
	   	    	}
	   	    	window.location.replace('<%=teampath%>/home/index');
	   	    }
	   	});
	}
}

//系统好友的用户退出
function sysUsrExit(){
	//数组对象
	var dataObj = [], dataObjSec = [];
    	dataObj.push({name:'parentid', value: '<%=relaId%>' });
    	dataObj.push({name:'parenttype', value: '<%=relaModule%>' });
       	dataObj.push({name:'type', value: 'cancel' });
       	dataObj.push({name:'shareuserid', value: '${crmId}' });
		dataObj.push({name:'shareusername', value: '' });
		
	asyncInvoke({
		url: '<%=teampath%>/shareUser/upd',
		data: dataObj,
	    callBackFunc: function(rst){
	    	if(!rst) return;
	    	rst = JSON.parse(rst);
	    	if(rst && rst.errorCode != '0'){
	    		alert(rst.errorMsg);
	    		return;
	    	}
	    	
	    	window.location.replace('<%=teampath%>/home/index');
	    }
	});
}
</script>


<!-- 团队成员 -->
<div class="teamTitle" style="line-height:50px;font-size:14px;color:#666;padding-left:5px;">
	分享到
</div>
<div class="container hy bgcw teamCon" style="font-size: 14px;background: #fff;border-bottom:1px solid #ddd;padding-left: 80px;margin-top: -42px;">
	<c:if test="${fn:length(shareusers) > 0}">
		    <c:forEach items="${shareusers}" var="user">
				<div class="teamPeason" style="float: left;padding:5px 8px;">
				    <input type="hidden" name="assId" value="${user.shareuserid}" />
			  		<input type="hidden" name="assName" value="${user.shareusername}" />
			  		<input type="hidden" name="assFlag" value="${user.flag}" />
			  		<input type="hidden" name="type" value="sysuser"/>
				    <div style="text-align: center;">
				    	<img src="<%=teampath%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -2px;left: 4px;">
				    	<span>${user.shareusername}</span>
				    </div>
				</div>
			</c:forEach>
	</c:if>
	<c:if test="${assFlg eq 'Y'}">
		<div class="teamAdd" at="teamAdd" style="clear:both;cursor:pointer;float: left;width: 50px;padding-top:8px;padding-bottom: 8px;">
			<div style="text-align: center;">
			   <img src="<%=teampath%>/image/mem_add.png" style="width: 30px;">
			</div>
		</div>
		<c:if test="${relaModule ne 'WorkReport' }">
			<div class="teamSub" style="cursor: pointer;float:left;width:50px;padding-top:8px;padding-bottom: 8px;">
				<div style="text-align: center;">
					<img src="<%=teampath%>/image/mem_sub.png" style="width: 30px;">
				</div>
			</div>
		</c:if>
	</c:if>
	<c:if test="${assFlg ne 'Y'}">
		<!-- 退出按钮 -->
		<div class="exitTeamBtn" style="float: left;padding:5px 8px;">
			 <div style="text-align: center;margin-top:5px;">
				 <a href="javascript:void(0)" class="exitteam" style="background-color: #F77557;border-radius: 3px;color: #fff;padding: 1px 2px;">退出</a>
			 </div>
		</div>
	</c:if>
	
	<div style="clear:both;"></div>
</div>
			
<!-- 关注用户form -->
<form method="post" name="followform" action="" >
    <!-- 数据拥有者的openId -->
	<input type="hidden" name="openId" value="1111"/>
	<input type="hidden" name="nickName" value=""/>
	<input type="hidden" name="relaId" value="<%=relaId%>"/>
	<input type="hidden" name="relaModel" value="<%=relaModule%>"/>
	<input type="hidden" name="relaName" value="<%=relaName%>"/>
	<input type="hidden" name="orgId" value="<%=orgId%>"/>
</form>	