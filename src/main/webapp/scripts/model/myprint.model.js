//访客对象
var MyPrint = function(_aoOption){
	// 配置（默认是从外面传进来）
	_aoOption || (_aoOption = {}) ;
	// 初始化函数
	this._init(_aoOption);
}

// 私有方法
MyPrint.prototype._init = function(_aoOptions) {
	var _oSelf = this;
	_oSelf._initData(_aoOptions);
	_oSelf._initBtnEvent(_aoOptions);
}

// 私有方法 初始化数据列表
MyPrint.prototype._initData = function(_aoOptions) {
	var _oSelf = this;
	//查询留言和私信列表
	$.ajax({
		url: _oSelf.getContentPath() + "/print/printList",
		data:{bcpartyid: _aoOptions.bcpartyid,pagecounts:_aoOptions.pagecounts, currpages:_aoOptions.currpages},
	 	success: function(data){
	 		
	 		var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			$(".print_list .content").html('<div style="margin-top:2px;font-size:14px;color:#999;text-align:center;">暂时还没有动态哦！</div>');
	 			return;
	 		}
	 		$(darr).each(function(){
	 			var n = '';
	 			var d = utc2date(this.createTime.time);
	 			var t= '';
	 			var url='';
	 			if(this.operativetype == 'SHARE'){ 				
	 				t = '分享'; 
	 			}else{
	 				t='创建';
	 			}
	 			if(this.objecttype=='ACTIVITY'){
	 				n='活动';
	 				
	 			}else{
	 				n='文章';
	 				url = _oSelf.getContentPath()+'/resource/detail?id='+this.objectid;
	 			}
	 			var h ='<div style="color:#999"><span class="cred">【'+t+n+'】</span><a href="'+url+'">'+this.objectname+'</a></div>';
	 			$("."+_aoOptions.con).find(".content").append(h);
	 		});
	    },
	    error:function(){
	    	$(".print_list").css("display","none");
	    }
	});
}

//私有方法 初始化按钮事件
MyPrint.prototype._initBtnEvent = function(_aoOptions) {
	var _oSelf = this;
	//more
	$("."+_aoOptions.con).find(".permore").click(function(){
		window.location.href = _oSelf.getContentPath() +"/print/goPrintList?partyId="+_aoOptions.bcpartyid;
	});
}

//获得上下文内容
MyPrint.prototype.getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}
