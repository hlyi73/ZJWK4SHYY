<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.takshine.wxcrm.base.util.StringUtils,java.security.MessageDigest,java.util.Formatter,com.takshine.wxcrm.base.common.Constants,com.takshine.wxcrm.base.util.WxUtil,java.util.UUID,com.takshine.wxcrm.base.util.PropertiesUtil" %>
<%
	    String wxjs = request.getContextPath();
        //获得sing
        // 调用接口获取access_token
		String at = WxUtil.getAccessTokenStr(Constants.APPID, Constants.APPSECRET);
		System.out.println("accesstoken = >" + at);
		String jsapi_ticket = WxUtil.getJsapiTicket(at);
		System.out.println("jsapi_ticket = >" + jsapi_ticket);

		String nonce_str = UUID.randomUUID().toString();
		String timestamp = Long.toString(System.currentTimeMillis() / 1000);
		
		Object urlobj = request.getAttribute("shareurl");
		String url = (urlobj != null) ? (String)urlobj: "";
		System.out.println("nonce_str => " + nonce_str);
		System.out.println("timestamp => " + timestamp);
		System.out.println("url => " + url);
		
		String string1;
		String signature = "";

		// 注意这里参数名必须全部小写，且必须有序
		string1 = "jsapi_ticket=" + jsapi_ticket + "&noncestr=" + nonce_str + "&timestamp=" + timestamp + "&url=" + url;
		System.out.println("string1 = >" + string1);

		MessageDigest crypt = MessageDigest.getInstance("SHA-1");
		crypt.reset();
		crypt.update(string1.getBytes("UTF-8"));
		
		byte[] hash =  crypt.digest();
		Formatter formatter = new Formatter();
        for (byte b : hash){
            formatter.format("%02x", b);
        }
        String result = formatter.toString();
        formatter.close();
        signature = result;
        System.out.println("signature = >" + signature);
%>
<script src="http://res.wx.qq.com/open/js/jweixin-1.0.0.js"></script>
<script>
  /*
   * 注意：
   * 1. 所有的JS接口只能在公众号绑定的域名下调用，公众号开发者需要先登录微信公众平台进入“公众号设置”的“功能设置”里填写“JS接口安全域名”。
   * 2. 如果发现在 Android 不能分享自定义内容，请到官网下载最新的包覆盖安装，Android 自定义分享接口需升级至 6.0.2.58 版本及以上。
   * 3. 完整 JS-SDK 文档地址：http://mp.weixin.qq.com/wiki/7/aaa137b55fb2e0456bf8dd9148dd613f.html
   *
   * 如有问题请通过以下渠道反馈：
   * 邮箱地址：weixin-open@qq.com
   * 邮件主题：【微信JS-SDK反馈】具体问题
   * 邮件内容说明：用简明的语言描述问题所在，并交代清楚遇到该问题的场景，可附上截屏图片，微信团队会尽快处理你的反馈。
   */
  wx.config({
      debug: false,
      appId: '<%=PropertiesUtil.getAppContext("wxcrm.appid")%>',
      timestamp: '<%=timestamp%>',
      nonceStr: '<%=nonce_str%>',
      signature: '<%=signature%>',
      jsApiList: [
        'checkJsApi',
        'onMenuShareTimeline',
        'onMenuShareAppMessage',
        'onMenuShareQQ',
        'onMenuShareWeibo',
        'hideMenuItems',
        'showMenuItems',
        'hideAllNonBaseMenuItem',
        'showAllNonBaseMenuItem',
        'translateVoice',
        'startRecord',
        'stopRecord',
        'onRecordEnd',
        'playVoice',
        'pauseVoice',
        'stopVoice',
        'uploadVoice',
        'downloadVoice',
        'chooseImage',
        'previewImage',
        'uploadImage',
        'downloadImage',
        'getNetworkType',
        'openLocation',
        'getLocation',
        'hideOptionMenu',
        'showOptionMenu',
        'closeWindow',
        'scanQRCode',
        'chooseWXPay',
        'openProductSpecificView',
        'addCard',
        'chooseCard',
        'openCard'
      ]
  });

  //1 判断当前版本是否支持指定 JS 接口，支持批量判断
  function wxjs_checkJsApi(jslist){
	  if(!jslist) jslist = [];
	  wx.checkJsApi({
	      jsApiList: jslist,
	      success: function (res) {
	         return JSON.stringify(res);
	      }
      });
  }
  
  //2. 分享接口
  // 2.1 监听“分享给朋友”，按钮点击、自定义分享内容及分享结果接口
  function wxjs_onMenuShareAppMessage(s){
	  if(!s) s = {};
	  var shareData = {
		    title: s.title || '指尖微客',
		    desc: s.desc || '分享给朋友',
		    link: s.link || window.location.href,
		    imgUrl: s.imgUrl || 'http://mmbiz.qpic.cn/mmbiz/icTdbqWNOwNRt8Qia4lv7k3M9J1SKqKCImxJCt7j9rHYicKDI45jRPBxdzdyREWnk0ia0N5TMnMfth7SdxtzMvVgXg/0',
		    trigger: function (res) {
		        //alert('用户点击发送给朋友');
		    },
		    success: function (res) {
		    	if(s.success) s.success.call(res);
		        //alert('已分享');
		        //记录操作
		        var dataObj = [];
		        dataObj.push({name:"type",value:"friend"});
		        dataObj.push({name:"url",value:s.link});
		        $.ajax({
					url : '<%=wxjs%>/plat/add',			
			        data: dataObj,
				    success: function(data){
						//
				    }
			    });
		    },
		    cancel: function (res) {
		        //alert('已取消');
		    },
		    fail: function (res) {
		        //alert(JSON.stringify(res));
		    }
	  };
	  wx.onMenuShareAppMessage(shareData);
  }
  
  //2.2 监听“分享到朋友圈”按钮点击、自定义分享内容及分享结果接口
  function wxjs_onMenuShareTimeline(s){
	  if(!s) s = {};
	  var shareData = {
			title: s.title || '指尖威客',
			desc: s.desc || '分享到朋友圈”',
			link: s.link || window.location.href,
			imgUrl: s.imgUrl || 'http://mmbiz.qpic.cn/mmbiz/icTdbqWNOwNRt8Qia4lv7k3M9J1SKqKCImxJCt7j9rHYicKDI45jRPBxdzdyREWnk0ia0N5TMnMfth7SdxtzMvVgXg/0',
			trigger: function (res) {
		        //alert('用户点击发送给朋友');
		    },
		    success: function (res) {
		    	if(s.success) s.success.call(res);
		        //alert('已分享');
		    	//记录操作
		        var dataObj = [];
		        dataObj.push({name:"type",value:"timeline"});
		        dataObj.push({name:"url",value:s.link});
		        $.ajax({
		        	type: 'post',
					url : '<%=wxjs%>/plat/add',			
			        data: dataObj,
			        dataType: 'text',
				    success: function(data){
						//
				    }
			    });
		    },
		    cancel: function (res) {
		        //alert('已取消');
		    },
		    fail: function (res) {
		        //alert(JSON.stringify(res));
		    }
	  };
	  wx.onMenuShareTimeline(shareData);
  }
  
  //2.3 监听“分享到QQ”按钮点击、自定义分享内容及分享结果接口
  function wxjs_onMenuShareQQ(s){
	  if(!s) s = {};
	  var shareData = {
			title: s.title || '指尖威客',
			desc: s.desc || '分享到QQ',
			link: s.link || window.location.href,
			imgUrl: s.imgUrl || 'http://mmbiz.qpic.cn/mmbiz/icTdbqWNOwNRt8Qia4lv7k3M9J1SKqKCImxJCt7j9rHYicKDI45jRPBxdzdyREWnk0ia0N5TMnMfth7SdxtzMvVgXg/0',
			trigger: function (res) {
		        //alert('用户点击发送给朋友');
		    },
		    success: function (res) {
		        //alert('已分享');
		    },
		    cancel: function (res) {
		        //alert('已取消');
		    },
		    fail: function (res) {
		        //alert(JSON.stringify(res));
		    }
	  };
	  wx.onMenuShareQQ(shareData);
  }
  
  //2.4 监听“分享到微博”按钮点击、自定义分享内容及分享结果接口
  function wxjs_onMenuShareWeibo(s){
	  if(!s) s = {};
	  var shareData = {
			title: s.title || '指尖威客',
			desc: s.desc || '分享到微博',
			link: s.link || window.location.href,
			imgUrl: s.imgUrl || 'http://mmbiz.qpic.cn/mmbiz/icTdbqWNOwNRt8Qia4lv7k3M9J1SKqKCImxJCt7j9rHYicKDI45jRPBxdzdyREWnk0ia0N5TMnMfth7SdxtzMvVgXg/0',
			trigger: function (res) {
		        //alert('用户点击发送给朋友');
		    },
		    success: function (res) {
		        //alert('已分享');
		    },
		    cancel: function (res) {
		        //alert('已取消');
		    },
		    fail: function (res) {
		        //alert(JSON.stringify(res));
		    }
	  };
	  wx.onMenuShareWeibo(shareData);
  }
  
  //初始化分享 对于老版本的微信不让它分享
  function wxjs_initMenuShare(setting){
	  var rst = wxjs_checkJsApi(['onMenuShareAppMessage']);
	  if(rst && rst.checkResult && !rst.checkResult.onMenuShareTimeline){
		  wxjs_hideOptionMenu();
	  } else{
		  //如果存在局部隐藏标志 则不需要调用隐藏按钮
		  if(!setting.partyhideflag){
			  wxjs_hideMenuItems([
                    'menuItem:copyUrl',//复制链接:
	      			'menuItem:favorite',//收藏:
	      			'menuItem:share:facebook',//分享到FB:
	      			'menuItem:jsDebug',//调试:
	      			'menuItem:editTag',//编辑标签: 
	      			'menuItem:delete',//删除: 
	      			'menuItem:originPage',//原网页:
	      			'menuItem:share:email',//邮件:
	      			'menuItem:share:brand'//一些特殊公众号:           
         	   ]);
		  }
		  wxjs_hideMenuItems([
     		'menuItem:openWithQQBrowser',//在QQ浏览器中打开:
     		'menuItem:openWithSafari'//在Safari中打开:
       	  ]);
		  wxjs_showOptionMenu();
		  wxjs_onMenuShareAppMessage(setting);
		  wxjs_onMenuShareTimeline(setting);
		  wxjs_onMenuShareQQ(setting);
	  }
  }
  
  //3 智能接口
  //3.1 识别音频并返回识别结果
  function wxjs_translateVoice(voice){
    if (voice.localId == '') {
      alert('请先使用 startRecord 接口录制一段声音');
      return;
    }
    wx.translateVoice({
      localId: voice.localId,
      complete: function (res) {
        if (res.hasOwnProperty('translateResult')) {
          //alert('识别结果：' + res.translateResult);
        } else {
          //alert('无法识别');
        }
      }
    });
  }
  
  //4 音频接口
  //4.2 开始录音
  function wxjs_startRecord(){
	  wx.startRecord({
	      cancel: function () {
	        alert('用户拒绝授权录音');
	      }
	  });
  }
  
  //4.3 停止录音
  function wxjs_stopRecord(){
    var voice = {
      localId: '',
      serverId: ''
    };
    wx.stopRecord({
      success: function (res) {
        voice.localId = res.localId;
      },
      fail: function (res) {
        //alert(JSON.stringify(res));
      }
    });
  }
  
  //4.4 监听录音自动停止
  function wxjs_onVoiceRecordEnd(){
      var voice = {
 	     localId: '',
 	     serverId: ''
 	  };
	  wx.onVoiceRecordEnd({
	    complete: function (res) {
	      voice.localId = res.localId;
	      //alert('录音时间已超过一分钟');
	    }
	  });
  }
  
  //4.5 播放音频
  function wxjs_playVoice(voice){
      if (voice.localId == '') {
        alert('请先使用 startRecord 接口录制一段声音');
        return;
      }
      wx.playVoice({
        localId: voice.localId
      });
  }
  
  //4.6 暂停播放音频
  function wxjs_pauseVoice(voice){
	  wx.pauseVoice({
	     localId: voice.localId
	  });
  }
  
  // 4.7 停止播放音频
  function wxjs_stopVoice(voice){
	  wx.stopVoice({
	    localId: voice.localId
	  });
  }
  
  //4.8 监听录音播放停止
  function wxjs_onVoicePlayEnd(){
	  wx.onVoicePlayEnd({
	    complete: function (res) {
	      //alert('录音（' + res.localId + '）播放结束');
	    }
	  });
  }
  
  //4.8 上传语音
  function wxjs_uploadVoice(voice){
	    if (voice.localId == '') {
	      alert('请先使用 startRecord 接口录制一段声音');
	      return;
	    }
	    wx.uploadVoice({
	      localId: voice.localId,
	      success: function (res) {
	        //alert('上传语音成功，serverId 为' + res.serverId);
	        voice.serverId = res.serverId;
	      }
	    });
  }
  
  //4.9 下载语音
  function wxjs_downloadVoice(voice){
	    if (voice.serverId == '') {
	      alert('请先使用 uploadVoice 上传声音');
	      return;
	    }
	    wx.downloadVoice({
	      serverId: voice.serverId,
	      success: function (res) {
	        //alert('下载语音成功，localId 为' + res.localId);
	        voice.localId = res.localId;
	      }
	    });
  }
  
  // 5 图片接口
  // 5.1 拍照、本地选图
  var images = {
	    localId: [],
	    serverId: []
  };
  function wxjs_chooseImage(setting){
	   if(!setting) setting = {};
	    wx.chooseImage({
	      success: function (res) {
	    	images.localId = res.localIds;
	    	if(setting.success){
	      		setting.success(res);
	      	}
	        
	        //alert('已选择 ' + res.localIds.length + ' 张图片');
	      }
	    });
  }
  
  //5.2 图片预览
  function wxjs_previewImage(curr_url,urls){
	   if(!curr_url){
		   return;
	   }
	    wx.previewImage({
	      current: curr_url,
	      urls: urls
	    });
  }
  
  //5.3 上传图片
  function wxjs_uploadImage(setting){
	    if(!setting) setting = {};
	    if (images.localId.length == 0) {
	      alert('请先使用 chooseImage 接口选择图片');
	      return;
	    }
	    var i = 0, length = images.localId.length;
	    images.serverId = [];

	    upload(i,length,setting);
  }
  
  function upload(i,length,setting) {
	  //alert(i);
      wx.uploadImage({
	        localId: images.localId[i],
	        success: function (res) {
	          //images.serverId.push(res.serverId);
	        	
	          i++;
	          //alert('已上传：' + i + '/' + length);
	          images.serverId.push(res.serverId);
	          if (i < length) {
	             upload(i,length,setting);
	          }else{
	        	  if(setting.success){
		        	 setting.success(images);
		          } 
	          }
	        },
	        fail: function (res) {
	          alert(JSON.stringify(res));
	        }
       });
  }
  
  //5.4 下载图片
  function wxjs_downloadImage(){
	    if (images.serverId.length === 0) {
	      alert('请先使用 uploadImage 上传图片');
	      return;
	    }
	    var i = 0, length = images.serverId.length;
	    images.localId = [];
	    
	    wx.downloadImage({
	        serverId: images.serverId[i],
	        success: function (res) {
	          i++;
	          //alert('已下载：' + i + '/' + length);
	          images.localId.push(res.localId);
	          if (i < length) {
	            //download();
	          }
	        }
	    });
  }
  
  //6 设备信息接口
  // 6.1 获取当前网络状态
  function wxjs_getNetworkType(){
	    wx.getNetworkType({
	      success: function (res) {
	        //alert(res.networkType);
	      },
	      fail: function (res) {
	        //alert(JSON.stringify(res));
	      }
	    });
  }
  
  // 7 地理位置接口
  // 7.1 查看地理位置
  function wxjs_openLocation(setting){
	  if(!setting) setting = {};
	  var opt = {
	      latitude: setting.lat || 23.099994,
	      longitude: setting.lon || 113.324520,
	      name: setting.name || 'TIT 创意园',
	      address: setting.addr || '广州市海珠区新港中路 397 号',
	      scale: setting.scale || 14,
	      infoUrl: setting.infoUrl || 'http://weixin.qq.com'
	  };
	  wx.openLocation(opt);
  }
  
  //7.2 获取当前地理位置
  function wxjs_getLocation(setting){
	  if(!setting) setting = {};
	  wx.getLocation({
	      success: function (res) {
	    	if(setting.success){
	    		setting.success(res);
	    	}
	      },
	      cancel: function (res) {
	        //alert('用户拒绝授权获取地理位置');
	      }
	  });
  }
  
  // 8 界面操作接口
  // 8.1 隐藏右上角菜单
  function wxjs_hideOptionMenu(){
	  wx.hideOptionMenu();
  }
  
  //8.2 显示右上角菜单
  function wxjs_showOptionMenu(){
	  wx.showOptionMenu();
  }
  
  //8.3 批量隐藏菜单项
  function wxjs_hideMenuItems(arr){
	  if(!arr) arr = [];
	  /* demo 
	  var arr = [
	    'menuItem:readMode', // 阅读模式
        'menuItem:share:timeline', // 分享到朋友圈
        'menuItem:copyUrl' // 复制链接
      ]; */
	  wx.hideMenuItems({
	      menuList: arr,
	      success: function (res) {
	        //alert('已隐藏“阅读模式”，“分享到朋友圈”，“复制链接”等按钮');
	      },
	      fail: function (res) {
	        //alert(JSON.stringify(res));
	      }
	  });
  }
  
  //8.3 批量隐藏菜单项
  function wxjs_hideAllMenuItems(){
	  var arr = [
		 'menuItem:exposeArticle',//举报:
		 'menuItem:setFont',//调整字体:
		 'menuItem:dayMode',//日间模式:
		 'menuItem:nightMode',//夜间模式:
		 'menuItem:refresh',//刷新:
		 'menuItem:profile',//查看公众号（已添加）:
		 'menuItem:addContact',//查看公众号（未添加）:
		 'menuItem:share:appMessage',//发送给朋友:
		 'menuItem:share:timeline',//分享到朋友圈:
		 'menuItem:share:qq',//分享到QQ:
		 'menuItem:share:weiboApp',//分享到Weibo:
		 'menuItem:favorite',//收藏:
		 'menuItem:share:facebook',//分享到FB:
		 'menuItem:jsDebug',//调试:
		 'menuItem:editTag',//编辑标签: 
		 'menuItem:delete',//删除: 
		 'menuItem:copyUrl',//复制链接:
		 'menuItem:originPage',//原网页: 
		 'menuItem:readMode',//阅读模式:
		 'menuItem:openWithQQBrowser',//在QQ浏览器中打开:
		 'menuItem:openWithSafari',//在Safari中打开:
		 'menuItem:share:email',//邮件:
		 'menuItem:share:brand'//一些特殊公众号:
      ];
	  wx.hideMenuItems({
	      menuList: arr,
	      success: function (res) {
	        //alert('已隐藏所有按钮');
	      },
	      fail: function (res) {
	    	  return JSON.stringify(res);
	      }
	  });
  }
  
  //8.4 批量显示菜单项
  function wxjs_showMenuItems(arr){
	  if(!arr) arr = [];
	  /* demo 
	  var arr = [
	    'menuItem:readMode', // 阅读模式
        'menuItem:share:timeline', // 分享到朋友圈
        'menuItem:copyUrl' // 复制链接
      ]; */
	  wx.showMenuItems({
	      menuList: arr,
	      success: function (res) {
	        //alert('已显示“阅读模式”，“分享到朋友圈”，“复制链接”等按钮');
	      },
	      fail: function (res) {
	        //alert(JSON.stringify(res));
	      }
	  });
  }
  
  //8.5 隐藏所有非基本菜单项
  function wxjs_hideAllNonBaseMenuItem(){
	  wx.hideAllNonBaseMenuItem({
	      success: function () {
	        //alert('已隐藏所有非基本菜单项');
	      }
	  });
  }
  
  //8.6 显示所有被隐藏的非基本菜单项
  function wxjs_showAllNonBaseMenuItem(){
	  wx.showAllNonBaseMenuItem({
	      success: function () {
	        //alert('已显示所有非基本菜单项');
	      }
	  });
  }
  
  //8.7 关闭当前窗口
  function wxjs_closeWindow(){
	  wx.closeWindow();
  }
  
  // 9 微信原生接口
  // 9.1.1 扫描二维码并返回结果
  function wxjs_scanQRCode0(){
	  wx.scanQRCode({
	      desc: 'scanQRCode desc'
	  });
  }
  
  //9.1.2 扫描二维码并返回结果
  function wxjs_scanQRCode1(){
	  wx.scanQRCode({
	      needResult: 1,
	      desc: 'scanQRCode desc',
	      success: function (res) {
	        return JSON.stringify(res);
	      }
	  });
  }
  
  // 10 微信支付接口
  // 10.1 发起一个支付请求
  function wxjs_chooseWXPay(){
	  wx.chooseWXPay({
	      timestamp: 1414723227,
	      nonceStr: 'noncestr',
	      package: 'addition=action_id%3dgaby1234%26limit_pay%3d&bank_type=WX&body=innertest&fee_type=1&input_charset=GBK&notify_url=http%3A%2F%2F120.204.206.246%2Fcgi-bin%2Fmmsupport-bin%2Fnotifypay&out_trade_no=1414723227818375338&partner=1900000109&spbill_create_ip=127.0.0.1&total_fee=1&sign=432B647FE95C7BF73BCD177CEECBEF8D',
	      paySign: 'bd5b1933cda6e9548862944836a9b52e8c9a2b69'
	  });
  }
  
  //11.3  跳转微信商品页
  function wxjs_openProductSpecificView(){
	  wx.openProductSpecificView({
	      productId: 'pDF3iY_m2M7EQ5EKKKWd95kAxfNw'
	  });
  }
  
  // 12 微信卡券接口
  // 12.1 添加卡券
  function wxjs_addCard(){
	  wx.addCard({
	      cardList: [
	        {
	          cardId: 'pDF3iY9tv9zCGCj4jTXFOo1DxHdo',
	          cardExt: '{"code": "", "openid": "", "timestamp": "1418301401", "signature":"64e6a7cc85c6e84b726f2d1cbef1b36e9b0f9750"}'
	        },
	        {
	          cardId: 'pDF3iY9tv9zCGCj4jTXFOo1DxHdo',
	          cardExt: '{"code": "", "openid": "", "timestamp": "1418301401", "signature":"64e6a7cc85c6e84b726f2d1cbef1b36e9b0f9750"}'
	        }
	      ],
	      success: function (res) {
	        //alert('已添加卡券：' + JSON.stringify(res.cardList));
	      }
	  });
  }
  
  //12.2 选择卡券
  function wxjs_chooseCard(){
	  wx.chooseCard({
	      cardSign: '97e9c5e58aab3bdf6fd6150e599d7e5806e5cb91',
	      timestamp: 1417504553,
	      nonceStr: 'k0hGdSXKZEj3Min5',
	      success: function (res) {
	        //alert('已选择卡券：' + JSON.stringify(res.cardList));
	      }
	  });
  }
  
  //12.3 查看卡券
  function wxjs_openCard(){
	  wx.openCard({
	      cardList: []
	  });
  }
  
  wx.error(function (res) {
	  //alert(res.errMsg);
  });

</script>