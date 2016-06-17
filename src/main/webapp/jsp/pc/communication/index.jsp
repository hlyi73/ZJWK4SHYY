
<!DOCTYPE HTML>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<HTML>
<HEAD>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<TITLE>Communication 首页</TITLE>
<META http-equiv=Content-Type content="text/html; charset=UTF-8">
<META content="MSHTML 6.00.2900.5848" name=GENERATOR>


<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>

<script>
$(function () {
});

</script>
</HEAD>
</body>


  <FRAMESET 
border=0 frameSpacing=0 frameBorder=no cols=20%,*>
    <FRAME id=leftFrame style="border-right:1px solid #aaa;background-color:#eee;"
name=leftFrame src="<%=path %>/jsp/pc/communication/left.jsp?orgId=${orgId}&assignerid=${assignerid}" noResize scrolling=no>
    <FRAME 
id=mainFrame name=mainFrame src="<%=path %>/jsp/pc/communication/list.jsp?orgId=${orgId}&assignerid=${assignerid}" noResize 
scrolling=no>
  </FRAMESET>

<noframes></noframes>
</HTML>
