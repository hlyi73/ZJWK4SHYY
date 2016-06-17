/**
 * 服务回访
 */
var visit_zijie_add = {};

var engine_follow_pool = [], operator_pool = [];

function initVisitElem(){

    visit_zijie_add.visit_date = $(".visit_date");//回访日期
    visit_zijie_add.visit_date_resp = $(".visit_date_resp");//回访日期
    visit_zijie_add.visit_date_stxt =  visit_zijie_add.visit_date_resp.find(".show_txt");

    visit_zijie_add.finish_desc = $(".finish_desc");//回访记录
    visit_zijie_add.finish_desc_resp = $(".finish_desc_resp");//回访记录
    visit_zijie_add.finish_desc_stxt =  visit_zijie_add.finish_desc_resp.find(".show_txt");

    visit_zijie_add.total = $(".total");
    visit_zijie_add.totalDetail = visit_zijie_add.total.find(".totalDetail");
    
    //form
    visit_zijie_add.visit_form = $("form[name=visit_form]");
    
	//编号
	visit_zijie_add.operator_con = $(".operator_con");
	visit_zijie_add.date_con = visit_zijie_add.operator_con.find(".date_con");
	visit_zijie_add.date_btn = visit_zijie_add.date_con.find(".date_btn");
	visit_zijie_add.date_input = visit_zijie_add.date_con.find("#date_input");

	visit_zijie_add.txt_con = visit_zijie_add.operator_con.find(".txt_con");
	visit_zijie_add.txt_btn = visit_zijie_add.txt_con.find(".txt_btn");
	visit_zijie_add.txt_input = visit_zijie_add.txt_con.find("textarea[name=txt_input]");

	visit_zijie_add.submit_con = visit_zijie_add.operator_con.find(".submit_con");
	visit_zijie_add.desc_input = visit_zijie_add.submit_con.find("textarea[name=desc_input]");
	visit_zijie_add.save_btn = visit_zijie_add.submit_con.find(".save_btn");
	visit_zijie_add.continue_btn = visit_zijie_add.submit_con.find(".continue_btn");
	
	visit_zijie_add.engine_curr_index = 0;
	
	operator_pool.push("date_con");
	operator_pool.push("txt_con");
	operator_pool.push("submit_con");
	
	engine_follow_pool.push({"key":"finish_desc", "label":"回访记录",  "type": "text", "status": "hide", "value": ""});
	engine_follow_pool.push({"key":"visit_date", "label":"回访日期",  "type": "date", "status": "hide", "value": ""});
	
}


function initVisitBtn(){
	//文本输入
	visit_zijie_add.txt_btn.click(function(){
		loadChatsEngine(getTxtInputVal());
	});
	//日期输入
	visit_zijie_add.date_btn.click(function(){
		loadChatsEngine(getDateInputVal());
	});
	
	autoTextArea(visit_zijie_add.txt_input);
	
	//日期
	visit_zijie_add.date_input.val(dateFormat(new Date(), "yyyy-MM-dd")).scroller('destroy').scroller($.extend({preset : 'date'}, { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	
	//保存
	visit_zijie_add.save_btn.click(function(){
		saveVisit();
	});
	//保存并添加
	visit_zijie_add.continue_btn.click(function(){
		visit_zijie_add.visit_form.append('<input type="hidden" name="continue_add" value="yes" />');
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
	 visit_zijie_add.date_con.removeClass("modal");
}
function hideDateInput(){
	 visit_zijie_add.date_con.addClass("modal");
}
function updTxtPlaceholder(v){
	visit_zijie_add.txt_input.attr("placeholder","请输入" + v);
}
function showTxtInput(){
	hideOperator();
	 visit_zijie_add.txt_con.removeClass("modal");
}
function hideTxtInput(){
	 visit_zijie_add.txt_con.addClass("modal");
}
function showSubmitBtn(){
	hideOperator();
	 visit_zijie_add.submit_con.removeClass("modal");
}
function hideSubmitBtn(){
	 visit_zijie_add.submit_con.addClass("modal");
}
function getTxtInputVal(){
	 var v = visit_zijie_add.txt_input.val()
	 if(!v){
		 visit_zijie_add.txt_input.attr("placeholder", "输入不能为空");
		 return;
	 }
	 return v;
}
function setTxtInputVal(value){
	 visit_zijie_add.txt_input.val(value);
}
function getDateInputVal(){
     return visit_zijie_add.date_input.val();
}
function setDateInputVal(value){
	 visit_zijie_add.date_input.val(value);
}
function hideOperator(){
	$.each(operator_pool, function(i){
		visit_zijie_add[this].addClass("modal");
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
	visit_zijie_add[key].find(".href_con a").unbind("click").click(function(){
		var type = $(this).parent().attr("hreftype");
		var index = getEngineFollowPoolIndex(type);
		if(visit_zijie_add.engine_curr_index > parseInt(index)){
			visit_zijie_add[type + "_resp"].removeClass("modal");
			visit_zijie_add[type + "_stxt"].html($(this).html());
			engine_follow_pool[parseInt(index)]["value"] = $(this).attr("key");
		}else{
			loadChatsEngine($(this).html(), $(this).attr("key"));
		}
	});
}

function engineFollowRelaEvent(key){
	visit_zijie_add[key].find(".rela_con").unbind("click").find("a").click(function(){
		var type = $(this).parent().parent().attr("hreftype");
		var index = getEngineFollowPoolIndex(type);
		if(visit_zijie_add.engine_curr_index > parseInt(index)){
			visit_zijie_add[type + "_resp"].removeClass("modal");
			visit_zijie_add[type + "_stxt"].html($(this).html());
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
	if(parseInt(visit_zijie_add.engine_curr_index) >= engine_follow_pool.length){
		showSubmitBtn();
		totalMsg();
		return;
	}
	
	var key = engine_follow_pool[visit_zijie_add.engine_curr_index]["key"];
	var type = engine_follow_pool[visit_zijie_add.engine_curr_index]["type"];
	var label = engine_follow_pool[visit_zijie_add.engine_curr_index]["label"];
	
	visit_zijie_add[key].removeClass("modal");
		
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
		
		visit_zijie_add[key + "_resp"].removeClass("modal");
		visit_zijie_add[key + "_stxt"].html(value);
		if(type === "href" || type === "rela"){
			engine_follow_pool[visit_zijie_add.engine_curr_index]["value"] = v2;
			engine_follow_pool[exec_add.engine_curr_index]["show_value"] = show_value;
		}else{
			engine_follow_pool[visit_zijie_add.engine_curr_index]["value"] = value;
		}
		
		visit_zijie_add.engine_curr_index = parseInt(visit_zijie_add.engine_curr_index) + 1;
		
		scrollToButtom();
		
		loadChatsEngine();
	}
}
function loadLovData(obj, lovkey){
	$.each(lov_data_list[lovkey], function(){
		if(this.key && this.value){
			obj.find(".href_con").append('<a href="javascript:void(0)" key="'+ this.value +'">'+ this.key +'</a>&nbsp;&nbsp;');
		}
	});
}

function loadRelaData(elementid, opt){
	var setting = $.extend({
		crmid: visit_zijie_add.crmid,
		publicid: visit_zijie_add.publicid,
		openid: visit_zijie_add.openid
	}, opt);
	//调用接口
	ivk_createRelation(elementid, setting);
}

//提交
function saveVisit(){
	$.each(engine_follow_pool, function(){
		visit_zijie_add.visit_form.append('<input type="hidden" name="'+ this.key +'" value="'+ this.value +'" />');
	});
	visit_zijie_add.visit_form.submit();
}

//汇总信息
function totalMsg(){
	
	var v  = '<h1 style="font-size: 15px;">您创建的汇总如下所示:</h1><br>';
	$.each(engine_follow_pool, function(i){
		if(this.type === "href" || this.type === "rela"){
			v +='【'+ i +'】.  '+this.label+': <span style="color:blue">'+ this.show_value +'</span><br>';
		}else{
			v +='【'+ i +'】.  '+this.label+': <span style="color:blue">'+ this.value +'</span><br>';
		}
		
	});
	visit_zijie_add.total.css("display", "");
	visit_zijie_add.totalDetail.empty().append(v);
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