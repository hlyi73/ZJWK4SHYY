//消息图片处理
function zjwk_upload_img(msgid,divid,modeltype){
	wx.ready(function () {
		 wxjs_chooseImage({
			  success: function(res){
				 wxjs_uploadImage({
					 success: function(images){
						 var localids = images.localId;
						 var serverids = images.serverId;
						 var v = "";
						 for(var i=0;i<localids.length;i++){
							 v += "<img style='margin:2px;' class='messages_imgs_list' onclick='zjwk_prev_img(\"messages_imgs_list\",this)' src='"+localids[i]+"' style='width:64px;height:64px;'>";
						 }
						 addSingleMsg('${crmId}', '我', dateFormat(new Date(), "MM-dd hh:mm"),v, "desc");
						 //如果成功
						 //保存消息
						 //下载图片到本地服务器
						 sendCustomerMsg({v:serverids, tuid:p.targetUId.val(), 
			  				  tuname: p.targetUName.val(), subRelaId: p.subRelaId.val(),msgType:'img',appendflag:'no'});
					 }
				 });
			  }
		  });
	  });
}

//消息图片处理
function zjwk_resource_upload_img(divObj,imgContent){
	wx.ready(function () {
		 wxjs_chooseImage({
			  success: function(res){
				 wxjs_uploadImage({
					 success: function(images){
						 var localids = images.localId;
						 var serverids = images.serverId;
						 var v = "";
						 for(var i=0;i<localids.length;i++){
							 v += '<img style="margin:2px;" class="messages_imgs_list" onclick="zjwk_prev_img(\"messages_imgs_list\",this)" src="'+localids[i]+'" width="64px;" height="64px" style="float:left;width:64px;height:64px;">';
						 }
						 if(divObj){
							 divObj.before(v);
						 }
						 if(imgContent){
							 imgContent.val(serverids);
						 }
					 }
				 });
			  }
		  });
	  });
}

//从微信服务器上下载文件
function download4WXServer(req,setting){
	if(!setting) setting = {};
	var res = {
		status :[]
	};
	$.ajax({
		type: 'post',
		url : getContentPath()+'/files/down4wx',			
        data: {
        	serverids:req.imgids,
        	relaid:req.relaId,
        	relatype:req.relaType,
        	filetype:req.fileType
        },
        dataType: 'text',
	    success: function(data){
	    	if(data && data == 'success'){
		    	if(setting.success){
		    		res.status = 'success';
		      		setting.success(res);
		      	}
	    	}else{
	    		alert("上传文件失败！");
	    	}
	    },
	    error:function(){
	    	if(setting.success){
	    		res.status = 'error';
	      		setting.success(res);
	      	}
	    }
	});
}


//从微信服务器上下载文件
function download4WXToOss(req,setting){
	if(!setting) setting = {};
	var res = {
		status :[]
	};
	$.ajax({
		type: 'post',
		url : getContentPath()+'/files/down4wxToOss',			
      data: {
      	serverids:req.imgids,
      	relaid:req.relaId,
      	relatype:req.relaType,
      	filetype:req.fileType
      },
      dataType: 'text',
	    success: function(data){
	    	if(data && data == 'success'){
		    	if(setting.success){
		    		res.status = 'success';
		      		setting.success(res);
		      	}
	    	}else{
	    		alert("上传文件失败！");
	    	}
	    },
	    error:function(){
	    	if(setting.success){
	    		res.status = 'error';
	      		setting.success(res);
	      	}
	    }
	});
}


//预览图片
function zjwk_prev_img(classid,obj){
	var curr_url = "";
	var urls = [];
	if(obj){
		curr_url = $(obj).attr("filepath")+"/source_"+$(obj).attr("filename");
	}
	
	$("."+classid).each(function(){
		if($(this).attr("src")){
			urls.push($(this).attr("filepath")+"/source_"+$(this).attr("filename"));
		}
	});
	
	if(curr_url){
		wxjs_previewImage(curr_url,urls);
	}
}


//开始录音
function zjwk_start_record(msgid,divid,modeltype){
	var height = ($(window).height()-50)/2;
	var width = ($(window).width()-100)/2;
	var audio_div = "<div class='audio_operation_div' style='z-index:999999;background-color:#555;opacity:0.8;position:fixed;top:0px;height:100%;width:100%;'>"
			+"<input type='button' value='停止' onclick='zjwk_stop_record()' style='posotion:fixed;opacity:1;width:100px;hieght:50px;line-height:50px;background-color:RGB(75, 192, 171);color:#fff;margin-top:"+height+"px;margin-left:"+width+"px;border-radius:5px;'>"
			+"</div>";
	$("body").append(audio_div);
	wx.ready(function () {
		wxjs_startRecord();
	});
}

/**
 * 停止录音
 * @param msgid
 * @param divid
 * @param modeltype
 */
function zjwk_stop_record(msgid,divid,modeltype){
	if($(".audio_operation_div")){
		$(".audio_operation_div").remove();
	}
	wxjs_stopRecord({
		success: function(res){
			wxjs_playVoice(res);
		}
	});
}


function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}
