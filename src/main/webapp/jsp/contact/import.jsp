<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@page import="com.takshine.wxcrm.base.common.Constants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String currUserName = UserUtil.getCurrUser(request).getName();
%>
<!DOCTYPE html>
<html lang="en">
<head>
	<!-- Meta -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">
    <title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME %></title>
    <%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
    <script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/util/takshine.util.js" type="text/javascript"></script>
    <script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
	<!--框架样式-->
	<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css"/> 
	<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
</head>
<style>
.file-box{ position:relative;width:100%;} 
.txt{ height:22px; border:0px; width:160px;border-bottom:1px solid #ddd;}   
.btn{height:24px;width:60px;line-height:0px;padding:0 1px;font-size:14px;}  
.btn1{height:24px;width:60px;line-height:0px;padding:0px;font-size:14px;}  
.file{ position:absolute; top:0; right:80px; height:24px; filter:alpha(opacity:0);opacity: 0;width:260px }
</style>

<script>
var prefile = "";
var t1;
//异步上传头像
function ajaxFileUpload(){
	if(prefile == ""){
		prefile = $("input[name=uploadFile]").val();
	}else if(prefile == $("input[name=uploadFile").val()){
		return;
	}
	if(prefile.indexOf(".csv") == -1 && prefile.indexOf(".vcf") == -1 ){
		$("input[name=filename]").attr("placeholder","请选择csv或vcf文件");
		return;
	}
	$("input[name=filename]").val(prefile);

	$.ajaxFileUpload({
		//处理文件上传操作的服务器端地址(可以传参数,已亲测可用)
		url:'<%=path%>/contact/uploaduser',
		secureuri:false,                       //是否启用安全提交,默认为false 
		fileElementId:'uploadFile',           //文件选择框的id属性
		dataType:'text',                       //服务器返回的格式,可以是json或xml等
		success:function(data, status){        //服务器响应成功时的处理函数
		},
		error:function(data, status, e){ //服务器响应失败时的处理函数
			
		}
	}); 
	
	//
	$(".shade").removeClass("none");
	$(".myDefMsgBox").removeClass("none");
 	$(".myDefMsgBox").delay(3000).fadeOut();
 	
 	t1 = window.setInterval('stopTime();', 3000);
}

function stopTime(){
	window.clearInterval(t1); 
	$(".backupbtn").trigger("click");
}

$(function(){
	$(".select_file").click(function(){
		$("#uploadFile").trigger("click");
	});
	var client = getClientBrower();
	if(client == 'mobile'){ 
		$(".client_model").css("display","");
	}else{
		$(".import_div").css("display","");
		$(".import_title").css("display","");
	}
});

function getClientBrower(){
	var source = "";
	var sUserAgent = navigator.userAgent.toLowerCase();
    var bIsIpad = sUserAgent.match(/ipad/i) == "ipad";
    var bIsIphoneOs = sUserAgent.match(/iphone os/i) == "iphone os";
    var bIsMidp = sUserAgent.match(/midp/i) == "midp";
    var bIsUc7 = sUserAgent.match(/rv:1.2.3.4/i) == "rv:1.2.3.4";
    var bIsUc = sUserAgent.match(/ucweb/i) == "ucweb";
    var bIsAndroid = sUserAgent.match(/android/i) == "android";
    var bIsCE = sUserAgent.match(/windows ce/i) == "windows ce";
    var bIsWM = sUserAgent.match(/windows mobile/i) == "windows mobile";
    if (bIsIpad || bIsIphoneOs || bIsMidp || bIsUc7 || bIsUc || bIsAndroid || bIsCE || bIsWM) {//如果是上述设备就会以手机域名打开
    	source = "mobile";
    }else{//否则就是电脑域名打开
    	source = "windows";
    }
    return source;
} 

</script>
<style>
.none{
	display:none;
}

.myDefMsgBox{
	width:140px;
	line-height:23px;
	position:fixed;
	left:50%;
	top:30%;
	background-color:#fff;
	border-radius:8px;
	border:1px solid #eee;
	margin-left:-70px;
	font-size: 14px;
  	padding: 10px;
  	z-index:999;
}
</style>
<body>
	<div class="import_title" style="display:none;background-color:#fff;padding:15px;margin-top:15px;line-height:25px;font-size:14px;">
		亲爱的<%=currUserName %>：<br/>
		请选择您需要导入的文件，数据将保存到您的个人账户中。小薇只能够处理csv结尾的文件哦。
		<br/>
		
	</div>
	
	<div class="client_model" style="display:none;margin-bottom:15px;background-color:#fff;padding:15px;margin-top:15px;line-height:25px;font-size:14px;">
		亲爱的<%=currUserName %>：<br/>
		<p>导入通讯录只能在PC端导入哦，支持csv结尾的文件。您可以通过PC端浏览器访问<a href="http://www.fingercrm.cn" style="border-bottom: 1px solid rgb(255, 136, 0);color: rgb(255, 136, 0);">www.fingercrm.cn</a>来导入文件！</p>
	</div>
		
	<div class="import_div" style="display:none;background-color:#fff;padding:15px;margin-top:15px;line-height:25px;font-size:14px;text-align:center;">
		<input type="text" name="filename" id="filename" style="border:0px;border-bottom:1px solid #ddd;" placeholder="未选择文件">
		<div style="margin-top:10px;">
			<input type="button" name="selectfile" value="上传文件" class="btn select_file">
			<!-- <input type="button" name="upload_file" value="上传" class="btn upload_file"> -->
			<input type="file" onchange="ajaxFileUpload();" style="width: 80px;height: 80px;display:none;" accept=".csv" name="uploadFile" id="uploadFile">
		</div>
		<div style="line-height:35px;margin-top:18px;">
			<a class="backupbtn" href="javascript:void(0)" onclick="javascript:history.go(-1)">返回</a>
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<a href="<%=path%>/template/import_contacts_template.csv">获取模板</a>
		</div>
	</div>
	
	<div class="myDefMsgBox none"><img src="<%=path %>/image/comments_list.png" width="24px;">小薇提示：<br/>系统正在处理中，处理完成后将通过消息通知您！</div>
	<div class="shade none" style="z-index:10"></div>
</body>
</html>