<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>
<%@ include file="/common/comlibs.jsp"%>
<style>
.circle {
    width: 120px;
    height: 120px;  
    position: absolute;
    border-radius: 50%;
    background: #22FA3D;
}
.pie_left, .pie_right {
    width: 120px; 
    height: 120px;
    position: absolute;
    top: 0;left: 0;
}
.left, .right {
    display: block;
    width:120px; 
    height:120px;
    background:#F79E15;
    border-radius: 50%;
    position: absolute;
    top: 0;
    left: 0;
    transform: rotate(30deg);
}
.pie_right, .right {
    clip:rect(0,auto,auto,60px); 
}
.pie_left, .left {
    clip:rect(0,60px,auto,0);
}
.mask {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    left: 20px;
    top: 20px;
    background: RGB(75, 192, 171);
    color:#fff;
    position: absolute;
    text-align: center;
    line-height: 80px;
    font-size: 24px;
    font-weight:bold;
}

.circle1 {
    width: 120px;
    height: 120px;  
    position: absolute;
    border-radius: 50%;
    background: #22FAFA;
}
.pie_left1, .pie_right1 {
    width: 120px; 
    height: 120px;
    position: absolute;
    top: 0;left: 0;
}
.left1, .right1 {
    display: block;
    width:120px; 
    height:120px;
    background:#E97DFA;
    border-radius: 50%;
    position: absolute;
    top: 0;
    left: 0;
    transform: rotate(30deg);
}
.pie_right1, .right1 {
    clip:rect(0,auto,auto,60px);
}
.pie_left1, .left1 {
    clip:rect(0,60px,auto,0);
}
.mask1 {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    left: 20px;
    top: 20px;
    background: RGB(75, 192, 171);
    color:#fff;
    position: absolute;
    text-align: center;
    line-height: 80px;
    font-size: 24px;
    font-weight:bold;
}
</style>
<script>
$(function() {
	var width = ($(window).width()-240)/4;
	$(".circle").css("margin-left",width);
	$(".circle1").css("margin-left",width);
    $('.circle').each(function(index, el) {
        var num = $(this).find('span').text() * 3.6;
        if (num<=180) {
            $(this).find('.right').css('transform', "rotate(" + num + "deg)");
        } else {
            $(this).find('.right').css('transform', "rotate(180deg)");
            $(this).find('.left').css('transform', "rotate(" + (num - 180) + "deg)");
        };
    });

    $('.circle1').each(function(index, el) {
        var num = $(this).find('span').text() * 3.6;
        if (num<=180) {
            $(this).find('.right1').css('transform', "rotate(" + num + "deg)");
        } else {
            $(this).find('.right1').css('transform', "rotate(180deg)");
            $(this).find('.left1').css('transform', "rotate(" + (num - 180) + "deg)");
        };
    });
});
</script>
<!-- 看板 -->
<a href="<%=path %>/analytics/oppty/funnel?openId=${openId}&publicId=${publicId}" style="color:#fff;">
<div style="width:100%;background-color:RGB(75, 192, 171);height:180px;padding:5px 0px 5px 0px;">

<div style="float:left;width:50%;text-align:center;">
<div style="width:100%;text-align:center;color:#fff;padding-bottom:5px;">目标</div>
<div class="circle">
    <div class="pie_left"><div class="left"></div></div>
    <div class="pie_right"><div class="right"></div></div>
    <div class="mask"><span>${indexKPI.percentage}</span>%</div>
</div>
<div style="width:100%;text-align:center;color:#fff;margin-top: 130px">￥${indexKPI.salesTargets}/￥${indexKPI.salesCompleted}(万)</div>
</div>

<div style="float:right;width:50%;text-align:center;">
<div style="width:100%;text-align:center;color:#fff;padding-bottom:5px;">回款</div>
<div class="circle1">
    <div class="pie_left1"><div class="left1"></div></div> 
    <div class="pie_right1"><div class="right1"></div></div>
    <div class="mask1"><span>${receive_percentage}</span>%</div>
</div>
<div style="width:100%;color:#fff;margin-top: 130px">￥${indexKPI.collectionTargets}/￥${indexKPI.collectionCompleted}(万)</div>
</div>
</div>
</a>
<div style="clear:both;"></div>