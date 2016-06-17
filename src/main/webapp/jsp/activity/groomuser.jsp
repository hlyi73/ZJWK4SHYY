<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<html lang="zh-cn">
<head>
<!-- Meta -->
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/>
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color"/>
<script type="text/javascript">
	$(function () {
		initAproveBtn();//初始化批量审批
		initWeixinFunc();
	});
	
	//微信网页按钮控制
	function initWeixinFunc(){
		//隐藏顶部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});
		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	}
	
	//初始化全选和不全选按钮
	function initAproveBtn(){
		
		//若没有好友，则只显示跳过
		var userList = '${isEmpty}';
		if("true"==userList){
			$(".confirmdiv").css("display","none");
			$(".skipdiv").css("width","100%");
		}
		
		//单选或多选
		$("#div_expense_list > a").unbind("click").bind("click", function(){
			if($(this).hasClass("checked")){
				$(this).removeClass("checked");
			}else{
				$(this).addClass("checked");
			}
			return false;
		});
		
		$(".skip").click(function(){
			$(":hidden[name=optype]").val('skip');
			$("form[name=directsendform]").submit();
		});
		
		//提交到活动那边保存
		$(".confirm").click(function(){
			var id="";
			$("#div_expense_list > a.checked").each(function(){
				var userid = $(this).find(":hidden[name=userid]").val();
				var phone = $(this).find(":hidden[name=phonenumber]").val();
				if(null!=userid&&null!=phone){
					id += userid+","+phone+";";
				}
			});
			if(!id){
				$(".myMsgBox").css("display","").html("邀请人不能为空，请重新选择！");
				$(".myMsgBox").delay(2000).fadeOut();
				return;
			}
			$(":hidden[name=id]").val(id);
			$("form[name=directsendform]").submit();
		});
	}

    </script>
</head>
<body>
<div id="site-nav" class="navbar">
	<div style="float: left">
		<a href="javascript:void(0)" onclick="javascript:history.go(-1)" style="color: #fff;padding:5px 5px 5px 0px;">
			<img src="<%=path %>/image/back.png" width="40px" style="padding:5px;">
		</a>
	</div>
	<h3 style="padding-right:45px;">好友列表</h3> 
</div>

<!-- 下拉菜单选项 end -->
<div style="clear:both"></div>
<div class="site-recommend-list page-patch">
	<!-- 查询End -->
	<div id="div_expense_list" class="list-group listview listview-header">
	<a href="javascript:void(0)" class="list-group-item listview-item  radio batchAprHref flooter" style="margin:0px;display:none;padding:.3em;padding-bottom: .3em;">
	   	<form name="directsendform" method="post" action="<%=path%>/zjwkactivity/saveGroomUser">
			<input type="hidden" name="id" value="" >
			<input type="hidden" name="return_url" value="${return_url}" >
			<input type="hidden" name="openId" value="${openId}" >
			<input type="hidden" name="publicId" value="${publicId}" >
			<input type="hidden" name="rowId" value="${rowId}" >
			<input type="hidden" name="orgId" value="${orgId}" >
			<input type="hidden" name="sourceid" value="${sourceid}" >
			<input type="hidden" name="source" value="${source}" >
			<input type="hidden" name="optype" value="" >
	   	</form>
	</a>
		<c:forEach items="${userRelaList}" var="user">
			<a href="#" class="list-group-item listview-item radio" style="border-left: 0px;">
				<input type="hidden" name="userid" value="${user.rela_user_id}" ><!-- rowID -->
				<input type="hidden" name="phonenumber" value="${user.mobile_no_1}" ><!-- rowID -->
				<div class="list-group-item-bd">
					 <div class="thumb list-icon">
						<img style="border-radius: 10px;" width="50px" src="${user.headimgurl }"/>
					</div>
					<div class="content" style="text-align: left">
						<h1>${user.rela_user_name}</h1>
						<p class="text-default" >电话：${user.mobile_no_1}</p>
						<p class="text-default" >公司/职位：${user.company}&nbsp;&nbsp;&nbsp;${user.depart }</p>
					</div>
				</div>
				<div class="input-radio" title="选择该条记录"></div>
			</a>
		</c:forEach>
		<c:if test="${fn:length(userRelaList) == 0 }">
			<div style="text-align:center;padding-top:50px;">没有找到数据</div>
		</c:if>
	</div>
</div>	
<div class="button-ctrl flooter">
	<fieldset class="">
		<div class="ui-block-a skipdiv" style="width:50%">
			<a href="javascript:void(0)" class="btn btn-block skip" 
			    style="font-size: 16px;margin-left:10px;margin-right:10px;">跳过</a>
		</div>
		<div class="ui-block-a confirmdiv" style="width:50%">
			<a href="javascript:void(0)" class="btn btn-block confirm" 
			    style="font-size: 16px;margin-left:10px;margin-right:10px;">确认</a>
		</div>
	</fieldset>
</div>
	<div class="myMsgBox" style="display:none;width:100%;position: fixed;color: #FFF;background: rgb(234,160,0);top: 0px;left: 0px;z-index: 1000;font-size: 16px;text-align: center;height: 30px;padding: 5px 0px 2px 0px;">121212</div>
</body>
</html>