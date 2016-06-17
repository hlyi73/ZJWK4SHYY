<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String wxsharepath = request.getContextPath();
    String publicid = request.getParameter("publicid");
    String title = request.getParameter("title");
    String desc = request.getParameter("desc");
%>
<!-- 分享JS区域 -->
<script src="<%=wxsharepath%>/scripts/util/share.util.js"
	type="text/javascript"></script>
<script type="text/javascript">
	var dataForWeixin = {  
		appId:"<%=publicid%>",  
		MsgImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=wxsharepath%>/image/wxcrm_logo.png",  
		TLImg:"http://<%=request.getServerName()%>:<%=request.getServerPort()%><%=wxsharepath%>/image/wxcrm_logo.png",
		url : window.location.href + "&shareBtnContol=yes",
		title : "<%=title%>",
		desc : "<%=desc%>",
		fakeid : "",
		callback : function() {
		}
	};
</script>