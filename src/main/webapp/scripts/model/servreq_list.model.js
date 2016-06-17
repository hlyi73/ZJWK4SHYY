/**
 * 服务请求 列表页面
 */

var serveq_list = {};

function initServeReqElem(){
	serveq_list.menu = $("._menu");
	serveq_list.submenu  = $("._submenu ");
	serveq_list.navbar = $(".serverq_list_navbar");
	serveq_list.search_btn = serveq_list.navbar.find(".search_btn");
	serveq_list.viewtype_select = serveq_list.navbar.find(".viewtype_select");
	serveq_list.viewtypelabel = serveq_list.navbar.find(".viewtypelabel");
	serveq_list.status_sel = serveq_list.navbar.find("select[name=status]");
	
	serveq_list.menu_list = $(".menu_list");
	serveq_list.list_container = $(".list_container");
	serveq_list.next_page_btn = serveq_list.list_container.find(".next_page_btn");
	serveq_list.next_page_con = serveq_list.list_container.find(".next_page_con");
	
	serveq_list.search_container = $(".search_container");
	serveq_list.search_form = serveq_list.search_container.find("form[name=search_form]");
	serveq_list.checked_sysuser_list = serveq_list.search_form.find(".checked_sysuser_list");
	serveq_list.sysuser_choose_btn = serveq_list.search_form.find(".sysuser_choose_btn");
	serveq_list.start_date = serveq_list.search_form.find("#start_date");
	serveq_list.end_date = serveq_list.search_form.find("#end_date");
	serveq_list.search_cannel_btn = serveq_list.search_container.find(".search_cannel_btn");
	serveq_list.search_ok_btn = serveq_list.search_container.find(".search_ok_btn");
}

function initServreqBtn(){

	serveq_list.search_btn.click(function(){
		serveq_list.list_container.addClass("modal");
		serveq_list.search_container.removeClass("modal");
	});
	
	serveq_list.sysuser_choose_btn.click(function(){
		serveq_list.navbar.addClass("modal");
		serveq_list.search_container.addClass("modal");
		serveq_list.menu.addClass("modal");
		serveq_list.submenu.addClass("modal");
		ivk_showSysuserList();
	});
	
	serveq_list.search_cannel_btn.click(function(){
		serveq_list.navbar.removeClass("modal");
		serveq_list.list_container.removeClass("modal");
		serveq_list.search_container.addClass("modal");
	});
	
	serveq_list.search_ok_btn.click(function(){
		searchList();
	});
	
	//下一页
	serveq_list.next_page_btn.click(function(){
		loadNextPageHtml();
	});
	
	serveq_list.start_date.val('').scroller('destroy').scroller($.extend({preset : 'date',dateFormat:'yy-mm-dd'}, { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh'}));
	serveq_list.end_date.val('').scroller('destroy').scroller($.extend({preset : 'date',dateFormat:'yy-mm-dd'}, { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));

	serveq_list.viewtype_select.click(function(){
		viewtypeClick();
	});	
	
	$("body").click(function(e){
		if(serveq_list.menu_list.css("display") == "block" && e.target.className == ''){
			viewtypeClick();
		}
	});
	
	serveq_list.status_sel.val(serveq_list.status);//列表类型
	serveq_list.viewtypelabel.html(serveq_list.status_sel.find('option:selected').text());
	
}

function loadNextPageHtml(){
	var currpage = serveq_list.search_form.find(":hidden[name=currpage]").val();
	var pagecount = serveq_list.search_form.find(":hidden[name=pagecount]").val();
	var nextpage = parseInt(currpage) + 1;
	serveq_list.search_form.find(":hidden[name=currpage]").val(nextpage)
	$.ajax({
	      url: getContentPath() + '/complaint/asycn_list',
	      data: {
			   servertype: 'case',
			   currpage: nextpage,
			   pagecount: '10',
			   viewtype: 'teamview',
			   status: serveq_list.status_sel.val(),
			   openid: serveq_list.openid,
			   publicid: serveq_list.publicid
		  },
	      success: function(data){
	    	  data = JSON.parse(data);
	    	  compNextPageHtml(data);
	      }
	});
}

function compNextPageHtml(data){
	    if(data.length === 0){
	    	serveq_list.next_page_con.css("display", "none");
	    	return ;
	    }
		$.each(data, function(i){
			var html = '<a href=" '+ getContentPath() + '/complaint/detail?rowid='+ this.rowid +'&servertype='+ serveq_list.servertype +'&openid='+ serveq_list.openid +'&publicid='+ serveq_list.publicid +'&crmid='+ serveq_list.crmid +'"'; 
				html +='	      class="list-group-item listview-item">';
				html +='			<div class="list-group-item-bd">';
				html +='				<div class="thumb list-icon">';
				html +='					<b>'+ this.status_name +'</b>';
				html +='				</div>';
				html +='				<div class="content">';
				html +='					<h1>'+ this.case_number +'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+ this.handle_name +'</span></h1>';
				if(this.subtype_name != ''){
					html +='<p class="text-default">服务分类:&nbsp;&nbsp;'+ this.subtype_name +'</p>';
				}
				if(this.handle_date != ''){
					html +='<p class="text-default">受理日期:&nbsp;&nbsp;'+ this.handle_date +'</p>';
				}
				if(this.sponsor != ''){
					html +='<p class="text-default">发起人:&nbsp;&nbsp;'+ this.sponsor +'</p>';
				}
				if(this.name != ''){
					if(this.name.length > 40){
						html +='<p class="text-default">客户诉求:&nbsp;&nbsp;'+ this.name.substr(0, 40) +'...</p>';
					}else{
						html +='<p class="text-default">客户诉求:&nbsp;&nbsp;'+ this.name +'</p>';
					}
				}
				if(this.finish_time == '' && this.stopday > 0){
					html +='<p class="text-default">停留时间:&nbsp;&nbsp;' + this.stopday + '天</p>';
				}
				if(this.finish_time !== ''){
					html +='<p class="text-default">处理时长:&nbsp;&nbsp;' + this.stopday + '天</p>';
				}
				html +='			</div>';
				html +='		</div>';
				html +='		<div class="list-group-item-fd">';
				html +='			<span class="icon icon-uniE603"></span>';
				html +='			</div>';
				html +='		</a>';
			
			serveq_list.list_container.find(".compslist").append(html); 
		});
}


function viewtypeClick(){
	if(serveq_list.menu_list.css("display") == "none"){
		serveq_list.menu_list.css("display","");
		serveq_list.menu_list.animate({height : 90}, [ 10000 ]);
		serveq_list.list_container.css("display","none");
	}else{
		serveq_list.menu_list.animate({height : 0}, [ 10000 ]);
		serveq_list.menu_list.css("display","none");
		serveq_list.list_container.css("display","");
	}
}

//查询列表
function searchList() {
	//追加责任人id
	serveq_list.checked_sysuser_list = serveq_list.search_form.find(".checked_sysuser_list");
	var sysuser_ids = '';
	serveq_list.checked_sysuser_list.find("span").each(function(){
		if($(this).attr("sysuser_id")){
			sysuser_ids += $(this).attr("sysuser_id") + ",";
		}
	});
	var status = serveq_list.search_form.find("select[name=status]");
	alert(status);
	alert(!status);
	if(!status){
		serveq_list.search_form.find(":hidden[name=viewtype]").val("teamview");
	}
	serveq_list.search_form.find(":hidden[name=assignId]").val(sysuser_ids);
	
	//提交查询表单
	serveq_list.search_form.submit();
}

//callback -> 选择系统用户之后 点击 确定按钮 的回调函数 
function callback_system_ok_btn_click(ids, names){
	ivk_hideSysuserList();
	serveq_list.menu.removeClass("modal");
	serveq_list.submenu.removeClass("modal");
	serveq_list.search_container.removeClass("modal");
	//遍历追加
	serveq_list.checked_sysuser_list.empty();
	for(var i = 0 ; i < ids.split(",").length ; i ++){
		var id = ids.split(",")[i], n = names.split(",")[i];
		var tpl = '<span style="margin-left: 10px;"><span>'+ n +'</span></span>';
		if(id){
			serveq_list.checked_sysuser_list.append($(tpl).attr({"sysuser_id": id,"sysuser_name": n }));
		}
	}
}

//callback -> 点击回退按钮 之后  的回调函数 
function callback_sysuser_gobak_btn_click(data){
	serveq_list.search_container.removeClass("modal");
}

function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}