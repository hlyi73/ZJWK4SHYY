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
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
<script	src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>

<link href="<%=path%>/scripts/plugin/umeditor1/themes/default/css/umeditor.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="<%=path%>/scripts/plugin/umeditor1/third-party/jquery.min.js"></script>
<script type="text/javascript" charset="utf-8" src="<%=path%>/scripts/plugin/umeditor1/umeditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="<%=path%>/scripts/plugin/umeditor1/umeditor.js"></script>
<script type="text/javascript" src="<%=path%>/scripts/plugin/umeditor1/lang/zh-cn/zh-cn.js"></script>

<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css" />
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color" />
<link rel="stylesheet" href="<%=path%>/css/style.css" id="style_color" />

<script type="text/javascript">
var um;
	$(function(){
				
		$(".cancelBtn").click(function(){
			window.history.back(1);
		})
		$(".saveBtn").click(function(){
			var title =$("input[name=resourceTitle]").val();
			if(!$.trim(title)){
				 $(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请填写文章标题!");
				 $(".myMsgBox").delay(2000).fadeOut();
		  		 return;
			}
			var content =um.getContent();
			if(!$.trim(content)){
				 $(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("请填写文章内容!");
				 $(".myMsgBox").delay(2000).fadeOut();
		  		 return;
			}
			var dataObj = [];
	        dataObj.push({name:"resourceType",value:"timg"});
	        dataObj.push({name:"resourceTitle",value:title});
	        dataObj.push({name:"resourceContent",value:content});
	        $.ajax({
	        	type: 'post',
				url : '<%=path%>/resource/save',			
		        data: dataObj,
		        dataType: 'text',
			    success: function(data){
					if(!data){
						 $(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("操作失败!");
						 $(".myMsgBox").delay(2000).fadeOut();
				  		 return;

					}
					
					var d = JSON.parse(data);
					if(!d || d.errorCode != "0" || !d.rowId){
						 $(".myMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("保存失败!");
						 $(".myMsgBox").delay(2000).fadeOut();
				  		 return;
					}
					
					//
					$(".myMsgBox").removeClass("error_tip").addClass("success_tip").css("display","").html("保存成功!");
					$(".myMsgBox").delay(2000).fadeOut();
					
					window.location.replace("<%=path%>/resource/list");
					
			    },
			    error:function(){
			    	alert('error');
			    }
		    });
		})
		
		//实例化编辑器
		try{
			um = UM.getEditor('myEditor', {
		   	 	imagePath: '<%=path%>/mkattachment/download'
			});
			um.setContent('');
		}catch(e){}
	});
</script>

</head>
<body style="background-color:#fff;height:100%;font-size:14px;min-width:100%;">
	<div id="site-nav" class="navbar" style="display:none" >
	</div>
	<!-- 控制区域 -->
	<div style="line-height:10px;background-color:#eee;height:10px;"></div>
	<div style="line-height:10px;background-color:#eee;height:35px;line-height:25px;padding:2px 10px;">文章标题：</div>
	<div class="resourceTitle" style="margin: 8px;">
		<input name="resourceTitle" class="resourceTitle" style="border:0px;" placeholder="在此输入文章标题"/>
	</div>
	<div style="clear: both"></div>
	<div style="line-height:10px;background-color:#eee;height:35px;line-height:25px;padding:5px 10px;">文章内容：</div>
	<div>
		<script type="text/plain" id="myEditor" style="margin:0px 20px;width:100%;height:280px;box-shadow:0"></script>
	</div>
	
	<div style="width:100%;line-height:50px;background-color:#fff;padding:5px;border-bottom: 1px solid #ddd;text-align:center;padding-right:20px;" id="opArea">
		<a href="javascript:void(0)" class="btn btn-default cancelBtn" style="font-size: 16px;height: 2em;line-height: 2em;"> 取消</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="javascript:void(0)" class="btn saveBtn" style="font-size: 16px;height: 2em;line-height: 2em;"> 保存</a>				
	</div>
	<jsp:include page="/common/footer.jsp"></jsp:include>
	<div class="myMsgBox" style="display:none;">&nbsp;</div>
</body>
</html>