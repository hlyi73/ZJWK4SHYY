<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
%>
<link rel="stylesheet" href="<%=path%>/css/share.css" />
<script type="text/javascript">
function share(){
	
    $(".share_div-bg").height(window.screen.height);
    $(".share_div-img").css("margin-left", -$(".share_div-img").outerWidth() / 2);
    $(".share_div-bg, .share_div-img").show();

    $(".share_div-bg, .share_div-img").unbind("click").click(function () {
        $(".share_div-bg, .share_div-img").hide();
    });	
}
</script>
<div class="share_div-bg" style="display: none;"></div>
<div class="share_div-img" style="display: none;">
    <span>
        <img src="<%=path%>/image/share.png">
    </span>
</div>