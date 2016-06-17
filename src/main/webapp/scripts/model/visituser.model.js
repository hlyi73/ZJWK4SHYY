//访客对象
var VisitUser = function(_aoOption){
	// 配置（默认是从外面传进来）
	_aoOption || (_aoOption = {}) ;
	// 初始化函数
	this._init(_aoOption);
}

// 私有方法
VisitUser.prototype._init = function(_aoOptions) {
	var _oSelf = this;
	_oSelf._initData(_aoOptions);
	_oSelf._initBtnEvent(_aoOptions);
}

// 私有方法 初始化数据列表
VisitUser.prototype._initData = function(_aoOptions) {
	var _oSelf = this;
	//查询留言和私信列表
	$.ajax({
		url: _oSelf.getContentPath() + "/print/vulist",
		data:{bcpartyid: _aoOptions.bcpartyid,pagecounts:_aoOptions.pagecounts, currpages:_aoOptions.currpages},
	 	success: function(data){
	 		var darr = JSON.parse(data);
	 		if(!darr || darr.length == 0){
	 			$(".visit_list .content").html('<div style="margin-top:2px;font-size:14px;color:#999;text-align:center;">暂时还没有人来访问您哦！</div>');
	 			return;
	 		}
	 		$(darr).each(function(i){
	 			var n = this.operativename;
	 			var d = utc2date(this.createTime.time);
	 			var t= '';
	 			if(this.objecttype == 'PERSONAL_HOMEPAGE'){
	 				if(_aoOptions.bcpartyid==_aoOptions.currpartyid){
	 				t = '我的主页'; 
	 				}else{
	 					t ='<span class="cred">' +_aoOptions.visitname+'</span>的主页'; 
	 				}
	 			}
	 			var h ='<div style="color:#999"><span class="cred"><a href="'+_oSelf.getContentPath()+'/businesscard/detail?partyId='+this.operativeid+'">' + n + '</a></span>&nbsp;' + d + '访问过' + t + '</div>';
	 			if(i < 18){
	 				$("."+_aoOptions.con).find(".content").append(h);
	 			}else{
	 				$("."+_aoOptions.con).find(".content_more").append(h);
	 			}
	 			//查看更多
	 			$("."+_aoOptions.con).find(".showAll").removeClass("none").click(function(){
	 				$(this).addClass("none");
	 				$("."+_aoOptions.con).find(".content_more").removeClass("none");
	 			});
	 		});
	    },
	    error:function(){
	    	$(".visit_list").css("display","none");
	    }
	});
}

//私有方法 初始化按钮事件
VisitUser.prototype._initBtnEvent = function(_aoOptions) {
	var _oSelf = this;
	//more
	$("."+_aoOptions.con).find(".permore").click(function(){
		window.location.href = _oSelf.getContentPath() + "/print/goVisitUserList?partyId="+_aoOptions.bcpartyid;
	});
}

//获得上下文内容
VisitUser.prototype.getContentPath =  function(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}
