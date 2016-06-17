/**
 * 系统用户
 */
//对外提供的调用方法 隐藏 跟进历史 列表
function ivk_hideTrackhisList(){
	trackhis.trackhis_con.addClass("modal");
	trackhis.trackhis_title.addClass("modal");
}
//对外提供的调用方法 显示 跟进历史 列表
function ivk_showTrackhisList(){
	trackhis.trackhis_con.removeClass("modal");
	trackhis.trackhis_title.removeClass("modal");
}

//ivk 对外提供的接口, 发送点对点消息前 追加消息
function ivk_befSendTrackhisMsg(){
	
	var dateStr = dateFormat(new Date(), "MM-dd hh:mm");
	
	var html = trackhisMsgTemp(msgsenduserid, p.subRelaId.val(), p.targetUId.val(), msgsendusername,
			                    p.targetUName.val(), p.inputTxt.val(), true);
	//点击某一个子项目
	var parObj = $("ul.trackhisReplayRst > li[selectThis=true]").parent();
	var fstli = parObj.find("li:eq(0)");
	if(fstli && fstli.length > 0){
		$(html).insertBefore(fstli);
	}else{
		parObj.find("ul").css("display","").append(html);
	}
	//点击一个业务机会跟进大项目
	var parObj2 = $(".trackhisReplayCon[selectThis=true]").parent();
	var fstli2 = parObj2.find("ul > li:eq(0)");
	if(fstli2 && fstli2.length > 0){
		$(html).insertBefore(fstli2);
	}else{
		parObj2.find("ul.trackhisReplayRst").css("display","").append(html);
	}
	//初始化
	initTrackhisEvent();
	
}

var trackhis = {};

function initTrackhisElem(){
	trackhis.trackhis_title = $(".trackhis_title");
	trackhis.trackhis_con = $(".trackhis_container");
}

function initTrackhisEvent(){
	//点击业务机会跟进 外层容器
	$(".trackhisReplayCon").unbind("click").bind("click", function(){
	   var i = $(this).attr("opid"),
	       n = $(this).attr("opname"),
	       r = $(this).attr("subRelaId");
	   //回调注册的方法
	   eval(trackhis.callback_p2pmsg_seleted + '(' + {op_id:i, op_name: n, sub_relaid: r} +')');
	   
	   //删除选择属性
	   $(".trackhisReplayCon").removeAttr("selectThis");
	   $("ul.trackhisReplayRst > li").removeAttr("selectThis");
	   $(this).attr("selectThis","true");
	   
	}); 
	    
	//点击业务机会跟进  里层容器
	$("ul.opptyReplayRst > li").unbind("click").bind("click", function(){
	   var n = $(this).find("a").html(),
	       i = $(this).find(":hidden[name=opid]").val(),
	       r = $(this).find(":hidden[name=subRelaId]").val();
	   //回调注册的方法
	   eval(trackhis.callback_p2pmsg_seleted + '(' + {op_id:i, op_name: n, sub_relaid: r} + ')');
	   
	   //删除选择属性
	   $(".trackhisReplayCon").removeAttr("selectThis");
	   $("ul.trackhisReplayRst > li").removeAttr("selectThis");
	   $(this).attr("selectThis","true");
	   
	});
}

function loadTrackhisList(){
	$.ajax({
		url: getContentPath() + '/trackhis/asycnlist',
		data: {
			crmid: trackhis.crmid,
			parentid: trackhis.parentid,
			parenttype: trackhis.parenttype,
		},
	    success: function(data){
	    	compileTrackhisList(JSON.parse(data));
	    }
	});
}

function compileTrackhisList(data){
	var hc = '';
	hc += '<dt style="line-height: 34px;">';
	hc += '	$$audit_opdate<span style="top: 16px;"></span>';
	hc += '</dt>';
	hc += '<dd style="width: 70%;cursor: pointer" class="" >';
	hc += '	<div style="border: 1px solid #ededed;border-radius: 3px;background: #f8f8f8;line-height: 24px;text-indent: 0;padding: 4px 4px 4px 6px;">';
	hc += '		<ul class="trackhisReplayCon" opid="$$audit_opid" opname="$$audit_opname_bef" subRelaId="$$audit_parentid_bef" >';
	hc += '			$$htmlByType';
	hc += 		'</ul>';
	hc += '		<ul class="twitter trackhisReplayRst" style="display:none"></ul>';
	hc += '	</div>';
	hc += '</dd>';
	
	var hc5 = '';
	hc5 += '<div class="show_trackhis_more" style="width: 100%; text- align: center;">';
	hc5 += '	<div style="clear: both"></div>';
	hc5 += '	<div style="padding: 8px; font-size: 14px;text-align: center;">';
	hc5 += '		<a href="javascript:void(0)">查看全部&nbsp;↓</a>';
	hc5 += '	</div>';
	hc5 += '</div>';
	
	if(data.length === 0){
		trackhis.trackhis_con.find("dl").append('<div style="line-height: 34px;text-align:center;font-size: 14px;">暂无跟进历史</div>');
		return;
	}
	
	var hall = '';
	var hall_more = '';
	$(data).each(function(i){
		var darr =this.opdate.split(" ")[0].split("-");
		var hcclone  = hc ;
		hcclone = hcclone.replace("$$htmlByType", htmlByType(this.optype));
		hcclone = hcclone.replace("$$audit_opdate", darr[1] + "-" + darr[2]);
		hcclone = hcclone.replace("$$audit_opid", this.opid);
		hcclone = hcclone.replace("$$audit_opname_bef", this.opname);
		hcclone = hcclone.replace("$$audit_parentid_bef", this.parentid);
		hcclone = hcclone.replace("$audit_parentid", this.parentid);
		hcclone = hcclone.replace("$audit_opname", this.opname);
		hcclone = hcclone.replace("$audit_beforevalue", this.beforevalue);
		hcclone = hcclone.replace("$audit_aftervalue", this.aftervalue);
		
		if(i < 5){
			hall += hcclone; 
		}else{
			hall_more += hcclone;
		}
	});
	if($(data).size()>5){
		trackhis.trackhis_con.find("dl").append(hall).append(hc5).append("<div class='trackhis_more_list' style='display: none;'>"+ hall_more + "</div>");
	}else{
		trackhis.trackhis_con.find("dl").append(hall).append("<div class='trackhis_more_list' style='display: none;'>"+ hall_more + "</div>");
	}
	//show more
	showTrackhisMoreEvent();
}

function htmlByType(type){
	var tp1 = '';
	var tp2 = ' <img src="'+ getContentPath() +'/image/navigation-forward.png" width="20px;">$$audit_aftervalue';
	if(type === 'amount'){
		tp1 = '修改业务机会金额，';
	}
	else if(type === 'closed'){
		tp1 = '修改业务机会关闭日期，';
	}
	else if(type === 'stage'){
		tp1 = '修改业务机会阶段，';
	}
	else if(type === 'contact'){
		tp1 = '创建了一个联系人：';
		tp2 = '<a href='+ getContentPath() +'"/contact/detail?openId='+trackhis.openid+'&publicId='+trackhis.publicid+'&rowId=$$audit_parentid">$$audit_aftervalue</a>';
	}
	else if(type === 'tasks'){
		tp1 = '创建了一个任务：';
		tp2 = '<a href="../schedule/detail?openId='+trackhis.openid+'&publicId='+trackhis.publicid+'&rowId=$$audit_parentid">$$audit_aftervalue</a>';
	}
	else if(type === 'rival'){
		tp1 = '创建了一个竞争对手：';
		tp2 = '<a href="../customer/detail?openId='+trackhis.openid+'&publicId='+trackhis.publicid+'&rowId=$$audit_parentid&flag=rival">$$audit_aftervalue</a>';
	}
	else if(type === 'partner'){
		tp1 = '创建了一个合作伙伴：';
		tp2 = '<a href="../customer/detail?openId='+trackhis.openid+'&publicId='+trackhis.publicid+'&rowId=$$audit_parentid&flag=rival">$$audit_aftervalue</a>';
	}
	else if(type === 'event'){
		tp1 = '修改了强制性事件：';
		tp2 = '<a href="../tas/getevt?openId='+trackhis.openid+'&publicId='+trackhis.publicid+'&rowId=$$audit_parentid&crmId='+trackhis.crmid+'&pagename=强制性事件">$$audit_aftervalue</a>';
	}
	else if(type === 'value'){
		tp1 = '修改了价值主张：';
		tp2 = '<a href="../tas/getval?openId='+trackhis.openid+'&publicId='+trackhis.publicid+'&rowId=$$audit_parentid&crmId='+trackhis.crmid+'&pagename=价值主张">$$audit_aftervalue</a>';
	}
	else if(type === 'relation'){
		tp1 = '调整了关系图：';
		tp2 = '<a href="../oppty/rela?openId='+trackhis.openid+'&publicId='+trackhis.publicid+'&rowId=$$audit_parentid&crmId='+trackhis.crmid+'">$$audit_aftervalue</a>';
	}
	else if(type === 'competitor'){
		tp1 = '调整了竞争策略';
	}
	else if(type === 'casevisit'){
		tp1 = ' 添加服务回访：';
		tp2 = '<a href="../complaint/servisitdetail?openid='+trackhis.openid+'&publicid='+trackhis.publicid+'&rowid=$$audit_parentid&crmid='+trackhis.crmid+'">$$audit_aftervalue</a>';
	}
	else if(type === 'caseexec'){
		tp1 = ' 添加服务执行：';
		tp2 = '<a href="../complaint/serexecdetail?openid='+trackhis.openid+'&publicid='+trackhis.publicid+'&rowid=$$audit_parentid&crmid='+trackhis.crmid+'">$$audit_aftervalue</a>';
	}
	else if(type === 'case_status'){
		tp1 = ' 修改服务状态：';
		//tp2 = "";
	}
	else if(type === 'case_finish_time'){
		tp1 = ' 完成服务：';
	}
	else if(type === 'assign'){
		tp1 = ' 修改责任人：';
		tp2 = ' $$audit_aftervalue ';
	}
	else if(type === 'share'){
		tp1 = ' 添加团队成员：';
	}
	else if(type === 'cancel_share'){
		tp1 = ' 删除团队成员：';
	}
	var html = ' <span style="color: #3e6790">\$\$audit_opname</span>'+ tp1 +'$$audit_beforevalue';
	    html += tp2;
	return html;
}

//show more
function showTrackhisMoreEvent(){
	trackhis.trackhis_con.find(".show_trackhis_more").click(function(){
		$(this).css("display","none");
		$(this).siblings(".trackhis_more_list").css("display","");
	});
}

function loadTrackhisMsg(){
	//遍历业务机会跟进数据列表
	$(".trackhisReplayCon").each(function(){
		var opptyReplayRstCon = $(this).siblings(".trackhisReplayRst");
		var subRelaId = $(this).attr("subRelaId");
		
		var obj = {
			crmId: msgsenduserid,
			relaModule: '<%=msg_model_type%>',
			relaId: '<%=rowid%>',
			subRelaId: subRelaId,
	    	invokeSucc: function(d){
	    		opptyReplayRstCon.empty();
	   	    	$(d).each(function(i){
		   	    	  var username = "";
				 	  if(this.userId == obj.crmId){
				 		  username = "我";
				 	  }else{
				 		  username = this.username;
				 	  }
	       	    	  var html = trackhisMsgTemp(this.userId, this.subRelaId, this.targetUId, username,
	       	    	    		this.targetUName, this.content, true);
	   	    		  opptyReplayRstCon.css("display", "").append(html);
	   	    	});
	   	    	initTrackhisEvent();//初始化业务机会回复消息
	    	}
	    };
	    //加载消息
		loadMessage_MsgCore(obj);
	});
}

//消息模板
function trackhisMsgTemp(userId, subRelaId, targetUId, username, targetUName, content, lastFlag){
	var html = '<li style="margin: 4px 0px 4px 8px;width: 90%;padding-right: 10px;">';
	    html += '   <input type="hidden" name="opid" value="'+ userId +'"/>';
	    html += '   <input type="hidden" name="subRelaId" value="'+ subRelaId +'"/>';
    if(targetUId != ''){
    	html += '<a>'+ username +'</a>&nbsp;回复 <a>'+ targetUName +'</a>';
    }else{
    	html += '<a>'+ username +'</a>';
    }
    html += '   <span> : '+ content +'.</span>';
    html += '</li>';
    //追加 下划线
    if(lastFlag){
    	html += '<li style="border-bottom: 1px solid #F0EAEA;margin: 4px 0px 4px 8px;width: 90%;line-height: 1px;">&nbsp;</li>';
    }

	return html;
}

function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0, index+1);
	 return contextPath; 
}
