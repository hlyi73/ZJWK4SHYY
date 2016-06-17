var DiscuGroup_Mass = function(_aoOption){
	// 配置（默认是从外面传进来）
	_aoOption || (_aoOption = {}) ;
	if(_aoOption.initFlag && _aoOption.initFlag === 'false') return;
	// 初始化函数
	this._init(_aoOption);
}

// 私有方法
DiscuGroup_Mass.prototype._init = function(_aoOptions) {
	var _oSelf = this;
	_oSelf._initData(_aoOptions);
	_oSelf._initBtnEvent(_aoOptions);
}

// 私有方法 初始化数据列表
DiscuGroup_Mass.prototype._initData = function(_aoOptions) {
	var _oSelf = this;
	_oSelf._initActListData($.extend(_aoOptions,{type:'owner'}));
}

// 初始化活动列表数据
DiscuGroup_Mass.prototype._initActListData = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_mass");
	//查询我的讨论组列表
	$.ajax({
		url: _oSelf.getContentPath() + "/discuGroup/massactlist02",
		data:{viewtype: _aoOptions.type},
	 	success: function(data){
			con.find(".activity_list .content").removeClass("none");
			con.find(".activity_list .loadingdata").addClass("none");
	 		
	 		var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			if(_aoOptions.type === 'owner'){
	 				con.find(".activity_list .sub_content_join").addClass("none");
	 				con.find(".activity_list .sub_content_regist").addClass("none");
	 				con.find(".activity_list .sub_content_owner").removeClass("none");
	 				con.find(".activity_list .sub_content_owner").empty().append('<div class=" nodata" style="position: fixed; width: 100%; text-align: center; margin-top: 45px;">没有找到匹配的数据！</div>');
	 			}else if(_aoOptions.type === 'join'){
	 				con.find(".activity_list .sub_content_owner").addClass("none");
	 				con.find(".activity_list .sub_content_regist").addClass("none");
	 				con.find(".activity_list .sub_content_join").removeClass("none");
	 				con.find(".activity_list .sub_content_join").empty().append('<div class=" nodata" style="position: fixed; width: 100%; text-align: center; margin-top: 45px;">没有找到匹配的数据！</div>');
	 			}else if(_aoOptions.type === 'regist'){
	 				con.find(".activity_list .sub_content_owner").addClass("none");
	 				con.find(".activity_list .sub_content_join").addClass("none");
	 				con.find(".activity_list .sub_content_regist").removeClass("none");
	 				con.find(".activity_list .sub_content_regist").empty().append('<div class=" nodata" style="position: fixed; width: 100%; text-align: center; margin-top: 45px;">没有找到匹配的数据！</div>');
	 			}
	 			return;
	 		}
	 		if(_aoOptions.type === 'owner'){
 				con.find(".activity_list .sub_content_owner").html(''); 
 			}else if(_aoOptions.type === 'join'){
 				con.find(".activity_list .sub_content_join").html(''); 
 			}else if(_aoOptions.type === 'regist'){
 				con.find(".activity_list .sub_content_regist").html('');
 			}
	 		$(darr).each(function(){ 
	 			//this.createTime = dateFormat(new Date(this.createTime.time), "yyyy-MM-dd hh:mm");
	 			if(_aoOptions.type === 'owner'){
	 				con.find(".activity_list .sub_content_owner").append(template("singleActTemp", this));
	 			}else if(_aoOptions.type === 'join'){
	 				con.find(".activity_list .sub_content_join").append(template("singleActTemp", this));
	 			}else if(_aoOptions.type === 'regist'){
	 				con.find(".activity_list .sub_content_regist").append(template("singleActTemp", this));
	 			}
	 		});
	 		
	 		//群发
	 		con.find(".sub_content_join .massgouxuanbtn ").click(function(){//join 类型的
	 			con.find(".sub_content_join .massgouxuanbtn").removeClass("rsel");
	 			$(this).addClass("rsel");
	 			$(":hidden[name=relaId]").val($(this).attr("rowid"));
	 			
	 		}).end().find(".sub_content_owner .massgouxuanbtn").click(function(){//owner 类型的
	 			con.find(".sub_content_owner .massgouxuanbtn").removeClass("rsel");
	 			$(this).addClass("rsel");
	 			$(":hidden[name=relaId]").val($(this).attr("rowid"));
	 			
	 		}).end().find(".sub_content_regist .massgouxuanbtn").click(function(){//regist 类型的
	 			con.find(".sub_content_regist .massgouxuanbtn").removeClass("rsel");
	 			$(this).addClass("rsel");
	 			$(":hidden[name=relaId]").val($(this).attr("rowid"));
	 			
	 		});
	    }
	});
}

// 私有方法 初始化按钮事件
DiscuGroup_Mass.prototype._initBtnEvent = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_mass");
	var dgid = con.find(":hidden[name=dgid]").val();
	//类型查询
	con.find(".masstype_con div").click(function(){
		$(this).addClass("tabseleted02");
		$(this).siblings().removeClass("tabseleted02");
		if($(this).hasClass("sendArticle")){//群发文章
			$("form[name=mass_form]").find(":hidden[name=massType]").val("article");
		    //活动
			con.find(".activity_list").addClass("none");
			//文章
			con.find(".article_list").removeClass("none");
			con.find(".article_list .content").addClass("none");
			con.find(".article_list .loadingdata").removeClass("none");
			
			con.find(".article_list .content").load(_oSelf.getContentPath() + "/resource/list?source=discu&dgid=" + dgid, function(){
				con.find(".article_list .content").removeClass("none");
				con.find(".article_list .loadingdata").addClass("none");
				//绑定事件
				con.find(".article_list").find(".massgouxuanbtn").click(function(){
					con.find(".article_list").find(".massgouxuanbtn").removeClass("rsel");
		 			$(this).addClass("rsel");
		 			$(":hidden[name=relaId]").val($(this).attr("rowid"));
		 		});
			});
			
		}else if($(this).hasClass("sendActivity")){//群发活动
			$("form[name=mass_form]").find(":hidden[name=massType]").val("activity"); 
			
			con.find(".article_list").addClass("none");
			
			con.find(".activity_list").removeClass("none");
			con.find(".activity_list .content").addClass("none");
			con.find(".activity_list .loadingdata").removeClass("none");
			
			_oSelf._initActListData($.extend(_aoOptions,{type:'owner'}));
		}
	});
	
	//方式发送
	con.find(".massway_con div").click(function(){
		$(this).addClass("tabseleted02");
		$(this).siblings().removeClass("tabseleted02");
		con.find(":hidden[name=massway]").val($(this).attr("key"));
	});
	
	//群发活动tab
	con.find(".activity_list .activity_tab div").click(function(){
		$(this).addClass("tabselected04");
		$(this).siblings().removeClass("tabselected04");
		if($(this).hasClass("all")){//all
			con.find(".activity_list .content").addClass("none");
			con.find(".activity_list .loadingdata").removeClass("none");
			
			con.find(".activity_list .sub_content_join").removeClass("none");
			con.find(".activity_list .sub_content_owner").removeClass("none");
			_oSelf._initActListData($.extend(_aoOptions,{type:'owner'}));
			
		}else if($(this).hasClass("owner")){
			con.find(".activity_list .content").addClass("none");
			con.find(".activity_list .loadingdata").removeClass("none");
			
			con.find(".activity_list .sub_content_join").addClass("none");
			con.find(".activity_list .sub_content_owner").removeClass("none");
			con.find(".activity_list .sub_content_regist").addClass("none");
			_oSelf._initActListData($.extend(_aoOptions,{type:'owner'}));
			
		}else if($(this).hasClass("join")){
			con.find(".activity_list .content").addClass("none");
			con.find(".activity_list .loadingdata").removeClass("none");
			
			con.find(".activity_list .sub_content_join").removeClass("none");
			con.find(".activity_list .sub_content_owner").addClass("none");
			con.find(".activity_list .sub_content_regist").addClass("none");
			_oSelf._initActListData($.extend(_aoOptions,{type:'join'}));
		}else if($(this).hasClass("regist")){
			con.find(".activity_list .content").addClass("none");
			con.find(".activity_list .loadingdata").removeClass("none");
			
			con.find(".activity_list .sub_content_join").addClass("none");
			con.find(".activity_list .sub_content_owner").addClass("none");
			con.find(".activity_list .sub_content_regist").removeClass("none");
			_oSelf._initActListData($.extend(_aoOptions,{type:'regist'}));
		}
	});
	
	//发送按钮
	con.find(".massaction_con .sendlmassbtn").click(function(){//发送
		var relaId = $(":hidden[name=relaId]").val();
		if(!relaId){
			$(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请选择");
  		    $(".myMsgBox").delay(1000).fadeOut();
			return;
		}
		$(this).remove();
		$(".g-mask").removeClass("none");
		$(".send_msg_loading").removeClass("none");
		$("form[name=mass_form]").attr("action",_oSelf.getContentPath() + "/discuGroup/sendMass");
		$("form[name=mass_form]").submit();
		
	}).end().find(".massaction_con .cannelmassbtn").click(function(){//取消
		window.location.replace(_oSelf.getContentPath() + '/discuGroup/detail?rowId='+dgid);
	});
	
	//创建活动
	con.find(".addActivity").click(function(){
		var appContent = con.find(":hidden[name='appContent']").val();
		var currPartyId = con.find(":hidden[name='currPartyId']").val();
		var source = _oSelf.isWeiXin();
		if('mobile'===source){//微信内置浏览器
    		window.location.href = appContent + "/zjwkactivity/get?source=WK&sourceid="+currPartyId+"&return_url="+appContent+"/zjactivity/add";
		}else if('windows'===source){//pc端浏览器
			window.location.href = appContent + '/zjwkactivity/get?source=PC&sourceid='+currPartyId+'&return_url='+appContent+'/zjactivity/add';
		}
	});
}

//判断浏览器客户端为移动端还是PC端
DiscuGroup_Mass.prototype.isWeiXin =  function(){
	var source = "";
	var sUserAgent = navigator.userAgent.toLowerCase();
    var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
    var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
    var bIsMidp = sUserAgent.match(/midp/i) == "midp";
    var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
    var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
    var bIsAndroid = sUserAgent.match(/android/i) == "android";
    var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
    var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
    if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {//如果是上述设备就会以手机域名打开
    	source = "mobile";
    }else{//否则就是电脑域名打开
    	source = "windows";
    }
    return source;
}

//获得上下文内容
DiscuGroup_Mass.prototype.getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}