<%@page import="com.takshine.wxcrm.base.util.PropertiesUtil"%>
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

	});
    
</script>
</head>
<body>
	<!-- 活动资料 -->
	<div class="act_attachment_list" style="width:100%;padding:0px 10px;background-color:#fff;">
		<c:forEach items="${attList}" var="att">
			<div style="padding: 8px 0px; font-size: 14px; border-bottom: 1px solid #eee;">
				<div style="float: left;">
					<c:if test="${att.file_type eq 'doc' || att.file_type eq 'docx'}">
						<img src="<%=path %>/image/attachment/attach_doc.png" width="36px" style="border-radius: 5px;">
					</c:if>
					<c:if test="${att.file_type eq 'xls' || att.file_type eq 'xlsx'}">
						<img src="<%=path %>/image/attachment/attach_xls.png" width="36px" style="border-radius: 5px;">
					</c:if>
					<c:if test="${att.file_type eq 'ppt' || att.file_type eq 'pptx'}">
						<img src="<%=path %>/image/attachment/attach_ppt.png" width="36px" style="border-radius: 5px;">
					</c:if>
					<c:if test="${att.file_type eq 'pdf'}">
						<img src="<%=path %>/image/attachment/attach_pdf.png" width="36px" style="border-radius: 5px;">
					</c:if>
					<c:if test="${att.file_type ne 'pdf' && att.file_type ne 'ppt' && att.file_type ne 'pptx'&& att.file_type ne 'xlsx'&& att.file_type ne 'doc'&& att.file_type ne 'docx'}">
						<img src="<%=path %>/image/attachment/attach_other.png" width="36px" style="border-radius: 5px;">
					</c:if>
				</div>
				<div style="line-height: 20px; padding-left: 50px;"><a href="${zjwk_file_service}/${att.file_rela_name}">${att.file_name}</a></div>
				<div style="padding-left: 50px; line-height: 20px; color: #999;">
					文件大小：${att.file_size}KB
				</div>
			</div>
		</c:forEach>
	</div>
</body>
</html>