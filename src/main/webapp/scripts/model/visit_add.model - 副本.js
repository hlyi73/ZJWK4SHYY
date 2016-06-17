/**
 * 服务回访
 */
var visit_add = {};

var engine_follow_pool = [], operator_pool = [];

function initVisitElem(){
	
    visit_add.assigned_user = $(".assigned_user");//服务人员
    visit_add.assigned_user_resp = $(".assigned_user_resp");//服务人员
    visit_add.assigned_user_stxt =  visit_add.assigned_user_resp.find(".show_txt");

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
    visit_add.finish_effect_stxt =  visit_add.handle_desc_resp.find(".show_txt");
    
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
	
	engine_follow_pool.push({"key":"assigned_user", "label":"服务人员", "type": "rela", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"timely", "label":"及时性",  "type": "href", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"service_attitude", "label":"服务态度",  "type": "href", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"finish_effect", "label":"完成情况",  "type": "href", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"work_effect", "label":"工作效率",  "type": "href", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"wear_card", "label":"佩戴胸牌",  "type": "href", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"leave_that", "label":"离开告知",  "type": "href", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"leave_question", "label":"遗留问题 ",  "type": "href", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"question_desc", "label":"问题描述",  "type": "text", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"account_suggest", "label":"客户建议",  "type": "text", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"question_handle", "label":"问题处理",  "type": "text", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"handle_desc", "label":"处理情况",  "type": "href", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"visit_date", "label":"回访日期",  "type": "date", "status": "hide", "value": ""});
	
	loadLovData(visit_add.handle_desc, "case_handle_list");
	loadLovData(visit_add.leave_question, "case_question_list");
	loadLovData(visit_add.service_attitude, "case_service_attitude_list");
	loadLovData(visit_add.timely, "case_timely_list");
	loadLovData(visit_add.work_effect, "case_work_effect_list");
	loadLovData(visit_add.wear_card, "yesorno_list");
	loadLovData(visit_add.leave_that, "yesorno_list");
	loadLovData(visit_add.finish_effect, "case_finish_list");
	
	loadRelaData("assigned_user",{
		async_flag: false,
		flag: 'share',
		viewtype: 'myview',
		parentid: '',
		parenttype: 'Cases',
		type: 'userList',
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
	 return visit_add.txt_input.val();
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
			engine_follow_pool[visit_add.engine_curr_index]["value"] = $(this).attr("key");
		}else{
			loadChatsEngine($(this).html(), $(this).attr("key"));
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
			engine_follow_pool[visit_add.engine_curr_index]["value"] = $(this).attr("key");
		}else{
			loadChatsEngine($(this).html(), $(this).attr("key"));
		}
	});
}



//加载引擎
function loadChatsEngine(value, v2){
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
		if(type === "href"){
			engine_follow_pool[visit_add.engine_curr_index]["value"] = v2;
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
		obj.find(".href_con").append('<a href="javascript:void(0)" key="'+ this.value +'">'+ this.key +'</a>&nbsp;&nbsp;');
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
		v +='【'+ i +'】.  '+this.label+': <span style="color:blue">'+ this.value +'</span><br>';
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