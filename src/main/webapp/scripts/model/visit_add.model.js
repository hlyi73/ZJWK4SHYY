/**
 * 服务回访
 */
var visit_add = {};

var engine_follow_pool = [], operator_pool = [];

function initVisitElem(){
	
    visit_add.assigned_user_id = $(".assigned_user_id");//服务人员
    visit_add.assigned_user_id_resp = $(".assigned_user_id_resp");//服务人员
    visit_add.assigned_user_id_stxt =  visit_add.assigned_user_id_resp.find(".show_txt");

    visit_add.serve_execute_id = $(".serve_execute_id");//服务执行
    visit_add.serve_execute_id_resp = $(".serve_execute_id_resp");//服务执行
    visit_add.serve_execute_id_stxt =  visit_add.serve_execute_id_resp.find(".show_txt");

    visit_add.visit_date = $(".visit_date");//回访日期
    visit_add.visit_date_resp = $(".visit_date_resp");//回访日期
    visit_add.visit_date_stxt =  visit_add.visit_date_resp.find(".show_txt");

    visit_add.finish_desc = $(".finish_desc");//回访记录
    visit_add.finish_desc_resp = $(".visit_date_resp");//回访记录
    visit_add.finish_desc_stxt =  visit_add.finish_desc_resp.find(".show_txt");

    visit_add.created_by = $(".created_by");//回访人 
    visit_add.created_by_resp = $(".created_by_resp");//回访人
    visit_add.created_by_stxt =  visit_add.created_by_resp.find(".show_txt");

    visit_add.timely = $(".timely");//及时性
    visit_add.timely_resp = $(".timely_resp");//及时性
    visit_add.timely_stxt =  visit_add.timely_resp.find(".show_txt");
    visit_add.timely_callback = 

    visit_add.service_attitude = $(".service_attitude");//服务态度
    visit_add.service_attitude_resp = $(".service_attitude_resp");//服务态度
    visit_add.service_attitude_stxt =  visit_add.service_attitude_resp.find(".show_txt");

    visit_add.work_effect = $(".work_effect");//工作效率
    visit_add.work_effect_resp = $(".work_effect_resp");//工作效率
    visit_add.work_effect_stxt =  visit_add.work_effect_resp.find(".show_txt");

    visit_add.wear_card = $(".wear_card");//佩戴胸牌
    visit_add.wear_card_resp = $(".wear_card_resp");//佩戴胸牌
    visit_add.wear_card_stxt =  visit_add.wear_card_resp.find(".show_txt");

    visit_add.leave_that = $(".leave_that");//离开告知
    visit_add.leave_that_resp = $(".leave_that_resp");//离开告知
    visit_add.leave_that_stxt =  visit_add.leave_that_resp.find(".show_txt");

    visit_add.leave_question = $(".leave_question");//遗留问题 
    visit_add.leave_question_resp = $(".leave_question_resp");//遗留问题
    visit_add.leave_question_stxt =  visit_add.leave_question_resp.find(".show_txt");

    visit_add.question_desc = $(".question_desc");//问题描述
    visit_add.question_desc_resp = $(".question_desc_resp");//问题描述
    visit_add.question_desc_stxt =  visit_add.question_desc_resp.find(".show_txt");

    visit_add.account_suggest = $(".account_suggest");//客户建议
    visit_add.account_suggest_resp = $(".account_suggest_resp");//客户建议
    visit_add.account_suggest_stxt =  visit_add.account_suggest_resp.find(".show_txt");

    visit_add.question_handle = $(".question_handle");//问题处理
    visit_add.question_handle_resp = $(".question_handle_resp");//问题处理
    visit_add.question_handle_stxt =  visit_add.question_handle_resp.find(".show_txt");

    visit_add.handle_desc = $(".handle_desc");//处理情况
    visit_add.handle_desc_resp = $(".handle_desc_resp");//问题处理
    visit_add.handle_desc_stxt =  visit_add.handle_desc_resp.find(".show_txt");
    
    visit_add.finish_effect = $(".finish_effect");//处理情况
    visit_add.finish_effect_resp = $(".finish_effect_resp");//问题处理
    visit_add.finish_effect_stxt =  visit_add.finish_effect_resp.find(".show_txt");
    
    visit_add.total = $(".total");
    visit_add.totalDetail = visit_add.total.find(".totalDetail");
    
    //form
    visit_add.visit_form = $("form[name=visit_form]");
    
	//编号
	visit_add.operator_con = $(".operator_con");
	visit_add.date_con = visit_add.operator_con.find(".date_con");
	visit_add.date_btn = visit_add.date_con.find(".date_btn");
	visit_add.date_input = visit_add.date_con.find("#date_input");

	visit_add.txt_con = visit_add.operator_con.find(".txt_con");
	visit_add.txt_btn = visit_add.txt_con.find(".txt_btn");
	visit_add.txt_input = visit_add.txt_con.find("textarea[name=txt_input]");

	visit_add.submit_con = visit_add.operator_con.find(".submit_con");
	visit_add.desc_input = visit_add.submit_con.find("textarea[name=desc_input]");
	visit_add.save_btn = visit_add.submit_con.find(".save_btn");
	visit_add.continue_btn = visit_add.submit_con.find(".continue_btn");
	
	visit_add.engine_curr_index = 0;
	
	operator_pool.push("date_con");
	operator_pool.push("txt_con");
	operator_pool.push("submit_con");
	
	engine_follow_pool.push({"key":"assigned_user_id", "label":"服务人员", "type": "rela", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"timely", "label":"及时性",  "type": "href", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"service_attitude", "label":"服务态度",  "type": "href", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"finish_effect", "label":"完成情况",  "type": "href", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"work_effect", "label":"工作效率",  "type": "href", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"wear_card", "label":"佩戴胸牌",  "type": "href", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"leave_that", "label":"离开告知",  "type": "href", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"leave_question", "label":"遗留问题 ",  "type": "href", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"question_desc", "label":"问题描述",  "type": "text", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"account_suggest", "label":"客户建议",  "type": "text", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"question_handle", "label":"问题处理",  "type": "text", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"handle_desc", "label":"处理情况",  "type": "href", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"visit_date", "label":"回访日期",  "type": "date", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"serve_execute_id", "label":"服务执行", "type": "rela", "status": "hide", "value": "", "show_value":""});
	
	loadLovData(visit_add.handle_desc, "case_handle_list");
	loadLovData(visit_add.leave_question, "case_question_list");
	loadLovData(visit_add.service_attitude, "case_service_attitude_list");
	loadLovData(visit_add.timely, "case_timely_list");
	loadLovData(visit_add.work_effect, "case_work_effect_list");
	loadLovData(visit_add.wear_card, "yesorno_list");
	loadLovData(visit_add.leave_that, "yesorno_list");
	loadLovData(visit_add.finish_effect, "case_finish_list");
	
	//选择服务人员
	loadRelaData("assigned_user_id",{
		async_flag: false,
		flag: 'share',
		viewtype: 'myview',
		parentid: '',
		parenttype: 'Systemuser',
		type: 'userList',
		callback_func: function(data){
			loadChatsEngineEvent();
		}
	});
	
	//服务回访可以 选择服务执行
	loadRelaData("serve_execute_id",{
		async_flag: false,
		parentid: visit_add.parent_id,
		parenttype: 'Serqexec',
		callback_func: function(data){
			loadChatsEngineEvent();
		}
	});
}


function initVisitBtn(){
	//文本输入
	visit_add.txt_btn.click(function(){
		loadChatsEngine(getTxtInputVal());
	});
	//日期输入
	visit_add.date_btn.click(function(){
		loadChatsEngine(getDateInputVal());
	});
	
	autoTextArea(visit_add.txt_input);
	
	//日期
	visit_add.date_input.val(dateFormat(new Date(), "yyyy-MM-dd")).scroller('destroy').scroller($.extend({preset : 'date'}, { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	
	//保存
	visit_add.save_btn.click(function(){
		saveVisit();
	});
	//保存并添加
	visit_add.continue_btn.click(function(){
		visit_add.visit_form.append('<input type="hidden" name="continue_add" value="yes" />');
		saveVisit();
	});
}


function loadChatsEngineEvent(){
	$.each(engine_follow_pool, function(i){
		if(this.type === "href"){
			engineFollowHrefEvent(this.key);
		}
		if(this.type === "rela"){
			engineFollowRelaEvent(this.key);
		}
	});
}

function showDateInput(){
	 hideOperator();
	 visit_add.date_con.removeClass("modal");
}
function hideDateInput(){
	 visit_add.date_con.addClass("modal");
}
function updTxtPlaceholder(v){
	visit_add.txt_input.attr("placeholder","请输入" + v);
}
function showTxtInput(){
	hideOperator();
	 visit_add.txt_con.removeClass("modal");
}
function hideTxtInput(){
	 visit_add.txt_con.addClass("modal");
}
function showSubmitBtn(){
	hideOperator();
	 visit_add.submit_con.removeClass("modal");
}
function hideSubmitBtn(){
	 visit_add.submit_con.addClass("modal");
}
function getTxtInputVal(){
	 var v = visit_add.txt_input.val()
	 if(!v){
		 visit_add.txt_input.attr("placeholder", "输入不能为空");
		 return;
	 }
	 return v;
}
function setTxtInputVal(value){
	 visit_add.txt_input.val(value);
}
function getDateInputVal(){
     return visit_add.date_input.val();
}
function setDateInputVal(value){
	 visit_add.date_input.val(value);
}
function hideOperator(){
	$.each(operator_pool, function(i){
		visit_add[this].addClass("modal");
	});
}
function getEngineFollowPoolIndex(mykey){
	var rt = 0;
	$.each(engine_follow_pool, function(j){
		if(this.key === mykey){
			rt = j;
		}
	});
	return rt;
}

function engineFollowHrefEvent(key){
	visit_add[key].find(".href_con a").unbind("click").click(function(){
		var type = $(this).parent().attr("hreftype");
		var index = getEngineFollowPoolIndex(type);
		if(visit_add.engine_curr_index > parseInt(index)){
			visit_add[type + "_resp"].removeClass("modal");
			visit_add[type + "_stxt"].html($(this).html());
			engine_follow_pool[parseInt(index)]["value"] = $(this).attr("key");
			engine_follow_pool[parseInt(index)]["show_value"] = $(this).html();
		}else{
			loadChatsEngine($(this).html(), $(this).attr("key"), $(this).html());
		}
	});
}

function engineFollowRelaEvent(key){
	visit_add[key].find(".rela_con").unbind("click").find("a").click(function(){
		var type = $(this).parent().parent().attr("hreftype");
		var index = getEngineFollowPoolIndex(type);
		if(visit_add.engine_curr_index > parseInt(index)){
			visit_add[type + "_resp"].removeClass("modal");
			visit_add[type + "_stxt"].html($(this).html());
			engine_follow_pool[parseInt(index)]["value"] = $(this).attr("id");
			engine_follow_pool[parseInt(index)]["show_value"] = $(this).html();
		}else{
			loadChatsEngine($(this).html(), $(this).attr("id"), $(this).html());
		}
	});
}



//加载引擎
function loadChatsEngine(value, v2, show_value){
	//判断大小
	if(parseInt(visit_add.engine_curr_index) >= engine_follow_pool.length){
		showSubmitBtn();
		totalMsg();
		return;
	}
	
	var key = engine_follow_pool[visit_add.engine_curr_index]["key"];
	var type = engine_follow_pool[visit_add.engine_curr_index]["type"];
	var label = engine_follow_pool[visit_add.engine_curr_index]["label"];
	
	visit_add[key].removeClass("modal");
		
	if(type === "text"){
		setTxtInputVal("");
		showTxtInput();
		updTxtPlaceholder(label);
	}else if(type === "date"){
		setTxtInputVal("");
		showDateInput();
	}else{
		hideOperator();
	}
	
	if(value){
		
		visit_add[key + "_resp"].removeClass("modal");
		visit_add[key + "_stxt"].html(value);
		if(type === "href" || type === "rela"){
			engine_follow_pool[visit_add.engine_curr_index]["value"] = v2;
			engine_follow_pool[visit_add.engine_curr_index]["show_value"] = show_value;
		}else{
			engine_follow_pool[visit_add.engine_curr_index]["value"] = value;
		}
		
		visit_add.engine_curr_index = parseInt(visit_add.engine_curr_index) + 1;
		
		scrollToButtom();
		
		loadChatsEngine();
	}
}
function loadLovData(obj, lovkey){
	$.each(lov_data_list[lovkey], function(){
		if(this.key && this.value){
			obj.find(".href_con").append('<a href="javascript:void(0)" key="'+ this.key +'">'+ this.value +'</a>&nbsp;&nbsp;');
		}
		
	});
}

function loadRelaData(elementid, opt){
	var setting = $.extend({
		crmid: visit_add.crmid,
		publicid: visit_add.publicid,
		openid: visit_add.openid
	}, opt);
	//调用接口
	ivk_createRelation(elementid, setting);
}

//提交
function saveVisit(){
	$.each(engine_follow_pool, function(){
		visit_add.visit_form.append('<input type="hidden" name="'+ this.key +'" value="'+ this.value +'" />');
	});
	visit_add.visit_form.submit();
}

//汇总信息
function totalMsg(){
	
	var v  = '<h1 style="font-size: 15px;">您创建的服务访问汇总如下所示:</h1><br>';
	$.each(engine_follow_pool, function(i){
		if(this.type === "href" || this.type === "rela"){
			v +='【'+ i +'】.  '+this.label+': <span style="color:blue">'+ this.show_value +'</span><br>';
		}else{
			v +='【'+ i +'】.  '+this.label+': <span style="color:blue">'+ this.value +'</span><br>';
		}
	});
	visit_add.total.css("display", "");
	visit_add.totalDetail.empty().append(v);
}

function autoTextArea(elemid){
    //新建一个textarea用户计算高度
    if(!document.getElementById("_textareacopy")){
        var t = document.createElement("textarea");
        t.id="_textareacopy";
        t.style.position="absolute";
        t.style.left="-9999px";
        t.rows = "1";
        t.style.lineHeight="20px";
        t.style.fontSize="16px";
        document.body.appendChild(t);
    }
    function change(){
    	document.getElementById("_textareacopy").value= document.getElementById("txt_input").value;
    	var height = document.getElementById("_textareacopy").scrollHeight;
    	if(height>100){
    		return;
    	}
    	if(document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height < 40){
    		document.getElementById("txt_input").style.height= "40px";
    	}else{
        	document.getElementById("txt_input").style.height= document.getElementById("_textareacopy").scrollHeight+document.getElementById("_textareacopy").style.height+"px";
    	}
    }
    
    $("#txt_input").bind("propertychange",function(){
    	change();
    });
    $("#txt_input").bind("input",function(){
    	change();
    });

    document.getElementById("txt_input").style.overflow="hidden";//一处隐藏，必须的。
    document.getElementById("txt_input").style.resize="none";//去掉textarea能拖拽放大/缩小高度/宽度功能
}

//滚动
function scrollToButtom(obj){
	if(obj){
		var y = $(obj).offset().top;
	    if(!y) y = 0;
		window.scrollTo(100, y);
	}else{
		window.scrollTo(100, 99999);
	}
	return false;
}

function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}

/**
 * 新增页面 公共 关联关系js
 */

var relation = {};

//ivk-> 对外提供接口 创建JS级的关联关系 
function ivk_createRelation(elementid, setting){
	initRelationElem(elementid, setting);
	loadFristCharListData(relation[elementid]);//加载首字母
	loadRelationListData(relation[elementid]);
}

//元素加载
function initRelationElem(elementid, setting){
	var obj = {};
	obj.curr_type = $("." + elementid).find(":hidden[name=curr_type]");
	obj.fst_char = $("." + elementid).find(":hidden[name=fst_char]");
	obj.curr_page = $("." + elementid).find(":hidden[name=curr_page]");
	obj.page_count = $("." + elementid).find(":hidden[name=page_count]");
	
	obj.fc_list = $("." + elementid).find(".fc_list");
	obj.pre_cus = $("." + elementid).find(".pre_cus");
	obj.content = $("." + elementid).find(".content");
	obj.next_cus = $("." + elementid).find(".next_cus");
	
	obj.crmid = setting.crmid;
	obj.openid = setting.openid;
	obj.publicid = setting.publicid;
	obj.flag = setting.flag;
	obj.viewtype = setting.viewtype;
	obj.parentid = setting.parentid;
	obj.parenttype = setting.parenttype;
	obj.type = setting.type;
	obj.async_flag = setting.async_flag;
	obj.callback_func = setting.callback_func;
	
	relation[elementid] = obj;
}

function loadRelationListData(obj){
	var search_url = '';
	if(obj.parenttype === "Opportunities"){
		search_url = getContentPath() + '/oppty/list'; //业务机会查询URL
		obj.curr_type.val('opptyList');
	}
	if(obj.parenttype === "Accounts"){
		search_url = getContentPath() + '/customer/list'; //客户查询URL
		obj.curr_type.val('accntList');
	}
	if(obj.parenttype === "Contract"){
		search_url = getContentPath() + '/contract/asylist'; //合同查询URL
		obj.curr_type.val('projectList');
	}
	if(obj.parenttype === "Contact"){
		search_url = getContentPath() + '/contact/asyclist'; //联系人查询URL
		obj.curr_type.val('contactList');
	}
	if(obj.parenttype === "Systemuser"){
		search_url = getContentPath() + '/lovuser/userlist'; //系统用户
	}
	if(obj.parenttype === "Serqexec"){
		search_url = getContentPath() + '/complaint/asycn_serexeclist'; //服务执行
	}
	asyncInvoke({
		url: search_url,
		async: obj.async_flag,
		data: {
		   crmId: obj.crmid,
		   openId: obj.openid,
		   publicId: obj.publicid,
		   openid: obj.openid,
		   publicid: obj.publicid,
		   flag: obj.flag,
		   viewtype: obj.viewtype,
		   parentid: obj.parentid,
		   parenttype: obj.parenttype,
		   firstchar: obj.fst_char.val(), 
		   currpage: obj.curr_page.val(),
		   pagecount: obj.page_count.val()
		},
	    callBackFunc: function(data){
	    	var d = JSON.parse(data);
	    	//初始化关联的数据列表
	    	compRetionListData(obj, d);
	    	//call back function
	    	if(obj.callback_func){
	    		obj.callback_func(d);
	    	}
	    }
	});
}

//查询模块的首字母
function loadFristCharListData(obj){
    var type='';
    if(obj.parenttype === "Opportunities"){
		type = "opptyList";
	}
	if(obj.parenttype === "Accounts"){
    	type="accntList";
	}
	if(obj.parenttype === "Contract"){
		type = "contractList";
	}
	if(obj.parenttype === "Contact"){
		type = "contactList";
	}
	obj.fc_list.empty();
    asyncInvoke({
		url: getContentPath() + '/fchart/list',
		async: obj.async_flag,
		data: {
		   crmId: obj.crmid,
		   type: obj.type,
		   parentid: obj.parentid,
		   parenttype: obj.parenttype
		},
	    callBackFunc: function(data){
	    	if(!data) return;
    	    var d = JSON.parse(data);
    	    if(d.errorCode){
    	    	return;
    	    }
    	    var ahtml = '';
    	    $(d).each(function(i){
    	    	ahtml += '<a href="javascript:void(0)" onclick="javascript:void(0)">'+ this +'</a>';
    	    });
    	    obj.fc_list.html(ahtml);
    	    
    	    initCharCheckedBtn(obj);//字母选择事件
	    }
	});
}

//字母选择事件
function initCharCheckedBtn(obj){
	obj.fc_list.find("a").unbind("click").bind("click", function(){
		obj.curr_page.val("1");
		obj.fst_char.val($(this).html());
		loadRelationListData(obj);
	});
}

//初始化关联的数据列表
function compRetionListData(obj, data){
	//上一页 控制显示与否
	if(1 !== parseInt(obj.curr_page.val())){
		obj.pre_cus.css("display",'');
	}else{
		obj.pre_cus.css("display",'none');
	}
	//下一页 控制显示与否
	if(data.length === parseInt(obj.page_count.val())){
		obj.next_cus.css("display",'');
	}else{
		obj.next_cus.css("display",'none');
	}
	//data length 为0的判断
    if(data.length === 0){
    	return;
    }
    var v = '';
	$(data).each(function(){
		var name = '';
		var id = this.rowid;
		
		if(obj.parenttype === "Opportunities"){
			name = this.name;
		}
		if(obj.parenttype === "Accounts"){
			name = this.name;
		}
		if(obj.parenttype === "Contract"){
			name = this.title;
		}
		if(obj.parenttype === "Contact"){
			name = this.conname;
		}
		if(obj.parenttype === "Systemuser"){
			id = this.userid;
			name = this.username;
		}
		if(obj.parenttype === "Serqexec"){
			id = this.rowid;
			name = this.assigned_user_name + "于" + this.start_date + "执行： " + this.process_desc;
		}
		
		if(!id){
			return true;
		}
		
		v += '<div style="height:25px;line-height:25px;">';
		v +=   '<a href="javascript:void(0)" id="'+ id +'">'+ name +'</a>';
		v += '</div>';
	});

	if(v){
		obj.content.empty().html(v);
	}

	//绑定上一页
	obj.pre_cus.unbind("click").bind("click", function(event){
		var currpage = parseInt(obj.curr_page.val()) - 1;
		if(currpage < 1)  currpage = 1;
		obj.curr_page.val(currpage);
		loadRelationListData(obj);
	});
	//下一页
	obj.next_cus.unbind("click").bind("click", function(event){
		obj.curr_page.val( parseInt(obj.curr_page.val()) + 1);
		loadRelationListData(obj);
	});
}

function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}