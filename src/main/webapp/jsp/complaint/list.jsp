<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- common include -->
<%@ include file="/common/comlibs.jsp"%>
<!--js类库-->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js" ></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"></script>
<!--css框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"  />
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css"/>

<script type="text/javascript">
$(function () {
	complaint_list.openid = '${openid}';
	complaint_list.publicid = '${publicid}';
	complaint_list.status = '${status}';
	
	initServeReqElem();
	initServeReqBtn();
});

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
		complaint_list.menu_list.animate({height : 150}, [ 10000 ]);
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
	
	var status = complaint_list.search_form.find("select[name=status]");
	if(!status.val()){
		complaint_list.search_form.find(":hidden[name=viewtype]").val("teamview");
	}
	complaint_list.search_form.find(":hidden[name=assignId]").val(sysuser_ids);
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

</script>

</head>
<body>
    <!-- 头部下拉框区域 -->
	<div id="site-nav" class="navbar complaint_list_navbar">
	    <!-- 回退按钮 -->
		<jsp:include page="/common/back.jsp"></jsp:include>
		<c:if test="${viewtype ne 'analyticsview' }">
		<div class="search_btn" style="float: left; cursor: pointer; margin-top: 15px;">
			<img src="<%=path%>/image/wxsearch.png">
		</div>
		</c:if>
		<div class="act-secondary">
			<a href="<%=path%>/complaint/get?servertype=${servertype}&openid=${openid}&publicid=${publicid}" style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a> 
		</div>
		<!-- 下拉选择框 -->
		<a href="javascript:void(0)" class="list-group-item listview-item">
		    <form name="statusForm" action="<%=path%>/complaint/list" method="post">
		        <input type="hidden" name="openid" value="${openid}" />
		        <input type="hidden" name="openid" value="${publicid}" />
		        <input type="hidden" name="currpage" value="1" />
				<div class="list-group-item-bd" style="width:180px;margin:0 auto;padding-top:5px;" >
					<p>
						<div class="form-control select viewtype_select">
							<div class="select-box viewtypelabel"></div>
							<select name="status" style="display:none;">
								<option value="">所有投诉</option>
								<option value="New">待处理投诉</option>
								<option value="Closed">已关闭投诉</option>
							</select>
						</div>
					</p>
				</div>
			</form>
		</a>
	</div>
	<!-- 下拉菜单 -->
	<div class="menu_list" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
		<a href="<%=path%>/complaint/list?viewtype=&servertype=${servertype}&status=New&openid=${openid}&publicid=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;待处理投诉
			</div>
		</a>
		<a href="<%=path%>/complaint/list?viewtype=&servertype=${servertype}&status=Closed&openid=${openid}&publicid=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;已关闭投诉
			</div>
		</a>
		<a href="<%=path%>/complaint/list?servertype=${servertype}&status=&openid=${openid}&publicid=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;所有投诉
			</div>
		</a>
		<div style="clear:both;width:100%;border-top:1px solid #ffefef;"></div>
		<a href="<%=path%>/analytics/complaint/month?servertype=${servertype}&openId=${openid}&publicId=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;投诉分析-by月
			</div>
		</a>
		<a href="<%=path%>/analytics/complaint/subtype?servertype=${servertype}&openId=${openid}&publicId=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;投诉分析-by类型
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/analytics/complaint/depart?servertype=${servertype}&openId=${openid}&publicId=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;投诉分析-by部门
			</div>
		</a>
		<div style="clear:both"></div>
	</div>
	<!-- 列表区域 -->
	<div class="site-recommend-list page-patch list_container">
		<div class="list-group listview compslist" style="margin-top:-1px;" id="div_tasks_list">
			<c:forEach items="${compslist}" var="comp">
				<a href="<%=path%>/complaint/detail?rowid=${comp.rowid}&servertype=${servertype}&openid=${openid}&publicid=${publicid}&crmid=${crmid}" 
					class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<div class="thumb list-icon">
							<b>${comp.status_name}</b>
						</div>
						<div class="content">
							<h1>${comp.case_number}&nbsp;<span style="color: #AAAAAA; font-size: 12px;">${comp.handle_name}</span></h1>
							<c:if test="${comp.subtype_name != ''}">
								<p class="text-default">投诉分类:&nbsp;&nbsp;${comp.subtype_name}</p>
							</c:if>
							<c:if test="${comp.handle_date != ''}">
								<p class="text-default">受理日期:&nbsp;&nbsp;${comp.handle_date}</p>
							</c:if>
							
							<c:if test="${comp.sponsor != '' }">
								<p class="text-default">发起人:&nbsp;&nbsp;${comp.sponsor}</p>
							</c:if>
							<c:if test="${comp.name != '' }">
								<c:if test="${fn:length(comp.name) >= 40}">
									<p class="text-default">投诉内容:&nbsp;&nbsp;${fn:substring(comp.name,0,40)}...</p>
								</c:if>
								<c:if test="${fn:length(comp.name) < 40}">
									<p class="text-default">投诉内容:&nbsp;&nbsp;${comp.name}</p>
								</c:if>
							</c:if>
							<c:if test="${comp.finish_time == '' && comp.stopday > 0}">
								<p class="text-default">停留时间:&nbsp;&nbsp;${comp.stopday}天</p>
							</c:if>
							<c:if test="${comp.finish_time != ''}">
								<p class="text-default">处理时长:&nbsp;&nbsp;${comp.stopday}天</p>
							</c:if>
						</div>
					</div>
					<div class="list-group-item-fd">
						<span class="icon icon-uniE603"></span>
					</div>
				</a>
			</c:forEach>
			<!-- 数据为空判断 -->
			<c:if test="${fn:length(compslist) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有找到数据</div>
			</c:if>
		</div>
		<!-- 翻页 -->
		<c:if test="${fn:length(compslist)==10 }">
			<div class="next_page_con" style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;">
				<a href="javascript:void(0)" class="next_page_btn">
					下一页&nbsp;<img id="nextpage" src="<%=path%>/image/nextpage.png" width="24px"/>
				</a>
			</div>
		</c:if>
	</div>
	<!-- 查询区域 -->
	<div class="site-card-view modal search_container" style="font-size: 14px; position: absolute; top: 0px; left: 0px; width: 100%; height: 800px; z-index: 999; background: #fff; opacity: 0.99;">
		<div style="width: 100%;">
			<form name="search_form" action="<%=path%>/complaint/list">
				<input type="hidden" name="servertype" value="complaint">
				<input type="hidden" name="currpage" value="1" />
		        <input type="hidden" name="pagecount" value="10" />
		        <input type="hidden" name="assignId" value="" />
		        <input type="hidden" name="openid" value="${openid}" />
		        <input type="hidden" name="publicid" value="${publicid}" />
		        <input type="hidden" name="viewtype" value="myview" />
				<div style="width: 100%; background-color:RGB(75, 192, 171); text-align: center; line-height:51px; height:51px; color: #ffffff;font-size:16px;">查询</div>
				<div class="search_div">
					<div style="float: left; padding-top: 4px;">投诉编号：</div>
					<div style="line-height: 25px; padding-left: 78px">
						<input type="text" name="case_number" style="width: 90%">
					</div>
				</div>
				<div class="search_div">
					<div style="float: left; padding-top: 4px;">投诉状态：</div>
					<div style="line-height: 25px; padding-left: 78px">
						<select name="status" style="width: 90%;height: 30px;">
							<option value="">所有投诉</option>
							<option value="New">待处理投诉</option>
							<option value="Closed">已关闭投诉</option>
						</select>
					</div>
				</div>
				<div style="clear: both;"></div>
			</form>
		</div>
		<div class="wrapper" style="margin-top: 50px;">
			<div class="button-ctrl">
				<fieldset class="">
					<div class="ui-block-b">
						<a href="javascript:void(0)" class="btn btn-block search_cannel_btn" style="background-color: #999999;font-size: 14px;">取 消 </a>
					</div>
					<div class="ui-block-a">
						<a href="javascript:void(0)" class="btn btn-success btn-block search_ok_btn" style="background-color: #49af53" style="font-size: 14px;">查 询 </a>
					</div>
				</fieldset>
			</div>
		</div>
	</div>
	<!-- 底部页面 -->
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>