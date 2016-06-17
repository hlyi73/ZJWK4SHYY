<%@page import="com.takshine.wxcrm.base.util.UserUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String path = request.getContextPath();
	String partyId = UserUtil.getCurrUser(request).getParty_row_id();
	String display = "N"; //临时处理
	if(null != partyId && !"".equals(partyId) && ("3d068a677e014df69d0c54051ef7b16c".equals(partyId) || "35791d3487d643f09eb523fa666247a0".equals(partyId))){
		display = "Y";
	}
	request.setAttribute("display",display);
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
		
	}
	
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
   	    		   $(".myDefMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("操作失败!" + "错误编码:" + data.errorCode + "错误描述:" + data.errorMsg);
   	    		   $(".myDefMsgBox").delay(2000).fadeOut();
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
					$(".myDefMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("图片上传失败,请重试");
		    		$(".myDefMsgBox").delay(2000).fadeOut();
				}
				$(".uptImg").append('<input type="file" onchange="ajaxFileUpload();"  style="height:200px"  accept="image/gif,image/x-png, image/x-ms-bmp, image/bmp,image/jpeg,image/png,image/jpg"  class="fileInput" name="uploadFile" id="uploadFile">');
			},
			error:function(data, status, e){ //服务器响应失败时的处理函数
				prefile = "";
				$(".myDefMsgBox").removeClass("success_tip").addClass("error_tip").css("display","").html("图片上传失败,请联系管理员");
	    		$(".myDefMsgBox").delay(2000).fadeOut();
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
		if ("${message}" != "" && "${message}" != "null"){
			$(".myDefMsgBox").removeClass("success_tip").addClass("success_tip").css("display","").html("${message}");
    		$(".myDefMsgBox").delay(2000).fadeOut();
		}
	});

</script>
</head>
<body style="min-height:100%;background-color:#eee;">
	<div id="site-nav" class="navbar" style="display:none;">
		<jsp:include page="/common/back.jsp"></jsp:include>
		<h3 style="padding-right:45px;">我的指尖微客</h3>
	</div>
	<div class="site-recommend-list page-patch acclist">
		<div class="list-group1 listview">
			<br/>
			<a href="<%=path%>/businesscard/detail"
					class="list-group-item listview-item" style="border-top: 1px solid #ddd">
				<div style="width:100%;">
				<div style="float:left;">
					<c:if test="${BusinessCard.headImageUrl ne '' and BusinessCard.headImageUrl ne null}">
								<img id="headImg" name="headImg" src="<%=path%>/contact/download?flag=dccrm&fileName=${BusinessCard.headImageUrl}" height="60px">
							</c:if>
							<c:if
								test="${BusinessCard.headImageUrl eq '' or BusinessCard.headImageUrl eq null}">
								<img id="headImg" name="headImg"  src="${user.headimgurl}" height="60px">
							</c:if>
				
				</div>
				<div style="margin-left:70px;">
					<c:if test="${BusinessCard.name ne '' and BusinessCard.name ne null}">
						${BusinessCard.name}
					</c:if>
					<c:if test="${BusinessCard.phone ne '' and BusinessCard.phone ne null}">
						${BusinessCard.phone}
					</c:if>
				</div>
				<div style="margin-left:70px;margin-top:10px;color:#999;font-size:12px;">
					<c:if test="${BusinessCard.company ne '' and BusinessCard.company ne null}">
						${BusinessCard.company}
					</c:if>
					<c:if test="${BusinessCard.position ne '' and BusinessCard.position ne null}">
							/${BusinessCard.position}
					</c:if>
				</div>
				<c:if test="${BusinessCard.name ne '' and BusinessCard.name ne null}">
				<div style="float:right;margin-top:-40px;"><span class="icon icon-uniE603"></span>
				
				</div>
				</c:if>
				<c:if test="${BusinessCard.address ne '' and BusinessCard.address ne null}">
					<div style="margin-left:70px;margin-top:10px;color:#999;font-size:12px;">	
						${BusinessCard.address}
						</div>
				</c:if>
				</div>
			</a>		
			<a href="<%=path%>/businesscard/modify"
					class="list-group-item listview-item" style="border-top: 1px solid #ddd;margin-top:10px;">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_qrcode.png" height="20px"></div> -->
				<div style="">完善我的资料</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>			
			<a href="<%=path%>/modelTag/taglist"
					class="list-group-item listview-item" style="">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_qrcode.png" height="20px"></div> -->
				<div style="">编辑我的标签</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			
			
			<a href="<%=path%>/print/goVisitUserList?partyId=${user.party_row_id}"
					class="list-group-item listview-item" style="border-top: 1px solid #ddd;margin-top:10px;">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_qrcode.png" height="20px"></div> -->
				<div style="">我的访客</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			<a href="<%=path%>/personalmsg/personalmsglist?bcpartyid=${user.party_row_id}"
					class="list-group-item listview-item" style=""> 
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_qrcode.png" height="20px"></div> -->
				<div style="">我的留言与私信</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			<a href="<%=path%>/dcCrm/make?partyId=${user.party_row_id}"
					class="list-group-item listview-item" style="">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_qrcode.png" height="20px"></div> -->
				<div style="">我的二维码名片</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			<%--<a href="<%=path%>/cbooks/list"
					class="list-group-item listview-item" style="">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_myfriends.png" height="20px"></div>-->
				<div style="">我的通讯录</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a> --%>
			<c:if test="${display eq 'Y'}">
				<a href="<%=path%>/access/total"
						class="list-group-item listview-item" style="border-top: 1px solid #ddd;margin-top:10px;">
					<div style="width:100%;">
					<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_accntmanage.png" height="20px"></div>-->
					<div style="">访问统计</div>
					<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
					</div>
				</a>
			</c:if>
			<a href="<%=path%>/sys/list"
					class="list-group-item listview-item" style="">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_accntmanage.png" height="20px"></div>-->
				<div style="">帐号管理</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
			<a href="<%=path%>/businesscard/getConfig"
					class="list-group-item listview-item" style="">
				<div style="width:100%;">
				<!-- <div style="float:left;padding-left:15px;"><img src="<%=path %>/image/zjwk_accntmanage.png" height="20px"></div>-->
				<div style="">更多设置</div>
				<div style="float:right;margin-top:-25px;"><span class="icon icon-uniE603"></span></div>
				</div>
			</a>
		</div>
	</div>
	<div class="myDefMsgBox" style="display:none;">&nbsp;</div>
<jsp:include page="/common/footer.jsp"></jsp:include>
</body>
</html>