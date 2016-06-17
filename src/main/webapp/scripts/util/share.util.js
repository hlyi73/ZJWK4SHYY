var onBridgeReady = function(){
	
	WeixinJSBridge.on('menu:share:appmessage', function(argv){
		 WeixinJSBridge.invoke('sendAppMessage',{
			"appid":dataForWeixin.appId,  
			"img_url":dataForWeixin.MsgImg,  
			"img_width":"120",  
			"img_height":"120",  
			"link":dataForWeixin.url,  
			"desc":dataForWeixin.desc,  
			"title":dataForWeixin.title  

		}, function(res){
			(dataForWeixin.callback)();
		});
	 
	});

    WeixinJSBridge.on('menu:share:timeline', function(argv){  
       (dataForWeixin.callback)();  
       WeixinJSBridge.invoke('shareTimeline',{  
          "img_url":dataForWeixin.TLImg,  
          "img_width":"120",  
          "img_height":"120",  
          "link":dataForWeixin.url,  
          "desc":dataForWeixin.desc,  
          "title":dataForWeixin.title  
       }, function(res){});  
    });
    
    WeixinJSBridge.on('menu:share:weibo', function(argv){  
       WeixinJSBridge.invoke('shareWeibo',{  
          "content":dataForWeixin.title,  
          "url":dataForWeixin.url  
       }, function(res){(dataForWeixin.callback)();});  
    });
    
    WeixinJSBridge.on('menu:share:facebook', function(argv){
       (dataForWeixin.callback)();  
       WeixinJSBridge.invoke('shareFB',{  
          "img_url":dataForWeixin.TLImg,  
          "img_width":"120",  
          "img_height":"120",  
          "link":dataForWeixin.url,  
          "desc":dataForWeixin.desc,  
          "title":dataForWeixin.title  
       }, function(res){});  
    });  
 };
 
//判断是否是在微信浏览器中
var is_weixn = function(){
    var ua = navigator.userAgent.toLowerCase();
    if(ua.match(/MicroMessenger/i)=="micromessenger"){
        return true;
    }else {
        return false;  
    }
};

//获得openId数据
var accessWxInfoUrl = function(appcontent, appid, redirectURLPath){
	 //微信url
	 var return_url = encodeURIComponent(appcontent + '/wxuser/wxCallBackSec?' + redirectURLPath);
	 var url = "https://open.weixin.qq.com/connect/oauth2/authorize?appid=" + appid + "&redirect_uri="+ return_url +"&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect";
	 //alert(url);
	 return url;
};

function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}

 
$(function() {
	 
	 if(document.addEventListener){  
	    document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);  
	 }else if(document.attachEvent){  
	    document.attachEvent('WeixinJSBridgeReady'   , onBridgeReady);  
	    document.attachEvent('onWeixinJSBridgeReady' , onBridgeReady);  
	 }
	 
});