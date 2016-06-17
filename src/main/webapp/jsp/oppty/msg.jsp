<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Meta -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
    <script type="text/javascript">
    $(function () {
    	$(".opptyDetail").click(function(){
		    $("form[name=detailForm]").submit();
    		return false;
    	});
	});
    </script>  
	</head>
    <body>
		<div id="site-nav" class="navbar">
			<div class="act-secondary" data-toggle="navbar"
				data-target="nav-collapse">
<!-- 				<i class="icon-menu"><b></b></i> -->
			</div>
			<h3>业务机会</h3>
		</div>
	    <jsp:include page="/common/navbar.jsp"></jsp:include>
		<div class="view site-phonebook">
			<div class="well text-center wrapper" style="padding: 2em 0">
				<c:if test="${success eq 'ok'}">
				    <h3 class="text-info" style="font-size: 18px;">创建业务机会成功!</h3>
				    <br>业务机会已同步到CRM<br>您同时可以登陆CRM系统中查看！<br><br>
				    <form name="detailForm" action="<%=path%>/oppty/detail" method="post" novalidate="true" >
				         <input type="hidden" name="rowId" value="${rowId}" />
				         <input type="hidden" name="orgId" value="${orgId}" />
				         <a href="javascript:void(0)" class="btn opptyDetail">
					        <span class="icon icon-search "></span> 点击查询详情
					    </a>
				    </form>
				</c:if>
				<c:if test="${success eq 'fail'}">
				    <h3 class="text-info" style="font-size: 18px;color:red">创建业务机会失败!</h3>
				    <br> 错误编码:${errorCode}, 错误描述:${errorMsg}<br>
				    <br> 请与管理员联系<br> 确认您的错误信息<br>
				</c:if>
				<c:if test="${bindSucc eq 'fail'}">
				    <h3 class="text-info" style="font-size: 18px;color:red">您还没绑定CRM账户!</h3>
				    <br>如果您没有CRM账号，请与系统管理员联系！
				</c:if>
			</div>
		</div>
		<jsp:include page="/common/footer.jsp"></jsp:include>
    </body>
</html>