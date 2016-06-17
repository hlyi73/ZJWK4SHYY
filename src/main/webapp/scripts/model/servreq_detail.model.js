/**
 * 服务请求详情 
 */
function ivk_hideflootermenu(){
	serveq_detail.flootermenu.addClass("modal");
}
function ivk_showflootermenu(){
	serveq_detail.flootermenu.removeClass("modal");
}

var serveq_detail = {};
    
function initServeReqElem(){
	serveq_detail.serveq_nav = $(".serveq_nav");
	serveq_detail.servreq_detail_con = $("#servreq_detail_con");
	serveq_detail.flootermenu = $("#flootermenu");
	
	serveq_detail.msg_con = serveq_detail.flootermenu.find(".msg_container");
	serveq_detail.add_container = serveq_detail.flootermenu.find(".add_container");
	
	serveq_detail.msg_model_type = serveq_detail.msg_con.find("input[name=msg_model_type]");
	serveq_detail.msg_type = serveq_detail.msg_con.find("input[name=msg_type]");//消息类型
    serveq_detail.input_msg = serveq_detail.msg_con.find("input[name=input_msg]");//输入的文本框
    serveq_detail.target_uid = serveq_detail.msg_con.find("input[name=target_uid]");//目标用户ID
    serveq_detail.target_uname = serveq_detail.msg_con.find("input[name=target_uname]");//目标用户名
    serveq_detail.sub_relaid = serveq_detail.msg_con.find("input[name=sub_relaid]");//子关联ID
    serveq_detail.examiner_send = serveq_detail.msg_con.find(".examiner_send");//发送按钮
    serveq_detail.add_btn = serveq_detail.msg_con.find(".add_btn");//跟进按钮
    
    serveq_detail.baseinfo_con = serveq_detail.servreq_detail_con.find(".baseinfo_con");
    serveq_detail.count_con = serveq_detail.servreq_detail_con.find(".count_con");
    serveq_detail.status_list_con = serveq_detail.servreq_detail_con.find(".status_list_con");
    serveq_detail.status_list_gobak = serveq_detail.servreq_detail_con.find(".status_list_gobak");
    serveq_detail.status_list_href = serveq_detail.servreq_detail_con.find(".status_list_href");
    serveq_detail.status_list_btn = serveq_detail.servreq_detail_con.find(".status_list_btn");
    serveq_detail.status_save_btn = serveq_detail.status_list_btn.find(".save");
    serveq_detail.status_cannel_btn = serveq_detail.status_list_btn.find(".cannel");
    
    //count
    serveq_detail.exec_count = $("#exec_count");
    serveq_detail.visit_count = $("#visit_count");
    serveq_detail.attach_count = $("#attach_count");
    serveq_detail.task_count = $("#task_count");
    
    //geng jing
    serveq_detail.servpatch_add_btn = serveq_detail.add_container.find(".servpatch_add_btn");//服务派工
    serveq_detail.exec_add_btn = serveq_detail.add_container.find(".exec_add_btn");//服务执行
    serveq_detail.servisit_add_btn = serveq_detail.add_container.find(".servisit_add_btn");//服务回访
    serveq_detail.servstatus_add_btn = serveq_detail.add_container.find(".servstatus_add_btn");//更新状态
    serveq_detail.task_add_btn = serveq_detail.add_container.find(".task_add_btn");//任务
}

//底部操作按钮区域
function initServeReqBtn(){
	//跟进按钮
	serveq_detail.add_btn.click(function(){
		if(!$(this).hasClass("showAddCon")){
			$(this).addClass("showAddCon");
			serveq_detail.add_container.animate({height :100}, [ 1000 ]);
			serveq_detail.flootermenu.animate({height :300}, [ 1000 ]);
			$(this).html("<b>取消</b>");	
		}else{
			$(this).removeClass("showAddCon");
			serveq_detail.flootermenu.animate({height :51}, [ 1000 ]);
			serveq_detail.add_container.animate({height :0}, [ 1000 ]);
			$(this).html("<b>跟进</b>");
		}
	});
	
	//gengjing-> 任务 按钮
	serveq_detail.task_add_btn.click(function(){
		var params = "?publicId=" + serveq_detail.publicid +
					"&openId=" + serveq_detail.openid +
					"&parentId=" + serveq_detail.parentid +
					"&parentType=Cases" +
					"&flag=other" +
					"&parentName=" + serveq_detail.parentname;
		
		window.location.href = getContentPath() + "/schedule/get" + params;
	});
	
	//gengjing-> 服务派工 按钮
	serveq_detail.servpatch_add_btn.click(function(){
		if(serveq_detail.status === "Processed" || serveq_detail.status === "Closed"){
			ivk_show_txt_msg('状态为 [关闭] [已完成] 的服务,不能再执行派工');
			return;
		}
		//调用公共方法接口 隐藏区域
		ivk_showSysuserList();
		ivk_hideTrackhisList();
		ivk_hideflootermenu();
		ivk_hideTeamList();
		ivk_hideMessageList();
		ivk_hideMenuBar();
		serveq_detail.serveq_nav.css("display", "none");
		serveq_detail.flootermenu.css("display", "none");
		serveq_detail.servreq_detail_con.css("display", "none");
		
	});
	
	//gengjing-> 服务执行 按钮
	serveq_detail.exec_add_btn.click(function(){
		var params = "?publicid=" + serveq_detail.publicid +
						"&openid=" + serveq_detail.openid +
						"&parentid=" + serveq_detail.parentid +
						"&parenttype=Cases" +
						"&flag=other" +
						"&parentname=" + serveq_detail.parentname;
						"&parenttype=" + serveq_detail.servertype;
		window.location.href = getContentPath() + "/complaint/getexec" + params;
	});
	//gengjing-> 服务回访 按钮
	serveq_detail.servisit_add_btn.click(function(){
		if(serveq_detail.status !== "Processed"){
			ivk_show_txt_msg('服务完成了 才能 进行 进行回访');
			return;
		}
		var params = "?publicid=" + serveq_detail.publicid +
						"&openid=" + serveq_detail.openid +
						"&parentid=" + serveq_detail.parentid +
						"&parenttype=Cases" +
						"&flag=other" +
						"&parentname=" + serveq_detail.parentname;
		window.location.href = getContentPath() + "/complaint/visit_choose" + params;
	});
	
	//gengjing-> 更新状态  按钮
	serveq_detail.servstatus_add_btn.click(function(){
		ivk_hideTrackhisList();
 	    ivk_hideflootermenu();
 	    ivk_hideTeamList();
 	    ivk_hideMessageList();
 	    serveq_detail.serveq_nav.css("display", "none");
 	    serveq_detail.baseinfo_con.css("display", "none");
 	    serveq_detail.count_con.css("display", "none");
 	    serveq_detail.status_list_con.removeClass("modal");
 	    
	});
	//a标签选择
	serveq_detail.status_list_href.find("a").click(function(){
		serveq_detail.status_list_href.find("a").removeClass("checked");
		$(this).addClass("checked");
	});
	//状态保存
	serveq_detail.status_save_btn.click(function(){
		var status = ''; 
		serveq_detail.status_list_href.find("a.checked").each(function(){
			status = $(this).find("h2").attr("key");
		});
		var obj = [];
    	obj.push({name:'openid', value:serveq_detail.openid});
	    obj.push({name:'publicid', value:serveq_detail.publicid});
	    obj.push({name:'crmid', value:serveq_detail.crmid});
	    obj.push({name:'rowid', value:serveq_detail.parentid});
		obj.push({name:'status', value:status });
		complaintStatusUpd(obj, function(){
			serveq_detail.status_cannel_btn.trigger("click");
			window.location.reload();
		});
	});
	//状态取消
	serveq_detail.status_cannel_btn.click(function(){
		/*ivk_showTrackhisList();
 	    ivk_showflootermenu();
 	    ivk_showTeamList();
 	    ivk_showMessageList();
 	    serveq_detail.serveq_nav.css("display", "");
 	    serveq_detail.baseinfo_con.css("display", "");
 	    serveq_detail.count_con.css("display", "");
 	    serveq_detail.status_list_con.addClass("modal");
 	    */window.location.reload();
	});
	//状态回退
	serveq_detail.status_list_gobak.click(function(){
		serveq_detail.status_cannel_btn.trigger("click");
	});
	
	//文本输入框点击事件
	serveq_detail.input_msg.unbind("keyup").bind("keyup", function(){//内容改变 、键盘输入完、 事件
		var v = $(this).val();
		if(v !== ''){
    		serveq_detail.examiner_send.css("display","");
    		serveq_detail.add_btn.css("display","none");
    	}else{
    		serveq_detail.examiner_send.css("display","none");
    		serveq_detail.add_btn.css("display","");
    	}
		//@ 某人
	    if(v && v.charAt(v.length-1) === "@"){
	    	ivk_showErtUsersList();
	    }else{
	    	ivk_hideErtUsersList();
	    }
	});
	
	//发送消息
	serveq_detail.examiner_send.unbind("click").bind("click", function(){
		 var sub_relaid = serveq_detail.sub_relaid.val();
		 var msg_type = serveq_detail.msg_type.val();
		 var input_msg = serveq_detail.input_msg.val();
		 var target_uid = serveq_detail.target_uid.val();
		 var target_uname = serveq_detail.target_uname.val();
		 if(sub_relaid){
			//发送消息
			 ivk_befSendTrackhisMsg();
		 }else{
			 sendMessage({
				 sub_relaid: sub_relaid,
				 msg_type: msg_type,
				 input_msg: input_msg,
				 target_uid: target_uid,
				 target_uname: target_uname
			 });
			 
			 serveq_detail.input_msg.attr("placeholder","回复  ").val('');
			 serveq_detail.target_uid.val('');
			 serveq_detail.target_uname.val('');
			 serveq_detail.sub_relaid.val('');
		 }
   		
   		 serveq_detail.add_btn.css('display','').html("<b>跟进</b>");
   		 serveq_detail.examiner_send.css("display","none");
		 serveq_detail.flootermenu.css("height",'51px');
   	});
}
function iniServeReqCount(){
	//执行 数量
	$.ajax({
		url: getContentPath() + '/complaint/asycn_serexeclist',
		data: {
			parentid: serveq_detail.parentid,
			openid: serveq_detail.openid,
			publicid: serveq_detail.publicid,
			currpage: '1',
			pagecount: '99999999'
		},
	    success: function(data){
	    	var obj  = JSON.parse(data);
	    	serveq_detail.exec_count.html(obj.length);
	    }
	});
	
	//回访
	$.ajax({
		url: getContentPath() + '/complaint/asycn_servisitlist',
		data: {
			parentid: serveq_detail.parentid,
			openid: serveq_detail.openid,
			publicid: serveq_detail.publicid,
			currpage: '1',
			pagecount: '99999999'
		},
	    success: function(data){
	    	var obj  = JSON.parse(data);
	    	serveq_detail.visit_count.html(obj.length);
	    }
	});
	
    //附件
	$.ajax({
		url: getContentPath() + '/attachment/asycnlist',
		data: {
			openId: serveq_detail.openid,
			publicId: serveq_detail.publicid,
			parentid: serveq_detail.parentid,
			parenttype: 'Cases'
		},
	    success: function(data){
	    	var obj  = JSON.parse(data);
	    	if(obj.errorCode && obj.errorCode !== '0'){
	    		serveq_detail.attach_count.html(0);
    		   return;
    		}
	    	serveq_detail.attach_count.html(obj.length);
	    }
	});
		
	//任务
	$.ajax({
		url: getContentPath() + '/schedule/alist',
		data: {
			parentId: serveq_detail.parentid,
			openId: serveq_detail.openid,
			publicId: serveq_detail.publicid
		},
	    success: function(data){
	    	var obj  = JSON.parse(data);
	    	if(obj.errorCode && obj.errorCode !== '0'){
	    		serveq_detail.task_count.html(0);
	    		return;
	    	}
	    	serveq_detail.task_count.html(obj.rowCount);
	    }
	});
}

//服务派工 以及状态变更
function complaintStatusUpd(params, callback){
	asyncInvoke({
		url: getContentPath() + '/complaint/complaint_status_upd',
		type: 'post',
		data: params,
	    callBackFunc: function(data){
	    	if(!data) return;
	    	var obj  = JSON.parse(data);
	    	if(obj.errorCode && obj.errorCode !== '0'){
	    		ivk_show_error_msg(obj);
	    	}else{
	    		if(callback) callback();
	    	}
	    }
	});
}

//Callback -> 调用接口之后 的回调方法  属于异步调用 非及时响应 
function callback_ertusers_selected(data){
	var txt = serveq_detail.input_msg.val();
	serveq_detail.input_msg.val(txt + data);
}

//Callback -> 调用接口之后 的回调方法  属于异步调用 非及时响应  点对点消息触发选择的回调方法
function callback_servreq_p2pmsg_seleted(data){
	serveq_detail.input_msg.attr("placeholder", "回复  " + data.op_name);
	serveq_detail.target_uid.val(data.op_id);
	serveq_detail.target_uname.val(data.op_name);
	serveq_detail.sub_relaid.val(data.sub_relaid);
}

//callback -> 服务派工 选择系统用户之后 点击 确定按钮 的回调函数 
function callback_system_ok_btn_click(ids, names){
	var obj = [];
	obj.push({name:'openid', value:serveq_detail.openid});
    obj.push({name:'publicid', value:serveq_detail.publicid});
    obj.push({name:'crmid', value:serveq_detail.crmid});
	obj.push({name:'rowid', value:serveq_detail.parentid});
	obj.push({name:'handle', value:ids});
		
	complaintStatusUpd(obj, function(){
		ivk_hideSysuserList();
 	    ivk_showTrackhisList();
 	    ivk_showflootermenu();
 	    ivk_showTeamList();
 	    ivk_showMessageList();
 	    ivk_showMenuBar();
 	    serveq_detail.serveq_nav.css("display", "none");
 	    serveq_detail.flootermenu.css("display", "");
	    serveq_detail.servreq_detail_con.css("display", "");
	});
}

//callback -> 服务派工   点击回退按钮 之后  的回调函数 
function callback_sysuser_gobak_btn_click(data){
	ivk_hideSysuserList();
    ivk_showTrackhisList();
    ivk_showflootermenu();
    ivk_showTeamList();
    ivk_showMessageList();
    ivk_showMenuBar();
    serveq_detail.serveq_nav.css("display", "");
    serveq_detail.flootermenu.css("display", "");
    serveq_detail.servreq_detail_con.css("display", "");
}

function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
};