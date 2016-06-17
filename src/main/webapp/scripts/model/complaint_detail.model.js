/**
 * 投诉请求详情 
 */
function ivk_hideflootermenu(){
	complaint_detail.flootermenu.addClass("modal");
}
function ivk_showflootermenu(){
	complaint_detail.flootermenu.removeClass("modal");
}

var complaint_detail = {};
    
function initComplaintElem(){
	complaint_detail.complaint_nav = $(".complaint_nav");
	complaint_detail.servreq_detail_con = $("#complaint_detail_con");
	complaint_detail.flootermenu = $("#flootermenu");
	
	complaint_detail.msg_con = complaint_detail.flootermenu.find(".msg_container");
	complaint_detail.add_container = complaint_detail.flootermenu.find(".add_container");
	
	complaint_detail.msg_model_type = complaint_detail.msg_con.find("input[name=msg_model_type]");
	complaint_detail.msg_type = complaint_detail.msg_con.find("input[name=msg_type]");//消息类型
    complaint_detail.input_msg = complaint_detail.msg_con.find("input[name=input_msg]");//输入的文本框
    complaint_detail.target_uid = complaint_detail.msg_con.find("input[name=target_uid]");//目标用户ID
    complaint_detail.target_uname = complaint_detail.msg_con.find("input[name=target_uname]");//目标用户名
    complaint_detail.sub_relaid = complaint_detail.msg_con.find("input[name=sub_relaid]");//子关联ID
    
    complaint_detail.examiner_send = complaint_detail.msg_con.find(".examiner_send");//发送按钮
    complaint_detail.add_btn = complaint_detail.msg_con.find(".add_btn");//跟进按钮
    
    complaint_detail.baseinfo_con = complaint_detail.servreq_detail_con.find(".baseinfo_con");
    complaint_detail.count_con = complaint_detail.servreq_detail_con.find(".count_con");
    complaint_detail.status_list_con = complaint_detail.servreq_detail_con.find(".status_list_con");
    complaint_detail.status_list_gobak = complaint_detail.servreq_detail_con.find(".status_list_gobak");
    complaint_detail.status_list_href = complaint_detail.servreq_detail_con.find(".status_list_href");
    complaint_detail.status_list_btn = complaint_detail.servreq_detail_con.find(".status_list_btn");
    complaint_detail.status_save_btn = complaint_detail.status_list_btn.find(".save");
    complaint_detail.status_cannel_btn = complaint_detail.status_list_btn.find(".cannel");
    
    //count
    complaint_detail.visit_count = $("#visit_count");
    complaint_detail.attach_count = $("#attach_count");
    complaint_detail.task_count = $("#task_count");
    
    //geng jing
    complaint_detail.servisit_add_btn = complaint_detail.add_container.find(".servisit_add_btn");//投诉回访
    complaint_detail.servstatus_add_btn = complaint_detail.add_container.find(".servstatus_add_btn");//更新状态
    complaint_detail.task_add_btn = complaint_detail.add_container.find(".task_add_btn");//任务
}

//底部操作按钮区域
function initComplaintBtn(){
	//跟进按钮
	complaint_detail.add_btn.click(function(){
		if(!$(this).hasClass("showAddCon")){
			$(this).addClass("showAddCon");
			complaint_detail.add_container.animate({height :100}, [ 1000 ]);
			complaint_detail.flootermenu.animate({height :200}, [ 1000 ]);
			$(this).html("<b>取消</b>");	
		}else{
			$(this).removeClass("showAddCon");
			complaint_detail.flootermenu.animate({height :51}, [ 1000 ]);
			complaint_detail.add_container.animate({height :0}, [ 1000 ]);
			$(this).html("<b>跟进</b>");
		}
	});
	
	//gengjing-> 任务 按钮
	complaint_detail.task_add_btn.click(function(){
		var params = "?publicId=" + complaint_detail.publicid +
					"&openId=" + complaint_detail.openid +
					"&parentId=" + complaint_detail.parentid +
					"&parentType=complaint" +
					"&flag=other" +
					"&parentName=" + complaint_detail.parentname;
		window.location.href = getContentPath() + "/schedule/get" + params;
	});
	//gengjing-> 投诉回访 按钮
	complaint_detail.servisit_add_btn.click(function(){
		var params = "?publicid=" + complaint_detail.publicid +
					"&openid=" + complaint_detail.openid +
					"&parentid=" + complaint_detail.parentid +
					"&parenttype=Cases" +
					"&flag=other" +
					"&parentname=" + complaint_detail.parentname;
		window.location.href = getContentPath() + "/complaint/getvisit_tousu" + params;
	});
	//gengjing-> 更新状态  按钮
	complaint_detail.servstatus_add_btn.click(function(){
		ivk_hideTrackhisList();
 	    ivk_hideflootermenu();
 	    ivk_hideTeamList();
 	    ivk_hideMessageList();
 	    complaint_detail.complaint_nav.css("display", "none");
 	    complaint_detail.baseinfo_con.css("display", "none");
 	    complaint_detail.count_con.css("display", "none");
 	    complaint_detail.status_list_con.removeClass("modal");
	});
	//a标签选择
	complaint_detail.status_list_href.find("a").click(function(){
		complaint_detail.status_list_href.find("a").removeClass("checked");
		$(this).addClass("checked");
	});
	//状态保存
	complaint_detail.status_save_btn.click(function(){
		var status = ''; 
		complaint_detail.status_list_href.find("a.checked").each(function(){
			status = $(this).find("h2").attr("key");
		});
		var obj = [];
    	obj.push({name:'openid', value:complaint_detail.openid});
	    obj.push({name:'publicid', value:complaint_detail.publicid});
	    obj.push({name:'crmid', value:complaint_detail.crmid});
	    obj.push({name:'rowid', value:complaint_detail.parentid});
		obj.push({name:'status', value:status });
		complaintStatusUpd(obj, function(){
			complaint_detail.status_cannel_btn.trigger("click");
		});
	});
	//状态取消
	complaint_detail.status_cannel_btn.click(function(){
//		ivk_showTrackhisList();
// 	    ivk_showflootermenu();
// 	    ivk_showTeamList();
// 	    ivk_showMessageList();
// 	    complaint_detail.complaint_nav.css("display", "");
// 	    complaint_detail.baseinfo_con.css("display", "");
// 	    complaint_detail.count_con.css("display", "");
// 	    complaint_detail.status_list_con.css("display", "none");
		window.location.reload();
	});
	//状态回退
	complaint_detail.status_list_gobak.click(function(){
		complaint_detail.status_cannel_btn.trigger("click");
	});
	
	//文本输入框点击事件
	complaint_detail.input_msg.unbind("keyup").bind("keyup", function(){//内容改变 、键盘输入完、 事件
		var v = $(this).val();
		if(v !== ''){
    		complaint_detail.examiner_send.css("display","");
    		complaint_detail.add_btn.css("display","none");
    	}else{
    		complaint_detail.examiner_send.css("display","none");
    		complaint_detail.add_btn.css("display","");
    	}
		//@ 某人
	    if(v && v.charAt(v.length-1) === "@"){
	    	ivk_showErtUsersList();
	    }else{
	    	ivk_hideErtUsersList();
	    }
	});
	
	//发送消息
	complaint_detail.examiner_send.unbind("click").bind("click", function(){
		 var sub_relaid = complaint_detail.sub_relaid.val();
		 var msg_type = complaint_detail.msg_type.val();
		 var input_msg = complaint_detail.input_msg.val();
		 var target_uid = complaint_detail.target_uid.val();
		 var target_uname = complaint_detail.target_uname.val();
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
			 
			 complaint_detail.input_msg.attr("placeholder","回复  ").val('');
			 complaint_detail.target_uid.val('');
			 complaint_detail.target_uname.val('');
			 complaint_detail.sub_relaid.val('');
		 }
   		
   		 complaint_detail.add_btn.css('display','').html("<b>跟进</b>");
   		 complaint_detail.examiner_send.css("display","none");
		 complaint_detail.flootermenu.css("height",'51px');
   	});
}

//初始化业务机会关联下的任务,联系人,合作伙伴,竞争对手
function iniComplaintCount(){
	//回访
	$.ajax({
		url: getContentPath() + '/complaint/asycn_servisitlist',
		data: {
			parentid: complaint_detail.parentid,
			openid: complaint_detail.openid,
			publicid: complaint_detail.publicid,
			currpage: '1',
			pagecount: '99999999'
		},
	    success: function(data){
	    	var obj  = JSON.parse(data);
	    	complaint_detail.visit_count.html(obj.length);
	    }
	});
	
    //附件
	$.ajax({
		url: getContentPath() + '/attachment/asycnlist',
		data: {
			openId: complaint_detail.openid,
			publicId: complaint_detail.publicid,
			parentid: complaint_detail.parentid,
			parenttype: 'Cases'
		},
	    success: function(data){
	    	var obj  = JSON.parse(data);
	    	if(obj.errorCode && obj.errorCode !== '0'){
	    		complaint_detail.attach_count.html(0);
    		   return;
    		}
	    	complaint_detail.attach_count.html(obj.length);
	    }
	});
		
	//任务
	$.ajax({
		url: getContentPath() + '/schedule/alist',
		data: {
			parentId: complaint_detail.parentid,
			openId: complaint_detail.openid,
			publicId: complaint_detail.publicid
		},
	    success: function(data){
	    	var obj  = JSON.parse(data);
	    	if(obj.errorCode && obj.errorCode !== '0'){
	    		complaint_detail.task_count.html(0);
	    		return;
	    	}
	    	complaint_detail.task_count.html(obj.rowCount);
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
	var txt = complaint_detail.input_msg.val();
	complaint_detail.input_msg.val(txt + data);
}

//Callback -> 调用接口之后 的回调方法  属于异步调用 非及时响应  点对点消息触发选择的回调方法
function callback_complaint_p2pmsg_seleted(data){
	complaint_detail.input_msg.attr("placeholder", "回复  " + data.op_name);
	complaint_detail.target_uid.val(data.op_id);
	complaint_detail.target_uname.val(data.op_name);
	complaint_detail.sub_relaid.val(data.sub_relaid);
}

function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}
