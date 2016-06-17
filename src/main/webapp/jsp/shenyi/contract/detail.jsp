<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js" type="text/javascript"></script>
<!--dc 基础类库-->
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<link rel="stylesheet" href="<%=path%>/css/style.css">
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css">
<script type="text/javascript">
    $(function () {
    	initVariable();
    	initBottomBtn();
    	shareBtnContol();//初始化分享按钮
    	//initWeixinFunc();
    	initButton();//初始化按钮
    	renderTeamPerm();
    	showImgHead();//显示团队成员的头像
	});
    
    //初始化底部操作按钮
    function initBottomBtn(){
    	//跟进按钮
		$(".addBtn").click(function(){
			if(!$(this).hasClass("showAddCon")){
				$(this).addClass("showAddCon");
				$(".addContainer").css('display','');
				$(".addContainer").css('height' ,'100');
				//$(this).html("<b>取消</b>");
				$("#upmenuimg").css("margin-bottom","135px");
			}else{
				$(this).removeClass("showAddCon");
				$(".addContainer").css('display','none');
				$(".addContainer").css('height' ,'0');
				$(".tasContainer").css("display", "none");
				//$(this).html('<img src="<%=path%>/image/addicon.png"/>');
				$("#upmenuimg").css("margin-bottom","0px");
			}
		});
		
		//task 任务 按钮
		$(".taskBtn").click(function(){
			//window.location.href = "<%=path%>/operorg/list?openId=${openId}&publicId=${publicId}&redirectUrl=" + encodeURIComponent('/schedule/get?publicId=${publicId}&openId=${openId}&parentId=${rowId}&parentType=Contract&parentName=${contractName}&flag=other');
			window.location.href = "<%=path%>/schedule/get?publicId=${publicId}&openId=${openId}&parentId=${rowId}&parentType=Contract&parentName=${contractName}&flag=other&orgId=${con.orgId}";
		});
		
		//contact 联系人 按钮
// 		$(".contactBtn").click(function(){
<%-- 			window.location.href = "<%=path%>/contact/get?publicId=${publicId}&openId=${openId}&parentId=${rowId}&parentName=${contractName}&parentType=Contract"; --%>
// 		});
		
		//contact 联系人 按钮
		$(".contactBtn").click(function(){
			$("#contract-create").addClass("modal");
			$("#site-nav").addClass("modal");
			$("#acct_more").removeClass("modal");
		});
		
		//联系人退回
		$(".acctGoBack").click(function(){
			$("#contract-create").removeClass("modal");
			$("#site-nav").removeClass("modal");
			$("#acct_more").addClass("modal");
			$(".addBtn").removeClass("showAddCon");
			$(".addContainer").css("display", "none");
			$(".tasContainer").css("display", "none");
			//$(".addBtn").html('<img src="<%=path%>/image/addicon.png"/>');
			$("#upmenuimg").css("margin-bottom","0px");
			//$("#flootermenu").css("height",'51px');
		});
		
		//勾选某个 联系人 的超链接
		$(".acctList > a").click(function(){
			$(".acctList > a").removeClass("checked");
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
			}
			return false;
		});
		
		// 联系人 的 确定按钮
		$(".acctbtn").click(function(){
			$(".acctList > a.checked").each(function(){
				var assId = $(this).find(":hidden[name=assId]").val();
				$("input[name=rowid]").val(assId);
				if(!assId){
					$(".myMsgBox").css("display","").html("请选择联系人!");
				    $(".myMsgBox").delay(2000).fadeOut();
					return;
				}
				$("form[name=contactForm]").submit();
			});
			
		});
		
		
		//增加回款计划
		$(".plangatheringBtn").click(function(){
			window.location.href = "<%=path%>/gathering/get?crmId=${crmId}&orgId=${con.orgId}&publicId=${publicId}&openId=${openId}&contractId=${rowId}&contractName=${contractName}&gatheringtype=plan";
		});
		
		//增加回款明细
		$(".detgatheringBtn").click(function(){
			window.location.href = "<%=path%>/gathering/get?crmId=${crmId}&orgId=${con.orgId}&publicId=${publicId}&openId=${openId}&contractId=${rowId}&contractName=${contractName}&gatheringtype=detail";
		});
		
		//文本输入框点击事件
    	$("textarea[name=inputMsg]").unbind("click").bind("click", function(){//点击事件
    		 $("#upmenuimg").css("margin-bottom","0px");
	   		 if($(".addBtn").hasClass("showAddCon")){
	   			$(".addBtn").removeClass("showAddCon");
	   				$(".addContainer").css('display','none');
	   				$(".addContainer").css('height' ,'0');
					//$(".tasContainer").css("display", "none");
	   		 }
	   		 
    	});
    }
    
    var p = {};
    
    function initVariable(){
    	
    	p.shareform = $("form[name=shareform]");
   	    p.openId = p.shareform.find(":hidden[name=openId]");
   	    p.publicId = p.shareform.find(":hidden[name=publicId]");
   	    p.parentid = p.shareform.find(":hidden[name=parentid]");
   	    p.parenttype = p.shareform.find(":hidden[name=parenttype]");
   	    p.shareuserid = p.shareform.find(":hidden[name=shareuserid]");
   	    p.shareusername = p.shareform.find(":hidden[name=shareusername]");
   	    p.type = p.shareform.find(":hidden[name=type]");
   	 	p.teamCon=$(".teamCon");
   	 	p.teamAdd=p.teamCon.find(".teamAdd");
   	 	p.teamSub=p.teamCon.find(".teamSub");
        p.particDiv = $("#shareuser-more");
        p.particFstChar = p.particDiv.find(":hidden[name=fstChar]");
        p.particCurrType = p.particDiv.find(":hidden[name=currType]");
    	p.particCurrPage = p.particDiv.find(":hidden[name=currPage]");
    	p.particPageCount = p.particDiv.find(":hidden[name=pageCount]");
        p.particChartList = p.particDiv.find(".chartList");
        p.particList = p.particDiv.find(".shareUserList");
        p.particBtn = p.particDiv.find(".shareuserbtn");
        
        p.msgCon = $(".msgContainer");
   	    p.msgModelType = p.msgCon.find("input[name=msgModelType]");
   	    p.msgType = p.msgCon.find("input[name=msgType]");//消息类型
  	    p.inputTxt = p.msgCon.find("textarea[name=inputMsg]");//输入的文本框
  	    p.targetUId = p.msgCon.find("input[name=targetUId]");//目标用户ID
  	    p.targetUName = p.msgCon.find("input[name=targetUName]");//目标用户名
  	    p.subRelaId = p.msgCon.find("input[name=subRelaId]");//子关联ID
  	    p.examinerSend = p.msgCon.find(".examinerSend");//发送按钮
  	    
  	    p.nativeDiv = $("#site-nav");
        p.contractDetailDiv = $("#contract-create");
        p.contractDetailFormDiv = p.contractDetailDiv.find(".contractDetailForm");
        
        p.shareusertab = p.particDiv.find(".shareusertab");
        p.followUserList = p.particDiv.find(".followUserList");
        p.followuserbtn = p.particDiv.find(".followuserbtn");
        p.followform = $("form[name=followform]");
        p.followuserid = p.followform.find(":hidden[name=openId]");
        p.follownickname = p.followform.find(":hidden[name=nickName]");
   	    p.followrelaid = p.followform.find(":hidden[name=relaId]");
    }

	function delShare(){
		//删除按钮 点击事件
		$(".teamCon").find(".delImg").unbind("click").click(function(){
			var assId = $(this).parent().parent().find(":hidden[name=userid]").val();
			var assName = $(this).parent().parent().find(":hidden[name=username]").val();
			var type = $(this).parent().parent().find(":hidden[name=type]").val();
    		if(type === "sysuser"){
    			$("form[name=shareform]").find(":hidden[name=shareuserid]").val(assId);
    			$("form[name=shareform]").find(":hidden[name=shareusername]").val(assName);
    			p.type.val("cancel");
    	    	//调用后台接口 发送 团队成员数据
    			saveShareUser();
    		}else if(type === "attenuser"){
    			$("form[name=followform]").find(":hidden[name=openId]").val(assId);
    			delFollowUser();
    		}
	    	
			$("#"+assId).remove();
		});
	}    
    
    //初始化按钮
    function initButton(){
    	//增加团队成员
		$(".teamAdd").click(function(){
			$("#site-nav").css("display","none");
			$(".site-recommend").addClass("modal");
			$("#shareuser-more").removeClass("modal");
			$("._menu").css("display","none");
			p.particList.find("a").each(function(){
				if($(this).hasClass("checked")){
					$(this).removeClass();
				}
			});
			p.followUserList.find("a").each(function(){
				if($(this).hasClass("checked")){
					$(this).removeClass("checked");
				}
			});
			 p.particFstChar.val('');
			$(".delImg").css("display","none");
			rendertPartic();
			renderAttenUser();//渲染关注用户
			window.scrollTo(100, 0);//滚动到顶部
		});
		
		//用户的返回按钮
		$(".shareuserGoBak").click(function(){
			$("#site-nav").css("display","");
			$(".site-recommend").removeClass("modal");
			$("#shareuser-more").addClass("modal");
			$("._menu").css("display","");
			clearTeamSeesion();
			$(".delImg").css("display","none");
		});
		
		//删除团队成员,头像上加删除标志
		delShare();
		
		//删除成员
    	$(".teamCon").find(".teamSub").click(function(){
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
    	});
    	//点击用户确定按钮
		p.particBtn.click(function(){
			var shareuserid="";
			var shareusername = "";
			var data=[];
			for(var i=0;i<sessionStorage.length;i++){
				var key = sessionStorage.key(i);
				if(key.indexOf("_teampeople")!=-1){
					var value=sessionStorage.getItem(key);
					var id =value.split(";")[0];
					var name = value.split(";")[1];
					shareuserid += id+",";
					shareusername += name+",";
					data.push({id:id , name:name, type: 'sysuser'});
				}
			}
// 			p.particList.find("a").each(function(){
// 				if($(this).hasClass("checked")){
// 					var id=$(this).find(":hidden[name=userid]").val();
// 					var name=$(this).find(":hidden[name=username]").val();
// 					shareuserid += id+",";
// 					shareusername += name+",";
// 					data.push({id:id , name:name, type: 'sysuser'});
// 				}
// 			});
			if(shareuserid==""){
				$(".myMsgBox").css("display","").html("请选择共享用户!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			p.shareuserid.val(shareuserid);
			p.shareusername.val(shareusername);
			p.type.val("share");
			saveShareUser(data);
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
    			p.particChartList.css("display", "");
    	        p.particList.css("display", "");
    	        p.followUserList.css("display", "none");
    	        p.particBtn.css("display", "");
    	        p.followuserbtn.css("display", "none");
    		}
    		if($(this).hasClass("attentionuser")){
    			p.particChartList.css("display", "none");
    	        p.particList.css("display", "none");
    	        p.followUserList.css("display", "");
    	        p.particBtn.css("display", "none");
    	        p.followuserbtn.css("display", "");
    		}
    	});
    	
    	renderAttenCheckedUser();//渲染选择的关注用户
    	
		//发送消息
    	p.examinerSend.click(function(){
    		sendMessage();
    	});
		
    	//文本输入框点击事件
    	p.inputTxt.unbind("keyup").bind("keyup", function(){//内容改变 、键盘输入完、 事件
    		var v = $(this).val();
    		
    		handlerErtUserList(v, getTeamLeas());//输入@符号作的处理
    	});
    }
    
    //获取 获取团队成员
    function getTeamLeas(){
 	   	var tArr = [];
 	   	$(".teamCon > div.teamPeason").each(function(){
 	   		var uid = $(this).find(":hidden[name=userid]").val();
 	   		var uname = $(this).find(":hidden[name=username]").val();
 	   		tArr.push({uid:uid, uname:uname});
 	   	});
 	   	return tArr;
    }
    
    //查询用户
    function compParticChartData(){
	asyncInvoke({
		url: '<%=path%>/fchart/list',
		async: 'false',
		data: {
		   crmId: '${crmId}',
		   type: p.particCurrType.val(),
		   parenttype:"Contract",
		   parentid:"${rowId}"
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
    	    p.particChartList.html(ahtml);
    	    
    	    //点击字母
    		$("#shareuser-more").find(".chartList").find("a").unbind("click").bind("click", function(event){
    			p.particCurrPage.val("1");
    			p.particFstChar.val($(this).html());
    			rendertPartic();
    		});
	    }
	});
	
}
    //按首字母查询
   function rendertPartic(){
   	asyncInvoke({
   		url: '<%=path%>/lovuser/userlist',
   		data: {
   			crmId: '${crmId}',
   			firstchar: p.particFstChar.val(), 
			flag:'share',
			parentid:"${rowId}",
			parenttype:"Contract",
			currpage: p.particCurrPage.val(),
			pagecount: p.particPageCount.val()  
   		},
   	    callBackFunc: function(data){
   	    	if(!data) return;
   	    	var d = JSON.parse(data);
   	    	compParticChartData();
   	    	compileParticData(d);
   	    	initTeamUserCheck();
   	    }	
   	});
    }
   
    //异步加载用户
   function compileParticData(d){
		if(d.length === 0){
			p.particList.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
	    	return;
	    }
		//组装数据
		var val = '';
		$(d).each(function(i){
			if(!this.userid) return;
			if(sessionStorage.getItem(this.userid+"_teampeople")){
         		val+='<a href="javascript:void(0)" class="list-group-item listview-item radio checked" >';
         	}else{
         		val+='<a href="javascript:void(0)" class="list-group-item listview-item radio" >';
         	}
			val	+='<div class="list-group-item-bd">'
         		+ '<input type="hidden" name="userid" value="'+this.userid+'">'
         		+ '<input type="hidden" name="username" value="'+this.username+'">'
         		+ '<h2 class="title ">'+this.username+'</h2>'
         		+ '<p>职称：'+this.title+'</p>'
         		+ '<p>部门：<b>'+this.department+'</b></p></div><div class="input-radio" title="选择该条记录"></div>'
         		+'</a>';
		});
		p.particList.html(val);
		
	}
    
   //初始化团队成员
 	function initTeamUserCheck(){
 		p.particList.find("a").click(function(){
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
	   	    	delShare();
	   	    	showImgHead();
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
       			+ '<input type="hidden" name="userid" value="'+ this.openId +'">'
       			+ '<input type="hidden" name="username" value="'+this.nickName+'">'
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
   
    //新增或者删除团队成员
   function saveShareUser(d){
	 //组装数据异步提交 
   	var dataObj = [];
   	p.shareform.find("input").each(function(){
   		var n = $(this).attr("name");
   		var v = $(this).val();
   		dataObj.push({name: n, value: v});
   	});
   	clearTeamSeesion();
   	$.ajax({
   		url: '<%=path%>/shareUser/upd',
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
   	    	}else{
   	    		if($("form[name=shareform]").find(":hidden[name=type]").val() == 'share'){
	   	    		compTeamPeason(d);
   	    			$(".site-recommend").removeClass("modal");
   	    			$("#site-nav").css("display","");
   	 				p.particDiv.addClass("modal");
   	 				$("._menu").css("display","");
   	 				delShare();
   	    		}
   	    	}
   	    }
   	});
   }
    
 //删除团队成员缓存的session
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
    
   //保存非关注用户
   function saveFollowUser(d){
	    //组装数据
		compTeamPeason(d);
			
		p.contractDetailDiv.removeClass("modal");
		$("#site-nav").css("display","");
		p.particDiv.addClass("modal");
		$("._menu").css("display","");
		
		//初始化分享删除按钮
	    delShare();
			
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
    
 	//追加团队成员
   function compTeamPeason(d){
   	if(!d || d.length == 0){
	   return;   
  	}
 	 //遍历数据追加到DOM节点
	var v = '';
	$(d).each(function(){
		v += '<div id="'+this.id+'" class="teamPeason" style="float: left;width: 25%;margin-top: 10px;">'
		  +  '<input type="hidden" name="userid" value="'+this.id+'">'
		  +  '<input type="hidden" name="username" value="'+this.name+'">'
		  +  '<input type="hidden" name="assFlag" value="Y">'
		  +  '<input type="hidden" name="type" value="'+this.type+'">'
		  +  '<div style="text-align: center;"><img src="<%=path%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;"><img src="<%=path%>/image/defailt_person.png"class="headImg"style="width: 50px;height: 50px;border-radius: 10px;">'
		  +  '</div><div style="margin-top: 10px;text-align: center;"><span>'+this.name+'</span></div></div>';
	});
	//var id = $(".teamCon").find(".teamPeason").last().attr("id");
	$(".teamCon").find(".teamPeason").last().after(v);
	//显示图片头像
	showImgHead();
	renderTeamPerm();//初始化团队的权限
   }
   //显示图片头像
   function showImgHead(){
   	//遍历业务机会跟进数据列表
   	$(".teamPeason").each(function(){
   		var userId = $(this).find(":hidden[name=userid]").val();
   		var img = $(this).find(".headImg");
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
       	    	  $(img).attr("src",data);
       	        //本地缓存
   	            sessionStorage.setItem(userId + "_headImg",data);
       	    }
       	});
   	});
   }

   //初始化团队的权限
    function renderTeamPerm(){
    	//遍历业务机会跟进数据列表
    	/*$(".teamPeason").each(function(){
    		var assId = $(this).find(":hidden[name=userid]").val();
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
   				var o = p.teamCon.find(":hidden[name=userid][value=" + assId + "]");
   				o.parent().find(".delImg").remove();
   			}
    	});*/
    }
    
    
    
    //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			var newUrl = r2.replace(getSepcialStr($(this).attr("href"), 'openId='), '${openIdNew}');
    			$(this).attr("href", newUrl);
    			return true;
    		});
    	}
    }
    
    //微信网页按钮控制
	/* function initWeixinFunc(){
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('showOptionMenu');
		});

		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
	 //得到当前时间
    function getDate(){   
    	var today = new Date();   
    	var day = today.getDate();   
    	var month = today.getMonth() + 1; 
	   	var hour = today.getHours();  
	   	var minute = today.getMinutes();
    	if(minute<10){
    		minute ='0'+minute;
    	}
    	var date = month + "-" + day+"  "+hour+":"+minute;   
    	
    	return date;
    }

  //验证正数
  function validates(num){
	   var reg = /^\d+(?=\.{0,1}\d+$|$)/;
	   if(reg.test(num)) return true;
	   return false ;  
  }
  
    </script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">
		合同详情
		</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div id="contract-create" class="view site-recommend">
		<div class="recommend-box contractDetailForm">
				<div id="view-list" class="list list-group1 listview accordion" style="margin:0;background-image:url(<%=path%>)/image/back-img.png)">
					<div class="card-info1">
						<a href="<%=path%>/contract/modify?openId=${openId}&publicId=${publicId}&rowId=${rowId}&orgId=${con.orgId}"
							class="list-group-item listview-item">
							<div class="list-group-item-bd">
								<h1 class="title">${contractName}&nbsp;
								<span style="color: #AAAAAA; font-size: 13px;">${con.assigner}
									</span>
								</h1>
								<p>金额：￥${con.cost}元 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;        
								 结束日期：${con.endDate} </p>
							
							</div> <span class="icon icon-uniE603" ></span>
						</a>
					</div>
				</div>
<%-- 				<c:if test="${sessionScope[openId].FC_COMMON_OPER.ZJWK_ROLE_CONTRACT_GATHERING eq '1' }"> --%>
				<!-- 回款信息总计 -->
				<div id="view-list" style="margin-top:1px;"  class="list list-group1 listview accordion" >
					<div class="card-info" style="padding:0px;">
						<a href="<%=path%>/gathering/ilist?openId=${openId}&publicId=${publicId}&contractId=${rowId}&crmId=${crmId}" class="list-group-item listview-item">
							<div class="list-group-item-bd"  style="font-size:16px;height:40px;margin-top:10px;">
								已回款${con.reccount}笔
								<span style="float:right;">￥${con.recamttotal}万元 / ￥${con.invamttotal}万元</span>
							</div>
							<span class="icon icon-uniE603" style="margin-left:10px;"></span>
						</a>
					</div>
				</div>
				
				<%--跟进历史 --%>
				<jsp:include page="/common/follow.jsp">
					<jsp:param value="Contracts" name="parenttype"/>
					<jsp:param name="parentid" value="${rowId}" />
					<jsp:param name="crmId" value="${crmId}" />
					<jsp:param name="orgId" value="${con.orgId}" />
				</jsp:include>
				
<!-- 				跟进历史 -->
<%-- 				<c:if test="${fn:length(auditList) > 0 }"> --%>
<!-- 				<div style="padding-left:5px;padding-right:5px;"> -->
<!-- 					<div style="line-height:50px;font-size:16px;font-weight:bold;padding-left:8px;"> -->
<%-- 							<img src="<%=path%>/image/title-feed.png" width="20px" style="margin-bottom:3px;opacity:0.3;">&nbsp;跟进历史 --%>
<!-- 					</div> -->
<!-- 					<div id="div_audit" class="container hy bgcw conBox _border_"> -->
<!-- 						<dl class="hyrc" id="tc01"> -->
<%-- 							<c:forEach items="${auditList }" var="audit" varStatus="stat"> --%>
<!-- 								序号等于5的情况 -->
<%-- 								<c:if test="${stat.index == 5}"> --%>
<!-- 									<div id="more_div" style="width: 100%; text- align: center;"> -->
<!-- 										<div style="clear: both"></div> -->
<!-- 										<div style="padding: 8px; font-size: 14px;text-align: center;"> -->
<!-- 											<a href="javascript:void(0)" -->
<!-- 												onclick='$("#more_div").css("display","none");$("#more_list").css("display","");'>查看全部&nbsp;↓</a> -->
<!-- 										</div> -->
<!-- 									</div> -->
<!-- 									<div id="more_list" style="display: none;"> -->
<%-- 								</c:if> --%>
								
<!-- 								序号大于5的情况 -->
<%-- 								<c:if test="${stat.index >= 5 }"> --%>
<!-- 									<dt style="line-height: 34px;"> -->
<%-- 										${audit.opdate}<span style="top: 16px;"></span> --%>
<!-- 									</dt> -->
<!-- 									<dd style="width: 70%;cursor: pointer" class="" > -->
<!-- 										<div style="border: 1px solid #ededed;border-radius: 3px;background: #f8f8f8;line-height: 24px;text-indent: 0;padding: 4px 4px 4px 6px;"> -->
<%-- 											<ul class="opptyReplayCon" opid="${audit.opid}" opname="${audit.opname}" --%>
<%-- 									     			subRelaId="${audit.parentid }" > --%>
<%-- 											<c:if test="${audit.optype eq 'upd_gathering_plan' }"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>修改了一个回款计划： --%>
<%-- 													<a href="<%=path %>/contact/detail?gatheringtype=plan&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'upd_gathering_detail' }"> --%>
<%-- 												<span style="color: #3e6790"> ${audit.opname}</span>修改了一个回款明细： --%>
<%-- 													<a href="<%=path %>/contact/detail?gatheringtype=detail&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'add_gathering_plan' }"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个回款计划： --%>
<%-- 													<a href="<%=path %>/contact/detail?gatheringtype=plan&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'add_gathering_detail' }"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个回款明细： --%>
<%-- 													<a href="<%=path %>/contact/detail?gatheringtype=detail&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'contact'}"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个联系人： --%>
<%-- 													<a href="<%=path %>/contact/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'tasks'}"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个任务：<a --%>
<%-- 														href="<%=path %>/schedule/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'share'}"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>添加团队成员：${audit.aftervalue} --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'cancel_share'}"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>删除团队成员：${audit.aftervalue} --%>
<%-- 											</c:if> --%>
<!-- 											</ul> -->
<!-- 											<ul class="twitter opptyReplayRst" style="display:none"></ul>  -->
<!-- 										</div> -->
<!-- 									</dd> -->
<%-- 								</c:if> --%>
<!-- 								序号小于5的情况 -->
<%-- 								<c:if test="${stat.index < 5 }"> --%>
<!-- 									<dt style="line-height: 34px;"> -->
<%-- 										${audit.opdate}<span style="top: 16px;"></span> --%>
<!-- 									</dt> -->
<!-- 									<dd style="width: 70%;cursor: pointer" > -->
<!-- 										<div style="border: 1px solid #ededed;border-radius: 3px;background: #f8f8f8;line-height: 24px;text-indent: 0;padding: 4px 4px 4px 6px;"> -->
<%-- 										   	<ul class="opptyReplayCon" opid="${audit.opid}" opname="${audit.opname}" --%>
<%-- 									     			subRelaId="${audit.parentid }" > --%>
<%-- 											<c:if test="${audit.optype eq 'upd_gathering_plan' }"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>修改了一个回款计划： --%>
<%-- 													<a href="<%=path %>/contact/detail?gatheringtype=plan&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'upd_gathering_detail' }"> --%>
<%-- 												<span style="color: #3e6790"> ${audit.opname}</span>修改了一个回款明细： --%>
<%-- 													<a href="<%=path %>/contact/detail?gatheringtype=detail&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'add_gathering_plan' }"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个回款计划： --%>
<%-- 													<a href="<%=path %>/contact/detail?gatheringtype=plan&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'add_gathering_detail' }"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个回款明细： --%>
<%-- 													<a href="<%=path %>/contact/detail?gatheringtype=detail&openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'contact'}"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个联系人： --%>
<%-- 													<a href="<%=path %>/contact/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'tasks'}"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>创建了一个任务：<a --%>
<%-- 														href="<%=path %>/schedule/detail?openId=${openId }&publicId=${publicId }&rowId=${audit.parentid }">${audit.aftervalue}</a> --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'share'}"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>添加团队成员：${audit.aftervalue} --%>
<%-- 											</c:if> --%>
<%-- 											<c:if test="${audit.optype eq 'cancel_share'}"> --%>
<%-- 													<span style="color: #3e6790"> ${audit.opname}</span>删除团队成员：${audit.aftervalue} --%>
<%-- 											</c:if> --%>
<!-- 											</ul> -->
<!-- 										</div> -->
<!-- 									</dd> -->
<%-- 								</c:if> --%>
								
<%-- 							</c:forEach> --%>
<!-- 						</dl> -->
<!-- 					</div> -->
<!-- 					<div style="clear: both"></div> -->
<!-- 					</div> -->
<%-- 				</c:if> --%>
				
<%-- 				</c:if> --%>
<%-- 				<c:if test="${sessionScope[openId].FC_COMMON_OPER.ZJWK_ROLE_CONTRACT_AUTITS eq '1' }"> --%>
				<!-- 审批历史 -->
				<c:if test="${fn:length(approves) > 0 }">
					<h3 class="wrapper examineInfo">审批历史</h3>
					<div id="div_audit" class="container hy bgcw">
						<div class="conBox">
							<dl class="hyrc" id="tc01">
								<c:forEach items="${approves }" var="app">
									<c:if test="${app.approvalstatus eq 'approving'}">
										<dt style="line-height: 34px;width:100px;">
											${app.commitdate}<span style="top: 16px;"></span>
										</dt>
										<dd id="${app.commitid}" st="${app.approvalstatus}"style="width:60%;padding-right:5px;">
											<p>
												<span style="color:#3e6790">
												<c:if test="${app.commitid eq crmId }">
													我
												</c:if>
												<c:if test="${app.commitid ne crmId }">
													${app.commitname}
												</c:if>
												</span>
												<c:if test="${app.type eq '转交' }">
													转交给
												</c:if>
												<c:if test="${app.type ne '转交' }">
													提交给
												</c:if>
												
												<span style="color:#3e6790">
												<c:if test="${app.approvalid eq crmId }">
													我
												</c:if>
												<c:if test="${app.approvalid ne crmId }">
													${app.approvalname}
												</c:if>
												</span>审批
											</p>
										</dd>
									</c:if>
									<c:if test="${app.approvalstatus eq 'approved'}">
										<dt style="line-height: 34px;width:100px;">
										${app.commitdate}<span style="top: 16px;"></span>
										</dt>
										<dd id="${app.commitid}" st="${app.approvalstatus}" style="width:60%;padding-right:5px;">
											<p>
												<span style="color:#3e6790">
												<c:if test="${app.commitid eq crmId }">
													我
												</c:if>
												<c:if test="${app.commitid ne crmId }">
													${app.commitname}
												</c:if>
												</span><span style="color:green">审批通过</span>
												<c:if test="${app.approvalname ne ''}">
													,并提交给<span style="color:#3e6790">
													<c:if test="${app.approvalid eq crmId }">
														我
													</c:if>
													<c:if test="${app.approvalid ne crmId }">
														${app.approvalname }
													</c:if>
													</span>审批
												</c:if>
											</p>
										</dd>
									</c:if>
									<c:if test="${app.approvalstatus eq 'reject'}">
										<dt style="line-height: 34px;width:100px;">
										${app.commitdate}<span style="top: 16px;"></span>
										</dt>
										<dd id="${app.commitid}" st="${app.approvalstatus}" style="width:60%;padding-right:5px;">
											<p>
												<span style="color:#3e6790">
													<c:if test="${app.commitid eq crmId }">
														我
													</c:if>
													<c:if test="${app.commitid ne crmId }">
														${app.commitname}
													</c:if>
												</span>&nbsp;<span style="color:red">已驳回</span>
												<c:if test="${app.approvaldesc ne '' }">
													(${app.approvaldesc})
												</c:if>
												
											</p>
										</dd>
									</c:if>
								</c:forEach>
							</dl>
						</div>
					</div>
				</c:if>
				
				<!-- 团队成员 -->
				<h3 class="wrapper teamTitle"><img src="<%=path%>/image/title-team.png" width="20px" style="margin-bottom:3px;opacity:0.6;">&nbsp;团队成员</h3>
				<div class="container hy bgcw teamCon" style="font-size: 14px;background: #fff;">
					<c:if test="${fn:length(shareusers) > 0}">
						<c:forEach items="${shareusers}" var="user">
							<div id="${user.shareuserid}" class="teamPeason" style="float: left;width: 25%;margin-top: 10px;">
								<input type="hidden" name="userid" value="${user.shareuserid}">
								<input type="hidden" name="username" value="${user.shareusername}">
								<input type="hidden" name="assFlag" value="${user.flag}">
								<input type="hidden" name="type" value="sysuser">
								<div style="text-align: center;">
								  <img src="<%=path%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;">
								  <img src="<%=path%>/image/defailt_person.png" class="headImg" id="${user.shareuserid}" style="width: 50px;height: 50px;border-radius: 10px;">
								</div>
							    <div style="margin-top: 10px;text-align: center;"><span>${user.shareusername}</span></div>
							</div>
						</c:forEach>
					</c:if>
					<c:if test="${con.authority eq 'Y'}">
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
		<!-- 底部操作区域 -->
			<div class="flooter" id="flootermenu" 
				style="z-index: 99999; background: #FFF; border-top: 1px solid #ddd; opacity: 1;">
				<!--发送消息的区域  -->
				<div class="msgContainer">
					<div class="ui-block-a" style="float: left;margin: 5px 0px 10px 10px;">
						<img id="upmenuimg" src="<%=path%>/scripts/plugin/menu/images/upmenu.png" width="30px" style="position:fixed;bottom:10px;" onclick="swicthUpMenu('flootermenu')">
					</div>
					<div class="ui-block-a replybtn"
						style="width:100%; margin: 5px 0px 5px 40px;padding-right:110px;">
						<!-- 目标用户ID -->
						<input type="hidden" name="targetUId" value="${con.assignerid}" />
						<!-- 目标用户名 -->
						<input type="hidden" name="targetUName"  value="${con.assigner}" />
						<!-- 消息模块 -->
					    <input name="msgModelType" type="hidden" value="contract" />
						<!-- 子级关联ID -->
						<input type="hidden" name="subRelaId" />
						<input name="msgType" type="hidden" value="txt" />
						<textarea name="inputMsg" id="inputMsg" style="width: 98%;font-size: 16px; line-height:20px;height: 40px;margin-left: 5px; margin-top: 0px;" class="form-control" placeholder="回复"></textarea>
					</div>
					<div class="ui-block-a "
						style="float: right; width: 60px; margin: -45px 5px 0px 0px;">
						<a href="javascript:void(0)"
				    		class="btn addBtn" style="font-size: 14px;width: 100%;background-color:RGB(255,255,255);border:0px;" ><img src="<%=path%>/image/followup.png" width="30px"></a>
						<a href="javascript:void(0)" class="btn examinerSend"
							style="font-size: 14px; display:none;width:100%;background-color: rgb(62, 144, 88);"><b>发送</b></a>
					</div>
					<div style="clear: both;"></div>
				</div>
				<!-- 添加任务、联系人 按钮 -->
				<div class="addContainer"
					style="background: #fff; z-index: 99999; display: none; border-top-color: #E6DADA; border-top: 1px solid #C2B2B2; padding-top: 25px;">
					
					<div class="ui-block-a taskBtn" style="cursor:pointer;float: left; width: 33%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/schedule.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">任务</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					
					<div class="ui-block-a contactBtn" style="display:none;cursor:pointer;float: left; width: 25%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
						<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
							<img alt="" src="<%=path %>/image/oppty_contact.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
						</div>
						<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">联系人</div>
						<div style="line-height:20px;">&nbsp;</div>
					</div>
					
					<div class="ui-block-a plangatheringBtn"
						style="cursor: pointer; float: left; width: 33%; margin-left: 10px; margin: 5px 0px 5px 0px;">
						<div
							style="border-radius: 5px; border: 1px solid #E6DFDF; margin-left: 10px; margin-right: 10px;">
							<img alt="" src="<%=path%>/image/wx_oppty_comp.png"
								style="width: 45px; height: 45px; margin-top: 5px; margin-bottom: 5px;">
						</div>
						<div
							style="font-size: 13px; margin-top: 10px; color: #8D8282; font-family: 'Microsoft YaHei';">回款计划</div>
						<div style="line-height: 20px;">&nbsp;</div>
					</div>
					
						<div class="ui-block-a detgatheringBtn" style="cursor:pointer;float: left; width: 33%; margin-left: 10px;margin: 5px 0px 5px 0px;/* margin-bottom: 5px; */">
							<div style="border-radius: 5px;border: 1px solid #E6DFDF;margin-left: 10px;margin-right: 10px;">
								<img alt="" src="<%=path %>/image/assigner.png" style="width: 35px;height: 35px;margin-top: 10px;margin-bottom: 10px;">
							</div>
							<div style="font-size: 13px;margin-top: 10px;color: #8D8282;font-family: 'Microsoft YaHei';">回款明细</div>
							<div style="line-height:20px;">&nbsp;</div>
						</div>
					<div style="clear: both;"></div>
					<div class="ui-block-a " style="height: 10px"></div>
				</div>
			</div>
		
	</div>
	
	<!-- 回款计划列表DIV -->
<!-- 	<div id="gathering-more" class=" modal"> -->
<!-- 		<div id="" class="navbar"> -->
<!-- 			<a href="#" onclick="javascript:void(0)" -->
<!-- 				class="act-primary gatheringGoBak"><i class="icon-back"></i></a> -->
<!-- 			回款计划 -->
<!-- 		</div> -->
<!-- 		<div class="site-recommend-list page-patch"> -->
<!-- 			<div id="div_contact_list" class="list-group listview"> -->
<%-- 				<c:forEach items="${gatherings}" var="gathering"> --%>
<%-- 					<a href="<%=path%>/gathering/ilist?openId=${openId}&publicId=${publicId}&contractId=${rowId}&rowId=${gathering.rowid}" class="list-group-item listview-item"> --%>
<!-- 							<div class="list-group-item-bd" > -->
<!-- 							<div class="thumb list-icon"> -->
<!-- 							<b> -->
<%-- 							${gathering.status} --%>
<!-- 							</b> -->
<!-- 							</div> -->
<%-- 								<div class="content"><h1 class="title">${gathering.title}&nbsp;<span --%>
<%-- 								style="color: #AAAAAA; font-size: 12px;">${gathering.assigner }</span> --%>
<%-- 								<c:if test="${gathering.margin eq '0.00'}"> --%>
<!-- 									<p style="color:blue;float:right">已付清</p> -->
<%-- 								</c:if> --%>
<%-- 								<c:if test="${gathering.margin ne '0.00'}"> --%>
<!-- 									<p style="color:blue;float:right">未付清</p> -->
<%-- 								</c:if> --%>
<!-- 								</h1> -->
<%-- 								<p>计划:&nbsp;&nbsp;&nbsp;&nbsp;${gathering.planDate}&nbsp;&nbsp;&nbsp;&nbsp;￥${gathering.planAmount}万元</p> --%>
<%-- 								<p>实际:&nbsp;&nbsp;&nbsp;&nbsp;￥${gathering.receivedAmount}万元</p> --%>
<!-- 								</div> -->
<!-- 							</div> -->
<!-- 							 <span class="icon icon-uniE603"></span> -->
<!-- 						</a> -->
<%-- 				</c:forEach> --%>
<%-- 				<c:if test="${fn:length(gatherings) == 0 }"> --%>
<!-- 					<div style="text-align:center;padding-top:50px;">没有找到数据</div> -->
<%-- 				</c:if> --%>
<!-- 			</div> -->
<!-- 		</div> -->
<!-- 	</div> -->
		
	<!-- 共享用户form -->
	<form method="post" name="shareform" action="" >
		<input type="hidden" name="openId" value="${openId}">
		<input type="hidden" name="publicId" value="${publicId}">
		<input type="hidden" name="parentid" value="${rowId}">
		<input type="hidden" name="crmname" value="${sessionScope.CurrentUser.name}">
		<input type="hidden" name="projname" value="${contractName}">
		<input type="hidden" name="parenttype" value="Contract">
		<input type="hidden" name="shareuserid" value="">
		<input type="hidden" name="shareusername" value="">
		<input type="hidden" name="type" value="">
	</form>
	<!-- 关注用户form -->
	<form method="post" name="followform" action="" >
	    <input type="hidden" name="crmId" value="${crmId}">
		<input type="hidden" name="ownerOpenId" value="${openId}">
		<input type="hidden" name="openId" value="">
		<input type="hidden" name="nickName" value="">
		<input type="hidden" name="relaId" value="${rowId}">
		<input type="hidden" name="relaModel" value="Contract">
		<input type="hidden" name="relaName" value="${contractName}">
		<input type="hidden" name="assigner" value="${sessionScope.CurrentUser.name}">
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
			<div class=" flooter" style="font-size: 14px;background: #F7F7F7;border-top: 1px solid #ADA7A7;padding-top: 4px;padding-right:20px;">
				<input class="btn btn-block shareuserbtn" type="button" value="确&nbsp;定" style="width: 100%;margin: 3px 0px 3px 8px;" >
				<input class="btn btn-block followuserbtn" type="button" value="确&nbsp;定" style="display:none;width: 100%;margin: 3px 0px 3px 8px;" >
			</div>
		</div>
	</div>
	
	<!-- 选择联系人提交表单 -->
	<form name="contactForm" action="<%=path%>/contact/saveContact" method="post">
		<input type="hidden" name="publicId" value="${publicId}" />
		<input type="hidden" name="openId" value="${openId}" />
		<input type="hidden" name="parentId" value="${rowId}" />
		<input type="hidden" name="parentType" value="Contract" />
		<input type="hidden" name="rowid" value="" >
	</form>
	
	<!-- 联系人列表DIV -->
	<div id="acct_more" class=" modal" >
		<div id="" class="navbar">
		    <a href="#" onclick="javascript:void(0)" class="act-primary acctGoBack"><i class="icon-back"></i></a>
				联系人列表
			<a href="<%=path%>/contact/add?publicId=${publicId}&openId=${openId}&parentId=${rowId}&parentType=Contract" style="float: right;color:#fff;">添加</a>
		</div>
		<div class="page-patch">
			<div class="list-group listview listview-header acctList">
				<c:forEach items="${contactList}" var="uitem">
					<a href="javascript:void(0)" class="list-group-item listview-item radio">
						<div class="list-group-item-bd">
							<input type="hidden" name="assId" value="${uitem.rowid}"/>
							<div class="thumb list-icon" style="background-color:#ffffff;width:45px;height:45px;">
									<c:if test="${uitem.filename ne ''}">
										<img src="<%=path %>/contact/download?fileName=${uitem.filename}" border=0 width="60px" height="60px;"style="background-color:#ffffff;">
									</c:if>
									<c:if test = "${uitem.filename eq ''}">
										<img src="<%=path %>/image/defailt_person.png" border=0 width="60px" height="60px;"style="background-color:#ffffff;">
									</c:if>
							</div>
							<div class="content" style="text-align: left">
								<h1>${uitem.conname }&nbsp;<span
										style="color: #AAAAAA; font-size: 12px;">${uitem.salutation}</span></h1>
							<p>
								${uitem.conjob }&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${uitem.phonemobile}
							</p>
							</div>
						</div>
						<div class="input-radio" title="选择该条记录"></div>
					</a>
				</c:forEach>
				<c:if test="${fn:length(contactList) == 0}">
					<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">
						无数据
					</div>
				</c:if>
			</div>
			<c:if test="${fn:length(contactList) > 0}">
				<div class="ui-block-a flooter" style="width: 100%;margin-left: 10px;height:42px;z-index:999999;opacity:1;padding-right:20px;">
					<a href="javascript:void(0)" class="btn btn-block acctbtn" style="font-size: 14px;">确&nbsp;定</a>
    			</div>
			</c:if>
		</div>
	</div>
	
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	<!-- 关注用户权限控制JSP -->
	<jsp:include page="/common/eventmonitor.jsp"></jsp:include>
	<!-- 分享JS区域 -->
	<%-- <script src="<%=path%>/scripts/util/share.util.js"
		type="text/javascript"></script>
	<script type="text/javascript">
		var dataForWeixin = {  
			appId:"${publicId}",  
			MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",  
			TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=path%>/image/wxcrm_logo.png",
			url : "https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=PropertiesUtil.getAppContext("wxcrm.appid")%>&redirect_uri="+encodeURIComponent('<%=PropertiesUtil.getAppContext("app.content")%>/entr/access?orgId=${con.orgId}&fopenId=${openId}&parentId=${rowId}&parentType=contract')+"&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect",
			title : "分享合同",
			desc : "${contractName}",
			fakeid : "",
			callback : function() {
			}
		};
	</script> --%>
</body>
</html>