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
	serveq_list.openid = '${openid}';
	serveq_list.publicid = '${publicid}';
	serveq_list.status = '${status}';
	serveq_list.servertype = '${servertype}';
	serveq_list.crmid = '${crmid}';
	
	initServeReqElem();
	initServreqBtn();
});

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
		$("._menu").removeClass("modal");
		$("._submenu").removeClass("modal");
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
		serveq_list.menu_list.animate({height : 150}, [ 10000 ]);
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
	if(!status.val()){
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

</script>

</head>
<body>
    <!-- 头部下拉框区域 -->
	<div id="site-nav" class="navbar serverq_list_navbar">
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
		        <input type="hidden" name="pagecount" value="10" />
				<div class="list-group-item-bd" style="width:180px;margin:0 auto;padding-top:5px;" >
					<p>
						<div class="form-control select viewtype_select">
							<div class="select-box viewtypelabel"></div>
							<select name="status" style="display:none;">
								<option value="New">待处理的服务</option>
								<option value="Processed">待回访的服务</option>
								<option value="Closed">已关闭的服务</option>
								<option value="">所有的服务</option>
							</select>
						</div>
					</p>
				</div>
			</form>
		</a>
	</div>
	<!-- 下拉菜单 -->
	<div class="menu_list" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
		<a href="<%=path%>/complaint/list?servertype=${servertype}&viewtype=myview&status=New&openid=${openid}&publicid=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;待处理的服务
			</div>
		</a>
		<a href="<%=path%>/complaint/list?servertype=${servertype}&viewtype=myview&status=Processed&openid=${openid}&publicid=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;待回访的服务
			</div>
		</a>
		<a href="<%=path%>/complaint/list?servertype=${servertype}&viewtype=myview&status=Closed&openid=${openid}&publicid=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;已关闭的服务
			</div>
		</a>
		<a href="<%=path%>/complaint/list?servertype=${servertype}&viewtype=teamview&status=&openid=${openid}&publicid=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;所有的服务
			</div>
		</a>
		<div style="clear:both;width:100%;border-top:1px solid #ffefef;"></div>
		<a href="<%=path%>/analytics/complaint/month?servertype=${servertype}&openId=${openid}&publicId=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;服务请求分析-by月
			</div>
		</a>
		<a href="<%=path%>/analytics/complaint/subtype?servertype=${servertype}&openId=${openid}&publicId=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;服务请求分析-by类型
			</div>
		</a>
		<div style="clear:both"></div>
		<a href="<%=path%>/analytics/complaint/depart?servertype=${servertype}&openId=${openid}&publicId=${publicid}">
			<div style="float:left;padding:10px;width:50%;">
				<img src="<%=path%>/image/icon_cirle.png">&nbsp;服务请求分析-by部门
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
							<c:if test="${comp.subtype_name != '' }">
								<p class="text-default">服务分类:&nbsp;&nbsp;${comp.subtype_name}</p>
							</c:if>
							<c:if test="${comp.handle_date != '' }">
								<p class="text-default">受理日期:&nbsp;&nbsp;${comp.handle_date}</p>
							</c:if>
							<c:if test="${comp.sponsor != '' }">
								<p class="text-default">发起人:&nbsp;&nbsp;${comp.sponsor}</p>
							</c:if>
							<c:if test="${comp.name != '' }">
								<c:if test="${fn:length(comp.name) >= 40}">
									<p class="text-default">客户诉求:&nbsp;&nbsp;${fn:substring(comp.name,0,40)}...</p>
								</c:if>
								<c:if test="${fn:length(comp.name) < 40}">
									<p class="text-default">客户诉求:&nbsp;&nbsp;${comp.name}</p>
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
			    <input type="hidden" name="currpage" value="1" />
		        <input type="hidden" name="pagecount" value="10" />
		        <input type="hidden" name="assignId" value="" />
		        <input type="hidden" name="openid" value="${openid}" />
		        <input type="hidden" name="publicid" value="${publicid}" />
		        <input type="hidden" name="viewtype" value="myview" />
				<div style="width: 100%; background-color:RGB(75, 192, 171); text-align: center; line-height:51px; height:51px; color: #ffffff;font-size:16px;">查询</div>
				<div class="search_div">
					<div style="float: left; padding-top: 4px;">服务编号：</div>
					<div style="line-height: 25px; padding-left: 78px">
						<input type="text" name="case_number" style="width: 90%">
					</div>
				</div>
				<div class="search_div">
					<div style="float: left; padding-top: 4px;">服务状态：</div>
					<div style="line-height: 25px; padding-left: 78px">
						<select name="status" style="width: 90%;height: 30px;">
							<option value="">所有的服务</option>
							<option value="New">待处理的服务</option>
							<option value="Processed">待回访的服务</option>
							<option value="Closed">已关闭的服务</option>
						</select>
					</div>
				</div>
				<div class="search_div">
					<div style="float: left; margin-top: 3px;">责&nbsp;任&nbsp;人:&nbsp;</div>
					<div class="checked_sysuser_list" style="float: left;padding-top: 6px;"></div>
					<div class="sysuser_choose_btn">
						<img src="<%=path%>/image/addusers.png" width="30px" border="0" 
						      style="margin-left: 15px; cursor: pointer;" />
					</div>
				</div>
				<div class="search_div">
					<div style="float: left; line-height: 30px;">日期：</div>
					<div>
						<input name="start_date" id="start_date" style="width: 110px; vertical-align: middle;" 
						    type="text" placeholder="开始" readonly=""> 
						<span>-</span> 
						<input name="end_date" id="end_date" value="" style="width: 110px;"
							type="text" placeholder="结束" readonly="">
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
	<!-- 系统用户页面 -->
	<jsp:include page="/common/sysuser.jsp">
		<jsp:param name="rowid"  value="${rowid}"/>
		<jsp:param name="crmid"  value="${crmid}"/>
		<jsp:param name="flag"  value="branch"/>
		<jsp:param name="parent_type"  value="Cases"/>
		<jsp:param name="callback_system_ok_btn_click"  value="callback_system_ok_btn_click"/>
		<jsp:param name="callback_sysuser_gobak_btn_click"  value="callback_sysuser_gobak_btn_click"/>
	</jsp:include>
	<!-- 底部页面 -->
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>