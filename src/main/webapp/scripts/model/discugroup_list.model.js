var DiscuGroup_List = function(_aoOption){
	// 配置（默认是从外面传进来）
	_aoOption || (_aoOption = {}) ;
	if(_aoOption.initFlag && _aoOption.initFlag === 'false') return;
	// 初始化函数
	this._init(_aoOption);
	
	this.currpages = 0;
	this.orgId = "";
}

// 私有方法
DiscuGroup_List.prototype._init = function(_aoOptions) {
	var _oSelf = this;
	_oSelf._initData(_aoOptions);
	_oSelf._initBtnEvent(_aoOptions);
}

// 私有方法 初始化数据列表
DiscuGroup_List.prototype._initData = function(_aoOptions) {
	var _oSelf = this;
	_oSelf.currpages = 0;
	_oSelf._initDgListData(_aoOptions);
	_oSelf._initWeightDgListData(_aoOptions);
}

//初始化列表数据
DiscuGroup_List.prototype._initConditionDgListData = function(_aoOptions) {
	var _oSelf = this;
	//查询我的讨论组列表
	$.ajax({
		type: 'post',
		url: _oSelf.getContentPath() + "/discuGroup/conditionlist",
		data:{stxt: _aoOptions.stxt, pagecounts: '0', currpages: '10'},
	 	success: function(data){
	 		$("#discugroup_list .search_list .loadingdata").addClass("none");
	 		var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			$("#discugroup_list .search_list .sub_content").addClass("none");
	 			$("#discugroup_list .search_list .nodata").removeClass("none");
	 			return;
	 		}
	 		$("#discugroup_list .search_list .sub_content").empty().removeClass("none");
	 		$(darr).each(function(i){
	 			//this.createTime = dateFormat(new Date(this.createTime.time), "yyyy-MM-dd hh:mm");
	 			$("#discugroup_list .search_list .sub_content").append(template("singleDiscuGroupTemp", this));
	 		});
	 		//列表单条数据点击事件
	 		_oSelf._dgListSingleClickEvent(_aoOptions);
	    }
	});
}

// 初始化列表数据
DiscuGroup_List.prototype._initDgListData = function(_aoOptions) {
	var _oSelf = this;
	$("#discugroup_list .my_list .nodata").addClass("none");//隐藏物数据输入框
	//查询我的讨论组列表
	$.ajax({
		url: _oSelf.getContentPath() + "/discuGroup/mygrouplist",
		data:{stxt: _aoOptions.stxt, pagecounts: _aoOptions.pagecounts || '3', currpages: _aoOptions.currpages || '0',orgId:_aoOptions.orgId},
	 	success: function(data){
	 		$("#discugroup_list .my_list .loadingdata").addClass("none");
	 		var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			//$("#discugroup_list .my_list .sub_content").addClass("none");
	 			$("#discugroup_list .my_list .more").addClass("none");
	 			var l = $("#discugroup_list .my_list .sub_content div").length;
	 			if(l === 0){
	 				$("#discugroup_list .my_list .nodata").removeClass("none");
	 			}
	 			return;
	 		}
	 		if(darr.length <= 3){
	 			$("#discugroup_list .my_list .more").addClass("none");
	 		}else{
	 			$("#discugroup_list .my_list .more").removeClass("none");
	 		}
	 		$("#discugroup_list .my_list .sub_content").removeClass("none");
	 		$(darr.slice(0,3)).each(function(i){
	 			//this.createTime = dateFormat(new Date(this.createTime.time), "yyyy-MM-dd hh:mm");
	 			$("#discugroup_list .my_list .sub_content").append(template("singleDiscuGroupTemp", this));
	 		});
	 		//列表单条数据点击事件
	 		_oSelf._dgListSingleClickEvent(_aoOptions);
	    }
	});
}

// 查询热门讨论组
DiscuGroup_List.prototype._initWeightDgListData = function(_aoOptions) {
	var _oSelf = this;
	//查询我的讨论组列表
	$.ajax({
		url: _oSelf.getContentPath() + "/discuGroup/weightlist",
		data:{stxt: _aoOptions.stxt, pagecounts: '3', currpages: '0'},
		success: function(data){
			$("#discugroup_list .weight_list .loadingdata").addClass("none");
			var darr = JSON.parse(data);
			if(!darr || darr.length == 0){
				$("#discugroup_list .weight_list .sub_content").addClass("none");
				$("#discugroup_list .weight_list .nodata").removeClass("none");
				return;
			}
			$("#discugroup_list .weight_list .sub_content").empty().removeClass("none");
			$(darr).each(function(i){
				//this.createTime = dateFormat(new Date(this.createTime.time), "yyyy-MM-dd hh:mm");
				$("#discugroup_list .weight_list .sub_content").append(template("singleWeightDiscuGroupTemp", this));
				if(i == darr.length - 1){
					$("#discugroup_list .weight_list .sub_content").append('');  
 				}
			});
			//列表单条数据点击事件
			_oSelf._dgListSingleClickEvent(_aoOptions);
			//绑定放开与收起事件
			_oSelf._initCollapseBtnEvent(_aoOptions);
		}
	});
}

// 私有方法 初始化按钮事件
DiscuGroup_List.prototype._initBtnEvent = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_list");
	//新增讨论组按钮
	con.find(".addBtn").click(function(){
		window.location.href = _oSelf.getContentPath() + "/discuGroup/add";
		
	}).end().find(".screeningBtn").click(function(){//筛选按钮
		con.find(".content_list").addClass("none");
		con.find(".search_list").removeClass("none");
		con.find(".search").removeClass("none");
		con.parent().find(".orgDiv").addClass("none");
	});
	//查询按钮
	con.find(".searchbtn").click(function(){
		var stxt = $("#discugroup_list").find("input[name=searchtxt]").val();
		if(!stxt){
			con.find(".myDefMsgBox").addClass("warning_tip").removeClass("success_tip error_tip").css("display","").html("搜索条件不能为空");
	   	    con.find(".myDefMsgBox").delay(2000).fadeOut();
			return;
		}
		con.find(".content_list").addClass("none");
		con.find(".search_list").removeClass("none");
		$("#discugroup_list .search_list .loadingdata").removeClass("none");
		$("#discugroup_list .search_list .sub_content").addClass("none");
		$("#discugroup_list .search_list .nodata").addClass("none");
		_oSelf._initConditionDgListData($.extend(_aoOptions, {stxt:stxt}));
		con.find("input[name=searchtxt]").val('');//清空输入框的值
	}).end().find(".backbtn").click(function(){
		con.find(".content_list").removeClass("none");
		con.find(".search_list").addClass("none");
		con.find(".search").addClass("none");
		con.parent().find(".orgDiv").removeClass("none");
	});
	//more 更多数据
	con.find(".my_list .more").click(function(){
		_oSelf.currpages = _oSelf.currpages + 3;
		$.extend(_aoOptions, {pagecounts: 3, currpages: _oSelf.currpages, orgId: _oSelf.orgId});
		_oSelf._initDgListData(_aoOptions);
	});
}

//初始化收起事件
DiscuGroup_List.prototype._initCollapseBtnEvent = function(_aoOptions) {
	var _oSelf = this;
	var con = $("#discugroup_list");
	//collapse 收起按钮
	con.find(".my_list_group").click(function(){
		if(con.find(".my_list .sub_content").hasClass("none")){
			con.find(".my_list .sub_content").removeClass("none");
			con.find(".my_list .more").removeClass("none");
			con.find(".my_list_group .arrdown").removeClass("none");
			con.find(".my_list_group .arrleft").addClass("none");
		}else{
			con.find(".my_list .sub_content").addClass("none");
			con.find(".my_list .more").addClass("none");
			con.find(".my_list_group .arrdown").addClass("none");
			con.find(".my_list_group .arrleft").removeClass("none");
		}
	});
}

// 讨论组列表点击 事件
DiscuGroup_List.prototype._dgListSingleClickEvent = function(_aoOptions) {
	var _oSelf = this;
	//讨论组列表 详情事件
	$("#discugroup_list .my_list .sub_content").find("div").click(function(){
		var obj = $(this);
		window.location.href = _oSelf.getContentPath() + "/discuGroup/detail?rowId="+obj.attr("dgid");
	});
	//讨论组列表 详情事件
	$("#discugroup_list .search_list .sub_content").find("div").click(function(){
		var obj = $(this);
		window.location.href = _oSelf.getContentPath() + "/discuGroup/detail?rowId="+obj.attr("dgid");
	});
	//讨论组列表 详情事件
	$("#discugroup_list .weight_list .sub_content").find("div").click(function(){
		var obj = $(this);
		window.location.href = _oSelf.getContentPath() + "/discuGroup/detail?rowId="+obj.attr("dgid");
	});
}

//获得上下文内容
DiscuGroup_List.prototype.getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}