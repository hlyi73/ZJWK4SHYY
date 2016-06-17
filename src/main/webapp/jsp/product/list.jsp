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
		//initWeixinFunc();
    	initForm();
	});
	
	//微信网页按钮控制
/* 	function initWeixinFunc(){
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
		var selObj = $("select[name=viewtype]");

	function topage() {
			var currpage = $("input[name=currpage]").val();
			$("input[name=currpage]").val(parseInt(currpage) + 1);
			currpage = $("input[name=currpage]").val();
			$.ajax({
				type : 'get',
				url : '<%=path%>/customer/alist' || '',			
			   // async: false,
		        data: {name:'${name}',industry:'${industry}',accnttype:'${accnttype}',viewtype:'${viewtype}',
		     	currpage:currpage,publicId:'${publicId}',openId:'${openId}',pagecount:'10'} || {},
			    dataType: 'text',
			    success: function(data){
			    	    var val = $("#div_accnt_list").html();
			    	    var d = JSON.parse(data);
						if(d != ""){
							if(d.errorCode && d.errorCode !== '0'){
								$("#div_accnt_list").html('<div style="text-align: center; padding-top: 50px;">操作失败!错误编码:"' + d.errorCode + "错误描述:" + d.errorMsg +'</div>');
								return;
							}
			    	    	if($(d).size() == 10){
			    	    		$("#div_next").css("display",'');
			    	    	}else{
			    	    		$("#div_next").css("display",'none');
			    	    	}
									
							$(d).each(function(i){
								val += '<a href="<%=path%>/customer/detail?rowId='
															+ this.rowid
															+ '&openId=${openId}&publicId=${publicId}" class="list-group-item listview-item">'
															+ '<div class="list-group-item-bd"> <div class="thumb list-icon"> '
															+ '<b>'
															+ this.accnttype
															+ '</b> </div>'
															+ '<div class="content" style="text-align: left">'
															+ '<h1>'
															+ this.name
															+ '&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
															+ this.assigner
															+ '</span></h1>'
															+ '<p class="text-default">'
															+ this.employees
															+ '</p><p class="text-default">'
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

	}
</script>
</head>
<body>
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">产品列表</h3>
	</div>

	<div class="site-recommend-list page-patch acclist">
		<div class="list-group listview" id="div_accnt_list">
			<c:forEach items="${proList }" var="pro">
				<a
					href="<%=path%>/product/detail?rowId=${pro.rowid}&openId=${openId}&publicId=${publicId}"
					class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<div class="content">
							<h1>${pro.name }&nbsp;<span
									style="color: #AAAAAA; font-size: 12px;">版本号： ${pro.version }</span>
							</h1>
							<p class="text-default">类别: ${pro.showname}</p>
							<p class="text-default">有效日期: ${pro.startdate}, ${pro.enddate}</p>
							<p class="text-default">价格: ${pro.price}</p>
						</div>
					</div>
					<div class="list-group-item-fd">
						<span class="icon icon-uniE603"></span>
					</div>
				</a>
			</c:forEach>
			<c:if test="${fn:length(proList) == 0 }">
				<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
			</c:if>
		</div>
		<c:if test="${fn:length(proList)==10 }">
			<div style="width: 100%; text-align: center;" id="div_next">
				<a href="javascript:void(0)" onclick="topage()"><img
					src="<%=path%>//image/nextpage.png" width="32px" /></a>
			</div>
		</c:if>
	</div>


	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<jsp:include page="/common/footer.jsp"></jsp:include>

</body>
</html>