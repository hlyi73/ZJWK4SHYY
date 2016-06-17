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
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>

<script type="text/javascript">
$(function () {
	initServreqMenuSel();
	
});

function initServreqMenuSel(){
	$("._viewtype_select").click(function(){
		viewtypeClick();
	});	
	
	$("body").click(function(e){
		if($("#_viewtype_menu").css("display") == "block" && e.target.className == ''){
			viewtypeClick();
		}
	});
}

function viewtypeClick(){
	if($("#_viewtype_menu").css("display") == "none"){
		$("#_viewtype_menu").css("display","");
		$("#_viewtype_menu").animate({height : 100}, [ 10000 ]);
		$(".site-recommend-list").css("display","none");
	}else{
		$("#_viewtype_menu").animate({height : 0}, [ 10000 ]);
		$("#_viewtype_menu").css("display","none");
		$(".site-recommend-list").css("display","");
	}
}
</script>

</head>
<body>
    <!-- 头部下拉框区域 -->
	<div id="site-nav" class="navbar">
	    <!-- 回退按钮 -->
		<jsp:include page="/common/back.jsp"></jsp:include>
		
		<div class="act-secondary">
			<a href="<%=path%>/complaint/getexec?parentid=${parentid}&parenttype=${parenttype}&openid=${openid}&publicid=${publicid}" style="font-size:35px;font-weight:bold;color:#fff;padding:0px 10px 0px 10px;">+</a> 
		</div>
		<!-- 下拉选择框 -->
		<a href="javascript:void(0)" class="list-group-item listview-item">
		    <form name="viewtypeForm" action="<%=path%>/complaint/list" method="post">
		        <input type="hidden" name="openid" value="${openid}" />
		        <input type="hidden" name="openid" value="${publicid}" />
		        <input type="hidden" name="currpage" value="1" />
				<div class="list-group-item-bd" style="width:180px;margin:0 auto;padding-top:5px;" >
					<p>
						<div class="form-control select _viewtype_select">
							<div class=" viewtypelabel" style="color:white"><h3>服务执行列表</h3></div>
						</div>
					</p>
				</div>
			</form>
		</a>
	</div>
	<!-- 列表 -->
	<div class="site-recommend-list page-patch ">
		<div class="list-group listview execlist" style="margin-top:-1px;" id="div_tasks_list">
			<c:forEach items="${execlist}" var="exec">
				<a href="<%=path%>/complaint/serexecdetail?rowid=${exec.rowid}&parentid=${exec.parentid}&openid=${openid}&publicid=${publicid}&crmid=${crmid}" 
					class="list-group-item listview-item">
					<div class="list-group-item-bd">
						<div class="content">
							<h1>${exec.process_desc }&nbsp;<span style="color: #AAAAAA; font-size: 12px;"></span></h1>
							<p class="text-default">服务人员：  ${exec.assigned_user_name}</p>
							<p class="text-default">服务开始时间：  ${exec.start_date}</p>
							<p class="text-default">服务结束时间：  ${exec.end_date}</p>
							<p class="text-default">故障描述：  ${exec.fault_desc}</p>
						</div>
					</div>
					<div class="list-group-item-fd">
						<span class="icon icon-uniE603"></span>
					</div>
				</a>
			</c:forEach>
			<!-- 数据为空判断 -->
			<c:if test="${fn:length(execlist) == 0 }">
					<div style="text-align:center;padding-top:50px;">没有找到数据</div>
			</c:if>
		</div>
		<!-- 翻页 -->
		<c:if test="${fn:length(execlist)==10 }">
			<div style="width:100% auto;text-align:center;background-color:#fff;margin:8px;padding:8px;border:1px solid #ddd;" id="div_next">
				<a href="javascript:void(0)" onclick="topage()">
					下一页&nbsp;<img id="nextpage" src="<%=path%>//image/nextpage.png" width="24px"/>
				</a>
			</div>
		</c:if>
	</div>
	
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>