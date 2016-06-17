/**
 * 服务回访
 */
var exec_add = {};

var engine_follow_pool = [], operator_pool = [];

function initExecElem(){
	
	exec_add.start_date = $(".start_date");//服务开始时间
	exec_add.start_date_resp = $(".start_date_resp");//服务开始时间
	exec_add.start_date_stxt =  exec_add.start_date_resp.find(".show_txt");
	
	exec_add.end_date = $(".end_date");//服务结束时间
	exec_add.end_date_resp = $(".end_date_resp");//服务结束时间
	exec_add.end_date_stxt =  exec_add.end_date_resp.find(".show_txt");
	
    exec_add.assigned_user_id = $(".assigned_user_id");//服务人员
    exec_add.assigned_user_id_resp = $(".assigned_user_id_resp");//服务人员
    exec_add.assigned_user_id_stxt =  exec_add.assigned_user_id_resp.find(".show_txt");

    exec_add.fault_desc = $(".fault_desc");//故障描述
    exec_add.fault_desc_resp = $(".fault_desc_resp");//故障描述
    exec_add.fault_desc_stxt =  exec_add.fault_desc_resp.find(".show_txt");

    exec_add.process_desc = $(".process_desc");//处置说明
    exec_add.process_desc_resp = $(".process_desc_resp");//处置说明
    exec_add.process_desc_stxt =  exec_add.process_desc_resp.find(".show_txt");

    exec_add.is_callback = $(".is_callback");//回执单是否收回 
    exec_add.is_callback_resp = $(".is_callback_resp");//回执单是否收回
    exec_add.is_callback_stxt =  exec_add.is_callback_resp.find(".show_txt");
    
    exec_add.total = $(".total");
    exec_add.totalDetail = exec_add.total.find(".totalDetail");

    //form
    exec_add.exec_form = $("form[name=exec_form]");
    
	//编号
	exec_add.operator_con = $(".operator_con");
	exec_add.date_con = exec_add.operator_con.find(".date_con");
	exec_add.date_btn = exec_add.date_con.find(".date_btn");
	exec_add.date_input = exec_add.date_con.find("#date_input");

	exec_add.txt_con = exec_add.operator_con.find(".txt_con");
	exec_add.txt_btn = exec_add.txt_con.find(".txt_btn");
	exec_add.txt_input = exec_add.txt_con.find("textarea[name=txt_input]");

	exec_add.submit_con = exec_add.operator_con.find(".submit_con");
	exec_add.desc_input = exec_add.submit_con.find("textarea[name=desc_input]");
	exec_add.save_btn = exec_add.submit_con.find(".save_btn");
	exec_add.continue_btn = exec_add.submit_con.find(".continue_btn");
	
	exec_add.engine_curr_index = 0;
	
	operator_pool.push("date_con");
	operator_pool.push("txt_con");
	operator_pool.push("submit_con");
	
	engine_follow_pool.push({"key":"start_date", "label":"服务开始时间",  "type": "date", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"end_date", "label":"服务结束时间",  "type": "date", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"assigned_user_id", "label":"服务人员", "type": "rela", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"fault_desc", "label":"故障描述", "type": "text", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"process_desc", "label":"处置说明", "type": "text", "status": "hide", "value": "", "show_value":""});
	engine_follow_pool.push({"key":"is_callback", "label":"回执单是否收回",  "type": "href", "status": "hide", "value": "", "show_value":""});
	
	loadLovData(exec_add.is_callback, "yesorno_list");
	
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
}


function initExecBtn(){
	//文本输入
	exec_add.txt_btn.click(function(){
		loadChatsEngine(getTxtInputVal());
	});
	//日期输入
	exec_add.date_btn.click(function(){
		loadChatsEngine(getDateInputVal());
	});
	
	autoTextArea(exec_add.txt_input);
	
	//日期
	exec_add.date_input.val(dateFormat(new Date(), "yyyy-MM-dd")).scroller('destroy').scroller($.extend({preset : 'date'}, { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
	
	//保存
	exec_add.save_btn.click(function(){
		saveExec();
	});
	//保存并添加
	exec_add.continue_btn.click(function(){
		exec_add.exec_form.append('<input type="hidden" name="continue_add" value="yes" />');
		saveExec();
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
	 exec_add.date_con.removeClass("modal");
}
function hideDateInput(){
	 exec_add.date_con.addClass("modal");
}
function updTxtPlaceholder(v){
	exec_add.txt_input.attr("placeholder","请输入" + v);
}
function showTxtInput(){
	hideOperator();
	 exec_add.txt_con.removeClass("modal");
}
function hideTxtInput(){
	 exec_add.txt_con.addClass("modal");
}
function showSubmitBtn(){
	hideOperator();
	 exec_add.submit_con.removeClass("modal");
}
function hideSubmitBtn(){
	 exec_add.submit_con.addClass("modal");
}
function getTxtInputVal(){
	 var v = exec_add.txt_input.val()
	 if(!v){
		 exec_add.txt_input.attr("placeholder", "输入不能为空");
		 return;
	 }
	 return v;
}
function setTxtInputVal(value){
	 exec_add.txt_input.val(value);
}
function getDateInputVal(){
     return exec_add.date_input.val();
}
function setDateInputVal(value){
	 exec_add.date_input.val(value);
}
function hideOperator(){
	$.each(operator_pool, function(i){
		exec_add[this].addClass("modal");
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
	exec_add[key].find(".href_con a").unbind("click").click(function(){
		var type = $(this).parent().attr("hreftype");
		var index = getEngineFollowPoolIndex(type);
		if(exec_add.engine_curr_index > parseInt(index)){
			exec_add[type + "_resp"].removeClass("modal");
			exec_add[type + "_stxt"].html($(this).html());
			engine_follow_pool[parseInt(index)]["value"] = $(this).attr("key");
			engine_follow_pool[parseInt(index)]["show_value"] = $(this).html();
		}else{
			loadChatsEngine($(this).html(), $(this).attr("key"), $(this).html());
		}
	});
}

function engineFollowRelaEvent(key){
	exec_add[key].find(".rela_con").unbind("click").find("a").click(function(){
		var type = $(this).parent().parent().attr("hreftype");
		var index = getEngineFollowPoolIndex(type);
		if(exec_add.engine_curr_index > parseInt(index)){
			exec_add[type + "_resp"].removeClass("modal");
			exec_add[type + "_stxt"].html($(this).html());
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
	if(parseInt(exec_add.engine_curr_index) >= engine_follow_pool.length){
		showSubmitBtn();
		totalMsg();
		return;
	}
	
	var key = engine_follow_pool[exec_add.engine_curr_index]["key"];
	var type = engine_follow_pool[exec_add.engine_curr_index]["type"];
	var label = engine_follow_pool[exec_add.engine_curr_index]["label"];
	
	exec_add[key].removeClass("modal");
		
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
		
		exec_add[key + "_resp"].removeClass("modal");
		exec_add[key + "_stxt"].html(value);
		if(type === "href" || type === "rela"){
			engine_follow_pool[exec_add.engine_curr_index]["value"] = v2;
			engine_follow_pool[exec_add.engine_curr_index]["show_value"] = show_value;
		}else{
			engine_follow_pool[exec_add.engine_curr_index]["value"] = value;
		}
		
		exec_add.engine_curr_index = parseInt(exec_add.engine_curr_index) + 1;
		
		scrollToButtom();
		
		loadChatsEngine();
	}
}
function loadLovData(obj, lovkey){
	$.each(lov_data_list[lovkey], function(){
		if(this.key && this.value){
			if(this.type === "href" || this.type === "rela"){
				obj.find(".href_con").append('<a href="javascript:void(0)" key="'+ this.key +'">'+ this.show_value +'</a>&nbsp;&nbsp;');
			}else{
				obj.find(".href_con").append('<a href="javascript:void(0)" key="'+ this.key +'">'+ this.value +'</a>&nbsp;&nbsp;');
			}
		}
	});
}

function loadRelaData(elementid, opt){
	var setting = $.extend({
		crmid: exec_add.crmid,
		publicid: exec_add.publicid,
		openid: exec_add.openid
	}, opt);
	//调用接口
	ivk_createRelation(elementid, setting);
}

//提交
function saveExec(){
	$.each(engine_follow_pool, function(){
		exec_add.exec_form.append('<input type="hidden" name="'+ this.key +'" value="'+ this.value +'" />');
	});
	exec_add.exec_form.submit();
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
	exec_add.total.css("display", "");
	exec_add.totalDetail.empty().append(v);
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