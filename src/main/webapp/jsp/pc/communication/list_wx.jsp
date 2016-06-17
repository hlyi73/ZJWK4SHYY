<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<script src="<%=path%>/scripts/navbar.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
	$(function () {
		initWeixinFunc();
    	initForm();
	});
	
	//微信网页按钮控制
	function initWeixinFunc(){
		//隐藏顶部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	}
	
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
    		date : {preset : 'date',dateFormat:'yy-mm-dd'},
    		tree_list : {preset : 'list', labels: ['Region', 'Country', 'City']},
    		image_text : {preset : 'list', labels: ['Cars']},
    		select : {preset : 'select'}
    	};
    	//类型 date  datetime
    	$('#startDate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh'}));
    	$('#endDate').val('').scroller('destroy').scroller($.extend(opt['date'], { theme: 'default', mode: 'scroller', display: 'modal', lang: 'zh' }));
    }
	function topage() {
			var currpage = $("input[name=currpage]").val();
			$("input[name=currpage]").val(parseInt(currpage) + 1);
			currpage = $("input[name=currpage]").val();
			$.ajax({
				type : 'get',
				url : '<%=path%>/articleInfo/alist' || '',			
			    async: false,
		        data: {title:'${title}',author:'${author}',image:'${image}',typeName:'${typeName}',
		     	currpage:currpage,publicId:'${publicId}',openId:'${openId}',pagecount:'10'} || {},
			    dataType: 'text',
			    success: function(data){
			    	    var val = $("#div_accnt_list").html();
			    	    var d = JSON.parse(data);
						if(d != ""){
			    	    	if($(d).size() == 10){
			    	    		$("#div_next").css("display",'');
			    	    	}else{
			    	    		$("#div_next").css("display",'none');
			    	    	}
									
							$(d).each(function(i){
								val += '<a href="<%=path%>/communication/detail?rowId='
														+ this.rowid
														+ '&openId=${openId}&publicId=${publicId}" class="list-group-item listview-item">'
														+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
														+ '<b>'
														+ this.image
														+ '</b> </div>'
														+ '<div class="content" style="text-align: left">'
														+ '<h1>'
														+ this.title
														+ '&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
														+ this.author
														+ '</span></h1>'
														+ '<p class="text-default">'
														+ this.street
														+ '</p> '
														+ '</div></div> '
														+ '<div class="list-group-item-fd"><span class="icon icon-uniE603"></span></div>'
														+ '</a>';
											});

						} else {
							$("#div_next").css("display", 'none');
						}
						$("#div_accnt_list").html(val);
					}
				});
	}
	
	//取消查询
	function closeSearch() {
		$("#div_search_content").addClass("modal");
		$("#site-nav").removeClass("modal");
		$(".listContainer").removeClass("modal");
		$("footer").removeClass("modal");
		$(".acclist").removeClass("modal");
		
	}

	//查询
	function search() {
		$("#div_search_content").removeClass("modal");
		$("#site-nav").addClass("modal");
		$(".listContainer").addClass("modal");
		$(".acclist").addClass("modal");
	}

	//提交查询
	function searchList() {
		$("form[name=alistForm]").submit();
	}
</script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<div class="act-secondary" data-toggle="navbar"
			data-target="nav-collapse">
			<i class="icon-menu"><b></b></i>
		</div>

		<c:if test="${viewtype ne 'analyticsview' }">
			<div id="div_search" onclick="search();"
				style="float: left; cursor: pointer; margin-top: 15px;">
				<img src="<%=path%>/image/wxsearch.png">
			</div>
		</c:if>
		<input type="hidden" name="currpage" value="1" />
		 <a
			href="javascript:void(0)" class="list-group-item listview-item">
			<form name="typeNameForm"
				action="<%=path%>/articleInfo/list?openId=${openId}&publicId=${publicId}"
				method="post">
				<div class="list-group-item-bd"
					style="width: 180px; margin: 0 auto; padding-top: 5px;">
					<p>
					<div class="form-control select">
							<div class="select-box viewtypelabel">公司介绍列表</div>
							<select name="typeName" id="typeName">
								<option value="compProf">公司介绍列表</option>
								<option value="compNews">公司新闻列表</option>
								<option value="compProd">公司产品列表</option>
								<option value="compIntro">案例介绍列表</option>
								<option value="compMark">市场活动列表</option>
							</select>
					</div>
					</p>
				</div>
			</form>
		</a>
	</div>

	<div class="site-recommend-list page-patch acclist">
		<div class="list-group listview" id="div_accnt_list">
			<c:forEach items="${mlist }" var="accnt">
				<a
					href="<%=path%>/articleInfo/detail?&openId=${openId}&publicId=${publicId}&id=${accnt.id}"
					class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<div class="thumb list-icon">
							<b><img src="<%=path %>/${accnt.image}" /> </b>
						</div>

						<div class="content">
							<h1>${accnt.title }&nbsp;<span
									style="color: #AAAAAA; font-size: 12px;">${accnt.author }</span>
							</h1>
						</div>
					</div>
					<div class="list-group-item-fd">
						<span class="icon icon-uniE603"></span>
					</div>
				</a>
			</c:forEach>
			<c:if test="${fn:length(mlist) == 0 }">
				<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
			</c:if>
		</div>
		<c:if test="${fn:length(mlist)==10 }">
			<div style="width: 100%; text-align: center;" id="div_next">
				<a href="javascript:void(0)" onclick="topage()"><img
					src="<%=path%>//image/nextpage.png" width="32px" /></a>
			</div>
		</c:if>
	</div>
	
	
	<!-- 查询区域 -->
	<div id="div_search_content" class="site-card-view modal"
		style="font-size: 14px; position: absolute; top: 0px; left: 0px; width: 100%; height: 800px; z-index: 999; background: #fff; opacity: 0.99;">
		<div style="width: 100%;">
			<form name="alistForm" method="post"
				action="<%=path%>/communication/list?openId=${openId}&publicId=${publicId}">
				<input type="hidden" name="title" value="" /> <input
					type="hidden" name="startDate" value="" />
					<input type="hidden" name="endDate" value="" />
				<div
					style="margin-top: -13;width: 100%; background-color:RGB(75, 192, 171); text-align: center; line-height: 3.4em; color: #ffffff;">查&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 询</div>
				<div id="search_div1" class="search_div">
					<div style="float: left; padding-top: 4px;">标&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 题：</div>
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
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>