<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<!-- 日历控件 -->
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/wb/js/mobiscroll.core-2.5.2-zh.js"
	type="text/javascript"></script>
<link href="<%=path%>/scripts/plugin/wb/css/mobiscroll.core-2.5.2.css"
	rel="stylesheet" type="text/css" />
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/wb/js/mobiscroll.datetime-2.5.1-zh.js"
	type="text/javascript"></script>
<script type="text/javascript">
	$(function () {
		//initWeixinFunc();
    	initForm();
    	initDatePicker();
	});
	
	/* //微信网页按钮控制
	function initWeixinFunc(){
		//隐藏顶部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
	
	function initForm(){
		var selObj = $("select[name=typeName]");
		//下拉框初始化
		selObj.change(function(){
			$("form[name=typeNameForm]").submit();
			return false ;
		});
		//获取类型值
		selObj.val('${typeName}');
		$(".viewtypelabel").html(selObj.find("option:selected").text());
	}

	//初始化日期控件
    function initDatePicker(){
    	var opt = {
    		date : {preset : 'date',dateFormat:'yy-mm-dd',maxDate:new Date(2099,11,30)},
    		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
    		image_text : {preset : 'list', labels: ['Cars']},
    		select : {preset : 'select'}
    	};
    	//类型 date  datetime
    	$('#startDate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh'}));
    	$('#endDate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    }
	
    function topage(){
    	$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");
    	
		var currpage = $("input[name=currpage]").val();
		$("input[name=currpage]").val(parseInt(currpage) + 1);
		currpage = $("input[name=currpage]").val();
		$.ajax({
		      type: 'get',
		      url : '<%=path%>/articleInfo/alist' || '',
		      async: false,
		      data: {failure:'${failure}',createTime:'${endDate}',title:'${title}',createTime:'${startDate}',typeName:'${typeName}',currpage:currpage,pagecount:'10'} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_accnt_list").html();
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	$("#div_accnt_list").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	   return;
	    	    	}
					if(d != ""){
		    	    	if($(d).size() == 10){
		    	    		$("#div_next").css("display",'');
		    	    	}else{
		    	    		$("#div_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							val += '<a href="<%=path%>/articleInfo/detail?rowId='
														+ this.rowid
														+ '" class="list-group-item listview-item">'
														+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
														+ '<b>'
														+ this.image
														+ '</b> </div>'
														+ '<div class="content" style="text-align: left">'
														+ '<h1>'
														+ this.title
														+ '&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
														+ this.descrition
														+ '<div class="content" style="text-align: left">'
														+ this.createTime
														+ '</span></p>'
														+ '<p>创建日期:' + '</a>';
											});
						} else {
							$("#div_next").css("display", 'none');
						}
						$("#div_accnt_list").html(val);
						
						$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
					}
				});
	}

	//取消查询
	function closeSearch() {
		$("#div_search_content").addClass("modal");
		$("#site-nav").removeClass("modal");
		$(".knowlege_list").removeClass("modal");
		$("footer").removeClass("modal");
	}

	//查询
	function search() {
		$("#div_search_content").removeClass("modal");
		$("#site-nav").addClass("modal");
		$(".knowlege_list").addClass("modal");
		$("footer").addClass("modal");
	}

	//提交查询
	function searchList() {
		$("form[name=alistForm]").submit();
	}

// 	function selectSalesStage(obj, stage) {
// 		var search_div = $("#search_div");
// 		search_div.find("a").each(function(index) {
// 			search_div.find("a").removeClass("selected");
// 		});
// 		obj.className = "selected";
// 		$("input[name=salesstage]").val(stage);
// 	}
</script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<div class="act-secondary" data-toggle="navbar"
			data-target="nav-collapse">
<!-- 			<i class="icon-menu"><b></b></i> -->
		</div>

		<c:if test="${viewtype ne 'analyticsview' }">
			<div id="div_search" onclick="search();"
				style="float: left; cursor: pointer; margin-top: 15px;">
				<img src="<%=path%>/image/wxsearch.png">
			</div>
		</c:if>
		<input type="hidden" name="currpage" value="1" /> <a
			href="javascript:void(0)" class="list-group-item listview-item">
			<form name="typeNameForm"
				action="<%=path%>/articleInfo/list"
				method="post">
				<div class="list-group-item-bd"
					style="width: 180px; margin: 0 auto; padding-top: 5px;">
					<p>
					<div class="form-control select _viewtype_select">
						<div class="select-box viewtypelabel"></div>
							<select name="typeName" id="typeName" style="display:none">
						<c:forEach items="${artTypeList }" var="list">
								<option value="${list.code }">${list.name }</option>
						</c:forEach>
							</select>
					</div>
					</p>
				</div>
			</form>
		</a>
	</div>

	<!-- 下拉菜单选项 -->
	<script>
	$(function () {
		$("._viewtype_select").click(function(){
			viewtypeClick();
		});	
		
		$("body").click(function(e){
			if($("#_viewtype_menu").css("display") == "block" && e.target.className == ''){
				viewtypeClick();
			}
		});
	});
	
	function viewtypeClick(){
		if($("#_viewtype_menu").css("display") == "none"){
			$("#_viewtype_menu").css("display","");
			$("#_viewtype_menu").animate({height : 125}, [ 10000 ]);
			$(".knowlege_list").css("display","none");
		}else{
			$("#_viewtype_menu").animate({height : 0}, [ 10000 ]);
			$("#_viewtype_menu").css("display","none");
			$(".knowlege_list").css("display","");
		}
	}
	
	</script>
	<div class="_viewtype_menu_class" id="_viewtype_menu" style="width:100%;padding:10px;background-color:#fff;display:none;text-align:left;font-size:14px;"> 
		<c:forEach items="${artTypeList }" var="list" varStatus="stat">
			 <c:if test="${stat.index % 2 == 0 }">
			 	 <div style="clear:both"></div>
			 </c:if>
			 <a href="<%=path%>/articleInfo/list?typeName=${list.code}">
				<div style="float:left;padding:10px;width:50%;">
					<img src="<%=path%>/image/icon_cirle.png">&nbsp;${list.name }
				</div>
			</a>
		</c:forEach>
		<div style="clear:both"></div>
	</div>
	<div class="knowlege_list">
	<!-- 下拉菜单选项 end -->
	<c:forEach items="${mlist }" var="accnt">
		<c:if test="${accnt.status eq '1' }">
			<div style="width:100%;text-align:center;margin-top:10px;">
				<span style="background-color:#ccc;border-radius:10px;width:100px;padding:0 5px 0 5px;color:#FFF;font-size:12px;">
					<fmt:formatDate value="${accnt.createTime }" type="both" pattern="yyyy-MM-dd" />
				</span>
			</div>
			<a href="<%=path%>/articleInfo/detail?id=${accnt.id}" class="list-group-item listview-item">
				<div style="width:100% auto;margin:10px 10px 0 10px;border:1px solid #dfdfdf;background-color:#FFF;">
					<div style="background-color:#FFF;line-height:35px;height:35px;padding-left:5px;">
						<h1 style="color: #666;">${accnt.title }</h1>
					</div>
					<div style="margin:10px;">
						<img src="${accnt.image}" width="100%;" height="120px;">
					</div>
					<div style="margin:0 10px 10px 10px;line-height:25px;color:#666;font-size:14px;">
						&nbsp;&nbsp;&nbsp;&nbsp;
						<c:if test="${fn:length(accnt.descrition) <= 50 }">
							${accnt.descrition}
						</c:if>
						<c:if test="${fn:length(accnt.descrition) > 50 }">
							${fn:substring(accnt.descrition, 0, 50)}...
						</c:if>
					</div>
				</div>
			</a>
		</c:if>
	</c:forEach>
	<c:if test="${fn:length(mlist) == 0 }">
				<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
	</c:if>
	<c:if test="${fn:length(mlist)==10 }">
		<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
				<a href="javascript:void(0)" onclick="topage()">
					下一页&nbsp;<img id="nextpage" src="<%=path %>/image/nextpage.png" width="24px"/>
				</a>
		</div>
	</c:if>
	</div>
	

	<!-- 查询区域 -->
	<div id="div_search_content" class="site-card-view modal"
		style="font-size: 14px; position: absolute; top: 0px; left: 0px; width: 100%; height: 800px; z-index: 999; background: #fff; opacity: 0.99;">
		<div style="width: 100%;">
			<form name="alistForm" method="post"
				action="<%=path%>/articleInfo/list?typeName=${typeName}">
				<div
					style="width: 100%; background-color:RGB(75, 192, 171); text-align: center; line-height: 3.5em; color: #ffffff;font-size:16px;">查询</div>
				<div id="search_div1" class="search_div">
					<div style="float: left; padding-top: 4px;">标&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						题：</div>
					<div style="line-height: 25px; padding-left: 78px">
						<input type="text" name="title" id="title" style="width: 90%">
					</div>
				</div>
				<div id="search_div2" class="search_div">
					<div style="float: left; line-height: 30px;">创建日期：&nbsp;&nbsp;</div>
					<div>
						<input name="startDate" id="startDate" value=""
							style="width: 110px; vertical-align: middle;" type="text"
							placeholder="开始" readonly=""> <span>-</span> <input
							name="endDate" id="endDate" value="" style="width: 110px;"
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
						<a href="javascript:void(0)" 
							class="btn btn-block" style="background-color: #999999"
							style="font-size: 14px;" onclick="closeSearch()"> 取 消 </a>
					</div>
					<div class="ui-block-a">
						<a href="javascript:void(0)" 
							class="btn btn-success btn-block"
							style="background-color: #49af53" style="font-size: 14px;"
							onclick="searchList()"> 查 询 </a>
					</div>
				</fieldset>
			</div>
		</div>
	</div>

	<jsp:include page="/common/footer.jsp"></jsp:include>

</body>
</html>