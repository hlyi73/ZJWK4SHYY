var DiscuGroup_Add = function(_aoOption){
	// 配置（默认是从外面传进来）
	_aoOption || (_aoOption = {}) ;
	if(_aoOption.initFlag && _aoOption.initFlag === 'false') return;
	// 初始化函数
	this._init(_aoOption);
}

// 私有方法
DiscuGroup_Add.prototype._init = function(_aoOptions) {
	var _oSelf = this;
	_oSelf._initData(_aoOptions);
	_oSelf._initBtnEvent(_aoOptions);
}

// 私有方法 初始化数据列表
DiscuGroup_Add.prototype._initData = function(_aoOptions) {
	var _oSelf = this;
	
	
	
}

// 私有方法 初始化按钮事件
DiscuGroup_Add.prototype._initBtnEvent = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discgroup_add");
	
	con.find(".addr_type").click(function(){
		$(this).siblings("a").removeClass("selected");
		$(this).addClass("selected");
	});
	
	con.find(".addr_add_btn").click(function(){
		var alen = con.find(".addr_type_con .addr_type").length;
		if(alen >= 10){
			//alert('讨论组标签不能超过10个');
			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip none").html("讨论组标签不能超过10个");
	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			return ;
		}
		con.find(".addr_add_con").removeClass("none");
		
	}).end().find(".addr_save_btn").click(function(){//保存
		var v = $("#addr_txt").val();
		if(!$.trim(v)){
			//alert('请输入文字');
			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css('display','').html("请输入文字");
	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			return;
		}
		var length = _oSelf.getBytesCount($.trim(v));
		if(length > 20){
			//alert('输入文字过长');
			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css('display','').html("输入文字过长");
	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			return;
		}
		con.find(".addr_type_con").append('<a class="ahref_type addr_type " href="javascript:void(0)" key=""><span class="sval">'+ v +'</span><span class="tagdelbtn" style="margin-left: 2px;"><img src="'+_oSelf.getContentPath()+'/image/fasdel.png" style="width: 12px;"></span>&nbsp;&nbsp;</a>');
		con.find(".addr_cancel_btn").trigger("click");
		$("#addr_txt").val('');
		//删除
		con.find(".tagdelbtn").click(function(){
			$(this).parent().remove();
		});
		
	}).end().find(".addr_cancel_btn").click(function(){//取消
		con.find(".addr_add_con").addClass("none");
		
	}).end().find(".joinin_flag").click(function(){//入群验证
		$(this).siblings("a").removeClass("selected");
		$(this).addClass("selected");
		con.find(":hidden[name=joinin_flag]").val($(this).attr("key"));
		
	}).end().find(".msg_group_flag").click(function(){//信息群发设置
		$(this).siblings("a").removeClass("selected");
		$(this).addClass("selected");
		con.find(":hidden[name=msg_group_flag]").val($(this).attr("key"));
		
	}).end().find(".discugroup_tag_add_btn").click(function(){//讨论组添加按钮
		var alen = con.find(".discugroup_tag_con .discugroup_tag").length;
		if(alen >= 10){
			//alert('讨论组标签不能超过10个');
			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css('display','').html("标签不能超过10个");
	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			return ;
		}
		con.find(".discugroup_tag_add_con").removeClass("none");
		
	}).end().find(".discugroup_tag_save_btn").click(function(){//保存
		var v = $("#discugroup_tag_txt").val();
		if(!$.trim(v)){
			//alert('请输入文字');
			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css('display','').html("请输入文字");
	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			return;
		}
		var length = _oSelf.getBytesCount($.trim(v));
		if(length > 20){
			//alert('输入文字过长');
			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css('display','').html("输入文字过长");
	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			return;
		}
		con.find(".discugroup_tag_con").append('<a href="javascript:void(0)" class="ahref_type discugroup_tag " key="0" style=""><span class="sval">'+ v +'</span><span class="tagdelbtn" style="margin-left: 2px;"><img src="'+_oSelf.getContentPath()+'/image/fasdel.png" style="width: 12px;"></span>&nbsp;&nbsp;&nbsp;&nbsp;</a>');
		con.find(".discugroup_tag_cancel_btn").trigger("click");
		$("#discugroup_tag_txt").val('');
		//删除
		con.find(".tagdelbtn").click(function(){
			$(this).parent().remove();
		});
		
	}).end().find(".discugroup_tag_cancel_btn").click(function(){//取消;
		con.find(".discugroup_tag_add_con").addClass("none");
		
	});
	
	//取消创建
	con.find(".dis_cancel_btn").click(function(){
		window.history.back(-1);
	});
	
	//保存讨论组
	con.find(".dis_save_btn").click(function(){
		var btnobj = $(this);
		var n = con.find("input[name=name]").val();
		var orgId = con.find("input[name=orgId]").val();
		var joinin_flag = con.find(":hidden[name=joinin_flag]").val();
		var msg_group_flag = con.find(":hidden[name=msg_group_flag]").val();
		var address = '';
		con.find(".addr_type_con a").each(function(){
			var h = $(this).find(".sval").html();
			address += h + ",";
		});
		var distags = '';
		con.find(".discugroup_tag_con a").each(function(){
			var h = $(this).find(".sval").html();
			distags += h + ",";
		});
		//验证
		if(!$.trim(orgId)){
			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css('display','').html("请选择账号");
	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			return;
		}
		//验证
		if(!$.trim(n)){
			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css('display','').html("讨论组名称不能为空");
	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			return;
		}
		if(_oSelf.getBytesCount(n) > 100){
			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css('display','').html("讨论组名称长度过长");
	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			return;
		}
//		if(!$.trim(address)){
//			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css('display','').html("讨论组地点不能为空");
//	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
//			return;
//		}
		if(!/^[^@#$%^&*()]*$/.test(address)){
			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css('display','').html("讨论组地点不能包含特殊【@#$%^&*()】字符");
	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			return;
		}
			
		btnobj.attr("disabled","disabled");
		//组装数据
		var data = [];
		    data.push({name: 'name',value: n});
		    data.push({name: 'joinin_flag',value: joinin_flag});
		    data.push({name: 'msg_group_flag',value: msg_group_flag});
		    data.push({name: 'address',value: address});
		    data.push({name: 'distags',value: distags});
		    data.push({name: 'orgId',value: orgId});
		
		$.ajax({
			url: _oSelf.getContentPath() + "/discuGroup/save",
			data: data,
		 	success: function(data){
		 		if(data === "success"){
		 			//alert('保存讨论组成功');
		 			con.find(".myDefMsgBox").addClass("success_tip ").removeClass("warning_tip error_tip").css('display','').html("保存讨论组成功");
			   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
		 			window.location.replace(_oSelf.getContentPath() + '/discuGroup/list');
		 			
		 		}else if(data === "repeat"){
		 			//alert('讨论组名称重复');
		 			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css('display','').html("讨论组名称重复");
			   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			   	    btnobj.removeAttr("disabled");
		 		}else{
		 			//alert('保存讨论组失败');
		 			con.find(".myDefMsgBox").addClass("error_tip").removeClass("warning_tip success_tip").css('display','').html("保存讨论组失败");
			   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			   	    btnobj.removeAttr("disabled");
		 		}
		    }
		});
	});
	
	//选择组织
	con.find(".orgchoose").click(function(){
		lovjs_choose('sysAccount',{
    		success: function(res){
    			$(":hidden[name=orgId]").val(res.key);
    			$("input[name=orgName]").val("账户："+res.val);
    		}
    	});
	});
}

//获得上下文内容
DiscuGroup_Add.prototype.getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}

//获取输入框输入的字节数
DiscuGroup_Add.prototype.getBytesCount = function(str) { 
	var bytesCount = 0; 
	if (str != null){ 
		for (var i = 0; i < str.length; i++){ 
			var c = str.charAt(i); 
			if (/^[\u0000-\u00ff]$/.test(c)){ 
				bytesCount += 1; 
			}else { 
				bytesCount += 2; 
			} 
		} 
	} 
	return bytesCount; 
}