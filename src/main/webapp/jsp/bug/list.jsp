<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
	<script type="text/javascript">
    $(function () {
    	//initWeixinFunc();
	});
    
   /*  //微信网页按钮控制
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
    
    function topage(){
    	$("#nextpage").attr("src","<%=path%>/image/loading_data_027.gif");

    	var currpage = $("input[name=currpage]").val();
		
    	$("input[name=currpage]").val(parseInt(currpage) + 1);
    	currpage = $("input[name=currpage]").val();
    	$.ajax({
		      type: 'get',
		      url: '<%=path%>/bug/jsonlist' || '',
		      //async: false,
		      data: {currpage:currpage,viewtype:'${viewtype}',crmId:'${crmId}',pagecount:'8'} || {},
		      dataType: 'text',
		      success: function(data){
		    	    var val = $("#div_oppty_list").html();
		    	    var d = JSON.parse(data);
		    	    if(d.errorCode && d.errorCode !== '0'){
		    	    	$("#div_oppty_list").html("操作失败!" + "错误编码:" + d.errorCode + "错误描述:" + d.errorMsg);
	    	    	   return;
	    	    	}
					if(d != ""){
		    	    	if($(d).size() == 10){
		    	    		$("#div_next").css("display",'');
		    	    	}else{
		    	    		$("#div_next").css("display",'none');
		    	    	}
						$(d).each(function(i){
							val+= '<a href="<%=path%>/bug/detail?rowId='
								+ this.rowid+'&openId=${openId}&publicId=${publicId}"'
								+ 'class="list-group-item listview-item"><div class="list-group-item-bd"><div class="thumb list-icon">'
								+ '<b>'+this.statusname+'</b></div><div class="content"><h1>'+this.title+'&nbsp;<span style="color: #AAAAAA; font-size: 12px;">'
								+ this.assigner+'</span></h1><p>创建日期:'
								+ this.createdate+'&nbsp;&nbsp;&nbsp;&nbsp;</p></div></div><div class="list-group-item-fd">'
								+ '<span class="icon icon-uniE603"></span></div></a>';
						});
						} else {
							$("#div_next").css("display", 'none');
						}
						$("#div_oppty_list").html(val);
						
						$("#nextpage").attr("src","<%=path%>/image/nextpage.png");
					}
				});
	}
    </script>
</head>
<body>
    <!-- 头部下拉框区域 -->
	<div id="site-nav" class="navbar">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">项目缺陷列表</h3>
		<%-- <div class="act-secondary" >
			<a
				href="<%=path%>/schedule/add?openId=${openId}&publicId=${publicId}&parentType=${parentType}&parentId=${parentId}&flag=other&parentName=${parentName}&parentTypeName=${parentTypeName}&assignerId=&assignerName=&scheType=plan" style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a>
		</div> --%>
	</div>
	<jsp:include page="/common/navbar.jsp"></jsp:include>
	<div class="site-recommend-list page-patch ">
	    <!-- 日程列表 -->
		<div class="list-group listview tasklist" id="div_tasks_list">
			<input type="hidden" name="currpage" value="1" />
		<c:forEach items="${bugList}" var="bug">
				<a href="<%=path%>/bug/detail?rowId=${bug.rowid}&openId=${openId}&publicId=${publicId}"
					class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<div class="thumb list-icon">
							<b>${bug.statusname}</b>
						</div>
						<div class="content">
							<h1>${bug.title }&nbsp;<span
									style="color: #AAAAAA; font-size: 12px;">${bug.assigner}</span>
							</h1>
							<p>创建时间：${bug.createdate}</p>
						</div>
					</div>
					<div class="list-group-item-fd">
						<span class="icon icon-uniE603"></span>
					</div>
				</a>
			</c:forEach>

			<c:if test="${fn:length(bugList) == 0 }">
				<div style="text-align: center; padding-top: 50px;">没有找到数据</div>
			</c:if>
		</div>
		<c:if test="${fn:length(taskList)==10 }">
			<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
				<a href="javascript:void(0)" onclick="topage()">
					下一页&nbsp;<img id="nextpage" src="<%=path %>/image/nextpage.png" width="24px"/>
				</a>
			</div>
		</c:if>
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>