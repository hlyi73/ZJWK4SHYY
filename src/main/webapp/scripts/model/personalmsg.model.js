var PersonalMsg = function(_aoOption){
	// 配置（默认是从外面传进来）
	_aoOption || (_aoOption = {}) ;
	// 初始化函数
	this._init(_aoOption);
}

// 私有方法
PersonalMsg.prototype._init = function(_aoOptions) {
	var _oSelf = this;
	_oSelf._initData(_aoOptions);
	_oSelf._initBtnEvent(_aoOptions);
}

// 私有方法 初始化数据列表
PersonalMsg.prototype._initData = function(_aoOptions) {
	var _oSelf = this;
	//查询留言和私信列表
	$.ajax({
		url: _oSelf.getContentPath() + "/personalmsg/perliumsglist",
		data:{bid: _aoOptions.bid, bcpartyid: _aoOptions.bcpartyid, pagecounts:_aoOptions.pagecounts, currpages:_aoOptions.currpages},
	 	success: function(data){
	 		var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			$(".personalmsgcon .content").html('<div class="nomsgdata" style="margin-top:2px;font-size:14px;color:#999;text-align:center;">暂时还没有人给您留言哦！</div>');
	 			return;
	 		}
	 		$(darr).each(function(){
	 			this.createTime = dateFormat(new Date(this.createTime.time), "yyyy-MM-dd hh:mm");
	 			if(_aoOptions.uid === _aoOptions.bcpartyid){
	 				$(".personalmsgcon .content").append(template("singlePerMsgTemp01", this));
	 			}else{
	 				$(".personalmsgcon .content").append(template("singlePerMsgTemp02", this));
	 			}
	 		});
	 		_oSelf._initBtnEventSgl(_aoOptions);
	 		
	 		//回复的查询
	 		$("."+_aoOptions.con).find(".sglMsg .d3").each(function(){
	 			var _obj = $(this);
	 			var mid = $(this).attr("mid");
	 			var userid = $(this).attr("userid");
	 			$.ajax({
	 				url: _oSelf.getContentPath() + "/personalmsg/replymsglist",
	 				data:{relaid: mid, userid: userid},
	 			 	success: function(data){
	 			 		data = JSON.parse(data);
	 			 		if(data && data.length >0){
	 			 			$(data).each(function(){
	 			 				_obj.append(template("singlePerMsgReplyTemp", this));
	 			 			});
	 			 		}
	 			 		//div长度判断
	 			 		if(_obj.find("div").size() == 0){
	 			 			_obj.remove();
	 			 		}
	 	    	    }
	 			});
	 		});
	 		//单个消息 删除 和 答复 按钮
	 		$("."+_aoOptions.con).find(".sglMsg").each(function(){
	 			var _obj = $(this);
	 			//相等就是自己 自己恢复和删除   , 不相等就不是自己 比人没有回复和删除功能
	 			if(_aoOptions.uid !== _aoOptions.bcpartyid){
	 				_obj.find(".d2").remove();
	 			}
	 		});
	    }
	});
}

// 私有方法 初始化按钮事件
PersonalMsg.prototype._initBtnEvent = function(_aoOptions) {
	var _oSelf = this;
	//按钮权限控制
	if(_aoOptions.uid === _aoOptions.bcpartyid){
		$("."+_aoOptions.con).find(".ptitle .t2").remove();
	}
	//私信
	$("."+_aoOptions.con).find(".sendPersonalBtn").click(function(){
		$("#sendcon").remove();
		$(".ptitle").after($('<div>').html($(".sendcontpl").html()).attr("id","sendcon").addClass("sendcontpl pmt15"));
		//隐藏留言与私信
		$(".liuyanandsixin").addClass("none");
		$("#sendcon").find("textarea[name=sendcontent]").attr("placeholder", "请输入私信内容");
		$("#sendcon").find(".savesend").click(function(){
			var v = $.trim($("textarea[name=sendcontent]").val());
			if(!v){
				$(".errMsgBox").css("display","").html("请输入发送内容");
	   	    	$(".errMsgBox").delay(2000).fadeOut();
	   	    	return;
			}
			$.ajax({
				url: _oSelf.getContentPath() + "/personalmsg/savepersonalmsg",
				data:{content: v, type:'System_Personal_Msg', bcpartyid: _aoOptions.bcpartyid, bid:_aoOptions.bid},
			 	success: function(data){
			 		if(data == "fail"){
			 			$(".errMsgBox").css("display","").html("发送失败");
			   	    	$(".errMsgBox").delay(2000).fadeOut();
			 			//window.location.reload();
			 		}else{
			 			$(".successMsgBox").css("display","").html("发送成功");
			   	    	$(".successMsgBox").delay(2000).fadeOut();
			 			$("#sendcon").remove();
			 			$(".liuyanandsixin").removeClass("none");
			 			data = JSON.parse(data);
			 			data.createTime = dateFormat(new Date(data.createTime.time), "yyyy-MM-dd hh:mm");
			 			if(_aoOptions.uid === _aoOptions.bcpartyid){
			 				$(".personalmsgcon .content").prepend(template("singlePerMsgTemp01", data));
			 			}else{
			 				$(".personalmsgcon .content").prepend(template("singlePerMsgTemp02", data));
			 			}		 			
			 		}
	    	    }
			});
		}).end().find(".cannelsend").click(function(){
			$("#sendcon").remove();
			$(".liuyanandsixin").removeClass("none");
		});
	});
	//留言
	$("."+_aoOptions.con).find(".sendLiuMsgBtn").click(function(){
		$("#sendcon").remove();
		$(".ptitle").after($('<div>').html($(".sendcontpl").html()).attr("id","sendcon").addClass("sendcontpl pmt15"));
		//隐藏留言与私信
		$(".liuyanandsixin").addClass("none");
		$("."+_aoOptions.con).find(".nomsgdata").addClass("none");
		$("#sendcon").find("textarea[name=sendcontent]").attr("placeholder", "请输入留言内容");
		$("#sendcon").find(".savesend").click(function(){
			var v = $.trim($("textarea[name=sendcontent]").val());
			if(!v){
				$(".errMsgBox").css("display","").html("请输入发送内容");
	   	    	$(".errMsgBox").delay(2000).fadeOut();
	   	    	return;
			}
			$.ajax({
				url: _oSelf.getContentPath() + "/personalmsg/savepersonalmsg",
				data:{content: v, type:'System_Liu_Msg', bcpartyid: _aoOptions.bcpartyid, bid:_aoOptions.bid},
			 	success: function(data){
			 		if(data == "fail"){
			 			$(".errMsgBox").css("display","").html("发送失败");
			   	    	$(".errMsgBox").delay(2000).fadeOut();
			 			//window.location.reload();
			 		}else{
			 			$(".successMsgBox").css("display","").html("发送成功");
			   	    	$(".successMsgBox").delay(2000).fadeOut();
			 			$("#sendcon").remove();
			 			$(".liuyanandsixin").removeClass("none");
			 			data = JSON.parse(data);
			 			data.createTime = dateFormat(new Date(data.createTime.time), "yyyy-MM-dd hh:mm");
			 			if(_aoOptions.uid === _aoOptions.bcpartyid){
			 				$(".personalmsgcon .content").prepend(template("singlePerMsgTemp01", data));
			 			}else{
			 				$(".personalmsgcon .content").prepend(template("singlePerMsgTemp02", data));
			 			}		 			
			 		}
	    	    }
			});
		}).end().find(".cannelsend").click(function(){
			$("#sendcon").remove();
			$(".liuyanandsixin").removeClass("none");
		});
	});
	//more
	$("."+_aoOptions.con).find(".permore").click(function(){
		window.location.href = _oSelf.getContentPath() + "/personalmsg/personalmsglist?bcpartyid=" + _aoOptions.bcpartyid;
	});
}

// 公有方法
PersonalMsg.prototype._initBtnEventSgl = function(_aoOptions) {
	var _oSelf = this;
	//答复新增
	$("."+_aoOptions.con).find(".sglMsg .reply").click(function(){
		var obj=$(this).parent();
		var relaid = $(this).parent().attr("mid");
		var tid = $(this).parent().attr("tid");
		var tname = $(this).parent().attr("tname");
		$(this).parent().after($('<div>').html($(".sendcontpl").html()).attr("id","sendcon02").addClass("sendcontpl pmt15"));
		//隐藏留言与私信
		$(".liuyanandsixin").addClass("none");
		$("#sendcon02").find(".savesend").click(function(){
			var v = $.trim($("textarea[name=sendcontent]").val());
			if(!v){
				$(".errMsgBox").css("display","").html("请输入发送内容");
	   	    	$(".errMsgBox").delay(2000).fadeOut();
	   	    	return;
			}
			$.ajax({
				url: _oSelf.getContentPath() + "/personalmsg/savepersonalmsg",
				data:{content: v, type:'System_LiuPer_Msg_Reply', bcpartyid: _aoOptions.bcpartyid, relaid:relaid, tid:tid, tname:tname},
			 	success: function(data){
			 		if(data == "fail"){
			 			
			 			$(".errMsgBox").css("display","").html("发送失败");
			   	    	$(".errMsgBox").delay(2000).fadeOut();
			 			
			 		}else{
			 			$(".successMsgBox").css("display","").html("发送成功");
			   	    	$(".successMsgBox").delay(2000).fadeOut();
			   	    	$("#sendcon02").remove();
			 			data = JSON.parse(data);
			 			if(!obj.next().hasClass("d3")){
			 				obj.after($('<div>').html(template("singlePerMsgReplyTemp", data)).attr("mid",_aoOptions.bid).addClass("d3"));
			 			}else{
			 			obj.next().prepend(template("singlePerMsgReplyTemp", data));
			 			}
	 			 	
	 			 	
			 		}
	    	    }
			});
		}).end().find(".cannelsend").click(function(){
			$("#sendcon02").remove();
			$(".liuyanandsixin").removeClass("none");
		});
	});
	var submit=function(){
		var relaid = $(this).parent().attr("mid");
		$.ajax({
			url: _oSelf.getContentPath() + "/personalmsg/delpersonalmsg",
			data:{relaid:relaid},
		 	success: function(data){
		 		if(data == "success"){
		 			$(".successMsgBox").css("display","").html("删除成功");
		   	    	$(".successMsgBox").delay(2000).fadeOut();
		 			$("#sendcon2").remove();
		 			window.location.reload();
		 		}else{
		 			$(".errMsgBox").css("display","").html("删除失败");
		   	    	$(".errMsgBox").delay(2000).fadeOut();
		 		}
    	    }
		});
	}
	//答复删除
	$("."+_aoOptions.con).find(".sglMsg .del").click(function(){
	jBox.confirm("确定删除吗?", "提示", submit, { id:'_confirm', showScrolling: false, buttons: { '取消': false, '确定': true } });
		
	});
}

//获得上下文内容
PersonalMsg.prototype.getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}

//var personalMsg = new PersonalMsg({ nHideTime: 200 });
//personalMsg.hide();