<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html>
<head>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script
	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>

<script>
$(function () {
	initform();
});

function initform(){
	var path = "<%=path%>";
	var typeName= "<%=request.getParameter("type")%>";
	var typeId = "<%=request.getParameter("id")%>";
	var assignerid = "<%=request.getParameter("assignerid")%>";
	var orgId =  "<%=request.getParameter("orgId")%>";
		//  	alert(	$("input[name=mlist]").val());
		$("input[name=orgId]").val(orgId);
		$("input[name=assignerid]").val(assignerid);
		$("input[name=typeId]").val(typeId);
		$("input[name=typeName]").val(typeName);
	}
</script>
<title>图文列表详情</title>
</head>
<body style="background-color: #fff;">
	<form name="listfm" id="listfm" action="?" method="post">
		<input type="hidden" name="assignerid" value=""> <input
			type="hidden" name="typeId" value=""> <input type="hidden"
			name="typeName" value="">

	</form>
	<div style="with: 100%;" text-align: center; font-family: 'MicrosoftYaHei'">
		<c:forEach items="${mlist}" var="articleInfo" varStatus="stat">
			<div style="width: 32%; margin: 2px; padding: 5px; min-height: 248px; float: left; border: 1px solid #aaa;">
				<div style="font-size: 16px; text-align: left;font-family: '微软雅黑'">${articleInfo.title}</div>
				<div style="font-size: 15px; text-align: left; margin-top: 5px;font-family: '微软雅黑'">${articleInfo.createTime}</div>
				<div style="margin-top: 10px;">
	<%-- 				<img src="<%=path%>/contact/download?fileName=${articleInfo.image}" width="80px"> --%>
					<img src="${articleInfo.image}" width="80px">
				</div>
				
				<div style="font-size: 14px; margin-top: 10px; text-align: left;min-height:80px;font-family: '微软雅黑'">
					<c:if test="${fn:length(articleInfo.descrition) > 120}">
									${fn:substring(articleInfo.descrition, 0, 120)}
					</c:if>
					<c:if test="${fn:length(articleInfo.descrition) <= 120}">
						${articleInfo.descrition}
					</c:if>
				</div>
				
				<div style="width:100%;border-top:1px solid #aaa;height:45px;line-height:45px;font-family: '微软雅黑'">
					<div style="float: left; width: 50%;margin-top:11px;text-align:center;">
						<a href="<%=path%>/pccomm/pc_detail?&id=${articleInfo.id}"> <img
							src="<%=path%>/scripts/plugin/communication/images/submit.jpg">
						</a>
					</div>
					<div style="float: left; width: 50%;margin-top:11px;text-align:center;">
						<a href="<%=path%>/pccomm/delete?&id=${articleInfo.id}"> <img
							src="<%=path%>/scripts/plugin/communication/images/del.jpg"></a>
					</div>
				</div>
				
			</div>
		</c:forEach>
	</div>

</body>
</html>