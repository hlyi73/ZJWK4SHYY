var DiscuGroup_Detail = function(_aoOption){
	// 配置（默认是从外面传进来）
	_aoOption || (_aoOption = {}) ;
	if(_aoOption.initFlag && _aoOption.initFlag === 'false') return;
	// 初始化函数
	this._init(_aoOption);
}

// 私有方法
DiscuGroup_Detail.prototype._init = function(_aoOptions) {
	var _oSelf = this;
	_oSelf._initData(_aoOptions);
	_oSelf._initBtnEvent(_aoOptions);
}

// 私有方法 初始化数据列表
DiscuGroup_Detail.prototype._initData = function(_aoOptions) {
	var _oSelf = this;
	_oSelf._initUserData(_aoOptions);
	_oSelf._initTopicData(_aoOptions);
	_oSelf._initMyTopicData(_aoOptions); 
	_oSelf._initEssTopicData(_aoOptions); //加精
}

// 私有方法 初始化按钮事件
DiscuGroup_Detail.prototype._initBtnEvent = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	var dgid = con.find(":hidden[name=dgid]").val();
	//群发信息
	con.find(".massbtn").click(function(){//群发
		window.location.href = _oSelf.getContentPath() + "/discuGroup/mass?dgid=" + dgid;
		
	}).end().find(".invitebtn").click(function(){//邀请好友
		window.location.href = _oSelf.getContentPath() + "/discuGroup/conlist?dgid=" + dgid;
		
	}).end().find(".sharebtn").click(function(){//分享
		share();
		
	}).end().find(".settingbtn").click(function(){//设置
		window.location.href = _oSelf.getContentPath() + "/discuGroup/manage?dgid=" + dgid;
		
	}).end().find(".managebtn").click(function(){//讨论组管理
		window.location.href = _oSelf.getContentPath() + "/discuGroup/manage?dgid=" + dgid;
		
	}).end().find(".exitbtn").click(function(){
		if(!confirm('确定退出吗?')){
			return;
		}
		$.ajax({
			url: _oSelf.getContentPath() + "/discuGroup/exit",
			data:{dgid: dgid},
		 	success: function(data){
		 		if(data == "success"){
		 			con.find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("退出成功");
			   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
		 			window.location.href = _oSelf.getContentPath() + "/discuGroup/list";
		 		}else{
		 			con.find(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("退出失败");
			   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
		 		}
		    }
		});
	});
	//tab页切换
	con.find(".tabbtns div").click(function(){
		$(this).siblings().removeClass("tabselected");
		$(this).addClass("tabselected");
		if($(this).hasClass("user")){
			con.find(".user_list").removeClass("none");
			con.find(".topic_list").addClass("none");
			con.find(".essence_list").addClass("none");
			con.find(".my_topic_list").addClass("none");
		}else if($(this).hasClass("topic")){
			con.find(".user_list").addClass("none");
			con.find(".topic_list").removeClass("none");
			con.find(".essence_list").addClass("none");
			con.find(".my_topic_list").addClass("none");
		}else if($(this).hasClass("essence")){
			con.find(".user_list").addClass("none");
			con.find(".topic_list").addClass("none");
			con.find(".essence_list").removeClass("none");
			con.find(".my_topic_list").addClass("none");
		}else if($(this).hasClass("mytopic")){
			con.find(".user_list").addClass("none");
			con.find(".topic_list").addClass("none");
			con.find(".essence_list").addClass("none");
			con.find(".my_topic_list").removeClass("none");
		}
	});
	
	//非讨论组用户申请加入该讨论组
	con.find(".joincon .joinbtn").click(function(){
		var con = $("#discugroup_detail");
		var dgid = con.find(":hidden[name=dgid]").val();
		$.ajax({
			url: _oSelf.getContentPath() + "/discuGroup/joindg",
			data:{dgid: dgid},
		 	success: function(data){
		 		if(data == "success"){
		 			window.location.href = _oSelf.getContentPath() + "/discuGroup/detail?rowId=" + dgid;
		 		}else{
		 			//alert("加入失败!");
		 			con.find(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("加入失败");
			   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
		 		}
		    }
		});
	});
}

//加载用户数据列表
DiscuGroup_Detail.prototype._initUserData = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	var dgid = con.find(":hidden[name=dgid]").val();
	$.ajax({
		url: _oSelf.getContentPath() + "/discuGroup/groupuserlist",
		data:{dgid: dgid},
	 	success: function(data){
	 		var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			//$(".ptitle .content").html('<div style="margin-top:2px;font-size:14px;color:#999;text-align:center;">暂时还没有人给您留言哦！</div>');
	 			return;
	 		}
	 		$(darr).each(function(){
	 			//this.createTime = dateFormat(new Date(this.createTime.time), "yyyy-MM-dd hh:mm");
	 			con.find(".user_list .content").append(template("singleDiscuUserTemp", this));
	 		});
	 		
	 		con.find(".tabbtns .user").html('成员('+ darr.length +')');
	 		//交换名片
	 		con.find(".changecardbtn").click(function(){
	 			//window.location.href = _oSelf.getContentPath() + "/dcCrm/modify";
	 			var uid = $(this).parent().attr("uid");
	 			var uname = $(this).parent().attr("uname");
	 			var curr_user_id = con.find(":hidden[name=curr_user_id]").val();
	 			var curr_user_name = con.find(":hidden[name=curr_user_name]").val();
	 			
	 			var obj = [];
	        	obj.push({name :'userId', value: curr_user_id});
	        	obj.push({name :'username', value: curr_user_name});
	        	obj.push({name :'targetUId', value: uid});
	        	obj.push({name :'targetUName', value: uname});
	        	obj.push({name :'msgType', value :'txt'});
	        	obj.push({name :'content', value :curr_user_name + '请求与您交换名片！'});
	        	obj.push({name :'relaModule', value :'System_ChangeCard'});
	        	obj.push({name :'relaId', value: curr_user_id});
	        	//发送名片交换申请
	        	$.ajax({
	    	  	      url: _oSelf.getContentPath() + '/dcCrm/changecard',
	    	  	      data: obj,
	    	  	      success: function(data){
	    	  	    	    if(data && data === "success"){
	    	  	    	    	//alert("申请发送成功！");
	    	  	    	    	con.find(".myDefMsgBox")
	    	  	    	    	.addClass("success_tip")
	    	  	    	    	.removeClass("error_tip warning_tip none").css("display","")
	    	  	    	    	.html('<p style="color: #545353;padding-left: 8px;text-align: left;line-height: 20px;">亲爱的主人:</p><p style="margin-top: 10px;color: #6F6D6D;">小薇已经为您向 【'+uname+'】 发送了加好友的信息，请您等候佳音噢。</p>')
	    	  	    	    	.css({"padding-left":"5px","padding-right":"5px","height":"180px"});
	    	  	    	    	
	    				   	    con.find(".myDefMsgBox").delay(2000).fadeOut(); 
	    	  	    	    }
	    	  	      }
	    	  	});
	 		});
	    }
	});
}

//加载话题数据列表
DiscuGroup_Detail.prototype._initTopicData = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	var dgid = con.find(":hidden[name=dgid]").val();
	$.ajax({
		url: _oSelf.getContentPath() + "/discuGroup/grouptopiclist",
		async: false,
		data:{dgid: dgid},
	 	success: function(data){
	 		var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			//$(".ptitle .content").html('<div style="margin-top:2px;font-size:14px;color:#999;text-align:center;">暂时还没有人给您留言哦！</div>');
	 			con.find(".topic_list .loadingdata").addClass("none");
	 			con.find(".topic_list .content").addClass("none");
	 			con.find(".topic_list .nodata").removeClass("none");
	 			return;
	 		}
	 		var c = 0;
	 		$(darr).each(function(i){
	 			if(this.topic_status !== "deleted"){
	 				//c ++;
	 				con.find(".topic_list .sub_content").append(template("singleDiscuTopicTemp", this));
	 			}
	 			if(i == darr.length - 1){
 					con.find(".topic_list .sub_content").append('<div style="margin-top:50px">&nbsp;</div>');
 				}
	 		});
	 		con.find(".tabbtns .topic").html('话题('+ darr.length +')');
	 		con.find(".topic_list .loadingdata").addClass("none");
 			con.find(".topic_list .content").removeClass("none");
 			con.find(".topic_list .nodata").addClass("none");
 			
 			
 			//加载话题消息数据
 			$.extend(_aoOptions,{con: 'topic_list'});
 			_oSelf._initTopicMsgData(_aoOptions);
 			//话题回复消息按钮事件
	 		_oSelf._initTopicMsgBtn(_aoOptions);
	 		_oSelf._recomEssence(_aoOptions);//推荐加精
	    }
	});
}

//加载我的话题数据列表
DiscuGroup_Detail.prototype._initMyTopicData = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	var dgid = con.find(":hidden[name=dgid]").val();
	$.ajax({
		url: _oSelf.getContentPath() + "/discuGroup/mygrouptopiclist",
		data:{dgid: dgid},
	 	success: function(data){
	 		var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			con.find(".my_topic_list .loadingdata").addClass("none");
	 			con.find(".my_topic_list .content").addClass("none");
	 			con.find(".my_topic_list .nodata").removeClass("none");
	 			return;
	 		}
	 		$(darr).each(function(i){
	 			if(this.topic_status !== "deleted"){
	 				con.find(".my_topic_list .sub_content").append(template("singleMyDiscuTopicTemp", this));
	 			}
	 			if(i == darr.length - 1){
 					con.find(".my_topic_list .sub_content").append('<div style="margin-top:50px">&nbsp;</div>');
 				}
	 		});
	 		con.find(".tabbtns .mytopic").html('我的群发('+ darr.length +')');
	 		con.find(".my_topic_list .loadingdata").addClass("none");
 			con.find(".my_topic_list .content").removeClass("none");
 			con.find(".my_topic_list .nodata").addClass("none");
 			
 			//加载我的话题数据列表
 			_oSelf._initMyTopicMsgData(_aoOptions);
 			//话题回复消息按钮事件
	 		_oSelf._initTopicMsgBtn(); 
	    }
	});
}

//加载讨论组加精话题列表
DiscuGroup_Detail.prototype._initEssTopicData = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	var dgid = con.find(":hidden[name=dgid]").val();
	$.ajax({
		url: _oSelf.getContentPath() + "/discuGroup/groupesstopiclist",
		data:{dgid: dgid},
	 	success: function(data){
	 		var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			con.find(".essence_list .loadingdata").addClass("none");
	 			con.find(".essence_list .content").addClass("none");
	 			con.find(".essence_list .nodata").removeClass("none");
	 			return;
	 		}
	 		$(darr).each(function(i){
	 			if(this.topic_status !== "deleted"){
	 				con.find(".essence_list .sub_content").append(template("singleEssDiscuTopicTemp", this));
	 			}
	 			if(i == darr.length - 1){
 					con.find(".essence_list .sub_content").append('<div style="margin-top:50px">&nbsp;</div>');
 				}
	 		});
	 		con.find(".tabbtns .essence").html('精华('+ darr.length +')');
	 		con.find(".essence_list .loadingdata").addClass("none");
 			con.find(".essence_list .content").removeClass("none");
 			con.find(".essence_list .nodata").addClass("none");
 			
 			$.extend(_aoOptions,{con: 'essence_list'});
 			//加载我的话题数据列表
 			_oSelf._initTopicMsgData(_aoOptions);
 			//话题回复消息按钮事件
	 		_oSelf._initTopicMsgBtn();
	    }
	});
}

//获得上下文内容
DiscuGroup_Detail.prototype.getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}