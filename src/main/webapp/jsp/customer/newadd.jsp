<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/plugin/json2.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet"
	href="<%=path%>/scripts/plugin/wb/css/wxchart.css">
<script src="<%=path%>/scripts/plugin/wb/js/wb.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/pro_city.js"
type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script type="text/javascript">
//初始化
$(function(){
	$("#cust_baseInfo").find("input").each(function(){
		//setStyle($(this));
	})
});

//创建
function save()
{
	//校验相关数据是否合法
	var cust_name = $("input[name=name]").val();
	if (cust_name == "")
	{
		$("input[name=name]").attr("placeholder","客户名称必填");
		$("input[name=name]").css("color","red");
		return;
	}
	
	var cust_phone = $("input[name=phoneoffice]").val();
	if (cust_phone != "")
	{
		var regMobile = /^1[3|4|5|7|8][0-9]{9}$/;//验证手机号码
		var regPhone = /^0\d{2,3}-?\d{7,8}$/;
		if(!regPhone.test($.trim(cust_phone)) && !regMobile.test($.trim(cust_phone)))
		{
			$("input[name=phoneoffice]").val("");
			$("input[name=phoneoffice]").attr("placeholder","请输入正确的电话号码");
			$("input[name=phoneoffice]").css("color","red");
	        return;
		}
	}

	//form提交
	$("form[name=cust_form]").submit();
}

function setStyle(obj)
{
	var name = obj.attr("name");
	$("input[name="+name +"]").css("color","");
}

//取消
function cancel()
{
	//window.history.go(-1);
	window.location.href = "<%=path%>/customer/acclist";
}
</script>
</head>
<body onload="onloadprovince()">
	<div id="userRegister" style="display:none"  class="navbar">
	</div>
	<!-- 控制区域 -->
	<div id="site-nav" class="cusomer_menu zjwk_fg_nav_1">
		    <a href="javascript:void(0)" onclick='cancel()' style="padding:5px 8px;">取消</a>
		    <a href="javascript:void(0)" onclick='save()' style="padding:5px 8px;">保存</a>
	</div>
	<div style="clear: both;"></div>
	<!-- 基本信息 -->
	<div id="cust_baseInfo" style="margin:5px 0px 0px 0px;">
		<form name="cust_form" action="<%=path%>/customer/save" method="post">
		<input type="hidden" name="orgId" value="${orgId}" />
				<div class="zjwk_form_row_div">
					<span style="float:right;width: 1%;margin-top: 10px;"><font color="red">*</font></span>
					<input name="name" onfocus="setStyle($(this))"  style="height:50px;width: 99%" placeholder="客户名称">
				</div>
				<div style="clear: both;"></div>
				<div class="zjwk_form_row_div">
					<input name="phoneoffice"  onfocus="setStyle($(this))"  style="height:50px;width: 99%" placeholder="客户电话">
				</div>
				<div style="clear: both;"></div>
				<div class="zjwk_form_row_div">
					<div style="border-bottom:1px solid #ddd;">
						<select id="province" name="province" onchange="cityName(this.value);"  style="border: 0px;border-bottom-style: ridge;height: 50px;width: 48%;color:#666;">
						  <option value="">
						            请选择省份
						            </option>
						</select>
						<select id="city" name="city" style="border: 0px;border-bottom-style: ridge;height: 50px;width: 48%;color:#666;">
						            <option value="">
						            请选择城市
						            </option>
						</select>
					<!-- <input name="city"  style="height:50px;border-bottom: 1px;border-bottom-style: ridge;width: 99%" placeholder="城市"> --></div>
					<div style="clear: both;"></div>
					<div><input name="street"  style="height:50px;width: 99%" placeholder="详细地址"></div>
				</div>
				<div style="clear: both;"></div>
				<div class="zjwk_form_row_div">
					<input name="desc"  style="height:50px;width: 99%" placeholder="客户描述">
				</div>
		</form>
	</div>
	<!-- 底部菜单 -->
	<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>