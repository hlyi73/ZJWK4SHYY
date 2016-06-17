var ConList_Group = function(_aoOption){
	// 配置（默认是从外面传进来）
	_aoOption || (_aoOption = {}) ;
	if(_aoOption.initFlag && _aoOption.initFlag === 'false') return;
	// 初始化函数
	this._init(_aoOption);
	$("."+_aoOption.contype +"_type").siblings().css({"background-color":"#e5e1e3","color":"#000"});
	$("."+_aoOption.contype +"_type").css({"background-color":"#fff","color":"#000"});//
}

// 私有方法
ConList_Group.prototype._init = function(_aoOptions) {
	var _oSelf = this;
	_oSelf._initData(_aoOptions);
	_oSelf._initBtnEvent(_aoOptions);
}

// 私有方法 初始化数据列表
ConList_Group.prototype._initData = function(_aoOptions) {
	var _oSelf = this;
	//_oSelf._initTypeListData(_aoOptions);
}

// 初始化列表数据
ConList_Group.prototype._initTypeListData = function(_aoOptions) {
	var _oSelf = this;
	var con = $(".conlist_group_con");
	//查询我的讨论组列表
	$.ajax({
		url: _oSelf.getContentPath() + "/cbooks/conlist_group",
		data:{stxt: _aoOptions.stxt, contype: _aoOptions.contype, pagecounts: '0', currpages: '10'},
	 	success: function(data){
	 		alert('success');
	 	}
	});
}

//同步提交初始化列表数据
ConList_Group.prototype._initTypeListData_Asycn = function(_aoOptions) {
	var _oSelf = this;
	var con = $(".conlist_group_con");
	//查询我的讨论组列表
	con.find("form[name=con_group_form] :hidden[name=contype]").val(_aoOptions.contype);
	con.find("form[name=con_group_form]").submit();
}

// 私有方法 初始化按钮事件
ConList_Group.prototype._initBtnEvent = function(_aoOptions) {
	var _oSelf = this;
	var con = $(".conlist_group_con");
	//左侧容器点击事件
	con.find(".left_con div").click(function(){
		var contype = "";
		if($(this).hasClass("comp_type")){
			contype = "company";//company , school, area, position
		}
		else if($(this).hasClass("school_type")){
			contype = "school";//company , school, area, position
		}
		else if($(this).hasClass("imp_type")){
			contype = "imp";//company , school, area, position
		}
		else if($(this).hasClass("position_type")){
			contype = "position";//company , school, area, position
		}
		else if($(this).hasClass("area_type")){
			contype = "area";//company , school, area, position
		}else{
			return;
		}
		$.extend(_aoOptions, {contype: contype});
		_oSelf._initTypeListData_Asycn(_aoOptions);
		
	});
}

//获得上下文内容
ConList_Group.prototype.getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}