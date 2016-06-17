<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<script type="text/javascript">
//ivk-> 显示消息盒子 
function ivk_show_error_msg(obj){
	$(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + obj.errorCode + "错误描述:" + obj.errorMsg);
	$(".myMsgBox").delay(2000).fadeOut();
}
//ivk-> 显示消息盒子 
function ivk_show_txt_msg(msg){
	$(".myMsgBox").css("display","").html(msg);
	$(".myMsgBox").delay(2000).fadeOut();
}
</script>
<!-- myMsgBox -->
<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
	