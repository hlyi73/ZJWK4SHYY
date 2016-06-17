<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
<!-- Meta -->
<title><%=com.takshine.wxcrm.base.common.Constants.PROJECT_NAME%></title>
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0">
<%@ include file="/common/comlibs.jsp"%><!-- comlibs page -->
<script src="<%=path%>/scripts/plugin/jquery/jquery-1.9.1.min.js"
	type="text/javascript"></script>
	<script src="<%=path%>/scripts/plugin/jquery/jquery_ajaxfileupload/ajaxfileupload.js" type="text/javascript"></script>
<script src="<%=path%>/scripts/util/takshine.util.js"
	type="text/javascript"></script>
<!--框架样式-->
<link rel="stylesheet" href="<%=path%>/scripts/plugin/wb/css/wb.css">
<link rel="stylesheet" href="<%=path%>/css/page.css" id="style_color">
<script type="text/javascript">
	function showDoc(){
		var disnew = $("#newSign").css("display");
		if("none"==disnew){
			$("#oldSign").css("display","none");
			$("#newSign").css("display","");
			$("#editimg").attr("src","<%=path%>/image/oper_success.png");
		}else{
			$("#oldSign").css("display","");
			$("#newSign").css("display","none");
			//$("#editimg").attr("src","<%=path%>/image/edit_information.png");
			conform();
		}
		
		//initWeixinFunc();
	}
	
	 //微信网页按钮控制
	/* function initWeixinFunc(){
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideOptionMenu');
		});

		//隐藏底部
		document.addEventListener('WeixinJSBridgeReady', function onBridgeReady() {
			WeixinJSBridge.call('hideToolbar');
		});
	} */
	 
	//异步修改签名
	function conform(){
		var opSignature = $("input[name=signature]").val();
		if(opSignature.length>25){
			$("input[name=signature]").val('');
			$("input[name=signature]").attr("placeholder","请输入25个字符以内的个性签名");
			return;
		}
		$("input[name=opSignature]").val(opSignature);
		var dataobj=[];
		var form = $("form[name=dccrmModify]");
		form.find("input").each(function(){
			var n = $(this).attr("name");
			var v = $(this).attr("value");
			dataobj.push({name:n,value:v});
		});
		$.ajax({
			url:"<%=path%>/dcCrm/asyupdate",
			type:'post',
			data:dataobj,
		 	success: function(data){
		 		if(data.errorCode && data.errorCode !== '0'){
   	    		   $(".myMsgBox").css("display","").html("操作失败!" + "错误编码:" + data.errorCode + "错误描述:" + data.errorMsg);
   	    		   $(".myMsgBox").delay(2000).fadeOut();
   	    		   return;
	   	    	}else if("ok"==data){
	    	    	$("#oldSign").css("display","");
	    			$("#newSign").css("display","none");
	    			$("#oldSign").html(opSignature);
	    			
	    			$("#editimg").attr("src","<%=path%>/image/edit_information.png");
	   	    	}
    	    }
		});
	}
	
	var prefile = "";
	//异步修改
	function ajaxFileUpload(){
		if(prefile === ""){
			prefile = $(".fileInput").val();
		}else if(prefile == $(".fileInput").val()){
			return;
		}
		$.ajaxFileUpload({
			//处理文件上传操作的服务器端地址(可以传参数,已亲测可用)
			url:'<%=path%>/dcCrm/upload',
			secureuri:false,                       //是否启用安全提交,默认为false 
			fileElementId:'uploadFile',           //文件选择框的id属性
			dataType:'text',                       //服务器返回的格式,可以是json或xml等
			success:function(data, status){        //服务器响应成功时的处理函数
				prefile = "";
				$(".uptImg").empty();
				if(data.substring(0, 1) == 0){     //0表示上传成功(后跟上传后的文件路径),1表示失败(后跟失败描述)
					var width = $(window).width();
					if(width > 640){
						width = 640;
					}
					var path = "<%=path%>/contact/download?flag=dccrm&fileName="+data.substring(1);
					$(".uptImg").append('<img style="height: 200px; width:'+width+'px ;" src="'+path+'"></img>');
					$(":hidden[name=opImage]").val(data.substring(1));
					conform();
				}else{
					$(".myMsgBox").css("display","").html("图片上传失败,请重试");
		    		$(".myMsgBox").delay(2000).fadeOut();
				}
				$(".uptImg").append('<input type="file" onchange="ajaxFileUpload();"  style="height:200px"  accept="image/gif,image/x-png, image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg"  class="fileInput" name="uploadFile" id="uploadFile">');
			},
			error:function(data, status, e){ //服务器响应失败时的处理函数
				prefile = "";
				$(".myMsgBox").css("display","").html("图片上传失败,请联系管理员");
	    		$(".myMsgBox").delay(2000).fadeOut();
	    		$(".uptImg").empty();
	    		$(".uptImg").append('<input type="file" onchange="ajaxFileUpload();"  style="height:200px"  accept="image/gif, image/x-png,image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg"  class="fileInput" name="uploadFile" id="uploadFile">');
			}
		});
	}
	$(function () { 
		var width = $(window).width();
		if(width > 640){
			width = 640;
		}
		$(".bgimg").attr("width",width);

	});

</script>
</head>
<body style="min-height:100%;">
	<div id="site-nav" class="navbar" style="">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">我的指尖微客</h3>
	</div>
	<div class="site-recommend-list page-patch acclist">
		<div class="list-group1 listview">
			<!-- <h4>详情</h4> -->
			<form name="dccrmModify" method="post" novalidate="true">
				<input type="hidden" name="publicId" value="${publicId}" /> 
				<input type="hidden" name="openId" value="${openId}" />
			</form>
			<br/>
			<a href="<%=path%>/dcCrm/detail?openId=${openId}&publicId=${publicId}"
					class="list-group-item listview-item" style="border-top: 1px solid #ddd">
				<div style="width:100%;">
				<div style="float:left;"><img src="${wxuser.headimgurl}" height="60px"></div>
				<div style="margin-left:70px;">
					<c:if test="${operator.opName ne ''}">
						${operator.opName}
					</c:if>
					<c:if test="${operator.opName eq ''}">
						${wxuser.nickname}
					</c:if>
				</div>
				<div style="margin-left:70px;margin-top:10px;color:#999;font-size:12px;">点击查看我的名片</div>
				<div style="float:right;margin-top:-40px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			
			<br/>
			<a href="<%=path%>/dcCrm/modify?openId=${openId}&publicId=${publicId}"
					class="list-group-item listview-item" style="border-top: 1px solid #ddd">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_qrcode.png" height="20px"></div> -->
				<div style="">完善我的资料</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			
			<br/>
			
			<a href="${zjrm_url}/out/user/tags/${party_row_id}"
					class="list-group-item listview-item" style="border-top: 1px solid #ddd">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_qrcode.png" height="20px"></div> -->
				<div style="">编辑我的标签</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			<br/>
			<a href="<%=path%>/dcCrm/make?openId=${openId}&publicId=${publicId}"
					class="list-group-item listview-item" style="border-top: 1px solid #ddd">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_qrcode.png" height="20px"></div> -->
				<div style="">我的二维码名片</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			<br/>
			
			<a href="<%=path%>/cbooks/list"
					class="list-group-item listview-item" style="border-top: 1px solid #ddd">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_myfriends.png" height="20px"></div>-->
				<div style="">我的通讯录</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			
			<%--
			<a href="<%=path%>/userRela/urelalist?userId=${party_row_id}"
					class="list-group-item listview-item" style="">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_myfriends.png" height="20px"></div>-->
				<div style="">我的好友</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			
			
			<a href="${zjrm_url}/out/group/mylist/${party_row_id}"
					class="list-group-item listview-item">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_qun.png" height="20px"></div>-->
				<div style="">我的群动态</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a> 
			
			<br/>
			<a href="<%=path%>/sys/list?openId=${openId}&publicId=${publicId}"
					class="list-group-item listview-item" style="border-top: 1px solid #ddd">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_accntmanage.png" height="20px"></div>-->
				<div style="">帐号管理</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			--%>
		</div>
	</div>
<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>