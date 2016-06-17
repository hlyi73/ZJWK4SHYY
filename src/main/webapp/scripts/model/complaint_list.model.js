/**
 * 服务请求 列表页面
 */

var complaint_list = {};

function initServeReqElem(){
	
	complaint_list.navbar = $(".complaint_list_navbar");
	complaint_list.search_btn = complaint_list.navbar.find(".search_btn");
	complaint_list.viewtype_select = complaint_list.navbar.find(".viewtype_select");
	complaint_list.viewtypelabel = complaint_list.navbar.find(".viewtypelabel");
	complaint_list.status_sel = complaint_list.navbar.find("select[name=status]");
	
	complaint_list.menu_list = $(".menu_list");
	complaint_list.list_container = $(".list_container");
	complaint_list.next_page_btn = complaint_list.list_container.find(".next_page_btn");
	complaint_list.next_page_con = complaint_list.list_container.find(".next_page_con");
	
	complaint_list.search_container = $(".search_container");
	complaint_list.search_form = complaint_list.search_container.find("form[name=search_form]");
	complaint_list.checked_sysuser_list = complaint_list.search_form.find(".checked_sysuser_list");
	complaint_list.sysuser_choose_btn = complaint_list.search_form.find(".sysuser_choose_btn");
	complaint_list.start_date = complaint_list.search_form.find("#start_date");
	complaint_list.end_date = complaint_list.search_form.find("#end_date");
	complaint_list.search_cannel_btn = complaint_list.search_container.find(".search_cannel_btn");
	complaint_list.search_ok_btn = complaint_list.search_container.find(".search_ok_btn");
}

function initServeReqBtn(){

	complaint_list.search_btn.click(function(){
		complaint_list.list_container.addClass("modal");
		complaint_list.search_container.removeClass("modal");
	});
	
	complaint_list.sysuser_choose_btn.click(function(){
		complaint_list.navbar.addClass("modal");
		complaint_list.search_container.addClass("modal");
		ivk_showSysuserList();
	});
	
	complaint_list.search_cannel_btn.click(function(){
		complaint_list.list_container.removeClass("modal");
		complaint_list.search_container.addClass("modal");
	});
	
	complaint_list.search_ok_btn.click(function(){
		searchList();
	});
	
	//下一页
	complaint_list.next_page_btn.click(function(){
		loadNextPageHtml();
	});
	
	complaint_list.start_date.val('').scroller('destroy').scroller($.extend({preset : 'date',dateFormat:'yy-mm-dd'}, { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh'}));
	complaint_list.end_date.val('').scroller('destroy').scroller($.extend({preset : 'date',dateFormat:'yy-mm-dd'}, { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));

	complaint_list.viewtype_select.click(function(){
		viewtypeClick();
	});	
	
	$("body").click(function(e){
		if(complaint_list.menu_list.css("display") == "block" && e.target.className == ''){
			viewtypeClick();
		}
	});
	
	complaint_list.status_sel.val(complaint_list.status);//列表类型
	complaint_list.viewtypelabel.html(complaint_list.status_sel.find('option:selected').text());
	
}


function loadNextPageHtml(){
	
	var currpage = complaint_list.search_form.find(":hidden[name=currpage]").val();
	var pagecount = complaint_list.search_form.find(":hidden[name=pagecount]").val();
	var nextpage = parseInt(currpage) + 1;
	complaint_list.search_form.find(":hidden[name=currpage]").val(nextpage);
	
	$.ajax({
	      url: getContentPath() + '/complaint/asycn_list',
	      data: {
			   servertype: 'case',
			   currpage: nextpage,
			   pagecount: '10',
			   viewtype: 'teamview',
			   status: complaint_list.status_sel.val(),
			   openid: complaint_list.openid,
			   publicid: complaint_list.publicid
		  },
	      success: function(data){
	    	  data = JSON.parse(data);
	    	  compNextPageHtml(data);
	      }
	});
}

function compNextPageHtml(data){
	    if(data.length === 0){
	    	complaint_list.next_page_con.css("display", "none");
	    	return ;
	    }
		$.each(data, function(i){
			var html = '<a href=" '+ getContentPath() + '/complaint/detail?rowid='+ this.rowid +'&servertype='+ complaint_list.servertype +'&openid='+ complaint_list.openid +'&publicid='+ complaint_list.publicid +'&crmid='+ complaint_list.crmid +'"'; 
				html +='	      class="list-group-item listview-item">';
				html +='			<div class="list-group-item-bd">';
				html +='				<div class="thumb list-icon">';
				html +='					<b>'+ this.status_name +'</b>';
				html +='				</div>';
				html +='				<div class="content">';
				html +='					<h1>'+ this.case_number +'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'+ this.handle_name +'</span></h1>';
				if(this.subtype_name != ''){
					html +='<p class="text-default">投诉分类:&nbsp;&nbsp;'+ this.subtype_name +'</p>';
				}
				if(this.handle_date != ''){
					html +='<p class="text-default">受理日期:&nbsp;&nbsp;'+ this.handle_date +'</p>';
				}
				if(this.sponsor != ''){
					html +='<p class="text-default">发起人:&nbsp;&nbsp;'+ this.sponsor +'</p>';
				}
				if(this.name != ''){
					if(this.name.length > 40){
						html +='<p class="text-default">投诉内容:&nbsp;&nbsp;'+ this.name.substr(0, 40) +'...</p>';
					}else{
						html +='<p class="text-default">投诉内容:&nbsp;&nbsp;'+ this.name +'</p>';
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
			
			complaint_list.list_container.find(".compslist").append(html); 
		});
}

function viewtypeClick(){
	if(complaint_list.menu_list.css("display") == "none"){
		complaint_list.menu_list.css("display","");
		complaint_list.menu_list.animate({height : 90}, [ 10000 ]);
		complaint_list.list_container.css("display","none");
	}else{
		complaint_list.menu_list.animate({height : 0}, [ 10000 ]);
		complaint_list.menu_list.css("display","none");
		complaint_list.list_container.css("display","");
	}
}

//查询列表
function searchList() {
	//追加责任人id
	complaint_list.checked_sysuser_list = complaint_list.search_form.find(".checked_sysuser_list");
	var sysuser_ids = '';
	complaint_list.checked_sysuser_list.find("span").each(function(){
		if($(this).attr("sysuser_id")){
			sysuser_ids += $(this).attr("sysuser_id") + ",";
		}
	});
	complaint_list.search_form.append('<input type="hidden" name="assignId" value="'+ sysuser_ids +'"/>');
	
	
	//提交查询表单
	complaint_list.search_form.submit();
}

//callback -> 选择系统用户之后 点击 确定按钮 的回调函数 
function callback_system_ok_btn_click(ids, names){
	ivk_hideSysuserList();
	complaint_list.search_container.removeClass("modal");
	//遍历追加
	complaint_list.checked_sysuser_list.empty();
	for(var i = 0 ; i < ids.split(",").length ; i ++){
		var id = ids.split(",")[i], n = names.split(",")[i];
		var tpl = '<span style="margin-left: 10px;"><span>'+ n +'</span></span>';
		if(id){
			complaint_list.checked_sysuser_list.append($(tpl).attr({"sysuser_id": id,"sysuser_name": n }));
		}
	}
}

//callback -> 点击回退按钮 之后  的回调函数 
function callback_sysuser_gobak_btn_click(data){
	complaint_list.search_container.removeClass("modal");
}

function getContentPath(){
	 var contextPath = document.location.pathname; 
	 var index =contextPath.substr(1).indexOf("/"); 
	 contextPath = contextPath.substr(0,index+1);
	 return contextPath; 
}