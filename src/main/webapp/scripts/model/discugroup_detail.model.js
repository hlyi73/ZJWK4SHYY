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
	_oSelf._initBtnAuth(_aoOptions);
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
	_oSelf._initNoticeData(_aoOptions); //公告数据
	_oSelf._initDgAdminUserData(_aoOptions); //管理员数据
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
		
	}).end().find(".talkbtn").click(function(){//发起话题
		window.location.href = _oSelf.getContentPath() + "/discuGroup/towntalk?dgid=" + dgid;
		
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
		if($(this).hasClass("user")){//用户
			con.find(".user_list").removeClass("none");
			con.find(".topic_list").addClass("none");
			con.find(".essence_list").addClass("none");
			con.find(".my_topic_list").addClass("none");
			
		}else if($(this).hasClass("topic")){//话题
			con.find(".user_list").addClass("none");
			con.find(".topic_list").removeClass("none");
			con.find(".essence_list").addClass("none");
			con.find(".my_topic_list").addClass("none");
			_oSelf._initTopicData(_aoOptions);
			
		}else if($(this).hasClass("essence")){//精华
			con.find(".user_list").addClass("none");
			con.find(".topic_list").addClass("none");
			con.find(".essence_list").removeClass("none");
			con.find(".my_topic_list").addClass("none");
			_oSelf._initEssTopicData(_aoOptions);
			
		}else if($(this).hasClass("mytopic")){//我的群发
			con.find(".user_list").addClass("none");
			con.find(".topic_list").addClass("none");
			con.find(".essence_list").addClass("none");
			con.find(".my_topic_list").removeClass("none");
			
		}
	});
	
	//非讨论组用户申请加入该讨论组
	con.find(".joincon .joinbtn").click(function(){
		$(this).attr("disabled","disabled").val("请求已发送...");
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
	 			return;
	 		}
	 		$(darr).each(function(){
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
		//async: false,
		data:{dgid: dgid},
	 	success: function(data){
	 		var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			con.find(".topic_list .loadingdata").addClass("none");
	 			con.find(".topic_list .content").addClass("none");
	 			con.find(".topic_list .nodata").removeClass("none");
	 			return;
	 		}
	 		con.find(".topic_list .sub_content").empty();
	 		var cc = 0;
	 		$(darr).each(function(i){
	 			if(this.topic_status !== "deleted"){
	 				con.find(".topic_list .sub_content").append(template("singleDiscuTopicTemp", this));
	 			}else{
	 				cc ++;
	 			}
	 			if(i == darr.length - 1){
 					con.find(".topic_list .sub_content").append('<div style="margin-top:50px">&nbsp;</div>');
 				}
	 		});
	 		con.find(".tabbtns .topic").html('话题('+ (darr.length - cc) +')');
	 		con.find(".topic_list .loadingdata").addClass("none");
 			con.find(".topic_list .content").removeClass("none");
 			con.find(".topic_list .nodata").addClass("none");
 			
 			
 			//加载话题消息数据
 			$.extend(_aoOptions,{con: 'topic_list'});
 			_oSelf._initTopicMsgData(_aoOptions);
 			//单个原创文章的查看更多的事件
 			_oSelf._initMoreTextEvent(_aoOptions);
 			//话题回复消息按钮事件
	 		_oSelf._initTopicMsgBtn(_aoOptions);
	 		_oSelf._recomEssence(_aoOptions);//推荐加精
	 		_oSelf._delTopicById(_aoOptions);//deltopic
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
	 		con.find(".my_topic_list .sub_content").empty();
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
 			//单个原创文章的查看更多的事件
 			_oSelf._initMoreTextEvent(_aoOptions);
 			//话题回复消息按钮事件
	 		_oSelf._initTopicMsgBtn(); 
	 		_oSelf._delTopicById(_aoOptions);//deltopic
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
	 		con.find(".essence_list .sub_content").empty();
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
 			//单个原创文章的查看更多的事件
 			_oSelf._initMoreTextEvent(_aoOptions);
 			//话题回复消息按钮事件
	 		_oSelf._initTopicMsgBtn();
	 		_oSelf._delTopicById(_aoOptions);//deltopic
	    }
	});
}

//加载讨论组公告列表
DiscuGroup_Detail.prototype._initNoticeData = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	var dgid = con.find(":hidden[name=dgid]").val();
	$.ajax({
	    type: 'post',
	     url: _oSelf.getContentPath() + '/discuGroup/groupnoticelist',
	      data: {dgid: dgid},
	      dataType: 'text',
	      success: function(data){
	    	  _oSelf.initMarquee();//开启滚动效果
	    	  if(!data){
	    		  con.find(".discugroupnoticelist_data ul").append('<div style="line-height:20px;width:100%;">暂无</div>');
	    		  return;
	    	  }
	    	  var d = JSON.parse(data);
	    	  if(!d){
	    		  con.find(".discugroupnoticelist_data ul").append('<div style="line-height:20px;width:100%;">暂无</div>');
	    		  return;
	    	  }
	    	  if($(d).size() == 0){
	    		  con.find(".discugroupnoticelist_data ul").append('<div style="line-height:20px;width:100%;">暂无</div>');
	    		  return;
	    	  }
	    	  $(".discugroupnoticelist_data ul").empty();
	    	  $(d).each(function(index){
	    		   con.find(".discugroupnoticelist_data ul").append('<li><p style="width:80%;line-height: 40px">'+ this.content +'</p></li>');
	    	  });
	    	  
	    	  if($(d).size() > 1){
	    		  $(".more_notice").removeClass("none");
	    	  }
	    	  
	    	  _oSelf.initMarquee();//开启滚动效果
	      }
	});
	
	$(".more_notice").click(function(){
		if($(".more_notice_img").attr("src").indexOf("bottom.png") == -1){
			$(".more_notice_img").attr("src",_oSelf.getContentPath() + '/image/bottom.png');
		}else{
			$(".more_notice_img").attr("src", _oSelf.getContentPath() + '/image/top.png');
		}
		if($(".notice_list").hasClass("none")){
			$(".notice_list").removeClass("none");
		}else{
			$(".notice_list").addClass("none");
		}
	});
}

//话题回复消息按钮事件
DiscuGroup_Detail.prototype._initTopicMsgBtn = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail"), dgid = con.find(":hidden[name=dgid]").val(), dgname = con.find(":hidden[name=dgname]").val(),
	    curr_user_id = con.find(":hidden[name=curr_user_id]").val(),
	    curr_user_name = con.find(":hidden[name=curr_user_name]").val();
	//公共话题 
	con.find(".topic_list .sub_content .reply_con").each(function(){
		var topicid = $(this).attr("topicid");
		var robj = $(this);
		$(this).find(".sendMsg").unbind("click").click(function(){
			con.find(".msg_con").removeClass("none");
			//con.find(".menu_shade").css("display","");
			con.find(".msg_con textarea[name=inputMsg]").val('').attr("placeholder","我要评论");
			//发送按钮
			con.find(".msg_con .sendBtn").unbind("click").click(function(){
				var btnobj = $(this);
				var v = con.find(".msg_con textarea[name=inputMsg]").val();
				if(!v){
					//alert('内容不能为空!');
					con.find(".myDefMsgBox").addClass("warning_tip").removeClass("error_tip success_tip none").html("内容不能为空");
			   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
					return;
				}
				var d = {
					send_user_id: curr_user_id,
					send_user_name: curr_user_name,
					target_user_id: '',
					target_user_name: '',
					content: v,
					topic_id: topicid
				};
				btnobj.attr("disabled","disabled");
				robj.find(".reply_content").append(template("singleTopicMsgTemp", d));
				//发送
				$.ajax({
					type: 'post',
					url: _oSelf.getContentPath() + "/discuGroup/savegrouptopicmsg",
					data:{dgid: dgid, dgname:dgname, topicid: topicid, targetuid: '', content: v},
				 	success: function(data){
				 		btnobj.removeAttr("disabled");
				 		con.find(".msg_con").addClass("none");
				 		if(data === 'success'){
				 			//alert('发送成功');
				 			con.find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("发送成功").css({"display":"", "width":"150px", "height":"100px"});
					   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
					   	    con.find(".msg_con").addClass("none");
				 			//window.location.replace(window.location.href) ;
					   	    _oSelf._initSingleMsgClickEvent(_aoOptions);
				 		}else{
				 			//alert('发送失败');
				 			con.find(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("发送失败").css("display","");
					   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
				 		}
				    }
				});
			});
		});
	});
	//精华
	con.find(".essence_list .sub_content .reply_con").each(function(){
		var topicid = $(this).attr("topicid");
		var robj = $(this);
		$(this).find(".sendMsg").unbind("click").click(function(){
			con.find(".msg_con").removeClass("none");
			//con.find(".menu_shade").css("display","");
			con.find(".msg_con textarea[name=inputMsg]").val('').attr("placeholder","我要评论");
			//发送按钮
			con.find(".msg_con .sendBtn").unbind("click").click(function(){
				var btnobj = $(this);
				var v = con.find(".msg_con textarea[name=inputMsg]").val();
				if(!v){
					//alert('内容不能为空!');
					con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip none").html("内容不能为空").css({"display":"", "width":"150px", "height":"100px"});
			   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
					return;
				}
				var d = {
					send_user_id: curr_user_id,
					send_user_name: curr_user_name,
					target_user_id: '',
					target_user_name: '',
					content: v,
					topic_id: topicid
				};
				btnobj.attr("disabled","disabled");
				robj.find(".reply_content").append(template("singleTopicMsgTemp", d));
				$.ajax({
					type: 'post',
					url: _oSelf.getContentPath() + "/discuGroup/savegrouptopicmsg",
					data:{dgid: dgid, dgname:dgname, topicid: topicid, targetuid: '', content: v},
				 	success: function(data){
				 		btnobj.removeAttr("disabled");
				 		con.find(".msg_con").addClass("none");
				 		if(data === 'success'){
				 			//alert('发送成功');
				 			con.find(".myDefMsgBox").addClass("success_tip").removeClass("warning_tip error_tip none").html("发送成功").css("display","");
					   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
				 			//window.location.replace(window.location.href) ;
					   	    _oSelf._initSingleMsgClickEvent(_aoOptions);
				 		}else{
				 			//alert('发送失败');
				 			con.find(".myDefMsgBox").addClass("error_tip").removeClass("warning_tip success_tip none").html("发送失败").css("display","");
					   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
				 		}
				    }
				});
			});
		});
	});
	//我的群发
	con.find(".my_topic_list .sub_content .reply_con").each(function(){
		var topicid = $(this).attr("topicid");
		$(this).find(".sendMsg").unbind("click").click(function(){
			con.find(".msg_con").removeClass("none");
			//$(".menu_shade").css("display","");
			con.find(".msg_con textarea[name=inputMsg]").val('').attr("placeholder","我要评论");
			//发送按钮
			con.find(".msg_con .sendBtn").unbind("click").click(function(){
				var btnobj = $(this);
				var v = con.find(".msg_con textarea[name=inputMsg]").val();
				if(!v){
					//alert('内容不能为空!');
					con.find(".myDefMsgBox").addClass("warning_tip").removeClass("error_tip success_tip none").html("内容不能为空").css("display","");
			   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
					return;
				}
				btnobj.attr("disabled","disabled");
				$.ajax({
					type: 'post',
					url: _oSelf.getContentPath() + "/discuGroup/savegrouptopicmsg",
					data:{dgid: dgid, dgname:dgname, topicid: topicid, targetuid: '', content: v},
				 	success: function(data){
				 		btnobj.removeAttr("disabled");
				 		con.find(".msg_con").addClass("none");
				 		if(data === 'success'){
				 			//alert('发送成功');
				 			con.find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("发送成功").css({"display":"", "width":"150px", "height":"100px"});
					   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
				 			//window.location.replace(window.location.href) ;
				 		}else{
				 			//alert('发送失败');
				 			con.find(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("发送失败").css("display","");
					   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
				 		}
				    }
				});
			});
		});
	});
}

//加载话题数据列表
DiscuGroup_Detail.prototype._initTopicMsgData = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail"); 
	var curr_user_id = con.find(":hidden[name=curr_user_id]").val();
	var curr_user_name = con.find(":hidden[name=curr_user_name]").val();
	var dgid = con.find(":hidden[name=dgid]").val();
	con.find("."+ _aoOptions.con).find(".reply_con").each(function(){
		var topicid = $(this).attr("topicid"), c_ct = $(this).find(".reply_content");
		$.ajax({
			url: _oSelf.getContentPath() + "/discuGroup/grouptopicmsglist",
			data:{dgid: dgid, topicid: topicid},
		 	success: function(data){
		 		var darr = JSON.parse(data);
		 		if(!darr || darr.length == 0){
		 			return;
		 		}
		 		if(darr.length > 3){
		 			c_ct.siblings(".viewall").removeClass("none");
		 		}
		 		$(darr).each(function(i){
		 			if(i < 3){
		 				c_ct.append(template("singleTopicMsgTemp", this));
		 			}else{
		 				c_ct.append(template("singleHideTopicMsgTemp", this));
		 			}
		 		});
		 		//初始化单条消息的点击事件
		 		_oSelf._initSingleMsgClickEvent(_aoOptions);
		 		//初始化查看全部点击事件
		 		_oSelf._initViewAllClickEvent(_aoOptions);
		 		
		    }
		});
	});
}

//初始化查看全部点击事件
DiscuGroup_Detail.prototype._initViewAllClickEvent = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	con.find(".viewall").click(function(){
		$(this).siblings(".reply_content").find(".singleMsg").removeClass("none"); 
		$(this).addClass("none");
		$(this).siblings(".upall").removeClass("none");
	});
	//收起
	con.find(".upall").click(function(){
		$(this).siblings(".reply_content").find(".singleMsg").each(function(i){
			if(i > 2){
				$(this).addClass("none");
			}
		});
		$(this).addClass("none");
		$(this).siblings(".viewall").removeClass("none");
	});
}

//初始化单条消息的点击事件
DiscuGroup_Detail.prototype._initSingleMsgClickEvent = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	var curr_user_id = con.find(":hidden[name=curr_user_id]").val();
	var curr_user_name = con.find(":hidden[name=curr_user_name]").val();
	var dgid = con.find(":hidden[name=dgid]").val();
	var dgname = con.find(":hidden[name=dgname]").val();
	//评论回复按钮 内容下的单个消息的回复按钮
	con.find(".singleMsg").unbind("click").click(function(){
		var robj = $(this).parent();
		var topicid = $(this).attr("topicid");
		var targetuid = $(this).attr("send_user_id");
		var targetuname = $(this).attr("send_user_name");
		con.find(".msg_con").removeClass("none");
		con.find(".msg_con textarea[name=inputMsg]").val('').attr("placeholder","回复: "+targetuname);
		//con.find(".menu_shade").css("display","");
		//发送按钮
		con.find(".msg_con .sendBtn").unbind("click").click(function(){
			var btnobj = $(this); 
			btnobj.attr("disabled","disabled");
			var v = con.find(".msg_con textarea[name=inputMsg]").val();
			if(!v){
				//alert('内容不能为空!');
				con.find(".myDefMsgBox").addClass("warning_tip").removeClass("error_tip success_tip none").html("内容不能为空");
		   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
				return;
			}
			var d = {
				send_user_id: curr_user_id,
				send_user_name: curr_user_name,
				target_user_id: targetuid,
				target_user_name: targetuname,
				content: v,
				topic_id: topicid
			};
			robj.prepend(template("singleTopicMsgTemp", d));
			$.ajax({
				type: 'post',
				url: _oSelf.getContentPath() + "/discuGroup/savegrouptopicmsg",
				data:{dgid: dgid, dgname:dgname, topicid: topicid, targetuid: targetuid,targetuname: targetuname, content: v},
			 	success: function(data){
			 		btnobj.removeAttr("disabled");
			 		if(data === 'success'){
			 			//alert('发送成功');
				   	    con.find(".myDefMsgBox").addClass("success_tip").removeClass("error_tip warning_tip none").html("发送成功").css({"display":"", "width":"150px", "height":"100px"});;
				   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
				   	    con.find(".msg_con").addClass("none");
			 			//window.location.href = window.location.href ;
				   	    con.find(".msg_con textarea[name=inputMsg]").val('');
				   	    _oSelf._initSingleMsgClickEvent();
			 		}else{
			 			//alert('发送失败');
			 			con.find(".myDefMsgBox").addClass("error_tip").removeClass("success_tip warning_tip none").html("发送失败");
				   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			 		}
			    }
			});
		});
	});
}

//初始化讨论组 原创话题中 查看更多 事件
DiscuGroup_Detail.prototype._initMoreTextEvent = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	con.find(".showall").click(function(){//查看全部
		var sc = $(this).parent();
		sc.find(".contentarea_sub").addClass("none");
		sc.find(".contentarea").removeClass("none");
		sc.find(".showall").addClass("none");
		sc.find(".closeall").removeClass("none");
	}).end().find(".closeall").click(function(){//收起
		var sc = $(this).parent();
		sc.find(".contentarea_sub").removeClass("none");
		sc.find(".contentarea").addClass("none");
		sc.find(".showall").removeClass("none");
		sc.find(".closeall").addClass("none");
	});
}

//加载我的话题数据列表
DiscuGroup_Detail.prototype._initMyTopicMsgData = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	var dgid = con.find(":hidden[name=dgid]").val();
	$.ajax({
		url: _oSelf.getContentPath() + "/discuGroup/mygrouptopicmsglist",
		data:{},
		success: function(data){   
		}
	});
}

//加载讨论组管理的数据
DiscuGroup_Detail.prototype._initDgAdminUserData = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	var dgid = con.find(":hidden[name=dgid]").val();
	$.ajax({
		url: _oSelf.getContentPath() + "/discuGroup/groupadminuserlist",
		data:{dgid: dgid},
		success: function(data){
			var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			_oSelf._initDgAdminClickEvent(_aoOptions);
	 			return;
	 		}
	 		$(darr).each(function(i){
	 			con.find(".dg_admin_con").append('<span style="margin-left: 10px;color: #64CAF7;font-weight: 500;" uid="'+ this.user_id +'">'+this.user_name+'</span>');
	 		});
	 		_oSelf._initDgAdminClickEvent(_aoOptions);
		}
	});
}

//加载讨论组管理的数据
DiscuGroup_Detail.prototype._initDgAdminClickEvent = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	con.find(".dg_admin_con span").click(function(){
		var uid = $(this).attr("uid");
		window.location.href = _oSelf.getContentPath() + '/out/user/card?partyId='+ uid +'&flag=RM';
	});
}

//初始化按钮quanxia
DiscuGroup_Detail.prototype._initBtnAuth = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_detail");
	//获得当前登陆的用户
	var creator = con.find(":hidden[name=creator]").val();
	var curr_user_id = con.find(":hidden[name=curr_user_id]").val();
	var cu_isdgowner = con.find(":hidden[name=cu_isdgowner]").val();
	var cu_isindg = con.find(":hidden[name=cu_isindg]").val();
	var cu_isdgadmin = con.find(":hidden[name=cu_isdgadmin]").val();
	if(cu_isdgowner || cu_isdgadmin){//是讨论组创建者 或者是管理者
		con.find(".managebtn").removeClass("none");
	}
	//成员 不使用else if 
	if(cu_isindg){//是讨论组成员
		con.find(".massbtn").removeClass("none");//群发
		con.find(".invitebtn").removeClass("none");//邀请好友
		con.find(".sharebtn").removeClass("none");//分享
		con.find(".talkbtn").removeClass("none");//发起话题
		//con.find(".settingbtn").removeClass("none");//设置
		if(!cu_isdgowner){
			con.find(".exitbtn").removeClass("none");//退出
		}
	}else{//非成员 加入
		$("._menu").addClass("none");
		con.find(".joincon_mask").removeClass("none");//申请加入
		con.find(".joincon").removeClass("none");//申请加入
	}
}

//推荐加精事件
DiscuGroup_Detail.prototype._recomEssence = function(_aoOptions){
	var _oSelf = this;
	var con = $("#discugroup_detail");
	var dgid = con.find(":hidden[name=dgid]").val();
	var dgname = con.find(":hidden[name=dgname]").val();
	con.find(".topic_list ._recommess").click(function(){
		var tobj = $(this);
		var topicid = $(this).attr("topicid");
		var topictype = $(this).attr("topictype");
		var relaid = $(this).attr("relaid");
		$.ajax({
		      type: 'post',
		      url: _oSelf.getContentPath() + '/discuGroup/recomess',
		      data: {topicid:topicid, topictype:topictype, dgid:dgid, dgname:dgname, relaid:relaid},
		      dataType: 'text',
		      success: function(data){
		    	  tobj.remove();
		    	  if(data === "success"){
		    		  $(".myDefMsgBox").addClass("success_tip").removeClass("error_tip none").html("操作成功").css({"display":"", "width":"150px", "height":"100px"});;
			   	      $(".myDefMsgBox").delay(2000).fadeOut();  
		    	  }else{
		    		  $(".myDefMsgBox").addClass("error_tip").removeClass("success_tip none").html("操作失败");
			   	      $(".myDefMsgBox").delay(2000).fadeOut();
		    	  }
		      }
		});
	});
}

//初始化滚动
DiscuGroup_Detail.prototype.initMarquee = function(_aoOptions){
	var scrtime;
	$("#noticelist").hover(function(){
		clearInterval(scrtime);
	
	},function(){
		scrtime = setInterval(function(){
			var $ul = $("#noticelist ul");
			$ul.find("li:last").prependTo($ul)
		}, 4000);
	
	}).trigger("mouseleave");
}

//根据id删除话题
DiscuGroup_Detail.prototype._delTopicById = function(_aoOptions){
	var _oSelf = this;
	var con = $("#discugroup_detail");
	con.find(".delTopic").unbind("click");//先移除点击事件，避免重复绑定
	con.find(".delTopic").click(function(){
		var topicId = $(this).attr("topicId");
		//删除 提示信息框
		var submit = function (v, h, f) {
	        if (v == true){
	        	$.ajax({
				      type: 'post',
				      url: _oSelf.getContentPath() + '/discuGroup/delTopic',
				      data: {topicid:topicId},
				      dataType: 'text',
				      success: function(data){
				    	  if(data === "success"){
				    		  $(".myDefMsgBox").addClass("success_tip").removeClass("error_tip none").html("操作成功").css({"display":"", "width":"150px", "height":"100px"});;
					   	      $(".myDefMsgBox").delay(2000).fadeOut();  
					   		 _oSelf._initTopicData(_aoOptions);
					   		 _oSelf._initMyTopicData(_aoOptions); 
					   		 _oSelf._initEssTopicData(_aoOptions);
				    	  }else{
				    		  $(".myDefMsgBox").addClass("error_tip").removeClass("success_tip none").html("操作失败");
					   	      $(".myDefMsgBox").delay(2000).fadeOut();
				    	  }
				      }
				});
	        }
	        return true;
	    };
	    //jbox
		jBox.confirm("您确定要删除此话题？", "提示", submit, { id:'hahaha', showScrolling: false, buttons: { '取消': false, '确定': true } });
	});
}

//获得上下文内容
DiscuGroup_Detail.prototype.getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}
