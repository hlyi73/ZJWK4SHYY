var DiscuGroup_List = function(_aoOption){
	// 配置（默认是从外面传进来）
	_aoOption || (_aoOption = {}) ;
	if(_aoOption.initFlag && _aoOption.initFlag === 'false') return;
	// 初始化函数
	this._init(_aoOption);
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
	_oSelf._initDgListData(_aoOptions);
}

// 私有方法 初始化按钮事件
DiscuGroup_List.prototype._initBtnEvent = function(_aoOptions) {
	var _oSelf = this;
	
}

//获得上下文内容
DiscuGroup_List.prototype.getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}