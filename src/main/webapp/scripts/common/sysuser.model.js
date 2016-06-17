/**
 * 系统用户
 */
//ivk 供外部系统调用 显示系统用户列表
function ivk_showSysuserList(){
	sysuser.sysuser_container.removeClass("modal");
}

//ivk 供外部系统调用 隐藏系统用户列表
function ivk_hideSysuserList(){
	sysuser.sysuser_container.addClass("modal");
}

//ivk 供外部系统调用 隐藏系统用户列表
function ivk_getCheckedSysuser(){
	return sysuser.sysuser_id_checked;
}

//ivk 供外部系统调用 隐藏系统用户列表
function ivk_getCheckedSysuserNames(){
	return sysuser.sysuser_name_checked;
}


var sysuser = {};

function initSysuserElem(){
	sysuser.sysuser_container = $(".sysuser_container");
	sysuser.sysuser_gobak = sysuser.sysuser_container.find(".sysuser_gobak");
	sysuser.sysuser_list = sysuser.sysuser_container.find(".sysuser_list");
	sysuser.sysuser_btn = sysuser.sysuser_container.find(".sysuser_btn");
	sysuser.chart_list = sysuser.sysuser_container.find(".chart_list");
	sysuser.sysuser_href_list = sysuser.sysuser_list.find(".sysuser_href_list");
	sysuser.fst_char = sysuser.sysuser_list.find(":hidden[name='fst_char']");
	sysuser.curr_type = sysuser.sysuser_list.find(":hidden[name='curr_type']");
	sysuser.curr_page = sysuser.sysuser_list.find(":hidden[name='curr_page']");
	sysuser.page_count = sysuser.sysuser_list.find(":hidden[name='page_count']");
	
	sysuser.sysuser_id_checked = '';
	sysuser.sysuser_name_checked = '';
}

function initSysuserBtn(){

	sysuser.sysuser_gobak.click(function(){
		sysuser.sysuser_container.addClass("modal");
		$("._menu").removeClass("modal");
		$("._submenu").removeClass("modal");
		eval(sysuser.callback_sysuser_gobak_btn_click + '()');
	});
	
	sysuser.sysuser_btn.unbind("click").click(function(){
		var sysuser_id = '', sysuser_name = '';
		sysuser.sysuser_list.find("a.checked").each(function(){
			sysuser_id += $(this).find(":hidden[name=sysuser_id]").val() + ",";
			sysuser_name += $(this).find(":hidden[name=sysuser_name]").val() + ",";
		});
		if(!sysuser_id){
			$(".myMsgBox").css("display","").html("请选择责任人!");
    		$(".myMsgBox").delay(2000).fadeOut();
    		return;
		}
		sysuser.sysuser_id_checked = sysuser_id;
		sysuser.sysuser_name_checked = sysuser_name;

		eval(sysuser.callback_system_ok_btn_click + '("' + sysuser_id + '","'+ sysuser_name +'")');
	});
	
	sysuser.sysuser_list.find("a").click(function(){
		if(sysuser.single_select === "null"){
			sysuser.sysuser_list.find("a").removeClass("checked");
		}
		if($(this).hasClass("checked")){
			$(this).removeClass("checked");
		}else{
			$(this).addClass("checked");
		}
		return false;
	});
}


//按首字母查询
function loadSysuserList(){
	$.ajax({
		url: getContentPath() + '/lovuser/userlist',
		data: {
 			crmId: sysuser.crmid,
 			parentid: sysuser.rowid,
 			flag: sysuser.flag,
 			parenttype: sysuser.parent_type,
			firstchar: sysuser.fst_char.val(), 
			currpage: sysuser.curr_page.val(),
			pagecount: sysuser.page_count.val()  
 		},
	    success: function(data){
	    	if(!data) return;
 	    	var d = JSON.parse(data);
 	    	compSysuserChartData();
 	    	compSysuserData(d);
 	    	initSysuserBtn();
	    }
	});
}

//查询用户
function compSysuserChartData(){
	$.ajax({
		url: getContentPath() + '/fchart/list',
		async: 'false',
		data: {
			   crmId: sysuser.crmid,
			   type: sysuser.curr_type.val(),
			   flag:sysuser.flag
		},
	    success: function(data){
	    	if(!data) return;
    	    var d = JSON.parse(data);
    	    if(d.errorCode && d.errorCode !== '0'){
    	    	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
    	    	$(".myMsgBox").delay(2000).fadeOut();
	    	   return;
	    	}
    	    var ahtml = '';
    	    $(d).each(function(i){
    	    	ahtml += '<a href="javascript:void(0)"  style="margin: 0px 12px 0px 12px;">'+ this +'</a>';
    	    });
    	    sysuser.chart_list.html(ahtml);
    	    
    	    //点击字母
    	    sysuser.chart_list.find("a").unbind("click").bind("click", function(event){
    			sysuser.curr_page.val("1");
    			sysuser.fst_char.val($(this).html());
    			loadSysuserList();
    		});
	    }
	});
}

//异步加载用户
function compSysuserData(d){
	if(d.length === 0||(d.length===1&&d[0]===null)){
		sysuser.sysuser_list.empty().html('<div class="alert-info text-center" style="padding: 2em 0; margin: 3em 0">无数据</div>');
    	return;
    }
	//组装数据
	var val = '';
	$(d).each(function(i){
		if(!this.userid) return;
			val += '<a href="javascript:void(0)" class="list-group-item listview-item radio" >'
         		+ '		<div class="list-group-item-bd">'
         		+ '			<input type="hidden" name="sysuser_id" value="'+this.userid+'">'
         		+ '			<input type="hidden" name="sysuser_name" value="'+this.username+'">'
         		+ '		<h2 class="title">'+this.username+'</h2>'
         		+ '		<p>职称：'+this.title+'</p>'
         		+ '		<p>部门：<b>'+this.department+'</b></p></div><div class="input-radio" title="选择该条记录"></div>'
         		+ '</a>';
	});
	sysuser.sysuser_href_list.html(val);
}

function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0, index+1);
	 return contextPath; 
}