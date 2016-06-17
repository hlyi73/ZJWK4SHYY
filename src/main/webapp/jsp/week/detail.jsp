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
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<link rel="stylesheet" href="<%=path%>/css/style.css"/>
<link rel="stylesheet" href="<%=path%>/css/bootstrap.min.css"/>
<script type="text/javascript">
    $(function () {
    	//初始化分享按钮
    	//shareBtnContol();
    	//initWeixinFunc();
    	gotopcolor();
    	//初始化网页控件
    	initVariable();
    	initOpptyForm();
    	//显示团队成员的头像
    	loadTeamImgHead();
	});
    
    //加载网页控件
	function initOpptyForm(){
		//初始化团队按钮
	    initTeamBtn();
		//删除团队成员,头像上加删除标志
		initShareDelBtn();
		initForm();
	}
    
    String.prototype.trim=function(){
		return this.replace(/(^\s*)|(\s*$)/g, "");
	};
    
    //分享按钮控制 如果是分享用户进入页面查看 需要禁用界面的 超链接  和 按钮以及其它元素
    function shareBtnContol(){
    	var c = '${shareBtnContol}';
    	if(c){
    		$("a").click(function(){
    			//TODO 以后扩展需要做其他的事情
    			return true;
    		});
    	}
    }
    
    //微信网页按钮控制
	/* function initWeixinFunc(){
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
    
    function gotopcolor(){
    	$(".gotop").css("background-color","rgba(213, 213, 213, 0.6)");
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
    	
        p.nativeDiv = $("#site-nav");
        p.weekDetailDiv = $("#weekDetail");
        p.weekDetailFormDiv = p.weekDetailDiv.find(".weekDetailForm");
        
        p.msgCon = $(".msgContainer");
	    p.msgModelType = p.msgCon.find("input[name=msgModelType]");
	    p.msgType = p.msgCon.find("input[name=msgType]");//消息类型
	    p.inputTxt = p.msgCon.find("textarea[name=inputMsg]");//输入的文本框
	    p.targetUId = p.msgCon.find("input[name=targetUId]");//目标用户ID
	    p.targetUName = p.msgCon.find("input[name=targetUName]");//目标用户名
	    p.subRelaId = p.msgCon.find("input[name=subRelaId]");//子关联ID
	    p.examinerSend = p.msgCon.find(".examinerSend");//发送按钮
        
        p.particDiv = $("#shareuser-more");
        p.particFstChar = p.particDiv.find(":hidden[name=fstChar]");
        p.particCurrType = p.particDiv.find(":hidden[name=currType]");
    	p.particCurrPage = p.particDiv.find(":hidden[name=currPage]");
    	p.particPageCount = p.particDiv.find(":hidden[name=pageCount]");
        p.particChartList = p.particDiv.find(".chartList");
        p.particList = p.particDiv.find(".shareUserList");
        p.particBtn = p.particDiv.find(".shareuserbtn");
        p.suSelectedBtn = p.particDiv.find(".suSelectedbtn");
        
        p.shareusertab = p.particDiv.find(".shareusertab");
        p.followUserList = p.particDiv.find(".followUserList");
        p.followuserbtn = p.particDiv.find(".followuserbtn");
        p.followform = $("form[name=followform]");
        p.followuserid = p.followform.find(":hidden[name=openId]");
        p.follownickname = p.followform.find(":hidden[name=nickName]");
   	    p.followrelaid = p.followform.find(":hidden[name=relaId]");
        
    }
    //初始化团队按钮
    function initTeamBtn(){
    	//增加团队成员
		$(".teamAdd").click(function(){
			$("#site-nav").css("display","none");
			$("#weekDetail").addClass("modal");
			$("#flootermenu").addClass("modal");
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
			$("#weekDetail").removeClass("modal");
			$("#shareuser-more").addClass("modal");
			$("._menu").css("display","");
			p.particList.find("a").each(function(){
				if($(this).hasClass("checked")){
					$(this).removeClass();
				}
			});
			$("#flootermenu").removeClass("modal");
			$(".delImg").css("display","none");
		});
		
		//删除成员
    	$(".teamCon").find(".teamSub").click(function(){
    		$(".teamCon").find(".teamPeason").each(function(){
    			var flag = $(this).find(":hidden[name=flag]").val();
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
		
    	//点击团队用户确定按钮
		p.particBtn.click(function(){
			var shareuserid="";
			var shareusername = "";
			var data=[];
			p.particList.find("a").each(function(){
				if($(this).hasClass("checked")){
					var id=$(this).find(":hidden[name=userid]").val();
					var name=$(this).find(":hidden[name=username]").val();
					shareuserid += id+",";
					shareusername += name+",";
					data.push({id:id , name:name, type: 'sysuser'});
				}
			});
			if(shareuserid==""){
				$(".myMsgBox").css("display","").html("请选择共享用户!");
    	    	$(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			p.shareuserid.val(shareuserid);
			p.shareusername.val(shareusername);
			$("#flootermenu").removeClass("modal");
			p.type.val("share");
			//新增或者删除团队成员
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
			$("#flootermenu").removeClass("modal");
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
    }
    
    //删除团队成员,头像上加删除标志
    function initShareDelBtn(){
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
    
    function initForm(){
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
  	
    
  //显示图片头像
    function showSingleMsgImgHead(userId, img){
    	if(sessionStorage.getItem(userId + "_headImg")){
    		$(img).attr("src", sessionStorage.getItem(userId + "_headImg"));
    		return;
    	}
   		if(userId){
 	   		//异步调用获取消息数据
 	       	asyncInvoke({
 	       		url: '<%=path%>/wxuser/getImgHeader',
 	       		data: {crmId: userId},
 	       	    callBackFunc: function(data){
 	       	    	if(data){
 	       	    	  $(img).attr("src",data);
 	       	    	  //本地缓存
 	       	          sessionStorage.setItem(userId + "_headImg",data);
 	       	    	}
 	       	    }
 	       	});
   		}
    }
  	
    
    //查询用户
    function compParticChartData(){
		asyncInvoke({
			url: '<%=path%>/fchart/list',
			async: 'false',
			data: {
			   crmId: '${crmId}',
			   type: p.particCurrType.val(),
			   parenttype:"WeekReport",
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
				parenttype:"WeekReport",
				currpage: p.particCurrPage.val(),
				pagecount: p.particPageCount.val()  
	   		},
	   	    callBackFunc: function(data){
	   	    	if(!data) return;
	   	    	var d = JSON.parse(data);
	   	    	compParticChartData();
	   	    	compileParticData(d);
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
				val += '<a href="javascript:void(0)" class="list-group-item listview-item radio" >'
	         		+ '<div class="list-group-item-bd">'
	         		+ '<input type="hidden" name="userid" value="'+this.userid+'">'
	         		+ '<input type="hidden" name="username" value="'+this.username+'">'
	         		+ '<h2 class="title ">'+this.username+'</h2>'
	         		+ '<p>职称：'+this.title+'</p>'
	         		+ '<p>部门：<b>'+this.department+'</b></p></div><div class="input-radio" title="选择该条记录"></div>'
	         		+'</a>';
		});
		p.particList.html(val);
		
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
	   	    	initShareDelBtn();
	   	    	loadTeamImgHead();
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
       			+ '<input type="hidden" name="flag" value="Y">'
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
	   	    			//组装数据
		   	    		compTeamPeason(d);
		   	    		
	   	    			$("#weekDetail").removeClass("modal");
	   	    			$("#site-nav").css("display","");
	   	 				p.particDiv.addClass("modal");
	   	 				$("._menu").css("display","");
	   	 				
	   	 				//初始化分享删除按钮
	   	 			    initShareDelBtn();
	   	    		}
	   	    	}
	   	    }
	   	});
   }
    
 //保存非关注用户
   function saveFollowUser(d){
	    //组装数据
  		compTeamPeason(d);
  		
		$("#weekDetail").removeClass("modal");
		$("#site-nav").css("display","");
		p.particDiv.addClass("modal");
		$("._menu").css("display","");
		
		//初始化分享删除按钮
	    initShareDelBtn();
		
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
			  +  '<input type="hidden" name="flag" value="Y">'
			  +  '<input type="hidden" name="type" value="'+this.type+'">'
			  +  '<div style="text-align: center;"><img src="<%=path%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;"><img src="<%=path%>/image/defailt_person.png"class="headImg"style="width: 50px;height: 50px;border-radius: 10px;">'
			  +  '</div><div style="margin-top: 10px;text-align: center;"><span>'+this.name+'</span></div></div>';
		});
		var id = $(".teamCon").find(".teamPeason").last().attr("id");
		$("#"+id).after(v);
		//显示图片头像
		loadTeamImgHead();
   }
 	
   //显示图片头像
   function loadTeamImgHead(){
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
   
   </script>
</head>

<body>
<div id="task-create">
	<!-- 导航栏菜单 -->
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">${sd.reporttypename}</h3>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<!-- 业务机会详情 容器 -->
	<div id="weekDetail">
			<div class="recommend-box weekDetailForm">
				<!-- <h4>详情</h4> -->
					<div id="view-list" class="list list-group1 listview accordion" style="margin:0">
						<div class="card-info">
							<a href="<%=path%>/weekreport/modify?openId=${openId}&publicId=${publicId}&rowId=${rowId}&reporttype=${sd.reporttype}"
								class="list-group-item listview-item">
								<div class="list-group-item-bd">
									<h1 class="title">${sd.reporttypename}&nbsp;
									</h1>
									<p style="font-size:14px;">填报人：${sd.assigner}&nbsp;&nbsp;&nbsp;&nbsp;填报日期：${sd.date}</p>
								</div> <span class="icon icon-uniE603" ></span>
							</a>
						</div>
					</div>
					
				<!-- 团队成员 -->
				<h3 class="wrapper teamTitle" style="display:'';">团队成员</h3>
				<div class="container hy bgcw teamCon" style="font-size: 14px;background: #fff;">
					<c:if test="${fn:length(shareusers) > 0}">
						<c:forEach items="${shareusers}" var="user">
							<div id="${user.shareuserid}" class="teamPeason" style="float: left;width: 25%;margin-top: 10px;">
								<input type="hidden" name="userid" value="${user.shareuserid}">
								<input type="hidden" name="username" value="${user.shareusername}">
								<input type="hidden" name="flag" value="${user.flag}">
								<input type="hidden" name="type" value="sysuser">
								<div style="text-align: center;">
								  <img src="<%=path%>/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;">
								  <img src="<%=path%>/image/defailt_person.png" class="headImg" id="${user.shareuserid}" style="width: 50px;height: 50px;border-radius: 10px;">
								</div>
							    <div style="margin-top: 10px;text-align: center;"><span>${user.shareusername}</span></div>
							</div>
						</c:forEach>
					</c:if>
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
					<div style="clear: both;">&nbsp;</div> 
				</div>
				<jsp:include page="/common/messages.jsp"></jsp:include>
			</div>
			</div>
		<!-- 发送消息的区域 -->
		<div class="flooter" id="flootermenu" 
		       style="z-index: 99999;background: #FFF;background: rgb(253, 253, 255);border-top: 1px solid #A2A2A2;opacity: 1;">
			<!--发送消息的区域  -->
			<div class="msgContainer">
			    <div class="ui-block-a" style="float: left;margin: 5px 0px 10px 10px;">
					<img style="position:fixed;bottom:10px;" src="<%=path %>/scripts/plugin/menu/images/upmenu.png" width="30px" onclick="swicthUpMenu('flootermenu')">
				</div>
				<div class="ui-block-a msgdiv" style="width: 100%;margin: 5px 0px 5px 40px;padding-right: 110px;">
				     <!-- 目标用户ID -->
					<input type="hidden" name="targetUId" value="${sd.assignerid}" />
					<!-- 目标用户名 -->
					<input type="hidden" name="targetUName" value="${sd.assigner}" />
					<!-- 子级关联ID -->
					<input type="hidden" name="subRelaId" />
					<!-- 消息模块 -->
					<input name="msgModelType" type="hidden" value="weekreport" />
					<!-- 消息类型 txt img doc-->
					<input name="msgType" type="hidden" value="txt" />
<!-- 					<input name="inputMsg" value="" style="width:98%;line-height:40px;font-size:14px;height:40px;margin-left: 5px;margin-top: 0px;" type="text" class="form-control" placeholder="回复"> -->
				<textarea name="inputMsg" id="inputMsg" style="width: 98%;font-size: 16px; line-height:20px;height: 40px;margin-left: 5px; margin-top: 0px;" class="form-control" placeholder="回复"></textarea>
				</div>
				<div class="ui-block-a " style="float: right;width: 60px;margin: -45px 0px 5px 0px;">
						<a href="javascript:void(0)" class="btn  btn-block examinerSend" style="font-size: 14px;width:100%;">发送</a>
					</div>
				<div style="clear: both;"></div>
			</div>
		</div>
	</div>
	<!-- 共享用户form -->
	<form method="post" name="shareform" action="" >
		<input type="hidden" name="openId" value="${openId}">
		<input type="hidden" name="publicId" value="${publicId}">
		<input type="hidden" name="parentid" value="${rowId}">
		<input type="hidden" name="crmname" value="${assigner}">
		<input type="hidden" name="projname" value="${weekName}">
		<input type="hidden" name="parenttype" value="WeekReport">
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
		<input type="hidden" name="relaModel" value="WeekReport">
		<input type="hidden" name="relaName" value="${weekName}">
		<input type="hidden" name="assigner" value="${assigner}">
	</form>
	
	<!-- 可以供选择的  共享用户列表DIV -->
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
			<div class="list-group listview  followUserList" style="display:none">
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
	<jsp:include page="/common/ertuserlist.jsp"></jsp:include>
	<div style="min-height:30px;"></div>
	<!-- myMsgBox -->
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	<!-- 关注用户权限控制JSP -->
	<jsp:include page="/common/eventmonitor.jsp"></jsp:include>
	
</body>
</html>