var DiscuGroup_ConList = function(_aoOption){
	// 配置（默认是从外面传进来）
	_aoOption || (_aoOption = {}) ;
	if(_aoOption.initFlag && _aoOption.initFlag === 'false') return;
	// 初始化函数
	this._init(_aoOption);
}

// 私有方法
DiscuGroup_ConList.prototype._init = function(_aoOptions) {
	var _oSelf = this;
	_oSelf._initData(_aoOptions);
	_oSelf._initBtnEvent(_aoOptions);
}

// 私有方法 初始化数据列表
DiscuGroup_ConList.prototype._initData = function(_aoOptions) {
	var _oSelf = this;
	
}

// 私有方法 初始化按钮事件
DiscuGroup_ConList.prototype._initBtnEvent = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_conlist");
	con.find("input[name=search]").keyup(function(){
		_oSelf.searchContact();
		
	}).end().find(".cannelbtn").click(function(){//取消
		
	}).end().find(".okbtn").click(function(){//ok
		
	});
	
	$("#discugroup_conlist #slider").sliderNav();
	
	//选择框
	con.find(".contact_list .check-radio").click(function(){
		var nums = $(".selected_contact_nums").html();
		if($(this).hasClass("rsel")){
			$(this).removeClass("rsel");
			nums = parseInt(nums) - 1;
		}else{
			$(this).addClass("rsel");
			nums = parseInt(nums) + 1;
		}
		$(".selected_contact_nums").html(nums);
	}).end().find(".cannelbtn").click(function(){//重选
		con.find(".contact_list .check-radio").removeClass("rsel");
		$(".selected_contact_nums").html("0");
	}).end().find(".okbtn").click(function(){//确定
		var dgid = con.find(":hidden[name=dgid]").val();
		var cids = '';
		con.find(".contact_list").each(function(){
			var obj = $(this).find(".rsel");
			if(obj.length > 0){
				var cid = $(this).attr("contactid");
				if(cid){
					cids += cid + ',';
				}
			}
		});
		if(!cids){
			$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请选择联系人!"); 
  		    $(".myMsgBox").delay(1000).fadeOut();
			return;
		}
		$(".g-mask").removeClass("none");
		$(".send_msg_loading").removeClass("none");
		$(this).attr("disabled","true");
		//异步调用发送给后台
		$.ajax({
			url: _oSelf.getContentPath() + "/discuGroup/saveconlist",
			data: {cids: cids, dgid: dgid},
		 	success: function(data){
		 		if(data === "success"){
		 			$(".send_msg_loading").addClass("none");
		 			$(".myMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("邀请发送成功!");
		  		    $(".myMsgBox").delay(1000).fadeOut();
		 			window.location.replace(_oSelf.getContentPath() + '/discuGroup/detail?rowId='+dgid);
		 		}else {
		 			$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("邀请失败!");
		  		    $(".myMsgBox").delay(1000).fadeOut();
		  		    $(".g-mask").addClass("none");
		  		    $(".send_msg_loading").addClass("none");
		 		}
		    }
		});
		
	});
}

// 讨论组列表点击 事件
DiscuGroup_ConList.prototype.searchContact = function(_aoOptions) {
	var _oSelf = this;
	var searchContent = $("input[name=search]").val();
	if(searchContent){
		var isSearch = false;
		$(".firstname_list").css("display","none");
		$(".contact_list").css('display',"none");
		$(".contact_list").each(function(){
			var name = $(this).attr("conname");
			var mobile = $(this).attr("conmobile");
			if(name.indexOf(searchContent) != -1 || mobile.indexOf(searchContent) != -1){
				isSearch = true;
				$(this).css("display","");
			}
		});
		if(!isSearch){
			$(".nodata").removeClass("none")
		}else{
			$(".nodata").addClass("none");
		}
	}else{
		$(".firstname_list").css("display","");
		$(".contact_list").css('display',"");
		$(".nodata").addClass("none");
	}
}

//获得上下文内容
DiscuGroup_ConList.prototype.getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}