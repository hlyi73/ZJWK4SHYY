<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	String path = request.getContextPath();
%>

<div
	style="float: left; height: 48px; width: 100%; background-color:RGB(75, 192, 171)">
	<img src="<%=path%>/image/takshine_logo1.png" width="64px"
		style="margin: 15px; border: 4px solid #eee;background-color:#fff;">
</div>
<div
	style="width: 100%; text-align: center; height: 210px; padding-top: 100px;">
	<div style="width: 100%; text-align: center;">
		<img src="${headimgurl}"
			style="border: 0; border-radius: 75px; width: 150px; height: 150px;">
	</div>
	<div
		style="width: 100%; text-align: center; margin-top: 28px; color: #fff">
		<span style="color: red; font-weight: bold;">Hi&nbsp;&nbsp;${nick }</span>
	</div>
	<div class="flooter"
		style="color: #666; font-size: 16px; height: 50px; line-height: 50px; margin-bottom: 80px; font-family: 微软雅黑;">
		<span> <a
			href="<%=path %>/register/get?openId=${openId}&publicId=${publicId}"
			style="color: #3e6790; font-weight: bold; font-size: 16px;">注册试用</a>
		</span> <span style="padding-left: 8px; padding-right: 8px; color: #ddd;">|</span>
		<span> <a
			href="<%=path%>/operMobile/get?openId=${openId }&publicId=${publicId}"
			style="color: #3e6790; font-weight: bold; font-size: 16px;">用户登陆</a>
		</span>
	</div>
</div>
<div class="flooter"
	style="color: #666; font-size: 12px; height: 50px; line-height: 50px; margin-bottom: 20px; font-family: 微软雅黑;">
	@2014指尖微客</div>
<div class="flooter"
	style="color: #666; font-size: 12px; height: 50px; line-height: 50px; padding-bottom: 25px; font-family: 微软雅黑;">
	连接企业资源，世界尽在指尖！</div>

