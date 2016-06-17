<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	String parentDiv = request.getParameter("parentDiv");
%>
<script src="<%=path%>/scripts/plugin/emotions/jquery.emoticons.js" type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/scripts/plugin/emotions/emoticon.css" />

<script type="text/javascript">
		$(function () {
			$("#message_face").jqfaceedit({txtAreaObj:$("#inputMsg"),containerObj:$('#container'),top:25,left:27});
			$("#message_face").click(function(){
				$("#<%=parentDiv%>").css("opacity","0.8");
			});
		});
</script>

<div class="ui-block-a "  style="float: right; width: 45px; margin: -45px 65px 5px 0px;">
	<a href="javascript:void(0)" id="message_face" class="btn  btn-block" style="font-size: 14px; width: 100%;">
		<img src="../scripts/plugin/emotions/emotions/1.gif">
	</a>
</div>