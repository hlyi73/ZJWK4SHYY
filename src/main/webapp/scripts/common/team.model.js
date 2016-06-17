/**
 * 系统用户
 */
//对外提供的调用方法 隐藏 跟进历史 列表
function ivk_hideTeamList(){
	team.con.addClass("modal");
	team.title.addClass("modal");
}
//对外提供的调用方法 显示 跟进历史 列表
function ivk_showTeamList(){
	team.con.removeClass("modal");
	team.title.removeClass("modal");
}


var team = {};

//初始化团队元素
function initTeamElem(){
	
	team.share_user_form = $("form[name=share_user_form]");
	team.shareuserid = team.share_user_form.find(":hidden[name=shareuserid]");
	team.shareusername = team.share_user_form.find(":hidden[name=shareusername]");
	team.type = team.share_user_form.find(":hidden[name=type]");
	team.follow_user_form = $("form[name=follow_user_form]");
	team.followuserid = team.follow_user_form.find(":hidden[name=openId]");
	team.follownickname = team.follow_user_form.find(":hidden[name=nickName]");
	
	team.title = $(".team_title");
	team.con = $(".team_con");
	team.team_peasons = team.con.find(".team_peasons");
	team.add_btn = team.con.find(".team_add");
	team.sub_btn = team.con.find(".team_sub");
	
	team.share_user_con = $("#share_users");//可以选择的共享用户容器
	team.shareuser_gobak = team.share_user_con.find(".shareuser_gobak");//
	team.fstchar_search = team.share_user_con.find(":hidden[name=fstChar]");//
	team.currtype_search = team.share_user_con.find(":hidden[name=currType]");//
	team.currpage_search = team.share_user_con.find(":hidden[name=currPage]");//
	team.pagecount_search = team.share_user_con.find(":hidden[name=pageCount]");//
	team.chart_list = team.share_user_con.find(".chart_list");//
	team.share_user_tab = team.share_user_con.find(".share_user_tab");//
	team.sys_users = team.share_user_con.find(".sys_users");//可以选择的系统用户
	team.follow_users = team.share_user_con.find(".follow_users");//可以选择的关注用户
	team.sys_user_btn = team.share_user_con.find(".sys_user_btn");//
	team.follow_user_btn = team.share_user_con.find(".follow_user_btn");//
	
}

 //初始化团队按钮
function initTeamBtn(){
	//增加团队成员
	team.add_btn.click(function(){
		$("#site-nav").css("display","none");
		$("._menu").css("display","none");
		team.main_invoke_con.addClass("modal");
		team.con.addClass("modal");
		team.title.addClass("modal");
		team.share_user_con.removeClass("modal");
		//其它
		var ivk_main_hide = team.ivk_main_invoke_con_hide.split(",");
		for(var i = 0; i < ivk_main_hide.length ; i++){
			eval(ivk_main_hide[i]);
		}
		
		team.sys_users.find("a").each(function(){
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}
		});
		team.follow_users.find("a").each(function(){
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}
		});
		
		loadSysuserList_Team();
		loadFollowUserList();//渲染关注用户
		
		team.fstchar_search.val('');
		team.share_user_con.find(".delImg").css("display","none");
		window.scrollTo(100, 0);//滚动到顶部
	});
	
	//删除成员
	team.sub_btn.click(function(){
		team.con.find(".team_peason").each(function(){
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
	
	//用户的返回按钮
	team.shareuser_gobak.click(function(){
		$("#site-nav").css("display","");
		$("._menu").css("display","");
		
		team.main_invoke_con.removeClass("modal");
		team.con.removeClass("modal");
		team.title.removeClass("modal");
		team.share_user_con.addClass("modal");
		
		//其它
		var ivk_main_show = team.ivk_main_invoke_con_show.split(",");
		for(var i = 0; i < ivk_main_show.length ; i++){
			eval(ivk_main_show[i]);
		}
		
		team.sys_users.find("a").each(function(){
			if($(this).hasClass("checked")){
				$(this).removeClass();
			}
		});
		team.follow_users.find("a").each(function(){
			if($(this).hasClass("checked")){
				$(this).removeClass();
			}
		});
		
		team.share_user_con.find(".delImg").css("display","none");
	});
	
	//点击团队用户确定按钮
	team.sys_user_btn.click(function(){
		var shareuserid="";
		var shareusername = "";
		var data=[];
		team.sys_users.find("a").each(function(){
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
		team.shareuserid.val(shareuserid);
		team.shareusername.val(shareusername);
		team.type.val("share");
		//新增或者删除团队成员
		saveSysUser(data);
	});
	
	//关注用户确定按钮
	team.follow_user_btn.click(function(){
		var shareuserid="";
		var shareusername = "";
		var data=[];
		team.follow_users.find("a").each(function(){
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
		team.followuserid.val(shareuserid);
		team.follownickname.val(shareusername);
		//新增或者删除团队成员
		saveFollowUser(data);
	});
	
	//团队用户列表 TAB页切换
	team.share_user_tab.find("div").click(function(){
		$(this).siblings().removeClass("active");
		$(this).addClass("active");
		if($(this).hasClass("system_user_tab")){
			team.chart_list.css("display", "");
			team.sys_users.css("display", "");
			team.follow_users.css("display", "none");
			team.sys_user_btn.css("display", "");
			team.follow_user_btn.css("display", "none");
		}
		if($(this).hasClass("follow_user_tab")){
			team.chart_list.css("display", "none");
			team.sys_users.css("display", "none");
			team.follow_users.css("display", "");
			team.sys_user_btn.css("display", "none");
			team.follow_user_btn.css("display", "");
		}
	});
	
	//权限控制
	if(team.authority === 'Y'){
		team.add_btn.css("display", "");
		team.sub_btn.css("display", "");
	}
	
	loadCheckedSysUser();//渲染选择的系统用户
	loadCheckedFollowUser();//渲染选择的关注用户
}

//删除团队成员,头像上加删除标志
function initTeamDelBtn(){
	//删除按钮 点击事件
	team.con.find(".delImg").click(function(){
		var assId = $(this).parent().parent().find(":hidden[name=userid]").val();
		var assName = $(this).parent().parent().find(":hidden[name=username]").val();
		var type = $(this).parent().parent().find(":hidden[name=type]").val();
		if(type === "sysuser"){
			team.shareuserid.val(assId);
			team.shareusername.val(assName);
			team.type.val("cancel");
	    	//调用后台接口 发送 团队成员数据
			saveSysUser();
		}else if(type === "attenuser"){
			team.followuserid.val(assId);
			delFollowUser();
		}
		
		$("#"+assId).remove();
	});
}

//按首字母查询
function loadSysuserList_Team(){
   	asyncInvoke({
   		url:  getContentPath() + '/lovuser/userlist',
   		data: {
   			crmId: team.crmid,
			flag: 'share',
			parentid: team.rowid,
			parenttype: team.parenttype,
			firstchar: team.fstchar_search.val(), 
			currpage: team.currpage_search.val(),
			pagecount: team.pagecount_search.val()  
   		},
   	    callBackFunc: function(data){
   	    	if(!data) return;
   	    	var d = JSON.parse(data);
   	    	compSysuserChartData_Team();
   	    	compSysuserData_Team(d);
   	    }	
   	});
}

//查询用户
function compSysuserChartData_Team(){
	asyncInvoke({
		url:  getContentPath() + '/fchart/list',
		data: {
		   crmId: team.crmid,
		   type: team.currtype_search.val(),
		   parenttype: team.parenttype,
		   parentid: team.rowid
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
    	    team.chart_list.html(ahtml);
    	    
    	    //点击字母
    	    team.chart_list.find("a").unbind("click").bind("click", function(event){
    			team.currpage_search.val("1");
    			team.fstchar_search.val($(this).html());
    			loadSysuserList_Team(); 
    		});
	    }
	});
}

 //异步加载用户
function compSysuserData_Team(d){
	if(d.length === 0){
		team.sys_users.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
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
	team.sys_users.html(val);
}


//加载关注用户列表
function loadFollowUserList(){
   asyncInvoke({
   		url: getContentPath() + '/lovuser/attenuserlist',
   		data: {
   			relaId: team.rowid
   		},
   	    callBackFunc: function(data){
   	    	if(!data) return;
   	    	var d = JSON.parse(data);
   	    	compFollowUserData(d);
   	    }	
   	});
}

//异步加载用户
function compFollowUserData(d){
	if(d.length === 0){
		team.follow_users.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
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
	team.follow_users.html(val);
}

//加载选中的系统用户列表
function loadCheckedSysUser(){
	asyncInvoke({
   		url: getContentPath() + '/shareUser/shareUsersList',
   		data: {
   			rowId: team.rowid,
   			openId: team.openid,
   			publicId: team.publicid,
   			parenttype: team.parenttype
   		},
   	    callBackFunc: function(data){
   	    	if(!data) return;
   	    	var d = JSON.parse(data);
   	    	compCheckedSysUserData(d);
   	    	initTeamDelBtn();
   	    	loadTeamImgHead();
   	    }	
   });
}

function compCheckedSysUserData(d){
	if(d.length === 0){
		return;
    }
	//组装数据
	$(d).each(function(i){
		if(!this.shareuserid) return;
		var val = '<div id="'+ this.shareuserid +'" class="team_peason" style="float: left;width: 25%;margin-top: 10px;">'
			+ '<input type="hidden" name="userid" value="'+ this.shareuserid +'">'
			+ '<input type="hidden" name="username" value="'+this.shareusername+'">'
			+ '<input type="hidden" name="flag" value="'+ this.flag +'">'
			+ '<input type="hidden" name="type" value="sysuser">'
			+ '<div style="text-align: center;">'
			+ '<img src="'+ getContentPath() +'/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;">'
			+ '<img src="'+ getContentPath() +'/image/defailt_person.png" class="headImg" id="'+ this.shareuserid +'" style="width: 50px;height: 50px;border-radius: 10px;">'
			+ '</div>'
			+ '<div style="margin-top: 10px;text-align: center;"><span>'+this.shareusername+'</span></div>'
			+ '</div>';
		team.team_peasons.append(val);
	});
}

//加载选中的关注用户列表
function loadCheckedFollowUser(){
   asyncInvoke({
   		url: getContentPath() + '/teampeason/asynclist',
   		data: {
   			relaId: team.rowid
   		},
   	    callBackFunc: function(data){
   	    	if(!data) return;
   	    	var d = JSON.parse(data);
   	    	compCheckedFollowUserData(d);
   	    	initTeamDelBtn();
   	    	loadTeamImgHead();
   	    }	
   	});
} 

//异步加载选中的用户
function compCheckedFollowUserData(d){
	if(d.length === 0){
		return;
    }
	//组装数据
	$(d).each(function(i){
		if(!this.openId) return;
    		var val = '<div id="'+ this.openId +'" class="team_peason" style="float: left;width: 25%;margin-top: 10px;">'
    			+ '<input type="hidden" name="userid" value="'+ this.openId +'">'
    			+ '<input type="hidden" name="username" value="'+this.nickName+'">'
    			+ '<input type="hidden" name="flag" value="Y">'
    			+ '<input type="hidden" name="type" value="attenuser">'
    			+ '<div style="text-align: center;">'
    			+ '<img src="'+ getContentPath() +'/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;">'
    			+ '<img src="'+ getContentPath() +'/image/defailt_person.png" class="headImg" id="'+ this.openId +'" style="width: 50px;height: 50px;border-radius: 10px;">'
    			+ '</div>'
    			+ '<div style="margin-top: 10px;text-align: center;"><span>'+this.nickName+'</span></div>'
    			+ '</div>';
         	
    		team.team_peasons.append(val);
	});
}

//新增或者删除团队成员
function saveSysUser(d){
	if(team.type.val() == 'share'){
		//组装数据
		compTeamPeason(d);
		
		team.main_invoke_con.removeClass("modal");
		team.share_user_con.addClass("modal");
		//其它
		var ivk_main_show = team.ivk_main_invoke_con_show.split(",");
		for(var i = 0; i < ivk_main_show.length ; i++){
			eval(ivk_main_show[i]);
		}
	
		$("#site-nav").css("display","");
		$("._menu").css("display","");
			
		//初始化分享删除按钮
	    initTeamDelBtn();
	}
	
    //组装数据异步提交 
   	var dataObj = [];
   	team.share_user_form.find("input").each(function(){
   		var n = $(this).attr("name");
   		var v = $(this).val();
   		dataObj.push({name: n, value: v});
   	});
   	
   	$.ajax({
   		url: getContentPath() + '/shareUser/upd',
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
   	    }
   	});
}

//保存非关注用户
function saveFollowUser(d){
    //组装数据
	compTeamPeason(d);
	
	team.main_invoke_con.removeClass("modal");
	team.share_user_con.addClass("modal");
	//其它
	var ivk_main_show = team.ivk_main_invoke_con_show.split(",");
	for(var i = 0; i < ivk_main_show.length ; i++){
		eval(ivk_main_show[i]);
	}
	$("#site-nav").css("display","");
	$("._menu").css("display","");
	
	//初始化分享删除按钮
    initTeamDelBtn();
	
    //组装数据异步提交 
   	var dataObj = [];
   	team.follow_user_form.find("input").each(function(){
   		var n = $(this).attr("name");
   		var v = $(this).val();
   		dataObj.push({name: n, value: v});
   	});
   	
   	$.ajax({
   		url: getContentPath() + '/teampeason/save',
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
   	team.follow_user_form.find("input").each(function(){
   		var n = $(this).attr("name");
   		var v = $(this).val();
   		dataObj.push({name: n, value: v});
   	});
   	
   	$.ajax({
   		url: getContentPath() + '/teampeason/del',
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
   	    	loadFollowUserList();
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
		v += '<div id="'+this.id+'" class="team_peason" style="float: left;width: 25%;margin-top: 10px;">'
		  +  '<input type="hidden" name="userid" value="'+this.id+'">'
		  +  '<input type="hidden" name="username" value="'+this.name+'">'
		  +  '<input type="hidden" name="flag" value="Y">'
		  +  '<input type="hidden" name="type" value="'+this.type+'">'
		  +  '<div style="text-align: center;">'
		  +  '  <img src="'+ getContentPath() +'/image/fasdel.png" class="delImg" style="cursor:pointer;display:none;height: 15px;width: 15px;position: relative;top: -24px;left: 12px;">'
		  +  '  <img src="'+ getContentPath() +'/image/defailt_person.png"class="headImg"style="width: 50px;height: 50px;border-radius: 10px;">'
		  +  '</div><div style="margin-top: 10px;text-align: center;"><span>'+this.name+'</span></div></div>';
	});
	team.team_peasons.append(v);
	//显示图片头像
	loadTeamImgHead();
}

//显示图片头像
function loadTeamImgHead(){
 	//遍历业务机会跟进数据列表
 	$(".team_peason").each(function(){
 		var userId = $(this).find(":hidden[name=userid]").val();
 		var img = $(this).find(".headImg");
 	    //显示单个图片头像
 	   	if(sessionStorage.getItem(userId + "_headImg")){
 	   		$(img).attr("src", sessionStorage.getItem(userId + "_headImg"));
 	   		return;
 	   	}
 		//异步调用获取消息数据
     	asyncInvoke({
     		url: getContentPath() + '/wxuser/getImgHeader',
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

//获取 获取团队成员
function getTeamLeas(){
	var tArr = [];
	team.con.find(".team_peason").each(function(){
		var uid = $(this).find(":hidden[name=userid]").val();
		var uname = $(this).find(":hidden[name=username]").val();
		tArr.push({uid:uid, uname:uname});
	});
	return tArr;
}

//对外提供的调用方法 显示@团队用户列表
function ivk_showErtUsersList(){
	ert.share_user_selected.removeClass("modal");
    team.main_invoke_con.css("display", "none");
    compileTeamLeas(getTeamLeas());//组装团队成员
        
}
//对外提供的调用方法 隐藏@团队用户列表
function ivk_hideErtUsersList(){
	ert.share_user_selected.addClass("modal");
}

var ert = {};

function initErtUserElem(){
	ert.share_user_selected = $("#share_user_selected");
	ert.seleted_gobak = ert.share_user_selected.find(".seleted_gobak");
	ert.selected_list = ert.share_user_selected.find(".selected_list");
}

//初始化@团队用户
function initErtUserBtn(){
	//分配 goback按钮
	ert.seleted_gobak.click(function(){
		ert.share_user_selected.addClass("modal");
		team.main_invoke_con.css("display", "");
	});
}

//组装团队成员
function compileTeamLeas(tLeas){
	if(tLeas.length === 0){
		$(".suSelectedList").html('<div class="alert-info text-center " style="display:none;padding: 2em 0; margin: 3em 0">无数据</div>');
		return;
	}
	
	var ertusrtpl =  ['<a href="javascript:void(0)" class="list-group-item listview-item radio" >',
			      		    '<div>',
				 	           '<img class="msgheadimg" style="border-radius:5px" userid="$$shareuserid"',
				 	                getContentPath() + 'src="/image/defailt_person.png" width="40px">',
				 	        '</div>',
				 	 		'<div class="list-group-item-bd">',
				 	     		'<input type="hidden" name="userid" value="$$shareuserid02">',
				 	     		'<input type="hidden" name="username" value="$$shareusername">',
				 	     		'<h2 class="title " style="margin-left: 10px">$$shareusername02</h2>',
				 	 		'</div>',
				 		'</a>'];
	//遍历数组
	var html = '';
	$.each(tLeas, function(i, v){
		var subhtml = ertusrtpl.join("").replace("$$shareuserid", v.uid).replace("$$shareusername", v.uname);
		subhtml = subhtml.replace("$$shareuserid02", v.uid).replace("$$shareusername02", v.uname);
		html += subhtml;
	});
	//绑定事件
	ert.selected_list.html(html).find("img").each(function(){
		var userid = $(this).attr("userid");
		loadErtUserImg(userid, $(this));
		
	}).end().find("a").click(function(){
		
		ert.share_user_selected.addClass("modal");
		team.main_invoke_con.css("display", "");
		
		eval(team.callback_ertusers_selected + '('+ $(this).find("h2").html() +')');
		return false;
	});
}

function loadErtUserImg(userId, img){
	//显示单个图片头像
   	if(sessionStorage.getItem(userId + "_headImg")){
   		$(img).attr("src", sessionStorage.getItem(userId + "_headImg"));
   		return;
   	}
	if(userId){
   		//异步调用获取消息数据
       	$.ajax({
    		url: getContentPath() + '/wxuser/getImgHeader',
    		type: 'get',
    		data: {crmId: userId},
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
}

function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0, index+1);
	 return contextPath; 
}
