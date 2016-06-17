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
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
<%@ include file="/common/comlibs2.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />
<link rel="stylesheet" href="<%=path%>/css/model/discugroup.css">

<script type="text/javascript">
	var discList = "";//已选讨论组id列表
	var num=0;//选择计数器
	var currId="";//当前点击的id
	
	//初始化
	$(function(){
		$(".cancelBtn").click(function(){
			cancelPush();
		})
		$(".pushBtn").click(function(){
			pushToDiscu();
		})
		$(".mail").click(function(){
			$(this).addClass("tabseleted02");
			$(this).siblings().removeClass("tabseleted02");
		})
		$(".message").click(function(){
			$(this).addClass("tabseleted02");
			$(this).siblings().removeClass("tabseleted02");
		})
		$(".weixin").click(function(){
			$(this).addClass("tabseleted02");
			$(this).siblings().removeClass("tabseleted02");
		})
		$(".auto").click(function(){
			$(this).addClass("tabseleted02");
			$(this).siblings().removeClass("tabseleted02");
		})
	});
	
	//搜索符合条件的讨论组
	function search()
	{
		var condition = $("input[name=search]").val();
		 $(":hidden[name=condition]").val(condition);
		 $("form[name=res_discu_form]").attr("action","<%=path%>/resource/showDiscu");

		 $("form[name=res_discu_form]").submit(); 
	}
	
	//增加一个讨论组id
	function addSelect(id)
	{
		//点击时先判断是否已经点击过
		if (discList != "")
		{
			var addFlag = false;
			var ids = discList.substring(0,discList.length-1).split(",");
			for (var i=0;i<ids.length;i++)
			{
				if (id == ids[i])
				{
					addFlag = true;
					currId = id;
					break;
				}
			}
			
			if (!addFlag)
			{
				//如果未点击过，则正常处理
				discList = discList + id + ",";
				$("#" + id + "_image").attr("src","<%=path%>/image/selected.png");
				
				num = num + 1;
				$("#selectNum").removeClass("none");
				$("#selectNum").html(" (" + num + ")");
			}
			else
			{
				//已点击过再次点击，则认为是反选
				$("#" + id + "_image").attr("src","<%=path%>/image/unselect.png");
				
				num = num - 1;
				$("#selectNum").removeClass("none");
				$("#selectNum").html(" (" + num + ")");
				//重组已选择的ids
				discList = "";
				for (var j=0;j<ids.length;j++)
				{
					if (currId == ids[j])
					{
						continue;
					}
					discList += ids[j] + ",";
				}
			}
		}
		else
		{
			//如果未点击过，则正常处理
			discList = discList + id + ",";
			$("#" + id + "_image").attr("src","<%=path%>/image/selected.png");
			
			num = num + 1;
			$("#selectNum").removeClass("none");
			$("#selectNum").html(" (" + num + ")");
		}
	}
	
	//文章推荐到讨论组
	function pushToDiscu()
	{
		if(discList != "")
		{
			//群发类型
			var messType;
			var mytype = $(".auto");//.siblings()
			mytype.parent().find("div").each(function(){
				if ($(this).hasClass("tabseleted02"))
				{
					messType = $(this).attr("value");
				}
			})

			$.ajax({
		  	      type: 'post',
		  	      url: '<%=path%>/resource/pushDiscu',
		  	      data: {selectIds: discList, type:messType,resId:'${resId}'},
		  	      dataType: 'text',
		  	      success: function(data){
		  	    	    if(!data) return;
		  	    	    var d = JSON.parse(data);
		  	    	    if(d.errorCode && d.errorCode == '0')
		  	    	    {
		  	    	    	if (d.rowCount && d.rowCount != '')
		  	    	    	{
		  	    	    		$(".myMsgBox").css("display","").html("推荐操作成功,但有" +d.rowCount+"个讨论组推荐失败");
		  	    	    	}
		  	    	    	$(".myMsgBox").css("display","").html("推荐操作成功");
			   	    		$(".myMsgBox").delay(2000).fadeOut();
			   	    	    //删除完成后清空全局变量
			   				discList = "";
			   	    	    
			   				$("form[name=res_discu_form]").submit();
				    	}
		  	    	    else
		  	    	    {
		  	    	    	$(".myMsgBox").css("display","").html("文章推荐失败");
			   	    		$(".myMsgBox").delay(2000).fadeOut();
			   	    	    //删除完成后清空全局变量
			   				discList = "";
			   	    		return;
		  	    	    }
		  	      }
		 	});
		}
		else
		{
			$(".myMsgBox").css("display","").html("没有选择任何讨论组");
    		$(".myMsgBox").delay(2000).fadeOut();
    		return;
		}
	}
	
	//取消推荐
	function cancelPush()
	{
		var child = $(".navbar");
		if (discList != "")
		{
			var idStr = discList.substring(0,discList.length-1);
			var ids = idStr.split(",");
			for (var i=0;i<ids.length;i++)
			{
				$("#" + ids[i] + "_image").attr("src","<%=path%>/image/unselect.png");
			}
			
			discList = "";
		}
		$("#selectNum").html("");
		if (num > 0)
		{
			num = 0;
		}
		
		$("form[name=res_discu_form]").submit();
	}
</script>
<style>
.dropdown-menu-group {
	font-size: 14px;
	position: fixed;
	width: 150px;
	right: 2px;
	left: 50%;
	top: 50%;
	text-align: left;
	z-index: 999;
	height:138px;
	margin: -150px 0px 0px -75px;
	line-height: 45px;
	background-color: RGB(75, 192, 171);
	-webkit-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-moz-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-ms-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	-o-box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
	box-shadow: 0 1px 13px 0 rgba(0, 0, 0, .6);
}
.dropdown-menu-group li {
	white-space: nowrap;
	margin-left: 10px;
	font-weight: 900;
	word-wrap: normal;
	border-bottom: 1px solid #365a7e;
}

.dropdown-menu-group li a {
	color: #fff
}
.none {
	display: none
}
.g-mask {
	position: fixed;
	top: -0px;
	left: -0px;
	width: 100%;
	height: 100%;
	background: #000;
	filter: alpha(opacity = 60);
	opacity: 0.5;
	z-index: 998;
}
a{
  color:#666;
}
</style>
</head>
<body style="font-size:14px;">
	    <div id="site-nav" class="navbar none" ></div>
	    <!-- 控制区 -->
	    <div class="button-ctrl mybtn" style="background-color: RGB(75, 192, 171);line-height: 38px;text-align: right;">
	  		  <a href="javascript:void(0)" class="cancelBtn"
						style="font-size: 16px;margin-right:15px;"><font color="floralwhite"> 取消</font></a>
			  <a href="javascript:void(0)" class="pushBtn"
						style="font-size: 16px;margin-right:15px;"> <font color="floralwhite">确定</font></a>
		</div>
		<!-- 消息推送类型 -->
		<div style="width: 100%; line-height: 30px; border-bottom: 1px solid #E7E7E7; color: #2CB6F7;background: #fff;margin-top: 5px;" class="none">
			<div style="float: right;  text-align: center; margin-right: 15px;" class="mail" value="mail">邮件发送
			</div>
			<div style="float: right;  text-align: center; margin-right: 15px;" class="message" value="message">短信发送
			</div>
			<div style="float: right;  text-align: center; margin-right: 15px;" class="weixin" value="weixin">微信发送
			</div>
			<div style="float: right;  text-align: center; margin-right: 15px;" class="tabseleted02 auto" value="auto">智能发送</div>
			<div style="clear: both;"></div>
		</div>
		<!-- 搜索区域 -->
		<div style="width:100%;line-height:50px;background-color:#fff;padding:5px;border-bottom: 1px solid #ddd;">
			<div style="height:44px;padding-top:3px;margin-right: 85px;margin-top:8px;" class="mysearch">
				<img src="<%=path %>/image/searchbtn.png" style="position: absolute;opacity: 0.5;width:30px;margin: 5px;right:5px" onclick="search()">
				<input type="text"  value="" placeholder="按名称" name="search" style="border-radius: 10px;font-size: 14px;padding-left:10px;border: 1px solid #ddd;line-height: 30px;width: 360px">
			</div>
		</div>
		
		<div style="width:100%;line-height:10px;background-color:#fff;padding:5px;border-bottom: 1px solid #ddd;">
		     已选择<label id="selectNum">0</label>个讨论组
		</div>
		<!-- 列表区域 -->
		<div style="width:100%;padding-right: 5px;background-color: white;" id="dgContaint">
		<form name="res_discu_form" action="<%=path%>/resource/detail" method="post">
			<input type="hidden" name="id" value="${resId}">
			<input type="hidden" name="resurl" value="${resUrl}">
			<input type="hidden" name="massType" value="">
			<input type="hidden" name="restype" value="${resType}">
			<input type="hidden" name="condition" value="">
		</form>
			<c:if test="${fn:length(dgList) >0 }">
			<c:forEach items="${dgList}" var="dg">
				<img src="<%=path%>/image/unselect.png" class="chooseImg" onclick="addSelect('${dg.id}')" id="${dg.id}_image" style="float:left;cursor:pointer;height: 25px;width: 25px;position: relative;top: 30px;left: 12px;">
				<div class="dglist_div" style="padding:0px 8px;border-bottom:1px solid #ddd;min-height:75px;padding-left:50px">
					<div style="width:100%;line-height:35px;">
						<div style="font-weight:bold;">讨论组：${dg.name }</div>
						<div style="">创建时间: ${fn:substring(dg.create_time,0,fn:length(dg.create_time) -2)}</div>
					</div>
					<div style="width:100%;line-height:35px;">
						<div style="">发起人：${dg.creator_name } &nbsp;&nbsp;&nbsp;人数：${dg.dis_user_count}&nbsp;&nbsp;&nbsp;话题数：${dg.dis_topic_count }</div>
					</div>
				</div>
				<div style="clear: both"></div>
			</c:forEach>
			</c:if>
			<c:if test="${fn:length(dgList) ==0 }">
				<div style="text-align: center; padding-top: 50px;font-size:14px;color:#999;">没有找到数据</div>
			</c:if>
		</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	<div class="myMsgBox"
		style="display: none; width: 100%; position: fixed; color: #FFF; background: rgb(234, 160, 0); top: 0px; left: 0px; z-index: 1000; font-size: 14px; text-align: center; height: 30px; padding: 5px 0px 2px 0px;">&nbsp;</div>
</body>
</html>